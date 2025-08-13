package com.coursemanagement.repository;

import com.coursemanagement.entity.User;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Repository interface cho User entity
 * Chứa các custom queries và method names để truy vấn users
 * Extends JpaSpecificationExecutor để hỗ trợ dynamic queries
 */
@Repository
public interface UserRepository extends JpaRepository<User, Long>, JpaSpecificationExecutor<User> {

    // ===== BASIC FINDER METHODS =====

    /**
     * Tìm user theo username (cho Spring Security authentication)
     * @param username Tên đăng nhập
     * @return Optional chứa User nếu tìm thấy
     */
    Optional<User> findByUsername(String username);

    /**
     * Tìm user theo email
     * @param email Email
     * @return Optional chứa User nếu tìm thấy
     */
    Optional<User> findByEmail(String email);

    /**
     * Kiểm tra username đã tồn tại chưa
     * @param username Tên đăng nhập
     * @return true nếu đã tồn tại
     */
    boolean existsByUsername(String username);

    /**
     * Kiểm tra email đã tồn tại chưa
     * @param email Email
     * @return true nếu đã tồn tại
     */
    boolean existsByEmail(String email);

    // ===== ROLE-BASED QUERIES =====

    /**
     * Tìm users theo role và active status
     * @param role Role của user
     * @param active Trạng thái active
     * @return Danh sách users
     */
    List<User> findByRoleAndActiveOrderByFullName(User.Role role, boolean active);

    /**
     * Tìm users theo role và active status với pagination
     * @param role Role của user
     * @param active Trạng thái active
     * @param pageable Pagination info
     * @return Danh sách users
     */
    List<User> findByRoleAndActive(User.Role role, boolean active, Pageable pageable);

    /**
     * Đếm users theo role
     * @param role Role cần đếm
     * @return Số lượng users
     */
    Long countByRole(User.Role role);

    /**
     * Đếm users theo role và active status
     * @param role Role
     * @param active Trạng thái active
     * @return Số lượng users
     */
    Long countByRoleAndActive(User.Role role, boolean active);

    // ===== ACTIVITY-BASED QUERIES =====

    /**
     * Đếm users active
     * @param active Trạng thái active
     * @return Số lượng active users
     */
    Long countByActive(boolean active);

    /**
     * Đếm users active và có last login sau thời điểm cụ thể
     * @param active Trạng thái active
     * @param lastLoginAfter Thời điểm last login
     * @return Số lượng users
     */
    Long countByActiveAndLastLoginAfter(boolean active, LocalDateTime lastLoginAfter);

    /**
     * Đếm users được tạo sau thời điểm cụ thể
     * @param createdAfter Thời điểm tạo
     * @return Số lượng users mới
     */
    Long countByCreatedAtAfter(LocalDateTime createdAfter);

    /**
     * Đếm users được tạo trong khoảng thời gian
     * @param startDate Thời điểm bắt đầu
     * @param endDate Thời điểm kết thúc
     * @return Số lượng users
     */
    Long countByCreatedAtBetween(LocalDateTime startDate, LocalDateTime endDate);

    // ===== INSTRUCTOR-SPECIFIC QUERIES =====

    /**
     * Tìm instructors hoạt động gần đây
     * @param role Role INSTRUCTOR
     * @param active Trạng thái active
     * @param pageable Pagination với sort theo lastLogin
     * @return Danh sách instructors
     */
    @Query("SELECT u FROM User u WHERE u.role = :role AND u.active = :active " +
            "ORDER BY u.lastLogin DESC NULLS LAST")
    List<User> findActiveInstructorsOrderByLastLogin(@Param("role") User.Role role,
                                                     @Param("active") boolean active,
                                                     Pageable pageable);

