package com.coursemanagement;

import com.coursemanagement.entity.Category;
import com.coursemanagement.entity.User;
import com.coursemanagement.service.CategoryService;
import com.coursemanagement.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.LocalDateTime;
import java.util.TimeZone;


/**
 * Main class để khởi động ứng dụng Course Management System
 * Tự động tạo dữ liệu mặc định khi khởi động
 * SỬA LỖI CIRCULAR DEPENDENCY: Sử dụng @EventListener thay vì CommandLineRunner
 */
@SpringBootApplication
public class CourseManagementApplication {

    @Autowired
    private UserService userService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // ✅ THÊM UserRepository để delete trực tiếp nếu cần
    @Autowired
    private com.coursemanagement.repository.UserRepository userRepository;

    public static void main(String[] args) {
        SpringApplication.run(CourseManagementApplication.class, args);
    }

    /**
     * Cấu hình timezone cho ứng dụng
     */

    /**
     * Chạy sau khi application đã khởi động hoàn toàn
     * Sử dụng @EventListener để tránh circular dependency
     */
    @EventListener(ApplicationReadyEvent.class)
    public void initializeDefaultData() {
        System.out.println("🚀 Course Management System đang khởi động...");

        try {
            createDefaultAdminIfNotExists();
            createDefaultCategoriesIfNotExists();

            // 🔍 DEBUG: Test password
            testPasswordForDebug();

            System.out.println("✅ Khởi tạo dữ liệu mặc định hoàn tất!");
            System.out.println("📚 Hệ thống quản lý khóa học đã sẵn sàng!");
            System.out.println("🌐 Truy cập: http://localhost:8080");
            System.out.println("👤 Admin: admin / admin123");
        } catch (Exception e) {
            System.err.println("❌ Lỗi khi khởi tạo dữ liệu mặc định: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Debug method để test password matching
     */
    private void testPasswordForDebug() {
        try {
            System.out.println("🔍 Testing password matching...");

            var userOpt = userService.findByUsername("admin");
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                boolean matches = passwordEncoder.matches("admin123", user.getPassword());

                System.out.println("🔍 User found: " + user.getUsername());
                System.out.println("🔍 User role: " + user.getRole());
                System.out.println("🔍 User active: " + user.isActive());
                System.out.println("🔍 Encoded password: " + user.getPassword());
                System.out.println("🔍 Password matches 'admin123': " + matches);
                System.out.println("🔍 User authorities: " + user.getAuthorities());
                System.out.println("🔍 User account non-locked: " + user.isAccountNonLocked());
                System.out.println("🔍 User enabled: " + user.isEnabled());
            } else {
                System.out.println("❌ Admin user not found!");
            }
        } catch (Exception e) {
            System.err.println("❌ Error testing password: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Tạo admin mặc định nếu chưa tồn tại
     */
    private void createDefaultAdminIfNotExists() {
        try {
            System.out.println("Bắt đầu khởi tạo dữ liệu mẫu...");

            // ✅ FORCE RECREATE ADMIN với password mới
            var existingAdmin = userService.findByUsername("admin");
            if (existingAdmin.isPresent()) {
                System.out.println("🔄 Force updating admin password...");

                // Cập nhật password với encoder hiện tại
                User admin = existingAdmin.get();
                String newEncodedPassword = passwordEncoder.encode("admin123");
                admin.setPassword(newEncodedPassword);
                admin.setUpdatedAt(LocalDateTime.now());

                // Save directly to repository để bypass validation
                userService.save(admin);

                System.out.println("✅ Đã force update password cho admin");
                System.out.println("🔍 New encoded password: " + newEncodedPassword);
            } else {
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