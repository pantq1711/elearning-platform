package com.coursemanagement.repository;

import com.coursemanagement.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository interface để thao tác với bảng categories
 * Kế thừa JpaRepository để có sẵn các method CRUD cơ bản
 */
@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {

    /**
     * Tìm danh mục theo tên (kiểm tra trùng lặp)
     * @param name Tên danh mục
     * @return Optional<Category> - có thể null nếu không tìm thấy
     */
    Optional<Category> findByName(String name);

    /**
     * Kiểm tra tên danh mục có tồn tại hay không
     * @param name Tên danh mục cần kiểm tra
     * @return true nếu tồn tại, false nếu không tồn tại
     */
    boolean existsByName(String name);

    /**
     * Tìm danh mục theo tên có chứa từ khóa (không phân biệt hoa thường)
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách danh mục chứa từ khóa
     */
    @Query("SELECT c FROM Category c WHERE LOWER(c.name) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<Category> findByNameContainingIgnoreCase(@Param("keyword") String keyword);

    /**
     * Lấy tất cả danh mục sắp xếp theo tên A-Z
     * @return Danh sách danh mục đã sắp xếp
     */
    @Query("SELECT c FROM Category c ORDER BY c.name ASC")
    List<Category> findAllOrderByName();

    /**
     * Lấy tất cả danh mục sắp xếp theo ngày tạo mới nhất
     * @return Danh sách danh mục sắp xếp theo ngày tạo
     */
    @Query("SELECT c FROM Category c ORDER BY c.createdAt DESC")
    List<Category> findAllOrderByCreatedAtDesc();

    /**
     * Lấy danh mục có nhiều khóa học nhất
     * Sử dụng LEFT JOIN để đếm số khóa học trong mỗi danh mục
     * @return Danh sách danh mục sắp xếp theo số khóa học giảm dần
     */
    @Query("SELECT c FROM Category c LEFT JOIN c.courses co GROUP BY c.id ORDER BY COUNT(co) DESC")
    List<Category> findCategoriesOrderByCourseCount();

    /**
     * Đếm số khóa học trong một danh mục
     * @param categoryId ID của danh mục
     * @return Số lượng khóa học
     */
    @Query("SELECT COUNT(co) FROM Course co WHERE co.category.id = :categoryId")
    long countCoursesByCategoryId(@Param("categoryId") Long categoryId);

    /**
     * Tìm danh mục có ít nhất một khóa học
     * @return Danh sách danh mục có khóa học
     */
    @Query("SELECT DISTINCT c FROM Category c INNER JOIN c.courses")
    List<Category> findCategoriesWithCourses();

    /**
     * Tìm danh mục không có khóa học nào
     * @return Danh sách danh mục trống
     */
    @Query("SELECT c FROM Category c WHERE c.id NOT IN (SELECT DISTINCT co.category.id FROM Course co)")
    List<Category> findCategoriesWithoutCourses();

    /**
     * Tìm top N danh mục có nhiều khóa học nhất
     * @param limit Số lượng danh mục cần lấy
     * @return Danh sách top danh mục
     */
    @Query("SELECT c FROM Category c LEFT JOIN c.courses co GROUP BY c.id ORDER BY COUNT(co) DESC LIMIT :limit")
    List<Category> findTopCategoriesByCourseCount(@Param("limit") int limit);

    /**
     * Kiểm tra danh mục có thể xóa được không
     * Chỉ có thể xóa khi không có khóa học nào
     * @param categoryId ID của danh mục
     * @return true nếu có thể xóa, false nếu không thể xóa
     */
    @Query("SELECT CASE WHEN COUNT(co) = 0 THEN true ELSE false END FROM Course co WHERE co.category.id = :categoryId")
    boolean canDeleteCategory(@Param("categoryId") Long categoryId);

    /**
     * Tìm danh mục theo tên chính xác (không phân biệt hoa thường)
     * @param name Tên danh mục
     * @return Optional<Category>
     */
    @Query("SELECT c FROM Category c WHERE LOWER(c.name) = LOWER(:name)")
    Optional<Category> findByNameIgnoreCase(@Param("name") String name);

    /**
     * Tìm danh mục trùng tên khi update (loại trừ danh mục hiện tại)
     * @param name Tên danh mục cần kiểm tra
     * @param excludeId ID của danh mục hiện tại (để loại trừ)
     * @return Optional<Category> - có thể null nếu không trùng
     */
    @Query("SELECT c FROM Category c WHERE LOWER(c.name) = LOWER(:name) AND c.id != :excludeId")
    Optional<Category> findDuplicateName(@Param("name") String name, @Param("excludeId") Long excludeId);

    /**
     * Lấy thống kê số khóa học cho mỗi danh mục
     * Trả về danh sách Object[] với format: [Category, Long courseCount]
     * @return Danh sách thống kê
     */
    @Query("SELECT c, COUNT(co) as courseCount FROM Category c LEFT JOIN c.courses co GROUP BY c.id ORDER BY courseCount DESC")
    List<Object[]> getCategoryStatistics();
}