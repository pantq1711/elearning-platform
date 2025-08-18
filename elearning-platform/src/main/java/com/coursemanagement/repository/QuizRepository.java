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
 * Repository interface cho Quiz entity
 * Chứa các custom queries cho quiz management
 * SỬA LỖI: Đã bỏ method startQuiz gây lỗi và sửa các method trùng lặp
 */
@Repository
public interface QuizRepository extends JpaRepository<Quiz, Long> {

    // ===== BASIC FINDER METHODS =====

    /**
     * Tìm quiz theo ID và course (cho security)
     */
    Optional<Quiz> findByIdAndCourse(Long id, Course course);

    /**
     * Kiểm tra title quiz đã tồn tại trong course chưa
     */
    boolean existsByTitleAndCourse(String title, Course course);

    /**
     * Kiểm tra title quiz đã tồn tại trong course chưa (exclude ID hiện tại)
     */
    boolean existsByTitleAndCourseAndIdNot(String title, Course course, Long id);

    // ===== COURSE-RELATED QUERIES =====

    /**
     * Tìm quizzes theo course sắp xếp theo ngày tạo
     */
    List<Quiz> findByCourseOrderByCreatedAtDesc(Course course);

    /**
     * Tìm active quizzes theo course (với order by)
     */
    List<Quiz> findByCourseAndActiveOrderByCreatedAtDesc(Course course, boolean active);

    /**
     * Tìm active quizzes theo course (không order by)
     */
    List<Quiz> findByCourseAndActive(Course course, boolean active);

    /**
     * Tìm quizzes theo course ID và active status
     */
    List<Quiz> findByCourseIdAndActiveOrderByCreatedAtDesc(Long courseId, boolean active);

    /**
     * Tìm quizzes theo course với pagination
     */
    Page<Quiz> findByCourse(Course course, Pageable pageable);

    /**
     * Đếm quizzes theo course
     */
    Long countByCourse(Course course);

    /**
     * Đếm quizzes theo course (alternative method name)
     */
    Long countQuizzesByCourse(Course course);

    /**
     * Đếm active quizzes theo course
     */
    Long countByCourseAndActive(Course course, boolean active);

    /**
     * Đếm active quizzes theo course (alternative method name)
     */
    Long countActiveQuizzesByCourse(Course course);

    /**
     * Đếm quiz attempts cho course
     */
    @Query("SELECT COUNT(qr) FROM QuizResult qr WHERE qr.quiz.course = :course")
    Long countByCourseQuizzes(@Param("course") Course course);

    /**
     * Đếm passed quiz attempts cho course
     */
    @Query("SELECT COUNT(qr) FROM QuizResult qr WHERE qr.quiz.course = :course AND qr.passed = true")
    Long countPassedByCourse(@Param("course") Course course);

    // ===== INSTRUCTOR-RELATED QUERIES =====

    /**
     * Tìm quizzes theo instructor (List version)
     */
    @Query("SELECT q FROM Quiz q WHERE q.course.instructor = :instructor ORDER BY q.createdAt DESC")
    List<Quiz> findByInstructor(@Param("instructor") User instructor);

    /**
     * Tìm quizzes theo instructor với pagination
     */
    @Query("SELECT q FROM Quiz q WHERE q.course.instructor = :instructor ORDER BY q.createdAt DESC")
    Page<Quiz> findByInstructor(@Param("instructor") User instructor, Pageable pageable);

    /**
     * Tìm quizzes theo instructor với pagination (với active filter)
     */
    @Query("SELECT q FROM Quiz q WHERE q.course.instructor = :instructor AND q.active = true " +
            "ORDER BY q.createdAt DESC")
    List<Quiz> findQuizzesByInstructor(@Param("instructor") User instructor, Pageable pageable);

    /**
     * Đếm quizzes của instructor
     */
    @Query("SELECT COUNT(q) FROM Quiz q WHERE q.course.instructor = :instructor")
    Long countByInstructor(@Param("instructor") User instructor);

    /**
     * Đếm active quizzes của instructor
     */
    @Query("SELECT COUNT(q) FROM Quiz q WHERE q.course.instructor = :instructor AND q.active = :active")
    Long countByInstructorAndActive(@Param("instructor") User instructor, @Param("active") boolean active);

    /**
     * Đếm quizzes theo instructor (alternative method)
     */
    @Query("SELECT COUNT(q) FROM Quiz q WHERE q.course.instructor = :instructor AND q.active = true")
    Long countQuizzesByInstructor(@Param("instructor") User instructor);

