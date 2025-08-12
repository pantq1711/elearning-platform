package com.coursemanagement;

import com.coursemanagement.service.UserService;
import com.coursemanagement.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

/**
 * Main class để khởi chạy ứng dụng Spring Boot
 * Tự động tạo dữ liệu mặc định khi khởi động lần đầu
 */
@SpringBootApplication
public class CourseManagementApplication {

    @Autowired
    private UserService userService;

    @Autowired
    private CategoryService categoryService;

    /**
     * Main method để khởi chạy ứng dụng
     */
    public static void main(String[] args) {
        try {
            SpringApplication.run(CourseManagementApplication.class, args);
            System.out.println("\n" +
                    "╔══════════════════════════════════════════════════════════════╗\n" +
                    "║          🎓 HỆ THỐNG QUẢN LÝ KHÓA HỌC KHỞI ĐỘNG THÀNH CÔNG   ║\n" +
                    "╠══════════════════════════════════════════════════════════════╣\n" +
                    "║  📋 Ứng dụng đang chạy tại: http://localhost:8080            ║\n" +
                    "║  👤 Tài khoản admin mặc định:                                ║\n" +
                    "║     Username: admin                                          ║\n" +
                    "║     Password: admin123                                       ║\n" +
                    "║                                                              ║\n" +
                    "║  🚀 Chúc bạn sử dụng ứng dụng hiệu quả!                     ║\n" +
                    "╚══════════════════════════════════════════════════════════════╝\n"
            );
        } catch (Exception e) {
            System.err.println("❌ Lỗi khởi động ứng dụng: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * CommandLineRunner để khởi tạo dữ liệu mặc định
     * Chạy sau khi ứng dụng Spring Boot khởi động hoàn tất
     */
    @Bean
    public CommandLineRunner initializeDefaultData() {
        return args -> {
            try {
                System.out.println("🔄 Đang khởi tạo dữ liệu mặc định...");

                // Tạo tài khoản admin mặc định nếu chưa có
                userService.createDefaultAdminIfNotExists();

                // Tạo các danh mục mặc định nếu chưa có
                categoryService.createDefaultCategoriesIfNotExists();

                System.out.println("✅ Khởi tạo dữ liệu mặc định hoàn tất!");

            } catch (Exception e) {
                System.err.println("❌ Lỗi khởi tạo dữ liệu mặc định: " + e.getMessage());
                // Không throw exception để không crash ứng dụng
            }
        };
    }
}