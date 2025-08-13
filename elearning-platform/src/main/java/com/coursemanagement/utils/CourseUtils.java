package com.coursemanagement.utils;

import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.DecimalFormat;
import java.text.Normalizer;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;
import java.util.regex.Pattern;

/**
 * Utility classes tổng hợp cho hệ thống Course Management
 * Chứa các helper methods cho string, validation, formatting, file operations, etc.
 */
public class CourseUtils {

    // ===== FILE OPERATION CONSTANTS =====

    private static final String UPLOAD_DIR = "uploads/";
    private static final String COURSE_IMAGE_DIR = "uploads/courses/images/";
    private static final String LESSON_VIDEO_DIR = "uploads/lessons/videos/";
    private static final String DOCUMENT_DIR = "uploads/documents/";

    // File size limits (bytes)
    private static final long MAX_IMAGE_SIZE = 5 * 1024 * 1024; // 5MB
    private static final long MAX_VIDEO_SIZE = 100 * 1024 * 1024; // 100MB
    private static final long MAX_DOCUMENT_SIZE = 10 * 1024 * 1024; // 10MB

    // Allowed file extensions
    private static final List<String> ALLOWED_IMAGE_EXTENSIONS = Arrays.asList("jpg", "jpeg", "png", "gif", "webp", "svg");
    private static final List<String> ALLOWED_VIDEO_EXTENSIONS = Arrays.asList("mp4", "avi", "mov", "wmv", "flv", "webm", "mkv");
    private static final List<String> ALLOWED_DOCUMENT_EXTENSIONS = Arrays.asList("pdf", "doc", "docx", "ppt", "pptx", "xls", "xlsx", "txt");

    // ===== FILE OPERATIONS METHODS =====

    /**
     * Kiểm tra file size có hợp lệ không
     */
    public static boolean isValidFileSize(MultipartFile file, int maxSizeMB) {
        if (file == null || file.isEmpty()) {
            return false;
        }
        long maxSizeBytes = maxSizeMB * 1024L * 1024L;
        return file.getSize() <= maxSizeBytes;
    }

    /**
     * Kiểm tra extension của file có hợp lệ không
     */
    public static boolean isValidFileExtension(String fileName, List<String> allowedExtensions) {
        if (fileName == null || fileName.trim().isEmpty()) {
            return false;
        }
        String extension = getFileExtension(fileName).toLowerCase();
        return allowedExtensions.contains(extension);
    }

    /**
     * Tạo tên file unique để tránh conflict
     */
    public static String generateUniqueFilename(String originalFileName) {
        if (originalFileName == null || originalFileName.trim().isEmpty()) {
            return UUID.randomUUID().toString();
        }

        String extension = getFileExtension(originalFileName);
        String nameWithoutExtension = originalFileName.substring(0,
                originalFileName.lastIndexOf('.') != -1 ? originalFileName.lastIndexOf('.') : originalFileName.length());

        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
        String shortUuid = UUID.randomUUID().toString().substring(0, 8);

        return cleanFileName(nameWithoutExtension) + "_" + timestamp + "_" + shortUuid +
                (extension.isEmpty() ? "" : "." + extension);
    }

    /**
     * Làm sạch tên file (loại bỏ ký tự đặc biệt)
     */
    public static String cleanFileName(String fileName) {
        if (fileName == null) {
            return "";
        }

        String normalized = Normalizer.normalize(fileName, Normalizer.Form.NFD);
        Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        String withoutAccents = pattern.matcher(normalized).replaceAll("");

        return withoutAccents.replaceAll("[^a-zA-Z0-9\\-_]", "_");
    }

    /**
     * Lưu file vào server
     */
    public static String saveFile(MultipartFile file, String directory, String fileName) throws IOException {
        if (file == null || file.isEmpty()) {
            throw new IOException("File rỗng hoặc không hợp lệ");
        }

        Path uploadPath = Paths.get(directory);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        Path filePath = uploadPath.resolve(fileName);
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        return directory + fileName;
    }

