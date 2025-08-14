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

@Service
@Transactional
public class UserService implements UserDetailsService {

    // ===== METHODS CÒN THIẾU CHO USER SERVICE =====
    // Thêm các methods này vào UserService.java

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
     * Tìm users theo keyword
     */
    public Page<User> searchUsers(String keyword, Pageable pageable) {
        return userRepository.searchUsers(keyword, pageable);
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
     * Tạo user mới với validation
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

    /**
     * Validate password
     */
    private void validatePassword(String password) {
        if (password == null || password.length() < 6) {
            throw new RuntimeException("Mật khẩu phải ít nhất 6 ký tự");
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

    /**
     * Tìm user theo ID với exception
     */
    public static User findByIdOrThrow(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng với ID: " + id));
    }

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("Không tìm thấy người dùng: " + username));

        user.updateLastLogin();
        userRepository.save(user);

        return user;
    }

    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public User registerUser(User user) {
        validateUserForRegistration(user);
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setActive(true);
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());
        return userRepository.save(user);
    }

    public User createUser(User user) {
        return registerUser(user);
    }

    public User updateUser(User user) {
        if (user.getId() == null) {
            throw new RuntimeException("ID user không được để trống khi cập nhật");
        }

        User existingUser = userRepository.findById(user.getId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user với ID: " + user.getId()));

        existingUser.setFullName(user.getFullName());
        existingUser.setEmail(user.getEmail());
        existingUser.setPhoneNumber(user.getPhoneNumber());
        existingUser.setBio(user.getBio());
        existingUser.setProfileImageUrl(user.getProfileImageUrl());
        existingUser.setUpdatedAt(LocalDateTime.now());

        return userRepository.save(existingUser);
    }

    public boolean changePassword(Long userId, String oldPassword, String newPassword) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user"));

        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            throw new RuntimeException("Mật khẩu cũ không đúng");
        }

