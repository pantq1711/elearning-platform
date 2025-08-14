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
     */
    @Repository
    public interface UserRepository extends JpaRepository<User, Long>, JpaSpecificationExecutor<User> {
        /**
         * Cập nhật last login time
         */

        /**
         * Đếm tất cả users
         */
        @Query("SELECT COUNT(u) FROM User u")
        Long countAllUsers();

        /**
         * Đếm active users trong tháng qua
         */
        @Query("SELECT COUNT(u) FROM User u WHERE u.lastLogin >= :fromDate")
        Long countActiveUsersInLastMonth(@Param("fromDate") LocalDateTime fromDate);

        /**
         * Tìm top instructors theo enrollment count
         */
        @Query("SELECT u, COUNT(e) as enrollmentCount FROM User u " +
                "LEFT JOIN Course c ON c.instructor = u " +
                "LEFT JOIN Enrollment e ON e.course = c " +
                "WHERE u.role = 'INSTRUCTOR' AND u.active = true " +
                "GROUP BY u ORDER BY COUNT(e) DESC")
        List<Object[]> getTopInstructorsByEnrollments(Pageable pageable);

        /**
         * Lấy user growth stats
         */
        @Query("SELECT YEAR(u.createdAt), MONTH(u.createdAt), COUNT(u) " +
                "FROM User u WHERE u.createdAt >= :fromDate " +
                "GROUP BY YEAR(u.createdAt), MONTH(u.createdAt) " +
                "ORDER BY YEAR(u.createdAt), MONTH(u.createdAt)")
        List<Object[]> getUserGrowthStats(@Param("fromDate") LocalDateTime fromDate);

        /**
         * Tìm recent users
         */
        @Query("SELECT u FROM User u ORDER BY u.createdAt DESC")
        List<User> findRecentUsers(Pageable pageable);

        /**
         * Đếm users created trong khoảng thời gian
         */
        @Query("SELECT COUNT(u) FROM User u WHERE u.createdAt BETWEEN :startDate AND :endDate")
        Long countUsersCreatedBetween(@Param("startDate") LocalDateTime startDate,
                                      @Param("endDate") LocalDateTime endDate);

        /**
         * Tìm instructors có nhiều students nhất
         */
        @Query("SELECT u, COUNT(DISTINCT e.student) as studentCount FROM User u " +
                "LEFT JOIN Course c ON c.instructor = u " +
                "LEFT JOIN Enrollment e ON e.course = c " +
                "WHERE u.role = 'INSTRUCTOR' AND u.active = true " +
                "GROUP BY u ORDER BY COUNT(DISTINCT e.student) DESC")
        List<Object[]> findInstructorsWithMostStudents(Pageable pageable);

        /**
         * Tìm active students
         */
        @Query("SELECT u FROM User u WHERE u.role = 'STUDENT' AND u.active = true " +
                "ORDER BY u.lastLogin DESC")
        List<User> findActiveStudents(Pageable pageable);

        // ===== BASIC FINDER METHODS =====

        Optional<User> findByUsername(String username);

        Optional<User> findByEmail(String email);

        boolean existsByUsername(String username);

        boolean existsByEmail(String email);

        boolean existsByUsernameAndIdNot(String username, Long id);

        boolean existsByEmailAndIdNot(String email, Long id);

        // ===== ROLE-BASED QUERIES =====

        List<User> findByRoleAndActiveOrderByFullName(User.Role role, boolean active);

        List<User> findByRole(User.Role role);

        Page<User> findByRoleAndActive(User.Role role, boolean active, Pageable pageable);

        Long countByRole(User.Role role);

        Long countByRoleAndActive(User.Role role, boolean active);

        // ===== SEARCH QUERIES =====

        @Query("SELECT u FROM User u WHERE " +
                "LOWER(u.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                "LOWER(u.username) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                "LOWER(u.email) LIKE LOWER(CONCAT('%', :keyword, '%'))")
        Page<User> searchUsers(@Param("keyword") String keyword, Pageable pageable);

        @Query("SELECT u FROM User u WHERE u.role = 'INSTRUCTOR' AND u.active = true AND " +
                "(LOWER(u.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                "LOWER(u.username) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
                "ORDER BY u.fullName")
        List<User> searchInstructors(@Param("keyword") String keyword, Pageable pageable);

        @Query("SELECT u FROM User u WHERE u.role = 'STUDENT' AND u.active = true AND " +
                "(LOWER(u.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                "LOWER(u.username) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
                "ORDER BY u.fullName")
        List<User> searchStudents(@Param("keyword") String keyword, Pageable pageable);

        // ===== UPDATE QUERIES =====

        @Modifying
        @Transactional
        @Query("UPDATE User u SET u.lastLogin = :lastLogin WHERE u.id = :userId")
        void updateLastLogin(@Param("userId") Long userId, @Param("lastLogin") LocalDateTime lastLogin);

        @Modifying
        @Transactional
        @Query("UPDATE User u SET u.lastLogin = CURRENT_TIMESTAMP WHERE u.id = :userId")
        void updateLastLogin(@Param("userId") Long userId);

        @Modifying
        @Transactional
        @Query("UPDATE User u SET u.active = :active WHERE u.id = :userId")
        void updateActiveStatus(@Param("userId") Long userId, @Param("active") boolean active);

        @Modifying
        @Transactional
        @Query("UPDATE User u SET u.password = :password WHERE u.id = :userId")
        void updatePassword(@Param("userId") Long userId, @Param("password") String encodedPassword);

        // ===== ANALYTICS QUERIES =====

        @Query("SELECT u.role, COUNT(u) FROM User u GROUP BY u.role")
        List<Object[]> getUserStatsByRole();

        @Query("SELECT u FROM User u WHERE u.createdAt >= :since ORDER BY u.createdAt DESC")
        Page<User> findRecentUsers(@Param("since") LocalDateTime since, Pageable pageable);


        @Query("SELECT YEAR(u.createdAt), MONTH(u.createdAt), COUNT(u) " +
                "FROM User u " +
                "GROUP BY YEAR(u.createdAt), MONTH(u.createdAt) " +
                "ORDER BY YEAR(u.createdAt) DESC, MONTH(u.createdAt) DESC")
        List<Object[]> getUserGrowthStats();

        @Query("SELECT u FROM User u WHERE u.lastLogin >= :since")
        List<User> findUsersActiveRecently(@Param("since") LocalDateTime since);

        @Query("SELECT COUNT(u) FROM User u WHERE u.active = true")
        Long countActiveUsers();

        @Query("SELECT u FROM User u WHERE u.lastLogin IS NULL")
        List<User> findUsersNeverLoggedIn();

        // ===== ADDITIONAL METHODS =====

        Long countByActiveAndLastLoginAfter(boolean active, LocalDateTime lastLoginAfter);

        Long countByActive(boolean active);

        Long countByCreatedAtAfter(LocalDateTime createdAfter);

        @Query("SELECT u FROM User u LEFT JOIN u.instructorCourses c WHERE u.role = :role AND u.active = :active " +
                "GROUP BY u ORDER BY COUNT(c) DESC")
        Page<User> findInstructorsOrderByCourseCount(@Param("role") User.Role role,
                                                     @Param("active") boolean active,
                                                     Pageable pageable);

        @Query("SELECT u FROM User u WHERE " +
                "LOWER(u.username) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                "LOWER(u.email) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                "LOWER(u.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
                "ORDER BY u.createdAt DESC")
        Page<User> findByKeyword(@Param("keyword") String keyword, Pageable pageable);

        @Query("SELECT YEAR(u.createdAt), MONTH(u.createdAt), COUNT(u) FROM User u " +
                "WHERE u.createdAt >= :fromDate GROUP BY YEAR(u.createdAt), MONTH(u.createdAt) " +
                "ORDER BY YEAR(u.createdAt), MONTH(u.createdAt)")
        List<Object[]> getUserStatsByMonth(@Param("fromDate") LocalDateTime fromDate);

        @Query("SELECT u FROM User u WHERE u.role = 'INSTRUCTOR' AND u.active = true ORDER BY u.fullName")
        List<User> findAllInstructorsOrderByName();

        @Query("SELECT u FROM User u WHERE u.role = 'STUDENT' AND u.active = true ORDER BY u.fullName")
        List<User> findAllStudentsOrderByName();
        /**
         * Tìm tất cả users active sắp xếp theo tên
         * @return Danh sách active users
         */
        @Query("SELECT u FROM User u WHERE u.active = true ORDER BY u.fullName")
        List<User> findAllActiveOrderByName();

        List<User> findAllByActiveTrueOrderByFullName();

        @Query("SELECT u FROM User u WHERE u.role = 'INSTRUCTOR' AND u.active = true AND " +
                "(LOWER(u.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                "LOWER(u.username) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
                "ORDER BY u.fullName")
        List<User> searchInstructors(@Param("keyword") String keyword);

        Page<User> findByRole(User.Role role, Pageable pageable);

        @Query("SELECT u FROM User u LEFT JOIN u.enrollments e WHERE u.role = 'STUDENT' " +
                "GROUP BY u ORDER BY AVG(COALESCE(e.finalScore, 0)) DESC")
        Page<User> findTopStudentsByAverageScore(Pageable pageable);

        @Query("SELECT COUNT(DISTINCT e.student) FROM Enrollment e WHERE e.course.instructor = :instructor")
        Long countStudentsByInstructor(@Param("instructor") User instructor);

        @Query("SELECT DISTINCT e.student FROM Enrollment e WHERE e.course.instructor = :instructor " +
                "AND e.progress <= :maxProgress AND e.enrollmentDate >= :enrolledAfter")
        List<User> findLowProgressStudents(@Param("instructor") User instructor,
                                           @Param("maxProgress") double maxProgress,
                                           @Param("enrolledAfter") LocalDateTime enrolledAfter);
    }
