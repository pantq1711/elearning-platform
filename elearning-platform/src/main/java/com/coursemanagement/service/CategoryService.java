package com.coursemanagement.service;

import com.coursemanagement.entity.Category;
import com.coursemanagement.entity.Course;
import com.coursemanagement.repository.CategoryRepository;
import com.coursemanagement.utils.CourseUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Dịch vụ quản lý danh mục khóa học (Category)
 * Xử lý logic nghiệp vụ cho việc tạo, cập nhật và quản lý categories
 */
@Service
@Transactional
public class CategoryService {

    @Autowired
    private CategoryRepository categoryRepository;

    // ===== CÁC THAO TÁC CRUD CƠ BẢN =====

    /**
     * Tìm category theo ID
     */
    public Optional<Category> findById(Long id) {
        return categoryRepository.findById(id);
    }

    /**
     * Tìm tất cả categories
     */
    public List<Category> findAll() {
        return categoryRepository.findAll();
    }

    /**
     * Tìm categories với phân trang
     */
    public Page<Category> findAll(Pageable pageable) {
        return categoryRepository.findAll(pageable);
    }

    /**
     * Tìm tất cả categories sắp xếp theo tên
     */
    public List<Category> findAllOrderByName() {
        return categoryRepository.findAll(Sort.by(Sort.Direction.ASC, "name"));
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
        validateCategory(category);

        // Kiểm tra tên đã tồn tại
        if (existsByName(category.getName())) {
            throw new RuntimeException("Tên danh mục đã tồn tại: " + category.getName());
        }

        category.setCreatedAt(LocalDateTime.now());
        category.setUpdatedAt(LocalDateTime.now());

        // Set default values
        if (category.getColorCode() == null) {
            category.setColorCode("#007bff"); // Default blue color
        }

        if (category.getIconClass() == null) {
            category.setIconClass("fas fa-book"); // Default book icon
        }

        return categoryRepository.save(category);
    }

