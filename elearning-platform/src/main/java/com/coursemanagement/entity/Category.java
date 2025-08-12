package com.coursemanagement.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Entity đại diện cho bảng categories trong database
 * Lưu thông tin danh mục khóa học
 */
@Entity
@Table(name = "categories")
public class Category {

    /**
     * ID tự động tăng - Primary Key
     */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Tên danh mục - unique và không được trống
     */
    @Column(unique = true, nullable = false)
    @NotBlank(message = "Tên danh mục không được để trống")
    @Size(min = 2, max = 100, message = "Tên danh mục phải từ 2-100 ký tự")
    private String name;

    /**
     * Mô tả về danh mục (tùy chọn)
     */
    @Column(columnDefinition = "TEXT")
    private String description;

    /**
     * Thời gian tạo danh mục
     */
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    /**
     * Thời gian cập nhật cuối cùng
     */
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    /**
     * Màu sắc đại diện cho danh mục (hex color)
     */
    @Column(name = "color_code")
    private String colorCode;

    /**
     * Icon đại diện cho danh mục (Font Awesome class)
     */
    @Column(name = "icon_class")
    private String iconClass;

    /**
     * Thứ tự sắp xếp hiển thị
     */
    @Column(name = "display_order")
    private Integer displayOrder;

    /**
     * Trạng thái hiển thị trên trang chủ
     */
    @Column(name = "is_featured")
    private boolean isFeatured = false;

    /**
     * Slug URL thân thiện
     */
    @Column(unique = true)
    private String slug;

    /**
     * Quan hệ One-to-Many với Course
     * Một danh mục có thể chứa nhiều khóa học
     */
    @OneToMany(mappedBy = "category", fetch = FetchType.LAZY)
    private List<Course> courses = new ArrayList<>();

    /**
     * Constructor mặc định
     */
    public Category() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Constructor với tên danh mục
     */
    public Category(String name) {
        this();
        this.name = name;
        this.slug = generateSlug(name);
    }

    /**
     * Constructor với tên và mô tả
     */
    public Category(String name, String description) {
        this(name);
        this.description = description;
    }

    /**
     * Callback được gọi trước khi persist entity
     */
    @PrePersist
    public void prePersist() {
        LocalDateTime now = LocalDateTime.now();
        this.createdAt = now;
        this.updatedAt = now;

        if (this.slug == null || this.slug.trim().isEmpty()) {
            this.slug = generateSlug(this.name);
        }
    }

    /**
     * Callback được gọi trước khi update entity
     */
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();

        if (this.slug == null || this.slug.trim().isEmpty()) {
            this.slug = generateSlug(this.name);
        }
    }

    // === Helper methods ===

    /**
     * Lấy số lượng khóa học trong danh mục
     */
    public int getCourseCount() {
        return courses != null ? courses.size() : 0;
    }

    /**
     * Lấy số lượng khóa học đang hoạt động
     */
    public long getActiveCourseCount() {
        if (courses == null) {
            return 0;
        }

        return courses.stream()
                .filter(Course::isActive)
                .count();
    }

    /**
     * Kiểm tra danh mục có thể xóa không
     * Chỉ có thể xóa khi không có khóa học nào
     */
    public boolean canBeDeleted() {
        return courses == null || courses.isEmpty();
    }

    /**
     * Thêm khóa học vào danh mục
     */
    public void addCourse(Course course) {
        if (courses == null) {
            courses = new ArrayList<>();
        }
        courses.add(course);
        course.setCategory(this);
    }

    /**
     * Xóa khóa học khỏi danh mục
     */
    public void removeCourse(Course course) {
        if (courses != null) {
            courses.remove(course);
        }
        course.setCategory(null);
    }

    /**
     * Lấy màu sắc mặc định nếu chưa có
     */
    public String getColorCodeOrDefault() {
        return colorCode != null && !colorCode.trim().isEmpty() ? colorCode : "#6c757d";
    }

    /**
     * Lấy icon mặc định nếu chưa có
     */
    public String getIconClassOrDefault() {
        return iconClass != null && !iconClass.trim().isEmpty() ? iconClass : "fas fa-folder";
    }

    /**
     * Tạo slug từ tên danh mục
     */
    private String generateSlug(String name) {
        if (name == null || name.trim().isEmpty()) {
            return "";
        }

        return name.toLowerCase()
                .replaceAll("[àáạảãâầấậẩẫăằắặẳẵ]", "a")
                .replaceAll("[èéẹẻẽêềếệểễ]", "e")
                .replaceAll("[ìíịỉĩ]", "i")
                .replaceAll("[òóọỏõôồốộổỗơờớợởỡ]", "o")
                .replaceAll("[ùúụủũưừứựửữ]", "u")
                .replaceAll("[ỳýỵỷỹ]", "y")
                .replaceAll("[đ]", "d")
                .replaceAll("[^a-z0-9\\s]", "")
                .replaceAll("\\s+", "-")
                .trim();
    }

    /**
     * Kiểm tra danh mục có nổi bật không
     */
    public boolean isFeatured() {
        return isFeatured;
    }

    /**
     * Lấy khóa học mới nhất trong danh mục
     */
    public Course getLatestCourse() {
        if (courses == null || courses.isEmpty()) {
            return null;
        }

        return courses.stream()
                .filter(Course::isActive)
                .max((c1, c2) -> c1.getCreatedAt().compareTo(c2.getCreatedAt()))
                .orElse(null);
    }

    /**
     * Lấy khóa học phổ biến nhất trong danh mục
     */
    public Course getMostPopularCourse() {
        if (courses == null || courses.isEmpty()) {
            return null;
        }

        return courses.stream()
                .filter(Course::isActive)
                .max((c1, c2) -> Integer.compare(c1.getEnrollmentCount(), c2.getEnrollmentCount()))
                .orElse(null);
    }

    /**
     * Tính tổng số học viên trong danh mục
     */
    public int getTotalStudentCount() {
        if (courses == null) {
            return 0;
        }

        return courses.stream()
                .filter(Course::isActive)
                .mapToInt(Course::getEnrollmentCount)
                .sum();
    }

    /**
     * Kiểm tra danh mục có khóa học mới trong X ngày qua không
     */
    public boolean hasNewCoursesWithinDays(int days) {
        if (courses == null || courses.isEmpty()) {
            return false;
        }

        LocalDateTime cutoff = LocalDateTime.now().minusDays(days);
        return courses.stream()
                .anyMatch(course -> course.getCreatedAt().isAfter(cutoff));
    }

    // === Getters và Setters ===

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

    public Integer getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(Integer displayOrder) {
        this.displayOrder = displayOrder;
    }

    public void setFeatured(boolean featured) {
        isFeatured = featured;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
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
                ", slug='" + slug + '\'' +
                ", courseCount=" + getCourseCount() +
                ", isFeatured=" + isFeatured +
                ", displayOrder=" + displayOrder +
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