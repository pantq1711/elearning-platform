package com.coursemanagement.repository;

import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.Quiz;
import com.coursemanagement.entity.QuizResult;
import com.coursemanagement.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Repository interface cho QuizResult entity
 * Chứa các custom queries cho quiz result management và analytics
 * Đã sửa tất cả lỗi compilation và entity field names
 */
@Repository
public interface QuizResultRepository extends JpaRepository<QuizResult, Long> {

    // ===== BASIC FINDER METHODS =====

    /**
     * Tìm quiz result theo student và quiz
     * @param student User entity (student)
     * @param quiz Quiz entity
     * @return Optional chứa QuizResult nếu tìm thấy
     */
    Optional<QuizResult> findByStudentAndQuiz(User student, Quiz quiz);

    /**
     * Tìm quiz results theo student và quiz sắp xếp theo completion time
     * @param student User entity (student)
     * @param quiz Quiz entity
     * @return List QuizResult sắp xếp theo completion time giảm dần
     */
    List<QuizResult> findByStudentAndQuizOrderByCompletionTimeDesc(User student, Quiz quiz);

    /**
     * Tìm quiz results theo student với pagination
     * @param student User entity (student)
     * @param pageable Pagination parameters
     * @return List QuizResult với pagination
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.student = :student " +
            "ORDER BY qr.completionTime DESC")
    List<QuizResult> findByStudentOrderByCompletionTimeDesc(@Param("student") User student, Pageable pageable);

    /**
     * Tìm quiz results theo quiz
     * @param quiz Quiz entity
     * @return List tất cả QuizResult cho quiz này
     */
    List<QuizResult> findByQuiz(Quiz quiz);

    /**
     * Đếm quiz results theo quiz
     * @param quiz Quiz entity
     * @return Số lượng quiz results
     */
    Long countByQuiz(Quiz quiz);

    /**
     * Đếm quiz results theo quiz và passed status
     * @param quiz Quiz entity
     * @param passed Pass/fail status
     * @return Số lượng quiz results theo status
     */
    Long countByQuizAndPassed(Quiz quiz, boolean passed);

