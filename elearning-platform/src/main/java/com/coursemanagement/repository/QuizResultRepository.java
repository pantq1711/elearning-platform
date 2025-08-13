package com.coursemanagement.repository;

import com.coursemanagement.entity.Quiz;
import com.coursemanagement.entity.QuizResult;
import com.coursemanagement.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Repository interface cho QuizResult entity
 * Chứa các custom queries cho quiz result management và analytics
 */
@Repository
public interface QuizResultRepository extends JpaRepository<QuizResult, Long> {

    // ===== BASIC FINDER METHODS =====

    /**
     * Tìm quiz result theo user và quiz
     * @param user User
     * @param quiz Quiz
     * @return Optional chứa QuizResult nếu tìm thấy
     */
    Optional<QuizResult> findByUserAndQuiz(User user, Quiz quiz);

    /**
     * Tìm latest quiz result của user cho quiz
     * @param user User
     * @param quiz Quiz
     * @return Optional chứa latest QuizResult
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.user = :user AND qr.quiz = :quiz ORDER BY qr.submittedAt DESC")
    Optional<QuizResult> findLatestByUserAndQuiz(@Param("user") User user, @Param("quiz") Quiz quiz);

    /**
     * Kiểm tra user đã attempt quiz chưa
     * @param user User
     * @param quiz Quiz
     * @return true nếu đã attempt
     */
    boolean existsByUserAndQuiz(User user, Quiz quiz);

    // ===== USER-RELATED QUERIES =====

    /**
     * Tìm tất cả quiz results của user
     * @param user User
     * @return Danh sách quiz results
     */
    List<QuizResult> findByUser(User user);

    /**
     * Tìm quiz results của user sắp xếp theo ngày submit
     * @param user User
     * @return Danh sách quiz results
     */
    List<QuizResult> findByUserOrderBySubmittedAtDesc(User user);

    /**
     * Tìm quiz results của user với pagination
     * @param user User
     * @param pageable Pagination info
     * @return Page chứa quiz results
     */
    Page<QuizResult> findByUser(User user, Pageable pageable);

    /**
     * Tìm passed quiz results của user
     * @param user User
     * @return Danh sách passed quiz results
     */
    List<QuizResult> findByUserAndPassed(User user, boolean passed);

    /**
     * Đếm quiz results của user
     * @param user User
     * @return Số lượng quiz results
     */
    Long countByUser(User user);

    /**
     * Đếm passed quiz results của user
     * @param user User
     * @return Số lượng passed quiz results
     */
    Long countByUserAndPassed(User user, boolean passed);

    // ===== QUIZ-RELATED QUERIES =====

    /**
     * Tìm tất cả quiz results của quiz
     * @param quiz Quiz
     * @return Danh sách quiz results
     */
    List<QuizResult> findByQuiz(Quiz quiz);

    /**
     * Tìm quiz results của quiz sắp xếp theo score
     * @param quiz Quiz
     * @return Danh sách quiz results theo score
     */
    List<QuizResult> findByQuizOrderByScoreDesc(Quiz quiz);

    /**
     * Tìm quiz results của quiz với pagination
     * @param quiz Quiz
     * @param pageable Pagination info
     * @return Page chứa quiz results
     */
    Page<QuizResult> findByQuiz(Quiz quiz, Pageable pageable);

    /**
     * Tìm top quiz results của quiz
     * @param quiz Quiz
     * @param limit Số lượng results
     * @return Danh sách top quiz results
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.quiz = :quiz ORDER BY qr.score DESC")
    List<QuizResult> findTopResultsByQuiz(@Param("quiz") Quiz quiz, @Param("limit") int limit);

    /**
     * Đếm quiz results của quiz
     * @param quiz Quiz
     * @return Số lượng quiz results
     */
    Long countByQuiz(Quiz quiz);

    /**
     * Đếm passed quiz results của quiz
     * @param quiz Quiz
     * @return Số lượng passed quiz results
     */
    Long countByQuizAndPassed(Quiz quiz, boolean passed);

    // ===== ANALYTICS QUERIES =====

