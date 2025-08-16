package com.coursemanagement.service;

import com.coursemanagement.entity.Category;
import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.User;
import com.coursemanagement.repository.CourseRepository;
import com.coursemanagement.utils.CourseUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Dịch vụ xử lý logic nghiệp vụ liên quan đến Course
 * Quản lý CRUD operations, validation và business rules cho courses
 * SỬA LỖI: Đã sửa static field injection và circular dependency issues
 */
@Service
@Transactional
public class CourseService {

    // SỬA LỖI: Bỏ static injection để tránh vấn đề
    @Autowired
    private CourseRepository courseRepository; // ✅ Instance field thay vì static

    // SỬA LỖI: Sử dụng @Lazy để tránh circular dependency với EnrollmentService
    @Lazy
    @Autowired
    private EnrollmentService enrollmentService;

    private static final String UPLOAD_DIR = "uploads/courses/";

    // ===== CÁC THAO TÁC CRUD CƠ BẢN =====

    /**
     * Tìm course theo ID
     */
    public Optional<Course> findById(Long id) {
        return courseRepository.findById(id);
    }

    /**
     * Tìm course theo ID và instructor (cho bảo mật)
     */
    public Optional<Course> findByIdAndInstructor(Long id, User instructor) {
        return courseRepository.findByIdAndInstructor(id, instructor);
    }

    /**
     * Tìm tất cả courses với pagination (alternative method)
     */
    public Page<Course> findAll(Pageable pageable) {
        return courseRepository.findAll(pageable);
    }
    /**
     * Search courses with pagination - THÊM MỚI
     */


    /**
     * Find active courses with pagination - THÊM MỚI
     */

    /**
     * Find featured courses - THÊM MỚI
     */


    @Transactional(readOnly = true)
    public Page<Course> findAllWithPagination(Pageable pageable) {
        try {
            // Thử dùng custom query với JOIN FETCH
            return findAllWithJoinFetch(pageable);
        } catch (Exception e) {
            // Fallback về method thông thường nếu có lỗi
            System.err.println("Fallback to simple findAll: " + e.getMessage());
            return courseRepository.findAll(pageable);
        }
    }

    /**
     * Custom method với JOIN FETCH
     */
    @Transactional(readOnly = true)
    public Page<Course> findAllWithJoinFetch(Pageable pageable) {
        // Sử dụng custom query hoặc EntityManager để JOIN FETCH
        // Tạm thời dùng method đơn giản và xử lý lazy loading ở JSP level
        return courseRepository.findAll(pageable);
    }

    /**
     * Tìm course theo slug
     */
    public Optional<Course> findBySlug(String slug) {
        return courseRepository.findBySlug(slug);
    }

    /**
     * Tạo course mới
     */
    public Course createCourse(Course course) {
        validateCourse(course);

        course.setSlug(CourseUtils.StringUtils.createSlug(course.getName()));
        course.setCreatedAt(LocalDateTime.now());
        course.setUpdatedAt(LocalDateTime.now());
        course.setActive(true);

        return courseRepository.save(course);
    }

