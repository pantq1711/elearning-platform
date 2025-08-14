package com.coursemanagement.controller;

import com.coursemanagement.dto.*;
import com.coursemanagement.entity.*;
import com.coursemanagement.service.*;
import com.coursemanagement.utils.CourseUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.util.Map;
import java.util.HashMap;
import org.springframework.http.ResponseEntity;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * REST API Controller cho mobile app và AJAX requests
 * Cung cấp endpoints cho tất cả các chức năng chính
 */
@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*", maxAge = 3600)
public class ApiController {

    /**
     * Kiểm tra enrollment status
     */
    @GetMapping("/enrollments/check")
    @ResponseBody
    public ResponseEntity<Map<String, Boolean>> checkEnrollment(
            @RequestParam Long studentId,
            @RequestParam Long courseId) {
        try {
            boolean isEnrolled = enrollmentService.isEnrolled(studentId, courseId);
            Map<String, Boolean> response = new HashMap<>();
            response.put("enrolled", isEnrolled);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Boolean> response = new HashMap<>();
            response.put("enrolled", false);
            return ResponseEntity.ok(response);
        }
    }

    /**
     * Tạo enrollment mới
     */
    @PostMapping("/enrollments")
    @ResponseBody
    public ResponseEntity<?> createEnrollment(
            @RequestParam Long studentId,
            @RequestParam Long courseId) {
        try {
            Enrollment enrollment = enrollmentService.createEnrollment(studentId, courseId);
            return ResponseEntity.ok(enrollment);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }

    @Autowired
    private CourseService courseService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private UserService userService;

    @Autowired
    private LessonService lessonService;

    @Autowired
    private QuizService quizService;

    @Autowired
    private EnrollmentService enrollmentService;

    // ==================== COURSE ENDPOINTS ====================

    /**
     * Lấy danh sách tất cả khóa học với filter và pagination
     */
    @GetMapping("/courses")
    public ResponseEntity<ApiResponse<Page<CourseDto>>> getAllCourses(
            @RequestParam(defaultValue = "") String search,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String difficulty,
            @RequestParam(required = false) Boolean featured,
            @RequestParam(required = false) Double minPrice,
            @RequestParam(required = false) Double maxPrice,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "12") int size,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir) {
        try {
            // Tạo Pageable
            Sort.Direction direction = "asc".equalsIgnoreCase(sortDir) ?
                    Sort.Direction.ASC : Sort.Direction.DESC;
            Pageable pageable = PageRequest.of(page, size, Sort.by(direction, sortBy));

            // Parse category thành categoryId
            Long categoryId = null;
            if (category != null && !category.isEmpty() && !"all".equals(category)) {
                try {
                    categoryId = Long.parseLong(category);
                } catch (NumberFormatException e) {
                    // Ignore invalid categoryId
                }
            }

            // Parse instructor thành instructorId (nếu có)
            Long instructorId = null;

            // Gọi service với đúng signature
            Page<Course> coursePage = courseService.findCoursesWithFilters(
                    search, categoryId, instructorId, true, pageable);

            // Convert sang DTO
            Page<CourseDto> courseDtoPage = coursePage.map(CourseDto::fromEntity);

            return ResponseEntity.ok(
                    ApiResponse.success(courseDtoPage)
                            .withMeta("totalElements", coursePage.getTotalElements())
                            .withMeta("totalPages", coursePage.getTotalPages())
                            .withMeta("currentPage", page)
                            .withMeta("pageSize", size)
            );
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Lỗi khi lấy danh sách khóa học: " + e.getMessage()));
        }
    }

    /**
     * Lấy khóa học phổ biến (featured)
     */
    @GetMapping("/courses/featured")
    public ResponseEntity<ApiResponse<List<CourseDto>>> getFeaturedCourses(
            @RequestParam(defaultValue = "8") int limit) {
        try {
            List<Course> featuredCourses = courseService.findFeaturedCourses(limit);
            List<CourseDto> courseDtos = featuredCourses.stream()
                    .map(CourseDto::fromEntity)
                    .collect(Collectors.toList());

            return ResponseEntity.ok(ApiResponse.success(courseDtos));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Lỗi khi lấy khóa học nổi bật: " + e.getMessage()));
        }
    }

