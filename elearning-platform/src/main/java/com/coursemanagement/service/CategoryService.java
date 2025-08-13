package com.coursemanagement.service;

import com.coursemanagement.entity.Category;
import com.coursemanagement.entity.Course;
import com.coursemanagement.repository.CategoryRepository;
import com.coursemanagement.repository.CourseRepository;
import com.coursemanagement.repository.EnrollmentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Service layer cho Category entity
 * Xử lý business logic liên quan đến danh mục khóa học
 * Cập nhật với CategoryStats và đầy đủ methods
 */
@Service
@Transactional
public class CategoryService {

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    // ===== BASIC CRUD OPERATIONS =====

    /**
     * Lấy tất cả categories
     * @return Danh sách categories
     */
    public List<Category> findAll() {
        return categoryRepository.findAll();
    }

    /**
     * Lấy categories với pagination
     * @param pageable Pagination info
     * @return Page chứa categories
     */
    public Page<Category> findAll(Pageable pageable) {
        return categoryRepository.findAll(pageable);
    }

    /**
     * Tìm category theo ID
     * @param id ID category
     * @return Optional chứa Category
     */
    public Optional<Category> findById(Long id) {
        return categoryRepository.findById(id);
    }

    /**
     * Tìm category theo name
     * @param name Tên category
     * @return Optional chứa Category
     */
    public Optional<Category> findByName(String name) {
        return categoryRepository.findByName(name);
    }

    /**
     * Lưu category
     * @param category Category cần lưu
     * @return Category đã lưu
     */
    public Category save(Category category) {
        // Cập nhật course count trước khi save
        category.updateCourseCount();
        return categoryRepository.save(category);
    }

    /**
     * Xóa category theo ID
     * @param id ID category cần xóa
     */
    public void deleteById(Long id) {
        categoryRepository.deleteById(id);
    }

    /**
     * Kiểm tra category name đã tồn tại chưa
     * @param name Tên category
     * @return true nếu đã tồn tại
     */
    public boolean existsByName(String name) {
        return categoryRepository.existsByName(name);
    }

    /**
     * Kiểm tra category name đã tồn tại chưa (exclude ID hiện tại)
     * @param name Tên category
     * @param id ID cần exclude
     * @return true nếu đã tồn tại
     */
    public boolean existsByNameAndIdNot(String name, Long id) {
        return categoryRepository.existsByNameAndIdNot(name, id);
    }

    // ===== FEATURED CATEGORIES =====

    /**
     * Lấy featured categories
     * @return Danh sách featured categories
     */
    public List<Category> findFeaturedCategories() {
        return categoryRepository.findByFeaturedOrderByNameAsc(true);
    }

    /**
     * Lấy featured categories với limit
     * @param limit Số lượng categories
     * @return Danh sách featured categories
     */
    public List<Category> findFeaturedCategories(int limit) {
        Pageable pageable = PageRequest.of(0, limit, Sort.by("name"));
        return categoryRepository.findByFeatured(true, pageable);
    }

    /**
     * Set featured status cho category
     * @param id ID category
     * @param featured Featured status
     */
    public void updateFeaturedStatus(Long id, boolean featured) {
        categoryRepository.updateFeaturedStatus(id, featured);
    }

    // ===== SEARCH METHODS =====

    /**
     * Search categories theo tên
     * @param keyword Từ khóa tìm kiếm
     * @param pageable Pagination info
     * @return Page chứa categories tìm thấy
     */
    public Page<Category> searchCategories(String keyword, Pageable pageable) {
        return categoryRepository.searchByName(keyword, pageable);
    }

    /**
     * Search categories với limit
     * @param keyword Từ khóa tìm kiếm
     * @param limit Số lượng kết quả
     * @return Danh sách categories tìm thấy
     */
    public List<Category> searchCategories(String keyword, int limit) {
        return categoryRepository.searchCategories(keyword, limit);
    }

    // ===== ANALYTICS & STATISTICS =====

    /**
     * Lấy thống kê categories
     * @return Map chứa thống kê
     */
    public Map<String, Object> getCategoryStatistics() {
        return Map.of(
                "totalCategories", categoryRepository.count(),
                "featuredCategories", categoryRepository.countByFeatured(true),
                "categoriesWithCourses", categoryRepository.countCategoriesWithCourses(),
                "averageCoursesPerCategory", categoryRepository.getAverageCoursesPerCategory()
        );
    }

    /**
     * Lấy top categories theo course count
     * @param limit Số lượng categories
     * @return Danh sách top categories
     */
    public List<Object[]> getTopCategoriesByCourseCount(int limit) {
        return categoryRepository.getTopCategoriesByCourseCount(limit);
    }

    /**
     * Lấy category performance stats
     * @return Danh sách performance stats
     */
    public List<Object[]> getCategoryPerformanceStats() {
        return categoryRepository.getCategoryPerformanceStats();
    }

    // ===== COURSE COUNT MANAGEMENT =====

    /**
     * Cập nhật course count cho tất cả categories
     */
    public void updateAllCategoryCounts() {
        List<Category> categories = categoryRepository.findAll();
        for (Category category : categories) {
            long courseCount = courseRepository.countByCategory(category);
            category.setCourseCount((int) courseCount);
        }
        categoryRepository.saveAll(categories);
    }

    /**
     * Cập nhật course count cho một category
     * @param categoryId ID category
     */
    public void updateCategoryCount(Long categoryId) {
        Optional<Category> categoryOpt = categoryRepository.findById(categoryId);
        if (categoryOpt.isPresent()) {
            Category category = categoryOpt.get();
            long courseCount = courseRepository.countByCategory(category);
            category.setCourseCount((int) courseCount);
            categoryRepository.save(category);
        }
    }

