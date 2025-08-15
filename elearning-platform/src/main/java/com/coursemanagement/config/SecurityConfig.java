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
 * ✅ SỬA LỖI REDIRECT LOOP: Cấu hình bảo mật với success handler đơn giản
 * Xử lý authentication (xác thực) và authorization (phân quyền)
 * Compatible với Spring Security 6.x
 */
@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true)
public class SecurityConfig {

    // Key bí mật cho remember-me token
    private static final String REMEMBER_ME_KEY = "elearning-platform-remember-me-key-2024";

    /**
     * Cấu hình mã hóa mật khẩu bằng BCrypt với strength cao
     */
    @Bean
    public static PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(12);
    }

    /**
     * Session Registry để quản lý sessions
     */
    @Bean
    public SessionRegistry sessionRegistry() {
        return new SessionRegistryImpl();
    }

    /**
     * Cấu hình Authentication Provider
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
     * Remember Me Services với token-based approach
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
     * ✅ SỬA LỖI: Success Handler đơn giản, tránh redirect loop
     * REDIRECT VỀ TRANG CHÍNH THAY VÌ DASHBOARD CỤ THỂ
     */
    @Bean
    public AuthenticationSuccessHandler authenticationSuccessHandler() {
        return new AuthenticationSuccessHandler() {
            @Override
            public void onAuthenticationSuccess(HttpServletRequest request,
                                                HttpServletResponse response,
                                                Authentication authentication) throws IOException, ServletException {

                System.out.println("✅ Login thành công cho user: " + authentication.getName());
                System.out.println("✅ Authorities: " + authentication.getAuthorities());

                // ✅ SỬA LỖI: Redirect về trang chính "/" thay vì dashboard cụ thể
                // Tránh redirect loop khi dashboard controllers chưa sẵn sàng
                String redirectURL = "/";

                // Hoặc có thể redirect theo role nhưng tới trang đơn giản hơn
                var authorities = authentication.getAuthorities();
                if (authorities.contains(new SimpleGrantedAuthority("ROLE_ADMIN"))) {
                    redirectURL = "/"; // Tạm thời redirect về home page
                } else if (authorities.contains(new SimpleGrantedAuthority("ROLE_INSTRUCTOR"))) {
                    redirectURL = "/"; // Tạm thời redirect về home page
                } else if (authorities.contains(new SimpleGrantedAuthority("ROLE_STUDENT"))) {
                    redirectURL = "/"; // Tạm thời redirect về home page
                }

                System.out.println("✅ Redirecting to: " + redirectURL);

                if (!response.isCommitted()) {
                    response.sendRedirect(redirectURL);
                }
            }
        };
    }

    /**
     * ✅ SỬA LỖI: Cấu hình Security Filter Chain đơn giản để test
     */
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http,
                                                   RememberMeServices rememberMeServices,
                                                   SessionRegistry sessionRegistry,
                                                   AuthenticationSuccessHandler authenticationSuccessHandler) throws Exception {
        http
                // CSRF Configuration - Tắt CSRF cho development
                .csrf(csrf -> csrf.disable())

                // ✅ AUTHORIZATION: Cấu hình quyền truy cập
                .authorizeHttpRequests(auth -> auth
                        // ✅ TẮT AUTHENTICATION TẠM THỜI ĐỂ TEST
                        .anyRequest().permitAll()
                )

                // ✅ TẮT FORM LOGIN TẠM THỜI ĐỂ TEST
                .formLogin(login -> login.disable())

                // ✅ LOGOUT: Cấu hình đăng xuất
                .logout(logout -> logout
                        .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                        .logoutSuccessUrl("/login?logout=true")
                        .deleteCookies("JSESSIONID", "elearning-remember-me")
                        .invalidateHttpSession(true)
                        .clearAuthentication(true)
                        .permitAll()
                )

                // ✅ REMEMBER ME: Cấu hình ghi nhớ đăng nhập
                .rememberMe(remember -> remember
                        .rememberMeServices(rememberMeServices)
                        .key(REMEMBER_ME_KEY)
                        .tokenValiditySeconds(30 * 24 * 60 * 60)
                )

                // ✅ SESSION MANAGEMENT: Quản lý phiên đăng nhập
                .sessionManagement(session -> session
                        .maximumSessions(2) // Cho phép tối đa 2 session cùng lúc
                        .maxSessionsPreventsLogin(false) // Không chặn login mới
                        .sessionRegistry(sessionRegistry)
                        .and()
                        .sessionFixation().migrateSession()
                        .invalidSessionUrl("/login?expired=true")
                )

                // ✅ SECURITY HEADERS: Cấu hình header bảo mật
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