    /**
     * Lấy chi tiết một khóa học
     */
    @GetMapping("/courses/{id}")
    public ResponseEntity<ApiResponse<CourseDto>> getCourseById(@PathVariable Long id) {
        try {
            Optional<Course> courseOpt = courseService.findById(id);
            if (courseOpt.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            CourseDto courseDto = CourseDto.fromEntity(courseOpt.get());
            return ResponseEntity.ok(ApiResponse.success(courseDto));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Lỗi khi lấy thông tin khóa học: " + e.getMessage()));
        }
    }

    /**
     * Lấy danh sách bài học của một khóa học
     */
    @GetMapping("/courses/{courseId}/lessons")
    public ResponseEntity<ApiResponse<List<LessonDto>>> getCourseLessons(
            @PathVariable Long courseId,
            Authentication authentication) {
        try {
            // Kiểm tra quyền truy cập (đã enroll hoặc preview lessons)
            User currentUser = authentication != null ?
                    (User) authentication.getPrincipal() : null;

            List<Lesson> lessons;
            if (currentUser != null && enrollmentService.isEnrolled(currentUser.getId(), courseId)) {
                // User đã đăng ký - lấy tất cả lessons
                lessons = lessonService.findByCourseIdAndActiveOrderByOrder(courseId, true);
            } else {
                // User chưa đăng ký - chỉ lấy preview lessons
                lessons = lessonService.findByCourseIdAndPreviewAndActiveOrderByOrder(courseId, true, true);
            }

            List<LessonDto> lessonDtos = lessons.stream()
                    .map(LessonDto::fromEntity)
                    .collect(Collectors.toList());

            return ResponseEntity.ok(ApiResponse.success(lessonDtos));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Lỗi khi lấy danh sách bài học: " + e.getMessage()));
        }
    }

    /**
     * Đăng ký khóa học
     */
    @PostMapping("/courses/{courseId}/enroll")
    public ResponseEntity<ApiResponse<String>> enrollCourse(
            @PathVariable Long courseId,
            Authentication authentication) {
        try {
            if (authentication == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(ApiResponse.error("Vui lòng đăng nhập để đăng ký khóa học"));
            }

            User currentUser = (User) authentication.getPrincipal();

            // Kiểm tra đã đăng ký chưa
            if (enrollmentService.isEnrolled(currentUser.getId(), courseId)) {
                return ResponseEntity.badRequest()
                        .body(ApiResponse.error("Bạn đã đăng ký khóa học này rồi"));
            }

            // Tạo enrollment mới
            Enrollment enrollment = enrollmentService.createEnrollment(currentUser.getId(), courseId);

            return ResponseEntity.ok(
                    ApiResponse.success("Đăng ký khóa học thành công!")
                            .withMeta("enrollmentId", enrollment.getId())
            );
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Lỗi khi đăng ký khóa học: " + e.getMessage()));
        }
    }

    /**
     * Lấy tiến độ học của user trong khóa học
     */
    @GetMapping("/courses/{courseId}/progress")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getCourseProgress(
            @PathVariable Long courseId,
            Authentication authentication) {
        try {
            if (authentication == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(ApiResponse.error("Vui lòng đăng nhập"));
            }

            User currentUser = (User) authentication.getPrincipal();

            // Tìm enrollment
            Optional<Enrollment> enrollmentOpt = enrollmentService.findByStudentIdAndCourseId(
                    currentUser.getId(), courseId);

            if (enrollmentOpt.isEmpty()) {
                return ResponseEntity.badRequest()
                        .body(ApiResponse.error("Bạn chưa đăng ký khóa học này"));
            }

            Enrollment enrollment = enrollmentOpt.get();
            Map<String, Object> progress = new HashMap<>();
            progress.put("progress", enrollment.getProgress());
            progress.put("completed", enrollment.isCompleted());
            progress.put("enrollmentDate", enrollment.getEnrollmentDate());
            progress.put("completionDate", enrollment.getCompletionDate());

            return ResponseEntity.ok(ApiResponse.success(progress));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Lỗi khi lấy tiến độ học: " + e.getMessage()));
        }
    }

    // ==================== QUIZ ENDPOINTS ====================

    /**
     * Lấy danh sách quiz của một khóa học
     */
    @GetMapping("/courses/{courseId}/quizzes")
    public ResponseEntity<ApiResponse<List<QuizDTO>>> getCourseQuizzes(@PathVariable Long courseId) {
        try {
            List<Quiz> quizzes = quizService.findByCourse(courseId);
            List<QuizDTO> quizDtos = quizzes.stream()
                    .map(QuizDTO::fromEntity)
                    .collect(Collectors.toList());

            return ResponseEntity.ok(ApiResponse.success(quizDtos));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Lỗi khi lấy danh sách quiz: " + e.getMessage()));
        }
    }

    /**
     * Lấy chi tiết một quiz
     */
    @GetMapping("/quizzes/{quizId}")
    public ResponseEntity<ApiResponse<QuizDTO>> getQuizById(
            @PathVariable Long quizId,
            Authentication authentication) {
        try {
            Optional<Quiz> quizOpt = quizService.findById(quizId);
            if (quizOpt.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            Quiz quiz = quizOpt.get();
            QuizDTO quizDto;

            if (authentication != null) {
                User currentUser = (User) authentication.getPrincipal();
                quizDto = QuizDTO.fromEntityWithStudentInfo(quiz, currentUser.getId());
            } else {
                quizDto = QuizDTO.fromEntity(quiz);
            }

            return ResponseEntity.ok(ApiResponse.success(quizDto));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Lỗi khi lấy thông tin quiz: " + e.getMessage()));
        }
    }

    // ==================== CATEGORY ENDPOINTS ====================

    /**
     * Lấy tất cả categories
     */
    @GetMapping("/categories")
    public ResponseEntity<ApiResponse<List<Category>>> getAllCategories() {
        try {
            List<Category> categories = categoryService.findAllOrderByName();
            return ResponseEntity.ok(ApiResponse.success(categories));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Lỗi khi lấy danh mục: " + e.getMessage()));
        }
    }

    /**
     * Tìm kiếm categories
     */
    @GetMapping("/categories/search")
    public ResponseEntity<ApiResponse<List<Category>>> searchCategories(
            @RequestParam String keyword,
            @RequestParam(defaultValue = "10") int limit) {
        try {
            // Sử dụng method có sẵn thay vì searchCategories
            List<Category> categories = categoryService.findByNameContainingIgnoreCase(keyword);

            // Giới hạn kết quả
            if (categories.size() > limit) {
                categories = categories.subList(0, limit);
            }

            return ResponseEntity.ok(ApiResponse.success(categories));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Lỗi khi tìm kiếm danh mục: " + e.getMessage()));
        }
    }

    // ==================== USER ENDPOINTS ====================

    /**
     * Upload avatar cho user
     */
    @PostMapping("/users/upload-avatar")
    public ResponseEntity<ApiResponse<String>> uploadAvatar(
            @RequestParam("file") MultipartFile file,
            Authentication authentication) {
        try {
            if (authentication == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(ApiResponse.error("Vui lòng đăng nhập"));
            }

            if (file.isEmpty()) {
                return ResponseEntity.badRequest()
                        .body(ApiResponse.error("Vui lòng chọn file ảnh"));
            }

            // Kiểm tra file type
            if (!CourseUtils.FileUtils.isImageFile(file.getOriginalFilename())) {
                return ResponseEntity.badRequest()
                        .body(ApiResponse.error("File phải là hình ảnh (jpg, png, gif)"));
            }

            // Kiểm tra file size (5MB)
            if (!CourseUtils.FileUtils.isValidFileSize(file, 5 * 1024 * 1024)) {
                return ResponseEntity.badRequest()
                        .body(ApiResponse.error("File không được vượt quá 5MB"));
            }

            User currentUser = (User) authentication.getPrincipal();

            // Generate unique filename
            String filename = CourseUtils.FileUtils.generateUniqueFilename(file.getOriginalFilename());
            String uploadDir = "uploads/avatars/";

            // Save file
            String filePath = CourseUtils.FileUtils.saveFile(file, uploadDir, filename);
            String fileUrl = "/uploads/avatars/" + filename;

            // Update user profile
            currentUser.setProfileImageUrl(fileUrl);
            userService.updateUser(currentUser);

            return ResponseEntity.ok(
                    ApiResponse.success("Upload avatar thành công", fileUrl)
            );
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Lỗi khi upload avatar: " + e.getMessage()));
        }
    }

    // ==================== STATISTICS ENDPOINTS ====================

    /**
     * Lấy thống kê tổng quan cho dashboard
     */
    @GetMapping("/statistics/overview")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getOverviewStatistics() {
        try {
            Map<String, Object> stats = new HashMap<>();
            stats.put("totalCourses", courseService.countAllCourses());
            stats.put("totalUsers", userService.countAllUsers());
            stats.put("totalEnrollments", enrollmentService.countAllEnrollments());
            stats.put("totalCategories", categoryService.countAllCategories());

            return ResponseEntity.ok(ApiResponse.success(stats));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Lỗi khi lấy thống kê: " + e.getMessage()));
        }
    }
}