package com.coursemanagement.utils;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.SecureRandom;
import java.text.Normalizer;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.regex.Pattern;

/**
 * Các utility classes hỗ trợ cho hệ thống e-learning
 * Bao gồm string utils, validation, file handling, security utils
 */
public class CourseUtils {

    // Patterns cho validation
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
    );

    private static final Pattern PHONE_PATTERN = Pattern.compile(
            "^(\\+84|0)[0-9]{9,10}$"
    );

    private static final Pattern USERNAME_PATTERN = Pattern.compile(
            "^[a-zA-Z0-9._-]{3,20}$"
    );

    // Allowed file extensions
    private static final Set<String> ALLOWED_IMAGE_EXTENSIONS = Set.of(
            "jpg", "jpeg", "png", "gif", "webp"
    );

    private static final Set<String> ALLOWED_DOCUMENT_EXTENSIONS = Set.of(
            "pdf", "doc", "docx", "ppt", "pptx", "txt"
    );

    /**
     * String Utilities Class
     * Xử lý các thao tác với string
     */
    public static class StringUtils {

        /**
         * Kiểm tra string có null hoặc empty không
         */
        public static boolean isNullOrEmpty(String str) {
            return str == null || str.trim().isEmpty();
        }

        /**
         * Kiểm tra string có giá trị không
         */
        public static boolean hasText(String str) {
            return !isNullOrEmpty(str);
        }

        /**
         * Tạo slug từ tiếng Việt có dấu
         * VD: "Khóa học Java" -> "khoa-hoc-java"
         */
        public static String createSlug(String input) {
            if (isNullOrEmpty(input)) {
                return "";
            }

            // Chuyển về lowercase
            String slug = input.toLowerCase();

            // Thay thế các ký tự tiếng Việt
            slug = slug.replaceAll("[àáạảãâầấậẩẫăằắặẳẵ]", "a");
            slug = slug.replaceAll("[èéẹẻẽêềếệểễ]", "e");
            slug = slug.replaceAll("[ìíịỉĩ]", "i");
            slug = slug.replaceAll("[òóọỏõôồốộổỗơờớợởỡ]", "o");
            slug = slug.replaceAll("[ùúụủũưừứựửữ]", "u");
            slug = slug.replaceAll("[ỳýỵỷỹ]", "y");
            slug = slug.replaceAll("đ", "d");

            // Xóa dấu
            slug = Normalizer.normalize(slug, Normalizer.Form.NFD);
            slug = slug.replaceAll("\\p{InCombiningDiacriticalMarks}+", "");

            // Thay thế ký tự đặc biệt bằng dấu gạch ngang
            slug = slug.replaceAll("[^a-z0-9\\s-]", "");
            slug = slug.replaceAll("\\s+", "-");
            slug = slug.replaceAll("-+", "-");
            slug = slug.replaceAll("^-|-$", "");

            return slug;
        }

        /**
         * Rút ngắn text với "..." ở cuối
         */
        public static String truncate(String text, int maxLength) {
            if (isNullOrEmpty(text) || text.length() <= maxLength) {
                return text;
            }
            return text.substring(0, maxLength - 3) + "...";
        }

        /**
         * Tạo excerpt từ HTML content
         */
        public static String createExcerpt(String htmlContent, int maxLength) {
            if (isNullOrEmpty(htmlContent)) {
                return "";
            }

            // Xóa HTML tags
            String plainText = htmlContent.replaceAll("<[^>]+>", "");
            // Xóa whitespace thừa
            plainText = plainText.replaceAll("\\s+", " ").trim();

            return truncate(plainText, maxLength);
        }

        /**
         * Chuyển đổi sang Title Case
         * VD: "nguyễn văn an" -> "Nguyễn Văn An"
         */
        public static String toTitleCase(String input) {
            if (isNullOrEmpty(input)) {
                return input;
            }

            String[] words = input.toLowerCase().split("\\s+");
            StringBuilder result = new StringBuilder();

            for (String word : words) {
                if (word.length() > 0) {
                    result.append(Character.toUpperCase(word.charAt(0)))
                            .append(word.substring(1))
                            .append(" ");
                }
            }

            return result.toString().trim();
        }
    }

    /**
     * Validation Utilities Class
     * Các method validation dữ liệu
     */
    public static class ValidationUtils {

        /**
         * Validate email format
         */
        public static boolean isValidEmail(String email) {
            return StringUtils.hasText(email) && EMAIL_PATTERN.matcher(email).matches();
        }

        /**
         * Validate số điện thoại Việt Nam
         */
        public static boolean isValidPhone(String phone) {
            return StringUtils.hasText(phone) && PHONE_PATTERN.matcher(phone).matches();
        }

        /**
         * Validate username
         */
        public static boolean isValidUsername(String username) {
            return StringUtils.hasText(username) && USERNAME_PATTERN.matcher(username).matches();
        }

        /**
         * Validate password strength
         */
        public static boolean isValidPassword(String password) {
            if (StringUtils.isNullOrEmpty(password)) {
                return false;
            }

            return password.length() >= 6 &&
                    password.length() <= 100 &&
                    password.matches(".*\\d.*"); // Có ít nhất 1 số
        }

        /**
         * Validate course duration (phút)
         */
        public static boolean isValidDuration(Integer duration) {
            return duration != null && duration > 0 && duration <= 500; // Tối đa 8+ tiếng
        }

        /**
         * Validate quiz score
         */
        public static boolean isValidScore(Double score, Double maxScore) {
            return score != null && maxScore != null &&
                    score >= 0 && score <= maxScore;
        }
    }

    /**
     * File Utilities Class
     * Xử lý upload file, validate file
     */
    public static class FileUtils {

        /**
         * Lấy extension của file
         */
        public static String getFileExtension(String filename) {
            if (StringUtils.isNullOrEmpty(filename)) {
                return "";
            }

            int lastDotIndex = filename.lastIndexOf('.');
            return lastDotIndex == -1 ? "" : filename.substring(lastDotIndex + 1).toLowerCase();
        }

        /**
         * Kiểm tra file có phải image không
         */
        public static boolean isImageFile(MultipartFile file) {
            if (file == null || file.isEmpty()) {
                return false;
            }

            String extension = getFileExtension(file.getOriginalFilename());
            return ALLOWED_IMAGE_EXTENSIONS.contains(extension);
        }

        /**
         * Kiểm tra file có phải document không
         */
        public static boolean isDocumentFile(MultipartFile file) {
            if (file == null || file.isEmpty()) {
                return false;
            }

            String extension = getFileExtension(file.getOriginalFilename());
            return ALLOWED_DOCUMENT_EXTENSIONS.contains(extension);
        }

        /**
         * Tạo filename unique để tránh trùng lặp
         */
        public static String generateUniqueFilename(String originalFilename) {
            if (StringUtils.isNullOrEmpty(originalFilename)) {
                return "file_" + System.currentTimeMillis();
            }

            String extension = getFileExtension(originalFilename);
            String nameWithoutExtension = originalFilename.substring(0,
                    originalFilename.lastIndexOf('.') == -1 ? originalFilename.length() : originalFilename.lastIndexOf('.'));

            String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
            String randomString = generateRandomString(6);

            return StringUtils.createSlug(nameWithoutExtension) + "_" + timestamp + "_" + randomString +
                    (StringUtils.hasText(extension) ? "." + extension : "");
        }

        /**
         * Validate file size
         */
        public static boolean isValidFileSize(MultipartFile file, long maxSizeInBytes) {
            return file != null && !file.isEmpty() && file.getSize() <= maxSizeInBytes;
        }

        /**
         * Tạo thư mục nếu chưa tồn tại
         */
        public static boolean createDirectoryIfNotExists(String directoryPath) {
            try {
                Path path = Paths.get(directoryPath);
                if (!Files.exists(path)) {
                    Files.createDirectories(path);
                }
                return true;
            } catch (IOException e) {
                return false;
            }
        }

        /**
         * Lưu file vào thư mục chỉ định
         */
        public static String saveFile(MultipartFile file, String uploadDir, String filename) throws IOException {
            if (file == null || file.isEmpty()) {
                throw new IllegalArgumentException("File không được để trống");
            }

            createDirectoryIfNotExists(uploadDir);

            Path filePath = Paths.get(uploadDir, filename);
            Files.copy(file.getInputStream(), filePath);

            return filePath.toString();
        }
    }

    /**
     * Security Utilities Class
     * Các method liên quan đến bảo mật
     */
    public static class SecurityUtils {

        private static final String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        private static final SecureRandom random = new SecureRandom();

        /**
         * Tạo random string
         */
        public static String generateRandomString(int length) {
            StringBuilder sb = new StringBuilder(length);
            for (int i = 0; i < length; i++) {
                sb.append(CHARACTERS.charAt(random.nextInt(CHARACTERS.length())));
            }
            return sb.toString();
        }

        /**
         * Tạo password ngẫu nhiên
         */
        public static String generateRandomPassword(int length) {
            String upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            String lowerCase = "abcdefghijklmnopqrstuvwxyz";
            String numbers = "0123456789";
            String specialChars = "!@#$%^&*";

            String allChars = upperCase + lowerCase + numbers + specialChars;

            StringBuilder password = new StringBuilder();

            // Đảm bảo có ít nhất 1 ký tự mỗi loại
            password.append(upperCase.charAt(random.nextInt(upperCase.length())));
            password.append(lowerCase.charAt(random.nextInt(lowerCase.length())));
            password.append(numbers.charAt(random.nextInt(numbers.length())));
            password.append(specialChars.charAt(random.nextInt(specialChars.length())));

            // Fill phần còn lại
            for (int i = 4; i < length; i++) {
                password.append(allChars.charAt(random.nextInt(allChars.length())));
            }

            // Shuffle password
            List<Character> passwordChars = new ArrayList<>();
            for (char c : password.toString().toCharArray()) {
                passwordChars.add(c);
            }
            Collections.shuffle(passwordChars);

            StringBuilder shuffledPassword = new StringBuilder();
            for (char c : passwordChars) {
                shuffledPassword.append(c);
            }

            return shuffledPassword.toString();
        }

        /**
         * Hash password với BCrypt
         */
        public static String hashPassword(String plainPassword) {
            BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(12);
            return encoder.encode(plainPassword);
        }

        /**
         * Verify password
         */
        public static boolean verifyPassword(String plainPassword, String hashedPassword) {
            BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
            return encoder.matches(plainPassword, hashedPassword);
        }

        /**
         * Tạo token ngẫu nhiên (cho reset password, verification, etc.)
         */
        public static String generateToken() {
            return generateRandomString(32);
        }
    }

    /**
     * Date Time Utilities Class
     * Xử lý date time
     */
    public static class DateTimeUtils {

        private static final DateTimeFormatter DEFAULT_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");

        /**
         * Format LocalDateTime thành string
         */
        public static String formatDateTime(LocalDateTime dateTime) {
            return dateTime != null ? dateTime.format(DEFAULT_FORMATTER) : "";
        }

        /**
         * Format chỉ ngày
         */
        public static String formatDate(LocalDateTime dateTime) {
            return dateTime != null ? dateTime.format(DATE_FORMATTER) : "";
        }

        /**
         * Format chỉ giờ
         */
        public static String formatTime(LocalDateTime dateTime) {
            return dateTime != null ? dateTime.format(TIME_FORMATTER) : "";
        }

        /**
         * Tính thời gian tương đối (VD: "2 giờ trước", "3 ngày trước")
         */
        public static String getTimeAgo(LocalDateTime dateTime) {
            if (dateTime == null) {
                return "";
            }

            LocalDateTime now = LocalDateTime.now();
            long minutes = java.time.Duration.between(dateTime, now).toMinutes();

            if (minutes < 1) {
                return "Vừa xong";
            } else if (minutes < 60) {
                return minutes + " phút trước";
            } else if (minutes < 1440) { // < 24 giờ
                long hours = minutes / 60;
                return hours + " giờ trước";
            } else if (minutes < 10080) { // < 7 ngày
                long days = minutes / 1440;
                return days + " ngày trước";
            } else if (minutes < 43200) { // < 30 ngày
                long weeks = minutes / 10080;
                return weeks + " tuần trước";
            } else {
                return formatDate(dateTime);
            }
        }

        /**
         * Kiểm tra có phải hôm nay không
         */
        public static boolean isToday(LocalDateTime dateTime) {
            if (dateTime == null) {
                return false;
            }

            LocalDateTime now = LocalDateTime.now();
            return dateTime.toLocalDate().equals(now.toLocalDate());
        }

        /**
         * Kiểm tra có phải tuần này không
         */
        public static boolean isThisWeek(LocalDateTime dateTime) {
            if (dateTime == null) {
                return false;
            }

            LocalDateTime now = LocalDateTime.now();
            return java.time.Duration.between(dateTime, now).toDays() < 7;
        }
    }

    /**
     * Course Utilities
     * Các method tiện ích riêng cho course management
     */
    public static class CourseHelper {

        /**
         * Tính toán percentage hoàn thành khóa học
         */
        public static int calculateProgress(int completedLessons, int totalLessons) {
            if (totalLessons == 0) {
                return 0;
            }
            return Math.min(100, (completedLessons * 100) / totalLessons);
        }

        /**
         * Format thời lượng khóa học (phút -> "X giờ Y phút")
         */
        public static String formatDuration(int totalMinutes) {
            if (totalMinutes < 60) {
                return totalMinutes + " phút";
            }

            int hours = totalMinutes / 60;
            int minutes = totalMinutes % 60;

            if (minutes == 0) {
                return hours + " giờ";
            }

            return hours + " giờ " + minutes + " phút";
        }

        /**
         * Tạo course code duy nhất
         */
        public static String generateCourseCode(String courseName) {
            String prefix = StringUtils.createSlug(courseName).toUpperCase();
            if (prefix.length() > 8) {
                prefix = prefix.substring(0, 8);
            }

            String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMM"));
            String randomPart = SecurityUtils.generateRandomString(4).toUpperCase();

            return prefix + "_" + timestamp + "_" + randomPart;
        }

        /**
         * Validate quiz passing score
         */
        public static boolean isQuizPassed(double score, double maxScore, double passPercentage) {
            if (maxScore == 0) {
                return false;
            }

            double percentage = (score / maxScore) * 100;
            return percentage >= passPercentage;
        }

        /**
         * Tính difficulty level dựa trên các metrics
         */
        public static String calculateDifficultyLevel(int totalLessons, int totalQuizzes, double avgQuizPassRate) {
            int complexityScore = 0;

            // Điểm dựa trên số bài học
            if (totalLessons > 20) complexityScore += 2;
            else if (totalLessons > 10) complexityScore += 1;

            // Điểm dựa trên số quiz
            if (totalQuizzes > 5) complexityScore += 2;
            else if (totalQuizzes > 2) complexityScore += 1;

            // Điểm dựa trên tỷ lệ pass quiz
            if (avgQuizPassRate < 60) complexityScore += 2;
            else if (avgQuizPassRate < 80) complexityScore += 1;

            if (complexityScore >= 4) return "ADVANCED";
            else if (complexityScore >= 2) return "INTERMEDIATE";
            else return "BEGINNER";
        }
    }

    // Private constructor để prevent instantiation
    private CourseUtils() {
        throw new UnsupportedOperationException("Utility class không thể instantiate");
    }

    // Helper method cho các class khác sử dụng
    public static String generateRandomString(int length) {
        return SecurityUtils.generateRandomString(length);
    }
}