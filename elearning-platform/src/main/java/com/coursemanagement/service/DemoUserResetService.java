// File: src/main/java/com/coursemanagement/service/DemoUserResetService.java

package com.coursemanagement.service;

import com.coursemanagement.entity.User;
import com.coursemanagement.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.PostConstruct;
import java.time.LocalDateTime;
import java.util.Optional;

/**
 * Service để reset password cho demo users
 * Giải quyết lỗi "password does not match stored value"
 */
@Service
@Transactional
public class DemoUserResetService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    /**
     * Reset tất cả demo users với password mới
     * Chạy sau DataInitializationService
     */
    @PostConstruct
    public void resetDemoPasswords() {
        try {
            System.out.println("🔄 Bắt đầu reset password cho demo users...");

            // Reset Admin
            resetUserPassword("admin", "admin123", "Quản trị viên hệ thống", "admin@elearning.vn", User.Role.ADMIN);

            // Reset Instructors  
            resetUserPassword("instructor1", "instructor123", "Nguyễn Văn An", "instructor1@elearning.vn", User.Role.INSTRUCTOR);
            resetUserPassword("instructor2", "instructor123", "Trần Thị Bình", "instructor2@elearning.vn", User.Role.INSTRUCTOR);

            // Reset Students
            resetUserPassword("student1", "student123", "Nguyễn Minh Tuấn", "student1@gmail.com", User.Role.STUDENT);
            resetUserPassword("student2", "student123", "Trần Thị Hoa", "student2@gmail.com", User.Role.STUDENT);

            System.out.println("✅ Reset password demo users hoàn thành!");

            // Test ngay
            testDemoLogin();

        } catch (Exception e) {
            System.err.println("❌ Lỗi reset demo passwords: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Reset password cho một user cụ thể
     */
    private void resetUserPassword(String username, String plainPassword, String fullName, String email, User.Role role) {
        try {
            Optional<User> userOpt = userRepository.findByUsername(username);

            if (userOpt.isPresent()) {
                // Update existing user
                User user = userOpt.get();
                String newHashedPassword = passwordEncoder.encode(plainPassword);

                user.setPassword(newHashedPassword);
                user.setActive(true);
                user.setUpdatedAt(LocalDateTime.now());

                userRepository.save(user);
                System.out.println("🔄 Updated user: " + username);

            } else {
                // Create new user
                User newUser = new User();
                newUser.setUsername(username);
                newUser.setPassword(passwordEncoder.encode(plainPassword));
                newUser.setFullName(fullName);
                newUser.setEmail(email);
                newUser.setRole(role);
                newUser.setActive(true);
                newUser.setCreatedAt(LocalDateTime.now());
                newUser.setUpdatedAt(LocalDateTime.now());

                userRepository.save(newUser);
                System.out.println("✅ Created user: " + username);
            }

        } catch (Exception e) {
            System.err.println("❌ Lỗi reset user " + username + ": " + e.getMessage());
        }
    }

    /**
     * Test login ngay sau khi reset
     */
    private void testDemoLogin() {
        System.out.println("\n🧪 Testing demo login credentials...");

        String[] demoUsers = {"admin", "instructor1", "student1"};
        String[] demoPasswords = {"admin123", "instructor123", "student123"};

        for (int i = 0; i < demoUsers.length; i++) {
            try {
                Optional<User> userOpt = userRepository.findByUsername(demoUsers[i]);
                if (userOpt.isPresent()) {
                    User user = userOpt.get();
                    boolean matches = passwordEncoder.matches(demoPasswords[i], user.getPassword());

                    System.out.println("🔍 " + demoUsers[i] + " / " + demoPasswords[i] + " -> " +
                            (matches ? "✅ OK" : "❌ FAIL"));

                    if (!matches) {
                        System.out.println("   Stored: " + user.getPassword());
                        System.out.println("   Active: " + user.isActive());
                        System.out.println("   Role: " + user.getRole());
                    }
                } else {
                    System.out.println("❌ User not found: " + demoUsers[i]);
                }
            } catch (Exception e) {
                System.err.println("❌ Test error for " + demoUsers[i] + ": " + e.getMessage());
            }
        }

        System.out.println("\n📋 Demo Credentials:");
        System.out.println("👤 Admin: admin / admin123");
        System.out.println("🎓 Instructor: instructor1 / instructor123");
        System.out.println("📚 Student: student1 / student123");
        System.out.println("🌐 Login: http://localhost:8080/login");
    }

    /**
     * Utility method để manually reset từ controller nếu cần
     */
    public void manualReset() {
        resetDemoPasswords();
    }
}

/*
 * HƯỚNG DẪN SỬ DỤNG:
 *
 * 1. Service này tự động chạy sau khi app start
 * 2. Nó sẽ reset password cho tất cả demo users
 * 3. Test ngay và hiển thị kết quả
 *
 * Nếu vẫn lỗi, có thể gọi manual:
 * - Inject DemoUserResetService vào controller
 * - Call demoUserResetService.manualReset()
 */