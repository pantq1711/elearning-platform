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
     * Kiểm tra học viên đã đăng ký khóa học chưa
     * @param student Học viên
     * @param course Khóa học
     * @return true nếu đã đăng ký, false nếu chưa
     */
    boolean existsByStudentAndCourse(User student, Course course);

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
     * Đếm số enrollment theo khóa học
     * @param course Khóa học
     * @return Số lượng enrollment
     */
    long countByCourse(Course course);

    /**
     * Đếm số enrollment theo học viên
     * @param student Học viên
     * @return Số lượng enrollment
     */
    long countByStudent(User student);

    /**
     * Đếm số enrollment theo học viên và trạng thái hoàn thành
     * @param student Học viên
     * @param isCompleted Trạng thái hoàn thành
     * @return Số lượng enrollment
     */
    long countByStudentAndIsCompleted(User student, boolean isCompleted);

    /**
     * Đếm số học viên theo giảng viên
     * @param instructor Giảng viên
     * @return Số lượng học viên
     */
    @Query("SELECT COUNT(DISTINCT e.student) FROM Enrollment e WHERE e.course.instructor = :instructor")
    long countStudentsByInstructor(@Param("instructor") User instructor);

    /**
     * Tìm enrollment theo giảng viên
     * @param instructor Giảng viên
     * @return Danh sách enrollment
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course.instructor = :instructor " +
            "ORDER BY e.enrolledAt DESC")
    List<Enrollment> findEnrollmentsByInstructor(@Param("instructor") User instructor);

    /**
     * Lấy enrollment gần đây nhất
     * @param limit Số lượng enrollment cần lấy
     * @return Danh sách enrollment gần đây
     */
    @Query("SELECT e FROM Enrollment e ORDER BY e.enrolledAt DESC LIMIT :limit")
    List<Enrollment> findTopByOrderByEnrolledAtDesc(@Param("limit") int limit);

    /**
     * Tìm enrollment theo khoảng thời gian đăng ký
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Danh sách enrollment trong khoảng thời gian
     */
    @Query("SELECT e FROM Enrollment e WHERE e.enrolledAt BETWEEN :startDate AND :endDate " +
            "ORDER BY e.enrolledAt DESC")
    List<Enrollment> findEnrollmentsByDateRange(@Param("startDate") LocalDateTime startDate,
                                                @Param("endDate") LocalDateTime endDate);

    /**
     * Lấy enrollment đã hoàn thành gần đây
     * @param limit Số lượng enrollment cần lấy
     * @return Danh sách enrollment đã hoàn thành gần đây
     */
    @Query("SELECT e FROM Enrollment e WHERE e.isCompleted = true " +
            "ORDER BY e.completedAt DESC LIMIT :limit")
    List<Enrollment> findRecentlyCompletedEnrollments(@Param("limit") int limit);

    /**
     * Tìm enrollment có điểm cao nhất
     * @param limit Số lượng enrollment cần lấy
     * @return Danh sách enrollment có điểm cao nhất
     */
    @Query("SELECT e FROM Enrollment e WHERE e.highestScore IS NOT NULL " +
            "ORDER BY e.highestScore DESC LIMIT :limit")
    List<Enrollment> findTopScoringEnrollments(@Param("limit") int limit);

    /**
     * Tính điểm trung bình của tất cả enrollment
     * @return Điểm trung bình
     */
    @Query("SELECT AVG(e.highestScore) FROM Enrollment e WHERE e.highestScore IS NOT NULL")
    Double calculateAverageScore();

    /**
     * Tính điểm trung bình của học viên
     * @param student Học viên
     * @return Điểm trung bình của học viên
     */
    @Query("SELECT AVG(e.highestScore) FROM Enrollment e WHERE e.student = :student " +
            "AND e.highestScore IS NOT NULL")
    Double calculateAverageScoreByStudent(@Param("student") User student);

    /**
     * Tính điểm trung bình của khóa học
     * @param course Khóa học
     * @return Điểm trung bình của khóa học
     */
    @Query("SELECT AVG(e.highestScore) FROM Enrollment e WHERE e.course = :course " +
            "AND e.highestScore IS NOT NULL")
    Double calculateAverageScoreByCourse(@Param("course") Course course);

    /**
     * Đếm số enrollment đã hoàn thành theo khóa học
     * @param course Khóa học
     * @return Số lượng enrollment đã hoàn thành
     */
    @Query("SELECT COUNT(e) FROM Enrollment e WHERE e.course = :course AND e.isCompleted = true")
    long countCompletedEnrollmentsByCourse(@Param("course") Course course);

    /**
     * Tính tỷ lệ hoàn thành của khóa học
     * @param course Khóa học
     * @return Tỷ lệ hoàn thành (0-1)
     */
    @Query("SELECT CASE WHEN COUNT(e) > 0 THEN " +
            "CAST(SUM(CASE WHEN e.isCompleted = true THEN 1 ELSE 0 END) AS DOUBLE) / COUNT(e) " +
            "ELSE 0 END FROM Enrollment e WHERE e.course = :course")
    Double calculateCompletionRateByCourse(@Param("course") Course course);

    /**
     * Tìm enrollment theo khóa học và trạng thái hoàn thành
     * @param course Khóa học
     * @param isCompleted Trạng thái hoàn thành
     * @return Danh sách enrollment
     */
    List<Enrollment> findByCourseAndIsCompleted(Course course, boolean isCompleted);

    /**
     * Lấy số lượng đăng ký mới trong tháng hiện tại
     * @return Số lượng đăng ký mới
     */
    @Query("SELECT COUNT(e) FROM Enrollment e WHERE " +
            "YEAR(e.enrolledAt) = YEAR(CURRENT_DATE) AND " +
            "MONTH(e.enrolledAt) = MONTH(CURRENT_DATE)")
    long countEnrollmentsThisMonth();

    /**
     * Lấy số lượng hoàn thành trong tháng hiện tại
     * @return Số lượng hoàn thành mới
     */
    @Query("SELECT COUNT(e) FROM Enrollment e WHERE e.isCompleted = true AND " +
            "YEAR(e.completedAt) = YEAR(CURRENT_DATE) AND " +
            "MONTH(e.completedAt) = MONTH(CURRENT_DATE)")
    long countCompletionsThisMonth();

    /**
     * Tìm enrollment theo danh mục khóa học
     * @param categoryId ID danh mục
     * @return Danh sách enrollment theo danh mục
     */
    @Query("SELECT e FROM Enrollment e WHERE e.course.category.id = :categoryId " +
            "ORDER BY e.enrolledAt DESC")
    List<Enrollment> findEnrollmentsByCategoryId(@Param("categoryId") Long categoryId);

    /**
     * Đếm số học viên duy nhất theo danh mục
     * @param categoryId ID danh mục
     * @return Số lượng học viên duy nhất
     */
    @Query("SELECT COUNT(DISTINCT e.student) FROM Enrollment e WHERE e.course.category.id = :categoryId")
    long countUniqueStudentsByCategoryId(@Param("categoryId") Long categoryId);

    /**
     * Tìm enrollment có điểm trong khoảng
     * @param minScore Điểm tối thiểu
     * @param maxScore Điểm tối đa
     * @return Danh sách enrollment trong khoảng điểm
     */
    @Query("SELECT e FROM Enrollment e WHERE e.highestScore BETWEEN :minScore AND :maxScore " +
            "ORDER BY e.highestScore DESC")
    List<Enrollment> findEnrollmentsByScoreRange(@Param("minScore") Double minScore,
                                                 @Param("maxScore") Double maxScore);

    /**
     * Lấy thống kê enrollment theo tháng
     * @param year Năm cần thống kê
     * @return Danh sách [Month, EnrollmentCount]
     */
    @Query("SELECT MONTH(e.enrolledAt), COUNT(e) FROM Enrollment e " +
            "WHERE YEAR(e.enrolledAt) = :year " +
            "GROUP BY MONTH(e.enrolledAt) " +
            "ORDER BY MONTH(e.enrolledAt)")
    List<Object[]> getEnrollmentStatisticsByMonth(@Param("year") int year);
}