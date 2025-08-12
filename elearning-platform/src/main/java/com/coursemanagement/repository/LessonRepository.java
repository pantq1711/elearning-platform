package com.coursemanagement.repository;

import com.coursemanagement.entity.Lesson;
import com.coursemanagement.entity.Course;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository interface để thao tác với bảng lessons
 * Kế thừa JpaRepository để có sẵn các method CRUD cơ bản
 */
@Repository
public interface LessonRepository extends JpaRepository<Lesson, Long> {

    /**
     * Tìm tất cả bài giảng theo khóa học
     * @param course Khóa học
     * @return Danh sách bài giảng sắp xếp theo orderIndex
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course ORDER BY l.orderIndex ASC, l.id ASC")
    List<Lesson> findByCourseOrderByOrderIndex(@Param("course") Course course);

    /**
     * Tìm tất cả bài giảng đang hoạt động theo khóa học
     * @param course Khóa học
     * @param isActive Trạng thái hoạt động
     * @return Danh sách bài giảng đang hoạt động
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.isActive = :isActive " +
            "ORDER BY l.orderIndex ASC, l.id ASC")
    List<Lesson> findByCourseAndIsActiveOrderByOrderIndex(@Param("course") Course course,
                                                          @Param("isActive") boolean isActive);

    /**
     * Tìm bài giảng theo ID khóa học
     * @param courseId ID của khóa học
     * @return Danh sách bài giảng
     */
    @Query("SELECT l FROM Lesson l WHERE l.course.id = :courseId AND l.isActive = true " +
            "ORDER BY l.orderIndex ASC, l.id ASC")
    List<Lesson> findByCourseIdAndActiveOrderByOrderIndex(@Param("courseId") Long courseId);

    /**
     * Tìm bài giảng theo ID và khóa học (để đảm bảo quyền truy cập)
     * @param id ID của bài giảng
     * @param course Khóa học
     * @return Optional<Lesson>
     */
    Optional<Lesson> findByIdAndCourse(Long id, Course course);

    /**
     * Tìm bài giảng có video YouTube
     * @param course Khóa học
     * @return Danh sách bài giảng có video
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.videoLink IS NOT NULL " +
            "AND l.videoLink != '' AND l.isActive = true ORDER BY l.orderIndex ASC")
    List<Lesson> findByCourseWithVideo(@Param("course") Course course);

    /**
     * Tìm bài giảng chỉ có text (không có video)
     * @param course Khóa học
     * @return Danh sách bài giảng chỉ có text
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND (l.videoLink IS NULL OR l.videoLink = '') " +
            "AND l.isActive = true ORDER BY l.orderIndex ASC")
    List<Lesson> findByCourseWithoutVideo(@Param("course") Course course);

    /**
     * Tìm bài giảng theo tiêu đề có chứa từ khóa
     * @param courseId ID của khóa học
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách bài giảng chứa từ khóa
     */
    @Query("SELECT l FROM Lesson l WHERE l.course.id = :courseId AND l.isActive = true " +
            "AND LOWER(l.title) LIKE LOWER(CONCAT('%', :keyword, '%')) ORDER BY l.orderIndex ASC")
    List<Lesson> findByCourseIdAndTitleContaining(@Param("courseId") Long courseId,
                                                  @Param("keyword") String keyword);

    /**
     * Đếm số bài giảng trong khóa học
     * @param course Khóa học
     * @return Số lượng bài giảng
     */
    long countByCourse(Course course);

    /**
     * Đếm số bài giảng đang hoạt động trong khóa học
     * @param course Khóa học
     * @param isActive Trạng thái hoạt động
     * @return Số lượng bài giảng đang hoạt động
     */
    long countByCourseAndIsActive(Course course, boolean isActive);

    /**
     * Lấy orderIndex lớn nhất trong khóa học
     * Dùng để tính orderIndex cho bài giảng mới
     * @param course Khóa học
     * @return OrderIndex lớn nhất, hoặc 0 nếu chưa có bài giảng nào
     */
    @Query("SELECT COALESCE(MAX(l.orderIndex), 0) FROM Lesson l WHERE l.course = :course")
    Integer findMaxOrderIndexByCourse(@Param("course") Course course);