    // ===== AVAILABILITY QUERIES =====

    /**
     * Tìm available quizzes (trong thời gian cho phép)
     */
    @Query("SELECT q FROM Quiz q WHERE q.course = :course AND q.active = true AND " +
            "(q.availableFrom IS NULL OR q.availableFrom <= :currentTime) AND " +
            "(q.availableUntil IS NULL OR q.availableUntil >= :currentTime)")
    List<Quiz> findAvailableQuizzes(@Param("course") Course course, @Param("currentTime") LocalDateTime currentTime);

    /**
     * Tìm quizzes available cho student (chưa làm và trong thời gian mở) - Version 1
     */
    @Query("SELECT q FROM Quiz q WHERE q.active = true " +
            "AND (q.availableFrom IS NULL OR q.availableFrom <= CURRENT_TIMESTAMP) " +
            "AND (q.availableUntil IS NULL OR q.availableUntil >= CURRENT_TIMESTAMP) " +
            "AND NOT EXISTS (SELECT qr FROM QuizResult qr WHERE qr.quiz = q AND qr.student.id = :studentId)")
    List<Quiz> findAvailableQuizzesForStudentById(@Param("studentId") Long studentId);

    /**
     * SỬA LỖI: Tìm available quizzes cho student (chưa làm hoặc có thể làm lại) - Version 2
     * Bỏ allowRetake field không tồn tại
     */
    @Query("SELECT q FROM Quiz q WHERE q.course.id IN " +
            "(SELECT e.course.id FROM Enrollment e WHERE e.student = :student) " +
            "AND q.active = true " +
            "AND q.id NOT IN (SELECT qr.quiz.id FROM QuizResult qr WHERE qr.student = :student AND qr.completed = true)")
    List<Quiz> findAvailableQuizzesForStudent(@Param("student") User student);

    /**
     * Tìm quizzes sắp hết hạn (trong khoảng thời gian)
     */
    @Query("SELECT q FROM Quiz q WHERE q.active = true AND q.availableUntil IS NOT NULL AND " +
            "q.availableUntil BETWEEN :beforeTime AND :currentTime")
    List<Quiz> findQuizzesExpiringBefore(@Param("beforeTime") LocalDateTime beforeTime,
                                         @Param("currentTime") LocalDateTime currentTime);

    /**
     * Tìm quizzes sắp hết hạn (expire trong X ngày)
     */
    @Query("SELECT q FROM Quiz q WHERE q.active = true AND q.availableUntil IS NOT NULL " +
            "AND q.availableUntil BETWEEN CURRENT_TIMESTAMP AND :expireDate")
    List<Quiz> findQuizzesExpiringWithin(@Param("expireDate") LocalDateTime expireDate);

    /**
     * Tìm quizzes chưa bắt đầu
     */
    @Query("SELECT q FROM Quiz q WHERE q.active = true AND q.availableFrom IS NOT NULL AND " +
            "q.availableFrom > :currentTime")
    List<Quiz> findUpcomingQuizzes(@Param("currentTime") LocalDateTime currentTime);

    // ===== SEARCH METHODS =====

