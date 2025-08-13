package com.coursemanagement.dto;

import com.coursemanagement.entity.User;
import com.coursemanagement.entity.Course;
import com.coursemanagement.utils.CourseUtils;
import jakarta.validation.constraints.*;

import java.time.LocalDateTime;
import java.util.List;

/**
 * DTO Classes cho việc transfer data an toàn giữa các layer
 * Tránh expose entity trực tiếp và cung cấp validation
 */

/**
 * DTO cho User registration và update
 */
public class UserDto {

    @NotBlank(message = "Tên đăng nhập không được để trống")
    @Size(min = 3, max = 20, message = "Tên đăng nhập phải từ 3-20 ký tự")
    @Pattern(regexp = "^[a-zA-Z0-9._-]+$", message = "Tên đăng nhập chỉ chứa chữ, số và ký tự ._-")
    private String username;

    @NotBlank(message = "Email không được để trống")
    @Email(message = "Email không đúng định dạng")
    private String email;

    @NotBlank(message = "Họ tên không được để trống")
    @Size(min = 2, max = 100, message = "Họ tên phải từ 2-100 ký tự")
    private String fullName;

    @Size(min = 6, max = 100, message = "Mật khẩu phải từ 6-100 ký tự")
    private String password;

    private String confirmPassword;

    @Pattern(regexp = "^(\\+84|0)[0-9]{9,10}$", message = "Số điện thoại không đúng định dạng")
    private String phoneNumber;

    @Size(max = 500, message = "Giới thiệu không được vượt quá 500 ký tự")
    private String bio;

    private String role; // ADMIN, INSTRUCTOR, STUDENT
    private boolean active = true;
    private LocalDateTime lastLogin;
    private String profileImageUrl;

    // Constructors
    public UserDto() {}

    public UserDto(String username, String email, String fullName) {
        this.username = username;
        this.email = email;
        this.fullName = fullName;
    }

    // Factory method để tạo từ Entity
    public static UserDto fromEntity(com.coursemanagement.entity.User user) {
        UserDto dto = new UserDto();
        dto.setUsername(user.getUsername());
        dto.setEmail(user.getEmail());
        dto.setFullName(user.getFullName());
        dto.setPhoneNumber(user.getPhoneNumber());
        dto.setBio(user.getBio());
        dto.setRole(user.getRole().name());
        dto.setActive(user.isActive());
        dto.setLastLogin(user.getLastLogin());
        dto.setProfileImageUrl(user.getProfileImageUrl());
        // Không include password
        return dto;
    }

    // Custom validation method
    public boolean isValidForRegistration() {
        return CourseUtils.ValidationUtils.isValidUsername(username) &&
                CourseUtils.ValidationUtils.isValidEmail(email) &&
                CourseUtils.ValidationUtils.isValidPassword(password) &&
                password.equals(confirmPassword);
    }

    // Getters và Setters
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getConfirmPassword() { return confirmPassword; }
    public void setConfirmPassword(String confirmPassword) { this.confirmPassword = confirmPassword; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public LocalDateTime getLastLogin() { return lastLogin; }
    public void setLastLogin(LocalDateTime lastLogin) { this.lastLogin = lastLogin; }

    public String getProfileImageUrl() { return profileImageUrl; }
    public void setProfileImageUrl(String profileImageUrl) { this.profileImageUrl = profileImageUrl; }

    /**
     * Lấy text hiển thị cho role
     * @return Text hiển thị role
     */
    public String getRoleText() {
        if (role == null) return "Không xác định";

        switch (role) {
            case "ADMIN": return "Quản trị viên";
            case "INSTRUCTOR": return "Giảng viên";
            case "STUDENT": return "Học viên";
            default: return "Không xác định";
        }
    }

    /**
     * Lấy text hiển thị cho status
     * @return Text hiển thị status
     */
    public String getStatusText() {
        return active ? "Hoạt động" : "Tạm khóa";
    }

    /**
     * Lấy CSS class cho status
     * @return CSS class
     */
    public String getStatusCssClass() {
        return active ? "badge-success" : "badge-danger";
    }

    /**
     * Lấy CSS class cho role
     * @return CSS class
     */
    public String getRoleCssClass() {
        if (role == null) return "badge-secondary";

        switch (role) {
            case "ADMIN": return "badge-danger";
            case "INSTRUCTOR": return "badge-warning";
            case "STUDENT": return "badge-info";
            default: return "badge-secondary";
        }
    }

    /**
     * Lấy formatted last login time
     * @return Formatted time
     */
    public String getFormattedLastLogin() {
        if (lastLogin == null) {
            return "Chưa đăng nhập";
        }
        return CourseUtils.DateTimeUtils.formatDateTime(lastLogin);
    }

    /**
     * Kiểm tra có avatar không
     * @return true nếu có avatar
     */
    public boolean hasAvatar() {
        return profileImageUrl != null && !profileImageUrl.trim().isEmpty();
    }

    /**
     * Lấy avatar URL hoặc default
     * @return Avatar URL
     */
    public String getAvatarUrl() {
        if (hasAvatar()) {
            return profileImageUrl;
        }
        return "/images/default-avatar.png";
    }

    /**
     * Lấy initials cho avatar placeholder
     * @return Initials (VD: "John Doe" -> "JD")
     */
    public String getInitials() {
        if (fullName == null || fullName.trim().isEmpty()) {
            return "?";
        }

        String[] parts = fullName.trim().split("\\s+");
        if (parts.length == 1) {
            return parts[0].substring(0, 1).toUpperCase();
        }

        return (parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1)).toUpperCase();
    }

    /**
     * Validation tổng thể
     * @return true nếu hợp lệ
     */
    public boolean isValid() {
        return username != null && !username.trim().isEmpty() &&
                email != null && !email.trim().isEmpty() &&
                fullName != null && !fullName.trim().isEmpty();
    }

    /**
     * Validation cho password
     * @return true nếu password hợp lệ
     */
    public boolean isPasswordValid() {
        return password != null &&
                password.length() >= 6 &&
                password.equals(confirmPassword);
    }
}