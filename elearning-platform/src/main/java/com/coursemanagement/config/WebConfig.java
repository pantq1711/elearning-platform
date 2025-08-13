package com.coursemanagement.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ContentNegotiationConfigurer;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.PathMatchConfigurer;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;

/**
 * Cấu hình Web MVC cho ứng dụng Course Management
 * Fix các deprecated methods trong Spring Boot 3.x
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

    /**
     * Cấu hình path matching - sửa deprecated methods
     * @param configurer Path match configurer
     */
    @Override
    public void configurePathMatch(PathMatchConfigurer configurer) {
        // Spring Boot 3.x không còn hỗ trợ suffix pattern matching
        // Các deprecated methods đã được remove

        // Cấu hình trailing slash matching nếu cần
        configurer.setUseTrailingSlashMatch(true);
    }

    /**
     * Cấu hình content negotiation - sửa deprecated methods
     * @param configurer Content negotiation configurer
     */
    @Override
    public void configureContentNegotiation(ContentNegotiationConfigurer configurer) {
        configurer
                .defaultContentType(org.springframework.http.MediaType.APPLICATION_JSON)
                .mediaType("json", org.springframework.http.MediaType.APPLICATION_JSON)
                .mediaType("xml", org.springframework.http.MediaType.APPLICATION_XML)
                .mediaType("html", org.springframework.http.MediaType.TEXT_HTML);

        // favorPathExtension đã deprecated - không sử dụng nữa
        // Spring Boot 3.x tự động handle content negotiation
    }

    /**
     * Cấu hình CORS cho REST API
     * @param registry CORS registry
     */
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOrigins("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .maxAge(3600);
    }

    /**
     * Cấu hình static resources
     * @param registry Resource handler registry
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/css/**")
                .addResourceLocations("classpath:/static/css/");

        registry.addResourceHandler("/js/**")
                .addResourceLocations("classpath:/static/js/");

        registry.addResourceHandler("/images/**")
                .addResourceLocations("classpath:/static/images/");

        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:uploads/");
    }

    /**
     * Cấu hình JSP view resolver
     * @param registry View resolver registry
     */
    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setViewClass(JstlView.class);
        resolver.setPrefix("/WEB-INF/views/");
        resolver.setSuffix(".jsp");
        resolver.setExposeContextBeansAsAttributes(true);

        registry.viewResolver(resolver);
    }
}