    // ===== CATEGORY STATS CLASS =====

    /**
     * Class chứa thống kê chi tiết của category
     * Sử dụng cho dashboard và reports
     */
    public static class CategoryStats {
        private Long categoryId;
        private String categoryName;
        private String colorCode;
        private String iconClass;
        private long courseCount;
        private long enrollmentCount;
        private long completedEnrollmentCount;
        private double averageRating;
        private double completionRate;
        private boolean featured;

        // Constructors
        public CategoryStats() {}

        public CategoryStats(Long categoryId, String categoryName, String colorCode, String iconClass) {
            this.categoryId = categoryId;
            this.categoryName = categoryName;
            this.colorCode = colorCode;
            this.iconClass = iconClass;
        }

        public CategoryStats(Category category) {
            this.categoryId = category.getId();
            this.categoryName = category.getName();
            this.colorCode = category.getColorCode();
            this.iconClass = category.getIconClass();
            this.courseCount = category.getCourseCount();
            this.featured = category.isFeatured();
        }

        // Helper methods
        /**
         * Tính completion rate percentage
         * @return Completion rate (0-100)
         */
        public double getCompletionRatePercentage() {
            return completionRate * 100.0;
        }

        /**
         * Lấy status string của category
         * @return Status string
         */
        public String getStatusString() {
            if (courseCount == 0) {
                return "Chưa có khóa học";
            } else if (enrollmentCount == 0) {
                return "Chưa có học viên";
            } else if (completionRate > 0.8) {
                return "Hiệu quả cao";
            } else if (completionRate > 0.5) {
                return "Hiệu quả trung bình";
            } else {
                return "Cần cải thiện";
            }
        }

        /**
         * Kiểm tra category có popular không
         * @return true nếu popular
         */
        public boolean isPopular() {
            return enrollmentCount > 100 || (courseCount > 5 && completionRate > 0.7);
        }

        // Getters and Setters
        public Long getCategoryId() {
            return categoryId;
        }

        public void setCategoryId(Long categoryId) {
            this.categoryId = categoryId;
        }

        public String getCategoryName() {
            return categoryName;
        }

        public void setCategoryName(String categoryName) {
            this.categoryName = categoryName;
        }

        public String getColorCode() {
            return colorCode;
        }

        public void setColorCode(String colorCode) {
            this.colorCode = colorCode;
        }

        public String getIconClass() {
            return iconClass;
        }

        public void setIconClass(String iconClass) {
            this.iconClass = iconClass;
        }

        public long getCourseCount() {
            return courseCount;
        }

        public void setCourseCount(long courseCount) {
            this.courseCount = courseCount;
        }

        public long getEnrollmentCount() {
            return enrollmentCount;
        }

        public void setEnrollmentCount(long enrollmentCount) {
            this.enrollmentCount = enrollmentCount;
        }

        public long getCompletedEnrollmentCount() {
            return completedEnrollmentCount;
        }

        public void setCompletedEnrollmentCount(long completedEnrollmentCount) {
            this.completedEnrollmentCount = completedEnrollmentCount;
        }

        public double getAverageRating() {
            return averageRating;
        }

        public void setAverageRating(double averageRating) {
            this.averageRating = averageRating;
        }

        public double getCompletionRate() {
            return completionRate;
        }

        public void setCompletionRate(double completionRate) {
            this.completionRate = completionRate;
        }

        public boolean isFeatured() {
            return featured;
        }

        public void setFeatured(boolean featured) {
            this.featured = featured;
        }

        @Override
        public String toString() {
            return "CategoryStats{" +
                    "categoryName='" + categoryName + '\'' +
                    ", courseCount=" + courseCount +
                    ", enrollmentCount=" + enrollmentCount +
                    ", completionRate=" + completionRate +
                    '}';
        }
    }

    /**
     * Tạo CategoryStats từ Category entity
     * @param category Category entity
     * @return CategoryStats object
     */
    public CategoryStats createCategoryStats(Category category) {
        CategoryStats stats = new CategoryStats(category);

        // Tính enrollment count
        List<Course> courses = courseRepository.findByCategory(category);
        long totalEnrollments = courses.stream()
                .mapToLong(course -> enrollmentRepository.countEnrollmentsByCourse(course))
                .sum();
        stats.setEnrollmentCount(totalEnrollments);

        // Tính completed enrollment count
        long completedEnrollments = courses.stream()
                .mapToLong(course -> enrollmentRepository.countByCompletedAndCourse(true, course))
                .sum();
        stats.setCompletedEnrollmentCount(completedEnrollments);

        // Tính completion rate
        if (totalEnrollments > 0) {
            stats.setCompletionRate((double) completedEnrollments / totalEnrollments);
        }

        return stats;
    }

    /**
     * Lấy danh sách CategoryStats cho tất cả categories
     * @return Danh sách CategoryStats
     */
    public List<CategoryStats> getAllCategoryStats() {
        return categoryRepository.findAll().stream()
                .map(this::createCategoryStats)
                .collect(Collectors.toList());
    }

    /**
     * Lấy CategoryStats cho featured categories
     * @return Danh sách CategoryStats của featured categories
     */
    public List<CategoryStats> getFeaturedCategoryStats() {
        return categoryRepository.findByFeaturedOrderByNameAsc(true).stream()
                .map(this::createCategoryStats)
                .collect(Collectors.toList());
    }
}