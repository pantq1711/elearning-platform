package com.coursemanagement.utils;

import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.io.InputStream;
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
    public static DateTimeUtils DateTimeUtils;

    // ===== STATIC UTILITY METHODS =====

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
        String uniqueId = UUID.randomUUID().toString().substring(0, 8);

        if (extension.isEmpty()) {
            return String.format("%s_%s_%s", nameWithoutExtension, timestamp, uniqueId);
        } else {
            return String.format("%s_%s_%s.%s", nameWithoutExtension, timestamp, uniqueId, extension);
        }
    }

    /**
     * Lấy extension của file
     */
    public static String getFileExtension(String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            return "";
        }
        int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex == -1 || lastDotIndex == fileName.length() - 1) {
            return "";
        }
        return fileName.substring(lastDotIndex + 1);
    }

    /**
     * Lưu file vào thư mục chỉ định
     */
    public static String saveFile(MultipartFile file, String uploadDirectory, String filename) throws IOException {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("File không được để trống");
        }

        // Tạo directory nếu chưa tồn tại
        Path uploadPath = Paths.get(uploadDirectory);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // Generate filename nếu không được cung cấp
        if (filename == null || filename.isEmpty()) {
            filename = generateUniqueFilename(file.getOriginalFilename());
        }

        // Đường dẫn file đầy đủ
        Path filePath = uploadPath.resolve(filename);

        // Lưu file
        try (InputStream inputStream = file.getInputStream()) {
            Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
        }

        return filePath.toString();
    }

    /**
     * Xóa file từ hệ thống
     */
    public static boolean deleteFile(String filePath) {
        if (filePath == null || filePath.isEmpty()) {
            return false;
        }

        try {
            Path path = Paths.get(filePath);
            return Files.deleteIfExists(path);
        } catch (IOException e) {
            return false;
        }
    }

    /**
     * Lấy thư mục upload cho course images
     */
    public static String getCourseImageDir() {
        return COURSE_IMAGE_DIR;
    }

    /**
     * Lấy thư mục upload cho lesson videos
     */
    public static String getLessonVideoDir() {
        return LESSON_VIDEO_DIR;
    }

    /**
     * Lấy thư mục upload cho documents
     */
    public static String getDocumentDir() {
        return DOCUMENT_DIR;
    }

    /**
     * Lấy danh sách extensions được phép cho images
     */
    public static List<String> getAllowedImageExtensions() {
        return ALLOWED_IMAGE_EXTENSIONS;
    }

    /**
     * Lấy danh sách extensions được phép cho videos
     */
    public static List<String> getAllowedVideoExtensions() {
        return ALLOWED_VIDEO_EXTENSIONS;
    }

    /**
     * Lấy danh sách extensions được phép cho documents
     */
    public static List<String> getAllowedDocumentExtensions() {
        return ALLOWED_DOCUMENT_EXTENSIONS;
    }

    // ===== STRING UTILITIES =====

    /**
     * String utilities inner class
     */
    public static class StringUtils {

        private static final Pattern DIACRITICS_AND_FRIENDS = Pattern.compile("[\\p{InCombiningDiacriticalMarks}\\p{IsLm}\\p{IsSk}]+");

        /**
         * Tạo slug từ string (để dùng trong URL)
         */
        public static String createSlug(String input) {
            if (input == null || input.trim().isEmpty()) {
                return "";
            }

            String noWhitespace = input.trim().toLowerCase()
                    .replaceAll("\\s+", "-")
                    .replaceAll("[^\\w\\-]", "")
                    .replaceAll("\\-+", "-")
                    .replaceAll("^-|-$", "");

            return removeDiacritics(noWhitespace);
        }

        /**
         * Loại bỏ dấu tiếng Việt
         */
        public static String removeDiacritics(String str) {
            if (str == null) {
                return null;
            }
            String normalized = Normalizer.normalize(str, Normalizer.Form.NFD);
            return DIACRITICS_AND_FRIENDS.matcher(normalized).replaceAll("");
        }

        /**
         * Viết hoa chữ cái đầu
         */
        public static String capitalize(String str) {
            if (str == null || str.isEmpty()) {
                return str;
            }
            return str.substring(0, 1).toUpperCase() + str.substring(1).toLowerCase();
        }

        /**
         * Truncate string với ellipsis
         */
        public static String truncate(String str, int maxLength) {
            if (str == null || str.length() <= maxLength) {
                return str;
            }
            return str.substring(0, maxLength - 3) + "...";
        }
    }

    // ===== FORMATTING UTILITIES =====

    /**
     * Formatting utilities inner class
     */
    public static class FormatUtils {

        private static final DecimalFormat PRICE_FORMAT = new DecimalFormat("#,###");
        private static final DecimalFormat PERCENTAGE_FORMAT = new DecimalFormat("0.0");

        /**
         * Format giá tiền VND
         */
        public static String formatPrice(Double price) {
            if (price == null || price == 0.0) {
                return "Miễn phí";
            }
            return PRICE_FORMAT.format(price) + " VND";
        }

        /**
         * Format phần trăm
         */
        public static String formatPercentage(double percentage) {
            return PERCENTAGE_FORMAT.format(percentage) + "%";
        }

        /**
         * Format thời lượng (phút)
         */
        public static String formatDuration(Integer minutes) {
            if (minutes == null || minutes == 0) {
                return "Chưa xác định";
            }

            if (minutes < 60) {
                return minutes + " phút";
            } else {
                int hours = minutes / 60;
                int remainingMinutes = minutes % 60;
                return hours + " giờ " + remainingMinutes + " phút";
            }
        }

        /**
         * Format difficulty level
         */
        public static String formatDifficultyLevel(String level) {
            if (level == null) {
                return "Không xác định";
            }

            return switch (level.toUpperCase()) {
                case "BEGINNER" -> "Cơ bản";
                case "INTERMEDIATE" -> "Trung bình";
                case "ADVANCED" -> "Nâng cao";
                default -> level;
            };
        }

        /**
         * Get Bootstrap badge class cho difficulty level
         */
        public static String getDifficultyBadgeClass(String level) {
            if (level == null) {
                return "badge-secondary";
            }

            return switch (level.toUpperCase()) {
                case "BEGINNER" -> "badge-success";
                case "INTERMEDIATE" -> "badge-warning";
                case "ADVANCED" -> "badge-danger";
                default -> "badge-secondary";
            };
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
     * File utilities inner class
     */
    public static class FileUtils {

        /**
         * Kiểm tra file size có hợp lệ không (overloaded method)
         */
        public static boolean isValidFileSize(MultipartFile file, int maxSizeBytes) {
            if (file == null || file.isEmpty()) {
                return false;
            }
            return file.getSize() <= maxSizeBytes;
        }

        /**
         * Tạo tên file unique (static wrapper)
         */
        public static String generateUniqueFilename(String originalFileName) {
            return CourseUtils.generateUniqueFilename(originalFileName);
        }

        /**
         * Lưu file (static wrapper)
         */
        public static String saveFile(MultipartFile file, String uploadDirectory, String filename) throws IOException {
            return CourseUtils.saveFile(file, uploadDirectory, filename);
        }

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

    /**
     * Validation utilities inner class
     */
    public static class ValidationUtils {

        private static final Pattern EMAIL_PATTERN =
                Pattern.compile("^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\\.[A-Za-z]{2,})$");

        private static final Pattern USERNAME_PATTERN =
                Pattern.compile("^[a-zA-Z0-9._-]{3,20}$");

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
    }
}