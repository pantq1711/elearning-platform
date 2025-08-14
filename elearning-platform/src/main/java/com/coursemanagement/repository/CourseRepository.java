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
 * Chứa các custom queries và method names để truy vấn courses
 * Thêm JpaSpecificationExecutor để hỗ trợ dynamic queries
 */
@Repository
public interface CourseRepository extends JpaRepository<Course, Long>, JpaSpecificationExecutor<Course> {

    // ===== BASIC FINDER METHODS =====

    /**
     * Tìm course theo ID và instructor (để kiểm tra quyền sở hữu)
     */
    Optional<Course> findByIdAndInstructor(Long id, User instructor);

    /**
     * Tìm course theo slug
     */
    Optional<Course> findBySlug(String slug);

    /**
     * Kiểm tra course name đã tồn tại chưa
     */
    boolean existsByName(String name);

    /**
     * Kiểm tra slug đã tồn tại chưa
     */
    boolean existsBySlug(String slug);

    // ===== COUNT METHODS =====

    /**
     * Đếm courses theo trạng thái active
     */
    Long countByActive(boolean active);

    /**
     * Đếm featured courses
     */
    Long countByFeaturedAndActive(boolean featured, boolean active);

    /**
     * Đếm courses theo category
     */
    Long countByCategory(Category category);

    /**
     * Đếm courses của instructor
     */
    Long countByInstructorAndActive(User instructor, boolean active);

    // ===== FINDER METHODS =====

    /**
     * Tìm tất cả courses đang active
     */
    List<Course> findAllByActiveTrue();

    /**
     * Tìm courses active theo thời gian tạo
     */
    List<Course> findByActiveOrderByCreatedAtDesc(boolean active);

    /**
     * Tìm featured courses với giới hạn số lượng
     */
    @Query("SELECT c FROM Course c WHERE c.featured = true AND c.active = true ORDER BY c.createdAt DESC")
    List<Course> findFeaturedCourses(@Param("limit") int limit);

    /**
     * Tìm courses theo category với pagination
     */
    Page<Course> findByCategoryIdAndActiveTrue(Long categoryId, Pageable pageable);

    /**
     * Tìm courses phổ biến dựa trên số lượng enrollment
     */
    @Query("SELECT c FROM Course c LEFT JOIN c.enrollments e WHERE c.active = true " +
            "GROUP BY c ORDER BY COUNT(e) DESC")
    Page<Course> findPopularCourses(Pageable pageable);

    /**
     * Tìm courses theo category và active, sắp xếp theo ngày tạo
     */
    List<Course> findByCategoryAndActiveOrderByCreatedAtDesc(Category category, boolean active);

    /**
     * Tìm courses theo category ID và active
     */
    List<Course> findByCategoryIdAndActiveOrderByCreatedAtDesc(Long categoryId, boolean active);

    /**
     * Tìm courses theo tên chứa keyword và active
     */
    List<Course> findByNameContainingIgnoreCaseAndActive(String keyword, boolean active);

    /**
     * Tìm available courses cho student (chưa đăng ký)
     */
    @Query("SELECT c FROM Course c WHERE c.active = true AND c.id NOT IN " +
            "(SELECT e.course.id FROM Enrollment e WHERE e.student.id = :studentId)")
    List<Course> findAvailableCoursesForStudent(@Param("studentId") Long studentId);

    // ===== INSTRUCTOR RELATED METHODS =====

    /**
     * Tìm courses của instructor (chỉ trả về List)
     */
    List<Course> findByInstructorOrderByCreatedAtDesc(User instructor);

    /**
     * Tìm courses của instructor với pagination
     */
    Page<Course> findByInstructor(User instructor, Pageable pageable);

    /**
     * Tìm courses của instructor với pagination và sắp xếp
     */
    @Query("SELECT c FROM Course c WHERE c.instructor = :instructor ORDER BY c.createdAt DESC")
    Page<Course> findByInstructorOrderByCreatedAtDesc(@Param("instructor") User instructor, Pageable pageable);

    /**
     * Tìm courses theo instructor và keyword
     */
    @Query("SELECT c FROM Course c WHERE c.instructor = :instructor AND " +
            "(LOWER(c.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
            "ORDER BY c.createdAt DESC")
    List<Course> findByInstructorAndKeyword(@Param("instructor") User instructor,
                                            @Param("keyword") String keyword);

    // ===== SEARCH METHODS =====

    /**
     * Tìm courses theo keyword với limit
     */
    @Query("SELECT c FROM Course c WHERE c.active = true AND " +
            "(LOWER(c.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
            "ORDER BY c.createdAt DESC")
    List<Course> searchCourses(@Param("keyword") String keyword, @Param("limit") int limit);

    /**
     * Tìm courses với filters kết hợp
     */
    @Query("SELECT c FROM Course c WHERE " +
            "(:keyword IS NULL OR LOWER(c.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND " +
            "(:categoryId IS NULL OR c.category.id = :categoryId) AND " +
            "(:instructorId IS NULL OR c.instructor.id = :instructorId) AND " +
            "c.active = :active " +
            "ORDER BY c.createdAt DESC")
    Page<Course> findCoursesWithFilters(@Param("keyword") String keyword,
                                        @Param("categoryId") Long categoryId,
                                        @Param("instructorId") Long instructorId,
                                        @Param("active") boolean active,
                                        Pageable pageable);

    // ===== STATISTICS METHODS =====

    /**
     * Lấy thống kê số course theo category
     */
    @Query("SELECT c.category.id, c.category.name, COUNT(c) FROM Course c " +
            "WHERE c.active = true GROUP BY c.category.id, c.category.name " +
            "ORDER BY COUNT(c) DESC")
    List<Object[]> getCourseCountByCategory();

    /**
     * Lấy thống kê số course theo instructor
     */
    @Query("SELECT c.instructor.id, c.instructor.fullName, COUNT(c) FROM Course c " +
            "WHERE c.active = true GROUP BY c.instructor.id, c.instructor.fullName " +
            "ORDER BY COUNT(c) DESC")
    List<Object[]> getCourseCountByInstructor();

    /**
     * Lấy thống kê courses theo tháng
     */
    @Query("SELECT YEAR(c.createdAt), MONTH(c.createdAt), COUNT(c) FROM Course c " +
            "WHERE c.createdAt >= :fromDate GROUP BY YEAR(c.createdAt), MONTH(c.createdAt) " +
            "ORDER BY YEAR(c.createdAt), MONTH(c.createdAt)")
    List<Object[]> getCourseStatsByMonth(@Param("fromDate") LocalDateTime fromDate);
}