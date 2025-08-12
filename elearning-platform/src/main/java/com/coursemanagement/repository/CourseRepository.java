package com.coursemanagement.repository;

import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.User;
import com.coursemanagement.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository interface để thao tác với bảng courses
 * Kế thừa JpaRepository để có sẵn các method CRUD cơ bản
 */
@Repository
public interface CourseRepository extends JpaRepository<Course, Long> {

    /**
     * Tìm tất cả khóa học đang hoạt động
     * @param isActive Trạng thái hoạt động
     * @return Danh sách khóa học đang hoạt động
     */
    List<Course> findByIsActive(boolean isActive);

    /**
     * Tìm khóa học theo giảng viên
     * @param instructor Giảng viên
     * @return Danh sách khóa học của giảng viên đó
     */
    List<Course> findByInstructor(User instructor);

    /**
     * Tìm khóa học theo giảng viên và trạng thái hoạt động
     * @param instructor Giảng viên
     * @param isActive Trạng thái hoạt động
     * @return Danh sách khóa học của giảng viên đang hoạt động
     */
    List<Course> findByInstructorAndIsActive(User instructor, boolean isActive);

    /**
     * Tìm khóa học theo danh mục
     * @param category Danh mục khóa học
     * @return Danh sách khóa học trong danh mục
     */
    List<Course> findByCategory(Category category);

    /**
     * Tìm khóa học theo danh mục và trạng thái hoạt động
     * @param category Danh mục khóa học
     * @param isActive Trạng thái hoạt động
     * @return Danh sách khóa học trong danh mục đang hoạt động
     */
    List<Course> findByCategoryAndIsActive(Category category, boolean isActive);

