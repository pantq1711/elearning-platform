package com.coursemanagement.repository;

import com.coursemanagement.entity.Question;
import com.coursemanagement.entity.QuestionType;
import com.coursemanagement.entity.Quiz;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository interface cho Question entity
 * Chứa các custom queries cho question management
 */
@Repository
public interface QuestionRepository extends JpaRepository<Question, Long> {

    // Difficulty and type filters
    List<Question> findByQuizAndDifficultyLevelOrderByDisplayOrder(Quiz quiz, Question.DifficultyLevel difficulty);
    List<Question> findByQuizAndQuestionTypeOrderByDisplayOrder(Quiz quiz, QuestionType questionType);

    // Random selection
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz ORDER BY RANDOM()")
    List<Question> findRandomQuestionsByQuiz(@Param("quiz") Quiz quiz, Pageable pageable);


    // ===== BASIC FINDER METHODS =====

    /**
     * Tìm question theo ID và quiz (cho security)
     */
    Optional<Question> findByIdAndQuiz(Long id, Quiz quiz);

    /**
     * Tìm questions theo quiz sắp xếp theo display order
     */
    List<Question> findByQuizOrderByDisplayOrder(Quiz quiz);

    /**
     * Tìm questions theo quiz với pagination
     */
    Page<Question> findByQuiz(Quiz quiz, Pageable pageable);

    /**
     * Đếm questions trong một quiz
     */
    Long countByQuiz(Quiz quiz);

    /**
     * Tìm questions theo quiz và correct option
     */
    List<Question> findByQuizAndCorrectOption(Quiz quiz, String correctOption);

    /**
     * Kiểm tra display order đã tồn tại trong quiz chưa
     */
    boolean existsByQuizAndDisplayOrder(Quiz quiz, Integer displayOrder);

    /**
     * Kiểm tra display order đã tồn tại (exclude ID hiện tại)
     */
    boolean existsByQuizAndDisplayOrderAndIdNot(Quiz quiz, Integer displayOrder, Long id);

    // ===== SEARCH METHODS =====

    /**
     * Tìm questions theo quiz và question text chứa keyword (List version)
     */
    List<Question> findByQuizAndQuestionTextContainingIgnoreCase(Quiz quiz, String keyword);

    /**
     * Tìm questions theo quiz và question text chứa keyword với pagination
     */
    Page<Question> findByQuizAndQuestionTextContainingIgnoreCase(Quiz quiz, String keyword, Pageable pageable);

    // ===== DIFFICULTY-BASED QUERIES =====

    /**
     * Tìm questions theo quiz và difficulty level
     */
    List<Question> findByQuizAndDifficultyLevel(Quiz quiz, Question.DifficultyLevel difficultyLevel);

    /**
     * Đếm questions theo difficulty level
     */
    Long countByQuizAndDifficultyLevel(Quiz quiz, Question.DifficultyLevel difficultyLevel);

    /**
     * Tìm questions theo difficulty với pagination
     */
    Page<Question> findByQuizAndDifficultyLevel(Quiz quiz, Question.DifficultyLevel difficultyLevel, Pageable pageable);

    // ===== QUESTION TYPE QUERIES =====

    /**
     * Tìm questions theo quiz và question type
     */
    List<Question> findByQuizAndQuestionType(Quiz quiz, QuestionType questionType);

    /**
     * Đếm questions theo question type
     */
    Long countByQuizAndQuestionType(Quiz quiz, QuestionType questionType);

    // ===== POINTS QUERIES =====

    /**
     * Tìm questions theo quiz sắp xếp theo points giảm dần
     */
    List<Question> findByQuizOrderByPointsDesc(Quiz quiz);

    /**
     * Tính tổng points của tất cả questions trong quiz
     */
    @Query("SELECT SUM(q.points) FROM Question q WHERE q.quiz = :quiz")
    Double sumPointsByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Lấy question có points cao nhất trong quiz
     */
    Optional<Question> findTopByQuizOrderByPointsDesc(Quiz quiz);

    // ===== DISPLAY ORDER MANAGEMENT =====

    /**
     * Tìm max display order trong quiz
     */
    @Query("SELECT MAX(q.displayOrder) FROM Question q WHERE q.quiz = :quiz")
    Integer findMaxDisplayOrderByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Lấy next display order cho question mới
     */
    @Query("SELECT COALESCE(MAX(q.displayOrder), 0) + 1 FROM Question q WHERE q.quiz = :quiz")
    Integer getNextDisplayOrder(@Param("quiz") Quiz quiz);

    // ===== ADVANCED QUERIES =====

    /**
     * Tìm questions theo multiple filters
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz " +
            "AND (:difficultyLevel IS NULL OR q.difficultyLevel = :difficultyLevel) " +
            "AND (:questionType IS NULL OR q.questionType = :questionType) " +
            "AND (:minPoints IS NULL OR q.points >= :minPoints) " +
            "AND (:maxPoints IS NULL OR q.points <= :maxPoints) " +
            "ORDER BY q.displayOrder")
    List<Question> findByQuizWithFilters(
            @Param("quiz") Quiz quiz,
            @Param("difficultyLevel") Question.DifficultyLevel difficultyLevel,
            @Param("questionType") QuestionType questionType,
            @Param("minPoints") Double minPoints,
            @Param("maxPoints") Double maxPoints);

    /**
     * Tìm questions theo tags
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz AND q.tags LIKE CONCAT('%', :tag, '%')")
    List<Question> findByQuizAndTagsContaining(@Param("quiz") Quiz quiz, @Param("tag") String tag);

    /**
     * Tìm random questions từ quiz
     */
    @Query(value = "SELECT * FROM questions q WHERE q.quiz_id = :quizId ORDER BY RAND() LIMIT :limit",
            nativeQuery = true)
    List<Question> findRandomQuestionsByQuiz(@Param("quizId") Long quizId, @Param("limit") int limit);

    /**
     * Kiểm tra có question nào trong quiz có image không
     */
    @Query("SELECT COUNT(q) > 0 FROM Question q WHERE q.quiz = :quiz AND q.imageUrl IS NOT NULL")
    boolean hasQuestionsWithImages(@Param("quiz") Quiz quiz);

    // ===== ANALYTICS QUERIES =====

    /**
     * Lấy thống kê questions theo difficulty level
     */
    @Query("SELECT q.difficultyLevel, COUNT(q) FROM Question q WHERE q.quiz = :quiz GROUP BY q.difficultyLevel")
    List<Object[]> getQuestionStatsByDifficulty(@Param("quiz") Quiz quiz);

    /**
     * Lấy thống kê questions theo question type
     */
    @Query("SELECT q.questionType, COUNT(q) FROM Question q WHERE q.quiz = :quiz GROUP BY q.questionType")
    List<Object[]> getQuestionStatsByType(@Param("quiz") Quiz quiz);
}