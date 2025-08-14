package com.coursemanagement.utils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.text.DecimalFormat;
import java.util.List;

/**
 * Date Time Utilities
 * Cung cấp các helper methods cho xử lý ngày tháng
 */
public class DateTimeUtils {

    private static final DateTimeFormatter DEFAULT_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");
    private static final DateTimeFormatter ISO_FORMATTER = DateTimeFormatter.ISO_LOCAL_DATE_TIME;

    /**
     * Format LocalDateTime với format mặc định
     */
    public static String formatDateTime(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "";
        }
        return dateTime.format(DEFAULT_FORMATTER);
    }

    /**
     * Format LocalDateTime với format tùy chỉnh
     */
    public static String formatDateTime(LocalDateTime dateTime, String pattern) {
        if (dateTime == null) {
            return "";
        }
        return dateTime.format(DateTimeFormatter.ofPattern(pattern));
    }

    /**
     * Format chỉ ngày
     */
    public static String formatDate(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "";
        }
        return dateTime.format(DATE_FORMATTER);
    }

    /**
     * Format chỉ giờ
     */
    public static String formatTime(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "";
        }
        return dateTime.format(TIME_FORMATTER);
    }

    /**
     * Format ISO format
     */
    public static String formatIso(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "";
        }
        return dateTime.format(ISO_FORMATTER);
    }

    /**
     * Tính khoảng cách thời gian (time ago)
     */
    public static String getTimeAgo(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "";
        }

        LocalDateTime now = LocalDateTime.now();
        long minutes = ChronoUnit.MINUTES.between(dateTime, now);
        long hours = ChronoUnit.HOURS.between(dateTime, now);
        long days = ChronoUnit.DAYS.between(dateTime, now);

        if (minutes < 1) {
            return "Vừa xong";
        } else if (minutes < 60) {
            return minutes + " phút trước";
        } else if (hours < 24) {
            return hours + " giờ trước";
        } else if (days < 7) {
            return days + " ngày trước";
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
        return dateTime.toLocalDate().equals(LocalDateTime.now().toLocalDate());
    }

    /**
     * Kiểm tra có phải tuần này không
     */
    public static boolean isThisWeek(LocalDateTime dateTime) {
        if (dateTime == null) {
            return false;
        }
        LocalDateTime weekStart = LocalDateTime.now().minusDays(7);
        return dateTime.isAfter(weekStart);
    }
}

/**
 * Number Utilities
 * Cung cấp các helper methods cho xử lý số
 */
class NumberUtils {

    private static final DecimalFormat DECIMAL_FORMAT = new DecimalFormat("#,###.##");
    private static final DecimalFormat PERCENTAGE_FORMAT = new DecimalFormat("0.0%");
    private static final DecimalFormat CURRENCY_FORMAT = new DecimalFormat("#,###");

    /**
     * Format số với dấu phẩy phân cách
     */
    public static String formatNumber(Number number) {
        if (number == null) {
            return "0";
        }
        return DECIMAL_FORMAT.format(number);
    }

    /**
     * Format phần trăm
     */
    public static String formatPercentage(double value) {
        return PERCENTAGE_FORMAT.format(value / 100);
    }

    /**
     * Format tiền tệ VND
     */
    public static String formatCurrency(Number amount) {
        if (amount == null || amount.doubleValue() == 0) {
            return "Miễn phí";
        }
        return CURRENCY_FORMAT.format(amount) + " VND";
    }

