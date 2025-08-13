package com.coursemanagement.service;

import com.coursemanagement.entity.Category;
import com.coursemanagement.repository.CategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Service class để xử lý business logic liên quan đến Category
 * Quản lý CRUD operations, validation và business rules cho categories
 */
@Service
@Transactional
public class CategoryService {

    @Autowired
    private CategoryRepository categoryRepository;

    // ===== BASIC CRUD OPERATIONS =====

    /**
     * Tìm category theo ID
     */
    public Optional<Category> findById(Long id) {
        return categoryRepository.findById(id);
    }

    /**
     * Tìm category theo name
     */
    public Optional<Category> findByName(String name) {
        return categoryRepository.findByName(name);
    }

    /**
     * Tìm tất cả categories
     */
    public List<Category> findAll() {
        return categoryRepository.findAll();
    }

    /**
     * Lưu category
     */
    public Category save(Category category) {
        validateCategory(category);

        if (category.getId() == null) {
            category.setCreatedAt(LocalDateTime.now());
        }
        category.setUpdatedAt(LocalDateTime.now());

        return categoryRepository.save(category);
    }

    /**
     * Tạo category mới
     */
    public Category createCategory(Category category) {
        if (category == null) {
            throw new RuntimeException("Category không được để trống");
        }

        if (isCategoryNameExists(category.getName())) {
            throw new RuntimeException("Tên danh mục đã tồn tại: " + category.getName());
        }

        category.setId(null);
        category.setActive(true);

        return save(category);
    }

