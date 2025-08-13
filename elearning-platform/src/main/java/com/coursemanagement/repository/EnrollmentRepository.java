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

    /**
     * Kiểm tra student đã đăng ký course chưa (theo ID)
     * @param studentId ID của student
     * @param courseId ID của course
     * @return true nếu đã đăng ký
     */
    boolean existsByStudentIdAndCourseId(Long studentId, Long courseId);

    // ===== STUDENT-RELATED QUERIES =====

    /**
     * Tìm enrollments của student sắp xếp theo ngày đăng ký
     * @param student Student
     * @return Danh sách enrollments
     */
    List<Enrollment> findByStudentOrderByEnrollmentDateDesc(User student);

    /**
     * Tìm enrollments theo student và completion status
     * @param student Student
     * @param completed Trạng thái completed
     * @return Danh sách enrollments
     */
    List<Enrollment> findByStudentAndCompletedOrderByEnrollmentDateDesc(User student, boolean completed);

    /**
     * Tìm completed enrollments theo student sắp xếp theo completion date
     * @param student Student
     * @param completed Trạng thái completed
     * @return Danh sách completed enrollments
     */
    List<Enrollment> findByStudentAndCompletedOrderByCompletionDateDesc(User student, boolean completed);

    /**
     * Tìm enrollments theo student có score > 0
     * @param student Student
     * @param score Score threshold
     * @return Danh sách enrollments có score
     */
    List<Enrollment> findByStudentAndScoreGreaterThanOrderByScoreDesc(User student, Double score);

    /**
     * Đếm enrollments theo student
     * @param student Student
     * @return Số lượng enrollments
     */
    Long countByStudent(User student);

    /**
     * Đếm enrollments theo student và completion status
     * @param student Student
     * @param completed Trạng thái completed
     * @return Số lượng enrollments
     */
    Long countByStudentAndCompleted(User student, boolean completed);

    /**
     * Lấy điểm trung bình theo student
     * @param student Student
     * @return Điểm trung bình
     */
    @Query("SELECT AVG(e.score) FROM Enrollment e WHERE e.student = :student AND e.score > 0")
    Double getAverageScoreByStudent(@Param("student") User student);

    // ===== COURSE-RELATED QUERIES =====

    /**
     * Tìm enrollments của course sắp xếp theo ngày đăng ký
     * @param course Course
     * @return Danh sách enrollments
     */
    List<Enrollment> findByCourseOrderByEnrollmentDateDesc(Course course);

    /**
     * Tìm enrollments của course với pagination
     * @param course Course
     * @param pageable Pagination info
     * @return Page enrollments
     */
    Page<Enrollment> findByCourseOrderByEnrollmentDateDesc(Course course, Pageable pageable);

    /**
     * Đếm enrollments theo course
     * @param course Course
     * @return Số lượng enrollments
     */
    Long countByCourse(Course course);

    /**
     * Đếm completed enrollments theo course
     * @param course Course
     * @param completed Trạng thái completed
     * @return Số lượng completed enrollments
     */
    Long countByCourseAndCompleted(Course course, boolean completed);

    // ===== INSTRUCTOR-RELATED QUERIES =====

    /**
     * Đếm students theo instructor
     * @param instructor Instructor
     * @return Số lượng unique students
     */
    @Query("SELECT COUNT(DISTINCT e.student) FROM Enrollment e WHERE e.course.instructor = :instructor")
    Long countStudentsByInstructor(@Param("instructor") User instructor);

    /**
     * Tính revenue theo instructor
     * @param instructor Instructor
     * @return Tổng revenue
     */
    @Query("SELECT SUM(e.course.price) FROM Enrollment e WHERE e.course.instructor = :instructor")
    Double calculateRevenueByInstructor(@Param("instructor") User instructor);

    /**
     * Tìm recent enrollments theo instructor
     * @param instructor Instructor
     * @param pageable Pagination info
     * @return Danh sách recent enrollments
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course.instructor = :instructor " +
            "ORDER BY e.enrollmentDate DESC")
    List<Enrollment> findRecentEnrollmentsByInstructor(@Param("instructor") User instructor, Pageable pageable);

    /**
     * Tìm enrollments theo instructor với pagination
     * @param instructor Instructor
     * @param pageable Pagination info
     * @return Page enrollments
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course.instructor = :instructor " +
            "ORDER BY e.enrollmentDate DESC")
    Page<Enrollment> findByInstructor(@Param("instructor") User instructor, Pageable pageable);

    // ===== COMPLETION-BASED QUERIES =====

    /**
     * Đếm enrollments theo completion status
     * @param completed Trạng thái completed
     * @return Số lượng enrollments
     */
    Long countByCompleted(boolean completed);

    /**
     * Tìm enrollments completed trong khoảng thời gian
     * @param completed Trạng thái completed
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Số lượng enrollments
     */
    Long countByCompletedAndCompletionDateBetween(boolean completed, LocalDateTime startDate, LocalDateTime endDate);

    /**
     * Tìm enrollments với progress thấp
     * @param instructor Instructor
     * @param maxProgress Progress tối đa
     * @param enrolledBefore Đăng ký trước ngày
     * @return Danh sách enrollments cần attention
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course.instructor = :instructor " +
            "AND e.completed = false AND e.progress < :maxProgress " +
            "AND e.enrollmentDate < :enrolledBefore " +
            "ORDER BY e.progress ASC")
    List<Enrollment> findLowProgressEnrollments(@Param("instructor") User instructor,
                                                @Param("maxProgress") Double maxProgress,
                                                @Param("enrolledBefore") LocalDateTime enrolledBefore);

    // ===== PROGRESS-RELATED QUERIES =====

    /**
     * Tìm enrollments theo progress range
     * @param minProgress Progress tối thiểu
     * @param maxProgress Progress tối đa
     * @return Danh sách enrollments
     */
    @Query("SELECT e FROM Enrollment e WHERE e.progress >= :minProgress AND e.progress <= :maxProgress " +
            "ORDER BY e.progress DESC")
    List<Enrollment> findByProgressRange(@Param("minProgress") Double minProgress,
                                         @Param("maxProgress") Double maxProgress);

    /**
     * Lấy average progress theo course
     * @param course Course
     * @return Average progress
     */
    @Query("SELECT AVG(e.progress) FROM Enrollment e WHERE e.course = :course")
    Double getAverageProgressByCourse(@Param("course") Course course);

    /**
     * Lấy completion rate theo course
     * @param course Course
     * @return Completion rate (%)
     */
    @Query("SELECT (COUNT(CASE WHEN e.completed = true THEN 1 END) * 100.0 / COUNT(e)) " +
            "FROM Enrollment e WHERE e.course = :course")
    Double getCompletionRateByCourse(@Param("course") Course course);

    // ===== TIME-BASED QUERIES =====

    /**
     * Tìm enrollments trong khoảng thời gian
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Danh sách enrollments
     */
    @Query("SELECT e FROM Enrollment e WHERE e.enrollmentDate >= :startDate AND e.enrollmentDate <= :endDate " +
            "ORDER BY e.enrollmentDate DESC")
    List<Enrollment> findByEnrollmentDateBetween(@Param("startDate") LocalDateTime startDate,
                                                 @Param("endDate") LocalDateTime endDate);

    /**
     * Đếm enrollments trong tháng này
     * @param startDate Ngày đầu tháng
     * @return Số lượng enrollments
     */
    @Query("SELECT COUNT(e) FROM Enrollment e WHERE e.enrollmentDate >= :startDate")
    Long countEnrollmentsThisMonth(@Param("startDate") LocalDateTime startDate);

    /**
     * Tìm recent enrollments (trong X ngày gần đây)
     * @param startDate Ngày bắt đầu
     * @return Danh sách recent enrollments
     */
    @Query("SELECT e FROM Enrollment e WHERE e.enrollmentDate >= :startDate " +
            "ORDER BY e.enrollmentDate DESC")
    List<Enrollment> findRecentEnrollments(@Param("startDate") LocalDateTime startDate);

    // ===== STATISTICS METHODS =====

    /**
     * Lấy thống kê enrollments theo tháng
     * @param startDate Ngày bắt đầu
     * @return List array [month, year, enrollmentCount, completionCount]
     */
    @Query("SELECT MONTH(e.enrollmentDate), YEAR(e.enrollmentDate), " +
            "COUNT(e), COUNT(CASE WHEN e.completed = true THEN 1 END) " +
            "FROM Enrollment e " +
            "WHERE e.enrollmentDate >= :startDate " +
            "GROUP BY YEAR(e.enrollmentDate), MONTH(e.enrollmentDate) " +
            "ORDER BY YEAR(e.enrollmentDate), MONTH(e.enrollmentDate)")
    List<Object[]> getEnrollmentStatsByMonth(@Param("startDate") LocalDateTime startDate);

    /**
     * Lấy top courses theo enrollment count
     * @param pageable Pagination info
     * @return List array [courseId, courseName, enrollmentCount]
     */
    @Query("SELECT e.course.id, e.course.name, COUNT(e) " +
            "FROM Enrollment e " +
            "GROUP BY e.course.id, e.course.name " +
            "ORDER BY COUNT(e) DESC")
    List<Object[]> findTopCoursesByEnrollmentCount(Pageable pageable);

    /**
     * Lấy top students theo average score
     * @param pageable Pagination info
     * @return List array [studentId, studentName, averageScore, enrollmentCount]
     */
    @Query("SELECT e.student.id, e.student.fullName, AVG(e.score), COUNT(e) " +
            "FROM Enrollment e " +
            "WHERE e.score > 0 " +
            "GROUP BY e.student.id, e.student.fullName " +
            "HAVING COUNT(e) >= 3 " +
            "ORDER BY AVG(e.score) DESC")
    List<Object[]> findTopStudentsByAverageScore(Pageable pageable);

    /**
     * Lấy thống kê completion rate theo instructor
     * @return List array [instructorId, instructorName, totalEnrollments, completedEnrollments, completionRate]
     */
    @Query("SELECT e.course.instructor.id, e.course.instructor.fullName, " +
            "COUNT(e), COUNT(CASE WHEN e.completed = true THEN 1 END), " +
            "(COUNT(CASE WHEN e.completed = true THEN 1 END) * 100.0 / COUNT(e)) " +
            "FROM Enrollment e " +
            "GROUP BY e.course.instructor.id, e.course.instructor.fullName " +
            "ORDER BY (COUNT(CASE WHEN e.completed = true THEN 1 END) * 100.0 / COUNT(e)) DESC")
    List<Object[]> getCompletionRateByInstructor();

    // ===== ADVANCED ANALYTICS =====

    /**
     * Tìm students at risk (low progress, enrolled long time ago)
     * @param maxProgress Progress tối đa
     * @param enrolledBefore Đăng ký trước ngày
     * @return List array [studentId, studentName, courseCount, averageProgress]
     */
    @Query("SELECT e.student.id, e.student.fullName, COUNT(e), AVG(e.progress) " +
            "FROM Enrollment e " +
            "WHERE e.completed = false AND e.progress < :maxProgress " +
            "AND e.enrollmentDate < :enrolledBefore " +
            "GROUP BY e.student.id, e.student.fullName " +
            "HAVING COUNT(e) >= 2 " +
            "ORDER BY AVG(e.progress) ASC")
    List<Object[]> findStudentsAtRisk(@Param("maxProgress") Double maxProgress,
                                      @Param("enrolledBefore") LocalDateTime enrolledBefore);

    /**
     * Lấy revenue theo tháng
     * @param startDate Ngày bắt đầu
     * @return List array [month, year, revenue]
     */
    @Query("SELECT MONTH(e.enrollmentDate), YEAR(e.enrollmentDate), SUM(e.course.price) " +
            "FROM Enrollment e " +
            "WHERE e.enrollmentDate >= :startDate " +
            "GROUP BY YEAR(e.enrollmentDate), MONTH(e.enrollmentDate) " +
            "ORDER BY YEAR(e.enrollmentDate), MONTH(e.enrollmentDate)")
    List<Object[]> getRevenueByMonth(@Param("startDate") LocalDateTime startDate);

    /**
     * Tìm inactive students (không có progress trong X ngày)
     * @param lastActiveDate Ngày active cuối
     * @return Danh sách inactive enrollments
     */
    @Query("SELECT e FROM Enrollment e WHERE e.completed = false " +
            "AND e.updatedAt < :lastActiveDate " +
            "ORDER BY e.updatedAt ASC")
    List<Enrollment> findInactiveEnrollments(@Param("lastActiveDate") LocalDateTime lastActiveDate);

    /**
     * Lấy enrollment trends (growth rate)
     * @param currentMonthStart Đầu tháng hiện tại
     * @param previousMonthStart Đầu tháng trước
     * @return List array [currentMonthCount, previousMonthCount, growthRate]
     */
    @Query("SELECT " +
            "(SELECT COUNT(e1) FROM Enrollment e1 WHERE e1.enrollmentDate >= :currentMonthStart), " +
            "(SELECT COUNT(e2) FROM Enrollment e2 WHERE e2.enrollmentDate >= :previousMonthStart AND e2.enrollmentDate < :currentMonthStart), " +
            "CASE WHEN (SELECT COUNT(e3) FROM Enrollment e3 WHERE e3.enrollmentDate >= :previousMonthStart AND e3.enrollmentDate < :currentMonthStart) > 0 " +
            "THEN ((SELECT COUNT(e4) FROM Enrollment e4 WHERE e4.enrollmentDate >= :currentMonthStart) - " +
            "      (SELECT COUNT(e5) FROM Enrollment e5 WHERE e5.enrollmentDate >= :previousMonthStart AND e5.enrollmentDate < :currentMonthStart)) * 100.0 / " +
            "     (SELECT COUNT(e6) FROM Enrollment e6 WHERE e6.enrollmentDate >= :previousMonthStart AND e6.enrollmentDate < :currentMonthStart) " +
            "ELSE 0 END")
    List<Object[]> getEnrollmentTrends(@Param("currentMonthStart") LocalDateTime currentMonthStart,
                                       @Param("previousMonthStart") LocalDateTime previousMonthStart);
}