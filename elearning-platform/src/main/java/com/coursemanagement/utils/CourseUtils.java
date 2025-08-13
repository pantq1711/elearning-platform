package com.coursemanagement.utils;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;

/**
 * Utility class chứa các helper methods cho ứng dụng Course Management
 * Bao gồm: string processing, file handling, validation, security utilities
 */
public class CourseUtils {

    /**
     * String Utilities Class
     * Các method xử lý chuỗi, slug, validation
     */
    public static class StringUtils {

        private static final Pattern SLUG_PATTERN = Pattern.compile("^[a-z0-9]+(?:-[a-z0-9]+)*$");
        private static final String VIETNAMESE_CHARS = "àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ";
        private static final String ENGLISH_CHARS = "aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd";

        /**
         * Tạo slug từ chuỗi tiếng Việt
         * VD: "Khóa học Java" -> "khoa-hoc-java"
         */
        public static String createSlug(String input) {
            if (!hasText(input)) {
                return "";
            }

            String slug = input.toLowerCase().trim();

            // Chuyển đổi ký tự tiếng Việt thành ký tự không dấu
            for (int i = 0; i < VIETNAMESE_CHARS.length(); i++) {
                slug = slug.replace(VIETNAMESE_CHARS.charAt(i), ENGLISH_CHARS.charAt(i));
            }

            // Thay thế ký tự đặc biệt bằng dấu gạch ngang
            slug = slug.replaceAll("[^a-z0-9\\s-]", "");

            // Thay thế khoảng trắng và nhiều dấu gạch ngang liên tiếp
            slug = slug.replaceAll("\\s+", "-");
            slug = slug.replaceAll("-+", "-");

            // Loại bỏ dấu gạch ngang ở đầu và cuối
            slug = slug.replaceAll("^-|-$", "");

            return slug;
        }

        /**
         * Kiểm tra chuỗi có nội dung hay không (không null và không rỗng)
         */
        public static boolean hasText(String str) {
            return str != null && !str.trim().isEmpty();
        }

        /**
         * Validate slug format
         */
        public static boolean isValidSlug(String slug) {
            return hasText(slug) && SLUG_PATTERN.matcher(slug).matches();
        }

        /**
         * Truncate chuỗi với suffix
         */
        public static String truncate(String str, int maxLength, String suffix) {
            if (!hasText(str) || str.length() <= maxLength) {
                return str;
            }

            suffix = suffix != null ? suffix : "...";
            return str.substring(0, maxLength - suffix.length()) + suffix;
        }

        /**
         * Truncate chuỗi với suffix mặc định là "..."
         */
        public static String truncate(String str, int maxLength) {
            return truncate(str, maxLength, "...");
        }

        /**
         * Capitalize từ đầu tiên của mỗi từ
         */
        public static String capitalizeWords(String str) {
            if (!hasText(str)) {
                return str;
            }

            String[] words = str.toLowerCase().split("\\s+");
            StringBuilder result = new StringBuilder();

            for (int i = 0; i < words.length; i++) {
                if (i > 0) {
                    result.append(" ");
                }

                String word = words[i];
                if (word.length() > 0) {
                    result.append(Character.toUpperCase(word.charAt(0)));
                    if (word.length() > 1) {
                        result.append(word.substring(1));
                    }
                }
            }

            return result.toString();
        }

        /**
         * Loại bỏ HTML tags khỏi chuỗi
         */
        public static String stripHtml(String str) {
            if (!hasText(str)) {
                return str;
            }
            return str.replaceAll("<[^>]*>", "").trim();
        }

        /**
         * Tạo excerpt từ nội dung dài
         */
        public static String createExcerpt(String content, int maxLength) {
            if (!hasText(content)) {
                return "";
            }

            // Loại bỏ HTML tags trước
            String plainText = stripHtml(content);

            // Truncate và đảm bảo không cắt giữa từ
            if (plainText.length() <= maxLength) {
                return plainText;
            }

            String truncated = plainText.substring(0, maxLength);
            int lastSpace = truncated.lastIndexOf(' ');

            if (lastSpace > 0) {
                truncated = truncated.substring(0, lastSpace);
            }

            return truncated + "...";
        }
    }

