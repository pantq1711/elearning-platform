package com.coursemanagement.repository;

import com.coursemanagement.entity.Question;
import com.coursemanagement.entity.Quiz;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository interface để thao tác với bảng questions
 * Kế thừa JpaRepository để có sẵn các method CRUD cơ bản
 */
@Repository
public interface QuestionRepository extends JpaRepository<Question, Long> {

    /**
     * Tìm tất cả câu hỏi theo bài kiểm tra
     * @param quiz Bài kiểm tra
     * @return Danh sách câu hỏi sắp xếp theo ID (thứ tự tạo)
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz ORDER BY q.id ASC")
    List<Question> findByQuizOrderById(@Param("quiz") Quiz quiz);

    /**
     * Tìm câu hỏi theo ID và bài kiểm tra (để đảm bảo quyền truy cập)
     * @param id ID của câu hỏi
     * @param quiz Bài kiểm tra
     * @return Optional<Question>
     */
    Optional<Question> findByIdAndQuiz(Long id, Quiz quiz);

    /**
     * Tìm câu hỏi theo nội dung có chứa từ khóa
     * @param quiz Bài kiểm tra
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách câu hỏi chứa từ khóa
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz " +
            "AND LOWER(q.questionText) LIKE LOWER(CONCAT('%', :keyword, '%')) ORDER BY q.id ASC")
    List<Question> findByQuizAndQuestionTextContaining(@Param("quiz") Quiz quiz,
                                                       @Param("keyword") String keyword);

    /**
     * Đếm số câu hỏi trong bài kiểm tra
     * @param quiz Bài kiểm tra
     * @return Số lượng câu hỏi
     */
    long countByQuiz(Quiz quiz);

    /**
     * Tìm câu hỏi theo đáp án đúng
     * @param quiz Bài kiểm tra
     * @param correctOption Đáp án đúng (A, B, C, D)
     * @return Danh sách câu hỏi có đáp án đúng đó
     */
    List<Question> findByQuizAndCorrectOption(Quiz quiz, String correctOption);

    /**
     * Đếm số câu hỏi theo từng đáp án đúng
     * @param quiz Bài kiểm tra
     * @return Danh sách Object[] với format: [String correctOption, Long count]
     */
    @Query("SELECT q.correctOption, COUNT(q) FROM Question q WHERE q.quiz = :quiz " +
            "GROUP BY q.correctOption ORDER BY q.correctOption")
    List<Object[]> countQuestionsByCorrectOption(@Param("quiz") Quiz quiz);

    /**
     * Tìm câu hỏi có giải thích
     * @param quiz Bài kiểm tra
     * @return Danh sách câu hỏi có giải thích
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz " +
            "AND q.explanation IS NOT NULL AND q.explanation != '' ORDER BY q.id ASC")
    List<Question> findByQuizWithExplanation(@Param("quiz") Quiz quiz);

    /**
     * Tìm câu hỏi không có giải thích
     * @param quiz Bài kiểm tra
     * @return Danh sách câu hỏi không có giải thích
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz " +
            "AND (q.explanation IS NULL OR q.explanation = '') ORDER BY q.id ASC")
    List<Question> findByQuizWithoutExplanation(@Param("quiz") Quiz quiz);

    /**
     * Đếm số câu hỏi có giải thích
     * @param quiz Bài kiểm tra
     * @return Số lượng câu hỏi có giải thích
     */
    @Query("SELECT COUNT(q) FROM Question q WHERE q.quiz = :quiz " +
            "AND q.explanation IS NOT NULL AND q.explanation != ''")
    long countQuestionsWithExplanation(@Param("quiz") Quiz quiz);

    /**
     * Lấy câu hỏi ngẫu nhiên từ bài kiểm tra
     * @param quiz Bài kiểm tra
     * @param limit Số lượng câu hỏi cần lấy
     * @return Danh sách câu hỏi ngẫu nhiên
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz ORDER BY RAND() LIMIT :limit")
    List<Question> findRandomQuestionsByQuiz(@Param("quiz") Quiz quiz, @Param("limit") int limit);

    /**
     * Tìm câu hỏi theo danh sách ID
     * @param ids Danh sách ID câu hỏi
     * @return Danh sách câu hỏi
     */
    @Query("SELECT q FROM Question q WHERE q.id IN :ids ORDER BY q.id ASC")
    List<Question> findByIdIn(@Param("ids") List<Long> ids);

