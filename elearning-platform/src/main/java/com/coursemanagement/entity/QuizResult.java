package com.coursemanagement.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;

import java.time.LocalDateTime;
import java.time.Duration;

/**
 * Entity đại diện cho bảng quiz_results trong database
 * Lưu kết quả bài kiểm tra của học viên
 */
@Entity
@Table(name = "quiz_results")
public class QuizResult {

    /**
     * ID tự động tăng - Primary Key
     */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Điểm số đạt được
     */
    @Column(nullable = false)
    @Min(value = 0, message = "Điểm số không được nhỏ hơn 0")
    @Max(value = 1000, message = "Điểm số không được lớn hơn 1000")
    private Double score;

    /**
     * Số câu trả lời đúng
     */
    @Column(name = "correct_answers")
    private Integer correctAnswers;

    /**
     * Tổng số câu hỏi
     */
    @Column(name = "total_questions")
    private Integer totalQuestions;

    /**
     * Trạng thái có đạt hay không
     */
    @Column(name = "is_passed")
    private Boolean isPassed;

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
     * Thời gian làm bài (giây)
     */
    @Column(name = "time_taken")
    private Integer timeTaken;

    /**
     * Đáp án của học viên (JSON format)
     */
    @Column(name = "answers", columnDefinition = "TEXT")
    private String answers;

    /**
     * Ghi chú về kết quả
     */
    @Column(columnDefinition = "TEXT")
    private String notes;

    /**
     * IP address của học viên khi làm bài
     */
    @Column(name = "ip_address")
    private String ipAddress;

    /**
     * User agent (trình duyệt) của học viên
     */
    @Column(name = "user_agent")
    private String userAgent;

    /**
     * Số lần thử (attempt number)
     */
    @Column(name = "attempt_number")
    private Integer attemptNumber = 1;

    /**
     * Trạng thái review bài làm
     */
    @Column(name = "is_reviewed")
    private boolean isReviewed = false;

    /**
     * Feedback từ giảng viên
     */
    @Column(name = "instructor_feedback", columnDefinition = "TEXT")
    private String instructorFeedback;

    /**
     * Điểm thưởng (nếu có)
     */
    @Column(name = "bonus_points")
    private Double bonusPoints = 0.0;

    /**
     * Quan hệ Many-to-One với User (Student)
     * Một kết quả thuộc về một học viên
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id", nullable = false)
    private User student;

    /**
     * Quan hệ Many-to-One với Quiz
     * Một kết quả thuộc về một bài kiểm tra
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "quiz_id", nullable = false)
    private Quiz quiz;

    /**
     * Constructor mặc định
     */
    public QuizResult() {
        this.submittedAt = LocalDateTime.now();
        this.attemptNumber = 1;
        this.bonusPoints = 0.0;
        this.isReviewed = false;
    }

    /**
     * Constructor với thông tin cơ bản
     */
    public QuizResult(User student, Quiz quiz, Double score, Integer correctAnswers,
                      Integer totalQuestions, Boolean isPassed) {
        this();
        this.student = student;
        this.quiz = quiz;
        this.score = score;
        this.correctAnswers = correctAnswers;
        this.totalQuestions = totalQuestions;
        this.isPassed = isPassed;
    }

    /**
     * Constructor đầy đủ
     */
    public QuizResult(User student, Quiz quiz, Double score, Integer correctAnswers,
                      Integer totalQuestions, Boolean isPassed, LocalDateTime startedAt,
                      String answers, Integer attemptNumber) {
        this(student, quiz, score, correctAnswers, totalQuestions, isPassed);
        this.startedAt = startedAt;
        this.answers = answers;
        this.attemptNumber = attemptNumber;

        // Tính thời gian làm bài nếu có startedAt
        if (startedAt != null) {
            this.timeTaken = (int) Duration.between(startedAt, submittedAt).getSeconds();
        }
    }

    // === Helper methods ===

