package com.coursemanagement.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.time.LocalDateTime;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Entity đại diện cho bảng lessons trong database
 * Lưu thông tin bài giảng trong khóa học
 */
@Entity
@Table(name = "lessons")
public class Lesson {

    /**
     * ID tự động tăng - Primary Key
     */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Tiêu đề bài giảng - không được trống
     */
    @Column(nullable = false)
    @NotBlank(message = "Tiêu đề bài giảng không được để trống")
    @Size(min = 3, max = 200, message = "Tiêu đề bài giảng phải từ 3-200 ký tự")
    private String title;

    /**
     * Nội dung bài giảng - không được trống
     */
    @Column(columnDefinition = "TEXT", nullable = false)
    @NotBlank(message = "Nội dung bài giảng không được để trống")
    private String content;

    /**
     * Link video YouTube (tùy chọn)
     */
    @Column(name = "video_link")
    private String videoLink;

    /**
     * Thứ tự bài giảng trong khóa học
     */
    @Column(name = "order_index", nullable = false)
    @Min(value = 1, message = "Thứ tự bài giảng phải lớn hơn 0")
    private Integer orderIndex;

    /**
     * Thời gian tạo bài giảng
     */
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    /**
     * Thời gian cập nhật cuối cùng
     */
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    /**
     * Trạng thái bài giảng có đang hoạt động không
     */
    @Column(name = "is_active")
    private boolean isActive = true;

    /**
     * Thời lượng ước tính (phút)
     */
    @Column(name = "estimated_duration")
    private Integer estimatedDuration;

    /**
     * Loại bài giảng (VIDEO, TEXT, MIXED)
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "lesson_type")
    private LessonType lessonType = LessonType.TEXT;

    /**
     * Ghi chú cho bài giảng
     */
    @Column(columnDefinition = "TEXT")
    private String notes;

    /**
     * File đính kèm (tài liệu, slide...)
     */
    @Column(name = "attachment_url")
    private String attachmentUrl;

    /**
     * Tên file đính kèm
     */
    @Column(name = "attachment_name")
    private String attachmentName;

    /**
     * Trạng thái preview miễn phí
     */
    @Column(name = "is_preview")
    private boolean isPreview = false;

    /**
     * Quan hệ Many-to-One với Course
     * Một bài giảng thuộc về một khóa học
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id", nullable = false)
    private Course course;

    /**
     * Enum định nghĩa loại bài giảng
     */
    public enum LessonType {
        VIDEO("Video"),
        TEXT("Văn bản"),
        MIXED("Kết hợp");

        private final String displayName;

        LessonType(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }

    /**
     * Constructor mặc định
     */
    public Lesson() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
        this.isActive = true;
    }

    /**
     * Constructor với thông tin cơ bản
     */
    public Lesson(String title, String content, Course course, Integer orderIndex) {
        this();
        this.title = title;
        this.content = content;
        this.course = course;
        this.orderIndex = orderIndex;

        // Tự động xác định loại bài giảng
        this.lessonType = determineType();
    }

    /**
     * Callback được gọi trước khi persist entity
     */
    @PrePersist
    public void prePersist() {
        LocalDateTime now = LocalDateTime.now();
        this.createdAt = now;
        this.updatedAt = now;

        if (this.lessonType == null) {
            this.lessonType = determineType();
        }
    }

