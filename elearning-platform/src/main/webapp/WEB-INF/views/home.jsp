package com.coursemanagement.config;

import org.springframework.context.annotation.Bean;
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
* ✅ SỬA LỖI: Web MVC Configuration cho ứng dụng Course Management
* Đã sửa view resolver configuration để tránh conflict
*/
@Configuration
public class WebConfig implements WebMvcConfigurer {

/**
* Cấu hình path matching
*/
@Override
public void configurePathMatch(PathMatchConfigurer configurer) {
configurer.setUseTrailingSlashMatch(true);
}

/**
* Cấu hình content negotiation
*/
@Override
public void configureContentNegotiation(ContentNegotiationConfigurer configurer) {
configurer
.defaultContentType(org.springframework.http.MediaType.TEXT_HTML)
.mediaType("json", org.springframework.http.MediaType.APPLICATION_JSON)
.mediaType("xml", org.springframework.http.MediaType.APPLICATION_XML)
.mediaType("html", org.springframework.http.MediaType.TEXT_HTML);
}

/**
* Cấu hình CORS cho REST API
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
*/
@Override
public void addResourceHandlers(ResourceHandlerRegistry registry) {
// CSS resources
registry.addResourceHandler("/css/**")
.addResourceLocations("classpath:/static/css/")
.setCachePeriod(3600);

// JavaScript resources
registry.addResourceHandler("/js/**")
.addResourceLocations("classpath:/static/js/")
.setCachePeriod(3600);

// Image resources
registry.addResourceHandler("/images/**")
.addResourceLocations("classpath:/static/images/")
.setCachePeriod(3600);

// Font resources
registry.addResourceHandler("/fonts/**")
.addResourceLocations("classpath:/static/fonts/")
.setCachePeriod(3600);

// File uploads
registry.addResourceHandler("/uploads/**")
.addResourceLocations("file:uploads/");

// Webjars (Bootstrap, jQuery, etc.)
registry.addResourceHandler("/webjars/**")
.addResourceLocations("classpath:/META-INF/resources/webjars/")
.setCachePeriod(3600);
}

/**
* ✅ SỬA LỖI: Chỉ sử dụng 1 method để cấu hình view resolver
* Bỏ @Bean method để tránh conflict
*/
@Override
public void configureViewResolvers(ViewResolverRegistry registry) {
InternalResourceViewResolver resolver = new InternalResourceViewResolver();
resolver.setViewClass(JstlView.class);
resolver.setPrefix("/WEB-INF/views/");
resolver.setSuffix(".jsp");
resolver.setExposeContextBeansAsAttributes(true);
resolver.setExposeSessionAttributes(true);
resolver.setExposeRequestAttributes(true);
resolver.setOrder(1);

registry.viewResolver(resolver);

System.out.println("✅ JSP View Resolver configured: /WEB-INF/views/*.jsp");
}
}