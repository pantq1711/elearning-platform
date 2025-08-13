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
     * Đếm quizzes theo course
     * @param course Course
     * @return Số lượng quizzes
     */
    Long countByCourse(Course course);

    /**
     * Đếm active quizzes theo course
     * @param course Course
     * @param active Trạng thái active
     * @return Số lượng active quizzes
     */
    Long countByCourseAndActive(Course course, boolean active);

    // ===== INSTRUCTOR-RELATED QUERIES =====

    /**
     * Tìm quizzes của instructor
     * @param instructor Instructor
     * @param pageable Pagination info
     * @return Page quizzes
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

    // ===== STUDENT-RELATED QUERIES =====

    /**
     * Tìm available quizzes cho student (chưa làm hoặc chưa pass)
     * @param studentId ID của student
     * @return Danh sách available quizzes
     */
    @Query("SELECT q FROM Quiz q JOIN q.course c JOIN c.enrollments e " +
            "WHERE e.student.id = :studentId AND q.active = true " +
            "AND q.id NOT IN (SELECT qr.quiz.id FROM QuizResult qr WHERE qr.student.id = :studentId AND qr.passed = true)")
    List<Quiz> findAvailableQuizzesForStudent(@Param("studentId") Long studentId);

    /**
     * Tìm completed quizzes cho student (đã pass)
     * @param studentId ID của student
     * @return Danh sách completed quizzes
     */
    @Query("SELECT q FROM Quiz q JOIN QuizResult qr ON q.id = qr.quiz.id " +
            "WHERE qr.student.id = :studentId AND qr.passed = true " +
            "ORDER BY qr.completionTime DESC")
    List<Quiz> findCompletedQuizzesForStudent(@Param("studentId") Long studentId);

    // ===== SEARCH AND FILTER METHODS =====

    /**
     * Tìm quizzes theo keyword trong title
     * @param keyword Từ khóa tìm kiếm
     * @param active Trạng thái active
     * @param pageable Pagination info
     * @return Page quizzes
     */
    @Query("SELECT q FROM Quiz q WHERE q.active = :active AND " +
            "LOWER(q.title) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "ORDER BY q.createdAt DESC")
    Page<Quiz> findByKeywordAndActive(@Param("keyword") String keyword,
                                      @Param("active") boolean active,
                                      Pageable pageable);

    /**
     * Tìm active quizzes sắp xếp theo ngày tạo
     * @param active Trạng thái active
     * @param pageable Pagination info
     * @return Page quizzes
     */
    Page<Quiz> findByActiveOrderByCreatedAtDesc(boolean active, Pageable pageable);

    // ===== DIFFICULTY AND SCORE QUERIES =====

    /**
     * Tìm quizzes theo pass score range
     * @param minPassScore Pass score tối thiểu
     * @param maxPassScore Pass score tối đa
     * @param active Trạng thái active
     * @return Danh sách quizzes
     */
    @Query("SELECT q FROM Quiz q WHERE q.active = :active " +
            "AND q.passScore >= :minPassScore AND q.passScore <= :maxPassScore " +
            "ORDER BY q.passScore ASC")
    List<Quiz> findByPassScoreRange(@Param("minPassScore") Double minPassScore,
                                    @Param("maxPassScore") Double maxPassScore,
                                    @Param("active") boolean active);

    /**
     * Tìm quizzes theo duration range
     * @param minDuration Duration tối thiểu (phút)
     * @param maxDuration Duration tối đa (phút)
     * @param active Trạng thái active
     * @return Danh sách quizzes
     */
    @Query("SELECT q FROM Quiz q WHERE q.active = :active " +
            "AND q.duration >= :minDuration AND q.duration <= :maxDuration " +
            "ORDER BY q.duration ASC")
    List<Quiz> findByDurationRange(@Param("minDuration") Integer minDuration,
                                   @Param("maxDuration") Integer maxDuration,
                                   @Param("active") boolean active);

    // ===== STATISTICS METHODS =====

    /**
     * Lấy thống kê quizzes theo course
     * @return List array [courseId, courseName, quizCount]
     */
    @Query("SELECT q.course.id, q.course.name, COUNT(q) " +
            "FROM Quiz q " +
            "WHERE q.active = true " +
            "GROUP BY q.course.id, q.course.name " +
            "ORDER BY COUNT(q) DESC")
    List<Object[]> getQuizCountByCourse();

    /**
     * Lấy thống kê quizzes theo instructor
     * @return List array [instructorId, instructorName, quizCount]
     */
    @Query("SELECT q.course.instructor.id, q.course.instructor.fullName, COUNT(q) " +
            "FROM Quiz q " +
            "WHERE q.active = true " +
            "GROUP BY q.course.instructor.id, q.course.instructor.fullName " +
            "ORDER BY COUNT(q) DESC")
    List<Object[]> getQuizCountByInstructor();

    /**
     * Lấy thống kê attempts theo quiz
     * @return List array [quizId, quizTitle, attemptCount, passRate]
     */
    @Query("SELECT q.id, q.title, COUNT(qr), " +
            "(COUNT(CASE WHEN qr.passed = true THEN 1 END) * 100.0 / COUNT(qr)) as passRate " +
            "FROM Quiz q LEFT JOIN QuizResult qr ON q.id = qr.quiz.id " +
            "WHERE q.active = true " +
            "GROUP BY q.id, q.title " +
            "ORDER BY COUNT(qr) DESC")
    List<Object[]> getQuizAttemptStatistics();

    /**
     * Đếm total active quizzes
     * @return Số lượng active quizzes
     */
    Long countByActive(boolean active);

    // ===== RECENT AND POPULAR QUERIES =====

    /**
     * Tìm recent quizzes (trong X ngày gần đây)
     * @param startDate Ngày bắt đầu
     * @param active Trạng thái active
     * @return Danh sách recent quizzes
     */
    @Query("SELECT q FROM Quiz q WHERE q.active = :active AND q.createdAt >= :startDate " +
            "ORDER BY q.createdAt DESC")
    List<Quiz> findRecentQuizzes(@Param("startDate") LocalDateTime startDate,
                                 @Param("active") boolean active);

    /**
     * Tìm popular quizzes (nhiều attempts nhất)
     * @param limit Số lượng giới hạn
     * @return Danh sách popular quizzes
     */
    @Query("SELECT q FROM Quiz q LEFT JOIN QuizResult qr ON q.id = qr.quiz.id " +
            "WHERE q.active = true " +
            "GROUP BY q.id, q.title, q.course, q.description, q.duration, q.maxScore, q.passScore, " +
            "q.active, q.createdAt, q.updatedAt " +
            "ORDER BY COUNT(qr) DESC")
    List<Quiz> findPopularQuizzes(Pageable pageable);

    // ===== ADVANCED ANALYTICS =====

    /**
     * Tìm quizzes có pass rate thấp
     * @param maxPassRate Pass rate tối đa (%)
     * @param minAttempts Số attempts tối thiểu
     * @return Danh sách quizzes có pass rate thấp
     */
    @Query("SELECT q FROM Quiz q " +
            "WHERE q.active = true AND " +
            "(SELECT COUNT(qr1) FROM QuizResult qr1 WHERE qr1.quiz = q) >= :minAttempts AND " +
            "(SELECT COUNT(qr2) * 100.0 / COUNT(qr3) FROM QuizResult qr2, QuizResult qr3 " +
            " WHERE qr2.quiz = q AND qr2.passed = true AND qr3.quiz = q) <= :maxPassRate")
    List<Quiz> findQuizzesWithLowPassRate(@Param("maxPassRate") Double maxPassRate,
                                          @Param("minAttempts") Long minAttempts);

    /**
     * Tìm quizzes chưa có attempts
     * @return Danh sách quizzes chưa có ai làm
     */
    @Query("SELECT q FROM Quiz q WHERE q.active = true AND " +
            "NOT EXISTS (SELECT 1 FROM QuizResult qr WHERE qr.quiz = q)")
    List<Quiz> findQuizzesWithoutAttempts();

    /**
     * Lấy average score theo quiz
     * @param quiz Quiz
     * @return Average score
     */
    @Query("SELECT AVG(qr.score) FROM QuizResult qr WHERE qr.quiz = :quiz AND qr.completed = true")
    Double getAverageScoreByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Đếm attempts theo quiz
     * @param quiz Quiz
     * @return Số lượng attempts
     */
    @Query("SELECT COUNT(qr) FROM QuizResult qr WHERE qr.quiz = :quiz")
    Long countAttemptsByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Đếm passed attempts theo quiz
     * @param quiz Quiz
     * @return Số lượng passed attempts
     */
    @Query("SELECT COUNT(qr) FROM QuizResult qr WHERE qr.quiz = :quiz AND qr.passed = true")
    Long countPassedAttemptsByQuiz(@Param("quiz") Quiz quiz);
}