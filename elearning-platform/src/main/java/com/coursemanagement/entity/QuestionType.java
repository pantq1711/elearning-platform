package com.coursemanagement.entity;

/**
 * Enum định nghĩa các loại câu hỏi trong quiz
 * Hỗ trợ nhiều loại câu hỏi khác nhau cho hệ thống e-learning
 */
public enum QuestionType {
    MULTIPLE_CHOICE("Trắc nghiệm", "Câu hỏi có 4 đáp án A, B, C, D"),
    TRUE_FALSE("Đúng/Sai", "Câu hỏi chỉ có 2 lựa chọn Đúng hoặc Sai"),
    ESSAY("Tự luận", "Câu hỏi yêu cầu trả lời bằng văn bản"),
    FILL_IN_THE_BLANK("Điền vào chỗ trống", "Câu hỏi điền từ/cụm từ vào chỗ trống"),
    MATCHING("Nối cặp", "Câu hỏi nối các cặp thông tin với nhau"),
    ORDERING("Sắp xếp", "Câu hỏi sắp xếp thứ tự đúng"),
    SHORT_ANSWER("Trả lời ngắn", "Câu hỏi yêu cầu trả lời ngắn gọn");

    private final String displayName;
    private final String description;

    /**
     * Constructor cho QuestionType
     * @param displayName Tên hiển thị bằng tiếng Việt
     * @param description Mô tả chi tiết về loại câu hỏi
     */
    QuestionType(String displayName, String description) {
        this.displayName = displayName;
        this.description = description;
    }

    /**
     * Lấy tên hiển thị của loại câu hỏi
     * @return Tên hiển thị bằng tiếng Việt
     */
    public String getDisplayName() {
        return displayName;
    }

    /**
     * Lấy mô tả chi tiết của loại câu hỏi
     * @return Mô tả chi tiết
     */
    public String getDescription() {
        return description;
    }

    /**
     * Kiểm tra loại câu hỏi có cần nhiều đáp án không (A, B, C, D)
     * @return true nếu cần nhiều đáp án
     */
    public boolean isMultipleOptions() {
        return this == MULTIPLE_CHOICE || this == MATCHING;
    }

    /**
     * Kiểm tra loại câu hỏi có thể chấm điểm tự động không
     * @return true nếu có thể chấm điểm tự động
     */
    public boolean isAutoGradable() {
        return this != ESSAY;
    }

    /**
     * Kiểm tra loại câu hỏi có cần text input không
     * @return true nếu cần text input
     */
    public boolean requiresTextInput() {
        return this == ESSAY || this == FILL_IN_THE_BLANK || this == SHORT_ANSWER;
    }

    /**
     * Kiểm tra loại câu hỏi có cần option A, B, C, D không
     * @return true nếu cần options
     */
    public boolean requiresOptions() {
        return this == MULTIPLE_CHOICE || this == TRUE_FALSE || this == MATCHING;
    }

    /**
     * Lấy số lượng options mặc định cho loại câu hỏi
     * @return Số lượng options
     */
    public int getDefaultOptionCount() {
        switch (this) {
            case MULTIPLE_CHOICE:
                return 4; // A, B, C, D
            case TRUE_FALSE:
                return 2; // Đúng, Sai
            case MATCHING:
                return 4; // Có thể nhiều hơn
            default:
                return 0;
        }
    }

    /**
     * Lấy icon CSS class cho hiển thị UI
     * @return Icon class name
     */
    public String getIconClass() {
        switch (this) {
            case MULTIPLE_CHOICE:
                return "fas fa-list-ul";
            case TRUE_FALSE:
                return "fas fa-check-double";
            case ESSAY:
                return "fas fa-edit";
            case FILL_IN_THE_BLANK:
                return "fas fa-i-cursor";
            case MATCHING:
                return "fas fa-arrows-alt-h";
            case ORDERING:
                return "fas fa-sort-numeric-down";
            case SHORT_ANSWER:
                return "fas fa-comment";
            default:
                return "fas fa-question-circle";
        }
    }

    /**
     * Lấy màu CSS class cho hiển thị UI
     * @return CSS class name
     */
    public String getCssClass() {
        switch (this) {
            case MULTIPLE_CHOICE:
                return "badge-primary";
            case TRUE_FALSE:
                return "badge-success";
            case ESSAY:
                return "badge-warning";
            case FILL_IN_THE_BLANK:
                return "badge-info";
            case MATCHING:
                return "badge-secondary";
            case ORDERING:
                return "badge-dark";
            case SHORT_ANSWER:
                return "badge-light";
            default:
                return "badge-secondary";
        }
    }

    /**
     * Lấy template HTML cho hiển thị câu hỏi
     * @return Template name
     */
    public String getTemplateName() {
        switch (this) {
            case MULTIPLE_CHOICE:
                return "multiple-choice";
            case TRUE_FALSE:
                return "true-false";
            case ESSAY:
                return "essay";
            case FILL_IN_THE_BLANK:
                return "fill-blank";
            case MATCHING:
                return "matching";
            case ORDERING:
                return "ordering";
            case SHORT_ANSWER:
                return "short-answer";
            default:
                return "default";
        }
    }

    /**
     * Kiểm tra câu trả lời có hợp lệ cho loại câu hỏi không
     * @param answer Câu trả lời
     * @return true nếu hợp lệ
     */
    public boolean isValidAnswer(String answer) {
        if (answer == null || answer.trim().isEmpty()) {
            return false;
        }

        switch (this) {
            case MULTIPLE_CHOICE:
                return answer.matches("[A-Da-d]");
            case TRUE_FALSE:
                return answer.equalsIgnoreCase("true") || answer.equalsIgnoreCase("false") ||
                        answer.equalsIgnoreCase("đúng") || answer.equalsIgnoreCase("sai");
            case ESSAY:
                return answer.length() >= 10; // Tối thiểu 10 ký tự
            case FILL_IN_THE_BLANK:
            case SHORT_ANSWER:
                return answer.length() >= 1;
            default:
                return true;
        }
    }

    /**
     * Lấy tất cả QuestionType dưới dạng array cho dropdown
     * @return Array các QuestionType
     */
    public static QuestionType[] getAllTypes() {
        return values();
    }

    @Override
    public String toString() {
        return displayName;
    }
}