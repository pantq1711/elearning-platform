package com.coursemanagement.dto;

import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.Category;
import com.coursemanagement.entity.User;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/**
 * DTO cho Course - dùng để transfer data và validation
 */
public class CourseDto {

    private Long id;

    @NotBlank(message = "Tên khóa học không được để trống")
    @Size(min = 5, max = 200, message = "Tên khóa học phải từ 5-200 ký tự")
    private String name;

    private String description;

    @NotNull(message = "Phải chọn danh mục")
    private Long categoryId;

    private String categoryName;
    private String instructorName;
    private boolean isActive;
    private int enrollmentCount;
    private int lessonCount;
    private int quizCount;

    // Constructors
    public CourseDto() {}

    public CourseDto(Course course) {
        this.id = course.getId();
        this.name = course.getName();
        this.description = course.getDescription();
        this.categoryId = course.getCategory().getId();
        this.categoryName = course.getCategory().getName();
        this.instructorName = course.getInstructor().getUsername();
        this.isActive = course.isActive();
        this.enrollmentCount = course.getEnrollmentCount();
        this.lessonCount = course.getLessonCount();
        this.quizCount = course.getQuizCount();
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Long getCategoryId() { return categoryId; }
    public void setCategoryId(Long categoryId) { this.categoryId = categoryId; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getInstructorName() { return instructorName; }
    public void setInstructorName(String instructorName) { this.instructorName = instructorName; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public int getEnrollmentCount() { return enrollmentCount; }
    public void setEnrollmentCount(int enrollmentCount) { this.enrollmentCount = enrollmentCount; }

    public int getLessonCount() { return lessonCount; }
    public void setLessonCount(int lessonCount) { this.lessonCount = lessonCount; }

    public int getQuizCount() { return quizCount; }
    public void setQuizCount(int quizCount) { this.quizCount = quizCount; }
}