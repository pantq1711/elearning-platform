package com.coursemanagement.controller;

import com.coursemanagement.entity.*;
import com.coursemanagement.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Controller xử lý các chức năng dành cho Student (Học viên)
 * Chỉ người dùng có role STUDENT mới truy cập được
 */
@Controller
@RequestMapping("/student")
@PreAuthorize("hasRole('STUDENT')")
public class StudentController {

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
     * Dashboard học viên - trang tổng quan
     */
    @GetMapping("/dashboard")
    public String dashboard(Model model, Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            // Thống kê tổng quan của học viên
            EnrollmentService.EnrollmentStats stats = enrollmentService.getStudentStats(currentUser);
            model.addAttribute("enrollmentStats", stats);

            // Khóa học đang học
            List<Enrollment> activeEnrollments = enrollmentService.findActiveEnrollmentsByStudent(currentUser);
            model.addAttribute("activeEnrollments", activeEnrollments);

            // Khóa học đã hoàn thành
            List<Enrollment> completedEnrollments = enrollmentService.findCompletedEnrollmentsByStudent(currentUser);
            model.addAttribute("completedEnrollments", completedEnrollments.stream().limit(5).toList());

            // Khóa học có thể đăng ký
            List<Course> availableCourses = courseService.findAvailableCoursesForStudent(currentUser.getId());
            model.addAttribute("suggestedCourses", availableCourses.stream().limit(6).toList());

            // Kết quả quiz gần đây
            List<QuizResult> recentQuizResults = quizService.findQuizResultsByStudent(currentUser);
            model.addAttribute("recentQuizResults", recentQuizResults.stream().limit(5).toList());

            return "student/dashboard";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải dashboard");
            return "error/500";
        }
    }

    // =============== TÌM KIẾM VÀ ĐĂNG KÝ KHÓA HỌC ===============

    /**
     * Danh sách tất cả khóa học có thể đăng ký
     */
    @GetMapping("/courses")
    public String listAvailableCourses(@RequestParam(value = "search", required = false) String search,
                                       @RequestParam(value = "category", required = false) Long categoryId,
                                       Model model,
                                       Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            List<Course> courses;

            if (search != null && !search.trim().isEmpty()) {
                courses = courseService.searchCourses(search);
            } else if (categoryId != null) {
                Category category = categoryService.findById(categoryId).orElse(null);
                if (category != null) {
                    courses = courseService.findActiveCoursesByCategory(category);
                } else {
                    courses = courseService.findAllActiveCourses();
                }
            } else {
                courses = courseService.findAllActiveCourses();
            }

            // Lọc ra những khóa học chưa đăng ký
            List<Course> availableCourses = courses.stream()
                    .filter(course -> !enrollmentService.isStudentEnrolled(currentUser, course))
                    .toList();

            model.addAttribute("courses", availableCourses);
            model.addAttribute("search", search);
            model.addAttribute("selectedCategory", categoryId);
            model.addAttribute("categories", categoryService.findCategoriesWithCourses());

            return "student/courses";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải danh sách khóa học");
            return "student/courses";
        }
    }

    /**
     * Chi tiết khóa học trước khi đăng ký
     */
    @GetMapping("/courses/{id}")
    public String viewCourseDetail(@PathVariable Long id,
                                   Model model,
                                   Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            Course course = courseService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học"));

            if (!course.isActive()) {
                model.addAttribute("error", "Khóa học hiện tại không khả dụng");
                return "redirect:/student/courses";
            }

            model.addAttribute("course", course);

            // Kiểm tra đã đăng ký chưa
            boolean isEnrolled = enrollmentService.isStudentEnrolled(currentUser, course);
            model.addAttribute("isEnrolled", isEnrolled);

            // Thống kê khóa học
            model.addAttribute("enrollmentCount", enrollmentService.countEnrollmentsByCourse(course));
            model.addAttribute("lessonCount", lessonService.countActiveLessonsByCourse(course));
            model.addAttribute("quizCount", quizService.countActiveQuizzesByCourse(course));

            // Nếu đã đăng ký, hiển thị tiến độ
            if (isEnrolled) {
                Optional<Enrollment> enrollmentOpt = enrollmentService.findByStudentAndCourse(currentUser, course);
                if (enrollmentOpt.isPresent()) {
                    model.addAttribute("enrollment", enrollmentOpt.get());
                }
            }

            return "student/course-detail";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/student/courses";
        }
    }

    /**
     * Đăng ký khóa học
     */
    @PostMapping("/courses/{id}/enroll")
    public String enrollCourse(@PathVariable Long id,
                               Authentication authentication,
                               RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) authentication.getPrincipal();

            Course course = courseService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học"));

            Enrollment enrollment = enrollmentService.enrollStudent(currentUser, course);

            redirectAttributes.addFlashAttribute("message",
                    "Đăng ký khóa học thành công: " + course.getName());

            return "redirect:/student/my-courses";

        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/student/courses/" + id;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra khi đăng ký khóa học");
            return "redirect:/student/courses/" + id;
        }
    }

    // =============== KHÓA HỌC ĐÃ ĐĂNG KÝ ===============

    /**
     * Danh sách khóa học đã đăng ký
     */
    @GetMapping("/my-courses")
    public String listMyCourses(@RequestParam(value = "status", required = false) String status,
                                Model model,
                                Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            List<Enrollment> enrollments;

            if ("completed".equals(status)) {
                enrollments = enrollmentService.findCompletedEnrollmentsByStudent(currentUser);
            } else if ("active".equals(status)) {
                enrollments = enrollmentService.findActiveEnrollmentsByStudent(currentUser);
            } else {
                enrollments = enrollmentService.findEnrollmentsByStudent(currentUser);
            }

            model.addAttribute("enrollments", enrollments);
            model.addAttribute("selectedStatus", status);

            return "student/my-courses";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải danh sách khóa học");
            return "student/my-courses";
        }
    }

    /**
     * Học bài - xem chi tiết khóa học đã đăng ký
     */
    @GetMapping("/my-courses/{id}")
    public String studyCourse(@PathVariable Long id,
                              Model model,
                              Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            Course course = courseService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học"));

            // Kiểm tra đã đăng ký chưa
            if (!enrollmentService.isStudentEnrolled(currentUser, course)) {
                throw new RuntimeException("Bạn chưa đăng ký khóa học này");
            }

            model.addAttribute("course", course);

            // Thông tin đăng ký
            Optional<Enrollment> enrollmentOpt = enrollmentService.findByStudentAndCourse(currentUser, course);
            if (enrollmentOpt.isPresent()) {
                model.addAttribute("enrollment", enrollmentOpt.get());
            }

            // Danh sách bài giảng
            List<Lesson> lessons = lessonService.findActiveLessonsByCourse(course);
            model.addAttribute("lessons", lessons);

            // Danh sách bài kiểm tra
            List<Quiz> availableQuizzes = quizService.findAvailableQuizzesForStudent(course, currentUser.getId());
            List<Quiz> completedQuizzes = quizService.findCompletedQuizzesForStudent(course, currentUser.getId());

            model.addAttribute("availableQuizzes", availableQuizzes);
            model.addAttribute("completedQuizzes", completedQuizzes);

            return "student/study-course";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/student/my-courses";
        }
    }

    /**
     * Xem bài giảng
     */
    @GetMapping("/my-courses/{courseId}/lessons/{lessonId}")
    public String viewLesson(@PathVariable Long courseId,
                             @PathVariable Long lessonId,
                             Model model,
                             Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            Course course = courseService.findById(courseId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học"));

            // Kiểm tra đã đăng ký chưa
            if (!enrollmentService.isStudentEnrolled(currentUser, course)) {
                throw new RuntimeException("Bạn chưa đăng ký khóa học này");
            }

            Lesson lesson = lessonService.findByIdAndCourse(lessonId, course)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy bài giảng"));

            if (!lesson.isActive()) {
                throw new RuntimeException("Bài giảng hiện tại không khả dụng");
            }

            model.addAttribute("course", course);
            model.addAttribute("lesson", lesson);

            // Tìm bài giảng trước và sau
            Optional<Lesson> previousLesson = lessonService.findPreviousLesson(course, lesson.getOrderIndex());
            Optional<Lesson> nextLesson = lessonService.findNextLesson(course, lesson.getOrderIndex());

            model.addAttribute("previousLesson", previousLesson.orElse(null));
            model.addAttribute("nextLesson", nextLesson.orElse(null));

            return "student/lesson-view";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/student/my-courses/" + courseId;
        }
    }

    // =============== BÀI KIỂM TRA ===============

    /**
     * Bắt đầu làm bài kiểm tra
     */
    @GetMapping("/my-courses/{courseId}/quizzes/{quizId}")
    public String startQuiz(@PathVariable Long courseId,
                            @PathVariable Long quizId,
                            Model model,
                            Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            Course course = courseService.findById(courseId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học"));

            // Kiểm tra đã đăng ký chưa
            if (!enrollmentService.isStudentEnrolled(currentUser, course)) {
                throw new RuntimeException("Bạn chưa đăng ký khóa học này");
            }

            Quiz quiz = quizService.findByIdAndCourse(quizId, course)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy bài kiểm tra"));

            // Kiểm tra đã làm bài chưa
            if (quizService.hasStudentTakenQuiz(quiz, currentUser)) {
                // Nếu đã làm, hiển thị kết quả
                return "redirect:/student/my-courses/" + courseId + "/quizzes/" + quizId + "/result";
            }

            // Bắt đầu làm bài
            QuizResult quizResult = quizService.startQuiz(quiz, currentUser);

            model.addAttribute("course", course);
            model.addAttribute("quiz", quiz);
            model.addAttribute("quizResult", quizResult);
            model.addAttribute("questions", quizService.findQuestionsByQuiz(quiz));

            return "student/quiz-take";

        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/student/my-courses/" + courseId;
        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi bắt đầu bài kiểm tra");
            return "redirect:/student/my-courses/" + courseId;
        }
    }

    /**
     * Nộp bài kiểm tra
     */
    @PostMapping("/my-courses/{courseId}/quizzes/{quizId}/submit")
    public String submitQuiz(@PathVariable Long courseId,
                             @PathVariable Long quizId,
                             @RequestParam Map<String, String> answers,
                             Authentication authentication,
                             RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) authentication.getPrincipal();

            Quiz quiz = quizService.findById(quizId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy bài kiểm tra"));

            // Tìm quiz result hiện tại
            Optional<QuizResult> quizResultOpt = quizService.findQuizResult(quiz, currentUser);
            if (quizResultOpt.isEmpty()) {
                throw new RuntimeException("Không tìm thấy phiên làm bài");
            }

            QuizResult quizResult = quizResultOpt.get();

            // Chuyển đổi answers sang định dạng Map<Long, String>
            Map<Long, String> questionAnswers = new HashMap<>();
            for (Map.Entry<String, String> entry : answers.entrySet()) {
                if (entry.getKey().startsWith("question_")) {
                    Long questionId = Long.valueOf(entry.getKey().substring(9)); // Bỏ "question_"
                    questionAnswers.put(questionId, entry.getValue());
                }
            }

            // Nộp bài
            QuizResult result = quizService.submitQuiz(quizResult.getId(), questionAnswers);

            redirectAttributes.addFlashAttribute("message",
                    "Nộp bài thành công! Điểm của bạn: " + result.getScoreText() + " - " + result.getResultText());

            return "redirect:/student/my-courses/" + courseId + "/quizzes/" + quizId + "/result";

        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/student/my-courses/" + courseId;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra khi nộp bài");
            return "redirect:/student/my-courses/" + courseId;
        }
    }

    /**
     * Xem kết quả bài kiểm tra
     */
    @GetMapping("/my-courses/{courseId}/quizzes/{quizId}/result")
    public String viewQuizResult(@PathVariable Long courseId,
                                 @PathVariable Long quizId,
                                 Model model,
                                 Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            Course course = courseService.findById(courseId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học"));

            Quiz quiz = quizService.findByIdAndCourse(quizId, course)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy bài kiểm tra"));

            Optional<QuizResult> quizResultOpt = quizService.findQuizResult(quiz, currentUser);
            if (quizResultOpt.isEmpty()) {
                throw new RuntimeException("Bạn chưa làm bài kiểm tra này");
            }

            QuizResult quizResult = quizResultOpt.get();

            model.addAttribute("course", course);
            model.addAttribute("quiz", quiz);
            model.addAttribute("quizResult", quizResult);

            return "student/quiz-result";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/student/my-courses/" + courseId;
        }
    }

    /**
     * Hủy đăng ký khóa học
     */
    @PostMapping("/my-courses/{id}/unenroll")
    public String unenrollCourse(@PathVariable Long id,
                                 Authentication authentication,
                                 RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) authentication.getPrincipal();

            Course course = courseService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học"));

            enrollmentService.unenrollStudent(currentUser, course);

            redirectAttributes.addFlashAttribute("message",
                    "Hủy đăng ký khóa học thành công: " + course.getName());

            return "redirect:/student/my-courses";

        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/student/my-courses";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra khi hủy đăng ký");
            return "redirect:/student/my-courses";
        }
    }

    /**
     * Trang kết quả học tập
     */
    @GetMapping("/results")
    public String viewResults(Model model, Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            // Thống kê tổng quan
            EnrollmentService.EnrollmentStats stats = enrollmentService.getStudentStats(currentUser);
            model.addAttribute("enrollmentStats", stats);

            // Tất cả kết quả quiz
            List<QuizResult> quizResults = quizService.findQuizResultsByStudent(currentUser);
            model.addAttribute("quizResults", quizResults);

            // Khóa học có điểm
            List<Enrollment> enrollmentsWithScores = enrollmentService.findEnrollmentsWithScoresByStudent(currentUser);
            model.addAttribute("enrollmentsWithScores", enrollmentsWithScores);

            return "student/results";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải kết quả học tập");
            return "student/results";
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