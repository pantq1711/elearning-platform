package com.coursemanagement.controller;

import com.coursemanagement.entity.User;
import com.coursemanagement.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.validation.Valid;

/**
 * Controller xử lý profile người dùng
 * Cho phép tất cả user đã đăng nhập xem và chỉnh sửa profile
 */
@Controller
@PreAuthorize("isAuthenticated()")
public class ProfileController {

    @Autowired
    private UserService userService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    /**
     * Hiển thị trang profile của user hiện tại
     */
    @GetMapping("/profile")
    public String viewProfile(Model model, Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();

            // Reload user từ database để đảm bảo dữ liệu mới nhất
            User user = userService.findById(currentUser.getId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy thông tin người dùng"));

            model.addAttribute("currentUser", user);
            model.addAttribute("user", user);

            return "student/profile"; // Sử dụng JSP đã có

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải profile: " + e.getMessage());
            return "error/500";
        }
    }

    /**
     * Cập nhật thông tin profile
     */
    @PostMapping("/student/profile/update")
    public String updateProfile(@Valid @ModelAttribute("user") User userForm,
                                BindingResult result,
                                Authentication authentication,
                                RedirectAttributes redirectAttributes,
                                Model model) {
        try {
            if (result.hasErrors()) {
                User currentUser = (User) authentication.getPrincipal();
                model.addAttribute("currentUser", currentUser);
                return "student/profile";
            }

            User currentUser = (User) authentication.getPrincipal();
            User existingUser = userService.findById(currentUser.getId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng"));

            // Cập nhật thông tin cơ bản (không cho sửa username và role)
            existingUser.setFullName(userForm.getFullName());
            existingUser.setEmail(userForm.getEmail());
            existingUser.setPhoneNumber(userForm.getPhoneNumber());
            existingUser.setBio(userForm.getBio());

            userService.updateUser(existingUser);

            redirectAttributes.addFlashAttribute("message", "Cập nhật thông tin thành công!");
            return "redirect:/profile";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi cập nhật: " + e.getMessage());
            return "redirect:/profile";
        }
    }

    /**
     * Đổi mật khẩu
     */
    @PostMapping("/student/profile/change-password")
    public String changePassword(@RequestParam("currentPassword") String currentPassword,
                                 @RequestParam("newPassword") String newPassword,
                                 @RequestParam("confirmPassword") String confirmPassword,
                                 Authentication authentication,
                                 RedirectAttributes redirectAttributes) {
        try {
            // Validate input
            if (!newPassword.equals(confirmPassword)) {
                redirectAttributes.addFlashAttribute("error", "Mật khẩu xác nhận không khớp!");
                return "redirect:/profile";
            }

            if (newPassword.length() < 6) {
                redirectAttributes.addFlashAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự!");
                return "redirect:/profile";
            }

            User currentUser = (User) authentication.getPrincipal();
            User user = userService.findById(currentUser.getId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng"));

            // Kiểm tra mật khẩu hiện tại
            if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
                redirectAttributes.addFlashAttribute("error", "Mật khẩu hiện tại không đúng!");
                return "redirect:/profile";
            }

            // Cập nhật mật khẩu mới
            user.setPassword(passwordEncoder.encode(newPassword));
            userService.updateUser(user);

            redirectAttributes.addFlashAttribute("message", "Đổi mật khẩu thành công!");
            return "redirect:/profile";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi đổi mật khẩu: " + e.getMessage());
            return "redirect:/profile";
        }
    }
}