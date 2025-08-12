package com.coursemanagement.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.time.Duration;

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
     * Tiến độ học tập (phần trăm hoàn thành)
     */
    @Column(name = "progress_percentage")
    private Double progressPercentage = 0.0;

    /**
     * Thời gian truy cập cuối cùng
     */
    @Column(name = "last_accessed")
    private LocalDateTime lastAccessed;

    /**
     * Số giờ học đã tích lũy
     */
    @Column(name = "study_hours")
    private Double studyHours = 0.0;

    /**
     * Ghi chú về quá trình học
     */
    @Column(columnDefinition = "TEXT")
    private String notes;

    /**
     * Trạng thái enrollment
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private EnrollmentStatus status = EnrollmentStatus.ACTIVE;

    /**
     * Lý do drop out (nếu có)
     */
    @Column(name = "dropout_reason")
    private String dropoutReason;

    /**
     * Ngày bắt đầu học thực tế
     */
    @Column(name = "study_started_at")
    private LocalDateTime studyStartedAt;

    /**
     * Deadline hoàn thành (nếu có)
     */
    @Column(name = "deadline")
    private LocalDateTime deadline;

    /**
     * Đánh giá của học viên về khóa học (1-5 sao)
     */
    @Column(name = "rating")
    private Integer rating;

    /**
     * Nhận xét của học viên về khóa học
     */
    @Column(name = "review", columnDefinition = "TEXT")
    private String review;

    /**
     * Chứng chỉ hoàn thành (URL đến file)
     */
    @Column(name = "certificate_url")
    private String certificateUrl;

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
     * Enum định nghĩa trạng thái enrollment
     */
    public enum EnrollmentStatus {
        ACTIVE("Đang học"),
        COMPLETED("Đã hoàn thành"),
        DROPPED("Đã bỏ học"),
        SUSPENDED("Tạm dừng"),
        EXPIRED("Hết hạn");

        private final String displayName;

        EnrollmentStatus(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }

    /**
     * Constructor mặc định
     */
    public Enrollment() {
        this.enrolledAt = LocalDateTime.now();
        this.progressPercentage = 0.0;
        this.studyHours = 0.0;
        this.status = EnrollmentStatus.ACTIVE;
        this.isCompleted = false;
    }

    /**
     * Constructor với học viên và khóa học
     */
    public Enrollment(User student, Course course) {
        this();
        this.student = student;
        this.course = course;
        this.lastAccessed = LocalDateTime.now();
    }

    // === Helper methods ===

    /**
     * Cập nhật thời gian truy cập cuối
     */
    public void updateLastAccessed() {
        this.lastAccessed = LocalDateTime.now();
    }

    /**
     * Hoàn thành khóa học
     */
    public void complete() {
        this.isCompleted = true;
        this.completedAt = LocalDateTime.now();
        this.status = EnrollmentStatus.COMPLETED;
        this.progressPercentage = 100.0;
    }

    /**
     * Bỏ học với lý do
     */
    public void dropout(String reason) {
        this.status = EnrollmentStatus.DROPPED;
        this.dropoutReason = reason;
    }

    /**
     * Tạm dừng học
     */
    public void suspend() {
        this.status = EnrollmentStatus.SUSPENDED;
    }

    /**
     * Kích hoạt lại
     */
    public void reactivate() {
        this.status = EnrollmentStatus.ACTIVE;
        this.dropoutReason = null;
    }

    /**
     * Cập nhật tiến độ học tập
     */
    public void updateProgress(double percentage) {
        this.progressPercentage = Math.max(0, Math.min(100, percentage));

        // Tự động hoàn thành nếu đạt 100%
        if (this.progressPercentage >= 100.0 && !isCompleted) {
            complete();
        }

        updateLastAccessed();
    }

    /**
     * Thêm giờ học
     */
    public void addStudyTime(double hours) {
        if (hours > 0) {
            this.studyHours = (this.studyHours != null ? this.studyHours : 0.0) + hours;
            updateLastAccessed();
        }
    }

    /**
     * Cập nhật điểm cao nhất
     */
    public void updateHighestScore(double score) {
        if (this.highestScore == null || score > this.highestScore) {
            this.highestScore = score;
        }
    }

    /**
     * Kiểm tra có đang học không
     */
    public boolean isActive() {
        return status == EnrollmentStatus.ACTIVE;
    }

    /**
     * Kiểm tra đã hoàn thành chưa
     */
    public boolean isCompleted() {
        return isCompleted && status == EnrollmentStatus.COMPLETED;
    }

    /**
     * Kiểm tra đã bỏ học chưa
     */
    public boolean isDropped() {
        return status == EnrollmentStatus.DROPPED;
    }

    /**
     * Kiểm tra có bị tạm dừng không
     */
    public boolean isSuspended() {
        return status == EnrollmentStatus.SUSPENDED;
    }

    /**
     * Kiểm tra có hết hạn không
     */
    public boolean isExpired() {
        return status == EnrollmentStatus.EXPIRED ||
                (deadline != null && LocalDateTime.now().isAfter(deadline));
    }

    /**
     * Lấy thời gian học (từ đăng ký đến hiện tại hoặc hoàn thành)
     */
    public long getStudyDurationDays() {
        LocalDateTime endTime = isCompleted() ? completedAt : LocalDateTime.now();
        return Duration.between(enrolledAt, endTime).toDays();
    }

    /**
     * Lấy thời gian học dưới dạng text
     */
    public String getDisplayStudyDuration() {
        long days = getStudyDurationDays();

        if (days < 1) {
            return "Dưới 1 ngày";
        } else if (days < 7) {
            return days + " ngày";
        } else if (days < 30) {
            long weeks = days / 7;
            return weeks + " tuần";
        } else if (days < 365) {
            long months = days / 30;
            return months + " tháng";
        } else {
            long years = days / 365;
            return years + " năm";
        }
    }

    /**
     * Lấy tiến độ dưới dạng text
     */
    public String getDisplayProgress() {
        if (progressPercentage == null) {
            return "0%";
        }
        return String.format("%.1f%%", progressPercentage);
    }

    /**
     * Lấy màu sắc cho tiến độ
     */
    public String getProgressColor() {
        if (progressPercentage == null || progressPercentage < 25) {
            return "#dc3545"; // Red
        } else if (progressPercentage < 50) {
            return "#fd7e14"; // Orange
        } else if (progressPercentage < 75) {
            return "#ffc107"; // Yellow
        } else if (progressPercentage < 100) {
            return "#17a2b8"; // Blue
        } else {
            return "#28a745"; // Green
        }
    }

    /**
     * Lấy giờ học dưới dạng text
     */
    public String getDisplayStudyHours() {
        if (studyHours == null || studyHours <= 0) {
            return "0 giờ";
        }

        if (studyHours < 1) {
            return String.format("%.1f giờ", studyHours);
        } else {
            return String.format("%.0f giờ", studyHours);
        }
    }

    /**
     * Kiểm tra có deadline không
     */
    public boolean hasDeadline() {
        return deadline != null;
    }

    /**
     * Kiểm tra có sắp hết deadline không (trong vòng X ngày)
     */
    public boolean isNearDeadline(int days) {
        if (deadline == null) {
            return false;
        }

        LocalDateTime cutoff = LocalDateTime.now().plusDays(days);
        return deadline.isBefore(cutoff) && deadline.isAfter(LocalDateTime.now());
    }

    /**
     * Lấy số ngày còn lại đến deadline
     */
    public long getDaysUntilDeadline() {
        if (deadline == null) {
            return -1;
        }

        return Duration.between(LocalDateTime.now(), deadline).toDays();
    }

    /**
     * Kiểm tra có đánh giá không
     */
    public boolean hasRating() {
        return rating != null && rating > 0;
    }

    /**
     * Kiểm tra có review không
     */
    public boolean hasReview() {
        return review != null && !review.trim().isEmpty();
    }

    /**
     * Lấy rating dưới dạng sao
     */
    public String getDisplayRating() {
        if (rating == null || rating <= 0) {
            return "Chưa đánh giá";
        }

        StringBuilder stars = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            if (i <= rating) {
                stars.append("★");
            } else {
                stars.append("☆");
            }
        }
        return stars.toString();
    }

    /**
     * Kiểm tra có chứng chỉ không
     */
    public boolean hasCertificate() {
        return certificateUrl != null && !certificateUrl.trim().isEmpty();
    }

    /**
     * Kiểm tra có thể nhận chứng chỉ không
     */
    public boolean canReceiveCertificate() {
        return isCompleted() && highestScore != null &&
                course != null && course.isActive();
    }

    /**
     * Lấy trạng thái chi tiết
     */
    public String getDetailedStatus() {
        switch (status) {
            case ACTIVE:
                return "Đang học (" + getDisplayProgress() + ")";
            case COMPLETED:
                return "Đã hoàn thành";
            case DROPPED:
                return "Đã bỏ học" + (dropoutReason != null ? " - " + dropoutReason : "");
            case SUSPENDED:
                return "Tạm dừng";
            case EXPIRED:
                return "Hết hạn";
            default:
                return status.getDisplayName();
        }
    }

    /**
     * Kiểm tra có truy cập gần đây không (trong X ngày)
     */
    public boolean hasRecentActivity(int days) {
        if (lastAccessed == null) {
            return false;
        }

        LocalDateTime cutoff = LocalDateTime.now().minusDays(days);
        return lastAccessed.isAfter(cutoff);
    }

    /**
     * Lấy thông tin tóm tắt
     */
    public String getSummary() {
        StringBuilder summary = new StringBuilder();
        summary.append(getDetailedStatus());

        if (highestScore != null) {
            summary.append(" - Điểm cao nhất: ").append(String.format("%.1f", highestScore));
        }

        if (studyHours != null && studyHours > 0) {
            summary.append(" - ").append(getDisplayStudyHours());
        }

        return summary.toString();
    }

    /**
     * Lấy icon cho trạng thái
     */
    public String getStatusIcon() {
        switch (status) {
            case ACTIVE:
                return "fas fa-play";
            case COMPLETED:
                return "fas fa-check-circle";
            case DROPPED:
                return "fas fa-times-circle";
            case SUSPENDED:
                return "fas fa-pause-circle";
            case EXPIRED:
                return "fas fa-clock";
            default:
                return "fas fa-question-circle";
        }
    }

    /**
     * Lấy màu cho trạng thái
     */
    public String getStatusColor() {
        switch (status) {
            case ACTIVE:
                return "#17a2b8"; // Blue
            case COMPLETED:
                return "#28a745"; // Green
            case DROPPED:
                return "#dc3545"; // Red
            case SUSPENDED:
                return "#ffc107"; // Yellow
            case EXPIRED:
                return "#6c757d"; // Gray
            default:
                return "#6c757d"; // Gray
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

    public void setCompleted(boolean completed) {
        isCompleted = completed;
    }

    public Double getHighestScore() {
        return highestScore;
    }

    public void setHighestScore(Double highestScore) {
        this.highestScore = highestScore;
    }

    public Double getProgressPercentage() {
        return progressPercentage;
    }

    public void setProgressPercentage(Double progressPercentage) {
        this.progressPercentage = progressPercentage;
    }

    public LocalDateTime getLastAccessed() {
        return lastAccessed;
    }

    public void setLastAccessed(LocalDateTime lastAccessed) {
        this.lastAccessed = lastAccessed;
    }

    public Double getStudyHours() {
        return studyHours;
    }

    public void setStudyHours(Double studyHours) {
        this.studyHours = studyHours;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public EnrollmentStatus getStatus() {
        return status;
    }

    public void setStatus(EnrollmentStatus status) {
        this.status = status;
    }

    public String getDropoutReason() {
        return dropoutReason;
    }

    public void setDropoutReason(String dropoutReason) {
        this.dropoutReason = dropoutReason;
    }

    public LocalDateTime getStudyStartedAt() {
        return studyStartedAt;
    }

    public void setStudyStartedAt(LocalDateTime studyStartedAt) {
        this.studyStartedAt = studyStartedAt;
    }

    public LocalDateTime getDeadline() {
        return deadline;
    }

    public void setDeadline(LocalDateTime deadline) {
        this.deadline = deadline;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public String getReview() {
        return review;
    }

    public void setReview(String review) {
        this.review = review;
    }

    public String getCertificateUrl() {
        return certificateUrl;
    }

    public void setCertificateUrl(String certificateUrl) {
        this.certificateUrl = certificateUrl;
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
                ", status=" + status +
                ", isCompleted=" + isCompleted +
                ", progressPercentage=" + progressPercentage +
                ", highestScore=" + highestScore +
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