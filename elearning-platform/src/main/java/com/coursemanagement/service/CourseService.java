package com.coursemanagement.service;

import com.coursemanagement.entity.Category;
import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.User;
import com.coursemanagement.repository.CourseRepository;
import com.coursemanagement.utils.CourseUtils;
import org.springframework.beans.factory.annotation.Autowired;
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
import java.util.*;

/**
 * Service class để xử lý business logic liên quan đến Course
 * Quản lý CRUD operations, validation và business rules cho courses
 */
@Service
@Transactional
public class CourseService {

    @Autowired
    private CourseRepository courseRepository;

    private static final String UPLOAD_DIR = "uploads/courses/";

    // ===== BASIC CRUD OPERATIONS =====

    /**
     * Tìm course theo ID
     */
    public Optional<Course> findById(Long id) {
        return courseRepository.findById(id);
    }

    /**
     * Tìm course theo ID và instructor (cho security)
     */
    public Optional<Course> findByIdAndInstructor(Long id, User instructor) {
        return courseRepository.findByIdAndInstructor(id, instructor);
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
     * Activate/Deactivate course
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

    // ===== COUNT OPERATIONS =====

    /**
     * Đếm tất cả courses active
     */
    public Long countActiveCourses() {
        return courseRepository.countByActive(true);
    }

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
     * Đếm tổng số courses (alias)
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

    // ===== FINDER METHODS FOR HOME CONTROLLER =====

    /**
     * Tìm top courses phổ biến nhất (theo số enrollment)
     */
    public List<Course> findTopPopularCourses(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return courseRepository.findPopularCourses(pageable);
    }

    /**
     * Tìm most popular courses (alias)
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
    public List<Course> findFeaturedCourses(int limit) {
        return courseRepository.findFeaturedCourses(limit);
    }

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

    // ===== SEARCH METHODS =====

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
        return courseRepository.searchCourses(keyword, limit);
    }

    // ===== INSTRUCTOR RELATED METHODS =====

    /**
     * Tìm courses của instructor sắp xếp theo ngày tạo
     */
    public List<Course> findByInstructorOrderByCreatedAtDesc(User instructor) {
        return courseRepository.findByInstructorOrderByCreatedAtDesc(instructor);
    }

    /**
     * Tìm recent courses của instructor
     */
    public List<Course> findRecentCoursesByInstructor(User instructor, int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return courseRepository.findByInstructor(instructor, pageable);
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

    // ===== SEARCH AND FILTER METHODS =====

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

    // ===== STATISTICS METHODS =====

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
     * Lấy thống kê courses theo tháng từ thời điểm cho trước
     */
    public List<Object[]> getCourseStatsByMonth(LocalDateTime fromDate) {
        return courseRepository.getCourseStatsByMonth(fromDate);
    }

    /**
     * Lấy thống kê courses theo category
     */
    public Map<String, Object> getCourseStatisticsByCategory() {
        List<Object[]> stats = courseRepository.getCourseCountByCategory();

        Map<String, Object> result = new HashMap<>();
        result.put("categoryStats", stats);
        result.put("totalCourses", countAllCourses());
        result.put("activeCourses", countActiveCourses());

        return result;
    }

    /**
     * Lấy thống kê courses theo instructor
     */
    public Map<String, Object> getCourseStatisticsByInstructor() {
        List<Object[]> stats = courseRepository.getCourseCountByInstructor();

        Map<String, Object> result = new HashMap<>();
        result.put("instructorStats", stats);
        result.put("totalInstructors", stats.size());

        return result;
    }

    /**
     * Lấy thống kê courses theo tháng
     */
    public Map<String, Object> getCourseStatisticsByMonth() {
        LocalDateTime oneYearAgo = LocalDateTime.now().minusYears(1);
        List<Object[]> stats = courseRepository.getCourseStatsByMonth(oneYearAgo);

        Map<String, Object> result = new HashMap<>();
        result.put("monthlyStats", stats);
        result.put("totalCourses", countAllCourses());
        result.put("activeCourses", countActiveCourses());

        return result;
    }

    /**
     * Lấy detailed monthly stats
     */
    public Map<String, Object> getDetailedMonthlyStats() {
        return getCourseStatisticsByMonth();
    }

    /**
     * Lấy thống kê dashboard cho instructor
     */
    public Map<String, Object> getInstructorDashboardStats(User instructor) {
        Map<String, Object> stats = new HashMap<>();

        List<Course> instructorCourses = findByInstructorOrderByCreatedAtDesc(instructor);
        stats.put("totalCourses", instructorCourses.size());

        long activeCourses = instructorCourses.stream()
                .mapToLong(course -> course.isActive() ? 1 : 0)
                .sum();
        stats.put("activeCourses", activeCourses);

        return stats;
    }

    // ===== FILE OPERATIONS =====

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
     * Lưu file thumbnail cho course
     */
    public String saveThumbnail(Course course, MultipartFile thumbnailFile) throws IOException {
        if (thumbnailFile == null || thumbnailFile.isEmpty()) {
            return null;
        }

        if (!CourseUtils.isValidFileSize(thumbnailFile, 5)) {
            throw new IOException("File thumbnail quá lớn (tối đa 5MB)");
        }

        if (!CourseUtils.isValidFileExtension(thumbnailFile.getOriginalFilename(),
                CourseUtils.getAllowedImageExtensions())) {
            throw new IOException("File thumbnail không đúng định dạng (chỉ cho phép: jpg, jpeg, png, gif, webp)");
        }

        String fileName = CourseUtils.generateUniqueFilename(thumbnailFile.getOriginalFilename());
        String filePath = CourseUtils.saveFile(thumbnailFile, CourseUtils.getCourseImageDir(), fileName);

        return filePath;
    }

    /**
     * Xóa thumbnail cũ của course
     */
    public void deleteThumbnail(Course course) {
        if (course != null && StringUtils.hasText(course.getThumbnailUrl())) {
            CourseUtils.deleteFile(course.getThumbnailUrl());
        }
    }

    /**
     * Cập nhật thumbnail cho course
     */
    public Course updateThumbnail(Course course, MultipartFile thumbnailFile) throws IOException {
        if (course == null) {
            throw new RuntimeException("Course không hợp lệ");
        }

        deleteThumbnail(course);

        String newThumbnailPath = saveThumbnail(course, thumbnailFile);
        course.setThumbnailUrl(newThumbnailPath);
        course.setUpdatedAt(LocalDateTime.now());

        return courseRepository.save(course);
    }

    // ===== VALIDATION & EXISTENCE CHECKS =====

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

    // ===== COURSE ANALYTICS HELPERS =====

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
        return 0.0; // Placeholder - would need to calculate from enrollments
    }

    /**
     * Tìm recent enrollments theo course
     */
    public List<Object[]> getRecentEnrollmentsByCourse(Course course, int limit) {
        return new ArrayList<>(); // Placeholder - would query enrollments
    }

    /**
     * Tìm top students theo course
     */
    public List<Object[]> getTopStudentsByCourse(Course course, int limit) {
        return new ArrayList<>(); // Placeholder - would query enrollments with scores
    }

    /**
     * Tìm top performing courses
     */
    public List<Object[]> getTopPerformingCourses(int limit) {
        return new ArrayList<>(); // Placeholder - would need performance metrics
    }


    // ===== PRIVATE VALIDATION METHODS =====

    /**
     * Validation cho course (Enhanced version from both files)
     */
    private void validateCourse(Course course) {
        if (course == null) {
            throw new RuntimeException("Course không được để trống");
        }

        if (!StringUtils.hasText(course.getName())) {
            throw new RuntimeException("Tên khóa học không được để trống");
        }

        if (!StringUtils.hasText(course.getDescription())) {
            throw new RuntimeException("Mô tả khóa học không được để trống");
        }

        if (course.getCategory() == null) {
            throw new RuntimeException("Danh mục không được để trống");
        }

        if (course.getInstructor() == null) {
            throw new RuntimeException("Giảng viên không được để trống");
        }

        if (course.getDuration() != null && course.getDuration() <= 0) {
            throw new RuntimeException("Thời lượng khóa học phải lớn hơn 0");
        }

        if (course.getPrice() != null && course.getPrice() < 0) {
            throw new RuntimeException("Giá khóa học không được âm");
        }
    }
}