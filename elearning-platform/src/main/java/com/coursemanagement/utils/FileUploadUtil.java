package com.coursemanagement.utils;

import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

/**
 * Utility class cho việc xử lý upload và quản lý files
 * Hỗ trợ validation, generate filename và save file
 */
public class FileUploadUtil {

    // Các extension cho phép cho hình ảnh
    private static final List<String> ALLOWED_IMAGE_EXTENSIONS = Arrays.asList(
            "jpg", "jpeg", "png", "gif", "bmp", "webp"
    );

    // Các extension cho phép cho documents
    private static final List<String> ALLOWED_DOCUMENT_EXTENSIONS = Arrays.asList(
            "pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx", "txt"
    );

    // Các extension cho phép cho video
    private static final List<String> ALLOWED_VIDEO_EXTENSIONS = Arrays.asList(
            "mp4", "avi", "mov", "wmv", "flv", "webm"
    );

    // Size tối đa cho từng loại file (MB)
    private static final int MAX_IMAGE_SIZE_MB = 5;
    private static final int MAX_DOCUMENT_SIZE_MB = 20;
    private static final int MAX_VIDEO_SIZE_MB = 500;

    /**
     * Kiểm tra file size có hợp lệ không
     * @param file File cần kiểm tra
     * @param maxSizeMB Kích thước tối đa tính bằng MB
     * @return true nếu file size hợp lệ
     */
    public static boolean isValidFileSize(MultipartFile file, int maxSizeMB) {
        if (file == null || file.isEmpty()) {
            return false;
        }

        long maxSizeBytes = maxSizeMB * 1024 * 1024L; // Convert MB to bytes
        return file.getSize() <= maxSizeBytes;
    }

    /**
     * Kiểm tra extension của file có được phép không
     * @param filename Tên file
     * @param allowedExtensions Danh sách extensions được phép
     * @return true nếu extension hợp lệ
     */
    public static boolean isValidFileExtension(String filename, List<String> allowedExtensions) {
        if (filename == null || filename.isEmpty()) {
            return false;
        }

        String extension = getFileExtension(filename);
        return allowedExtensions.contains(extension.toLowerCase());
    }

    /**
     * Kiểm tra file hình ảnh có hợp lệ không
     * @param file File cần kiểm tra
     * @return true nếu là hình ảnh hợp lệ
     */
    public static boolean isValidImage(MultipartFile file) {
        return isValidFileSize(file, MAX_IMAGE_SIZE_MB) &&
                isValidFileExtension(file.getOriginalFilename(), ALLOWED_IMAGE_EXTENSIONS);
    }

    /**
     * Kiểm tra file document có hợp lệ không
     * @param file File cần kiểm tra
     * @return true nếu là document hợp lệ
     */
    public static boolean isValidDocument(MultipartFile file) {
        return isValidFileSize(file, MAX_DOCUMENT_SIZE_MB) &&
                isValidFileExtension(file.getOriginalFilename(), ALLOWED_DOCUMENT_EXTENSIONS);
    }

    /**
     * Kiểm tra file video có hợp lệ không
     * @param file File cần kiểm tra
     * @return true nếu là video hợp lệ
     */
    public static boolean isValidVideo(MultipartFile file) {
        return isValidFileSize(file, MAX_VIDEO_SIZE_MB) &&
                isValidFileExtension(file.getOriginalFilename(), ALLOWED_VIDEO_EXTENSIONS);
    }

    /**
     * Lấy extension của file
     * @param filename Tên file
     * @return Extension của file (không bao gồm dấu chấm)
     */
    public static String getFileExtension(String filename) {
        if (filename == null || filename.isEmpty()) {
            return "";
        }

        int lastDotIndex = filename.lastIndexOf('.');
        if (lastDotIndex == -1 || lastDotIndex == filename.length() - 1) {
            return "";
        }

        return filename.substring(lastDotIndex + 1);
    }

