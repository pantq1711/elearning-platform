package com.coursemanagement.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

import java.time.LocalDateTime;

/**
 * Entity đại diện cho bảng questions trong database
 * Lưu thông tin câu hỏi trắc nghiệm 4 đáp án trong bài kiểm tra
 */
@Entity
@Table(name = "questions")
public class Question {

    /**
     * ID tự động tăng - Primary Key
     */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Nội dung câu hỏi - không được trống
     */
    @Column(name = "question_text", nullable = false, columnDefinition = "TEXT")
    @NotBlank(message = "Nội dung câu hỏi không được để trống")
    private String questionText;

    /**
     * Đáp án A
     */
    @Column(name = "option_a", nullable = false)
    @NotBlank(message = "Đáp án A không được để trống")
    private String optionA;

    /**
     * Đáp án B
     */
    @Column(name = "option_b", nullable = false)
    @NotBlank(message = "Đáp án B không được để trống")
    private String optionB;

    /**
     * Đáp án C
     */
    @Column(name = "option_c", nullable = false)
    @NotBlank(message = "Đáp án C không được để trống")
    private String optionC;

    /**
     * Đáp án D
     */
    @Column(name = "option_d", nullable = false)
    @NotBlank(message = "Đáp án D không được để trống")
    private String optionD;

    /**
     * Đáp án đúng - chỉ chấp nhận A, B, C, D
     */
    @Column(name = "correct_option", nullable = false)
    @Pattern(regexp = "^[ABCD]$", message = "Đáp án đúng phải là A, B, C hoặc D")
    private String correctOption;

    /**
     * Giải thích cho đáp án (tùy chọn)
     */
    @Column(columnDefinition = "TEXT")
    private String explanation;

    /**
     * Thời gian tạo câu hỏi
     */
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    /**
     * Thời gian cập nhật cuối cùng
     */
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    /**
     * Quan hệ Many-to-One với Quiz
     * Một câu hỏi thuộc về một bài kiểm tra
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "quiz_id", nullable = false)
    private Quiz quiz;

    /**
     * Constructor mặc định
     */
    public Question() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Constructor với thông tin cơ bản
     */
    public Question(String questionText, String optionA, String optionB,
                    String optionC, String optionD, String correctOption, Quiz quiz) {
        this();
        this.questionText = questionText;
        this.optionA = optionA;
        this.optionB = optionB;
        this.optionC = optionC;
        this.optionD = optionD;
        this.correctOption = correctOption.toUpperCase();
        this.quiz = quiz;
    }

    /**
     * Constructor đầy đủ với giải thích
     */
    public Question(String questionText, String optionA, String optionB,
                    String optionC, String optionD, String correctOption,
                    String explanation, Quiz quiz) {
        this(questionText, optionA, optionB, optionC, optionD, correctOption, quiz);
        this.explanation = explanation;
    }

    /**
     * Callback được gọi trước khi update entity
     */
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Kiểm tra đáp án có đúng không
     * @param selectedOption Đáp án được chọn (A, B, C, D)
     * @return true nếu đúng, false nếu sai
     */
    public boolean isCorrectAnswer(String selectedOption) {
        if (selectedOption == null) {
            return false;
        }
        return correctOption.equalsIgnoreCase(selectedOption.trim());
    }

    /**
     * Lấy text của đáp án theo option
     * @param option Đáp án cần lấy (A, B, C, D)
     * @return Nội dung đáp án hoặc null nếu option không hợp lệ
     */
    public String getOptionText(String option) {
        if (option == null) {
            return null;
        }

        switch (option.toUpperCase()) {
            case "A":
                return optionA;
            case "B":
                return optionB;
            case "C":
                return optionC;
            case "D":
                return optionD;
            default:
                return null;
        }
    }

    /**
     * Lấy nội dung đáp án đúng
     * @return Nội dung của đáp án đúng
     */
    public String getCorrectAnswerText() {
        return getOptionText(correctOption);
    }

    /**
     * Lấy tất cả các đáp án dạng array
     * @return Mảng chứa 4 đáp án theo thứ tự A, B, C, D
     */
    public String[] getAllOptions() {
        return new String[]{optionA, optionB, optionC, optionD};
    }

    /**
     * Lấy tất cả các đáp án dạng array với label
     * @return Mảng chứa đáp án có label, VD: ["A. Đáp án A", "B. Đáp án B", ...]
     */
    public String[] getAllOptionsWithLabels() {
        return new String[]{
                "A. " + optionA,
                "B. " + optionB,
                "C. " + optionC,
                "D. " + optionD
        };
    }

    /**
     * Kiểm tra câu hỏi có giải thích không
     * @return true nếu có giải thích, false nếu không có
     */
    public boolean hasExplanation() {
        return explanation != null && !explanation.trim().isEmpty();
    }

    /**
     * Lấy preview câu hỏi (50 ký tự đầu)
     * @return Nội dung câu hỏi rút gọn
     */
    public String getQuestionPreview() {
        if (questionText == null || questionText.trim().isEmpty()) {
            return "Không có nội dung";
        }

        if (questionText.length() <= 50) {
            return questionText;
        }

        return questionText.substring(0, 50) + "...";
    }

    /**
     * Validate đáp án đúng
     * @param correctOption Đáp án cần validate
     * @return true nếu hợp lệ, false nếu không hợp lệ
     */
    public static boolean isValidCorrectOption(String correctOption) {
        if (correctOption == null) {
            return false;
        }
        return correctOption.matches("^[ABCD]$");
    }

    // === Getters và Setters ===

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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
        this.correctOption = correctOption != null ? correctOption.toUpperCase() : null;
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
        return "Question{" +
                "id=" + id +
                ", questionPreview='" + getQuestionPreview() + '\'' +
                ", correctOption='" + correctOption + '\'' +
                ", hasExplanation=" + hasExplanation() +
                ", quiz=" + (quiz != null ? quiz.getTitle() : "null") +
                '}';
    }
}