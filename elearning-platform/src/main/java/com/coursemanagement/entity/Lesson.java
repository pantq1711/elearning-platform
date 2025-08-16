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
    // ===== LESSON ENTITY OPTIONAL FIELDS =====

/**
 * Thêm các fields sau vào Lesson.java nếu muốn hỗ trợ thêm tính năng:
 * (Các fields này là optional - chỉ thêm nếu cần)
 */

    /**
     * 1. Thêm videoUrl field riêng biệt với videoLink:
     */
    @Column(name = "video_url", length = 500)
    private String videoUrl; // URL video đã upload lên server

    /**
     * 2. Thêm duration field riêng biệt với estimatedDuration:
     */
    @Column(name = "duration_minutes")
    private Integer duration; // Thời lượng thực tế của video (phút)

    /**
     * 3. Thêm video metadata fields:
     */
    @Column(name = "video_size")
    private Long videoSize; // Kích thước file video (bytes)

    @Column(name = "video_format", length = 50)
    private String videoFormat; // Định dạng video (mp4, avi, etc.)

    /**
     * 4. Thêm content type field:
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "content_type")
    private ContentType contentType = ContentType.TEXT;

    /**
     * Enum cho Content Type:
     */
    public enum ContentType {
        TEXT("Văn bản"),
        VIDEO("Video"),
        DOCUMENT("Tài liệu"),
        INTERACTIVE("Tương tác"),
        QUIZ("Bài tập");

        private final String displayName;

        ContentType(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }

    /**
     * Getter/Setter methods cho các fields mới:
     */

    public String getVideoUrl() {
        return videoUrl;
    }

    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl;
    }

    public Integer getDuration() {
        return duration;
    }

    public void setDuration(Integer duration) {
        this.duration = duration;
    }

    public Long getVideoSize() {
        return videoSize;
    }

    public void setVideoSize(Long videoSize) {
        this.videoSize = videoSize;
    }

    public String getVideoFormat() {
        return videoFormat;
    }

    public void setVideoFormat(String videoFormat) {
        this.videoFormat = videoFormat;
    }

    public ContentType getContentType() {
        return contentType;
    }

    public void setContentType(ContentType contentType) {
        this.contentType = contentType;
    }

/**
 * Helper methods:
 */


    /**
     * Lấy URL video ưu tiên (videoUrl trước, fallback về videoLink)
     */
    public String getPreferredVideoUrl() {
        if (videoUrl != null && !videoUrl.trim().isEmpty()) {
            return videoUrl;
        }
        return videoLink;
    }

    /**
     * Lấy duration ưu tiên (duration trước, fallback về estimatedDuration)
     */
    public Integer getPreferredDuration() {
        if (duration != null && duration > 0) {
            return duration;
        }
        return estimatedDuration;
    }

    /**
     * Get formatted video size
     */
    public String getFormattedVideoSize() {
        if (videoSize == null || videoSize == 0) {
            return "Không xác định";
        }

        if (videoSize < 1024 * 1024) {
            return String.format("%.1f KB", videoSize / 1024.0);
        } else if (videoSize < 1024 * 1024 * 1024) {
            return String.format("%.1f MB", videoSize / (1024.0 * 1024.0));
        } else {
            return String.format("%.1f GB", videoSize / (1024.0 * 1024.0 * 1024.0));
        }
    }



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
    // ===== JSP COMPATIBILITY - TYPE PROPERTY =====

    public static enum LessonType {
        VIDEO, DOCUMENT, TEXT;

        public String getName() {
            return this.toString();
        }
    }

    /**
     * Get lesson type dựa trên content có sẵn
     */
    public LessonType getType() {
        if (hasVideo()) {
            return LessonType.VIDEO;
        } else if (hasDocument()) {
            return LessonType.DOCUMENT;
        } else {
            return LessonType.TEXT;
        }
    }

    public String getTypeString() {
        return getType().name();
    }

    /**
     * Helper methods
     */

    public String getTypeDisplayName() {
        switch (getType()) {
            case VIDEO: return "Video";
            case DOCUMENT: return "Tài liệu";
            default: return "Văn bản";
        }
    }
}