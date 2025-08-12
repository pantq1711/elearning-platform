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

import jakarta.validation.Valid;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

/**
 * Controller xử lý các chức năng dành cho Instructor (Giảng viên)
 * Chỉ người dùng có role INSTRUCTOR mới truy cập được
 */
@Controller
@RequestMapping("/instructor")
@PreAuthorize("hasRole('INSTRUCTOR')")
public class InstructorController {

    @Autowired
    private UserService userService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private CourseService courseService;

    @Autowired
    private LessonService lessonService;

    @Autowired
    private QuizService quizService;

    @Autowired
    private EnrollmentService enrollmentService;

    /**
     * Dashboard giảng viên - trang tổng quan
     */
    @GetMapping("/dashboard")
    public String dashboard(Model model, Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            // Thống kê tổng quan của giảng viên
            long totalCourses = courseService.countCoursesByInstructor(currentUser);
            long totalStudents = enrollmentService.countStudentsByInstructor(currentUser);

            model.addAttribute("totalCourses", totalCourses);
            model.addAttribute("totalStudents", totalStudents);

            // Khóa học của giảng viên
            List<Course> myCourses = courseService.findActiveCoursesByInstructor(currentUser);
            model.addAttribute("myCourses", myCourses);

            // Khóa học mới nhất
            model.addAttribute("latestCourses",
                    courseService.findLatestCoursesByInstructor(currentUser.getId(), 5));

            // Thống kê đăng ký gần đây
            List<Enrollment> recentEnrollments = enrollmentService.findEnrollmentsByInstructor(currentUser);
            model.addAttribute("recentEnrollments",
                    recentEnrollments.stream().limit(10).toList());

            return "instructor/dashboard";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải dashboard");
            return "error/500";
        }
    }

    // =============== QUẢN LÝ KHÓA HỌC ===============

    /**
     * Danh sách khóa học của giảng viên
     */
    @GetMapping("/courses")
    public String listMyCourses(@RequestParam(value = "search", required = false) String search,
                                Model model,
                                Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            List<Course> courses;

            if (search != null && !search.trim().isEmpty()) {
                // Lọc khóa học của giảng viên theo từ khóa
                courses = courseService.findCoursesByInstructor(currentUser).stream()
                        .filter(course -> course.getName().toLowerCase().contains(search.toLowerCase()) ||
                                (course.getDescription() != null &&
                                        course.getDescription().toLowerCase().contains(search.toLowerCase())))
                        .toList();
            } else {
                courses = courseService.findCoursesByInstructor(currentUser);
            }

            model.addAttribute("courses", courses);
            model.addAttribute("search", search);

            return "instructor/courses";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải danh sách khóa học");
            return "instructor/courses";
        }
    }

    /**
     * Form tạo khóa học mới
     */
    @GetMapping("/courses/new")
    public String showCreateCourseForm(Model model, Authentication authentication) {
        User currentUser = (User) authentication.getPrincipal();
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("course", new Course());
        model.addAttribute("categories", categoryService.findAllOrderByName());
        return "instructor/course-form";
    }

    /**
     * Xử lý tạo khóa học mới
     */
    @PostMapping("/courses")
    public String createCourse(@Valid @ModelAttribute("course") Course course,
                               BindingResult bindingResult,
                               Model model,
                               Authentication authentication,
                               RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            if (bindingResult.hasErrors()) {
                model.addAttribute("categories", categoryService.findAllOrderByName());
                return "instructor/course-form";
            }

            // Gán giảng viên hiện tại cho khóa học
            course.setInstructor(currentUser);

            Course createdCourse = courseService.createCourse(course);

            redirectAttributes.addFlashAttribute("message",
                    "Tạo khóa học thành công: " + createdCourse.getName());

            return "redirect:/instructor/courses";

        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("categories", categoryService.findAllOrderByName());
            return "instructor/course-form";
        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tạo khóa học");
            model.addAttribute("categories", categoryService.findAllOrderByName());
            return "instructor/course-form";
        }
    }

    /**
     * Form chỉnh sửa khóa học
     */
    @GetMapping("/courses/{id}/edit")
    public String showEditCourseForm(@PathVariable Long id,
                                     Model model,
                                     Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            Course course = courseService.findByIdAndInstructor(id, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học hoặc bạn không có quyền truy cập"));

            model.addAttribute("course", course);
            model.addAttribute("categories", categoryService.findAllOrderByName());
            model.addAttribute("isEdit", true);

            return "instructor/course-form";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/instructor/courses";
        }
    }

    /**
     * Xử lý cập nhật khóa học
     */
    @PostMapping("/courses/{id}")
    public String updateCourse(@PathVariable Long id,
                               @Valid @ModelAttribute("course") Course course,
                               BindingResult bindingResult,
                               Model model,
                               Authentication authentication,
                               RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            // Kiểm tra quyền truy cập
            Course existingCourse = courseService.findByIdAndInstructor(id, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học hoặc bạn không có quyền truy cập"));

            if (bindingResult.hasErrors()) {
                model.addAttribute("categories", categoryService.findAllOrderByName());
                model.addAttribute("isEdit", true);
                return "instructor/course-form";
            }

            // Giữ nguyên giảng viên
            course.setInstructor(currentUser);

            Course updatedCourse = courseService.updateCourse(id, course);

            redirectAttributes.addFlashAttribute("message",
                    "Cập nhật khóa học thành công: " + updatedCourse.getName());

            return "redirect:/instructor/courses";

        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("categories", categoryService.findAllOrderByName());
            model.addAttribute("isEdit", true);
            return "instructor/course-form";
        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi cập nhật khóa học");
            model.addAttribute("categories", categoryService.findAllOrderByName());
            model.addAttribute("isEdit", true);
            return "instructor/course-form";
        }
    }

    /**
     * Xóa khóa học
     */
    @PostMapping("/courses/{id}/delete")
    public String deleteCourse(@PathVariable Long id,
                               Authentication authentication,
                               RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) authentication.getPrincipal();

            Course course = courseService.findByIdAndInstructor(id, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học hoặc bạn không có quyền truy cập"));

            courseService.deleteCourse(id);

            redirectAttributes.addFlashAttribute("message",
                    "Xóa khóa học thành công: " + course.getName());

            return "redirect:/instructor/courses";

        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/instructor/courses";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra khi xóa khóa học");
            return "redirect:/instructor/courses";
        }
    }

    /**
     * Chi tiết khóa học và quản lý
     */
    @GetMapping("/courses/{id}")
    public String viewCourse(@PathVariable Long id,
                             Model model,
                             Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            Course course = courseService.findByIdAndInstructor(id, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học hoặc bạn không có quyền truy cập"));

            model.addAttribute("course", course);

            // Thống kê khóa học
            model.addAttribute("enrollmentCount", enrollmentService.countEnrollmentsByCourse(course));
            model.addAttribute("lessonCount", lessonService.countActiveLessonsByCourse(course));
            model.addAttribute("quizCount", quizService.countActiveQuizzesByCourse(course));

            // Danh sách bài giảng
            model.addAttribute("lessons", lessonService.findActiveLessonsByCourse(course));

            // Danh sách bài kiểm tra
            model.addAttribute("quizzes", quizService.findActiveQuizzesByCourse(course));

            // Học viên đăng ký gần đây
            model.addAttribute("recentEnrollments",
                    enrollmentService.getRecentEnrollmentsByCourse(course, 5));

            return "instructor/course-detail";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/instructor/courses";
        }
    }

    // =============== QUẢN LÝ BÀI GIẢNG ===============

    /**
     * Danh sách bài giảng của khóa học
     */
    @GetMapping("/courses/{courseId}/lessons")
    public String listLessons(@PathVariable Long courseId,
                              Model model,
                              Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            Course course = courseService.findByIdAndInstructor(courseId, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học hoặc bạn không có quyền truy cập"));

            model.addAttribute("course", course);
            model.addAttribute("lessons", lessonService.findLessonsByCourse(course));

            return "instructor/lessons";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/instructor/courses";
        }
    }

    /**
     * Form tạo bài giảng mới
     */
    @GetMapping("/courses/{courseId}/lessons/new")
    public String showCreateLessonForm(@PathVariable Long courseId,
                                       Model model,
                                       Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            Course course = courseService.findByIdAndInstructor(courseId, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học hoặc bạn không có quyền truy cập"));

            Lesson lesson = new Lesson();
            lesson.setCourse(course);
            lesson.setOrderIndex(lessonService.getNextOrderIndex(course));

            model.addAttribute("course", course);
            model.addAttribute("lesson", lesson);

            return "instructor/lesson-form";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/instructor/courses";
        }
    }

    /**
     * Xử lý tạo bài giảng mới
     */
    @PostMapping("/courses/{courseId}/lessons")
    public String createLesson(@PathVariable Long courseId,
                               @Valid @ModelAttribute("lesson") Lesson lesson,
                               BindingResult bindingResult,
                               Model model,
                               Authentication authentication,
                               RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            Course course = courseService.findByIdAndInstructor(courseId, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học hoặc bạn không có quyền truy cập"));

            if (bindingResult.hasErrors()) {
                model.addAttribute("course", course);
                return "instructor/lesson-form";
            }

            lesson.setCourse(course);
            Lesson createdLesson = lessonService.createLesson(lesson);

            redirectAttributes.addFlashAttribute("message",
                    "Tạo bài giảng thành công: " + createdLesson.getTitle());

            return "redirect:/instructor/courses/" + courseId + "/lessons";

        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            Course course = courseService.findById(courseId).orElse(null);
            model.addAttribute("course", course);
            return "instructor/lesson-form";
        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tạo bài giảng");
            Course course = courseService.findById(courseId).orElse(null);
            model.addAttribute("course", course);
            return "instructor/lesson-form";
        }
    }

    /**
     * Form chỉnh sửa bài giảng
     */
    @GetMapping("/courses/{courseId}/lessons/{lessonId}/edit")
    public String showEditLessonForm(@PathVariable Long courseId,
                                     @PathVariable Long lessonId,
                                     Model model,
                                     Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            Course course = courseService.findByIdAndInstructor(courseId, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học hoặc bạn không có quyền truy cập"));

            Lesson lesson = lessonService.findByIdAndCourse(lessonId, course)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy bài giảng"));

            model.addAttribute("course", course);
            model.addAttribute("lesson", lesson);
            model.addAttribute("isEdit", true);

            return "instructor/lesson-form";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/instructor/courses/" + courseId + "/lessons";
        }
    }

    /**
     * Xử lý cập nhật bài giảng
     */
    @PostMapping("/courses/{courseId}/lessons/{lessonId}")
    public String updateLesson(@PathVariable Long courseId,
                               @PathVariable Long lessonId,
                               @Valid @ModelAttribute("lesson") Lesson lesson,
                               BindingResult bindingResult,
                               Model model,
                               Authentication authentication,
                               RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            Course course = courseService.findByIdAndInstructor(courseId, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học hoặc bạn không có quyền truy cập"));

            if (bindingResult.hasErrors()) {
                model.addAttribute("course", course);
                model.addAttribute("isEdit", true);
                return "instructor/lesson-form";
            }

            lesson.setCourse(course);
            Lesson updatedLesson = lessonService.updateLesson(lessonId, lesson);

            redirectAttributes.addFlashAttribute("message",
                    "Cập nhật bài giảng thành công: " + updatedLesson.getTitle());

            return "redirect:/instructor/courses/" + courseId + "/lessons";

        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            Course course = courseService.findById(courseId).orElse(null);
            model.addAttribute("course", course);
            model.addAttribute("isEdit", true);
            return "instructor/lesson-form";
        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi cập nhật bài giảng");
            Course course = courseService.findById(courseId).orElse(null);
            model.addAttribute("course", course);
            model.addAttribute("isEdit", true);
            return "instructor/lesson-form";
        }
    }

    /**
     * Xóa bài giảng
     */
    @PostMapping("/courses/{courseId}/lessons/{lessonId}/delete")
    public String deleteLesson(@PathVariable Long courseId,
                               @PathVariable Long lessonId,
                               Authentication authentication,
                               RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) authentication.getPrincipal();

            Course course = courseService.findByIdAndInstructor(courseId, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học hoặc bạn không có quyền truy cập"));

            Lesson lesson = lessonService.findByIdAndCourse(lessonId, course)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy bài giảng"));

            lessonService.deleteLesson(lessonId);

            redirectAttributes.addFlashAttribute("message",
                    "Xóa bài giảng thành công: " + lesson.getTitle());

            return "redirect:/instructor/courses/" + courseId + "/lessons";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/instructor/courses/" + courseId + "/lessons";
        }
    }

    // =============== QUẢN LÝ BÀI KIỂM TRA ===============

    /**
     * Danh sách bài kiểm tra của khóa học
     */
    @GetMapping("/courses/{courseId}/quizzes")
    public String listQuizzes(@PathVariable Long courseId,
                              Model model,
                              Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            Course course = courseService.findByIdAndInstructor(courseId, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học hoặc bạn không có quyền truy cập"));

            model.addAttribute("course", course);
            model.addAttribute("quizzes", quizService.findQuizzesByCourse(course));

            return "instructor/quizzes";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/instructor/courses";
        }
    }

    /**
     * Form tạo bài kiểm tra mới
     */
    @GetMapping("/courses/{courseId}/quizzes/new")
    public String showCreateQuizForm(@PathVariable Long courseId,
                                     Model model,
                                     Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            Course course = courseService.findByIdAndInstructor(courseId, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học hoặc bạn không có quyền truy cập"));

            Quiz quiz = new Quiz();
            quiz.setCourse(course);
            quiz.setDuration(30); // Mặc định 30 phút
            quiz.setMaxScore(100.0); // Mặc định 100 điểm
            quiz.setPassScore(60.0); // Mặc định 60 điểm để pass

            model.addAttribute("course", course);
            model.addAttribute("quiz", quiz);

            return "instructor/quiz-form";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/instructor/courses";
        }
    }

    /**
     * Xử lý tạo bài kiểm tra mới
     */
    @PostMapping("/courses/{courseId}/quizzes")
    public String createQuiz(@PathVariable Long courseId,
                             @Valid @ModelAttribute("quiz") Quiz quiz,
                             BindingResult bindingResult,
                             Model model,
                             Authentication authentication,
                             RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            Course course = courseService.findByIdAndInstructor(courseId, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học hoặc bạn không có quyền truy cập"));

            if (bindingResult.hasErrors()) {
                model.addAttribute("course", course);
                return "instructor/quiz-form";
            }

            quiz.setCourse(course);
            Quiz createdQuiz = quizService.createQuiz(quiz);

            redirectAttributes.addFlashAttribute("message",
                    "Tạo bài kiểm tra thành công: " + createdQuiz.getTitle());

            return "redirect:/instructor/courses/" + courseId + "/quizzes/" + createdQuiz.getId() + "/questions";

        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            Course course = courseService.findById(courseId).orElse(null);
            model.addAttribute("course", course);
            return "instructor/quiz-form";
        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tạo bài kiểm tra");
            Course course = courseService.findById(courseId).orElse(null);
            model.addAttribute("course", course);
            return "instructor/quiz-form";
        }
    }

    /**
     * Chi tiết bài kiểm tra và quản lý câu hỏi
     */
    @GetMapping("/courses/{courseId}/quizzes/{quizId}")
    public String viewQuiz(@PathVariable Long courseId,
                           @PathVariable Long quizId,
                           Model model,
                           Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            Course course = courseService.findByIdAndInstructor(courseId, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học hoặc bạn không có quyền truy cập"));

            Quiz quiz = quizService.findByIdAndCourse(quizId, course)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy bài kiểm tra"));

            model.addAttribute("course", course);
            model.addAttribute("quiz", quiz);
            model.addAttribute("questions", quizService.findQuestionsByQuiz(quiz));

            // Thống kê bài kiểm tra
            QuizService.QuizStats stats = quizService.getQuizStatistics(quiz);
            model.addAttribute("quizStats", stats);

            // Kết quả học viên
            model.addAttribute("quizResults", quizService.findQuizResultsByQuiz(quiz));

            return "instructor/quiz-detail";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/instructor/courses/" + courseId + "/quizzes";
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