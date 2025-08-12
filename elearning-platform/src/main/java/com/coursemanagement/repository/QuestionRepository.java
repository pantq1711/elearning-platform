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
     * Lấy câu hỏi đầu tiên của quiz
     * @param quiz Quiz
     * @return Optional<Question>
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz ORDER BY q.id ASC LIMIT 1")
    Optional<Question> findFirstQuestionByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Lấy câu hỏi cuối cùng của quiz
     * @param quiz Quiz
     * @return Optional<Question>
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz ORDER BY q.id DESC LIMIT 1")
    Optional<Question> findLastQuestionByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Tìm câu hỏi tiếp theo
     * @param quiz Quiz
     * @param currentId ID câu hỏi hiện tại
     * @return Optional<Question>
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz AND q.id > :currentId " +
            "ORDER BY q.id ASC LIMIT 1")
    Optional<Question> findNextQuestion(@Param("quiz") Quiz quiz, @Param("currentId") Long currentId);

    /**
     * Tìm câu hỏi trước đó
     * @param quiz Quiz
     * @param currentId ID câu hỏi hiện tại
     * @return Optional<Question>
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz AND q.id < :currentId " +
            "ORDER BY q.id DESC LIMIT 1")
    Optional<Question> findPreviousQuestion(@Param("quiz") Quiz quiz, @Param("currentId") Long currentId);

    /**
     * Lấy thống kê phân bố đáp án đúng
     * @param quiz Quiz
     * @return Danh sách [CorrectOption, QuestionCount]
     */
    @Query("SELECT q.correctOption, COUNT(q) FROM Question q WHERE q.quiz = :quiz " +
            "GROUP BY q.correctOption ORDER BY q.correctOption")
    List<Object[]> getAnswerDistributionByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Tìm câu hỏi có giải thích
     * @param quiz Quiz
     * @return Danh sách câu hỏi có giải thích
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz " +
            "AND q.explanation IS NOT NULL AND q.explanation != '' ORDER BY q.id ASC")
    List<Question> findQuestionsWithExplanation(@Param("quiz") Quiz quiz);

    /**
     * Tìm câu hỏi không có giải thích
     * @param quiz Quiz
     * @return Danh sách câu hỏi không có giải thích
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz " +
            "AND (q.explanation IS NULL OR q.explanation = '') ORDER BY q.id ASC")
    List<Question> findQuestionsWithoutExplanation(@Param("quiz") Quiz quiz);

    /**
     * Tìm câu hỏi theo độ dài nội dung
     * @param quiz Quiz
     * @param minLength Độ dài tối thiểu
     * @param maxLength Độ dài tối đa
     * @return Danh sách câu hỏi trong khoảng độ dài
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz " +
            "AND LENGTH(q.questionText) BETWEEN :minLength AND :maxLength ORDER BY q.id ASC")
    List<Question> findQuestionsByTextLength(@Param("quiz") Quiz quiz,
                                             @Param("minLength") int minLength,
                                             @Param("maxLength") int maxLength);

    /**
     * Tìm câu hỏi theo giảng viên
     * @param instructorId ID giảng viên
     * @return Danh sách câu hỏi của giảng viên
     */
    @Query("SELECT q FROM Question q WHERE q.quiz.course.instructor.id = :instructorId " +
            "ORDER BY q.quiz.title, q.id ASC")
    List<Question> findQuestionsByInstructorId(@Param("instructorId") Long instructorId);

    /**
     * Đếm tổng số câu hỏi của giảng viên
     * @param instructorId ID giảng viên
     * @return Số lượng câu hỏi
     */
    @Query("SELECT COUNT(q) FROM Question q WHERE q.quiz.course.instructor.id = :instructorId")
    long countQuestionsByInstructorId(@Param("instructorId") Long instructorId);

    /**
     * Tìm câu hỏi theo danh mục khóa học
     * @param categoryId ID danh mục
     * @return Danh sách câu hỏi theo danh mục
     */
    @Query("SELECT q FROM Question q WHERE q.quiz.course.category.id = :categoryId " +
            "ORDER BY q.quiz.title, q.id ASC")
    List<Question> findQuestionsByCategoryId(@Param("categoryId") Long categoryId);

    /**
     * Đếm số câu hỏi theo danh mục
     * @param categoryId ID danh mục
     * @return Số lượng câu hỏi
     */
    @Query("SELECT COUNT(q) FROM Question q WHERE q.quiz.course.category.id = :categoryId")
    long countQuestionsByCategoryId(@Param("categoryId") Long categoryId);

    /**
     * Tìm câu hỏi được tạo gần đây nhất
     * @param limit Số lượng câu hỏi cần lấy
     * @return Danh sách câu hỏi mới nhất
     */
    @Query("SELECT q FROM Question q ORDER BY q.createdAt DESC LIMIT :limit")
    List<Question> findRecentQuestions(@Param("limit") int limit);

    /**
     * Tìm câu hỏi theo khoảng thời gian tạo
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Danh sách câu hỏi trong khoảng thời gian
     */
    @Query("SELECT q FROM Question q WHERE q.createdAt BETWEEN :startDate AND :endDate " +
            "ORDER BY q.createdAt DESC")
    List<Question> findQuestionsByDateRange(@Param("startDate") java.time.LocalDateTime startDate,
                                            @Param("endDate") java.time.LocalDateTime endDate);

    /**
     * Lấy số lượng câu hỏi được tạo trong tháng hiện tại
     * @return Số lượng câu hỏi mới
     */
    @Query("SELECT COUNT(q) FROM Question q WHERE " +
            "YEAR(q.createdAt) = YEAR(CURRENT_DATE) AND " +
            "MONTH(q.createdAt) = MONTH(CURRENT_DATE)")
    long countQuestionsCreatedThisMonth();

    /**
     * Tìm câu hỏi có tất cả đáp án giống nhau (câu hỏi có vấn đề)
     * @param quiz Quiz
     * @return Danh sách câu hỏi có vấn đề
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz " +
            "AND (q.optionA = q.optionB OR q.optionA = q.optionC OR q.optionA = q.optionD " +
            "OR q.optionB = q.optionC OR q.optionB = q.optionD OR q.optionC = q.optionD)")
    List<Question> findProblematicQuestions(@Param("quiz") Quiz quiz);

    /**
     * Tìm câu hỏi theo từ khóa trong đáp án
     * @param quiz Quiz
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách câu hỏi có đáp án chứa từ khóa
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz " +
            "AND (LOWER(q.optionA) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "OR LOWER(q.optionB) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "OR LOWER(q.optionC) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "OR LOWER(q.optionD) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
            "ORDER BY q.id ASC")
    List<Question> findQuestionsByAnswerContent(@Param("quiz") Quiz quiz,
                                                @Param("keyword") String keyword);

    /**
     * Lấy thống kê câu hỏi theo tháng
     * @param year Năm cần thống kê
     * @return Danh sách [Month, QuestionCount]
     */
    @Query("SELECT MONTH(q.createdAt), COUNT(q) FROM Question q " +
            "WHERE YEAR(q.createdAt) = :year " +
            "GROUP BY MONTH(q.createdAt) " +
            "ORDER BY MONTH(q.createdAt)")
    List<Object[]> getQuestionStatisticsByMonth(@Param("year") int year);

    /**
     * Tìm câu hỏi theo giải thích có chứa từ khóa
     * @param quiz Quiz
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách câu hỏi có giải thích chứa từ khóa
     */
    @Query("SELECT q FROM Question q WHERE q.quiz = :quiz " +
            "AND LOWER(q.explanation) LIKE LOWER(CONCAT('%', :keyword, '%')) ORDER BY q.id ASC")
    List<Question> findQuestionsByExplanationContent(@Param("quiz") Quiz quiz,
                                                     @Param("keyword") String keyword);
}