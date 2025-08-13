package com.coursemanagement.dto;

import com.coursemanagement.entity.Quiz;
import com.coursemanagement.entity.Question;
import java.time.LocalDateTime;
import java.util.List;

/**
 * DTO (Data Transfer Object) cho Quiz entity
 * Sử dụng để transfer data giữa các layer và API responses
 * Tránh expose trực tiếp entity ra ngoài
 */
public class QuizDTO {

    private Long id;
    private String title;
    private String description;
    private Long courseId;
    private String courseName;
    private Integer duration; // Thời gian làm bài (phút)
    private Double maxScore;
    private Double passScore;
    private Double points;
    private boolean active;
    private boolean showCorrectAnswers;
    private boolean shuffleQuestions;
    private boolean shuffleAnswers;
    private boolean requireLogin;
    private LocalDateTime availableFrom;
    private LocalDateTime availableUntil;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Thông tin thống kê
    private int questionCount;
    private int submissionCount;
    private double averageScore;
    private boolean isAvailable;

    // Thông tin cho student
    private boolean isEnrolled;
    private boolean hasAttempted;
    private Double studentScore;
    private LocalDateTime lastAttemptTime;

    // Constructors
    public QuizDTO() {}

    /**
     * Constructor từ Quiz entity
     * @param quiz Quiz entity
     */
    public QuizDTO(Quiz quiz) {
        this.id = quiz.getId();
        this.title = quiz.getTitle();
        this.description = quiz.getDescription();
        this.courseId = quiz.getCourse() != null ? quiz.getCourse().getId() : null;
        this.courseName = quiz.getCourse() != null ? quiz.getCourse().getName() : null;
        this.duration = quiz.getDuration();
        this.maxScore = quiz.getMaxScore();
        this.passScore = quiz.getPassScore();
        this.points = quiz.getPoints();
        this.active = quiz.isActive();
        this.showCorrectAnswers = quiz.isShowCorrectAnswers();
        this.shuffleQuestions = quiz.isShuffleQuestions();
        this.shuffleAnswers = quiz.isShuffleAnswers();
        this.requireLogin = quiz.isRequireLogin();
        this.availableFrom = quiz.getAvailableFrom();
        this.availableUntil = quiz.getAvailableUntil();
        this.createdAt = quiz.getCreatedAt();
        this.updatedAt = quiz.getUpdatedAt();

        // Tính toán thông tin thống kê
        this.questionCount = quiz.getQuestionCount();
        this.submissionCount = quiz.getQuizResults() != null ? quiz.getQuizResults().size() : 0;
        this.isAvailable = quiz.isAvailable();

        // Tính average score
        if (quiz.getQuizResults() != null && !quiz.getQuizResults().isEmpty()) {
            this.averageScore = quiz.getQuizResults().stream()
                    .mapToDouble(result -> result.getScore() != null ? result.getScore() : 0.0)
                    .average()
                    .orElse(0.0);
        } else {
            this.averageScore = 0.0;
        }
    }

    /**
     * Static factory method để tạo QuizDTO từ entity
     * @param quiz Quiz entity
     * @return QuizDTO object
     */
    public static QuizDTO fromEntity(Quiz quiz) {
        if (quiz == null) {
            return null;
        }
        return new QuizDTO(quiz);
    }

    /**
     * Static factory method để tạo QuizDTO với thông tin student
     * @param quiz Quiz entity
     * @param studentId ID của student (để check enrollment và attempt)
     * @return QuizDTO object với thông tin student
     */
    public static QuizDTO fromEntityWithStudentInfo(Quiz quiz, Long studentId) {
        if (quiz == null) {
            return null;
        }

        QuizDTO dto = new QuizDTO(quiz);

        // Kiểm tra enrollment
        if (quiz.getCourse() != null && quiz.getCourse().getEnrollments() != null) {
            dto.isEnrolled = quiz.getCourse().getEnrollments().stream()
                    .anyMatch(enrollment -> enrollment.getStudent().getId().equals(studentId));
        }

        // Kiểm tra đã attempt chưa và lấy điểm số
        if (quiz.getQuizResults() != null) {
            quiz.getQuizResults().stream()
                    .filter(result -> result.getUser().getId().equals(studentId))
                    .findFirst()
                    .ifPresent(result -> {
                        dto.hasAttempted = true;
                        dto.studentScore = result.getScore();
                        dto.lastAttemptTime = result.getSubmittedAt();
                    });
        }

        return dto;
    }

