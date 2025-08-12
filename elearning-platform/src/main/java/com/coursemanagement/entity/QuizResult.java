package com.coursemanagement.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Entity đại diện cho bảng quiz_results trong database
 * Lưu thông tin kết quả bài kiểm tra của học viên
 * Mỗi học viên chỉ có thể làm mỗi bài kiểm tra 1 lần
 */
@Entity
@Table(name = "quiz_results",
        uniqueConstraints = @UniqueConstraint(columnNames = {"quiz_id", "user_id"}))
public class QuizResult {

    /**
     * ID tự động tăng - Primary Key
     */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Điểm đạt được (từ 0 đến maxScore của Quiz)
     */
    @Column(nullable = false)
    private Double score;

    /**
     * Số câu trả lời đúng
     */
    @Column(name = "correct_answers")
    private Integer correctAnswers = 0;

    /**
     * Tổng số câu hỏi trong bài kiểm tra
     */
    @Column(name = "total_questions")
    private Integer totalQuestions = 0;

    /**
     * Thời gian bắt đầu làm bài
     */
    @Column(name = "started_at")
    private LocalDateTime startedAt;

    /**
     * Thời gian nộp bài
     */
    @Column(name = "submitted_at")
    private LocalDateTime submittedAt;

    /**
     * Thời gian thực tế làm bài (tính bằng giây)
     */
    @Column(name = "time_taken")
    private Long timeTaken;

    /**
     * Trạng thái đạt hay không đạt bài kiểm tra
     */
    @Column(name = "is_passed")
    private boolean isPassed = false;

    /**
     * Quan hệ Many-to-One với Quiz
     * Một kết quả thuộc về một bài kiểm tra
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "quiz_id", nullable = false)
    private Quiz quiz;

    /**
     * Quan hệ Many-to-One với User (Student)
     * Một kết quả thuộc về một học viên
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User student;

    /**
     * Constructor mặc định
     */
    public QuizResult() {
        this.startedAt = LocalDateTime.now();
    }

    /**
     * Constructor với thông tin cơ bản
     */
    public QuizResult(Quiz quiz, User student) {
        this();
        this.quiz = quiz;
        this.student = student;
        this.totalQuestions = quiz.getQuestionCount();
    }

    /**
     * Hoàn thành bài kiểm tra và tính điểm
     * @param correctAnswers Số câu trả lời đúng
     */
    public void complete(int correctAnswers) {
        this.submittedAt = LocalDateTime.now();
        this.correctAnswers = correctAnswers;

        // Tính thời gian làm bài
        if (startedAt != null && submittedAt != null) {
            this.timeTaken = java.time.Duration.between(startedAt, submittedAt).getSeconds();
        }

        // Tính điểm
        calculateScore();

        // Kiểm tra đạt hay không
        if (quiz != null) {
            this.isPassed = quiz.isPassing(this.score);
        }
    }

    /**
     * Tính điểm dựa trên số câu đúng và tổng số câu
     */
    private void calculateScore() {
        if (totalQuestions > 0 && quiz != null) {
            double percentage = (double) correctAnswers / totalQuestions;
            this.score = percentage * quiz.getMaxScore();
        } else {
            this.score = 0.0;
        }
    }

    /**
     * Lấy phần trăm điểm
     * @return Phần trăm điểm (0-100)
     */
    public double getPercentage() {
        if (quiz == null || quiz.getMaxScore() == 0) {
            return 0.0;
        }
        return (score / quiz.getMaxScore()) * 100;
    }

    /**
     * Lấy điểm dạng text với 1 chữ số thập phân
     * @return Chuỗi điểm, VD: "85.5"
     */
    public String getScoreText() {
        return String.format("%.1f", score);
    }

    /**
     * Lấy phần trăm dạng text với 1 chữ số thập phân
     * @return Chuỗi phần trăm, VD: "85.5%"
     */
    public String getPercentageText() {
        return String.format("%.1f%%", getPercentage());
    }

    /**
     * Lấy kết quả dạng text
     * @return "ĐẠT" hoặc "KHÔNG ĐẠT"
     */
    public String getResultText() {
        return isPassed ? "ĐẠT" : "KHÔNG ĐẠT";
    }

