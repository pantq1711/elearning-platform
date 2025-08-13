package com.coursemanagement.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.ui.Model;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.NoHandlerFoundException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.ConstraintViolationException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * Global Exception Handler cho toàn bộ ứng dụng
 * Xử lý tất cả các exception và trả về response phù hợp
 * Hỗ trợ cả Web views và REST API responses
 */
@ControllerAdvice
public class GlobalExceptionHandler {

    /**
     * Xử lý lỗi không tìm thấy trang (404)
     */
    @ExceptionHandler(NoHandlerFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ModelAndView handleNotFound(HttpServletRequest request, NoHandlerFoundException e) {
        String requestId = generateRequestId();
        logError("Page not found", e, request, requestId);

        ModelAndView mav = new ModelAndView("error/404");
        mav.addObject("error", "Không tìm thấy trang yêu cầu");
        mav.addObject("path", request.getRequestURI());
        mav.addObject("timestamp", LocalDateTime.now());
        mav.addObject("requestId", requestId);

        return mav;
    }

    /**
     * Xử lý lỗi truy cập bị từ chối (403)
     */
    @ExceptionHandler(AccessDeniedException.class)
    @ResponseStatus(HttpStatus.FORBIDDEN)
    public ModelAndView handleAccessDenied(HttpServletRequest request, AccessDeniedException e) {
        String requestId = generateRequestId();
        logError("Access denied", e, request, requestId);

        ModelAndView mav = new ModelAndView("error/403");
        mav.addObject("error", "Bạn không có quyền truy cập trang này");
        mav.addObject("path", request.getRequestURI());
        mav.addObject("timestamp", LocalDateTime.now());
        mav.addObject("requestId", requestId);

        return mav;
    }

    /**
     * Xử lý lỗi xác thực (Authentication)
     */
    @ExceptionHandler({AuthenticationException.class, BadCredentialsException.class})
    @ResponseStatus(HttpStatus.UNAUTHORIZED)
    public ModelAndView handleAuthenticationError(HttpServletRequest request, Exception e) {
        String requestId = generateRequestId();
        logError("Authentication error", e, request, requestId);

        // Nếu là AJAX request, trả về JSON
        if (isAjaxRequest(request)) {
            return createJsonErrorResponse("Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.",
                    HttpStatus.UNAUTHORIZED, requestId);
        }

        // Redirect về trang login cho web request
        ModelAndView mav = new ModelAndView("redirect:/login");
        mav.addObject("error", "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.");

        return mav;
    }

    /**
     * Xử lý lỗi validation cho form data
     */
    @ExceptionHandler({MethodArgumentNotValidException.class, BindException.class})
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ModelAndView handleValidationError(HttpServletRequest request, Exception e) {
        String requestId = generateRequestId();
        logError("Validation error", e, request, requestId);

        Map<String, String> errors = new HashMap<>();

        if (e instanceof MethodArgumentNotValidException) {
            MethodArgumentNotValidException ex = (MethodArgumentNotValidException) e;
            ex.getBindingResult().getAllErrors().forEach(error -> {
                String fieldName = ((FieldError) error).getField();
                String errorMessage = error.getDefaultMessage();
                errors.put(fieldName, errorMessage);
            });
        } else if (e instanceof BindException) {
            BindException ex = (BindException) e;
            ex.getBindingResult().getAllErrors().forEach(error -> {
                String fieldName = ((FieldError) error).getField();
                String errorMessage = error.getDefaultMessage();
                errors.put(fieldName, errorMessage);
            });
        }

        // Nếu là AJAX request, trả về JSON với chi tiết lỗi validation
        if (isAjaxRequest(request)) {
            ModelAndView mav = new ModelAndView("jsonView");
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Dữ liệu không hợp lệ");
            response.put("errors", errors);
            response.put("requestId", requestId);
            mav.addObject("response", response);
            return mav;
        }

        // Trả về trang lỗi với thông tin chi tiết
        ModelAndView mav = new ModelAndView("error/validation");
        mav.addObject("errors", errors);
        mav.addObject("path", request.getRequestURI());
        mav.addObject("timestamp", LocalDateTime.now());
        mav.addObject("requestId", requestId);

        return mav;
    }

    /**
     * Xử lý lỗi constraint violation (database constraints)
     */
    @ExceptionHandler(ConstraintViolationException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ModelAndView handleConstraintViolation(HttpServletRequest request, ConstraintViolationException e) {
        String requestId = generateRequestId();
        logError("Constraint violation", e, request, requestId);

        String errorMessage = "Dữ liệu không hợp lệ: " + e.getMessage();

        if (isAjaxRequest(request)) {
            return createJsonErrorResponse(errorMessage, HttpStatus.BAD_REQUEST, requestId);
        }

        ModelAndView mav = new ModelAndView("error/400");
        mav.addObject("error", errorMessage);
        mav.addObject("path", request.getRequestURI());
        mav.addObject("timestamp", LocalDateTime.now());
        mav.addObject("requestId", requestId);

        return mav;
    }

    /**
     * Xử lý lỗi database (SQLException)
     */
    @ExceptionHandler(SQLException.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ModelAndView handleDatabaseError(HttpServletRequest request, SQLException e) {
        String requestId = generateRequestId();
        logError("Database error", e, request, requestId);

        String userMessage = "Có lỗi xảy ra với cơ sở dữ liệu. Vui lòng thử lại sau.";

        if (isAjaxRequest(request)) {
            return createJsonErrorResponse(userMessage, HttpStatus.INTERNAL_SERVER_ERROR, requestId);
        }

        ModelAndView mav = new ModelAndView("error/database");
        mav.addObject("error", userMessage);
        mav.addObject("path", request.getRequestURI());
        mav.addObject("timestamp", LocalDateTime.now());
        mav.addObject("requestId", requestId);

        return mav;
    }

    /**
     * Xử lý lỗi upload file quá lớn
     */
    @ExceptionHandler(MaxUploadSizeExceededException.class)
    @ResponseStatus(HttpStatus.PAYLOAD_TOO_LARGE)
    public ModelAndView handleFileUploadError(HttpServletRequest request, MaxUploadSizeExceededException e) {
        String requestId = generateRequestId();
        logError("File upload size exceeded", e, request, requestId);

        String errorMessage = "File upload quá lớn. Kích thước tối đa cho phép là " +
                formatFileSize(e.getMaxUploadSize()) + ".";

        if (isAjaxRequest(request)) {
            return createJsonErrorResponse(errorMessage, HttpStatus.PAYLOAD_TOO_LARGE, requestId);
        }

        ModelAndView mav = new ModelAndView("error/file-too-large");
        mav.addObject("error", errorMessage);
        mav.addObject("maxSize", formatFileSize(e.getMaxUploadSize()));
        mav.addObject("path", request.getRequestURI());
        mav.addObject("timestamp", LocalDateTime.now());
        mav.addObject("requestId", requestId);

        return mav;
    }

    /**
     * Xử lý RuntimeException (business logic errors)
     */
    @ExceptionHandler(RuntimeException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ModelAndView handleRuntimeException(HttpServletRequest request, RuntimeException e) {
        String requestId = generateRequestId();
        logError("Runtime exception", e, request, requestId);

        // Lấy message từ exception, fallback về message mặc định
        String errorMessage = e.getMessage() != null ? e.getMessage() :
                "Có lỗi xảy ra trong quá trình xử lý yêu cầu.";

        if (isAjaxRequest(request)) {
            return createJsonErrorResponse(errorMessage, HttpStatus.BAD_REQUEST, requestId);
        }

        ModelAndView mav = new ModelAndView("error/400");
        mav.addObject("error", errorMessage);
        mav.addObject("path", request.getRequestURI());
        mav.addObject("timestamp", LocalDateTime.now());
        mav.addObject("requestId", requestId);

        return mav;
    }

    /**
     * Xử lý IllegalArgumentException
     */
    @ExceptionHandler(IllegalArgumentException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ModelAndView handleIllegalArgument(HttpServletRequest request, IllegalArgumentException e) {
        String requestId = generateRequestId();
        logError("Illegal argument", e, request, requestId);

        String errorMessage = "Tham số không hợp lệ: " + e.getMessage();

        if (isAjaxRequest(request)) {
            return createJsonErrorResponse(errorMessage, HttpStatus.BAD_REQUEST, requestId);
        }

        ModelAndView mav = new ModelAndView("error/400");
        mav.addObject("error", errorMessage);
        mav.addObject("path", request.getRequestURI());
        mav.addObject("timestamp", LocalDateTime.now());
        mav.addObject("requestId", requestId);

        return mav;
    }

    /**
     * Xử lý tất cả các exception khác (catch-all)
     */
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ModelAndView handleGenericError(HttpServletRequest request, Exception e) {
        String requestId = generateRequestId();
        logError("Unexpected error", e, request, requestId);

        String errorMessage = "Có lỗi không mong muốn xảy ra. Đội ngũ kỹ thuật đã được thông báo.";

        if (isAjaxRequest(request)) {
            return createJsonErrorResponse(errorMessage, HttpStatus.INTERNAL_SERVER_ERROR, requestId);
        }

        ModelAndView mav = new ModelAndView("error/500");
        mav.addObject("error", errorMessage);
        mav.addObject("path", request.getRequestURI());
        mav.addObject("timestamp", LocalDateTime.now());
        mav.addObject("requestId", requestId);

        // Trong môi trường development, hiển thị stack trace
        if (isDevelopmentMode()) {
            mav.addObject("stackTrace", getStackTrace(e));
            mav.addObject("exceptionClass", e.getClass().getSimpleName());
            mav.addObject("detailedMessage", e.getMessage());
        }

        return mav;
    }

    /**
     * Tạo JSON error response cho AJAX requests
     */
    private ModelAndView createJsonErrorResponse(String message, HttpStatus status, String requestId) {
        ModelAndView mav = new ModelAndView("jsonView");
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", message);
        response.put("status", status.value());
        response.put("timestamp", LocalDateTime.now().toString());
        response.put("requestId", requestId);
        mav.addObject("response", response);
        return mav;
    }

    /**
     * Kiểm tra có phải AJAX request không
     */
    private boolean isAjaxRequest(HttpServletRequest request) {
        String xRequestedWith = request.getHeader("X-Requested-With");
        String accept = request.getHeader("Accept");
        String contentType = request.getContentType();

        return "XMLHttpRequest".equals(xRequestedWith) ||
                (accept != null && accept.contains("application/json")) ||
                (contentType != null && contentType.contains("application/json")) ||
                request.getRequestURI().startsWith("/api/");
    }

    /**
     * Tạo unique request ID để tracking
     */
    private String generateRequestId() {
        return UUID.randomUUID().toString().substring(0, 8);
    }

    /**
     * Log error với đầy đủ thông tin
     */
    private void logError(String type, Exception e, HttpServletRequest request, String requestId) {
        System.err.println("=== ERROR LOG ===");
        System.err.println("Type: " + type);
        System.err.println("Request ID: " + requestId);
        System.err.println("Timestamp: " + LocalDateTime.now());
        System.err.println("Method: " + request.getMethod());
        System.err.println("URL: " + request.getRequestURL());
        System.err.println("Parameters: " + request.getQueryString());
        System.err.println("User-Agent: " + request.getHeader("User-Agent"));
        System.err.println("Remote Address: " + request.getRemoteAddr());
        System.err.println("Exception: " + e.getClass().getSimpleName());
        System.err.println("Message: " + e.getMessage());

        // Print stack trace trong development mode
        if (isDevelopmentMode()) {
            e.printStackTrace();
        }

        System.err.println("=== END ERROR LOG ===");
    }

    /**
     * Format file size cho user-friendly display
     */
    private String formatFileSize(long bytes) {
        if (bytes <= 0) return "0 B";

        String[] units = {"B", "KB", "MB", "GB"};
        int digitGroups = (int) (Math.log10(bytes) / Math.log10(1024));

        return String.format("%.1f %s",
                bytes / Math.pow(1024, digitGroups),
                units[digitGroups]);
    }

    /**
     * Lấy stack trace dưới dạng string
     */
    private String getStackTrace(Exception e) {
        java.io.StringWriter sw = new java.io.StringWriter();
        java.io.PrintWriter pw = new java.io.PrintWriter(sw);
        e.printStackTrace(pw);
        return sw.toString();
    }

    /**
     * Kiểm tra có phải development mode không
     */
    private boolean isDevelopmentMode() {
        String profile = System.getProperty("spring.profiles.active");
        return "dev".equals(profile) || "development".equals(profile) || profile == null;
    }

    /**
     * REST API Exception Handlers
     * Các methods này trả về ResponseEntity cho REST endpoints
     */

    /**
     * Xử lý validation errors cho REST API
     */
    public ResponseEntity<Map<String, Object>> handleApiValidationError(MethodArgumentNotValidException e) {
        Map<String, Object> response = new HashMap<>();
        Map<String, String> errors = new HashMap<>();

        e.getBindingResult().getAllErrors().forEach(error -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });

        response.put("success", false);
        response.put("message", "Dữ liệu không hợp lệ");
        response.put("errors", errors);
        response.put("timestamp", LocalDateTime.now());

        return ResponseEntity.badRequest().body(response);
    }

    /**
     * Xử lý runtime exceptions cho REST API
     */
    public ResponseEntity<Map<String, Object>> handleApiRuntimeException(RuntimeException e) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", e.getMessage() != null ? e.getMessage() : "Có lỗi xảy ra");
        response.put("timestamp", LocalDateTime.now());

        return ResponseEntity.badRequest().body(response);
    }

    /**
     * Xử lý generic errors cho REST API
     */
    public ResponseEntity<Map<String, Object>> handleApiGenericError(Exception e) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", "Có lỗi không mong muốn xảy ra");
        response.put("timestamp", LocalDateTime.now());
        response.put("requestId", generateRequestId());

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
    }
}