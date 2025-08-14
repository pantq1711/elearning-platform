package com.coursemanagement.repository;

import com.coursemanagement.entity.Category;
import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.Enrollment;
import com.coursemanagement.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Repository interface cho Enrollment entity
 * Chứa các custom queries cho enrollment management và analytics
 */
@Repository
public interface EnrollmentRepository extends JpaRepository<Enrollment, Long> {


    /**
     * Đếm enrollments theo category
     */
    @Query("SELECT COUNT(e) FROM Enrollment e WHERE e.course.category = :category")
    Long countEnrollmentsByCategory(@Param("category") Category category);

    /**
     * Đếm completed enrollments
     */

    /**
     * Tìm recent enrollments
     */
    @Query("SELECT e FROM Enrollment e ORDER BY e.enrollmentDate DESC")
    List<Enrollment> findRecentEnrollments(Pageable pageable);

    /**
     * Tìm most active instructors theo enrollment count
     */
    @Query("SELECT e.course.instructor, COUNT(e) as enrollmentCount FROM Enrollment e " +
            "GROUP BY e.course.instructor ORDER BY COUNT(e) DESC")
    List<Object[]> findMostActiveInstructors(Pageable pageable);

    /**
     * Lấy monthly enrollment stats
     */
    @Query("SELECT YEAR(e.enrollmentDate), MONTH(e.enrollmentDate), COUNT(e) " +
            "FROM Enrollment e WHERE e.enrollmentDate >= :fromDate " +
            "GROUP BY YEAR(e.enrollmentDate), MONTH(e.enrollmentDate) " +
            "ORDER BY YEAR(e.enrollmentDate), MONTH(e.enrollmentDate)")
    List<Object[]> getMonthlyEnrollmentStats(@Param("fromDate") LocalDateTime fromDate);

    /**
     * Tính average completion rate
     */

    /**
     * Tìm recent enrollments theo course
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course = :course " +
            "ORDER BY e.enrollmentDate DESC")
    List<Enrollment> getRecentEnrollmentsByCourse(@Param("course") Course course, Pageable pageable);

    /**
     * Tìm top students theo course (by progress)
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course = :course " +
            "ORDER BY e.progress DESC, e.enrollmentDate ASC")
    List<Enrollment> getTopStudentsByCourse(@Param("course") Course course, Pageable pageable);

    /**
     * Lấy detailed monthly stats
     */
    @Query("SELECT YEAR(e.enrollmentDate), MONTH(e.enrollmentDate), " +
            "COUNT(e), COUNT(CASE WHEN e.completed = true THEN 1 END), " +
            "AVG(e.progress) " +
            "FROM Enrollment e WHERE e.enrollmentDate >= :fromDate " +
            "GROUP BY YEAR(e.enrollmentDate), MONTH(e.enrollmentDate) " +
            "ORDER BY YEAR(e.enrollmentDate), MONTH(e.enrollmentDate)")
    List<Object[]> getDetailedMonthlyStats(@Param("fromDate") LocalDateTime fromDate);

    /**
     * Đếm tất cả enrollments
     */
    @Query("SELECT COUNT(e) FROM Enrollment e")
    Long countAllEnrollments();

    /**
     * Tìm active enrollments theo student
     */

    // Basic finders
    Optional<Enrollment> findByStudentIdAndCourseId(Long studentId, Long courseId);

    // Student-related methods
    List<Enrollment> findByStudentAndCompletedOrderByUpdatedAtDesc(User student, boolean completed);

    // Course-related methods
    List<Enrollment> findByCourseOrderByEnrollmentDateDesc(Course course);

    // Count methods
    Long countByCourse(Course course);
    Long countByCourseId(Long courseId);
    Long countByCourseIdAndCompleted(Long courseId, boolean completed);

    // Advanced statistics
    @Query("SELECT YEAR(e.enrollmentDate), MONTH(e.enrollmentDate), COUNT(e) FROM Enrollment e " +
            "WHERE e.enrollmentDate >= :fromDate GROUP BY YEAR(e.enrollmentDate), MONTH(e.enrollmentDate)")
    Page<Object[]> getEnrollmentStatsByMonth(@Param("fromDate") LocalDateTime fromDate, Pageable pageable);

