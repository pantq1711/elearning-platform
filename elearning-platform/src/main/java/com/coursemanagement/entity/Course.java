package com.coursemanagement.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Entity đại diện cho một khóa học trong hệ thống
 * Chứa thông tin chi tiết về khóa học, instructor, category và các quan hệ
 * Mapping đầy đủ với database schema và JSP requirements
 */
@Entity
@Table(name = "courses")
public class Course {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;

    // Thêm field shortDescription để mapping với database và JSP
    @Column(name = "short_description", length = 500)
    private String shortDescription;

    @Column(unique = true, length = 255)
    private String slug;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "instructor_id", nullable = false)
    private User instructor;

    @Column(name = "duration_minutes")
    private Integer duration; // Thời lượng tính bằng phút

    @Enumerated(EnumType.STRING)
    @Column(name = "difficulty_level", length = 20)
    private DifficultyLevel difficultyLevel = DifficultyLevel.EASY;

    @Column()
    private Double price = 0.0;

    @Column(name = "is_featured", nullable = false)
    private boolean featured = false;

    @Column(name = "is_active", nullable = false)
    private boolean active = true;

    @Column(name = "image_url", length = 500)
    private String imageUrl;

    // Thêm field thumbnail để mapping với database
    @Column(name = "thumbnail", length = 500)
    private String thumbnail;

    // Thêm field videoPreviewUrl để mapping với database
    @Column(name = "video_preview_url", length = 500)
    private String videoPreviewUrl;

    @Column(name = "language", length = 50)
    private String language = "Vietnamese";

    @Column(columnDefinition = "TEXT")
    private String prerequisites;

    @Column(name = "learning_objectives", columnDefinition = "TEXT")
    private String learningObjectives;

    // Thêm field targetAudience để mapping với database
    @Column(name = "target_audience", columnDefinition = "TEXT")
    private String targetAudience;

    // Thêm field certificateAvailable để mapping với database
    @Column(name = "certificate_available")
    private Boolean certificateAvailable = false;

    // Thêm field enrollmentCount để mapping với database
    @Column(name = "enrollment_count")
    private Integer enrollmentCount = 0;

    // Thêm các field rating để mapping với database và JSP
    @Column(name = "rating_average")
    private Double ratingAverage = 0.0;

    @Column(name = "rating_count")
    private Integer ratingCount = 0;

    // Thêm field viewCount để mapping với database
    @Column(name = "view_count")
    private Integer viewCount = 0;

    // Thêm field publishedAt để mapping với database
    @Column(name = "published_at")
    private LocalDateTime publishedAt;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Relationships
    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Lesson> lessons = new ArrayList<>();

    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Enrollment> enrollments = new ArrayList<>();

    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Quiz> quizzes = new ArrayList<>();

    // Constructors
    public Course() {}

    public Course(String name, String description, Category category, User instructor) {
        this.name = name;
        this.description = description;
        this.category = category;
        this.instructor = instructor;
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
     * Method getRating() để tương thích với JSP files
     * Trả về ratingAverage để khắc phục lỗi PropertyNotFoundException
     */
    public Double getRating() {
        return ratingAverage != null ? ratingAverage : 0.0;
    }

    /**
     * Method getAverageRating() để tương thích với JSP files
     * Trả về ratingAverage
     */
    public Double getAverageRating() {
        return ratingAverage != null ? ratingAverage : 0.0;
    }

    /**
     * Method getReviewCount() để tương thích với JSP files
     * Trả về ratingCount để khắc phục lỗi PropertyNotFoundException
     */
    public Integer getReviewCount() {
        return ratingCount != null ? ratingCount : 0;
    }

    /**
     * Lấy số lượng enrollments từ database field (ưu tiên) hoặc từ relationship
     * @return Số lượng học viên đã đăng ký
     */
    public int getEnrollmentCount() {
        if (enrollmentCount != null) {
            return enrollmentCount;
        }
        return enrollments != null ? enrollments.size() : 0;
    }

    /**
     * Lấy số lượng lessons
     * @return Số lượng bài học
     */
    public int getLessonCount() {
        return lessons != null ? lessons.size() : 0;
    }

    /**
     * Lấy số lượng quizzes
     * @return Số lượng bài kiểm tra
     */
    public int getQuizCount() {
        return quizzes != null ? quizzes.size() : 0;
    }
    /**
     * Set số lượng lessons (để hiển thị trong DTO/Service)
     * @param count Số lượng lessons
     */
    public void setLessonCount(int count) {
        // This is a transient setter used for display purposes
        // The actual count is calculated from the lessons list
    }

    /**
     * Set số lượng quizzes (để hiển thị trong DTO/Service)
     * @param count Số lượng quizzes
     */
    public void setQuizCount(int count) {
        // This is a transient setter used for display purposes
        // The actual count is calculated from the quizzes list
    }
    /**
     * Kiểm tra course có active không
     * @return true nếu active
     */
    public boolean isActive() {
        return active;
    }

    /**
     * Kiểm tra course có featured không
     * @return true nếu featured
     */


    /**
     * Lấy text hiển thị cho difficulty level
     * @return Text hiển thị difficulty
     */
    public String getDifficultyLevelText() {
        return difficultyLevel != null ? difficultyLevel.getDisplayName() : "Không xác định";
    }

    /**
     * Lấy CSS class cho difficulty level
     * @return CSS class
     */
    public String getDifficultyLevelCssClass() {
        return difficultyLevel != null ?
                "difficulty-" + difficultyLevel.name().toLowerCase() : "difficulty-unknown";
    }

    /**
     * Lấy formatted price
     * @return Formatted price string
     */
    public String getFormattedPrice() {
        if (price == null || price == 0.0) {
            return "Miễn phí";
        }
        return String.format("%,.0f VNĐ", price);
    }

    /**
     * Lấy formatted duration
     * @return Formatted duration string
     */
    public String getFormattedDuration() {
        if (duration == null || duration == 0) {
            return "Chưa xác định";
        }

        if (duration < 60) {
            return duration + " phút";
        } else {
            int hours = duration / 60;
            int minutes = duration % 60;
            if (minutes == 0) {
                return hours + " giờ";
            } else {
                return hours + " giờ " + minutes + " phút";
            }
        }
    }

    /**
     * Lấy formatted average rating
     * @return Formatted rating string
     */
    public String getFormattedRating() {
        if (ratingAverage == null || ratingAverage == 0.0) {
            return "Chưa có đánh giá";
        }
        return String.format("%.1f", ratingAverage);
    }

    /**
     * Lấy path ảnh thumbnail với fallback
     */
    public String getThumbnailPath() {
        if (thumbnail != null && !thumbnail.trim().isEmpty()) {
            return thumbnail;
        }
        if (imageUrl != null && !imageUrl.trim().isEmpty()) {
            return imageUrl;
        }
        return "default-course.jpg";
    }

    // Getters và Setters - Đầy đủ cho tất cả các fields
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getShortDescription() {
        return shortDescription;
    }

    public void setShortDescription(String shortDescription) {
        this.shortDescription = shortDescription;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public User getInstructor() {
        return instructor;
    }

    public void setInstructor(User instructor) {
        this.instructor = instructor;
    }

    public Integer getDuration() {
        return duration;
    }

    public void setDuration(Integer duration) {
        this.duration = duration;
    }

    public DifficultyLevel getDifficultyLevel() {
        return difficultyLevel;
    }

    public void setDifficultyLevel(DifficultyLevel difficultyLevel) {
        this.difficultyLevel = difficultyLevel;
    }

    /**
     * Setter cho DifficultyLevel từ String (để compatibility với form data)
     * @param level String representation của difficulty level
     */
    public void setDifficultyLevelFromString(String level) {
        this.difficultyLevel = DifficultyLevel.fromString(level);
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public boolean isFeatured() {
        return featured;
    }

    public void setFeatured(boolean featured) {
        this.featured = featured;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getThumbnail() {
        return thumbnail;
    }

    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
    }

    public String getVideoPreviewUrl() {
        return videoPreviewUrl;
    }

    public void setVideoPreviewUrl(String videoPreviewUrl) {
        this.videoPreviewUrl = videoPreviewUrl;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getPrerequisites() {
        return prerequisites;
    }

    public void setPrerequisites(String prerequisites) {
        this.prerequisites = prerequisites;
    }

    public String getLearningObjectives() {
        return learningObjectives;
    }

    public void setLearningObjectives(String learningObjectives) {
        this.learningObjectives = learningObjectives;
    }

    public String getTargetAudience() {
        return targetAudience;
    }

    public void setTargetAudience(String targetAudience) {
        this.targetAudience = targetAudience;
    }

    public Boolean getCertificateAvailable() {
        return certificateAvailable;
    }

    public void setCertificateAvailable(Boolean certificateAvailable) {
        this.certificateAvailable = certificateAvailable;
    }

    public void setEnrollmentCount(Integer enrollmentCount) {
        this.enrollmentCount = enrollmentCount;
    }

    public Double getRatingAverage() {
        return ratingAverage;
    }

    public void setRatingAverage(Double ratingAverage) {
        this.ratingAverage = ratingAverage;
    }

    public Integer getRatingCount() {
        return ratingCount;
    }

    public void setRatingCount(Integer ratingCount) {
        this.ratingCount = ratingCount;
    }

    public Integer getViewCount() {
        return viewCount;
    }

    public void setViewCount(Integer viewCount) {
        this.viewCount = viewCount;
    }

    public LocalDateTime getPublishedAt() {
        return publishedAt;
    }

    public void setPublishedAt(LocalDateTime publishedAt) {
        this.publishedAt = publishedAt;
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

    public List<Lesson> getLessons() {
        return lessons;
    }

    public void setLessons(List<Lesson> lessons) {
        this.lessons = lessons;
    }

    public List<Enrollment> getEnrollments() {
        return enrollments;
    }

    public void setEnrollments(List<Enrollment> enrollments) {
        this.enrollments = enrollments;
    }

    public List<Quiz> getQuizzes() {
        return quizzes;
    }

    public void setQuizzes(List<Quiz> quizzes) {
        this.quizzes = quizzes;
    }


    /**
     * Kiểm tra course có miễn phí không
     * @return true nếu miễn phí
     */
    public boolean isFree() {
        return price == null || price == 0.0;
    }

    /**
     * Kiểm tra course có được publish chưa
     * @return true nếu đã publish
     */
    public boolean isPublished() {
        return publishedAt != null && active;
    }

    /**
     * Override toString để debug dễ dàng
     */
    @Override
    public String toString() {
        return "Course{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", instructor=" + (instructor != null ? instructor.getUsername() : "null") +
                ", category=" + (category != null ? category.getName() : "null") +
                ", isActive=" + active +
                ", enrollmentCount=" + getEnrollmentCount() +
                ", lessonCount=" + getLessonCount() +
                ", quizCount=" + getQuizCount() +
                ", averageRating=" + ratingAverage +
                '}';
    }

    /**
     * Override equals và hashCode cho JPA
     */
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Course)) return false;
        Course course = (Course) o;
        return id != null && id.equals(course.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }

    /**
     * Enum định nghĩa các mức độ khó cho khóa học và câu hỏi
     * Sử dụng chung cho Course và Question entities
     * Tránh conflict và đảm bảo tính nhất quán trong hệ thống
     */
    public enum DifficultyLevel {
        EASY("Dễ", 1, "Dành cho người mới bắt đầu"),
        MEDIUM("Trung bình", 2, "Cần kiến thức cơ bản"),
        HARD("Khó", 3, "Cần kinh nghiệm và kiến thức sâu");

        private final String displayName;
        private final int level;
        private final String description;

        /**
         * Constructor cho DifficultyLevel
         * @param displayName Tên hiển thị bằng tiếng Việt
         * @param level Mức độ khó (1-3)
         * @param description Mô tả chi tiết
         */
        DifficultyLevel(String displayName, int level, String description) {
            this.displayName = displayName;
            this.level = level;
            this.description = description;
        }

        /**
         * Lấy tên hiển thị của mức độ khó
         * @return Tên hiển thị bằng tiếng Việt
         */
        public String getDisplayName() {
            return displayName;
        }

        /**
         * Lấy level số của độ khó (1-3)
         * @return Level số
         */
        public int getLevel() {
            return level;
        }

        /**
         * Lấy mô tả chi tiết
         * @return Mô tả
         */
        public String getDescription() {
            return description;
        }

        /**
         * Lấy màu CSS class cho hiển thị UI
         * @return CSS class name
         */
        public String getCssClass() {
            return switch (this) {
                case EASY -> "badge-success";
                case MEDIUM -> "badge-warning";
                case HARD -> "badge-danger";
            };
        }

        /**
         * Lấy icon class cho hiển thị UI
         * @return Icon class name
         */
        public String getIconClass() {
            return switch (this) {
                case EASY -> "fas fa-star";
                case MEDIUM -> "fas fa-star-half-alt";
                case HARD -> "fas fa-fire";
            };
        }

        /**
         * Lấy text color cho hiển thị
         * @return Text color class
         */
        public String getTextColor() {
            return switch (this) {
                case EASY -> "text-success";
                case MEDIUM -> "text-warning";
                case HARD -> "text-danger";
            };
        }

        /**
         * Kiểm tra độ khó có khó hơn level khác không
         * @param other DifficultyLevel khác
         * @return true nếu khó hơn
         */
        public boolean isHarderThan(DifficultyLevel other) {
            return this.level > other.level;
        }

        /**
         * Kiểm tra độ khó có dễ hơn level khác không
         * @param other DifficultyLevel khác
         * @return true nếu dễ hơn
         */
        public boolean isEasierThan(DifficultyLevel other) {
            return this.level < other.level;
        }

        /**
         * Lấy DifficultyLevel từ level số
         * @param level Level số (1-3)
         * @return DifficultyLevel tương ứng
         */
        public static DifficultyLevel fromLevel(int level) {
            for (DifficultyLevel difficulty : values()) {
                if (difficulty.level == level) {
                    return difficulty;
                }
            }
            return EASY; // Default
        }

        /**
         * Lấy DifficultyLevel từ string
         * @param levelString String mức độ
         * @return DifficultyLevel tương ứng
         */
        public static DifficultyLevel fromString(String levelString) {
            if (levelString == null || levelString.trim().isEmpty()) {
                return EASY;
            }

            return switch (levelString.toUpperCase()) {
                case "BEGINNER", "EASY", "CƠ BẢN", "DỄ" -> EASY;
                case "INTERMEDIATE", "MEDIUM", "TRUNG BÌNH" -> MEDIUM;
                case "ADVANCED", "HARD", "NÂNG CAO", "KHÓ" -> HARD;
                default -> EASY;
            };
        }

        /**
         * Lấy DifficultyLevel từ điểm phần trăm
         * @param percentage Điểm phần trăm (0-100)
         * @return DifficultyLevel phù hợp
         */
        public static DifficultyLevel fromPercentage(double percentage) {
            if (percentage >= 80) {
                return EASY;
            } else if (percentage >= 60) {
                return MEDIUM;
            } else {
                return HARD;
            }
        }

        /**
         * Lấy tất cả DifficultyLevel dưới dạng array cho dropdown
         * @return Array các DifficultyLevel
         */
        public static DifficultyLevel[] getAllLevels() {
            return values();
        }

        @Override
        public String toString() {
            return displayName;
        }
    }
}