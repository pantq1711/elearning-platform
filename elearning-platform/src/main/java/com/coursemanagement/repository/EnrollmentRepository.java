package com.coursemanagement.repository;

import com.coursemanagement.entity.Enrollment;
import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Repository interface để thao tác với bảng enrollments
 * Kế thừa JpaRepository để có sẵn các method CRUD cơ bản
 */
@Repository
public interface EnrollmentRepository extends JpaRepository<Enrollment, Long> {

    /**
     * Tìm đăng ký theo học viên và khóa học
     * @param student Học viên
     * @param course Khóa học
     * @return Optional<Enrollment> - có thể null nếu chưa đăng ký
     */
    Optional<Enrollment> findByStudentAndCourse(User student, Course course);

    /**
     * Tìm tất cả đăng ký của học viên
     * @param student Học viên
     * @return Danh sách đăng ký sắp xếp theo ngày đăng ký mới nhất
     */
    @Query("SELECT e FROM Enrollment e WHERE e.student = :student ORDER BY e.enrolledAt DESC")
    List<Enrollment> findByStudentOrderByEnrolledAtDesc(@Param("student") User student);

    /**
     * Tìm tất cả đăng ký của một khóa học
     * @param course Khóa học
     * @return Danh sách đăng ký sắp xếp theo ngày đăng ký
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course = :course ORDER BY e.enrolledAt ASC")
    List<Enrollment> findByCourseOrderByEnrolledAt(@Param("course") Course course);

    /**
     * Tìm đăng ký đã hoàn thành của học viên
     * @param student Học viên
     * @param isCompleted Trạng thái hoàn thành
     * @return Danh sách đăng ký đã hoàn thành
     */
    List<Enrollment> findByStudentAndIsCompleted(User student, boolean isCompleted);

    /**
     * Tìm đăng ký đang học của học viên (chưa hoàn thành)
     * @param student Học viên
     * @return Danh sách đăng ký đang học
     */
    @Query("SELECT e FROM Enrollment e WHERE e.student = :student AND e.isCompleted = false " +
            "ORDER BY e.enrolledAt DESC")
    List<Enrollment> findActiveEnrollmentsByStudent(@Param("student") User student);

    /**
     * Tìm đăng ký đã hoàn thành của học viên
     * @param student Học viên
     * @return Danh sách đăng ký đã hoàn thành
     */
    @Query("SELECT e FROM Enrollment e WHERE e.student = :student AND e.isCompleted = true " +
            "ORDER BY e.completedAt DESC")
    List<Enrollment> findCompletedEnrollmentsByStudent(@Param("student") User student);

    /**
     * Kiểm tra học viên đã đăng ký khóa học chưa
     * @param student Học viên
     * @param course Khóa học
     * @return true nếu đã đăng ký, false nếu chưa đăng ký
     */
    boolean existsByStudentAndCourse(User student, Course course);

    /**
     * Đếm số học viên đã đăng ký khóa học
     * @param course Khóa học
     * @return Số lượng học viên đăng ký
     */
    long countByCourse(Course course);

    /**
     * Đếm số khóa học học viên đã đăng ký
     * @param student Học viên
     * @return Số lượng khóa học đã đăng ký
     */
    long countByStudent(User student);

    /**
     * Đếm số khóa học học viên đã hoàn thành
     * @param student Học viên
     * @return Số lượng khóa học đã hoàn thành
     */
    long countByStudentAndIsCompleted(User student, boolean isCompleted);

    /**
     * Tìm học viên đăng ký gần đây nhất của khóa học
     * @param course Khóa học
     * @param limit Số lượng học viên cần lấy
     * @return Danh sách học viên đăng ký gần đây
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course = :course " +
            "ORDER BY e.enrolledAt DESC LIMIT :limit")
    List<Enrollment> findRecentEnrollmentsByCourse(@Param("course") Course course,
                                                   @Param("limit") int limit);

    /**
     * Tìm khóa học phổ biến nhất (có nhiều đăng ký nhất)
     * @param limit Số lượng khóa học cần lấy
     * @return Danh sách khóa học phổ biến
     */
    @Query("SELECT e.course, COUNT(e) as enrollmentCount FROM Enrollment e " +
            "GROUP BY e.course ORDER BY enrollmentCount DESC LIMIT :limit")
    List<Object[]> findMostPopularCourses(@Param("limit") int limit);

    /**
     * Tìm học viên tích cực nhất (đăng ký nhiều khóa học nhất)
     * @param limit Số lượng học viên cần lấy
     * @return Danh sách học viên tích cực
     */
    @Query("SELECT e.student, COUNT(e) as enrollmentCount FROM Enrollment e " +
            "GROUP BY e.student ORDER BY enrollmentCount DESC LIMIT :limit")
    List<Object[]> findMostActiveStudents(@Param("limit") int limit);