    @Query("SELECT c.name, COUNT(e) FROM Enrollment e JOIN e.course c " +
            "GROUP BY c.id, c.name ORDER BY COUNT(e) DESC")
    List<Object[]> findTopCoursesByEnrollmentCount(Pageable pageable);

    // ===== BASIC FINDER METHODS =====

    /**
     * Tìm enrollment theo student và course
     */
    Optional<Enrollment> findByStudentAndCourse(User student, Course course);

    /**
     * Kiểm tra student đã đăng ký course chưa
     */
    boolean existsByStudentAndCourse(User student, Course course);

    /**
     * Kiểm tra student đã đăng ký course theo ID không
     */
    boolean existsByStudentIdAndCourseId(Long studentId, Long courseId);

    // ===== STUDENT-RELATED QUERIES =====

    /**
     * Tìm tất cả enrollments của student
     */
    List<Enrollment> findByStudent(User student);

    /**
     * Tìm enrollments của student sắp xếp theo ngày đăng ký
     */
    List<Enrollment> findByStudentOrderByEnrollmentDateDesc(User student);

    /**
     * Tìm enrollments theo student và trạng thái completed
     */
    List<Enrollment> findByStudentAndCompletedOrderByEnrollmentDateDesc(User student, boolean completed);

    /**
     * Tìm completed enrollments theo completion date
     */
    List<Enrollment> findByStudentAndCompletedOrderByCompletionDateDesc(User student, boolean completed);

    /**
     * Tìm enrollments theo student và score lớn hơn threshold
     */
    List<Enrollment> findByStudentAndFinalScoreGreaterThanOrderByFinalScoreDesc(User student, double minScore);

    /**
     * Tìm active enrollments của student (chưa hoàn thành)
     */
    @Query("SELECT e FROM Enrollment e WHERE e.student = :student AND e.completed = false")
    List<Enrollment> findActiveEnrollmentsByStudent(@Param("student") User student);

    /**
     * Tìm completed enrollments của student
     */
    @Query("SELECT e FROM Enrollment e WHERE e.student = :student AND e.completed = true")
    List<Enrollment> findCompletedEnrollmentsByStudent(@Param("student") User student);

    /**
     * Tìm enrollments của student với pagination
     */
    Page<Enrollment> findByStudent(User student, Pageable pageable);

    /**
     * Đếm enrollments của student
     */
    Long countByStudent(User student);

    /**
     * Đếm completed enrollments của student
     */
    Long countByStudentAndCompleted(User student, boolean completed);

    /**
     * Lấy điểm trung bình của student từ tất cả enrollments
     */
    @Query("SELECT AVG(COALESCE(e.finalScore, 0)) FROM Enrollment e WHERE e.student = :student")
    Double getAverageScoreByStudent(@Param("student") User student);

    /**
     * Tìm enrollments by student ID
     */
    @Query("SELECT e FROM Enrollment e WHERE e.student.id = :studentId ORDER BY e.enrollmentDate DESC")
    List<Enrollment> findByStudentId(@Param("studentId") Long studentId);

    // ===== INSTRUCTOR-RELATED QUERIES =====

    /**
     * Tìm enrollments của courses thuộc instructor
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course.instructor = :instructor")
    List<Enrollment> findByInstructor(@Param("instructor") User instructor);

    /**
     * Tìm enrollments của instructor với pagination
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course.instructor = :instructor")
    Page<Enrollment> findByInstructor(@Param("instructor") User instructor, Pageable pageable);

    /**
     * Tìm recent enrollments của instructor
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course.instructor = :instructor ORDER BY e.enrollmentDate DESC")
    Page<Enrollment> findRecentEnrollmentsByInstructor(@Param("instructor") User instructor, Pageable pageable);

    /**
     * Đếm enrollments trong courses của instructor
     */
    @Query("SELECT COUNT(e) FROM Enrollment e WHERE e.course.instructor = :instructor")
    Long countByInstructor(@Param("instructor") User instructor);

    /**
     * Đếm số students của một instructor
     */
    @Query("SELECT COUNT(DISTINCT e.student) FROM Enrollment e WHERE e.course.instructor = :instructor")
    Long countStudentsByInstructor(@Param("instructor") User instructor);

