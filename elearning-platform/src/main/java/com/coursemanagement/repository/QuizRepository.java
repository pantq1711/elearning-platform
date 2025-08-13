package com.coursemanagement.repository;

import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.Quiz;
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
 * Repository interface cho Quiz entity
 * Chứa các custom queries cho quiz management
 * Cập nhật với đầy đủ methods cần thiết
 */
@Repository
public interface QuizRepository extends JpaRepository<Quiz, Long> {

    // ===== BASIC FINDER METHODS =====

    /**
     * Tìm quiz theo ID và course (cho security)
     * @param id ID quiz
     * @param course Course chứa quiz
     * @return Optional chứa Quiz nếu tìm thấy
     */
    Optional<Quiz> findByIdAndCourse(Long id, Course course);

    /**
     * Kiểm tra title quiz đã tồn tại trong course chưa
     * @param title Title quiz
     * @param course Course
     * @return true nếu đã tồn tại
     */
    boolean existsByTitleAndCourse(String title, Course course);

    /**
     * Kiểm tra title quiz đã tồn tại trong course chưa (exclude ID hiện tại)
     * @param title Title quiz
     * @param course Course
     * @param id ID cần exclude
     * @return true nếu đã tồn tại
     */
    boolean existsByTitleAndCourseAndIdNot(String title, Course course, Long id);

    // ===== COURSE-RELATED QUERIES =====

    /**
     * Tìm quizzes theo course sắp xếp theo ngày tạo
     * @param course Course
     * @return Danh sách quizzes
     */
    List<Quiz> findByCourseOrderByCreatedAtDesc(Course course);

    /**
     * Tìm active quizzes theo course
     * @param course Course
     * @param active Trạng thái active
     * @return Danh sách active quizzes
     */
    List<Quiz> findByCourseAndActiveOrderByCreatedAtDesc(Course course, boolean active);

    /**
     * Tìm quizzes theo course với pagination
     * @param course Course
     * @param pageable Pagination info
     * @return Page chứa quizzes
     */
    Page<Quiz> findByCourse(Course course, Pageable pageable);

    /**
     * Đếm quizzes theo course
     * @param course Course
     * @return Số lượng quizzes
     */
    Long countQuizzesByCourse(Course course);

    /**
     * Đếm active quizzes theo course
     * @param course Course
     * @param active Trạng thái active
     * @return Số lượng active quizzes
     */
    Long countByCourseAndActive(Course course, boolean active);

    // ===== INSTRUCTOR-RELATED QUERIES =====

    /**
     * Tìm quizzes theo instructor
     * @param instructor Instructor
     * @param pageable Pagination info
     * @return Page chứa quizzes
     */
    @Query("SELECT q FROM Quiz q WHERE q.course.instructor = :instructor ORDER BY q.createdAt DESC")
    Page<Quiz> findByInstructor(@Param("instructor") User instructor, Pageable pageable);

    /**
     * Đếm quizzes của instructor
     * @param instructor Instructor
     * @return Số lượng quizzes
     */
    @Query("SELECT COUNT(q) FROM Quiz q WHERE q.course.instructor = :instructor")
    Long countByInstructor(@Param("instructor") User instructor);

    /**
     * Đếm active quizzes của instructor
     * @param instructor Instructor
     * @param active Trạng thái active
     * @return Số lượng active quizzes
     */
    @Query("SELECT COUNT(q) FROM Quiz q WHERE q.course.instructor = :instructor AND q.active = :active")
    Long countByInstructorAndActive(@Param("instructor") User instructor, @Param("active") boolean active);

    // ===== AVAILABILITY QUERIES =====

    /**
     * Tìm available quizzes (trong thời gian cho phép)
     * @param course Course
     * @param currentTime Thời gian hiện tại
     * @return Danh sách available quizzes
     */
    @Query("SELECT q FROM Quiz q WHERE q.course = :course AND q.active = true AND " +
            "(q.availableFrom IS NULL OR q.availableFrom <= :currentTime) AND " +
            "(q.availableUntil IS NULL OR q.availableUntil >= :currentTime)")
    List<Quiz> findAvailableQuizzes(@Param("course") Course course, @Param("currentTime") LocalDateTime currentTime);

    /**
     * Tìm quizzes sắp hết hạn
     * @param beforeTime Thời gian trước đó
     * @return Danh sách quizzes sắp hết hạn
     */
    @Query("SELECT q FROM Quiz q WHERE q.active = true AND q.availableUntil IS NOT NULL AND " +
            "q.availableUntil BETWEEN :beforeTime AND :currentTime")
    List<Quiz> findQuizzesExpiringBefore(@Param("beforeTime") LocalDateTime beforeTime,
                                         @Param("currentTime") LocalDateTime currentTime);

    /**
     * Tìm quizzes chưa bắt đầu
     * @param currentTime Thời gian hiện tại
     * @return Danh sách quizzes chưa bắt đầu
     */
    @Query("SELECT q FROM Quiz q WHERE q.active = true AND q.availableFrom IS NOT NULL AND " +
            "q.availableFrom > :currentTime")
    List<Quiz> findUpcomingQuizzes(@Param("currentTime") LocalDateTime currentTime);

    // ===== SEARCH METHODS =====

