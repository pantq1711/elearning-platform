package com.coursemanagement.config;

import com.coursemanagement.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.RememberMeServices;
import org.springframework.security.web.authentication.rememberme.TokenBasedRememberMeServices;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import java.io.IOException;

/**
 * Cấu hình bảo mật toàn diện cho hệ thống e-learning
 * Xử lý authentication (xác thực) và authorization (phân quyền)
 * Cải thiện bảo mật với nhiều tính năng nâng cao
 */
@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true) // Bật phân quyền theo method
public class SecurityConfig {

    @Autowired
    private UserService userService; // Service để load thông tin user

    // Key bí mật cho remember-me token
    private static final String REMEMBER_ME_KEY = "elearning-platform-remember-me-key-2024";

    /**
     * Cấu hình mã hóa mật khẩu bằng BCrypt với strength cao
     * @return PasswordEncoder - BCrypt encoder với cost factor 12
     */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(12); // Tăng cost factor cho bảo mật cao hơn
    }

    /**
     * Cấu hình Authentication Provider
     * Xác định cách thức xác thực user (username/password)
     * @return DaoAuthenticationProvider
     */
    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userService);
        authProvider.setPasswordEncoder(passwordEncoder());
        authProvider.setHideUserNotFoundExceptions(false); // Show error cho debug
        return authProvider;
    }

    /**
     * Cấu hình Authentication Manager
     * @param config Authentication configuration
     * @return AuthenticationManager
     * @throws Exception Nếu có lỗi cấu hình
     */
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    /**
     * Remember Me Services với token-based approach
     * @return RememberMeServices
     */
    @Bean
    public RememberMeServices rememberMeServices() {
        TokenBasedRememberMeServices rememberMeServices =
                new TokenBasedRememberMeServices(REMEMBER_ME_KEY, userService);
        rememberMeServices.setTokenValiditySeconds(86400 * 7); // 7 ngày
        rememberMeServices.setParameter("remember-me");
        rememberMeServices.setCookieName("ELEARNING_REMEMBER_ME");
        return rememberMeServices;
    }

    /**
     * Custom Authentication Success Handler
     * Điều hướng user đến trang phù hợp sau khi đăng nhập
     */
    @Bean
    public AuthenticationSuccessHandler authenticationSuccessHandler() {
        return new AuthenticationSuccessHandler() {
            @Override
            public void onAuthenticationSuccess(HttpServletRequest request,
                                                HttpServletResponse response,
                                                Authentication authentication) throws IOException, ServletException {

                // Lấy role của user để điều hướng
                if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_ADMIN"))) {
                    response.sendRedirect("/admin/dashboard");
                } else if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_INSTRUCTOR"))) {
                    response.sendRedirect("/instructor/dashboard");
                } else if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_STUDENT"))) {
                    response.sendRedirect("/student/dashboard");
                } else {
                    response.sendRedirect("/"); // Default home page
                }
            }
        };
    }

    /**
     * Cấu hình Security Filter Chain với bảo mật toàn diện
     * @param http HttpSecurity object
     * @return SecurityFilterChain
     * @throws Exception Nếu có lỗi cấu hình
     */
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                // Cấu hình authorization requests với quyền chi tiết
                .authorizeHttpRequests(authz -> authz
                        // Public endpoints - không cần đăng nhập
                        .requestMatchers("/", "/home", "/login", "/register", "/logout",
                                "/css/**", "/js/**", "/images/**", "/fonts/**", "/favicon.ico",
                                "/webjars/**", "/uploads/**", "/error/**", "/about", "/contact").permitAll()

                        // API public endpoints
                        .requestMatchers("/api/public/**").permitAll()

                        // Admin endpoints - chỉ ADMIN
                        .requestMatchers("/admin/**").hasRole("ADMIN")

                        // Instructor endpoints - ADMIN hoặc INSTRUCTOR
                        .requestMatchers("/instructor/**").hasAnyRole("ADMIN", "INSTRUCTOR")

                        // Student endpoints - tất cả authenticated users
                        .requestMatchers("/student/**").hasAnyRole("ADMIN", "INSTRUCTOR", "STUDENT")

                        // API endpoints với authentication
                        .requestMatchers("/api/**").authenticated()

                        // Actuator endpoints - chỉ ADMIN
                        .requestMatchers("/actuator/**").hasRole("ADMIN")

                        // Tất cả requests khác cần authentication
                        .anyRequest().authenticated()
                )

                // Cấu hình form login với custom settings
                .formLogin(form -> form
                        .loginPage("/login") // Trang login custom
                        .loginProcessingUrl("/perform_login") // URL xử lý login
                        .usernameParameter("username") // Tên parameter username
                        .passwordParameter("password") // Tên parameter password
                        .successHandler(authenticationSuccessHandler()) // Custom success handler
                        .failureUrl("/login?error=true") // URL khi login fail
                        .permitAll()
                )

                // Cấu hình remember me với security cao
                .rememberMe(remember -> remember
                        .rememberMeServices(rememberMeServices())
                        .key(REMEMBER_ME_KEY)
                        .tokenValiditySeconds(86400 * 7) // 7 ngày
                        .userDetailsService(userService)
                )

                // Cấu hình logout với bảo mật
                .logout(logout -> logout
                        .logoutRequestMatcher(new AntPathRequestMatcher("/logout", "GET")) // GET logout
                        .logoutSuccessUrl("/login?logout=true") // URL sau logout
                        .invalidateHttpSession(true) // Hủy session
                        .deleteCookies("JSESSIONID", "ELEARNING_REMEMBER_ME") // Xóa cookies
                        .clearAuthentication(true) // Clear authentication
                        .permitAll()
                )

                // Cấu hình exception handling
                .exceptionHandling(ex -> ex
                        .accessDeniedPage("/access-denied") // Trang lỗi 403
                        .authenticationEntryPoint((request, response, authException) -> {
                            response.sendRedirect("/login?expired=true");
                        })
                )

                // Cấu hình session management với bảo mật cao
                .sessionManagement(session -> session
                        .maximumSessions(2) // Tối đa 2 session per user
                        .maxSessionsPreventsLogin(false) // Cho phép login mới kick session cũ
                        .expiredUrl("/login?expired=true") // URL khi session hết hạn
                        .sessionRegistry(org.springframework.security.core.session.SessionRegistryImpl::new)
                        .and()
                        .sessionFixation().migrateSession() // Migrate session ID after login
                        .sessionCreationPolicy(org.springframework.security.config.http.SessionCreationPolicy.IF_REQUIRED)
                )

                // Cấu hình CSRF protection với exception cho API
                .csrf(csrf -> csrf
                        .ignoringRequestMatchers("/api/**") // Bỏ qua CSRF cho REST API
                        .csrfTokenRepository(org.springframework.security.web.csrf.CookieCsrfTokenRepository.withHttpOnlyFalse())
                )

                // Cấu hình headers security
                .headers(headers -> headers
                        .frameOptions().DENY // Ngăn clickjacking
                        .contentTypeOptions().and() // Ngăn MIME type sniffing
                        .httpStrictTransportSecurity(hstsConfig -> hstsConfig
                                .maxAgeInSeconds(31536000) // HSTS 1 năm
                                .includeSubdomains(true)
                                .preload(true)
                        )
                        .referrerPolicy(org.springframework.security.web.header.writers.ReferrerPolicyHeaderWriter.ReferrerPolicy.STRICT_ORIGIN_WHEN_CROSS_ORIGIN)
                );

        return http.build();
    }

    /**
     * Bean để bypass security cho static resources trong development
     * Chỉ sử dụng khi profile development được active
     */
    /*
    @Bean
    @Profile("dev")
    public WebSecurityCustomizer webSecurityCustomizer() {
        return (web) -> web.ignoring()
                .requestMatchers("/h2-console/**") // H2 console trong dev
                .requestMatchers("/actuator/health"); // Health check trong dev
    }
    */
}