    /**
     * Tính tổng revenue của instructor
     */
    @Query("SELECT SUM(COALESCE(e.course.price, 0)) FROM Enrollment e WHERE e.course.instructor = :instructor")
    Double calculateRevenueByInstructor(@Param("instructor") User instructor);

    /**
     * Tìm students có low progress trong courses của instructor
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course.instructor = :instructor " +
            "AND e.progress <= :maxProgress AND e.enrollmentDate >= :enrolledAfter " +
            "ORDER BY e.progress ASC")
    List<Enrollment> findLowProgressEnrollments(@Param("instructor") User instructor,
                                                @Param("maxProgress") double maxProgress,
                                                @Param("enrolledAfter") LocalDateTime enrolledAfter);

    // ===== COURSE-RELATED QUERIES =====

    /**
     * Tìm enrollments theo course
     */
    List<Enrollment> findByCourse(Course course);

    /**
     * Tìm enrollments theo course với pagination
     */
    Page<Enrollment> findByCourse(Course course, Pageable pageable);

    /**
     * Tìm enrollments theo course sắp xếp theo enrollment date
     */
    Page<Enrollment> findByCourseOrderByEnrollmentDateDesc(Course course, Pageable pageable);

    /**
     * Đếm enrollments của course
     */
    Long countEnrollmentsByCourse(Course course);

    /**
     * Đếm completed enrollments của course
     */
    Long countByCompletedAndCourse(boolean completed, Course course);

    /**
     * Lấy completion rate của course
     */
    @Query("SELECT CASE WHEN COUNT(e) = 0 THEN 0.0 ELSE " +
            "CAST(SUM(CASE WHEN e.completed = true THEN 1 ELSE 0 END) AS double) / COUNT(e) END " +
            "FROM Enrollment e WHERE e.course = :course")
    Double getCompletionRateByCourse(@Param("course") Course course);

    /**
     * Lấy recent enrollments của course
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course = :course ORDER BY e.enrollmentDate DESC")
    List<Enrollment> getRecentEnrollmentsByCourse(@Param("course") Course course);

    /**
     * Lấy top students của course (theo progress)
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course = :course ORDER BY e.progress DESC")
    List<Enrollment> getTopStudentsByCourse(@Param("course") Course course);

    /**
     * Tìm enrollments by course ID
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course.id = :courseId ORDER BY e.enrollmentDate DESC")
    List<Enrollment> findByCourseId(@Param("courseId") Long courseId);

    /**
     * Tìm enrollments theo course với filters
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course.id = :courseId " +
            "AND (:completed IS NULL OR e.completed = :completed) " +
            "ORDER BY e.enrollmentDate DESC")
    Page<Enrollment> findByCourseWithFilters(@Param("courseId") Long courseId,
                                             @Param("completed") Boolean completed,
                                             Pageable pageable);

    // ===== ANALYTICS QUERIES =====

    /**
     * Đếm tất cả completed enrollments
     */
    @Query("SELECT COUNT(e) FROM Enrollment e WHERE e.completed = true")
    Long countCompletedEnrollments();

    /**
     * Đếm enrollments theo trạng thái completed
     */
    Long countByCompleted(boolean completed);

    /**
     * Đếm total enrollments
     */
    @Query("SELECT COUNT(e) FROM Enrollment e")
    Long countTotal();

    /**
     * Tìm recent enrollments với limit
     */
    @Query("SELECT e FROM Enrollment e ORDER BY e.enrollmentDate DESC")
    List<Enrollment> findRecentEnrollments(@Param("limit") int limit);

    /**
     * Lấy thống kê enrollment theo tháng
     */
    @Query("SELECT YEAR(e.enrollmentDate), MONTH(e.enrollmentDate), COUNT(e) " +
            "FROM Enrollment e " +
            "GROUP BY YEAR(e.enrollmentDate), MONTH(e.enrollmentDate) " +
            "ORDER BY YEAR(e.enrollmentDate) DESC, MONTH(e.enrollmentDate) DESC")
    List<Object[]> getMonthlyEnrollmentStats();

