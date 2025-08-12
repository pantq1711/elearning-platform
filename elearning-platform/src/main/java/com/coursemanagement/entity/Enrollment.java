package com.coursemanagement.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;

/**
 * Entity đại diện cho bảng enrollments trong database
 * Lưu thông tin đăng ký khóa học của học viên
 * Đây là bảng trung gian giữa User và Course (Many-to-Many relationship)
 */
@Entity
@Table(name = "enrollments",
        uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "course_id"}))
public class Enrollment {

    /**
     * ID tự động tăng - Primary Key
     */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Thời gian đăng ký khóa học
     */
    @Column(name = "enrolled_at")
    private LocalDateTime enrolledAt;

    /**
     * Thời gian hoàn thành khóa học
     * Null nếu chưa hoàn thành
     */
    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    /**
     * Trạng thái hoàn thành khóa học
     */
    @Column(name = "is_completed")
    private boolean isCompleted = false;

    /**
     * Điểm cao nhất đạt được trong các bài kiểm tra
     * Null nếu chưa làm bài kiểm tra nào
     */
    @Column(name = "highest_score")
    private Double highestScore;

    /**
     * Quan hệ Many-to-One với User (Student)
     * Một học viên có thể đăng ký nhiều khóa học
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User student;

    /**
     * Quan hệ Many-to-One với Course
     * Một khóa học có thể có nhiều học viên đăng ký
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id", nullable = false)
    private Course course;

    /**
     * Constructor mặc định
     */
    public Enrollment() {
        this.enrolledAt = LocalDateTime.now();
    }

    /**
     * Constructor với học viên và khóa học
     */
    public Enrollment(User student, Course course) {
        this();
        this.student = student;
        this.course = course;
    }

    /**
     * Đánh dấu khóa học là đã hoàn thành
     */
    public void markAsCompleted() {
        this.isCompleted = true;
        this.completedAt = LocalDateTime.now();
    }

    /**
     * Đánh dấu khóa học là chưa hoàn thành
     */
    public void markAsIncomplete() {
        this.isCompleted = false;
        this.completedAt = null;
    }

    /**
     * Cập nhật điểm cao nhất nếu điểm mới cao hơn
     * @param newScore Điểm mới
     */
    public void updateHighestScore(Double newScore) {
        if (newScore != null) {
            if (this.highestScore == null || newScore > this.highestScore) {
                this.highestScore = newScore;
            }
        }
    }

    /**
     * Tính số ngày đã học
     * @return Số ngày từ khi đăng ký đến hiện tại
     */
    public long getDaysEnrolled() {
        LocalDateTime now = LocalDateTime.now();
        return java.time.temporal.ChronoUnit.DAYS.between(enrolledAt, now);
    }

    /**
     * Tính số ngày để hoàn thành khóa học
     * @return Số ngày từ khi đăng ký đến khi hoàn thành, hoặc -1 nếu chưa hoàn thành
     */
    public long getDaysToComplete() {
        if (!isCompleted || completedAt == null) {
            return -1;
        }
        return java.time.temporal.ChronoUnit.DAYS.between(enrolledAt, completedAt);
    }

    /**
     * Lấy trạng thái học tập dạng text
     * @return Chuỗi mô tả trạng thái
     */
    public String getStatusText() {
        if (isCompleted) {
            return "Đã hoàn thành";
        } else {
            return "Đang học";
        }
    }

    /**
     * Lấy màu sắc cho trạng thái (để hiển thị trên UI)
     * @return Tên class CSS cho màu
     */
    public String getStatusColor() {
        if (isCompleted) {
            return "text-success"; // Màu xanh lá
        } else {
            return "text-primary"; // Màu xanh dương
        }
    }

    /**
     * Kiểm tra có điểm hay không
     * @return true nếu có điểm, false nếu không có
     */
    public boolean hasScore() {
        return highestScore != null;
    }

    /**
     * Lấy điểm dạng phần trăm với 1 chữ số thập phân
     * @return Chuỗi điểm dạng "85.5%" hoặc "Chưa có điểm"
     */
    public String getScoreText() {
        if (hasScore()) {
            return String.format("%.1f%%", highestScore);
        } else {
            return "Chưa có điểm";
        }
    }

    // === Getters và Setters ===

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public LocalDateTime getEnrolledAt() {
        return enrolledAt;
    }

    public void setEnrolledAt(LocalDateTime enrolledAt) {
        this.enrolledAt = enrolledAt;
    }

    public LocalDateTime getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(LocalDateTime completedAt) {
        this.completedAt = completedAt;
    }

    public boolean isCompleted() {
        return isCompleted;
    }

    public void setCompleted(boolean completed) {
        isCompleted = completed;
    }

    public Double getHighestScore() {
        return highestScore;
    }

    public void setHighestScore(Double highestScore) {
        this.highestScore = highestScore;
    }

    public User getStudent() {
        return student;
    }

    public void setStudent(User student) {
        this.student = student;
    }

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }

    /**
     * Override toString để debug dễ dàng
     */
    @Override
    public String toString() {
        return "Enrollment{" +
                "id=" + id +
                ", student=" + (student != null ? student.getUsername() : "null") +
                ", course=" + (course != null ? course.getName() : "null") +
                ", isCompleted=" + isCompleted +
                ", highestScore=" + highestScore +
                ", daysEnrolled=" + getDaysEnrolled() +
                '}';
    }
}