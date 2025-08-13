package com.coursemanagement.repository;

import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.Lesson;
import com.coursemanagement.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * Repository interface cho Lesson entity
 * Chứa các custom queries cho lesson management
 */
@Repository
public interface LessonRepository extends JpaRepository<Lesson, Long> {

    // ===== BASIC FINDER METHODS =====

    /**
     * Tìm lesson theo slug
     */
    Optional<Lesson> findBySlug(String slug);

    /**
     * Tìm lesson theo ID và course (cho security)
     */
    Optional<Lesson> findByIdAndCourse(Long id, Course course);

    /**
     * Kiểm tra slug đã tồn tại trong course chưa
     */
    boolean existsBySlugAndCourse(String slug, Course course);

    /**
     * Kiểm tra slug đã tồn tại trong course chưa (exclude ID hiện tại)
     */
    boolean existsBySlugAndCourseAndIdNot(String slug, Course course, Long id);

    /**
     * Kiểm tra có lesson nào với order index không
     */
    boolean existsByCourseAndOrderIndex(Course course, Integer orderIndex);

    /**
     * Kiểm tra có lesson nào với order index (exclude ID hiện tại)
     */
    boolean existsByCourseAndOrderIndexAndIdNot(Course course, Integer orderIndex, Long id);

    // ===== COURSE-RELATED QUERIES =====

    /**
     * Tìm lessons theo course sắp xếp theo order index
     */
    List<Lesson> findByCourseOrderByOrderIndex(Course course);

    /**
     * Tìm lessons theo course ID sắp xếp theo order index
     */
    @Query("SELECT l FROM Lesson l WHERE l.course.id = :courseId ORDER BY l.orderIndex ASC")
    List<Lesson> findByCourseIdOrderByOrderIndex(@Param("courseId") Long courseId);

    /**
     * Tìm lessons theo course với pagination
     */
    Page<Lesson> findByCourse(Course course, Pageable pageable);

    /**
     * Tìm lessons theo course sắp xếp theo order index với pagination
     */
    Page<Lesson> findByCourseOrderByOrderIndex(Course course, Pageable pageable);

    /**
     * Tìm active lessons theo course
     */
    List<Lesson> findByCourseAndActiveOrderByOrderIndex(Course course, boolean active);

    /**
     * Đếm lessons theo course
     */
    Long countByCourse(Course course);

    /**
     * Đếm lessons theo course (alternative method name)
     */
    Long countLessonsByCourse(Course course);

    /**
     * Đếm active lessons theo course
     */
    Long countByCourseAndActive(Course course, boolean active);

    // ===== PREVIEW LESSONS =====

    /**
     * Tìm preview lessons theo course
     */
    List<Lesson> findByCourseAndPreviewOrderByOrderIndex(Course course, boolean preview);

    /**
     * Lấy lesson đầu tiên có preview trong course
     */
    Optional<Lesson> findFirstByCourseAndPreviewOrderByOrderIndex(Course course, boolean preview);

    // ===== ORDER INDEX MANAGEMENT =====

    /**
     * Lấy max order index trong course
     */
    @Query("SELECT COALESCE(MAX(l.orderIndex), 0) FROM Lesson l WHERE l.course = :course")
    Integer getMaxOrderIndexByCourse(@Param("course") Course course);

    /**
     * Tìm max order index trong course (alternative method)
     */
    @Query("SELECT MAX(l.orderIndex) FROM Lesson l WHERE l.course = :course")
    Integer findMaxOrderIndexByCourse(@Param("course") Course course);

    /**
     * Lấy next order index cho lesson mới
     */
    @Query("SELECT COALESCE(MAX(l.orderIndex), 0) + 1 FROM Lesson l WHERE l.course = :course")
    Integer getNextOrderIndex(@Param("course") Course course);

    /**
     * Cập nhật order index của lessons từ vị trí cho trước
     */
    @Modifying
    @Transactional
    @Query("UPDATE Lesson l SET l.orderIndex = l.orderIndex + 1 WHERE l.course = :course AND l.orderIndex >= :fromIndex")
    void incrementOrderIndexFrom(@Param("course") Course course, @Param("fromIndex") Integer fromIndex);

    /**
     * Tăng order index của các lessons từ vị trí cho trước với số lượng tùy chọn
     */
    @Modifying
    @Transactional
    @Query("UPDATE Lesson l SET l.orderIndex = l.orderIndex + :incrementBy " +
            "WHERE l.course = :course AND l.orderIndex >= :fromIndex")
    void incrementOrderIndex(@Param("course") Course course,
                             @Param("fromIndex") Integer fromIndex,
                             @Param("incrementBy") int incrementBy);

    /**
     * Giảm order index của các lessons trong khoảng
     */
    @Modifying
    @Transactional
    @Query("UPDATE Lesson l SET l.orderIndex = l.orderIndex - 1 " +
            "WHERE l.course = :course AND l.orderIndex > :fromIndex AND l.orderIndex <= :toIndex")
    void decrementOrderIndex(@Param("course") Course course,
                             @Param("fromIndex") int fromIndex,
                             @Param("toIndex") Integer toIndex);

    // ===== SEARCH METHODS =====