    /**
     * Lấy thống kê enrollments theo tháng từ một thời điểm
     */
    @Query("SELECT YEAR(e.enrollmentDate), MONTH(e.enrollmentDate), COUNT(e) FROM Enrollment e " +
            "WHERE e.enrollmentDate >= :fromDate GROUP BY YEAR(e.enrollmentDate), MONTH(e.enrollmentDate) " +
            "ORDER BY YEAR(e.enrollmentDate), MONTH(e.enrollmentDate)")
    List<Object[]> getEnrollmentStatsByMonth(@Param("fromDate") LocalDateTime fromDate);

    /**
     * Lấy detailed monthly stats với completion data
     */
    @Query("SELECT YEAR(e.enrollmentDate), MONTH(e.enrollmentDate), " +
            "COUNT(e) as total, " +
            "SUM(CASE WHEN e.completed = true THEN 1 ELSE 0 END) as completed " +
            "FROM Enrollment e " +
            "GROUP BY YEAR(e.enrollmentDate), MONTH(e.enrollmentDate) " +
            "ORDER BY YEAR(e.enrollmentDate) DESC, MONTH(e.enrollmentDate) DESC")
    List<Object[]> getDetailedMonthlyStats();

    /**
     * Tính average completion rate
     */
    @Query("SELECT CASE WHEN COUNT(e) = 0 THEN 0.0 ELSE " +
            "CAST(SUM(CASE WHEN e.completed = true THEN 1 ELSE 0 END) AS double) / COUNT(e) END " +
            "FROM Enrollment e")
    Double getAverageCompletionRate();

    /**
     * Lấy enrollments trong khoảng thời gian
     */
    @Query("SELECT e FROM Enrollment e WHERE e.enrollmentDate BETWEEN :startDate AND :endDate")
    List<Enrollment> findEnrollmentsBetweenDates(@Param("startDate") LocalDateTime startDate,
                                                 @Param("endDate") LocalDateTime endDate);

    /**
     * Lấy enrollments với scores (có quiz results)
     */
    @Query("SELECT DISTINCT e FROM Enrollment e " +
            "LEFT JOIN e.course.quizzes q " +
            "LEFT JOIN q.quizResults qr " +
            "WHERE e.student = :student AND qr.student = :student")
    List<Enrollment> findEnrollmentsWithScoresByStudent(@Param("student") User student);

    /**
     * Lấy top courses theo enrollment count
     */
    @Query("SELECT e.course, COUNT(e) as enrollmentCount " +
            "FROM Enrollment e " +
            "GROUP BY e.course " +
            "ORDER BY enrollmentCount DESC")
    List<Object[]> getTopCoursesByEnrollmentCount(@Param("limit") int limit);

    /**
     * Lấy enrollment progress statistics
     */
    @Query("SELECT " +
            "CASE " +
            "WHEN e.progress < 25 THEN '0-25%' " +
            "WHEN e.progress < 50 THEN '25-50%' " +
            "WHEN e.progress < 75 THEN '50-75%' " +
            "WHEN e.progress < 100 THEN '75-100%' " +
            "ELSE 'Completed' END as progressRange, " +
            "COUNT(e) " +
            "FROM Enrollment e " +
            "GROUP BY " +
            "CASE " +
            "WHEN e.progress < 25 THEN '0-25%' " +
            "WHEN e.progress < 50 THEN '25-50%' " +
            "WHEN e.progress < 75 THEN '50-75%' " +
            "WHEN e.progress < 100 THEN '75-100%' " +
            "ELSE 'Completed' END")
    List<Object[]> getProgressStatistics();

    /**
     * Tìm students chưa hoàn thành course sau X ngày
     */
    @Query("SELECT e FROM Enrollment e WHERE e.completed = false AND " +
            "e.enrollmentDate <= :cutoffDate")
    List<Enrollment> findIncompleteEnrollmentsOlderThan(@Param("cutoffDate") LocalDateTime cutoffDate);

    /**
     * Tìm top students theo average score
     */
    @Query("SELECT e.student, AVG(COALESCE(e.finalScore, 0)) as avgScore FROM Enrollment e " +
            "WHERE e.finalScore IS NOT NULL GROUP BY e.student ORDER BY avgScore DESC")
    Page<Object[]> findTopStudentsByAverageScore(Pageable pageable);
}