package com.coursemanagement.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Entity đại diện cho bài kiểm tra trong khóa học
 * Chứa câu hỏi, thời gian làm bài và điểm số
 * Cập nhật với đầy đủ các tính năng cần thiết
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

    @Column(name = "max_score", nullable = false)
    private Double maxScore;

    @Column(name = "pass_score", nullable = false)
    private Double passScore;

    @Column(name = "points")
    private Double points = 100.0; // Tổng điểm của quiz

    @Column(name = "is_active")
    private boolean active = true;

    @Column(name = "show_correct_answers")
    private boolean showCorrectAnswers = true; // Hiển thị đáp án sau khi nộp bài

    @Column(name = "shuffle_questions")
    private boolean shuffleQuestions = false; // Xáo trộn thứ tự câu hỏi

    @Column(name = "shuffle_answers")
    private boolean shuffleAnswers = false; // Xáo trộn thứ tự đáp án

    @Column(name = "require_login")
    private boolean requireLogin = true; // Yêu cầu đăng nhập để làm bài

    @Column(name = "available_from")
    private LocalDateTime availableFrom; // Thời gian bắt đầu có thể làm bài

    @Column(name = "available_until")
    private LocalDateTime availableUntil; // Thời gian kết thúc làm bài

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
     * Kiểm tra quiz có đang available không
     * @return true nếu có thể làm bài
     */
    public boolean isAvailable() {
        LocalDateTime now = LocalDateTime.now();
        return active &&
                (availableFrom == null || now.isAfter(availableFrom)) &&
                (availableUntil == null || now.isBefore(availableUntil));
    }

    /**
     * Tính tổng điểm của tất cả câu hỏi
     * @return Tổng điểm
     */
    public double calculateTotalPoints() {
        return questions.stream()
                .mapToDouble(q -> q.getPoints() != null ? q.getPoints() : 0.0)
                .sum();
    }

    // Getters and Setters
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

    public Double getPoints() {
        return points;
    }

    public void setPoints(Double points) {
        this.points = points;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public boolean isShowCorrectAnswers() {
        return showCorrectAnswers;
    }

    public void setShowCorrectAnswers(boolean showCorrectAnswers) {
        this.showCorrectAnswers = showCorrectAnswers;
    }

    public boolean isShuffleQuestions() {
        return shuffleQuestions;
    }

    public void setShuffleQuestions(boolean shuffleQuestions) {
        this.shuffleQuestions = shuffleQuestions;
    }

    public boolean isShuffleAnswers() {
        return shuffleAnswers;
    }

    public void setShuffleAnswers(boolean shuffleAnswers) {
        this.shuffleAnswers = shuffleAnswers;
    }

    public boolean isRequireLogin() {
        return requireLogin;
    }

    public void setRequireLogin(boolean requireLogin) {
        this.requireLogin = requireLogin;
    }

    public LocalDateTime getAvailableFrom() {
        return availableFrom;
    }

    public void setAvailableFrom(LocalDateTime availableFrom) {
        this.availableFrom = availableFrom;
    }

    public LocalDateTime getAvailableUntil() {
        return availableUntil;
    }

    public void setAvailableUntil(LocalDateTime availableUntil) {
        this.availableUntil = availableUntil;
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
}