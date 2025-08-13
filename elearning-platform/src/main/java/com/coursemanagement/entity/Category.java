package com.coursemanagement.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Entity đại diện cho danh mục khóa học
 * Nhóm các khóa học theo chủ đề
 */
@Entity
@Table(name = "categories")
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false, length = 100)
    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(unique = true, length = 150)
    private String slug;

    @Column(name = "is_featured")
    private Boolean featured = false;

    @Column(name = "course_count")
    private Long courseCount = 0L;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Relationships
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
     * Cập nhật course count từ relationship
     */
    public void updateCourseCount() {
        this.courseCount = courses != null ? (long) courses.size() : 0L;
    }

    /**
     * Lấy số lượng active courses
     * @return Số active courses
     */
    public long getActiveCourseCount() {
        if (courses == null) return 0;

        return courses.stream()
                .mapToLong(course -> course.isActive() ? 1 : 0)
                .sum();
    }

    /**
     * Kiểm tra category có featured không
     * @return true nếu featured
     */
    public boolean isFeatured() {
        return featured != null && featured;
    }

    /**
     * Lấy formatted course count
     * @return Formatted text
     */
    public String getFormattedCourseCount() {
        if (courseCount == null || courseCount == 0) {
            return "Chưa có khóa học";
        } else if (courseCount == 1) {
            return "1 khóa học";
        } else {
            return courseCount + " khóa học";
        }
    }

    // Getters và Setters
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

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public Boolean getFeatured() {
        return featured;
    }

    public void setFeatured(Boolean featured) {
        this.featured = featured;
    }

    public Long getCourseCount() {
        return courseCount;
    }

    public void setCourseCount(Long courseCount) {
        this.courseCount = courseCount;
    }

    public void setCourseCount(long courseCount) {
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
                ", slug='" + slug + '\'' +
                ", featured=" + featured +
                ", courseCount=" + courseCount +
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