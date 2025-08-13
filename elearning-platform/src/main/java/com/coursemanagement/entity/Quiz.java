package com.coursemanagement.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Entity đại diện cho bài kiểm tra trong khóa học
 * Chứa câu hỏi, thời gian làm bài và điểm số
 */
@Entity
@Table(name = "quizzes")
public class Quiz {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id", nullable = false)
    private Course course;

    @Column(nullable = false)
    private Integer duration; // Thời gian làm bài tính bằng phút

    @Column(name = "max_score", nullable = false, precision = 5, scale = 2)
    private Double maxScore;

    @Column(name = "pass_score", nullable = false, precision = 5, scale = 2)
    private Double passScore;

    @Column(name = "is_active")
    private boolean active = true;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Relationships
    @OneToMany(mappedBy = "quiz", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Question> questions = new ArrayList<>();

    @OneToMany(mappedBy = "quiz", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<QuizResult> quizResults = new ArrayList<>();

    // Constructors
    public Quiz() {}

    public Quiz(String title, String description, Course course, Integer duration, Double maxScore, Double passScore) {
        this.title = title;
        this.description = description;
        this.course = course;
        this.duration = duration;
        this.maxScore = maxScore;
        this.passScore = passScore;
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
     * Kiểm tra student đã đăng ký course của quiz này chưa
     * @param student Student cần kiểm tra
     * @return true nếu đã đăng ký
     */
    public boolean isEnrolledByStudent(User student) {
        if (course == null || student == null) {
            return false;
        }

        return course.getEnrollments().stream()
                .anyMatch(enrollment -> enrollment.getStudent().getId().equals(student.getId()));
    }

    /**
     * Lấy số lượng questions
     * @return Số lượng questions
     */
    public int getQuestionCount() {
        return questions != null ? questions.size() : 0;
    }

    /**
     * Lấy số lượng attempts
     * @return Số lượng attempts
     */
    public int getAttemptCount() {
        return quizResults != null ? quizResults.size() : 0;
    }

    /**
     * Lấy formatted duration
     * @return Duration được format
     */
    public String getFormattedDuration() {
        if (duration == null || duration == 0) {
            return "Không giới hạn";
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
     * Lấy pass rate percentage
     * @return Pass rate
     */
    public double getPassRate() {
        if (quizResults == null || quizResults.isEmpty()) {
            return 0.0;
        }

        long passedCount = quizResults.stream()
                .mapToLong(result -> result.isPassed() ? 1 : 0)
                .sum();

        return (double) passedCount / quizResults.size() * 100;
    }

    /**
     * Lấy average score
     * @return Average score
     */
    public double getAverageScore() {
        if (quizResults == null || quizResults.isEmpty()) {
            return 0.0;
        }

        return quizResults.stream()
                .filter(QuizResult::isCompleted)
                .mapToDouble(QuizResult::getScore)
                .average()
                .orElse(0.0);
    }

    /**
     * Kiểm tra student đã làm quiz này chưa
     * @param student Student
     * @return true nếu đã làm
     */
    public boolean isAttemptedByStudent(User student) {
        if (quizResults == null || student == null) {
            return false;
        }

        return quizResults.stream()
                .anyMatch(result -> result.getStudent().getId().equals(student.getId()));
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }

    public Integer getDuration() {
        return duration;
    }

    public void setDuration(Integer duration) {
        this.duration = duration;
    }

    public Double getMaxScore() {
        return maxScore;
    }

    public void setMaxScore(Double maxScore) {
        this.maxScore = maxScore;
    }

    public Double getPassScore() {
        return passScore;
    }

    public void setPassScore(Double passScore) {
        this.passScore = passScore;
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

    public List<Question> getQuestions() {
        return questions;
    }

    public void setQuestions(List<Question> questions) {
        this.questions = questions;
    }

    public List<QuizResult> getQuizResults() {
        return quizResults;
    }

    public void setQuizResults(List<QuizResult> quizResults) {
        this.quizResults = quizResults;
    }

    /**
     * Override toString để debug dễ dàng
     */
    @Override
    public String toString() {
        return "Quiz{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", courseId=" + (course != null ? course.getId() : "null") +
                ", duration=" + duration +
                ", maxScore=" + maxScore +
                ", passScore=" + passScore +
                ", isActive=" + active +
                ", questionCount=" + getQuestionCount() +
                ", attemptCount=" + getAttemptCount() +
                '}';
    }

    /**
     * Override equals và hashCode cho JPA
     */
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Quiz)) return false;
        Quiz quiz = (Quiz) o;
        return id != null && id.equals(quiz.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}