    /**
     * Generate unique filename để tránh trùng lặp
     * @param originalFilename Tên file gốc
     * @return Tên file unique mới
     */
    public static String generateUniqueFilename(String originalFilename) {
        if (originalFilename == null || originalFilename.isEmpty()) {
            return UUID.randomUUID().toString();
        }

        String extension = getFileExtension(originalFilename);
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
        String uniqueId = UUID.randomUUID().toString().substring(0, 8);

        if (extension.isEmpty()) {
            return String.format("%s_%s", timestamp, uniqueId);
        } else {
            return String.format("%s_%s.%s", timestamp, uniqueId, extension);
        }
    }

    /**
     * Generate filename với prefix
     * @param originalFilename Tên file gốc
     * @param prefix Prefix cho file name
     * @return Tên file với prefix
     */
    public static String generateFilenameWithPrefix(String originalFilename, String prefix) {
        String uniqueFilename = generateUniqueFilename(originalFilename);
        return prefix + "_" + uniqueFilename;
    }

    /**
     * Save file vào directory chỉ định
     * @param file File cần save
     * @param uploadDirectory Directory để save
     * @param filename Tên file (nếu null sẽ tự generate)
     * @return Đường dẫn file đã save
     * @throws IOException Nếu có lỗi khi save file
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

        // Save file
        try (InputStream inputStream = file.getInputStream()) {
            Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
        }

        return filePath.toString();
    }

    /**
     * Save file với validation
     * @param file File cần save
     * @param uploadDirectory Directory để save
     * @param filename Tên file
     * @param fileType Loại file (image, document, video)
     * @return Đường dẫn file đã save
     * @throws IOException Nếu có lỗi khi save file
     * @throws IllegalArgumentException Nếu file không hợp lệ
     */
    public static String saveFileWithValidation(MultipartFile file, String uploadDirectory,
                                                String filename, String fileType) throws IOException {
        // Validate file theo loại
        boolean isValid = switch (fileType.toLowerCase()) {
            case "image" -> isValidImage(file);
            case "document" -> isValidDocument(file);
            case "video" -> isValidVideo(file);
            default -> throw new IllegalArgumentException("Loại file không được hỗ trợ: " + fileType);
        };

        if (!isValid) {
            throw new IllegalArgumentException("File không hợp lệ cho loại: " + fileType);
        }

        return saveFile(file, uploadDirectory, filename);
    }

    /**
     * Xóa file khỏi hệ thống
     * @param filePath Đường dẫn file cần xóa
     * @return true nếu xóa thành công
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
     * Kiểm tra file có tồn tại không
     * @param filePath Đường dẫn file
     * @return true nếu file tồn tại
     */
    public static boolean fileExists(String filePath) {
        if (filePath == null || filePath.isEmpty()) {
            return false;
        }

        return Files.exists(Paths.get(filePath));
    }

    /**
     * Lấy kích thước file
     * @param filePath Đường dẫn file
     * @return Kích thước file tính bằng bytes, -1 nếu file không tồn tại
     */
    public static long getFileSize(String filePath) {
        if (filePath == null || filePath.isEmpty()) {
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
     * Convert bytes thành human readable format
     * @param bytes Số bytes
     * @return String format human readable (VD: 1.5 MB)
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

    /**
     * Tạo URL để truy cập file
     * @param filename Tên file
     * @param baseUrl Base URL của application
     * @param uploadDirectory Directory chứa file
     * @return URL đầy đủ để truy cập file
     */
    public static String generateFileUrl(String filename, String baseUrl, String uploadDirectory) {
        if (filename == null || filename.isEmpty()) {
            return null;
        }

        // Remove leading slash nếu có
        if (uploadDirectory.startsWith("/")) {
            uploadDirectory = uploadDirectory.substring(1);
        }

        // Remove trailing slash from base URL
        if (baseUrl.endsWith("/")) {
            baseUrl = baseUrl.substring(0, baseUrl.length() - 1);
        }

        return String.format("%s/%s/%s", baseUrl, uploadDirectory, filename);
    }
}