    /**
     * Lấy average score của quiz
     * @param quiz Quiz
     * @return Average score
     */
    @Query("SELECT AVG(qr.score) FROM QuizResult qr WHERE qr.quiz = :quiz")
    Double getAverageScoreByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Lấy highest score của quiz
     * @param quiz Quiz
     * @return Highest score
     */
    @Query("SELECT MAX(qr.score) FROM QuizResult qr WHERE qr.quiz = :quiz")
    Double getHighestScoreByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Lấy lowest score của quiz
     * @param quiz Quiz
     * @return Lowest score
     */
    @Query("SELECT MIN(qr.score) FROM QuizResult qr WHERE qr.quiz = :quiz")
    Double getLowestScoreByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Lấy pass rate của quiz
     * @param quiz Quiz
     * @return Pass rate (0.0 - 1.0)
     */
    @Query("SELECT CASE WHEN COUNT(qr) = 0 THEN 0.0 ELSE " +
            "CAST(COUNT(CASE WHEN qr.passed = true THEN 1 END) AS double) / COUNT(qr) END " +
            "FROM QuizResult qr WHERE qr.quiz = :quiz")
    Double getPassRateByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Lấy average time taken của quiz
     * @param quiz Quiz
     * @return Average time taken (minutes)
     */
    @Query("SELECT AVG(qr.timeTaken) FROM QuizResult qr WHERE qr.quiz = :quiz AND qr.timeTaken IS NOT NULL")
    Double getAverageTimeTakenByQuiz(@Param("quiz") Quiz quiz);

    // ===== STUDENT PERFORMANCE QUERIES =====

    /**
     * Lấy quiz results của student trong course
     * @param user Student
     * @param courseId Course ID
     * @return Danh sách quiz results
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.user = :user AND qr.quiz.course.id = :courseId")
    List<QuizResult> findByUserAndCourseId(@Param("user") User user, @Param("courseId") Long courseId);

    /**
     * Lấy recent quiz results của student
     * @param user Student
     * @param limit Số lượng results
     * @return Danh sách recent quiz results
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.user = :user ORDER BY qr.submittedAt DESC")
    List<QuizResult> findRecentByUser(@Param("user") User user, @Param("limit") int limit);

    /**
     * Lấy average score của student
     * @param user Student
     * @return Average score
     */
    @Query("SELECT AVG(qr.score) FROM QuizResult qr WHERE qr.user = :user")
    Double getAverageScoreByUser(@Param("user") User user);

    /**
     * Lấy best score của student
     * @param user Student
     * @return Best score
     */
    @Query("SELECT MAX(qr.score) FROM QuizResult qr WHERE qr.user = :user")
    Double getBestScoreByUser(@Param("user") User user);

    /**
     * Lấy completion rate của student (quiz attempts vs enrollments)
     * @param user Student
     * @return Completion rate
     */
    @Query("SELECT COUNT(DISTINCT qr.quiz.course.id) FROM QuizResult qr WHERE qr.user = :user")
    Long countCoursesWithQuizAttemptsByUser(@Param("user") User user);

    // ===== TIME-BASED QUERIES =====

