package com.coursemanagement.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

import java.time.LocalDateTime;
import java.util.List;

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
    @Size(min = 10, max = 1000, message = "Nội dung câu hỏi phải từ 10-1000 ký tự")
    private String questionText;

    /**
     * Đáp án A
     */
    @Column(name = "option_a", nullable = false)
    @NotBlank(message = "Đáp án A không được để trống")
    @Size(max = 200, message = "Đáp án A không được vượt quá 200 ký tự")
    private String optionA;

    /**
     * Đáp án B
     */
    @Column(name = "option_b", nullable = false)
    @NotBlank(message = "Đáp án B không được để trống")
    @Size(max = 200, message = "Đáp án B không được vượt quá 200 ký tự")
    private String optionB;

    /**
     * Đáp án C
     */
    @Column(name = "option_c", nullable = false)
    @NotBlank(message = "Đáp án C không được để trống")
    @Size(max = 200, message = "Đáp án C không được vượt quá 200 ký tự")
    private String optionC;

    /**
     * Đáp án D
     */
    @Column(name = "option_d", nullable = false)
    @NotBlank(message = "Đáp án D không được để trống")
    @Size(max = 200, message = "Đáp án D không được vượt quá 200 ký tự")
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
    @Size(max = 500, message = "Giải thích không được vượt quá 500 ký tự")
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
     * Điểm số cho câu hỏi (mặc định là 1)
     */
    @Column(name = "points")
    private Double points = 1.0;

    /**
     * Mức độ khó của câu hỏi
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "difficulty_level")
    private DifficultyLevel difficultyLevel = DifficultyLevel.EASY;

    /**
     * Loại câu hỏi (cho tương lai mở rộng)
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "question_type")
    private QuestionType questionType = QuestionType.MULTIPLE_CHOICE;

    /**
     * Thẻ tag để phân loại câu hỏi
     */
    @Column(name = "tags")
    private String tags;

    /**
     * Hình ảnh đính kèm câu hỏi (tùy chọn)
     */
    @Column(name = "image_url")
    private String imageUrl;

    /**
     * Thứ tự hiển thị trong quiz
     */
    @Column(name = "display_order")
    private Integer displayOrder;

    /**
     * Quan hệ Many-to-One với Quiz
     * Một câu hỏi thuộc về một bài kiểm tra
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "quiz_id", nullable = false)
    private Quiz quiz;

    /**
     * Enum định nghĩa mức độ khó
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

    /**
     * Enum định nghĩa loại câu hỏi
     */
    public enum QuestionType {
        MULTIPLE_CHOICE("Trắc nghiệm"),
        TRUE_FALSE("Đúng/Sai"),
        FILL_BLANK("Điền vào chỗ trống");

        private final String displayName;

        QuestionType(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }

    /**
     * Constructor mặc định
     */
    public Question() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
        this.points = 1.0;
        this.difficultyLevel = DifficultyLevel.EASY;
        this.questionType = QuestionType.MULTIPLE_CHOICE;
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
        this.correctOption = correctOption;
        this.quiz = quiz;
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
     * Lấy tất cả các tùy chọn dưới dạng danh sách
     */
    public List<String> getAllOptions() {
        return List.of(optionA, optionB, optionC, optionD);
    }

    /**
     * Lấy text của đáp án đúng
     */
    public String getCorrectAnswerText() {
        switch (correctOption) {
            case "A": return optionA;
            case "B": return optionB;
            case "C": return optionC;
            case "D": return optionD;
            default: return null;
        }
    }

    /**
     * Kiểm tra đáp án có đúng không
     */
    public boolean isCorrectAnswer(String selectedOption) {
        return correctOption != null && correctOption.equals(selectedOption);
    }

    /**
     * Kiểm tra đáp án đúng có hợp lệ không
     */
    public boolean isValidCorrectOption() {
        return correctOption != null && correctOption.matches("^[ABCD]$");
    }

    /**
     * Lấy text của option theo chữ cái
     */
    public String getOptionText(String option) {
        if (option == null) return null;

        switch (option.toUpperCase()) {
            case "A": return optionA;
            case "B": return optionB;
            case "C": return optionC;
            case "D": return optionD;
            default: return null;
        }
    }

    /**
     * Kiểm tra câu hỏi có hình ảnh không
     */
    public boolean hasImage() {
        return imageUrl != null && !imageUrl.trim().isEmpty();
    }

    /**
     * Kiểm tra câu hỏi có giải thích không
     */
    public boolean hasExplanation() {
        return explanation != null && !explanation.trim().isEmpty();
    }

    /**
     * Lấy tags dưới dạng danh sách
     */
    public List<String> getTagList() {
        if (tags == null || tags.trim().isEmpty()) {
            return List.of();
        }

        return List.of(tags.split(","))
                .stream()
                .map(String::trim)
                .filter(tag -> !tag.isEmpty())
                .toList();
    }

    /**
     * Thêm tag mới
     */
    public void addTag(String tag) {
        if (tag == null || tag.trim().isEmpty()) {
            return;
        }

        List<String> currentTags = getTagList();
        if (!currentTags.contains(tag.trim())) {
            if (tags == null || tags.trim().isEmpty()) {
                tags = tag.trim();
            } else {
                tags += ", " + tag.trim();
            }
        }
    }

    /**
     * Xóa tag
     */
    public void removeTag(String tag) {
        if (tag == null || tag.trim().isEmpty() || tags == null) {
            return;
        }

        List<String> currentTags = getTagList();
        currentTags = currentTags.stream()
                .filter(t -> !t.equals(tag.trim()))
                .toList();

        tags = String.join(", ", currentTags);
    }

    /**
     * Kiểm tra có các đáp án trùng lặp không
     */
    public boolean hasDuplicateOptions() {
        List<String> options = getAllOptions();
        return options.size() != options.stream().distinct().count();
    }

    /**
     * Lấy độ dài câu hỏi
     */
    public int getQuestionLength() {
        return questionText != null ? questionText.length() : 0;
    }

    /**
     * Kiểm tra câu hỏi có phải dạng ngắn không
     */
    public boolean isShortQuestion() {
        return getQuestionLength() <= 100;
    }

    /**
     * Kiểm tra câu hỏi có phải dạng dài không
     */
    public boolean isLongQuestion() {
        return getQuestionLength() > 300;
    }

    /**
     * Lấy tóm tắt câu hỏi (50 ký tự đầu)
     */
    public String getQuestionSummary() {
        if (questionText == null || questionText.trim().isEmpty()) {
            return "Không có nội dung";
        }

        String cleanText = questionText.replaceAll("<[^>]*>", "").trim();

        if (cleanText.length() <= 50) {
            return cleanText;
        }

        return cleanText.substring(0, 50) + "...";
    }

    /**
     * Kiểm tra câu hỏi có được tạo trong X ngày qua không
     */
    public boolean isNewWithinDays(int days) {
        LocalDateTime cutoff = LocalDateTime.now().minusDays(days);
        return createdAt.isAfter(cutoff);
    }

    /**
     * Lấy màu sắc theo mức độ khó
     */
    public String getDifficultyColor() {
        switch (difficultyLevel) {
            case EASY: return "#28a745";    // Green
            case MEDIUM: return "#ffc107";  // Yellow
            case HARD: return "#dc3545";    // Red
            default: return "#6c757d";      // Gray
        }
    }

    /**
     * Lấy icon theo mức độ khó
     */
    public String getDifficultyIcon() {
        switch (difficultyLevel) {
            case EASY: return "fas fa-star";
            case MEDIUM: return "fas fa-star-half-alt";
            case HARD: return "fas fa-skull";
            default: return "fas fa-question";
        }
    }

    /**
     * Kiểm tra tính hợp lệ của câu hỏi
     */
    public boolean isValid() {
        return questionText != null && !questionText.trim().isEmpty() &&
                optionA != null && !optionA.trim().isEmpty() &&
                optionB != null && !optionB.trim().isEmpty() &&
                optionC != null && !optionC.trim().isEmpty() &&
                optionD != null && !optionD.trim().isEmpty() &&
                isValidCorrectOption() &&
                !hasDuplicateOptions();
    }

    /**
     * Lấy thông báo lỗi validation
     */
    public List<String> getValidationErrors() {
        List<String> errors = new java.util.ArrayList<>();

        if (questionText == null || questionText.trim().isEmpty()) {
            errors.add("Nội dung câu hỏi không được để trống");
        }

        if (optionA == null || optionA.trim().isEmpty()) {
            errors.add("Đáp án A không được để trống");
        }

        if (optionB == null || optionB.trim().isEmpty()) {
            errors.add("Đáp án B không được để trống");
        }

        if (optionC == null || optionC.trim().isEmpty()) {
            errors.add("Đáp án C không được để trống");
        }

        if (optionD == null || optionD.trim().isEmpty()) {
            errors.add("Đáp án D không được để trống");
        }

        if (!isValidCorrectOption()) {
            errors.add("Đáp án đúng phải là A, B, C hoặc D");
        }

        if (hasDuplicateOptions()) {
            errors.add("Các đáp án không được trùng lặp");
        }

        return errors;
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
        this.correctOption = correctOption;
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

    public Double getPoints() {
        return points;
    }

    public void setPoints(Double points) {
        this.points = points;
    }

    public DifficultyLevel getDifficultyLevel() {
        return difficultyLevel;
    }

    public void setDifficultyLevel(DifficultyLevel difficultyLevel) {
        this.difficultyLevel = difficultyLevel;
    }

    public QuestionType getQuestionType() {
        return questionType;
    }

    public void setQuestionType(QuestionType questionType) {
        this.questionType = questionType;
    }

    public String getTags() {
        return tags;
    }

    public void setTags(String tags) {
        this.tags = tags;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Integer getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(Integer displayOrder) {
        this.displayOrder = displayOrder;
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
                ", questionText='" + getQuestionSummary() + '\'' +
                ", correctOption='" + correctOption + '\'' +
                ", points=" + points +
                ", difficultyLevel=" + difficultyLevel +
                ", quiz=" + (quiz != null ? quiz.getTitle() : "null") +
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