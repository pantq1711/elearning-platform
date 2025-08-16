package com.coursemanagement.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Entity đại diện cho việc đăng ký khóa học của học viên
 * Theo dõi progress và completion status
 */
@Entity
@Table(name = "enrollments")
public class Enrollment {
    // ===== ENROLLMENT ENTITY OPTIONAL FIELDS =====

/**
 * Thêm các fields sau vào Enrollment.java nếu muốn hỗ trợ thêm tính năng:
 * (Các fields này là optional - chỉ thêm nếu cần)
 */

    /**
     * 1. Thêm final score field:
     */
    @Column(name = "final_score")
    private Double finalScore; // Điểm cuối khóa của học viên

    /**
     * 2. Thêm certificate issued date:
     */
    @Column(name = "certificate_issued_date")
    private LocalDateTime certificateIssuedDate; // Ngày cấp chứng chỉ

    /**
     * 3. Thêm learning time tracking:
     */
    @Column(name = "total_learning_time")
    private Integer totalLearningTime; // Tổng thời gian học (phút)

    @Column(name = "last_accessed_at")
    private LocalDateTime lastAccessedAt; // Lần truy cập cuối

    /**
     * 4. Thêm payment information:
     */
    @Column(name = "payment_status")
    @Enumerated(EnumType.STRING)
    private PaymentStatus paymentStatus = PaymentStatus.FREE;

    @Column(name = "payment_amount")
    private Double paymentAmount = 0.0;

    @Column(name = "payment_date")
    private LocalDateTime paymentDate;

    /**
     * 5. Thêm feedback fields:
     */
    @Column(name = "rating")
    private Double rating; // Đánh giá từ 1-5 sao

    @Column(name = "review", columnDefinition = "TEXT")
    private String review; // Nhận xét của học viên

    @Column(name = "review_date")
    private LocalDateTime reviewDate;

    /**
     * Enum cho Payment Status:
     */
    public enum PaymentStatus {
        FREE("Miễn phí"),
        PENDING("Chờ thanh toán"),
        PAID("Đã thanh toán"),
        REFUNDED("Đã hoàn tiền"),
        CANCELLED("Đã hủy");

        private final String displayName;

        PaymentStatus(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }

        public String getCssClass() {
            return switch (this) {
                case FREE -> "badge-success";
                case PENDING -> "badge-warning";
                case PAID -> "badge-success";
                case REFUNDED -> "badge-info";
                case CANCELLED -> "badge-danger";
            };
        }
    }

    /**
     * Getter/Setter methods cho các fields mới:
     */

    public Double getFinalScore() {
        return finalScore;
    }

    public void setFinalScore(Double finalScore) {
        this.finalScore = finalScore;
    }

    public LocalDateTime getCertificateIssuedDate() {
        return certificateIssuedDate;
    }

    public void setCertificateIssuedDate(LocalDateTime certificateIssuedDate) {
        this.certificateIssuedDate = certificateIssuedDate;
    }

    public Integer getTotalLearningTime() {
        return totalLearningTime;
    }

    public void setTotalLearningTime(Integer totalLearningTime) {
        this.totalLearningTime = totalLearningTime;
    }

    public LocalDateTime getLastAccessedAt() {
        return lastAccessedAt;
    }

    public void setLastAccessedAt(LocalDateTime lastAccessedAt) {
        this.lastAccessedAt = lastAccessedAt;
    }

    public PaymentStatus getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(PaymentStatus paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public Double getPaymentAmount() {
        return paymentAmount;
    }

    public void setPaymentAmount(Double paymentAmount) {
        this.paymentAmount = paymentAmount;
    }

    public LocalDateTime getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(LocalDateTime paymentDate) {
        this.paymentDate = paymentDate;
    }

    public Double getRating() {
        return rating;
    }

    public void setRating(Double rating) {
        this.rating = rating;
    }

    public String getReview() {
        return review;
    }

    public void setReview(String review) {
        this.review = review;
    }

    public LocalDateTime getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(LocalDateTime reviewDate) {
        this.reviewDate = reviewDate;
    }

/**
 * Helper methods:
 */

    /**
     * Kiểm tra có điểm cuối khóa chưa
     */
    public boolean hasFinalScore() {
        return finalScore != null && finalScore > 0;
    }

    /**
     * Lấy formatted final score
     */
    public String getFormattedFinalScore() {
        if (finalScore == null || finalScore == 0) {
            return "Chưa có điểm";
        }
        return String.format("%.1f", finalScore);
    }

    /**
     * Kiểm tra có review chưa
     */
    public boolean hasReview() {
        return review != null && !review.trim().isEmpty();
    }

    /**
     * Lấy formatted rating
     */
    public String getFormattedRating() {
        if (rating == null || rating == 0) {
            return "Chưa đánh giá";
        }
        return String.format("%.1f/5 ⭐", rating);
    }

    /**
     * Kiểm tra đã thanh toán chưa
     */
    public boolean isPaid() {
        return paymentStatus == PaymentStatus.PAID || paymentStatus == PaymentStatus.FREE;
    }

    /**
     * Lấy formatted payment amount
     */
    public String getFormattedPaymentAmount() {
        if (paymentAmount == null || paymentAmount == 0) {
            return "Miễn phí";
        }
        return String.format("%,.0f VNĐ", paymentAmount);
    }

    /**
     * Cập nhật learning time
     */
    public void addLearningTime(int minutes) {
        if (totalLearningTime == null) {
            totalLearningTime = 0;
        }
        totalLearningTime += minutes;
        lastAccessedAt = LocalDateTime.now();
        setUpdatedAt(LocalDateTime.now());
    }

    /**
     * Lấy formatted total learning time
     */
    public String getFormattedLearningTime() {
        if (totalLearningTime == null || totalLearningTime == 0) {
            return "Chưa học";
        }

        if (totalLearningTime < 60) {
            return totalLearningTime + " phút";
        } else {
            int hours = totalLearningTime / 60;
            int minutes = totalLearningTime % 60;
            if (minutes == 0) {
                return hours + " giờ";
            } else {
                return hours + " giờ " + minutes + " phút";
            }
        }
    }

    /**
     * Update complete method để set final score và certificate date
     */


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

    @Column()
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
    // Thêm vào class Enrollment.java

    /**
     * Lấy progress dưới dạng percentage (compatibility với JSP)
     * @return Progress percentage
     */
    public Double getProgressPercentage() {
        return this.progress;
    }

    /**
     * Lấy số lessons đã hoàn thành (computed field)
     * Tạm thời return 0, cần implement logic sau
     */
    public Integer getCompletedLessons() {
        // TODO: Implement logic đếm lessons đã complete
        // Có thể tính dựa trên progress và total lessons
        if (course != null && course.getLessonCount() != 0) {
            return (int) Math.round(progress / 100.0 * course.getLessonCount());
        }
        return 0;
    }
    /**
     * Helper methods để format date cho JSP
     */
    public String getFormattedReviewDate() {
        if (reviewDate == null) {
            return "N/A";
        }
        return reviewDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }

    public String getFormattedEnrollmentDate() {
        if (enrollmentDate == null) {
            return "N/A";
        }
        return enrollmentDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }

    /**
     * Lấy tổng số lessons của course
     */
    public Integer getTotalLessons() {
        return course != null ? course.getLessonCount() : 0;
    }

    /**
     * Lấy status enum dựa trên progress
     */
    public String getStatus() {
        if (completed) {
            return "COMPLETED";
        } else if (progress > 0) {
            return "IN_PROGRESS";
        } else {
            return "NOT_STARTED";
        }
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