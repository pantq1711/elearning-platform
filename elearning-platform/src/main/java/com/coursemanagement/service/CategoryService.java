package com.coursemanagement.service;

import com.coursemanagement.entity.Category;
import com.coursemanagement.repository.CategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * Service class để xử lý business logic liên quan đến Category
 */
@Service
@Transactional
public class CategoryService {

    @Autowired
    private CategoryRepository categoryRepository;

    /**
     * Tạo danh mục mới
     * @param category Danh mục cần tạo
     * @return Category đã được tạo
     * @throws RuntimeException Nếu tên danh mục đã tồn tại
     */
    public Category createCategory(Category category) {
        // Kiểm tra tên danh mục đã tồn tại chưa (không phân biệt hoa thường)
        Optional<Category> existingCategory = categoryRepository.findByNameIgnoreCase(category.getName());
        if (existingCategory.isPresent()) {
            throw new RuntimeException("Tên danh mục đã tồn tại: " + category.getName());
        }

        // Validate thông tin danh mục
        validateCategory(category);

        return categoryRepository.save(category);
    }

    /**
     * Cập nhật thông tin danh mục
     * @param id ID của danh mục cần cập nhật
     * @param updatedCategory Thông tin danh mục mới
     * @return Category đã được cập nhật
     * @throws RuntimeException Nếu không tìm thấy danh mục hoặc tên bị trùng
     */
    public Category updateCategory(Long id, Category updatedCategory) {
        // Tìm danh mục hiện tại
        Category existingCategory = categoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy danh mục với ID: " + id));

        // Kiểm tra tên danh mục trùng lặp (loại trừ danh mục hiện tại)
        Optional<Category> duplicateCategory = categoryRepository.findDuplicateName(
                updatedCategory.getName(),
                id
        );

        if (duplicateCategory.isPresent()) {
            throw new RuntimeException("Tên danh mục đã tồn tại: " + updatedCategory.getName());
        }

        // Validate thông tin danh mục mới
        validateCategory(updatedCategory);

        // Cập nhật thông tin
        existingCategory.setName(updatedCategory.getName());
        existingCategory.setDescription(updatedCategory.getDescription());

        return categoryRepository.save(existingCategory);
    }

    /**
     * Xóa danh mục
     * @param id ID của danh mục cần xóa
     * @throws RuntimeException Nếu không tìm thấy danh mục hoặc không thể xóa
     */
    public void deleteCategory(Long id) {
        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy danh mục với ID: " + id));

        // Kiểm tra có thể xóa danh mục không (không có khóa học nào)
        if (!categoryRepository.canDeleteCategory(id)) {
            throw new RuntimeException("Không thể xóa danh mục vì vẫn còn khóa học thuộc danh mục này");
        }

        categoryRepository.delete(category);
    }

    /**
     * Tìm danh mục theo ID
     * @param id ID của danh mục
     * @return Optional<Category>
     */
    public Optional<Category> findById(Long id) {
        return categoryRepository.findById(id);
    }

    /**
     * Tìm danh mục theo tên
     * @param name Tên danh mục
     * @return Optional<Category>
     */
    public Optional<Category> findByName(String name) {
        return categoryRepository.findByName(name);
    }

    /**
     * Lấy tất cả danh mục
     * @return Danh sách tất cả danh mục
     */
    public List<Category> findAll() {
        return categoryRepository.findAll();
    }

    /**
     * Lấy tất cả danh mục sắp xếp theo tên
     * @return Danh sách danh mục đã sắp xếp theo tên A-Z
     */
    public List<Category> findAllOrderByName() {
        return categoryRepository.findAllOrderByName();
    }

    /**
     * Lấy tất cả danh mục sắp xếp theo ngày tạo mới nhất
     * @return Danh sách danh mục sắp xếp theo ngày tạo
     */
    public List<Category> findAllOrderByCreatedDate() {
        return categoryRepository.findAllOrderByCreatedAtDesc();
    }

