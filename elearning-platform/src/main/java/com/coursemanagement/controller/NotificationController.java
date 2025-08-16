// File: src/main/java/com/coursemanagement/controller/NotificationController.java

package com.coursemanagement.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

/**
 * REST Controller xử lý notifications
 * Giải quyết lỗi: No endpoint GET /api/notifications/count
 */
@RestController
@RequestMapping("/api/notifications")
@PreAuthorize("isAuthenticated()")
public class NotificationController {

    /**
     * Đếm số thông báo chưa đọc
     * Endpoint được gọi từ JavaScript trong header
     */
    @GetMapping("/count")
    public ResponseEntity<Map<String, Object>> getNotificationCount(Authentication authentication) {
        try {
            // TODO: Implement thực tế với NotificationService
            // Hiện tại return mock data để tránh lỗi 404

            Map<String, Object> response = new HashMap<>();
            response.put("unreadCount", 0);  // Mock: 0 thông báo chưa đọc
            response.put("totalCount", 0);   // Mock: 0 tổng thông báo
            response.put("hasNewNotifications", false);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            // Trả về empty response nếu có lỗi
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("unreadCount", 0);
            errorResponse.put("totalCount", 0);
            errorResponse.put("hasNewNotifications", false);
            errorResponse.put("error", "Unable to fetch notifications");

            return ResponseEntity.ok(errorResponse);
        }
    }

    /**
     * Lấy danh sách thông báo (placeholder)
     */
    @GetMapping("")
    public ResponseEntity<Map<String, Object>> getNotifications(Authentication authentication) {
        Map<String, Object> response = new HashMap<>();
        response.put("notifications", new java.util.ArrayList<>());  // Empty list
        response.put("totalCount", 0);
        response.put("unreadCount", 0);

        return ResponseEntity.ok(response);
    }

    /**
     * Đánh dấu thông báo đã đọc (placeholder)
     */
    @GetMapping("/mark-read/{id}")
    public ResponseEntity<Map<String, String>> markAsRead(@org.springframework.web.bind.annotation.PathVariable Long id) {
        Map<String, String> response = new HashMap<>();
        response.put("status", "success");
        response.put("message", "Notification marked as read");

        return ResponseEntity.ok(response);
    }

    /**
     * Đánh dấu tất cả thông báo đã đọc (placeholder)
     */
    @GetMapping("/mark-all-read")
    public ResponseEntity<Map<String, String>> markAllAsRead(Authentication authentication) {
        Map<String, String> response = new HashMap<>();
        response.put("status", "success");
        response.put("message", "All notifications marked as read");

        return ResponseEntity.ok(response);
    }
}

/*
 * HƯỚNG DẪN PHÁT TRIỂN NOTIFICATION SYSTEM:
 *
 * 1. Tạo Entity: Notification.java
 * 2. Tạo Repository: NotificationRepository.java
 * 3. Tạo Service: NotificationService.java
 * 4. Update Controller này để sử dụng NotificationService
 * 5. Thêm WebSocket cho real-time notifications
 *
 * Hiện tại Controller này chỉ là MOCK để tránh lỗi 404
 */