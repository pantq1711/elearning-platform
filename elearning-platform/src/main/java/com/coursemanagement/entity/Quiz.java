package com.coursemanagement.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Entity đại diện cho bảng quizzes trong database
 * Lưu thông tin bài kiểm tra trắc nghiệm trong khóa học
 */
@Entity
@Table(name = "quizzes")
public class Quiz {

    /**
     * ID tự động tăng - Primary Key
     */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Tiêu đề bài kiểm tra - không được trống
     */
    @Column(nullable = false)
    @NotBlank(message = "Tiêu đề bài kiểm tra không được để trống")
    @Size(min = 5, max = 200, message = "Tiêu đề bài kiểm tra phải từ 5-200 ký tự")
    private String title;

    /**
     * Mô tả về bài kiểm tra
     */
    @Column(columnDefinition = "TEXT")
    private String description;

    /**
     * Thời gian làm bài tính bằng phút
     * Minimum là 1 phút
     */
    @Column(nullable = false)
    @Min(value = 1, message = "Thời gian làm bài phải ít nhất 1 phút")
    private Integer duration;

    /**
     * Điểm tối đa có thể đạt được
     * Mặc định là 100 điểm
     */
    @Column(name = "max_score")
    private Double maxScore = 100.0;

    /**
     * Điểm tối thiểu để pass bài kiểm tra
     * Mặc định là 60% tổng điểm
     */
    @Column(name = "pass_score")
    private Double passScore = 60.0;

    /**
     * Thời gian tạo bài kiểm tra
     */
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    /**
     * Thời gian cập nhật cuối cùng
     */
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    /**
     * Trạng thái bài kiểm tra có được kích hoạt không
     */
    @Column(name = "is_active")
    private boolean isActive = true;

    /**
     * Quan hệ Many-to-One với Course
     * Một bài kiểm tra thuộc về một khóa học
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id", nullable = false)
    private Course course;

    /**
     * Danh sách câu hỏi trong bài kiểm tra
     * Quan hệ One-to-Many với Question
     * cascade = CascadeType.ALL nghĩa là khi xóa Quiz thì xóa luôn các Question
     */
    @OneToMany(mappedBy = "quiz", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @OrderBy("id ASC") // Sắp xếp câu hỏi theo thứ tự tạo
    private List<Question> questions = new ArrayList<>();

    /**
     * Danh sách kết quả bài kiểm tra của học viên
     * Quan hệ One-to-Many với QuizResult
     */
    @OneToMany(mappedBy = "quiz", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<QuizResult> quizResults = new ArrayList<>();

    /**
     * Constructor mặc định
     */
    public Quiz() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Constructor với thông tin cơ bản
     */
    public Quiz(String title, String description, Integer duration, Course course) {
        this();
        this.title = title;
        this.description = description;
        this.duration = duration;
        this.course = course;
    }

    /**
     * Callback được gọi trước khi update entity
     */
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Thêm câu hỏi vào bài kiểm tra
     * @param question Câu hỏi cần thêm
     */
    public void addQuestion(Question question) {
        questions.add(question);
        question.setQuiz(this);
    }

    /**
     * Xóa câu hỏi khỏi bài kiểm tra
     * @param question Câu hỏi cần xóa
     */
    public void removeQuestion(Question question) {
        questions.remove(question);
        question.setQuiz(null);
    }

    /**
     * Thêm kết quả bài kiểm tra
     * @param quizResult Kết quả bài kiểm tra
     */
    public void addQuizResult(QuizResult quizResult) {
        quizResults.add(quizResult);
        quizResult.setQuiz(this);
    }

    /**
     * Lấy số lượng câu hỏi trong bài kiểm tra
     * @return Số lượng câu hỏi
     */
    public int getQuestionCount() {
        return questions.size();
    }

    /**
     * Lấy số lượng học viên đã làm bài
     * @return Số lượng học viên
     */
    public int getAttemptCount() {
        return quizResults.size();
    }

    /**
     * Tính điểm cho mỗi câu hỏi
     * @return Điểm của mỗi câu hỏi
     */
    public double getPointsPerQuestion() {
        if (questions.isEmpty()) {
            return 0.0;
        }
        return maxScore / questions.size();
    }

    /**
     * Kiểm tra điểm có đạt hay không
     * @param score Điểm cần kiểm tra
     * @return true nếu đạt, false nếu không đạt
     */
    public boolean isPassing(double score) {
        return score >= passScore;
    }

    /**
     * Lấy phần trăm điểm đạt
     * @return Phần trăm cần để pass
     */
    public double getPassPercentage() {
        return (passScore / maxScore) * 100;
    }

    /**
     * Lấy thời gian làm bài dạng text
     * @return Chuỗi mô tả thời gian (VD: "30 phút", "1 giờ 15 phút")
     */
    public String getDurationText() {
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
     * Kiểm tra bài kiểm tra có thể bắt đầu được không
     * Cần có ít nhất 1 câu hỏi và bài kiểm tra phải active
     * @return true nếu có thể bắt đầu, false nếu không thể
     */
    public boolean canStart() {
        return isActive && !questions.isEmpty();
    }

    /**
     * Lấy điểm trung bình của tất cả học viên đã làm bài
     * @return Điểm trung bình hoặc 0 nếu chưa có ai làm
     */
    public double getAverageScore() {
        if (quizResults.isEmpty()) {
            return 0.0;
        }

        double totalScore = quizResults.stream()
                .mapToDouble(QuizResult::getScore)
                .sum();

        return totalScore / quizResults.size();
    }

    /**
     * Lấy tỷ lệ học viên đạt bài kiểm tra
     * @return Tỷ lệ phần trăm học viên đạt
     */
    public double getPassRate() {
        if (quizResults.isEmpty()) {
            return 0.0;
        }

        long passCount = quizResults.stream()
                .mapToDouble(QuizResult::getScore)
                .filter(this::isPassing)
                .count();

        return (double) passCount / quizResults.size() * 100;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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
                ", duration=" + duration +
                ", questionCount=" + getQuestionCount() +
                ", attemptCount=" + getAttemptCount() +
                ", course=" + (course != null ? course.getName() : "null") +
                ", isActive=" + isActive +
                '}';
    }
}