    /**
     * Tạo summary QuizDTO (chỉ thông tin cơ bản)
     * @param quiz Quiz entity
     * @return QuizDTO với thông tin tóm tắt
     */
    public static QuizDTO createSummary(Quiz quiz) {
        if (quiz == null) {
            return null;
        }

        QuizDTO dto = new QuizDTO();
        dto.id = quiz.getId();
        dto.title = quiz.getTitle();
        dto.description = quiz.getDescription();
        dto.duration = quiz.getDuration();
        dto.maxScore = quiz.getMaxScore();
        dto.passScore = quiz.getPassScore();
        dto.active = quiz.isActive();
        dto.questionCount = quiz.getQuestionCount();
        dto.isAvailable = quiz.isAvailable();

        return dto;
    }

    // Helper methods
    /**
     * Kiểm tra quiz có pass được không với điểm số cho trước
     * @param score Điểm số cần kiểm tra
     * @return true nếu pass
     */
    public boolean isPassed(Double score) {
        return score != null && passScore != null && score >= passScore;
    }

    /**
     * Tính phần trăm điểm số
     * @param score Điểm số
     * @return Phần trăm (0-100)
     */
    public double getScorePercentage(Double score) {
        if (score == null || maxScore == null || maxScore == 0) {
            return 0.0;
        }
        return (score / maxScore) * 100.0;
    }

    /**
     * Lấy trạng thái quiz dạng string
     * @return Trạng thái quiz
     */
    public String getStatusString() {
        if (!active) {
            return "Không hoạt động";
        }
        if (!isAvailable) {
            return "Chưa mở";
        }
        return "Đang mở";
    }

    /**
     * Lấy độ khó dựa trên pass score
     * @return Độ khó của quiz
     */
    public String getDifficultyLevel() {
        if (passScore == null || maxScore == null || maxScore == 0) {
            return "Trung bình";
        }

        double passPercentage = (passScore / maxScore) * 100.0;

        if (passPercentage < 60) {
            return "Dễ";
        } else if (passPercentage < 80) {
            return "Trung bình";
        } else {
            return "Khó";
        }
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

    public Long getCourseId() {
        return courseId;
    }

    public void setCourseId(Long courseId) {
        this.courseId = courseId;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
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

    public int getQuestionCount() {
        return questionCount;
    }

    public void setQuestionCount(int questionCount) {
        this.questionCount = questionCount;
    }

    public int getSubmissionCount() {
        return submissionCount;
    }

    public void setSubmissionCount(int submissionCount) {
        this.submissionCount = submissionCount;
    }

    public double getAverageScore() {
        return averageScore;
    }

    public void setAverageScore(double averageScore) {
        this.averageScore = averageScore;
    }

    public boolean isAvailable() {
        return isAvailable;
    }

    public void setAvailable(boolean available) {
        isAvailable = available;
    }

    public boolean isEnrolled() {
        return isEnrolled;
    }

    public void setEnrolled(boolean enrolled) {
        isEnrolled = enrolled;
    }

    public boolean isHasAttempted() {
        return hasAttempted;
    }

    public void setHasAttempted(boolean hasAttempted) {
        this.hasAttempted = hasAttempted;
    }

    public Double getStudentScore() {
        return studentScore;
    }

    public void setStudentScore(Double studentScore) {
        this.studentScore = studentScore;
    }

    public LocalDateTime getLastAttemptTime() {
        return lastAttemptTime;
    }

    public void setLastAttemptTime(LocalDateTime lastAttemptTime) {
        this.lastAttemptTime = lastAttemptTime;
    }
}