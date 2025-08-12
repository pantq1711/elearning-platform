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
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

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
        authProvider.setUserDetailsService(userService); // Service load user details
        authProvider.setPasswordEncoder(passwordEncoder()); // Encoder để so sánh password
        return authProvider;
    }

    /**
     * Cấu hình Authentication Manager
     * @param config Authentication configuration
     * @return AuthenticationManager
     */
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    /**
     * Xử lý sau khi đăng nhập thành công
     * Chuyển hướng user đến trang phù hợp theo role
     * @return AuthenticationSuccessHandler
     */
    @Bean
    public AuthenticationSuccessHandler successHandler() {
        return (request, response, authentication) -> {
            // Lấy authorities (quyền) của user
            String redirectURL = "/";

            if (authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
                // Admin -> trang quản trị
                redirectURL = "/admin/dashboard";
            } else if (authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_INSTRUCTOR"))) {
                // Giảng viên -> trang giảng viên
                redirectURL = "/instructor/dashboard";
            } else if (authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_STUDENT"))) {
                // Học viên -> trang học viên
                redirectURL = "/student/dashboard";
            }

            response.sendRedirect(redirectURL);
        };
    }

    /**
     * Cấu hình chính cho Spring Security
     * Định nghĩa quyền truy cập, form đăng nhập, logout...
     * @param http HttpSecurity object
     * @return SecurityFilterChain
     */
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                // Tắt CSRF cho development (có thể bật lại nếu cần)
                .csrf(csrf -> csrf.disable())

                // Cấu hình phân quyền cho các URL
                .authorizeHttpRequests(authz -> authz
                        // Các trang public - không cần đăng nhập
                        .requestMatchers(
                                "/",
                                "/login",
                                "/register",
                                "/css/**",
                                "/js/**",
                                "/images/**",
                                "/webjars/**",
                                "/favicon.ico"
                        ).permitAll()

                        // Trang admin - chỉ admin mới truy cập được
                        .requestMatchers("/admin/**").hasRole("ADMIN")

                        // Trang instructor - chỉ giảng viên mới truy cập được
                        .requestMatchers("/instructor/**").hasRole("INSTRUCTOR")

                        // Trang student - chỉ học viên mới truy cập được
                        .requestMatchers("/student/**").hasRole("STUDENT")

                        // API endpoints - cần đăng nhập
                        .requestMatchers("/api/**").authenticated()

                        // Tất cả các request khác đều cần đăng nhập
                        .anyRequest().authenticated()
                )

                // Cấu hình form đăng nhập
                .formLogin(form -> form
                        .loginPage("/login") // Trang đăng nhập custom
                        .loginProcessingUrl("/perform_login") // URL xử lý đăng nhập
                        .usernameParameter("username") // Tên field username trong form
                        .passwordParameter("password") // Tên field password trong form
                        .successHandler(successHandler()) // Handler sau khi đăng nhập thành công
                        .failureUrl("/login?error=true") // URL khi đăng nhập thất bại
                        .permitAll() // Cho phép tất cả truy cập trang login
                )

                // Cấu hình logout
                .logout(logout -> logout
                        .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                        .logoutSuccessUrl("/login?logout=true") // URL sau khi logout
                        .deleteCookies("JSESSIONID") // Xóa session cookie
                        .invalidateHttpSession(true) // Hủy session
                        .clearAuthentication(true) // Xóa thông tin xác thực
                        .permitAll()
                )

                // Cấu hình session management
                .sessionManagement(session -> session
                        .maximumSessions(1) // Giới hạn 1 session/user
                        .maxSessionsPreventsLogin(false) // Cho phép đăng nhập mới (đẩy session cũ)
                )

                // Cấu hình remember-me (ghi nhớ đăng nhập)
                .rememberMe(remember -> remember
                        .key("courseManagementRememberMe") // Secret key
                        .tokenValiditySeconds(86400 * 7) // 7 ngày
                        .userDetailsService(userService) // Service load user details
                )

                // Cấu hình exception handling
                .exceptionHandling(ex -> ex
                        .accessDeniedPage("/access-denied") // Trang báo lỗi khi không có quyền
                );

        return http.build();
    }
}