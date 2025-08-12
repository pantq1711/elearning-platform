package com.coursemanagement.controller;

import com.coursemanagement.entity.User;
import com.coursemanagement.service.UserService;
import com.coursemanagement.service.CategoryService;
import com.coursemanagement.service.CourseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.validation.Valid;

/**
 * Controller xử lý authentication (đăng nhập, đăng ký, logout)
 */
@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private CourseService courseService;

    /**
     * Trang chủ - hiển thị danh sách khóa học công khai
     */
    @GetMapping("/")
    public String home(Model model) {
        try {
            // Thêm danh sách danh mục để hiển thị
            model.addAttribute("categories", categoryService.findAll());

            // Thêm khóa học phổ biến
            model.addAttribute("popularCourses", courseService.findTopPopularCourses(8));

            // Thêm thống kê tổng quan
            model.addAttribute("totalCourses", courseService.countActiveCourses());
            model.addAttribute("totalCategories", categoryService.countAllCategories());

            // Kiểm tra user đã đăng nhập chưa
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated() && !auth.getPrincipal().equals("anonymousUser")) {
                User currentUser = (User) auth.getPrincipal();
                model.addAttribute("currentUser", currentUser);

                // Chuyển hướng theo role nếu đã đăng nhập
                switch (currentUser.getRole()) {
                    case ADMIN:
                        return "redirect:/admin/dashboard";
                    case INSTRUCTOR:
                        return "redirect:/instructor/dashboard";
                    case STUDENT:
                        return "redirect:/student/dashboard";
                }
            }

            return "home"; // Trả về trang chủ cho khách vãng lai

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải trang chủ");
            return "error/500";
        }
    }

    /**
     * Trang đăng nhập
     */
    @GetMapping("/login")
    public String login(@RequestParam(value = "error", required = false) String error,
                        @RequestParam(value = "logout", required = false) String logout,
                        @RequestParam(value = "expired", required = false) String expired,
                        Model model) {

        // Kiểm tra đã đăng nhập chưa
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !auth.getPrincipal().equals("anonymousUser")) {
            return "redirect:/"; // Chuyển về trang chủ nếu đã đăng nhập
        }

        // Thêm thông báo lỗi nếu đăng nhập thất bại
        if (error != null) {
            model.addAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng!");
        }

        // Thêm thông báo đăng xuất thành công
        if (logout != null) {
            model.addAttribute("message", "Đăng xuất thành công!");
        }

        // Thêm thông báo session hết hạn
        if (expired != null) {
            model.addAttribute("warning", "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại!");
        }

        return "auth/login";
    }

    /**
     * Trang đăng ký
     */
    @GetMapping("/register")
    public String register(Model model) {
        // Kiểm tra đã đăng nhập chưa
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !auth.getPrincipal().equals("anonymousUser")) {
            return "redirect:/"; // Chuyển về trang chủ nếu đã đăng nhập
        }

        model.addAttribute("user", new User());
        return "auth/register";
    }

    /**
     * Xử lý đăng ký
     */
    @PostMapping("/register")
    public String processRegister(@Valid @ModelAttribute("user") User user,
                                  BindingResult bindingResult,
                                  @RequestParam("confirmPassword") String confirmPassword,
                                  Model model,
                                  RedirectAttributes redirectAttributes) {
        try {
            // Kiểm tra lỗi validation
            if (bindingResult.hasErrors()) {
                return "auth/register";
            }

            // Kiểm tra mật khẩu và xác nhận có khớp không
            if (!user.getPassword().equals(confirmPassword)) {
                model.addAttribute("error", "Mật khẩu và xác nhận mật khẩu không khớp");
                return "auth/register";
            }

            // Mặc định role là STUDENT cho user đăng ký mới
            user.setRole(User.Role.STUDENT);

            // Tạo user mới
            User createdUser = userService.createUser(user);

            redirectAttributes.addFlashAttribute("message",
                    "Đăng ký thành công! Bạn có thể đăng nhập với tài khoản: " + createdUser.getUsername());

            return "redirect:/login";

        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            return "auth/register";
        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra trong quá trình đăng ký");
            return "auth/register";
        }
    }

    /**
     * Trang lỗi truy cập bị từ chối
     */
    @GetMapping("/access-denied")
    public String accessDenied(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.getPrincipal() instanceof User) {
            User currentUser = (User) auth.getPrincipal();
            model.addAttribute("currentUser", currentUser);
        }

        return "error/access-denied";
    }

    /**
     * Trang lỗi 404
     */
    @GetMapping("/404")
    public String notFound() {
        return "error/404";
    }

    /**
     * Trang lỗi 500
     */
    @GetMapping("/500")
    public String serverError() {
        return "error/500";
    }

    /**
     * API endpoint kiểm tra username có tồn tại không
     * Dùng cho AJAX validation
     */
    @GetMapping("/api/check-username")
    @ResponseBody
    public boolean checkUsernameAvailability(@RequestParam("username") String username) {
        try {
            return !userService.existsByUsername(username);
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * API endpoint kiểm tra email có tồn tại không
     * Dùng cho AJAX validation
     */
    @GetMapping("/api/check-email")
    @ResponseBody
    public boolean checkEmailAvailability(@RequestParam("email") String email) {
        try {
            return !userService.existsByEmail(email);
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Trang thông tin tài khoản (cho tất cả user đã đăng nhập)
     */
    @GetMapping("/profile")
    public String profile(Model model, Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();

            // Load lại user từ database để có thông tin mới nhất
            User user = userService.findById(currentUser.getId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy thông tin người dùng"));

            model.addAttribute("user", user);
            return "profile";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải thông tin tài khoản");
            return "error/500";
        }
    }

    /**
     * Xử lý cập nhật thông tin tài khoản
     */
    @PostMapping("/profile")
    public String updateProfile(@Valid @ModelAttribute("user") User user,
                                BindingResult bindingResult,
                                Authentication authentication,
                                Model model,
                                RedirectAttributes redirectAttributes) {
        try {
            if (bindingResult.hasErrors()) {
                return "profile";
            }

            User currentUser = (User) authentication.getPrincipal();

            // Chỉ cho phép cập nhật một số thông tin nhất định
            user.setId(currentUser.getId());
            user.setRole(currentUser.getRole()); // Không cho đổi role
            user.setActive(currentUser.isActive()); // Không cho đổi trạng thái

            userService.updateUser(currentUser.getId(), user);

            redirectAttributes.addFlashAttribute("message", "Cập nhật thông tin thành công!");
            return "redirect:/profile";

        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("user", user);
            return "profile";
        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi cập nhật thông tin");
            model.addAttribute("user", user);
            return "profile";
        }
    }

    /**
     * Trang đổi mật khẩu
     */
    @GetMapping("/change-password")
    public String changePasswordForm(Model model, Authentication authentication) {
        User currentUser = (User) authentication.getPrincipal();
        model.addAttribute("currentUser", currentUser);
        return "change-password";
    }

    /**
     * Xử lý đổi mật khẩu
     */
    @PostMapping("/change-password")
    public String changePassword(@RequestParam("currentPassword") String currentPassword,
                                 @RequestParam("newPassword") String newPassword,
                                 @RequestParam("confirmPassword") String confirmPassword,
                                 Authentication authentication,
                                 Model model,
                                 RedirectAttributes redirectAttributes) {
        try {
            // Kiểm tra mật khẩu mới và xác nhận có khớp không
            if (!newPassword.equals(confirmPassword)) {
                model.addAttribute("error", "Mật khẩu mới và xác nhận không khớp");
                return "change-password";
            }

            // Kiểm tra độ dài mật khẩu mới
            if (newPassword.length() < 6) {
                model.addAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự");
                return "change-password";
            }

            User currentUser = (User) authentication.getPrincipal();

            // Thực hiện đổi mật khẩu
            userService.changePassword(currentUser.getId(), currentPassword, newPassword);

            redirectAttributes.addFlashAttribute("message", "Đổi mật khẩu thành công!");
            return "redirect:/profile";

        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            return "change-password";
        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi đổi mật khẩu");
            return "change-password";
        }
    }

    /**
     * Trang giới thiệu về website
     */
    @GetMapping("/about")
    public String about(Model model) {
        // Thêm thống kê tổng quan cho trang about
        try {
            model.addAttribute("totalCourses", courseService.countAllCourses());
            model.addAttribute("totalCategories", categoryService.countAllCategories());
            model.addAttribute("totalInstructors", userService.countByRole(User.Role.INSTRUCTOR));
            model.addAttribute("totalStudents", userService.countByRole(User.Role.STUDENT));
        } catch (Exception e) {
            // Không làm gì nếu có lỗi, chỉ hiển thị trang about bình thường
        }

        return "about";
    }

    /**
     * Trang liên hệ
     */
    @GetMapping("/contact")
    public String contact() {
        return "contact";
    }

    /**
     * Trang tìm kiếm khóa học công khai
     */
    @GetMapping("/courses")
    public String publicCourses(@RequestParam(value = "search", required = false) String search,
                                @RequestParam(value = "category", required = false) Long categoryId,
                                Model model) {
        try {
            model.addAttribute("categories", categoryService.findAll());

            if (search != null && !search.trim().isEmpty()) {
                model.addAttribute("courses", courseService.searchCourses(search));
                model.addAttribute("searchKeyword", search);
            } else if (categoryId != null) {
                var category = categoryService.findById(categoryId);
                if (category.isPresent()) {
                    model.addAttribute("courses", courseService.findByCategory(category.get()));
                    model.addAttribute("selectedCategory", category.get());
                } else {
                    model.addAttribute("courses", courseService.findAllActiveCourses());
                }
            } else {
                model.addAttribute("courses", courseService.findAllActiveCourses());
            }

            return "public/courses";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải danh sách khóa học");
            return "error/500";
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