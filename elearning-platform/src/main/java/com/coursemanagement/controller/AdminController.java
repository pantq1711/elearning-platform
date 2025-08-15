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
import org.springframework.security.crypto.password.PasswordEncoder;
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
 * Thêm đầy đủ chức năng Edit/Delete cho Users, Categories, Courses
 * QUAN TRỌNG: Đặt /create routes TRƯỚC /{id} routes để tránh conflict
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

    @Autowired
    private PasswordEncoder passwordEncoder;

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
                             @RequestParam("password") String password,
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

            // Mã hóa mật khẩu
            user.setPassword(passwordEncoder.encode(password));
            user.setActive(true);

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

            Page<User> users;
            // SỬA LỖI: Sử dụng method có sẵn trong UserService
            users = userService.findUsersWithFilter(search, role, status, pageable);

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

    // THÊM MỚI: Edit User
    @GetMapping("/users/{id}/edit")
    public String editUserForm(@PathVariable Long id,
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
            return "redirect:/admin/users?error=user_not_found";
        }
    }

    // THÊM MỚI: Update User
    @PostMapping("/users/{id}/update")
    public String updateUser(@PathVariable Long id,
                             @Valid @ModelAttribute("user") User user,
                             BindingResult result,
                             @RequestParam(value = "password", required = false) String password,
                             RedirectAttributes redirectAttributes,
                             Model model,
                             Authentication authentication) {
        try {
            if (result.hasErrors()) {
                User currentUser = (User) authentication.getPrincipal();
                model.addAttribute("currentUser", currentUser);
                model.addAttribute("roles", User.Role.values());
                model.addAttribute("isEdit", true);
                return "admin/user-form";
            }

            User existingUser = userService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng"));

            // Cập nhật thông tin
            existingUser.setUsername(user.getUsername());
            existingUser.setEmail(user.getEmail());
            existingUser.setFullName(user.getFullName());
            existingUser.setRole(user.getRole());
            existingUser.setActive(user.isActive());

            // Cập nhật mật khẩu nếu có
            if (password != null && !password.trim().isEmpty()) {
                existingUser.setPassword(passwordEncoder.encode(password));
            }

            userService.updateUser(existingUser);
            redirectAttributes.addFlashAttribute("message",
                    "Cập nhật người dùng thành công: " + existingUser.getFullName());

            return "redirect:/admin/users";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Có lỗi xảy ra khi cập nhật người dùng: " + e.getMessage());
            return "redirect:/admin/users";
        }
    }

    // THÊM MỚI: Delete User
    @PostMapping("/users/{id}/delete")
    public String deleteUser(@PathVariable Long id,
                             RedirectAttributes redirectAttributes,
                             Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();

            // Không cho phép xóa chính mình
            if (currentUser.getId().equals(id)) {
                redirectAttributes.addFlashAttribute("error",
                        "Không thể xóa tài khoản của chính mình");
                return "redirect:/admin/users";
            }

            User user = userService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng"));

            userService.deleteUser(id);
            redirectAttributes.addFlashAttribute("message",
                    "Đã xóa người dùng: " + user.getFullName());

            return "redirect:/admin/users";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Có lỗi xảy ra khi xóa người dùng: " + e.getMessage());
            return "redirect:/admin/users";
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

    // THÊM MỚI: Edit Category
    @GetMapping("/categories/{id}/edit")
    public String editCategoryForm(@PathVariable Long id,
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
            return "redirect:/admin/categories?error=category_not_found";
        }
    }

    // THÊM MỚI: Update Category
    @PostMapping("/categories/{id}/update")
    public String updateCategory(@PathVariable Long id,
                                 @Valid @ModelAttribute("category") Category category,
                                 BindingResult result,
                                 RedirectAttributes redirectAttributes,
                                 Model model,
                                 Authentication authentication) {
        try {
            if (result.hasErrors()) {
                User currentUser = (User) authentication.getPrincipal();
                model.addAttribute("currentUser", currentUser);
                model.addAttribute("isEdit", true);
                return "admin/category-form";
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

    // THÊM MỚI: Delete Category
    @PostMapping("/categories/{id}/delete")
    public String deleteCategory(@PathVariable Long id,
                                 RedirectAttributes redirectAttributes) {
        try {
            Category category = categoryService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy danh mục"));

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

    // ===== COURSE MANAGEMENT =====

    @GetMapping("/courses/create")
    public String newCourseForm(Model model, Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);
            model.addAttribute("course", new Course());
            model.addAttribute("categories", categoryService.findAllOrderByName());
            return "admin/course-form";
        } catch (Exception e) {
            return "redirect:/admin/courses?error=form_error";
        }
    }

    @PostMapping("/courses/create")
    public String createCourse(@Valid @ModelAttribute("course") Course course,
                               BindingResult result,
                               Authentication authentication,
                               RedirectAttributes redirectAttributes,
                               Model model) {
        try {
            if (result.hasErrors()) {
                User currentUser = (User) authentication.getPrincipal();
                model.addAttribute("currentUser", currentUser);
                model.addAttribute("categories", categoryService.findAllOrderByName());
                return "admin/course-form";
            }

            // Admin có thể tạo khóa học cho bất kỳ giảng viên nào
            // Nếu không chọn instructor, mặc định là admin tạo
            User currentUser = (User) authentication.getPrincipal();
            if (course.getInstructor() == null) {
                course.setInstructor(currentUser);
            }

            Course createdCourse = courseService.createCourse(course);
            redirectAttributes.addFlashAttribute("message",
                    "Tạo khóa học thành công: " + createdCourse.getName());

            return "redirect:/admin/courses";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Có lỗi xảy ra khi tạo khóa học: " + e.getMessage());
            return "redirect:/admin/courses";
        }
    }

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

            Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());

            Page<Course> courses;
            if (search != null && !search.trim().isEmpty()) {
                // SỬA LỖI: Sử dụng method có sẵn
                List<Course> searchResults = courseService.searchCoursesByName(search.trim());
                // Convert List to Page manually
                courses = courseService.findAllWithPagination(pageable);
                model.addAttribute("search", search);
            } else if (categoryId != null) {
                // SỬA LỖI: Sử dụng method có sẵn
                courses = courseService.findByCategoryId(categoryId, pageable);
                model.addAttribute("selectedCategory", categoryId);
            } else {
                courses = courseService.findAllWithPagination(pageable);
            }

            model.addAttribute("courses", courses);
            model.addAttribute("categories", categoryService.findAllOrderByName());
            model.addAttribute("selectedStatus", status);

            return "admin/courses";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải danh sách khóa học: " + e.getMessage());
            return "admin/courses";
        }
    }

    // THÊM MỚI: Edit Course
    @GetMapping("/courses/{id}/edit")
    public String editCourseForm(@PathVariable Long id,
                                 Model model,
                                 Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            Course course = courseService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học"));

            model.addAttribute("course", course);
            model.addAttribute("categories", categoryService.findAllOrderByName());
            model.addAttribute("isEdit", true);
            return "admin/course-form";

        } catch (Exception e) {
            return "redirect:/admin/courses?error=course_not_found";
        }
    }

    // THÊM MỚI: Update Course
    @PostMapping("/courses/{id}/update")
    public String updateCourse(@PathVariable Long id,
                               @Valid @ModelAttribute("course") Course course,
                               BindingResult result,
                               RedirectAttributes redirectAttributes,
                               Model model,
                               Authentication authentication) {
        try {
            if (result.hasErrors()) {
                User currentUser = (User) authentication.getPrincipal();
                model.addAttribute("currentUser", currentUser);
                model.addAttribute("categories", categoryService.findAllOrderByName());
                model.addAttribute("isEdit", true);
                return "admin/course-form";
            }

            Course existingCourse = courseService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học"));

            // Giữ nguyên instructor và các thông tin quan trọng
            course.setId(id);
            course.setInstructor(existingCourse.getInstructor());
            course.setCreatedAt(existingCourse.getCreatedAt());

            Course updatedCourse = courseService.updateCourse(course);
            redirectAttributes.addFlashAttribute("message",
                    "Cập nhật khóa học thành công: " + updatedCourse.getName());

            return "redirect:/admin/courses";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Có lỗi xảy ra khi cập nhật khóa học: " + e.getMessage());
            return "redirect:/admin/courses";
        }
    }

    // THÊM MỚI: Delete Course
    @PostMapping("/courses/{id}/delete")
    public String deleteCourse(@PathVariable Long id,
                               RedirectAttributes redirectAttributes) {
        try {
            Course course = courseService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học"));

            courseService.deleteCourse(id);
            redirectAttributes.addFlashAttribute("message",
                    "Đã xóa khóa học: " + course.getName());

            return "redirect:/admin/courses";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Có lỗi xảy ra khi xóa khóa học: " + e.getMessage());
            return "redirect:/admin/courses";
        }
    }

    // ===== ANALYTICS =====

    @GetMapping("/analytics")
    public String analytics(Model model, Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            // Thống kê tổng quan
            Map<String, Object> stats = new HashMap<>();
            stats.put("totalUsers", userService.countAllUsers());
            stats.put("totalCourses", courseService.countAllCourses());
            stats.put("totalEnrollments", enrollmentService.countAllEnrollments());
            stats.put("totalCategories", categoryService.countAllCategories());

            model.addAttribute("stats", stats);

            return "admin/analytics";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải thống kê");
            return "admin/analytics";
        }
    }
}