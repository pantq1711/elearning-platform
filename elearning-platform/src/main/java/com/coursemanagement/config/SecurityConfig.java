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
import org.springframework.security.config.http.SessionCreationPolicy;
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
import java.time.Duration;

/**
 * Cấu hình bảo mật toàn diện cho hệ thống e-learning
 * Xử lý authentication (xác thực) và authorization (phân quyền)
 * Cải thiện bảo mật với nhiều tính năng nâng cao - Spring Security 6.x compatible
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
     * Session Registry để quản lý sessions
     * @return SessionRegistry implementation
     */
    @Bean
    public SessionRegistry sessionRegistry() {
        return new SessionRegistryImpl();
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
     * Điều hướng user đến trang phù hợp sau khi đăng nhập thành công
     */
    @Bean
    public AuthenticationSuccessHandler authenticationSuccessHandler() {
        return new AuthenticationSuccessHandler() {
            @Override
            public void onAuthenticationSuccess(HttpServletRequest request,
                                                HttpServletResponse response,
                                                Authentication authentication) throws IOException, ServletException {

                // Lấy thông tin user để xác định role
                Object principal = authentication.getPrincipal();
                if (principal instanceof org.springframework.security.core.userdetails.UserDetails) {
                    var userDetails = (org.springframework.security.core.userdetails.UserDetails) principal;

                    // Điều hướng dựa trên role
                    String redirectUrl = "/dashboard"; // Default fallback

                    if (userDetails.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_ADMIN"))) {
                        redirectUrl = "/admin/dashboard";
                    } else if (userDetails.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_INSTRUCTOR"))) {
                        redirectUrl = "/instructor/dashboard";
                    } else if (userDetails.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_STUDENT"))) {
                        redirectUrl = "/student/dashboard";
                    }

                    // Redirect về trang đích
                    response.sendRedirect(redirectUrl);
                } else {
                    // Fallback redirect
                    response.sendRedirect("/dashboard");
                }
            }
        };
    }

    /**
     * Cấu hình Security Filter Chain chính
     * Đây là phần cốt lõi của Spring Security configuration
     * @param http HttpSecurity configuration object
     * @return SecurityFilterChain đã được cấu hình
     * @throws Exception Nếu có lỗi cấu hình
     */
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                // Cấu hình authorization rules
                .authorizeHttpRequests(authz -> authz
                        // Public resources - không cần authentication
                        .requestMatchers("/", "/home", "/login", "/register").permitAll()
                        .requestMatchers("/css/**", "/js/**", "/images/**", "/favicon.ico").permitAll()
                        .requestMatchers("/public/**", "/about", "/contact").permitAll()
                        .requestMatchers("/api/v1/public/**").permitAll()
                        .requestMatchers("/actuator/health").permitAll()

                        // Admin-only endpoints
                        .requestMatchers("/admin/**").hasRole("ADMIN")

                        // Instructor endpoints
                        .requestMatchers("/instructor/**").hasRole("INSTRUCTOR")

                        // Student endpoints
                        .requestMatchers("/student/**").hasRole("STUDENT")

                        // API endpoints với role-based access
                        .requestMatchers("/api/v1/admin/**").hasRole("ADMIN")
                        .requestMatchers("/api/v1/instructor/**").hasRole("INSTRUCTOR")
                        .requestMatchers("/api/v1/student/**").hasRole("STUDENT")

                        // Dashboard - authenticated users only
                        .requestMatchers("/dashboard").authenticated()

                        // Tất cả request khác cần authentication
                        .anyRequest().authenticated()
                )

                // Cấu hình form login
                .formLogin(form -> form
                        .loginPage("/login")
                        .loginProcessingUrl("/perform_login") // URL xử lý login
                        .usernameParameter("username")
                        .passwordParameter("password")
                        .successHandler(authenticationSuccessHandler()) // Custom success handler
                        .failureUrl("/login?error=true")
                        .permitAll()
                )

                // Cấu hình logout
                .logout(logout -> logout
                        .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                        .logoutSuccessUrl("/login?logout=true")
                        .deleteCookies("JSESSIONID", "ELEARNING_REMEMBER_ME")
                        .invalidateHttpSession(true)
                        .clearAuthentication(true)
                        .permitAll()
                )

                // Remember me configuration
                .rememberMe(remember -> remember
                        .rememberMeServices(rememberMeServices())
                        .key(REMEMBER_ME_KEY)
                        .tokenValiditySeconds(86400 * 7) // 7 ngày
                        .userDetailsService(userService)
                )

                // Exception handling
                .exceptionHandling(exceptions -> exceptions
                        .accessDeniedPage("/access-denied")
                        .authenticationEntryPoint((request, response, authException) -> {
                            response.sendRedirect("/login?required=true");
                        })
                )

                // Session management với Spring Security 6.x syntax
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)
                        .maximumSessions(3) // Tối đa 3 sessions đồng thời
                        .maxSessionsPreventsLogin(false) // Cho phép login mới, kick old sessions
                        .expiredUrl("/login?expired=true") // URL khi session hết hạn
                        .sessionRegistry(sessionRegistry())
                        .sessionFixation().migrateSession() // Fix: không dùng .and()
                        .invalidSessionUrl("/login?invalid=true")
                )

                // Cấu hình CSRF protection với exception cho API
                .csrf(csrf -> csrf
                        .ignoringRequestMatchers("/api/**", "/h2-console/**") // Bỏ qua CSRF cho REST API
                        .csrfTokenRepository(org.springframework.security.web.csrf.CookieCsrfTokenRepository.withHttpOnlyFalse())
                )

                // Cấu hình headers security với syntax mới
                .headers(headers -> headers
                        .frameOptions(frameOptions -> frameOptions.deny()) // Sửa: không dùng deprecated DENY
                        .contentTypeOptions() // Fix: không dùng .and()
                        .httpStrictTransportSecurity(hstsConfig -> hstsConfig
                                .maxAgeInSeconds(31536000) // HSTS 1 năm
                                .includeSubDomains(true) // Fix: chính xác method name
                                .preload(true)
                        )
                        .referrerPolicy(org.springframework.security.web.header.writers.ReferrerPolicyHeaderWriter.ReferrerPolicy.STRICT_ORIGIN_WHEN_CROSS_ORIGIN) // Fix: full class path
                );

        return http.build();
    }

    /**
     * Authentication Provider configuration
     * @param http HttpSecurity object
     * @throws Exception Nếu có lỗi cấu hình
     */
    @Autowired
    public void configureGlobal(HttpSecurity http) throws Exception {
        http.authenticationProvider(authenticationProvider());
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