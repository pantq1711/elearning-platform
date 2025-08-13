package com.coursemanagement.repository;

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

    // ===== BASIC FINDER METHODS =====

    /**
     * Tìm enrollment theo student và course
     * @param student Student
     * @param course Course
     * @return Optional chứa Enrollment nếu tìm thấy
     */
    Optional<Enrollment> findByStudentAndCourse(User student, Course course);

    /**
     * Kiểm tra student đã đăng ký course chưa
     * @param student Student
     * @param course Course
     * @return true nếu đã đăng ký
     */
    boolean existsByStudentAndCourse(User student, Course course);

    // ===== STUDENT-RELATED QUERIES =====

    /**
     * Tìm tất cả enrollments của student
     * @param student Student
     * @return Danh sách enrollments
     */
    List<Enrollment> findByStudent(User student);

    /**
     * Tìm enrollments của student sắp xếp theo ngày đăng ký
     * @param student Student
     * @return Danh sách enrollments
     */
    List<Enrollment> findByStudentOrderByEnrollmentDateDesc(User student);

    /**
     * Tìm active enrollments của student (chưa hoàn thành)
     * @param student Student
     * @return Danh sách active enrollments
     */
    @Query("SELECT e FROM Enrollment e WHERE e.student = :student AND e.completed = false")
    List<Enrollment> findActiveEnrollmentsByStudent(@Param("student") User student);

    /**
     * Tìm completed enrollments của student
     * @param student Student
     * @return Danh sách completed enrollments
     */
    @Query("SELECT e FROM Enrollment e WHERE e.student = :student AND e.completed = true")
    List<Enrollment> findCompletedEnrollmentsByStudent(@Param("student") User student);

    /**
     * Tìm enrollments của student với pagination
     * @param student Student
     * @param pageable Pagination info
     * @return Page chứa enrollments
     */
    Page<Enrollment> findByStudent(User student, Pageable pageable);

    /**
     * Đếm enrollments của student
     * @param student Student
     * @return Số lượng enrollments
     */
    Long countByStudent(User student);

    /**
     * Đếm completed enrollments của student
     * @param student Student
     * @return Số lượng completed enrollments
     */
    Long countByStudentAndCompleted(User student, boolean completed);

    // ===== INSTRUCTOR-RELATED QUERIES =====

    /**
     * Tìm enrollments của courses thuộc instructor
     * @param instructor Instructor
     * @return Danh sách enrollments
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course.instructor = :instructor")
    List<Enrollment> findByInstructor(@Param("instructor") User instructor);

    /**
     * Tìm enrollments của instructor với pagination
     * @param instructor Instructor
     * @param pageable Pagination info
     * @return Page chứa enrollments
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course.instructor = :instructor")
    Page<Enrollment> findByInstructor(@Param("instructor") User instructor, Pageable pageable);

    /**
     * Đếm enrollments trong courses của instructor
     * @param instructor Instructor
     * @return Số lượng enrollments
     */
    @Query("SELECT COUNT(e) FROM Enrollment e WHERE e.course.instructor = :instructor")
    Long countByInstructor(@Param("instructor") User instructor);

    // ===== COURSE-RELATED QUERIES =====

    /**
     * Tìm enrollments theo course
     * @param course Course
     * @return Danh sách enrollments
     */
    List<Enrollment> findByCourse(Course course);

    /**
     * Tìm enrollments theo course với pagination
     * @param course Course
     * @param pageable Pagination info
     * @return Page chứa enrollments
     */
    Page<Enrollment> findByCourse(Course course, Pageable pageable);

    /**
     * Đếm enrollments của course
     * @param course Course
     * @return Số lượng enrollments
     */
    Long countEnrollmentsByCourse(Course course);

    /**
     * Đếm completed enrollments của course
     * @param course Course
     * @return Số lượng completed enrollments
     */
    Long countByCompletedAndCourse(boolean completed, Course course);

    /**
     * Lấy completion rate của course
     * @param course Course
     * @return Completion rate (0.0 - 1.0)
     */
    @Query("SELECT CASE WHEN COUNT(e) = 0 THEN 0.0 ELSE " +
            "CAST(SUM(CASE WHEN e.completed = true THEN 1 ELSE 0 END) AS double) / COUNT(e) END " +
            "FROM Enrollment e WHERE e.course = :course")
    Double getCompletionRateByCourse(@Param("course") Course course);

    /**
     * Lấy recent enrollments của course
     * @param course Course
     * @param limit Số lượng enrollments
     * @return Danh sách recent enrollments
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course = :course ORDER BY e.enrollmentDate DESC")
    List<Enrollment> getRecentEnrollmentsByCourse(@Param("course") Course course, @Param("limit") int limit);

    /**
     * Lấy top students của course (theo progress)
     * @param course Course
     * @param limit Số lượng students
     * @return Danh sách top students
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course = :course ORDER BY e.progress DESC")
    List<Enrollment> getTopStudentsByCourse(@Param("course") Course course, @Param("limit") int limit);

    // ===== ANALYTICS QUERIES =====

    /**
     * Đếm tất cả completed enrollments
     * @return Số lượng completed enrollments
     */
    @Query("SELECT COUNT(e) FROM Enrollment e WHERE e.completed = true")
    Long countCompletedEnrollments();

    /**
     * Tìm recent enrollments với limit
     * @param limit Số lượng enrollments
     * @return Danh sách recent enrollments
     */
    @Query("SELECT e FROM Enrollment e ORDER BY e.enrollmentDate DESC")
    List<Enrollment> findRecentEnrollments(@Param("limit") int limit);

    /**
     * Lấy thống kê enrollment theo tháng
     * @return Danh sách [Year, Month, Count]
     */
    @Query("SELECT YEAR(e.enrollmentDate), MONTH(e.enrollmentDate), COUNT(e) " +
            "FROM Enrollment e " +
            "GROUP BY YEAR(e.enrollmentDate), MONTH(e.enrollmentDate) " +
            "ORDER BY YEAR(e.enrollmentDate) DESC, MONTH(e.enrollmentDate) DESC")
    List<Object[]> getMonthlyEnrollmentStats();

    /**
     * Lấy detailed monthly stats với completion data
     * @return Danh sách thống kê chi tiết
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
     * @return Average completion rate (0.0 - 1.0)
     */
    @Query("SELECT CASE WHEN COUNT(e) = 0 THEN 0.0 ELSE " +
            "CAST(SUM(CASE WHEN e.completed = true THEN 1 ELSE 0 END) AS double) / COUNT(e) END " +
            "FROM Enrollment e")
    Double getAverageCompletionRate();

    /**
     * Lấy enrollments trong khoảng thời gian
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Danh sách enrollments
     */
    @Query("SELECT e FROM Enrollment e WHERE e.enrollmentDate BETWEEN :startDate AND :endDate")
    List<Enrollment> findEnrollmentsBetweenDates(@Param("startDate") LocalDateTime startDate,
                                                 @Param("endDate") LocalDateTime endDate);

    /**
     * Lấy enrollments với scores (có quiz results)
     * @param student Student
     * @return Danh sách enrollments với scores
     */
    @Query("SELECT DISTINCT e FROM Enrollment e " +
            "LEFT JOIN e.course.quizzes q " +
            "LEFT JOIN q.quizResults qr " +
            "WHERE e.student = :student AND qr.user = :student")
    List<Enrollment> findEnrollmentsWithScoresByStudent(@Param("student") User student);

    /**
     * Tìm enrollments by student ID
     * @param studentId ID của student
     * @return Danh sách enrollments
     */
    @Query("SELECT e FROM Enrollment e WHERE e.student.id = :studentId")
    List<Enrollment> findByStudentId(@Param("studentId") Long studentId);

    /**
     * Tìm enrollments by course ID
     * @param courseId ID của course
     * @return Danh sách enrollments
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course.id = :courseId")
    List<Enrollment> findByCourseId(@Param("courseId") Long courseId);

    /**
     * Lấy top courses theo enrollment count
     * @param limit Số lượng courses
     * @return Danh sách [Course, EnrollmentCount]
     */
    @Query("SELECT e.course, COUNT(e) as enrollmentCount " +
            "FROM Enrollment e " +
            "GROUP BY e.course " +
            "ORDER BY enrollmentCount DESC")
    List<Object[]> getTopCoursesByEnrollmentCount(@Param("limit") int limit);

    /**
     * Lấy enrollment progress statistics
     * @return Danh sách [ProgressRange, Count]
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
     * @param days Số ngày
     * @return Danh sách enrollments
     */
    @Query("SELECT e FROM Enrollment e WHERE e.completed = false AND " +
            "e.enrollmentDate <= :cutoffDate")
    List<Enrollment> findIncompleteEnrollmentsOlderThan(@Param("cutoffDate") LocalDateTime cutoffDate);
}