    /**
     * Tìm kiếm danh mục theo từ khóa
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách danh mục chứa từ khóa
     */
    public List<Category> searchCategories(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return categoryRepository.findAllOrderByName();
        }
        return categoryRepository.findByNameContainingIgnoreCase(keyword.trim());
    }

    /**
     * Lấy danh mục có nhiều khóa học nhất
     * @return Danh sách danh mục sắp xếp theo số khóa học giảm dần
     */
    public List<Category> findCategoriesOrderByCourseCount() {
        return categoryRepository.findCategoriesOrderByCourseCount();
    }

    /**
     * Lấy top danh mục phổ biến nhất
     * @param limit Số lượng danh mục cần lấy
     * @return Danh sách top danh mục
     */
    public List<Category> findTopCategoriesByCourseCount(int limit) {
        return categoryRepository.findTopCategoriesByCourseCount(limit);
    }

    /**
     * Lấy danh mục có khóa học
     * @return Danh sách danh mục có ít nhất một khóa học
     */
    public List<Category> findCategoriesWithCourses() {
        return categoryRepository.findCategoriesWithCourses();
    }

    /**
     * Lấy danh mục không có khóa học
     * @return Danh sách danh mục trống (không có khóa học nào)
     */
    public List<Category> findCategoriesWithoutCourses() {
        return categoryRepository.findCategoriesWithoutCourses();
    }

    /**
     * Đếm số khóa học trong danh mục
     * @param categoryId ID của danh mục
     * @return Số lượng khóa học
     */
    public long countCoursesByCategory(Long categoryId) {
        return categoryRepository.countCoursesByCategoryId(categoryId);
    }

    /**
     * Kiểm tra danh mục có thể xóa được không
     * @param id ID của danh mục
     * @return true nếu có thể xóa, false nếu không thể
     */
    public boolean canDelete(Long id) {
        return categoryRepository.canDeleteCategory(id);
    }

    /**
     * Kiểm tra tên danh mục có tồn tại không
     * @param name Tên danh mục
     * @return true nếu tồn tại, false nếu không
     */
    public boolean existsByName(String name) {
        return categoryRepository.existsByName(name);
    }

    /**
     * Đếm tổng số danh mục
     * @return Tổng số danh mục
     */
    public long countAllCategories() {
        return categoryRepository.count();
    }

    /**
     * Lấy thống kê danh mục
     * @return Danh sách Object[] với [Category, số lượng khóa học]
     */
    public List<Object[]> getCategoryStatistics() {
        return categoryRepository.getCategoryStatistics();
    }

    /**
     * Validate thông tin danh mục
     * @param category Danh mục cần validate
     * @throws RuntimeException Nếu có lỗi validation
     */
    private void validateCategory(Category category) {
        // Kiểm tra tên danh mục
        if (category.getName() == null || category.getName().trim().isEmpty()) {
            throw new RuntimeException("Tên danh mục không được để trống");
        }

        if (category.getName().trim().length() < 2) {
            throw new RuntimeException("Tên danh mục phải có ít nhất 2 ký tự");
        }

        if (category.getName().trim().length() > 100) {
            throw new RuntimeException("Tên danh mục không được vượt quá 100 ký tự");
        }

        // Trim tên danh mục
        category.setName(category.getName().trim());

        // Trim mô tả nếu có
        if (category.getDescription() != null) {
            category.setDescription(category.getDescription().trim());
        }
    }

    /**
     * Tạo danh mục mặc định nếu chưa có
     * Gọi khi khởi động ứng dụng
     */
    public void createDefaultCategoriesIfNotExists() {
        // Kiểm tra đã có danh mục nào chưa
        long categoryCount = categoryRepository.count();

        if (categoryCount == 0) {
            // Tạo các danh mục mặc định
            String[] defaultCategories = {
                    "Lập trình",
                    "Ngoại ngữ",
                    "Kinh doanh",
                    "Thiết kế",
                    "Marketing",
                    "Kỹ năng mềm"
            };

            String[] descriptions = {
                    "Các khóa học về lập trình và phát triển phần mềm",
                    "Các khóa học ngoại ngữ như tiếng Anh, tiếng Nhật...",
                    "Các khóa học về kinh doanh và quản lý",
                    "Các khóa học về thiết kế đồ họa và UI/UX",
                    "Các khóa học về marketing và bán hàng",
                    "Các khóa học phát triển kỹ năng mềm"
            };

            for (int i = 0; i < defaultCategories.length; i++) {
                Category category = new Category();
                category.setName(defaultCategories[i]);
                category.setDescription(descriptions[i]);
                categoryRepository.save(category);
            }

            System.out.println("Đã tạo " + defaultCategories.length + " danh mục mặc định");
        }
    }
}