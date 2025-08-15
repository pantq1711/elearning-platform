package com.coursemanagement.utils;

/**
 * Helper class để xử lý images và fallbacks
 * Tránh lỗi 404 khi images không tồn tại
 */
public class ImageHelper {

    private static final String DEFAULT_AVATAR = "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHJlY3Qgd2lkdGg9IjQwIiBoZWlnaHQ9IjQwIiByeD0iMjAiIGZpbGw9IiM2Njc4ZWEiLz4KPHN2ZyB3aWR0aD0iMjAiIGhlaWdodD0iMjAiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4PSIxMCIgeT0iMTAiPgo8cGF0aCBkPSJNMTIgMTJDMTQuMjA5MSAxMiAxNiAxMC4yMDkxIDE2IDhDMTYgNS43OTA5IDE0LjIwOTEgNCA4IDRDOS43OTA5IDQgOCA1Ljc5MDkgOCA4QzggMTAuMjA5MSA5Ljc5MDkgMTIgMTIgMTJaIiBmaWxsPSJ3aGl0ZSIvPgo8cGF0aCBkPSJNMTIgMTRDOC42ODYyOSAxNCA2IDE2LjY4NjMgNiAyMEgxOEMxOCAxNi42ODYzIDE1LjMxMzcgMTQgMTIgMTRaIiBmaWxsPSJ3aGl0ZSIvPgo8L3N2Zz4KPC9zdmc+";

    private static final String DEFAULT_COURSE = "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA2MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHJlY3Qgd2lkdGg9IjYwIiBoZWlnaHQ9IjQwIiByeD0iNiIgZmlsbD0iIzY2N2VlYSIvPgo8c3ZnIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHg9IjE4IiB5PSI4Ij4KPHN0eWxlPi5hIHsgZmlsbDogd2hpdGU7IH08L3N0eWxlPgo8cGF0aCBjbGFzcz0iYSIgZD0iTTEyIDJMMTMuMDkgOC4yNkwyMCA5TDEzLjA5IDE1Ljc0TDEyIDIyTDEwLjkxIDE1Ljc0TDQgOUwxMC45MSA4LjI2TDEyIDJaIi8+Cjwvc3ZnPgo8L3N2Zz4=";

    /**
     * Lấy avatar URL với fallback
     */
    public static String getAvatarUrl(String profileImageUrl) {
        if (profileImageUrl == null || profileImageUrl.trim().isEmpty()) {
            return DEFAULT_AVATAR;
        }
        return profileImageUrl;
    }

    /**
     * Lấy course thumbnail URL với fallback
     */
    public static String getCourseImageUrl(String imageUrl) {
        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            return DEFAULT_COURSE;
        }
        return imageUrl;
    }

    /**
     * Kiểm tra URL có hợp lệ không
     */
    public static boolean isValidImageUrl(String url) {
        if (url == null || url.trim().isEmpty()) {
            return false;
        }
        return url.startsWith("http") || url.startsWith("/") || url.startsWith("data:");
    }
}

/**
 * HƯỚNG DẪN SETUP IMAGES:
 *
 * 1. Tạo thư mục src/main/resources/static/images/
 * 2. Thêm các file sau:
 *    - default-avatar.png (40x40px)
 *    - default-course.jpg (300x200px)
 *
 * 3. Hoặc sử dụng online placeholder services:
 *    - Avatar: https://ui-avatars.com/api/?name=User&size=40&background=667eea&color=fff
 *    - Course: https://via.placeholder.com/300x200/667eea/ffffff?text=Course
 *
 * 4. Hoặc dùng SVG inline như đã implement ở trên
 */