    /**
     * Callback được gọi trước khi update entity
     */
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
        this.lessonType = determineType();
    }

    // === Helper methods ===

    /**
     * Kiểm tra bài giảng có video không
     */
    public boolean hasVideo() {
        return videoLink != null && !videoLink.trim().isEmpty();
    }

    /**
     * Kiểm tra bài giảng có file đính kèm không
     */
    public boolean hasAttachment() {
        return attachmentUrl != null && !attachmentUrl.trim().isEmpty();
    }

    /**
     * Lấy YouTube video ID từ URL
     */
    public String getYouTubeVideoId() {
        if (videoLink == null || videoLink.trim().isEmpty()) {
            return null;
        }

        // Pattern cho các định dạng URL YouTube khác nhau
        String[] patterns = {
                "(?:youtube\\.com/watch\\?v=)([^&\\n]*)",
                "(?:youtu\\.be/)([^&\\n]*)",
                "(?:youtube\\.com/embed/)([^&\\n]*)"
        };

        for (String patternStr : patterns) {
            Pattern pattern = Pattern.compile(patternStr);
            Matcher matcher = pattern.matcher(videoLink);
            if (matcher.find()) {
                return matcher.group(1);
            }
        }

        return null;
    }

    /**
     * Lấy URL embed YouTube
     */
    public String getYouTubeEmbedUrl() {
        String videoId = getYouTubeVideoId();
        if (videoId != null) {
            return "https://www.youtube.com/embed/" + videoId;
        }
        return null;
    }

    /**
     * Lấy URL thumbnail YouTube
     */
    public String getYouTubeThumbnailUrl() {
        String videoId = getYouTubeVideoId();
        if (videoId != null) {
            return "https://img.youtube.com/vi/" + videoId + "/maxresdefault.jpg";
        }
        return null;
    }

    /**
     * Kiểm tra URL YouTube có hợp lệ không
     */
    public boolean isValidYouTubeUrl() {
        return getYouTubeVideoId() != null;
    }

    /**
     * Tự động xác định loại bài giảng
     */
    private LessonType determineType() {
        boolean hasVideoContent = hasVideo();
        boolean hasTextContent = content != null && !content.trim().isEmpty();

        if (hasVideoContent && hasTextContent) {
            return LessonType.MIXED;
        } else if (hasVideoContent) {
            return LessonType.VIDEO;
        } else {
            return LessonType.TEXT;
        }
    }

    /**
     * Lấy thời lượng hiển thị
     */
    public String getDisplayDuration() {
        if (estimatedDuration == null || estimatedDuration <= 0) {
            return "Chưa xác định";
        }

        if (estimatedDuration < 60) {
            return estimatedDuration + " phút";
        } else {
            int hours = estimatedDuration / 60;
            int minutes = estimatedDuration % 60;

            if (minutes > 0) {
                return hours + " giờ " + minutes + " phút";
            } else {
                return hours + " giờ";
            }
        }
    }

    /**
     * Lấy tóm tắt nội dung (100 ký tự đầu)
     */
    public String getContentSummary() {
        if (content == null || content.trim().isEmpty()) {
            return "Không có nội dung";
        }

        String cleanContent = content.replaceAll("<[^>]*>", "").trim(); // Remove HTML tags

        if (cleanContent.length() <= 100) {
            return cleanContent;
        }

        return cleanContent.substring(0, 100) + "...";
    }

    /**
     * Kiểm tra bài giảng có thể xem trước miễn phí không
     */
    public boolean canPreview() {
        return isPreview && isActive;
    }

    /**
     * Lấy icon cho loại bài giảng
     */
    public String getTypeIcon() {
        switch (lessonType) {
            case VIDEO:
                return "fas fa-play-circle";
            case TEXT:
                return "fas fa-file-text";
            case MIXED:
                return "fas fa-layer-group";
            default:
                return "fas fa-book";
        }
    }

    /**
     * Kiểm tra học viên có thể truy cập bài giảng không
     */
    public boolean canAccessBy(User student) {
        if (!isActive) {
            return false;
        }

        if (canPreview()) {
            return true;
        }

        if (course == null || student == null) {
            return false;
        }

        return course.isEnrolledByStudent(student);
    }

    /**
     * Lấy độ dài nội dung (ước tính thời gian đọc)
     */
    public int getEstimatedReadingTime() {
        if (content == null || content.trim().isEmpty()) {
            return 0;
        }

        String cleanContent = content.replaceAll("<[^>]*>", "").trim();
        int wordCount = cleanContent.split("\\s+").length;

        // Ước tính 200 từ/phút cho tiếng Việt
        return Math.max(1, wordCount / 200);
    }

    /**
     * Kiểm tra bài giảng có được tạo trong X ngày qua không
     */
    public boolean isNewWithinDays(int days) {
        LocalDateTime cutoff = LocalDateTime.now().minusDays(days);
        return createdAt.isAfter(cutoff);
    }

    /**
     * Lấy file extension từ attachment URL
     */
    public String getAttachmentExtension() {
        if (attachmentUrl == null || attachmentUrl.trim().isEmpty()) {
            return null;
        }

        int lastDotIndex = attachmentUrl.lastIndexOf('.');
        if (lastDotIndex > 0 && lastDotIndex < attachmentUrl.length() - 1) {
            return attachmentUrl.substring(lastDotIndex + 1).toLowerCase();
        }

        return null;
    }

    /**
     * Kiểm tra attachment có phải là file PDF không
     */
    public boolean isPdfAttachment() {
        String extension = getAttachmentExtension();
        return "pdf".equals(extension);
    }

    /**
     * Kiểm tra attachment có phải là file hình ảnh không
     */
    public boolean isImageAttachment() {
        String extension = getAttachmentExtension();
        return extension != null &&
                (extension.equals("jpg") || extension.equals("jpeg") ||
                        extension.equals("png") || extension.equals("gif") ||
                        extension.equals("webp"));
    }

    // === Getters và Setters ===

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

    public String getVideoLink() {
        return videoLink;
    }

    public void setVideoLink(String videoLink) {
        this.videoLink = videoLink;
    }

    public Integer getOrderIndex() {
        return orderIndex;
    }

    public void setOrderIndex(Integer orderIndex) {
        this.orderIndex = orderIndex;
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

    public Integer getEstimatedDuration() {
        return estimatedDuration;
    }

    public void setEstimatedDuration(Integer estimatedDuration) {
        this.estimatedDuration = estimatedDuration;
    }

    public LessonType getLessonType() {
        return lessonType;
    }

    public void setLessonType(LessonType lessonType) {
        this.lessonType = lessonType;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getAttachmentUrl() {
        return attachmentUrl;
    }

    public void setAttachmentUrl(String attachmentUrl) {
        this.attachmentUrl = attachmentUrl;
    }

    public String getAttachmentName() {
        return attachmentName;
    }

    public void setAttachmentName(String attachmentName) {
        this.attachmentName = attachmentName;
    }

    public boolean isPreview() {
        return isPreview;
    }

    public void setPreview(boolean preview) {
        isPreview = preview;
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
        return "Lesson{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", orderIndex=" + orderIndex +
                ", lessonType=" + lessonType +
                ", hasVideo=" + hasVideo() +
                ", hasAttachment=" + hasAttachment() +
                ", isActive=" + isActive +
                ", course=" + (course != null ? course.getName() : "null") +
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