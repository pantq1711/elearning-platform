package com.coursemanagement.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.time.LocalDateTime;

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
    @Size(min = 5, max = 200, message = "Tiêu đề bài giảng phải từ 5-200 ký tự")
    private String title;

    /**
     * Nội dung bài giảng dạng text
     * Có thể chứa HTML để format nội dung
     */
    @Column(columnDefinition = "TEXT")
    private String content;

    /**
     * Link video YouTube cho bài giảng
     * Có thể null nếu bài giảng chỉ có text
     */
    @Column(name = "video_link")
    private String videoLink;

    /**
     * Thứ tự sắp xếp bài giảng trong khóa học
     * Bài giảng nào có order_index nhỏ hơn sẽ hiển thị trước
     */
    @Column(name = "order_index")
    private Integer orderIndex = 0;

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
     * Trạng thái bài giảng có được kích hoạt không
     */
    @Column(name = "is_active")
    private boolean isActive = true;

    /**
     * Quan hệ Many-to-One với Course
     * Một bài giảng thuộc về một khóa học
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id", nullable = false)
    private Course course;

    /**
     * Constructor mặc định
     */
    public Lesson() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Constructor với thông tin cơ bản
     */
    public Lesson(String title, String content, Course course) {
        this();
        this.title = title;
        this.content = content;
        this.course = course;
    }

    /**
     * Constructor đầy đủ thông tin
     */
    public Lesson(String title, String content, String videoLink, Course course) {
        this(title, content, course);
        this.videoLink = videoLink;
    }

    /**
     * Callback được gọi trước khi update entity
     */
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Kiểm tra bài giảng có video không
     * @return true nếu có video, false nếu không có
     */
    public boolean hasVideo() {
        return videoLink != null && !videoLink.trim().isEmpty();
    }

    /**
     * Lấy YouTube video ID từ link
     * Hỗ trợ các format: youtube.com/watch?v=ID, youtu.be/ID
     * @return Video ID hoặc null nếu không hợp lệ
     */
    public String getYouTubeVideoId() {
        if (!hasVideo()) {
            return null;
        }

        String link = videoLink.trim();

        // Format: https://www.youtube.com/watch?v=VIDEO_ID
        if (link.contains("youtube.com/watch?v=")) {
            String[] parts = link.split("v=");
            if (parts.length > 1) {
                String videoId = parts[1];
                // Xóa các tham số khác sau dấu &
                int ampersandPos = videoId.indexOf('&');
                if (ampersandPos != -1) {
                    videoId = videoId.substring(0, ampersandPos);
                }
                return videoId;
            }
        }

        // Format: https://youtu.be/VIDEO_ID
        if (link.contains("youtu.be/")) {
            String[] parts = link.split("youtu.be/");
            if (parts.length > 1) {
                String videoId = parts[1];
                // Xóa các tham số khác sau dấu ?
                int questionPos = videoId.indexOf('?');
                if (questionPos != -1) {
                    videoId = videoId.substring(0, questionPos);
                }
                return videoId;
            }
        }

        return null;
    }

    /**
     * Lấy embed URL cho YouTube video
     * @return Embed URL hoặc null nếu không có video
     */
    public String getYouTubeEmbedUrl() {
        String videoId = getYouTubeVideoId();
        if (videoId != null) {
            return "https://www.youtube.com/embed/" + videoId;
        }
        return null;
    }

    /**
     * Lấy preview nội dung (100 ký tự đầu)
     * @return Nội dung rút gọn
     */
    public String getContentPreview() {
        if (content == null || content.trim().isEmpty()) {
            return "Không có nội dung";
        }

        String plainText = content.replaceAll("<[^>]*>", ""); // Xóa HTML tags
        if (plainText.length() <= 100) {
            return plainText;
        }

        return plainText.substring(0, 100) + "...";
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
                ", hasVideo=" + hasVideo() +
                ", orderIndex=" + orderIndex +
                ", course=" + (course != null ? course.getName() : "null") +
                ", isActive=" + isActive +
                '}';
    }
}