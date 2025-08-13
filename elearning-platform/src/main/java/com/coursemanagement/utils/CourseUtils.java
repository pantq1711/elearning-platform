package com.coursemanagement.utils;

import java.text.DecimalFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.regex.Pattern;

/**
 * Utility classes tổng hợp cho hệ thống Course Management
 * Chứa các helper methods cho string, validation, formatting, etc.
 */
public class CourseUtils {

    /**
     * String utilities
     */
    public static class StringUtils {

        /**
         * Tạo slug từ string (cho URL friendly)
         * @param input String đầu vào
         * @return Slug đã được tạo
         */
        public static String createSlug(String input) {
            if (input == null || input.trim().isEmpty()) {
                return "";
            }

            return input.trim()
                    .toLowerCase()
                    .replaceAll("[àáạảãâầấậẩẫăằắặẳẵ]", "a")
                    .replaceAll("[èéẹẻẽêềếệểễ]", "e")
                    .replaceAll("[ìíịỉĩ]", "i")
                    .replaceAll("[òóọỏõôồốộổỗơờớợởỡ]", "o")
                    .replaceAll("[ùúụủũưừứựửữ]", "u")
                    .replaceAll("[ỳýỵỷỹ]", "y")
                    .replaceAll("[đ]", "d")
                    .replaceAll("[^a-z0-9\\s-]", "") // Loại bỏ ký tự đặc biệt
                    .replaceAll("\\s+", "-") // Thay space bằng dấu -
                    .replaceAll("-+", "-") // Loại bỏ dấu - liên tiếp
                    .replaceAll("^-|-$", ""); // Loại bỏ dấu - đầu/cuối
        }

        /**
         * Truncate string với ellipsis
         * @param text Text cần cắt
         * @param maxLength Độ dài tối đa
         * @return Text đã được cắt
         */
        public static String truncate(String text, int maxLength) {
            if (text == null || text.length() <= maxLength) {
                return text;
            }
            return text.substring(0, maxLength - 3) + "...";
        }

        /**
         * Capitalize first letter
         * @param text Text đầu vào
         * @return Text với chữ cái đầu viết hoa
         */
        public static String capitalize(String text) {
            if (text == null || text.isEmpty()) {
                return text;
            }
            return text.substring(0, 1).toUpperCase() + text.substring(1).toLowerCase();
        }
    }

    /**
     * Validation utilities
     */
    public static class ValidationUtils {

        private static final Pattern EMAIL_PATTERN =
                Pattern.compile("^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\\.[A-Za-z]{2,})$");

        private static final Pattern USERNAME_PATTERN =
                Pattern.compile("^[a-zA-Z0-9._-]{3,20}$");

        private static final Pattern PHONE_PATTERN =
                Pattern.compile("^(\\+84|0)[0-9]{9,10}$");

        /**
         * Validate email
         * @param email Email cần validate
         * @return true nếu hợp lệ
         */
        public static boolean isValidEmail(String email) {
            return email != null && EMAIL_PATTERN.matcher(email).matches();
        }

        /**
         * Validate username
         * @param username Username cần validate
         * @return true nếu hợp lệ
         */
        public static boolean isValidUsername(String username) {
            return username != null && USERNAME_PATTERN.matcher(username).matches();
        }

        /**
         * Validate password
         * @param password Password cần validate
         * @return true nếu hợp lệ
         */
        public static boolean isValidPassword(String password) {
            return password != null &&
                    password.length() >= 6 &&
                    password.length() <= 100;
        }

        /**
         * Validate phone number
         * @param phone Phone cần validate
         * @return true nếu hợp lệ
         */
        public static boolean isValidPhone(String phone) {
            return phone != null && PHONE_PATTERN.matcher(phone).matches();
        }
    }

    /**
     * Number and currency utilities
     */
    public static class NumberUtils {

        private static final DecimalFormat CURRENCY_FORMAT = new DecimalFormat("#,##0");
        private static final DecimalFormat DECIMAL_FORMAT = new DecimalFormat("#,##0.##");

        /**
         * Format currency (VND)
         * @param amount Số tiền
         * @return Formatted currency
         */
        public static String formatCurrency(Double amount) {
            if (amount == null || amount == 0) {
                return "Miễn phí";
            }
            return CURRENCY_FORMAT.format(amount) + " VNĐ";
        }

        /**
         * Format number với dấu phẩy
         * @param number Số cần format
         * @return Formatted number
         */
        public static String formatNumber(Number number) {
            if (number == null) {
                return "0";
            }
            return DECIMAL_FORMAT.format(number);
        }

        /**
         * Format percentage
         * @param value Giá trị
         * @param total Tổng
         * @return Percentage string
         */
        public static String formatPercentage(Number value, Number total) {
            if (value == null || total == null || total.doubleValue() == 0) {
                return "0%";
            }
            double percentage = value.doubleValue() / total.doubleValue() * 100;
            return String.format("%.1f%%", percentage);
        }
    }

    /**
     * Date and time utilities
     */
    public static class DateTimeUtils {

        private static final DateTimeFormatter DATE_TIME_FORMATTER =
                DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

        private static final DateTimeFormatter DATE_FORMATTER =
                DateTimeFormatter.ofPattern("dd/MM/yyyy");

        private static final DateTimeFormatter TIME_FORMATTER =
                DateTimeFormatter.ofPattern("HH:mm");

        /**
         * Format datetime
         * @param dateTime LocalDateTime cần format
         * @return Formatted datetime string
         */
        public static String formatDateTime(LocalDateTime dateTime) {
            if (dateTime == null) {
                return "";
            }
            return dateTime.format(DATE_TIME_FORMATTER);
        }