    /**
     * Cập nhật category
     */
    public Category updateCategory(Category category) {
        if (category.getId() == null) {
            throw new RuntimeException("ID category không được để trống khi cập nhật");
        }

        Category existingCategory = findById(category.getId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy danh mục với ID: " + category.getId()));

        if (isCategoryNameExists(category.getName(), category.getId())) {
            throw new RuntimeException("Tên danh mục đã tồn tại: " + category.getName());
        }

        existingCategory.setName(category.getName());
        existingCategory.setDescription(category.getDescription());
        existingCategory.setActive(category.isActive());
        existingCategory.setUpdatedAt(LocalDateTime.now());

        return categoryRepository.save(existingCategory);
    }

    /**
     * Xóa category (soft delete)
     */
    public void deleteCategory(Long id) {
        Category category = findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy danh mục với ID: " + id));

        Long courseCount = countCoursesByCategory(id);
        if (courseCount > 0) {
            throw new RuntimeException("Không thể xóa danh mục đang có " + courseCount + " khóa học");
        }

        category.setActive(false);
        category.setUpdatedAt(LocalDateTime.now());
        categoryRepository.save(category);
    }

    // ===== COUNT OPERATIONS =====

    /**
     * Đếm tổng số categories
     */
    public Long countAllCategories() {
        return categoryRepository.countAllCategories();
    }

    /**
     * Đếm categories active
     */
    public Long countByActive(boolean active) {
        return categoryRepository.countByActive(active);
    }

    /**
     * Đếm số courses trong category
     */
    public Long countCoursesByCategory(Long categoryId) {
        Category category = findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy danh mục với ID: " + categoryId));
        return categoryRepository.countCoursesByCategory(category);
    }

    /**
     * Đếm số active courses trong category
     */
    public Long countActiveCoursesByCategory(Long categoryId) {
        Category category = findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy danh mục với ID: " + categoryId));
        return categoryRepository.countCoursesByCategoryAndActive(category, true);
    }

    // ===== FINDER METHODS =====

    /**
     * Tìm tất cả categories active sắp xếp theo tên
     */
    public List<Category> findAllActive() {
        return categoryRepository.findAllByActiveTrueOrderByName();
    }

    /**
     * Tìm categories sắp xếp theo tên (tất cả)
     */
    public List<Category> findAllOrderByName() {
        return categoryRepository.findAll(Sort.by(Sort.Direction.ASC, "name"));
    }

    /**
     * Tìm categories theo active status với pagination
     */
    public Page<Category> findByActive(boolean active, Pageable pageable) {
        return categoryRepository.findByActive(active, pageable);
    }

    /**
     * Tìm categories có courses active
     */
    public List<Category> findCategoriesWithActiveCourses() {
        return categoryRepository.findCategoriesWithActiveCourses();
    }

    /**
     * Tìm categories không có courses
     */
    public List<Category> findEmptyCategories() {
        return categoryRepository.findEmptyCategories();
    }

    /**
     * Tìm categories có courses
     */
    public List<Category> findCategoriesWithCourses() {
        return categoryRepository.findCategoriesWithCourses();
    }

    // ===== TOP & POPULAR CATEGORIES =====

    /**
     * Tìm top categories theo số lượng courses
     */
    public List<Category> findTopCategoriesByCourseCount(int limit) {
        List<Category> allCategories = categoryRepository.findTopCategoriesByCourseCount(limit);
        return allCategories.stream()
                .limit(limit)
                .collect(Collectors.toList());
    }

    /**
     * Tìm popular categories
     */
    public List<Category> findPopularCategories(int limit) {
        List<Category> allPopular = categoryRepository.findPopularCategories(limit);
        return allPopular.stream()
                .limit(limit)
                .collect(Collectors.toList());
    }

    /**
     * Tìm categories được tạo gần đây
     */
    public List<Category> findRecentCategories(int daysAgo) {
        LocalDateTime fromDate = LocalDateTime.now().minusDays(daysAgo);
        return categoryRepository.findRecentCategoriesByDate(fromDate);
    }

    // ===== SEARCH METHODS =====

    /**
     * Tìm categories theo keyword
     */
    public Page<Category> findByKeyword(String keyword, Pageable pageable) {
        return categoryRepository.findByKeyword(keyword, pageable);
    }

    /**
     * Search categories theo tên và description
     */
    public Page<Category> searchByName(String keyword, Pageable pageable) {
        return categoryRepository.searchByName(keyword, pageable);
    }

    // ===== STATISTICS METHODS =====

    /**
     * Tìm categories với số lượng courses
     */
    public List<CategoryStats> findCategoriesWithCourseCount() {
        List<Object[]> results = categoryRepository.findCategoriesWithCourseCount();
        return results.stream()
                .map(result -> {
                    Category category = (Category) result[0];
                    Long courseCount = (Long) result[1];
                    return new CategoryStats(category, courseCount.intValue());
                })
                .collect(Collectors.toList());
    }

    /**
     * Lấy thống kê categories
     */
    public List<CategoryStats> getCategoryStats() {
        List<Object[]> results = categoryRepository.getCategoryStats();
        return results.stream()
                .map(result -> {
                    String categoryName = (String) result[0];
                    Long totalCourses = (Long) result[1];
                    Long activeCourses = (Long) result[2];

                    CategoryStats stats = new CategoryStats();
                    stats.setCategoryName(categoryName);
                    stats.setTotalCourses(totalCourses.intValue());
                    stats.setActiveCourses(activeCourses.intValue());
                    return stats;
                })
                .collect(Collectors.toList());
    }

    /**
     * Lấy revenue theo category
     */
    public List<Object[]> getRevenueByCategory() {
        return categoryRepository.getRevenueByCategory();
    }

    /**
     * Lấy thống kê dashboard cho categories
     */
    public Map<String, Object> getCategoryDashboardStats() {
        Map<String, Object> stats = new HashMap<>();

        stats.put("totalCategories", countAllCategories());
        stats.put("activeCategories", countByActive(true));
        stats.put("categoriesWithCourses", findCategoriesWithCourses().size());
        stats.put("emptyCategories", findEmptyCategories().size());

        return stats;
    }

    /**
     * Lấy category performance stats
     */
    public List<Object[]> getCategoryPerformanceStats() {
        return categoryRepository.getCategoryPerformanceStats();
    }

    /**
     * Lấy thống kê categories theo course count ranges
     */
    public List<Object[]> getCategoryDistributionStats() {
        return categoryRepository.getCategoryDistributionStats();
    }

    /**
     * Lấy category stats với enrollment data
     */
    public List<Object[]> getCategoriesWithEnrollmentStats() {
        return categoryRepository.getCategoriesWithEnrollmentStats();
    }

    // ===== FEATURED CATEGORIES =====

    /**
     * Tìm categories theo featured status
     */
    public List<Category> findByFeaturedOrderByNameAsc(boolean featured) {
        return categoryRepository.findByFeaturedOrderByNameAsc(featured);
    }

    /**
     * Đếm categories theo featured status
     */
    public Long countByFeatured(boolean featured) {
        return categoryRepository.countByFeatured(featured);
    }

    /**
     * Cập nhật featured status của category
     */
    public Category updateFeaturedStatus(Long id, boolean featured) {
        Category category = findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy danh mục với ID: " + id));

        category.setFeatured(featured);
        category.setUpdatedAt(LocalDateTime.now());

        return categoryRepository.save(category);
    }

    // ===== APPEARANCE METHODS =====

    /**
     * Tìm categories theo color code
     */
    public List<Category> findByColorCode(String colorCode) {
        return categoryRepository.findByColorCode(colorCode);
    }

    /**
     * Tìm categories theo icon class
     */
    public List<Category> findByIconClass(String iconClass) {
        return categoryRepository.findByIconClass(iconClass);
    }

    /**
     * Lấy tất cả color codes đang sử dụng
     */
    public List<String> findAllUsedColorCodes() {
        return categoryRepository.findAllUsedColorCodes();
    }

    /**
     * Lấy tất cả icon classes đang sử dụng
     */
    public List<String> findAllUsedIconClasses() {
        return categoryRepository.findAllUsedIconClasses();
    }

    // ===== VALIDATION & EXISTENCE CHECKS =====

    /**
     * Kiểm tra category name đã tồn tại chưa
     */
    public boolean isCategoryNameExists(String name) {
        return categoryRepository.existsByName(name);
    }

    /**
     * Kiểm tra category name đã tồn tại chưa (cho update)
     */
    public boolean isCategoryNameExists(String name, Long excludeId) {
        return categoryRepository.existsByNameAndIdNot(name, excludeId);
    }

    // ===== PRIVATE VALIDATION METHODS =====

    /**
     * Validate category data
     */
    private void validateCategory(Category category) {
        if (category == null) {
            throw new RuntimeException("Category không được để trống");
        }

        if (!StringUtils.hasText(category.getName())) {
            throw new RuntimeException("Tên danh mục không được để trống");
        }

        if (category.getName().length() > 100) {
            throw new RuntimeException("Tên danh mục không được quá 100 ký tự");
        }

        if (category.getDescription() != null && category.getDescription().length() > 500) {
            throw new RuntimeException("Mô tả danh mục không được quá 500 ký tự");
        }
    }

    // ===== INNER CLASS FOR STATISTICS =====

    /**
     * Inner class cho Category Statistics
     */
    public static class CategoryStats {
        private Long id;
        private String categoryName;
        private int totalCourses;
        private int activeCourses;
        private int enrollmentCount;
        private double revenue;
        private Category category;

        public CategoryStats() {}

        public CategoryStats(Category category, int courseCount) {
            this.category = category;
            this.id = category.getId();
            this.categoryName = category.getName();
            this.totalCourses = courseCount;
        }

        // Getters and setters
        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }

        public String getCategoryName() { return categoryName; }
        public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

        public int getTotalCourses() { return totalCourses; }
        public void setTotalCourses(int totalCourses) { this.totalCourses = totalCourses; }

        public int getActiveCourses() { return activeCourses; }
        public void setActiveCourses(int activeCourses) { this.activeCourses = activeCourses; }

        public int getEnrollmentCount() { return enrollmentCount; }
        public void setEnrollmentCount(int enrollmentCount) { this.enrollmentCount = enrollmentCount; }

        public double getRevenue() { return revenue; }
        public void setRevenue(double revenue) { this.revenue = revenue; }

        public Category getCategory() { return category; }
        public void setCategory(Category category) { this.category = category; }
    }
}