package com.coursemanagement.repository;

import com.coursemanagement.entity.Category;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

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
     * Tìm category theo slug
     * @param slug Slug của category
     * @return Optional chứa Category nếu tìm thấy
     */
    Optional<Category> findBySlug(String slug);

    /**
     * Kiểm tra tên category đã tồn tại chưa
     * @param name Tên category
     * @return true nếu đã tồn tại
     */
    boolean existsByName(String name);

    /**
     * Kiểm tra slug đã tồn tại chưa
     * @param slug Slug
     * @return true nếu đã tồn tại
     */
    boolean existsBySlug(String slug);

    /**
     * Kiểm tra slug đã tồn tại chưa (exclude ID hiện tại)
     * @param slug Slug
     * @param id ID cần exclude
     * @return true nếu đã tồn tại
     */
    boolean existsBySlugAndIdNot(String slug, Long id);

    // ===== SORTING AND ORDERING =====

    /**
     * Tìm tất cả categories sắp xếp theo tên
     * @return Danh sách categories theo alphabet
     */
    List<Category> findAllByOrderByNameAsc();

    /**
     * Tìm categories theo featured status
     * @param featured Featured status
     * @return Danh sách categories
     */
    List<Category> findByFeaturedOrderByNameAsc(boolean featured);

    // ===== SEARCH METHODS =====

    /**
     * Tìm categories theo keyword trong tên
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách categories
     */
    List<Category> findByNameContainingIgnoreCaseOrderByName(String keyword);

    // ===== ACTIVE CATEGORIES WITH COURSES =====

    /**
     * Tìm categories có courses (active)
     * @return Danh sách active categories
     */
    @Query("SELECT DISTINCT c FROM Category c " +
            "WHERE EXISTS (SELECT 1 FROM Course co WHERE co.category = c AND co.active = true)")
    List<Category> findActiveCategoriesWithCourses();

    /**
     * Đếm categories có courses
     * @return Số lượng categories có courses
     */
    @Query("SELECT COUNT(DISTINCT c) FROM Category c " +
            "WHERE EXISTS (SELECT 1 FROM Course co WHERE co.category = c AND co.active = true)")
    Long countActiveCategoriesWithCourses();

    // ===== COURSE COUNT METHODS =====

    /**
     * Đếm courses trong category
     * @param categoryId ID của category
     * @return Số lượng courses
     */
    @Query("SELECT COUNT(c) FROM Course c WHERE c.category.id = :categoryId AND c.active = true")
    Long countCoursesByCategory(@Param("categoryId") Long categoryId);

    /**
     * Tìm top categories theo số lượng courses
     * @param pageable Pagination info
     * @return List array [categoryId, categoryName, courseCount]
     */
    @Query("SELECT c.id, c.name, COUNT(co) " +
            "FROM Category c LEFT JOIN c.courses co " +
            "WHERE co.active = true " +
            "GROUP BY c.id, c.name " +
            "ORDER BY COUNT(co) DESC")
    List<Object[]> findTopCategoriesByCourseCount(Pageable pageable);

    // ===== FEATURED CATEGORIES =====

    /**
     * Tìm featured categories có courses
     * @return Danh sách featured categories có courses
     */
    @Query("SELECT c FROM Category c " +
            "WHERE c.featured = true AND " +
            "EXISTS (SELECT 1 FROM Course co WHERE co.category = c AND co.active = true) " +
            "ORDER BY c.name ASC")
    List<Category> findFeaturedCategoriesWithCourses();

    /**
     * Đếm featured categories
     * @return Số lượng featured categories
     */
    Long countByFeatured(boolean featured);

    // ===== STATISTICS METHODS =====

    /**
     * Lấy thống kê categories với course count
     * @return List array [categoryId, categoryName, courseCount, enrollmentCount]
     */
    @Query("SELECT c.id, c.name, COUNT(DISTINCT co), COUNT(DISTINCT e) " +
            "FROM Category c " +
            "LEFT JOIN c.courses co ON co.active = true " +
            "LEFT JOIN co.enrollments e " +
            "GROUP BY c.id, c.name " +
            "ORDER BY COUNT(DISTINCT co) DESC")
    List<Object[]> getCategoryStatistics();

    /**
     * Tìm categories phổ biến nhất (nhiều enrollments)
     * @param limit Số lượng giới hạn
     * @return Danh sách popular categories
     */
    @Query("SELECT c.id, c.name, COUNT(e) as enrollmentCount " +
            "FROM Category c " +
            "JOIN c.courses co " +
            "JOIN co.enrollments e " +
            "WHERE co.active = true " +
            "GROUP BY c.id, c.name " +
            "ORDER BY COUNT(e) DESC")
    List<Object[]> findPopularCategories(Pageable pageable);

    // ===== CUSTOM COMPLEX QUERIES =====

    /**
     * Tìm categories với thông tin tóm tắt
     * @return List array [categoryId, categoryName, courseCount, avgPrice, totalEnrollments]
     */
    @Query("SELECT c.id, c.name, " +
            "COUNT(DISTINCT co) as courseCount, " +
            "AVG(co.price) as avgPrice, " +
            "COUNT(e) as totalEnrollments " +
            "FROM Category c " +
            "LEFT JOIN c.courses co ON co.active = true " +
            "LEFT JOIN co.enrollments e " +
            "GROUP BY c.id, c.name " +
            "ORDER BY c.name ASC")
    List<Object[]> findCategoriesWithSummary();

    /**
     * Tìm categories có revenue cao nhất
     * @param limit Số lượng giới hạn
     * @return List array [categoryId, categoryName, totalRevenue]
     */
    @Query("SELECT c.id, c.name, SUM(co.price) as totalRevenue " +
            "FROM Category c " +
            "JOIN c.courses co " +
            "JOIN co.enrollments e " +
            "WHERE co.active = true " +
            "GROUP BY c.id, c.name " +
            "ORDER BY SUM(co.price) DESC")
    List<Object[]> findTopRevenueCategories(Pageable pageable);

    // ===== ADMIN MANAGEMENT QUERIES =====

    /**
     * Tìm categories không có courses nào
     * @return Danh sách empty categories
     */
    @Query("SELECT c FROM Category c " +
            "WHERE NOT EXISTS (SELECT 1 FROM Course co WHERE co.category = c)")
    List<Category> findEmptyCategories();

    /**
     * Đếm categories không có courses
     * @return Số lượng empty categories
     */
    @Query("SELECT COUNT(c) FROM Category c " +
            "WHERE NOT EXISTS (SELECT 1 FROM Course co WHERE co.category = c)")
    Long countEmptyCategories();

    /**
     * Tìm categories cần attention (ít courses, ít enrollments)
     * @param minCourses Số courses tối thiểu
     * @param minEnrollments Số enrollments tối thiểu
     * @return Danh sách categories cần attention
     */
    @Query("SELECT c FROM Category c " +
            "WHERE (SELECT COUNT(co) FROM Course co WHERE co.category = c AND co.active = true) < :minCourses " +
            "OR (SELECT COUNT(e) FROM Course co JOIN co.enrollments e WHERE co.category = c AND co.active = true) < :minEnrollments")
    List<Category> findCategoriesNeedingAttention(@Param("minCourses") Long minCourses,
                                                  @Param("minEnrollments") Long minEnrollments);
}