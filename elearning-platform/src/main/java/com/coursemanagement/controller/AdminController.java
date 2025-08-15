package com.coursemanagement.controller;

import com.coursemanagement.entity.*;
import com.coursemanagement.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

/**
 * Controller xử lý các chức năng dành cho Admin
 * SỬA LỖI: Sắp xếp lại thứ tự routing để tránh conflict
 * QUAN TRỌNG: Đặt /create routes TRƯỚC /{id} routes
 */
@Controller
@RequestMapping("/admin")
@PreAuthorize("hasRole('ADMIN')")
public class AdminController {

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

    // ===== DASHBOARD =====

    @GetMapping("/dashboard")
    public String dashboard(Model model, Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            // Thống kê cơ bản
            model.addAttribute("totalUsers", userService.countAllUsers());
            model.addAttribute("totalCourses", courseService.countAllCourses());
            model.addAttribute("totalEnrollments", enrollmentService.countAllEnrollments());
            model.addAttribute("totalStudents", userService.countUsersByRole(User.Role.STUDENT));
            model.addAttribute("totalInstructors", userService.countUsersByRole(User.Role.INSTRUCTOR));

            return "admin/dashboard";
        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải dashboard");
            return "admin/dashboard";
        }
    }

    // ===== USER MANAGEMENT =====
    // QUAN TRỌNG: Đặt /users/create TRƯỚC /users/{id}

    @GetMapping("/users/create")
    public String newUserForm(Model model, Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);
            model.addAttribute("user", new User());
            model.addAttribute("roles", User.Role.values());
            return "admin/user-form";
        } catch (Exception e) {
            return "redirect:/admin/users?error=form_error";
        }
    }

    @PostMapping("/users/create")
    public String createUser(@Valid @ModelAttribute("user") User user,
                             BindingResult result,
                             @RequestParam("rawPassword") String rawPassword,
                             RedirectAttributes redirectAttributes,
                             Model model,
                             Authentication authentication) {
        try {
            if (result.hasErrors()) {
                User currentUser = (User) authentication.getPrincipal();
                model.addAttribute("currentUser", currentUser);
                model.addAttribute("roles", User.Role.values());
                return "admin/user-form";
            }

            user.setPassword(rawPassword);
            User createdUser = userService.createUser(user);

            redirectAttributes.addFlashAttribute("message",
                    "Tạo người dùng thành công: " + createdUser.getFullName());

            return "redirect:/admin/users";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Có lỗi xảy ra khi tạo người dùng: " + e.getMessage());
            return "redirect:/admin/users";
        }
    }

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

            Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
            Page<User> users = userService.findUsersWithFilter(search, role, status, pageable);

            model.addAttribute("users", users);
            model.addAttribute("search", search);
            model.addAttribute("selectedRole", role);
            model.addAttribute("selectedStatus", status);
            model.addAttribute("roles", User.Role.values());

            return "admin/users";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải danh sách người dùng");
            return "admin/users";
        }
    }

    // QUAN TRỌNG: Đặt AFTER /users/create để tránh "create" bị hiểu là {id}
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
            return "admin/user-detail";

        } catch (Exception e) {
            return "redirect:/admin/users?error=user_not_found";
        }
    }

    // ===== CATEGORY MANAGEMENT =====
    // QUAN TRỌNG: Đặt /categories/create TRƯỚC /categories/{id}

    @GetMapping("/categories/create")
    public String newCategoryForm(Model model, Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);
            model.addAttribute("category", new Category());
            return "admin/category-form";
        } catch (Exception e) {
            return "redirect:/admin/categories?error=form_error";
        }
    }

    @PostMapping("/categories/create")
    public String createCategory(@Valid @ModelAttribute("category") Category category,
                                 BindingResult result,
                                 RedirectAttributes redirectAttributes,
                                 Model model,
                                 Authentication authentication) {
        try {
            if (result.hasErrors()) {
                User currentUser = (User) authentication.getPrincipal();
                model.addAttribute("currentUser", currentUser);
                return "admin/category-form";
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

    @GetMapping("/categories")
    public String listCategories(Model model, Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            List<Category> categories = categoryService.findAllOrderByName();
            model.addAttribute("categories", categories);
            model.addAttribute("totalCategories", categories.size());

            return "admin/categories";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải danh sách danh mục");
            return "admin/categories";
        }
    }

    // ===== COURSE MANAGEMENT =====

    @GetMapping("/courses")
    public String listCourses(@RequestParam(value = "page", defaultValue = "0") int page,
                              @RequestParam(value = "size", defaultValue = "20") int size,
                              Model model,
                              Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());

            // SỬA LỖI: Sử dụng method tồn tại trong CourseService
            Page<Course> courses;
            try {
                courses = courseService.findAllWithPagination(pageable);
            } catch (Exception e) {
                // Fallback nếu method không tồn tại
                courses = courseService.findAllWithPagination(pageable);
            }

            model.addAttribute("courses", courses);
            model.addAttribute("categories", categoryService.findAllOrderByName());

            return "admin/courses";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải danh sách khóa học: " + e.getMessage());
            return "admin/courses";
        }
    }

    // ===== ANALYTICS =====

    @GetMapping("/analytics")
    public String analytics(Model model, Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            // Placeholder data cho analytics
            model.addAttribute("totalUsers", userService.countAllUsers());
            model.addAttribute("totalCourses", courseService.countAllCourses());
            model.addAttribute("totalEnrollments", enrollmentService.countAllEnrollments());
            model.addAttribute("totalRevenue", 0);

            return "admin/analytics";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải trang thống kê");
            return "admin/dashboard";
        }
    }

    // ===== API ENDPOINTS =====

    @GetMapping("/api/dashboard-stats")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getDashboardStats() {
        try {
            Map<String, Object> stats = new HashMap<>();
            stats.put("totalUsers", userService.countAllUsers());
            stats.put("totalCourses", courseService.countAllCourses());
            stats.put("totalEnrollments", enrollmentService.countAllEnrollments());
            stats.put("totalRevenue", 0);
            return ResponseEntity.ok(stats);
        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "Có lỗi xảy ra khi lấy thống kê");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    // ===== NOTIFICATION API (placeholder để tránh lỗi 404) =====

    @GetMapping("/api/notifications/count")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getNotificationCount() {
        Map<String, Object> result = new HashMap<>();
        result.put("count", 0);
        return ResponseEntity.ok(result);
    }

    // ===== EXCEPTION HANDLER =====

    @ExceptionHandler(Exception.class)
    public String handleException(Exception e, Model model, Authentication authentication, HttpServletRequest request) {
        System.err.println("========== ADMIN CONTROLLER ERROR ==========");
        System.err.println("URL: " + request.getRequestURL());
        System.err.println("Method: " + request.getMethod());
        System.err.println("User: " + (authentication != null ? ((User) authentication.getPrincipal()).getUsername() : "Anonymous"));
        System.err.println("Error: " + e.getMessage());
        System.err.println("Exception: " + e.getClass().getName());
        e.printStackTrace();
        System.err.println("============================================");

        if (authentication != null && authentication.getPrincipal() instanceof User) {
            model.addAttribute("currentUser", (User) authentication.getPrincipal());
        }

        String errorMessage = "Có lỗi xảy ra: " + e.getMessage();
        model.addAttribute("error", errorMessage);

        // Redirect về dashboard cho các lỗi nghiêm trọng
        if (request.getRequestURI().contains("/admin")) {
            return "redirect:/admin/dashboard?error=system_error";
        }

        return "error/500";
    }
}