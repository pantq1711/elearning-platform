package com.coursemanagement.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * Entity đại diện cho danh mục khóa học
 * Chứa thông tin về danh mục, màu sắc, icon và số lượng khóa học
 * Cập nhật với đầy đủ các field cần thiết
 */
@Entity
@Table(name = "categories")
public class Category {
    // ===== CATEGORY ENTITY OPTIONAL FIELDS =====

/**
 * Thêm các fields sau vào Category.java nếu muốn hỗ trợ thêm tính năng:
 * (Các fields này là optional - chỉ thêm nếu cần)
 */

    /**
     * 1. Thêm active field để có thể ẩn/hiện category:
     */
    @Column(name = "active")
    private boolean active = true;

    /**
     * 2. Thêm sort order field:
     */
    @Column(name = "sort_order")
    private Integer sortOrder = 0;

    /**
     * 3. Thêm SEO fields:
     */
    @Column(name = "meta_title", length = 255)
    private String metaTitle;

    @Column(name = "meta_description", length = 500)
    private String metaDescription;

    @Column(name = "slug", unique = true, length = 255)
    private String slug;

    /**
     * 4. Thêm image field:
     */
    @Column(name = "image_url", length = 500)
    private String imageUrl;

    /**
     * 5. Thêm parent category support (hierarchical categories):
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    private Category parent;

    @OneToMany(mappedBy = "parent", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Category> children = new ArrayList<>();

    /**
     * 6. Thêm statistics fields:
     */
    @Column(name = "total_enrollments")
    private Long totalEnrollments = 0L;

    @Column(name = "average_rating")
    private Double averageRating = 0.0;

