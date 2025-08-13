
// ===== QuizResultRepository.java =====
package com.coursemanagement.repository;

import com.coursemanagement.entity.Quiz;
import com.coursemanagement.entity.QuizResult;
import com.coursemanagement.entity.User;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository interface cho QuizResult entity
 */
@Repository
public interface QuizResultRepository extends JpaRepository<QuizResult, Long> {

    /**
     * Tìm quiz results theo quiz
     */
    List<QuizResult> findByQuizOrderBySubmittedAtDesc(Quiz quiz);

    /**
     * Tìm quiz results theo user
     */
    List<QuizResult> findByUserOrderBySubmittedAtDesc(User user);

    /**
     * Tìm quiz result theo quiz và user
     */
    Optional<QuizResult> findByQuizAndUser(Quiz quiz, User user);

    /**
     * Kiểm tra user đã làm quiz chưa
     */
    boolean existsByQuizAndUser(Quiz quiz, User user);

    /**
     * Đếm quiz results của quiz
     */
    Long countByQuiz(Quiz quiz);

    /**
     * Lấy best score của user cho quiz
     */
    @Query("SELECT MAX(qr.score) FROM QuizResult qr WHERE qr.quiz = :quiz AND qr.user = :user")
    Optional<Double> findBestScoreByQuizAndUser(@Param("quiz") Quiz quiz, @Param("user") User user);

    /**
     * Tìm quiz results của instructor
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.quiz.course.instructor = :instructor ORDER BY qr.submittedAt DESC")
    List<QuizResult> findByInstructorOrderBySubmittedAtDesc(@Param("instructor") User instructor, Pageable pageable);

    /**
     * Tìm top students trong quiz
     */
    List<QuizResult> findByQuizOrderByScoreDesc(Quiz quiz, Pageable pageable);
}

