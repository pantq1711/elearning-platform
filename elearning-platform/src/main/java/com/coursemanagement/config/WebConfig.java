package com.coursemanagement.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.config.annotation.*;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;
import org.springframework.web.servlet.i18n.LocaleChangeInterceptor;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;

import java.util.Locale;
import java.util.Properties;

/**
 * Cấu hình Spring MVC cho ứng dụng e-learning
 * Xử lý view resolver, static resources, interceptors, internationalization
 */
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    /**
     * Cấu hình View Resolver cho JSP với JSTL support
     * Định nghĩa vị trí và extension của view files
     */
    @Bean
    public InternalResourceViewResolver viewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setViewClass(JstlView.class);
        resolver.setPrefix("/WEB-INF/views/");
        resolver.setSuffix(".jsp");
        resolver.setOrder(1);

        // Cấu hình thêm cho JSP và JSTL
        resolver.setExposeContextBeansAsAttributes(true);
        resolver.setExposedContextBeanNames("messageSource");

        // Expose request attributes cho JSP
        resolver.setExposeRequestAttributes(true);
        resolver.setExposeSessionAttributes(true);

        // Cache views trong production
        resolver.setCache(true);
        resolver.setCacheLimit(1024);

        return resolver;
    }

    /**
     * Cấu hình Static Resource Handling với cache optimization
     * Xử lý các file tĩnh như CSS, JS, images với tối ưu cache
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // CSS files với cache 1 giờ
        registry.addResourceHandler("/css/**")
                .addResourceLocations("/WEB-INF/static/css/", "classpath:/static/css/")
                .setCachePeriod(3600)
                .resourceChain(true);

        // JavaScript files với cache 1 giờ
        registry.addResourceHandler("/js/**")
                .addResourceLocations("/WEB-INF/static/js/", "classpath:/static/js/")
                .setCachePeriod(3600)
                .resourceChain(true);

        // Image files với cache 24 giờ
        registry.addResourceHandler("/images/**")
                .addResourceLocations("/WEB-INF/static/images/", "classpath:/static/images/")
                .setCachePeriod(86400)
                .resourceChain(true);

        // Favicon với cache 24 giờ
        registry.addResourceHandler("/favicon.ico")
                .addResourceLocations("/WEB-INF/static/", "classpath:/static/")
                .setCachePeriod(86400)
                .resourceChain(true);

        // Fonts với cache 24 giờ
        registry.addResourceHandler("/fonts/**")
                .addResourceLocations("/WEB-INF/static/fonts/", "classpath:/static/fonts/")
                .setCachePeriod(86400)
                .resourceChain(true);

        // Upload directory cho file upload
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:uploads/")
                .setCachePeriod(3600)
                .resourceChain(true);

        // WebJars support cho các thư viện JS/CSS từ Maven
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
     * Cấu hình View Controllers cho các trang không cần logic phức tạp
     * Mapping trực tiếp URL đến view không cần controller
     */
    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        // Error pages
        registry.addViewController("/404").setViewName("error/404");
        registry.addViewController("/500").setViewName("error/500");
        registry.addViewController("/access-denied").setViewName("error/access-denied");

        // Static pages
        registry.addViewController("/about").setViewName("public/about");
        registry.addViewController("/contact").setViewName("public/contact");
        registry.addViewController("/privacy").setViewName("public/privacy");
        registry.addViewController("/terms").setViewName("public/terms");
    }

    /**
     * Cấu hình Locale Resolver cho đa ngôn ngữ
     * Sử dụng session để lưu ngôn ngữ người dùng chọn
     */
    @Bean
    public LocaleResolver localeResolver() {
        SessionLocaleResolver resolver = new SessionLocaleResolver();
        resolver.setDefaultLocale(new Locale("vi", "VN")); // Mặc định tiếng Việt
        return resolver;
    }

    /**
     * Locale Change Interceptor
     * Cho phép đổi ngôn ngữ bằng parameter ?lang=en hoặc ?lang=vi
     */
    @Bean
    public LocaleChangeInterceptor localeChangeInterceptor() {
        LocaleChangeInterceptor interceptor = new LocaleChangeInterceptor();
        interceptor.setParamName("lang");
        return interceptor;
    }

    /**
     * Message Source cho internationalization (i18n)
     * Đọc các file messages_vi.properties, messages_en.properties
     */
    @Bean
    public ResourceBundleMessageSource messageSource() {
        ResourceBundleMessageSource messageSource = new ResourceBundleMessageSource();
        messageSource.setBasename("messages");
        messageSource.setDefaultEncoding("UTF-8");
        messageSource.setCacheSeconds(3600);
        messageSource.setFallbackToSystemLocale(false);
        return messageSource;
    }

    /**
     * Multipart Resolver cho file upload
     * Xử lý upload file với Spring Boot
     */
    @Bean
    public StandardServletMultipartResolver multipartResolver() {
        return new StandardServletMultipartResolver();
    }

    /**
     * Global Exception Handler
     * Xử lý các exception không được catch và mapping tới error pages
     */
    @Bean
    public HandlerExceptionResolver handlerExceptionResolver() {
        SimpleMappingExceptionResolver resolver = new SimpleMappingExceptionResolver();

        Properties mappings = new Properties();
        mappings.setProperty("java.lang.Exception", "error/500");
        mappings.setProperty("java.sql.SQLException", "error/database");
        mappings.setProperty("org.springframework.security.access.AccessDeniedException", "error/access-denied");
        mappings.setProperty("org.springframework.web.multipart.MaxUploadSizeExceededException", "error/file-too-large");

        resolver.setExceptionMappings(mappings);
        resolver.setDefaultErrorView("error/500");
        resolver.setExceptionAttribute("exception");
        resolver.setWarnLogCategory("warn");

        return resolver;
    }

    /**
     * Thêm các interceptors vào registry
     * Bao gồm locale change interceptor
     */
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(localeChangeInterceptor());
    }

    /**
     * Cấu hình CORS cho API endpoints (nếu cần)
     * Cho phép cross-origin requests từ frontend khác
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
     * Cấu hình Content Negotiation
     * Xác định kiểu response dựa trên Accept header hoặc URL extension
     */
    @Override
    public void configureContentNegotiation(ContentNegotiationConfigurer configurer) {
        configurer
                .favorParameter(false)
                .favorPathExtension(false)
                .ignoreAcceptHeader(false)
                .defaultContentType(org.springframework.http.MediaType.TEXT_HTML)
                .mediaType("json", org.springframework.http.MediaType.APPLICATION_JSON)
                .mediaType("xml", org.springframework.http.MediaType.APPLICATION_XML);
    }
}