    /**
     * Date Time Utilities Class
     * Các method xử lý ngày tháng, thời gian
     */
    public static class DateTimeUtils {

        private static final DateTimeFormatter DEFAULT_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");
        private static final DateTimeFormatter ISO_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

        /**
         * Format LocalDateTime thành chuỗi với format mặc định
         */
        public static String formatDateTime(LocalDateTime dateTime) {
            return dateTime != null ? dateTime.format(DEFAULT_FORMATTER) : "";
        }

        /**
         * Format LocalDateTime thành chuỗi ngày
         */
        public static String formatDate(LocalDateTime dateTime) {
            return dateTime != null ? dateTime.format(DATE_FORMATTER) : "";
        }

        /**
         * Format LocalDateTime thành chuỗi giờ
         */
        public static String formatTime(LocalDateTime dateTime) {
            return dateTime != null ? dateTime.format(TIME_FORMATTER) : "";
        }

        /**
         * Format LocalDateTime thành ISO string
         */
        public static String formatIso(LocalDateTime dateTime) {
            return dateTime != null ? dateTime.format(ISO_FORMATTER) : "";
        }

        /**
         * Tính thời gian tương đối (time ago)
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
            } else if (minutes < 1440) { // 24 hours
                long hours = minutes / 60;
                return hours + " giờ trước";
            } else if (minutes < 43200) { // 30 days
                long days = minutes / 1440;
                return days + " ngày trước";
            } else {
                return formatDate(dateTime);
            }
        }

        /**
         * Kiểm tra ngày có phải hôm nay không
         */
        public static boolean isToday(LocalDateTime dateTime) {
            if (dateTime == null) {
                return false;
            }

            LocalDateTime now = LocalDateTime.now();
            return dateTime.toLocalDate().equals(now.toLocalDate());
        }

        /**
         * Kiểm tra ngày có phải hôm qua không
         */
        public static boolean isYesterday(LocalDateTime dateTime) {
            if (dateTime == null) {
                return false;
            }

            LocalDateTime yesterday = LocalDateTime.now().minusDays(1);
            return dateTime.toLocalDate().equals(yesterday.toLocalDate());
        }
    }

    /**
     * Validation Utilities Class
     * Các method validation cho input data
     */
    public static class ValidationUtils {

        private static final Pattern EMAIL_PATTERN = Pattern.compile(
                "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$");

        private static final Pattern PHONE_PATTERN = Pattern.compile(
                "^(\\+84|0)[0-9]{9,10}$");

        private static final Pattern USERNAME_PATTERN = Pattern.compile(
                "^[a-zA-Z0-9_]{3,20}$");

        /**
         * Validate email format
         */
        public static boolean isValidEmail(String email) {
            return StringUtils.hasText(email) && EMAIL_PATTERN.matcher(email).matches();
        }

        /**
         * Validate số điện thoại Việt Nam
         */
        public static boolean isValidPhoneNumber(String phone) {
            return StringUtils.hasText(phone) && PHONE_PATTERN.matcher(phone).matches();
        }

        /**
         * Validate username format
         */
        public static boolean isValidUsername(String username) {
            return StringUtils.hasText(username) && USERNAME_PATTERN.matcher(username).matches();
        }

        /**
         * Validate password strength
         */
        public static boolean isStrongPassword(String password) {
            if (!StringUtils.hasText(password) || password.length() < 8) {
                return false;
            }

            boolean hasUpper = password.matches(".*[A-Z].*");
            boolean hasLower = password.matches(".*[a-z].*");
            boolean hasDigit = password.matches(".*\\d.*");
            boolean hasSpecial = password.matches(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*");

            return hasUpper && hasLower && hasDigit && hasSpecial;
        }

        /**
         * Validate URL format
         */
        public static boolean isValidUrl(String url) {
            if (!StringUtils.hasText(url)) {
                return false;
            }

            try {
                new java.net.URL(url);
                return url.startsWith("http://") || url.startsWith("https://");
            } catch (Exception e) {
                return false;
            }
        }

        /**
         * Validate YouTube URL
         */
        public static boolean isValidYouTubeUrl(String url) {
            if (!isValidUrl(url)) {
                return false;
            }

            return url.contains("youtube.com/watch") || url.contains("youtu.be/");
        }
    }

