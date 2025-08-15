package com.coursemanagement.config;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.core.session.SessionRegistryImpl;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.security.web.authentication.RememberMeServices;
import org.springframework.security.web.authentication.rememberme.TokenBasedRememberMeServices;
import com.coursemanagement.service.UserService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.RememberMeServices;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

/**
 * ✅ SECURITY CONFIG - BƯỚC 2: BẬT AUTHENTICATION ĐƠN GIẢN
 *
 * Trang login đã hoạt động ở bước 1!
 * Bây giờ bật authentication từ từ:
 * - Chỉ yêu cầu login, chưa phân quyền role
 * - Test với demo accounts có sẵn
 * - Redirect đơn giản về trang chủ
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final UserService userService;

    /**
     * ✅ Constructor injection với @Lazy để tránh circular dependency
     */
    public SecurityConfig(@Lazy UserService userService) {
        this.userService = userService;
    }

    /**
     * ✅ PasswordEncoder static method
     */
    @Bean
    public static PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(12);
    }
    @Bean
    public RememberMeServices rememberMeServices(UserService userService) {
        // "uniqueKey" có thể đổi theo dự án của bạn
        TokenBasedRememberMeServices rememberMeServices =
                new TokenBasedRememberMeServices("uniqueKey", userService);
        rememberMeServices.setAlwaysRemember(false);
        return rememberMeServices;
    }

    /**
     * ✅ Bean SessionRegistry
     */
    @Bean
    public SessionRegistry sessionRegistry() {
        return new SessionRegistryImpl();
    }

    /**
     * ✅ Bean AuthenticationSuccessHandler cơ bản
     */
    @Bean
    public AuthenticationSuccessHandler authenticationSuccessHandler() {
        SimpleUrlAuthenticationSuccessHandler handler =
                new SimpleUrlAuthenticationSuccessHandler();
        handler.setDefaultTargetUrl("/"); // Redirect sau khi login thành công
        handler.setAlwaysUseDefaultTargetUrl(true);
        return handler;
    }

    /**
     * ✅ DaoAuthenticationProvider - CẦN CHO AUTHENTICATION
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
     * ✅ AuthenticationManager
     */
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    /**
     * ✅ BƯỚC 1: PERMIT ALL (ĐÃ TEST OK - COMMENT LẠI)
     */
//    @Bean
//    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
//        http
//                .csrf(csrf -> csrf.disable())
//                .authorizeHttpRequests(auth -> auth
//                        .anyRequest().permitAll()
//                )
//                .formLogin(login -> login.disable())
//                .logout(logout -> logout.disable())
//                .headers(headers -> headers
//                        .frameOptions().sameOrigin()
//                );
//        return http.build();
//    }

    /**
     * ✅ BƯỚC 2: BẬT AUTHENTICATION ĐƠN GIẢN
     * - Chỉ yêu cầu login, chưa phân quyền role cụ thể
     * - Test với demo accounts: admin/admin123, instructor1/instructor123, student1/student123
     */
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http,
                                                   RememberMeServices rememberMeServices,
                                                   SessionRegistry sessionRegistry,
                                                   AuthenticationSuccessHandler authenticationSuccessHandler) throws Exception {
        http
                // CSRF Configuration - Tắt CSRF cho development
                .csrf(csrf -> csrf.disable())

                // ✅ SỬA LỖI: AUTHORIZATION CƠ BẢN
                .authorizeHttpRequests(auth -> auth
                        // Public pages - không cần login
                        .requestMatchers("/", "/home", "/login", "/register").permitAll()
                        .requestMatchers("/css/**", "/js/**", "/images/**", "/favicon.ico").permitAll()
                        .requestMatchers("/error").permitAll()

                        // ✅ TẤT CẢ TRANG KHÁC CẦN LOGIN NHƯNG CHƯA PHÂN QUYỀN ROLE
                        .anyRequest().authenticated()
                )

                // ✅ SỬA LỖI: BẬT LẠI FORM LOGIN ĐÚNG CÁCH
                .formLogin(login -> login
                        .loginPage("/login")                    // Custom login page
                        .loginProcessingUrl("/login")           // URL xử lý POST login
                        .usernameParameter("username")          // Tên field username
                        .passwordParameter("password")          // Tên field password
                        .defaultSuccessUrl("/", true)          // Redirect về home sau login
                        .failureUrl("/login?error=true")       // Redirect khi login fail
                        .permitAll()                           // Cho phép truy cập login page
                )

                // ✅ SỬA LỖI: LOGOUT ĐÚNG CÁCH
                .logout(logout -> logout
                        .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                        .logoutSuccessUrl("/")                 // ✅ SỬA: Redirect về HOME thay vì login
                        .deleteCookies("JSESSIONID")
                        .invalidateHttpSession(true)
                        .clearAuthentication(true)
                        .permitAll()
                )

                // ✅ SESSION MANAGEMENT ĐƠNGIẢN
                .sessionManagement(session -> session
                        .maximumSessions(1)                    // Chỉ cho phép 1 session
                        .maxSessionsPreventsLogin(false)       // Không chặn login mới
                        .sessionRegistry(sessionRegistry)
                        .and()
                        .sessionFixation().migrateSession()
                        .invalidSessionUrl("/")               // ✅ SỬA: Redirect về HOME khi session hết hạn
                )

                // ✅ HEADERS CƠ BẢN
                .headers(headers -> headers
                        .frameOptions().sameOrigin()
                );

        return http.build();
    }

    /**
     * ✅ BƯỚC 3: ROLE-BASED AUTHORIZATION (SỬ DỤNG KHI ĐÃ TEST OK BƯỚC 2)
     */
//    @Bean
//    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
//        http
//                .csrf(csrf -> csrf.disable())
//
//                .authorizeHttpRequests(auth -> auth
//                        // Public pages
//                        .requestMatchers("/", "/login", "/register", "/test-*").permitAll()
//                        .requestMatchers("/css/**", "/js/**", "/images/**", "/webjars/**").permitAll()
//
//                        // Role-based authorization - CHỈ KHI ĐÃ TEST OK AUTHENTICATION CƠ BẢN
//                        .requestMatchers("/admin/**").hasRole("ADMIN")
//                        .requestMatchers("/instructor/**").hasRole("INSTRUCTOR")
//                        .requestMatchers("/student/**").hasRole("STUDENT")
//
//                        // Default
//                        .anyRequest().authenticated()
//                )
//
//                .formLogin(login -> login
//                        .loginPage("/login")
//                        .defaultSuccessUrl("/")
//                        .permitAll()
//                )
//
//                .logout(logout -> logout
//                        .logoutUrl("/logout")
//                        .logoutSuccessUrl("/login?logout=true")
//                        .permitAll()
//                );
//
//        return http.build();
//    }
}