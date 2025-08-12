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
     * Tìm danh mục theo tên (không phân biệt hoa thường)
     * @param name Tên danh mục
     * @return Optional<Category>
     */
    @Query("SELECT c FROM Category c WHERE LOWER(c.name) = LOWER(:name)")
    Optional<Category> findByNameIgnoreCase(@Param("name") String name);

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
     * Lấy danh mục có nhiều khóa học nhất
     * @param limit Số lượng danh mục cần lấy
     * @return Danh sách danh mục phổ biến
     */
    @Query("SELECT cat FROM Category cat " +
            "LEFT JOIN cat.courses c " +
            "GROUP BY cat " +
            "ORDER BY COUNT(c) DESC " +
            "LIMIT :limit")
    List<Category> findTopCategoriesByCourseCount(@Param("limit") int limit);

    /**
     * Tìm danh mục theo mô tả có chứa từ khóa
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách danh mục có mô tả chứa từ khóa
     */
    @Query("SELECT c FROM Category c WHERE LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<Category> findByDescriptionContainingIgnoreCase(@Param("keyword") String keyword);

    /**
     * Tìm danh mục theo tên hoặc mô tả có chứa từ khóa
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách danh mục chứa từ khóa trong tên hoặc mô tả
     */
    @Query("SELECT c FROM Category c WHERE " +
            "LOWER(c.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "ORDER BY c.name ASC")
    List<Category> searchCategories(@Param("keyword") String keyword);

    /**
     * Lấy danh mục được tạo gần đây nhất
     * @param limit Số lượng danh mục cần lấy
     * @return Danh sách danh mục mới nhất
     */
    @Query("SELECT c FROM Category c ORDER BY c.createdAt DESC LIMIT :limit")
    List<Category> findRecentCategories(@Param("limit") int limit);

    /**
     * Đếm số khóa học theo danh mục
     * @param categoryId ID danh mục
     * @return Số lượng khóa học trong danh mục
     */
    @Query("SELECT COUNT(c) FROM Course c WHERE c.category.id = :categoryId")
    long countCoursesByCategoryId(@Param("categoryId") Long categoryId);

    /**
     * Đếm số khóa học đang hoạt động theo danh mục
     * @param categoryId ID danh mục
     * @return Số lượng khóa học đang hoạt động trong danh mục
     */
    @Query("SELECT COUNT(c) FROM Course c WHERE c.category.id = :categoryId AND c.isActive = true")
    long countActiveCoursesByCategoryId(@Param("categoryId") Long categoryId);

    /**
     * Lấy thống kê danh mục với số lượng khóa học
     * @return Danh sách [CategoryId, CategoryName, CourseCount]
     */
    @Query("SELECT cat.id, cat.name, COUNT(c) FROM Category cat " +
            "LEFT JOIN cat.courses c " +
            "GROUP BY cat.id, cat.name " +
            "ORDER BY COUNT(c) DESC")
    List<Object[]> getCategoryStatistics();

    /**
     * Tìm danh mục có khóa học đang hoạt động
     * @return Danh sách danh mục có ít nhất 1 khóa học đang hoạt động
     */
    @Query("SELECT DISTINCT cat FROM Category cat " +
            "INNER JOIN cat.courses c " +
            "WHERE c.isActive = true " +
            "ORDER BY cat.name ASC")
    List<Category> findCategoriesWithActiveCourses();

    /**
     * Tìm danh mục không có khóa học nào
     * @return Danh sách danh mục rỗng
     */
    @Query("SELECT cat FROM Category cat " +
            "WHERE cat.id NOT IN (SELECT DISTINCT c.category.id FROM Course c) " +
            "ORDER BY cat.name ASC")
    List<Category> findEmptyCategories();

    /**
     * Kiểm tra danh mục có thể xóa không (không có khóa học nào)
     * @param categoryId ID danh mục
     * @return true nếu có thể xóa
     */
    @Query("SELECT CASE WHEN COUNT(c) = 0 THEN true ELSE false END " +
            "FROM Course c WHERE c.category.id = :categoryId")
    boolean canCategoryBeDeleted(@Param("categoryId") Long categoryId);

    /**
     * Tìm danh mục theo khoảng thời gian tạo
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Danh sách danh mục trong khoảng thời gian
     */
    @Query("SELECT c FROM Category c WHERE c.createdAt BETWEEN :startDate AND :endDate " +
            "ORDER BY c.createdAt DESC")
    List<Category> findCategoriesByDateRange(@Param("startDate") java.time.LocalDateTime startDate,
                                             @Param("endDate") java.time.LocalDateTime endDate);

    /**
     * Lấy số lượng danh mục được tạo trong tháng hiện tại
     * @return Số lượng danh mục mới
     */
    @Query("SELECT COUNT(c) FROM Category c WHERE " +
            "YEAR(c.createdAt) = YEAR(CURRENT_DATE) AND " +
            "MONTH(c.createdAt) = MONTH(CURRENT_DATE)")
    long countCategoriesCreatedThisMonth();

    /**
     * Lấy tổng số khóa học trong tất cả danh mục
     * @return Tổng số khóa học
     */
    @Query("SELECT COUNT(c) FROM Course c")
    long countTotalCourses();
}