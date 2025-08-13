package com.coursemanagement.service;

import com.coursemanagement.entity.Category;
import com.coursemanagement.repository.CategoryRepository;
import com.coursemanagement.utils.CourseUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.ArrayList;
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
     * Class để chứa thống kê category
     */
    public static class CategoryStats {
        private String categoryName;
        private Long courseCount;
        private Long id;

        public CategoryStats() {}

        public CategoryStats(String categoryName, Long courseCount, Long id) {
            this.categoryName = categoryName;
            this.courseCount = courseCount;
            this.id = id;
        }

        // Getters và Setters
        public String getCategoryName() { return categoryName; }
        public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

        public Long getCourseCount() { return courseCount; }
        public void setCourseCount(Long courseCount) { this.courseCount = courseCount; }

        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }
    }

    /**
     * Tìm category theo ID
     * @param id ID của category
     * @return Optional chứa Category nếu tìm thấy
     */
    public Optional<Category> findById(Long id) {
        return categoryRepository.findById(id);
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
     * Tìm tất cả categories sắp xếp theo tên
     * @return Danh sách categories theo alphabet
     */
    public List<Category> findAllOrderByName() {
        return categoryRepository.findAllByOrderByNameAsc();
    }

    /**
     * Tìm tất cả categories active
     * @return Danh sách active categories
     */
    public List<Category> findAllActive() {
        return categoryRepository.findActiveCategoriesWithCourses();
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
     * Tìm top categories theo số lượng courses
     * @param limit Số lượng giới hạn
     * @return Danh sách CategoryStats
     */
    public List<CategoryStats> findTopCategoriesByCourseCount(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        List<Object[]> results = categoryRepository.findTopCategoriesByCourseCount(pageable);

        List<CategoryStats> categoryStatsList = new ArrayList<>();
        for (Object[] result : results) {
            Long categoryId = (Long) result[0];
            String categoryName = (String) result[1];
            Long courseCount = (Long) result[2];

            CategoryStats stats = new CategoryStats(categoryName, courseCount, categoryId);
            categoryStatsList.add(stats);
        }

        return categoryStatsList;
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

        // Kiểm tra slug đã tồn tại chưa
        if (categoryRepository.existsBySlug(category.getSlug())) {
            // Thêm timestamp vào slug để đảm bảo unique
            category.setSlug(category.getSlug() + "-" + System.currentTimeMillis());
        }

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

        // Cập nhật thông tin
        existingCategory.setName(category.getName());
        existingCategory.setDescription(category.getDescription());
        existingCategory.setFeatured(category.isFeatured());

        // Cập nhật slug nếu tên thay đổi
        if (!existingCategory.getName().equals(category.getName())) {
            String newSlug = CourseUtils.StringUtils.createSlug(category.getName());
            if (categoryRepository.existsBySlugAndIdNot(newSlug, category.getId())) {
                newSlug = newSlug + "-" + System.currentTimeMillis();
            }
            existingCategory.setSlug(newSlug);
        }

        existingCategory.setUpdatedAt(LocalDateTime.now());

        return categoryRepository.save(existingCategory);
    }

    /**
     * Xóa category (chỉ cho phép nếu không có courses)
     * @param categoryId ID của category
     */
    public void deleteCategory(Long categoryId) {
        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy category với ID: " + categoryId));

        // Kiểm tra xem category có courses không
        if (category.getCourseCount() > 0) {
            throw new RuntimeException("Không thể xóa category vì vẫn còn courses thuộc category này");
        }

        categoryRepository.delete(category);
    }

    /**
     * Cập nhật course count cho category
     * @param categoryId ID của category
     */
    public void updateCourseCount(Long categoryId) {
        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy category với ID: " + categoryId));

        Long courseCount = categoryRepository.countCoursesByCategory(categoryId);
        category.setCourseCount(courseCount);
        category.setUpdatedAt(LocalDateTime.now());

        categoryRepository.save(category);
    }

    /**
     * Tìm categories theo keyword
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách categories
     */
    public List<Category> searchCategoriesByKeyword(String keyword) {
        if (!StringUtils.hasText(keyword)) {
            return findAllOrderByName();
        }
        return categoryRepository.findByNameContainingIgnoreCaseOrderByName(keyword);
    }

    /**
     * Đếm tất cả categories
     * @return Tổng số categories
     */
    public Long countAllCategories() {
        return categoryRepository.count();
    }

    /**
     * Đếm categories có courses
     * @return Số categories có courses
     */
    public Long countActiveCategoriesWithCourses() {
        return categoryRepository.countActiveCategoriesWithCourses();
    }

    /**
     * Lấy thống kê category
     * @return CategoryStats object
     */
    public CategoryStats getCategoryStatistics() {
        Long totalCategories = countAllCategories();
        Long activeCategories = countActiveCategoriesWithCourses();

        CategoryStats stats = new CategoryStats();
        stats.setCourseCount(totalCategories);

        return stats;
    }

    /**
     * Validation cho category
     * @param category Category cần validate
     */
    private void validateCategory(Category category) {
        if (!StringUtils.hasText(category.getName())) {
            throw new RuntimeException("Tên category không được để trống");
        }

        if (category.getName().length() < 2) {
            throw new RuntimeException("Tên category phải có ít nhất 2 ký tự");
        }

        if (category.getName().length() > 100) {
            throw new RuntimeException("Tên category không được vượt quá 100 ký tự");
        }

        if (category.getDescription() != null && category.getDescription().length() > 500) {
            throw new RuntimeException("Mô tả category không được vượt quá 500 ký tự");
        }
    }
}