    /**
     * Search quizzes theo title hoặc description
     * @param course Course
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách quizzes tìm thấy
     */
    @Query("SELECT q FROM Quiz q WHERE q.course = :course AND " +
            "(LOWER(q.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(q.description) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    List<Quiz> searchQuizzesInCourse(@Param("course") Course course, @Param("keyword") String keyword);

    /**
     * Search quizzes global với pagination
     * @param keyword Từ khóa tìm kiếm
     * @param pageable Pagination info
     * @return Page chứa quizzes tìm thấy
     */
    @Query("SELECT q FROM Quiz q WHERE q.active = true AND " +
            "(LOWER(q.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(q.description) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    Page<Quiz> searchQuizzes(@Param("keyword") String keyword, Pageable pageable);

    // ===== ANALYTICS QUERIES =====

    /**
     * Lấy thống kê quiz theo course
     * @param course Course
     * @return Map chứa thống kê
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
     * @param quiz Quiz
     * @return Performance stats
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
     * Lấy recent quizzes với limit
     * @param limit Số lượng quizzes
     * @return Danh sách recent quizzes
     */
    @Query("SELECT q FROM Quiz q WHERE q.active = true ORDER BY q.createdAt DESC")
    List<Quiz> findRecentQuizzes(@Param("limit") int limit);

    /**
     * Lấy popular quizzes (nhiều attempts)
     * @param limit Số lượng quizzes
     * @return Danh sách popular quizzes
     */
    @Query("SELECT q, COUNT(qr) as attemptCount FROM Quiz q " +
            "LEFT JOIN q.quizResults qr " +
            "WHERE q.active = true " +
            "GROUP BY q " +
            "ORDER BY attemptCount DESC")
    List<Object[]> findPopularQuizzes(@Param("limit") int limit);

    /**
     * Lấy quizzes theo difficulty level (dựa trên pass score)
     * @param minPassScorePercent Minimum pass score percentage
     * @param maxPassScorePercent Maximum pass score percentage
     * @return Danh sách quizzes trong range difficulty
     */
    @Query("SELECT q FROM Quiz q WHERE q.active = true AND " +
            "(q.passScore / q.maxScore * 100) BETWEEN :minPassScorePercent AND :maxPassScorePercent")
    List<Quiz> findQuizzesByDifficultyRange(@Param("minPassScorePercent") double minPassScorePercent,
                                            @Param("maxPassScorePercent") double maxPassScorePercent);

    /**
     * Lấy quizzes chưa có câu hỏi
     * @return Danh sách empty quizzes
     */
    @Query("SELECT q FROM Quiz q WHERE q.active = true AND " +
            "(SELECT COUNT(qu) FROM Question qu WHERE qu.quiz = q) = 0")
    List<Quiz> findEmptyQuizzes();

    /**
     * Lấy average completion time cho quiz
     * @param quiz Quiz
     * @return Average completion time (minutes)
     */
    @Query("SELECT AVG(qr.timeTaken) FROM QuizResult qr WHERE qr.quiz = :quiz AND qr.timeTaken IS NOT NULL")
    Double getAverageCompletionTime(@Param("quiz") Quiz quiz);

    /**
     * Lấy pass rate của quiz
     * @param quiz Quiz
     * @return Pass rate (0.0 - 1.0)
     */
    @Query("SELECT CASE WHEN COUNT(qr) = 0 THEN 0.0 ELSE " +
            "CAST(COUNT(CASE WHEN qr.passed = true THEN 1 END) AS double) / COUNT(qr) END " +
            "FROM QuizResult qr WHERE qr.quiz = :quiz")
    Double getPassRate(@Param("quiz") Quiz quiz);

    /**
     * Lấy quiz attempts trong khoảng thời gian
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Số lượng attempts
     */
    @Query("SELECT COUNT(qr) FROM QuizResult qr WHERE qr.quiz = :quiz AND " +
            "qr.submittedAt BETWEEN :startDate AND :endDate")
    Long countAttemptsBetweenDates(@Param("quiz") Quiz quiz,
                                   @Param("startDate") LocalDateTime startDate,
                                   @Param("endDate") LocalDateTime endDate);

    // ===== STUDENT RELATED QUERIES =====

    /**
     * Tìm quizzes mà student chưa attempt
     * @param student Student
     * @param course Course
     * @return Danh sách quizzes chưa attempt
     */
    @Query("SELECT q FROM Quiz q WHERE q.course = :course AND q.active = true AND " +
            "q.id NOT IN (SELECT qr.quiz.id FROM QuizResult qr WHERE qr.user = :student)")
    List<Quiz> findUnattemptedQuizzesByStudent(@Param("student") User student, @Param("course") Course course);

    /**
     * Tìm quizzes mà student đã attempt
     * @param student Student
     * @param course Course
     * @return Danh sách quizzes đã attempt
     */
    @Query("SELECT DISTINCT q FROM Quiz q JOIN q.quizResults qr " +
            "WHERE q.course = :course AND qr.user = :student")
    List<Quiz> findAttemptedQuizzesByStudent(@Param("student") User student, @Param("course") Course course);

    /**
     * Tìm quizzes mà student đã pass
     * @param student Student
     * @param course Course
     * @return Danh sách quizzes đã pass
     */
    @Query("SELECT DISTINCT q FROM Quiz q JOIN q.quizResults qr " +
            "WHERE q.course = :course AND qr.user = :student AND qr.passed = true")
    List<Quiz> findPassedQuizzesByStudent(@Param("student") User student, @Param("course") Course course);
}