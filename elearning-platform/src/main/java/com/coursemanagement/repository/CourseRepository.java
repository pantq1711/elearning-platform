package com.coursemanagement.repository;

import com.coursemanagement.entity.Category;
import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Repository interface cho Course entity
 * Chứa các custom queries cho course management và analytics
 * Extends JpaSpecificationExecutor để hỗ trợ dynamic filtering
 */
@Repository
public interface CourseRepository extends JpaRepository<Course, Long>, JpaSpecificationExecutor<Course> {

    // ===== BASIC FINDER METHODS =====

    /**
     * Tìm course theo slug
     * @param slug Slug của course
     * @return Optional chứa Course nếu tìm thấy
     */
    Optional<Course> findBySlug(String slug);

    /**
     * Tìm course theo ID và instructor (cho security)
     * @param id ID course
     * @param instructor Instructor sở hữu
     * @return Optional chứa Course nếu tìm thấy
     */
    Optional<Course> findByIdAndInstructor(Long id, User instructor);

    /**
     * Kiểm tra course name đã tồn tại chưa
     * @param name Tên course
     * @return true nếu đã tồn tại
     */
    boolean existsByName(String name);

    /**
     * Kiểm tra slug đã tồn tại chưa
     * @param slug Slug
     * @return true nếu đã tồn tại
     */
    boolean existsBySlug(String slug);

    // ===== INSTRUCTOR-RELATED QUERIES =====

    /**
     * Tìm courses của một instructor, sắp xếp theo ngày tạo
     * @param instructor Instructor
     * @return Danh sách courses
     */
    List<Course> findByInstructorOrderByCreatedAtDesc(User instructor);

    /**
     * Tìm courses theo instructor với pagination
     * @param instructor Instructor
     * @param pageable Pagination info
     * @return Page chứa courses
     */
    Page<Course> findByInstructor(User instructor, Pageable pageable);

    /**
     * Đếm courses của instructor
     * @param instructor Instructor
     * @return Số lượng courses
     */
    Long countByInstructor(User instructor);

    /**
     * Đếm active courses của instructor
     * @param instructor Instructor
     * @param active Trạng thái active
     * @return Số lượng active courses
     */
    Long countByInstructorAndActive(User instructor, boolean active);

    // ===== CATEGORY-RELATED QUERIES =====

    /**
     * Tìm courses theo category
     * @param category Category
     * @return Danh sách courses
     */
    List<Course> findByCategory(Category category);

    /**
     * Tìm courses theo category ID với pagination
     * @param categoryId ID của category
     * @param pageable Pagination info
     * @return Page chứa courses
     */
    Page<Course> findByCategoryId(Long categoryId, Pageable pageable);

    /**
     * Đếm courses trong category
     * @param category Category
     * @return Số lượng courses
     */
    Long countByCategory(Category category);

    // ===== FEATURED & ACTIVE QUERIES =====

    /**
     * Đếm courses theo featured và active status
     * @param featured Trạng thái featured
     * @param active Trạng thái active
     * @return Số lượng courses
     */
    Long countByFeaturedAndActive(boolean featured, boolean active);

    /**
     * Tìm featured courses với limit
     * @param featured Trạng thái featured
     * @param active Trạng thái active
     * @param pageable Pagination info
     * @return Danh sách featured courses
     */
    Page<Course> findByFeaturedAndActiveOrderByCreatedAtDesc(boolean featured, boolean active, Pageable pageable);

    /**
     * Tìm featured courses với limit bằng query method
     * @param limit Số lượng courses
     * @return Danh sách featured courses
     */
    @Query("SELECT c FROM Course c WHERE c.featured = true AND c.active = true ORDER BY c.createdAt DESC")
    List<Course> findFeaturedCourses(@Param("limit") int limit);

    /**
     * Tìm active courses
     * @param active Trạng thái active
     * @return Danh sách active courses
     */
    List<Course> findByActiveOrderByCreatedAtDesc(boolean active);

    /**
     * Đếm tất cả active courses
     * @return Số lượng active courses
     */
    @Query("SELECT COUNT(c) FROM Course c WHERE c.active = true")
    Long countAllActiveCourses();

