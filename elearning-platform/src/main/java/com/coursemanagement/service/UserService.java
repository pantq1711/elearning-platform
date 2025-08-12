package com.coursemanagement.service;

import com.coursemanagement.entity.User;
import com.coursemanagement.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Service class để xử lý business logic liên quan đến User
 * Triển khai UserDetailsService để tích hợp với Spring Security
 */
@Service
@Transactional
public class UserService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    /**
     * Load user cho Spring Security authentication
     * @param username Tên đăng nhập
     * @return UserDetails object
     * @throws UsernameNotFoundException Nếu không tìm thấy user
     */
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("Không tìm thấy người dùng: " + username));

        // Cập nhật thời gian đăng nhập cuối
        user.updateLastLogin();
        userRepository.save(user);

        return user;
    }

    /**
     * Tạo user mới
     * @param user User cần tạo
     * @return User đã được tạo
     * @throws RuntimeException Nếu có lỗi validation
     */
    public User createUser(User user) {
        // Validate thông tin user
        validateUser(user, true);

        // Kiểm tra username đã tồn tại chưa
        if (userRepository.existsByUsername(user.getUsername())) {
            throw new RuntimeException("Tên đăng nhập đã tồn tại: " + user.getUsername());
        }

        // Kiểm tra email đã tồn tại chưa
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new RuntimeException("Email đã tồn tại: " + user.getEmail());
        }

        // Mã hóa mật khẩu
        user.setPassword(passwordEncoder.encode(user.getPassword()));

        // Đảm bảo user được kích hoạt
        user.setActive(true);

        return userRepository.save(user);
    }

    /**
     * Cập nhật thông tin user
     * @param id ID của user cần cập nhật
     * @param updatedUser Thông tin user mới
     * @return User đã được cập nhật
     * @throws RuntimeException Nếu không tìm thấy user hoặc có lỗi validation
     */
    public User updateUser(Long id, User updatedUser) {
        // Tìm user hiện tại
        User existingUser = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng với ID: " + id));

        // Validate thông tin user mới (không cần validate password nếu không đổi)
        validateUser(updatedUser, false);

        // Kiểm tra username trùng lặp (loại trừ chính nó)
        Optional<User> duplicateUsername = userRepository.findByUsername(updatedUser.getUsername());
        if (duplicateUsername.isPresent() && !duplicateUsername.get().getId().equals(id)) {
            throw new RuntimeException("Tên đăng nhập đã tồn tại: " + updatedUser.getUsername());
        }

        // Kiểm tra email trùng lặp (loại trừ chính nó)
        Optional<User> duplicateEmail = userRepository.findByEmail(updatedUser.getEmail());
        if (duplicateEmail.isPresent() && !duplicateEmail.get().getId().equals(id)) {
            throw new RuntimeException("Email đã tồn tại: " + updatedUser.getEmail());
        }

        // Cập nhật thông tin (không cập nhật password ở đây)
        existingUser.setUsername(updatedUser.getUsername());
        existingUser.setEmail(updatedUser.getEmail());
        existingUser.setFullName(updatedUser.getFullName());
        existingUser.setRole(updatedUser.getRole());
        existingUser.setActive(updatedUser.isActive());

        return userRepository.save(existingUser);
    }

    /**
     * Đổi mật khẩu cho user
     * @param userId ID của user
     * @param oldPassword Mật khẩu cũ
     * @param newPassword Mật khẩu mới
     * @throws RuntimeException Nếu mật khẩu cũ không đúng hoặc validation fail
     */
    public void changePassword(Long userId, String oldPassword, String newPassword) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng với ID: " + userId));

        // Kiểm tra mật khẩu cũ
        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            throw new RuntimeException("Mật khẩu cũ không chính xác");
        }

        // Validate mật khẩu mới
        validatePassword(newPassword);

        // Cập nhật mật khẩu mới
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }

    /**
     * Reset mật khẩu cho user (dành cho admin)
     * @param userId ID của user
     * @param newPassword Mật khẩu mới
     */
    public void resetPassword(Long userId, String newPassword) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng với ID: " + userId));

        // Validate mật khẩu mới
        validatePassword(newPassword);

        // Cập nhật mật khẩu mới
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }

    /**
     * Xóa user (soft delete - chuyển trạng thái thành inactive)
     * @param id ID của user cần xóa
     * @throws RuntimeException Nếu không tìm thấy user
     */
    public void deleteUser(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng với ID: " + id));

        // Soft delete - chuyển trạng thái thành inactive thay vì xóa hẳn
        user.setActive(false);
        userRepository.save(user);
    }

    /**
     * Khôi phục user (kích hoạt lại)
     * @param id ID của user cần khôi phục
     */
    public void restoreUser(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng với ID: " + id));

        user.setActive(true);
        userRepository.save(user);
    }

    /**
     * Tìm user theo ID
     * @param id ID của user
     * @return Optional<User>
     */
    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    /**
     * Tìm user theo username
     * @param username Tên đăng nhập
     * @return Optional<User>
     */
    public Optional<User> findByUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return Optional.empty();
        }
        return userRepository.findByUsername(username.trim());
    }

    /**
     * Tìm user theo email
     * @param email Email
     * @return Optional<User>
     */
    public Optional<User> findByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return Optional.empty();
        }
        return userRepository.findByEmail(email.trim());
    }

    /**
     * Tìm tất cả user
     * @return Danh sách tất cả user
     */
    public List<User> findAll() {
        return userRepository.findAll();
    }

    /**
     * Tìm user theo vai trò
     * @param role Vai trò
     * @return Danh sách user có vai trò đó
     */
    public List<User> findByRole(User.Role role) {
        if (role == null) {
            throw new RuntimeException("Vai trò không hợp lệ");
        }
        return userRepository.findByRole(role);
    }

    /**
     * Tìm user đang hoạt động theo vai trò
     * @param role Vai trò
     * @return Danh sách user đang hoạt động có vai trò đó
     */
    public List<User> findActiveByRole(User.Role role) {
        if (role == null) {
            throw new RuntimeException("Vai trò không hợp lệ");
        }
        return userRepository.findByRoleAndIsActive(role, true);
    }

    /**
     * Tìm user đang hoạt động
     * @return Danh sách user đang hoạt động
     */
    public List<User> findActiveUsers() {
        return userRepository.findByIsActive(true);
    }

    /**
     * Tìm kiếm user theo từ khóa
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách user chứa từ khóa
     */
    public List<User> searchUsers(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return findAll();
        }
        return userRepository.findByUsernameContainingIgnoreCaseOrEmailContainingIgnoreCase(keyword.trim());
    }

    /**
     * Đếm tổng số user
     * @return Số lượng user
     */
    public long countAllUsers() {
        return userRepository.count();
    }

    /**
     * Đếm số user theo vai trò
     * @param role Vai trò
     * @return Số lượng user
     */
    public long countByRole(User.Role role) {
        if (role == null) {
            return 0;
        }
        return userRepository.countByRole(role);
    }

    /**
     * Lấy user mới đăng ký gần đây
     * @param limit Số lượng user cần lấy
     * @return Danh sách user mới
     */
    public List<User> getRecentUsers(int limit) {
        return userRepository.findTopByOrderByCreatedAtDesc(limit);
    }

    /**
     * Kiểm tra username có tồn tại không
     * @param username Tên đăng nhập
     * @return true nếu tồn tại, false nếu không tồn tại
     */
    public boolean existsByUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }
        return userRepository.existsByUsername(username.trim());
    }

    /**
     * Kiểm tra email có tồn tại không
     * @param email Email
     * @return true nếu tồn tại, false nếu không tồn tại
     */
    public boolean existsByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return userRepository.existsByEmail(email.trim());
    }

    /**
     * Validate thông tin user
     * @param user User cần validate
     * @param isCreation true nếu đang tạo mới, false nếu đang cập nhật
     * @throws RuntimeException Nếu validation fail
     */
    private void validateUser(User user, boolean isCreation) {
        if (user == null) {
            throw new RuntimeException("Thông tin người dùng không được để trống");
        }

        // Validate username
        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
            throw new RuntimeException("Tên đăng nhập không được để trống");
        }

        String username = user.getUsername().trim();
        if (username.length() < 3) {
            throw new RuntimeException("Tên đăng nhập phải có ít nhất 3 ký tự");
        }

        if (username.length() > 50) {
            throw new RuntimeException("Tên đăng nhập không được vượt quá 50 ký tự");
        }

        if (!username.matches("^[a-zA-Z0-9_]+$")) {
            throw new RuntimeException("Tên đăng nhập chỉ được chứa chữ cái, số và dấu gạch dưới");
        }

        // Validate email
        if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            throw new RuntimeException("Email không được để trống");
        }

        String email = user.getEmail().trim();
        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            throw new RuntimeException("Email không hợp lệ");
        }

        // Validate password (chỉ khi tạo mới)
        if (isCreation) {
            validatePassword(user.getPassword());
        }

        // Validate role
        if (user.getRole() == null) {
            throw new RuntimeException("Vai trò không được để trống");
        }

        // Validate full name nếu có
        if (user.getFullName() != null && !user.getFullName().trim().isEmpty()) {
            String fullName = user.getFullName().trim();
            if (fullName.length() > 100) {
                throw new RuntimeException("Họ tên không được vượt quá 100 ký tự");
            }
        }
    }

    /**
     * Validate mật khẩu
     * @param password Mật khẩu cần validate
     * @throws RuntimeException Nếu validation fail
     */
    private void validatePassword(String password) {
        if (password == null || password.trim().isEmpty()) {
            throw new RuntimeException("Mật khẩu không được để trống");
        }

        if (password.length() < 6) {
            throw new RuntimeException("Mật khẩu phải có ít nhất 6 ký tự");
        }

        if (password.length() > 100) {
            throw new RuntimeException("Mật khẩu không được vượt quá 100 ký tự");
        }

        // Kiểm tra mật khẩu có chứa ít nhất một chữ cái và một số
        if (!password.matches(".*[a-zA-Z].*") || !password.matches(".*\\d.*")) {
            throw new RuntimeException("Mật khẩu phải chứa ít nhất một chữ cái và một số");
        }
    }
}