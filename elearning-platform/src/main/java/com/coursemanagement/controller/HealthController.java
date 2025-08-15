// Thêm vào ApiController.java hoặc tạo HealthController.java mới

package com.coursemanagement.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;
import java.sql.Connection;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * Health Check và Status endpoints
 */
@RestController
@RequestMapping("/api")
public class HealthController {

    @Autowired
    private DataSource dataSource;

    /**
     * Basic health check
     */
    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> health() {
        Map<String, Object> health = new HashMap<>();
        health.put("status", "UP");
        health.put("timestamp", LocalDateTime.now());
        health.put("service", "EduLearn Platform");
        health.put("version", "1.0.0");

        return ResponseEntity.ok(health);
    }

    /**
     * Detailed health check với database
     */
    @GetMapping("/health/detailed")
    public ResponseEntity<Map<String, Object>> detailedHealth() {
        Map<String, Object> health = new HashMap<>();
        Map<String, Object> components = new HashMap<>();

        // Check database connection
        try {
            Connection connection = dataSource.getConnection();
            if (connection != null && !connection.isClosed()) {
                components.put("database", createComponent("UP", "Database connection successful"));
                connection.close();
            } else {
                components.put("database", createComponent("DOWN", "Database connection failed"));
            }
        } catch (Exception e) {
            components.put("database", createComponent("DOWN", "Database error: " + e.getMessage()));
        }

        // Check memory
        Runtime runtime = Runtime.getRuntime();
        long maxMemory = runtime.maxMemory();
        long totalMemory = runtime.totalMemory();
        long freeMemory = runtime.freeMemory();
        long usedMemory = totalMemory - freeMemory;

        Map<String, Object> memoryInfo = new HashMap<>();
        memoryInfo.put("max", formatBytes(maxMemory));
        memoryInfo.put("total", formatBytes(totalMemory));
        memoryInfo.put("used", formatBytes(usedMemory));
        memoryInfo.put("free", formatBytes(freeMemory));
        memoryInfo.put("usage_percent", (usedMemory * 100.0) / maxMemory);

        components.put("memory", createComponent("UP", "Memory status", memoryInfo));

        // Overall status
        boolean allUp = components.values().stream()
                .allMatch(component -> "UP".equals(((Map<?, ?>) component).get("status")));

        health.put("status", allUp ? "UP" : "DOWN");
        health.put("timestamp", LocalDateTime.now());
        health.put("components", components);

        return ResponseEntity.ok(health);
    }

    /**
     * Application info
     */
    @GetMapping("/info")
    public ResponseEntity<Map<String, Object>> info() {
        Map<String, Object> info = new HashMap<>();
        info.put("name", "EduLearn Platform");
        info.put("description", "Nền tảng học trực tuyến");
        info.put("version", "1.0.0");
        info.put("build_time", LocalDateTime.now());
        info.put("java_version", System.getProperty("java.version"));
        info.put("spring_profiles", System.getProperty("spring.profiles.active", "default"));

        return ResponseEntity.ok(info);
    }

    /**
     * Simple ping endpoint
     */
    @GetMapping("/ping")
    public ResponseEntity<String> ping() {
        return ResponseEntity.ok("pong");
    }

    /**
     * Database connectivity test
     */
    @GetMapping("/health/db")
    public ResponseEntity<Map<String, Object>> databaseHealth() {
        Map<String, Object> dbHealth = new HashMap<>();

        try {
            Connection connection = dataSource.getConnection();
            if (connection != null && !connection.isClosed()) {
                dbHealth.put("status", "UP");
                dbHealth.put("database", connection.getMetaData().getDatabaseProductName());
                dbHealth.put("driver", connection.getMetaData().getDriverName());
                dbHealth.put("url", connection.getMetaData().getURL());
                connection.close();
            } else {
                dbHealth.put("status", "DOWN");
                dbHealth.put("error", "Unable to establish connection");
            }
        } catch (Exception e) {
            dbHealth.put("status", "DOWN");
            dbHealth.put("error", e.getMessage());
        }

        dbHealth.put("timestamp", LocalDateTime.now());
        return ResponseEntity.ok(dbHealth);
    }

    // Helper methods
    private Map<String, Object> createComponent(String status, String description) {
        return createComponent(status, description, null);
    }

    private Map<String, Object> createComponent(String status, String description, Object details) {
        Map<String, Object> component = new HashMap<>();
        component.put("status", status);
        component.put("description", description);
        if (details != null) {
            component.put("details", details);
        }
        return component;
    }

    private String formatBytes(long bytes) {
        int unit = 1024;
        if (bytes < unit) return bytes + " B";
        int exp = (int) (Math.log(bytes) / Math.log(unit));
        String pre = "KMGTPE".charAt(exp-1) + "";
        return String.format("%.1f %sB", bytes / Math.pow(unit, exp), pre);
    }
}