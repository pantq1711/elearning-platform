package com.coursemanagement.controller;
import com.coursemanagement.dto.CategoryStats;
import java.util.stream.Collectors;

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

    @Autowired
    private LessonService lessonService;

    @Autowired
    private QuizService quizService;

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

            // Danh mục nổi bật với thống kê
            List<CategoryService.CategoryStats> topCategories = categoryService.findTopCategoriesByCourseCount(8);
            model.addAttribute("topCategories", topCategories);

            // Featured categories
            List<Category> featuredCategories = categoryService.findFeaturedCategories();
            model.addAttribute("featuredCategories", featuredCategories);

            return "home";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải trang chủ: " + e.getMessage());
            return "error/500";
        }
    }

    /**
     * Trang tìm kiếm courses
     */
    @GetMapping("/search")
    public String search(@RequestParam(required = false) String q,
                         @RequestParam(required = false) Long categoryId,
                         Model model) {
        try {
            // Lấy tất cả categories cho filter
            List<Category> categories = categoryService.findAllOrderByName();
            model.addAttribute("categories", categories);

            List<Course> searchResults;

            if (q != null && !q.trim().isEmpty()) {
                // Tìm kiếm theo từ khóa
                searchResults = courseService.searchCoursesByName(q.trim());
                model.addAttribute("searchQuery", q);
            } else if (categoryId != null) {
                // Tìm kiếm theo category
                searchResults = courseService.findActiveCoursesByCategory(categoryId);
                Category selectedCategory = categoryService.findById(categoryId).orElse(null);
                model.addAttribute("selectedCategory", selectedCategory);
            } else {
                // Hiển thị tất cả courses active
                searchResults = courseService.findActiveCoursesOrderByLatest();
            }

            // Thêm thông tin thống kê cho mỗi course
            for (Course course : searchResults) {
                course.setLessonCount((int) lessonService.countActiveLessonsByCourse(course));
                course.setQuizCount((int) quizService.countActiveQuizzesByCourse(course));
            }

            model.addAttribute("searchResults", searchResults);
            model.addAttribute("resultCount", searchResults.size());

            return "public/search";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tìm kiếm: " + e.getMessage());
            return "error/500";
        }
    }

    /**
     * Trang chi tiết course cho guest
     */
    @GetMapping("/course/{slug}")
    public String courseDetail(@PathVariable String slug, Model model) {
        try {
            Course course = courseService.findBySlug(slug)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học"));

            if (!course.isActive()) {
                throw new RuntimeException("Khóa học này hiện không khả dụng");
            }

            model.addAttribute("course", course);

            // Thống kê course
            model.addAttribute("totalLessons", lessonService.countActiveLessonsByCourse(course));
            model.addAttribute("totalQuizzes", quizService.countActiveQuizzesByCourse(course));

            // Lessons preview (chỉ những lessons có preview = true)
            List<com.coursemanagement.entity.Lesson> previewLessons =
                    lessonService.findActiveLessonsByCourse(course)
                            .stream()
                            .filter(com.coursemanagement.entity.Lesson::isPreview)
                            .limit(3)
                            .toList();
            model.addAttribute("previewLessons", previewLessons);

            // Courses liên quan (cùng category)
            List<Course> relatedCourses = courseService.findActiveCoursesByCategory(course.getCategory())
                    .stream()
                    .filter(c -> !c.getId().equals(course.getId()))
                    .limit(4)
                    .toList();
            model.addAttribute("relatedCourses", relatedCourses);

            // Kiểm tra user đã đăng nhập và đã enroll chưa
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            boolean isEnrolled = false;
            if (auth != null && auth.isAuthenticated() && !auth.getPrincipal().equals("anonymousUser")) {
                User currentUser = (User) auth.getPrincipal();
                model.addAttribute("currentUser", currentUser);
                isEnrolled = enrollmentService.isStudentEnrolled(currentUser, course);
            }
            model.addAttribute("isEnrolled", isEnrolled);

            return "public/course-detail";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "error/404";
        }
    }

    /**
     * Trang danh sách categories
     */
    @GetMapping("/categories")
    public String categories(Model model) {
        try {
            List<Category> allCategories = categoryService.findAllOrderByName();
            model.addAttribute("categories", allCategories);

            // Thống kê cho mỗi category
            for (Category category : allCategories) {
                List<Course> categoryCourses = courseService.findActiveCoursesByCategory(category);
                category.setCourseCount((long) categoryCourses.size());
            }

            return "public/categories";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải danh mục: " + e.getMessage());
            return "error/500";
        }
    }

    /**
     * Trang courses theo category
     */
    @GetMapping("/category/{slug}")
    public String categoryDetail(@PathVariable String slug, Model model) {
        try {
            Category category = categoryService.findByName(slug)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy danh mục"));

            model.addAttribute("category", category);

            // Courses trong category
            List<Course> categoryCourses = courseService.findActiveCoursesByCategory(category);

            // Thêm thông tin thống kê cho mỗi course
            for (Course course : categoryCourses) {
                course.setLessonCount((int) lessonService.countActiveLessonsByCourse(course));
                course.setQuizCount((int) quizService.countActiveQuizzesByCourse(course));
            }

            model.addAttribute("courses", categoryCourses);
            model.addAttribute("courseCount", categoryCourses.size());

            return "public/category-detail";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "error/404";
        }
    }

    /**
     * Trang thống kê công khai
     */
    @GetMapping("/stats")
    public String publicStats(Model model) {
        try {
            // Thống kê tổng quan
            model.addAttribute("totalCourses", courseService.countActiveCourses());
            model.addAttribute("totalStudents", userService.countByRole(User.Role.STUDENT));
            model.addAttribute("totalInstructors", userService.countByRole(User.Role.INSTRUCTOR));
            model.addAttribute("totalEnrollments", enrollmentService.countAllEnrollments());

            // Top categories
            List<CategoryService.CategoryStats> topCategories = categoryService.findTopCategoriesByCourseCount(10);
            model.addAttribute("topCategories", topCategories);

            // Popular courses
            List<Course> popularCourses = courseService.findTopPopularCourses(10);
            model.addAttribute("popularCourses", popularCourses);

            // Thống kê theo tháng
            Map<String, Object> courseStats = courseService.getCourseStatisticsByMonth();
            model.addAttribute("courseStats", courseStats);

            Map<String, Object> categoryStats = categoryService.findFeaturedCategories();
            model.addAttribute("categoryStats", categoryStats);

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