// ===== QuizRepository.java =====
package com.coursemanagement.repository;

import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.Quiz;
import com.coursemanagement.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository interface cho Quiz entity
 */
@Repository
public interface QuizRepository extends JpaRepository<Quiz, Long> {

    /**
     * Tìm quiz theo ID và course
     */
    Optional<Quiz> findByIdAndCourse(Long id, Course course);

    /**
     * Tìm quizzes của course
     */
    List<Quiz> findByCourseOrderByCreatedAtDesc(Course course);

    /**
     * Đếm quizzes trong course
     */
    Long countByCourse(Course course);

    /**
     * Tìm quizzes của instructor
     */
    @Query("SELECT q FROM Quiz q WHERE q.course.instructor = :instructor ORDER BY q.createdAt DESC")
    List<Quiz> findByInstructorOrderByCreatedAtDesc(@Param("instructor") User instructor);

    /**
     * Tìm quizzes active của course
     */
    List<Quiz> findByCourseAndActiveOrderByCreatedAtDesc(Course course, boolean active);

    /**
     * Tìm quizzes available (trong thời gian cho phép)
     */
    @Query("SELECT q FROM Quiz q WHERE q.course = :course AND q.active = true AND " +
            "(q.availableFrom IS NULL OR q.availableFrom <= CURRENT_TIMESTAMP) AND " +
            "(q.availableUntil IS NULL OR q.availableUntil >= CURRENT_TIMESTAMP)")
    List<Quiz> findAvailableQuizzesByCourse(@Param("course") Course course);
}
