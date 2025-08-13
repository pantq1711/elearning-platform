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

    /**
     * Tìm course theo ID
     * @param id ID của course
     * @return Optional chứa Course nếu tìm thấy
     */
    public Optional<Course> findById(Long id) {
        return courseRepository.findById(id);
    }

    /**
     * Tìm course theo ID và instructor (cho security)
     * @param id ID course
     * @param instructor Instructor sở hữu
     * @return Optional chứa Course nếu tìm thấy
     */
    public Optional<Course> findByIdAndInstructor(Long id, User instructor) {
        return courseRepository.findByIdAndInstructor(id, instructor);
    }

    /**
     * Tìm course theo slug
     * @param slug Slug của course
     * @return Optional chứa Course nếu tìm thấy
     */
    public Optional<Course> findBySlug(String slug) {
        return courseRepository.findBySlug(slug);
    }

    /**
     * Tạo course mới
     * @param course Course cần tạo
     * @return Course đã được tạo
     */
    public Course createCourse(Course course) {
        validateCourse(course);

        // Tạo slug từ tên course
        course.setSlug(CourseUtils.StringUtils.createSlug(course.getName()));

        // Set thời gian tạo
        course.setCreatedAt(LocalDateTime.now());
        course.setUpdatedAt(LocalDateTime.now());

        // Mặc định là active
        course.setActive(true);

        return courseRepository.save(course);
    }

    /**
     * Cập nhật course
     * @param course Course cần cập nhật
     * @return Course đã được cập nhật
     */
    public Course updateCourse(Course course) {
        if (course.getId() == null) {
            throw new RuntimeException("ID course không được để trống khi cập nhật");
        }

        Course existingCourse = courseRepository.findById(course.getId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy course với ID: " + course.getId()));

        // Cập nhật thông tin
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

        // Cập nhật slug nếu tên thay đổi
        if (!existingCourse.getName().equals(course.getName())) {
            existingCourse.setSlug(CourseUtils.StringUtils.createSlug(course.getName()));
        }

        return courseRepository.save(existingCourse);
    }

    /**
     * Xóa course (soft delete)
     * @param courseId ID của course
     */
    public void deleteCourse(Long courseId) {
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy course với ID: " + courseId));

        course.setActive(false);
        course.setUpdatedAt(LocalDateTime.now());
        courseRepository.save(course);
    }

    // ===== METHODS CHO HOMECONTROLLER =====

    /**
     * Đếm tất cả courses active
     * @return Số lượng courses active
     */
    public Long countActiveCourses() {
        return courseRepository.countByActive(true);
    }

    /**
     * Đếm tất cả courses
     * @return Tổng số courses
     */
    public Long countAllCourses() {
        return courseRepository.count();
    }

    /**
     * Tìm top courses phổ biến nhất (theo số enrollment)
     * @param limit Số lượng giới hạn
     * @return Danh sách courses phổ biến
     */
    public List<Course> findTopPopularCourses(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return courseRepository.findPopularCourses(pageable);
    }

    /**
     * Tìm courses active mới nhất
     * @return Danh sách courses mới nhất
     */
    public List<Course> findActiveCoursesOrderByLatest() {
        return courseRepository.findByActiveOrderByCreatedAtDesc(true);
    }

    /**
     * Tìm courses active theo category
     * @param category Category
     * @return Danh sách courses
     */
    public List<Course> findActiveCoursesByCategory(Category category) {
        return courseRepository.findByCategoryAndActiveOrderByCreatedAtDesc(category, true);
    }

    /**
     * Tìm courses active theo category ID
     * @param categoryId ID của category
     * @return Danh sách courses
     */
    public List<Course> findActiveCoursesByCategory(Long categoryId) {
        return courseRepository.findByCategoryIdAndActiveOrderByCreatedAtDesc(categoryId, true);
    }

    /**
     * Tìm available courses cho student (chưa đăng ký)
     * @param studentId ID của student
     * @return Danh sách available courses
     */
    public List<Course> findAvailableCoursesForStudent(Long studentId) {
        return courseRepository.findAvailableCoursesForStudent(studentId);
    }

    /**
     * Tìm courses theo tên (search)
     * @param name Tên course
     * @return Danh sách courses
     */
    public List<Course> searchCoursesByName(String name) {
        return courseRepository.findByNameContainingIgnoreCaseAndActive(name, true);
    }

    // ===== INSTRUCTOR RELATED METHODS =====

    /**
     * Đếm courses của instructor
     * @param instructor Instructor
     * @return Số lượng courses
     */
    public Long countCoursesByInstructor(User instructor) {
        return courseRepository.countByInstructorAndActive(instructor, true);
    }

    /**
     * Tìm recent courses của instructor
     * @param instructor Instructor
     * @param limit Số lượng giới hạn
     * @return Danh sách courses gần đây
     */
    public List<Course> findRecentCoursesByInstructor(User instructor, int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return courseRepository.findByInstructor(instructor, pageable);
    }

    /**
     * Tìm courses của instructor với pagination
     * @param instructor Instructor
     * @param pageable Pagination info
     * @return Page courses
     */
    public Page<Course> findCoursesByInstructor(User instructor, Pageable pageable) {
        return courseRepository.findByInstructorOrderByCreatedAtDesc(instructor, pageable);
    }

    // ===== STATISTICS METHODS =====

    /**
     * Lấy thống kê courses theo category
     * @return Map chứa thống kê
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
     * @return Map chứa thống kê
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
     * @return Map chứa thống kê theo tháng
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

    // ===== SEARCH AND FILTER METHODS =====

    /**
     * Tìm courses với filters
     * @param search Từ khóa tìm kiếm
     * @param categoryId ID category
     * @param instructorId ID instructor
     * @param featured Featured status
     * @param pageable Pagination info
     * @return Page courses
     */
    public Page<Course> findCoursesWithFilters(String search, Long categoryId,
                                               Long instructorId, Boolean featured,
                                               Pageable pageable) {
        return courseRepository.findAll((root, query, criteriaBuilder) -> {
            var predicates = criteriaBuilder.conjunction();

            // Active courses only
            predicates = criteriaBuilder.and(predicates,
                    criteriaBuilder.equal(root.get("active"), true));

            // Search filter
            if (StringUtils.hasText(search)) {
                String searchPattern = "%" + search.toLowerCase() + "%";
                var searchPredicate = criteriaBuilder.or(
                        criteriaBuilder.like(criteriaBuilder.lower(root.get("name")), searchPattern),
                        criteriaBuilder.like(criteriaBuilder.lower(root.get("description")), searchPattern)
                );
                predicates = criteriaBuilder.and(predicates, searchPredicate);
            }

            // Category filter
            if (categoryId != null) {
                predicates = criteriaBuilder.and(predicates,
                        criteriaBuilder.equal(root.get("category").get("id"), categoryId));
            }

            // Instructor filter
            if (instructorId != null) {
                predicates = criteriaBuilder.and(predicates,
                        criteriaBuilder.equal(root.get("instructor").get("id"), instructorId));
            }

            // Featured filter
            if (featured != null) {
                predicates = criteriaBuilder.and(predicates,
                        criteriaBuilder.equal(root.get("featured"), featured));
            }

            return predicates;
        }, pageable);
    }

    /**
     * Upload image cho course
     * @param courseId ID course
     * @param file File ảnh
     * @return URL của ảnh đã upload
     */
    public String uploadCourseImage(Long courseId, MultipartFile file) {
        try {
            // Logic upload file (sẽ implement sau)
            String fileName = "course_" + courseId + "_" + System.currentTimeMillis() + "_" + file.getOriginalFilename();
            String imageUrl = "/images/courses/" + fileName;

            // Cập nhật imageUrl cho course
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
     * Tìm courses của instructor sắp xếp theo ngày tạo
     * @param instructor Instructor
     * @return Danh sách courses
     */
    public List<Course> findByInstructorOrderByCreatedAtDesc(User instructor) {
        return courseRepository.findByInstructorOrderByCreatedAtDesc(instructor);
    }

    /**
     * Tìm courses của instructor theo keyword
     * @param instructor Instructor
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách courses
     */
    public List<Course> findByInstructorAndKeyword(User instructor, String keyword) {
        return courseRepository.findByInstructorAndKeyword(instructor, keyword);
    }

    /**
     * Đếm featured courses
     * @return Số lượng featured courses
     */
    public Long countFeaturedCourses() {
        return courseRepository.countByFeaturedAndActive(true, true);
    }

    /**
     * Đếm courses theo category
     * @param category Category
     * @return Số lượng courses
     */
    public Long countCoursesByCategory(Category category) {
        return courseRepository.countByCategory(category);
    }

    /**
     * Tìm courses với filter
     * @param search Từ khóa tìm kiếm
     * @param categoryId ID category
     * @param status Status filter
     * @param pageable Pagination info
     * @return Page courses
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

    /**
     * Đếm enrollments theo course
     * @param course Course
     * @return Số lượng enrollments
     */
    public Long countEnrollmentsByCourse(Course course) {
        return (long) course.getEnrollmentCount();
    }

    /**
     * Đếm lessons theo course
     * @param course Course
     * @return Số lượng lessons
     */
    public Long countLessonsByCourse(Course course) {
        return (long) course.getLessonCount();
    }

    /**
     * Đếm quizzes theo course
     * @param course Course
     * @return Số lượng quizzes
     */
    public Long countQuizzesByCourse(Course course) {
        return (long) course.getQuizCount();
    }

    /**
     * Lấy average rating cho course
     * @param course Course
     * @return Average rating
     */
    public Double getAverageRating(Course course) {
        // Placeholder - would need Rating entity
        return 0.0;
    }

    /**
     * Lấy completion rate theo course
     * @param course Course
     * @return Completion rate
     */
    public Double getCompletionRateByCourse(Course course) {
        // Placeholder - would need to calculate from enrollments
        return 0.0;
    }

    /**
     * Tìm recent enrollments theo course
     * @param course Course
     * @param limit Số lượng giới hạn
     * @return Danh sách recent enrollments
     */
    public List<Object[]> getRecentEnrollmentsByCourse(Course course, int limit) {
        // Placeholder - would query enrollments
        return new ArrayList<>();
    }

    /**
     * Tìm top students theo course
     * @param course Course
     * @param limit Số lượng giới hạn
     * @return Danh sách top students
     */
    public List<Object[]> getTopStudentsByCourse(Course course, int limit) {
        // Placeholder - would query enrollments with scores
        return new ArrayList<>();
    }

    /**
     * Cập nhật featured status
     * @param courseId ID course
     * @param featured Featured status
     * @return Course đã được cập nhật
     */
    public Course updateFeaturedStatus(Long courseId, boolean featured) {
        Course course = findById(courseId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy course"));

        course.setFeatured(featured);
        course.setUpdatedAt(LocalDateTime.now());

        return courseRepository.save(course);
    }

    /**
     * Tìm most popular courses
     * @param limit Số lượng giới hạn
     * @return Danh sách popular courses
     */
    public List<Course> findMostPopularCourses(int limit) {
        return findTopPopularCourses(limit);
    }

    /**
     * Lấy detailed monthly stats
     * @return Map chứa detailed stats
     */
    public Map<String, Object> getDetailedMonthlyStats() {
        return getCourseStatisticsByMonth();
    }

    /**
     * Tìm top performing courses
     * @param limit Số lượng giới hạn
     * @return Danh sách top performing courses
     */
    public List<Object[]> getTopPerformingCourses(int limit) {
        // Placeholder - would need performance metrics
        return new ArrayList<>();
    }

    /**
     * Validation cho course
     * @param course Course cần validate
     */
    private void validateCourse(Course course) {
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

        if (course.getDuration() == null || course.getDuration() <= 0) {
            throw new RuntimeException("Thời lượng course phải lớn hơn 0");
        }

        if (course.getPrice() == null || course.getPrice() < 0) {
            throw new RuntimeException("Giá course không được âm");
        }
    }
}