    /**
     * Cập nhật category
     */
    public Category updateCategory(Category category) {
        if (category.getId() == null) {
            throw new RuntimeException("ID category không được để trống khi cập nhật");
        }

        Category existingCategory = categoryRepository.findById(category.getId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy category với ID: " + category.getId()));

        // Kiểm tra tên trùng lặp (exclude current category)
        if (!existingCategory.getName().equals(category.getName()) && existsByName(category.getName())) {
            throw new RuntimeException("Tên danh mục đã tồn tại: " + category.getName());
        }

        // Cập nhật các trường
        existingCategory.setName(category.getName());
        existingCategory.setDescription(category.getDescription());
        existingCategory.setColorCode(category.getColorCode());
        existingCategory.setIconClass(category.getIconClass());
        existingCategory.setFeatured(category.isFeatured());
        existingCategory.setUpdatedAt(LocalDateTime.now());

        return categoryRepository.save(existingCategory);
    }

    /**
     * Xóa category (chỉ khi không có courses)
     */
    public void deleteCategory(Long categoryId) {
        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy category với ID: " + categoryId));

        // Kiểm tra có courses không
        if (category.getCourseCount() > 0) {
            throw new RuntimeException("Không thể xóa danh mục có chứa khóa học");
        }

        categoryRepository.delete(category);
    }

    // ===== ACTIVE STATUS MANAGEMENT =====

    /**
     * Set active status cho category (nếu Category entity có active field)
     */
    public Category setActive(Long categoryId, boolean active) {
        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy category với ID: " + categoryId));

        // Nếu Category entity có active field
        if (hasActiveField(category)) {
            setActiveField(category, active);
            category.setUpdatedAt(LocalDateTime.now());
            return categoryRepository.save(category);
        }

        // Nếu không có active field, return category without changes
        return category;
    }

    /**
     * Check if category is active
     */
    public boolean isActive(Category category) {
        if (category == null) {
            return false;
        }

        // Nếu Category entity có active field
        if (hasActiveField(category)) {
            return getActiveField(category);
        }

        // Default: category luôn active nếu không có field
        return true;
    }

    // ===== TÌM KIẾM VÀ LỌC =====

    /**
     * Tìm category theo tên
     */
    public Optional<Category> findByName(String name) {
        return categoryRepository.findByName(name);
    }

    /**
     * Tìm categories theo tên chứa keyword (case insensitive)
     */
    public List<Category> findByNameContainingIgnoreCase(String keyword) {
        return categoryRepository.findByNameContainingIgnoreCase(keyword);
    }

    /**
     * Tìm featured categories
     */
    public List<Category> findFeaturedCategories() {
        return categoryRepository.findByFeaturedOrderByName(true);
    }

    /**
     * Tìm featured categories với limit
     */
    public List<Category> findFeaturedCategories(int limit) {
        Pageable pageable = PageRequest.of(0, limit, Sort.by(Sort.Direction.ASC, "name"));
        return categoryRepository.findByFeatured(true, pageable).getContent();
    }

    /**
     * Tìm top categories theo course count
     */
    public List<Category> findTopCategoriesByCourseCount(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return categoryRepository.findTopCategoriesByCourseCount(pageable);
    }

    /**
     * Tìm categories có courses
     */
    public List<Category> findCategoriesWithCourses() {
        return categoryRepository.findByCourseCountGreaterThan(0);
    }

    // ===== ĐẾM VÀ THỐNG KÊ =====

    /**
     * Đếm tất cả categories
     */
    public Long countAll() {
        return categoryRepository.count();
    }

    /**
     * Đếm tất cả categories (alias)
     */
    public Long countAllCategories() {
        return countAll();
    }

    /**
     * Đếm featured categories
     */
    public Long countFeaturedCategories() {
        return categoryRepository.countByFeatured(true);
    }

    /**
     * Đếm categories có courses
     */
    public Long countCategoriesWithCourses() {
        return categoryRepository.countByCourseCountGreaterThan(0);
    }

    // ===== COURSE COUNT MANAGEMENT =====

    /**
     * Cập nhật course count cho category
     */
    public void updateCourseCount(Long categoryId) {
        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy category"));

        // Tính số courses active trong category
        int courseCount = category.getCourses() != null ?
                (int) category.getCourses().stream().filter(Course::isActive).count() : 0;

        category.setCourseCount(courseCount);
        category.setUpdatedAt(LocalDateTime.now());
        categoryRepository.save(category);
    }

    /**
     * Cập nhật course count cho tất cả categories
     */
    public void updateAllCourseCount() {
        List<Category> categories = findAll();
        for (Category category : categories) {
            updateCourseCount(category.getId());
        }
    }

    /**
     * Increment course count
     */
    public void incrementCourseCount(Long categoryId) {
        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy category"));

        category.setCourseCount(category.getCourseCount() + 1);
        category.setUpdatedAt(LocalDateTime.now());
        categoryRepository.save(category);
    }

    /**
     * Decrement course count
     */
    public void decrementCourseCount(Long categoryId) {
        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy category"));

        category.setCourseCount(Math.max(0, category.getCourseCount() - 1));
        category.setUpdatedAt(LocalDateTime.now());
        categoryRepository.save(category);
    }

    // ===== FEATURED MANAGEMENT =====

    /**
     * Set featured status cho category
     */
    public Category setFeatured(Long categoryId, boolean featured) {
        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy category"));

        category.setFeatured(featured);
        category.setUpdatedAt(LocalDateTime.now());

        return categoryRepository.save(category);
    }

    /**
     * Toggle featured status
     */
    public Category toggleFeatured(Long categoryId) {
        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy category"));

        category.setFeatured(!category.isFeatured());
        category.setUpdatedAt(LocalDateTime.now());

        return categoryRepository.save(category);
    }

    // ===== KIỂM TRA TỒN TẠI =====

    /**
     * Kiểm tra tên category đã tồn tại chưa
     */
    public boolean existsByName(String name) {
        return categoryRepository.existsByName(name);
    }

    /**
     * Kiểm tra category có courses không
     */
    public boolean hasCourses(Long categoryId) {
        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy category"));
        return category.getCourseCount() > 0;
    }

    // ===== VALIDATION =====

    /**
     * Validate category trước khi lưu
     */
    private void validateCategory(Category category) {
        if (category == null) {
            throw new RuntimeException("Category không được để trống");
        }

        if (!StringUtils.hasText(category.getName())) {
            throw new RuntimeException("Tên category không được để trống");
        }

        // Kiểm tra độ dài tên
        if (category.getName().length() < 2 || category.getName().length() > 100) {
            throw new RuntimeException("Tên category phải từ 2-100 ký tự");
        }

        // Validate color code format
        if (category.getColorCode() != null && !isValidColorCode(category.getColorCode())) {
            throw new RuntimeException("Mã màu không đúng định dạng (ví dụ: #FF0000)");
        }

        // Validate icon class format
        if (category.getIconClass() != null && category.getIconClass().length() > 50) {
            throw new RuntimeException("Icon class không được quá 50 ký tự");
        }
    }

    /**
     * Kiểm tra color code có hợp lệ không
     */
    private boolean isValidColorCode(String colorCode) {
        if (colorCode == null || colorCode.trim().isEmpty()) {
            return false;
        }
        return colorCode.matches("^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$");
    }

    // ===== HELPER METHODS CHO ACTIVE FIELD REFLECTION =====

    /**
     * Kiểm tra Category có active field không
     */
    private boolean hasActiveField(Category category) {
        try {
            category.getClass().getDeclaredField("active");
            return true;
        } catch (NoSuchFieldException e) {
            return false;
        }
    }

    /**
     * Set active field value
     */
    private void setActiveField(Category category, boolean active) {
        try {
            java.lang.reflect.Field field = category.getClass().getDeclaredField("active");
            field.setAccessible(true);
            field.setBoolean(category, active);
        } catch (Exception e) {
            // Ignore reflection errors
        }
    }

    /**
     * Get active field value
     */
    private boolean getActiveField(Category category) {
        try {
            java.lang.reflect.Field field = category.getClass().getDeclaredField("active");
            field.setAccessible(true);
            return field.getBoolean(category);
        } catch (Exception e) {
            return true; // Default active
        }
    }

    // ===== UTILITY METHODS =====

    /**
     * Lấy category với course count cao nhất
     */
    public Optional<Category> findMostPopularCategory() {
        List<Category> categories = findTopCategoriesByCourseCount(1);
        return categories.isEmpty() ? Optional.empty() : Optional.of(categories.get(0));
    }

    /**
     * Lấy danh sách categories cho dropdown/select
     */
    public List<Category> findForDropdown() {
        return categoryRepository.findAll(Sort.by(Sort.Direction.ASC, "name"));
    }

    /**
     * Generate default icon class dựa trên tên category
     */
    public String generateDefaultIcon(String categoryName) {
        if (categoryName == null) {
            return "fas fa-book";
        }

        String lowerName = categoryName.toLowerCase();

        if (lowerName.contains("programming") || lowerName.contains("lập trình")) {
            return "fas fa-code";
        } else if (lowerName.contains("design") || lowerName.contains("thiết kế")) {
            return "fas fa-paint-brush";
        } else if (lowerName.contains("business") || lowerName.contains("kinh doanh")) {
            return "fas fa-briefcase";
        } else if (lowerName.contains("marketing")) {
            return "fas fa-bullhorn";
        } else if (lowerName.contains("music") || lowerName.contains("âm nhạc")) {
            return "fas fa-music";
        } else if (lowerName.contains("language") || lowerName.contains("ngôn ngữ")) {
            return "fas fa-globe";
        } else {
            return "fas fa-book";
        }
    }

    /**
     * Generate default color dựa trên tên category
     */
    public String generateDefaultColor(String categoryName) {
        if (categoryName == null) {
            return "#007bff";
        }

        String lowerName = categoryName.toLowerCase();

        if (lowerName.contains("programming") || lowerName.contains("lập trình")) {
            return "#28a745"; // Green
        } else if (lowerName.contains("design") || lowerName.contains("thiết kế")) {
            return "#e83e8c"; // Pink
        } else if (lowerName.contains("business") || lowerName.contains("kinh doanh")) {
            return "#343a40"; // Dark
        } else if (lowerName.contains("marketing")) {
            return "#fd7e14"; // Orange
        } else if (lowerName.contains("music") || lowerName.contains("âm nhạc")) {
            return "#6f42c1"; // Purple
        } else if (lowerName.contains("language") || lowerName.contains("ngôn ngữ")) {
            return "#20c997"; // Teal
        } else {
            return "#007bff"; // Blue
        }
    }
}