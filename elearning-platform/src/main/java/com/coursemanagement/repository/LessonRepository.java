package com.coursemanagement.repository;

import com.coursemanagement.entity.Lesson;
import com.coursemanagement.entity.Course;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Repository interface để thao tác với bảng lessons
 * Kế thừa JpaRepository để có sẵn các method CRUD cơ bản
 */
@Repository
public interface LessonRepository extends JpaRepository<Lesson, Long> {

    /**
     * Tìm tất cả bài giảng theo khóa học, sắp xếp theo thứ tự
     * @param course Khóa học
     * @return Danh sách bài giảng sắp xếp theo order_index
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course ORDER BY l.orderIndex ASC")
    List<Lesson> findByCourseOrderByOrderIndexAsc(@Param("course") Course course);

    /**
     * Tìm bài giảng đang hoạt động theo khóa học
     * @param course Khóa học
     * @param isActive Trạng thái hoạt động
     * @return Danh sách bài giảng đang hoạt động
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.isActive = :isActive " +
            "ORDER BY l.orderIndex ASC")
    List<Lesson> findByCourseAndIsActiveOrderByOrderIndexAsc(@Param("course") Course course,
                                                             @Param("isActive") boolean isActive);

    /**
     * Tìm bài giảng theo ID và khóa học (để đảm bảo quyền truy cập)
     * @param id ID của bài giảng
     * @param course Khóa học
     * @return Optional<Lesson>
     */
    Optional<Lesson> findByIdAndCourse(Long id, Course course);

    /**
     * Tìm bài giảng theo tiêu đề có chứa từ khóa
     * @param course Khóa học
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách bài giảng chứa từ khóa
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course " +
            "AND LOWER(l.title) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "ORDER BY l.orderIndex ASC")
    List<Lesson> findByCourseAndTitleContainingIgnoreCaseOrderByOrderIndexAsc(@Param("course") Course course,
                                                                              @Param("keyword") String keyword);

    /**
     * Đếm số bài giảng theo khóa học
     * @param course Khóa học
     * @return Số lượng bài giảng
     */
    long countByCourse(Course course);

    /**
     * Đếm số bài giảng đang hoạt động theo khóa học
     * @param course Khóa học
     * @param isActive Trạng thái hoạt động
     * @return Số lượng bài giảng đang hoạt động
     */
    long countByCourseAndIsActive(Course course, boolean isActive);

    /**
     * Tìm bài giảng tiếp theo
     * @param course Khóa học
     * @param currentOrderIndex Thứ tự hiện tại
     * @return Optional<Lesson>
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course " +
            "AND l.orderIndex > :currentOrderIndex AND l.isActive = true " +
            "ORDER BY l.orderIndex ASC LIMIT 1")
    Optional<Lesson> findNextLesson(@Param("course") Course course,
                                    @Param("currentOrderIndex") Integer currentOrderIndex);

    /**
     * Tìm bài giảng trước đó
     * @param course Khóa học
     * @param currentOrderIndex Thứ tự hiện tại
     * @return Optional<Lesson>
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course " +
            "AND l.orderIndex < :currentOrderIndex AND l.isActive = true " +
            "ORDER BY l.orderIndex DESC LIMIT 1")
    Optional<Lesson> findPreviousLesson(@Param("course") Course course,
                                        @Param("currentOrderIndex") Integer currentOrderIndex);

    /**
     * Lấy order index lớn nhất của khóa học
     * @param course Khóa học
     * @return Order index lớn nhất
     */
    @Query("SELECT MAX(l.orderIndex) FROM Lesson l WHERE l.course = :course")
    Integer findMaxOrderIndexByCourse(@Param("course") Course course);

    /**
     * Tìm bài giảng theo thứ tự trong khóa học
     * @param course Khóa học
     * @param orderIndex Thứ tự
     * @return Optional<Lesson>
     */
    Optional<Lesson> findByCourseAndOrderIndex(Course course, Integer orderIndex);