    /**
     * Search quizzes theo title hoặc description trong course
     */
    @Query("SELECT q FROM Quiz q WHERE q.course = :course AND " +
            "(LOWER(q.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(q.description) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    List<Quiz> searchQuizzesInCourse(@Param("course") Course course, @Param("keyword") String keyword);

    /**
     * Search quizzes global với pagination
     */
    @Query("SELECT q FROM Quiz q WHERE q.active = true AND " +
            "(LOWER(q.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(q.description) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    Page<Quiz> searchQuizzes(@Param("keyword") String keyword, Pageable pageable);

    /**
     * Tìm quizzes theo title chứa keyword
     */
    @Query("SELECT q FROM Quiz q WHERE LOWER(q.title) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "ORDER BY q.createdAt DESC")
    Page<Quiz> findByTitleContainingIgnoreCase(@Param("keyword") String keyword, Pageable pageable);

    // ===== STUDENT-RELATED QUERIES =====

    /**
     * Tìm quizzes mà student chưa attempt
     */
    @Query("SELECT q FROM Quiz q WHERE q.course = :course AND q.active = true AND " +
            "q.id NOT IN (SELECT qr.quiz.id FROM QuizResult qr WHERE qr.student = :student)")
    List<Quiz> findUnattemptedQuizzesByStudent(@Param("student") User student, @Param("course") Course course);

    /**
     * Tìm quizzes mà student đã attempt
     */
    @Query("SELECT DISTINCT q FROM Quiz q JOIN q.quizResults qr " +
            "WHERE q.course = :course AND qr.student = :student")
    List<Quiz> findAttemptedQuizzesByStudent(@Param("student") User student, @Param("course") Course course);

    /**
     * Tìm quizzes mà student đã pass
     */
    @Query("SELECT DISTINCT q FROM Quiz q JOIN q.quizResults qr " +
            "WHERE q.course = :course AND qr.student = :student AND qr.passed = true")
    List<Quiz> findPassedQuizzesByStudent(@Param("student") User student, @Param("course") Course course);

    /**
     * Tìm completed quizzes cho student - Version 1 (by User object)
     */
    @Query("SELECT DISTINCT q FROM Quiz q JOIN q.quizResults qr " +
            "WHERE qr.student = :student AND qr.completed = true AND q.active = true " +
            "ORDER BY qr.completionTime DESC")
    List<Quiz> findCompletedQuizzesForStudent(@Param("student") User student);

    /**
     * Tìm completed quizzes cho student - Version 2 (by student ID)
     */
    @Query("SELECT DISTINCT qr.quiz FROM QuizResult qr WHERE qr.student.id = :studentId AND qr.completed = true " +
            "ORDER BY qr.completionTime DESC")
    List<Quiz> findCompletedQuizzesForStudentById(@Param("studentId") Long studentId);

    /**
     * Kiểm tra student đã làm quiz chưa - Version 1
     */
    @Query("SELECT CASE WHEN COUNT(qr) > 0 THEN true ELSE false END " +
            "FROM QuizResult qr WHERE qr.student = :student AND qr.quiz = :quiz AND qr.completed = true")
    boolean hasStudentTakenQuiz(@Param("student") User student, @Param("quiz") Quiz quiz);

    /**
     * Kiểm tra student đã làm quiz chưa - Version 2
     */
    @Query("SELECT COUNT(qr) > 0 FROM QuizResult qr WHERE qr.student = :student AND qr.quiz = :quiz")
    boolean existsByStudentAndQuiz(@Param("student") User student, @Param("quiz") Quiz quiz);

    /**
     * Tìm quiz result theo student và quiz - Version 1
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.student = :student AND qr.quiz = :quiz " +
            "ORDER BY qr.completionTime DESC LIMIT 1")
    Optional<QuizResult> findQuizResult(@Param("student") User student, @Param("quiz") Quiz quiz);

    /**
     * Tìm quiz result theo student và quiz - Version 2
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.student = :student AND qr.quiz = :quiz")
    Optional<QuizResult> findByStudentAndQuiz(@Param("student") User student, @Param("quiz") Quiz quiz);

    /**
     * Tìm quiz results theo student sắp xếp theo attempt date
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.student = :student ORDER BY qr.completionTime DESC")
    List<QuizResult> findByStudentOrderByAttemptDateDesc(@Param("student") User student);

    // ===== COUNT AND GENERAL QUERIES =====

    /**
     * Đếm tất cả quizzes active
     */
    @Query("SELECT COUNT(q) FROM Quiz q WHERE q.active = true")
    Long countAllActiveQuizzes();

    // ===== ANALYTICS QUERIES =====

    /**
     * Lấy thống kê quiz theo course
     */
    @Query("SELECT " +
            "COUNT(q) as totalQuizzes, " +
            "COUNT(CASE WHEN q.active = true THEN 1 END) as activeQuizzes, " +
            "AVG(q.duration) as averageDuration, " +
            "AVG(q.maxScore) as averageMaxScore " +
            "FROM Quiz q WHERE q.course = :course")
    Object[] getQuizStatsByCourse(@Param("course") Course course);

    /**
     * Lấy quiz performance stats
     */
    @Query("SELECT " +
            "COUNT(qr) as totalAttempts, " +
            "AVG(qr.score) as averageScore, " +
            "COUNT(CASE WHEN qr.passed = true THEN 1 END) as passedCount, " +
            "MIN(qr.score) as minScore, " +
            "MAX(qr.score) as maxScore " +
            "FROM QuizResult qr WHERE qr.quiz = :quiz")
    Object[] getQuizPerformanceStats(@Param("quiz") Quiz quiz);




    /**
     * Lấy quizzes theo difficulty level (dựa trên pass score)
     */
    @Query("SELECT q FROM Quiz q WHERE q.active = true AND " +
            "(q.passScore / q.maxScore * 100) BETWEEN :minPassScorePercent AND :maxPassScorePercent")
    List<Quiz> findQuizzesByDifficultyRange(@Param("minPassScorePercent") double minPassScorePercent,
                                            @Param("maxPassScorePercent") double maxPassScorePercent);

    /**
     * Lấy quizzes chưa có câu hỏi
     */
    @Query("SELECT q FROM Quiz q WHERE q.active = true AND " +
            "(SELECT COUNT(qu) FROM Question qu WHERE qu.quiz = q) = 0")
    List<Quiz> findEmptyQuizzes();

    /**
     * SỬA LỖI: Lấy average completion time cho quiz
     * Sử dụng native query để tính chênh lệch thời gian
     */
    @Query(value = "SELECT AVG(TIMESTAMPDIFF(SECOND, qr.start_time, qr.completion_time)) " +
            "FROM quiz_results qr " +
            "WHERE qr.quiz_id = :quizId AND qr.start_time IS NOT NULL AND qr.completion_time IS NOT NULL",
            nativeQuery = true)
    Double getAverageCompletionTime(@Param("quizId") Long quizId);

    /**
     * Lấy pass rate của quiz
     */
    @Query("SELECT CASE WHEN COUNT(qr) = 0 THEN 0.0 ELSE " +
            "CAST(COUNT(CASE WHEN qr.passed = true THEN 1 END) AS double) / COUNT(qr) END " +
            "FROM QuizResult qr WHERE qr.quiz = :quiz")
    Double getPassRate(@Param("quiz") Quiz quiz);

    /**
     * Lấy quiz attempts trong khoảng thời gian
     */
    @Query("SELECT COUNT(qr) FROM QuizResult qr WHERE qr.quiz = :quiz AND " +
            "qr.completionTime BETWEEN :startDate AND :endDate")
    Long countAttemptsBetweenDates(@Param("quiz") Quiz quiz,
                                   @Param("startDate") LocalDateTime startDate,
                                   @Param("endDate") LocalDateTime endDate);

    /**
     * Lấy average score của quiz
     */
    @Query("SELECT AVG(qr.score) FROM QuizResult qr WHERE qr.quiz = :quiz")
    Double getAverageScore(@Param("quiz") Quiz quiz);

    /**
     * Lấy highest score của quiz
     */
    @Query("SELECT MAX(qr.score) FROM QuizResult qr WHERE qr.quiz = :quiz")
    Double getHighestScore(@Param("quiz") Quiz quiz);

    /**
     * Lấy lowest score của quiz
     */
    @Query("SELECT MIN(qr.score) FROM QuizResult qr WHERE qr.quiz = :quiz")
    Double getLowestScore(@Param("quiz") Quiz quiz);

    /**
     * Đếm students đã attempt quiz
     */
    @Query("SELECT COUNT(DISTINCT qr.student) FROM QuizResult qr WHERE qr.quiz = :quiz")
    Long countAttemptsByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Tìm recent quiz results với pagination
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.quiz = :quiz ORDER BY qr.completionTime DESC")
    Page<QuizResult> findRecentResultsByQuiz(@Param("quiz") Quiz quiz, Pageable pageable);
    /**
     * SỬA LỖI N+1: Tìm quizzes theo instructor với FETCH JOIN
     * Eager load course và category để tránh lazy loading
     */
    @Query("SELECT DISTINCT q FROM Quiz q " +
            "LEFT JOIN FETCH q.course c " +
            "LEFT JOIN FETCH c.category " +
            "LEFT JOIN FETCH c.instructor " +
            "WHERE c.instructor = :instructor AND q.active = true " +
            "ORDER BY q.createdAt DESC")
    List<Quiz> findQuizzesByInstructorWithDetails(@Param("instructor") User instructor);

    /**
     * SỬA LỖI: Tìm tất cả quizzes theo instructor với FETCH JOIN
     */
    @Query("SELECT DISTINCT q FROM Quiz q " +
            "LEFT JOIN FETCH q.course c " +
            "LEFT JOIN FETCH c.category " +
            "LEFT JOIN FETCH c.instructor " +
            "WHERE c.instructor = :instructor " +
            "ORDER BY q.createdAt DESC")
    List<Quiz> findAllQuizzesByInstructorWithDetails(@Param("instructor") User instructor);
}