package com.coursemanagement.config;

import com.coursemanagement.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
 * ✅ FIXED: Sửa lỗi cho phép tất cả request và tắt form login
 * ✅ FIXED: Sửa lỗi UserDetailsService cannot be null và dependency injection
 */
@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true)
public class SecurityConfig {

    private static final String REMEMBER_ME_KEY = "elearning-platform-remember-me-key-2024";

    /**
     * Cấu hình mã hóa mật khẩu bằng BCrypt
     */
    @Bean
    public static PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(12);
    }

    /**
     * Session Registry để quản lý sessions - SỬA LỖI: Bỏ static
     */
    @Bean
    public SessionRegistry sessionRegistry() {
        return new SessionRegistryImpl();
    }

    /**
     * Cấu hình Authentication Provider - SỬA LỖI: Bỏ static
     */
    @Bean
    public DaoAuthenticationProvider authenticationProvider(UserService userService, PasswordEncoder passwordEncoder) {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userService);
        authProvider.setPasswordEncoder(passwordEncoder);
        authProvider.setHideUserNotFoundExceptions(false);
        return authProvider;
    }

    /**
     * Cấu hình Authentication Manager
     */
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    /**
     * Remember Me Services - SỬA LỖI: Bỏ static và inject UserService đúng cách
     */
    @Bean
    public RememberMeServices rememberMeServices(UserService userService) {
        TokenBasedRememberMeServices rememberMeServices =
                new TokenBasedRememberMeServices(REMEMBER_ME_KEY, userService);
        rememberMeServices.setTokenValiditySeconds(30 * 24 * 60 * 60); // 30 ngày
        rememberMeServices.setCookieName("elearning-remember-me");
        rememberMeServices.setParameter("remember-me");
        return rememberMeServices;
    }

    /**
     * Success Handler để redirect theo role
     */
    @Bean
    public AuthenticationSuccessHandler authenticationSuccessHandler() {
        return new AuthenticationSuccessHandler() {
            @Override
            public void onAuthenticationSuccess(HttpServletRequest request,
                                                HttpServletResponse response,
                                                Authentication authentication) throws IOException, ServletException {

                var authorities = authentication.getAuthorities();
                String redirectURL;

                if (authorities.contains(new SimpleGrantedAuthority("ROLE_ADMIN"))) {
                    redirectURL = "/admin/dashboard";
                } else if (authorities.contains(new SimpleGrantedAuthority("ROLE_INSTRUCTOR"))) {
                    redirectURL = "/instructor/dashboard";
                } else if (authorities.contains(new SimpleGrantedAuthority("ROLE_STUDENT"))) {
                    redirectURL = "/student/dashboard";
                } else {
                    redirectURL = "/dashboard";
                }

                if (!response.isCommitted()) {
                    response.sendRedirect(redirectURL);
                }
            }
        };
    }

    /**
     * ✅ FIXED: Cấu hình Security Filter Chain đúng cách
     */
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http,
                                                   RememberMeServices rememberMeServices,
                                                   SessionRegistry sessionRegistry,
                                                   AuthenticationSuccessHandler authenticationSuccessHandler) throws Exception {
        http
                // CSRF Configuration - Tắt CSRF cho development, bật lại cho production
                .csrf(csrf -> csrf.disable())

                // ✅ FIXED: Cấu hình authorization requests đúng cách
                .authorizeHttpRequests(auth -> auth
                        // Public resources - Cho phép truy cập không cần đăng nhập
                        .requestMatchers("/", "/home", "/about", "/contact").permitAll()
                        .requestMatchers("/register", "/login", "/forgot-password").permitAll()
                        .requestMatchers("/courses", "/courses/**", "/course-detail/**").permitAll()
                        .requestMatchers("/api/public/**").permitAll()

                        // Static resources - CSS, JS, Images
                        .requestMatchers("/css/**", "/js/**", "/images/**", "/uploads/**").permitAll()
                        .requestMatchers("/favicon.ico", "/robots.txt").permitAll()

                        // Error pages
                        .requestMatchers("/error", "/error/**").permitAll()

                        // Admin only
                        .requestMatchers("/admin/**").hasRole("ADMIN")

                        // Instructor only
                        .requestMatchers("/instructor/**").hasRole("INSTRUCTOR")

                        // Student only
                        .requestMatchers("/student/**").hasRole("STUDENT")

                        // API endpoints need authentication
                        .requestMatchers("/api/**").authenticated()

                        // All other requests need authentication
                        .anyRequest().authenticated()
                )

                // ✅ FIXED: Bật lại form login với cấu hình đúng
                .formLogin(login -> login
                        .loginPage("/login")
                        .loginProcessingUrl("/login")
                        .usernameParameter("username")
                        .passwordParameter("password")
                        .successHandler(authenticationSuccessHandler)
                        .failureUrl("/login?error=true")
                        .permitAll()
                )

                // Logout configuration
                .logout(logout -> logout
                        .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                        .logoutSuccessUrl("/login?logout=true")
                        .deleteCookies("JSESSIONID", "elearning-remember-me")
                        .invalidateHttpSession(true)
                        .clearAuthentication(true)
                        .permitAll()
                )

                // Remember Me configuration - SỬA LỖI: Sử dụng RememberMeServices đã inject
                .rememberMe(remember -> remember
                        .rememberMeServices(rememberMeServices)
                        .key(REMEMBER_ME_KEY)
                        .tokenValiditySeconds(30 * 24 * 60 * 60)
                )

                // Session Management - SỬA LỖI: Sử dụng SessionRegistry đã inject
                .sessionManagement(session -> session
                        .maximumSessions(2) // Cho phép tối đa 2 session cùng lúc
                        .maxSessionsPreventsLogin(false) // Không chặn login mới
                        .sessionRegistry(sessionRegistry)
                        .and()
                        .sessionFixation().migrateSession()
                        .invalidSessionUrl("/login?expired=true")
                )

                // Security Headers
                .headers(headers -> headers
                        .frameOptions().deny()
                        .contentTypeOptions().and()
                        .httpStrictTransportSecurity(hstsConfig -> hstsConfig
                                .maxAgeInSeconds(31536000)
                                .includeSubDomains(true)
                        )
                        .referrerPolicy(ReferrerPolicyHeaderWriter.ReferrerPolicy.STRICT_ORIGIN_WHEN_CROSS_ORIGIN)
                );

        return http.build();
    }
}