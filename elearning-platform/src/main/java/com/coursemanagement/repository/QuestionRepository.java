// ===== QuestionRepository.java =====
package com.coursemanagement.repository;

import com.coursemanagement.entity.Question;
import com.coursemanagement.entity.Quiz;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository interface cho Question entity
 */
@Repository
public interface QuestionRepository extends JpaRepository<Question, Long> {

    /**
     * Tìm questions theo quiz, sắp xếp theo display order
     */
    List<Question> findByQuizOrderByDisplayOrder(Quiz quiz);

    /**
     * Tìm question theo ID và quiz
     */
    Optional<Question> findByIdAndQuiz(Long id, Quiz quiz);

    /**
     * Đếm questions trong quiz
     */
    Long countByQuiz(Quiz quiz);

    /**
     * Tìm questions theo difficulty level
     */
    List<Question> findByQuizAndDifficultyLevel(Quiz quiz, Question.DifficultyLevel difficultyLevel);

    /**
     * Tìm questions theo correct option
     */
    List<Question> findByQuizAndCorrectOption(Quiz quiz, String correctOption);

    /**
     * Tìm questions theo keyword
     */
    List<Question> findByQuizAndQuestionTextContainingIgnoreCase(Quiz quiz, String keyword);
}