// ===== CategoryRepository.java =====
package com.coursemanagement.repository;

import com.coursemanagement.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository interface cho Category entity
 */
@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {

    /**
     * Tìm tất cả categories sắp xếp theo tên
     */
    List<Category> findAllByOrderByNameAsc();

    /**
     * Tìm category theo tên
     */
    Optional<Category> findByName(String n);

    /**
     * Tìm category theo slug
     */
    Optional<Category> findBySlug(String slug);

    /**
     * Kiểm tra tên category đã tồn tại chưa
     */
    boolean existsByName(String n);

    /**
     * Tìm featured categories
     */
    List<Category> findByFeaturedOrderByNameAsc(boolean featured);

    /**
     * Đếm featured categories
     */
    Long countByFeatured(boolean featured);

    /**
     * Tìm categories có courses active
     */
    @Query("SELECT DISTINCT c FROM Category c JOIN Course co ON c = co.category WHERE co.active = true")
    List<Category> findActiveCategoriesWithCourses();

    /**
     * Đếm categories có courses active
     */
    @Query("SELECT COUNT(DISTINCT c) FROM Category c JOIN Course co ON c = co.category WHERE co.active = true")
    Long countActiveCategoriesWithCourses();

    /**
     * Đếm courses active trong category
     */
    @Query("SELECT COUNT(co) FROM Course co WHERE co.category.id = :categoryId AND co.active = true")
    Long countActiveCoursesInCategory(@Param("categoryId") Long categoryId);

    /**
     * Tìm top categories theo số courses
     */
    @Query("SELECT c FROM Category c ORDER BY " +
            "(SELECT COUNT(co) FROM Course co WHERE co.category = c AND co.active = true) DESC")
    List<Category> findTopCategoriesByCourseCount(@Param("limit") int limit);
}


