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

    /**
     * Đếm users theo active status
     * @param active Trạng thái active
     * @return Số lượng users
     */
    Long countByActive(boolean active);

    /**
     * Đếm users active trong thời gian gần đây
     * @param active Trạng thái active
     * @param lastLoginAfter Thời gian login cuối
     * @return Số lượng active users
     */
    Long countByActiveAndLastLoginAfter(boolean active, LocalDateTime lastLoginAfter);

    /**
     * Đếm users tạo sau một thời điểm
     * @param createdAt Thời điểm tạo
     * @return Số lượng users
     */
    Long countByCreatedAtAfter(LocalDateTime createdAt);

    // ===== INSTRUCTOR SPECIFIC QUERIES =====

    /**
     * Tìm instructors sắp xếp theo số lượng courses
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
     * @param startDate Ngày bắt đầu
     * @return List array [month, year, count]
     */
    @Query("SELECT MONTH(u.createdAt), YEAR(u.createdAt), COUNT(u) " +
            "FROM User u " +
            "WHERE u.createdAt >= :startDate " +
            "GROUP BY YEAR(u.createdAt), MONTH(u.createdAt) " +
            "ORDER BY YEAR(u.createdAt), MONTH(u.createdAt)")
    List<Object[]> getUserStatsByMonth(@Param("startDate") LocalDateTime startDate);

    /**
     * Lấy thống kê users theo role
     * @return List array [role, count]
     */
    @Query("SELECT u.role, COUNT(u) FROM User u GROUP BY u.role ORDER BY COUNT(u) DESC")
    List<Object[]> getUserStatsByRole();

    /**
     * Lấy top active users (theo last login)
     * @param pageable Pagination
     * @return Danh sách top active users
     */
    @Query("SELECT u FROM User u WHERE u.active = true AND u.lastLogin IS NOT NULL " +
            "ORDER BY u.lastLogin DESC")
    List<User> findTopActiveUsers(Pageable pageable);

    // ===== ACTIVITY TRACKING =====

    /**
     * Tìm users chưa đăng nhập lâu
     * @param lastLoginBefore Thời điểm login cuối
     * @return Danh sách inactive users
     */
    @Query("SELECT u FROM User u WHERE u.active = true AND " +
            "(u.lastLogin IS NULL OR u.lastLogin < :lastLoginBefore)")
    List<User> findInactiveUsers(@Param("lastLoginBefore") LocalDateTime lastLoginBefore);

    /**
     * Tìm new users trong X ngày gần đây
     * @param startDate Ngày bắt đầu
     * @return Danh sách new users
     */
    @Query("SELECT u FROM User u WHERE u.createdAt >= :startDate ORDER BY u.createdAt DESC")
    List<User> findNewUsers(@Param("startDate") LocalDateTime startDate);

    /**
     * Đếm users online (đăng nhập trong X phút gần đây)
     * @param onlineThreshold Thời gian threshold
     * @return Số lượng users online
     */
    @Query("SELECT COUNT(u) FROM User u WHERE u.active = true AND u.lastLogin >= :onlineThreshold")
    Long countOnlineUsers(@Param("onlineThreshold") LocalDateTime onlineThreshold);

    // ===== ADMIN MANAGEMENT =====

    /**
     * Tìm users cần attention (chưa complete profile)
     * @return Danh sách users cần attention
     */
    @Query("SELECT u FROM User u WHERE u.active = true AND " +
            "(u.bio IS NULL OR u.bio = '' OR u.phoneNumber IS NULL OR u.phoneNumber = '')")
    List<User> findUsersNeedingAttention();

    /**
     * Tìm duplicate emails (nếu có lỗi data)
     * @return List array [email, count]
     */
    @Query("SELECT u.email, COUNT(u) FROM User u GROUP BY u.email HAVING COUNT(u) > 1")
    List<Object[]> findDuplicateEmails();

    /**
     * Tìm users theo email domain
     * @param domain Email domain (VD: "gmail.com")
     * @return Danh sách users
     */
    @Query("SELECT u FROM User u WHERE u.email LIKE CONCAT('%@', :domain)")
    List<User> findByEmailDomain(@Param("domain") String domain);

    // ===== ADVANCED ANALYTICS =====

    /**
     * Lấy user growth rate
     * @param currentMonthStart Đầu tháng hiện tại
     * @param previousMonthStart Đầu tháng trước
     * @return List array [currentMonthCount, previousMonthCount, growthRate]
     */
    @Query("SELECT " +
            "(SELECT COUNT(u1) FROM User u1 WHERE u1.createdAt >= :currentMonthStart), " +
            "(SELECT COUNT(u2) FROM User u2 WHERE u2.createdAt >= :previousMonthStart AND u2.createdAt < :currentMonthStart), " +
            "CASE WHEN (SELECT COUNT(u3) FROM User u3 WHERE u3.createdAt >= :previousMonthStart AND u3.createdAt < :currentMonthStart) > 0 " +
            "THEN ((SELECT COUNT(u4) FROM User u4 WHERE u4.createdAt >= :currentMonthStart) - " +
            "      (SELECT COUNT(u5) FROM User u5 WHERE u5.createdAt >= :previousMonthStart AND u5.createdAt < :currentMonthStart)) * 100.0 / " +
            "     (SELECT COUNT(u6) FROM User u6 WHERE u6.createdAt >= :previousMonthStart AND u6.createdAt < :currentMonthStart) " +
            "ELSE 0 END")
    List<Object[]> getUserGrowthRate(@Param("currentMonthStart") LocalDateTime currentMonthStart,
                                     @Param("previousMonthStart") LocalDateTime previousMonthStart);

    /**
     * Lấy retention rate (users vẫn active sau X tháng)
     * @param registeredBefore Đăng ký trước thời điểm
     * @param activeAfter Vẫn active sau thời điểm
     * @return List array [totalRegistered, stillActive, retentionRate]
     */
    @Query("SELECT " +
            "(SELECT COUNT(u1) FROM User u1 WHERE u1.createdAt <= :registeredBefore), " +
            "(SELECT COUNT(u2) FROM User u2 WHERE u2.createdAt <= :registeredBefore AND u2.active = true AND u2.lastLogin >= :activeAfter), " +
            "CASE WHEN (SELECT COUNT(u3) FROM User u3 WHERE u3.createdAt <= :registeredBefore) > 0 " +
            "THEN (SELECT COUNT(u4) FROM User u4 WHERE u4.createdAt <= :registeredBefore AND u4.active = true AND u4.lastLogin >= :activeAfter) * 100.0 / " +
            "     (SELECT COUNT(u5) FROM User u5 WHERE u5.createdAt <= :registeredBefore) " +
            "ELSE 0 END")
    List<Object[]> getUserRetentionRate(@Param("registeredBefore") LocalDateTime registeredBefore,
                                        @Param("activeAfter") LocalDateTime activeAfter);

    /**
     * Tìm users most engaged (nhiều activities)
     * @param pageable Pagination
     * @return List array [userId, userName, totalEnrollments, totalQuizzes]
     */
    @Query("SELECT u.id, u.fullName, " +
            "(SELECT COUNT(e) FROM Enrollment e WHERE e.student = u), " +
            "(SELECT COUNT(qr) FROM QuizResult qr WHERE qr.student = u) " +
            "FROM User u " +
            "WHERE u.role = 'STUDENT' AND u.active = true " +
            "ORDER BY ((SELECT COUNT(e) FROM Enrollment e WHERE e.student = u) + " +
            "          (SELECT COUNT(qr) FROM QuizResult qr WHERE qr.student = u)) DESC")
    List<Object[]> findMostEngagedUsers(Pageable pageable);
}