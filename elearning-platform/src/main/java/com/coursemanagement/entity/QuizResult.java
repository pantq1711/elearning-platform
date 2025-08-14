package com.coursemanagement.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Entity đại diện cho kết quả bài kiểm tra của học viên
 * Lưu trữ điểm số, trạng thái pass/fail và câu trả lời
 */
@Entity
@Table(name = "quiz_results")
public class QuizResult {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id", nullable = false)
    private User student;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "quiz_id", nullable = false)
    private Quiz quiz;

    @Column(nullable = false, precision = 5, scale = 2)
    private Double score = 0.0;

    @Column(name = "is_passed")
    private boolean passed = false;

    @Column(name = "is_completed")
    private boolean completed = false;

    @Column(name = "start_time")
    private LocalDateTime startTime;

    @Column(name = "completion_time")
    private LocalDateTime completionTime;

    @Column(name = "attempt_date")
    private LocalDateTime attemptDate;

    @Column(columnDefinition = "TEXT")
    private String answers; // JSON string chứa câu trả lời

    @Column(columnDefinition = "TEXT")
    private String feedback; // Feedback từ instructor

    // Constructors
    public QuizResult() {
        this.attemptDate = LocalDateTime.now();
    }

    public QuizResult(User student, Quiz quiz) {
        this.student = student;
        this.quiz = quiz;
        this.attemptDate = LocalDateTime.now();
        this.startTime = LocalDateTime.now();
    }

    // Helper methods
    @PrePersist
    protected void onCreate() {
        if (attemptDate == null) {
            attemptDate = LocalDateTime.now();
        }
        if (startTime == null) {
            startTime = LocalDateTime.now();
        }
    }

    /**
     * Lấy text hiển thị cho điểm số
     * @return Text điểm số với format
     */
    public String getScoreText() {
        if (score == null) {
            return "0.0";
        }
        return String.format("%.1f", score);
    }

    /**
     * Lấy text hiển thị cho kết quả (Pass/Fail)
     * @return Text kết quả
     */
    public String getResultText() {
        if (!completed) {
            return "Chưa hoàn thành";
        }
        return passed ? "Đạt" : "Không đạt";
    }

    /**
     * Lấy CSS class cho kết quả
     * @return CSS class
     */
    public String getResultCssClass() {
        if (!completed) {
            return "badge-secondary";
        }
        return passed ? "badge-success" : "badge-danger";
    }

    /**
     * Lấy percentage score
     * @return Percentage score
     */
    public double getPercentageScore() {
        if (quiz == null || quiz.getMaxScore() == null || quiz.getMaxScore() == 0) {
            return 0.0;
        }
        return (score / quiz.getMaxScore()) * 100;
    }

    /**
     * Lấy formatted percentage score
     * @return Formatted percentage
     */
    public String getFormattedPercentage() {
        return String.format("%.1f%%", getPercentageScore());
    }

    /**
     * Tính thời gian làm bài (phút)
     * @return Thời gian làm bài
     */
    public Long getDurationInMinutes() {
        if (startTime == null || completionTime == null) {
            return 0L;
        }
        return java.time.Duration.between(startTime, completionTime).toMinutes();
    }

    /**
     * Lấy formatted duration
     * @return Duration text
     */
    public String getFormattedDuration() {
        Long minutes = getDurationInMinutes();
        if (minutes == null || minutes == 0) {
            return "Chưa hoàn thành";
        }

        if (minutes < 60) {
            return minutes + " phút";
        } else {
            long hours = minutes / 60;
            long remainingMinutes = minutes % 60;
            if (remainingMinutes == 0) {
                return hours + " giờ";
            } else {
                return hours + " giờ " + remainingMinutes + " phút";
            }
        }
    }

    /**
     * Kiểm tra có vượt quá thời gian cho phép không
     * @return true nếu vượt quá thời gian
     */
    public boolean isOvertime() {
        if (quiz == null || quiz.getDuration() == null || getDurationInMinutes() == null) {
            return false;
        }
        return getDurationInMinutes() > quiz.getDuration();
    }

    /**
     * Lấy grade letter (A, B, C, D, F)
     * @return Grade letter
     */
    public String getGradeLetter() {
        double percentage = getPercentageScore();

        if (percentage >= 90) return "A";
        else if (percentage >= 80) return "B";
        else if (percentage >= 70) return "C";
        else if (percentage >= 60) return "D";
        else return "F";
    }

    /**
     * Lấy CSS class cho grade
     * @return CSS class
     */
    public String getGradeCssClass() {
        String grade = getGradeLetter();
        switch (grade) {
            case "A": return "text-success";
            case "B": return "text-info";
            case "C": return "text-warning";
            case "D": return "text-warning";
            case "F": return "text-danger";
            default: return "text-secondary";
        }
    }

    /**
     * Lấy formatted attempt date
     * @return Formatted date
     */
    public String getFormattedAttemptDate() {
        if (attemptDate == null) {
            return "";
        }
        // Simple formatting - có thể dùng CourseUtils.DateTimeUtils.formatDateTime
        return attemptDate.toString();
    }

    /**
     * Lấy number of correct answers (nếu có thông tin)
     * @return Số câu đúng ước tính
     */
    public int getEstimatedCorrectAnswers() {
        if (quiz == null || quiz.getMaxScore() == null || quiz.getMaxScore() == 0) {
            return 0;
        }

        // Giả sử mỗi câu có điểm bằng nhau
        // Có thể cần method để đếm chính xác số câu hỏi
        int totalQuestions = quiz.getQuestionCount();
        if (totalQuestions == 0) {
            return 0;
        }

        double scorePerQuestion = quiz.getMaxScore() / totalQuestions;
        return (int) Math.round(score / scorePerQuestion);
    }

    /**
     * Kiểm tra có feedback không
     * @return true nếu có feedback
     */
    public boolean hasFeedback() {
        return feedback != null && !feedback.trim().isEmpty();
    }

    // ===== GETTERS AND SETTERS =====

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getStudent() {
        return student;
    }

    public void setStudent(User student) {
        this.student = student;
    }

    public Quiz getQuiz() {
        return quiz;
    }

    public void setQuiz(Quiz quiz) {
        this.quiz = quiz;
    }

    public Double getScore() {
        return score;
    }

    public void setScore(Double score) {
        this.score = score;
    }

    public boolean isPassed() {
        return passed;
    }

    public void setPassed(boolean passed) {
        this.passed = passed;
    }

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }

    public LocalDateTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalDateTime startTime) {
        this.startTime = startTime;
    }

    public LocalDateTime getCompletionTime() {
        return completionTime;
    }

    public void setCompletionTime(LocalDateTime completionTime) {
        this.completionTime = completionTime;
    }

    public LocalDateTime getAttemptDate() {
        return attemptDate;
    }

    public void setAttemptDate(LocalDateTime attemptDate) {
        this.attemptDate = attemptDate;
    }

    public String getAnswers() {
        return answers;
    }

    public void setAnswers(String answers) {
        this.answers = answers;
    }

    public String getFeedback() {
        return feedback;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }

    /**
     * Override toString để debug dễ dàng
     */
    @Override
    public String toString() {
        return "QuizResult{" +
                "id=" + id +
                ", studentId=" + (student != null ? student.getId() : "null") +
                ", quizId=" + (quiz != null ? quiz.getId() : "null") +
                ", score=" + score +
                ", passed=" + passed +
                ", completed=" + completed +
                '}';
    }

    /**
     * Override equals và hashCode cho JPA
     */
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof QuizResult)) return false;
        QuizResult that = (QuizResult) o;
        return id != null && id.equals(that.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }

    public void setTotalQuestions(int totalQuestions) {

    }
}