    /**
     * Lấy màu sắc cho kết quả (để hiển thị trên UI)
     * @return Tên class CSS cho màu
     */
    public String getResultColor() {
        return isPassed ? "text-success" : "text-danger";
    }

    /**
     * Lấy thời gian làm bài dạng text
     * @return Chuỗi thời gian, VD: "15 phút 30 giây"
     */
    public String getTimeTakenText() {
        if (timeTaken == null || timeTaken == 0) {
            return "Không xác định";
        }

        long minutes = timeTaken / 60;
        long seconds = timeTaken % 60;

        if (minutes == 0) {
            return seconds + " giây";
        } else if (seconds == 0) {
            return minutes + " phút";
        } else {
            return minutes + " phút " + seconds + " giây";
        }
    }

    /**
     * Lấy thời gian nộp bài dạng text
     * @return Chuỗi thời gian định dạng dd/MM/yyyy HH:mm
     */
    public String getSubmittedAtText() {
        if (submittedAt == null) {
            return "Chưa nộp bài";
        }

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        return submittedAt.format(formatter);
    }

    /**
     * Kiểm tra có hoàn thành bài kiểm tra chưa
     * @return true nếu đã hoàn thành, false nếu chưa
     */
    public boolean isCompleted() {
        return submittedAt != null;
    }

    /**
     * Lấy tỷ lệ câu đúng
     * @return Tỷ lệ câu đúng (0.0 - 1.0)
     */
    public double getCorrectRatio() {
        if (totalQuestions == 0) {
            return 0.0;
        }
        return (double) correctAnswers / totalQuestions;
    }

    /**
     * Lấy số câu sai
     * @return Số câu trả lời sai
     */
    public int getWrongAnswers() {
        return totalQuestions - correctAnswers;
    }

    /**
     * Lấy thông tin chi tiết kết quả
     * @return Chuỗi mô tả chi tiết, VD: "8/10 câu đúng (80%)"
     */
    public String getDetailText() {
        return String.format("%d/%d câu đúng (%.1f%%)",
                correctAnswers, totalQuestions, getPercentage());
    }

    /**
     * So sánh với điểm pass để lấy chênh lệch
     * @return Số điểm chênh lệch với điểm pass (dương nếu vượt, âm nếu thiếu)
     */
    public double getScoreDifferenceFromPass() {
        if (quiz == null) {
            return 0.0;
        }
        return score - quiz.getPassScore();
    }

    // === Getters và Setters ===

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Double getScore() {
        return score;
    }

    public void setScore(Double score) {
        this.score = score;
    }

    public Integer getCorrectAnswers() {
        return correctAnswers;
    }

    public void setCorrectAnswers(Integer correctAnswers) {
        this.correctAnswers = correctAnswers;
    }

    public Integer getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(Integer totalQuestions) {
        this.totalQuestions = totalQuestions;
    }

    public LocalDateTime getStartedAt() {
        return startedAt;
    }

    public void setStartedAt(LocalDateTime startedAt) {
        this.startedAt = startedAt;
    }

    public LocalDateTime getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(LocalDateTime submittedAt) {
        this.submittedAt = submittedAt;
    }

    public Long getTimeTaken() {
        return timeTaken;
    }

    public void setTimeTaken(Long timeTaken) {
        this.timeTaken = timeTaken;
    }

    public boolean isPassed() {
        return isPassed;
    }

    public void setPassed(boolean passed) {
        isPassed = passed;
    }

    public Quiz getQuiz() {
        return quiz;
    }

    public void setQuiz(Quiz quiz) {
        this.quiz = quiz;
    }

    public User getStudent() {
        return student;
    }

    public void setStudent(User student) {
        this.student = student;
    }

    /**
     * Override toString để debug dễ dàng
     */
    @Override
    public String toString() {
        return "QuizResult{" +
                "id=" + id +
                ", student=" + (student != null ? student.getUsername() : "null") +
                ", quiz=" + (quiz != null ? quiz.getTitle() : "null") +
                ", score=" + score +
                ", correctAnswers=" + correctAnswers + "/" + totalQuestions +
                ", isPassed=" + isPassed +
                ", timeTaken=" + getTimeTakenText() +
                '}';
    }
}