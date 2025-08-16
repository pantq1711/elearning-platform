package com.coursemanagement.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Controller để xử lý auto-redirect dựa trên role
 * Tránh user truy cập nhầm trang không phù hợp với role của mình
 * SỬA LỖI: Bỏ các mapping bị conflict với controllers khác
 */
@Controller
public class RoleBasedRedirectController {

    /**
     * Auto redirect cho /admin routes khi user không phải ADMIN
     */
    @GetMapping("/admin")
    public String adminRedirect(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }

        if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_ADMIN"))) {
            return "redirect:/admin/dashboard";
        } else if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_INSTRUCTOR"))) {
            return "redirect:/instructor/dashboard";
        } else if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_STUDENT"))) {
            return "redirect:/student/dashboard";
        }

        return "redirect:/";
    }

    /**
     * Auto redirect cho /instructor routes khi user không phải INSTRUCTOR
     */
    @GetMapping("/instructor")
    public String instructorRedirect(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }

        if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_INSTRUCTOR"))) {
            return "redirect:/instructor/dashboard";
        } else if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_ADMIN"))) {
            return "redirect:/admin/dashboard";
        } else if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_STUDENT"))) {
            return "redirect:/student/dashboard";
        }

        return "redirect:/";
    }

    /**
     * Auto redirect cho /student routes khi user không phải STUDENT
     */
    @GetMapping("/student")
    public String studentRedirect(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }

        if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_STUDENT"))) {
            return "redirect:/student/dashboard";
        } else if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_ADMIN"))) {
            return "redirect:/admin/dashboard";
        } else if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_INSTRUCTOR"))) {
            return "redirect:/instructor/dashboard";
        }

        return "redirect:/";
    }

    /**
     * Route /my-account - Redirect tới profile tương ứng theo role
     */
    @GetMapping("/my-account")
    public String myAccount(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }

        // Redirect tới trang profile chung (ProfileController xử lý)
        return "redirect:/profile";
    }

    // BỎ /profile mapping - ProfileController đã handle
    // BỎ /settings mapping - Tránh conflict
    // BỎ /notifications mapping - Tránh conflict

    /**
     * Route /app-settings - Settings riêng không conflict
     */
    @GetMapping("/app-settings")
    public String appSettings(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }

        if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_ADMIN"))) {
            return "redirect:/admin/settings";
        } else if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_INSTRUCTOR"))) {
            return "redirect:/instructor/settings";
        } else if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_STUDENT"))) {
            return "redirect:/student/settings";
        }

        return "redirect:/profile";
    }

    /**
     * Route /my-notifications - Notifications riêng không conflict
     */
    @GetMapping("/my-notifications")
    public String myNotifications(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }

        if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_ADMIN"))) {
            return "redirect:/admin/notifications";
        } else if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_INSTRUCTOR"))) {
            return "redirect:/instructor/notifications";
        } else if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_STUDENT"))) {
            return "redirect:/student/notifications";
        }

        return "redirect:/"; // Fallback
    }
}