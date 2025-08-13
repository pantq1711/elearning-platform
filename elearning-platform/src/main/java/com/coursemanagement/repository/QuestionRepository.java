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
 * Cập nhật với đầy đủ methods cần thiết
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

    // ===== SEARCH METHODS =====

    /**
     * Tìm questions theo quiz và question text chứa keyword (không phân biệt hoa thường)
     * @param quiz Quiz chứa questions
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách questions tìm thấy
     */
    List<Question> findByQuizAndQuestionTextContainingIgnoreCase(Quiz quiz, String keyword);

    /**
     * Tìm questions theo quiz và question text chứa keyword với pagination
     * @param quiz Quiz chứa questions
     * @param keyword Từ khóa tìm kiếm
     * @param pageable Pagination info
     * @return Page chứa questions tìm thấy
     */
    Page<Question> findByQuizAndQuestionTextContainingIgnoreCase(Quiz quiz, String keyword, Pageable pageable);

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
     * @return Page chứa questions
     */
    Page<Question> findByQuizAndDifficultyLevel(Quiz quiz, Question.DifficultyLevel difficultyLevel, Pageable pageable);

    // ===== QUESTION TYPE QUERIES =====

    /**
     * Tìm questions theo quiz và question type
     * @param quiz Quiz
     * @param questionType Loại câu hỏi
     * @return Danh sách questions
     */
    List<Question> findByQuizAndQuestionType(Quiz quiz, QuestionType questionType);

    /**
     * Đếm questions theo question type
     * @param quiz Quiz
     * @param questionType Loại câu hỏi
     * @return Số lượng questions
     */
    Long countByQuizAndQuestionType(Quiz quiz, QuestionType questionType);

    // ===== POINTS QUERIES =====

    /**
     * Tìm questions theo quiz sắp xếp theo points giảm dần
     * @param quiz Quiz
     * @return Danh sách questions theo points
     */
    List<Question> findByQuizOrderByPointsDesc(Quiz quiz);

    /**
     * Tính tổng points của tất cả questions trong quiz
     * @param quiz Quiz
     * @return Tổng points
     */
    @Query("SELECT SUM(q.points) FROM Question q WHERE q.quiz = :quiz")
    Double sumPointsByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Lấy question có points cao nhất trong quiz
     * @param quiz Quiz
     * @return Optional chứa question có points cao nhất
     */
    Optional<Question> findTopByQuizOrderByPointsDesc(Quiz quiz);

    // ===== ADVANCED QUERIES =====

    /**
     * Tìm questions theo multiple filters
     * @param quiz Quiz
     * @param difficultyLevel Độ khó (có thể null)
     * @param questionType Loại câu hỏi (có thể null)
     * @param minPoints Điểm tối thiểu (có thể null)
     * @param maxPoints Điểm tối đa (có thể null)
     * @return Danh sách questions phù hợp
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
     * @param quiz Quiz
     * @param tag Tag cần tìm
     * @return Danh sách questions có tag
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz AND q.tags LIKE CONCAT('%', :tag, '%')")
    List<Question> findByQuizAndTagsContaining(@Param("quiz") Quiz quiz, @Param("tag") String tag);

    /**
     * Lấy thống kê questions theo difficulty level
     * @param quiz Quiz
     * @return Danh sách thống kê [DifficultyLevel, Count]
     */
    @Query("SELECT q.difficultyLevel, COUNT(q) FROM Question q WHERE q.quiz = :quiz GROUP BY q.difficultyLevel")
    List<Object[]> getQuestionStatsByDifficulty(@Param("quiz") Quiz quiz);

    /**
     * Lấy thống kê questions theo question type
     * @param quiz Quiz
     * @return Danh sách thống kê [QuestionType, Count]
     */
    @Query("SELECT q.questionType, COUNT(q) FROM Question q WHERE q.quiz = :quiz GROUP BY q.questionType")
    List<Object[]> getQuestionStatsByType(@Param("quiz") Quiz quiz);

    /**
     * Tìm random questions từ quiz
     * @param quiz Quiz
     * @param limit Số lượng questions
     * @return Danh sách random questions
     */
    @Query(value = "SELECT * FROM questions q WHERE q.quiz_id = :quizId ORDER BY RAND() LIMIT :limit",
            nativeQuery = true)
    List<Question> findRandomQuestionsByQuiz(@Param("quizId") Long quizId, @Param("limit") int limit);

    /**
     * Kiểm tra có question nào trong quiz có image không
     * @param quiz Quiz
     * @return true nếu có question có image
     */
    @Query("SELECT COUNT(q) > 0 FROM Question q WHERE q.quiz = :quiz AND q.imageUrl IS NOT NULL")
    boolean hasQuestionsWithImages(@Param("quiz") Quiz quiz);

    /**
     * Lấy next display order cho question mới
     * @param quiz Quiz
     * @return Display order tiếp theo
     */
    @Query("SELECT COALESCE(MAX(q.displayOrder), 0) + 1 FROM Question q WHERE q.quiz = :quiz")
    Integer getNextDisplayOrder(@Param("quiz") Quiz quiz);
}