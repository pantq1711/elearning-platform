package com.coursemanagement.repository;

import com.coursemanagement.entity.Question;
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

    // ===== BASIC FINDER METHODS =====

    /**
     * Tìm question theo ID và quiz (cho security)
     * @param id ID question
     * @param quiz Quiz chứa question
     * @return Optional chứa Question nếu tìm thấy
     */
    Optional<Question> findByIdAndQuiz(Long id, Quiz quiz);

    /**
     * Tìm questions theo quiz sắp xếp theo display order
     * @param quiz Quiz
     * @return Danh sách questions đã sắp xếp
     */
    List<Question> findByQuizOrderByDisplayOrder(Quiz quiz);

    /**
     * Đếm questions trong một quiz
     * @param quiz Quiz
     * @return Số lượng questions
     */
    Long countByQuiz(Quiz quiz);

    // ===== DIFFICULTY-BASED QUERIES =====

    /**
     * Tìm questions theo quiz và difficulty level
     * @param quiz Quiz
     * @param difficultyLevel Độ khó
     * @return Danh sách questions
     */
    List<Question> findByQuizAndDifficultyLevel(Quiz quiz, Question.DifficultyLevel difficultyLevel);

    /**
     * Đếm questions theo difficulty level
     * @param quiz Quiz
     * @param difficultyLevel Độ khó
     * @return Số lượng questions
     */
    Long countByQuizAndDifficultyLevel(Quiz quiz, Question.DifficultyLevel difficultyLevel);

    /**
     * Tìm questions theo difficulty với pagination
     * @param quiz Quiz
     * @param difficultyLevel Độ khó
     * @param pageable Pagination info
     * @return Page questions
     */
    Page<Question> findByQuizAndDifficultyLevelOrderByDisplayOrder(Quiz quiz,
                                                                   Question.DifficultyLevel difficultyLevel,
                                                                   Pageable pageable);

    // ===== CORRECT ANSWER QUERIES =====

    /**
     * Tìm questions theo correct option
     * @param quiz Quiz
     * @param correctOption Đáp án đúng (A, B, C, D)
     * @return Danh sách questions
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz AND q.correctOption = :correctOption " +
            "ORDER BY q.displayOrder")
    List<Question> findByQuizAndCorrectOption(@Param("quiz") Quiz quiz,
                                              @Param("correctOption") String correctOption);

    /**
     * Đếm questions theo correct option
     * @param quiz Quiz
     * @param correctOption Đáp án đúng
     * @return Số lượng questions
     */
    Long countByQuizAndCorrectOption(Quiz quiz, String correctOption);

    // ===== DISPLAY ORDER MANAGEMENT =====

    /**
     * Tìm max display order trong quiz
     * @param quiz Quiz
     * @return Max display order
     */
    @Query("SELECT MAX(q.displayOrder) FROM Question q WHERE q.quiz = :quiz")
    Integer findMaxDisplayOrderByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Tìm question theo display order
     * @param quiz Quiz
     * @param displayOrder Display order
     * @return Optional chứa Question
     */
    Optional<Question> findByQuizAndDisplayOrder(Quiz quiz, Integer displayOrder);

    /**
     * Tìm questions trong range display order
     * @param quiz Quiz
     * @param startOrder Start order
     * @param endOrder End order
     * @return Danh sách questions
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz AND " +
            "q.displayOrder >= :startOrder AND q.displayOrder <= :endOrder " +
            "ORDER BY q.displayOrder")
    List<Question> findByDisplayOrderRange(@Param("quiz") Quiz quiz,
                                           @Param("startOrder") Integer startOrder,
                                           @Param("endOrder") Integer endOrder);

    // ===== SEARCH AND FILTER =====

    /**
     * Tìm questions theo keyword trong question text
     * @param quiz Quiz
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách questions
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz AND " +
            "LOWER(q.questionText) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "ORDER BY q.displayOrder")
    List<Question> findByQuizAndKeyword(@Param("quiz") Quiz quiz,
                                        @Param("keyword") String keyword);

    /**
     * Tìm questions theo keyword với pagination
     * @param quiz Quiz
     * @param keyword Từ khóa tìm kiếm
     * @param pageable Pagination info
     * @return Page questions
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz AND " +
            "LOWER(q.questionText) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "ORDER BY q.displayOrder")
    Page<Question> findByQuizAndKeyword(@Param("quiz") Quiz quiz,
                                        @Param("keyword") String keyword,
                                        Pageable pageable);

    // ===== VALIDATION QUERIES =====

    /**
     * Tìm questions có explanation
     * @param quiz Quiz
     * @return Danh sách questions có explanation
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz AND " +
            "q.explanation IS NOT NULL AND q.explanation != '' " +
            "ORDER BY q.displayOrder")
    List<Question> findQuestionsWithExplanation(@Param("quiz") Quiz quiz);

    /**
     * Tìm questions chưa có explanation
     * @param quiz Quiz
     * @return Danh sách questions chưa có explanation
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz AND " +
            "(q.explanation IS NULL OR q.explanation = '') " +
            "ORDER BY q.displayOrder")
    List<Question> findQuestionsWithoutExplanation(@Param("quiz") Quiz quiz);

    /**
     * Kiểm tra questions có options hợp lệ không
     * @param quiz Quiz
     * @return Danh sách questions có thể có vấn đề
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz AND " +
            "(q.optionA IS NULL OR q.optionA = '' OR " +
            " q.optionB IS NULL OR q.optionB = '' OR " +
            " q.optionC IS NULL OR q.optionC = '' OR " +
            " q.optionD IS NULL OR q.optionD = '') " +
            "ORDER BY q.displayOrder")
    List<Question> findQuestionsWithIncompleteOptions(@Param("quiz") Quiz quiz);

    // ===== STATISTICS QUERIES =====

    /**
     * Lấy thống kê questions theo difficulty
     * @param quiz Quiz
     * @return List array [difficultyLevel, count]
     */
    @Query("SELECT q.difficultyLevel, COUNT(q) FROM Question q WHERE q.quiz = :quiz " +
            "GROUP BY q.difficultyLevel ORDER BY q.difficultyLevel")
    List<Object[]> getQuestionStatsByDifficulty(@Param("quiz") Quiz quiz);

    /**
     * Lấy thống kê correct answers distribution
     * @param quiz Quiz
     * @return List array [correctOption, count]
     */
    @Query("SELECT q.correctOption, COUNT(q) FROM Question q WHERE q.quiz = :quiz " +
            "GROUP BY q.correctOption ORDER BY q.correctOption")
    List<Object[]> getCorrectAnswerDistribution(@Param("quiz") Quiz quiz);

    /**
     * Đếm total questions trong hệ thống
     * @return Tổng số questions
     */
    @Query("SELECT COUNT(q) FROM Question q")
    Long countAllQuestions();

    /**
     * Lấy thống kê questions theo instructor
     * @return List array [instructorId, instructorName, questionCount]
     */
    @Query("SELECT q.quiz.course.instructor.id, q.quiz.course.instructor.fullName, COUNT(q) " +
            "FROM Question q " +
            "GROUP BY q.quiz.course.instructor.id, q.quiz.course.instructor.fullName " +
            "ORDER BY COUNT(q) DESC")
    List<Object[]> getQuestionCountByInstructor();

    // ===== BULK OPERATIONS HELPERS =====

    /**
     * Tìm questions có duplicate content trong quiz
     * @param quiz Quiz
     * @return List array [questionText, count]
     */
    @Query("SELECT q.questionText, COUNT(q) FROM Question q WHERE q.quiz = :quiz " +
            "GROUP BY q.questionText HAVING COUNT(q) > 1")
    List<Object[]> findDuplicateQuestions(@Param("quiz") Quiz quiz);

    /**
     * Tìm questions theo quiz với pagination (all questions)
     * @param quiz Quiz
     * @param pageable Pagination info
     * @return Page questions
     */
    Page<Question> findByQuizOrderByDisplayOrder(Quiz quiz, Pageable pageable);

    /**
     * Xóa tất cả questions của quiz
     * @param quiz Quiz
     */
    void deleteByQuiz(Quiz quiz);

    // ===== RANDOM SELECTION =====

    /**
     * Tìm random questions theo difficulty (for dynamic quiz generation)
     * @param quiz Quiz
     * @param difficultyLevel Difficulty level
     * @param limit Số lượng cần lấy
     * @return Danh sách random questions
     */
    @Query(value = "SELECT * FROM questions q WHERE q.quiz_id = :quizId AND q.difficulty_level = :difficultyLevel " +
            "ORDER BY RAND() LIMIT :limit", nativeQuery = true)
    List<Question> findRandomQuestionsByDifficulty(@Param("quizId") Long quizId,
                                                   @Param("difficultyLevel") String difficultyLevel,
                                                   @Param("limit") int limit);

    /**
     * Tìm random questions từ quiz
     * @param quiz Quiz
     * @param limit Số lượng cần lấy
     * @return Danh sách random questions
     */
    @Query(value = "SELECT * FROM questions q WHERE q.quiz_id = :quizId " +
            "ORDER BY RAND() LIMIT :limit", nativeQuery = true)
    List<Question> findRandomQuestions(@Param("quizId") Long quizId, @Param("limit") int limit);
}