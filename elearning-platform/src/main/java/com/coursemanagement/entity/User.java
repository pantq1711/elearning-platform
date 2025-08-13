package com.coursemanagement.entity;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

/**
 * Entity đại diện cho người dùng trong hệ thống
 * Triển khai UserDetails cho Spring Security
 * Hỗ trợ 3 roles: ADMIN, INSTRUCTOR, STUDENT
 */
@Entity
@Table(name = "users")
public class User implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false, length = 50)
    private String username;

    @Column(unique = true, nullable = false, length = 100)
    private String email;

    @Column(name = "full_name", nullable = false, length = 100)
    private String fullName;

    @Column(nullable = false, length = 255)
    private String password;

    @Column(name = "phone_number", length = 20)
    private String phoneNumber;

    @Column(columnDefinition = "TEXT")
    private String bio;

    @Column(name = "profile_image_url", length = 500)
    private String profileImageUrl;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Role role = Role.STUDENT;

    @Column(name = "is_active")
    private boolean active = true;

    @Column(name = "last_login")
    private LocalDateTime lastLogin;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Relationships
    @OneToMany(mappedBy = "instructor", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Course> instructorCourses = new ArrayList<>();

    @OneToMany(mappedBy = "student", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Enrollment> enrollments = new ArrayList<>();

    @OneToMany(mappedBy = "student", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<QuizResult> quizResults = new ArrayList<>();

    /**
     * Enum cho các role trong hệ thống
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

    // Constructors
    public User() {}

    public User(String username, String email, String fullName, String password, Role role) {
        this.username = username;
        this.email = email;
        this.fullName = fullName;
        this.password = password;
        this.role = role;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    // Helper methods
    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    /**
     * Cập nhật thời gian đăng nhập cuối
     */
    public void updateLastLogin() {
        this.lastLogin = LocalDateTime.now();
    }

    /**
     * Lấy text hiển thị cho role
     * @return Text hiển thị role
     */
    public String getRoleText() {
        return role != null ? role.getDisplayName() : "Không xác định";
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
            case ADMIN: return "badge-danger";
            case INSTRUCTOR: return "badge-warning";
            case STUDENT: return "badge-info";
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
        // Simple formatting - có thể dùng CourseUtils.DateTimeUtils.formatDateTime(lastLogin)
        return lastLogin.toString();
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
     * Kiểm tra user có phải admin không
     * @return true nếu là admin
     */
    public boolean isAdmin() {
        return Role.ADMIN.equals(role);
    }

    /**
     * Kiểm tra user có phải instructor không
     * @return true nếu là instructor
     */
    public boolean isInstructor() {
        return Role.INSTRUCTOR.equals(role);
    }

    /**
     * Kiểm tra user có phải student không
     * @return true nếu là student
     */
    public boolean isStudent() {
        return Role.STUDENT.equals(role);
    }

    // ===== SPRING SECURITY USERDETAILS IMPLEMENTATION =====

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + role.name()));
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return username;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return active;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return active;
    }

    // ===== GETTERS AND SETTERS =====

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public String getProfileImageUrl() {
        return profileImageUrl;
    }

    public void setProfileImageUrl(String profileImageUrl) {
        this.profileImageUrl = profileImageUrl;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public LocalDateTime getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(LocalDateTime lastLogin) {
        this.lastLogin = lastLogin;
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

    public List<Course> getInstructorCourses() {
        return instructorCourses;
    }

    public void setInstructorCourses(List<Course> instructorCourses) {
        this.instructorCourses = instructorCourses;
    }

    public List<Enrollment> getEnrollments() {
        return enrollments;
    }

    public void setEnrollments(List<Enrollment> enrollments) {
        this.enrollments = enrollments;
    }

    public List<QuizResult> getQuizResults() {
        return quizResults;
    }

    public void setQuizResults(List<QuizResult> quizResults) {
        this.quizResults = quizResults;
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
                ", fullName='" + fullName + '\'' +
                ", role=" + role +
                ", active=" + active +
                '}';
    }

    /**
     * Override equals và hashCode cho JPA
     */
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof User)) return false;
        User user = (User) o;
        return id != null && id.equals(user.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}