    /**
     * Tìm bài giảng có video theo khóa học
     * @param course Khóa học
     * @return Danh sách bài giảng có video
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course " +
            "AND l.videoLink IS NOT NULL AND l.videoLink != '' " +
            "AND l.isActive = true ORDER BY l.orderIndex ASC")
    List<Lesson> findLessonsWithVideoByCourse(@Param("course") Course course);

    /**
     * Tìm bài giảng không có video theo khóa học
     * @param course Khóa học
     * @return Danh sách bài giảng không có video
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course " +
            "AND (l.videoLink IS NULL OR l.videoLink = '') " +
            "AND l.isActive = true ORDER BY l.orderIndex ASC")
    List<Lesson> findLessonsWithoutVideoByCourse(@Param("course") Course course);

    /**
     * Tìm bài giảng theo giảng viên
     * @param instructorId ID giảng viên
     * @return Danh sách bài giảng của giảng viên
     */
    @Query("SELECT l FROM Lesson l WHERE l.course.instructor.id = :instructorId " +
            "ORDER BY l.course.name, l.orderIndex ASC")
    List<Lesson> findByInstructorId(@Param("instructorId") Long instructorId);

    /**
     * Đếm tổng số bài giảng của giảng viên
     * @param instructorId ID giảng viên
     * @return Số lượng bài giảng
     */
    @Query("SELECT COUNT(l) FROM Lesson l WHERE l.course.instructor.id = :instructorId")
    long countByInstructorId(@Param("instructorId") Long instructorId);

    /**
     * Đếm số bài giảng đang hoạt động của giảng viên
     * @param instructorId ID giảng viên
     * @return Số lượng bài giảng đang hoạt động
     */
    @Query("SELECT COUNT(l) FROM Lesson l WHERE l.course.instructor.id = :instructorId " +
            "AND l.isActive = true")
    long countActiveLessonsByInstructorId(@Param("instructorId") Long instructorId);

    /**
     * Tìm bài giảng được tạo gần đây nhất
     * @param limit Số lượng bài giảng cần lấy
     * @return Danh sách bài giảng mới nhất
     */
    @Query("SELECT l FROM Lesson l ORDER BY l.createdAt DESC LIMIT :limit")
    List<Lesson> findTopByOrderByCreatedAtDesc(@Param("limit") int limit);

    /**
     * Tìm bài giảng theo khoảng thời gian tạo
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Danh sách bài giảng trong khoảng thời gian
     */
    @Query("SELECT l FROM Lesson l WHERE l.createdAt BETWEEN :startDate AND :endDate " +
            "ORDER BY l.createdAt DESC")
    List<Lesson> findLessonsByDateRange(@Param("startDate") LocalDateTime startDate,
                                        @Param("endDate") LocalDateTime endDate);

    /**
     * Tìm bài giảng theo danh mục khóa học
     * @param categoryId ID danh mục
     * @return Danh sách bài giảng theo danh mục
     */
    @Query("SELECT l FROM Lesson l WHERE l.course.category.id = :categoryId " +
            "AND l.isActive = true ORDER BY l.course.name, l.orderIndex ASC")
    List<Lesson> findLessonsByCategoryId(@Param("categoryId") Long categoryId);

    /**
     * Đếm số bài giảng theo danh mục
     * @param categoryId ID danh mục
     * @return Số lượng bài giảng
     */
    @Query("SELECT COUNT(l) FROM Lesson l WHERE l.course.category.id = :categoryId")
    long countLessonsByCategoryId(@Param("categoryId") Long categoryId);

    /**
     * Tìm bài giảng theo nội dung có chứa từ khóa
     * @param course Khóa học
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách bài giảng có nội dung chứa từ khóa
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course " +
            "AND LOWER(l.content) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "ORDER BY l.orderIndex ASC")
    List<Lesson> findByCourseAndContentContaining(@Param("course") Course course,
                                                  @Param("keyword") String keyword);

    /**
     * Tìm bài giảng theo độ dài nội dung
     * @param course Khóa học
     * @param minLength Độ dài tối thiểu
     * @param maxLength Độ dài tối đa
     * @return Danh sách bài giảng trong khoảng độ dài
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course " +
            "AND LENGTH(l.content) BETWEEN :minLength AND :maxLength " +
            "ORDER BY l.orderIndex ASC")
    List<Lesson> findLessonsByContentLength(@Param("course") Course course,
                                            @Param("minLength") int minLength,
                                            @Param("maxLength") int maxLength);

    /**
     * Lấy số lượng bài giảng được tạo trong tháng hiện tại
     * @return Số lượng bài giảng mới
     */
    @Query("SELECT COUNT(l) FROM Lesson l WHERE " +
            "YEAR(l.createdAt) = YEAR(CURRENT_DATE) AND " +
            "MONTH(l.createdAt) = MONTH(CURRENT_DATE)")
    long countLessonsCreatedThisMonth();

