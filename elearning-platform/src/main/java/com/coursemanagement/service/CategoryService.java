package com.coursemanagement.service;

import com.coursemanagement.entity.Category;
import com.coursemanagement.utils.CourseUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Service class để xử lý business logic liên quan đến Category
 * Quản lý CRUD operations và business rules cho categories
 */
@Service
@Transactional
public class CategoryService {

    @Autowired
    private CategoryRepository categoryRepository;

    /**
     * Tìm category theo ID
     * @param id ID của category
     * @return Optional chứa Category nếu tìm thấy
     */
    public Optional<Category> findById(Long id) {
        return categoryRepository.findById(id);
    }

    /**
     * Tìm tất cả categories sắp xếp theo tên
     * @return Danh sách categories theo alphabet
     */
    public List<Category> findAllOrderByName() {
        return categoryRepository.findAllByOrderByNameAsc();
    }

    /**
     * Tìm featured categories
     * @return Danh sách featured categories
     */
    public List<Category> findFeaturedCategories() {
        return categoryRepository.findByFeaturedOrderByNameAsc(true);
    }

    /**
     * Tìm categories active (có courses)
     * @return Danh sách active categories
     */
    public List<Category> findActiveCategories() {
        return categoryRepository.findActiveCategoriesWithCourses();
    }

    /**
     * Tạo category mới
     * @param category Category cần tạo
     * @return Category đã được tạo
     */
    public Category createCategory(Category category) {
        validateCategory(category);

        // Kiểm tra tên category đã tồn tại chưa
        if (categoryRepository.existsByName(category.getName())) {
            throw new RuntimeException("Tên danh mục đã tồn tại: " + category.getName());
        }

        // Tạo slug từ tên category
        category.setSlug(CourseUtils.StringUtils.createSlug(category.getName()));

        // Set thời gian tạo
        category.setCreatedAt(LocalDateTime.now());

        // Mặc định featured = false nếu chưa set
        if (category.isFeatured() == null) {
            category.setFeatured(false);
        }

        // Khởi tạo course count = 0
        category.setCourseCount(0L);

        return categoryRepository.save(category);
    }

