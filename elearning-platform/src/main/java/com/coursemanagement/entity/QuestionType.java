package com.coursemanagement.entity;

/**
 * Enum định nghĩa các loại câu hỏi trong quiz
 * Hỗ trợ nhiều format câu hỏi khác nhau
 */
public enum QuestionType {
    MULTIPLE_CHOICE("Trắc nghiệm", "Chọn 1 đáp án đúng từ 4 lựa chọn", "fas fa-check-circle"),
    TRUE_FALSE("Đúng/Sai", "Câu hỏi có 2 lựa chọn: Đúng hoặc Sai", "fas fa-question-circle"),
    ESSAY("Tự luận", "Câu hỏi yêu cầu trả lời bằng văn bản", "fas fa-edit"),
    FILL_BLANK("Điền từ", "Điền từ/cụm từ vào chỗ trống", "fas fa-keyboard");

    private final String displayName;
    private final String description;
    private final String iconClass;

    QuestionType(String displayName, String description, String iconClass) {
        this.displayName = displayName;
        this.description = description;
        this.iconClass = iconClass;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getDescription() {
        return description;
    }

    public String getIconClass() {
        return iconClass;
    }

    /**
     * Chuyển đổi từ String sang enum
     */
    public static QuestionType fromString(String type) {
        if (type == null || type.trim().isEmpty()) {
            return MULTIPLE_CHOICE;
        }

        return switch (type.toUpperCase()) {
            case "MULTIPLE_CHOICE", "TRẮC NGHIỆM", "MCQ" -> MULTIPLE_CHOICE;
            case "TRUE_FALSE", "ĐÚNG SAI", "T/F" -> TRUE_FALSE;
            case "ESSAY", "TỰ LUẬN", "ESSAY_QUESTION" -> ESSAY;
            case "FILL_BLANK", "ĐIỀN TỪ", "FILL_IN_BLANK" -> FILL_BLANK;
            default -> MULTIPLE_CHOICE;
        };
    }

    /**
     * Kiểm tra có cần options A,B,C,D không
     */
    public boolean hasMultipleOptions() {
        return this == MULTIPLE_CHOICE;
    }

    /**
     * Kiểm tra có cần scoring tự động không
     */
    public boolean isAutoGradable() {
        return this == MULTIPLE_CHOICE || this == TRUE_FALSE || this == FILL_BLANK;
    }

    /**
     * Lấy số options mặc định
     */
    public int getDefaultOptionCount() {
        return switch (this) {
            case MULTIPLE_CHOICE -> 4;
            case TRUE_FALSE -> 2;
            case ESSAY, FILL_BLANK -> 0;
        };
    }

    /**
     * Lấy CSS class cho icon
     */
    public String getColorClass() {
        return switch (this) {
            case MULTIPLE_CHOICE -> "text-primary";
            case TRUE_FALSE -> "text-info";
            case ESSAY -> "text-warning";
            case FILL_BLANK -> "text-success";
        };
    }
}