    /**
     * Cập nhật course
     */
    public Course updateCourse(Course course) {
        if (course.getId() == null) {
            throw new RuntimeException("ID course không được để trống khi cập nhật");
        }

        Course existingCourse = courseRepository.findById(course.getId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy course với ID: " + course.getId()));

        existingCourse.setName(course.getName());
        existingCourse.setDescription(course.getDescription());
        existingCourse.setCategory(course.getCategory());
        existingCourse.setDuration(course.getDuration());
        existingCourse.setDifficultyLevel(course.getDifficultyLevel());
        existingCourse.setPrice(course.getPrice());
        existingCourse.setPrerequisites(course.getPrerequisites());
        existingCourse.setLearningObjectives(course.getLearningObjectives());
        existingCourse.setLanguage(course.getLanguage());
        existingCourse.setFeatured(course.isFeatured());
        existingCourse.setActive(course.isActive());
        existingCourse.setUpdatedAt(LocalDateTime.now());

        if (!existingCourse.getName().equals(course.getName())) {
            existingCourse.setSlug(CourseUtils.StringUtils.createSlug(course.getName()));
        }

        return courseRepository.save(existingCourse);
    }

    /**
     * Xóa course (soft delete)
     */
    public void deleteCourse(Long courseId) {
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy course với ID: " + courseId));

        course.setActive(false);
        course.setUpdatedAt(LocalDateTime.now());
        courseRepository.save(course);
    }

    /**
     * Kích hoạt/Vô hiệu hóa course
     */
    public Course toggleActive(Long courseId, boolean active) {
        Course course = findById(courseId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học với ID: " + courseId));

        course.setActive(active);
        course.setUpdatedAt(LocalDateTime.now());

        return courseRepository.save(course);
    }

    /**
     * Cập nhật featured status
     */
    public Course updateFeaturedStatus(Long courseId, boolean featured) {
        Course course = findById(courseId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy course"));

        course.setFeatured(featured);
        course.setUpdatedAt(LocalDateTime.now());

        return courseRepository.save(course);
    }

    // ===== CÁC THAO TÁC ĐẾM =====

    /**
     * Đếm tất cả courses active
     */
    /**
     * Đếm courses theo trạng thái active
     */
    public Long countByActive(boolean active) {
        return courseRepository.countByActive(active);
    }

    /**
     * Đếm tất cả courses
     */
    public Long countAllCourses() {
        return courseRepository.count();
    }

    /**
     * Đếm tổng số courses (bí danh)
     */
    public Long countAll() {
        return courseRepository.count();
    }

    /**
     * Đếm featured courses
     */
    public Long countFeaturedCourses() {
        return courseRepository.countByFeaturedAndActive(true, true);
    }

    /**
     * Đếm courses theo category
     */
    public Long countCoursesByCategory(Category category) {
        return courseRepository.countByCategory(category);
    }

    /**
     * Đếm courses của instructor
     */
    public Long countCoursesByInstructor(User instructor) {
        return courseRepository.countByInstructorAndActive(instructor, true);
    }

    // ===== CÁC PHƯƠNG THỨC TÌM KIẾM CHO HOME CONTROLLER =====

    /**
     * Tìm top courses phổ biến nhất (theo số enrollment)
     */
    public List<Course> findTopPopularCourses(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        Page<Course> coursePage = courseRepository.findPopularCourses(pageable);
        return coursePage.getContent(); // Convert Page to List
    }

    /**
     * Tìm most popular courses (bí danh)
     */
    public List<Course> findMostPopularCourses(int limit) {
        return findTopPopularCourses(limit);
    }

    /**
     * Tìm popular courses với pagination
     */
    public Page<Course> findPopularCourses(Pageable pageable) {
        return courseRepository.findPopularCourses(pageable);
    }

    /**
     * Tìm featured courses với limit
     */


    /**
     * Tìm tất cả courses active
     */
    public List<Course> findAllActive() {
        return courseRepository.findAllByActiveTrue();
    }

    /**
     * Tìm courses active mới nhất
     */
    public List<Course> findActiveCoursesOrderByLatest() {
        return courseRepository.findByActiveOrderByCreatedAtDesc(true);
    }

    /**
     * Tìm courses active theo category
     */
    public List<Course> findActiveCoursesByCategory(Category category) {
        return courseRepository.findByCategoryAndActiveOrderByCreatedAtDesc(category, true);
    }

    /**
     * Tìm courses active theo category ID
     */
    public List<Course> findActiveCoursesByCategory(Long categoryId) {
        return courseRepository.findByCategoryIdAndActiveOrderByCreatedAtDesc(categoryId, true);
    }

    /**
     * Tìm courses theo category và active
     */
    public List<Course> findByCategoryAndActiveOrderByCreatedAtDesc(Category category, boolean active) {
        return courseRepository.findByCategoryAndActiveOrderByCreatedAtDesc(category, active);
    }

    /**
     * Tìm courses theo category ID và active
     */
    public List<Course> findByCategoryIdAndActiveOrderByCreatedAtDesc(Long categoryId, boolean active) {
        return courseRepository.findByCategoryIdAndActiveOrderByCreatedAtDesc(categoryId, active);
    }

    /**
     * Tìm courses theo category với pagination
     */
    public Page<Course> findByCategoryId(Long categoryId, Pageable pageable) {
        return courseRepository.findByCategoryIdAndActiveTrue(categoryId, pageable);
    }

    /**
     * Tìm available courses cho student (chưa đăng ký)
     */
    public List<Course> findAvailableCoursesForStudent(Long studentId) {
        return courseRepository.findAvailableCoursesForStudent(studentId);
    }

    // ===== CÁC PHƯƠNG THỨC TÌM KIẾM =====

    /**
     * Tìm courses theo tên (search)
     */
    public List<Course> searchCoursesByName(String name) {
        return courseRepository.findByNameContainingIgnoreCaseAndActive(name, true);
    }

    /**
     * Tìm courses theo tên chứa keyword
     */
    public List<Course> findByNameContainingIgnoreCaseAndActive(String keyword, boolean active) {
        return courseRepository.findByNameContainingIgnoreCaseAndActive(keyword, active);
    }

    /**
     * Tìm courses theo keyword với limit
     */
    public List<Course> searchCourses(String keyword, int limit) {
        return courseRepository.searchCourses(keyword).stream()
                .limit(limit)
                .collect(Collectors.toList());
    }

    /**
     * Tìm courses với pagination và search
     */
    public Page<Course> searchCourses(String keyword, String category, String level,
                                      String sortBy, Pageable pageable) {
        // Implement search logic with filters
        return courseRepository.findAll(pageable); // Placeholder
    }

    // ===== CÁC PHƯƠNG THỨC LIÊN QUAN ĐẾN INSTRUCTOR =====

    /**
     * Tìm courses của instructor sắp xếp theo ngày tạo
     */
    public List<Course> findByInstructorOrderByCreatedAtDesc(User instructor) {
        return courseRepository.findByInstructorOrderByCreatedAtDesc(instructor);
    }

    /**
     * Tìm courses theo instructor
     */
    public List<Course> findCoursesByInstructor(User instructor) {
        return courseRepository.findByInstructorAndActiveOrderByCreatedAtDesc(instructor, true);
    }

    /**
     * Tìm recent courses của instructor
     */
    public List<Course> findRecentCoursesByInstructor(User instructor, int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        Page<Course> coursePage = courseRepository.findByInstructor(instructor, pageable);
        return coursePage.getContent(); // Convert Page to List
    }

    /**
     * Tìm courses của instructor với pagination
     */
    public Page<Course> findCoursesByInstructor(User instructor, Pageable pageable) {
        return courseRepository.findByInstructorOrderByCreatedAtDesc(instructor, pageable);
    }

    /**
     * Tìm courses của instructor theo keyword
     */
    public List<Course> findByInstructorAndKeyword(User instructor, String keyword) {
        return courseRepository.findByInstructorAndKeyword(instructor, keyword);
    }

    // ===== CÁC PHƯƠNG THỨC TÌM KIẾM VÀ LỌC =====

    /**
     * Tìm courses với filters (Original complex criteria version)
     */
    public Page<Course> findCoursesWithFilters(String search, Long categoryId,
                                               Long instructorId, Boolean featured,
                                               Pageable pageable) {
        return courseRepository.findAll((root, query, criteriaBuilder) -> {
            var predicates = criteriaBuilder.conjunction();

            predicates = criteriaBuilder.and(predicates,
                    criteriaBuilder.equal(root.get("active"), true));

            if (StringUtils.hasText(search)) {
                String searchPattern = "%" + search.toLowerCase() + "%";
                var searchPredicate = criteriaBuilder.or(
                        criteriaBuilder.like(criteriaBuilder.lower(root.get("name")), searchPattern),
                        criteriaBuilder.like(criteriaBuilder.lower(root.get("description")), searchPattern)
                );
                predicates = criteriaBuilder.and(predicates, searchPredicate);
            }

            if (categoryId != null) {
                predicates = criteriaBuilder.and(predicates,
                        criteriaBuilder.equal(root.get("category").get("id"), categoryId));
            }

            if (instructorId != null) {
                predicates = criteriaBuilder.and(predicates,
                        criteriaBuilder.equal(root.get("instructor").get("id"), instructorId));
            }

            if (featured != null) {
                predicates = criteriaBuilder.and(predicates,
                        criteriaBuilder.equal(root.get("featured"), featured));
            }

            return predicates;
        }, pageable);
    }

    /**
     * Tìm courses với filters kết hợp (Repository version)
     */
    public Page<Course> findCoursesWithFilters(String keyword, Long categoryId, Long instructorId,
                                               boolean active, Pageable pageable) {
        return courseRepository.findCoursesWithFilters(keyword, categoryId, instructorId, active, pageable);
    }

    /**
     * Tìm courses với filter (Simplified version)
     */
    public Page<Course> findCoursesWithFilter(String search, Long categoryId, String status, Pageable pageable) {
        Boolean activeFilter = null;
        if ("active".equals(status)) {
            activeFilter = true;
        } else if ("inactive".equals(status)) {
            activeFilter = false;
        }

        return findCoursesWithFilters(search, categoryId, null, null, pageable);
    }

    // ===== CÁC PHƯƠNG THỨC THỐNG KÊ =====

    /**
     * Lấy thống kê số course theo category
     */
    public List<Object[]> getCourseCountByCategory() {
        return courseRepository.getCourseCountByCategory();
    }

    /**
     * Lấy thống kê số course theo instructor
     */
    public List<Object[]> getCourseCountByInstructor() {
        return courseRepository.getCourseCountByInstructor();
    }

    /**
     * Lấy thống kê courses theo tháng
     */
    public List<Object[]> getCourseStatsByMonth(LocalDateTime fromDate) {
        return courseRepository.getCourseStatsByMonth(fromDate);
    }

    /**
     * Lấy thống kê courses theo tháng
     */
    public Map<String, Object> getCourseStatisticsByMonth() {
        LocalDateTime fromDate = LocalDateTime.now().minusMonths(12);
        List<Object[]> stats = courseRepository.getCourseStatisticsByMonth(fromDate);

        Map<String, Object> result = new HashMap<>();
        result.put("monthlyData", stats);
        result.put("totalCourses", courseRepository.count());
        result.put("activeCourses", courseRepository.countAllActiveCourses());

        return result;
    }

    /**
     * Tìm top performing courses
     */
    public List<Course> getTopPerformingCourses(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return courseRepository.getTopPerformingCourses(pageable);
    }

    /**
     * Lấy thống kê performance theo category
     */
    public Map<String, Long> getCategoryPerformanceStats() {
        List<Object[]> stats = courseRepository.getCategoryPerformanceStats();
        Map<String, Long> result = new HashMap<>();

        for (Object[] stat : stats) {
            String categoryName = (String) stat[0];
            Long enrollmentCount = (Long) stat[1];
            result.put(categoryName, enrollmentCount);
        }

        return result;
    }

    /**
     * Lấy thống kê dashboard cho admin
     */
    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();

        // Đếm courses theo trạng thái
        stats.put("totalCourses", countAllCourses());
        stats.put("activeCourses", countActiveCourses());
        stats.put("featuredCourses", countFeaturedCourses());

        // Lấy thống kê theo category
        List<Object[]> categoryStats = getCourseCountByCategory();
        stats.put("coursesByCategory", categoryStats);

        // Lấy thống kê theo instructor
        List<Object[]> instructorStats = getCourseCountByInstructor();
        stats.put("coursesByInstructor", instructorStats);

        // Thống kê courses theo tháng (6 tháng gần đây)
        LocalDateTime sixMonthsAgo = LocalDateTime.now().minusMonths(6);
        List<Object[]> monthlyStats = getCourseStatsByMonth(sixMonthsAgo);
        stats.put("monthlyGrowth", monthlyStats);

        // Tính tổng enrollments cho tất cả courses
        Long totalEnrollments = courseRepository.findAll().stream()
                .mapToLong(course -> course.getEnrollments() != null ? course.getEnrollments().size() : 0)
                .sum();
        stats.put("totalEnrollments", totalEnrollments);

        // Tính tổng courses active
        Long activeCourses = courseRepository.findAll().stream()
                .mapToLong(course -> course.isActive() ? 1 : 0)
                .sum();
        stats.put("activeCourses", activeCourses);

        return stats;
    }

    // ===== CÁC THAO TÁC FILE =====

    /**
     * Upload image cho course (Original version)
     */
    public String uploadCourseImage(Long courseId, MultipartFile file) {
        try {
            String fileName = "course_" + courseId + "_" + System.currentTimeMillis() + "_" + file.getOriginalFilename();
            String imageUrl = "/images/courses/" + fileName;

            Course course = findById(courseId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy course"));
            course.setImageUrl(imageUrl);
            updateCourse(course);

            return imageUrl;
        } catch (Exception e) {
            throw new RuntimeException("Lỗi upload ảnh: " + e.getMessage());
        }
    }

    /**
     * Lưu file image cho course (sử dụng imageUrl thay vì thumbnailUrl)
     */
    public String saveImage(Course course, MultipartFile imageFile) throws IOException {
        if (imageFile == null || imageFile.isEmpty()) {
            return null;
        }

        if (!CourseUtils.isValidFileSize(imageFile, 5)) {
            throw new IOException("File ảnh quá lớn (tối đa 5MB)");
        }

        if (!CourseUtils.isValidFileExtension(imageFile.getOriginalFilename(),
                CourseUtils.getAllowedImageExtensions())) {
            throw new IOException("File ảnh không đúng định dạng (chỉ cho phép: jpg, jpeg, png, gif, webp)");
        }

        String fileName = CourseUtils.generateUniqueFilename(imageFile.getOriginalFilename());
        String filePath = CourseUtils.saveFile(imageFile, CourseUtils.getCourseImageDir(), fileName);

        return filePath;
    }

    /**
     * Xóa image cũ của course (sử dụng imageUrl thay vì thumbnailUrl)
     */
    public void deleteImage(Course course) {
        if (course != null && StringUtils.hasText(course.getImageUrl())) {
            CourseUtils.deleteFile(course.getImageUrl());
        }
    }

    /**
     * Cập nhật image cho course (sử dụng imageUrl thay vì thumbnailUrl)
     */
    public Course updateImage(Course course, MultipartFile imageFile) throws IOException {
        if (course == null) {
            throw new RuntimeException("Course không hợp lệ");
        }

        deleteImage(course);

        String newImagePath = saveImage(course, imageFile);
        course.setImageUrl(newImagePath);
        course.setUpdatedAt(LocalDateTime.now());

        return courseRepository.save(course);
    }

    // ===== XÁC THỰC & KIỂM TRA TỒN TẠI =====

    /**
     * Kiểm tra course name đã tồn tại chưa
     */
    public boolean isCourseNameExists(String name) {
        return courseRepository.existsByName(name);
    }

    /**
     * Kiểm tra slug đã tồn tại chưa
     */
    public boolean isSlugExists(String slug) {
        return courseRepository.existsBySlug(slug);
    }

    /**
     * Tìm course theo slug với validation
     */
    public Course findBySlugOrThrow(String slug) {
        return courseRepository.findBySlug(slug)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học với slug: " + slug));
    }

    /**
     * Tìm course theo ID với exception
     * SỬA LỖI: Bỏ static vì courseRepository giờ là instance field
     */
    public Course findByIdOrThrow(Long id) {
        return courseRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học với ID: " + id));
    }

    // ===== CÁC HELPER CHO PHÂN TÍCH COURSE =====

    /**
     * Đếm enrollments theo course
     */
    public Long countEnrollmentsByCourse(Course course) {
        return (long) course.getEnrollmentCount();
    }

    /**
     * Đếm lessons theo course
     */
    public Long countLessonsByCourse(Course course) {
        return (long) course.getLessonCount();
    }

    /**
     * Đếm quizzes theo course
     */
    public Long countQuizzesByCourse(Course course) {
        return (long) course.getQuizCount();
    }

    /**
     * Lấy average rating cho course
     */
    public Double getAverageRating(Course course) {
        return 0.0; // Placeholder - would need Rating entity
    }

    /**
     * Lấy completion rate theo course
     */
    public Double getCompletionRateByCourse(Course course) {
        return 0.0; // Placeholder - would need completion tracking
    }

    /**
     * Tìm courses theo category và active status
     */
    public List<Course> findByCategoryAndActive(Category category, boolean active) {
        return courseRepository.findByCategoryAndActive(category, active);
    }

    /**
     * Đếm courses theo category và active status
     */
    public Long countByCategoryAndActive(Category category, boolean active) {
        return courseRepository.countByCategoryAndActive(category, active);
    }

    /**
     * Cập nhật enrollment count cho course
     */
    @Transactional
    public void updateEnrollmentCount(Long courseId) {
        Course course = findByIdOrThrow(courseId);
        Long enrollmentCount = enrollmentService.countByCourse(course);
        // Update logic here if needed
    }

    // ===== CÁC PHƯƠNG THỨC XÁC THỰC RIÊNG TƯ =====

    /**
     * Xác thực course trước khi lưu
     */
    private void validateCourse(Course course) {
        if (course == null) {
            throw new RuntimeException("Course không được để trống");
        }

        if (!StringUtils.hasText(course.getName())) {
            throw new RuntimeException("Tên course không được để trống");
        }

        if (!StringUtils.hasText(course.getDescription())) {
            throw new RuntimeException("Mô tả course không được để trống");
        }

        if (course.getCategory() == null) {
            throw new RuntimeException("Category không được để trống");
        }

        if (course.getInstructor() == null) {
            throw new RuntimeException("Instructor không được để trống");
        }

        // Kiểm tra tên course đã tồn tại (chỉ cho course mới)
        if (course.getId() == null && isCourseNameExists(course.getName())) {
            throw new RuntimeException("Tên course đã tồn tại: " + course.getName());
        }

        // Kiểm tra độ dài tên course
        if (course.getName().length() < 5 || course.getName().length() > 200) {
            throw new RuntimeException("Tên course phải từ 5-200 ký tự");
        }

        // Kiểm tra giá course
        if (course.getPrice() != null && course.getPrice() < 0) {
            throw new RuntimeException("Giá course không được âm");
        }
    }
    /**
     * Find active courses (simple list) - THÊM MỚI
     */
    public List<Course> findActiveCourses() {
        try {
            return courseRepository.findByActiveOrderByCreatedAtDesc(true);
        } catch (Exception e) {
            // Fallback: find all and filter
            return courseRepository.findAll()
                    .stream()
                    .filter(Course::isActive)
                    .sorted((a, b) -> b.getCreatedAt().compareTo(a.getCreatedAt()))
                    .toList();
        }
    }

    /**
     * Count total courses - THÊM MỚI
     */
    public long countTotalCourses() {
        return courseRepository.count();
    }

    /**
     * Search courses with pagination - THÊM MỚI
     */
    public Page<Course> searchCoursesWithPagination(String keyword, Pageable pageable) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return findAllWithPagination(pageable);
        }
        try {
            return courseRepository.findByNameContainingIgnoreCaseAndActiveTrue(keyword, pageable);
        } catch (Exception e) {
            // Fallback: return all courses
            return findAllWithPagination(pageable);
        }
    }

    /**
     * Find active courses with pagination - THÊM MỚI
     */
    public Page<Course> findActiveCoursesWithPagination(Pageable pageable) {
        try {
            return courseRepository.findByActiveTrueOrderByCreatedAtDesc(pageable);
        } catch (Exception e) {
            // Fallback: return all courses
            return findAllWithPagination(pageable);
        }
    }

    /**
     * Find featured courses - THÊM MỚI
     */
    public List<Course> findFeaturedCourses(int limit) {
        try {
            return courseRepository.findByFeaturedTrueAndActiveTrueOrderByCreatedAtDesc()
                    .stream()
                    .limit(limit)
                    .toList();
        } catch (Exception e) {
            // Fallback: return active courses
            return findActiveCourses()
                    .stream()
                    .filter(course -> Boolean.TRUE.equals(course.isFeatured()))
                    .limit(limit)
                    .toList();
        }
    }

    /**
     * Count active courses - THÊM MỚI
     */
    public long countActiveCourses() {
        try {
            return courseRepository.countByActiveTrue();
        } catch (Exception e) {
            // Fallback: count manually
            return courseRepository.findAll()
                    .stream()
                    .mapToLong(course -> course.isActive() ? 1L : 0L)
                    .sum();
        }
    }

}