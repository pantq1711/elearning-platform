package com.coursemanagement.controller;

import com.coursemanagement.entity.User;
import com.coursemanagement.entity.Category;
import com.coursemanagement.entity.Course;
import com.coursemanagement.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.validation.Valid;
import java.util.List;
import java.util.Optional;

/**
 * Controller xử lý các chức năng dành cho Admin
 * Chỉ người dùng có role ADMIN mới truy cập được
 */
@Controller
@RequestMapping("/admin")
@PreAuthorize("hasRole('ADMIN')")
public class AdminController {

    @Autowired
    private UserService userService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private CourseService courseService;

    @Autowired
    private EnrollmentService enrollmentService;

    @Autowired
    private QuizService quizService;

    /**
     * Dashboard admin - trang tổng quan
     */
    @GetMapping("/dashboard")
    public String dashboard(Model model, Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            // Thống kê tổng quan
            model.addAttribute("totalUsers", userService.countAllUsers());
            model.addAttribute("totalStudents", userService.countByRole(User.Role.STUDENT));
            model.addAttribute("totalInstructors", userService.countByRole(User.Role.INSTRUCTOR));
            model.addAttribute("totalCourses", courseService.countAllCourses());
            model.addAttribute("activeCourses", courseService.countActiveCourses());
            model.addAttribute("totalCategories", categoryService.countAllCategories());

            // User mới đăng ký gần đây
            model.addAttribute("recentUsers", userService.getRecentUsers(5));

            // Khóa học phổ biến
            model.addAttribute("popularCourses", courseService.findTopPopularCourses(5));

            // Thống kê theo danh mục
            model.addAttribute("categoryStats", courseService.getCourseStatisticsByCategory());

            return "admin/dashboard";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải dashboard");
            return "error/500";
        }
    }

    // =============== QUẢN LÝ NGƯỜI DÙNG ===============

    /**
     * Danh sách tất cả người dùng
     */
    @GetMapping("/users")
    public String listUsers(@RequestParam(value = "search", required = false) String search,
                            @RequestParam(value = "role", required = false) String roleFilter,
                            Model model,
                            Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            List<User> users;

            // Tìm kiếm và lọc
            if (search != null && !search.trim().isEmpty()) {
                users = userService.searchUsers(search);
            } else if (roleFilter != null && !roleFilter.isEmpty()) {
                User.Role role = User.Role.valueOf(roleFilter);
                users = userService.findByRole(role);
            } else {
                users = userService.findAll();
            }

            model.addAttribute("users", users);
            model.addAttribute("search", search);
            model.addAttribute("roleFilter", roleFilter);
            model.addAttribute("roles", User.Role.values());

            return "admin/users";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải danh sách người dùng");
            return "admin/users";
        }
    }

    /**
     * Form tạo người dùng mới
     */
    @GetMapping("/users/new")
    public String showCreateUserForm(Model model, Authentication authentication) {
        User currentUser = (User) authentication.getPrincipal();
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("user", new User());
        model.addAttribute("roles", User.Role.values());
        return "admin/user-form";
    }

    /**
     * Xử lý tạo người dùng mới
     */
    @PostMapping("/users")
    public String createUser(@Valid @ModelAttribute("user") User user,
                             BindingResult bindingResult,
                             Model model,
                             Authentication authentication,
                             RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            if (bindingResult.hasErrors()) {
                model.addAttribute("roles", User.Role.values());
                return "admin/user-form";
            }

            // Validate và tạo user
            userService.validateUser(user, false);
            User createdUser = userService.createUser(user);

            redirectAttributes.addFlashAttribute("message",
                    "Tạo người dùng thành công: " + createdUser.getUsername());

            return "redirect:/admin/users";

        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("roles", User.Role.values());
            return "admin/user-form";
        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tạo người dùng");
            model.addAttribute("roles", User.Role.values());
            return "admin/user-form";
        }
    }

    /**
     * Form chỉnh sửa người dùng
     */
    @GetMapping("/users/{id}/edit")
    public String showEditUserForm(@PathVariable Long id,
                                   Model model,
                                   Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            User user = userService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng"));

            model.addAttribute("user", user);
            model.addAttribute("roles", User.Role.values());
            model.addAttribute("isEdit", true);

            return "admin/user-form";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải thông tin người dùng");
            return "redirect:/admin/users";
        }
    }

    /**
     * Xử lý cập nhật người dùng
     */
    @PostMapping("/users/{id}")
    public String updateUser(@PathVariable Long id,
                             @Valid @ModelAttribute("user") User user,
                             BindingResult bindingResult,
                             Model model,
                             Authentication authentication,
                             RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            if (bindingResult.hasErrors()) {
                model.addAttribute("roles", User.Role.values());
                model.addAttribute("isEdit", true);
                return "admin/user-form";
            }

            // Cập nhật user
            User updatedUser = userService.updateUser(id, user);

            redirectAttributes.addFlashAttribute("message",
                    "Cập nhật người dùng thành công: " + updatedUser.getUsername());

            return "redirect:/admin/users";

        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("roles", User.Role.values());
            model.addAttribute("isEdit", true);
            return "admin/user-form";
        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi cập nhật người dùng");
            model.addAttribute("roles", User.Role.values());
            model.addAttribute("isEdit", true);
            return "admin/user-form";
        }
    }

    /**
     * Xóa người dùng
     */
    @PostMapping("/users/{id}/delete")
    public String deleteUser(@PathVariable Long id,
                             Authentication authentication,
                             RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) authentication.getPrincipal();

            // Không cho phép xóa chính mình
            if (currentUser.getId().equals(id)) {
                redirectAttributes.addFlashAttribute("error", "Không thể xóa tài khoản của chính mình");
                return "redirect:/admin/users";
            }

            Optional<User> userToDelete = userService.findById(id);
            if (userToDelete.isPresent()) {
                userService.deleteUser(id);
                redirectAttributes.addFlashAttribute("message",
                        "Xóa người dùng thành công: " + userToDelete.get().getUsername());
            } else {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy người dùng");
            }

            return "redirect:/admin/users";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra khi xóa người dùng");
            return "redirect:/admin/users";
        }
    }

    /**
     * Kích hoạt/vô hiệu hóa tài khoản
     */
    @PostMapping("/users/{id}/toggle-status")
    public String toggleUserStatus(@PathVariable Long id,
                                   Authentication authentication,
                                   RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) authentication.getPrincipal();

            // Không cho phép vô hiệu hóa chính mình
            if (currentUser.getId().equals(id)) {
                redirectAttributes.addFlashAttribute("error", "Không thể thay đổi trạng thái tài khoản của chính mình");
                return "redirect:/admin/users";
            }

            User user = userService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng"));

            userService.toggleUserStatus(id, !user.isActive());

            String status = !user.isActive() ? "kích hoạt" : "vô hiệu hóa";
            redirectAttributes.addFlashAttribute("message",
                    "Đã " + status + " tài khoản: " + user.getUsername());

            return "redirect:/admin/users";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra khi thay đổi trạng thái tài khoản");
            return "redirect:/admin/users";
        }
    }

    /**
     * Reset mật khẩu người dùng
     */
    @PostMapping("/users/{id}/reset-password")
    public String resetPassword(@PathVariable Long id,
                                @RequestParam("newPassword") String newPassword,
                                RedirectAttributes redirectAttributes) {
        try {
            if (newPassword.length() < 6) {
                redirectAttributes.addFlashAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự");
                return "redirect:/admin/users";
            }

            User user = userService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng"));

            userService.resetPassword(id, newPassword);

            redirectAttributes.addFlashAttribute("message",
                    "Reset mật khẩu thành công cho: " + user.getUsername());

            return "redirect:/admin/users";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra khi reset mật khẩu");
            return "redirect:/admin/users";
        }
    }

    // =============== QUẢN LÝ DANH MỤC ===============

    /**
     * Danh sách tất cả danh mục
     */
    @GetMapping("/categories")
    public String listCategories(@RequestParam(value = "search", required = false) String search,
                                 Model model,
                                 Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            List<Category> categories;

            if (search != null && !search.trim().isEmpty()) {
                categories = categoryService.searchCategories(search);
            } else {
                categories = categoryService.findAllOrderByName();
            }

            model.addAttribute("categories", categories);
            model.addAttribute("search", search);

            // Thống kê danh mục
            model.addAttribute("categoryStats", categoryService.getCategoryStatistics());

            return "admin/categories";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải danh sách danh mục");
            return "admin/categories";
        }
    }

    /**
     * Form tạo danh mục mới
     */
    @GetMapping("/categories/new")
    public String showCreateCategoryForm(Model model, Authentication authentication) {
        User currentUser = (User) authentication.getPrincipal();
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("category", new Category());
        return "admin/category-form";
    }

    /**
     * Xử lý tạo danh mục mới
     */
    @PostMapping("/categories")
    public String createCategory(@Valid @ModelAttribute("category") Category category,
                                 BindingResult bindingResult,
                                 Model model,
                                 Authentication authentication,
                                 RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            if (bindingResult.hasErrors()) {
                return "admin/category-form";
            }

            Category createdCategory = categoryService.createCategory(category);

            redirectAttributes.addFlashAttribute("message",
                    "Tạo danh mục thành công: " + createdCategory.getName());

            return "redirect:/admin/categories";

        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            return "admin/category-form";
        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tạo danh mục");
            return "admin/category-form";
        }
    }

    /**
     * Form chỉnh sửa danh mục
     */
    @GetMapping("/categories/{id}/edit")
    public String showEditCategoryForm(@PathVariable Long id,
                                       Model model,
                                       Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            Category category = categoryService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy danh mục"));

            model.addAttribute("category", category);
            model.addAttribute("isEdit", true);

            return "admin/category-form";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải thông tin danh mục");
            return "redirect:/admin/categories";
        }
    }

    /**
     * Xử lý cập nhật danh mục
     */
    @PostMapping("/categories/{id}")
    public String updateCategory(@PathVariable Long id,
                                 @Valid @ModelAttribute("category") Category category,
                                 BindingResult bindingResult,
                                 Model model,
                                 Authentication authentication,
                                 RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            if (bindingResult.hasErrors()) {
                model.addAttribute("isEdit", true);
                return "admin/category-form";
            }

            Category updatedCategory = categoryService.updateCategory(id, category);

            redirectAttributes.addFlashAttribute("message",
                    "Cập nhật danh mục thành công: " + updatedCategory.getName());

            return "redirect:/admin/categories";

        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("isEdit", true);
            return "admin/category-form";
        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi cập nhật danh mục");
            model.addAttribute("isEdit", true);
            return "admin/category-form";
        }
    }

    /**
     * Xóa danh mục
     */
    @PostMapping("/categories/{id}/delete")
    public String deleteCategory(@PathVariable Long id,
                                 RedirectAttributes redirectAttributes) {
        try {
            Optional<Category> categoryToDelete = categoryService.findById(id);

            if (categoryToDelete.isPresent()) {
                categoryService.deleteCategory(id);
                redirectAttributes.addFlashAttribute("message",
                        "Xóa danh mục thành công: " + categoryToDelete.get().getName());
            } else {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy danh mục");
            }

            return "redirect:/admin/categories";

        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/admin/categories";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra khi xóa danh mục");
            return "redirect:/admin/categories";
        }
    }

    // =============== QUẢN LÝ KHÓA HỌC ===============

    /**
     * Danh sách tất cả khóa học trong hệ thống
     */
    @GetMapping("/courses")
    public String listAllCourses(@RequestParam(value = "search", required = false) String search,
                                 @RequestParam(value = "category", required = false) Long categoryId,
                                 @RequestParam(value = "instructor", required = false) Long instructorId,
                                 Model model,
                                 Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            List<Course> courses;

            // Tìm kiếm và lọc khóa học
            if (search != null && !search.trim().isEmpty()) {
                courses = courseService.searchCourses(search);
            } else {
                courses = courseService.findAll();
            }

            model.addAttribute("courses", courses);
            model.addAttribute("search", search);
            model.addAttribute("categories", categoryService.findAllOrderByName());
            model.addAttribute("instructors", userService.findActiveInstructors());

            // Thống kê khóa học
            model.addAttribute("totalCourses", courseService.countAllCourses());
            model.addAttribute("activeCourses", courseService.countActiveCourses());

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

            // Thống kê khóa học
            model.addAttribute("enrollmentCount", enrollmentService.countEnrollmentsByCourse(course));
            model.addAttribute("lessonCount", courseService.countLessonsByCourse(id));
            model.addAttribute("quizCount", courseService.countQuizzesByCourse(id));

            // Học viên gần đây
            model.addAttribute("recentEnrollments",
                    enrollmentService.getRecentEnrollmentsByCourse(course, 10));

            return "admin/course-detail";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải thông tin khóa học");
            return "redirect:/admin/courses";
        }
    }

    /**
     * Exception handler cho controller này
     */
    @ExceptionHandler(Exception.class)
    public String handleException(Exception e, Model model) {
        model.addAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        return "error/500";
    }
}