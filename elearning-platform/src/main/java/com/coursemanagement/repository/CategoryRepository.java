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

import java.util.List;
import java.util.Optional;

/**
 * Repository interface cho Category entity
 * Chứa các custom queries cho category management
 * Cập nhật với đầy đủ methods cần thiết
 */
@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {

    // ===== BASIC FINDER METHODS =====

    /**
     * Tìm category theo tên
     * @param name Tên category
     * @return Optional chứa Category nếu tìm thấy
     */
    Optional<Category> findByName(String name);

    /**
     * Kiểm tra tên category đã tồn tại chưa
     * @param name Tên category
     * @return true nếu đã tồn tại
     */
    boolean existsByName(String name);

    /**
     * Kiểm tra tên category đã tồn tại chưa (exclude ID hiện tại)
     * @param name Tên category
     * @param id ID cần exclude
     * @return true nếu đã tồn tại
     */
    boolean existsByNameAndIdNot(String name, Long id);

    // ===== FEATURED CATEGORIES =====

    /**
     * Tìm categories theo featured status
     * @param featured Featured status
     * @return Danh sách categories
     */
    List<Category> findByFeaturedOrderByNameAsc(boolean featured);

    /**
     * Tìm featured categories với pagination
     * @param featured Featured status
     * @param pageable Pagination info
     * @return Danh sách categories
     */
    List<Category> findByFeatured(boolean featured, Pageable pageable);

    /**
     * Đếm categories theo featured status
     * @param featured Featured status
     * @return Số lượng categories
     */
    Long countByFeatured(boolean featured);

    /**
     * Cập nhật featured status của category
     * @param id ID category
     * @param featured Featured status mới
     */
    @Modifying
    @Transactional
    @Query("UPDATE Category c SET c.featured = :featured WHERE c.id = :id")
    void updateFeaturedStatus(@Param("id") Long id, @Param("featured") boolean featured);

    // ===== SEARCH METHODS =====

    /**
     * Search categories theo tên (không phân biệt hoa thường)
     * @param keyword Từ khóa tìm kiếm
     * @param pageable Pagination info
     * @return Page chứa categories tìm thấy
     */
    @Query("SELECT c FROM Category c WHERE LOWER(c.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    Page<Category> searchByName(@Param("keyword") String keyword, Pageable pageable);

    /**
     * Search categories với limit
     * @param keyword Từ khóa tìm kiếm
     * @param limit Số lượng kết quả
     * @return Danh sách categories tìm thấy
     */
    @Query("SELECT c FROM Category c WHERE " +
            "LOWER(c.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "ORDER BY c.name")
    List<Category> searchCategories(@Param("keyword") String keyword, @Param("limit") int limit);

    // ===== COURSE COUNT QUERIES =====

    /**
     * Cập nhật course count cho category
     * @param id ID category
     * @param courseCount Số lượng courses mới
     */
    @Modifying
    @Transactional
    @Query("UPDATE Category c SET c.courseCount = :courseCount WHERE c.id = :id")
    void updateCourseCount(@Param("id") Long id, @Param("courseCount") int courseCount);

    /**
     * Đếm categories có ít nhất 1 course
     * @return Số lượng categories có courses
     */
    @Query("SELECT COUNT(c) FROM Category c WHERE c.courseCount > 0")
    Long countCategoriesWithCourses();

    /**
     * Lấy average courses per category
     * @return Average courses per category
     */
    @Query("SELECT AVG(c.courseCount) FROM Category c")
    Double getAverageCoursesPerCategory();

    // ===== ANALYTICS QUERIES =====

    /**
     * Lấy top categories theo course count
     * @param limit Số lượng categories
     * @return Danh sách [Category, CourseCount]
     */
    @Query("SELECT c FROM Category c ORDER BY c.courseCount DESC")
    List<Category> getTopCategoriesByCourseCount(@Param("limit") int limit);

    /**
     * Lấy category performance stats
     * @return Danh sách [CategoryName, CourseCount, EnrollmentCount]
     */
    @Query("SELECT c.name, c.courseCount, " +
            "(SELECT COUNT(e) FROM Enrollment e WHERE e.course.category = c) as enrollmentCount " +
            "FROM Category c " +
            "ORDER BY enrollmentCount DESC")
    List<Object[]> getCategoryPerformanceStats();

    /**
     * Lấy thống kê categories theo course count ranges
     * @return Danh sách [Range, Count]
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
     * Tìm categories chưa có courses
     * @return Danh sách empty categories
     */
    @Query("SELECT c FROM Category c WHERE c.courseCount = 0")
    List<Category> findEmptyCategories();

    /**
     * Tìm categories có nhiều courses nhất
     * @param limit Số lượng categories
     * @return Danh sách popular categories
     */
    @Query("SELECT c FROM Category c WHERE c.courseCount > 0 ORDER BY c.courseCount DESC")
    List<Category> findMostPopularCategories(@Param("limit") int limit);

    /**
     * Lấy categories được tạo gần đây
     * @param limit Số lượng categories
     * @return Danh sách recent categories
     */
    @Query("SELECT c FROM Category c ORDER BY c.createdAt DESC")
    List<Category> findRecentCategories(@Param("limit") int limit);

    /**
     * Tìm categories theo color code
     * @param colorCode Mã màu
     * @return Danh sách categories có cùng màu
     */
    List<Category> findByColorCode(String colorCode);

    /**
     * Tìm categories theo icon class
     * @param iconClass Icon class
     * @return Danh sách categories có cùng icon
     */
    List<Category> findByIconClass(String iconClass);

    /**
     * Lấy tất cả color codes đang sử dụng
     * @return Danh sách color codes
     */
    @Query("SELECT DISTINCT c.colorCode FROM Category c WHERE c.colorCode IS NOT NULL")
    List<String> findAllUsedColorCodes();

    /**
     * Lấy tất cả icon classes đang sử dụng
     * @return Danh sách icon classes
     */
    @Query("SELECT DISTINCT c.iconClass FROM Category c WHERE c.iconClass IS NOT NULL")
    List<String> findAllUsedIconClasses();

    /**
     * Lấy category stats với enrollment data
     * @return Danh sách [CategoryId, CategoryName, CourseCount, TotalEnrollments, CompletedEnrollments]
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
}