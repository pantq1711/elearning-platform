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
     * Hướng dẫn làm bài
     */
    @Column(name = "instructions", columnDefinition = "TEXT")
    private String instructions;

    /**
     * Số lần làm bài tối đa (mặc định là 1)
     */
    @Column(name = "max_attempts")
    private Integer maxAttempts = 1;

    /**
     * Hiển thị kết quả ngay sau khi nộp bài
     */
    @Column(name = "show_result_immediately")
    private boolean showResultImmediately = true;

    /**
     * Hiển thị đáp án đúng
     */
    @Column(name = "show_correct_answers")
    private boolean showCorrectAnswers = true;

    /**
     * Xáo trộn thứ tự câu hỏi
     */
    @Column(name = "shuffle_questions")
    private boolean shuffleQuestions = false;

    /**
     * Xáo trộn thứ tự đáp án
     */
    @Column(name = "shuffle_answers")
    private boolean shuffleAnswers = false;

    /**
     * Yêu cầu đăng nhập để làm bài
     */
    @Column(name = "require_login")
    private boolean requireLogin = true;

    /**
     * Thời gian mở bài kiểm tra
     */
    @Column(name = "available_from")
    private LocalDateTime availableFrom;

    /**
     * Thời gian đóng bài kiểm tra
     */
    @Column(name = "available_until")
    private LocalDateTime availableUntil;

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
    private List<Question> questions = new ArrayList<>();

    /**
     * Danh sách kết quả bài kiểm tra
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
        this.maxScore = 100.0;
        this.passScore = 60.0;
        this.isActive = true;
        this.maxAttempts = 1;
        this.showResultImmediately = true;
        this.showCorrectAnswers = true;
        this.requireLogin = true;
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
     * Thêm câu hỏi vào bài kiểm tra
     */
    public void addQuestion(Question question) {
        if (questions == null) {
            questions = new ArrayList<>();
        }
        questions.add(question);
        question.setQuiz(this);
    }

    /**
     * Xóa câu hỏi khỏi bài kiểm tra
     */
    public void removeQuestion(Question question) {
        if (questions != null) {
            questions.remove(question);
        }
        question.setQuiz(null);
    }

    /**
     * Thêm kết quả bài kiểm tra
     */
    public void addQuizResult(QuizResult quizResult) {
        if (quizResults == null) {
            quizResults = new ArrayList<>();
        }
        quizResults.add(quizResult);
        quizResult.setQuiz(this);
    }

    /**
     * Lấy số lượng câu hỏi
     */
    public int getQuestionCount() {
        return questions != null ? questions.size() : 0;
    }

    /**
     * Lấy số lượng kết quả bài kiểm tra
     */
    public int getResultCount() {
        return quizResults != null ? quizResults.size() : 0;
    }

    /**
     * Kiểm tra bài kiểm tra có thể xóa không
     * Chỉ có thể xóa khi chưa có ai làm bài
     */
    public boolean canBeDeleted() {
        return quizResults == null || quizResults.isEmpty();
    }

    /**
     * Kiểm tra pass score có hợp lệ không
     */
    public boolean isValidPassScore() {
        return passScore != null && passScore >= 0 &&
                maxScore != null && passScore <= maxScore;
    }

    /**
     * Lấy tỷ lệ pass score (%)
     */
    public double getPassScorePercentage() {
        if (maxScore == null || maxScore <= 0 || passScore == null) {
            return 0.0;
        }
        return (passScore / maxScore) * 100.0;
    }

    /**
     * Kiểm tra bài kiểm tra có đang mở không
     */
    public boolean isAvailable() {
        if (!isActive) {
            return false;
        }

        LocalDateTime now = LocalDateTime.now();

        if (availableFrom != null && now.isBefore(availableFrom)) {
            return false;
        }

        if (availableUntil != null && now.isAfter(availableUntil)) {
            return false;
        }

        return true;
    }

    /**
     * Kiểm tra học viên có thể làm bài không
     */
    public boolean canStudentTakeQuiz(User student) {
        if (!isAvailable()) {
            return false;
        }

        if (requireLogin && student == null) {
            return false;
        }

        if (student != null && !course.isEnrolledByStudent(student)) {
            return false;
        }

        // Kiểm tra số lần làm bài
        if (student != null && maxAttempts > 0) {
            long attemptCount = getAttemptCountByStudent(student);
            return attemptCount < maxAttempts;
        }

        return true;
    }

    /**
     * Lấy số lần học viên đã làm bài
     */
    public long getAttemptCountByStudent(User student) {
        if (quizResults == null || student == null) {
            return 0;
        }

        return quizResults.stream()
                .filter(qr -> qr.getStudent().getId().equals(student.getId()))
                .count();
    }

    /**
     * Lấy kết quả tốt nhất của học viên
     */
    public QuizResult getBestResultByStudent(User student) {
        if (quizResults == null || student == null) {
            return null;
        }

        return quizResults.stream()
                .filter(qr -> qr.getStudent().getId().equals(student.getId()))
                .max((qr1, qr2) -> Double.compare(qr1.getScore(), qr2.getScore()))
                .orElse(null);
    }

    /**
     * Tính điểm trung bình của bài kiểm tra
     */
    public Double getAverageScore() {
        if (quizResults == null || quizResults.isEmpty()) {
            return null;
        }

        return quizResults.stream()
                .filter(qr -> qr.getScore() != null)
                .mapToDouble(QuizResult::getScore)
                .average()
                .orElse(0.0);
    }

    /**
     * Tính tỷ lệ đạt của bài kiểm tra
     */
    public double getPassRate() {
        if (quizResults == null || quizResults.isEmpty()) {
            return 0.0;
        }

        long passedCount = quizResults.stream()
                .filter(QuizResult::isPassedQuiz)
                .count();

        return (double) passedCount / quizResults.size() * 100.0;
    }

    /**
     * Lấy điểm cao nhất
     */
    public Double getHighestScore() {
        if (quizResults == null || quizResults.isEmpty()) {
            return null;
        }

        return quizResults.stream()
                .filter(qr -> qr.getScore() != null)
                .mapToDouble(QuizResult::getScore)
                .max()
                .orElse(0.0);
    }

    /**
     * Lấy điểm thấp nhất
     */
    public Double getLowestScore() {
        if (quizResults == null || quizResults.isEmpty()) {
            return null;
        }

        return quizResults.stream()
                .filter(qr -> qr.getScore() != null)
                .mapToDouble(QuizResult::getScore)
                .min()
                .orElse(0.0);
    }

    /**
     * Kiểm tra có câu hỏi nào chưa
     */
    public boolean hasQuestions() {
        return questions != null && !questions.isEmpty();
    }

    /**
     * Lấy thời gian hiển thị
     */
    public String getDisplayDuration() {
        if (duration == null || duration <= 0) {
            return "Không giới hạn";
        }

        if (duration < 60) {
            return duration + " phút";
        } else {
            int hours = duration / 60;
            int minutes = duration % 60;

            if (minutes > 0) {
                return hours + " giờ " + minutes + " phút";
            } else {
                return hours + " giờ";
            }
        }
    }

    /**
     * Lấy trạng thái hiển thị
     */
    public String getDisplayStatus() {
        if (!isActive) {
            return "Không hoạt động";
        }

        LocalDateTime now = LocalDateTime.now();

        if (availableFrom != null && now.isBefore(availableFrom)) {
            return "Chưa mở";
        }

        if (availableUntil != null && now.isAfter(availableUntil)) {
            return "Đã đóng";
        }

        return "Đang mở";
    }

    /**
     * Kiểm tra bài kiểm tra có được tạo trong X ngày qua không
     */
    public boolean isNewWithinDays(int days) {
        LocalDateTime cutoff = LocalDateTime.now().minusDays(days);
        return createdAt.isAfter(cutoff);
    }

    /**
     * Lấy độ khó ước tính dựa trên số câu hỏi và thời gian
     */
    public String getEstimatedDifficulty() {
        int questionCount = getQuestionCount();

        if (questionCount == 0 || duration == null) {
            return "Chưa xác định";
        }

        double minutesPerQuestion = (double) duration / questionCount;

        if (minutesPerQuestion >= 3) {
            return "Dễ";
        } else if (minutesPerQuestion >= 1.5) {
            return "Trung bình";
        } else {
            return "Khó";
        }
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

    public String getInstructions() {
        return instructions;
    }

    public void setInstructions(String instructions) {
        this.instructions = instructions;
    }

    public Integer getMaxAttempts() {
        return maxAttempts;
    }

    public void setMaxAttempts(Integer maxAttempts) {
        this.maxAttempts = maxAttempts;
    }

    public boolean isShowResultImmediately() {
        return showResultImmediately;
    }

    public void setShowResultImmediately(boolean showResultImmediately) {
        this.showResultImmediately = showResultImmediately;
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
                ", maxScore=" + maxScore +
                ", passScore=" + passScore +
                ", questionCount=" + getQuestionCount() +
                ", resultCount=" + getResultCount() +
                ", isActive=" + isActive +
                ", course=" + (course != null ? course.getName() : "null") +
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