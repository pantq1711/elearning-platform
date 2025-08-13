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
     * Tìm user theo username
     * @param username Username của user
     * @return Optional chứa User nếu tìm thấy
     */
    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    /**
     * Tìm user theo email
     * @param email Email của user
     * @return Optional chứa User nếu tìm thấy
     */
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    /**
     * Đăng ký user mới
     * @param user User cần đăng ký
     * @return User đã được tạo
     */
    public User registerUser(User user) {
        // Validate thông tin đầu vào
        validateUserForRegistration(user);

        // Mã hóa mật khẩu
        user.setPassword(passwordEncoder.encode(user.getPassword()));

        // Set các thông tin mặc định
        user.setActive(true);
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());

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

        // Cập nhật các thông tin được phép thay đổi
        existingUser.setFullName(user.getFullName());
        existingUser.setEmail(user.getEmail());
        existingUser.setPhoneNumber(user.getPhoneNumber());
        existingUser.setBio(user.getBio());
        existingUser.setProfileImageUrl(user.getProfileImageUrl());
        existingUser.setUpdatedAt(LocalDateTime.now());

        return userRepository.save(existingUser);
    }

    /**
     * Đổi mật khẩu user
     * @param userId ID của user
     * @param oldPassword Mật khẩu cũ
     * @param newPassword Mật khẩu mới
     * @return true nếu đổi thành công
     */
    public boolean changePassword(Long userId, String oldPassword, String newPassword) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user"));

        // Kiểm tra mật khẩu cũ
        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            throw new RuntimeException("Mật khẩu cũ không đúng");
        }

        // Cập nhật mật khẩu mới
        user.setPassword(passwordEncoder.encode(newPassword));
        user.setUpdatedAt(LocalDateTime.now());
        userRepository.save(user);

        return true;
    }

    /**
     * Đếm số users theo role
     * @param role Role cần đếm
     * @return Số lượng users
     */
    public Long countByRole(User.Role role) {
        return userRepository.countByRole(role);
    }

    /**
     * Đếm tất cả users
     * @return Tổng số users
     */
    public Long countAllUsers() {
        return userRepository.count();
    }

    /**
     * Đếm users active trong tháng qua
     * @return Số lượng active users
     */
    public Long countActiveUsersInLastMonth() {
        LocalDateTime oneMonthAgo = LocalDateTime.now().minusMonths(1);
        return userRepository.countByActiveAndLastLoginAfter(true, oneMonthAgo);
    }

    /**
     * Đếm users theo role và status active
     * @param role Role cần đếm
     * @param active Status active
     * @return Số lượng users
     */
    public Long countByRoleAndActive(User.Role role, boolean active) {
        return userRepository.countByRoleAndActive(role, active);
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
     * Tìm users theo role và status active
     * @param role Role
     * @param active Status active
     * @return Danh sách users
     */
    public List<User> findByRoleAndActive(User.Role role, boolean active) {
        return userRepository.findByRoleAndActiveOrderByFullName(role, active);
    }

    /**
     * Tìm instructors theo số lượng courses
     * @param limit Số lượng giới hạn
     * @return Danh sách instructors
     */
    public List<User> findTopInstructorsByCourseCount(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return userRepository.findInstructorsOrderByCourseCount(User.Role.INSTRUCTOR, true, pageable);
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
                boolean activeStatus = "active".equals(status);
                predicates = criteriaBuilder.and(predicates,
                        criteriaBuilder.equal(root.get("active"), activeStatus));
            }

            return predicates;
        }, pageable);
    }

    /**
     * Tìm users theo keyword trong multiple fields
     * @param keyword Từ khóa tìm kiếm
     * @param pageable Pagination info
     * @return Danh sách users
     */
    public List<User> searchUsersByKeyword(String keyword, Pageable pageable) {
        return userRepository.findByKeyword(keyword, pageable);
    }

    /**
     * Active/Deactive user
     * @param userId ID của user
     * @param active Status active mới
     * @return User đã được cập nhật
     */
    public User updateUserStatus(Long userId, boolean active) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user với ID: " + userId));

        user.setActive(active);
        user.setUpdatedAt(LocalDateTime.now());

        return userRepository.save(user);
    }

    /**
     * Xóa user (soft delete)
     * @param userId ID của user
     */
    public void deleteUser(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user với ID: " + userId));

        // Soft delete - chỉ set active = false
        user.setActive(false);
        user.setUpdatedAt(LocalDateTime.now());
        userRepository.save(user);
    }

    /**
     * Lấy thống kê users theo tháng
     * @return Map chứa thống kê theo tháng
     */
    public Map<String, Object> getUserStatisticsByMonth() {
        LocalDateTime oneYearAgo = LocalDateTime.now().minusYears(1);
        List<Object[]> stats = userRepository.getUserStatsByMonth(oneYearAgo);

        Map<String, Object> result = new HashMap<>();
        result.put("monthlyStats", stats);
        result.put("totalUsers", countAllUsers());
        result.put("activeUsers", countActiveUsers());
        result.put("newUsersThisMonth", countNewUsersThisMonth());

        return result;
    }

    /**
     * Đếm users theo role (alias cho countByRole)
     * @param role Role cần đếm
     * @return Số lượng users
     */
    public Long countUsersByRole(User.Role role) {
        return countByRole(role);
    }

    /**
     * Tìm users theo role
     * @param role Role cần tìm
     * @return Danh sách users
     */
    public List<User> findByRole(User.Role role) {
        return userRepository.findByRoleAndActiveOrderByFullName(role, true);
    }

    /**
     * Tạo user mới
     * @param user User cần tạo
     * @return User đã được tạo
     */
    public User createUser(User user) {
        return registerUser(user);
    }

    /**
     * Cập nhật role của user
     * @param userId ID của user
     * @param newRole Role mới
     * @return User đã được cập nhật
     */
    public User updateUserRole(Long userId, User.Role newRole) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user với ID: " + userId));

        user.setRole(newRole);
        user.setUpdatedAt(LocalDateTime.now());

        return userRepository.save(user);
    }

    /**
     * Tìm active instructors
     * @return Danh sách active instructors
     */
    public List<User> findActiveInstructors() {
        return userRepository.findByRoleAndActiveOrderByFullName(User.Role.INSTRUCTOR, true);
    }

    /**
     * Đếm active students
     * @return Số lượng active students
     */
    public Long countActiveStudents() {
        return userRepository.countByRoleAndActive(User.Role.STUDENT, true);
    }

    /**
     * Đếm active instructors
     * @return Số lượng active instructors
     */
    public Long countActiveInstructors() {
        return userRepository.countByRoleAndActive(User.Role.INSTRUCTOR, true);
    }

    /**
     * Đếm tất cả active courses (alias method)
     * @return Số lượng active courses
     */
    public Long countAllActiveCourses() {
        // This method should be in CourseService, but adding here for compatibility
        return 0L; // Placeholder - should call courseService.countActiveCourses()
    }

    /**
     * Validation tổng thể
     * @param user User cần validate
     */
    private void validateUserForRegistration(User user) {
        if (!StringUtils.hasText(user.getUsername())) {
            throw new RuntimeException("Username không được để trống");
        }

        if (!StringUtils.hasText(user.getEmail())) {
            throw new RuntimeException("Email không được để trống");
        }

        if (!StringUtils.hasText(user.getPassword())) {
            throw new RuntimeException("Password không được để trống");
        }

        // Kiểm tra username đã tồn tại
        if (userRepository.existsByUsername(user.getUsername())) {
            throw new RuntimeException("Username đã tồn tại: " + user.getUsername());
        }

        // Kiểm tra email đã tồn tại
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new RuntimeException("Email đã tồn tại: " + user.getEmail());
        }
    }
}