    /**
     * Cập nhật category
     * @param category Category cần cập nhật
     * @return Category đã được cập nhật
     */
    public Category updateCategory(Category category) {
        if (category.getId() == null) {
            throw new RuntimeException("ID category không được để trống khi cập nhật");
        }

        Category existingCategory = categoryRepository.findById(category.getId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy category với ID: " + category.getId()));

        validateCategory(category);

        // Kiểm tra tên category conflict (trừ chính category đó)
        if (!existingCategory.getName().equals(category.getName()) &&
                categoryRepository.existsByName(category.getName())) {
            throw new RuntimeException("Tên danh mục đã tồn tại: " + category.getName());
        }

        // Cập nhật slug nếu tên thay đổi
        if (!existingCategory.getName().equals(category.getName())) {
            category.setSlug(CourseUtils.StringUtils.createSlug(category.getName()));
        } else {
            category.setSlug(existingCategory.getSlug());
        }

        // Giữ nguyên thời gian tạo và course count
        category.setCreatedAt(existingCategory.getCreatedAt());
        category.setCourseCount(existingCategory.getCourseCount());

        return categoryRepository.save(category);
    }

    /**
     * Xóa category
     * @param categoryId ID category cần xóa
     */
    public void deleteCategory(Long categoryId) {
        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy category"));

        // Kiểm tra xem có courses nào đang sử dụng category này không
        if (category.getCourseCount() > 0) {
            throw new RuntimeException("Không thể xóa danh mục đang có " + category.getCourseCount() +
                    " khóa học. Vui lòng di chuyển các khóa học trước khi xóa.");
        }

        categoryRepository.delete(category);
    }

    /**
     * Cập nhật course count cho category
     * @param categoryId ID category
     */
    public void updateCourseCount(Long categoryId) {
        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy category"));

        // Query để đếm số courses active trong category
        Long courseCount = categoryRepository.countActiveCoursesInCategory(categoryId);
        category.setCourseCount(courseCount);

        categoryRepository.save(category);
    }

    /**
     * Cập nhật course count cho tất cả categories
     */
    public void updateAllCourseCount() {
        List<Category> categories = categoryRepository.findAll();

        for (Category category : categories) {
            Long courseCount = categoryRepository.countActiveCoursesInCategory(category.getId());
            category.setCourseCount(courseCount);
        }

        categoryRepository.saveAll(categories);
    }

    /**
     * Toggle featured status của category
     * @param categoryId ID category
     * @param featured Featured status mới
     */
    public void updateFeaturedStatus(Long categoryId, boolean featured) {
        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy category"));

        category.setFeatured(featured);
        categoryRepository.save(category);
    }

    /**
     * Tìm category theo slug
     * @param slug Slug của category
     * @return Optional chứa Category nếu tìm thấy
     */
    public Optional<Category> findBySlug(String slug) {
        return categoryRepository.findBySlug(slug);
    }

    /**
     * Tìm category theo tên
     * @param n Tên category
     * @return Optional chứa Category nếu tìm thấy
     */
    public Optional<Category> findByName(String n) {
        return categoryRepository.findByName(n);
    }

    /**
     * Lấy categories phổ biến nhất (có nhiều courses nhất)
     * @param limit Số lượng cần lấy
     * @return Danh sách popular categories
     */
    public List<Category> findMostPopularCategories(int limit) {
        return categoryRepository.findTopCategoriesByCourseCount(limit);
    }

    /**
     * Lấy thống kê categories
     * @return Category statistics
     */
    public CategoryStats getCategoryStatistics() {
        Long totalCategories = categoryRepository.count();
        Long featuredCategories = categoryRepository.countByFeatured(true);
        Long activeCategories = categoryRepository.countActiveCategoriesWithCourses();

        return new CategoryStats(totalCategories, featuredCategories, activeCategories);
    }

    /**
     * Tìm categories có courses
     * @return Danh sách categories có ít nhất 1 course
     */
    public List<Category> findCategoriesWithCourses() {
        return categoryRepository.findActiveCategoriesWithCourses();
    }

    /**
     * Kiểm tra category có courses không
     * @param categoryId ID category
     * @return true nếu có courses
     */
    public boolean hasCourses(Long categoryId) {
        Category category = categoryRepository.findById(categoryId).orElse(null);
        return category != null && category.getCourseCount() > 0;
    }

    /**
     * Lấy tất cả categories (không sắp xếp)
     * @return Danh sách tất cả categories
     */
    public List<Category> findAll() {
        return categoryRepository.findAll();
    }

    /**
     * Đếm tổng số categories
     * @return Số lượng categories
     */
    public Long countAllCategories() {
        return categoryRepository.count();
    }

    // ===== PRIVATE HELPER METHODS =====

    /**
     * Validate thông tin category
     * @param category Category cần validate
     */
    private void validateCategory(Category category) {
        if (category == null) {
            throw new RuntimeException("Thông tin category không được để trống");
        }

        // Validate name
        if (!StringUtils.hasText(category.getName())) {
            throw new RuntimeException("Tên danh mục không được để trống");
        }
        if (category.getName().length() < 2) {
            throw new RuntimeException("Tên danh mục phải có ít nhất 2 ký tự");
        }
        if (category.getName().length() > 100) {
            throw new RuntimeException("Tên danh mục không được vượt quá 100 ký tự");
        }

        // Validate description
        if (StringUtils.hasText(category.getDescription()) && category.getDescription().length() > 500) {
            throw new RuntimeException("Mô tả danh mục không được vượt quá 500 ký tự");
        }

        // Validate color code (nếu có)
        if (StringUtils.hasText(category.getColorCode())) {
            if (!category.getColorCode().matches("^#[0-9A-Fa-f]{6}$")) {
                throw new RuntimeException("Mã màu không hợp lệ. Định dạng: #RRGGBB");
            }
        }

        // Validate icon class (nếu có)
        if (StringUtils.hasText(category.getIconClass())) {
            if (category.getIconClass().length() > 50) {
                throw new RuntimeException("Icon class không được vượt quá 50 ký tự");
            }
        }
    }

    // ===== INNER CLASSES =====

    /**
     * Category statistics data class
     */
    public static class CategoryStats {
        private final Long totalCategories;
        private final Long featuredCategories;
        private final Long activeCategories;

        public CategoryStats(Long totalCategories, Long featuredCategories, Long activeCategories) {
            this.totalCategories = totalCategories;
            this.featuredCategories = featuredCategories;
            this.activeCategories = activeCategories;
        }

        // Getters
        public Long getTotalCategories() { return totalCategories; }
        public Long getFeaturedCategories() { return featuredCategories; }
        public Long getActiveCategories() { return activeCategories; }
    }
}