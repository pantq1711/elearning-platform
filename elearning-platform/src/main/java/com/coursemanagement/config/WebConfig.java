package com.coursemanagement.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;

/**
 * Cấu hình Web MVC cho ứng dụng
 * Thiết lập view resolver, static resources, và view controllers
 */
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    /**
     * Cấu hình JSP View Resolver
     * Xác định cách tìm và render các file JSP
     * @return ViewResolver cho JSP
     */
    @Bean
    public ViewResolver viewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();

        // Thiết lập prefix - đường dẫn đến thư mục chứa JSP files
        resolver.setPrefix("/WEB-INF/views/");

        // Thiết lập suffix - phần mở rộng file
        resolver.setSuffix(".jsp");

        // Sử dụng JSTL view để hỗ trợ JSTL tags
        resolver.setViewClass(JstlView.class);

        // Thiết lập order - độ ưu tiên của resolver này
        resolver.setOrder(1);

        return resolver;
    }

    /**
     * Cấu hình static resource handlers
     * Xác định cách serve static files (CSS, JS, images...)
     * @param registry ResourceHandlerRegistry
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Cấu hình cho CSS files
        registry.addResourceHandler("/css/**")
                .addResourceLocations("classpath:/static/css/")
                .setCachePeriod(3600); // Cache 1 giờ

        // Cấu hình cho JavaScript files
        registry.addResourceHandler("/js/**")
                .addResourceLocations("classpath:/static/js/")
                .setCachePeriod(3600);

        // Cấu hình cho Images
        registry.addResourceHandler("/images/**")
                .addResourceLocations("classpath:/static/images/")
                .setCachePeriod(86400); // Cache 1 ngày

        // Cấu hình cho WebJars (Bootstrap, jQuery từ Maven)
        registry.addResourceHandler("/webjars/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/")
                .setCachePeriod(86400);

        // Cấu hình cho favicon
        registry.addResourceHandler("/favicon.ico")
                .addResourceLocations("classpath:/static/")
                .setCachePeriod(86400);

        // Cấu hình cho fonts
        registry.addResourceHandler("/fonts/**")
                .addResourceLocations("classpath:/static/fonts/")
                .setCachePeriod(86400);
    }

    /**
     * Cấu hình view controllers
     * Định nghĩa các route đơn giản không cần logic phức tạp
     * @param registry ViewControllerRegistry
     */
    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        // Trang chủ
        registry.addViewController("/").setViewName("home");

        // Trang đăng nhập
        registry.addViewController("/login").setViewName("login");

        // Trang đăng ký (nếu có)
        registry.addViewController("/register").setViewName("register");

        // Trang lỗi truy cập bị từ chối
        registry.addViewController("/access-denied").setViewName("error/access-denied");

        // Trang lỗi 404
        registry.addViewController("/404").setViewName("error/404");

        // Trang lỗi 500
        registry.addViewController("/500").setViewName("error/500");
    }
}