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
import java.util.*;
import java.util.stream.Collectors;

/**
 * Service quản lý User - authentication và user management
 * Implements UserDetailsService cho Spring Security
 * SỬA LỖI: Đã sửa static field injection và tất cả các vấn đề compilation
 * Hoàn chỉnh với tất cả methods từ file gốc
 */
@Service
@Transactional
public class UserService implements UserDetailsService {

    // SỬA LỖI: Bỏ static để tránh vấn đề injection
    @Autowired
    private UserRepository userRepository; // ✅ Instance field thay vì static

    @Autowired
    private PasswordEncoder passwordEncoder;

    // ===== IMPLEMENTATION CỦA UserDetailsService =====

    /**
     * Load user by username cho Spring Security
     * @param username Username hoặc email
     * @return UserDetails object
     * @throws UsernameNotFoundException Nếu không tìm thấy user
     */
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // Tìm theo username hoặc email
        User user = userRepository.findByUsername(username)
                .or(() -> userRepository.findByEmail(username))
                .orElseThrow(() -> new UsernameNotFoundException("Không tìm thấy người dùng: " + username));

        // Cập nhật last login
        user.updateLastLogin();
        userRepository.save(user);

        return user;
    }

    /**
     * DEBUG: Test password matching
     */
    public void testPasswordMatching(String username, String rawPassword) {
        try {
            Optional<User> userOpt = findByUsername(username);
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                boolean matches = passwordEncoder.matches(rawPassword, user.getPassword());
                System.out.println("🔍 Password test for user: " + username);
                System.out.println("🔍 Raw password: " + rawPassword);
                System.out.println("🔍 Encoded password: " + user.getPassword());
                System.out.println("🔍 Password matches: " + matches);
                System.out.println("🔍 User active: " + user.isActive());
                System.out.println("🔍 User role: " + user.getRole());
            } else {
                System.out.println("❌ User not found: " + username);
            }
        } catch (Exception e) {
            System.out.println("❌ Error testing password: " + e.getMessage());
            e.printStackTrace();
        }
    }
    // ===== CÁC THAO TÁC CRUD CƠ BẢN =====

    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    /**
     * Đăng ký user mới
     */
    @Transactional
    public User registerUser(User user) {
        validateUserForRegistration(user);
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setActive(true);
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());
        return userRepository.save(user);
    }

    /**
     * Tạo user mới (alias của registerUser)
     */
    public User createUser(User user) {
        return registerUser(user);
    }

    /**
     * Cập nhật thông tin user
     */
    @Transactional
    public User updateUser(User user) {
        if (user.getId() == null) {
            throw new RuntimeException("ID user không được để trống khi cập nhật");
        }

        User existingUser = userRepository.findById(user.getId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user với ID: " + user.getId()));

        // Cập nhật các fields
        existingUser.setFullName(user.getFullName());
        existingUser.setEmail(user.getEmail());
        existingUser.setPhoneNumber(user.getPhoneNumber());
        existingUser.setBio(user.getBio());
        existingUser.setProfileImageUrl(user.getProfileImageUrl());
        existingUser.setUpdatedAt(LocalDateTime.now());

        return userRepository.save(existingUser);
    }

    /**
     * Thay đổi mật khẩu
     */
    @Transactional
    public boolean changePassword(Long userId, String oldPassword, String newPassword) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user"));

        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            throw new RuntimeException("Mật khẩu cũ không đúng");
        }

        validatePassword(newPassword);
        user.setPassword(passwordEncoder.encode(newPassword));
        user.setUpdatedAt(LocalDateTime.now());
        userRepository.save(user);
        return true;
    }

    /**
     * Cập nhật trạng thái user (active/inactive)
     */
    @Transactional
    public User updateUserStatus(Long userId, boolean active) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user với ID: " + userId));

        user.setActive(active);
        user.setUpdatedAt(LocalDateTime.now());
        return userRepository.save(user);
    }

    /**
     * Cập nhật role của user
     */
    @Transactional
    public User updateUserRole(Long userId, User.Role newRole) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user với ID: " + userId));

        user.setRole(newRole);
        user.setUpdatedAt(LocalDateTime.now());
        return userRepository.save(user);
    }

    /**
     * Xóa user (soft delete)
     */
    @Transactional
    public void deleteUser(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user với ID: " + userId));

        user.setActive(false);
        user.setUpdatedAt(LocalDateTime.now());
        userRepository.save(user);
    }

    // ===== CÁC THAO TÁC QUERY VÀ THỐNG KÊ =====

    /**
     * Đếm số lượng user theo role
     */
    public Long countByRole(User.Role role) {
        return userRepository.countByRole(role);
    }

    /**
     * Alias của countByRole
     */
    public Long countUsersByRole(User.Role role) {
        return countByRole(role);
    }

    /**
     * Tìm users theo role (active only)
     */
    public List<User> findByRole(User.Role role) {
        return userRepository.findByRoleAndActiveOrderByFullName(role, true);
    }

    /**
     * Tìm users theo role với pagination
     */
    public Page<User> findByRole(User.Role role, Pageable pageable) {
        return userRepository.findByRole(role, pageable);
    }

    /**
     * Tìm users theo role và trạng thái
     */
    public List<User> findByRoleAndActive(User.Role role, boolean active) {
        return userRepository.findByRoleAndActiveOrderByFullName(role, active);
    }

    /**
     * Tìm users theo role và trạng thái với pagination
     */
    public Page<User> findByRoleAndActive(User.Role role, boolean active, Pageable pageable) {
        return userRepository.findByRoleAndActive(role, active, pageable);
    }

    /**
     * Đếm users theo role và trạng thái
     */
    public Long countByRoleAndActive(User.Role role, boolean active) {
        return userRepository.countByRoleAndActive(role, active);
    }

    // ===== INSTRUCTOR SPECIFIC METHODS =====

    /**
     * Tìm active instructors
     */
    public List<User> findActiveInstructors() {
        return userRepository.findByRoleAndActiveOrderByFullName(User.Role.INSTRUCTOR, true);
    }

    /**
     * Tìm tất cả instructors order by name
     */
    public List<User> findAllInstructorsOrderByName() {
        return userRepository.findAllInstructorsOrderByName();
    }

    /**
     * Tìm top instructors theo course count
     */
    public List<User> findTopInstructorsByCourseCount(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return userRepository
                .findInstructorsOrderByCourseCount(User.Role.INSTRUCTOR, true, pageable)
                .getContent(); // Lấy List từ Page
    }

    /**
     * Tìm instructors order by course count với pagination
     */
    public Page<User> findInstructorsOrderByCourseCount(User.Role role, boolean active, Pageable pageable) {
        return userRepository.findInstructorsOrderByCourseCount(role, active, pageable);
    }

    /**
     * Search instructors
     */
    public List<User> searchInstructors(String keyword, int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return userRepository.searchInstructors(keyword, pageable);
    }

    /**
     * Đếm active instructors
     */
    public Long countActiveInstructors() {
        return userRepository.countByRoleAndActive(User.Role.INSTRUCTOR, true);
    }

    /**
     * Đếm students của instructor
     */
    public Long countStudentsByInstructor(User instructor) {
        return userRepository.countStudentsByInstructor(instructor);
    }

    // ===== STUDENT SPECIFIC METHODS =====

    /**
     * Tìm tất cả students order by name
     */
    public List<User> findAllStudentsOrderByName() {
        return userRepository.findAllStudentsOrderByName();
    }

    /**
     * Đếm active students
     */
    public Long countActiveStudents() {
        return userRepository.countByRoleAndActive(User.Role.STUDENT, true);
    }

    /**
     * Tìm top students theo average score
     */
    public Page<User> findTopStudentsByAverageScore(Pageable pageable) {
        return userRepository.findTopStudentsByAverageScore(pageable);
    }

    /**
     * Tìm students có progress thấp
     */
    public List<User> findLowProgressStudents(User instructor, double maxProgress, LocalDateTime enrolledAfter) {
        return userRepository.findLowProgressStudents(instructor, maxProgress, enrolledAfter);
    }

    // ===== GENERAL USER STATISTICS =====

    /**
     * Đếm active users
     */
    public Long countActiveUsers() {
        return userRepository.countByActive(true);
    }

    /**
     * Đếm users theo trạng thái
     */
    public Long countByActive(boolean active) {
        return userRepository.countByActive(active);
    }

    /**
     * Đếm users active và đăng nhập sau ngày cụ thể
     */
    public Long countByActiveAndLastLoginAfter(boolean active, LocalDateTime lastLoginAfter) {
        return userRepository.countByActiveAndLastLoginAfter(active, lastLoginAfter);
    }

    /**
     * Đếm active users trong tháng qua
     */
    public Long countActiveUsersInLastMonth() {
        LocalDateTime oneMonthAgo = LocalDateTime.now().minusMonths(1);
        return userRepository.countByActiveAndLastLoginAfter(true, oneMonthAgo);
    }

    /**
     * Đếm tất cả users
     */
    public Long countAllUsers() {
        return userRepository.count();
    }

    /**
     * Tìm tất cả active users order by name
     */
    public List<User> findAllActiveOrderByName() {
        return userRepository.findAllByActiveTrueOrderByFullName();
    }

    /**
     * Đếm users được tạo sau ngày cụ thể
     */
    public Long countByCreatedAtAfter(LocalDateTime createdAfter) {
        return userRepository.countByCreatedAtAfter(createdAfter);
    }

    /**
     * Tìm tất cả users order by name
     */
    public List<User> findAllOrderByName() {
        return userRepository.findAll(Sort.by(Sort.Direction.ASC, "fullName"));
    }

    /**
     * Alias của countAllUsers
     */
    public Long countAll() {
        return userRepository.count();
    }

    /**
     * Save user với validation
     */
    public User save(User user) {
        validateUser(user);
        if (user.getId() == null) {
            user.setCreatedAt(LocalDateTime.now());
        }
        user.setUpdatedAt(LocalDateTime.now());
        return userRepository.save(user);
    }

    /**
     * Đếm users mới trong tháng này
     */
    public Long countNewUsersThisMonth() {
        LocalDateTime startOfMonth = LocalDateTime.now().withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0);
        return userRepository.countByCreatedAtAfter(startOfMonth);
    }

    // ===== SEARCH VÀ FILTER METHODS =====

    /**
     * Tìm users với filter
     */
    public Page<User> findUsersWithFilter(String search, String role, String status, Pageable pageable) {
        return userRepository.findAll((root, query, criteriaBuilder) -> {
            var predicates = criteriaBuilder.conjunction();

            if (StringUtils.hasText(search)) {
                String searchPattern = "%" + search.toLowerCase() + "%";
                var searchPredicate = criteriaBuilder.or(
                        criteriaBuilder.like(criteriaBuilder.lower(root.get("username")), searchPattern),
                        criteriaBuilder.like(criteriaBuilder.lower(root.get("email")), searchPattern),
                        criteriaBuilder.like(criteriaBuilder.lower(root.get("fullName")), searchPattern)
                );
                predicates = criteriaBuilder.and(predicates, searchPredicate);
            }

            if (StringUtils.hasText(role) && !"all".equals(role)) {
                try {
                    User.Role roleEnum = User.Role.valueOf(role.toUpperCase());
                    predicates = criteriaBuilder.and(predicates,
                            criteriaBuilder.equal(root.get("role"), roleEnum));
                } catch (IllegalArgumentException e) {
                    // Ignore invalid role
                }
            }

            if (StringUtils.hasText(status) && !"all".equals(status)) {
                boolean activeStatus = "active".equals(status);
                predicates = criteriaBuilder.and(predicates,
                        criteriaBuilder.equal(root.get("active"), activeStatus));
            }

            return predicates;
        }, pageable);
    }

    /**
     * Search users by keyword (multiple overloads)
     */
    public List<User> searchUsersByKeyword(String keyword, Pageable pageable) {
        Page<User> userPage = userRepository.findByKeyword(keyword, pageable);
        return userPage.getContent();
    }

    public List<User> searchUsersByKeyword(String keyword, int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        Page<User> userPage = userRepository.findByKeyword(keyword, pageable);
        return userPage.getContent();
    }

    public Page<User> findByKeyword(String keyword, Pageable pageable) {
        return userRepository.findByKeyword(keyword, pageable);
    }

    /**
     * Search users with pagination
     */
    public Page<User> searchUsers(String keyword, Pageable pageable) {
        return userRepository.searchUsers(keyword, pageable);
    }

    // ===== UTILITY METHODS WITH LIMITS =====

    /**
     * Tìm users theo role với limit
     */
    public List<User> findByRoleWithLimit(User.Role role, int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        Page<User> userPage = userRepository.findByRole(role, pageable);
        return userPage.getContent();
    }

    /**
     * Tìm users theo role và active với limit
     */
    public List<User> findByRoleAndActiveWithLimit(User.Role role, boolean active, int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        Page<User> userPage = userRepository.findByRoleAndActive(role, active, pageable);
        return userPage.getContent();
    }

    /**
     * Lấy instructors với limit
     */
    public List<User> getAllInstructorsWithLimit(int limit) {
        return findByRoleAndActiveWithLimit(User.Role.INSTRUCTOR, true, limit);
    }

    /**
     * Lấy students với limit
     */
    public List<User> getAllStudentsWithLimit(int limit) {
        return findByRoleAndActiveWithLimit(User.Role.STUDENT, true, limit);
    }

    /**
     * Lấy admins với limit
     */
    public List<User> getAllAdminsWithLimit(int limit) {
        return findByRoleWithLimit(User.Role.ADMIN, limit);
    }

    // ===== MISSING METHODS FROM ORIGINAL FILE =====

    /**
     * Cập nhật last login time
     */
    @Transactional
    public void updateLastLogin(Long userId) {
        userRepository.updateLastLogin(userId, LocalDateTime.now());
    }

    /**
     * Tìm top instructors theo enrollment count
     */
    public List<User> getTopInstructorsByEnrollments(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        List<Object[]> results = userRepository.getTopInstructorsByEnrollments(pageable);

        return results.stream()
                .map(result -> (User) result[0])
                .collect(Collectors.toList());
    }

    /**
     * Lấy user growth statistics
     */
    public Map<String, Long> getUserGrowthStats() {
        LocalDateTime fromDate = LocalDateTime.now().minusMonths(12);
        List<Object[]> stats = userRepository.getUserGrowthStats(fromDate);

        Map<String, Long> result = new HashMap<>();
        for (Object[] stat : stats) {
            Integer year = (Integer) stat[0];
            Integer month = (Integer) stat[1];
            Long count = (Long) stat[2];
            String key = year + "-" + String.format("%02d", month);
            result.put(key, count);
        }

        return result;
    }

    /**
     * Tìm users theo role và active status
     */
    public Page<User> findUsersByRoleAndActive(User.Role role, boolean active, Pageable pageable) {
        return userRepository.findByRoleAndActive(role, active, pageable);
    }

    /**
     * Tìm recent users
     */
    public List<User> findRecentUsers(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return userRepository.findRecentUsers(pageable);
    }

    /**
     * Đếm users được tạo trong khoảng thời gian
     */
    public Long countUsersCreatedBetween(LocalDateTime startDate, LocalDateTime endDate) {
        return userRepository.countUsersCreatedBetween(startDate, endDate);
    }

    /**
     * Tìm instructors có nhiều students nhất
     */
    public List<User> findInstructorsWithMostStudents(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        List<Object[]> results = userRepository.findInstructorsWithMostStudents(pageable);

        return results.stream()
                .map(result -> (User) result[0])
                .collect(Collectors.toList());
    }

    /**
     * Tìm active students
     */
    public List<User> findActiveStudents(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return userRepository.findActiveStudents(pageable);
    }

    /**
     * Kiểm tra username đã tồn tại chưa
     */
    public boolean existsByUsername(String username) {
        return userRepository.existsByUsername(username);
    }

    /**
     * Kiểm tra email đã tồn tại chưa
     */
    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }

    /**
     * Tạo user mới với validation đầy đủ
     */
    @Transactional
    public User createUser(User user, String rawPassword) {
        validateUser(user);

        // Kiểm tra username và email đã tồn tại chưa
        if (existsByUsername(user.getUsername())) {
            throw new RuntimeException("Username đã tồn tại: " + user.getUsername());
        }

        if (existsByEmail(user.getEmail())) {
            throw new RuntimeException("Email đã tồn tại: " + user.getEmail());
        }

        // Validate password
        validatePassword(rawPassword);

        // Mã hóa password
        user.setPassword(passwordEncoder.encode(rawPassword));
        user.setActive(true);
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());

        return userRepository.save(user);
    }

    /**
     * Reset password
     */
    @Transactional
    public String resetPassword(Long userId) {
        User user = findByIdOrThrow(userId);

        // Tạo password mới
        String newPassword = generateRandomPassword();
        user.setPassword(passwordEncoder.encode(newPassword));
        user.setUpdatedAt(LocalDateTime.now());

        userRepository.save(user);

        return newPassword;
    }

    // ===== STATISTICS METHODS =====

    /**
     * Lấy thống kê user theo tháng
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
     * Lấy user stats theo tháng
     */
    public List<Object[]> getUserStatsByMonth(LocalDateTime fromDate) {
        return userRepository.getUserStatsByMonth(fromDate);
    }

    /**
     * Lấy dashboard statistics
     */
    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();

        stats.put("totalUsers", userRepository.count());
        stats.put("activeUsers", userRepository.countByActive(true));
        stats.put("inactiveUsers", userRepository.countByActive(false));

        stats.put("totalInstructors", userRepository.countByRole(User.Role.INSTRUCTOR));
        stats.put("totalStudents", userRepository.countByRole(User.Role.STUDENT));
        stats.put("totalAdmins", userRepository.countByRole(User.Role.ADMIN));

        LocalDateTime thirtyDaysAgo = LocalDateTime.now().minusDays(30);
        stats.put("newUsersThisMonth", userRepository.countByCreatedAtAfter(thirtyDaysAgo));

        LocalDateTime sevenDaysAgo = LocalDateTime.now().minusDays(7);
        stats.put("activeUsersThisWeek", userRepository.countByActiveAndLastLoginAfter(true, sevenDaysAgo));

        return stats;
    }

    // ===== EXISTENCE CHECK METHODS =====

    /**
     * Kiểm tra username tồn tại
     */
    public boolean isUsernameExists(String username) {
        return userRepository.existsByUsername(username);
    }

    /**
     * Kiểm tra email tồn tại
     */
    public boolean isEmailExists(String email) {
        return userRepository.existsByEmail(email);
    }

    /**
     * Kiểm tra username tồn tại (exclude ID)
     */
    public boolean isUsernameExists(String username, Long excludeId) {
        return userRepository.existsByUsernameAndIdNot(username, excludeId);
    }

    /**
     * Kiểm tra email tồn tại (exclude ID)
     */
    public boolean isEmailExists(String email, Long excludeId) {
        return userRepository.existsByEmailAndIdNot(email, excludeId);
    }

    /**
     * Placeholder method
     */
    public Long countAllActiveCourses() {
        return 0L;
    }

    /**
     * Tìm user theo ID với exception
     * SỬA LỖI: Bỏ static vì userRepository giờ là instance field
     */
    public User findByIdOrThrow(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng với ID: " + id));
    }

    // ===== PRIVATE VALIDATION METHODS =====

    /**
     * Validate user cho registration
     */
    private void validateUserForRegistration(User user) {
        validateUser(user);

        if (!StringUtils.hasText(user.getPassword())) {
            throw new RuntimeException("Password không được để trống");
        }

        if (userRepository.existsByUsername(user.getUsername())) {
            throw new RuntimeException("Username đã tồn tại: " + user.getUsername());
        }

        if (userRepository.existsByEmail(user.getEmail())) {
            throw new RuntimeException("Email đã tồn tại: " + user.getEmail());
        }
    }

    /**
     * Validate user cơ bản
     */
    private void validateUser(User user) {
        if (user == null) {
            throw new RuntimeException("User không được để trống");
        }

        if (!StringUtils.hasText(user.getUsername())) {
            throw new RuntimeException("Username không được để trống");
        }

        if (!StringUtils.hasText(user.getEmail())) {
            throw new RuntimeException("Email không được để trống");
        }

        if (!StringUtils.hasText(user.getFullName())) {
            throw new RuntimeException("Họ tên không được để trống");
        }

        if (user.getRole() == null) {
            throw new RuntimeException("Role không được để trống");
        }

        if (!user.getEmail().matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new RuntimeException("Email không đúng định dạng");
        }

        if (user.getUsername().length() < 3 || user.getUsername().length() > 50) {
            throw new RuntimeException("Username phải từ 3-50 ký tự");
        }
    }

    /**
     * Validate password
     */
    private void validatePassword(String password) {
        if (password == null || password.length() < 6) {
            throw new RuntimeException("Mật khẩu phải ít nhất 6 ký tự");
        }

        // Có thể thêm rule phức tạp hơn
        if (password.length() > 100) {
            throw new RuntimeException("Mật khẩu không được quá 100 ký tự");
        }
    }

    /**
     * Generate random password
     */
    private String generateRandomPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder password = new StringBuilder();
        Random random = new Random();

        for (int i = 0; i < 8; i++) {
            password.append(chars.charAt(random.nextInt(chars.length())));
        }

        return password.toString();
    }
}