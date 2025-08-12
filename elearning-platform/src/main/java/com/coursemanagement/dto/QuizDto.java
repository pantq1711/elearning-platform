package com.coursemanagement.dto;

import com.coursemanagement.entity.Quiz;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/**
 * DTO cho Quiz - dùng để transfer data và validation
 */
public class QuizDto {

    private Long id;

    @NotBlank(message = "Tiêu đề bài kiểm tra không được để trống")
    @Size(min = 5, max = 200, message = "Tiêu đề bài kiểm tra phải từ 5-200 ký tự")
    private String title;

    private String description;

    @NotNull(message = "Thời gian làm bài không được để trống")
    @Min(value = 1, message = "Thời gian làm bài phải ít nhất 1 phút")
    private Integer duration;

    @NotNull(message = "Điểm tối đa không được để trống")
    @Min(value = 1, message = "Điểm tối đa phải lớn hơn 0")
    private Double maxScore;

    @NotNull(message = "Điểm pass không được để trống")
    @Min(value = 0, message = "Điểm pass phải lớn hơn hoặc bằng 0")
    private Double passScore;

    private boolean isActive;
    private String courseName;
    private int questionCount;
    private int attemptCount;

    // Constructors
    public QuizDto() {}

    public QuizDto(Quiz quiz) {
        this.id = quiz.getId();
        this.title = quiz.getTitle();
        this.description = quiz.getDescription();
        this.duration = quiz.getDuration();
        this.maxScore = quiz.getMaxScore();
        this.passScore = quiz.getPassScore();
        this.isActive = quiz.isActive();
        this.courseName = quiz.getCourse().getName();
        this.questionCount = quiz.getQuestionCount();
        this.attemptCount = quiz.getAttemptCount();
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Integer getDuration() { return duration; }
    public void setDuration(Integer duration) { this.duration = duration; }

    public Double getMaxScore() { return maxScore; }
    public void setMaxScore(Double maxScore) { this.maxScore = maxScore; }

    public Double getPassScore() { return passScore; }
    public void setPassScore(Double passScore) { this.passScore = passScore; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }

    public int getQuestionCount() { return questionCount; }
    public void setQuestionCount(int questionCount) { this.questionCount = questionCount; }

    public int getAttemptCount() { return attemptCount; }
    public void setAttemptCount(int attemptCount) { this.attemptCount = attemptCount; }
}