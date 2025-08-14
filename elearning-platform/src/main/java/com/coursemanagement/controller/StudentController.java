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
            model.addAttribute("error", "Có lỗi xảy ra khi tải dashboard: " + e.getMessage());
            return "error/500";
        }
    }

    /**
     * Danh sách khóa học đã đăng ký
     */
    @GetMapping("/my-courses")
    public String myCourses(Model model, Authentication authentication,
                            @RequestParam(required = false, defaultValue = "all") String filter) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            List<Enrollment> enrollments;
            switch (filter) {
                case "active":
                    enrollments = enrollmentService.findActiveEnrollmentsByStudent(currentUser);
                    break;
                case "completed":
                    enrollments = enrollmentService.findCompletedEnrollmentsByStudent(currentUser);
                    break;
                default:
                    enrollments = enrollmentService.findEnrollmentsByStudent(currentUser);
                    break;
            }

            model.addAttribute("enrollments", enrollments);
            model.addAttribute("currentFilter", filter);

            // Thống kê
            EnrollmentService.EnrollmentStats stats = enrollmentService.getStudentStats(currentUser);
            model.addAttribute("stats", stats);

            return "student/my-courses";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải khóa học: " + e.getMessage());
            return "error/500";
        }
    }

    /**
     * Trang browse courses để đăng ký
     */
    @GetMapping("/browse")
    public String browse(Model model, Authentication authentication,
                         @RequestParam(required = false) Long categoryId,
                         @RequestParam(required = false) String search) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            // Lấy danh sách categories
            List<Category> categories = categoryService.findAllOrderByName();
            model.addAttribute("categories", categories);

            // Lấy courses theo filter
            List<Course> courses;
            if (search != null && !search.trim().isEmpty()) {
                courses = courseService.searchCoursesByName(search.trim());
                model.addAttribute("searchQuery", search);
            } else if (categoryId != null) {
                courses = courseService.findActiveCoursesByCategory(categoryId);
                Category selectedCategory = categoryService.findById(categoryId).orElse(null);
                model.addAttribute("selectedCategory", selectedCategory);
            } else {
                courses = courseService.findAvailableCoursesForStudent(currentUser.getId());
            }

            // Thêm thông tin thống kê cho mỗi course
            for (Course course : courses) {
                long lessonCount = lessonService.countActiveLessonsByCourse(course);
                long quizCount = quizService.countActiveQuizzesByCourse(course);
                course.setLessonCount((int) lessonCount);
                course.setQuizCount((int) quizCount);
            }

            model.addAttribute("courses", courses);
            model.addAttribute("selectedCategoryId", categoryId);

            return "student/browse";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải khóa học: " + e.getMessage());
            return "error/500";
        }
    }

    /**
     * Chi tiết course cho student
     */
    @GetMapping("/course/{id}")
    public String courseDetail(@PathVariable Long id,
                               Model model,
                               Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            Course course = courseService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học"));

            model.addAttribute("course", course);
            model.addAttribute("currentUser", currentUser);

            // Kiểm tra đã đăng ký chưa
            boolean isEnrolled = enrollmentService.isStudentEnrolled(currentUser, course);
            model.addAttribute("isEnrolled", isEnrolled);

            if (isEnrolled) {
                // Lấy enrollment để hiển thị progress
                Optional<Enrollment> enrollment = enrollmentService.findByStudentAndCourse(currentUser, course);
                model.addAttribute("enrollment", enrollment.orElse(null));

                // Lấy tất cả lessons
                List<Lesson> lessons = lessonService.findActiveLessonsByCourse(course);
                model.addAttribute("lessons", lessons);
            } else {
                // Chỉ hiển thị preview lessons
                List<Lesson> previewLessons = lessonService.findActiveLessonsByCourse(course)
                        .stream()
                        .filter(Lesson::isPreview)
                        .toList();
                model.addAttribute("lessons", previewLessons);
            }

            // Quizzes của course
            List<Quiz> quizzes = quizService.findActiveQuizzesByCourse(course);
            model.addAttribute("quizzes", quizzes);

            // Thống kê course
            long totalLessons = lessonService.countActiveLessonsByCourse(course);
            long totalQuizzes = quizService.countActiveQuizzesByCourse(course);
            model.addAttribute("totalLessons", totalLessons);
            model.addAttribute("totalQuizzes", totalQuizzes);

            return "student/course-detail";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "error/404";
        }
    }

    /**
     * Đăng ký khóa học
     */
    @GetMapping("/courses/{courseId}/enroll")
    public String enrollCourse(@PathVariable Long courseId, Authentication authentication,
                               RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) authentication.getPrincipal();

            // SỬA LỖI: Truyền currentUser.getId() thay vì currentUser
            Enrollment enrollment = enrollmentService.enrollStudent(currentUser.getId(), courseId);

            redirectAttributes.addFlashAttribute("message",
                    "Đăng ký khóa học thành công!");
            return "redirect:/student/courses/" + courseId;

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/courses";
        }
    }

    /**
     * Hủy đăng ký khóa học
     */
    @PostMapping("/unenroll/{courseId}")
    public String unenrollCourse(@PathVariable Long courseId,
                                 Authentication authentication,
                                 RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            Course course = courseService.findById(courseId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học"));

            enrollmentService.unenrollStudent(currentUser, course);
            redirectAttributes.addFlashAttribute("success", "Hủy đăng ký khóa học thành công!");
            return "redirect:/student/my-courses";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi hủy đăng ký: " + e.getMessage());
            return "redirect:/student/my-courses";
        }
    }

    /**
     * Xem lesson
     */
    @GetMapping("/lesson/{id}")
    public String viewLesson(@PathVariable Long id,
                             Model model,
                             Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            Lesson lesson = lessonService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy bài học"));

            // Kiểm tra quyền truy cập
            boolean hasAccess = lesson.isPreview() ||
                    enrollmentService.isStudentEnrolled(currentUser, lesson.getCourse());

            if (!hasAccess) {
                throw new RuntimeException("Bạn cần đăng ký khóa học để xem bài học này");
            }

            model.addAttribute("lesson", lesson);
            model.addAttribute("course", lesson.getCourse());

            // Navigation lessons
            Optional<Lesson> previousLesson = lessonService.findPreviousLesson(lesson);
            Optional<Lesson> nextLesson = lessonService.findNextLesson(lesson);

            model.addAttribute("previousLesson", previousLesson.orElse(null));
            model.addAttribute("nextLesson", nextLesson.orElse(null));

            // Enrollment info nếu đã đăng ký
            if (enrollmentService.isStudentEnrolled(currentUser, lesson.getCourse())) {
                Optional<Enrollment> enrollment = enrollmentService.findByStudentAndCourse(currentUser, lesson.getCourse());
                model.addAttribute("enrollment", enrollment.orElse(null));
            }

            return "student/lesson-view";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "error/404";
        }
    }

    /**
     * Danh sách quizzes available
     */
    @GetMapping("/quizzes")
    public String quizzes(Model model, Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            // Available quizzes (chưa làm hoặc chưa pass)
            List<Quiz> availableQuizzes = quizService.findAvailableQuizzesForStudent(currentUser);
            model.addAttribute("availableQuizzes", availableQuizzes);

            // Completed quizzes (đã pass)
            List<Quiz> completedQuizzes = quizService.findCompletedQuizzesForStudent(currentUser);
            model.addAttribute("completedQuizzes", completedQuizzes);

            // Quiz results
            List<QuizResult> quizResults = quizService.findQuizResultsByStudent(currentUser);
            model.addAttribute("quizResults", quizResults);

            return "student/quizzes";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải bài kiểm tra: " + e.getMessage());
            return "error/500";
        }
    }

    /**
     * Làm quiz
     */
    @GetMapping("/quiz/{id}")
    public String takeQuiz(@PathVariable Long id,
                           Model model,
                           Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            Quiz quiz = quizService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy bài kiểm tra"));

            // Kiểm tra quyền truy cập
            if (!enrollmentService.isStudentEnrolled(currentUser, quiz.getCourse())) {
                throw new RuntimeException("Bạn cần đăng ký khóa học để làm bài kiểm tra này");
            }

            // Kiểm tra đã làm chưa
            boolean hasTaken = quizService.hasStudentTakenQuiz(currentUser, quiz);
            if (hasTaken) {
                // Hiển thị kết quả
                Optional<QuizResult> result = quizService.findQuizResult(currentUser, quiz);
                model.addAttribute("quizResult", result.orElse(null));
                return "student/quiz-result";
            }

            model.addAttribute("quiz", quiz);
            model.addAttribute("course", quiz.getCourse());

            // Start quiz attempt
            QuizResult quizResult = quizService.startQuiz(currentUser, quiz);
            model.addAttribute("quizResult", quizResult);

            return "student/take-quiz";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "error/404";
        }
    }

    /**
     * Submit quiz
     */
    @PostMapping("/quiz/{id}/submit")
    public String submitQuiz(@PathVariable Long id,
                             @RequestParam Map<String, String> answers,
                             Authentication authentication,
                             RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            Quiz quiz = quizService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy bài kiểm tra"));

            // Convert answers to proper format
            Map<Long, String> quizAnswers = new HashMap<>();
            for (Map.Entry<String, String> entry : answers.entrySet()) {
                if (entry.getKey().startsWith("question_")) {
                    Long questionId = Long.parseLong(entry.getKey().replace("question_", ""));
                    quizAnswers.put(questionId, entry.getValue());
                }
            }

            QuizResult result = quizService.submitQuiz(currentUser, quiz, quizAnswers);

            redirectAttributes.addFlashAttribute("success", "Nộp bài thành công! Điểm của bạn: " + result.getScore());
            return "redirect:/student/quiz/" + id + "/result";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi nộp bài: " + e.getMessage());
            return "redirect:/student/quiz/" + id;
        }
    }

    /**
     * Xem kết quả quiz
     */
    @GetMapping("/quiz/{id}/result")
    public String quizResult(@PathVariable Long id,
                             Model model,
                             Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            Quiz quiz = quizService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy bài kiểm tra"));

            Optional<QuizResult> result = quizService.findQuizResult(currentUser, quiz);
            if (result.isEmpty()) {
                throw new RuntimeException("Bạn chưa làm bài kiểm tra này");
            }

            model.addAttribute("quiz", quiz);
            model.addAttribute("quizResult", result.get());
            model.addAttribute("course", quiz.getCourse());

            return "student/quiz-result";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "error/404";
        }
    }

    /**
     * Thống kê học tập của student
     */
    @GetMapping("/statistics")
    public String statistics(Model model, Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            // Enrollment stats
            EnrollmentService.EnrollmentStats enrollmentStats = enrollmentService.getStudentStats(currentUser);
            model.addAttribute("enrollmentStats", enrollmentStats);

            // Quiz results với scores
            List<Enrollment> enrollmentsWithScores = enrollmentService.findEnrollmentsWithScoresByStudent(currentUser);
            model.addAttribute("enrollmentsWithScores", enrollmentsWithScores);

            // Recent quiz results
            List<QuizResult> recentQuizResults = quizService.findQuizResultsByStudent(currentUser);
            model.addAttribute("recentQuizResults", recentQuizResults);

            // Course completion stats
            List<Enrollment> allEnrollments = enrollmentService.findEnrollmentsByStudent(currentUser);
            Map<String, Object> completionStats = new HashMap<>();
            completionStats.put("totalEnrollments", allEnrollments.size());
            completionStats.put("completedEnrollments", allEnrollments.stream().mapToLong(e -> e.isCompleted() ? 1 : 0).sum());
            completionStats.put("averageProgress", allEnrollments.stream().mapToDouble(Enrollment::getProgress).average().orElse(0.0));

            model.addAttribute("completionStats", completionStats);

            return "student/statistics";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải thống kê: " + e.getMessage());
            return "error/500";
        }
    }
}