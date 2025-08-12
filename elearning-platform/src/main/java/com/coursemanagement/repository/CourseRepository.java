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
    @Query("SELECT c FROM Course c WHERE LOWER(c.name) LIKE LOWER(CONCAT('%', :keyword, '%')) AND c.isActive = true")
    List<Course> findByNameContainingIgnoreCase(@Param("keyword") String keyword);

    /**
     * Tìm khóa học theo tên hoặc mô tả có chứa từ khóa
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách khóa học chứa từ khóa trong tên hoặc mô tả
     */
    @Query("SELECT c FROM Course c WHERE (LOWER(c.name) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "OR LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND c.isActive = true")
    List<Course> findByNameOrDescriptionContaining(@Param("keyword") String keyword);

    /**
     * Lấy tất cả khóa học sắp xếp theo ngày tạo mới nhất
     * @return Danh sách khóa học sắp xếp theo ngày tạo
     */
    @Query("SELECT c FROM Course c WHERE c.isActive = true ORDER BY c.createdAt DESC")
    List<Course> findAllActiveOrderByCreatedAtDesc();

    /**
     * Lấy khóa học phổ biến nhất (có nhiều học viên đăng ký nhất)
     * @return Danh sách khóa học sắp xếp theo số lượng đăng ký giảm dần
     */
    @Query("SELECT c FROM Course c LEFT JOIN c.enrollments e WHERE c.isActive = true " +
            "GROUP BY c.id ORDER BY COUNT(e) DESC")
    List<Course> findPopularCourses();

    /**
     * Lấy top N khóa học phổ biến nhất
     * @param limit Số lượng khóa học cần lấy
     * @return Danh sách top khóa học phổ biến
     */
    @Query("SELECT c FROM Course c LEFT JOIN c.enrollments e WHERE c.isActive = true " +
            "GROUP BY c.id ORDER BY COUNT(e) DESC LIMIT :limit")
    List<Course> findTopPopularCourses(@Param("limit") int limit);

    /**
     * Đếm số học viên đã đăng ký khóa học
     * @param courseId ID của khóa học
     * @return Số lượng học viên đăng ký
     */
    @Query("SELECT COUNT(e) FROM Enrollment e WHERE e.course.id = :courseId")
    long countEnrollmentsByCourseId(@Param("courseId") Long courseId);

    /**
     * Đếm số bài giảng trong khóa học
     * @param courseId ID của khóa học
     * @return Số lượng bài giảng
     */
    @Query("SELECT COUNT(l) FROM Lesson l WHERE l.course.id = :courseId AND l.isActive = true")
    long countLessonsByCourseId(@Param("courseId") Long courseId);

    /**
     * Đếm số bài kiểm tra trong khóa học
     * @param courseId ID của khóa học
     * @return Số lượng bài kiểm tra
     */
    @Query("SELECT COUNT(q) FROM Quiz q WHERE q.course.id = :courseId AND q.isActive = true")
    long countQuizzesByCourseId(@Param("courseId") Long courseId);

    /**
     * Tìm khóa học mà học viên đã đăng ký
     * @param studentId ID của học viên
     * @return Danh sách khóa học đã đăng ký
     */
    @Query("SELECT c FROM Course c INNER JOIN c.enrollments e WHERE e.student.id = :studentId AND c.isActive = true")
    List<Course> findEnrolledCoursesByStudentId(@Param("studentId") Long studentId);

    /**
     * Tìm khóa học mà học viên chưa đăng ký
     * @param studentId ID của học viên
     * @return Danh sách khóa học chưa đăng ký
     */
    @Query("SELECT c FROM Course c WHERE c.isActive = true AND c.id NOT IN " +
            "(SELECT e.course.id FROM Enrollment e WHERE e.student.id = :studentId)")
    List<Course> findAvailableCoursesForStudent(@Param("studentId") Long studentId);

    /**
     * Kiểm tra học viên đã đăng ký khóa học chưa
     * @param courseId ID của khóa học
     * @param studentId ID của học viên
     * @return true nếu đã đăng ký, false nếu chưa đăng ký
     */
    @Query("SELECT CASE WHEN COUNT(e) > 0 THEN true ELSE false END FROM Enrollment e " +
            "WHERE e.course.id = :courseId AND e.student.id = :studentId")
    boolean isStudentEnrolled(@Param("courseId") Long courseId, @Param("studentId") Long studentId);

    /**
     * Tìm khóa học theo ID và giảng viên (để đảm bảo quyền truy cập)
     * @param id ID của khóa học
     * @param instructor Giảng viên
     * @return Optional<Course>
     */
    Optional<Course> findByIdAndInstructor(Long id, User instructor);

    /**
     * Kiểm tra khóa học có thể xóa được không
     * Chỉ có thể xóa khi chưa có học viên nào đăng ký
     * @param courseId ID của khóa học
     * @return true nếu có thể xóa, false nếu không thể xóa
     */
    @Query("SELECT CASE WHEN COUNT(e) = 0 THEN true ELSE false END FROM Enrollment e WHERE e.course.id = :courseId")
    boolean canDeleteCourse(@Param("courseId") Long courseId);

    /**
     * Lấy khóa học mới nhất của giảng viên
     * @param instructorId ID của giảng viên
     * @param limit Số lượng khóa học cần lấy
     * @return Danh sách khóa học mới nhất
     */
    @Query("SELECT c FROM Course c WHERE c.instructor.id = :instructorId " +
            "ORDER BY c.createdAt DESC LIMIT :limit")
    List<Course> findLatestCoursesByInstructor(@Param("instructorId") Long instructorId,
                                               @Param("limit") int limit);

    /**
     * Lấy thống kê khóa học theo danh mục
     * Trả về danh sách Object[] với format: [Category, Long courseCount]
     * @return Danh sách thống kê
     */
    @Query("SELECT c.category, COUNT(c) as courseCount FROM Course c WHERE c.isActive = true " +
            "GROUP BY c.category ORDER BY courseCount DESC")
    List<Object[]> getCourseStatisticsByCategory();

    /**
     * Lấy thống kê khóa học theo giảng viên
     * Trả về danh sách Object[] với format: [User, Long courseCount]
     * @return Danh sách thống kê
     */
    @Query("SELECT c.instructor, COUNT(c) as courseCount FROM Course c WHERE c.isActive = true " +
            "GROUP BY c.instructor ORDER BY courseCount DESC")
    List<Object[]> getCourseStatisticsByInstructor();

    /**
     * Tìm khóa học có nhiều bài giảng nhất
     * @param limit Số lượng khóa học cần lấy
     * @return Danh sách khóa học có nhiều bài giảng nhất
     */
    @Query("SELECT c FROM Course c LEFT JOIN c.lessons l WHERE c.isActive = true " +
            "GROUP BY c.id ORDER BY COUNT(l) DESC LIMIT :limit")
    List<Course> findCoursesWithMostLessons(@Param("limit") int limit);

    /**
     * Đếm tổng số khóa học theo trạng thái
     * @param isActive Trạng thái hoạt động
     * @return Số lượng khóa học
     */
    long countByIsActive(boolean isActive);

    /**
     * Đếm số khóa học của giảng viên
     * @param instructor Giảng viên
     * @return Số lượng khóa học
     */
    long countByInstructor(User instructor);
}