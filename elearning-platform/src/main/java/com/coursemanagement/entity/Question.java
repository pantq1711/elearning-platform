package com.coursemanagement.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Entity đại diện cho câu hỏi trong bài kiểm tra
 * Chứa nội dung câu hỏi, các lựa chọn và đáp án đúng
 */
@Entity
@Table(name = "questions")
public class Question {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "quiz_id", nullable = false)
    private Quiz quiz;

    @Column(name = "question_text", nullable = false, columnDefinition = "TEXT")
    private String questionText;

    @Column(name = "option_a", nullable = false, length = 500)
    private String optionA;

    @Column(name = "option_b", nullable = false, length = 500)
    private String optionB;

    @Column(name = "option_c", nullable = false, length = 500)
    private String optionC;

    @Column(name = "option_d", nullable = false, length = 500)
    private String optionD;

    @Column(name = "correct_option", nullable = false, length = 1)
    private String correctOption; // A, B, C, D

    @Column(name = "display_order")
    private Integer displayOrder;

    @Enumerated(EnumType.STRING)
    @Column(name = "difficulty_level")
    private DifficultyLevel difficultyLevel = DifficultyLevel.MEDIUM;

    @Column(columnDefinition = "TEXT")
    private String explanation; // Giải thích đáp án

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    /**
     * Enum cho độ khó của câu hỏi
     */
    public enum DifficultyLevel {
        EASY("Dễ"),
        MEDIUM("Trung bình"),
        HARD("Khó");

        private final String displayName;

        DifficultyLevel(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }

    // Constructors
    public Question() {}

    public Question(Quiz quiz, String questionText, String optionA, String optionB,
                    String optionC, String optionD, String correctOption) {
        this.quiz = quiz;
        this.questionText = questionText;
        this.optionA = optionA;
        this.optionB = optionB;
        this.optionC = optionC;
        this.optionD = optionD;
        this.correctOption = correctOption;
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
     * Kiểm tra đáp án có đúng không
     * @param answer Đáp án cần kiểm tra (A, B, C, D)
     * @return true nếu đúng
     */
    public boolean isCorrectAnswer(String answer) {
        return correctOption != null && correctOption.equalsIgnoreCase(answer);
    }

    /**
     * Lấy text của đáp án đúng
     * @return Text đáp án đúng
     */
    public String getCorrectAnswerText() {
        switch (correctOption) {
            case "A": return optionA;
            case "B": return optionB;
            case "C": return optionC;
            case "D": return optionD;
            default: return "";
        }
    }

    /**
     * Lấy text của option theo letter
     * @param option Option letter (A, B, C, D)
     * @return Text của option
     */
    public String getOptionText(String option) {
        switch (option.toUpperCase()) {
            case "A": return optionA;
            case "B": return optionB;
            case "C": return optionC;
            case "D": return optionD;
            default: return "";
        }
    }

    /**
     * Lấy formatted difficulty level
     * @return Difficulty display name
     */
    public String getFormattedDifficulty() {
        return difficultyLevel != null ? difficultyLevel.getDisplayName() : "Không xác định";
    }

    /**
     * Lấy CSS class cho difficulty level
     * @return CSS class
     */
    public String getDifficultyCssClass() {
        if (difficultyLevel == null) return "badge-secondary";

        switch (difficultyLevel) {
            case EASY: return "badge-success";
            case MEDIUM: return "badge-warning";
            case HARD: return "badge-danger";
            default: return "badge-secondary";
        }
    }

    // Getters và Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Quiz getQuiz() {
        return quiz;
    }

    public void setQuiz(Quiz quiz) {
        this.quiz = quiz;
    }

    public String getQuestionText() {
        return questionText;
    }

    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }

    public String getOptionA() {
        return optionA;
    }

    public void setOptionA(String optionA) {
        this.optionA = optionA;
    }

    public String getOptionB() {
        return optionB;
    }

    public void setOptionB(String optionB) {
        this.optionB = optionB;
    }

    public String getOptionC() {
        return optionC;
    }

    public void setOptionC(String optionC) {
        this.optionC = optionC;
    }

    public String getOptionD() {
        return optionD;
    }

    public void setOptionD(String optionD) {
        this.optionD = optionD;
    }

    public String getCorrectOption() {
        return correctOption;
    }

    public void setCorrectOption(String correctOption) {
        this.correctOption = correctOption;
    }

    public Integer getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(Integer displayOrder) {
        this.displayOrder = displayOrder;
    }

    public DifficultyLevel getDifficultyLevel() {
        return difficultyLevel;
    }

    public void setDifficultyLevel(DifficultyLevel difficultyLevel) {
        this.difficultyLevel = difficultyLevel;
    }

    public String getExplanation() {
        return explanation;
    }

    public void setExplanation(String explanation) {
        this.explanation = explanation;
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

    /**
     * Override toString để debug dễ dàng
     */
    @Override
    public String toString() {
        return "Question{" +
                "id=" + id +
                ", quizId=" + (quiz != null ? quiz.getId() : "null") +
                ", correctOption='" + correctOption + '\'' +
                ", difficultyLevel=" + difficultyLevel +
                ", displayOrder=" + displayOrder +
                '}';
    }

    /**
     * Override equals và hashCode cho JPA
     */
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Question)) return false;
        Question question = (Question) o;
        return id != null && id.equals(question.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}