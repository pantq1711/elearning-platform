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

    // ===== SPRING SECURITY INTEGRATION =====

    /**
     * Load user cho Spring Security authentication
     */
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("Không tìm thấy người dùng: " + username));

        user.updateLastLogin();
        userRepository.save(user);

        return user;
    }

    // ===== BASIC CRUD OPERATIONS =====

    /**
     * Tìm user theo ID
     */
    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    /**
     * Tìm user theo username
     */
    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    /**
     * Tìm user theo email
     */
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    /**
     * Đăng ký user mới
     */
    public User registerUser(User user) {
        validateUserForRegistration(user);

        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setActive(true);
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());

        return userRepository.save(user);
    }

    /**
     * Tạo user mới (alias for registerUser)
     */
    public User createUser(User user) {
        return registerUser(user);
    }

    /**
     * Cập nhật thông tin user
     */
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

    /**
     * Đổi mật khẩu user
     */
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

    /**
     * Active/Deactive user
     */
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
    public void deleteUser(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user với ID: " + userId));

        user.setActive(false);
        user.setUpdatedAt(LocalDateTime.now());
        userRepository.save(user);
    }

    // ===== ROLE-BASED QUERIES =====

    /**
     * Đếm số users theo role
     */
    public Long countByRole(User.Role role) {
        return userRepository.countByRole(role);
    }

    /**
     * Đếm users theo role (alias)
     */
    public Long countUsersByRole(User.Role role) {
        return countByRole(role);
    }

    /**
     * Tìm users theo role (List version)
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
     * Tìm users theo role và status active (List version)
     */
    public List<User> findByRoleAndActive(User.Role role, boolean active) {
        return userRepository.findByRoleAndActiveOrderByFullName(role, active);
    }

    /**
     * Tìm users theo role và active với pagination
     */
    public Page<User> findByRoleAndActive(User.Role role, boolean active, Pageable pageable) {
        return userRepository.findByRoleAndActive(role, active, pageable);
    }

    /**
     * Đếm users theo role và status active
     */
    public Long countByRoleAndActive(User.Role role, boolean active) {
        return userRepository.countByRoleAndActive(role, active);
    }

    // ===== INSTRUCTOR SPECIFIC QUERIES =====

    /**
     * Tìm active instructors
     */
    public List<User> findActiveInstructors() {
        return userRepository.findByRoleAndActiveOrderByFullName(User.Role.INSTRUCTOR, true);
    }

    /**
     * Tìm tất cả instructors sắp xếp theo tên
     */
    public List<User> findAllInstructorsOrderByName() {
        return userRepository.findAllInstructorsOrderByName();
    }

    /**
     * Tìm instructors theo số lượng courses
     */
    public List<User> findTopInstructorsByCourseCount(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return userRepository.findInstructorsOrderByCourseCount(User.Role.INSTRUCTOR, true, pageable);
    }

    /**
     * Tìm instructors sắp xếp theo số lượng courses với pagination
     */
    public Page<User> findInstructorsOrderByCourseCount(User.Role role, boolean active, Pageable pageable) {
        return userRepository.findInstructorsOrderByCourseCount(role, active, pageable);
    }

    /**
     * Tìm instructors với keyword
     */
    public List<User> searchInstructors(String keyword, int limit) {
        return userRepository.searchInstructors(keyword, limit);
    }

    /**
     * Đếm active instructors
     */
    public Long countActiveInstructors() {
        return userRepository.countByRoleAndActive(User.Role.INSTRUCTOR, true);
    }

    /**
     * Lấy số lượng students của một instructor
     */
    public Long countStudentsByInstructor(User instructor) {
        return userRepository.countStudentsByInstructor(instructor);
    }

    // ===== STUDENT SPECIFIC QUERIES =====

    /**
     * Tìm tất cả students sắp xếp theo tên
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
     * Tìm students có low progress
     */
    public List<User> findLowProgressStudents(User instructor, double maxProgress, LocalDateTime enrolledAfter) {
        return userRepository.findLowProgressStudents(instructor, maxProgress, enrolledAfter);
    }

    // ===== ACTIVITY & STATUS QUERIES =====

    /**
     * Đếm số users active
     */
    public Long countActiveUsers() {
        return userRepository.countByActive(true);
    }

    /**
     * Đếm users theo trạng thái active
     */
    public Long countByActive(boolean active) {
        return userRepository.countByActive(active);
    }

    /**
     * Đếm users active có last login sau thời điểm cho trước
     */
    public Long countByActiveAndLastLoginAfter(boolean active, LocalDateTime lastLoginAfter) {
        return userRepository.countByActiveAndLastLoginAfter(active, lastLoginAfter);
    }

    /**
     * Đếm users active trong tháng qua
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
     * Tìm tất cả users active sắp xếp theo tên
     */
    public List<User> findAllActiveOrderByName() {
        return userRepository.findAllByActiveTrueOrderByFullName();
    }

    // ===== TIME-BASED QUERIES =====

    /**
     * Đếm users được tạo sau thời điểm cho trước
     */
    public Long countByCreatedAtAfter(LocalDateTime createdAfter) {
        return userRepository.countByCreatedAtAfter(createdAfter);
    }
    /**
     * Tìm tất cả users sắp xếp theo tên
     * @return Danh sách users sắp xếp theo fullName
     */
    public List<User> findAllOrderByName() {
        return userRepository.findAll(Sort.by(Sort.Direction.ASC, "fullName"));
    }

    /**
     * Đếm tổng số users
     * @return Tổng số users
     */
    public Long countAll() {
        return userRepository.count();
    }

    /**
     * Lưu user
     * @param user User cần lưu
     * @return User đã lưu
     */
    public User save(User user) {
        validateUser(user);

        // Set thời gian tạo/cập nhật
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

    // ===== SEARCH & FILTERING =====

    /**
     * Tìm users với filter và pagination (Complex criteria query)
     */
    public Page<User> findUsersWithFilter(String search, String role, String status, Pageable pageable) {
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
     * Tìm users theo keyword trong multiple fields (List version)
     */
    public List<User> searchUsersByKeyword(String keyword, Pageable pageable) {
        return userRepository.findByKeyword(keyword, pageable);
    }

    /**
     * Tìm users theo keyword với pagination
     */
    public Page<User> findByKeyword(String keyword, Pageable pageable) {
        return userRepository.findByKeyword(keyword, pageable);
    }

    // ===== STATISTICS & ANALYTICS =====

    /**
     * Lấy thống kê users theo tháng
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
     * Lấy thống kê users theo tháng từ thời điểm cho trước
     */
    public List<Object[]> getUserStatsByMonth(LocalDateTime fromDate) {
        return userRepository.getUserStatsByMonth(fromDate);
    }

    /**
     * Lấy thống kê dashboard cho admin
     */
    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();

        // Tổng số users
        stats.put("totalUsers", userRepository.count());
        stats.put("activeUsers", userRepository.countByActive(true));
        stats.put("inactiveUsers", userRepository.countByActive(false));

        // Users theo role
        stats.put("totalInstructors", userRepository.countByRole(User.Role.INSTRUCTOR));
        stats.put("totalStudents", userRepository.countByRole(User.Role.STUDENT));
        stats.put("totalAdmins", userRepository.countByRole(User.Role.ADMIN));

        // Users mới trong 30 ngày
        LocalDateTime thirtyDaysAgo = LocalDateTime.now().minusDays(30);
        stats.put("newUsersThisMonth", userRepository.countByCreatedAtAfter(thirtyDaysAgo));

        // Users active trong 7 ngày
        LocalDateTime sevenDaysAgo = LocalDateTime.now().minusDays(7);
        stats.put("activeUsersThisWeek", userRepository.countByActiveAndLastLoginAfter(true, sevenDaysAgo));

        return stats;
    }

    // ===== VALIDATION & EXISTENCE CHECKS =====

    /**
     * Kiểm tra username đã tồn tại chưa (cho create)
     */
    public boolean isUsernameExists(String username) {
        return userRepository.existsByUsername(username);
    }

    /**
     * Kiểm tra email đã tồn tại chưa (cho create)
     */
    public boolean isEmailExists(String email) {
        return userRepository.existsByEmail(email);
    }

    /**
     * Kiểm tra username đã tồn tại chưa (cho update)
     */
    public boolean isUsernameExists(String username, Long excludeId) {
        return userRepository.existsByUsernameAndIdNot(username, excludeId);
    }

    /**
     * Kiểm tra email đã tồn tại chưa (cho update)
     */
    public boolean isEmailExists(String email, Long excludeId) {
        return userRepository.existsByEmailAndIdNot(email, excludeId);
    }

    // ===== COMPATIBILITY METHODS =====

    /**
     * Đếm tất cả active courses (placeholder - should be in CourseService)
     */
    public Long countAllActiveCourses() {
        return 0L; // Placeholder - should call courseService.countActiveCourses()
    }

    // ===== PRIVATE VALIDATION METHODS =====

    /**
     * Validation cho registration
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
     * Validate thông tin user trước khi save
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

        // Validate email format
        if (!user.getEmail().matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new RuntimeException("Email không đúng định dạng");
        }

        // Validate username length
        if (user.getUsername().length() < 3 || user.getUsername().length() > 50) {
            throw new RuntimeException("Username phải từ 3-50 ký tự");
        }
    }
}