    /**
     * Search lessons theo title hoặc content trong course
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND " +
            "(LOWER(l.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(l.content) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    List<Lesson> searchLessonsInCourse(@Param("course") Course course, @Param("keyword") String keyword);

    /**
     * Search lessons global
     */
    @Query("SELECT l FROM Lesson l WHERE l.active = true AND " +
            "(LOWER(l.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(l.content) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    Page<Lesson> searchLessons(@Param("keyword") String keyword, Pageable pageable);

    /**
     * Tìm lessons active sắp xếp theo ngày tạo
     */
    Page<Lesson> findByActiveOrderByCreatedAtDesc(boolean active, Pageable pageable);

    /**
     * Tìm lessons theo title chứa keyword và active
     */
    Page<Lesson> findByTitleContainingIgnoreCaseAndActiveOrderByCreatedAtDesc(String keyword,
                                                                              boolean active,
                                                                              Pageable pageable);

    // ===== INSTRUCTOR-RELATED QUERIES =====

    /**
     * Tìm lessons theo instructor
     */
    @Query("SELECT l FROM Lesson l WHERE l.course.instructor = :instructor ORDER BY l.createdAt DESC")
    List<Lesson> findByInstructor(@Param("instructor") User instructor);

    /**
     * Tìm lessons theo instructor với pagination
     */
    @Query("SELECT l FROM Lesson l WHERE l.course.instructor = :instructor ORDER BY l.createdAt DESC")
    Page<Lesson> findByInstructor(@Param("instructor") User instructor, Pageable pageable);

    /**
     * Đếm lessons của instructor
     */
    @Query("SELECT COUNT(l) FROM Lesson l WHERE l.course.instructor = :instructor")
    Long countByInstructor(@Param("instructor") User instructor);

    // ===== VIDEO & DOCUMENT QUERIES =====

    /**
     * Tìm lessons có video (videoLink field)
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.videoLink IS NOT NULL AND l.videoLink != ''")
    List<Lesson> findLessonsWithVideo(@Param("course") Course course);

    /**
     * Tìm lessons có video content (videoUrl field)
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.videoUrl IS NOT NULL " +
            "ORDER BY l.orderIndex ASC")
    List<Lesson> findLessonsWithVideoUrl(@Param("course") Course course);

    /**
     * Tìm lessons có document
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.documentUrl IS NOT NULL AND l.documentUrl != ''")
    List<Lesson> findLessonsWithDocument(@Param("course") Course course);

    /**
     * Đếm lessons có video trong course
     */
    @Query("SELECT COUNT(l) FROM Lesson l WHERE l.course = :course AND l.videoLink IS NOT NULL AND l.videoLink != ''")
    Long countLessonsWithVideo(@Param("course") Course course);

    /**
     * Đếm lessons có document trong course
     */
    @Query("SELECT COUNT(l) FROM Lesson l WHERE l.course = :course AND l.documentUrl IS NOT NULL AND l.documentUrl != ''")
    Long countLessonsWithDocument(@Param("course") Course course);

    // ===== ANALYTICS QUERIES =====

    /**
     * Lấy tổng estimated duration của course
     */
    @Query("SELECT COALESCE(SUM(l.estimatedDuration), 0) FROM Lesson l WHERE l.course = :course AND l.active = true")
    Integer getTotalEstimatedDurationByCourse(@Param("course") Course course);

    /**
     * Tính tổng duration của course (duration field)
     */
    @Query("SELECT SUM(COALESCE(l.duration, 0)) FROM Lesson l WHERE l.course = :course")
    Integer getTotalDurationByCourse(@Param("course") Course course);

    /**
     * Lấy average duration per lesson trong course
     */
    @Query("SELECT AVG(l.estimatedDuration) FROM Lesson l WHERE l.course = :course AND l.active = true")
    Double getAverageDurationByCourse(@Param("course") Course course);

    /**
     * Lấy lessons được tạo gần đây
     */
    @Query("SELECT l FROM Lesson l WHERE l.active = true ORDER BY l.createdAt DESC")
    List<Lesson> findRecentLessons(@Param("limit") int limit);

    /**
     * Lấy lessons được update gần đây
     */
    @Query("SELECT l FROM Lesson l WHERE l.active = true ORDER BY l.updatedAt DESC")
    List<Lesson> findRecentlyUpdatedLessons(@Param("limit") int limit);

    /**
     * Lấy thống kê lessons theo course của instructor
     */
    @Query("SELECT c.name, COUNT(l), COALESCE(SUM(l.estimatedDuration), 0) " +
            "FROM Course c LEFT JOIN c.lessons l " +
            "WHERE c.instructor = :instructor " +
            "GROUP BY c.id, c.name " +
            "ORDER BY COUNT(l) DESC")
    List<Object[]> getLessonStatsByInstructor(@Param("instructor") User instructor);

    // ===== NAVIGATION METHODS =====

    /**
     * Lấy lesson tiếp theo trong course
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.orderIndex > :currentOrderIndex AND l.active = true ORDER BY l.orderIndex ASC")
    Optional<Lesson> findNextLesson(@Param("course") Course course, @Param("currentOrderIndex") Integer currentOrderIndex);

    /**
     * Lấy lesson trước đó trong course
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.orderIndex < :currentOrderIndex AND l.active = true ORDER BY l.orderIndex DESC")
    Optional<Lesson> findPreviousLesson(@Param("course") Course course, @Param("currentOrderIndex") Integer currentOrderIndex);

    /**
     * Lấy lesson đầu tiên trong course (active)
     */
    Optional<Lesson> findFirstByCourseAndActiveOrderByOrderIndex(Course course, boolean active);

    /**
     * Tìm lesson đầu tiên trong course
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course ORDER BY l.orderIndex ASC")
    Optional<Lesson> findFirstLessonByCourse(@Param("course") Course course);

    /**
     * Lấy lesson cuối cùng trong course (active)
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.active = true ORDER BY l.orderIndex DESC")
    Optional<Lesson> findLastLessonInCourse(@Param("course") Course course);

    /**
     * Tìm lesson cuối cùng trong course
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course ORDER BY l.orderIndex DESC")
    Optional<Lesson> findLastLessonByCourse(@Param("course") Course course);
}