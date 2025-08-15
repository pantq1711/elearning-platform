package com.coursemanagement.controller;

import com.coursemanagement.entity.User;
import com.coursemanagement.service.UserService;
import com.coursemanagement.service.CategoryService;
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
 * ✅ AUTH CONTROLLER ĐÃ SỬA - LOẠI BỎ REDIRECT LOOP
 *
 * Các thay đổi:
 * - Loại bỏ logic redirect về /dashboard
 * - Đơn giản hóa login page logic
 * - Loại bỏ auto-redirect khi đã đăng nhập
 * - Tập trung vào hiển thị view thay vì redirect
 */
@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private CategoryService categoryService;

    /**
     * ✅ HIỂN THỊ TRANG ĐĂNG NHẬP - ĐƠN GIẢN, KHÔNG REDIRECT
     */
    @GetMapping("/login")
    public String loginPage(@RequestParam(value = "error", required = false) String error,
                            @RequestParam(value = "logout", required = false) String logout,
                            @RequestParam(value = "expired", required = false) String expired,
                            Model model) {

        System.out.println("🔐 AuthController.loginPage() được gọi");

        // ✅ LOẠI BỎ AUTO-REDIRECT LOGIC - chỉ hiển thị trang login
        // Không check authentication để tránh redirect loop

        // Xử lý các thông báo
        if (error != null) {
            model.addAttribute("error", "Tên đăng nhập hoặc mật khẩu không chính xác!");
        }

        if (logout != null) {
            model.addAttribute("message", "Bạn đã đăng xuất thành công!");
        }

        if (expired != null) {
            model.addAttribute("warning", "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại!");
        }

        System.out.println("🔐 Trả về view 'login'");
        return "login";
    }

    /**
     * ✅ HIỂN THỊ TRANG ĐĂNG KÝ - ĐƠN GIẢN, KHÔNG REDIRECT
     */
    @GetMapping("/register")
    public String registerPage(Model model) {

        System.out.println("📝 AuthController.registerPage() được gọi");

        // ✅ LOẠI BỎ AUTO-REDIRECT LOGIC - để tránh loop
        // Không check authentication

        // Tạo User object mới cho form
        model.addAttribute("user", new User());

        // Thêm categories nếu cần (với exception handling)
        try {
            model.addAttribute("featuredCategories", categoryService.findFeaturedCategories());
        } catch (Exception e) {
            System.err.println("Lỗi khi tải categories: " + e.getMessage());
            // Không ném exception, chỉ log và tiếp tục
        }

        System.out.println("📝 Trả về view 'register'");
        return "register";
    }

    /**
     * ✅ XỬ LÝ ĐĂNG KÝ NGƯỜI DÙNG MỚI
     */
    @PostMapping("/register")
    public String processRegistration(@Valid @ModelAttribute("user") User user,
                                      BindingResult result,
                                      RedirectAttributes redirectAttributes,
                                      Model model) {

        System.out.println("📝 Xử lý đăng ký cho user: " + user.getUsername());

        try {
            // Kiểm tra validation errors
            if (result.hasErrors()) {
                System.out.println("❌ Validation errors found");
                // Reload categories cho form
                try {
                    model.addAttribute("featuredCategories", categoryService.findFeaturedCategories());
                } catch (Exception e) {
                    System.err.println("Lỗi khi reload categories: " + e.getMessage());
                }
                return "register";
            }

            // Kiểm tra username đã tồn tại
            if (userService.existsByUsername(user.getUsername())) {
                result.rejectValue("username", "error.user",
                        "Tên đăng nhập đã tồn tại. Vui lòng chọn tên khác.");
                try {
                    model.addAttribute("featuredCategories", categoryService.findFeaturedCategories());
                } catch (Exception e) {
                    System.err.println("Lỗi khi reload categories: " + e.getMessage());
                }
                return "register";
            }

            // Kiểm tra email đã tồn tại
            if (userService.existsByEmail(user.getEmail())) {
                result.rejectValue("email", "error.user",
                        "Email đã được sử dụng. Vui lòng dùng email khác.");
                try {
                    model.addAttribute("featuredCategories", categoryService.findFeaturedCategories());
                } catch (Exception e) {
                    System.err.println("Lỗi khi reload categories: " + e.getMessage());
                }
                return "register";
            }

            // Thiết lập role mặc định
            user.setRole(User.Role.STUDENT);
            user.setActive(true);

            // Tạo user mới
            User createdUser = userService.createUser(user);
            System.out.println("✅ Đăng ký thành công cho user: " + createdUser.getUsername());

            // Thông báo thành công và redirect về login
            redirectAttributes.addFlashAttribute("message",
                    "Đăng ký thành công! Vui lòng đăng nhập để tiếp tục.");

            return "redirect:/login";

        } catch (RuntimeException e) {
            System.err.println("❌ Lỗi runtime khi đăng ký: " + e.getMessage());
            model.addAttribute("error", e.getMessage());
            try {
                model.addAttribute("featuredCategories", categoryService.findFeaturedCategories());
            } catch (Exception ex) {
                System.err.println("Lỗi khi reload categories: " + ex.getMessage());
            }
            return "register";

        } catch (Exception e) {
            System.err.println("❌ Lỗi không mong muốn khi đăng ký: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "Có lỗi xảy ra trong quá trình đăng ký. Vui lòng thử lại.");
            try {
                model.addAttribute("featuredCategories", categoryService.findFeaturedCategories());
            } catch (Exception ex) {
                System.err.println("Lỗi khi reload categories: " + ex.getMessage());
            }
            return "register";
        }
    }

    /**
     * ✅ XỬ LÝ LOGOUT (Spring Security sẽ handle chính)
     * Method này chỉ để fallback nếu cần
     */
    @PostMapping("/logout")
    public String logout(HttpServletRequest request, RedirectAttributes redirectAttributes) {

        System.out.println("🚪 Manual logout được gọi");

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
     * ✅ EXCEPTION HANDLER CHO CONTROLLER NÀY
     */
    @ExceptionHandler(Exception.class)
    public String handleException(Exception e, Model model) {
        System.err.println("🚨 Lỗi trong AuthController: " + e.getMessage());
        e.printStackTrace();

        model.addAttribute("error", "Có lỗi xảy ra trong hệ thống. Vui lòng thử lại sau.");

        // Redirect về trang chủ thay vì error page để tránh loop
        return "redirect:/";
    }
}