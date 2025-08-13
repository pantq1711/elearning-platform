package com.coursemanagement.service;

import com.coursemanagement.entity.User;
import com.coursemanagement.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Service class để xử lý business logic liên quan đến User
 * Triển khai UserDetailsService để tích hợp với Spring Security
 * Bổ sung đầy đủ các methods cho admin management
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
     * Tìm user theo ID
     * @param id ID của user
     * @return Optional chứa User nếu tìm thấy
     */
    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    /**
     * Kiểm tra username đã tồn tại chưa
     * @param username Tên đăng nhập
     * @return true nếu đã tồn tại
     */
    public boolean existsByUsername(String username) {
        return userRepository.existsByUsername(username);
    }

    /**
     * Kiểm tra email đã tồn tại chưa
     * @param email Email
     * @return true nếu đã tồn tại
     */
    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
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

        // Set thời gian tạo
        user.setCreatedAt(LocalDateTime.now());
        user.setActive(true);

        return userRepository.save(user);
    }

    /**
     * Cập nhật thông tin user
     * @param user User cần cập nhật
     * @return User đã được cập nhật
     */
    public User updateUser(User user) {
        if (user.getId() == null) {
            throw new RuntimeException("ID user không được để trống khi cập nhật");
        }

        User existingUser = userRepository.findById(user.getId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user với ID: " + user.getId()));

        // Validate thông tin user (không check password)
        validateUser(user, false);

        // Kiểm tra username conflict (trừ chính user đó)
        if (!existingUser.getUsername().equals(user.getUsername()) &&
                userRepository.existsByUsername(user.getUsername())) {
            throw new RuntimeException("Tên đăng nhập đã tồn tại: " + user.getUsername());
        }

        // Kiểm tra email conflict (trừ chính user đó)
        if (!existingUser.getEmail().equals(user.getEmail()) &&
                userRepository.existsByEmail(user.getEmail())) {
            throw new RuntimeException("Email đã tồn tại: " + user.getEmail());
        }

        // Giữ nguyên mật khẩu và thời gian tạo
        user.setPassword(existingUser.getPassword());
        user.setCreatedAt(existingUser.getCreatedAt());

        return userRepository.save(user);
    }

    /**
     * Cập nhật last login time
     * @param userId ID của user
     */
    public void updateLastLogin(Long userId) {
        userRepository.findById(userId).ifPresent(user -> {
            user.setLastLogin(LocalDateTime.now());
            userRepository.save(user);
        });
    }

    /**
     * Thay đổi mật khẩu
     * @param userId ID user
     * @param currentPassword Mật khẩu hiện tại
     * @param newPassword Mật khẩu mới
     * @return true nếu thành công
     */
    public boolean changePassword(Long userId, String currentPassword, String newPassword) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user"));

        // Kiểm tra mật khẩu hiện tại
        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            return false;
        }

        // Validate mật khẩu mới
        validatePassword(newPassword);

        // Cập nhật mật khẩu mới
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        return true;
    }

    // ===== ADMIN MANAGEMENT METHODS =====

    /**
     * Đếm tổng số users
     * @return Số lượng users
     */
    public Long countAllUsers() {
        return userRepository.count();
    }

    /**
     * Đếm số users active trong tháng trước
     * @return Số lượng active users
     */
    public Long countActiveUsersInLastMonth() {
        LocalDateTime oneMonthAgo = LocalDateTime.now().minusMonths(1);
        return userRepository.countByActiveAndLastLoginAfter(true, oneMonthAgo);
    }

    /**
     * Đếm users theo role
     * @param role Role cần đếm
     * @return Số lượng users
     */
    public Long countUsersByRole(User.Role role) {
        return userRepository.countByRole(role);
    }

    /**
     * Đếm số users active
     * @return Số lượng active users
     */
    public Long countActiveUsers() {
        return userRepository.countByActive(true);
    }

    /**
     * Đếm users mới trong tháng này
     * @return Số lượng users mới
     */
    public Long countNewUsersThisMonth() {
        LocalDateTime startOfMonth = LocalDateTime.now().withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0);
        return userRepository.countByCreatedAtAfter(startOfMonth);
    }

    /**
     * Tìm users với filter và pagination
     * @param search Từ khóa tìm kiếm
     * @param role Role filter
     * @param status Status filter
     * @param pageable Pagination info
     * @return Page của users
     */
    public Page<User> findUsersWithFilter(String search, String role, String status, Pageable pageable) {
        // Tạo specification cho complex query
        return userRepository.findAll((root, query, criteriaBuilder) -> {
            var predicates = criteriaBuilder.conjunction();

            // Search filter (username, email, fullName)
            if (StringUtils.hasText(search)) {
                String searchPattern = "%" + search.toLowerCase() + "%";
                var searchPredicate = criteriaBuilder.or(
                        criteriaBuilder.like(criteriaBuilder.lower(root.get("username")), searchPattern),
                        criteriaBuilder.like(criteriaBuilder.lower(root.get("email")), searchPattern),
                        criteriaBuilder.like(criteriaBuilder.lower(root.get("fullName")), searchPattern)
                );
                predicates = criteriaBuilder.and(predicates, searchPredicate);
            }

            // Role filter
            if (StringUtils.hasText(role) && !"all".equals(role)) {
                try {
                    User.Role roleEnum = User.Role.valueOf(role.toUpperCase());
                    predicates = criteriaBuilder.and(predicates,
                            criteriaBuilder.equal(root.get("role"), roleEnum));
                } catch (IllegalArgumentException e) {
                    // Invalid role, ignore filter
                }
            }

            // Status filter
            if (StringUtils.hasText(status) && !"all".equals(status)) {
                boolean isActive = "active".equals(status);
                predicates = criteriaBuilder.and(predicates,
                        criteriaBuilder.equal(root.get("active"), isActive));
            }

            return predicates;
        }, pageable);
    }

    /**
     * Cập nhật trạng thái active của user
     * @param userId ID user
     * @param active Trạng thái mới
     */
    public void updateUserStatus(Long userId, boolean active) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user với ID: " + userId));

        user.setActive(active);
        userRepository.save(user);
    }

    /**
     * Cập nhật role của user
     * @param userId ID user
     * @param role Role mới
     */
    public void updateUserRole(Long userId, User.Role role) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user với ID: " + userId));

        user.setRole(role);
        userRepository.save(user);
    }

    /**
     * Tìm instructors active
     * @return Danh sách active instructors
     */
    public List<User> findActiveInstructors() {
        return userRepository.findByRoleAndActiveOrderByFullName(User.Role.INSTRUCTOR, true);
    }

    /**
     * Tìm instructors hoạt động tích cực nhất
     * @param limit Số lượng cần lấy
     * @return Danh sách top instructors
     */
    public List<User> findMostActiveInstructors(int limit) {
        Pageable pageable = PageRequest.of(0, limit, Sort.by("lastLogin").descending());
        return userRepository.findByRoleAndActive(User.Role.INSTRUCTOR, true, pageable);
    }

    /**
     * Lấy top instructors theo số enrollment
     * @param limit Số lượng cần lấy
     * @return Danh sách top instructors
     */
    public List<User> getTopInstructorsByEnrollments(int limit) {
        // Có thể implement query phức tạp hơn để đếm enrollments
        // Hiện tại trả về instructors active gần đây
        return findMostActiveInstructors(limit);
    }

    /**
     * Lấy thống kê tăng trưởng users theo tháng
     * @return Map chứa thống kê theo tháng
     */
    public Map<String, Long> getUserGrowthStats() {
        Map<String, Long> stats = new HashMap<>();

        LocalDateTime now = LocalDateTime.now();

        for (int i = 11; i >= 0; i--) {
            LocalDateTime monthStart = now.minusMonths(i).withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0);
            LocalDateTime monthEnd = monthStart.plusMonths(1).minusSeconds(1);

            Long count = userRepository.countByCreatedAtBetween(monthStart, monthEnd);
            String monthKey = monthStart.getMonth().toString() + " " + monthStart.getYear();
            stats.put(monthKey, count);
        }

        return stats;
    }

    /**
     * Lấy tất cả students active
     * @return Số lượng students active
     */
    public Long countActiveStudents() {
        return userRepository.countByRoleAndActive(User.Role.STUDENT, true);
    }

    /**
     * Lấy tất cả instructors active
     * @return Số lượng instructors active
     */
    public Long countActiveInstructors() {
        return userRepository.countByRoleAndActive(User.Role.INSTRUCTOR, true);
    }

    // ===== PRIVATE HELPER METHODS =====

    /**
     * Validate thông tin user
     * @param user User cần validate
     * @param checkPassword Có check password hay không
     */
    private void validateUser(User user, boolean checkPassword) {
        if (user == null) {
            throw new RuntimeException("Thông tin user không được để trống");
        }

        // Validate username
        if (!StringUtils.hasText(user.getUsername())) {
            throw new RuntimeException("Tên đăng nhập không được để trống");
        }
        if (user.getUsername().length() < 3) {
            throw new RuntimeException("Tên đăng nhập phải có ít nhất 3 ký tự");
        }
        if (user.getUsername().length() > 50) {
            throw new RuntimeException("Tên đăng nhập không được vượt quá 50 ký tự");
        }

        // Validate email
        if (!StringUtils.hasText(user.getEmail())) {
            throw new RuntimeException("Email không được để trống");
        }
        if (!isValidEmail(user.getEmail())) {
            throw new RuntimeException("Định dạng email không hợp lệ");
        }

        // Validate full name
        if (!StringUtils.hasText(user.getFullName())) {
            throw new RuntimeException("Họ tên không được để trống");
        }
        if (user.getFullName().length() > 100) {
            throw new RuntimeException("Họ tên không được vượt quá 100 ký tự");
        }

        // Validate password nếu cần
        if (checkPassword) {
            validatePassword(user.getPassword());
        }

        // Validate role
        if (user.getRole() == null) {
            user.setRole(User.Role.STUDENT); // Default role
        }
    }

    /**
     * Validate password
     * @param password Mật khẩu cần validate
     */
    private void validatePassword(String password) {
        if (!StringUtils.hasText(password)) {
            throw new RuntimeException("Mật khẩu không được để trống");
        }
        if (password.length() < 6) {
            throw new RuntimeException("Mật khẩu phải có ít nhất 6 ký tự");
        }
        if (password.length() > 100) {
            throw new RuntimeException("Mật khẩu không được vượt quá 100 ký tự");
        }
    }

    /**
     * Kiểm tra email format
     * @param email Email cần kiểm tra
     * @return true nếu valid
     */
    private boolean isValidEmail(String email) {
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
        return email.matches(emailRegex);
    }
}