    /**
     * Tìm khóa học theo tên có chứa từ khóa (không phân biệt hoa thường)
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách khóa học chứa từ khóa
     */
    @Query("SELECT c FROM Course c WHERE LOWER(c.name) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "AND c.isActive = true ORDER BY c.name ASC")
    List<Course> findByNameContainingIgnoreCase(@Param("keyword") String keyword);

    /**
     * Tìm khóa học theo tên có chứa từ khóa và trạng thái hoạt động
     * @param keyword Từ khóa tìm kiếm
     * @param isActive Trạng thái hoạt động
     * @return Danh sách khóa học chứa từ khóa và đang hoạt động
     */
    @Query("SELECT c FROM Course c WHERE LOWER(c.name) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "AND c.isActive = :isActive ORDER BY c.name ASC")
    List<Course> findByNameContainingIgnoreCaseAndIsActive(@Param("keyword") String keyword,
                                                           @Param("isActive") boolean isActive);

    /**
     * Đếm số khóa học theo trạng thái
     * @param isActive Trạng thái hoạt động
     * @return Số lượng khóa học
     */
    long countByIsActive(boolean isActive);

    /**
     * Đếm số khóa học theo danh mục
     * @param category Danh mục
     * @return Số lượng khóa học
     */
    long countByCategory(Category category);

    /**
     * Đếm số khóa học theo giảng viên
     * @param instructor Giảng viên
     * @return Số lượng khóa học
     */
    long countByInstructor(User instructor);

    /**
     * Lấy khóa học phổ biến nhất theo số lượng đăng ký
     * @param limit Số lượng khóa học cần lấy
     * @return Danh sách khóa học phổ biến
     */
    @Query("SELECT c FROM Course c " +
            "LEFT JOIN c.enrollments e " +
            "WHERE c.isActive = true " +
            "GROUP BY c " +
            "ORDER BY COUNT(e) DESC " +
            "LIMIT :limit")
    List<Course> findTopPopularCourses(@Param("limit") int limit);

    /**
     * Lấy thống kê số khóa học theo danh mục
     * @return Danh sách [CategoryName, CourseCount]
     */
    @Query("SELECT cat.name, COUNT(c) FROM Course c " +
            "RIGHT JOIN c.category cat " +
            "GROUP BY cat.name " +
            "ORDER BY COUNT(c) DESC")
    List<Object[]> getCourseCountByCategory();

    /**
     * Tìm khóa học mới nhất của giảng viên
     * @param instructorId ID giảng viên
     * @param limit Số lượng khóa học cần lấy
     * @return Danh sách khóa học mới nhất
     */
    @Query("SELECT c FROM Course c WHERE c.instructor.id = :instructorId " +
            "ORDER BY c.createdAt DESC " +
            "LIMIT :limit")
    List<Course> findLatestCoursesByInstructor(@Param("instructorId") Long instructorId,
                                               @Param("limit") int limit);

    /**
     * Tìm khóa học có thể đăng ký cho học viên
     * @param studentId ID học viên
     * @return Danh sách khóa học có thể đăng ký
     */
    @Query("SELECT c FROM Course c WHERE c.isActive = true " +
            "AND c.id NOT IN (SELECT e.course.id FROM Enrollment e WHERE e.student.id = :studentId) " +
            "ORDER BY c.createdAt DESC")
    List<Course> findAvailableCoursesForStudent(@Param("studentId") Long studentId);

    /**
     * Tìm khóa học theo mô tả có chứa từ khóa
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách khóa học có mô tả chứa từ khóa
     */
    @Query("SELECT c FROM Course c WHERE LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "AND c.isActive = true ORDER BY c.name ASC")
    List<Course> findByDescriptionContainingIgnoreCase(@Param("keyword") String keyword);

    /**
     * Tìm khóa học theo tên hoặc mô tả có chứa từ khóa
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách khóa học chứa từ khóa trong tên hoặc mô tả
     */
    @Query("SELECT c FROM Course c WHERE " +
            "(LOWER(c.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
            "AND c.isActive = true ORDER BY c.name ASC")
    List<Course> searchCourses(@Param("keyword") String keyword);

    /**
     * Lấy khóa học được tạo gần đây nhất
     * @param limit Số lượng khóa học cần lấy
     * @return Danh sách khóa học mới nhất
     */
    @Query("SELECT c FROM Course c WHERE c.isActive = true " +
            "ORDER BY c.createdAt DESC " +
            "LIMIT :limit")
    List<Course> findRecentCourses(@Param("limit") int limit);

    /**
     * Tìm khóa học có nhiều bài giảng nhất
     * @param limit Số lượng khóa học cần lấy
     * @return Danh sách khóa học có nhiều bài giảng
     */
    @Query("SELECT c FROM Course c " +
            "LEFT JOIN c.lessons l " +
            "WHERE c.isActive = true " +
            "GROUP BY c " +
            "ORDER BY COUNT(l) DESC " +
            "LIMIT :limit")
    List<Course> findCoursesWithMostLessons(@Param("limit") int limit);

    /**
     * Tìm khóa học có nhiều quiz nhất
     * @param limit Số lượng khóa học cần lấy
     * @return Danh sách khóa học có nhiều quiz
     */
    @Query("SELECT c FROM Course c " +
            "LEFT JOIN c.quizzes q " +
            "WHERE c.isActive = true " +
            "GROUP BY c " +
            "ORDER BY COUNT(q) DESC " +
            "LIMIT :limit")
    List<Course> findCoursesWithMostQuizzes(@Param("limit") int limit);

    /**
     * Đếm tổng số học viên của giảng viên
     * @param instructor Giảng viên
     * @return Tổng số học viên
     */
    @Query("SELECT COUNT(DISTINCT e.student) FROM Course c " +
            "LEFT JOIN c.enrollments e " +
            "WHERE c.instructor = :instructor")
    long countTotalStudentsByInstructor(@Param("instructor") User instructor);

    /**
     * Tìm khóa học theo khoảng thời gian tạo
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Danh sách khóa học trong khoảng thời gian
     */
    @Query("SELECT c FROM Course c WHERE c.createdAt BETWEEN :startDate AND :endDate " +
            "ORDER BY c.createdAt DESC")
    List<Course> findCoursesByDateRange(@Param("startDate") java.time.LocalDateTime startDate,
                                        @Param("endDate") java.time.LocalDateTime endDate);

    /**
     * Kiểm tra khóa học có thể xóa không
     * @param courseId ID khóa học
     * @return true nếu có thể xóa (không có enrollment)
     */
    @Query("SELECT CASE WHEN COUNT(e) = 0 THEN true ELSE false END " +
            "FROM Course c LEFT JOIN c.enrollments e WHERE c.id = :courseId")
    boolean canCourseBeDeleted(@Param("courseId") Long courseId);
}