    /**
     * File Utilities Class
     * Các method xử lý file upload, validation
     */
    public static class FileUtils {

        // Các extension được phép cho từng loại file
        private static final List<String> ALLOWED_IMAGE_EXTENSIONS =
                Arrays.asList("jpg", "jpeg", "png", "gif", "webp");

        private static final List<String> ALLOWED_DOCUMENT_EXTENSIONS =
                Arrays.asList("pdf", "doc", "docx", "txt", "rtf");

        private static final List<String> ALLOWED_VIDEO_EXTENSIONS =
                Arrays.asList("mp4", "avi", "mov", "wmv", "flv");

        // Kích thước file tối đa (bytes)
        private static final long MAX_IMAGE_SIZE = 5 * 1024 * 1024; // 5MB
        private static final long MAX_DOCUMENT_SIZE = 10 * 1024 * 1024; // 10MB
        private static final long MAX_VIDEO_SIZE = 100 * 1024 * 1024; // 100MB

        /**
         * Lấy file extension từ tên file
         */
        public static String getFileExtension(String filename) {
            if (!StringUtils.hasText(filename)) {
                return "";
            }

            int lastDot = filename.lastIndexOf('.');
            return lastDot != -1 ? filename.substring(lastDot + 1).toLowerCase() : "";
        }

        /**
         * Validate file image
         */
        public static boolean isValidImageFile(MultipartFile file) {
            if (file == null || file.isEmpty()) {
                return false;
            }

            String extension = getFileExtension(file.getOriginalFilename());
            return ALLOWED_IMAGE_EXTENSIONS.contains(extension) &&
                    file.getSize() <= MAX_IMAGE_SIZE;
        }

        /**
         * Validate file document
         */
        public static boolean isValidDocumentFile(MultipartFile file) {
            if (file == null || file.isEmpty()) {
                return false;
            }

            String extension = getFileExtension(file.getOriginalFilename());
            return ALLOWED_DOCUMENT_EXTENSIONS.contains(extension) &&
                    file.getSize() <= MAX_DOCUMENT_SIZE;
        }

        /**
         * Validate file video
         */
        public static boolean isValidVideoFile(MultipartFile file) {
            if (file == null || file.isEmpty()) {
                return false;
            }

            String extension = getFileExtension(file.getOriginalFilename());
            return ALLOWED_VIDEO_EXTENSIONS.contains(extension) &&
                    file.getSize() <= MAX_VIDEO_SIZE;
        }

        /**
         * Tạo tên file unique để tránh trùng lặp
         */
        public static String generateUniqueFilename(String originalFilename) {
            if (!StringUtils.hasText(originalFilename)) {
                return "file_" + System.currentTimeMillis();
            }

            String extension = getFileExtension(originalFilename);
            String nameWithoutExtension = originalFilename.substring(0,
                    originalFilename.lastIndexOf('.') == -1 ? originalFilename.length() : originalFilename.lastIndexOf('.'));

            String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
            String randomString = SecurityUtils.generateRandomString(6);

            return StringUtils.createSlug(nameWithoutExtension) + "_" + timestamp + "_" + randomString +
                    (StringUtils.hasText(extension) ? "." + extension : "");
        }

        /**
         * Validate kích thước file
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
                System.err.println("Lỗi khi tạo thư mục: " + e.getMessage());
                return false;
            }
        }

        /**
         * Lưu file vào thư mục chỉ định với error handling tốt hơn
         */
        public static String saveFile(MultipartFile file, String uploadDir, String filename) throws IOException {
            if (file == null || file.isEmpty()) {
                throw new IllegalArgumentException("File không được để trống");
            }

            if (!StringUtils.hasText(filename)) {
                throw new IllegalArgumentException("Tên file không hợp lệ");
            }

            // Tạo thư mục nếu chưa tồn tại
            if (!createDirectoryIfNotExists(uploadDir)) {
                throw new IOException("Không thể tạo thư mục upload: " + uploadDir);
            }

            Path filePath = Paths.get(uploadDir, filename);

            try {
                Files.copy(file.getInputStream(), filePath);
                return filePath.toString();
            } catch (IOException e) {
                throw new IOException("Lỗi khi lưu file: " + e.getMessage(), e);
            }
        }

