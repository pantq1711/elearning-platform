package com.coursemanagement.repository;

import com.coursemanagement.entity.Course;
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
     * Tìm quiz result theo student và quiz
     * @param student Student
     * @param quiz Quiz
     * @return Optional chứa QuizResult nếu tìm thấy
     */
    Optional<QuizResult> findByStudentAndQuiz(User student, Quiz quiz);

    /**
     * Kiểm tra student đã làm quiz chưa
     * @param student Student
     * @param quiz Quiz
     * @return true nếu đã làm
     */
    boolean existsByStudentAndQuiz(User student, Quiz quiz);

    // ===== STUDENT-RELATED QUERIES =====

    /**
     * Tìm quiz results theo student sắp xếp theo ngày làm
     * @param student Student
     * @return Danh sách quiz results
     */
    List<QuizResult> findByStudentOrderByAttemptDateDesc(User student);

    /**
     * Tìm quiz results theo student với pagination
     * @param student Student
     * @param pageable Pagination info
     * @return Page quiz results
     */
    Page<QuizResult> findByStudentOrderByAttemptDateDesc(User student, Pageable pageable);

    /**
     * Tìm completed quiz results theo student
     * @param student Student
     * @param completed Trạng thái completed
     * @return Danh sách completed quiz results
     */
    List<QuizResult> findByStudentAndCompletedOrderByCompletionTimeDesc(User student, boolean completed);

    /**
     * Tìm passed quiz results theo student
     * @param student Student
     * @param passed Trạng thái passed
     * @return Danh sách passed quiz results
     */
    List<QuizResult> findByStudentAndPassedOrderByCompletionTimeDesc(User student, boolean passed);

    /**
     * Đếm quiz results theo student
     * @param student Student
     * @return Số lượng quiz results
     */
    Long countByStudent(User student);

    /**
     * Đếm passed quiz results theo student
     * @param student Student
     * @param passed Trạng thái passed
     * @return Số lượng passed quiz results
     */
    Long countByStudentAndPassed(User student, boolean passed);

    /**
     * Đếm completed quiz results theo student
     * @param student Student
     * @param completed Trạng thái completed
     * @return Số lượng completed quiz results
     */
    Long countByStudentAndCompleted(User student, boolean completed);

    // ===== QUIZ-RELATED QUERIES =====

    /**
     * Tìm quiz results theo quiz sắp xếp theo điểm số
     * @param quiz Quiz
     * @return Danh sách quiz results
     */
    List<QuizResult> findByQuizOrderByScoreDesc(Quiz quiz);

    /**
     * Tìm quiz results theo quiz với pagination
     * @param quiz Quiz
     * @param pageable Pagination info
     * @return Page quiz results
     */
    Page<QuizResult> findByQuizOrderByAttemptDateDesc(Quiz quiz, Pageable pageable);

    /**
     * Đếm attempts theo quiz
     * @param quiz Quiz
     * @return Số lượng attempts
     */
    Long countByQuiz(Quiz quiz);

    /**
     * Đếm passed attempts theo quiz
     * @param quiz Quiz
     * @param passed Trạng thái passed
     * @return Số lượng passed attempts
     */
    Long countByQuizAndPassed(Quiz quiz, boolean passed);

    /**
     * Lấy điểm cao nhất theo quiz
     * @param quiz Quiz
     * @return Điểm cao nhất
     */
    @Query("SELECT MAX(qr.score) FROM QuizResult qr WHERE qr.quiz = :quiz AND qr.completed = true")
    Double findMaxScoreByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Lấy điểm trung bình theo quiz
     * @param quiz Quiz
     * @return Điểm trung bình
     */
    @Query("SELECT AVG(qr.score) FROM QuizResult qr WHERE qr.quiz = :quiz AND qr.completed = true")
    Double findAverageScoreByQuiz(@Param("quiz") Quiz quiz);

    // ===== COURSE-RELATED QUERIES =====

    /**
     * Đếm quiz attempts theo course
     * @param course Course
     * @return Số lượng attempts
     */
    @Query("SELECT COUNT(qr) FROM QuizResult qr WHERE qr.quiz.course = :course")
    Long countByCourseQuizzes(@Param("course") Course course);

    /**
     * Đếm passed attempts theo course
     * @param course Course
     * @return Số lượng passed attempts
     */
    @Query("SELECT COUNT(qr) FROM QuizResult qr WHERE qr.quiz.course = :course AND qr.passed = true")
    Long countPassedByCourse(@Param("course") Course course);

    /**
     * Lấy điểm trung bình theo course
     * @param course Course
     * @return Điểm trung bình
     */
    @Query("SELECT AVG(qr.score) FROM QuizResult qr WHERE qr.quiz.course = :course AND qr.completed = true")
    Double findAverageScoreByCourse(@Param("course") Course course);

    // ===== INSTRUCTOR-RELATED QUERIES =====

    /**
     * Tìm quiz results theo instructor với pagination
     * @param instructor Instructor
     * @param pageable Pagination info
     * @return Page quiz results
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.quiz.course.instructor = :instructor " +
            "ORDER BY qr.attemptDate DESC")
    Page<QuizResult> findByInstructor(@Param("instructor") User instructor, Pageable pageable);

    /**
     * Đếm quiz attempts theo instructor
     * @param instructor Instructor
     * @return Số lượng attempts
     */
    @Query("SELECT COUNT(qr) FROM QuizResult qr WHERE qr.quiz.course.instructor = :instructor")
    Long countByInstructor(@Param("instructor") User instructor);

    /**
     * Đếm passed attempts theo instructor
     * @param instructor Instructor
     * @return Số lượng passed attempts
     */
    @Query("SELECT COUNT(qr) FROM QuizResult qr WHERE qr.quiz.course.instructor = :instructor AND qr.passed = true")
    Long countPassedByInstructor(@Param("instructor") User instructor);

    // ===== SCORE-RELATED QUERIES =====

    /**
     * Tìm quiz results theo score range
     * @param minScore Score tối thiểu
     * @param maxScore Score tối đa
     * @param completed Trạng thái completed
     * @return Danh sách quiz results
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.completed = :completed " +
            "AND qr.score >= :minScore AND qr.score <= :maxScore " +
            "ORDER BY qr.score DESC")
    List<QuizResult> findByScoreRange(@Param("minScore") Double minScore,
                                      @Param("maxScore") Double maxScore,
                                      @Param("completed") boolean completed);

    /**
     * Tìm top performers (điểm cao nhất)
     * @param pageable Pagination info
     * @return Danh sách top performers
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.completed = true " +
            "ORDER BY qr.score DESC")
    List<QuizResult> findTopPerformers(Pageable pageable);

    /**
     * Lấy điểm trung bình theo student
     * @param student Student
     * @return Điểm trung bình
     */
    @Query("SELECT AVG(qr.score) FROM QuizResult qr WHERE qr.student = :student AND qr.completed = true")
    Double getAverageScoreByStudent(@Param("student") User student);

    // ===== TIME-BASED QUERIES =====

    /**
     * Tìm quiz results trong khoảng thời gian
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Danh sách quiz results
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.attemptDate >= :startDate AND qr.attemptDate <= :endDate " +
            "ORDER BY qr.attemptDate DESC")
    List<QuizResult> findByDateRange(@Param("startDate") LocalDateTime startDate,
                                     @Param("endDate") LocalDateTime endDate);

    /**
     * Tìm recent quiz results (trong X ngày gần đây)
     * @param startDate Ngày bắt đầu
     * @return Danh sách recent quiz results
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.attemptDate >= :startDate " +
            "ORDER BY qr.attemptDate DESC")
    List<QuizResult> findRecentResults(@Param("startDate") LocalDateTime startDate);

    /**
     * Đếm attempts trong tháng này
     * @param startDate Ngày đầu tháng
     * @return Số lượng attempts
     */
    @Query("SELECT COUNT(qr) FROM QuizResult qr WHERE qr.attemptDate >= :startDate")
    Long countAttemptsThisMonth(@Param("startDate") LocalDateTime startDate);

    // ===== STATISTICS METHODS =====

    /**
     * Lấy thống kê quiz results theo tháng
     * @param startDate Ngày bắt đầu
     * @return List array [month, year, attemptCount, passCount]
     */
    @Query("SELECT MONTH(qr.attemptDate), YEAR(qr.attemptDate), " +
            "COUNT(qr), COUNT(CASE WHEN qr.passed = true THEN 1 END) " +
            "FROM QuizResult qr " +
            "WHERE qr.attemptDate >= :startDate " +
            "GROUP BY YEAR(qr.attemptDate), MONTH(qr.attemptDate) " +
            "ORDER BY YEAR(qr.attemptDate), MONTH(qr.attemptDate)")
    List<Object[]> getQuizResultStatsByMonth(@Param("startDate") LocalDateTime startDate);

    /**
     * Lấy pass rate theo quiz
     * @return List array [quizId, quizTitle, totalAttempts, passedAttempts, passRate]
     */
    @Query("SELECT qr.quiz.id, qr.quiz.title, COUNT(qr), " +
            "COUNT(CASE WHEN qr.passed = true THEN 1 END), " +
            "(COUNT(CASE WHEN qr.passed = true THEN 1 END) * 100.0 / COUNT(qr)) as passRate " +
            "FROM QuizResult qr " +
            "GROUP BY qr.quiz.id, qr.quiz.title " +
            "ORDER BY passRate DESC")
    List<Object[]> getPassRateStatistics();

    /**
     * Lấy top students theo average score
     * @param pageable Pagination info
     * @return List array [studentId, studentName, averageScore, totalAttempts]
     */
    @Query("SELECT qr.student.id, qr.student.fullName, AVG(qr.score), COUNT(qr) " +
            "FROM QuizResult qr " +
            "WHERE qr.completed = true " +
            "GROUP BY qr.student.id, qr.student.fullName " +
            "HAVING COUNT(qr) >= 3 " +
            "ORDER BY AVG(qr.score) DESC")
    List<Object[]> findTopStudentsByAverageScore(Pageable pageable);

    // ===== ADVANCED ANALYTICS =====

    /**
     * Tìm quiz results cần review (điểm thấp)
     * @param maxScore Điểm tối đa để coi là cần review
     * @param instructor Instructor (optional)
     * @return Danh sách quiz results cần review
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.completed = true AND qr.score <= :maxScore " +
            "AND (:instructor IS NULL OR qr.quiz.course.instructor = :instructor) " +
            "ORDER BY qr.score ASC")
    List<QuizResult> findResultsNeedingReview(@Param("maxScore") Double maxScore,
                                              @Param("instructor") User instructor);

    /**
     * Tìm students struggling (nhiều lần fail)
     * @param minFailCount Số lần fail tối thiểu
     * @return List array [studentId, studentName, failCount]
     */
    @Query("SELECT qr.student.id, qr.student.fullName, COUNT(qr) " +
            "FROM QuizResult qr " +
            "WHERE qr.completed = true AND qr.passed = false " +
            "GROUP BY qr.student.id, qr.student.fullName " +
            "HAVING COUNT(qr) >= :minFailCount " +
            "ORDER BY COUNT(qr) DESC")
    List<Object[]> findStrugglingStudents(@Param("minFailCount") Long minFailCount);

    /**
     * Lấy completion rate overview
     * @return List array [totalAttempts, completedAttempts, passedAttempts]
     */
    @Query("SELECT COUNT(qr), " +
            "COUNT(CASE WHEN qr.completed = true THEN 1 END), " +
            "COUNT(CASE WHEN qr.passed = true THEN 1 END) " +
            "FROM QuizResult qr")
    List<Object[]> getCompletionRateOverview();
}