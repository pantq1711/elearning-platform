package com.coursemanagement.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Entity đại diện cho bảng courses trong database
 * Lưu thông tin khóa học
 */
@Entity
@Table(name = "courses")
public class Course {

    /**
     * ID tự động tăng - Primary Key
     */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Tên khóa học - không được trống
     */
    @Column(nullable = false)
    @NotBlank(message = "Tên khóa học không được để trống")
    @Size(min = 5, max = 200, message = "Tên khóa học phải từ 5-200 ký tự")
    private String name;

    /**
     * Mô tả về khóa học - không được trống
     */
    @Column(columnDefinition = "TEXT", nullable = false)
    @NotBlank(message = "Mô tả khóa học không được để trống")
    @Size(min = 10, message = "Mô tả khóa học phải có ít nhất 10 ký tự")
    private String description;

    /**
     * Thời gian tạo khóa học
     */
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    /**
     * Thời gian cập nhật cuối cùng
     */
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    /**
     * Trạng thái khóa học có đang hoạt động không
     */
    @Column(name = "is_active")
    private boolean isActive = true;

    /**
     * Hình ảnh thumbnail cho khóa học
     */
    @Column(name = "thumbnail_url")
    private String thumbnailUrl;

    /**
     * Thời lượng ước tính (số giờ)
     */
    @Column(name = "estimated_duration")
    private Integer estimatedDuration;

    /**
     * Mức độ khó (BEGINNER, INTERMEDIATE, ADVANCED)
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "difficulty_level")
    private DifficultyLevel difficultyLevel = DifficultyLevel.BEGINNER;

    /**
     * Ngôn ngữ giảng dạy
     */
    @Column(name = "language")
    private String language = "Vietnamese";

    /**
     * Yêu cầu kiến thức trước
     */
    @Column(name = "prerequisites", columnDefinition = "TEXT")
    private String prerequisites;

    /**
     * Mục tiêu học tập
     */
    @Column(name = "learning_objectives", columnDefinition = "TEXT")
    private String learningObjectives;

    /**
     * Giá khóa học (mặc định miễn phí)
     */
    @Column(name = "price")
    private Double price = 0.0;

    /**
     * Trạng thái nổi bật
     */
    @Column(name = "is_featured")
    private boolean isFeatured = false;

    /**
     * Quan hệ Many-to-One với Category
     * Một khóa học thuộc về một danh mục
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;

    /**
     * Quan hệ Many-to-One với User (Instructor)
     * Một khóa học được tạo bởi một giảng viên
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "instructor_id", nullable = false)
    private User instructor;

    /**
     * Danh sách bài giảng trong khóa học
     * Quan hệ One-to-Many với Lesson
     */
    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @OrderBy("orderIndex ASC")
    private List<Lesson> lessons = new ArrayList<>();

    /**
     * Danh sách học viên đăng ký khóa học
     * Quan hệ One-to-Many với Enrollment
     */
    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Enrollment> enrollments = new ArrayList<>();

    /**
     * Danh sách bài kiểm tra trong khóa học
     * Quan hệ One-to-Many với Quiz
     */
    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Quiz> quizzes = new ArrayList<>();

    /**
     * Enum định nghĩa mức độ khó
     */
    public enum DifficultyLevel {
        BEGINNER("Cơ bản"),
        INTERMEDIATE("Trung bình"),
        ADVANCED("Nâng cao");

        private final String displayName;

        DifficultyLevel(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }

    /**
     * Constructor mặc định
     */
    public Course() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Constructor với thông tin cơ bản
     */
    public Course(String name, String description, Category category, User instructor) {
        this();
        this.name = name;
        this.description = description;
        this.category = category;
        this.instructor = instructor;
    }

    /**
     * Callback được gọi trước khi persist entity
     */
    @PrePersist
    public void prePersist() {
        LocalDateTime now = LocalDateTime.now();
        this.createdAt = now;
        this.updatedAt = now;
    }

    /**
     * Callback được gọi trước khi update entity
     */
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    // === Helper methods ===

    /**
     * Thêm bài giảng vào khóa học
     */
    public void addLesson(Lesson lesson) {
        if (lessons == null) {
            lessons = new ArrayList<>();
        }
        lessons.add(lesson);
        lesson.setCourse(this);
    }

    /**
     * Xóa bài giảng khỏi khóa học
     */
    public void removeLesson(Lesson lesson) {
        if (lessons != null) {
            lessons.remove(lesson);
        }
        lesson.setCourse(null);
    }

    /**
     * Thêm học viên đăng ký khóa học
     */
    public void addEnrollment(Enrollment enrollment) {
        if (enrollments == null) {
            enrollments = new ArrayList<>();
        }
        enrollments.add(enrollment);
        enrollment.setCourse(this);
    }

    /**
     * Xóa học viên khỏi khóa học
     */
    public void removeEnrollment(Enrollment enrollment) {
        if (enrollments != null) {
            enrollments.remove(enrollment);
        }
        enrollment.setCourse(null);
    }

    /**
     * Thêm bài kiểm tra vào khóa học
     */
    public void addQuiz(Quiz quiz) {
        if (quizzes == null) {
            quizzes = new ArrayList<>();
        }
        quizzes.add(quiz);
        quiz.setCourse(this);
    }

    /**
     * Xóa bài kiểm tra khỏi khóa học
     */
    public void removeQuiz(Quiz quiz) {
        if (quizzes != null) {
            quizzes.remove(quiz);
        }
        quiz.setCourse(null);
    }

