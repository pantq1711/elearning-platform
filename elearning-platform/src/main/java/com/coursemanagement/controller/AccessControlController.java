package com.coursemanagement.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Controller xử lý access control và error pages
 * Cung cấp trang lỗi và auto-redirect theo role
 * SỬA LỖI: Bỏ mapping "/" để tránh conflict với HomeController
 */
@Controller
public class AccessControlController {

    /**
     * Trang chủ - BỎ MAPPING "/" để tránh conflict với HomeController
     * HomeController sẽ xử lý "/" và hiển thị landing page
     */
    // REMOVED @GetMapping("/") - HomeController handles this

    /**
     * Dashboard chung - Auto redirect theo role
     */
    @GetMapping("/dashboard")
    public String dashboard(Authentication authentication) {
        if (authentication != null && authentication.isAuthenticated()) {
            if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_ADMIN"))) {
                return "redirect:/admin/dashboard";
            } else if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_INSTRUCTOR"))) {
                return "redirect:/instructor/dashboard";
            } else if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_STUDENT"))) {
                return "redirect:/student/dashboard";
            }
        }

        return "redirect:/login";
    }

    /**
     * Trang lỗi 403 - Không có quyền truy cập
     */
    @GetMapping("/error/403")
    public String accessDenied(Model model, Authentication authentication) {
        model.addAttribute("errorCode", "403");
        model.addAttribute("errorTitle", "Không có quyền truy cập");
        model.addAttribute("errorMessage", "Bạn không có quyền truy cập vào trang này.");

        if (authentication != null && authentication.isAuthenticated()) {
            model.addAttribute("currentUser", authentication.getPrincipal());

            // Đề xuất trang phù hợp theo role
            if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_ADMIN"))) {
                model.addAttribute("suggestedPage", "/admin/dashboard");
                model.addAttribute("suggestedPageName", "Dashboard Admin");
            } else if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_INSTRUCTOR"))) {
                model.addAttribute("suggestedPage", "/instructor/dashboard");
                model.addAttribute("suggestedPageName", "Dashboard Giảng viên");
            } else if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_STUDENT"))) {
                model.addAttribute("suggestedPage", "/student/dashboard");
                model.addAttribute("suggestedPageName", "Dashboard Học viên");
            }
        } else {
            model.addAttribute("suggestedPage", "/login");
            model.addAttribute("suggestedPageName", "Đăng nhập");
        }

        return "error/403";
    }

    /**
     * Trang lỗi 404 - Không tìm thấy trang
     */
    @GetMapping("/error/404")
    public String notFound(Model model) {
        model.addAttribute("errorCode", "404");
        model.addAttribute("errorTitle", "Không tìm thấy trang");
        model.addAttribute("errorMessage", "Trang bạn tìm kiếm không tồn tại hoặc đã bị di chuyển.");
        return "error/404";
    }

    /**
     * Trang lỗi 500 - Lỗi server
     */
    @GetMapping("/error/500")
    public String serverError(Model model) {
        model.addAttribute("errorCode", "500");
        model.addAttribute("errorTitle", "Lỗi hệ thống");
        model.addAttribute("errorMessage", "Đã xảy ra lỗi trong hệ thống. Vui lòng thử lại sau.");
        return "error/500";
    }

    /**
     * Quick access - Kiểm tra quyền và redirect nhanh
     */
    @GetMapping("/quick-access")
    public String quickAccess(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }

        // Redirect nhanh theo role
        if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_ADMIN"))) {
            return "redirect:/admin/dashboard";
        } else if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_INSTRUCTOR"))) {
            return "redirect:/instructor/dashboard";
        } else if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_STUDENT"))) {
            return "redirect:/student/dashboard";
        }

        return "redirect:/";
    }
}