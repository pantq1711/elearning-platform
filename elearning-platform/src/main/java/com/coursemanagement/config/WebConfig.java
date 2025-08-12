package com.coursemanagement.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.*;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;

/**
 * Cấu hình Spring MVC cho ứng dụng
 * Xử lý view resolver, static resources, interceptors, v.v.
 */
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    /**
     * Cấu hình View Resolver cho JSP
     * Định nghĩa vị trí và extension của view files
     */
    @Bean
    public InternalResourceViewResolver viewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setViewClass(JstlView.class);
        resolver.setPrefix("/WEB-INF/views/");
        resolver.setSuffix(".jsp");
        resolver.setOrder(1);

        // Cấu hình thêm cho JSP
        resolver.setExposeContextBeansAsAttributes(true);
        resolver.setExposedContextBeanNames("messageSource");

        return resolver;
    }

    /**
     * Cấu hình Static Resource Handling
     * Xử lý các file tĩnh như CSS, JS, images
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // CSS files
        registry.addResourceHandler("/css/**")
                .addResourceLocations("/WEB-INF/static/css/", "classpath:/static/css/")
                .setCachePeriod(3600)
                .resourceChain(true);

        // JavaScript files
        registry.addResourceHandler("/js/**")
                .addResourceLocations("/WEB-INF/static/js/", "classpath:/static/js/")
                .setCachePeriod(3600)
                .resourceChain(true);

        // Image files
        registry.addResourceHandler("/images/**")
                .addResourceLocations("/WEB-INF/static/images/", "classpath:/static/images/")
                .setCachePeriod(86400) // Cache 24 hours cho images
                .resourceChain(true);

        // Favicon
        registry.addResourceHandler("/favicon.ico")
                .addResourceLocations("/WEB-INF/static/", "classpath:/static/")
                .setCachePeriod(86400)
                .resourceChain(true);

        // Fonts
        registry.addResourceHandler("/fonts/**")
                .addResourceLocations("/WEB-INF/static/fonts/", "classpath:/static/fonts/")
                .setCachePeriod(86400)
                .resourceChain(true);

        // Upload directory (nếu có)
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:uploads/")
                .setCachePeriod(3600)
                .resourceChain(true);

        // Thêm handler cho các thư viện CDN local (nếu cần)
        registry.addResourceHandler("/webjars/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/")
                .setCachePeriod(86400)
                .resourceChain(true);
    }

    /**
     * Cấu hình Default Servlet Handler
     * Cho phép serving static content từ servlet container
     */
    @Override
    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
        configurer.enable();
    }

    /**
     * Cấu hình View Controllers
     * Mapping trực tiếp URL đến view không cần controller logic
     */
    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        // Error pages
        registry.addViewController("/404").setViewName("error/404");
        registry.addViewController("/500").setViewName("error/500");
        registry.addViewController("/access-denied").setViewName("error/access-denied");

        // Static pages
        registry.addViewController("/about").setViewName("about");
        registry.addViewController("/contact").setViewName("contact");
        registry.addViewController("/privacy").setViewName("privacy");
        registry.addViewController("/terms").setViewName("terms");
    }

    /**
     * Cấu hình CORS (Cross-Origin Resource Sharing)
     * Cho phép API calls từ different origins (nếu cần)
     */
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOriginPatterns("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true)
                .maxAge(3600);
    }

    /**
     * Cấu hình Interceptors
     * Xử lý logic trước và sau mỗi request
     */
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // Logging interceptor
        registry.addInterceptor(new LoggingInterceptor())
                .addPathPatterns("/**")
                .excludePathPatterns("/css/**", "/js/**", "/images/**", "/favicon.ico");

        // Performance monitoring interceptor
        registry.addInterceptor(new PerformanceInterceptor())
                .addPathPatterns("/**")
                .excludePathPatterns("/css/**", "/js/**", "/images/**", "/favicon.ico");

        // Security headers interceptor
        registry.addInterceptor(new SecurityHeadersInterceptor())
                .addPathPatterns("/**");
    }

    /**
     * Cấu hình Content Negotiation
     * Xử lý format của response (JSON, XML, etc.)
     */
    @Override
    public void configureContentNegotiation(ContentNegotiationConfigurer configurer) {
        configurer
                .favorParameter(false)
                .favorPathExtension(false)
                .defaultContentType(org.springframework.http.MediaType.TEXT_HTML)
                .mediaType("json", org.springframework.http.MediaType.APPLICATION_JSON)
                .mediaType("xml", org.springframework.http.MediaType.APPLICATION_XML);
    }

    /**
     * Cấu hình Message Converters
     * Chuyển đổi objects thành JSON/XML responses
     */
    @Override
    public void configureMessageConverters(java.util.List<org.springframework.http.converter.HttpMessageConverter<?>> converters) {
        // JSON converter
        org.springframework.http.converter.json.MappingJackson2HttpMessageConverter jsonConverter =
                new org.springframework.http.converter.json.MappingJackson2HttpMessageConverter();
        jsonConverter.setPrettyPrint(true);
        converters.add(jsonConverter);

        // String converter với UTF-8 encoding
        org.springframework.http.converter.StringHttpMessageConverter stringConverter =
                new org.springframework.http.converter.StringHttpMessageConverter(java.nio.charset.StandardCharsets.UTF_8);
        converters.add(stringConverter);
    }

    /**
     * Cấu hình Path Matching
     * Tùy chỉnh cách Spring MVC match URLs
     */
    @Override
    public void configurePathMatch(PathMatchConfigurer configurer) {
        configurer
                .setUseTrailingSlashMatch(true)
                .setUseSuffixPatternMatch(false)
                .setUrlPathHelper(new org.springframework.web.util.UrlPathHelper());
    }

    /**
     * Custom Locale Resolver
     * Xử lý internationalization (i18n)
     */
    @Bean
    public org.springframework.web.servlet.LocaleResolver localeResolver() {
        org.springframework.web.servlet.i18n.SessionLocaleResolver resolver =
                new org.springframework.web.servlet.i18n.SessionLocaleResolver();
        resolver.setDefaultLocale(new java.util.Locale("vi", "VN")); // Default Vietnamese
        return resolver;
    }

    /**
     * Locale Change Interceptor
     * Cho phép đổi ngôn ngữ bằng parameter
     */
    @Bean
    public org.springframework.web.servlet.i18n.LocaleChangeInterceptor localeChangeInterceptor() {
        org.springframework.web.servlet.i18n.LocaleChangeInterceptor interceptor =
                new org.springframework.web.servlet.i18n.LocaleChangeInterceptor();
        interceptor.setParamName("lang");
        return interceptor;
    }

    /**
     * Message Source cho internationalization
     */
    @Bean
    public org.springframework.context.MessageSource messageSource() {
        org.springframework.context.support.ResourceBundleMessageSource messageSource =
                new org.springframework.context.support.ResourceBundleMessageSource();
        messageSource.setBasename("messages");
        messageSource.setDefaultEncoding("UTF-8");
        messageSource.setCacheSeconds(3600);
        return messageSource;
    }

    /**
     * Multipart Resolver cho file upload
     */
    @Bean
    public org.springframework.web.multipart.MultipartResolver multipartResolver() {
        org.springframework.web.multipart.support.StandardServletMultipartResolver resolver =
                new org.springframework.web.multipart.support.StandardServletMultipartResolver();
        return resolver;
    }

    /**
     * Custom Exception Handler
     * Xử lý global exceptions
     */
    @Bean
    public org.springframework.web.servlet.HandlerExceptionResolver handlerExceptionResolver() {
        org.springframework.web.servlet.handler.SimpleMappingExceptionResolver resolver =
                new org.springframework.web.servlet.handler.SimpleMappingExceptionResolver();

        java.util.Properties mappings = new java.util.Properties();
        mappings.setProperty("java.lang.Exception", "error/500");
        mappings.setProperty("java.sql.SQLException", "error/database");
        mappings.setProperty("org.springframework.security.access.AccessDeniedException", "error/access-denied");

        resolver.setExceptionMappings(mappings);
        resolver.setDefaultErrorView("error/500");
        resolver.setOrder(1);

        return resolver;
    }

    // === Custom Interceptors ===

    /**
     * Logging Interceptor để log requests
     */
    public static class LoggingInterceptor implements org.springframework.web.servlet.HandlerInterceptor {
        private static final org.slf4j.Logger logger = org.slf4j.LoggerFactory.getLogger(LoggingInterceptor.class);

        @Override
        public boolean preHandle(jakarta.servlet.http.HttpServletRequest request,
                                 jakarta.servlet.http.HttpServletResponse response,
                                 Object handler) throws Exception {
            logger.debug("Request: {} {} from {}", request.getMethod(), request.getRequestURI(), request.getRemoteAddr());
            return true;
        }

        @Override
        public void afterCompletion(jakarta.servlet.http.HttpServletRequest request,
                                    jakarta.servlet.http.HttpServletResponse response,
                                    Object handler, Exception ex) throws Exception {
            if (ex != null) {
                logger.error("Request completed with error: {}", ex.getMessage());
            }
        }
    }

    /**
     * Performance Interceptor để monitor thời gian response
     */
    public static class PerformanceInterceptor implements org.springframework.web.servlet.HandlerInterceptor {
        private static final org.slf4j.Logger logger = org.slf4j.LoggerFactory.getLogger(PerformanceInterceptor.class);
        private static final String START_TIME = "startTime";

        @Override
        public boolean preHandle(jakarta.servlet.http.HttpServletRequest request,
                                 jakarta.servlet.http.HttpServletResponse response,
                                 Object handler) throws Exception {
            request.setAttribute(START_TIME, System.currentTimeMillis());
            return true;
        }

        @Override
        public void afterCompletion(jakarta.servlet.http.HttpServletRequest request,
                                    jakarta.servlet.http.HttpServletResponse response,
                                    Object handler, Exception ex) throws Exception {
            Long startTime = (Long) request.getAttribute(START_TIME);
            if (startTime != null) {
                long duration = System.currentTimeMillis() - startTime;
                if (duration > 1000) { // Log slow requests (>1s)
                    logger.warn("Slow request: {} {} took {}ms",
                            request.getMethod(), request.getRequestURI(), duration);
                }
            }
        }
    }

    /**
     * Security Headers Interceptor để thêm security headers
     */
    public static class SecurityHeadersInterceptor implements org.springframework.web.servlet.HandlerInterceptor {

        @Override
        public boolean preHandle(jakarta.servlet.http.HttpServletRequest request,
                                 jakarta.servlet.http.HttpServletResponse response,
                                 Object handler) throws Exception {
            // Add security headers
            response.setHeader("X-Content-Type-Options", "nosniff");
            response.setHeader("X-Frame-Options", "DENY");
            response.setHeader("X-XSS-Protection", "1; mode=block");
            response.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");

            // Content Security Policy
            response.setHeader("Content-Security-Policy",
                    "default-src 'self'; " +
                            "script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdnjs.cloudflare.com https://cdn.jsdelivr.net; " +
                            "style-src 'self' 'unsafe-inline' https://cdnjs.cloudflare.com https://fonts.googleapis.com; " +
                            "font-src 'self' https://fonts.gstatic.com https://cdnjs.cloudflare.com; " +
                            "img-src 'self' data: https://img.youtube.com; " +
                            "frame-src https://www.youtube.com;");

            return true;
        }
    }
}