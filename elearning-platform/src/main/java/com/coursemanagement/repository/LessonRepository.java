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
     * Tìm lessons theo course ID sắp xếp theo order index
     * @param courseId ID của course
     * @return Danh sách lessons đã sắp xếp
     */
    List<Lesson> findByCourseIdOrderByOrderIndex(Long courseId);

    /**
     * Tìm active lessons theo course
     * @param course Course
     * @param active Trạng thái active
     * @return Danh sách active lessons
     */
    List<Lesson> findByCourseAndActiveOrderByOrderIndex(Course course, boolean active);

    /**
     * Đếm lessons theo course và trạng thái active
     * @param course Course
     * @param active Trạng thái active
     * @return Số lượng lessons
     */
    Long countByCourseAndActive(Course course, boolean active);

    /**
     * Đếm tất cả lessons của course
     * @param course Course
     * @return Số lượng lessons
     */
    Long countByCourse(Course course);

    // ===== INSTRUCTOR-RELATED QUERIES =====

    /**
     * Đếm lessons của instructor
     * @param instructor Instructor
     * @return Số lượng lessons
     */
    @Query("SELECT COUNT(l) FROM Lesson l WHERE l.course.instructor = :instructor")
    Long countByInstructor(@Param("instructor") User instructor);

    /**
     * Tìm lessons của instructor với pagination
     * @param instructor Instructor
     * @param pageable Pagination info
     * @return Page lessons
     */
    @Query("SELECT l FROM Lesson l WHERE l.course.instructor = :instructor ORDER BY l.createdAt DESC")
    Page<Lesson> findByInstructor(@Param("instructor") User instructor, Pageable pageable);

    // ===== ORDER INDEX METHODS =====

    /**
     * Tìm max order index trong course
     * @param course Course
     * @return Max order index
     */
    @Query("SELECT MAX(l.orderIndex) FROM Lesson l WHERE l.course = :course")
    Integer findMaxOrderIndexByCourse(@Param("course") Course course);

    /**
     * Tăng order index cho các lessons trong range
     * @param course Course
     * @param startIndex Start index
     * @param endIndex End index
     */
    @Modifying
    @Query("UPDATE Lesson l SET l.orderIndex = l.orderIndex + 1 " +
            "WHERE l.course = :course AND l.orderIndex >= :startIndex AND l.orderIndex <= :endIndex")
    void incrementOrderIndex(@Param("course") Course course,
                             @Param("startIndex") Integer startIndex,
                             @Param("endIndex") Integer endIndex);

    /**
     * Giảm order index cho các lessons trong range
     * @param course Course
     * @param startIndex Start index
     * @param endIndex End index
     */
    @Modifying
    @Query("UPDATE Lesson l SET l.orderIndex = l.orderIndex - 1 " +
            "WHERE l.course = :course AND l.orderIndex >= :startIndex AND l.orderIndex <= :endIndex")
    void decrementOrderIndex(@Param("course") Course course,
                             @Param("startIndex") Integer startIndex,
                             @Param("endIndex") Integer endIndex);

    // ===== NAVIGATION METHODS =====

    /**
     * Tìm lesson trước đó trong course
     * @param course Course
     * @param currentOrderIndex Order index hiện tại
     * @return Optional chứa lesson trước đó
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.orderIndex < :currentOrderIndex " +
            "AND l.active = true ORDER BY l.orderIndex DESC")
    Optional<Lesson> findPreviousLesson(@Param("course") Course course,
                                        @Param("currentOrderIndex") Integer currentOrderIndex);

    /**
     * Tìm lesson tiếp theo trong course
     * @param course Course
     * @param currentOrderIndex Order index hiện tại
     * @return Optional chứa lesson tiếp theo
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.orderIndex > :currentOrderIndex " +
            "AND l.active = true ORDER BY l.orderIndex ASC")
    Optional<Lesson> findNextLesson(@Param("course") Course course,
                                    @Param("currentOrderIndex") Integer currentOrderIndex);

    // ===== SEARCH AND FILTER METHODS =====

    /**
     * Tìm lessons theo keyword trong title
     * @param keyword Từ khóa tìm kiếm
     * @param active Trạng thái active
     * @param pageable Pagination info
     * @return Page lessons
     */
    Page<Lesson> findByTitleContainingIgnoreCaseAndActiveOrderByCreatedAtDesc(String keyword, boolean active, Pageable pageable);

    /**
     * Tìm active lessons sắp xếp theo ngày tạo
     * @param active Trạng thái active
     * @param pageable Pagination info
     * @return Page lessons
     */
    Page<Lesson> findByActiveOrderByCreatedAtDesc(boolean active, Pageable pageable);

    /**
     * Tìm preview lessons của course
     * @param course Course
     * @return Danh sách preview lessons
     */
    List<Lesson> findByCourseAndPreviewAndActiveOrderByOrderIndex(Course course, boolean preview, boolean active);

    // ===== STATISTICS METHODS =====

    /**
     * Lấy thống kê lessons theo course
     * @return List array [courseId, courseName, lessonCount]
     */
    @Query("SELECT l.course.id, l.course.name, COUNT(l) " +
            "FROM Lesson l " +
            "WHERE l.active = true " +
            "GROUP BY l.course.id, l.course.name " +
            "ORDER BY COUNT(l) DESC")
    List<Object[]> getLessonCountByCourse();

    /**
     * Lấy thống kê lessons theo instructor
     * @return List array [instructorId, instructorName, lessonCount]
     */
    @Query("SELECT l.course.instructor.id, l.course.instructor.fullName, COUNT(l) " +
            "FROM Lesson l " +
            "WHERE l.active = true " +
            "GROUP BY l.course.instructor.id, l.course.instructor.fullName " +
            "ORDER BY COUNT(l) DESC")
    List<Object[]> getLessonCountByInstructor();

    /**
     * Đếm total active lessons
     * @return Số lượng active lessons
     */
    Long countByActive(boolean active);

    // ===== ADVANCED QUERIES =====

    /**
     * Tìm lessons có video
     * @param course Course
     * @return Danh sách lessons có video
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.videoLink IS NOT NULL " +
            "AND l.videoLink != '' AND l.active = true ORDER BY l.orderIndex")
    List<Lesson> findLessonsWithVideo(@Param("course") Course course);

    /**
     * Tìm lessons có tài liệu
     * @param course Course
     * @return Danh sách lessons có tài liệu
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.documentUrl IS NOT NULL " +
            "AND l.documentUrl != '' AND l.active = true ORDER BY l.orderIndex")
    List<Lesson> findLessonsWithDocument(@Param("course") Course course);

    /**
     * Tìm lessons theo estimated duration range
     * @param course Course
     * @param minDuration Duration tối thiểu (phút)
     * @param maxDuration Duration tối đa (phút)
     * @return Danh sách lessons
     */
    @Query("SELECT l FROM Lesson l WHERE l.course = :course AND l.active = true " +
            "AND l.estimatedDuration >= :minDuration AND l.estimatedDuration <= :maxDuration " +
            "ORDER BY l.orderIndex")
    List<Lesson> findByDurationRange(@Param("course") Course course,
                                     @Param("minDuration") Integer minDuration,
                                     @Param("maxDuration") Integer maxDuration);

    /**
     * Tìm lessons cần được review (không có video và document)
     * @param instructor Instructor
     * @return Danh sách lessons cần review
     */
    @Query("SELECT l FROM Lesson l WHERE l.course.instructor = :instructor AND l.active = true " +
            "AND (l.videoLink IS NULL OR l.videoLink = '') " +
            "AND (l.documentUrl IS NULL OR l.documentUrl = '') " +
            "ORDER BY l.createdAt DESC")
    List<Lesson> findLessonsNeedingContent(@Param("instructor") User instructor);

    /**
     * Lấy total estimated duration của course
     * @param course Course
     * @return Tổng thời lượng ước tính (phút)
     */
    @Query("SELECT SUM(l.estimatedDuration) FROM Lesson l WHERE l.course = :course AND l.active = true")
    Integer getTotalDurationByCourse(@Param("course") Course course);
}