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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

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

        validateCourse(course);

        // Cập nhật slug nếu tên thay đổi
        if (!existingCourse.getName().equals(course.getName())) {
            course.setSlug(CourseUtils.StringUtils.createSlug(course.getName()));
        } else {
            course.setSlug(existingCourse.getSlug());
        }

        // Giữ nguyên thời gian tạo
        course.setCreatedAt(existingCourse.getCreatedAt());
        course.setUpdatedAt(LocalDateTime.now());

        return courseRepository.save(course);
    }

    /**
     * Upload course image
     * @param imageFile File image
     * @return URL của image đã upload
     * @throws IOException Nếu có lỗi I/O
     */
    public String uploadCourseImage(MultipartFile imageFile) throws IOException {
        if (!CourseUtils.FileUtils.isValidImageFile(imageFile)) {
            throw new RuntimeException("File không hợp lệ. Chỉ chấp nhận JPG, PNG, GIF dưới 5MB");
        }

        String filename = CourseUtils.FileUtils.generateUniqueFilename(imageFile.getOriginalFilename());
        String savedPath = CourseUtils.FileUtils.saveFile(imageFile, UPLOAD_DIR + "images/", filename);

        // Trả về relative URL
        return "/uploads/courses/images/" + filename;
    }

    /**
     * Soft delete course
     * @param courseId ID course cần xóa
     */
    public void softDeleteCourse(Long courseId) {
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy course"));

        course.setActive(false);
        course.setUpdatedAt(LocalDateTime.now());
        courseRepository.save(course);
    }

    // ===== ADMIN & ANALYTICS METHODS =====

    /**
     * Đếm tổng số courses
     * @return Số lượng courses
     */
    public Long countAllCourses() {
        return courseRepository.count();
    }

    /**
     * Đếm số courses active
     * @return Số lượng active courses
     */
    public Long countActiveCourses() {
        return courseRepository.countByActive(true);
    }

    /**
     * Đếm số courses active (public method)
     * @return Số lượng active courses
     */
    public Long countAllActiveCourses() {
        return countActiveCourses();
    }

    /**
     * Đếm số courses featured
     * @return Số lượng featured courses
     */
    public Long countFeaturedCourses() {
        return courseRepository.countByFeatured(true);
    }

    /**
     * Đếm số courses của một instructor
     * @param instructor Instructor
     * @return Số lượng courses
     */
    public Long countCoursesByInstructor(User instructor) {
        return courseRepository.countByInstructor(instructor);
    }

    /**
     * Đếm số courses trong một category
     * @param category Category
     * @return Số lượng courses
     */
    public Long countCoursesByCategory(Category category) {
        return courseRepository.countByCategory(category);
    }

    /**
     * Đếm số lessons trong một course
     * @param courseId ID course
     * @return Số lượng lessons
     */
    public Long countLessonsByCourse(Long courseId) {
        // Cần implement query với join hoặc call LessonService
        // Tạm thời trả về 0
        return 0L;
    }

    /**
     * Đếm số quizzes trong một course
     * @param courseId ID course
     * @return Số lượng quizzes
     */
    public Long countQuizzesByCourse(Long courseId) {
        // Cần implement query với join hoặc call QuizService
        // Tạm thời trả về 0
        return 0L;
    }

    /**
     * Tìm courses của một instructor
     * @param instructor Instructor
     * @return Danh sách courses
     */
    public List<Course> findByInstructor(User instructor) {
        return courseRepository.findByInstructorOrderByCreatedAtDesc(instructor);
    }

    /**
     * Tìm courses gần đây của instructor
     * @param instructor Instructor
     * @param limit Số lượng cần lấy
     * @return Danh sách recent courses
     */
    public List<Course> findRecentCoursesByInstructor(User instructor, int limit) {
        Pageable pageable = PageRequest.of(0, limit, Sort.by("createdAt").descending());
        return courseRepository.findByInstructor(instructor, pageable);
    }

    /**
     * Tìm courses với filter cho instructor
     * @param instructor Instructor
     * @param search Từ khóa tìm kiếm
     * @param categoryId Category ID
     * @param status Status filter
     * @return Danh sách courses
     */
    public List<Course> findCoursesByInstructorWithFilter(User instructor, String search, Long categoryId, String status) {
        // Simplified implementation - có thể mở rộng với Specification
        if (StringUtils.hasText(search)) {
            return courseRepository.findByInstructorAndNameContainingIgnoreCaseOrderByCreatedAtDesc(instructor, search);
        }
        return courseRepository.findByInstructorOrderByCreatedAtDesc(instructor);
    }

    /**
     * Tìm courses phổ biến nhất
     * @param limit Số lượng cần lấy
     * @return Danh sách popular courses
     */
    public List<Course> findMostPopularCourses(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return courseRepository.findMostPopularCourses(pageable);
    }

    /**
     * Tìm courses với filter và pagination
     * @param search Từ khóa tìm kiếm
     * @param categoryId Category ID
     * @param status Status filter
     * @param pageable Pagination info
     * @return Page của courses
     */
    public Page<Course> findCoursesWithFilter(String search, Long categoryId, String status, Pageable pageable) {
        return courseRepository.findAll((root, query, criteriaBuilder) -> {
            var predicates = criteriaBuilder.conjunction();

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
            if (categoryId != null && categoryId > 0) {
                predicates = criteriaBuilder.and(predicates,
                        criteriaBuilder.equal(root.get("category").get("id"), categoryId));
            }

            // Status filter
            if (StringUtils.hasText(status) && !"all".equals(status)) {
                boolean isActive = "active".equals(status);
                predicates = criteriaBuilder.and(predicates,
                        criteriaBuilder.equal(root.get("active"), isActive));
            }

            return predicates;
        }, pageable);
    }

    /**
     * Cập nhật featured status
     * @param courseId ID course
     * @param featured Featured status mới
     */
    public void updateFeaturedStatus(Long courseId, boolean featured) {
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy course"));

        course.setFeatured(featured);
        course.setUpdatedAt(LocalDateTime.now());
        courseRepository.save(course);
    }

    /**
     * Lấy average rating của course
     * @param course Course
     * @return Average rating
     */
    public Double getAverageRating(Course course) {
        // Placeholder - cần implement rating system
        return 4.5; // Tạm thời trả về 4.5
    }

    /**
     * Lấy top performing courses
     * @param limit Số lượng cần lấy
     * @return Danh sách top courses
     */
    public List<Course> getTopPerformingCourses(int limit) {
        return findMostPopularCourses(limit);
    }

    /**
     * Lấy thống kê performance theo category
     * @return Map chứa thống kê categories
     */
    public Map<String, Long> getCategoryPerformanceStats() {
        Map<String, Long> stats = new HashMap<>();

        // Placeholder implementation
        // Cần query complex để group by category và count enrollments
        stats.put("Programming", 150L);
        stats.put("Design", 89L);
        stats.put("Business", 67L);
        stats.put("Marketing", 45L);

        return stats;
    }

    /**
     * Tìm tất cả courses active
     * @return Danh sách active courses
     */
    public List<Course> findAllActiveCourses() {
        return courseRepository.findByActiveOrderByCreatedAtDesc(true);
    }

    /**
     * Tìm courses featured
     * @return Danh sách featured courses
     */
    public List<Course> findFeaturedCourses() {
        return courseRepository.findByFeaturedAndActiveOrderByCreatedAtDesc(true, true);
    }

    /**
     * Tìm courses theo category
     * @param category Category
     * @return Danh sách courses
     */
    public List<Course> findByCategory(Category category) {
        return courseRepository.findByCategoryAndActiveOrderByCreatedAtDesc(category, true);
    }

    /**
     * Tìm courses theo keyword
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách courses
     */
    public List<Course> searchCourses(String keyword) {
        if (!StringUtils.hasText(keyword)) {
            return findAllActiveCourses();
        }
        return courseRepository.findByNameContainingIgnoreCaseAndActiveOrderByCreatedAtDesc(keyword, true);
    }

    // ===== PRIVATE HELPER METHODS =====

    /**
     * Validate thông tin course
     * @param course Course cần validate
     */
    private void validateCourse(Course course) {
        if (course == null) {
            throw new RuntimeException("Thông tin course không được để trống");
        }

        // Validate name
        if (!StringUtils.hasText(course.getName())) {
            throw new RuntimeException("Tên khóa học không được để trống");
        }
        if (course.getName().length() < 5) {
            throw new RuntimeException("Tên khóa học phải có ít nhất 5 ký tự");
        }
        if (course.getName().length() > 200) {
            throw new RuntimeException("Tên khóa học không được vượt quá 200 ký tự");
        }

        // Validate description
        if (!StringUtils.hasText(course.getDescription())) {
            throw new RuntimeException("Mô tả khóa học không được để trống");
        }
        if (course.getDescription().length() < 20) {
            throw new RuntimeException("Mô tả khóa học phải có ít nhất 20 ký tự");
        }

        // Validate instructor
        if (course.getInstructor() == null) {
            throw new RuntimeException("Khóa học phải có giảng viên");
        }

        // Validate category
        if (course.getCategory() == null) {
            throw new RuntimeException("Khóa học phải có danh mục");
        }

        // Validate duration
        if (course.getDuration() != null && course.getDuration() <= 0) {
            throw new RuntimeException("Thời lượng khóa học phải là số dương");
        }
    }
}