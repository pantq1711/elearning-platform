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
 * Compatible với Spring Security 6.x - Đã sửa tất cả lỗi compilation
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
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                // Cấu hình authorization rules
                .authorizeHttpRequests(authz -> authz
                        // Public resources - không cần authentication
                        .requestMatchers("/", "/home", "/login", "/register").permitAll()
                        .requestMatchers("/css/**", "/js/**", "/images/**", "/favicon.ico").permitAll()
                        .requestMatchers("/public/**", "/about", "/contact", "/stats").permitAll()
                        .requestMatchers("/api/v1/public/**").permitAll()
                        .requestMatchers("/actuator/health").permitAll()
                        .requestMatchers("/h2-console/**").permitAll() // H2 console trong dev

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

                // Cấu hình form login với syntax mới Spring Security 6.x
                .formLogin(form -> form
                        .loginPage("/login")
                        .loginProcessingUrl("/login")
                        .usernameParameter("username")
                        .passwordParameter("password")
                        .successHandler(authenticationSuccessHandler())
                        .failureUrl("/login?error=true")
                        .permitAll()
                )

                // Cấu hình logout
                .logout(logout -> logout
                        .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                        .logoutSuccessUrl("/login?logout=true")
                        .invalidateHttpSession(true)
                        .deleteCookies("JSESSIONID", "elearning-remember-me")
                        .clearAuthentication(true)
                        .permitAll()
                )

                // Cấu hình Remember Me
                .rememberMe(rememberMe -> rememberMe
                        .rememberMeServices(rememberMeServices())
                        .key(REMEMBER_ME_KEY)
                        .tokenValiditySeconds(30 * 24 * 60 * 60) // 30 ngày
                )

                // Cấu hình session management với syntax mới
                .sessionManagement(session -> session
                        .maximumSessions(1) // Chỉ cho phép 1 session per user
                        .maxSessionsPreventsLogin(false) // Session mới sẽ kick session cũ
                        .sessionRegistry(sessionRegistry())
                        .and()
                        .sessionFixation(sessionFixation -> sessionFixation.migrateSession()) // Fix session fixation
                        .invalidSessionUrl("/login?invalid=true")
                )

                // Cấu hình CSRF protection với exception cho API
                .csrf(csrf -> csrf
                        .ignoringRequestMatchers("/api/**", "/h2-console/**") // Bỏ qua CSRF cho REST API
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