package com.coursemanagement.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * Entity đại diện cho bảng users trong database
 * Triển khai UserDetails để tích hợp với Spring Security
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
     * Tên đăng nhập - unique và không được trống
     */
    @Column(unique = true, nullable = false)
    @NotBlank(message = "Tên đăng nhập không được để trống")
    @Size(min = 3, max = 50, message = "Tên đăng nhập phải từ 3-50 ký tự")
    private String username;

    /**
     * Mật khẩu đã được mã hóa - không được trống
     */
    @Column(nullable = false)
    @NotBlank(message = "Mật khẩu không được để trống")
    @Size(min = 6, message = "Mật khẩu phải có ít nhất 6 ký tự")
    private String password;

    /**
     * Email - unique và không được trống
     */
    @Column(unique = true, nullable = false)
    @NotBlank(message = "Email không được để trống")
    @Email(message = "Email không hợp lệ")
    private String email;

    /**
     * Họ và tên đầy đủ (tùy chọn)
     */
    @Column(name = "full_name")
    private String fullName;

    /**
     * Vai trò của user trong hệ thống
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role = Role.STUDENT;

    /**
     * Trạng thái tài khoản có đang hoạt động không
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
     * Thời gian đăng nhập cuối cùng
     */
    @Column(name = "last_login")
    private LocalDateTime lastLogin;

    /**
     * Số điện thoại (tùy chọn)
     */
    @Column(name = "phone_number")
    private String phoneNumber;

    /**
     * Địa chỉ (tùy chọn)
     */
    @Column(columnDefinition = "TEXT")
    private String address;

    /**
     * Ghi chú về người dùng (tùy chọn)
     */
    @Column(columnDefinition = "TEXT")
    private String notes;

    // Quan hệ với Course (cho Instructor)
    @OneToMany(mappedBy = "instructor", fetch = FetchType.LAZY)
    private List<Course> instructedCourses = new ArrayList<>();

    // Quan hệ với Enrollment (cho Student)
    @OneToMany(mappedBy = "student", fetch = FetchType.LAZY)
    private List<Enrollment> enrollments = new ArrayList<>();

    // Quan hệ với QuizResult (cho Student)
    @OneToMany(mappedBy = "student", fetch = FetchType.LAZY)
    private List<QuizResult> quizResults = new ArrayList<>();

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
     * Constructor với thông tin cơ bản
     */
    public User(String username, String password, String email, Role role) {
        this();
        this.username = username;
        this.password = password;
        this.email = email;
        this.role = role;
    }

    /**
     * Callback được gọi trước khi persist entity
     */
    @PrePersist
    public void prePersist() {
        LocalDateTime now = LocalDateTime.now();
        this.createdAt = now;
        this.updatedAt = now;
    }

    /**
     * Callback được gọi trước khi update entity
     */
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    // === Spring Security UserDetails implementation ===

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority("ROLE_" + role.name()));
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return isActive;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return isActive;
    }

    // === Helper methods ===

    /**
     * Cập nhật thời gian đăng nhập cuối
     */
    public void updateLastLogin() {
        this.lastLogin = LocalDateTime.now();
    }

    /**
     * Kiểm tra có phải Admin không
     */
    public boolean isAdmin() {
        return role == Role.ADMIN;
    }

    /**
     * Kiểm tra có phải Instructor không
     */
    public boolean isInstructor() {
        return role == Role.INSTRUCTOR;
    }

    /**
     * Kiểm tra có phải Student không
     */
    public boolean isStudent() {
        return role == Role.STUDENT;
    }

    /**
     * Lấy tên hiển thị
     */
    public String getDisplayName() {
        return fullName != null && !fullName.trim().isEmpty() ? fullName : username;
    }

    /**
     * Kiểm tra có thông tin liên hệ đầy đủ không
     */
    public boolean hasCompleteContactInfo() {
        return fullName != null && !fullName.trim().isEmpty() &&
                phoneNumber != null && !phoneNumber.trim().isEmpty() &&
                address != null && !address.trim().isEmpty();
    }

    /**
     * Lấy số lượng khóa học đã tạo (cho Instructor)
     */
    public int getInstructedCourseCount() {
        return instructedCourses != null ? instructedCourses.size() : 0;
    }

    /**
     * Lấy số lượng khóa học đã đăng ký (cho Student)
     */
    public int getEnrollmentCount() {
        return enrollments != null ? enrollments.size() : 0;
    }

    /**
     * Lấy số lượng quiz đã làm (cho Student)
     */
    public int getQuizResultCount() {
        return quizResults != null ? quizResults.size() : 0;
    }

    /**
     * Tính điểm trung bình quiz (cho Student)
     */
    public Double getAverageQuizScore() {
        if (quizResults == null || quizResults.isEmpty()) {
            return null;
        }

        return quizResults.stream()
                .filter(qr -> qr.getScore() != null)
                .mapToDouble(QuizResult::getScore)
                .average()
                .orElse(0.0);
    }

    /**
     * Đếm số khóa học đã hoàn thành (cho Student)
     */
    public long getCompletedCourseCount() {
        if (enrollments == null) {
            return 0;
        }

        return enrollments.stream()
                .filter(Enrollment::isCompleted)
                .count();
    }

    /**
     * Kiểm tra có đăng nhập trong X ngày qua không
     */
    public boolean hasLoggedInWithinDays(int days) {
        if (lastLogin == null) {
            return false;
        }

        LocalDateTime cutoff = LocalDateTime.now().minusDays(days);
        return lastLogin.isAfter(cutoff);
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

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
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

    public LocalDateTime getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(LocalDateTime lastLogin) {
        this.lastLogin = lastLogin;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public List<Course> getInstructedCourses() {
        return instructedCourses;
    }

    public void setInstructedCourses(List<Course> instructedCourses) {
        this.instructedCourses = instructedCourses;
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
                ", isActive=" + isActive +
                ", lastLogin=" + lastLogin +
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