    /**
     * Tìm bài giảng đầu tiên trong khóa học
     * @param course Khóa học
     * @return Optional<Lesson> - bài giảng đầu tiên
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.isActive = true " +
            "ORDER BY l.orderIndex ASC, l.id ASC LIMIT 1")
    Optional<Lesson> findFirstLessonByCourse(@Param("course") Course course);

    /**
     * Tìm bài giảng cuối cùng trong khóa học
     * @param course Khóa học
     * @return Optional<Lesson> - bài giảng cuối cùng
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.isActive = true " +
            "ORDER BY l.orderIndex DESC, l.id DESC LIMIT 1")
    Optional<Lesson> findLastLessonByCourse(@Param("course") Course course);

    /**
     * Tìm bài giảng tiếp theo
     * @param course Khóa học
     * @param currentOrderIndex OrderIndex hiện tại
     * @return Optional<Lesson> - bài giảng tiếp theo
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.isActive = true " +
            "AND l.orderIndex > :currentOrderIndex ORDER BY l.orderIndex ASC LIMIT 1")
    Optional<Lesson> findNextLesson(@Param("course") Course course,
                                    @Param("currentOrderIndex") Integer currentOrderIndex);

    /**
     * Tìm bài giảng trước đó
     * @param course Khóa học
     * @param currentOrderIndex OrderIndex hiện tại
     * @return Optional<Lesson> - bài giảng trước đó
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.isActive = true " +
            "AND l.orderIndex < :currentOrderIndex ORDER BY l.orderIndex DESC LIMIT 1")
    Optional<Lesson> findPreviousLesson(@Param("course") Course course,
                                        @Param("currentOrderIndex") Integer currentOrderIndex);

    /**
     * Tìm các bài giảng có orderIndex trùng lặp trong khóa học
     * @param course Khóa học
     * @return Danh sách bài giảng có orderIndex trùng lặp
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.orderIndex IN " +
            "(SELECT l2.orderIndex FROM Lesson l2 WHERE l2.course = :course " +
            "GROUP BY l2.orderIndex HAVING COUNT(l2.orderIndex) > 1)")
    List<Lesson> findDuplicateOrderIndexByCourse(@Param("course") Course course);

    /**
     * Cập nhật orderIndex cho các bài giảng từ vị trí start trở về sau
     * @param course Khóa học
     * @param startOrderIndex Vị trí bắt đầu
     * @param increment Số lượng tăng thêm
     */
    @Query("UPDATE Lesson l SET l.orderIndex = l.orderIndex + :increment " +
            "WHERE l.course = :course AND l.orderIndex >= :startOrderIndex")
    void updateOrderIndexFromPosition(@Param("course") Course course,
                                      @Param("startOrderIndex") Integer startOrderIndex,
                                      @Param("increment") Integer increment);

    /**
     * Kiểm tra bài giảng có thể xóa được không
     * Luôn có thể xóa bài giảng (không có ràng buộc đặc biệt)
     * @param lessonId ID của bài giảng
     * @return true - luôn có thể xóa
     */
    @Query("SELECT true FROM Lesson l WHERE l.id = :lessonId")
    boolean canDeleteLesson(@Param("lessonId") Long lessonId);

    /**
     * Tìm bài giảng theo danh sách ID
     * @param ids Danh sách ID bài giảng
     * @return Danh sách bài giảng
     */
    @Query("SELECT l FROM Lesson l WHERE l.id IN :ids ORDER BY l.orderIndex ASC")
    List<Lesson> findByIdIn(@Param("ids") List<Long> ids);

    /**
     * Đếm số bài giảng có video theo khóa học
     * @param course Khóa học
     * @return Số lượng bài giảng có video
     */
    @Query("SELECT COUNT(l) FROM Lesson l WHERE l.course = :course AND l.isActive = true " +
            "AND l.videoLink IS NOT NULL AND l.videoLink != ''")
    long countLessonsWithVideoByCourse(@Param("course") Course course);

    /**
     * Đếm số bài giảng chỉ có text theo khóa học
     * @param course Khóa học
     * @return Số lượng bài giảng chỉ có text
     */
    @Query("SELECT COUNT(l) FROM Lesson l WHERE l.course = :course AND l.isActive = true " +
            "AND (l.videoLink IS NULL OR l.videoLink = '')")
    long countTextOnlyLessonsByCourse(@Param("course") Course course);

    /**
     * Lấy tất cả bài giảng có video từ tất cả khóa học
     * @return Danh sách bài giảng có video
     */
    @Query("SELECT l FROM Lesson l WHERE l.isActive = true AND l.videoLink IS NOT NULL " +
            "AND l.videoLink != '' ORDER BY l.createdAt DESC")
    List<Lesson> findAllLessonsWithVideo();
}