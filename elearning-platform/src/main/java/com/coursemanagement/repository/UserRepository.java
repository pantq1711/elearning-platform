package com.coursemanagement.repository;

import com.coursemanagement.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

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
     * Tìm tất cả user đang hoạt động theo vai trò
     * @param role Vai trò cần tìm
     * @param isActive Trạng thái hoạt động (true/false)
     * @return Danh sách user hoạt động có vai trò đó
     */
    List<User> findByRoleAndIsActive(User.Role role, boolean isActive);

    /**
     * Tìm tất cả user đang hoạt động
     * @param isActive Trạng thái hoạt động
     * @return Danh sách user hoạt động
     */
    List<User> findByIsActive(boolean isActive);

    /**
     * Tìm user theo username hoặc email (dùng cho tìm kiếm)
     * @param username Tên đăng nhập
     * @param email Email
     * @return Danh sách user tìm thấy
     */
    @Query("SELECT u FROM User u WHERE u.username LIKE %:keyword% OR u.email LIKE %:keyword%")
    List<User> findByUsernameOrEmailContaining(@Param("keyword") String keyword);

    /**
     * Đếm số lượng user theo vai trò
     * @param role Vai trò cần đếm
     * @return Số lượng user
     */
    long countByRole(User.Role role);

    /**
     * Đếm số lượng user đang hoạt động
     * @param isActive Trạng thái hoạt động
     * @return Số lượng user đang hoạt động
     */
    long countByIsActive(boolean isActive);

    /**
     * Tìm tất cả giảng viên đang hoạt động
     * Sử dụng @Query để viết JPQL tùy chỉnh
     * @return Danh sách giảng viên đang hoạt động
     */
    @Query("SELECT u FROM User u WHERE u.role = 'INSTRUCTOR' AND u.isActive = true")
    List<User> findActiveInstructors();

    /**
     * Tìm tất cả học viên đang hoạt động
     * @return Danh sách học viên đang hoạt động
     */
    @Query("SELECT u FROM User u WHERE u.role = 'STUDENT' AND u.isActive = true")
    List<User> findActiveStudents();

    /**
     * Tìm user theo ID và vai trò (để đảm bảo quyền truy cập)
     * @param id ID của user
     * @param role Vai trò của user
     * @return Optional<User>
     */
    Optional<User> findByIdAndRole(Long id, User.Role role);

    /**
     * Tìm user theo username và trạng thái hoạt động
     * Dùng cho việc đăng nhập (chỉ cho phép user đang hoạt động)
     * @param username Tên đăng nhập
     * @param isActive Trạng thái hoạt động
     * @return Optional<User>
     */
    Optional<User> findByUsernameAndIsActive(String username, boolean isActive);

    /**
     * Lấy top N user được tạo gần đây nhất
     * @param limit Số lượng user cần lấy
     * @return Danh sách user mới nhất
     */
    @Query("SELECT u FROM User u ORDER BY u.createdAt DESC LIMIT :limit")
    List<User> findTopNewestUsers(@Param("limit") int limit);

    /**
     * Tìm user có username hoặc email trùng với user khác (dùng khi update)
     * Loại trừ user hiện tại khi kiểm tra trùng lặp
     * @param username Tên đăng nhập cần kiểm tra
     * @param email Email cần kiểm tra
     * @param excludeId ID của user hiện tại (để loại trừ)
     * @return Danh sách user trùng lặp
     */
    @Query("SELECT u FROM User u WHERE (u.username = :username OR u.email = :email) AND u.id != :excludeId")
    List<User> findDuplicateUsernameOrEmail(@Param("username") String username,
                                            @Param("email") String email,
                                            @Param("excludeId") Long excludeId);
}