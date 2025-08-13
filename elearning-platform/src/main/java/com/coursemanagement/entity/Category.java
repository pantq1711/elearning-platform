package com.coursemanagement.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Entity đại diện cho danh mục khóa học
 * Chứa thông tin về danh mục, màu sắc, icon và số lượng khóa học
 * Cập nhật với đầy đủ các field cần thiết
 */
@Entity
@Table(name = "categories")
public class Category {

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