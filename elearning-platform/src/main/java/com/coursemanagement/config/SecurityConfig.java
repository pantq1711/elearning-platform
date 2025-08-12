package com.coursemanagement.config;

import com.coursemanagement.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Cấu hình bảo mật cho ứng dụng
 * Xử lý authentication (xác thực) và authorization (phân quyền)
 */
@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true) // Bật phân quyền theo method
public class SecurityConfig {

    @Autowired
    private UserService userService; // Service để load thông tin user

    /**
     * Cấu hình mã hóa mật khẩu bằng BCrypt
     * @return PasswordEncoder - BCrypt encoder
     */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    /**
     * Cấu hình Authentication Provider
     * Xác định cách thức xác thực user (username/password)
     * @return DaoAuthenticationProvider
     */
    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userService); // Sử dụng UserService để load user
        authProvider.setPasswordEncoder(passwordEncoder()); // Sử dụng BCrypt để verify password
        return authProvider;
    }

    /**
     * Cấu hình AuthenticationManager
     * @param config AuthenticationConfiguration
     * @return AuthenticationManager
     * @throws Exception Nếu có lỗi cấu hình
     */
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    /**
     * Custom Authentication Success Handler
     * Chuyển hướng user đến trang phù hợp sau khi đăng nhập thành công
     * @return AuthenticationSuccessHandler
     */
    @Bean
    public AuthenticationSuccessHandler authenticationSuccessHandler() {
        return new AuthenticationSuccessHandler() {
            @Override
            public void onAuthenticationSuccess(HttpServletRequest request,
                                                HttpServletResponse response,
                                                Authentication authentication)
                    throws IOException, ServletException {

                String redirectUrl = "/";

                // Xác định URL chuyển hướng dựa trên role của user
                if (authentication.getAuthorities().stream()
                        .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
                    redirectUrl = "/admin/dashboard";
                } else if (authentication.getAuthorities().stream()
                        .anyMatch(a -> a.getAuthority().equals("ROLE_INSTRUCTOR"))) {
                    redirectUrl = "/instructor/dashboard";
                } else if (authentication.getAuthorities().stream()
                        .anyMatch(a -> a.getAuthority().equals("ROLE_STUDENT"))) {
                    redirectUrl = "/student/dashboard";
                }

                response.sendRedirect(redirectUrl);
            }
        };
    }

    /**
     * Cấu hình Security Filter Chain
     * Định nghĩa các quy tắc phân quyền và xử lý authentication
     * @param http HttpSecurity object
     * @return SecurityFilterChain
     * @throws Exception Nếu có lỗi cấu hình
     */
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                // Cấu hình authorization (phân quyền)
                .authorizeHttpRequests(authz -> authz
                        // Cho phép truy cập không cần đăng nhập
                        .requestMatchers(
                                "/",
                                "/login",
                                "/register",
                                "/api/check-username",
                                "/api/check-email",
                                "/css/**",
                                "/js/**",
                                "/images/**",
                                "/favicon.ico",
                                "/error/**",
                                "/404",
                                "/500"
                        ).permitAll()

                        // Phân quyền theo role
                        .requestMatchers("/admin/**").hasRole("ADMIN")
                        .requestMatchers("/instructor/**").hasRole("INSTRUCTOR")
                        .requestMatchers("/student/**").hasRole("STUDENT")

                        // Các endpoint chung cho user đã đăng nhập
                        .requestMatchers("/profile/**", "/change-password/**").authenticated()

                        // Tất cả request khác cần authentication
                        .anyRequest().authenticated()
                )

                // Cấu hình form login
                .formLogin(form -> form
                        .loginPage("/login") // Trang login custom
                        .loginProcessingUrl("/perform_login") // URL xử lý login
                        .usernameParameter("username") // Tên field username
                        .passwordParameter("password") // Tên field password
                        .successHandler(authenticationSuccessHandler()) // Custom success handler
                        .failureUrl("/login?error=true") // URL khi login fail
                        .permitAll()
                )

                // Cấu hình logout
                .logout(logout -> logout
                        .logoutRequestMatcher(new AntPathRequestMatcher("/logout")) // URL logout
                        .logoutSuccessUrl("/login?logout=true") // URL sau khi logout thành công
                        .invalidateHttpSession(true) // Hủy session
                        .deleteCookies("JSESSIONID") // Xóa cookie session
                        .permitAll()
                )

                // Cấu hình exception handling
                .exceptionHandling(ex -> ex
                        .accessDeniedPage("/access-denied") // Trang lỗi 403
                )

                // Cấu hình session management
                .sessionManagement(session -> session
                        .maximumSessions(1) // Giới hạn 1 session per user
                        .maxSessionsPreventsLogin(false) // Cho phép login mới kick session cũ
                        .expiredUrl("/login?expired=true") // URL khi session hết hạn
                )

                // Tắt CSRF cho API endpoints (nếu cần)
                .csrf(csrf -> csrf
                        .ignoringRequestMatchers("/api/**") // Bỏ qua CSRF cho API
                )

                // Cấu hình headers security
                .headers(headers -> headers
                        .frameOptions().DENY // Ngăn clickjacking
                        .contentTypeOptions().and() // Ngăn MIME type sniffing
                        .httpStrictTransportSecurity(hstsConfig -> hstsConfig
                                .maxAgeInSeconds(31536000) // HSTS 1 năm
                                .includeSubdomains(true)
                        )
                );

        return http.build();
    }

    /**
     * Bean để bypass security cho static resources trong development
     * Chỉ nên sử dụng trong môi trường development
     */
    /*
    @Bean
    @Profile("dev")
    public WebSecurityCustomizer webSecurityCustomizer() {
        return (web) -> web.ignoring()
                .requestMatchers("/h2-console/**") // H2 console trong dev
                .requestMatchers("/actuator/**"); // Actuator endpoints trong dev
    }
    */
}