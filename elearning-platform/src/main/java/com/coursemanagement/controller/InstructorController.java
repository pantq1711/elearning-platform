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

            // Thống kê theo tháng (cho chart)
            model.addAttribute("monthlyStats", enrollmentService.getMonthlyStatsByInstructor(currentUser));

            return "instructor/dashboard";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tải dashboard: " + e.getMessage());
            return "instructor/dashboard";
        }
    }

    /**
     * Danh sách khóa học của instructor
     */
    @GetMapping("/courses")
    public String listCourses(@RequestParam(value = "search", required = false) String search,
                              @RequestParam(value = "category", required = false) Long categoryId,
                              @RequestParam(value = "status", required = false) String status,
                              Model model,
                              Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            // Lấy danh sách khóa học với filter
            List<Course> courses = courseService.findCoursesByInstructorWithFilter(
                    currentUser, search, categoryId, status);

            model.addAttribute("courses", courses);
            model.addAttribute("search", search);
            model.addAttribute("selectedCategory", categoryId);
            model.addAttribute("selectedStatus", status);
            model.addAttribute("categories", categoryService.findAllOrderByName());

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
    public String newCourseForm(Model model, Authentication authentication) {
        User currentUser = (User) authentication.getPrincipal();
        model.addAttribute("currentUser", currentUser);

        model.addAttribute("course", new Course());
        model.addAttribute("categories", categoryService.findAllOrderByName());
        model.addAttribute("difficulties", Course.DifficultyLevel.values());

        return "instructor/course-form";
    }

    /**
     * Xử lý tạo khóa học mới
     */
    @PostMapping("/courses")
    public String createCourse(@Valid @ModelAttribute("course") Course course,
                               BindingResult result,
                               @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                               Model model,
                               Authentication authentication,
                               RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) authentication.getPrincipal();

            if (result.hasErrors()) {
                model.addAttribute("currentUser", currentUser);
                model.addAttribute("categories", categoryService.findAllOrderByName());
                model.addAttribute("difficulties", Course.DifficultyLevel.values());
                return "instructor/course-form";
            }

            // Set instructor cho khóa học
            course.setInstructor(currentUser);

            // Xử lý upload image nếu có
            if (imageFile != null && !imageFile.isEmpty()) {
                String imageUrl = courseService.uploadCourseImage(imageFile);
                course.setImageUrl(imageUrl);
            }

            // Tạo khóa học
            Course createdCourse = courseService.createCourse(course);

            redirectAttributes.addFlashAttribute("message",
                    "Tạo khóa học thành công: " + createdCourse.getN());

            return "redirect:/instructor/courses/" + createdCourse.getId();

        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("currentUser", (User) authentication.getPrincipal());
            model.addAttribute("categories", categoryService.findAllOrderByName());
            model.addAttribute("difficulties", Course.DifficultyLevel.values());
            return "instructor/course-form";
        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tạo khóa học");
            model.addAttribute("currentUser", (User) authentication.getPrincipal());
            model.addAttribute("categories", categoryService.findAllOrderByName());
            model.addAttribute("difficulties", Course.DifficultyLevel.values());
            return "instructor/course-form";
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
            Long enrollmentCount = enrollmentService.countEnrollmentsByCourse(course);
            Long lessonCount = lessonService.countLessonsByCourse(course);
            Long quizCount = quizService.countQuizzesByCourse(course);
            Double averageRating = courseService.getAverageRating(course);

            model.addAttribute("enrollmentCount", enrollmentCount);
            model.addAttribute("lessonCount", lessonCount);
            model.addAttribute("quizCount", quizCount);
            model.addAttribute("averageRating", averageRating);

            // Danh sách bài giảng
            List<Lesson> lessons = lessonService.findByCourseOrderByOrderIndex(course);
            model.addAttribute("lessons", lessons);

            // Học viên gần đây
            List<Enrollment> recentEnrollments = enrollmentService.getRecentEnrollmentsByCourse(course, 10);
            model.addAttribute("recentEnrollments", recentEnrollments);

            return "instructor/course-detail";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/instructor/courses";
        }
    }

    /**
     * Form chỉnh sửa khóa học
     */
    @GetMapping("/courses/{id}/edit")
    public String editCourseForm(@PathVariable Long id,
                                 Model model,
                                 Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            Course course = courseService.findByIdAndInstructor(id, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học hoặc bạn không có quyền truy cập"));

            model.addAttribute("course", course);
            model.addAttribute("categories", categoryService.findAllOrderByName());
            model.addAttribute("difficulties", Course.DifficultyLevel.values());

            return "instructor/course-edit";

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
                               BindingResult result,
                               @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                               Model model,
                               Authentication authentication,
                               RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) authentication.getPrincipal();

            if (result.hasErrors()) {
                model.addAttribute("currentUser", currentUser);
                model.addAttribute("categories", categoryService.findAllOrderByName());
                model.addAttribute("difficulties", Course.DifficultyLevel.values());
                return "instructor/course-edit";
            }

            // Kiểm tra quyền sở hữu khóa học
            Course existingCourse = courseService.findByIdAndInstructor(id, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học hoặc bạn không có quyền truy cập"));

            // Cập nhật thông tin
            course.setId(id);
            course.setInstructor(currentUser);

            // Xử lý upload image mới nếu có
            if (imageFile != null && !imageFile.isEmpty()) {
                String imageUrl = courseService.uploadCourseImage(imageFile);
                course.setImageUrl(imageUrl);
            } else {
                // Giữ nguyên image cũ
                course.setImageUrl(existingCourse.getImageUrl());
            }

            // Cập nhật khóa học
            Course updatedCourse = courseService.updateCourse(course);

            redirectAttributes.addFlashAttribute("message",
                    "Cập nhật khóa học thành công!");

            return "redirect:/instructor/courses/" + updatedCourse.getId();

        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("currentUser", (User) authentication.getPrincipal());
            model.addAttribute("categories", categoryService.findAllOrderByName());
            model.addAttribute("difficulties", Course.DifficultyLevel.values());
            return "instructor/course-edit";
        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi cập nhật khóa học");
            model.addAttribute("currentUser", (User) authentication.getPrincipal());
            model.addAttribute("categories", categoryService.findAllOrderByName());
            model.addAttribute("difficulties", Course.DifficultyLevel.values());
            return "instructor/course-edit";
        }
    }

    /**
     * Xóa khóa học (soft delete)
     */
    @PostMapping("/courses/{id}/delete")
    public String deleteCourse(@PathVariable Long id,
                               Authentication authentication,
                               RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) authentication.getPrincipal();

            Course course = courseService.findByIdAndInstructor(id, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học hoặc bạn không có quyền truy cập"));

            // Kiểm tra xem có học viên đã đăng ký không
            Long enrollmentCount = enrollmentService.countEnrollmentsByCourse(course);
            if (enrollmentCount > 0) {
                redirectAttributes.addFlashAttribute("error",
                        "Không thể xóa khóa học đã có học viên đăng ký. Vui lòng tắt kích hoạt thay vì xóa.");
                return "redirect:/instructor/courses/" + id;
            }

            // Thực hiện soft delete
            courseService.softDeleteCourse(id);

            redirectAttributes.addFlashAttribute("message",
                    "Đã xóa khóa học: " + course.getN());

            return "redirect:/instructor/courses";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Có lỗi xảy ra khi xóa khóa học: " + e.getMessage());
            return "redirect:/instructor/courses";
        }
    }

    /**
     * Danh sách bài giảng của một khóa học
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

            List<Lesson> lessons = lessonService.findByCourseOrderByOrderIndex(course);
            model.addAttribute("lessons", lessons);

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
    public String newLessonForm(@PathVariable Long courseId,
                                Model model,
                                Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            model.addAttribute("currentUser", currentUser);

            Course course = courseService.findByIdAndInstructor(courseId, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học hoặc bạn không có quyền truy cập"));

            model.addAttribute("course", course);
            model.addAttribute("lesson", new Lesson());

            // Tính order index tiếp theo
            Integer nextOrderIndex = lessonService.getNextOrderIndex(course);
            model.addAttribute("nextOrderIndex", nextOrderIndex);

            return "instructor/lesson-form";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/instructor/courses/" + courseId + "/lessons";
        }
    }

    /**
     * Xử lý tạo bài giảng mới
     */
    @PostMapping("/courses/{courseId}/lessons")
    public String createLesson(@PathVariable Long courseId,
                               @Valid @ModelAttribute("lesson") Lesson lesson,
                               BindingResult result,
                               @RequestParam(value = "documentFile", required = false) MultipartFile documentFile,
                               Model model,
                               Authentication authentication,
                               RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) authentication.getPrincipal();

            if (result.hasErrors()) {
                Course course = courseService.findByIdAndInstructor(courseId, currentUser).orElse(null);
                model.addAttribute("currentUser", currentUser);
                model.addAttribute("course", course);
                model.addAttribute("nextOrderIndex", lessonService.getNextOrderIndex(course));
                return "instructor/lesson-form";
            }

            Course course = courseService.findByIdAndInstructor(courseId, currentUser)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học hoặc bạn không có quyền truy cập"));

            // Set course cho lesson
            lesson.setCourse(course);

            // Xử lý upload document nếu có
            if (documentFile != null && !documentFile.isEmpty()) {
                String documentUrl = lessonService.uploadLessonDocument(documentFile);
                lesson.setDocumentUrl(documentUrl);
            }

            // Tạo bài giảng
            Lesson createdLesson = lessonService.createLesson(lesson);

            redirectAttributes.addFlashAttribute("message",
                    "Tạo bài giảng thành công: " + createdLesson.getTitle());

            return "redirect:/instructor/courses/" + courseId + "/lessons";

        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            Course course = courseService.findById(courseId).orElse(null);
            model.addAttribute("course", course);
            model.addAttribute("currentUser", (User) authentication.getPrincipal());
            return "instructor/lesson-form";
        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tạo bài giảng");
            Course course = courseService.findById(courseId).orElse(null);
            model.addAttribute("course", course);
            model.addAttribute("currentUser", (User) authentication.getPrincipal());
            return "instructor/lesson-form";
        }
    }

    /**
     * Exception handler cho controller này
     */
    @ExceptionHandler(Exception.class)
    public String handleException(Exception e, Model model) {
        System.err.println("Lỗi trong InstructorController: " + e.getMessage());
        e.printStackTrace();

        model.addAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        return "error/500";
    }
}