        user.setPassword(passwordEncoder.encode(newPassword));
        user.setUpdatedAt(LocalDateTime.now());
        userRepository.save(user);
        return true;
    }

    public User updateUserStatus(Long userId, boolean active) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user với ID: " + userId));

        user.setActive(active);
        user.setUpdatedAt(LocalDateTime.now());
        return userRepository.save(user);
    }

    public User updateUserRole(Long userId, User.Role newRole) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user với ID: " + userId));

        user.setRole(newRole);
        user.setUpdatedAt(LocalDateTime.now());
        return userRepository.save(user);
    }

    public void deleteUser(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user với ID: " + userId));

        user.setActive(false);
        user.setUpdatedAt(LocalDateTime.now());
        userRepository.save(user);
    }

    public Long countByRole(User.Role role) {
        return userRepository.countByRole(role);
    }

    public Long countUsersByRole(User.Role role) {
        return countByRole(role);
    }

    public List<User> findByRole(User.Role role) {
        return userRepository.findByRoleAndActiveOrderByFullName(role, true);
    }

    public Page<User> findByRole(User.Role role, Pageable pageable) {
        return userRepository.findByRole(role, pageable);
    }

    public List<User> findByRoleAndActive(User.Role role, boolean active) {
        return userRepository.findByRoleAndActiveOrderByFullName(role, active);
    }

    public Page<User> findByRoleAndActive(User.Role role, boolean active, Pageable pageable) {
        return userRepository.findByRoleAndActive(role, active, pageable);
    }

    public Long countByRoleAndActive(User.Role role, boolean active) {
        return userRepository.countByRoleAndActive(role, active);
    }

    public List<User> findActiveInstructors() {
        return userRepository.findByRoleAndActiveOrderByFullName(User.Role.INSTRUCTOR, true);
    }

    public List<User> findAllInstructorsOrderByName() {
        return userRepository.findAllInstructorsOrderByName();
    }

    public List<User> findTopInstructorsByCourseCount(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return userRepository
                .findInstructorsOrderByCourseCount(User.Role.INSTRUCTOR, true, pageable)
                .getContent(); // Lấy List từ Page
    }


    public Page<User> findInstructorsOrderByCourseCount(User.Role role, boolean active, Pageable pageable) {
        return userRepository.findInstructorsOrderByCourseCount(role, active, pageable);
    }

    public List<User> searchInstructors(String keyword, int limit) {
        return userRepository.searchInstructors(keyword, limit);
    }

    public Long countActiveInstructors() {
        return userRepository.countByRoleAndActive(User.Role.INSTRUCTOR, true);
    }

    public Long countStudentsByInstructor(User instructor) {
        return userRepository.countStudentsByInstructor(instructor);
    }

    public List<User> findAllStudentsOrderByName() {
        return userRepository.findAllStudentsOrderByName();
    }

    public Long countActiveStudents() {
        return userRepository.countByRoleAndActive(User.Role.STUDENT, true);
    }

    public Page<User> findTopStudentsByAverageScore(Pageable pageable) {
        return userRepository.findTopStudentsByAverageScore(pageable);
    }

    public List<User> findLowProgressStudents(User instructor, double maxProgress, LocalDateTime enrolledAfter) {
        return userRepository.findLowProgressStudents(instructor, maxProgress, enrolledAfter);
    }

    public Long countActiveUsers() {
        return userRepository.countByActive(true);
    }

    public Long countByActive(boolean active) {
        return userRepository.countByActive(active);
    }

    public Long countByActiveAndLastLoginAfter(boolean active, LocalDateTime lastLoginAfter) {
        return userRepository.countByActiveAndLastLoginAfter(active, lastLoginAfter);
    }

    public Long countActiveUsersInLastMonth() {
        LocalDateTime oneMonthAgo = LocalDateTime.now().minusMonths(1);
        return userRepository.countByActiveAndLastLoginAfter(true, oneMonthAgo);
    }

    public Long countAllUsers() {
        return userRepository.count();
    }

    public List<User> findAllActiveOrderByName() {
        return userRepository.findAllByActiveTrueOrderByFullName();
    }

    public Long countByCreatedAtAfter(LocalDateTime createdAfter) {
        return userRepository.countByCreatedAtAfter(createdAfter);
    }

    public List<User> findAllOrderByName() {
        return userRepository.findAll(Sort.by(Sort.Direction.ASC, "fullName"));
    }

    public Long countAll() {
        return userRepository.count();
    }

    public User save(User user) {
        validateUser(user);
        if (user.getId() == null) {
            user.setCreatedAt(LocalDateTime.now());
        }
        user.setUpdatedAt(LocalDateTime.now());
        return userRepository.save(user);
    }

    public Long countNewUsersThisMonth() {
        LocalDateTime startOfMonth = LocalDateTime.now().withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0);
        return userRepository.countByCreatedAtAfter(startOfMonth);
    }

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

    public List<User> searchUsersByKeyword(String keyword, Pageable pageable) {
        Page<User> userPage = userRepository.findByKeyword(keyword, pageable);
        return userPage.getContent();
    }

    public List<User> searchUsersByKeyword(String keyword, int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        Page<User> userPage = userRepository.findByKeyword(keyword, pageable);
        return userPage.getContent();
    }

    public List<User> findByRoleWithLimit(User.Role role, int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        Page<User> userPage = userRepository.findByRole(role, pageable);
        return userPage.getContent();
    }

    public List<User> findByRoleAndActiveWithLimit(User.Role role, boolean active, int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        Page<User> userPage = userRepository.findByRoleAndActive(role, active, pageable);
        return userPage.getContent();
    }

    public List<User> getAllInstructorsWithLimit(int limit) {
        return findByRoleAndActiveWithLimit(User.Role.INSTRUCTOR, true, limit);
    }

    public List<User> getAllStudentsWithLimit(int limit) {
        return findByRoleAndActiveWithLimit(User.Role.STUDENT, true, limit);
    }

    public List<User> getAllAdminsWithLimit(int limit) {
        return findByRoleWithLimit(User.Role.ADMIN, limit);
    }

    public Page<User> findByKeyword(String keyword, Pageable pageable) {
        return userRepository.findByKeyword(keyword, pageable);
    }

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

    public List<Object[]> getUserStatsByMonth(LocalDateTime fromDate) {
        return userRepository.getUserStatsByMonth(fromDate);
    }

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

    public boolean isUsernameExists(String username) {
        return userRepository.existsByUsername(username);
    }

    public boolean isEmailExists(String email) {
        return userRepository.existsByEmail(email);
    }

    public boolean isUsernameExists(String username, Long excludeId) {
        return userRepository.existsByUsernameAndIdNot(username, excludeId);
    }

    public boolean isEmailExists(String email, Long excludeId) {
        return userRepository.existsByEmailAndIdNot(email, excludeId);
    }

    public Long countAllActiveCourses() {
        return 0L;
    }

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
}
