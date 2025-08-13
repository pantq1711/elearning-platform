package com.coursemanagement;

import com.coursemanagement.entity.Category;
import com.coursemanagement.entity.User;
import com.coursemanagement.service.CategoryService;
import com.coursemanagement.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.security.crypto.password.PasswordEncoder;

/**
 * Main class để khởi động ứng dụng Course Management System
 * Tự động tạo dữ liệu mặc định khi khởi động
 */
@SpringBootApplication
public class CourseManagementApplication implements CommandLineRunner {

    @Autowired
    private UserService userService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private PasswordEncoder passwordEncoder;

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

        createDefaultAdminIfNotExists();
        createDefaultCategoriesIfNotExists();

        System.out.println("✅ Khởi tạo dữ liệu mặc định hoàn tất!");
    }

    /**
     * Tạo admin user mặc định nếu chưa tồn tại
     */
    private void createDefaultAdminIfNotExists() {
        try {
            // Kiểm tra xem đã có admin chưa
            if (userService.countByRole(User.Role.ADMIN) == 0) {
                System.out.println("📝 Tạo admin user mặc định...");

                User admin = new User();
                admin.setUsername("admin");
                admin.setEmail("admin@coursemanagement.com");
                admin.setFullName("Administrator");
                admin.setPassword("admin123"); // Will be encoded
                admin.setRole(User.Role.ADMIN);
                admin.setActive(true);
                admin.setBio("Administrator của hệ thống Course Management");

                userService.registerUser(admin);
                System.out.println("✅ Đã tạo admin user: admin/admin123");
            }

            // Tạo instructor demo nếu chưa có
            if (userService.countByRole(User.Role.INSTRUCTOR) == 0) {
                System.out.println("📝 Tạo instructor demo...");

                User instructor = new User();
                instructor.setUsername("instructor");
                instructor.setEmail("instructor@coursemanagement.com");
                instructor.setFullName("Giảng viên Demo");
                instructor.setPassword("instructor123");
                instructor.setRole(User.Role.INSTRUCTOR);
                instructor.setActive(true);
                instructor.setBio("Giảng viên demo của hệ thống");

                userService.registerUser(instructor);
                System.out.println("✅ Đã tạo instructor user: instructor/instructor123");
            }

            // Tạo student demo nếu chưa có
            if (userService.countByRole(User.Role.STUDENT) == 0) {
                System.out.println("📝 Tạo student demo...");

                User student = new User();
                student.setUsername("student");
                student.setEmail("student@coursemanagement.com");
                student.setFullName("Học viên Demo");
                student.setPassword("student123");
                student.setRole(User.Role.STUDENT);
                student.setActive(true);
                student.setBio("Học viên demo của hệ thống");

                userService.registerUser(student);
                System.out.println("✅ Đã tạo student user: student/student123");
            }

        } catch (Exception e) {
            System.err.println("❌ Lỗi tạo default users: " + e.getMessage());
        }
    }

    /**
     * Tạo các category mặc định nếu chưa tồn tại
     */
    private void createDefaultCategoriesIfNotExists() {
        try {
            if (categoryService.countAllCategories() == 0) {
                System.out.println("📝 Tạo categories mặc định...");

                // Danh sách categories mặc định
                String[][] defaultCategories = {
                        {"Lập trình", "Các khóa học về lập trình và phát triển phần mềm"},
                        {"Thiết kế", "Các khóa học về thiết kế đồ họa và UI/UX"},
                        {"Marketing", "Các khóa học về marketing và kinh doanh"},
                        {"Ngoại ngữ", "Các khóa học ngoại ngữ"},
                        {"Công nghệ thông tin", "Các khóa học về IT và công nghệ"},
                        {"Kỹ năng mềm", "Các khóa học phát triển kỹ năng cá nhân"},
                        {"Khoa học dữ liệu", "Các khóa học về Data Science và AI"},
                        {"Nhiếp ảnh", "Các khóa học về nhiếp ảnh và quay phim"}
                };

                for (String[] categoryData : defaultCategories) {
                    Category category = new Category();
                    category.setName(categoryData[0]);
                    category.setDescription(categoryData[1]);

                    // Set featured cho một số category
                    category.setFeatured(categoryData[0].equals("Lập trình") ||
                            categoryData[0].equals("Thiết kế") ||
                            categoryData[0].equals("Khoa học dữ liệu"));

                    categoryService.createCategory(category);
                    System.out.println("✅ Đã tạo category: " + categoryData[0]);
                }

                System.out.println("✅ Đã tạo " + defaultCategories.length + " categories mặc định");
            }

        } catch (Exception e) {
            System.err.println("❌ Lỗi tạo default categories: " + e.getMessage());
        }
    }
}