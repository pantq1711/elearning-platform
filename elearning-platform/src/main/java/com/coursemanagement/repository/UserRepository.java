package com.coursemanagement.repository;

import com.coursemanagement.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Repository interface để thao tác với bảng users
 * Kế thừa JpaRepository để có sẵn các method CRUD cơ bản
 */
@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    /**
     * Tìm user theo username (dùng cho đăng nhập)
     * @param username Tên đăng nhập
     * @return Optional<User> - có thể null nếu không tìm thấy
     */
    Optional<User> findByUsername(String username);

    /**
     * Tìm user theo email (kiểm tra email trùng lặp)
     * @param email Email cần tìm
     * @return Optional<User> - có thể null nếu không tìm thấy
     */
    Optional<User> findByEmail(String email);

    /**
     * Kiểm tra username có tồn tại hay không
     * @param username Tên đăng nhập cần kiểm tra
     * @return true nếu tồn tại, false nếu không tồn tại
     */
    boolean existsByUsername(String username);

    /**
     * Kiểm tra email có tồn tại hay không
     * @param email Email cần kiểm tra
     * @return true nếu tồn tại, false nếu không tồn tại
     */
    boolean existsByEmail(String email);

    /**
     * Tìm tất cả user theo vai trò
     * @param role Vai trò cần tìm (ADMIN, INSTRUCTOR, STUDENT)
     * @return Danh sách user có vai trò đó
     */
    List<User> findByRole(User.Role role);

    /**
     * Đếm số user theo vai trò
     * @param role Vai trò
     * @return Số lượng user
     */
    long countByRole(User.Role role);

    /**
     * Tìm user theo trạng thái hoạt động
     * @param isActive Trạng thái hoạt động
     * @return Danh sách user
     */
    List<User> findByIsActive(boolean isActive);

    /**
     * Tìm user theo vai trò và trạng thái hoạt động
     * @param role Vai trò
     * @param isActive Trạng thái hoạt động
     * @return Danh sách user
     */
    List<User> findByRoleAndIsActive(User.Role role, boolean isActive);

    /**
     * Lấy user mới đăng ký gần đây
     * @param limit Số lượng user cần lấy
     * @return Danh sách user mới
     */
    @Query("SELECT u FROM User u ORDER BY u.createdAt DESC LIMIT :limit")
    List<User> findTopByOrderByCreatedAtDesc(@Param("limit") int limit);

    /**
     * Tìm user theo tên có chứa từ khóa
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách user chứa từ khóa
     */
    @Query("SELECT u FROM User u WHERE LOWER(u.username) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "OR LOWER(u.email) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "ORDER BY u.username ASC")
    List<User> findByUsernameContainingIgnoreCaseOrEmailContainingIgnoreCase(@Param("keyword") String keyword);

    /**
     * Tìm user theo họ tên có chứa từ khóa
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách user có họ tên chứa từ khóa
     */
    @Query("SELECT u FROM User u WHERE LOWER(u.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "ORDER BY u.fullName ASC")
    List<User> findByFullNameContainingIgnoreCase(@Param("keyword") String keyword);

    /**
     * Tìm user theo username, email hoặc họ tên có chứa từ khóa
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách user chứa từ khóa
     */
    @Query("SELECT u FROM User u WHERE " +
            "LOWER(u.username) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(u.email) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(u.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "ORDER BY u.username ASC")
    List<User> searchUsers(@Param("keyword") String keyword);

    /**
     * Tìm user theo khoảng thời gian tạo
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Danh sách user trong khoảng thời gian
     */
    @Query("SELECT u FROM User u WHERE u.createdAt BETWEEN :startDate AND :endDate " +
            "ORDER BY u.createdAt DESC")
    List<User> findUsersByDateRange(@Param("startDate") LocalDateTime startDate,
                                    @Param("endDate") LocalDateTime endDate);

    /**
     * Tìm user đăng nhập gần đây
     * @param limit Số lượng user cần lấy
     * @return Danh sách user đăng nhập gần đây
     */
    @Query("SELECT u FROM User u WHERE u.lastLogin IS NOT NULL " +
            "ORDER BY u.lastLogin DESC LIMIT :limit")
    List<User> findRecentlyLoggedInUsers(@Param("limit") int limit);

    /**
     * Tìm user chưa đăng nhập lần nào
     * @return Danh sách user chưa đăng nhập
     */
    @Query("SELECT u FROM User u WHERE u.lastLogin IS NULL ORDER BY u.createdAt DESC")
    List<User> findUsersNeverLoggedIn();

    /**
     * Tìm user không hoạt động trong khoảng thời gian
     * @param days Số ngày không hoạt động
     * @return Danh sách user không hoạt động
     */
    @Query("SELECT u FROM User u WHERE u.lastLogin < :cutoffDate OR u.lastLogin IS NULL " +
            "ORDER BY u.lastLogin ASC")
    List<User> findInactiveUsers(@Param("cutoffDate") LocalDateTime cutoffDate);

    /**
     * Đếm số user đăng ký trong tháng hiện tại
     * @return Số lượng user mới
     */
    @Query("SELECT COUNT(u) FROM User u WHERE " +
            "YEAR(u.createdAt) = YEAR(CURRENT_DATE) AND " +
            "MONTH(u.createdAt) = MONTH(CURRENT_DATE)")
    long countUsersCreatedThisMonth();

    /**
     * Đếm số user đăng nhập trong ngày hôm nay
     * @return Số lượng user đăng nhập hôm nay
     */
    @Query("SELECT COUNT(u) FROM User u WHERE DATE(u.lastLogin) = CURRENT_DATE")
    long countUsersLoggedInToday();

    /**
     * Đếm số user đăng nhập trong tuần này
     * @return Số lượng user đăng nhập tuần này
     */
    @Query("SELECT COUNT(u) FROM User u WHERE u.lastLogin >= :weekStart")
    long countUsersLoggedInThisWeek(@Param("weekStart") LocalDateTime weekStart);

    /**
     * Lấy thống kê user theo vai trò
     * @return Danh sách [Role, UserCount]
     */
    @Query("SELECT u.role, COUNT(u) FROM User u GROUP BY u.role ORDER BY COUNT(u) DESC")
    List<Object[]> getUserStatisticsByRole();

    /**
     * Lấy thống kê user theo tháng đăng ký
     * @param year Năm cần thống kê
     * @return Danh sách [Month, UserCount]
     */
    @Query("SELECT MONTH(u.createdAt), COUNT(u) FROM User u " +
            "WHERE YEAR(u.createdAt) = :year " +
            "GROUP BY MONTH(u.createdAt) " +
            "ORDER BY MONTH(u.createdAt)")
    List<Object[]> getUserRegistrationStatisticsByMonth(@Param("year") int year);

    /**
     * Tìm giảng viên có nhiều khóa học nhất
     * @param limit Số lượng giảng viên cần lấy
     * @return Danh sách giảng viên hàng đầu
     */
    @Query("SELECT u FROM User u " +
            "LEFT JOIN u.instructedCourses c " +
            "WHERE u.role = 'INSTRUCTOR' " +
            "GROUP BY u " +
            "ORDER BY COUNT(c) DESC " +
            "LIMIT :limit")
    List<User> findTopInstructorsByCourseCount(@Param("limit") int limit);

    /**
     * Tìm học viên có nhiều đăng ký nhất
     * @param limit Số lượng học viên cần lấy
     * @return Danh sách học viên tích cực nhất
     */
    @Query("SELECT u FROM User u " +
            "LEFT JOIN u.enrollments e " +
            "WHERE u.role = 'STUDENT' " +
            "GROUP BY u " +
            "ORDER BY COUNT(e) DESC " +
            "LIMIT :limit")
    List<User> findTopStudentsByEnrollmentCount(@Param("limit") int limit);

    /**
     * Tìm user theo email domain
     * @param domain Email domain (vd: gmail.com)
     * @return Danh sách user có email domain đó
     */
    @Query("SELECT u FROM User u WHERE u.email LIKE CONCAT('%@', :domain) ORDER BY u.username ASC")
    List<User> findUsersByEmailDomain(@Param("domain") String domain);

    /**
     * Đếm số user theo trạng thái hoạt động
     * @param isActive Trạng thái hoạt động
     * @return Số lượng user
     */
    long countByIsActive(boolean isActive);

    /**
     * Tìm user có nhiều enrollment nhất trong tháng
     * @param year Năm
     * @param month Tháng
     * @param limit Số lượng user cần lấy
     * @return Danh sách user tích cực nhất trong tháng
     */
    @Query("SELECT u FROM User u " +
            "LEFT JOIN u.enrollments e " +
            "WHERE YEAR(e.enrolledAt) = :year AND MONTH(e.enrolledAt) = :month " +
            "GROUP BY u " +
            "ORDER BY COUNT(e) DESC " +
            "LIMIT :limit")
    List<User> findMostActiveUsersInMonth(@Param("year") int year,
                                          @Param("month") int month,
                                          @Param("limit") int limit);

    /**
     * Tìm admin users
     * @return Danh sách admin
     */
    @Query("SELECT u FROM User u WHERE u.role = 'ADMIN' ORDER BY u.createdAt ASC")
    List<User> findAdminUsers();

    /**
     * Kiểm tra có ít nhất một admin đang hoạt động không
     * @return true nếu có admin hoạt động
     */
    @Query("SELECT CASE WHEN COUNT(u) > 0 THEN true ELSE false END " +
            "FROM User u WHERE u.role = 'ADMIN' AND u.isActive = true")
    boolean hasActiveAdmin();
}