    /**
     * Lấy thống kê bài giảng theo tháng
     * @param year Năm cần thống kê
     * @return Danh sách [Month, LessonCount]
     */
    @Query("SELECT MONTH(l.createdAt), COUNT(l) FROM Lesson l " +
            "WHERE YEAR(l.createdAt) = :year " +
            "GROUP BY MONTH(l.createdAt) " +
            "ORDER BY MONTH(l.createdAt)")
    List<Object[]> getLessonStatisticsByMonth(@Param("year") int year);

    /**
     * Tìm bài giảng đầu tiên của khóa học
     * @param course Khóa học
     * @return Optional<Lesson>
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.isActive = true " +
            "ORDER BY l.orderIndex ASC LIMIT 1")
    Optional<Lesson> findFirstLessonByCourse(@Param("course") Course course);

    /**
     * Tìm bài giảng cuối cùng của khóa học
     * @param course Khóa học
     * @return Optional<Lesson>
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.isActive = true " +
            "ORDER BY l.orderIndex DESC LIMIT 1")
    Optional<Lesson> findLastLessonByCourse(@Param("course") Course course);

    /**
     * Kiểm tra thứ tự bài giảng có tồn tại trong khóa học không
     * @param course Khóa học
     * @param orderIndex Thứ tự cần kiểm tra
     * @param excludeId ID bài giảng cần loại trừ (khi update)
     * @return true nếu thứ tự đã tồn tại
     */
    @Query("SELECT CASE WHEN COUNT(l) > 0 THEN true ELSE false END " +
            "FROM Lesson l WHERE l.course = :course AND l.orderIndex = :orderIndex " +
            "AND (:excludeId IS NULL OR l.id != :excludeId)")
    boolean existsOrderIndexInCourse(@Param("course") Course course,
                                     @Param("orderIndex") Integer orderIndex,
                                     @Param("excludeId") Long excludeId);

    /**
     * Tìm các thứ tự bị trùng trong khóa học
     * @param course Khóa học
     * @return Danh sách thứ tự bị trùng
     */
    @Query("SELECT l.orderIndex FROM Lesson l WHERE l.course = :course " +
            "GROUP BY l.orderIndex HAVING COUNT(l.orderIndex) > 1")
    List<Integer> findDuplicateOrderIndexes(@Param("course") Course course);

    /**
     * Tìm bài giảng có link YouTube không hợp lệ
     * @return Danh sách bài giảng có link YouTube lỗi
     */
    @Query("SELECT l FROM Lesson l WHERE l.videoLink IS NOT NULL " +
            "AND l.videoLink != '' " +
            "AND l.videoLink NOT LIKE '%youtube.com%' " +
            "AND l.videoLink NOT LIKE '%youtu.be%'")
    List<Lesson> findLessonsWithInvalidYouTubeLinks();

    /**
     * Đếm số bài giảng có video của giảng viên
     * @param instructorId ID giảng viên
     * @return Số lượng bài giảng có video
     */
    @Query("SELECT COUNT(l) FROM Lesson l WHERE l.course.instructor.id = :instructorId " +
            "AND l.videoLink IS NOT NULL AND l.videoLink != ''")
    long countLessonsWithVideoByInstructorId(@Param("instructorId") Long instructorId);

    /**
     * Tìm khóa học có nhiều bài giảng nhất
     * @param limit Số lượng khóa học cần lấy
     * @return Danh sách khóa học có nhiều bài giảng
     */
    @Query("SELECT l.course FROM Lesson l " +
            "WHERE l.isActive = true " +
            "GROUP BY l.course " +
            "ORDER BY COUNT(l) DESC " +
            "LIMIT :limit")
    List<Course> findCoursesWithMostLessons(@Param("limit") int limit);
}