    /**
     * Tính average score theo quiz
     * @param quiz Quiz entity
     * @return Average score hoặc null nếu không có data
     */
    @Query("SELECT AVG(qr.score) FROM QuizResult qr WHERE qr.quiz = :quiz AND qr.score IS NOT NULL")
    Double getAverageScoreByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Tìm latest quiz result của student cho quiz với pagination
     * @param student User entity (student)
     * @param quiz Quiz entity
     * @param pageable Pagination (thường limit 1)
     * @return Page chứa latest QuizResult
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.student = :student AND qr.quiz = :quiz " +
            "ORDER BY qr.completionTime DESC")
    Page<QuizResult> findQuizResultWithPagination(@Param("student") User student, @Param("quiz") Quiz quiz, Pageable pageable);

    /**
     * Wrapper method cho findQuizResult - tìm latest quiz result
     * @param student User entity (student)
     * @param quiz Quiz entity
     * @return Optional chứa latest QuizResult
     */
    default Optional<QuizResult> findQuizResult(User student, Quiz quiz) {
        Page<QuizResult> results = findQuizResultWithPagination(student, quiz, Pageable.ofSize(1));
        return results.hasContent() ? Optional.of(results.getContent().get(0)) : Optional.empty();
    }

    /**
     * Tìm recent quiz results theo student
     * @param student User entity (student)
     * @param pageable Pagination parameters
     * @return List QuizResult gần đây nhất
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.student = :student " +
            "AND qr.completionTime IS NOT NULL " +
            "ORDER BY qr.completionTime DESC")
    List<QuizResult> findRecentQuizResultsByStudent(@Param("student") User student, Pageable pageable);

    // ===== STATISTICS METHODS =====

    /**
     * Đếm tất cả quiz results
     * @return Tổng số quiz results trong hệ thống
     */
    @Query("SELECT COUNT(qr) FROM QuizResult qr")
    Long countAllQuizResults();

    /**
     * Đếm quiz results đã pass
     * @return Số lượng quiz results có passed = true
     */
    @Query("SELECT COUNT(qr) FROM QuizResult qr WHERE qr.passed = true")
    Long countPassedQuizResults();

    /**
     * Tính average score tổng thể
     * @return Average score của tất cả quiz results
     */
    @Query("SELECT AVG(qr.score) FROM QuizResult qr WHERE qr.score IS NOT NULL")
    Double getAverageScore();

    /**
     * Tìm best quiz results theo course
     * @param course Course entity
     * @param pageable Pagination parameters
     * @return List QuizResult có điểm cao nhất
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.quiz.course = :course " +
            "AND qr.passed = true ORDER BY qr.score DESC")
    List<QuizResult> findBestResultsByCourse(@Param("course") Course course, Pageable pageable);

    /**
     * Lấy thống kê quiz results theo tháng
     * @param fromDate Từ ngày nào
     * @return List thống kê theo năm, tháng
     */
    @Query("SELECT YEAR(qr.completionTime), MONTH(qr.completionTime), COUNT(qr), AVG(qr.score) " +
            "FROM QuizResult qr WHERE qr.completionTime >= :fromDate " +
            "GROUP BY YEAR(qr.completionTime), MONTH(qr.completionTime) " +
            "ORDER BY YEAR(qr.completionTime), MONTH(qr.completionTime)")
    List<Object[]> getQuizStatsByMonth(@Param("fromDate") LocalDateTime fromDate);

    // ===== COURSE STATISTICS =====

    /**
     * Đếm quiz results theo course ID
     * @param courseId Course ID
     * @return Số lượng quiz results
     */
    @Query("SELECT COUNT(qr) FROM QuizResult qr WHERE qr.quiz.course.id = :courseId")
    Long countByCourseId(@Param("courseId") Long courseId);

    /**
     * Đếm quiz results theo course ID và passed status
     * @param courseId Course ID
     * @param passed Pass/fail status
     * @return Số lượng quiz results theo status
     */
    @Query("SELECT COUNT(qr) FROM QuizResult qr WHERE qr.quiz.course.id = :courseId AND qr.passed = :passed")
    Long countByCourseIdAndPassed(@Param("courseId") Long courseId, @Param("passed") boolean passed);

    /**
     * Tìm course average scores
     * @param pageable Pagination parameters
     * @return List thống kê điểm trung bình theo course
     */
    @Query("SELECT qr.quiz.course.name, AVG(qr.score) FROM QuizResult qr " +
            "GROUP BY qr.quiz.course.id, qr.quiz.course.name ORDER BY AVG(qr.score) DESC")
    List<Object[]> findCourseAverageScores(Pageable pageable);

    /**
     * Đếm quiz results theo quiz và score threshold
     * @param quiz Quiz entity
     * @param minScore Điểm tối thiểu
     * @return Số lượng quiz results có điểm >= minScore
     */
    Long countByQuizAndScoreGreaterThanEqual(Quiz quiz, Double minScore);

    // ===== ADVANCED QUERIES =====

    /**
     * Tìm quiz results theo student với completed status
     * @param student User entity (student)
     * @return List QuizResult đã completed
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.student = :student AND qr.completed = true " +
            "ORDER BY qr.completionTime DESC")
    List<QuizResult> findCompletedByStudent(@Param("student") User student);

    /**
     * Tìm quiz results theo course và student
     * @param course Course entity
     * @param student User entity (student)
     * @return List QuizResult của student trong course
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.quiz.course = :course AND qr.student = :student " +
            "ORDER BY qr.completionTime DESC")
    List<QuizResult> findByCourseAndStudent(@Param("course") Course course, @Param("student") User student);

    /**
     * Kiểm tra student đã làm quiz chưa
     * @param student User entity (student)
     * @param quiz Quiz entity
     * @return true nếu đã làm, false nếu chưa
     */
    @Query("SELECT CASE WHEN COUNT(qr) > 0 THEN true ELSE false END " +
            "FROM QuizResult qr WHERE qr.student = :student AND qr.quiz = :quiz AND qr.completed = true")
    boolean hasStudentCompletedQuiz(@Param("student") User student, @Param("quiz") Quiz quiz);

    /**
     * Tìm top performers theo quiz
     * @param quiz Quiz entity
     * @param pageable Pagination parameters
     * @return List QuizResult có điểm cao nhất
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.quiz = :quiz AND qr.completed = true " +
            "ORDER BY qr.score DESC, qr.completionTime ASC")
    List<QuizResult> findTopPerformersByQuiz(@Param("quiz") Quiz quiz, Pageable pageable);

    /**
     * Tính completion rate theo quiz
     * @param quiz Quiz entity
     * @return Tỷ lệ hoàn thành (%)
     */
    @Query("SELECT CAST(COUNT(CASE WHEN qr.completed = true THEN 1 END) AS DOUBLE) / COUNT(qr) * 100 " +
            "FROM QuizResult qr WHERE qr.quiz = :quiz")
    Double getCompletionRateByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Tìm quiz results trong khoảng thời gian
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return List QuizResult trong khoảng thời gian
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.completionTime BETWEEN :startDate AND :endDate " +
            "ORDER BY qr.completionTime DESC")
    List<QuizResult> findByCompletionTimeBetween(@Param("startDate") LocalDateTime startDate,
                                                 @Param("endDate") LocalDateTime endDate);

    /**
     * Lấy daily quiz statistics
     * @param fromDate Từ ngày nào
     * @return List thống kê theo ngày
     */
    @Query("SELECT DATE(qr.completionTime), COUNT(qr), AVG(qr.score), " +
            "COUNT(CASE WHEN qr.passed = true THEN 1 END) " +
            "FROM QuizResult qr WHERE qr.completionTime >= :fromDate " +
            "GROUP BY DATE(qr.completionTime) " +
            "ORDER BY DATE(qr.completionTime)")
    List<Object[]> getDailyQuizStats(@Param("fromDate") LocalDateTime fromDate);

    // ===== DELETE OPERATIONS =====

    /**
     * Xóa quiz results theo quiz (khi xóa quiz)
     * @param quiz Quiz entity
     */
    @Modifying
    @Transactional
    @Query("DELETE FROM QuizResult qr WHERE qr.quiz = :quiz")
    void deleteByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Xóa quiz results theo student (khi xóa student)
     * @param student User entity (student)
     */
    @Modifying
    @Transactional
    @Query("DELETE FROM QuizResult qr WHERE qr.student = :student")
    void deleteByStudent(@Param("student") User student);

    /**
     * Reset quiz results theo quiz (để cho phép làm lại)
     * @param quiz Quiz entity
     */
    @Modifying
    @Transactional
    @Query("UPDATE QuizResult qr SET qr.completed = false, qr.score = 0, qr.passed = false " +
            "WHERE qr.quiz = :quiz")
    void resetQuizResults(@Param("quiz") Quiz quiz);

    /**
     * Tìm quiz results theo quiz và sắp xếp theo ngày attempt
     */
    List<QuizResult> findByQuizOrderByAttemptDateDesc(Quiz quiz);

    /**
     * Tìm quiz results theo quiz (không sắp xếp)
     */
    /**
     * Kiểm tra student đã làm quiz chưa
     */
    boolean existsByStudentAndQuiz(User student, Quiz quiz);

    /**
     * Đếm số lượng attempts của quiz
     */


    /**
     * Đếm số lượng passed attempts của quiz
     */
    @Query("SELECT COUNT(qr) FROM QuizResult qr WHERE qr.quiz = :quiz AND qr.passed = true")
    Long countPassedByQuiz(@Param("quiz") Quiz quiz);
}