    /**
     * Xóa file khỏi server
     */
    public static boolean deleteFile(String filePath) {
        if (filePath == null || filePath.trim().isEmpty()) {
            return false;
        }

        try {
            Path path = Paths.get(filePath);
            return Files.deleteIfExists(path);
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Kiểm tra file có tồn tại không
     */
    public static boolean fileExists(String filePath) {
        if (filePath == null || filePath.trim().isEmpty()) {
            return false;
        }

        Path path = Paths.get(filePath);
        return Files.exists(path);
    }

    /**
     * Lấy size của file tính bằng bytes
     */
    public static long getFileSize(String filePath) {
        if (filePath == null || filePath.trim().isEmpty()) {
            return -1;
        }

        try {
            Path path = Paths.get(filePath);
            return Files.size(path);
        } catch (IOException e) {
            return -1;
        }
    }

    /**
     * Get file extension
     */
    public static String getFileExtension(String filename) {
        if (filename == null || !filename.contains(".")) {
            return "";
        }
        return filename.substring(filename.lastIndexOf(".") + 1);
    }

    // ===== GETTER METHODS FOR CONSTANTS =====

    public static String getUploadDir() { return UPLOAD_DIR; }
    public static String getCourseImageDir() { return COURSE_IMAGE_DIR; }
    public static String getLessonVideoDir() { return LESSON_VIDEO_DIR; }
    public static String getDocumentDir() { return DOCUMENT_DIR; }
    public static List<String> getAllowedImageExtensions() { return ALLOWED_IMAGE_EXTENSIONS; }
    public static List<String> getAllowedVideoExtensions() { return ALLOWED_VIDEO_EXTENSIONS; }
    public static List<String> getAllowedDocumentExtensions() { return ALLOWED_DOCUMENT_EXTENSIONS; }
    public static long getMaxImageSize() { return MAX_IMAGE_SIZE; }
    public static long getMaxVideoSize() { return MAX_VIDEO_SIZE; }
    public static long getMaxDocumentSize() { return MAX_DOCUMENT_SIZE; }

    /**
     * String utilities
     */
    public static class StringUtils {

        /**
         * Tạo slug từ string (cho URL friendly) - Enhanced version
         */
        public static String createSlug(String input) {
            if (input == null || input.trim().isEmpty()) {
                return "";
            }

            // Chuyển về lowercase và trim
            String slug = input.toLowerCase().trim();

            // Loại bỏ dấu tiếng Việt
            slug = Normalizer.normalize(slug, Normalizer.Form.NFD);
            Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
            slug = pattern.matcher(slug).replaceAll("");

            // Thay thế khoảng trắng và ký tự đặc biệt bằng dấu gạch ngang
            slug = slug.replaceAll("[^a-z0-9\\-]", "-");

            // Loại bỏ dấu gạch ngang liên tiếp
            slug = slug.replaceAll("-+", "-");

            // Loại bỏ dấu gạch ngang ở đầu và cuối
            slug = slug.replaceAll("^-|-$", "");

            return slug;
        }

        /**
         * Cắt ngắn text với custom suffix
         */
        public static String truncate(String text, int maxLength, String suffix) {
            if (text == null) {
                return "";
            }

            if (text.length() <= maxLength) {
                return text;
            }

            return text.substring(0, maxLength - suffix.length()) + suffix;
        }

        /**
         * Truncate string với ellipsis
         */
        public static String truncate(String text, int maxLength) {
            return truncate(text, maxLength, "...");
        }

        /**
         * Capitalize first letter
         */
        public static String capitalize(String text) {
            if (text == null || text.isEmpty()) {
                return text;
            }
            return text.substring(0, 1).toUpperCase() + text.substring(1).toLowerCase();
        }

        /**
         * Kiểm tra string có rỗng hoặc null không
         */
        public static boolean isEmpty(String str) {
            return str == null || str.trim().isEmpty();
        }

        /**
         * Kiểm tra string có không rỗng và không null
         */
        public static boolean isNotEmpty(String str) {
            return !isEmpty(str);
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
         */
        public static boolean isValidEmail(String email) {
            return email != null && EMAIL_PATTERN.matcher(email).matches();
        }

        /**
         * Validate username
         */
        public static boolean isValidUsername(String username) {
            return username != null && USERNAME_PATTERN.matcher(username).matches();
        }

        /**
         * Validate password
         */
        public static boolean isValidPassword(String password) {
            return password != null &&
                    password.length() >= 6 &&
                    password.length() <= 100;
        }

        /**
         * Validate phone number
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
         */
        public static String formatCurrency(Double amount) {
            if (amount == null || amount == 0) {
                return "Miễn phí";
            }
            return CURRENCY_FORMAT.format(amount) + " VNĐ";
        }

        /**
         * Format number với dấu phẩy
         */
        public static String formatNumber(Number number) {
            if (number == null) {
                return "0";
            }
            return DECIMAL_FORMAT.format(number);
        }

        /**
         * Format percentage
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
         */
        public static String formatDateTime(LocalDateTime dateTime) {
            if (dateTime == null) {
                return "";
            }
            return dateTime.format(DATE_TIME_FORMATTER);
        }

        /**
         * Format date only
         */
        public static String formatDate(LocalDateTime dateTime) {
            if (dateTime == null) {
                return "";
            }
            return dateTime.format(DATE_FORMATTER);
        }

        /**
         * Format time only
         */
        public static String formatTime(LocalDateTime dateTime) {
            if (dateTime == null) {
                return "";
            }
            return dateTime.format(TIME_FORMATTER);
        }

        /**
         * Format relative time (time ago)
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
         */
        public static boolean isDocumentFile(String filename) {
            if (filename == null) {
                return false;
            }
            String extension = getFileExtension(filename).toLowerCase();
            return extension.matches("pdf|doc|docx|ppt|pptx|xls|xlsx|txt");
        }

        /**
         * Format file size
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