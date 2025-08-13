// ===== LessonRepository.java =====
package com.coursemanagement.repository;

import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.Lesson;
import com.coursemanagement.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository interface cho Lesson entity
 */
@Repository
public interface LessonRepository extends JpaRepository<Lesson, Long> {

    /**
     * Tìm lessons theo course, sắp xếp theo order index
     */
    List<Lesson> findByCourseOrderByOrderIndex(Course course);

    /**
     * Tìm lesson theo ID và course
     */
    Optional<Lesson> findByIdAndCourse(Long id, Course course);

    /**
     * Đếm lessons trong course
     */
    Long countByCourse(Course course);

    /**
     * Đếm lessons của instructor
     */
    @Query("SELECT COUNT(l) FROM Lesson l WHERE l.course.instructor = :instructor")
    Long countByInstructor(@Param("instructor") User instructor);

    /**
     * Tìm lessons active của course
     */
    List<Lesson> findByCourseAndActiveOrderByOrderIndex(Course course, boolean active);

    /**
     * Tìm lessons theo keyword
     */
    List<Lesson> findByCourseAndTitleContainingIgnoreCaseOrderByOrderIndex(Course course, String keyword);

    /**
     * Kiểm tra lesson thuộc course không
     */
    boolean existsByIdAndCourseId(Long lessonId, Long courseId);

    /**
     * Tìm lesson theo slug và course
     */
    Optional<Lesson> findBySlugAndCourse(String slug, Course course);

    /**
     * Tìm lessons preview của course
     */
    List<Lesson> findByCourseAndPreviewAndActiveOrderByOrderIndex(Course course, boolean preview, boolean active);
}