    // ===== SEARCH QUERIES =====

    /**
     * Search courses theo tên hoặc description
     * @param keyword Từ khóa tìm kiếm
     * @param pageable Pagination info
     * @return Page chứa courses tìm thấy
     */
    @Query("SELECT c FROM Course c WHERE " +
            "(LOWER(c.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND " +
            "c.active = true")
    Page<Course> searchCourses(@Param("keyword") String keyword, Pageable pageable);

    /**
     * Search courses với limit
     * @param keyword Từ khóa tìm kiếm
     * @param limit Số lượng kết quả
     * @return Danh sách courses tìm thấy
     */
    @Query("SELECT c FROM Course c WHERE " +
            "(LOWER(c.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND " +
            "c.active = true " +
            "ORDER BY c.createdAt DESC")
    List<Course> searchCourses(@Param("keyword") String keyword, @Param("limit") int limit);

    // ===== ANALYTICS QUERIES =====

    /**
     * Lấy thống kê enrollment theo tháng
     * @return Danh sách thống kê
     */
    @Query("SELECT MONTH(e.enrollmentDate), YEAR(e.enrollmentDate), COUNT(e) " +
            "FROM Enrollment e " +
            "GROUP BY YEAR(e.enrollmentDate), MONTH(e.enrollmentDate) " +
            "ORDER BY YEAR(e.enrollmentDate) DESC, MONTH(e.enrollmentDate) DESC")
    List<Object[]> getMonthlyEnrollmentStats();

    /**
     * Lấy top courses theo số lượng enrollments
     * @param limit Số lượng courses
     * @return Danh sách top courses
     */
    @Query("SELECT c, COUNT(e) as enrollmentCount " +
            "FROM Course c LEFT JOIN c.enrollments e " +
            "WHERE c.active = true " +
            "GROUP BY c " +
            "ORDER BY enrollmentCount DESC")
    List<Object[]> getTopCoursesByEnrollments(@Param("limit") int limit);

    /**
     * Lấy courses mới nhất
     * @param days Số ngày gần đây
     * @param pageable Pagination info
     * @return Page chứa courses mới
     */
    @Query("SELECT c FROM Course c WHERE c.createdAt >= :since AND c.active = true ORDER BY c.createdAt DESC")
    Page<Course> findRecentCourses(@Param("since") LocalDateTime since, Pageable pageable);

    /**
     * Advanced search với filters
     * @param keyword Từ khóa
     * @param categoryId ID category
     * @param instructorId ID instructor
     * @param difficultyLevel Độ khó
     * @param minPrice Giá tối thiểu
     * @param maxPrice Giá tối đa
     * @param pageable Pagination info
     * @return Page chứa courses phù hợp
     */
    @Query("SELECT c FROM Course c WHERE " +
            "(:keyword IS NULL OR " +
            " LOWER(c.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            " LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND " +
            "(:categoryId IS NULL OR c.category.id = :categoryId) AND " +
            "(:instructorId IS NULL OR c.instructor.id = :instructorId) AND " +
            "(:difficultyLevel IS NULL OR c.difficultyLevel = :difficultyLevel) AND " +
            "(:minPrice IS NULL OR c.price >= :minPrice) AND " +
            "(:maxPrice IS NULL OR c.price <= :maxPrice) AND " +
            "c.active = true " +
            "ORDER BY c.createdAt DESC")
    Page<Course> findCoursesWithFilters(
            @Param("keyword") String keyword,
            @Param("categoryId") Long categoryId,
            @Param("instructorId") Long instructorId,
            @Param("difficultyLevel") String difficultyLevel,
            @Param("minPrice") Double minPrice,
            @Param("maxPrice") Double maxPrice,
            Pageable pageable);

    /**
     * Tìm available courses cho student (chưa đăng ký)
     * @param studentId ID của student
     * @return Danh sách available courses
     */
    @Query("SELECT c FROM Course c WHERE c.active = true AND " +
            "c.id NOT IN (SELECT e.course.id FROM Enrollment e WHERE e.student.id = :studentId)")
    List<Course> findAvailableCoursesForStudent(@Param("studentId") Long studentId);
}