package com.coursemanagement.repository;

import com.coursemanagement.entity.Category;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Repository interface cho Category entity
 * Chứa các custom queries cho category management
 */
@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {

    // ===== BASIC FINDER METHODS =====

    /**
     * Tìm category theo tên
     */
    Optional<Category> findByName(String name);

    /**
     * Kiểm tra tên category đã tồn tại chưa
     */
    boolean existsByName(String name);

    /**
     * Kiểm tra tên category đã tồn tại chưa (exclude ID hiện tại)
     */
    boolean existsByNameAndIdNot(String name, Long id);

    /**
     * Tìm tất cả categories active sắp xếp theo tên
     */
    List<Category> findAllByActiveTrueOrderByName();

    /**
     * Tìm categories theo active status với pagination
     */
    Page<Category> findByActive(boolean active, Pageable pageable);

    /**
     * Đếm categories active
     */
    Long countByActive(boolean active);

    /**
     * Đếm tổng số categories
     */
    @Query("SELECT COUNT(c) FROM Category c")
    Long countAllCategories();

    // ===== FEATURED CATEGORIES =====

    /**
     * Tìm categories theo featured status
     */
    List<Category> findByFeaturedOrderByNameAsc(boolean featured);

    /**
     * Tìm featured categories với pagination
     */
    List<Category> findByFeatured(boolean featured, Pageable pageable);

    /**
     * Đếm categories theo featured status
     */
    Long countByFeatured(boolean featured);

    /**
     * Cập nhật featured status của category
     */
    @Modifying
    @Transactional
    @Query("UPDATE Category c SET c.featured = :featured WHERE c.id = :id")
    void updateFeaturedStatus(@Param("id") Long id, @Param("featured") boolean featured);

    // ===== SEARCH METHODS =====

    /**
     * Search categories theo tên và description
     */
    @Query("SELECT c FROM Category c WHERE LOWER(c.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    Page<Category> searchByName(@Param("keyword") String keyword, Pageable pageable);

    /**
     * Search categories với limit
     */
    @Query("SELECT c FROM Category c WHERE " +
            "LOWER(c.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "ORDER BY c.name")
    List<Category> searchCategories(@Param("keyword") String keyword, @Param("limit") int limit);

    /**
     * Tìm categories theo keyword (active only)
     */
    @Query("SELECT c FROM Category c WHERE c.active = true AND " +
            "(LOWER(c.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
            "ORDER BY c.name")
    Page<Category> findByKeyword(@Param("keyword") String keyword, Pageable pageable);

    // ===== COURSE COUNT QUERIES =====

    /**
     * Cập nhật course count cho category
     */
    @Modifying
    @Transactional
    @Query("UPDATE Category c SET c.courseCount = :courseCount WHERE c.id = :id")
    void updateCourseCount(@Param("id") Long id, @Param("courseCount") int courseCount);

    /**
     * Đếm categories có ít nhất 1 course
     */
    @Query("SELECT COUNT(c) FROM Category c WHERE c.courseCount > 0")
    Long countCategoriesWithCourses();

    /**
     * Lấy average courses per category
     */
    @Query("SELECT AVG(c.courseCount) FROM Category c")
    Double getAverageCoursesPerCategory();

    /**
     * Đếm số courses trong category
     */
    @Query("SELECT COUNT(c) FROM Course c WHERE c.category = :category")
    Long countCoursesByCategory(@Param("category") Category category);

    /**
     * Đếm số active courses trong category
     */
    @Query("SELECT COUNT(c) FROM Course c WHERE c.category = :category AND c.active = :active")
    Long countCoursesByCategoryAndActive(@Param("category") Category category, @Param("active") boolean active);

    // ===== COURSE RELATIONSHIP QUERIES =====

    /**
     * Tìm categories có courses active
     */
    @Query("SELECT DISTINCT c FROM Category c INNER JOIN c.courses co WHERE co.active = true " +
            "ORDER BY c.name")
    List<Category> findCategoriesWithActiveCourses();

    /**
     * Tìm categories không có courses nào
     */
    @Query("SELECT c FROM Category c WHERE c.courses IS EMPTY ORDER BY c.name")
    List<Category> findEmptyCategories();

    /**
     * Tìm categories có ít nhất 1 course
     */
    @Query("SELECT c FROM Category c WHERE c.courses IS NOT EMPTY ORDER BY c.name")
    List<Category> findCategoriesWithCourses();

    /**
     * Tìm categories với số lượng courses
     */
    @Query("SELECT c, COUNT(co) FROM Category c LEFT JOIN c.courses co " +
            "WHERE c.active = true GROUP BY c ORDER BY c.name")
    List<Object[]> findCategoriesWithCourseCount();

    // ===== TOP CATEGORIES QUERIES =====

    /**
     * Lấy top categories theo course count (sử dụng courseCount field)
     */
    @Query("SELECT c FROM Category c ORDER BY c.courseCount DESC")
    List<Category> getTopCategoriesByCourseCount(@Param("limit") int limit);

    /**
     * Tìm top categories theo số lượng courses (sử dụng JOIN)
     */
    @Query("SELECT c FROM Category c LEFT JOIN c.courses co WHERE c.active = true " +
            "GROUP BY c ORDER BY COUNT(co) DESC")
    List<Category> findTopCategoriesByCourseCountJoin(@Param("limit") int limit);

    /**
     * Tìm categories có nhiều courses nhất
     */
    @Query("SELECT c FROM Category c WHERE c.courseCount > 0 ORDER BY c.courseCount DESC")
    List<Category> findMostPopularCategories(@Param("limit") int limit);

    /**
     * Tìm popular categories (có nhiều enrollments)
     */
    @Query("SELECT c FROM Category c LEFT JOIN c.courses co LEFT JOIN co.enrollments e " +
            "WHERE c.active = true GROUP BY c ORDER BY COUNT(e) DESC")
    List<Category> findPopularCategories(@Param("limit") int limit);

    // ===== RECENT CATEGORIES =====

    /**
     * Lấy categories được tạo gần đây (by limit)
     */
    @Query("SELECT c FROM Category c ORDER BY c.createdAt DESC")
    List<Category> findRecentCategories(@Param("limit") int limit);

    /**
     * Tìm categories được tạo gần đây (by date)
     */
    @Query("SELECT c FROM Category c WHERE c.createdAt >= :fromDate ORDER BY c.createdAt DESC")
    List<Category> findRecentCategoriesByDate(@Param("fromDate") LocalDateTime fromDate);

    // ===== APPEARANCE QUERIES =====

    /**
     * Tìm categories theo color code
     */
    List<Category> findByColorCode(String colorCode);

    /**
     * Tìm categories theo icon class
     */
    List<Category> findByIconClass(String iconClass);

    /**
     * Lấy tất cả color codes đang sử dụng
     */
    @Query("SELECT DISTINCT c.colorCode FROM Category c WHERE c.colorCode IS NOT NULL")
    List<String> findAllUsedColorCodes();

    /**
     * Lấy tất cả icon classes đang sử dụng
     */
    @Query("SELECT DISTINCT c.iconClass FROM Category c WHERE c.iconClass IS NOT NULL")
    List<String> findAllUsedIconClasses();

    // ===== ANALYTICS QUERIES =====

    /**
     * Lấy category performance stats
     */
    @Query("SELECT c.name, c.courseCount, " +
            "(SELECT COUNT(e) FROM Enrollment e WHERE e.course.category = c) as enrollmentCount " +
            "FROM Category c " +
            "ORDER BY enrollmentCount DESC")
    List<Object[]> getCategoryPerformanceStats();

    /**
     * Lấy thống kê categories theo số courses
     */
    @Query("SELECT c.name, COUNT(co), SUM(CASE WHEN co.active = true THEN 1 ELSE 0 END) " +
            "FROM Category c LEFT JOIN c.courses co GROUP BY c.id, c.name ORDER BY COUNT(co) DESC")
    List<Object[]> getCategoryStats();

    /**
     * Lấy thống kê categories theo course count ranges
     */
    @Query("SELECT " +
            "CASE " +
            "WHEN c.courseCount = 0 THEN 'No courses' " +
            "WHEN c.courseCount <= 5 THEN '1-5 courses' " +
            "WHEN c.courseCount <= 10 THEN '6-10 courses' " +
            "WHEN c.courseCount <= 20 THEN '11-20 courses' " +
            "ELSE '20+ courses' END as courseRange, " +
            "COUNT(c) " +
            "FROM Category c " +
            "GROUP BY " +
            "CASE " +
            "WHEN c.courseCount = 0 THEN 'No courses' " +
            "WHEN c.courseCount <= 5 THEN '1-5 courses' " +
            "WHEN c.courseCount <= 10 THEN '6-10 courses' " +
            "WHEN c.courseCount <= 20 THEN '11-20 courses' " +
            "ELSE '20+ courses' END")
    List<Object[]> getCategoryDistributionStats();

    /**
     * Lấy category stats với enrollment data
     */
    @Query("SELECT c.id, c.name, c.courseCount, " +
            "COALESCE(SUM(ec.enrollmentCount), 0) as totalEnrollments, " +
            "COALESCE(SUM(ec.completedCount), 0) as completedEnrollments " +
            "FROM Category c " +
            "LEFT JOIN (" +
            "    SELECT co.category.id as categoryId, " +
            "           COUNT(e) as enrollmentCount, " +
            "           SUM(CASE WHEN e.completed = true THEN 1 ELSE 0 END) as completedCount " +
            "    FROM Course co " +
            "    LEFT JOIN co.enrollments e " +
            "    GROUP BY co.category.id" +
            ") ec ON c.id = ec.categoryId " +
            "GROUP BY c.id, c.name, c.courseCount " +
            "ORDER BY totalEnrollments DESC")
    List<Object[]> getCategoriesWithEnrollmentStats();

    /**
     * Lấy revenue theo category
     */
    @Query("SELECT c.name, SUM(COALESCE(co.price, 0) * SIZE(co.enrollments)) " +
            "FROM Category c LEFT JOIN c.courses co GROUP BY c.id, c.name " +
            "ORDER BY SUM(COALESCE(co.price, 0) * SIZE(co.enrollments)) DESC")
    List<Object[]> getRevenueByCategory();
}