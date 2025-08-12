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

/**
 * Controller xử lý các trang công khai và trang chủ
 * Không yêu cầu đăng nhập để truy cập
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
     * Trang chủ công khai
     * Hiển thị khóa học nổi bật, danh mục...
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

            // Thống kê tổng quan cho trang chủ
            model.addAttribute("totalCourses", courseService.countActiveCourses());
            model.addAttribute("totalStudents", userService.countByRole(User.Role.STUDENT));
            model.addAttribute("totalInstructors", userService.countByRole(User.Role.INSTRUCTOR));

            // Khóa học phổ biến nhất
            List<Course> popularCourses = courseService.findTopPopularCourses(6);
            model.addAttribute("popularCourses", popularCourses);

            // Khóa học mới nhất
            List<Course> latestCourses = courseService.findActiveCoursesOrderByLatest()
                    .stream().limit(6).toList();
            model.addAttribute("latestCourses", latestCourses);

            // Danh mục có khóa học
            List<Category> categoriesWithCourses = categoryService.findCategoriesWithCourses();
            model.addAttribute("categories", categoriesWithCourses);

            // Top danh mục phổ biến
            List<Category> topCategories = categoryService.findTopCategoriesByCourseCount(8);
            model.addAttribute("topCategories", topCategories);

            return "home";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải trang chủ");
            return "error/500";
        }
    }

    /**
     * Trang danh sách khóa học công khai
     * Cho phép khách vãng lai xem danh sách khóa học
     */
    @GetMapping("/courses")
    public String publicCourses(@RequestParam(value = "search", required = false) String search,
                                @RequestParam(value = "category", required = false) Long categoryId,
                                Model model) {
        try {
            // Kiểm tra user đã đăng nhập chưa
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated() && !auth.getPrincipal().equals("anonymousUser")) {
                User currentUser = (User) auth.getPrincipal();
                model.addAttribute("currentUser", currentUser);
            }

            List<Course> courses;

            // Tìm kiếm và lọc khóa học
            if (search != null && !search.trim().isEmpty()) {
                courses = courseService.searchCourses(search);
            } else if (categoryId != null) {
                Category category = categoryService.findById(categoryId).orElse(null);
                if (category != null) {
                    courses = courseService.findActiveCoursesByCategory(category);
                    model.addAttribute("selectedCategory", category);
                } else {
                    courses = courseService.findAllActiveCourses();
                }
            } else {
                courses = courseService.findAllActiveCourses();
            }

            model.addAttribute("courses", courses);
            model.addAttribute("search", search);
            model.addAttribute("categories", categoryService.findCategoriesWithCourses());

            return "public/courses";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải danh sách khóa học");
            return "public/courses";
        }
    }

    /**
     * Chi tiết khóa học công khai
     * Cho phép xem thông tin khóa học trước khi đăng nhập
     */
    @GetMapping("/courses/{id}")
    public String publicCourseDetail(@PathVariable Long id, Model model) {
        try {
            // Kiểm tra user đã đăng nhập chưa
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated() && !auth.getPrincipal().equals("anonymousUser")) {
                User currentUser = (User) auth.getPrincipal();
                model.addAttribute("currentUser", currentUser);

                // Nếu là học viên đã đăng nhập, chuyển hướng đến trang chi tiết dành cho học viên
                if (currentUser.getRole() == User.Role.STUDENT) {
                    return "redirect:/student/courses/" + id;
                }
            }

            Course course = courseService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học"));

            if (!course.isActive()) {
                model.addAttribute("error", "Khóa học hiện tại không khả dụng");
                return "redirect:/courses";
            }

            model.addAttribute("course", course);

            // Thống kê cơ bản cho khách vãng lai
            model.addAttribute("enrollmentCount", enrollmentService.countEnrollmentsByCourse(course));
            model.addAttribute("lessonCount", lessonService.countActiveLessonsByCourse(course));
            model.addAttribute("quizCount", quizService.countActiveQuizzesByCourse(course));

            // Khóa học cùng danh mục
            List<Course> relatedCourses = courseService.findActiveCoursesByCategory(course.getCategory())
                    .stream()
                    .filter(c -> !c.getId().equals(course.getId()))
                    .limit(4)
                    .toList();
            model.addAttribute("relatedCourses", relatedCourses);

            return "public/course-detail";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/courses";
        }
    }

    /**
     * Trang danh mục khóa học
     */
    @GetMapping("/categories")
    public String publicCategories(Model model) {
        try {
            // Kiểm tra user đã đăng nhập chưa
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated() && !auth.getPrincipal().equals("anonymousUser")) {
                User currentUser = (User) auth.getPrincipal();
                model.addAttribute("currentUser", currentUser);
            }

            // Tất cả danh mục có khóa học
            List<Category> categories = categoryService.findCategoriesWithCourses();
            model.addAttribute("categories", categories);

            // Thống kê cho mỗi danh mục
            List<Object[]> categoryStats = categoryService.getCategoryStatistics();
            model.addAttribute("categoryStats", categoryStats);

            return "public/categories";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải danh sách danh mục");
            return "public/categories";
        }
    }

    /**
     * Trang giới thiệu
     */
    @GetMapping("/about")
    public String about(Model model) {
        try {
            // Kiểm tra user đã đăng nhập chưa
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated() && !auth.getPrincipal().equals("anonymousUser")) {
                User currentUser = (User) auth.getPrincipal();
                model.addAttribute("currentUser", currentUser);
            }

            // Thống kê tổng quan
            model.addAttribute("totalCourses", courseService.countActiveCourses());
            model.addAttribute("totalStudents", userService.countByRole(User.Role.STUDENT));
            model.addAttribute("totalInstructors", userService.countByRole(User.Role.INSTRUCTOR));
            model.addAttribute("totalCategories", categoryService.countAllCategories());

            return "public/about";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải trang giới thiệu");
            return "public/about";
        }
    }

    /**
     * Trang liên hệ
     */
    @GetMapping("/contact")
    public String contact(Model model) {
        try {
            // Kiểm tra user đã đăng nhập chưa
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated() && !auth.getPrincipal().equals("anonymousUser")) {
                User currentUser = (User) auth.getPrincipal();
                model.addAttribute("currentUser", currentUser);
            }

            return "public/contact";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải trang liên hệ");
            return "public/contact";
        }
    }

    /**
     * API endpoint tìm kiếm khóa học (cho AJAX)
     */
    @GetMapping("/api/courses/search")
    @ResponseBody
    public List<Course> searchCoursesApi(@RequestParam("q") String query) {
        try {
            if (query == null || query.trim().length() < 2) {
                return List.of();
            }

            return courseService.searchCoursesByName(query.trim())
                    .stream()
                    .limit(10)
                    .toList();

        } catch (Exception e) {
            return List.of();
        }
    }

    /**
     * API endpoint lấy khóa học theo danh mục (cho AJAX)
     */
    @GetMapping("/api/categories/{categoryId}/courses")
    @ResponseBody
    public List<Course> getCoursesByCategory(@PathVariable Long categoryId) {
        try {
            Category category = categoryService.findById(categoryId).orElse(null);
            if (category == null) {
                return List.of();
            }

            return courseService.findActiveCoursesByCategory(category);

        } catch (Exception e) {
            return List.of();
        }
    }

    /**
     * Trang hiển thị thống kê công khai
     */
    @GetMapping("/stats")
    public String publicStats(Model model) {
        try {
            // Kiểm tra user đã đăng nhập chưa
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated() && !auth.getPrincipal().equals("anonymousUser")) {
                User currentUser = (User) auth.getPrincipal();
                model.addAttribute("currentUser", currentUser);
            }

            // Thống kê tổng quan
            model.addAttribute("totalCourses", courseService.countActiveCourses());
            model.addAttribute("totalStudents", userService.countByRole(User.Role.STUDENT));
            model.addAttribute("totalInstructors", userService.countByRole(User.Role.INSTRUCTOR));
            model.addAttribute("totalCategories", categoryService.countAllCategories());

            // Top khóa học phổ biến
            model.addAttribute("popularCourses", courseService.findTopPopularCourses(10));

            // Thống kê theo danh mục
            model.addAttribute("categoryStats", courseService.getCourseStatisticsByCategory());

            // Thống kê theo giảng viên
            model.addAttribute("instructorStats", courseService.getCourseStatisticsByInstructor());

            return "public/stats";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải thống kê");
            return "public/stats";
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