    /**
     * Tìm top instructors theo số enrollments (cần join với Course và Enrollment)
     * @param role Role INSTRUCTOR
     * @param active Trạng thái active
     * @param pageable Pagination
     * @return Danh sách top instructors
     */
    @Query("SELECT u FROM User u WHERE u.role = :role AND u.active = :active " +
            "ORDER BY (SELECT COUNT(e) FROM Enrollment e WHERE e.course.instructor = u) DESC")
    List<User> findTopInstructorsByEnrollments(@Param("role") User.Role role,
                                               @Param("active") boolean active,
                                               Pageable pageable);

    /**
     * Tìm instructors theo số courses
     * @param role Role INSTRUCTOR
     * @param active Trạng thái active
     * @param pageable Pagination
     * @return Danh sách instructors
     */
    @Query("SELECT u FROM User u WHERE u.role = :role AND u.active = :active " +
            "ORDER BY (SELECT COUNT(c) FROM Course c WHERE c.instructor = u AND c.active = true) DESC")
    List<User> findInstructorsOrderByCourseCount(@Param("role") User.Role role,
                                                 @Param("active") boolean active,
                                                 Pageable pageable);

    // ===== SEARCH AND FILTER QUERIES =====

    /**
     * Tìm users theo keyword trong username, email hoặc fullName
     * @param keyword Từ khóa tìm kiếm
     * @param pageable Pagination
     * @return Danh sách users
     */
    @Query("SELECT u FROM User u WHERE " +
            "LOWER(u.username) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(u.email) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(u.fullName) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<User> findByKeyword(@Param("keyword") String keyword, Pageable pageable);

    /**
     * Tìm users theo multiple criteria
     * @param keyword Từ khóa tìm kiếm (có thể null)
     * @param role Role filter (có thể null)
     * @param active Status filter (có thể null)
     * @param pageable Pagination
     * @return Danh sách users
     */
    @Query("SELECT u FROM User u WHERE " +
            "(:keyword IS NULL OR " +
            " LOWER(u.username) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            " LOWER(u.email) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            " LOWER(u.fullName) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND " +
            "(:role IS NULL OR u.role = :role) AND " +
            "(:active IS NULL OR u.active = :active)")
    List<User> findByMultipleCriteria(@Param("keyword") String keyword,
                                      @Param("role") User.Role role,
                                      @Param("active") Boolean active,
                                      Pageable pageable);

    // ===== STATISTICS QUERIES =====

    /**
     * Lấy thống kê users theo tháng
     * @return List array [month, year, count]
     */
    @Query("SELECT MONTH(u.createdAt), YEAR(u.createdAt), COUNT(u) " +
            "FROM User u " +
            "WHERE u.createdAt >= :startDate " +
            "GROUP BY YEAR(u.createdAt), MONTH(u.createdAt) " +
            "ORDER BY YEAR(u.createdAt), MONTH(u.createdAt)")
    List<Object[]> getUserRegistrationStatsByMonth(@Param("startDate") LocalDateTime startDate);

    /**
     * Lấy thống kê users theo role
     * @return List array [role, count]
     */
    @Query("SELECT u.role, COUNT(u) FROM User u GROUP BY u.role")
    List<Object[]> getUserStatsByRole();

    /**
     * Đếm users online gần đây (last login trong 24 giờ)
     * @param since Thời điểm 24 giờ trước
     * @return Số lượng users online
     */
    @Query("SELECT COUNT(u) FROM User u WHERE u.active = true AND u.lastLogin >= :since")
    Long countActiveUsersInLast24Hours(@Param("since") LocalDateTime since);

    // ===== MANAGEMENT QUERIES =====

    /**
     * Tìm users chưa đăng nhập trong thời gian dài
     * @param threshold Thời điểm threshold
     * @return Danh sách inactive users
     */
    @Query("SELECT u FROM User u WHERE u.active = true AND " +
            "(u.lastLogin IS NULL OR u.lastLogin < :threshold)")
    List<User> findInactiveUsers(@Param("threshold") LocalDateTime threshold);

    /**
     * Tìm users mới cần approve (nếu có approval workflow)
     * @param role Role cần approve
     * @param active Trạng thái active
     * @param createdAfter Tạo sau thời điểm này
     * @return Danh sách users cần approve
     */
    @Query("SELECT u FROM User u WHERE u.role = :role AND u.active = :active AND " +
            "u.createdAt >= :createdAfter ORDER BY u.createdAt DESC")
    List<User> findNewUsersForApproval(@Param("role") User.Role role,
                                       @Param("active") boolean active,
                                       @Param("createdAfter") LocalDateTime createdAfter);

    /**
     * Tìm users có email domain cụ thể
     * @param domain Email domain (ví dụ: "gmail.com")
     * @return Danh sách users
     */
    @Query("SELECT u FROM User u WHERE LOWER(u.email) LIKE LOWER(CONCAT('%@', :domain))")
    List<User> findByEmailDomain(@Param("domain") String domain);

    // ===== BULK OPERATIONS =====

    /**
     * Bulk update active status cho multiple users
     * @param userIds Danh sách user IDs
     * @param active Status mới
     * @return Số lượng users đã update
     */
    @Query("UPDATE User u SET u.active = :active WHERE u.id IN :userIds")
    int bulkUpdateActiveStatus(@Param("userIds") List<Long> userIds,
                               @Param("active") boolean active);

    /**
     * Bulk update role cho multiple users
     * @param userIds Danh sách user IDs
     * @param role Role mới
     * @return Số lượng users đã update
     */
    @Query("UPDATE User u SET u.role = :role WHERE u.id IN :userIds")
    int bulkUpdateRole(@Param("userIds") List<Long> userIds,
                       @Param("role") User.Role role);

    // ===== SECURITY QUERIES =====

    /**
     * Tìm users có login attempts nhiều trong thời gian ngắn (security)
     * @param threshold Thời điểm threshold
     * @return Danh sách suspicious users
     */
    @Query("SELECT u FROM User u WHERE u.lastLogin >= :threshold " +
            "GROUP BY u HAVING COUNT(u) > 5")
    List<User> findSuspiciousLoginActivity(@Param("threshold") LocalDateTime threshold);

    /**
     * Tìm users theo IP range (nếu store IP addresses)
     * Placeholder method - cần thêm IP field vào User entity
     */
    // List<User> findByLastLoginIpStartingWith(String ipPrefix);

    // ===== REPORTING QUERIES =====

    /**
     * Lấy summary statistics cho admin dashboard
     * @return Object array [totalUsers, activeUsers, newThisMonth, instructors, students]
     */
    @Query("SELECT " +
            "(SELECT COUNT(u) FROM User u), " +
            "(SELECT COUNT(u) FROM User u WHERE u.active = true), " +
            "(SELECT COUNT(u) FROM User u WHERE u.createdAt >= :monthStart), " +
            "(SELECT COUNT(u) FROM User u WHERE u.role = 'INSTRUCTOR'), " +
            "(SELECT COUNT(u) FROM User u WHERE u.role = 'STUDENT')")
    Object[] getUserSummaryStats(@Param("monthStart") LocalDateTime monthStart);

    /**
     * Lấy growth statistics
     * @param months Số tháng cần lấy thống kê
     * @return List array [month, newUsers, totalUsers]
     */
    @Query(value = "SELECT DATE_FORMAT(created_at, '%Y-%m') as month, " +
            "COUNT(*) as new_users, " +
            "(SELECT COUNT(*) FROM users u2 WHERE u2.created_at <= LAST_DAY(u1.created_at)) as total_users " +
            "FROM users u1 " +
            "WHERE created_at >= DATE_SUB(NOW(), INTERVAL :months MONTH) " +
            "GROUP BY DATE_FORMAT(created_at, '%Y-%m') " +
            "ORDER BY month",
            nativeQuery = true)
    List<Object[]> getUserGrowthStats(@Param("months") int months);
}