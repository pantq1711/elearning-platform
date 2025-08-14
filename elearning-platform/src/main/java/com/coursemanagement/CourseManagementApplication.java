package com.coursemanagement;

import com.coursemanagement.entity.Category;
import com.coursemanagement.entity.User;
import com.coursemanagement.service.CategoryService;
import com.coursemanagement.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.LocalDateTime;

/**
 * Main class để khởi động ứng dụng Course Management System
 * Tự động tạo dữ liệu mặc định khi khởi động
 * SỬA LỖI CIRCULAR DEPENDENCY: Sử dụng ApplicationContext thay vì direct injection
 */
@SpringBootApplication
public class CourseManagementApplication implements CommandLineRunner {

    // SỬA LỖI: Sử dụng ApplicationContext để tránh circular dependency
    @Autowired
    private ApplicationContext applicationContext;

    public static void main(String[] args) {
        SpringApplication.run(CourseManagementApplication.class, args);
    }

    /**
     * Chạy các initialization tasks sau khi application start
     * @param args Command line arguments
     * @throws Exception Nếu có lỗi initialization
     */
    @Override
    public void run(String... args) throws Exception {
        System.out.println("🚀 Course Management System đang khởi động...");

        // ✅ Lấy beans từ ApplicationContext khi cần
        createDefaultAdminIfNotExists();
        createDefaultCategoriesIfNotExists();

        System.out.println("✅ Khởi tạo dữ liệu mặc định hoàn tất!");
        System.out.println("📚 Hệ thống quản lý khóa học đã sẵn sàng!");
        System.out.println("🌐 Truy cập: http://localhost:8080");
        System.out.println("👤 Admin: admin / admin123");
    }

    /**
     * Tạo admin mặc định nếu chưa tồn tại
     */
    private void createDefaultAdminIfNotExists() {
        try {
            // ✅ Lấy UserService từ ApplicationContext
            UserService userService = applicationContext.getBean(UserService.class);
            PasswordEncoder passwordEncoder = applicationContext.getBean(PasswordEncoder.class);

            // Kiểm tra xem đã có admin chưa
            if (userService.findByUsername("admin").isEmpty()) {
                System.out.println("📝 Tạo admin mặc định...");

                User admin = new User();
                admin.setUsername("admin");
                admin.setEmail("admin@coursemanagement.com");
                admin.setFullName("System Administrator");
                admin.setPassword(passwordEncoder.encode("admin123"));
                admin.setRole(User.Role.ADMIN);
                admin.setActive(true);
                admin.setCreatedAt(LocalDateTime.now());
                admin.setUpdatedAt(LocalDateTime.now());

                userService.createUser(admin);
                System.out.println("✅ Đã tạo admin mặc định: admin / admin123");
            } else {
                System.out.println("ℹ️ Admin đã tồn tại, bỏ qua việc tạo mới");
            }
        } catch (Exception e) {
            System.err.println("❌ Lỗi khi tạo admin mặc định: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Tạo categories mặc định nếu chưa tồn tại
     */
    private void createDefaultCategoriesIfNotExists() {
        try {
            // ✅ Lấy CategoryService từ ApplicationContext
            CategoryService categoryService = applicationContext.getBean(CategoryService.class);

            // Kiểm tra xem đã có categories chưa
            if (categoryService.countAll() == 0) {
                System.out.println("📝 Tạo categories mặc định...");

                // Tạo các categories mặc định
                String[] categoryNames = {
                        "Lập trình", "Thiết kế", "Kinh doanh", "Marketing",
                        "Ngôn ngữ", "Khoa học", "Toán học", "Nghệ thuật"
                };

                String[] categorySlugs = {
                        "lap-trinh", "thiet-ke", "kinh-doanh", "marketing",
                        "ngon-ngu", "khoa-hoc", "toan-hoc", "nghe-thuat"
                };

                String[] categoryDescriptions = {
                        "Các khóa học về lập trình và phát triển phần mềm",
                        "Thiết kế đồ họa, UI/UX và thiết kế web",
                        "Quản trị kinh doanh và khởi nghiệp",
                        "Digital marketing và quảng cáo",
                        "Học ngoại ngữ và giao tiếp",
                        "Khoa học tự nhiên và công nghệ",
                        "Toán học và thống kê",
                        "Nghệ thuật và sáng tạo"
                };

                for (int i = 0; i < categoryNames.length; i++) {
                    Category category = new Category();
                    category.setName(categoryNames[i]);
                    category.setSlug(categorySlugs[i]);
                    category.setDescription(categoryDescriptions[i]);
                    category.setActive(true);
                    category.setCreatedAt(LocalDateTime.now());
                    category.setUpdatedAt(LocalDateTime.now());

                    categoryService.createCategory(category);
                }

                System.out.println("✅ Đã tạo " + categoryNames.length + " categories mặc định");
            } else {
                System.out.println("ℹ️ Categories đã tồn tại, bỏ qua việc tạo mới");
            }
        } catch (Exception e) {
            System.err.println("❌ Lỗi khi tạo categories mặc định: " + e.getMessage());
            e.printStackTrace();
        }
    }
}