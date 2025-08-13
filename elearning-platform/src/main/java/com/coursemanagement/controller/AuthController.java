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
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * Controller xử lý authentication và authorization
 * Quản lý đăng nhập, đăng ký, đăng xuất và redirect sau khi login
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
     * Hiển thị trang đăng nhập
     * @param error Tham số error từ Spring Security khi login thất bại
     * @param logout Tham số logout khi user đăng xuất thành công
     * @param model Model để truyền data xuống view
     * @return Tên view đăng nhập
     */
    @GetMapping("/login")
    public String loginPage(@RequestParam(value = "error", required = false) String error,
                            @RequestParam(value = "logout", required = false) String logout,
                            Model model) {

        // Kiểm tra nếu user đã login rồi thì redirect về dashboard
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() &&
                !auth.getName().equals("anonymousUser")) {
            return "redirect:/dashboard";
        }

        // Xử lý thông báo lỗi đăng nhập
        if (error != null) {
            model.addAttribute("error", "Tên đăng nhập hoặc mật khẩu không chính xác!");
        }

        // Xử lý thông báo đăng xuất thành công
        if (logout != null) {
            model.addAttribute("message", "Bạn đã đăng xuất thành công!");
        }

        // Thêm thống kê tổng quan cho trang login
        try {
            model.addAttribute("totalCourses", courseService.countAllActiveCourses());
            model.addAttribute("totalStudents", userService.countActiveStudents());
            model.addAttribute("totalInstructors", userService.countActiveInstructors());
        } catch (Exception e) {
            // Log lỗi nhưng không làm gián đoạn trang login
            System.err.println("Lỗi khi tải thống kê cho trang login: " + e.getMessage());
        }

        return "login";
    }

    /**
     * Hiển thị trang đăng ký
     * @param model Model để truyền User object xuống form
     * @return Tên view đăng ký
     */
    @GetMapping("/register")
    public String registerPage(Model model) {

        // Kiểm tra nếu user đã login rồi thì redirect về dashboard
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() &&
                !auth.getName().equals("anonymousUser")) {
            return "redirect:/dashboard";
        }

        // Tạo User object mới cho form đăng ký
        model.addAttribute("user", new User());

        // Thêm danh sách categories để hiển thị các khóa học có sẵn
        try {
            model.addAttribute("featuredCategories", categoryService.findFeaturedCategories());
        } catch (Exception e) {
            System.err.println("Lỗi khi tải categories cho trang đăng ký: " + e.getMessage());
        }

        return "register";
    }

    /**
     * Xử lý đăng ký người dùng mới
     * @param user User object từ form
     * @param result BindingResult để kiểm tra validation errors
     * @param request HttpServletRequest để lấy thông tin request
     * @param redirectAttributes RedirectAttributes để truyền thông báo
     * @param model Model để truyền data khi có lỗi
     * @return Redirect hoặc view name
     */
    @PostMapping("/register")
    public String processRegistration(@Valid @ModelAttribute("user") User user,
                                      BindingResult result,
                                      HttpServletRequest request,
                                      RedirectAttributes redirectAttributes,
                                      Model model) {
        try {
            // Kiểm tra validation errors
            if (result.hasErrors()) {
                model.addAttribute("featuredCategories", categoryService.findFeaturedCategories());
                return "register";
            }

            // Kiểm tra xem username đã tồn tại chưa
            if (userService.existsByUsername(user.getUsername())) {
                result.rejectValue("username", "error.user",
                        "Tên đăng nhập đã tồn tại. Vui lòng chọn tên khác.");
                model.addAttribute("featuredCategories", categoryService.findFeaturedCategories());
                return "register";
            }

            // Kiểm tra xem email đã tồn tại chưa
            if (userService.existsByEmail(user.getEmail())) {
                result.rejectValue("email", "error.user",
                        "Email đã được sử dụng. Vui lòng dùng email khác.");
                model.addAttribute("featuredCategories", categoryService.findFeaturedCategories());
                return "register";
            }

            // Mặc định role là STUDENT cho đăng ký thông thường
            user.setRole(User.Role.STUDENT);
            user.setActive(true);

            // Tạo user mới
            User createdUser = userService.createUser(user);

            // Ghi log đăng ký thành công
            System.out.println("Đăng ký thành công cho user: " + createdUser.getUsername());

            // Thông báo thành công và redirect về trang login
            redirectAttributes.addFlashAttribute("message",
                    "Đăng ký thành công! Vui lòng đăng nhập để tiếp tục.");

            return "redirect:/login";

        } catch (RuntimeException e) {
            // Xử lý lỗi từ UserService
            model.addAttribute("error", e.getMessage());
            model.addAttribute("featuredCategories", categoryService.findFeaturedCategories());
            return "register";

        } catch (Exception e) {
            // Xử lý lỗi không mong muốn
            System.err.println("Lỗi không mong muốn khi đăng ký: " + e.getMessage());
            model.addAttribute("error", "Có lỗi xảy ra trong quá trình đăng ký. Vui lòng thử lại.");
            model.addAttribute("featuredCategories", categoryService.findFeaturedCategories());
            return "register";
        }
    }

    /**
     * Redirect sau khi đăng nhập thành công
     * Dựa vào role của user để redirect đến trang phù hợp
     * @param authentication Authentication object chứa thông tin user
     * @param request HttpServletRequest để lấy session
     * @return Redirect URL dựa vào role
     */
    @GetMapping("/dashboard")
    public String dashboard(Authentication authentication, HttpServletRequest request) {

        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }

        User user = (User) authentication.getPrincipal();
        HttpSession session = request.getSession();

        // Cập nhật last login time
        try {
            userService.updateLastLogin(user.getId());
        } catch (Exception e) {
            System.err.println("Lỗi khi cập nhật last login: " + e.getMessage());
        }

        // Lưu thông tin user vào session để sử dụng trong toàn bộ ứng dụng
        session.setAttribute("currentUser", user);
        session.setAttribute("userRole", user.getRole().toString());

        // Redirect dựa vào role của user
        switch (user.getRole()) {
            case ADMIN:
                return "redirect:/admin/dashboard";

            case INSTRUCTOR:
                return "redirect:/instructor/dashboard";

            case STUDENT:
                return "redirect:/student/dashboard";

            default:
                // Fallback cho trường hợp role không hợp lệ
                System.err.println("Role không hợp lệ cho user: " + user.getUsername());
                return "redirect:/login?error=invalid_role";
        }
    }

    /**
     * Xử lý logout (thực tế được handle bởi Spring Security)
     * Method này chỉ để redirect trong trường hợp cần thiết
     * @param request HttpServletRequest
     * @param redirectAttributes RedirectAttributes
     * @return Redirect về trang login
     */
    @PostMapping("/logout")
    public String logout(HttpServletRequest request, RedirectAttributes redirectAttributes) {

        // Invalidate session
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // Clear security context
        SecurityContextHolder.clearContext();

        // Thông báo đăng xuất thành công
        redirectAttributes.addFlashAttribute("message", "Bạn đã đăng xuất thành công!");

        return "redirect:/login";
    }

    /**
     * Trang thay đổi mật khẩu
     * @param model Model
     * @param authentication Authentication để lấy user hiện tại
     * @return View name
     */
    @GetMapping("/change-password")
    public String changePasswordPage(Model model, Authentication authentication) {

        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }

        User currentUser = (User) authentication.getPrincipal();
        model.addAttribute("currentUser", currentUser);

        return "auth/change-password";
    }

    /**
     * Xử lý thay đổi mật khẩu
     * @param currentPassword Mật khẩu hiện tại
     * @param newPassword Mật khẩu mới
     * @param confirmPassword Xác nhận mật khẩu mới
     * @param authentication Authentication
     * @param redirectAttributes RedirectAttributes
     * @param model Model
     * @return Redirect hoặc view name
     */
    @PostMapping("/change-password")
    public String processChangePassword(@RequestParam("currentPassword") String currentPassword,
                                        @RequestParam("newPassword") String newPassword,
                                        @RequestParam("confirmPassword") String confirmPassword,
                                        Authentication authentication,
                                        RedirectAttributes redirectAttributes,
                                        Model model) {
        try {
            User currentUser = (User) authentication.getPrincipal();

            // Kiểm tra mật khẩu mới và xác nhận có khớp không
            if (!newPassword.equals(confirmPassword)) {
                model.addAttribute("error", "Mật khẩu mới và xác nhận mật khẩu không khớp!");
                model.addAttribute("currentUser", currentUser);
                return "auth/change-password";
            }

            // Kiểm tra độ mạnh mật khẩu mới
            if (newPassword.length() < 6) {
                model.addAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự!");
                model.addAttribute("currentUser", currentUser);
                return "auth/change-password";
            }

            // Thay đổi mật khẩu
            boolean success = userService.changePassword(currentUser.getId(), currentPassword, newPassword);

            if (success) {
                redirectAttributes.addFlashAttribute("message",
                        "Thay đổi mật khẩu thành công!");
                return "redirect:/dashboard";
            } else {
                model.addAttribute("error", "Mật khẩu hiện tại không chính xác!");
                model.addAttribute("currentUser", currentUser);
                return "auth/change-password";
            }

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            model.addAttribute("currentUser", (User) authentication.getPrincipal());
            return "auth/change-password";
        }
    }

    /**
     * Exception handler cho controller này
     * @param e Exception được throw
     * @param model Model để truyền error message
     * @return Error view name
     */
    @ExceptionHandler(Exception.class)
    public String handleException(Exception e, Model model) {
        System.err.println("Lỗi trong AuthController: " + e.getMessage());
        e.printStackTrace();

        model.addAttribute("error", "Có lỗi xảy ra trong hệ thống. Vui lòng thử lại sau.");
        return "error/500";
    }
}