    /**
     * Tính phần trăm điểm số
     */
    public double getScorePercentage() {
        if (quiz == null || quiz.getMaxScore() == null || score == null) {
            return 0.0;
        }
        return (score / quiz.getMaxScore()) * 100.0;
    }

    /**
     * Lấy grade letter dựa trên phần trăm điểm
     */
    public String getGradeLetter() {
        double percentage = getScorePercentage();

        if (percentage >= 90) return "A";
        if (percentage >= 80) return "B";
        if (percentage >= 70) return "C";
        if (percentage >= 60) return "D";
        return "F";
    }

    /**
     * Lấy màu sắc grade
     */
    public String getGradeColor() {
        String grade = getGradeLetter();
        switch (grade) {
            case "A": return "#28a745"; // Green
            case "B": return "#17a2b8"; // Blue
            case "C": return "#ffc107"; // Yellow
            case "D": return "#fd7e14"; // Orange
            case "F": return "#dc3545"; // Red
            default: return "#6c757d"; // Gray
        }
    }

    /**
     * Kiểm tra có đạt yêu cầu không
     */
    public boolean isPassedQuiz() {
        return isPassed != null && isPassed;
    }

    /**
     * Tính tỷ lệ trả lời đúng
     */
    public double getAccuracyRate() {
        if (totalQuestions == null || totalQuestions == 0 || correctAnswers == null) {
            return 0.0;
        }
        return ((double) correctAnswers / totalQuestions) * 100.0;
    }

    /**
     * Lấy thời gian làm bài dưới dạng text
     */
    public String getDisplayTimeTaken() {
        if (timeTaken == null || timeTaken <= 0) {
            return "Không xác định";
        }

        int hours = timeTaken / 3600;
        int minutes = (timeTaken % 3600) / 60;
        int seconds = timeTaken % 60;

        if (hours > 0) {
            return String.format("%d giờ %d phút %d giây", hours, minutes, seconds);
        } else if (minutes > 0) {
            return String.format("%d phút %d giây", minutes, seconds);
        } else {
            return String.format("%d giây", seconds);
        }
    }

    /**
     * Kiểm tra có làm bài nhanh bất thường không
     */
    public boolean isSuspiciouslyFast() {
        if (timeTaken == null || totalQuestions == null || totalQuestions == 0) {
            return false;
        }

        // Nếu làm bài dưới 10 giây/câu thì có thể đáng nghi
        double secondsPerQuestion = (double) timeTaken / totalQuestions;
        return secondsPerQuestion < 10;
    }

    /**
     * Kiểm tra có làm bài chậm bất thường không
     */
    public boolean isSuspiciouslySlow() {
        if (quiz == null || quiz.getDuration() == null || timeTaken == null) {
            return false;
        }

        // Nếu làm bài vượt quá 150% thời gian quy định
        int allowedSeconds = quiz.getDuration() * 60;
        return timeTaken > allowedSeconds * 1.5;
    }

    /**
     * Lấy trạng thái chi tiết
     */
    public String getDetailedStatus() {
        if (isPassedQuiz()) {
            return "Đạt (" + String.format("%.1f", getScorePercentage()) + "%)";
        } else {
            return "Không đạt (" + String.format("%.1f", getScorePercentage()) + "%)";
        }
    }

    /**
     * Tính điểm cuối cùng (bao gồm bonus)
     */
    public Double getFinalScore() {
        if (score == null) {
            return null;
        }

        double finalScore = score;
        if (bonusPoints != null && bonusPoints > 0) {
            finalScore += bonusPoints;
        }

        // Không vượt quá điểm tối đa của quiz
        if (quiz != null && quiz.getMaxScore() != null) {
            finalScore = Math.min(finalScore, quiz.getMaxScore());
        }

        return finalScore;
    }

    /**
     * Kiểm tra có điểm thưởng không
     */
    public boolean hasBonus() {
        return bonusPoints != null && bonusPoints > 0;
    }

