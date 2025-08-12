package com.coursemanagement.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Entity đại diện cho bảng categories trong database
 * Lưu thông tin danh mục khóa học (Lập trình, Tiếng Anh, Toán học...)
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
     * Tên danh mục - không được trống và phải unique
     */
    @Column(unique = true, nullable = false)
    @NotBlank(message = "Tên danh mục không được để trống")
    @Size(min = 2, max = 100, message = "Tên danh mục phải từ 2-100 ký tự")
    private String name;

    /**
     * Mô tả chi tiết về danh mục
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
     * Danh sách các khóa học thuộc danh mục này
     * Quan hệ One-to-Many với Course
     * mappedBy = "category" nghĩa là Course entity có thuộc tính category
     * cascade = CascadeType.ALL nghĩa là khi xóa Category thì xóa luôn các Course
     * fetch = FetchType.LAZY nghĩa là chỉ load courses khi cần thiết
     */
    @OneToMany(mappedBy = "category", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
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
    }

    /**
     * Constructor với tên và mô tả
     */
    public Category(String name, String description) {
        this(name);
        this.description = description;
    }

    /**
     * Callback được gọi trước khi update entity
     */
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Thêm khóa học vào danh mục
     * @param course Khóa học cần thêm
     */
    public void addCourse(Course course) {
        courses.add(course);
        course.setCategory(this);
    }

    /**
     * Xóa khóa học khỏi danh mục
     * @param course Khóa học cần xóa
     */
    public void removeCourse(Course course) {
        courses.remove(course);
        course.setCategory(null);
    }

    /**
     * Lấy số lượng khóa học trong danh mục
     * @return Số lượng khóa học
     */
    public int getCourseCount() {
        return courses.size();
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
                ", description='" + description + '\'' +
                ", courseCount=" + getCourseCount() +
                '}';
    }
}