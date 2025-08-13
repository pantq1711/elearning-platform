package com.coursemanagement.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Entity đại diện cho một bài học trong khóa học
 * Chứa nội dung, video, tài liệu và thông tin về bài học
 */
@Entity
@Table(name = "lessons")
public class Lesson {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String content;

    @Column(unique = true, length = 255)
    private String slug;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id", nullable = false)
    private Course course;

    @Column(name = "order_index")
    private Integer orderIndex;

    @Column(name = "video_link", length = 500)
    private String videoLink;

    @Column(name = "document_url", length = 500)
    private String documentUrl;

    @Column(name = "estimated_duration")
    private Integer estimatedDuration; // Thời lượng ước tính tính bằng phút

    @Column(name = "is_preview")
    private boolean preview = false; // Có thể xem trước không cần đăng ký

    @Column(name = "is_active")
    private boolean active = true;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Constructors
    public Lesson() {}

    public Lesson(String title, String content, Course course, Integer orderIndex) {
        this.title = title;
        this.content = content;
        this.course = course;
        this.orderIndex = orderIndex;
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
     * Kiểm tra lesson có video không
     * @return true nếu có video
     */
    public boolean hasVideo() {
        return videoLink != null && !videoLink.trim().isEmpty();
    }

    /**
     * Kiểm tra lesson có tài liệu không
     * @return true nếu có tài liệu
     */
    public boolean hasDocument() {
        return documentUrl != null && !documentUrl.trim().isEmpty();
    }

    /**
     * Lấy formatted duration
     * @return Duration được format
     */
    public String getFormattedDuration() {
        if (estimatedDuration == null || estimatedDuration == 0) {
            return "Chưa xác định";
        }

        if (estimatedDuration < 60) {
            return estimatedDuration + " phút";
        } else {
            int hours = estimatedDuration / 60;
            int minutes = estimatedDuration % 60;
            if (minutes == 0) {
                return hours + " giờ";
            } else {
                return hours + " giờ " + minutes + " phút";
            }
        }
    }

    /**
     * Lấy text hiển thị cho preview status
     * @return Text hiển thị
     */
    public String getPreviewText() {
        return preview ? "Xem trước" : "Yêu cầu đăng ký";
    }

    /**
     * Lấy CSS class cho preview status
     * @return CSS class
     */
    public String getPreviewCssClass() {
        return preview ? "badge-success" : "badge-warning";
    }

    /**
     * Lấy icon class cho lesson type
     * @return Icon class
     */
    public String getIconClass() {
        if (hasVideo()) {
            return "fas fa-play-circle";
        } else if (hasDocument()) {
            return "fas fa-file-alt";
        } else {
            return "fas fa-book-open";
        }
    }

    /**
     * Lấy type text cho lesson
     * @return Type text
     */
    public String getTypeText() {
        if (hasVideo()) {
            return "Video";
        } else if (hasDocument()) {
            return "Tài liệu";
        } else {
            return "Bài đọc";
        }
    }

    // Getters và Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }

    public Integer getOrderIndex() {
        return orderIndex;
    }

    public void setOrderIndex(Integer orderIndex) {
        this.orderIndex = orderIndex;
    }

    public String getVideoLink() {
        return videoLink;
    }

    public void setVideoLink(String videoLink) {
        this.videoLink = videoLink;
    }

    public String getDocumentUrl() {
        return documentUrl;
    }

    public void setDocumentUrl(String documentUrl) {
        this.documentUrl = documentUrl;
    }

    public Integer getEstimatedDuration() {
        return estimatedDuration;
    }

    public void setEstimatedDuration(Integer estimatedDuration) {
        this.estimatedDuration = estimatedDuration;
    }

    public boolean isPreview() {
        return preview;
    }

    public void setPreview(boolean preview) {
        this.preview = preview;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
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
        return "Lesson{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", courseId=" + (course != null ? course.getId() : "null") +
                ", orderIndex=" + orderIndex +
                ", isActive=" + active +
                ", isPreview=" + preview +
                ", hasVideo=" + hasVideo() +
                ", hasDocument=" + hasDocument() +
                '}';
    }

    /**
     * Override equals và hashCode cho JPA
     */
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Lesson)) return false;
        Lesson lesson = (Lesson) o;
        return id != null && id.equals(lesson.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}