package com.coursemanagement.config;

import com.coursemanagement.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
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
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.core.session.SessionRegistryImpl;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.RememberMeServices;
import org.springframework.security.web.authentication.rememberme.TokenBasedRememberMeServices;
import org.springframework.security.web.header.writers.ReferrerPolicyHeaderWriter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import java.io.IOException;

/**
 * Cấu hình bảo mật toàn diện cho hệ thống e-learning
 * Xử lý authentication (xác thực) và authorization (phân quyền)
 * Compatible với Spring Security 6.x - Đã sửa tất cả lỗi compilation và circular dependency
 * SỬA LỖI: Sử dụng static methods để tránh circular dependency
 */
@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true) // Bật phân quyền theo method
public class SecurityConfig {

    // Key bí mật cho remember-me token
    private static final String REMEMBER_ME_KEY = "elearning-platform-remember-me-key-2024";

    /**
     * Cấu hình mã hóa mật khẩu bằng BCrypt với strength cao
     * @return PasswordEncoder - BCrypt encoder với cost factor 12
     */
    @Bean
    public static PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(12); // Tăng cost factor cho bảo mật cao hơn
    }

    /**
     * Session Registry để quản lý sessions
     * @return SessionRegistry implementation
     */
    @Bean
    public static SessionRegistry sessionRegistry() {
        return new SessionRegistryImpl();
    }

    /**
     * Cấu hình Authentication Provider
     * Xác định cách thức xác thực user (username/password)
     * SỬA LỖI: Sử dụng static method và dependency injection parameter
     * @return DaoAuthenticationProvider
     */
    @Bean
    public static DaoAuthenticationProvider authenticationProvider(UserService userService, PasswordEncoder passwordEncoder) {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userService);
        authProvider.setPasswordEncoder(passwordEncoder);
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
     * SỬA LỖI: Sử dụng static method và dependency injection parameter
     * @return RememberMeServices
     */
    @Bean
    public static RememberMeServices rememberMeServices(UserService userService) {
        TokenBasedRememberMeServices rememberMeServices =
                new TokenBasedRememberMeServices(REMEMBER_ME_KEY, userService);
        rememberMeServices.setTokenValiditySeconds(30 * 24 * 60 * 60); // 30 ngày
        rememberMeServices.setCookieName("elearning-remember-me");
        rememberMeServices.setParameter("remember-me");
        return rememberMeServices;
    }

    /**
     * Success Handler để redirect theo role
     * @return AuthenticationSuccessHandler
     */
    @Bean
    public AuthenticationSuccessHandler authenticationSuccessHandler() {
        return new AuthenticationSuccessHandler() {
            @Override
            public void onAuthenticationSuccess(HttpServletRequest request,
                                                HttpServletResponse response,
                                                Authentication authentication) throws IOException, ServletException {

                // Lấy authorities của user
                var authorities = authentication.getAuthorities();

                // Redirect theo role
                String redirectURL = "/dashboard"; // Default

                if (authorities.contains(new SimpleGrantedAuthority("ROLE_ADMIN"))) {
                    redirectURL = "/admin/dashboard";
                } else if (authorities.contains(new SimpleGrantedAuthority("ROLE_INSTRUCTOR"))) {
                    redirectURL = "/instructor/dashboard";
                } else if (authorities.contains(new SimpleGrantedAuthority("ROLE_STUDENT"))) {
                    redirectURL = "/student/dashboard";
                }

                response.sendRedirect(redirectURL);
            }
        };
    }

    /**
     * Cấu hình Security Filter Chain chính - Spring Security 6.x syntax
     * Đây là phần cốt lõi của Spring Security configuration
     * SỬA LỖI: Tất cả các method calls đã được cập nhật cho Spring Security 6.x
     * @param http HttpSecurity configuration object
     * @return SecurityFilterChain đã được cấu hình
     * @throws Exception Nếu có lỗi cấu hình
     */
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http,
                                           RememberMeServices rememberMeServices,
                                           SessionRegistry sessionRegistry,
                                           AuthenticationSuccessHandler authenticationSuccessHandler,
                                           UserService userService) throws Exception {

        http
                // ===== CẤU HÌNH AUTHORIZATION (PHÂN QUYỀN) =====
                .authorizeHttpRequests(authz -> authz
                        // Public endpoints - không cần authentication
                        .requestMatchers("/", "/home", "/register", "/login", "/css/**", "/js/**", "/images/**", "/uploads/**").permitAll()
                        .requestMatchers("/api/public/**").permitAll()
                        .requestMatchers("/courses/public/**").permitAll()
                        .requestMatchers("/courses/search", "/courses/category/**").permitAll()

                        // Admin endpoints
                        .requestMatchers("/admin/**").hasRole("ADMIN")
                        .requestMatchers("/api/admin/**").hasRole("ADMIN")

                        // Instructor endpoints
                        .requestMatchers("/instructor/**").hasAnyRole("INSTRUCTOR", "ADMIN")
                        .requestMatchers("/api/instructor/**").hasAnyRole("INSTRUCTOR", "ADMIN")

                        // Student endpoints
                        .requestMatchers("/student/**").hasAnyRole("STUDENT", "INSTRUCTOR", "ADMIN")
                        .requestMatchers("/api/student/**").hasAnyRole("STUDENT", "INSTRUCTOR", "ADMIN")

                        // Course management - Instructor và Admin
                        .requestMatchers("/courses/create", "/courses/*/edit").hasAnyRole("INSTRUCTOR", "ADMIN")
                        .requestMatchers("/api/courses/create", "/api/courses/*/edit").hasAnyRole("INSTRUCTOR", "ADMIN")

                        // API endpoints
                        .requestMatchers("/api/auth/**").permitAll()
                        .requestMatchers("/api/**").authenticated()

                        // All other requests need authentication
                        .anyRequest().authenticated()
                )

                // ===== CẤU HÌNH FORM LOGIN =====
                .formLogin(form -> form
                        .loginPage("/login")
                        .loginProcessingUrl("/login")
                        .successHandler(authenticationSuccessHandler)
                        .failureUrl("/login?error=true")
                        .usernameParameter("email")
                        .passwordParameter("password")
                        .permitAll()
                )

                // ===== CẤU HÌNH LOGOUT =====
                .logout(logout -> logout
                        .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                        .logoutSuccessUrl("/login?logout=true")
                        .invalidateHttpSession(true)
                        .deleteCookies("JSESSIONID", "elearning-remember-me")
                        .clearAuthentication(true)
                        .permitAll()
                )

                // ===== CẤU HÌNH REMEMBER ME =====
                .rememberMe(rememberMe -> rememberMe
                        .rememberMeServices(rememberMeServices)
                        .key(REMEMBER_ME_KEY)
                        .tokenValiditySeconds(30 * 24 * 60 * 60) // 30 ngày
                        .userDetailsService(userService)
                )

                // ===== CẤU HÌNH SESSION MANAGEMENT =====
                .sessionManagement(session -> session
                        .maximumSessions(3) // Tối đa 3 sessions per user
                        .maxSessionsPreventsLogin(false) // Cho phép login mới, logout session cũ
                        .sessionRegistry(sessionRegistry)
                        .expiredUrl("/login?expired=true")
                )

                // ===== CẤU HÌNH EXCEPTION HANDLING =====
                .exceptionHandling(exceptions -> exceptions
                        .authenticationEntryPoint((request, response, authException) -> {
                            response.sendRedirect("/login?error=unauthorized");
                        })
                        .accessDeniedHandler((request, response, accessDeniedException) -> {
                            response.sendRedirect("/access-denied");
                        })
                )

                // ===== CẤU HÌNH CSRF PROTECTION =====
                .csrf(csrf -> csrf
                        // Tắt CSRF cho API endpoints nếu cần
                        .ignoringRequestMatchers("/api/**")
                        // Cấu hình CSRF token repository
                        .csrfTokenRepository(org.springframework.security.web.csrf.CookieCsrfTokenRepository.withHttpOnlyFalse())
                )

                // SỬA LỖI: Cấu hình headers security với syntax mới Spring Security 6.x
                .headers(headers -> headers
                        // Frame options để chống clickjacking
                        .frameOptions(frameOptions -> frameOptions.deny())

                        // Content type options
                        .contentTypeOptions(contentTypeOptions -> {
                            // Sử dụng lambda rỗng vì không cần config thêm
                        })

                        // SỬA LỖI CHÍNH: includeSubdomains -> includeSubDomains (chữ D viết hoa)
                        .httpStrictTransportSecurity(hstsConfig -> hstsConfig
                                .maxAgeInSeconds(31536000) // HSTS 1 năm
                                .includeSubDomains(true) // ✅ SỬA LỖI: includeSubDomains thay vì includeSubdomains
                                .preload(true)
                        )

                        // Referrer policy
                        .referrerPolicy(ReferrerPolicyHeaderWriter.ReferrerPolicy.STRICT_ORIGIN_WHEN_CROSS_ORIGIN)
                );

        return http.build();
    }

    /**
     * Bean để bypass security cho static resources trong development
     * Chỉ sử dụng khi profile development được active
     *
     * Uncomment đoạn code này nếu cần bypass security cho H2 console trong dev:
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