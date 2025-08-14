package com.coursemanagement.dto;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

/**
 * Response wrapper class cho consistent API responses
 * Cung cấp format chuẩn cho tất cả REST API endpoints
 * Hỗ trợ success, error, metadata và pagination info
 */
public class ApiResponse<T> {

    private boolean success;
    private String message;
    private T data;
    private String timestamp;
    private Map<String, Object> meta;

    // ===== CONSTRUCTORS =====

    public ApiResponse() {
        this.timestamp = LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);
        this.meta = new HashMap<>();
    }

    public ApiResponse(boolean success, String message, T data) {
        this();
        this.success = success;
        this.message = message;
        this.data = data;
    }

    // ===== STATIC FACTORY METHODS =====

    /**
     * Tạo success response với data
     */
    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(true, "Thành công", data);
    }

    /**
     * Tạo success response với custom message và data
     */
    public static <T> ApiResponse<T> success(String message, T data) {
        return new ApiResponse<>(true, message, data);
    }

    /**
     * Tạo success response chỉ với message (no data)
     */
    public static <T> ApiResponse<T> success(String message) {
        return new ApiResponse<>(true, message, null);
    }

    /**
     * Tạo error response với message
     */
    public static <T> ApiResponse<T> error(String message) {
        return new ApiResponse<>(false, message, null);
    }

    /**
     * Tạo error response với custom message và error data
     */
    public static <T> ApiResponse<T> error(String message, T errorData) {
        return new ApiResponse<>(false, message, errorData);
    }

    // ===== BUILDER METHODS =====

    /**
     * Thêm metadata vào response
     */
    public ApiResponse<T> withMeta(String key, Object value) {
        this.meta.put(key, value);
        return this;
    }

    /**
     * Thêm multiple metadata
     */
    public ApiResponse<T> withMeta(Map<String, Object> metadata) {
        this.meta.putAll(metadata);
        return this;
    }

    /**
     * Thêm pagination info
     */
    public ApiResponse<T> withPagination(long totalElements, int totalPages, int currentPage, int pageSize) {
        this.meta.put("totalElements", totalElements);
        this.meta.put("totalPages", totalPages);
        this.meta.put("currentPage", currentPage);
        this.meta.put("pageSize", pageSize);
        this.meta.put("hasNext", currentPage < totalPages - 1);
        this.meta.put("hasPrevious", currentPage > 0);
        return this;
    }

    /**
     * Thêm timing info
     */
    public ApiResponse<T> withTiming(long processTimeMs) {
        this.meta.put("processTime", processTimeMs + "ms");
        return this;
    }

    /**
     * Thêm validation errors
     */
    public ApiResponse<T> withValidationErrors(Map<String, String> errors) {
        this.meta.put("validationErrors", errors);
        return this;
    }

    // ===== UTILITY METHODS =====

    /**
     * Kiểm tra response có thành công không
     */
    public boolean isSuccess() {
        return success;
    }

    /**
     * Kiểm tra response có lỗi không
     */
    public boolean isError() {
        return !success;
    }

    /**
     * Kiểm tra có data không
     */
    public boolean hasData() {
        return data != null;
    }

    /**
     * Kiểm tra có metadata không
     */
    public boolean hasMeta() {
        return meta != null && !meta.isEmpty();
    }

    /**
     * Lấy giá trị metadata theo key
     */
    public Object getMetaValue(String key) {
        return meta != null ? meta.get(key) : null;
    }

    /**
     * Override toString để debug dễ dàng
     */
    @Override
    public String toString() {
        return "ApiResponse{" +
                "success=" + success +
                ", message='" + message + '\'' +
                ", hasData=" + hasData() +
                ", timestamp='" + timestamp + '\'' +
                ", metaKeys=" + (meta != null ? meta.keySet() : "[]") +
                '}';
    }

    // ===== GETTERS AND SETTERS =====

    public boolean getSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public Map<String, Object> getMeta() {
        return meta;
    }

    public void setMeta(Map<String, Object> meta) {
        this.meta = meta;
    }
}