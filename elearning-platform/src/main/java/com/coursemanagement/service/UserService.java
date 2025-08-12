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

import java.util.List;
import java.util.Optional;

/**
 * Service class để xử lý business logic liên quan đến User
 * Implement UserDetailsService để tích hợp với Spring Security
 */
@Service
@Transactional
public class UserService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    /**
     * Load user để đăng nhập (implement từ UserDetailsService)
     * @param username Tên đăng nhập
     * @return UserDetails cho Spring Security
     * @throws UsernameNotFoundException Nếu không tìm thấy user
     */
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // Tìm user theo username và phải đang hoạt động
        User user = userRepository.findByUsernameAndIsActive(username, true)
                .orElseThrow(() -> new UsernameNotFoundException("Không tìm thấy user: " + username));

        return user; // User entity đã implement UserDetails
    }

    /**
     * Tạo user mới
     * @param user User cần tạo
     * @return User đã được tạo
     * @throws RuntimeException Nếu username hoặc email đã tồn tại
     */
    public User createUser(User user) {
        // Kiểm tra username đã tồn tại chưa
        if (userRepository.existsByUsername(user.getUsername())) {
            throw new RuntimeException("Tên đăng nhập đã tồn tại: " + user.getUsername());
        }

        // Kiểm tra email đã tồn tại chưa
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new RuntimeException("Email đã tồn tại: " + user.getEmail());
        }

        // Mã hóa mật khẩu trước khi lưu
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
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user với ID: " + id));

        // Kiểm tra username trùng lặp (loại trừ user hiện tại)
        List<User> duplicateUsers = userRepository.findDuplicateUsernameOrEmail(
                updatedUser.getUsername(),
                updatedUser.getEmail(),
                id
        );

        if (!duplicateUsers.isEmpty()) {
            throw new RuntimeException("Username hoặc email đã tồn tại");
        }

        // Cập nhật thông tin
        existingUser.setUsername(updatedUser.getUsername());
        existingUser.setEmail(updatedUser.getEmail());
        existingUser.setRole(updatedUser.getRole());
        existingUser.setActive(updatedUser.isActive());

        // Chỉ cập nhật password nếu có password mới
        if (updatedUser.getPassword() != null && !updatedUser.getPassword().trim().isEmpty()) {
            existingUser.setPassword(passwordEncoder.encode(updatedUser.getPassword()));
        }

        return userRepository.save(existingUser);
    }

    /**
     * Xóa user
     * @param id ID của user cần xóa
     * @throws RuntimeException Nếu không tìm thấy user
     */
    public void deleteUser(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user với ID: " + id));

        userRepository.delete(user);
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
        return userRepository.findByUsername(username);
    }

    /**
     * Tìm user theo email
     * @param email Email
     * @return Optional<User>
     */
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    /**
     * Lấy tất cả user
     * @return Danh sách tất cả user
     */
    public List<User> findAll() {
        return userRepository.findAll();
    }

    /**
     * Lấy user theo role
     * @param role Vai trò
     * @return Danh sách user có vai trò đó
     */
    public List<User> findByRole(User.Role role) {
        return userRepository.findByRole(role);
    }

    /**
     * Lấy user đang hoạt động theo role
     * @param role Vai trò
     * @return Danh sách user đang hoạt động có vai trò đó
     */
    public List<User> findActiveUsersByRole(User.Role role) {
        return userRepository.findByRoleAndIsActive(role, true);
    }

    /**
     * Lấy tất cả giảng viên đang hoạt động
     * @return Danh sách giảng viên đang hoạt động
     */
    public List<User> findActiveInstructors() {
        return userRepository.findActiveInstructors();
    }

    /**
     * Lấy tất cả học viên đang hoạt động
     * @return Danh sách học viên đang hoạt động
     */
    public List<User> findActiveStudents() {
        return userRepository.findActiveStudents();
    }

    /**
     * Tìm kiếm user theo từ khóa
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách user chứa từ khóa
     */
    public List<User> searchUsers(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return userRepository.findAll();
        }
        return userRepository.findByUsernameOrEmailContaining(keyword.trim());
    }

    /**
     * Đổi mật khẩu user
     * @param userId ID của user
     * @param currentPassword Mật khẩu hiện tại
     * @param newPassword Mật khẩu mới
     * @throws RuntimeException Nếu mật khẩu hiện tại không đúng
     */
    public void changePassword(Long userId, String currentPassword, String newPassword) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user"));

        // Kiểm tra mật khẩu hiện tại
        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            throw new RuntimeException("Mật khẩu hiện tại không đúng");
        }

        // Cập nhật mật khẩu mới
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }

    /**
     * Reset mật khẩu user (chỉ admin)
     * @param userId ID của user
     * @param newPassword Mật khẩu mới
     */
    public void resetPassword(Long userId, String newPassword) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user"));

        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }

    /**
     * Kích hoạt/vô hiệu hóa tài khoản user
     * @param userId ID của user
     * @param isActive Trạng thái kích hoạt
     */
    public void toggleUserStatus(Long userId, boolean isActive) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user"));

        user.setActive(isActive);
        userRepository.save(user);
    }

    /**
     * Kiểm tra username có tồn tại không
     * @param username Tên đăng nhập
     * @return true nếu tồn tại, false nếu không
     */
    public boolean existsByUsername(String username) {
        return userRepository.existsByUsername(username);
    }

    /**
     * Kiểm tra email có tồn tại không
     * @param email Email
     * @return true nếu tồn tại, false nếu không
     */
    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }

    /**
     * Đếm số lượng user theo role
     * @param role Vai trò
     * @return Số lượng user
     */
    public long countByRole(User.Role role) {
        return userRepository.countByRole(role);
    }

    /**
     * Đếm số lượng user đang hoạt động
     * @return Số lượng user đang hoạt động
     */
    public long countActiveUsers() {
        return userRepository.countByIsActive(true);
    }

    /**
     * Đếm tổng số user
     * @return Tổng số user
     */
    public long countAllUsers() {
        return userRepository.count();
    }

    /**
     * Lấy user mới đăng ký gần đây
     * @param limit Số lượng user cần lấy
     * @return Danh sách user mới nhất
     */
    public List<User> getRecentUsers(int limit) {
        return userRepository.findTopNewestUsers(limit);
    }

    /**
     * Validate thông tin user trước khi tạo/cập nhật
     * @param user User cần validate
     * @param isUpdate Có phải là update không (true) hay tạo mới (false)
     * @throws RuntimeException Nếu có lỗi validation
     */
    public void validateUser(User user, boolean isUpdate) {
        // Kiểm tra username
        if (user.getUsername() == null || user.getUsername().trim().length() < 3) {
            throw new RuntimeException("Tên đăng nhập phải có ít nhất 3 ký tự");
        }

        // Kiểm tra email
        if (user.getEmail() == null || !user.getEmail().contains("@")) {
            throw new RuntimeException("Email không hợp lệ");
        }

        // Kiểm tra password (chỉ khi tạo mới hoặc có thay đổi password)
        if (!isUpdate && (user.getPassword() == null || user.getPassword().length() < 6)) {
            throw new RuntimeException("Mật khẩu phải có ít nhất 6 ký tự");
        }

        // Kiểm tra role
        if (user.getRole() == null) {
            throw new RuntimeException("Phải chọn vai trò cho người dùng");
        }
    }

    /**
     * Tạo user admin mặc định nếu chưa có
     * Gọi khi khởi động ứng dụng
     */
    public void createDefaultAdminIfNotExists() {
        // Kiểm tra đã có admin chưa
        List<User> admins = userRepository.findByRole(User.Role.ADMIN);

        if (admins.isEmpty()) {
            User admin = new User();
            admin.setUsername("admin");
            admin.setPassword("admin123"); // Sẽ được mã hóa trong createUser()
            admin.setEmail("admin@coursemanagement.com");
            admin.setRole(User.Role.ADMIN);
            admin.setActive(true);

            createUser(admin);
            System.out.println("Đã tạo tài khoản admin mặc định: admin/admin123");
        }
    }
}