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

import jakarta.validation.Valid;
import java.util.*;
import java.util.stream.Collectors;

/**
 * REST API Controller cho mobile app và external integrations
 * Cung cấp các endpoint RESTful với JSON response
 * Hỗ trợ authentication, pagination, filtering, sorting
 */
@RestController
@RequestMapping("/api/v1")
@CrossOrigin(origins = "*", maxAge = 3600)
public class ApiController {

    @Autowired private UserService userService;
    @Autowired private CourseService courseService;
    @Autowired private CategoryService categoryService;
    @Autowired private LessonService lessonService;
    @Autowired private QuizService quizService;
    @Autowired private EnrollmentService enrollmentService;

    /**
     * Response wrapper class cho consistent API responses
     */
    public static class ApiResponse<T> {
        private boolean success;
        private String message;
        private T data;
        private String timestamp;
        private Map<String, Object> meta;

        public ApiResponse(boolean success, String message, T data) {
            this.success = success;
            this.message = message;
            this.data = data;
            this.timestamp = CourseUtils.DateTimeUtils.formatDateTime(java.time.LocalDateTime.now());
            this.meta = new HashMap<>();
        }

        public static <T> ApiResponse<T> success(T data) {
            return new ApiResponse<>(true, "Thành công", data);
        }

        public static <T> ApiResponse<T> success(String message, T data) {
            return new ApiResponse<>(true, message, data);
        }

        public static <T> ApiResponse<T> error(String message) {
            return new ApiResponse<>(false, message, null);
        }

        public ApiResponse<T> withMeta(String key, Object value) {
            this.meta.put(key, value);
            return this;
        }

        // Getters và Setters
        public boolean isSuccess() { return success; }
        public void setSuccess(boolean success) { this.success = success; }

        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }

        public T getData() { return data; }
        public void setData(T data) { this.data = data; }

        public String getTimestamp() { return timestamp; }
        public void setTimestamp(String timestamp) { this.timestamp = timestamp; }

