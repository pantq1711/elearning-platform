package com.coursemanagement.controller;

import com.coursemanagement.entity.User;
import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.Category;
import com.coursemanagement.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
public class HomeController {

    @Autowired
    private CourseService courseService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private UserService userService;

    @Autowired
    private EnrollmentService enrollmentService;

    /**
     * Trang chủ công khai (SỬA TẤT CẢ LỖI TYPE CONVERSION)
     */
    @GetMapping("/")
    public String home(Model model) {
        try {
            // Kiểm tra user đã đăng nhập chưa
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated() && !auth.getPrincipal().equals("anonymousUser")) {
                User currentUser = (User) auth.getPrincipal();
                model.addAttribute("currentUser", currentUser);

                // Nếu đã đăng nhập, chuyển hướng theo role
                switch (currentUser.getRole()) {
                    case ADMIN:
                        return "redirect:/admin/dashboard";
                    case INSTRUCTOR:
                        return "redirect:/instructor/dashboard";
                    case STUDENT:
                        return "redirect:/student/dashboard";
                }
            }

            // Thống kê tổng quan cho trang chủ (SỬA LỖI LONG TO INT)
            Long totalCoursesLong = courseService.countActiveCourses();
            Long totalStudentsLong = userService.countByRole(User.Role.STUDENT);
            Long totalInstructorsLong = userService.countByRole(User.Role.INSTRUCTOR);

            // SỬA LỖI: Safe conversion Long to int
            model.addAttribute("totalCourses", totalCoursesLong != null ? totalCoursesLong.intValue() : 0);
            model.addAttribute("totalStudents", totalStudentsLong != null ? totalStudentsLong.intValue() : 0);
            model.addAttribute("totalInstructors", totalInstructorsLong != null ? totalInstructorsLong.intValue() : 0);

            // Khóa học phổ biến nhất
            List<Course> popularCourses = courseService.findTopPopularCourses(6);
            model.addAttribute("popularCourses", popularCourses);

            // Khóa học mới nhất
            List<Course> latestCourses = courseService.findActiveCoursesOrderByLatest()
                    .stream().limit(6).collect(Collectors.toList());
            model.addAttribute("latestCourses", latestCourses);

            // Danh mục nổi bật
            List<Category> featuredCategories = categoryService.findAllActive()
                    .stream().limit(8).collect(Collectors.toList());
            model.addAttribute("featuredCategories", featuredCategories);

            return "public/home";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải trang chủ: " + e.getMessage());
            return "error/500";
        }
    }

    /**
     * Trang thống kê công khai (SỬA TẤT CẢ LỖI)
     */
    @GetMapping("/stats")
    public String publicStats(Model model) {
        try {
            // Thống kê tổng quan (SỬA LỖI LONG TO INT)
            Long totalCoursesLong = courseService.countActiveCourses();
            Long totalStudentsLong = userService.countByRole(User.Role.STUDENT);
            Long totalInstructorsLong = userService.countByRole(User.Role.INSTRUCTOR);
            Long totalEnrollmentsLong = enrollmentService.countAllEnrollments();

            model.addAttribute("totalCourses", totalCoursesLong != null ? totalCoursesLong.intValue() : 0);
            model.addAttribute("totalStudents", totalStudentsLong != null ? totalStudentsLong.intValue() : 0);
            model.addAttribute("totalInstructors", totalInstructorsLong != null ? totalInstructorsLong.intValue() : 0);
            model.addAttribute("totalEnrollments", totalEnrollmentsLong != null ? totalEnrollmentsLong.intValue() : 0);

            // Top categories (SỬA LỖI: Sử dụng đúng type)
            List<CategoryService.CategoryStats> topCategories = categoryService.findTopCategoriesByCourseCount(10);
            model.addAttribute("topCategories", topCategories);

            // Popular courses
            List<Course> popularCourses = courseService.findTopPopularCourses(10);
            model.addAttribute("popularCourses", popularCourses);

            // Thống kê theo tháng
            Map<String, Object> courseStats = courseService.getCourseStatisticsByMonth();
            model.addAttribute("courseStats", courseStats);

            // SỬA LỖI: getCategoryStatistics() trả về Map
            Map<String, Object> categoryStatsMap = categoryService.getCategoryStatistics();
            model.addAttribute("categoryStats", categoryStatsMap);

            return "public/stats";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải thống kê: " + e.getMessage());
            return "error/500";
        }
    }

    /**
     * Trang About
     */
    @GetMapping("/about")
    public String about(Model model) {
        // Thống kê cơ bản cho about page
        model.addAttribute("totalCourses", courseService.countActiveCourses());
        model.addAttribute("totalStudents", userService.countByRole(User.Role.STUDENT));
        model.addAttribute("totalInstructors", userService.countByRole(User.Role.INSTRUCTOR));

        return "public/about";
    }

    /**
     * Trang Contact
     */
    @GetMapping("/contact")
    public String contact() {
        return "public/contact";
    }
}