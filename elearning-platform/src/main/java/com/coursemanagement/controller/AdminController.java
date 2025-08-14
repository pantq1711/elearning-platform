package com.coursemanagement.controller;

import com.coursemanagement.entity.*;
import com.coursemanagement.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.stream.Collectors;
import jakarta.validation.Valid;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Controller xử lý các chức năng dành cho Admin
 * Quản lý toàn bộ hệ thống: users, courses, categories, analytics
 * Chỉ cho phép user có role ADMIN truy cập
 */
@Controller
@RequestMapping("/admin")
@PreAuthorize("hasRole('ADMIN')")
public class    AdminController {

    @Autowired
    private UserService userService;

    @Autowired
    private CourseService courseService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private EnrollmentService enrollmentService;

    @Autowired
    private QuizService quizService;

    @Autowired
    private LessonService lessonService;

    /**
     * Dashboard chính của admin
     * Hiển thị thống kê tổng quan và các chỉ số quan trọng
     */
    @GetMapping("/dashboard")
    public String dashboard(Model model, Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            // Thống kê tổng quan
            Long totalUsers = userService.countAllUsers();
            Long totalCourses = courseService.countAllCourses();
            Long totalEnrollments = enrollmentService.countAllEnrollments();
            Long totalActiveUsers = userService.countActiveUsersInLastMonth();

            model.addAttribute("totalUsers", totalUsers);
            model.addAttribute("totalCourses", totalCourses);
            model.addAttribute("totalEnrollments", totalEnrollments);
            model.addAttribute("totalActiveUsers", totalActiveUsers);

            // Thống kê theo role
            model.addAttribute("totalStudents", userService.countUsersByRole(User.Role.STUDENT));
            model.addAttribute("totalInstructors", userService.countUsersByRole(User.Role.INSTRUCTOR));
            model.addAttribute("totalAdmins", userService.countUsersByRole(User.Role.ADMIN));

            // Thống kê khóa học
            model.addAttribute("activeCourses", courseService.countActiveCourses());
            model.addAttribute("featuredCourses", courseService.countFeaturedCourses());
            model.addAttribute("completedCourses", enrollmentService.countCompletedEnrollments());

            // Đăng ký gần đây
            List<Enrollment> recentEnrollments = enrollmentService.findRecentEnrollments(10);
            model.addAttribute("recentEnrollments", recentEnrollments);

            // Khóa học phổ biến
            List<Course> popularCourses = courseService.findMostPopularCourses(5);
            model.addAttribute("popularCourses", popularCourses);

            // Giảng viên hoạt động
            List<User> activeInstructors = userService.findActiveInstructors();
            model.addAttribute("activeInstructors", activeInstructors);

            // Thống kê theo tháng (cho biểu đồ)
            Map<String, Object> monthlyEnrollments = enrollmentService.getEnrollmentStatisticsByMonth();
            model.addAttribute("monthlyEnrollments", monthlyEnrollments);

            // Thống kê completion rate
            Double averageCompletionRate = enrollmentService.getAverageCompletionRate();
            model.addAttribute("averageCompletionRate", averageCompletionRate);

            return "admin/dashboard";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải dashboard: " + e.getMessage());
            return "admin/dashboard";
        }
    }

    /**
     * Quản lý người dùng
     */
    @GetMapping("/users")
    public String listUsers(@RequestParam(value = "page", defaultValue = "0") int page,
                            @RequestParam(value = "size", defaultValue = "20") int size,
                            @RequestParam(value = "search", required = false) String search,
                            @RequestParam(value = "role", required = false) String role,
                            @RequestParam(value = "status", required = false) String status,
                            Model model,
                            Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            // Tạo Pageable với sort theo ngày tạo
            Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());

            // Tìm kiếm users với filter
            Page<User> users = userService.findUsersWithFilter(search, role, status, pageable);

            model.addAttribute("users", users);
            model.addAttribute("search", search);
            model.addAttribute("selectedRole", role);
            model.addAttribute("selectedStatus", status);
            model.addAttribute("roles", User.Role.values());

            // Thống kê users
            model.addAttribute("totalUsers", userService.countAllUsers());
            model.addAttribute("activeUsers", userService.countActiveUsers());
            model.addAttribute("newUsersThisMonth", userService.countNewUsersThisMonth());

            return "admin/users";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải danh sách người dùng");
            return "admin/users";
        }
    }

    /**
     * Chi tiết người dùng
     */
    @GetMapping("/users/{id}")
    public String viewUser(@PathVariable Long id,
                           Model model,
                           Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            User user = userService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng"));

            model.addAttribute("user", user);

            // Thống kê chi tiết dựa vào role
            if (user.getRole() == User.Role.STUDENT) {
                // Thống kê học viên
                List<Enrollment> enrollments = enrollmentService.findEnrollmentsByStudent(user);
                model.addAttribute("enrollments", enrollments);
                model.addAttribute("totalEnrollments", enrollments.size());
                model.addAttribute("completedCourses",
                        enrollments.stream().mapToLong(e -> e.isCompleted() ? 1 : 0).sum());
            } else if (user.getRole() == User.Role.INSTRUCTOR) {
                // Thống kê giảng viên
                List<Course> courses = courseService.findCoursesByInstructor(user);
                model.addAttribute("courses", courses);
                model.addAttribute("totalCourses", courses.size());
                model.addAttribute("totalStudents",
                        enrollmentService.countStudentsByInstructor(user));
            }

            // Login history (nếu có)
            model.addAttribute("lastLogin", user.getLastLogin());
            model.addAttribute("memberSince", user.getCreatedAt());

            return "admin/user-detail";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải thông tin người dùng");
            return "redirect:/admin/users";
        }
    }

    /**
     * Kích hoạt/vô hiệu hóa người dùng
     */
    @PostMapping("/users/{id}/toggle-status")
    public String toggleUserStatus(@PathVariable Long id,
                                   RedirectAttributes redirectAttributes,
                                   Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();

            // Không cho phép tự vô hiệu hóa chính mình
            if (currentUser.getId().equals(id)) {
                redirectAttributes.addFlashAttribute("error",
                        "Bạn không thể thay đổi trạng thái của chính mình!");
                return "redirect:/admin/users/" + id;
            }

            User user = userService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng"));

            boolean newStatus = !user.isActive();
            userService.updateUserStatus(id, newStatus);

            String statusText = newStatus ? "kích hoạt" : "vô hiệu hóa";
            redirectAttributes.addFlashAttribute("message",
                    "Đã " + statusText + " người dùng: " + user.getFullName());

            return "redirect:/admin/users/" + id;

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Có lỗi xảy ra khi thay đổi trạng thái người dùng: " + e.getMessage());
            return "redirect:/admin/users";
        }
    }

    /**
     * Thay đổi role của người dùng
     */
    @PostMapping("/users/{id}/change-role")
    public String changeUserRole(@PathVariable Long id,
                                 @RequestParam("newRole") String newRole,
                                 RedirectAttributes redirectAttributes,
                                 Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();

            // Không cho phép thay đổi role của chính mình
            if (currentUser.getId().equals(id)) {
                redirectAttributes.addFlashAttribute("error",
                        "Bạn không thể thay đổi role của chính mình!");
                return "redirect:/admin/users/" + id;
            }

            User user = userService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng"));

            User.Role role = User.Role.valueOf(newRole);
            userService.updateUserRole(id, role);

            redirectAttributes.addFlashAttribute("message",
                    "Đã thay đổi role của " + user.getFullName() + " thành " + role.toString());

            return "redirect:/admin/users/" + id;

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Có lỗi xảy ra khi thay đổi role: " + e.getMessage());
            return "redirect:/admin/users";
        }
    }

    /**
     * Quản lý danh mục khóa học
     */
    @GetMapping("/categories")
    public String listCategories(Model model, Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            List<Category> categories = categoryService.findAllOrderByName();
            model.addAttribute("categories", categories);

            // Thống kê categories
            model.addAttribute("totalCategories", categories.size());
            model.addAttribute("featuredCategories",
                    categories.stream().mapToLong(c -> c.isFeatured() ? 1 : 0).sum());

            // Category mới cho form
            model.addAttribute("newCategory", new Category());

            return "admin/categories";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải danh sách danh mục");
            return "admin/categories";
        }
    }

    /**
     * Tạo danh mục mới
     */
    @PostMapping("/categories")
    public String createCategory(@Valid @ModelAttribute("newCategory") Category category,
                                 BindingResult result,
                                 RedirectAttributes redirectAttributes,
                                 Model model,
                                 Authentication authentication) {
        try {
            if (result.hasErrors()) {
                User currentUser = (User) authentication.getPrincipal();
                model.addAttribute("currentUser", currentUser);
                model.addAttribute("categories", categoryService.findAllOrderByName());
                return "admin/categories";
            }

            Category createdCategory = categoryService.createCategory(category);

            redirectAttributes.addFlashAttribute("message",
                    "Tạo danh mục thành công: " + createdCategory.getName());

            return "redirect:/admin/categories";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Có lỗi xảy ra khi tạo danh mục: " + e.getMessage());
            return "redirect:/admin/categories";
        }
    }

    /**
     * Cập nhật danh mục
     */
    @PostMapping("/categories/{id}")
    public String updateCategory(@PathVariable Long id,
                                 @Valid @ModelAttribute Category category,
                                 BindingResult result,
                                 RedirectAttributes redirectAttributes) {
        try {
            if (result.hasErrors()) {
                redirectAttributes.addFlashAttribute("error",
                        "Dữ liệu không hợp lệ. Vui lòng kiểm tra lại.");
                return "redirect:/admin/categories";
            }

            category.setId(id);
            Category updatedCategory = categoryService.updateCategory(category);

            redirectAttributes.addFlashAttribute("message",
                    "Cập nhật danh mục thành công: " + updatedCategory.getName());

            return "redirect:/admin/categories";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Có lỗi xảy ra khi cập nhật danh mục: " + e.getMessage());
            return "redirect:/admin/categories";
        }
    }

    /**
     * Xóa danh mục
     */
    @PostMapping("/categories/{id}/delete")
    public String deleteCategory(@PathVariable Long id,
                                 RedirectAttributes redirectAttributes) {
        try {
            Category category = categoryService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy danh mục"));

            // Kiểm tra xem có khóa học nào đang sử dụng category này không
            Long courseCount = courseService.countCoursesByCategory(category);
            if (courseCount > 0) {
                redirectAttributes.addFlashAttribute("error",
                        "Không thể xóa danh mục đang có " + courseCount + " khóa học. " +
                                "Vui lòng di chuyển các khóa học trước khi xóa.");
                return "redirect:/admin/categories";
            }

            categoryService.deleteCategory(id);

            redirectAttributes.addFlashAttribute("message",
                    "Đã xóa danh mục: " + category.getName());

            return "redirect:/admin/categories";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Có lỗi xảy ra khi xóa danh mục: " + e.getMessage());
            return "redirect:/admin/categories";
        }
    }

    /**
     * Quản lý khóa học
     */
    @GetMapping("/courses")
    public String listCourses(@RequestParam(value = "page", defaultValue = "0") int page,
                              @RequestParam(value = "size", defaultValue = "20") int size,
                              @RequestParam(value = "search", required = false) String search,
                              @RequestParam(value = "category", required = false) Long categoryId,
                              @RequestParam(value = "status", required = false) String status,
                              Model model,
                              Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            // Tạo Pageable
            Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());

            // Tìm kiếm courses với filter
            Page<Course> courses = courseService.findCoursesWithFilter(search, categoryId, status, pageable);

            model.addAttribute("courses", courses);
            model.addAttribute("search", search);
            model.addAttribute("selectedCategory", categoryId);
            model.addAttribute("selectedStatus", status);
            model.addAttribute("categories", categoryService.findAllOrderByName());
            model.addAttribute("instructors", userService.findActiveInstructors());

            // Thống kê khóa học
            model.addAttribute("totalCourses", courseService.countAllCourses());
            model.addAttribute("activeCourses", courseService.countActiveCourses());
            model.addAttribute("featuredCourses", courseService.countFeaturedCourses());

            return "admin/courses";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải danh sách khóa học");
            return "admin/courses";
        }
    }

    /**
     * Chi tiết khóa học (cho admin xem)
     */
    @GetMapping("/courses/{id}")
    public String viewCourse(@PathVariable Long id,
                             Model model,
                             Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            Course course = courseService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học"));

            model.addAttribute("course", course);

            // Thống kê khóa học chi tiết
            Long enrollmentCount = enrollmentService.countByCourse(course);
            Long lessonCount = lessonService.countByCourse(course);
            Long quizCount = quizService.countByCourse(course);
            Double averageRating = courseService.getAverageRating(course);
            Double completionRate = enrollmentService.getAverageCompletionRate();

            model.addAttribute("enrollmentCount", enrollmentCount);
            model.addAttribute("lessonCount", lessonCount);
            model.addAttribute("quizCount", quizCount);
            model.addAttribute("averageRating", averageRating);
            model.addAttribute("completionRate", completionRate);

            // Học viên gần đây
            List<Enrollment> recentEnrollments = enrollmentService.findRecentEnrollments(10);
            model.addAttribute("recentEnrollments", recentEnrollments);

            // SỬA LỖI: Sử dụng đúng method signature với Pageable
            Pageable pageable = PageRequest.of(0, 5);
            List<Enrollment> topStudents = enrollmentService.getTopStudentsByCourse(course, pageable);
            model.addAttribute("topStudents", topStudents);

            // Bài giảng của khóa học
            List<Lesson> lessons = lessonService.findByCourseOrderByOrderIndex(course);
            model.addAttribute("lessons", lessons);

            return "admin/course-detail";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải thông tin khóa học");
            return "redirect:/admin/courses";
        }
    }

    /**
     * Toggle featured status cho khóa học
     */
    @PostMapping("/courses/{id}/toggle-featured")
    public String toggleCourseFeatured(@PathVariable Long id,
                                       RedirectAttributes redirectAttributes) {
        try {
            Course course = courseService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học"));

            boolean newFeaturedStatus = !course.isFeatured();
            courseService.updateFeaturedStatus(id, newFeaturedStatus);

            String statusText = newFeaturedStatus ? "đánh dấu nổi bật" : "bỏ đánh dấu nổi bật";
            redirectAttributes.addFlashAttribute("message",
                    "Đã " + statusText + " khóa học: " + course.getName());

            return "redirect:/admin/courses/" + id;

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Có lỗi xảy ra khi thay đổi trạng thái featured: " + e.getMessage());
            return "redirect:/admin/courses";
        }
    }

    /**
     * Báo cáo và thống kê
     */
    @GetMapping("/reports")
    public String reports(Model model, Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            // Thống kê tổng quan theo thời gian
            Map<String, Object> monthlyStats = enrollmentService.getEnrollmentStatisticsByMonth();
            model.addAttribute("monthlyStats", monthlyStats);

            // Top performing courses
            List<Course> topCourses = courseService.getTopPerformingCourses(10);
            model.addAttribute("topCourses", topCourses);

            // Top instructors
            List<User> topInstructors = userService.getTopInstructorsByEnrollments(10);
            model.addAttribute("topInstructors", topInstructors);

            // Category performance
            Map<String, Long> categoryStats = courseService.getCategoryPerformanceStats();
            model.addAttribute("categoryStats", categoryStats);

            // User growth
            Map<String, Long> userGrowthStats = userService.getUserGrowthStats();
            model.addAttribute("userGrowthStats", userGrowthStats);

            return "admin/reports";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải báo cáo: " + e.getMessage());
            return "admin/reports";
        }
    }

    /**
     * Cài đặt hệ thống
     */
    @GetMapping("/settings")
    public String settings(Model model, Authentication authentication) {
        User currentUser = (User) authentication.getPrincipal();
        model.addAttribute("currentUser", currentUser);

        // Load system settings
        // Có thể implement SystemSettingsService để quản lý cài đặt

        return "admin/settings";
    }

    /**
     * Exception handler cho controller này
     */
    @ExceptionHandler(Exception.class)
    public String handleException(Exception e, Model model, Authentication authentication) {
        System.err.println("Lỗi trong AdminController: " + e.getMessage());
        e.printStackTrace();

        if (authentication != null) {
            model.addAttribute("currentUser", (User) authentication.getPrincipal());
        }
        model.addAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        return "error/500";
    }
}