        public Map<String, Object> getMeta() { return meta; }
        public void setMeta(Map<String, Object> meta) { this.meta = meta; }
    }

    // ==================== AUTH ENDPOINTS ====================

    /**
     * Đăng ký tài khoản mới qua API
     */
    @PostMapping("/auth/register")
    public ResponseEntity<ApiResponse<UserDto>> register(@Valid @RequestBody UserDto userDto) {
        try {
            // Validate input
            if (!userDto.isValidForRegistration()) {
                return ResponseEntity.badRequest()
                        .body(ApiResponse.error("Thông tin đăng ký không hợp lệ"));
            }

            // Tạo user entity từ DTO
            User user = new User();
            user.setUsername(userDto.getUsername());
            user.setEmail(userDto.getEmail());
            user.setFullName(userDto.getFullName());
            user.setPassword(userDto.getPassword());
            user.setPhoneNumber(userDto.getPhoneNumber());
            user.setBio(userDto.getBio());
            user.setRole(User.Role.STUDENT); // Default role cho API registration

            User savedUser = userService.createUser(user);
            UserDto responseDto = UserDto.fromEntity(savedUser);

            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(ApiResponse.success("Đăng ký tài khoản thành công", responseDto));

        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Lỗi đăng ký: " + e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Lỗi hệ thống, vui lòng thử lại sau"));
        }
    }

    /**
     * Lấy thông tin profile của user hiện tại
     */
    @GetMapping("/auth/profile")
    public ResponseEntity<ApiResponse<UserDto>> getProfile(Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            UserDto userDto = UserDto.fromEntity(currentUser);

            return ResponseEntity.ok(ApiResponse.success(userDto));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(ApiResponse.error("Không thể lấy thông tin profile"));
        }
    }

    /**
     * Cập nhật profile user
     */
    @PutMapping("/auth/profile")
    public ResponseEntity<ApiResponse<UserDto>> updateProfile(
            @Valid @RequestBody UserDto userDto,
            Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();

            // Cập nhật thông tin (không cập nhật username, email, password qua endpoint này)
            currentUser.setFullName(userDto.getFullName());
            currentUser.setPhoneNumber(userDto.getPhoneNumber());
            currentUser.setBio(userDto.getBio());

            User updatedUser = userService.updateUser(currentUser);
            UserDto responseDto = UserDto.fromEntity(updatedUser);

            return ResponseEntity.ok(ApiResponse.success("Cập nhật profile thành công", responseDto));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Lỗi cập nhật profile: " + e.getMessage()));
        }
    }

    // ==================== COURSE ENDPOINTS ====================

    /**
     * Lấy danh sách tất cả khóa học với pagination, filtering, sorting
     */
    @GetMapping("/courses")
    public ResponseEntity<ApiResponse<Page<CourseDto>>> getCourses(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String difficulty,
            @RequestParam(required = false) Boolean featured,
            @RequestParam(required = false) Double minPrice,
            @RequestParam(required = false) Double maxPrice) {
        try {
            Sort.Direction direction = sortDir.equalsIgnoreCase("desc") ?
                    Sort.Direction.DESC : Sort.Direction.ASC;
            Pageable pageable = PageRequest.of(page, size, Sort.by(direction, sortBy));

            // Tạo specification cho filtering (nếu cần)
            Page<Course> coursePage = courseService.findCoursesWithFilters(
                    search, category, difficulty, featured, minPrice, maxPrice, pageable);

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
                    .body(ApiResponse.error("Lỗi khi lấy danh sách khóa học"));
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
                    .body(ApiResponse.error("Lỗi khi lấy khóa học nổi bật"));
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
                    .body(ApiResponse.error("Lỗi khi lấy thông tin khóa học"));
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
            User currentUser = authentication != null ? (User) authentication.getPrincipal() : null;
            boolean hasAccess = currentUser != null &&
                    enrollmentService.isStudentEnrolled(currentUser.getId(), courseId);

            List<com.coursemanagement.entity.Lesson> lessons = lessonService.findByCourseId(courseId);

            // Nếu chưa enroll, chỉ show preview lessons
            if (!hasAccess) {
                lessons = lessons.stream()
                        .filter(com.coursemanagement.entity.Lesson::isPreview)
                        .collect(Collectors.toList());
            }

            List<LessonDto> lessonDtos = lessons.stream()
                    .map(LessonDto::fromEntity)
                    .collect(Collectors.toList());

            return ResponseEntity.ok(
                    ApiResponse.success(lessonDtos)
                            .withMeta("hasFullAccess", hasAccess)
                            .withMeta("totalLessons", lessonDtos.size())
            );
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Lỗi khi lấy danh sách bài học"));
        }
    }

    // ==================== CATEGORY ENDPOINTS ====================

    /**
     * Lấy danh sách tất cả danh mục
     */
    @GetMapping("/categories")
    public ResponseEntity<ApiResponse<List<Category>>> getCategories() {
        try {
            List<Category> categories = categoryService.findAllActive();
            return ResponseEntity.ok(ApiResponse.success(categories));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Lỗi khi lấy danh sách danh mục"));
        }
    }

    /**
     * Lấy khóa học theo danh mục
     */
    @GetMapping("/categories/{categoryId}/courses")
    public ResponseEntity<ApiResponse<Page<CourseDto>>> getCoursesByCategory(
            @PathVariable Long categoryId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        try {
            Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));
            Page<Course> coursePage = courseService.findByCategoryId(categoryId, pageable);
            Page<CourseDto> courseDtoPage = coursePage.map(CourseDto::fromEntity);

            return ResponseEntity.ok(ApiResponse.success(courseDtoPage));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Lỗi khi lấy khóa học theo danh mục"));
        }
    }

    // ==================== ENROLLMENT ENDPOINTS ====================

    /**
     * Đăng ký khóa học
     */
    @PostMapping("/enrollments")
    public ResponseEntity<ApiResponse<String>> enrollCourse(
            @RequestParam Long courseId,
            Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();

            // Kiểm tra đã đăng ký chưa
            if (enrollmentService.isStudentEnrolled(currentUser.getId(), courseId)) {
                return ResponseEntity.badRequest()
                        .body(ApiResponse.error("Bạn đã đăng ký khóa học này rồi"));
            }

            // Thực hiện đăng ký
            Enrollment enrollment = enrollmentService.enrollStudent(currentUser.getId(), courseId);

            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(ApiResponse.success("Đăng ký khóa học thành công",
                            "Enrollment ID: " + enrollment.getId()));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Lỗi khi đăng ký khóa học: " + e.getMessage()));
        }
    }

    /**
     * Lấy danh sách khóa học đã đăng ký của user
     */
    @GetMapping("/enrollments/my-courses")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getMyEnrollments(
            Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();
            List<Enrollment> enrollments = enrollmentService.findByStudentId(currentUser.getId());

            List<Map<String, Object>> enrollmentData = enrollments.stream()
                    .map(enrollment -> {
                        Map<String, Object> data = new HashMap<>();
                        data.put("enrollmentId", enrollment.getId());
                        data.put("course", CourseDto.fromEntity(enrollment.getCourse()));
                        data.put("progress", enrollment.getProgress());
                        data.put("completed", enrollment.isCompleted());
                        data.put("enrollmentDate", enrollment.getEnrollmentDate());
                        data.put("completionDate", enrollment.getCompletionDate());
                        return data;
                    })
                    .collect(Collectors.toList());

            return ResponseEntity.ok(ApiResponse.success(enrollmentData));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Lỗi khi lấy danh sách khóa học đã đăng ký"));
        }
    }

    // ==================== QUIZ ENDPOINTS ====================

    /**
     * Lấy danh sách quiz của một khóa học
     */
    @GetMapping("/courses/{courseId}/quizzes")
    public ResponseEntity<ApiResponse<List<QuizDto>>> getCourseQuizzes(
            @PathVariable Long courseId,
            Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();

            // Kiểm tra quyền truy cập
            if (!enrollmentService.isStudentEnrolled(currentUser.getId(), courseId)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(ApiResponse.error("Bạn cần đăng ký khóa học để xem quiz"));
            }

            List<com.coursemanagement.entity.Quiz> quizzes = quizService.findByCourseId(courseId);
            List<QuizDto> quizDtos = quizzes.stream()
                    .map(QuizDto::fromEntity)
                    .collect(Collectors.toList());

            return ResponseEntity.ok(ApiResponse.success(quizDtos));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Lỗi khi lấy danh sách quiz"));
        }
    }

    /**
     * Lấy chi tiết quiz (không bao gồm đáp án đúng)
     */
    @GetMapping("/quizzes/{quizId}")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getQuizDetails(
            @PathVariable Long quizId,
            Authentication authentication) {
        try {
            User currentUser = (User) authentication.getPrincipal();

            Optional<com.coursemanagement.entity.Quiz> quizOpt = quizService.findById(quizId);
            if (quizOpt.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            com.coursemanagement.entity.Quiz quiz = quizOpt.get();

            // Kiểm tra quyền truy cập
            if (!enrollmentService.isStudentEnrolled(currentUser.getId(), quiz.getCourse().getId())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(ApiResponse.error("Bạn cần đăng ký khóa học để làm quiz"));
            }

            Map<String, Object> quizData = new HashMap<>();
            quizData.put("quiz", QuizDto.fromEntity(quiz));

            // Lấy câu hỏi (không include đáp án đúng)
            List<com.coursemanagement.entity.Question> questions = quiz.getQuestions();
            List<Map<String, Object>> questionData = questions.stream()
                    .map(question -> {
                        Map<String, Object> qData = new HashMap<>();
                        qData.put("id", question.getId());
                        qData.put("questionText", question.getQuestionText());
                        qData.put("optionA", question.getOptionA());
                        qData.put("optionB", question.getOptionB());
                        qData.put("optionC", question.getOptionC());
                        qData.put("optionD", question.getOptionD());
                        qData.put("points", question.getPoints());
                        // Không include correctOption
                        return qData;
                    })
                    .collect(Collectors.toList());

            quizData.put("questions", questionData);

            return ResponseEntity.ok(ApiResponse.success(quizData));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Lỗi khi lấy thông tin quiz"));
        }
    }

    // ==================== SEARCH ENDPOINTS ====================

    /**
     * Search tổng hợp (courses, instructors)
     */
    @GetMapping("/search")
    public ResponseEntity<ApiResponse<Map<String, Object>>> search(
            @RequestParam String query,
            @RequestParam(defaultValue = "5") int limit) {
        try {
            Map<String, Object> searchResults = new HashMap<>();

            // Search courses
            List<Course> courses = courseService.searchCourses(query, limit);
            searchResults.put("courses", courses.stream()
                    .map(CourseDto::fromEntity)
                    .collect(Collectors.toList()));

            // Search instructors
            List<User> instructors = userService.searchInstructors(query, limit);
            searchResults.put("instructors", instructors.stream()
                    .map(UserDto::fromEntity)
                    .collect(Collectors.toList()));

            // Search categories
            List<Category> categories = categoryService.searchCategories(query, limit);
            searchResults.put("categories", categories);

            return ResponseEntity.ok(
                    ApiResponse.success(searchResults)
                            .withMeta("query", query)
                            .withMeta("totalResults",
                                    courses.size() + instructors.size() + categories.size())
            );
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Lỗi khi tìm kiếm"));
        }
    }

    // ==================== FILE UPLOAD ENDPOINTS ====================

    /**
     * Upload avatar cho user
     */
    @PostMapping("/upload/avatar")
    public ResponseEntity<ApiResponse<String>> uploadAvatar(
            @RequestParam("file") MultipartFile file,
            Authentication authentication) {
        try {
            if (!CourseUtils.FileUtils.isImageFile(file)) {
                return ResponseEntity.badRequest()
                        .body(ApiResponse.error("File phải là hình ảnh (jpg, png, gif)"));
            }

            if (!CourseUtils.FileUtils.isValidFileSize(file, 5 * 1024 * 1024)) { // 5MB
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
                    .body(ApiResponse.error("Lỗi khi lấy thống kê"));
        }
    }
}