package com.coursemanagement.repository;

import com.coursemanagement.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Repository interface cho User entity
 * Chứa các custom queries và method names để truy vấn users
 * Extends JpaSpecificationExecutor để hỗ trợ dynamic queries
 * Cập nhật với đầy đủ methods cần thiết
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

    /**
     * Kiểm tra username đã tồn tại chưa (exclude user hiện tại)
     * @param username Username
     * @param id ID user cần exclude
     * @return true nếu đã tồn tại
     */
    boolean existsByUsernameAndIdNot(String username, Long id);

    /**
     * Kiểm tra email đã tồn tại chưa (exclude user hiện tại)
     * @param email Email
     * @param id ID user cần exclude
     * @return true nếu đã tồn tại
     */
    boolean existsByEmailAndIdNot(String email, Long id);

    // ===== ROLE-BASED QUERIES =====

    /**
     * Tìm users theo role và active status
     * @param role Role của user
     * @param active Trạng thái active
     * @return Danh sách users
     */
    List<User> findByRoleAndActiveOrderByFullName(User.Role role, boolean active);

    /**
     * Tìm users theo role
     * @param role Role của user
     * @return Danh sách users
     */
    List<User> findByRole(User.Role role);

    /**
     * Tìm users theo role và active status với pagination
     * @param role Role của user
     * @param active Trạng thái active
     * @param pageable Pagination info
     * @return Page chứa users
     */
    Page<User> findByRoleAndActive(User.Role role, boolean active, Pageable pageable);

    /**
     * Đếm users theo role
     * @param role Role cần đếm
     * @return Số lượng users
     */
    Long countByRole(User.Role role);

    /**
     * Đếm active users theo role
     * @param role Role cần đếm
     * @param active Trạng thái active
     * @return Số lượng active users
     */
    Long countByRoleAndActive(User.Role role, boolean active);

    // ===== SEARCH QUERIES =====

    /**
     * Search users theo full name hoặc username
     * @param keyword Từ khóa tìm kiếm
     * @param pageable Pagination info
     * @return Page chứa users tìm thấy
     */
    @Query("SELECT u FROM User u WHERE " +
            "LOWER(u.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(u.username) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(u.email) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    Page<User> searchUsers(@Param("keyword") String keyword, Pageable pageable);

    /**
     * Search instructors với limit
     * @param keyword Từ khóa tìm kiếm
     * @param limit Số lượng kết quả
     * @return Danh sách instructors tìm thấy
     */
    @Query("SELECT u FROM User u WHERE u.role = 'INSTRUCTOR' AND u.active = true AND " +
            "(LOWER(u.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(u.username) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
            "ORDER BY u.fullName")
    List<User> searchInstructors(@Param("keyword") String keyword, @Param("limit") int limit);

    /**
     * Search students với limit
     * @param keyword Từ khóa tìm kiếm
     * @param limit Số lượng kết quả
     * @return Danh sách students tìm thấy
     */
    @Query("SELECT u FROM User u WHERE u.role = 'STUDENT' AND u.active = true AND " +
            "(LOWER(u.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(u.username) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
            "ORDER BY u.fullName")
    List<User> searchStudents(@Param("keyword") String keyword, @Param("limit") int limit);

    // ===== UPDATE QUERIES =====

    /**
     * Cập nhật last login time cho user
     * @param userId ID của user
     * @param lastLogin Thời gian login
     */
    @Modifying
    @Transactional
    @Query("UPDATE User u SET u.lastLogin = :lastLogin WHERE u.id = :userId")
    void updateLastLogin(@Param("userId") Long userId, @Param("lastLogin") LocalDateTime lastLogin);

    /**
     * Cập nhật last login time cho user (overload method)
     * @param userId ID của user
     */
    @Modifying
    @Transactional
    @Query("UPDATE User u SET u.lastLogin = CURRENT_TIMESTAMP WHERE u.id = :userId")
    void updateLastLogin(@Param("userId") Long userId);

    /**
     * Cập nhật active status của user
     * @param userId ID của user
     * @param active Trạng thái active mới
     */
    @Modifying
    @Transactional
    @Query("UPDATE User u SET u.active = :active WHERE u.id = :userId")
    void updateActiveStatus(@Param("userId") Long userId, @Param("active") boolean active);

    /**
     * Cập nhật password của user
     * @param userId ID của user
     * @param encodedPassword Password đã mã hóa
     */
    @Modifying
    @Transactional
    @Query("UPDATE User u SET u.password = :password WHERE u.id = :userId")
    void updatePassword(@Param("userId") Long userId, @Param("password") String encodedPassword);

    // ===== ANALYTICS QUERIES =====

    /**
     * Lấy thống kê users theo role
     * @return Danh sách [Role, Count]
     */
    @Query("SELECT u.role, COUNT(u) FROM User u GROUP BY u.role")
    List<Object[]> getUserStatsByRole();

    /**
     * Lấy users mới đăng ký gần đây
     * @param days Số ngày gần đây
     * @param pageable Pagination info
     * @return Page chứa users mới
     */
    @Query("SELECT u FROM User u WHERE u.createdAt >= :since ORDER BY u.createdAt DESC")
    Page<User> findRecentUsers(@Param("since") LocalDateTime since, Pageable pageable);

    /**
     * Lấy top instructors theo số lượng courses
     * @param limit Số lượng instructors
     * @return Danh sách top instructors
     */
    @Query("SELECT u, COUNT(c) as courseCount FROM User u " +
            "LEFT JOIN u.instructorCourses c " +
            "WHERE u.role = 'INSTRUCTOR' AND u.active = true " +
            "GROUP BY u " +
            "ORDER BY courseCount DESC")
    List<Object[]> getTopInstructorsByEnrollments(@Param("limit") int limit);

    /**
     * Lấy most active instructors (theo enrollments)
     * @param limit Số lượng instructors
     * @return Danh sách most active instructors
     */
    @Query("SELECT u, COUNT(e) as enrollmentCount FROM User u " +
            "LEFT JOIN u.instructorCourses c " +
            "LEFT JOIN c.enrollments e " +
            "WHERE u.role = 'INSTRUCTOR' AND u.active = true " +
            "GROUP BY u " +
            "ORDER BY enrollmentCount DESC")
    List<Object[]> findMostActiveInstructors(@Param("limit") int limit);

    /**
     * Lấy thống kê user growth theo tháng
     * @return Danh sách [Year, Month, Count]
     */
    @Query("SELECT YEAR(u.createdAt), MONTH(u.createdAt), COUNT(u) " +
            "FROM User u " +
            "GROUP BY YEAR(u.createdAt), MONTH(u.createdAt) " +
            "ORDER BY YEAR(u.createdAt) DESC, MONTH(u.createdAt) DESC")
    List<Object[]> getUserGrowthStats();

    /**
     * Tìm users theo múi giờ last login
     * @param hours Số giờ gần đây
     * @return Danh sách users active gần đây
     */
    @Query("SELECT u FROM User u WHERE u.lastLogin >= :since")
    List<User> findUsersActiveRecently(@Param("since") LocalDateTime since);

    /**
     * Đếm total active users
     * @return Số lượng active users
     */
    @Query("SELECT COUNT(u) FROM User u WHERE u.active = true")
    Long countActiveUsers();

    /**
     * Lấy users chưa bao giờ login
     * @return Danh sách users chưa login
     */
    @Query("SELECT u FROM User u WHERE u.lastLogin IS NULL")
    List<User> findUsersNeverLoggedIn();
}