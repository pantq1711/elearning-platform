package com.coursemanagement.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;

/**
 * Entity đại diện cho bảng users trong database
 * Lưu thông tin người dùng: Admin, Giảng viên, Học viên
 * Implement UserDetails để tích hợp với Spring Security
 */
@Entity
@Table(name = "users")
public class User implements UserDetails {

    /**
     * ID tự động tăng - Primary Key
     */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Tên đăng nhập - phải unique và không được trống
     */
    @Column(unique = true, nullable = false)
    @NotBlank(message = "Tên đăng nhập không được để trống")
    @Size(min = 3, max = 50, message = "Tên đăng nhập phải từ 3-50 ký tự")
    private String username;

    /**
     * Mật khẩu đã được mã hóa BCrypt
     */
    @Column(nullable = false)
    @NotBlank(message = "Mật khẩu không được để trống")
    private String password;

    /**
     * Email người dùng - phải unique và đúng định dạng
     */
    @Column(unique = true, nullable = false)
    @Email(message = "Email không đúng định dạng")
    @NotBlank(message = "Email không được để trống")
    private String email;

    /**
     * Vai trò của người dùng: ADMIN, INSTRUCTOR, STUDENT
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role;

    /**
     * Trạng thái tài khoản - có hoạt động hay không
     */
    @Column(name = "is_active")
    private boolean isActive = true;

    /**
     * Thời gian tạo tài khoản
     */
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    /**
     * Thời gian cập nhật cuối cùng
     */
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    /**
     * Enum định nghĩa các vai trò trong hệ thống
     */
    public enum Role {
        ADMIN("Quản trị viên"),
        INSTRUCTOR("Giảng viên"),
        STUDENT("Học viên");

        private final String displayName;

        Role(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }

    /**
     * Constructor mặc định
     */
    public User() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Constructor với tham số cơ bản
     */
    public User(String username, String password, String email, Role role) {
        this();
        this.username = username;
        this.password = password;
        this.email = email;
        this.role = role;
    }

    /**
     * Callback được gọi trước khi update entity
     */
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    // === Implement UserDetails cho Spring Security ===

    /**
     * Trả về quyền của user dựa trên role
     */
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority("ROLE_" + role.name()));
    }

    /**
     * Kiểm tra tài khoản có hết hạn không
     */
    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    /**
     * Kiểm tra tài khoản có bị khóa không
     */
    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    /**
     * Kiểm tra thông tin đăng nhập có hết hạn không
     */
    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    /**
     * Kiểm tra tài khoản có được kích hoạt không
     */
    @Override
    public boolean isEnabled() {
        return isActive;
    }

    // === Getters và Setters ===

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    /**
     * Override toString để debug dễ dàng
     */
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", role=" + role +
                ", isActive=" + isActive +
                '}';
    }
}