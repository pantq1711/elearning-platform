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
     * Tìm courses của instructor với pagination
     * @param instructor Instructor
     * @param pageable Pagination info
     * @return Page courses
     */
    Page<Course> findByInstructorOrderByCreatedAtDesc(User instructor, Pageable pageable);

    /**
     * Tìm courses của instructor với pagination (List version)
     * @param instructor Instructor
     * @param pageable Pagination info
     * @return Danh sách courses
     */
    List<Course> findByInstructor(User instructor, Pageable pageable);

    /**
     * Tìm courses của instructor theo keyword
     * @param instructor Instructor
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách courses
     */
    @Query("SELECT c FROM Course c WHERE c.instructor = :instructor AND " +
            "(LOWER(c.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            " LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    List<Course> findByInstructorAndKeyword(@Param("instructor") User instructor,
                                            @Param("keyword") String keyword);

    /**
     * Đếm courses của instructor
     * @param instructor Instructor
     * @param active Trạng thái active
     * @return Số lượng courses
     */
    Long countByInstructorAndActive(User instructor, boolean active);

    // ===== CATEGORY-RELATED QUERIES =====

    /**
     * Tìm courses theo category
     * @param category Category
     * @param active Trạng thái active
     * @return Danh sách courses
     */
    List<Course> findByCategoryAndActiveOrderByCreatedAtDesc(Category category, boolean active);

    /**
     * Tìm courses theo category ID
     * @param categoryId ID của category
     * @param active Trạng thái active
     * @return Danh sách courses
     */
    List<Course> findByCategoryIdAndActiveOrderByCreatedAtDesc(Long categoryId, boolean active);

    /**
     * Đếm courses theo category
     * @param category Category
     * @return Số lượng courses
     */
    Long countByCategory(Category category);

    // ===== ACTIVE/STATUS QUERIES =====

    /**
     * Tìm courses active
     * @param active Trạng thái active
     * @return Danh sách courses
     */
    List<Course> findByActiveOrderByCreatedAtDesc(boolean active);

    /**
     * Đếm courses theo trạng thái active
     * @param active Trạng thái active
     * @return Số lượng courses
     */
    Long countByActive(boolean active);

    /**
     * Tìm featured courses
     * @param featured Trạng thái featured
     * @param active Trạng thái active
     * @return Danh sách courses
     */
    List<Course> findByFeaturedAndActiveOrderByCreatedAtDesc(boolean featured, boolean active);

    // ===== SEARCH QUERIES =====

    /**
     * Tìm courses theo tên (search)
     * @param name Tên course
     * @param active Trạng thái active
     * @return Danh sách courses
     */
    List<Course> findByNameContainingIgnoreCaseAndActive(String name, boolean active);

    /**
     * Search courses theo multiple criteria
     * @param keyword Từ khóa tìm kiếm
     * @param active Trạng thái active
     * @param pageable Pagination info
     * @return Page courses
     */
    @Query("SELECT c FROM Course c WHERE c.active = :active AND " +
            "(LOWER(c.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            " LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    Page<Course> findByKeywordAndActive(@Param("keyword") String keyword,
                                        @Param("active") boolean active,
                                        Pageable pageable);

    // ===== POPULAR/ANALYTICS QUERIES =====

    /**
     * Tìm popular courses theo enrollment count
     * @param pageable Pagination info
     * @return Danh sách popular courses
     */
    @Query("SELECT c FROM Course c LEFT JOIN c.enrollments e " +
            "WHERE c.active = true " +
            "GROUP BY c.id, c.name, c.description, c.createdAt, c.updatedAt, " +
            "c.instructor, c.category, c.duration, c.price, c.featured, " +
            "c.active, c.slug, c.imageUrl, c.difficultyLevel, c.language, " +
            "c.prerequisites, c.learningObjectives " +
            "ORDER BY COUNT(e) DESC")
    List<Course> findPopularCourses(Pageable pageable);

    /**
     * Tìm available courses cho student (chưa đăng ký)
     * @param studentId ID của student
     * @return Danh sách available courses
     */
    @Query("SELECT c FROM Course c WHERE c.active = true AND " +
            "c.id NOT IN (SELECT e.course.id FROM Enrollment e WHERE e.student.id = :studentId)")
    List<Course> findAvailableCoursesForStudent(@Param("studentId") Long studentId);

    // ===== STATISTICS QUERIES =====

    /**
     * Lấy thống kê courses theo category
     * @return List array [categoryId, categoryName, courseCount]
     */
    @Query("SELECT c.category.id, c.category.name, COUNT(c) " +
            "FROM Course c " +
            "WHERE c.active = true " +
            "GROUP BY c.category.id, c.category.name " +
            "ORDER BY COUNT(c) DESC")
    List<Object[]> getCourseCountByCategory();

    /**
     * Lấy thống kê courses theo instructor
     * @return List array [instructorId, instructorName, courseCount]
     */
    @Query("SELECT c.instructor.id, c.instructor.fullName, COUNT(c) " +
            "FROM Course c " +
            "WHERE c.active = true " +
            "GROUP BY c.instructor.id, c.instructor.fullName " +
            "ORDER BY COUNT(c) DESC")
    List<Object[]> getCourseCountByInstructor();

    /**
     * Lấy thống kê courses theo tháng
     * @param startDate Ngày bắt đầu
     * @return List array [month, year, count]
     */
    @Query("SELECT MONTH(c.createdAt), YEAR(c.createdAt), COUNT(c) " +
            "FROM Course c " +
            "WHERE c.createdAt >= :startDate " +
            "GROUP BY YEAR(c.createdAt), MONTH(c.createdAt) " +
            "ORDER BY YEAR(c.createdAt), MONTH(c.createdAt)")
    List<Object[]> getCourseStatsByMonth(@Param("startDate") LocalDateTime startDate);

    /**
     * Lấy revenue theo instructor
     * @param instructor Instructor
     * @return Tổng revenue
     */
    @Query("SELECT SUM(c.price * SIZE(c.enrollments)) " +
            "FROM Course c " +
            "WHERE c.instructor = :instructor")
    Double calculateRevenueByInstructor(@Param("instructor") User instructor);

    // ===== ADVANCED QUERIES =====

    /**
     * Tìm courses theo price range
     * @param minPrice Giá tối thiểu
     * @param maxPrice Giá tối đa
     * @param active Trạng thái active
     * @return Danh sách courses
     */
    @Query("SELECT c FROM Course c WHERE c.active = :active AND " +
            "c.price >= :minPrice AND c.price <= :maxPrice " +
            "ORDER BY c.price ASC")
    List<Course> findByPriceRangeAndActive(@Param("minPrice") Double minPrice,
                                           @Param("maxPrice") Double maxPrice,
                                           @Param("active") boolean active);

    /**
     * Tìm courses theo difficulty level
     * @param difficultyLevel Độ khó
     * @param active Trạng thái active
     * @return Danh sách courses
     */
    List<Course> findByDifficultyLevelAndActiveOrderByCreatedAtDesc(String difficultyLevel, boolean active);

    /**
     * Tìm recent courses (trong X ngày gần đây)
     * @param days Số ngày
     * @param active Trạng thái active
     * @return Danh sách recent courses
     */
    @Query("SELECT c FROM Course c WHERE c.active = :active AND " +
            "c.createdAt >= :startDate " +
            "ORDER BY c.createdAt DESC")
    List<Course> findRecentCourses(@Param("startDate") LocalDateTime startDate,
                                   @Param("active") boolean active);

    /**
     * Tìm courses có nhiều enrollments nhất
     * @param limit Số lượng giới hạn
     * @return Danh sách courses
     */
    @Query(value = "SELECT c.* FROM courses c " +
            "LEFT JOIN enrollments e ON c.id = e.course_id " +
            "WHERE c.active = true " +
            "GROUP BY c.id " +
            "ORDER BY COUNT(e.id) DESC " +
            "LIMIT :limit", nativeQuery = true)
    List<Course> findMostEnrolledCourses(@Param("limit") int limit);
}