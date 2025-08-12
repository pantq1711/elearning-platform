import com.coursemanagement.utils.CourseUtils;

import java.time.LocalDateTime;

/**
 * DTO cho Course creation và update
 */
class CourseDto {

    @NotBlank(message = "Tên khóa học không được để trống")
    @Size(min = 5, max = 200, message = "Tên khóa học phải từ 5-200 ký tự")
    private String name;

    @NotBlank(message = "Mô tả không được để trống")
    @Size(min = 20, max = 2000, message = "Mô tả phải từ 20-2000 ký tự")
    private String description;

    @NotNull(message = "Danh mục không được để trống")
    private Long categoryId;

    @NotNull(message = "Giảng viên không được để trống")
    private Long instructorId;

    @Min(value = 1, message = "Thời lượng phải ít nhất 1 phút")
    @Max(value = 10000, message = "Thời lượng không được vượt quá 10000 phút")
    private Integer duration;

    private String difficultyLevel = "BEGINNER"; // BEGINNER, INTERMEDIATE, ADVANCED

    @DecimalMin(value = "0.0", message = "Giá không được âm")
    @DecimalMax(value = "10000000.0", message = "Giá không được vượt quá 10 triệu")
    private Double price = 0.0;

    private boolean featured = false;
    private boolean active = true;

    @Size(max = 1000, message = "Yêu cầu tiên quyết không được vượt quá 1000 ký tự")
    private String prerequisites;

    @Size(max = 1000, message = "Mục tiêu học tập không được vượt quá 1000 ký tự")
    private String learningObjectives;

    private String language = "Vietnamese";
    private String imageUrl;
    private String slug;

    // Thông tin runtime (không save vào DB)
    private int enrollmentCount;
    private int lessonCount;
    private int quizCount;
    private double avgRating;
    private String categoryName;
    private String instructorName;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructors
    public CourseDto() {}

    public CourseDto(String name, String description, Long categoryId, Long instructorId) {
        this.name = name;
        this.description = description;
        this.categoryId = categoryId;
        this.instructorId = instructorId;
    }

    // Factory method từ Entity
    public static CourseDto fromEntity(Course course) {
        CourseDto dto = new CourseDto();
        dto.setName(course.getName());
        dto.setDescription(course.getDescription());
        dto.setCategoryId(course.getCategory().getId());
        dto.setInstructorId(course.getInstructor().getId());
        dto.setDuration(course.getDuration());
        dto.setDifficultyLevel(course.getDifficultyLevel().name());
        dto.setPrice(course.getPrice());
        dto.setFeatured(course.isFeatured());
        dto.setActive(course.isActive());
        dto.setPrerequisites(course.getPrerequisites());
        dto.setLearningObjectives(course.getLearningObjectives());
        dto.setLanguage(course.getLanguage());
        dto.setImageUrl(course.getImageUrl());
        dto.setSlug(course.getSlug());
        dto.setCreatedAt(course.getCreatedAt());
        dto.setUpdatedAt(course.getUpdatedAt());

        // Runtime data
        dto.setEnrollmentCount(course.getEnrollmentCount());
        dto.setLessonCount(course.getLessonCount());
        dto.setQuizCount(course.getQuizCount());
        dto.setCategoryName(course.getCategory().getName());
        dto.setInstructorName(course.getInstructor().getFullName());

        return dto;
    }

    // Helper methods
    public String getFormattedPrice() {
        if (price == null || price == 0) {
            return "Miễn phí";
        }
        return String.format("%,.0f VNĐ", price);
    }

    public String getFormattedDuration() {
        return CourseUtils.CourseHelper.formatDuration(duration != null ? duration : 0);
    }

    public String getDifficultyDisplayName() {
        switch (difficultyLevel) {
            case "BEGINNER": return "Cơ bản";
            case "INTERMEDIATE": return "Trung bình";
            case "ADVANCED": return "Nâng cao";
            default: return "Không xác định";
        }
    }

    // Getters và Setters
    public String getName() { return name; }
    public void setName(String name) {
        this.name = name;
        this.slug = CourseUtils.StringUtils.createSlug(name);
    }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Long getCategoryId() { return categoryId; }
    public void setCategoryId(Long categoryId) { this.categoryId = categoryId; }

    public Long getInstructorId() { return instructorId; }
    public void setInstructorId(Long instructorId) { this.instructorId = instructorId; }

    public Integer getDuration() { return duration; }
    public void setDuration(Integer duration) { this.duration = duration; }

    public String getDifficultyLevel() { return difficultyLevel; }
    public void setDifficultyLevel(String difficultyLevel) { this.difficultyLevel = difficultyLevel; }

    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }

    public boolean isFeatured() { return featured; }
    public void setFeatured(boolean featured) { this.featured = featured; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public String getPrerequisites() { return prerequisites; }
    public void setPrerequisites(String prerequisites) { this.prerequisites = prerequisites; }

    public String getLearningObjectives() { return learningObjectives; }
    public void setLearningObjectives(String learningObjectives) { this.learningObjectives = learningObjectives; }

    public String getLanguage() { return language; }
    public void setLanguage(String language) { this.language = language; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }

    public int getEnrollmentCount() { return enrollmentCount; }
    public void setEnrollmentCount(int enrollmentCount) { this.enrollmentCount = enrollmentCount; }

    public int getLessonCount() { return lessonCount; }
    public void setLessonCount(int lessonCount) { this.lessonCount = lessonCount; }

    public int getQuizCount() { return quizCount; }
    public void setQuizCount(int quizCount) { this.quizCount = quizCount; }

    public double getAvgRating() { return avgRating; }
    public void setAvgRating(double avgRating) { this.avgRating = avgRating; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getInstructorName() { return instructorName; }
    public void setInstructorName(String instructorName) { this.instructorName = instructorName; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}