        /**
         * Xóa file
         */
        public static boolean deleteFile(String filePath) {
            try {
                if (StringUtils.hasText(filePath)) {
                    Path path = Paths.get(filePath);
                    return Files.deleteIfExists(path);
                }
                return false;
            } catch (IOException e) {
                System.err.println("Lỗi khi xóa file: " + e.getMessage());
                return false;
            }
        }

        /**
         * Lấy kích thước file readable (KB, MB, GB)
         */
        public static String getReadableFileSize(long bytes) {
            if (bytes <= 0) return "0 B";

            String[] units = {"B", "KB", "MB", "GB", "TB"};
            int digitGroups = (int) (Math.log10(bytes) / Math.log10(1024));

            return String.format("%.1f %s",
                    bytes / Math.pow(1024, digitGroups),
                    units[digitGroups]);
        }
    }

    /**
     * Security Utilities Class
     * Các method liên quan đến bảo mật
     */
    public static class SecurityUtils {

        private static final String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        private static final String UPPERCASE = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        private static final String LOWERCASE = "abcdefghijklmnopqrstuvwxyz";
        private static final String NUMBERS = "0123456789";
        private static final String SPECIAL_CHARS = "!@#$%^&*()_+-=[]{}|;:,.<>?";

        private static final SecureRandom random = new SecureRandom();

        /**
         * Tạo random string với charset tùy chỉnh
         */
        public static String generateRandomString(int length) {
            return generateRandomString(length, CHARACTERS);
        }

        /**
         * Tạo random string với charset được chỉ định
         */
        public static String generateRandomString(int length, String charset) {
            if (length <= 0 || !StringUtils.hasText(charset)) {
                throw new IllegalArgumentException("Length phải > 0 và charset không được rỗng");
            }

            StringBuilder sb = new StringBuilder(length);
            for (int i = 0; i < length; i++) {
                sb.append(charset.charAt(random.nextInt(charset.length())));
            }
            return sb.toString();
        }

        /**
         * Tạo password ngẫu nhiên mạnh
         */
        public static String generateStrongPassword(int length) {
            if (length < 8) {
                throw new IllegalArgumentException("Password phải có ít nhất 8 ký tự");
            }

            StringBuilder password = new StringBuilder();

            // Đảm bảo có ít nhất 1 ký tự từ mỗi loại
            password.append(UPPERCASE.charAt(random.nextInt(UPPERCASE.length())));
            password.append(LOWERCASE.charAt(random.nextInt(LOWERCASE.length())));
            password.append(NUMBERS.charAt(random.nextInt(NUMBERS.length())));
            password.append(SPECIAL_CHARS.charAt(random.nextInt(SPECIAL_CHARS.length())));

            // Fill phần còn lại
            String allChars = UPPERCASE + LOWERCASE + NUMBERS + SPECIAL_CHARS;
            for (int i = 4; i < length; i++) {
                password.append(allChars.charAt(random.nextInt(allChars.length())));
            }

            // Shuffle password
            return shuffleString(password.toString());
        }

        /**
         * Shuffle string
         */
        private static String shuffleString(String str) {
            char[] chars = str.toCharArray();
            for (int i = chars.length - 1; i > 0; i--) {
                int j = random.nextInt(i + 1);
                char temp = chars[i];
                chars[i] = chars[j];
                chars[j] = temp;
            }
            return new String(chars);
        }

        /**
         * Sanitize string để tránh XSS
         */
        public static String sanitizeHtml(String input) {
            if (!StringUtils.hasText(input)) {
                return input;
            }

            return input
                    .replaceAll("<", "&lt;")
                    .replaceAll(">", "&gt;")
                    .replaceAll("\"", "&quot;")
                    .replaceAll("'", "&#x27;")
                    .replaceAll("/", "&#x2F;");
        }

        /**
         * Tạo verification token
         */
        public static String generateVerificationToken() {
            return generateRandomString(32, CHARACTERS);
        }

        /**
         * Tạo API key
         */
        public static String generateApiKey() {
            return "api_" + generateRandomString(40, CHARACTERS);
        }
    }
}