        /**
         * Format date only
         * @param dateTime LocalDateTime cần format
         * @return Formatted date string
         */
        public static String formatDate(LocalDateTime dateTime) {
            if (dateTime == null) {
                return "";
            }
            return dateTime.format(DATE_FORMATTER);
        }

        /**
         * Format time only
         * @param dateTime LocalDateTime cần format
         * @return Formatted time string
         */
        public static String formatTime(LocalDateTime dateTime) {
            if (dateTime == null) {
                return "";
            }
            return dateTime.format(TIME_FORMATTER);
        }

        /**
         * Format relative time (time ago)
         * @param dateTime LocalDateTime cần format
         * @return Relative time string
         */
        public static String formatRelativeTime(LocalDateTime dateTime) {
            if (dateTime == null) {
                return "";
            }

            LocalDateTime now = LocalDateTime.now();
            long minutes = java.time.Duration.between(dateTime, now).toMinutes();

            if (minutes < 1) {
                return "Vừa xong";
            } else if (minutes < 60) {
                return minutes + " phút trước";
            } else if (minutes < 1440) { // < 24 hours
                return (minutes / 60) + " giờ trước";
            } else if (minutes < 43200) { // < 30 days
                return (minutes / 1440) + " ngày trước";
            } else {
                return formatDate(dateTime);
            }
        }
    }

    /**
     * Course specific helpers
     */
    public static class CourseHelper {

        /**
         * Format duration (minutes to readable format)
         * @param minutes Duration in minutes
         * @return Formatted duration
         */
        public static String formatDuration(Integer minutes) {
            if (minutes == null || minutes == 0) {
                return "Chưa xác định";
            }

            if (minutes < 60) {
                return minutes + " phút";
            } else if (minutes < 1440) { // < 24 hours
                int hours = minutes / 60;
                int remainingMinutes = minutes % 60;
                if (remainingMinutes == 0) {
                    return hours + " giờ";
                } else {
                    return hours + " giờ " + remainingMinutes + " phút";
                }
            } else {
                int days = minutes / 1440;
                int remainingHours = (minutes % 1440) / 60;
                if (remainingHours == 0) {
                    return days + " ngày";
                } else {
                    return days + " ngày " + remainingHours + " giờ";
                }
            }
        }

        /**
         * Get difficulty level text
         * @param level Difficulty level enum
         * @return Text hiển thị
         */
        public static String getDifficultyText(String level) {
            if (level == null) {
                return "Không xác định";
            }

            switch (level.toUpperCase()) {
                case "BEGINNER": return "Cơ bản";
                case "INTERMEDIATE": return "Trung cấp";
                case "ADVANCED": return "Nâng cao";
                default: return "Không xác định";
            }
        }

        /**
         * Get difficulty CSS class
         * @param level Difficulty level
         * @return CSS class
         */
        public static String getDifficultyCssClass(String level) {
            if (level == null) {
                return "badge-secondary";
            }

            switch (level.toUpperCase()) {
                case "BEGINNER": return "badge-success";
                case "INTERMEDIATE": return "badge-warning";
                case "ADVANCED": return "badge-danger";
                default: return "badge-secondary";
            }
        }

        /**
         * Calculate completion percentage
         * @param completed Số lượng đã hoàn thành
         * @param total Tổng số lượng
         * @return Percentage (0-100)
         */
        public static double calculateCompletionPercentage(int completed, int total) {
            if (total == 0) {
                return 0.0;
            }
            return Math.round((double) completed / total * 100 * 10.0) / 10.0;
        }
    }

    /**
     * File utilities
     */
    public static class FileUtils {

        /**
         * Check if file is image
         * @param filename Filename
         * @return true if image
         */
        public static boolean isImageFile(String filename) {
            if (filename == null) {
                return false;
            }
            String extension = getFileExtension(filename).toLowerCase();
            return extension.matches("jpg|jpeg|png|gif|webp|svg");
        }

        /**
         * Check if file is video
         * @param filename Filename
         * @return true if video
         */
        public static boolean isVideoFile(String filename) {
            if (filename == null) {
                return false;
            }
            String extension = getFileExtension(filename).toLowerCase();
            return extension.matches("mp4|avi|mov|wmv|flv|webm|mkv");
        }

        /**
         * Check if file is document
         * @param filename Filename
         * @return true if document
         */
        public static boolean isDocumentFile(String filename) {
            if (filename == null) {
                return false;
            }
            String extension = getFileExtension(filename).toLowerCase();
            return extension.matches("pdf|doc|docx|ppt|pptx|xls|xlsx|txt");
        }

        /**
         * Get file extension
         * @param filename Filename
         * @return File extension
         */
        public static String getFileExtension(String filename) {
            if (filename == null || !filename.contains(".")) {
                return "";
            }
            return filename.substring(filename.lastIndexOf(".") + 1);
        }

        /**
         * Format file size
         * @param bytes File size in bytes
         * @return Formatted file size
         */
        public static String formatFileSize(long bytes) {
            if (bytes < 1024) {
                return bytes + " B";
            } else if (bytes < 1024 * 1024) {
                return String.format("%.1f KB", bytes / 1024.0);
            } else if (bytes < 1024 * 1024 * 1024) {
                return String.format("%.1f MB", bytes / (1024.0 * 1024.0));
            } else {
                return String.format("%.1f GB", bytes / (1024.0 * 1024.0 * 1024.0));
            }
        }
    }
}