    /**
     * Lấy số lượng học viên đã đăng ký
     */
    public int getEnrollmentCount() {
        return enrollments != null ? enrollments.size() : 0;
    }

    /**
     * Lấy số lượng bài giảng
     */
    public int getLessonCount() {
        return lessons != null ? lessons.size() : 0;
    }

    /**
     * Lấy số lượng bài kiểm tra
     */
    public int getQuizCount() {
        return quizzes != null ? quizzes.size() : 0;
    }

    /**
     * Lấy số lượng bài giảng đang hoạt động
     */
    public long getActiveLessonCount() {
        if (lessons == null) {
            return 0;
        }

        return lessons.stream()
                .filter(Lesson::isActive)
                .count();
    }

    /**
     * Lấy số lượng quiz đang hoạt động
     */
    public long getActiveQuizCount() {
        if (quizzes == null) {
            return 0;
        }

        return quizzes.stream()
                .filter(Quiz::isActive)
                .count();
    }

    /**
     * Kiểm tra khóa học có thể xóa không
     * Chỉ có thể xóa khi chưa có học viên nào đăng ký
     */
    public boolean canBeDeleted() {
        return enrollments == null || enrollments.isEmpty();
    }

    /**
     * Lấy bài giảng đầu tiên
     */
    public Lesson getFirstLesson() {
        if (lessons == null || lessons.isEmpty()) {
            return null;
        }

        return lessons.stream()
                .filter(Lesson::isActive)
                .min((l1, l2) -> Integer.compare(l1.getOrderIndex(), l2.getOrderIndex()))
                .orElse(null);
    }

    /**
     * Kiểm tra có khóa học miễn phí không
     */
    public boolean isFree() {
        return price == null || price <= 0;
    }

    /**
     * Lấy giá hiển thị
     */
    public String getDisplayPrice() {
        if (isFree()) {
            return "Miễn phí";
        }
        return String.format("%,.0f VNĐ", price);
    }

    /**
     * Tính tỷ lệ hoàn thành trung bình
     */
    public double getCompletionRate() {
        if (enrollments == null || enrollments.isEmpty()) {
            return 0.0;
        }

        long completedCount = enrollments.stream()
                .filter(Enrollment::isCompleted)
                .count();

        return (double) completedCount / enrollments.size() * 100;
    }

    /**
     * Lấy điểm trung bình của khóa học
     */
    public Double getAverageScore() {
        if (enrollments == null || enrollments.isEmpty()) {
            return null;
        }

        return enrollments.stream()
                .filter(e -> e.getHighestScore() != null)
                .mapToDouble(Enrollment::getHighestScore)
                .average()
                .orElse(0.0);
    }

    /**
     * Kiểm tra học viên đã đăng ký chưa
     */
    public boolean isEnrolledByStudent(User student) {
        if (enrollments == null || student == null) {
            return false;
        }

        return enrollments.stream()
                .anyMatch(e -> e.getStudent().getId().equals(student.getId()));
    }

    /**
     * Lấy enrollment của học viên cụ thể
     */
    public Enrollment getEnrollmentByStudent(User student) {
        if (enrollments == null || student == null) {
            return null;
        }

        return enrollments.stream()
                .filter(e -> e.getStudent().getId().equals(student.getId()))
                .findFirst()
                .orElse(null);
    }

    /**
     * Kiểm tra khóa học có nội dung đầy đủ không
     */
    public boolean hasCompleteContent() {
        return getActiveLessonCount() > 0 && getActiveQuizCount() > 0;
    }

    /**
     * Lấy thời lượng ước tính hiển thị
     */
    public String getDisplayDuration() {
        if (estimatedDuration == null || estimatedDuration <= 0) {
            return "Chưa xác định";
        }

        if (estimatedDuration < 60) {
            return estimatedDuration + " giờ";
        } else {
            int weeks = estimatedDuration / 168; // 168 hours = 1 week
            int remainingHours = estimatedDuration % 168;

            if (weeks > 0 && remainingHours > 0) {
                return weeks + " tuần " + remainingHours + " giờ";
            } else if (weeks > 0) {
                return weeks + " tuần";
            } else {
                return estimatedDuration + " giờ";
            }
        }
    }

    /**
     * Kiểm tra khóa học có được tạo trong X ngày qua không
     */
    public boolean isNewWithinDays(int days) {
        LocalDateTime cutoff = LocalDateTime.now().minusDays(days);
        return createdAt.isAfter(cutoff);
    }

    // === Getters và Setters ===

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

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
    }

    public Integer getEstimatedDuration() {
        return estimatedDuration;
    }

    public void setEstimatedDuration(Integer estimatedDuration) {
        this.estimatedDuration = estimatedDuration;
    }

    public DifficultyLevel getDifficultyLevel() {
        return difficultyLevel;
    }

    public void setDifficultyLevel(DifficultyLevel difficultyLevel) {
        this.difficultyLevel = difficultyLevel;
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

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public boolean isFeatured() {
        return isFeatured;
    }

    public void setFeatured(boolean featured) {
        isFeatured = featured;
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
     * Override toString để debug dễ dàng
     */
    @Override
    public String toString() {
        return "Course{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", instructor=" + (instructor != null ? instructor.getUsername() : "null") +
                ", category=" + (category != null ? category.getName() : "null") +
                ", isActive=" + isActive +
                ", enrollmentCount=" + getEnrollmentCount() +
                ", lessonCount=" + getLessonCount() +
                ", quizCount=" + getQuizCount() +
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
}