// File: src/main/java/com/coursemanagement/exception/ImprovedGlobalExceptionHandler.java

package com.coursemanagement.exception;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.NoHandlerFoundException;
import org.springframework.web.servlet.resource.NoResourceFoundException;
import org.springframework.http.converter.HttpMessageNotWritableException;
import org.springframework.web.servlet.ModelAndView;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * Cải thiện Global Exception Handler để xử lý tất cả lỗi
 */
@ControllerAdvice
public class ImprovedGlobalExceptionHandler {

    /**
     * Xử lý lỗi static resources không tìm thấy
     */
    @ExceptionHandler(NoResourceFoundException.class)
    public ResponseEntity<Map<String, Object>> handleNoResourceFound(
            NoResourceFoundException ex,
            HttpServletRequest request) {

        // Log lỗi để debug
        logError("NoResourceFoundException", ex, request);

        // Nếu là favicon thì trả về 204 No Content
        if (request.getRequestURI().endsWith("favicon.ico")) {
            return ResponseEntity.noContent().build();
        }

        // Nếu là ảnh thì trả về placeholder
        if (request.getRequestURI().contains("/images/")) {
            Map<String, Object> error = createErrorResponse(
                    "RESOURCE_NOT_FOUND",
                    "Image not found: " + ex.getResourcePath(),
                    HttpStatus.NOT_FOUND.value(),
                    request.getRequestURI()
            );
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
        }

        // Các static resource khác
        Map<String, Object> error = createErrorResponse(
                "STATIC_RESOURCE_NOT_FOUND",
                "Static resource not found: " + ex.getResourcePath(),
                HttpStatus.NOT_FOUND.value(),
                request.getRequestURI()
        );

        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }

    /**
     * Xử lý lỗi không tìm thấy handler (404)
     */
    @ExceptionHandler(NoHandlerFoundException.class)
    public ModelAndView handleNoHandlerFound(
            NoHandlerFoundException ex,
            HttpServletRequest request) {

        logError("NoHandlerFoundException", ex, request);

        // Nếu là favicon thì redirect đến trang tạo favicon
        if (request.getRequestURI().endsWith("favicon.ico")) {
            return new ModelAndView("redirect:/favicon.ico");
        }

        // Nếu là API request thì trả về JSON
        if (isApiRequest(request)) {
            Map<String, Object> error = createErrorResponse(
                    "ENDPOINT_NOT_FOUND",
                    "No endpoint found for: " + ex.getRequestURL(),
                    HttpStatus.NOT_FOUND.value(),
                    request.getRequestURI()
            );

            ModelAndView mv = new ModelAndView();
            mv.addObject("error", error);
            mv.setViewName("error/api-error");
            return mv;
        }

        // Trả về trang 404 thông thường
        ModelAndView mv = new ModelAndView();
        mv.addObject("errorCode", "404");
        mv.addObject("errorMessage", "Trang không tồn tại");
        mv.addObject("requestUrl", request.getRequestURI());
        mv.setViewName("error/404");
        return mv;
    }

    /**
     * Xử lý lỗi HttpMessageNotWritableException
     */
    @ExceptionHandler(HttpMessageNotWritableException.class)
    public ResponseEntity<String> handleHttpMessageNotWritable(
            HttpMessageNotWritableException ex,
            HttpServletRequest request,
            HttpServletResponse response) {

        logError("HttpMessageNotWritableException", ex, request);

        // Nếu là favicon request
        if (request.getRequestURI().endsWith("favicon.ico")) {
            return ResponseEntity.noContent().build();
        }

        // Xác định content type phù hợp
        String acceptHeader = request.getHeader("Accept");

        if (acceptHeader != null && acceptHeader.contains("application/json")) {
            // Trả về JSON error
            response.setContentType("application/json;charset=UTF-8");
            String jsonError = "{\"error\":\"Internal server error\",\"code\":500}";
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(jsonError);
        } else {
            // Trả về plain text
            response.setContentType("text/plain;charset=UTF-8");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .contentType(MediaType.TEXT_PLAIN)
                    .body("Internal Server Error");
        }
    }

    /**
     * Xử lý các lỗi chung khác
     */
    @ExceptionHandler(Exception.class)
    public ModelAndView handleGenericException(
            Exception ex,
            HttpServletRequest request) {

        logError("GenericException", ex, request);

        // Nếu là API request
        if (isApiRequest(request)) {
            Map<String, Object> error = createErrorResponse(
                    "INTERNAL_SERVER_ERROR",
                    "An unexpected error occurred",
                    HttpStatus.INTERNAL_SERVER_ERROR.value(),
                    request.getRequestURI()
            );

            ModelAndView mv = new ModelAndView();
            mv.addObject("error", error);
            mv.setViewName("error/api-error");
            return mv;
        }

        // Trả về trang lỗi thông thường
        ModelAndView mv = new ModelAndView();
        mv.addObject("errorCode", "500");
        mv.addObject("errorMessage", "Đã xảy ra lỗi hệ thống");
        mv.addObject("requestUrl", request.getRequestURI());
        mv.setViewName("error/500");
        return mv;
    }

    /**
     * Tạo error response object
     */
    private Map<String, Object> createErrorResponse(String type, String message, int status, String path) {
        Map<String, Object> error = new HashMap<>();
        error.put("timestamp", LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
        error.put("status", status);
        error.put("error", type);
        error.put("message", message);
        error.put("path", path);
        error.put("requestId", UUID.randomUUID().toString().substring(0, 8));
        return error;
    }

    /**
     * Kiểm tra xem có phải API request không
     */
    private boolean isApiRequest(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String acceptHeader = request.getHeader("Accept");

        return uri.startsWith("/api/") ||
                (acceptHeader != null && acceptHeader.contains("application/json"));
    }

    /**
     * Log lỗi với thông tin chi tiết
     */
    private void logError(String type, Exception ex, HttpServletRequest request) {
        String requestId = UUID.randomUUID().toString().substring(0, 8);

        System.err.println("=== ERROR LOG ===");
        System.err.println("Type: " + type);
        System.err.println("Request ID: " + requestId);
        System.err.println("Timestamp: " + LocalDateTime.now());
        System.err.println("Method: " + request.getMethod());
        System.err.println("URL: " + request.getRequestURL());
        System.err.println("Parameters: " + request.getQueryString());
        System.err.println("User-Agent: " + request.getHeader("User-Agent"));
        System.err.println("Remote Address: " + request.getRemoteAddr());
        System.err.println("Exception: " + ex.getClass().getSimpleName());
        System.err.println("Message: " + ex.getMessage());

        // In stack trace chỉ cho lỗi quan trọng
        if (!(ex instanceof NoResourceFoundException) &&
                !(ex instanceof NoHandlerFoundException)) {
            ex.printStackTrace();
        }

        System.err.println("=== END ERROR LOG ===");
    }
}