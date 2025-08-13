package com.coursemanagement.entity;

/**
 * Enum định nghĩa các loại câu hỏi trong quiz
 * Hỗ trợ multiple choice, true/false, và essay
 */
public enum QuestionType {
    MULTIPLE_CHOICE("Trắc nghiệm"),
    TRUE_FALSE("Đúng/Sai"),
    ESSAY("Tự luận"),
    FILL_IN_THE_BLANK("Điền vào chỗ trống"),
    MATCHING("Nối cặp");

    private final String displayName;

    /**
     * Constructor cho QuestionType
     * @param displayName Tên hiển thị bằng tiếng Việt
     */
    QuestionType(String displayName) {
        this.displayName = displayName;
    }

    /**
     * Lấy tên hiển thị của loại câu hỏi
     * @return Tên hiển thị bằng tiếng Việt
     */
    public String getDisplayName() {
        return displayName;
    }

    /**
     * Kiểm tra xem loại câu hỏi có cần nhiều đáp án không
     * @return true nếu cần nhiều đáp án (A, B, C, D)
     */
    public boolean isMultipleOptions() {
        return this == MULTIPLE_CHOICE;
    }

    /**
     * Kiểm tra xem loại câu hỏi có cần chấm điểm tự động không
     * @return true nếu có thể chấm điểm tự động
     */
    public boolean isAutoGradable() {
        return this != ESSAY;
    }
}