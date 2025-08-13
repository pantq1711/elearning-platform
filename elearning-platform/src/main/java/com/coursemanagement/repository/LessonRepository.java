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
 * Cập nhật với đầy đủ methods cần thiết
 */
@Repository
public interface LessonRepository extends JpaRepository<Lesson, Long> {

    // ===== BASIC FINDER METHODS =====

    /**
     * Tìm lesson theo slug
     * @param slug Slug của lesson
     * @return Optional chứa Lesson nếu tìm thấy
     */
    Optional<Lesson> findBySlug(String slug);

    /**
     * Tìm lesson theo ID và course (cho security)
     * @param id ID lesson
     * @param course Course chứa lesson
     * @return Optional chứa Lesson nếu tìm thấy
     */
    Optional<Lesson> findByIdAndCourse(Long id, Course course);

    /**
     * Kiểm tra slug đã tồn tại trong course chưa
     * @param slug Slug
     * @param course Course
     * @return true nếu đã tồn tại
     */
    boolean existsBySlugAndCourse(String slug, Course course);

    /**
     * Kiểm tra slug đã tồn tại trong course chưa (exclude ID hiện tại)
     * @param slug Slug
     * @param course Course
     * @param id ID cần exclude
     * @return true nếu đã tồn tại
     */
    boolean existsBySlugAndCourseAndIdNot(String slug, Course course, Long id);

    // ===== COURSE-RELATED QUERIES =====

    /**
     * Tìm lessons theo course sắp xếp theo order index
     * @param course Course
     * @return Danh sách lessons đã sắp xếp
     */
    List<Lesson> findByCourseOrderByOrderIndex(Course course);

    /**
     * Tìm lessons theo course với pagination
     * @param course Course
     * @param pageable Pagination info
     * @return Page chứa lessons
     */
    Page<Lesson> findByCourse(Course course, Pageable pageable);

    /**
     * Tìm active lessons theo course
     * @param course Course
     * @param active Trạng thái active
     * @return Danh sách active lessons
     */
    List<Lesson> findByCourseAndActiveOrderByOrderIndex(Course course, boolean active);

    /**
     * Đếm lessons theo course
     * @param course Course
     * @return Số lượng lessons
     */
    Long countLessonsByCourse(Course course);

    /**
     * Đếm active lessons theo course
     * @param course Course
     * @param active Trạng thái active
     * @return Số lượng active lessons
     */
    Long countByCourseAndActive(Course course, boolean active);

    // ===== PREVIEW LESSONS =====

    /**
     * Tìm preview lessons theo course
     * @param course Course
     * @return Danh sách preview lessons
     */
    List<Lesson> findByCourseAndPreviewOrderByOrderIndex(Course course, boolean preview);

    /**
     * Lấy lesson đầu tiên có preview trong course
     * @param course Course
     * @return Optional chứa preview lesson đầu tiên
     */
    Optional<Lesson> findFirstByCourseAndPreviewOrderByOrderIndex(Course course, boolean preview);

    // ===== ORDER INDEX MANAGEMENT =====

    /**
     * Lấy max order index trong course
     * @param course Course
     * @return Max order index
     */
    @Query("SELECT COALESCE(MAX(l.orderIndex), 0) FROM Lesson l WHERE l.course = :course")
    Integer getMaxOrderIndexByCourse(@Param("course") Course course);

    /**
     * Lấy next order index cho lesson mới
     * @param course Course
     * @return Next order index
     */
    @Query("SELECT COALESCE(MAX(l.orderIndex), 0) + 1 FROM Lesson l WHERE l.course = :course")
    Integer getNextOrderIndex(@Param("course") Course course);

    /**
     * Cập nhật order index của lessons
     * @param lessonIds Danh sách lesson IDs
     * @param newOrderIndex Order index mới
     */
    @Modifying
    @Transactional
    @Query("UPDATE Lesson l SET l.orderIndex = l.orderIndex + 1 WHERE l.course = :course AND l.orderIndex >= :fromIndex")
    void incrementOrderIndexFrom(@Param("course") Course course, @Param("fromIndex") Integer fromIndex);

    // ===== SEARCH METHODS =====