    /**
     * Tìm đăng ký trong khoảng thời gian
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Danh sách đăng ký trong khoảng thời gian
     */
    @Query("SELECT e FROM Enrollment e WHERE e.enrolledAt BETWEEN :startDate AND :endDate " +
            "ORDER BY e.enrolledAt DESC")
    List<Enrollment> findByEnrolledAtBetween(@Param("startDate") LocalDateTime startDate,
                                             @Param("endDate") LocalDateTime endDate);

    /**
     * Đếm số đăng ký trong khoảng thời gian
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Số lượng đăng ký
     */
    long countByEnrolledAtBetween(LocalDateTime startDate, LocalDateTime endDate);

    /**
     * Tìm học viên có điểm cao nhất trong khóa học
     * @param course Khóa học
     * @return Danh sách đăng ký sắp xếp theo điểm cao nhất
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course = :course AND e.highestScore IS NOT NULL " +
            "ORDER BY e.highestScore DESC")
    List<Enrollment> findByCourseOrderByHighestScoreDesc(@Param("course") Course course);

    /**
     * Lấy điểm trung bình của khóa học
     * @param course Khóa học
     * @return Điểm trung bình hoặc 0 nếu không có điểm
     */
    @Query("SELECT COALESCE(AVG(e.highestScore), 0) FROM Enrollment e " +
            "WHERE e.course = :course AND e.highestScore IS NOT NULL")
    Double getAverageScoreByCourse(@Param("course") Course course);

    /**
     * Tìm đăng ký theo khóa học của giảng viên
     * @param instructor Giảng viên
     * @return Danh sách đăng ký của tất cả khóa học do giảng viên tạo
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course.instructor = :instructor " +
            "ORDER BY e.enrolledAt DESC")
    List<Enrollment> findByInstructor(@Param("instructor") User instructor);

    /**
     * Đếm tổng số học viên của giảng viên
     * @param instructor Giảng viên
     * @return Tổng số học viên đăng ký khóa học của giảng viên
     */
    @Query("SELECT COUNT(e) FROM Enrollment e WHERE e.course.instructor = :instructor")
    long countStudentsByInstructor(@Param("instructor") User instructor);

    /**
     * Tìm khóa học học viên đã có điểm
     * @param student Học viên
     * @return Danh sách đăng ký có điểm
     */
    @Query("SELECT e FROM Enrollment e WHERE e.student = :student AND e.highestScore IS NOT NULL " +
            "ORDER BY e.highestScore DESC")
    List<Enrollment> findByStudentWithScores(@Param("student") User student);

    /**
     * Tìm học viên chưa có điểm trong khóa học
     * @param course Khóa học
     * @return Danh sách đăng ký chưa có điểm
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course = :course AND e.highestScore IS NULL " +
            "ORDER BY e.enrolledAt ASC")
    List<Enrollment> findByCourseWithoutScores(@Param("course") Course course);

    /**
     * Lấy thống kê đăng ký theo tháng
     * @param year Năm cần thống kê
     * @return Danh sách Object[] với format: [Month, Long enrollmentCount]
     */
    @Query("SELECT MONTH(e.enrolledAt) as month, COUNT(e) as enrollmentCount " +
            "FROM Enrollment e WHERE YEAR(e.enrolledAt) = :year " +
            "GROUP BY MONTH(e.enrolledAt) ORDER BY month")
    List<Object[]> getEnrollmentStatisticsByMonth(@Param("year") int year);

    /**
     * Tìm top học viên có điểm trung bình cao nhất
     * @param limit Số lượng học viên cần lấy
     * @return Danh sách học viên với điểm trung bình cao nhất
     */
    @Query("SELECT e.student, AVG(e.highestScore) as avgScore FROM Enrollment e " +
            "WHERE e.highestScore IS NOT NULL GROUP BY e.student " +
            "ORDER BY avgScore DESC LIMIT :limit")
    List<Object[]> findTopStudentsByAverageScore(@Param("limit") int limit);

    /**
     * Tính tỷ lệ hoàn thành khóa học
     * @param course Khóa học
     * @return Tỷ lệ hoàn thành (0-100)
     */
    @Query("SELECT (COUNT(CASE WHEN e.isCompleted = true THEN 1 END) * 100.0 / COUNT(e)) " +
            "FROM Enrollment e WHERE e.course = :course")
    Double getCompletionRateByCourse(@Param("course") Course course);
}