    /**
     * Parse safe integer
     */
    public static int parseInt(String str, int defaultValue) {
        try {
            return Integer.parseInt(str);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    /**
     * Parse safe long
     */
    public static long parseLong(String str, long defaultValue) {
        try {
            return Long.parseLong(str);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    /**
     * Parse safe double
     */
    public static double parseDouble(String str, double defaultValue) {
        try {
            return Double.parseDouble(str);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    /**
     * Kiểm tra số có hợp lệ không
     */
    public static boolean isValidNumber(String str) {
        try {
            Double.parseDouble(str);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * Làm tròn đến n chữ số thập phân
     */
    public static double round(double value, int decimals) {
        double factor = Math.pow(10, decimals);
        return Math.round(value * factor) / factor;
    }
}

/**
 * Course Helper Utilities
 * Cung cấp các helper methods cho Course management
 */
class CourseHelper {

    /**
     * Tính completion rate
     */
    public static double calculateCompletionRate(int completed, int total) {
        if (total == 0) {
            return 0.0;
        }
        return NumberUtils.round((double) completed / total * 100, 1);
    }

    /**
     * Get difficulty color class
     */
    public static String getDifficultyColorClass(String difficulty) {
        if (difficulty == null) {
            return "text-secondary";
        }

        return switch (difficulty.toUpperCase()) {
            case "BEGINNER" -> "text-success";
            case "INTERMEDIATE" -> "text-warning";
            case "ADVANCED" -> "text-danger";
            default -> "text-secondary";
        };
    }

    /**
     * Get difficulty badge class
     */
    public static String getDifficultyBadgeClass(String difficulty) {
        if (difficulty == null) {
            return "badge-secondary";
        }

        return switch (difficulty.toUpperCase()) {
            case "BEGINNER" -> "badge-success";
            case "INTERMEDIATE" -> "badge-warning";
            case "ADVANCED" -> "badge-danger";
            default -> "badge-secondary";
        };
    }

    /**
     * Format duration từ phút
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
            if (remainingMinutes == 0) {
                return hours + " giờ";
            } else {
                return hours + " giờ " + remainingMinutes + " phút";
            }
        }
    }

    /**
     * Get price display text
     */
    public static String getPriceText(Double price) {
        if (price == null || price == 0.0) {
            return "Miễn phí";
        }
        return NumberUtils.formatCurrency(price);
    }

    /**
     * Get enrollment status text
     */
    public static String getEnrollmentStatusText(boolean enrolled, boolean completed) {
        if (!enrolled) {
            return "Chưa đăng ký";
        } else if (completed) {
            return "Đã hoàn thành";
        } else {
            return "Đang học";
        }
    }

    /**
     * Get enrollment status class
     */
    public static String getEnrollmentStatusClass(boolean enrolled, boolean completed) {
        if (!enrolled) {
            return "text-secondary";
        } else if (completed) {
            return "text-success";
        } else {
            return "text-primary";
        }
    }

    /**
     * Validate course data
     */
    public static boolean isValidCourseData(String name, String description, Double price) {
        if (name == null || name.trim().length() < 5) {
            return false;
        }
        if (description == null || description.trim().length() < 20) {
            return false;
        }
        if (price != null && price < 0) {
            return false;
        }
        return true;
    }

    /**
     * Generate course slug từ name
     */
    public static String generateSlug(String name) {
        if (name == null || name.trim().isEmpty()) {
            return "";
        }
        return CourseUtils.StringUtils.createSlug(name);
    }

    /**
     * Calculate average score từ list scores
     */
    public static double calculateAverageScore(List<Double> scores) {
        if (scores == null || scores.isEmpty()) {
            return 0.0;
        }

        double sum = scores.stream()
                .filter(score -> score != null)
                .mapToDouble(Double::doubleValue)
                .sum();

        return NumberUtils.round(sum / scores.size(), 1);
    }

    /**
     * Check if course is popular (dựa trên số enrollments)
     */
    public static boolean isPopularCourse(int enrollmentCount, int threshold) {
        return enrollmentCount >= threshold;
    }

    /**
     * Get progress percentage text
     */
    public static String getProgressText(double progress) {
        if (progress >= 100.0) {
            return "Hoàn thành";
        } else if (progress >= 75.0) {
            return "Gần hoàn thành";
        } else if (progress >= 50.0) {
            return "Đang tiến triển tốt";
        } else if (progress > 0) {
            return "Mới bắt đầu";
        } else {
            return "Chưa bắt đầu";
        }
    }

    /**
     * Get progress bar class
     */
    public static String getProgressBarClass(double progress) {
        if (progress >= 100.0) {
            return "bg-success";
        } else if (progress >= 75.0) {
            return "bg-info";
        } else if (progress >= 50.0) {
            return "bg-warning";
        } else {
            return "bg-secondary";
        }
    }
}