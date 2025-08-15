// File: src/main/java/com/coursemanagement/controller/StaticResourcesController.java

package com.coursemanagement.controller;

import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.IOException;
import java.io.InputStream;

/**
 * Controller xử lý static resources và các tài nguyên đặc biệt
 */
@Controller
public class StaticResourcesController {

    /**
     * Xử lý favicon.ico
     */
    @GetMapping("/favicon.ico")
    @ResponseBody
    public ResponseEntity<byte[]> favicon() {
        try {
            // Tạo favicon đơn giản bằng code (16x16 ICO format)
            byte[] faviconData = createSimpleFavicon();

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.valueOf("image/x-icon"));
            headers.setCacheControl("public, max-age=31536000"); // Cache 1 năm

            return new ResponseEntity<>(faviconData, headers, HttpStatus.OK);
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * Xử lý placeholder cho ảnh bị thiếu
     */
    @GetMapping("/images/placeholder/{type}")
    @ResponseBody
    public ResponseEntity<String> getPlaceholder(@PathVariable String type) {
        String svg = createPlaceholderSVG(type);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.valueOf("image/svg+xml"));
        headers.setCacheControl("public, max-age=3600"); // Cache 1 giờ

        return new ResponseEntity<>(svg, headers, HttpStatus.OK);
    }

    /**
     * Tạo SVG placeholder cho các loại ảnh khác nhau
     */
    private String createPlaceholderSVG(String type) {
        String color, icon, text;

        switch (type) {
            case "avatar":
                color = "#4f46e5";
                icon = "👤";
                text = "Avatar";
                break;
            case "course":
                color = "#059669";
                icon = "📚";
                text = "Course";
                break;
            case "hero":
                color = "#7c3aed";
                icon = "🎓";
                text = "EduLearn";
                break;
            default:
                color = "#6b7280";
                icon = "🖼️";
                text = "Image";
        }

        return String.format(
                "<svg width='400' height='300' xmlns='http://www.w3.org/2000/svg'>" +
                        "<rect width='100%%' height='100%%' fill='%s'/>" +
                        "<text x='50%%' y='40%%' font-family='Arial, sans-serif' font-size='48' " +
                        "fill='white' text-anchor='middle' dominant-baseline='central'>%s</text>" +
                        "<text x='50%%' y='65%%' font-family='Arial, sans-serif' font-size='24' " +
                        "fill='white' text-anchor='middle' dominant-baseline='central'>%s</text>" +
                        "</svg>",
                color, icon, text
        );
    }

    /**
     * Tạo favicon đơn giản (16x16 pixels)
     * Đây là một favicon ICO cơ bản với chữ "E" (EduLearn)
     */
    private byte[] createSimpleFavicon() {
        // Base64 của một favicon 16x16 với chữ "E" màu xanh
        String base64Favicon =
                "AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAQAAAAAAAAAAAAAAAAAAA" +
                        "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
                        "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
                        "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAPDw8P/w8PD/8PDw//Dw8P/w8PD/8PDw//Dw8P/w8PD/8PDw//Dw" +
                        "8P/w8PD/8PDw//Dw8P/w8PD/8PDw/wAAAAAAAAAA8PDw//Dw8P/w8PD/8PDw//Dw8P/w8PD/8PDw//Dw" +
                        "8P/w8PD/8PDw//Dw8P/w8PD/8PDw//Dw8P/w8PD/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
                        "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";

        try {
            return java.util.Base64.getDecoder().decode(base64Favicon);
        } catch (Exception e) {
            // Fallback: trả về favicon rỗng
            return new byte[0];
        }
    }

    /**
     * Health check endpoint cho static resources
     */
    @GetMapping("/health/static")
    @ResponseBody
    public ResponseEntity<String> staticResourcesHealth() {
        return ResponseEntity.ok("Static resources are working");
    }
}