    /**
     * Lấy thông tin tóm tắt
     */
    public String getSummary() {
        return String.format("Điểm: %.1f/%.1f (%.1f%%) - %s - %d/%d câu đúng",
                getFinalScore(),
                quiz != null ? quiz.getMaxScore() : 0,
                getScorePercentage(),
                isPassedQuiz() ? "ĐẠT" : "KHÔNG ĐẠT",
                correctAnswers != null ? correctAnswers : 0,
                totalQuestions != null ? totalQuestions : 0);
    }

    /**
     * Kiểm tra có feedback từ giảng viên không
     */
    public boolean hasInstructorFeedback() {
        return instructorFeedback != null && !instructorFeedback.trim().isEmpty();
    }

    /**
     * Lấy số ngày từ khi nộp bài
     */
    public long getDaysSinceSubmission() {
        if (submittedAt == null) {
            return 0;
        }
        return Duration.between(submittedAt, LocalDateTime.now()).toDays();
    }

    /**
     * Kiểm tra kết quả có mới không (trong vòng X ngày)
     */
    public boolean isRecentResult(int days) {
        return getDaysSinceSubmission() <= days;
    }

    /**
     * Lấy thời gian bắt đầu hiển thị
     */
    public String getDisplayStartTime() {
        if (startedAt == null) {
            return "Không xác định";
        }
        return startedAt.toString(); // Có thể format theo ý muốn
    }

    /**
     * Lấy thời gian nộp bài hiển thị
     */
    public String getDisplaySubmissionTime() {
        if (submittedAt == null) {
            return "Không xác định";
        }
        return submittedAt.toString(); // Có thể format theo ý muốn
    }

    /**
     * Kiểm tra có đúng giờ làm bài không
     */
    public boolean isWithinTimeLimit() {
        if (quiz == null || quiz.getDuration() == null || timeTaken == null) {
            return true; // Không có giới hạn thời gian
        }

        int allowedSeconds = quiz.getDuration() * 60;
        return timeTaken <= allowedSeconds;
    }

    /**
     * Lấy icon trạng thái
     */
    public String getStatusIcon() {
        if (isPassedQuiz()) {
            return "fas fa-check-circle";
        } else {
            return "fas fa-times-circle";
        }
    }

    /**
     * Lấy màu trạng thái
     */
    public String getStatusColor() {
        if (isPassedQuiz()) {
            return "#28a745"; // Green
        } else {
            return "#dc3545"; // Red
        }
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

    public Boolean getIsPassed() {
        return isPassed;
    }

    public void setIsPassed(Boolean isPassed) {
        this.isPassed = isPassed;
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

    public Integer getTimeTaken() {
        return timeTaken;
    }

    public void setTimeTaken(Integer timeTaken) {
        this.timeTaken = timeTaken;
    }

    public String getAnswers() {
        return answers;
    }

    public void setAnswers(String answers) {
        this.answers = answers;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getUserAgent() {
        return userAgent;
    }

    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }

    public Integer getAttemptNumber() {
        return attemptNumber;
    }

    public void setAttemptNumber(Integer attemptNumber) {
        this.attemptNumber = attemptNumber;
    }

    public boolean isReviewed() {
        return isReviewed;
    }

    public void setReviewed(boolean reviewed) {
        isReviewed = reviewed;
    }

    public String getInstructorFeedback() {
        return instructorFeedback;
    }

    public void setInstructorFeedback(String instructorFeedback) {
        this.instructorFeedback = instructorFeedback;
    }

    public Double getBonusPoints() {
        return bonusPoints;
    }

    public void setBonusPoints(Double bonusPoints) {
        this.bonusPoints = bonusPoints;
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

    /**
     * Override toString để debug dễ dàng
     */
    @Override
    public String toString() {
        return "QuizResult{" +
                "id=" + id +
                ", score=" + score +
                ", correctAnswers=" + correctAnswers +
                ", totalQuestions=" + totalQuestions +
                ", isPassed=" + isPassed +
                ", attemptNumber=" + attemptNumber +
                ", student=" + (student != null ? student.getUsername() : "null") +
                ", quiz=" + (quiz != null ? quiz.getTitle() : "null") +
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
}