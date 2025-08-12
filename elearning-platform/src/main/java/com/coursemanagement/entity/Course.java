package com.coursemanagement.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Entity đại diện cho bảng courses trong database
 * Lưu thông tin khóa học do giảng viên tạo ra
 */
@Entity
@Table(name = "courses")
public class Course {

    /**
     * ID tự động tăng - Primary Key
     */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Tên khóa học - không được trống
     */
    @Column(nullable = false)
    @NotBlank(message = "Tên khóa học không được để trống")
    @Size(min = 5, max = 200, message = "Tên khóa học phải từ 5-200 ký tự")
    private String name;

    /**
     * Mô tả chi tiết về khóa học
     */
    @Column(columnDefinition = "TEXT")
    private String description;

    /**
     * Thời gian tạo khóa học
     */
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    /**
     * Thời gian cập nhật cuối cùng
     */
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    /**
     * Trạng thái khóa học có được kích hoạt không
     */
    @Column(name = "is_active")
    private boolean isActive = true;

    /**
     * Quan hệ Many-to-One với Category
     * Một khóa học thuộc về một danh mục
     * @JoinColumn chỉ định foreign key column trong bảng courses
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;

    /**
     * Quan hệ Many-to-One với User (Instructor)
     * Một khóa học được tạo bởi một giảng viên
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "instructor_id", nullable = false)
    private User instructor;

    /**
     * Danh sách các bài giảng trong khóa học
     * Quan hệ One-to-Many với Lesson
     * cascade = CascadeType.ALL nghĩa là khi xóa Course thì xóa luôn các Lesson
     */
    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @OrderBy("id ASC") // Sắp xếp bài giảng theo thứ tự tạo
    private List<Lesson> lessons = new ArrayList<>();

    /**
     * Danh sách học viên đăng ký khóa học
     * Quan hệ One-to-Many với Enrollment
     */
    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Enrollment> enrollments = new ArrayList<>();

    /**
     * Danh sách bài kiểm tra trong khóa học
     * Quan hệ One-to-Many với Quiz
     */
    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Quiz> quizzes = new ArrayList<>();

    /**
     * Constructor mặc định
     */
    public Course() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Constructor với thông tin cơ bản
     */
    public Course(String name, String description, Category category, User instructor) {
        this();
        this.name = name;
        this.description = description;
        this.category = category;
        this.instructor = instructor;
    }

    /**
     * Callback được gọi trước khi update entity
     */
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Thêm bài giảng vào khóa học
     * @param lesson Bài giảng cần thêm
     */
    public void addLesson(Lesson lesson) {
        lessons.add(lesson);
        lesson.setCourse(this);
    }

    /**
     * Xóa bài giảng khỏi khóa học
     * @param lesson Bài giảng cần xóa
     */
    public void removeLesson(Lesson lesson) {
        lessons.remove(lesson);
        lesson.setCourse(null);
    }

    /**
     * Thêm học viên đăng ký khóa học
     * @param enrollment Đăng ký khóa học
     */
    public void addEnrollment(Enrollment enrollment) {
        enrollments.add(enrollment);
        enrollment.setCourse(this);
    }

    /**
     * Xóa học viên khỏi khóa học
     * @param enrollment Đăng ký khóa học cần xóa
     */
    public void removeEnrollment(Enrollment enrollment) {
        enrollments.remove(enrollment);
        enrollment.setCourse(null);
    }

    /**
     * Thêm bài kiểm tra vào khóa học
     * @param quiz Bài kiểm tra cần thêm
     */
    public void addQuiz(Quiz quiz) {
        quizzes.add(quiz);
        quiz.setCourse(this);
    }

    /**
     * Xóa bài kiểm tra khỏi khóa học
     * @param quiz Bài kiểm tra cần xóa
     */
    public void removeQuiz(Quiz quiz) {
        quizzes.remove(quiz);
        quiz.setCourse(null);
    }

    /**
     * Lấy số lượng học viên đã đăng ký
     * @return Số lượng học viên
     */
    public int getEnrollmentCount() {
        return enrollments.size();
    }

    /**
     * Lấy số lượng bài giảng
     * @return Số lượng bài giảng
     */
    public int getLessonCount() {
        return lessons.size();
    }

    /**
     * Lấy số lượng bài kiểm tra
     * @return Số lượng bài kiểm tra
     */
    public int getQuizCount() {
        return quizzes.size();
    }

    /**
     * Kiểm tra học viên có thể xóa khóa học không
     * Chỉ có thể xóa khi chưa có học viên nào đăng ký
     * @return true nếu có thể xóa, false nếu không thể
     */
    public boolean canBeDeleted() {
        return enrollments.isEmpty();
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

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public User getInstructor() {
        return instructor;
    }

    public void setInstructor(User instructor) {
        this.instructor = instructor;
    }

    public List<Lesson> getLessons() {
        return lessons;
    }

    public void setLessons(List<Lesson> lessons) {
        this.lessons = lessons;
    }

    public List<Enrollment> getEnrollments() {
        return enrollments;
    }

    public void setEnrollments(List<Enrollment> enrollments) {
        this.enrollments = enrollments;
    }

    public List<Quiz> getQuizzes() {
        return quizzes;
    }

    public void setQuizzes(List<Quiz> quizzes) {
        this.quizzes = quizzes;
    }

    /**
     * Override toString để debug dễ dàng
     */
    @Override
    public String toString() {
        return "Course{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", instructor=" + (instructor != null ? instructor.getUsername() : "null") +
                ", category=" + (category != null ? category.getName() : "null") +
                ", isActive=" + isActive +
                ", enrollmentCount=" + getEnrollmentCount() +
                '}';
    }
}