package com.coursemanagement.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Entity đại diện cho việc đăng ký khóa học của học viên
 * Theo dõi progress và completion status
 */
@Entity
@Table(name = "enrollments")
public class Enrollment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id", nullable = false)
    private User student;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id", nullable = false)
    private Course course;

    @Column(name = "enrollment_date", nullable = false)
    private LocalDateTime enrollmentDate;

    @Column(name = "completion_date")
    private LocalDateTime completionDate;

    @Column(nullable = false)
    private Double progress = 0.0; // Tiến độ từ 0-100%

    @Column(precision = 5, scale = 2)
    private Double score = 0.0; // Điểm cuối khóa

    @Column(name = "is_completed")
    private boolean completed = false;

    @Column(name = "certificate_issued")
    private boolean certificateIssued = false;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Constructors
    public Enrollment() {
        this.enrollmentDate = LocalDateTime.now();
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public Enrollment(User student, Course course) {
        this.student = student;
        this.course = course;
        this.enrollmentDate = LocalDateTime.now();
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    // Helper methods
    @PrePersist
    protected void onCreate() {
        if (enrollmentDate == null) {
            enrollmentDate = LocalDateTime.now();
        }
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
     * Cập nhật progress và auto-complete nếu đạt 100%
     * @param newProgress Progress mới (0-100)
     */
    public void updateProgress(double newProgress) {
        this.progress = Math.max(0.0, Math.min(100.0, newProgress));

        if (this.progress >= 100.0 && !this.completed) {
            this.completed = true;
            this.completionDate = LocalDateTime.now();
        }

        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Hoàn thành enrollment
     * @param finalScore Điểm cuối khóa
     */
    public void complete(Double finalScore) {
        this.completed = true;
        this.progress = 100.0;
        this.completionDate = LocalDateTime.now();
        if (finalScore != null) {
            this.score = finalScore;
        }
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Lấy formatted progress
     * @return Progress text
     */
    public String getFormattedProgress() {
        return String.format("%.1f%%", progress);
    }

    /**
     * Lấy formatted score
     * @return Score text
     */
    public String getFormattedScore() {
        if (score == null || score == 0.0) {
            return "Chưa có điểm";
        }
        return String.format("%.1f", score);
    }

    /**
     * Tính thời gian học
     * @return Số ngày đã học
     */
    public long getStudyDays() {
        if (enrollmentDate == null) {
            return 0;
        }

        LocalDateTime endDate = completionDate != null ? completionDate : LocalDateTime.now();
        return java.time.Duration.between(enrollmentDate, endDate).toDays();
    }

    // Getters và Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

    public LocalDateTime getEnrollmentDate() {
        return enrollmentDate;
    }

    public void setEnrollmentDate(LocalDateTime enrollmentDate) {
        this.enrollmentDate = enrollmentDate;
    }

    public LocalDateTime getCompletionDate() {
        return completionDate;
    }

    public void setCompletionDate(LocalDateTime completionDate) {
        this.completionDate = completionDate;
    }

    public Double getProgress() {
        return progress;
    }

    public void setProgress(Double progress) {
        this.progress = progress;
    }

    public void setProgress(double progress) {
        this.progress = progress;
    }

    public Double getScore() {
        return score;
    }

    public void setScore(Double score) {
        this.score = score;
    }

    public void setScore(double score) {
        this.score = score;
    }

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }

    public boolean isCertificateIssued() {
        return certificateIssued;
    }

    public void setCertificateIssued(boolean certificateIssued) {
        this.certificateIssued = certificateIssued;
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

    /**
     * Override toString để debug dễ dàng
     */
    @Override
    public String toString() {
        return "Enrollment{" +
                "id=" + id +
                ", studentId=" + (student != null ? student.getId() : "null") +
                ", courseId=" + (course != null ? course.getId() : "null") +
                ", progress=" + progress +
                ", score=" + score +
                ", completed=" + completed +
                '}';
    }

    /**
     * Override equals và hashCode cho JPA
     */
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Enrollment)) return false;
        Enrollment that = (Enrollment) o;
        return id != null && id.equals(that.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}