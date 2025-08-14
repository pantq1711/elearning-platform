package com.coursemanagement.controller;

import com.coursemanagement.entity.*;
import com.coursemanagement.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.multipart.MultipartFile;

import jakarta.validation.Valid;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Controller xử lý các chức năng dành cho Instructor
 * Bao gồm quản lý khóa học, bài giảng, quiz và thống kê
 * Chỉ cho phép user có role INSTRUCTOR truy cập
 */
@Controller
@RequestMapping("/instructor")
@PreAuthorize("hasRole('INSTRUCTOR')")
public class InstructorController {

    @Autowired
    private UserService userService;

    @Autowired
    private CourseService courseService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private LessonService lessonService;

    @Autowired
    private QuizService quizService;

    @Autowired
    private EnrollmentService enrollmentService;

    /**
     * Dashboard chính của instructor
     * Hiển thị thống kê tổng quan và khóa học gần đây
     */
    @GetMapping("/dashboard")
    public String dashboard(Model model, Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            // Thống kê tổng quan cho instructor
            Long totalCourses = courseService.countCoursesByInstructor(currentUser);
            Long totalStudents = enrollmentService.countStudentsByInstructor(currentUser);
            Long totalLessons = lessonService.countLessonsByInstructor(currentUser);
            Long totalRevenue = enrollmentService.calculateRevenueByInstructor(currentUser);

            model.addAttribute("totalCourses", totalCourses);
            model.addAttribute("totalStudents", totalStudents);
            model.addAttribute("totalLessons", totalLessons);
            model.addAttribute("totalRevenue", totalRevenue);

            // Khóa học gần đây của instructor
            List<Course> recentCourses = courseService.findRecentCoursesByInstructor(currentUser, 5);
            model.addAttribute("recentCourses", recentCourses);

            // Học viên mới đăng ký gần đây
            List<Enrollment> recentEnrollments = enrollmentService.findRecentEnrollmentsByInstructor(currentUser, 10);
            model.addAttribute("recentEnrollments", recentEnrollments);

            // Thống kê theo tháng
            Map<String, Object> monthlyStats = courseService.getCourseStatisticsByMonth();
            model.addAttribute("monthlyStats", monthlyStats);

            return "instructor/dashboard";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải dashboard: " + e.getMessage());
            return "error/500";
        }
    }

    // ===== COURSE MANAGEMENT =====

    /**
     * Danh sách courses của instructor
     */
    @GetMapping("/courses")
    public String courses(Model model, Authentication authentication,
                          @RequestParam(required = false) String search) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            List<Course> courses;
            if (search != null && !search.trim().isEmpty()) {
                courses = courseService.findByInstructorAndKeyword(currentUser, search.trim());
                model.addAttribute("searchQuery", search);
            } else {
                courses = courseService.findByInstructorOrderByCreatedAtDesc(currentUser);
            }

            // Thêm thông tin thống kê cho mỗi course
            for (Course course : courses) {
                long lessonCount = lessonService.countActiveLessonsByCourse(course);
                long quizCount = quizService.countActiveQuizzesByCourse(course);
                course.setLessonCount((int) lessonCount);
                course.setQuizCount((int) quizCount);
            }

            model.addAttribute("courses", courses);
            return "instructor/courses";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải danh sách khóa học: " + e.getMessage());
            return "error/500";
        }
    }

    /**
     * Form tạo course mới
     */
    @GetMapping("/courses/new")
    public String newCourse(Model model) {
        model.addAttribute("course", new Course());
        model.addAttribute("categories", categoryService.findAllOrderByName());
        return "instructor/course-form";
    }

    /**
     * Xử lý tạo course mới
     */
    @PostMapping("/courses")
    public String createCourse(@Valid @ModelAttribute Course course,
                               BindingResult result,
                               Authentication authentication,
                               RedirectAttributes redirectAttributes,
                               Model model) {
        try {
            if (result.hasErrors()) {
                model.addAttribute("categories", categoryService.findAllOrderByName());
                return "instructor/course-form";
            }

            User currentUser = (User) authentication.getPrincipal();
            course.setInstructor(currentUser);

            Course savedCourse = courseService.createCourse(course);
            redirectAttributes.addFlashAttribute("success", "Tạo khóa học thành công!");
            return "redirect:/instructor/courses/" + savedCourse.getId();

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tạo khóa học: " + e.getMessage());
            model.addAttribute("categories", categoryService.findAllOrderByName());
            return "instructor/course-form";
        }
    }

    /**
     * Chi tiết course của instructor
     */
    @GetMapping("/courses/{id}")
    public String courseDetail(@PathVariable Long id,
                               Model model,
                               Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            Course course = courseService.findByIdAndInstructor(id, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học hoặc bạn không có quyền truy cập"));

            model.addAttribute("course", course);

            // Lessons của course
            List<Lesson> lessons = lessonService.findByCourseOrderByOrderIndex(course);
            model.addAttribute("lessons", lessons);

            // Quizzes của course
            List<Quiz> quizzes = quizService.findByCourse(course);
            model.addAttribute("quizzes", quizzes);

            // Enrollments của course
            List<Enrollment> enrollments = enrollmentService.findEnrollmentsByCourse(course,
                    org.springframework.data.domain.PageRequest.of(0, 20)).getContent();
            model.addAttribute("enrollments", enrollments);

            // Thống kê course
            Map<String, Object> courseStats = Map.of(
                    "totalLessons", lessons.size(),
                    "totalQuizzes", quizzes.size(),
                    "totalEnrollments", enrollments.size(),
                    "completedEnrollments", enrollments.stream().mapToLong(e -> e.isCompleted() ? 1 : 0).sum()
            );
            model.addAttribute("courseStats", courseStats);

            return "instructor/course-detail";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "error/404";
        }
    }

    /**
     * Form edit course
     */
    @GetMapping("/courses/{id}/edit")
    public String editCourse(@PathVariable Long id,
                             Model model,
                             Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            Course course = courseService.findByIdAndInstructor(id, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học hoặc bạn không có quyền truy cập"));

            model.addAttribute("course", course);
            model.addAttribute("categories", categoryService.findAllOrderByName());
            return "instructor/course-form";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "error/404";
        }
    }

    /**
     * Xử lý update course
     */
    @PostMapping("/courses/{id}")
    public String updateCourse(@PathVariable Long id,
                               @Valid @ModelAttribute Course course,
                               BindingResult result,
                               Authentication authentication,
                               RedirectAttributes redirectAttributes,
                               Model model) {
        try {
            if (result.hasErrors()) {
                model.addAttribute("categories", categoryService.findAllOrderByName());
                return "instructor/course-form";
            }

            User currentUser = (User) authentication.getPrincipal();
            Course existingCourse = courseService.findByIdAndInstructor(id, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học hoặc bạn không có quyền truy cập"));

            // Copy properties
            course.setId(existingCourse.getId());
            course.setInstructor(currentUser);

            courseService.updateCourse(course);
            redirectAttributes.addFlashAttribute("success", "Cập nhật khóa học thành công!");
            return "redirect:/instructor/courses/" + id;

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi cập nhật khóa học: " + e.getMessage());
            model.addAttribute("categories", categoryService.findAllOrderByName());
            return "instructor/course-form";
        }
    }

    /**
     * Upload course image
     */
    @PostMapping("/courses/{id}/upload-image")
    public String uploadCourseImage(@PathVariable Long id,
                                    @RequestParam("file") MultipartFile file,
                                    Authentication authentication,
                                    RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            Course course = courseService.findByIdAndInstructor(id, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học"));

            if (file.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Vui lòng chọn file ảnh");
                return "redirect:/instructor/courses/" + id;
            }

            String imageUrl = courseService.uploadCourseImage(id, file);
            redirectAttributes.addFlashAttribute("success", "Upload ảnh thành công!");
            return "redirect:/instructor/courses/" + id;

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi upload ảnh: " + e.getMessage());
            return "redirect:/instructor/courses/" + id;
        }
    }

    // ===== LESSON MANAGEMENT =====

    /**
     * Form tạo lesson mới
     */
    @GetMapping("/courses/{courseId}/lessons/new")
    public String newLesson(@PathVariable Long courseId,
                            Model model,
                            Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            Course course = courseService.findByIdAndInstructor(courseId, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học"));

            Lesson lesson = new Lesson();
            lesson.setCourse(course);

            model.addAttribute("lesson", lesson);
            model.addAttribute("course", course);
            return "instructor/lesson-form";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "error/404";
        }
    }

    /**
     * Xử lý tạo lesson mới
     */
    @PostMapping("/courses/{courseId}/lessons")
    public String createLesson(@PathVariable Long courseId,
                               @Valid @ModelAttribute Lesson lesson,
                               BindingResult result,
                               Authentication authentication,
                               RedirectAttributes redirectAttributes,
                               Model model) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            Course course = courseService.findByIdAndInstructor(courseId, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học"));

            if (result.hasErrors()) {
                model.addAttribute("course", course);
                return "instructor/lesson-form";
            }

            lesson.setCourse(course);
            lessonService.createLesson(lesson);

            redirectAttributes.addFlashAttribute("success", "Tạo bài học thành công!");
            return "redirect:/instructor/courses/" + courseId;

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tạo bài học: " + e.getMessage());
            return "instructor/lesson-form";
        }
    }

    /**
     * Upload lesson document
     */
    @PostMapping("/lessons/{id}/upload-document")
    public String uploadLessonDocument(@PathVariable Long id,
                                       @RequestParam("file") MultipartFile file,
                                       Authentication authentication,
                                       RedirectAttributes redirectAttributes) {
        try {
            Lesson lesson = lessonService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy bài học"));

            User currentUser = (User) authentication.getPrincipal();
            Course course = courseService.findByIdAndInstructor(lesson.getCourse().getId(), currentUser)
                    .orElseThrow(() -> new RuntimeException("Bạn không có quyền truy cập"));

            if (file.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Vui lòng chọn file tài liệu");
                return "redirect:/instructor/courses/" + course.getId();
            }

            String documentUrl = lessonService.uploadLessonDocument(id, file);
            redirectAttributes.addFlashAttribute("success", "Upload tài liệu thành công!");
            return "redirect:/instructor/courses/" + course.getId();

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi upload tài liệu: " + e.getMessage());
            return "redirect:/instructor/dashboard";
        }
    }

    // ===== QUIZ MANAGEMENT =====

    /**
     * Form tạo quiz mới
     */
    @GetMapping("/courses/{courseId}/quizzes/new")
    public String newQuiz(@PathVariable Long courseId,
                          Model model,
                          Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            Course course = courseService.findByIdAndInstructor(courseId, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học"));

            Quiz quiz = new Quiz();
            quiz.setCourse(course);

            model.addAttribute("quiz", quiz);
            model.addAttribute("course", course);
            return "instructor/quiz-form";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "error/404";
        }
    }

    /**
     * Xử lý tạo quiz mới
     */
    @PostMapping("/courses/{courseId}/quizzes")
    public String createQuiz(@PathVariable Long courseId,
                             @Valid @ModelAttribute Quiz quiz,
                             BindingResult result,
                             Authentication authentication,
                             RedirectAttributes redirectAttributes,
                             Model model) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            Course course = courseService.findByIdAndInstructor(courseId, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học"));

            if (result.hasErrors()) {
                model.addAttribute("course", course);
                return "instructor/quiz-form";
            }

            quiz.setCourse(course);
            quizService.createQuiz(quiz);

            redirectAttributes.addFlashAttribute("success", "Tạo bài kiểm tra thành công!");
            return "redirect:/instructor/courses/" + courseId;

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tạo bài kiểm tra: " + e.getMessage());
            return "instructor/quiz-form";
        }
    }

    // ===== STATISTICS =====

    /**
     * Trang thống kê của instructor
     */
    @GetMapping("/statistics")
    public String statistics(Model model, Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            // Thống kê tổng quan
            Map<String, Object> instructorStats = Map.of(
                    "totalCourses", courseService.countCoursesByInstructor(currentUser),
                    "totalStudents", enrollmentService.countStudentsByInstructor(currentUser),
                    "totalRevenue", enrollmentService.calculateRevenueByInstructor(currentUser),
                    "totalLessons", lessonService.countLessonsByInstructor(currentUser)
            );
            model.addAttribute("instructorStats", instructorStats);

            // Thống kê courses
            Map<String, Object> courseStats = courseService.getCourseStatisticsByMonth();
            model.addAttribute("courseStats", courseStats);

            // Monthly enrollment stats
            Map<String, Object> enrollmentStats = enrollmentService.getEnrollmentStatisticsByMonth();
            model.addAttribute("enrollmentStats", enrollmentStats);

            return "instructor/statistics";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải thống kê: " + e.getMessage());
            return "error/500";
        }
    }
}