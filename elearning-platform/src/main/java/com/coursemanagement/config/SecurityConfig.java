package com.coursemanagement.config;

import jakarta.servlet.DispatcherType;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.Customizer;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.core.session.SessionRegistryImpl;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.security.web.authentication.RememberMeServices;
import org.springframework.security.web.authentication.rememberme.TokenBasedRememberMeServices;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.security.access.hierarchicalroles.RoleHierarchy;
import org.springframework.security.access.hierarchicalroles.RoleHierarchyImpl;

import com.coursemanagement.service.UserService;

/**
 * ✅ SECURITY CONFIG - ĐÃ FIX TẤT CẢ DEPRECATED WARNINGS
 *
 * Spring Security 6.1+ Compatible
 * - Loại bỏ tất cả .and() deprecated
 * - Cập nhật headers API mới
 * - Fix session management syntax
 * - Compatible với Spring Boot 3.x
 */
@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true, securedEnabled = true, jsr250Enabled = true)
public class SecurityConfig {

    private final UserService userService;

    /**
     * ✅ Constructor injection với @Lazy để tránh circular dependency
     */
    public SecurityConfig(@Lazy UserService userService) {
        this.userService = userService;
    }

    /**
     * ✅ PasswordEncoder static method - Giữ nguyên như cũ
     */
    @Bean
    public static PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(10); // Giữ nguyên strength 10 để match DB hiện tại
    }

    /**
     * ✅ Role Hierarchy - ADMIN có quyền của tất cả role dưới
     * ADMIN > INSTRUCTOR > STUDENT
     */
    @Bean
    public RoleHierarchy roleHierarchy() {
        RoleHierarchyImpl roleHierarchy = new RoleHierarchyImpl();
        String hierarchy = """
            ROLE_ADMIN > ROLE_INSTRUCTOR
            ROLE_INSTRUCTOR > ROLE_STUDENT
            """;
        roleHierarchy.setHierarchy(hierarchy);
        return roleHierarchy;
    }

    /**
     * ✅ RememberMe Services - Updated API
     */
    @Bean
    public RememberMeServices rememberMeServices(@Lazy UserService userService) {
        TokenBasedRememberMeServices rememberMeServices =
                new TokenBasedRememberMeServices("elearning-unique-key-2024", userService);
        rememberMeServices.setAlwaysRemember(false);
        rememberMeServices.setTokenValiditySeconds(30 * 24 * 60 * 60); // 30 ngày
        return rememberMeServices;
    }

    /**
     * ✅ SessionRegistry
     */
    @Bean
    public SessionRegistry sessionRegistry() {
        return new SessionRegistryImpl();
    }

    /**
     * ✅ Custom Authentication Success Handler theo Role - Updated
     */
    @Bean
    public AuthenticationSuccessHandler authenticationSuccessHandler() {
        return (request, response, authentication) -> {
            // Lấy user authorities
            boolean isAdmin = authentication.getAuthorities().stream()
                    .anyMatch(auth -> auth.getAuthority().equals("ROLE_ADMIN"));
            boolean isInstructor = authentication.getAuthorities().stream()
                    .anyMatch(auth -> auth.getAuthority().equals("ROLE_INSTRUCTOR"));
            boolean isStudent = authentication.getAuthorities().stream()
                    .anyMatch(auth -> auth.getAuthority().equals("ROLE_STUDENT"));

            // Redirect theo role
            String redirectUrl = "/";
            if (isAdmin) {
                redirectUrl = "/admin/dashboard";
            } else if (isInstructor) {
                redirectUrl = "/instructor/dashboard";
            } else if (isStudent) {
                redirectUrl = "/student/dashboard";
            }

            response.sendRedirect(redirectUrl);
        };
    }

    /**
     * ✅ DaoAuthenticationProvider - Updated
     */
    @Bean
    public DaoAuthenticationProvider authenticationProvider(@Lazy UserService userService,
                                                            PasswordEncoder passwordEncoder) {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userService);
        authProvider.setPasswordEncoder(passwordEncoder);
        authProvider.setHideUserNotFoundExceptions(false);
        return authProvider;
    }

    /**
     * ✅ AuthenticationManager
     */
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    /**
     * ✅ SECURITY FILTER CHAIN - FIXED ALL DEPRECATED APIs
     */
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http,
                                                   RememberMeServices rememberMeServices,
                                                   SessionRegistry sessionRegistry,
                                                   AuthenticationSuccessHandler authenticationSuccessHandler,
                                                   DaoAuthenticationProvider authenticationProvider) throws Exception {
        http
                // ✅ CSRF Configuration
                .csrf(csrf -> csrf.disable())

                // ✅ Authorization Rules - FIXED: No deprecated .and()
                .authorizeHttpRequests(auth -> auth
                        // Cho phép JSP views
                        .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.INCLUDE).permitAll()

                        // Public endpoints
                        .requestMatchers("/", "/home", "/login", "/register", "/about", "/contact").permitAll()
                        .requestMatchers("/css/**", "/js/**", "/images/**", "/favicon.ico", "/webjars/**").permitAll()
                        .requestMatchers("/error", "/WEB-INF/**", "/403", "/404", "/500").permitAll()

                        // Public API và content
                        .requestMatchers("/api/public/**").permitAll()
                        .requestMatchers("/courses", "/courses/**").permitAll() // Xem khóa học công khai
                        .requestMatchers("/categories", "/categories/**").permitAll() // Xem danh mục

                        // Role-based authorization
                        .requestMatchers("/admin/**").hasRole("ADMIN")
                        .requestMatchers("/instructor/**").hasRole("INSTRUCTOR")
                        .requestMatchers("/student/**").hasRole("STUDENT")

                        // API endpoints
                        .requestMatchers("/api/admin/**").hasRole("ADMIN")
                        .requestMatchers("/api/instructor/**").hasRole("INSTRUCTOR")
                        .requestMatchers("/api/student/**").hasRole("STUDENT")

                        // Authenticated users only
                        .requestMatchers("/profile/**").authenticated()
                        .requestMatchers("/upload/**").authenticated()

                        // All other requests require authentication
                        .anyRequest().authenticated()
                )

                // ✅ Form Login - FIXED: No deprecated API
                .formLogin(login -> login
                        .loginPage("/login")
                        .loginProcessingUrl("/login")
                        .usernameParameter("username")
                        .passwordParameter("password")
                        .successHandler(authenticationSuccessHandler)
                        .failureUrl("/login?error=true")
                        .permitAll()
                )

                // ✅ Remember Me - FIXED: No deprecated API
                .rememberMe(remember -> remember
                        .rememberMeServices(rememberMeServices)
                        .key("elearning-unique-key-2024")
                        .tokenValiditySeconds(30 * 24 * 60 * 60) // 30 ngày
                )

                // ✅ Logout - FIXED: No deprecated API
                .logout(logout -> logout
                        .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                        .logoutSuccessUrl("/?logout=true")
                        .deleteCookies("JSESSIONID", "remember-me")
                        .invalidateHttpSession(true)
                        .clearAuthentication(true)
                        .permitAll()
                )

                // ✅ Session Management - FIXED: Correct sessionFixation placement
                .sessionManagement(session -> session
                        .sessionFixation(sessionFixation -> sessionFixation.migrateSession())
                        .invalidSessionUrl("/login?expired=true")
                        .maximumSessions(3)
                        .maxSessionsPreventsLogin(false)
                        .sessionRegistry(sessionRegistry)
                )

                // ✅ Exception Handling - FIXED: No deprecated API
                .exceptionHandling(exception -> exception
                        .accessDeniedPage("/403")
                        .authenticationEntryPoint((request, response, authException) -> {
                            response.sendRedirect("/login?required=true");
                        })
                )

                // ✅ Authentication Provider
                .authenticationProvider(authenticationProvider)

                // ✅ Security Headers - FIXED: All deprecated APIs updated
                .headers(headers -> headers
                        .frameOptions(frameOptions -> frameOptions.sameOrigin())
                        .contentTypeOptions(Customizer.withDefaults())
                        .httpStrictTransportSecurity(hstsConfig -> hstsConfig
                                .maxAgeInSeconds(31536000)
                                .includeSubDomains(true)
                        )
                );

        return http.build();
    }
}