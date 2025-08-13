package com.coursemanagement.utils;

import java.util.regex.Pattern;

/**
 * Utility class cho các validation methods
 * Được sử dụng trong CourseUtils và các DTOs
 */
public class ValidationUtils {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\\.[A-Za-z]{2,})$");

    private static final Pattern USERNAME_PATTERN =
            Pattern.compile("^[a-zA-Z0-9._-]{3,20}$");

    private static final Pattern PHONE_PATTERN =
            Pattern.compile("^(\\+84|0)[0-9]{9,10}$");

    private static final Pattern PASSWORD_PATTERN =
            Pattern.compile("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d@$!%*?&]{6,}$");

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
     * Validate strong password (có chữ hoa, chữ thường, số)
     * @param password Password cần validate
     * @return true nếu đủ mạnh
     */
    public static boolean isStrongPassword(String password) {
        return password != null && PASSWORD_PATTERN.matcher(password).matches();
    }

    /**
     * Validate phone number
     * @param phone Phone cần validate
     * @return true nếu hợp lệ
     */
    public static boolean isValidPhone(String phone) {
        return phone != null && PHONE_PATTERN.matcher(phone).matches();
    }

    /**
     * Validate URL
     * @param url URL cần validate
     * @return true nếu hợp lệ
     */
    public static boolean isValidUrl(String url) {
        if (url == null || url.trim().isEmpty()) {
            return false;
        }

        try {
            new java.net.URL(url);
            return true;
        } catch (java.net.MalformedURLException e) {
            return false;
        }
    }

    /**
     * Validate required string
     * @param value String cần validate
     * @return true nếu không null và không empty
     */
    public static boolean isNotEmpty(String value) {
        return value != null && !value.trim().isEmpty();
    }

    /**
     * Validate string length
     * @param value String cần validate
     * @param minLength Độ dài tối thiểu
     * @param maxLength Độ dài tối đa
     * @return true nếu độ dài hợp lệ
     */
    public static boolean isValidLength(String value, int minLength, int maxLength) {
        if (value == null) {
            return false;
        }
        int length = value.trim().length();
        return length >= minLength && length <= maxLength;
    }

    /**
     * Validate positive number
     * @param value Number cần validate
     * @return true nếu > 0
     */
    public static boolean isPositive(Number value) {
        return value != null && value.doubleValue() > 0;
    }

    /**
     * Validate non-negative number
     * @param value Number cần validate
     * @return true nếu >= 0
     */
    public static boolean isNonNegative(Number value) {
        return value != null && value.doubleValue() >= 0;
    }

    /**
     * Validate number range
     * @param value Number cần validate
     * @param min Giá trị tối thiểu
     * @param max Giá trị tối đa
     * @return true nếu trong khoảng
     */
    public static boolean isInRange(Number value, double min, double max) {
        if (value == null) {
            return false;
        }
        double val = value.doubleValue();
        return val >= min && val <= max;
    }

    /**
     * Validate Vietnamese name
     * @param name Name cần validate
     * @return true nếu hợp lệ
     */
    public static boolean isValidVietnameseName(String name) {
        if (name == null || name.trim().isEmpty()) {
            return false;
        }

        // Pattern cho tên tiếng Việt (có dấu)
        String vietnamesePattern = "^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẾỀỂỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪỬỮỰỲỴÝỶỸưăạảấầẩẫậắằẳẵặẹẻếềểễệỉịọỏốồổỗộớờởỡợụủứừửữựỳỵýỷỹ\\s]{2,50}$";
        return Pattern.matches(vietnamesePattern, name.trim());
    }

    /**
     * Validate slug (URL-friendly string)
     * @param slug Slug cần validate
     * @return true nếu hợp lệ
     */
    public static boolean isValidSlug(String slug) {
        if (slug == null || slug.trim().isEmpty()) {
            return false;
        }

        String slugPattern = "^[a-z0-9-]+$";
        return Pattern.matches(slugPattern, slug.trim()) &&
                !slug.startsWith("-") &&
                !slug.endsWith("-") &&
                !slug.contains("--");
    }

    /**
     * Validate file extension
     * @param filename Filename
     * @param allowedExtensions Danh sách extensions cho phép
     * @return true nếu extension hợp lệ
     */
    public static boolean hasValidExtension(String filename, String... allowedExtensions) {
        if (filename == null || filename.trim().isEmpty()) {
            return false;
        }

        String extension = "";
        int lastDotIndex = filename.lastIndexOf(".");
        if (lastDotIndex > 0) {
            extension = filename.substring(lastDotIndex + 1).toLowerCase();
        }

        for (String allowed : allowedExtensions) {
            if (extension.equals(allowed.toLowerCase())) {
                return true;
            }
        }

        return false;
    }

    /**
     * Validate price (course price)
     * @param price Price cần validate
     * @return true nếu hợp lệ
     */
    public static boolean isValidPrice(Double price) {
        return price != null && price >= 0 && price <= 10000000; // Max 10 triệu VNĐ
    }

    /**
     * Validate duration (in minutes)
     * @param duration Duration cần validate
     * @return true nếu hợp lệ
     */
    public static boolean isValidDuration(Integer duration) {
        return duration != null && duration > 0 && duration <= 10000; // Max ~167 hours
    }

    /**
     * Validate quiz score
     * @param score Score cần validate
     * @param maxScore Max possible score
     * @return true nếu hợp lệ
     */
    public static boolean isValidScore(Double score, Double maxScore) {
        if (score == null || maxScore == null) {
            return false;
        }
        return score >= 0 && score <= maxScore;
    }

    /**
     * Validate percentage (0-100)
     * @param percentage Percentage cần validate
     * @return true nếu hợp lệ
     */
    public static boolean isValidPercentage(Double percentage) {
        return percentage != null && percentage >= 0 && percentage <= 100;
    }
}