    /**
     * Search lessons theo title hoặc content
     * @param course Course
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách lessons tìm thấy
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND " +
            "(LOWER(l.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(l.content) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    List<Lesson> searchLessonsInCourse(@Param("course") Course course, @Param("keyword") String keyword);

    /**
     * Search lessons global
     * @param keyword Từ khóa tìm kiếm
     * @param pageable Pagination info
     * @return Page chứa lessons tìm thấy
     */
    @Query("SELECT l FROM Lesson l WHERE l.active = true AND " +
            "(LOWER(l.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(l.content) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    Page<Lesson> searchLessons(@Param("keyword") String keyword, Pageable pageable);

    // ===== INSTRUCTOR-RELATED QUERIES =====

    /**
     * Tìm lessons theo instructor
     * @param instructor Instructor
     * @param pageable Pagination info
     * @return Page chứa lessons
     */
    @Query("SELECT l FROM Lesson l WHERE l.course.instructor = :instructor ORDER BY l.createdAt DESC")
    Page<Lesson> findByInstructor(@Param("instructor") User instructor, Pageable pageable);

    /**
     * Đếm lessons của instructor
     * @param instructor Instructor
     * @return Số lượng lessons
     */
    @Query("SELECT COUNT(l) FROM Lesson l WHERE l.course.instructor = :instructor")
    Long countByInstructor(@Param("instructor") User instructor);

    // ===== VIDEO & DOCUMENT QUERIES =====

    /**
     * Tìm lessons có video
     * @param course Course
     * @return Danh sách lessons có video
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.videoLink IS NOT NULL AND l.videoLink != ''")
    List<Lesson> findLessonsWithVideo(@Param("course") Course course);

    /**
     * Tìm lessons có document
     * @param course Course
     * @return Danh sách lessons có document
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.documentUrl IS NOT NULL AND l.documentUrl != ''")
    List<Lesson> findLessonsWithDocument(@Param("course") Course course);

    /**
     * Đếm lessons có video trong course
     * @param course Course
     * @return Số lượng lessons có video
     */
    @Query("SELECT COUNT(l) FROM Lesson l WHERE l.course = :course AND l.videoLink IS NOT NULL AND l.videoLink != ''")
    Long countLessonsWithVideo(@Param("course") Course course);

    /**
     * Đếm lessons có document trong course
     * @param course Course
     * @return Số lượng lessons có document
     */
    @Query("SELECT COUNT(l) FROM Lesson l WHERE l.course = :course AND l.documentUrl IS NOT NULL AND l.documentUrl != ''")
    Long countLessonsWithDocument(@Param("course") Course course);

    // ===== ANALYTICS QUERIES =====

    /**
     * Lấy tổng estimated duration của course
     * @param course Course
     * @return Tổng duration (minutes)
     */
    @Query("SELECT COALESCE(SUM(l.estimatedDuration), 0) FROM Lesson l WHERE l.course = :course AND l.active = true")
    Integer getTotalDurationByCourse(@Param("course") Course course);

    /**
     * Lấy average duration per lesson trong course
     * @param course Course
     * @return Average duration
     */
    @Query("SELECT AVG(l.estimatedDuration) FROM Lesson l WHERE l.course = :course AND l.active = true")
    Double getAverageDurationByCourse(@Param("course") Course course);

    /**
     * Lấy lessons được tạo gần đây
     * @param limit Số lượng lessons
     * @return Danh sách recent lessons
     */
    @Query("SELECT l FROM Lesson l WHERE l.active = true ORDER BY l.createdAt DESC")
    List<Lesson> findRecentLessons(@Param("limit") int limit);

    /**
     * Lấy lessons được update gần đây
     * @param limit Số lượng lessons
     * @return Danh sách recently updated lessons
     */
    @Query("SELECT l FROM Lesson l WHERE l.active = true ORDER BY l.updatedAt DESC")
    List<Lesson> findRecentlyUpdatedLessons(@Param("limit") int limit);

    /**
     * Lấy thống kê lessons theo course của instructor
     * @param instructor Instructor
     * @return Danh sách [CourseName, LessonCount, TotalDuration]
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
     * @param course Course
     * @param currentOrderIndex Order index hiện tại
     * @return Optional chứa lesson tiếp theo
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.orderIndex > :currentOrderIndex AND l.active = true ORDER BY l.orderIndex ASC")
    Optional<Lesson> findNextLesson(@Param("course") Course course, @Param("currentOrderIndex") Integer currentOrderIndex);

    /**
     * Lấy lesson trước đó trong course
     * @param course Course
     * @param currentOrderIndex Order index hiện tại
     * @return Optional chứa lesson trước đó
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.orderIndex < :currentOrderIndex AND l.active = true ORDER BY l.orderIndex DESC")
    Optional<Lesson> findPreviousLesson(@Param("course") Course course, @Param("currentOrderIndex") Integer currentOrderIndex);

    /**
     * Lấy lesson đầu tiên trong course
     * @param course Course
     * @return Optional chứa lesson đầu tiên
     */
    Optional<Lesson> findFirstByCourseAndActiveOrderByOrderIndex(Course course, boolean active);

    /**
     * Lấy lesson cuối cùng trong course
     * @param course Course
     * @return Optional chứa lesson cuối cùng
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.active = true ORDER BY l.orderIndex DESC")
    Optional<Lesson> findLastLessonInCourse(@Param("course") Course course);
}