    /**
     * Tìm câu hỏi đầu tiên trong bài kiểm tra
     * @param quiz Bài kiểm tra
     * @return Optional<Question> - câu hỏi đầu tiên
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz ORDER BY q.id ASC LIMIT 1")
    Optional<Question> findFirstQuestionByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Tìm câu hỏi cuối cùng trong bài kiểm tra
     * @param quiz Bài kiểm tra
     * @return Optional<Question> - câu hỏi cuối cùng
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz ORDER BY q.id DESC LIMIT 1")
    Optional<Question> findLastQuestionByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Tìm câu hỏi tiếp theo
     * @param quiz Bài kiểm tra
     * @param currentId ID câu hỏi hiện tại
     * @return Optional<Question> - câu hỏi tiếp theo
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz AND q.id > :currentId " +
            "ORDER BY q.id ASC LIMIT 1")
    Optional<Question> findNextQuestion(@Param("quiz") Quiz quiz, @Param("currentId") Long currentId);

    /**
     * Tìm câu hỏi trước đó
     * @param quiz Bài kiểm tra
     * @param currentId ID câu hỏi hiện tại
     * @return Optional<Question> - câu hỏi trước đó
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz AND q.id < :currentId " +
            "ORDER BY q.id DESC LIMIT 1")
    Optional<Question> findPreviousQuestion(@Param("quiz") Quiz quiz, @Param("currentId") Long currentId);

    /**
     * Tìm câu hỏi có nội dung dài nhất
     * @param quiz Bài kiểm tra
     * @return Optional<Question> - câu hỏi có nội dung dài nhất
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz " +
            "ORDER BY LENGTH(q.questionText) DESC LIMIT 1")
    Optional<Question> findQuestionWithLongestText(@Param("quiz") Quiz quiz);

    /**
     * Tìm câu hỏi có nội dung ngắn nhất
     * @param quiz Bài kiểm tra
     * @return Optional<Question> - câu hỏi có nội dung ngắn nhất
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz " +
            "ORDER BY LENGTH(q.questionText) ASC LIMIT 1")
    Optional<Question> findQuestionWithShortestText(@Param("quiz") Quiz quiz);

    /**
     * Kiểm tra bài kiểm tra có đủ câu hỏi không
     * @param quiz Bài kiểm tra
     * @param minQuestions Số câu hỏi tối thiểu
     * @return true nếu đủ câu hỏi, false nếu không đủ
     */
    @Query("SELECT CASE WHEN COUNT(q) >= :minQuestions THEN true ELSE false END " +
            "FROM Question q WHERE q.quiz = :quiz")
    boolean hasEnoughQuestions(@Param("quiz") Quiz quiz, @Param("minQuestions") int minQuestions);

    /**
     * Lấy thống kê độ dài nội dung câu hỏi
     * @param quiz Bài kiểm tra
     * @return Danh sách Object[] với format: [Long questionId, Integer textLength]
     */
    @Query("SELECT q.id, LENGTH(q.questionText) as textLength FROM Question q " +
            "WHERE q.quiz = :quiz ORDER BY textLength DESC")
    List<Object[]> getQuestionLengthStatistics(@Param("quiz") Quiz quiz);

    /**
     * Tìm câu hỏi trùng lặp nội dung trong bài kiểm tra
     * @param quiz Bài kiểm tra
     * @return Danh sách câu hỏi có nội dung trùng lặp
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz AND q.questionText IN " +
            "(SELECT q2.questionText FROM Question q2 WHERE q2.quiz = :quiz " +
            "GROUP BY q2.questionText HAVING COUNT(q2.questionText) > 1)")
    List<Question> findDuplicateQuestionsByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Xóa tất cả câu hỏi của bài kiểm tra
     * @param quiz Bài kiểm tra
     */
    void deleteByQuiz(Quiz quiz);

    /**
     * Đếm tổng số câu hỏi trong hệ thống
     * @return Tổng số câu hỏi
     */
    @Query("SELECT COUNT(q) FROM Question q")
    long countAllQuestions();

    /**
     * Lấy câu hỏi mới nhất được tạo
     * @param limit Số lượng câu hỏi cần lấy
     * @return Danh sách câu hỏi mới nhất
     */
    @Query("SELECT q FROM Question q ORDER BY q.createdAt DESC LIMIT :limit")
    List<Question> findLatestQuestions(@Param("limit") int limit);
}