    /**
     * Getter/Setter methods cho các fields mới:
     */

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public Integer getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }

    public String getMetaTitle() {
        return metaTitle;
    }

    public void setMetaTitle(String metaTitle) {
        this.metaTitle = metaTitle;
    }

    public String getMetaDescription() {
        return metaDescription;
    }

    public void setMetaDescription(String metaDescription) {
        this.metaDescription = metaDescription;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Category getParent() {
        return parent;
    }

    public void setParent(Category parent) {
        this.parent = parent;
    }

    public List<Category> getChildren() {
        return children;
    }

    public void setChildren(List<Category> children) {
        this.children = children;
    }

    public Long getTotalEnrollments() {
        return totalEnrollments;
    }

    public void setTotalEnrollments(Long totalEnrollments) {
        this.totalEnrollments = totalEnrollments;
    }

    public Double getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(Double averageRating) {
        this.averageRating = averageRating;
    }

/**
 * Helper methods:
 */

    /**
     * Kiểm tra có children categories không
     */
    public boolean hasChildren() {
        return children != null && !children.isEmpty();
    }

    /**
     * Kiểm tra có parent category không
     */
    public boolean hasParent() {
        return parent != null;
    }

    /**
     * Lấy tất cả children categories active
     */
    public List<Category> getActiveChildren() {
        if (children == null) {
            return new ArrayList<>();
        }
        return children.stream()
                .filter(Category::isActive)
                .sorted((c1, c2) -> {
                    if (c1.getSortOrder() == null) return 1;
                    if (c2.getSortOrder() == null) return -1;
                    return c1.getSortOrder().compareTo(c2.getSortOrder());
                })
                .collect(Collectors.toList());
    }

    /**
     * Lấy breadcrumb path
     */
    public List<Category> getBreadcrumbPath() {
        List<Category> path = new ArrayList<>();
        Category current = this;

        // Prevent infinite loop
        Set<Long> visited = new HashSet<>();

        while (current != null && !visited.contains(current.getId())) {
            path.add(0, current);
            visited.add(current.getId());
            current = current.getParent();
        }

        return path;
    }

    /**
     * Kiểm tra có image không
     */
    public boolean hasImage() {
        return imageUrl != null && !imageUrl.trim().isEmpty();
    }

    /**
     * Lấy formatted average rating
     */
    public String getFormattedAverageRating() {
        if (averageRating == null || averageRating == 0) {
            return "Chưa có đánh giá";
        }
        return String.format("%.1f/5 ⭐", averageRating);
    }

    /**
     * Tạo slug từ name (helper method)
     */
    public void generateSlugFromName() {
        if (name != null && !name.trim().isEmpty()) {
            this.slug = createSlug(name);
        }
    }

    /**
     * Helper method để tạo slug
     */
    private String createSlug(String input) {
        if (input == null || input.trim().isEmpty()) {
            return "";
        }

        return input.trim()
                .toLowerCase()
                .replaceAll("[àáạảãâầấậẩẫăằắặẳẵ]", "a")
                .replaceAll("[èéẹẻẽêềếệểễ]", "e")
                .replaceAll("[ìíịỉĩ]", "i")
                .replaceAll("[òóọỏõôồốộổỗơờớợởỡ]", "o")
                .replaceAll("[ùúụủũưừứựửữ]", "u")
                .replaceAll("[ỳýỵỷỹ]", "y")
                .replaceAll("[đ]", "d")
                .replaceAll("[^a-z0-9\\s]", "")
                .replaceAll("\\s+", "-")
                .replaceAll("^-|-$", "");
    }

    /**
     * PrePersist method override để set slug
     */
    /**
     * Kiểm tra category có phổ biến không
     */
    public boolean isPopular() {
        return courseCount > 10 || totalEnrollments > 100;
    }

    /**
     * Get display name with parent (if has parent)
     */
    public String getFullDisplayName() {
        if (hasParent()) {
            return parent.getName() + " > " + name;
        }
        return name;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 100)
    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "color_code", length = 7)
    private String colorCode; // Mã màu hex (#FF5733)

    @Column(name = "icon_class", length = 50)
    private String iconClass; // Class icon CSS (fa-graduation-cap)

    @Column(name = "featured")
    private boolean featured = false; // Danh mục nổi bật

    @Column(name = "course_count")
    private int courseCount = 0; // Số lượng khóa học trong danh mục

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Relationship với Course
    @OneToMany(mappedBy = "category", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Course> courses = new ArrayList<>();

    // Constructors
    public Category() {}

    public Category(String name, String description) {
        this.name = name;
        this.description = description;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public Category(String name, String description, String colorCode, String iconClass) {
        this.name = name;
        this.description = description;
        this.colorCode = colorCode;
        this.iconClass = iconClass;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    // Helper methods
    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    /**
     * Cập nhật số lượng khóa học trong danh mục
     */
    public void updateCourseCount() {
        this.courseCount = courses != null ? courses.size() : 0;
    }

    /**
     * Thêm khóa học vào danh mục
     * @param course Khóa học cần thêm
     */
    public void addCourse(Course course) {
        if (courses == null) {
            courses = new ArrayList<>();
        }
        courses.add(course);
        course.setCategory(this);
        updateCourseCount();
    }

    /**
     * Xóa khóa học khỏi danh mục
     * @param course Khóa học cần xóa
     */
    public void removeCourse(Course course) {
        if (courses != null) {
            courses.remove(course);
            course.setCategory(null);
            updateCourseCount();
        }
    }

    /**
     * Lấy màu sắc mặc định nếu chưa set
     * @return Color code
     */
    public String getDisplayColorCode() {
        return colorCode != null ? colorCode : "#007bff"; // Bootstrap primary blue
    }

    /**
     * Lấy icon mặc định nếu chưa set
     * @return Icon class
     */
    public String getDisplayIconClass() {
        return iconClass != null ? iconClass : "fa-folder"; // Default folder icon
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

    public boolean isFeatured() {
        return featured;
    }

    public void setFeatured(boolean featured) {
        this.featured = featured;
    }

    public int getCourseCount() {
        return courseCount;
    }

    public void setCourseCount(int courseCount) {
        this.courseCount = courseCount;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<Course> getCourses() {
        return courses;
    }

    public void setCourses(List<Course> courses) {
        this.courses = courses;
    }

    /**
     * Override toString để debug dễ dàng
     */
    @Override
    public String toString() {
        return "Category{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", courseCount=" + courseCount +
                ", featured=" + featured +
                '}';
    }

    /**
     * Override equals và hashCode cho JPA
     */
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Category)) return false;
        Category category = (Category) o;
        return id != null && id.equals(category.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}