package com.coursemanagement.dto;

import jakarta.validation.constraints.*;
import org.hibernate.validator.constraints.URL;

import java.time.LocalDateTime;
import java.util.List;

import com.coursemanagement.utils.CourseUtils;
import com.coursemanagement.entity.Lesson;
import com.coursemanagement.entity.Quiz;

/**
 * DTO cho Lesson
 */
public class LessonDto {

    @NotBlank(message = "Tiêu đề bài học không được để trống")
    @Size(min = 5, max = 200, message = "Tiêu đề phải từ 5-200 ký tự")
    private String title;

    @NotBlank(message = "Nội dung bài học không được để trống")
    @Size(min = 20, message = "Nội dung phải ít nhất 20 ký tự")
    private String content;

    @URL(message = "Link video không đúng định dạng URL")
    private String videoLink;

    @NotNull(message = "Khóa học không được để trống")
    private Long courseId;

    @Min(value = 1, message = "Thứ tự phải ít nhất là 1")
    private Integer orderIndex;

    @Min(value = 1, message = "Thời lượng ước tính phải ít nhất 1 phút")
    private Integer estimatedDuration;

    private boolean preview = false;
    private boolean active = true;

    @URL(message = "URL tài liệu không đúng định dạng")
    private String documentUrl;

    private String slug;

    // Runtime data
    private String courseName;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public LessonDto() {}

    public static LessonDto fromEntity(Lesson lesson) {
        LessonDto dto = new LessonDto();
        dto.setTitle(lesson.getTitle());
        dto.setContent(lesson.getContent());
        dto.setVideoLink(lesson.getVideoLink());
        dto.setCourseId(lesson.getCourse().getId());
        dto.setOrderIndex(lesson.getOrderIndex());
        dto.setEstimatedDuration(lesson.getEstimatedDuration());
        dto.setPreview(lesson.isPreview());
        dto.setActive(lesson.isActive());
        dto.setDocumentUrl(lesson.getDocumentUrl());
        dto.setSlug(lesson.getSlug());
        dto.setCreatedAt(lesson.getCreatedAt());
        dto.setUpdatedAt(lesson.getUpdatedAt());
        dto.setCourseName(lesson.getCourse().getName());
        return dto;
    }

    // Getters và Setters
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getVideoLink() { return videoLink; }
    public void setVideoLink(String videoLink) { this.videoLink = videoLink; }

    public Long getCourseId() { return courseId; }
    public void setCourseId(Long courseId) { this.courseId = courseId; }

    public Integer getOrderIndex() { return orderIndex; }
    public void setOrderIndex(Integer orderIndex) { this.orderIndex = orderIndex; }

    public Integer getEstimatedDuration() { return estimatedDuration; }
    public void setEstimatedDuration(Integer estimatedDuration) { this.estimatedDuration = estimatedDuration; }

    public boolean isPreview() { return preview; }
    public void setPreview(boolean preview) { this.preview = preview; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public String getDocumentUrl() { return documentUrl; }
    public void setDocumentUrl(String documentUrl) { this.documentUrl = documentUrl; }

    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }

    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    
    /**
     * Kiểm tra có video không
     * @return true nếu có video
     */
    public boolean hasVideo() {
        return videoLink != null && !videoLink.trim().isEmpty();
    }

    /**
     * Kiểm tra có tài liệu không
     * @return true nếu có tài liệu
     */
    public boolean hasDocument() {
        return documentUrl != null && !documentUrl.trim().isEmpty();
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
     * Validation method
     * @return true nếu hợp lệ
     */
    public boolean isValid() {
        return title != null && !title.trim().isEmpty() &&
                content != null && !content.trim().isEmpty() &&
                courseId != null &&
                orderIndex != null && orderIndex > 0;
    }
}