    /**
     * Tìm quiz results trong khoảng thời gian
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Danh sách quiz results
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.submittedAt BETWEEN :startDate AND :endDate")
    List<QuizResult> findResultsBetweenDates(@Param("startDate") LocalDateTime startDate,
                                             @Param("endDate") LocalDateTime endDate);

    /**
     * Lấy quiz results trong ngày hôm nay
     * @param startOfDay Đầu ngày
     * @param endOfDay Cuối ngày
     * @return Danh sách quiz results hôm nay
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.submittedAt BETWEEN :startOfDay AND :endOfDay")
    List<QuizResult> findTodayResults(@Param("startOfDay") LocalDateTime startOfDay,
                                      @Param("endOfDay") LocalDateTime endOfDay);

    /**
     * Lấy quiz results trong tuần này
     * @param startOfWeek Đầu tuần
     * @param endOfWeek Cuối tuần
     * @return Danh sách quiz results tuần này
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.submittedAt BETWEEN :startOfWeek AND :endOfWeek")
    List<QuizResult> findThisWeekResults(@Param("startOfWeek") LocalDateTime startOfWeek,
                                         @Param("endOfWeek") LocalDateTime endOfWeek);

    // ===== INSTRUCTOR ANALYTICS =====

    /**
     * Lấy quiz results của courses thuộc instructor
     * @param instructor Instructor
     * @return Danh sách quiz results
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.quiz.course.instructor = :instructor")
    List<QuizResult> findByInstructor(@Param("instructor") User instructor);

    /**
     * Lấy quiz results của instructor với pagination
     * @param instructor Instructor
     * @param pageable Pagination info
     * @return Page chứa quiz results
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.quiz.course.instructor = :instructor ORDER BY qr.submittedAt DESC")
    Page<QuizResult> findByInstructor(@Param("instructor") User instructor, Pageable pageable);

    /**
     * Đếm quiz results của instructor
     * @param instructor Instructor
     * @return Số lượng quiz results
     */
    @Query("SELECT COUNT(qr) FROM QuizResult qr WHERE qr.quiz.course.instructor = :instructor")
    Long countByInstructor(@Param("instructor") User instructor);

    /**
     * Lấy average score của instructor's quizzes
     * @param instructor Instructor
     * @return Average score
     */
    @Query("SELECT AVG(qr.score) FROM QuizResult qr WHERE qr.quiz.course.instructor = :instructor")
    Double getAverageScoreByInstructor(@Param("instructor") User instructor);

    // ===== SCORE DISTRIBUTION QUERIES =====

    /**
     * Lấy score distribution của quiz
     * @param quiz Quiz
     * @return Danh sách [ScoreRange, Count]
     */
    @Query("SELECT " +
            "CASE " +
            "WHEN qr.score < 20 THEN '0-20%' " +
            "WHEN qr.score < 40 THEN '20-40%' " +
            "WHEN qr.score < 60 THEN '40-60%' " +
            "WHEN qr.score < 80 THEN '60-80%' " +
            "ELSE '80-100%' END as scoreRange, " +
            "COUNT(qr) " +
            "FROM QuizResult qr WHERE qr.quiz = :quiz " +
            "GROUP BY " +
            "CASE " +
            "WHEN qr.score < 20 THEN '0-20%' " +
            "WHEN qr.score < 40 THEN '20-40%' " +
            "WHEN qr.score < 60 THEN '40-60%' " +
            "WHEN qr.score < 80 THEN '60-80%' " +
            "ELSE '80-100%' END")
    List<Object[]> getScoreDistributionByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Lấy monthly quiz attempt statistics
     * @return Danh sách [Year, Month, Count]
     */
    @Query("SELECT YEAR(qr.submittedAt), MONTH(qr.submittedAt), COUNT(qr) " +
            "FROM QuizResult qr " +
            "GROUP BY YEAR(qr.submittedAt), MONTH(qr.submittedAt) " +
            "ORDER BY YEAR(qr.submittedAt) DESC, MONTH(qr.submittedAt) DESC")
    List<Object[]> getMonthlyAttemptStats();

    /**
     * Lấy leaderboard cho quiz
     * @param quiz Quiz
     * @param limit Số lượng top users
     * @return Danh sách [User, Score, SubmittedAt]
     */
    @Query("SELECT qr.user, qr.score, qr.submittedAt FROM QuizResult qr " +
            "WHERE qr.quiz = :quiz " +
            "ORDER BY qr.score DESC, qr.submittedAt ASC")
    List<Object[]> getQuizLeaderboard(@Param("quiz") Quiz quiz, @Param("limit") int limit);

    /**
     * Tìm struggling students (low scores)
     * @param maxScore Score threshold
     * @return Danh sách struggling students
     */
    @Query("SELECT qr.user, AVG(qr.score) as avgScore FROM QuizResult qr " +
            "GROUP BY qr.user " +
            "HAVING AVG(qr.score) < :maxScore " +
            "ORDER BY avgScore ASC")
    List<Object[]> findStrugglingstudents(@Param("maxScore") double maxScore);
}