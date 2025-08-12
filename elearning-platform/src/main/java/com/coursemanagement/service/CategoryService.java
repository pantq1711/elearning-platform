package com.coursemanagement.service;

import com.coursemanagement.entity.Category;
import com.coursemanagement.repository.CategoryRepository;
import com.coursemanagement.repository.CourseRepository;
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

    @Autowired
    private CourseRepository courseRepository;

    /**
     * Tạo danh mục mới
     * @param category Danh mục cần tạo
     * @return Category đã được tạo
     * @throws RuntimeException Nếu tên danh mục đã tồn tại
     */
    public Category createCategory(Category category) {
        // Validate thông tin danh mục
        validateCategory(category);

        // Kiểm tra tên danh mục đã tồn tại chưa (không phân biệt hoa thường)
        Optional<Category> existingCategory = categoryRepository.findByNameIgnoreCase(category.getName().trim());
        if (existingCategory.isPresent()) {
            throw new RuntimeException("Tên danh mục đã tồn tại: " + category.getName());
        }

        // Chuẩn hóa tên danh mục
        category.setName(category.getName().trim());

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

        // Validate thông tin danh mục mới
        validateCategory(updatedCategory);

        // Chuẩn hóa tên danh mục
        String newName = updatedCategory.getName().trim();

        // Kiểm tra tên danh mục trùng lặp (loại trừ chính nó)
        Optional<Category> duplicateCategory = categoryRepository.findByNameIgnoreCase(newName);
        if (duplicateCategory.isPresent() && !duplicateCategory.get().getId().equals(id)) {
            throw new RuntimeException("Tên danh mục đã tồn tại: " + newName);
        }

        // Cập nhật thông tin
        existingCategory.setName(newName);
        existingCategory.setDescription(updatedCategory.getDescription() != null ?
                updatedCategory.getDescription().trim() : null);

        return categoryRepository.save(existingCategory);
    }

    /**
     * Xóa danh mục (chỉ khi không có khóa học nào)
     * @param id ID của danh mục cần xóa
     * @throws RuntimeException Nếu không tìm thấy danh mục hoặc không thể xóa
     */
    public void deleteCategory(Long id) {
        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy danh mục với ID: " + id));

        // Kiểm tra có khóa học nào trong danh mục không
        long courseCount = courseRepository.countByCategory(category);
        if (courseCount > 0) {
            throw new RuntimeException("Không thể xóa danh mục đã có khóa học. " +
                    "Vui lòng xóa hoặc chuyển các khóa học sang danh mục khác trước.");
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
     * Tìm tất cả danh mục
     * @return Danh sách tất cả danh mục
     */
    public List<Category> findAll() {
        return categoryRepository.findAllOrderByName();
    }

    /**
     * Tìm danh mục theo tên
     * @param name Tên danh mục
     * @return Optional<Category>
     */
    public Optional<Category> findByName(String name) {
        if (name == null || name.trim().isEmpty()) {
            return Optional.empty();
        }
        return categoryRepository.findByNameIgnoreCase(name.trim());
    }

    /**
     * Tìm kiếm danh mục theo từ khóa
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách danh mục chứa từ khóa
     */
    public List<Category> searchCategories(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return findAll();
        }
        return categoryRepository.findByNameContainingIgnoreCase(keyword.trim());
    }

    /**
     * Đếm tổng số danh mục
     * @return Số lượng danh mục
     */
    public long countAllCategories() {
        return categoryRepository.count();
    }

    /**
     * Lấy danh mục có nhiều khóa học nhất
     * @param limit Số lượng danh mục cần lấy
     * @return Danh sách danh mục phổ biến
     */
    public List<Category> findTopCategoriesByCourseCount(int limit) {
        return categoryRepository.findTopCategoriesByCourseCount(limit);
    }

    /**
     * Kiểm tra danh mục có thể xóa không
     * @param id ID danh mục
     * @return true nếu có thể xóa, false nếu không thể
     */
    public boolean canCategoryBeDeleted(Long id) {
        Optional<Category> categoryOpt = findById(id);
        if (categoryOpt.isEmpty()) {
            return false;
        }

        long courseCount = courseRepository.countByCategory(categoryOpt.get());
        return courseCount == 0;
    }

    /**
     * Lấy số lượng khóa học theo danh mục
     * @param categoryId ID danh mục
     * @return Số lượng khóa học
     */
    public long getCourseCountByCategory(Long categoryId) {
        Optional<Category> categoryOpt = findById(categoryId);
        if (categoryOpt.isEmpty()) {
            return 0;
        }
        return courseRepository.countByCategory(categoryOpt.get());
    }

    /**
     * Validate thông tin danh mục
     * @param category Danh mục cần validate
     * @throws RuntimeException Nếu validation fail
     */
    private void validateCategory(Category category) {
        if (category == null) {
            throw new RuntimeException("Thông tin danh mục không được để trống");
        }

        if (category.getName() == null || category.getName().trim().isEmpty()) {
            throw new RuntimeException("Tên danh mục không được để trống");
        }

        String name = category.getName().trim();
        if (name.length() < 2) {
            throw new RuntimeException("Tên danh mục phải có ít nhất 2 ký tự");
        }

        if (name.length() > 100) {
            throw new RuntimeException("Tên danh mục không được vượt quá 100 ký tự");
        }

        // Kiểm tra ký tự hợp lệ (chỉ cho phép chữ, số, khoảng trắng và một số ký tự đặc biệt)
        if (!name.matches("^[a-zA-ZÀ-ỹ0-9\\s\\-_&/()]+$")) {
            throw new RuntimeException("Tên danh mục chỉ được chứa chữ cái, số và một số ký tự đặc biệt");
        }

        // Validate mô tả nếu có
        if (category.getDescription() != null && !category.getDescription().trim().isEmpty()) {
            String description = category.getDescription().trim();
            if (description.length() > 500) {
                throw new RuntimeException("Mô tả danh mục không được vượt quá 500 ký tự");
            }
        }
    }
}