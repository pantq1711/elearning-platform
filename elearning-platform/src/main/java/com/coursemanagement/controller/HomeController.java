package com.coursemanagement.controller;

import com.coursemanagement.dto.CategoryStats;
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
import jakarta.servlet.http.HttpServletRequest;

/**
 * HomeController - xử lý trang chủ công khai
 * SỬA LỖI: Loại bỏ duplicate redirect logic, chỉ hiển thị landing page
 */
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
     * Trang chủ công khai - Landing Page
     * ✅ SỬA LỖI: Bỏ auto-redirect logic, chỉ hiển thị landing page
     */
    @GetMapping("/")
    public String home(Model model, HttpServletRequest request) {
        try {
            System.out.println("🏠 HomeController.home() được gọi");
            System.out.println("🏠 Request URL: " + request.getRequestURL());

            // ✅ SỬA LỖI: BỎ AUTO-REDIRECT - Chỉ check user cho display purposes
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated() && !auth.getPrincipal().equals("anonymousUser")) {
                User currentUser = (User) auth.getPrincipal();
                model.addAttribute("currentUser", currentUser);
                model.addAttribute("isLoggedIn", true);
                System.out.println("👤 User đã đăng nhập: " + currentUser.getUsername());
            } else {
                model.addAttribute("isLoggedIn", false);
                System.out.println("👤 User chưa đăng nhập");
            }

            // ✅ GIẢM TẢI QUERIES: Chỉ lấy thống kê cơ bản cho landing page
            try {
                // Thống kê tổng quan cho trang chủ - cached hoặc optimized
                Long totalCoursesLong = courseService.countActiveCourses();
                Long totalStudentsLong = userService.countByRole(User.Role.STUDENT);
                Long totalInstructorsLong = userService.countByRole(User.Role.INSTRUCTOR);

                // Safe conversion Long to int
                model.addAttribute("totalCourses", totalCoursesLong != null ? totalCoursesLong.intValue() : 0);
                model.addAttribute("totalStudents", totalStudentsLong != null ? totalStudentsLong.intValue() : 0);
                model.addAttribute("totalInstructors", totalInstructorsLong != null ? totalInstructorsLong.intValue() : 0);

                System.out.println("📊 Stats loaded - Courses: " + totalCoursesLong + ", Students: " + totalStudentsLong + ", Instructors: " + totalInstructorsLong);

            } catch (Exception e) {
                // Fallback values nếu có lỗi database
                System.err.println("Lỗi khi tải thống kê trang chủ: " + e.getMessage());
                model.addAttribute("totalCourses", 0);
                model.addAttribute("totalStudents", 0);
                model.addAttribute("totalInstructors", 0);
            }

            // Featured courses cho trang chủ (limit để tránh N+1)
            try {
                List<Course> featuredCourses = courseService.findFeaturedCourses(6) // ✅ SỬA: Thêm limit parameter
                        .stream()
                        .collect(Collectors.toList());
                model.addAttribute("featuredCourses", featuredCourses);
            } catch (Exception e) {
                System.err.println("Lỗi khi tải featured courses: " + e.getMessage());
                model.addAttribute("featuredCourses", List.of()); // Empty list
            }

            // Categories cho menu navigation (cached)
            try {
                List<Category> categories = categoryService.findAllActive()
                        .stream()
                        .limit(8) // ✅ GIẢM TẢI: Chỉ hiển thị 8 categories chính
                        .collect(Collectors.toList());
                model.addAttribute("categories", categories);
            } catch (Exception e) {
                System.err.println("Lỗi khi tải categories: " + e.getMessage());
                model.addAttribute("categories", List.of()); // Empty list
            }

            // Popular instructors (optional, có thể comment out nếu không cần)
            try {
                List<User> popularInstructors = userService.findActiveInstructors()
                        .stream()
                        .limit(4) // ✅ SỬA: Sử dụng findActiveInstructors + limit
                        .collect(Collectors.toList());
                model.addAttribute("popularInstructors", popularInstructors);
            } catch (Exception e) {
                System.err.println("Lỗi khi tải popular instructors: " + e.getMessage());
                model.addAttribute("popularInstructors", List.of());
            }

            System.out.println("🏠 Trả về view 'home' với data đầy đủ");
            System.out.println("🏠 Model attributes: " + model.asMap().keySet());
            return "home"; // ✅ LUÔN RETURN LANDING PAGE

        } catch (Exception e) {
            System.err.println("🚨 Lỗi nghiêm trọng trong HomeController: " + e.getMessage());
            e.printStackTrace();

            // Fallback - basic home page
            model.addAttribute("isLoggedIn", false);
            model.addAttribute("totalCourses", 0);
            model.addAttribute("totalStudents", 0);
            model.addAttribute("totalInstructors", 0);
            model.addAttribute("featuredCourses", List.of());
            model.addAttribute("categories", List.of());

            System.out.println("🏠 Returning home view with fallback data");
            System.out.println("🏠 Exception Model attributes: " + model.asMap().keySet());
            return "home";
        }
    }

    /**
     * Trang giới thiệu
     */
    @GetMapping("/about")
    public String about(Model model) {
        // Check if user is logged in for navigation purposes
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !auth.getPrincipal().equals("anonymousUser")) {
            model.addAttribute("currentUser", (User) auth.getPrincipal());
            model.addAttribute("isLoggedIn", true);
        } else {
            model.addAttribute("isLoggedIn", false);
        }

        return "about";
    }

    /**
     * Trang liên hệ
     */
    @GetMapping("/contact")
    public String contact(Model model) {
        // Check if user is logged in for navigation purposes
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !auth.getPrincipal().equals("anonymousUser")) {
            model.addAttribute("currentUser", (User) auth.getPrincipal());
            model.addAttribute("isLoggedIn", true);
        } else {
            model.addAttribute("isLoggedIn", false);
        }

        return "contact";
    }

    /**
     * Trang hiển thị tất cả khóa học công khai
     */
    @GetMapping("/courses")
    public String allCourses(Model model,
                             @RequestParam(required = false) String search,
                             @RequestParam(required = false) String category) {
        try {
            // Check if user is logged in
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated() && !auth.getPrincipal().equals("anonymousUser")) {
                model.addAttribute("currentUser", (User) auth.getPrincipal());
                model.addAttribute("isLoggedIn", true);
            } else {
                model.addAttribute("isLoggedIn", false);
            }

            // Get courses with filtering
            List<Course> courses;
            if (search != null && !search.trim().isEmpty()) {
                courses = courseService.searchCoursesByName(search.trim()); // ✅ SỬA: Sử dụng searchCoursesByName
                model.addAttribute("searchQuery", search);
            } else if (category != null && !category.trim().isEmpty()) {
                try {
                    Long categoryId = Long.parseLong(category);
                    courses = courseService.findActiveCoursesByCategory(categoryId); // ✅ SỬA: Sử dụng đúng method name
                } catch (NumberFormatException e) {
                    courses = courseService.findAllActive(); // Fallback nếu category không phải số
                }
                model.addAttribute("selectedCategory", category);
            } else {
                courses = courseService.findAllActive(); // ✅ SỬA: Sử dụng findAllActive
            }

            model.addAttribute("courses", courses);

            // Categories for filter
            List<Category> categories = categoryService.findAllActive();
            model.addAttribute("categories", categories);

            return "courses/list";

        } catch (Exception e) {
            System.err.println("Lỗi khi tải danh sách courses: " + e.getMessage());
            model.addAttribute("error", "Có lỗi xảy ra khi tải danh sách khóa học.");
            return "error/500";
        }
    }

    /**
     * Chi tiết khóa học công khai
     */
    @GetMapping("/courses/{slug}")
    public String courseDetail(@PathVariable String slug, Model model) {
        try {
            // Check if user is logged in
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            boolean isLoggedIn = auth != null && auth.isAuthenticated() && !auth.getPrincipal().equals("anonymousUser");

            if (isLoggedIn) {
                model.addAttribute("currentUser", (User) auth.getPrincipal());
                model.addAttribute("isLoggedIn", true);
            } else {
                model.addAttribute("isLoggedIn", false);
            }

            // Get course by slug
            Course course = courseService.findBySlug(slug)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học"));

            model.addAttribute("course", course);

            // Check if user is enrolled (if logged in)
            if (isLoggedIn) {
                User currentUser = (User) auth.getPrincipal();
                boolean isEnrolled = enrollmentService.isStudentEnrolled(currentUser, course);
                model.addAttribute("isEnrolled", isEnrolled);
            } else {
                model.addAttribute("isEnrolled", false);
            }

            // Related courses - sử dụng courses từ cùng category
            try {
                List<Course> relatedCourses = courseService.findActiveCoursesByCategory(course.getCategory())
                        .stream()
                        .filter(c -> !c.getId().equals(course.getId())) // Exclude current course
                        .limit(4) // ✅ SỬA: Lấy tối đa 4 courses liên quan
                        .collect(Collectors.toList());
                model.addAttribute("relatedCourses", relatedCourses);
            } catch (Exception e) {
                System.err.println("Lỗi khi tải related courses: " + e.getMessage());
                model.addAttribute("relatedCourses", List.of());
            }

            return "courses/detail";

        } catch (Exception e) {
            System.err.println("Lỗi khi tải chi tiết course: " + e.getMessage());
            model.addAttribute("error", e.getMessage());
            return "error/404";
        }
    }

    /**
     * Exception handler
     */
    @ExceptionHandler(Exception.class)
    public String handleException(Exception e, Model model) {
        System.err.println("Lỗi trong HomeController: " + e.getMessage());
        e.printStackTrace();

        model.addAttribute("error", "Có lỗi xảy ra trong hệ thống.");
        return "error/500";
    }
}