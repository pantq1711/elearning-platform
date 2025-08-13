package com.coursemanagement.repository;

import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.Enrollment;
import com.coursemanagement.entity.User;
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
     * Tìm enrollments của một student, sắp xếp theo ngày đăng ký
     * @param student Student
     * @return Danh sách enrollments
     */
    List<Enrollment> findByStudentOrderByEnrollmentDateDesc(User student);

    /**
     * Tìm enrollments của một course, sắp xếp theo ngày đăng ký
     * @param course Course
     * @return Danh sách enrollments
     */
    List<Enrollment> findByCourseOrderByEnrollmentDateDesc(Course course);

    /**
     * Tìm enrollments của một course với pagination
     * @param course Course
     * @param pageable Pagination info
     * @return Danh sách enrollments
     */
    List<Enrollment> findByCourseOrderByEnrollmentDateDesc(Course course, Pageable pageable);

    // ===== COMPLETION-BASED QUERIES =====

    /**
     * Đếm enrollments theo completion status
     * @param completed Trạng thái hoàn thành
     * @return Số lượng enrollments
     */
    Long countByCompleted(boolean completed);

    /**
     * Tìm enrollments đã hoàn thành trong khoảng thời gian
     * @param completed Trạng thái hoàn thành
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Số lượng enrollments
     */
    Long countByCompletedAndCompletionDateBetween(boolean completed, LocalDateTime startDate, LocalDateTime endDate);

    /**
     * Đếm enrollments theo course và completion status
     * @param course Course
     * @param completed Trạng thái hoàn thành
     * @return Số lượng enrollments
     */
    Long countByCourseAndCompleted(Course course, boolean completed);

    /**
     * Đếm enrollments theo course
     * @param course Course
     * @return Số lượng enrollments
     */
    Long countByCourse(Course course);

    // ===== INSTRUCTOR-RELATED QUERIES =====

    /**
     * Đếm distinct students của một instructor
     * @param instructor Instructor
     * @return Số lượng unique students
     */
    @Query("SELECT COUNT(DISTINCT e.student) FROM Enrollment e WHERE e.course.instructor = :instructor")
    Long countDistinctStudentsByInstructor(@Param("instructor") User instructor);

    /**
     * Tìm enrollments của instructor, sắp xếp theo ngày đăng ký
     * @param instructor Instructor
     * @param pageable Pagination info
     * @return Danh sách enrollments
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course.instructor = :instructor ORDER BY e.enrollmentDate DESC")
    List<Enrollment> findByInstructorOrderByEnrollmentDateDesc(@Param("instructor") User instructor, Pageable pageable);

    /**
     * Đếm enrollments của instructor trong khoảng thời gian
     * @param instructor Instructor
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Số lượng enrollments
     */
    @Query("SELECT COUNT(e) FROM Enrollment e WHERE e.course.instructor = :instructor " +
            "AND e.enrollmentDate BETWEEN :startDate AND :endDate")
    Long countByInstructorAndEnrollmentDateBetween(@Param("instructor") User instructor,
                                                   @Param("startDate") LocalDateTime startDate,
                                                   @Param("endDate") LocalDateTime endDate);

    /**
     * Đếm completions của instructor trong khoảng thời gian
     * @param instructor Instructor
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Số lượng completions
     */
    @Query("SELECT COUNT(e) FROM Enrollment e WHERE e.course.instructor = :instructor " +
            "AND e.completed = true AND e.completionDate BETWEEN :startDate AND :endDate")
    Long countByInstructorAndCompletionDateBetween(@Param("instructor") User instructor,
                                                   @Param("startDate") LocalDateTime startDate,
                                                   @Param("endDate") LocalDateTime endDate);

    // ===== TIME-BASED ANALYTICS =====

    /**
     * Đếm enrollments trong khoảng thời gian
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Số lượng enrollments
     */
    Long countByEnrollmentDateBetween(LocalDateTime startDate, LocalDateTime endDate);

    /**
     * Lấy thống kê enrollments theo tháng
     * @param months Số tháng cần lấy
     * @return List array [month, year, count]
     */
    @Query("SELECT MONTH(e.enrollmentDate), YEAR(e.enrollmentDate), COUNT(e) " +
            "FROM Enrollment e " +
            "WHERE e.enrollmentDate >= :startDate " +
            "GROUP BY YEAR(e.enrollmentDate), MONTH(e.enrollmentDate) " +
            "ORDER BY YEAR(e.enrollmentDate), MONTH(e.enrollmentDate)")
    List<Object[]> getEnrollmentStatsByMonth(@Param("startDate") LocalDateTime startDate);

    /**
     * Lấy thống kê completions theo tháng
     * @param months Số tháng cần lấy
     * @return List array [month, year, count]
     */
    @Query("SELECT MONTH(e.completionDate), YEAR(e.completionDate), COUNT(e) " +
            "FROM Enrollment e " +
            "WHERE e.completed = true AND e.completionDate >= :startDate " +
            "GROUP BY YEAR(e.completionDate), MONTH(e.completionDate) " +
            "ORDER BY YEAR(e.completionDate), MONTH(e.completionDate)")
    List<Object[]> getCompletionStatsByMonth(@Param("startDate") LocalDateTime startDate);

    // ===== PROGRESS-BASED QUERIES =====

    /**
     * Tìm enrollments theo course sắp xếp theo progress
     * @param course Course
     * @param pageable Pagination info
     * @return Danh sách enrollments
     */
    List<Enrollment> findByCourseOrderByProgressDesc(Course course, Pageable pageable);

    /**
     * Tìm enrollments có progress trong khoảng cụ thể
     * @param course Course
     * @param minProgress Progress tối thiểu
     * @param maxProgress Progress tối đa
     * @return Danh sách enrollments
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course = :course " +
            "AND e.progress BETWEEN :minProgress AND :maxProgress")
    List<Enrollment> findByCourseAndProgressBetween(@Param("course") Course course,
                                                    @Param("minProgress") double minProgress,
                                                    @Param("maxProgress") double maxProgress);

    /**
     * Lấy average progress của course
     * @param course Course
     * @return Average progress
     */
    @Query("SELECT AVG(e.progress) FROM Enrollment e WHERE e.course = :course")
    Double getAverageProgressByCourse(@Param("course") Course course);

    // ===== RANKING AND TOP PERFORMERS =====

    /**
     * Lấy top students theo progress của instructor
     * @param instructor Instructor
     * @param pageable Pagination info
     * @return Danh sách top students
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course.instructor = :instructor " +
            "ORDER BY e.progress DESC, e.completionDate ASC NULLS LAST")
    List<Enrollment> findTopStudentsByInstructor(@Param("instructor") User instructor, Pageable pageable);

    /**
     * Lấy recent completions
     * @param limit Số lượng cần lấy
     * @return Danh sách recent completions
     */
    @Query("SELECT e FROM Enrollment e WHERE e.completed = true " +
            "ORDER BY e.completionDate DESC")
    List<Enrollment> findRecentCompletions(Pageable pageable);

    /**
     * Lấy students đang struggle (progress thấp sau thời gian dài)
     * @param maxProgress Progress tối đa
     * @param enrolledBefore Đăng ký trước thời điểm này
     * @return Danh sách struggling students
     */
    @Query("SELECT e FROM Enrollment e WHERE e.progress <= :maxProgress " +
            "AND e.enrollmentDate <= :enrolledBefore AND e.completed = false")
    List<Enrollment> findStrugglingStudents(@Param("maxProgress") double maxProgress,
                                            @Param("enrolledBefore") LocalDateTime enrolledBefore);

    // ===== COURSE POPULARITY QUERIES =====

    /**
     * Lấy courses phổ biến nhất theo số enrollments
     * @param pageable Pagination info
     * @return List array [course, enrollment_count]
     */
    @Query("SELECT e.course, COUNT(e) as enrollmentCount FROM Enrollment e " +
            "GROUP BY e.course ORDER BY enrollmentCount DESC")
    List<Object[]> findMostPopularCourses(Pageable pageable);

    /**
     * Lấy courses có completion rate cao nhất
     * @param pageable Pagination info
     * @return List array [course, completion_rate]
     */
    @Query("SELECT e.course, " +
            "(COUNT(CASE WHEN e.completed = true THEN 1 END) * 100.0 / COUNT(e)) as completionRate " +
            "FROM Enrollment e " +
            "GROUP BY e.course " +
            "HAVING COUNT(e) >= 5 " +
            "ORDER BY completionRate DESC")
    List<Object[]> findCoursesWithHighestCompletionRate(Pageable pageable);

    // ===== REVENUE AND FINANCIAL QUERIES =====

    /**
     * Tính tổng revenue của instructor (nếu có pricing)
     * Placeholder - cần thêm price field vào Course
     * @param instructor Instructor
     * @return Tổng revenue
     */
    @Query("SELECT COALESCE(SUM(e.course.price), 0) FROM Enrollment e WHERE e.course.instructor = :instructor")
    Double calculateRevenueByInstructor(@Param("instructor") User instructor);

    /**
     * Lấy thống kê revenue theo tháng
     * @param startDate Ngày bắt đầu
     * @return List array [month, year, revenue]
     */
    @Query("SELECT MONTH(e.enrollmentDate), YEAR(e.enrollmentDate), SUM(e.course.price) " +
            "FROM Enrollment e " +
            "WHERE e.enrollmentDate >= :startDate AND e.course.price IS NOT NULL " +
            "GROUP BY YEAR(e.enrollmentDate), MONTH(e.enrollmentDate) " +
            "ORDER BY YEAR(e.enrollmentDate), MONTH(e.enrollmentDate)")
    List<Object[]> getRevenueStatsByMonth(@Param("startDate") LocalDateTime startDate);

    // ===== CATEGORY-BASED ANALYTICS =====

    /**
     * Lấy thống kê enrollments theo category
     * @return List array [category, enrollment_count]
     */
    @Query("SELECT e.course.category, COUNT(e) FROM Enrollment e " +
            "GROUP BY e.course.category ORDER BY COUNT(e) DESC")
    List<Object[]> getEnrollmentStatsByCategory();

    /**
     * Lấy completion rate theo category
     * @return List array [category, completion_rate]
     */
    @Query("SELECT e.course.category, " +
            "(COUNT(CASE WHEN e.completed = true THEN 1 END) * 100.0 / COUNT(e)) as completionRate " +
            "FROM Enrollment e " +
            "GROUP BY e.course.category " +
            "ORDER BY completionRate DESC")
    List<Object[]> getCompletionRateByCategory();

    // ===== STUDENT ACTIVITY QUERIES =====

    /**
     * Tìm students active (có enrollment gần đây)
     * @param since Thời điểm bắt đầu
     * @return Danh sách active students
     */
    @Query("SELECT DISTINCT e.student FROM Enrollment e WHERE e.enrollmentDate >= :since")
    List<User> findActiveStudentsSince(@Param("since") LocalDateTime since);

    /**
     * Tìm students chưa hoàn thành course nào
     * @return Danh sách students
     */
    @Query("SELECT DISTINCT e.student FROM Enrollment e WHERE e.student NOT IN " +
            "(SELECT e2.student FROM Enrollment e2 WHERE e2.completed = true)")
    List<User> findStudentsWithNoCompletions();

    /**
     * Đếm số courses đã hoàn thành của student
     * @param student Student
     * @return Số lượng completed courses
     */
    @Query("SELECT COUNT(e) FROM Enrollment e WHERE e.student = :student AND e.completed = true")
    Long countCompletedCoursesByStudent(@Param("student") User student);

    // ===== ENGAGEMENT METRICS =====

    /**
     * Lấy average time to completion theo course
     * @param course Course
     * @return Average days to complete
     */
    @Query("SELECT AVG(DATEDIFF(e.completionDate, e.enrollmentDate)) FROM Enrollment e " +
            "WHERE e.course = :course AND e.completed = true")
    Double getAverageTimeToCompletion(@Param("course") Course course);

    /**
     * Lấy retention rate (students still active after 30 days)
     * @param course Course
     * @return Retention rate percentage
     */
    @Query("SELECT " +
            "(COUNT(CASE WHEN e.progress > 0 OR e.completed = true THEN 1 END) * 100.0 / COUNT(e)) " +
            "FROM Enrollment e WHERE e.course = :course " +
            "AND e.enrollmentDate <= :thirtyDaysAgo")
    Double getRetentionRate(@Param("course") Course course, @Param("thirtyDaysAgo") LocalDateTime thirtyDaysAgo);

    // ===== SUMMARY STATISTICS =====

    /**
     * Lấy enrollment summary cho admin dashboard
     * @return Object array [totalEnrollments, completedEnrollments, averageProgress, activeStudents]
     */
    @Query("SELECT " +
            "COUNT(e), " +
            "SUM(CASE WHEN e.completed = true THEN 1 ELSE 0 END), " +
            "AVG(e.progress), " +
            "COUNT(DISTINCT e.student) " +
            "FROM Enrollment e")
    Object[] getEnrollmentSummary();

    /**
     * Lấy performance summary cho instructor
     * @param instructor Instructor
     * @return Object array [totalEnrollments, completions, averageProgress, activeStudents]
     */
    @Query("SELECT " +
            "COUNT(e), " +
            "SUM(CASE WHEN e.completed = true THEN 1 ELSE 0 END), " +
            "AVG(e.progress), " +
            "COUNT(DISTINCT e.student) " +
            "FROM Enrollment e WHERE e.course.instructor = :instructor")
    Object[] getInstructorPerformanceSummary(@Param("instructor") User instructor);
}