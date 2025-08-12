package com.coursemanagement.repository;

import com.coursemanagement.entity.Quiz;
import com.coursemanagement.entity.Course;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository interface để thao tác với bảng quizzes
 * Kế thừa JpaRepository để có sẵn các method CRUD cơ bản
 */
@Repository
public interface QuizRepository extends JpaRepository<Quiz, Long> {

    /**
     * Tìm tất cả bài kiểm tra theo khóa học
     * @param course Khóa học
     * @return Danh sách bài kiểm tra sắp xếp theo ngày tạo
     */
    @Query("SELECT q FROM Quiz q WHERE q.course = :course ORDER BY q.createdAt ASC")
    List<Quiz> findByCourseOrderByCreatedAt(@Param("course") Course course);

    /**
     * Tìm tất cả bài kiểm tra đang hoạt động theo khóa học
     * @param course Khóa học
     * @param isActive Trạng thái hoạt động
     * @return Danh sách bài kiểm tra đang hoạt động
     */
    @Query("SELECT q FROM Quiz q WHERE q.course = :course AND q.isActive = :isActive " +
            "ORDER BY q.createdAt ASC")
    List<Quiz> findByCourseAndIsActiveOrderByCreatedAt(@Param("course") Course course,
                                                       @Param("isActive") boolean isActive);

    /**
     * Tìm bài kiểm tra theo ID và khóa học (để đảm bảo quyền truy cập)
     * @param id ID của bài kiểm tra
     * @param course Khóa học
     * @return Optional<Quiz>
     */
    Optional<Quiz> findByIdAndCourse(Long id, Course course);

    /**
     * Tìm bài kiểm tra theo tiêu đề có chứa từ khóa
     * @param course Khóa học
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách bài kiểm tra chứa từ khóa
     */
    @Query("SELECT q FROM Quiz q WHERE q.course = :course AND q.isActive = true " +
            "AND LOWER(q.title) LIKE LOWER(CONCAT('%', :keyword, '%')) ORDER BY q.createdAt ASC")
    List<Quiz> findByCourseAndTitleContaining(@Param("course") Course course,
                                              @Param("keyword") String keyword);

    /**
     * Đếm số bài kiểm tra trong khóa học
     * @param course Khóa học
     * @return Số lượng bài kiểm tra
     */
    long countByCourse(Course course);

    /**
     * Đếm số bài kiểm tra đang hoạt động trong khóa học
     * @param course Khóa học
     * @param isActive Trạng thái hoạt động
     * @return Số lượng bài kiểm tra đang hoạt động
     */
    long countByCourseAndIsActive(Course course, boolean isActive);

    /**
     * Tìm bài kiểm tra có thể làm được (đang hoạt động và có câu hỏi)
     * @param course Khóa học
     * @return Danh sách bài kiểm tra có thể làm
     */
    @Query("SELECT q FROM Quiz q WHERE q.course = :course AND q.isActive = true " +
            "AND EXISTS (SELECT 1 FROM Question qu WHERE qu.quiz = q) " +
            "ORDER BY q.createdAt ASC")
    List<Quiz> findAvailableQuizzesByCourse(@Param("course") Course course);

    /**
     * Tìm bài kiểm tra chưa có câu hỏi
     * @param course Khóa học
     * @return Danh sách bài kiểm tra chưa có câu hỏi
     */
    @Query("SELECT q FROM Quiz q WHERE q.course = :course " +
            "AND NOT EXISTS (SELECT 1 FROM Question qu WHERE qu.quiz = q) " +
            "ORDER BY q.createdAt ASC")
    List<Quiz> findQuizzesWithoutQuestions(@Param("course") Course course);

    /**
     * Tìm bài kiểm tra theo khoảng thời gian làm bài
     * @param course Khóa học
     * @param minDuration Thời gian tối thiểu (phút)
     * @param maxDuration Thời gian tối đa (phút)
     * @return Danh sách bài kiểm tra trong khoảng thời gian
     */
    @Query("SELECT q FROM Quiz q WHERE q.course = :course AND q.isActive = true " +
            "AND q.duration BETWEEN :minDuration AND :maxDuration ORDER BY q.duration ASC")
    List<Quiz> findByCourseAndDurationBetween(@Param("course") Course course,
                                              @Param("minDuration") Integer minDuration,
                                              @Param("maxDuration") Integer maxDuration);

    /**
     * Lấy bài kiểm tra có nhiều câu hỏi nhất trong khóa học
     * @param course Khóa học
     * @return Optional<Quiz> - bài kiểm tra có nhiều câu hỏi nhất
     */
    @Query("SELECT q FROM Quiz q LEFT JOIN q.questions qu WHERE q.course = :course AND q.isActive = true " +
            "GROUP BY q.id ORDER BY COUNT(qu) DESC LIMIT 1")
    Optional<Quiz> findQuizWithMostQuestionsByCourse(@Param("course") Course course);

    /**
     * Lấy bài kiểm tra có ít câu hỏi nhất trong khóa học
     * @param course Khóa học
     * @return Optional<Quiz> - bài kiểm tra có ít câu hỏi nhất
     */
    @Query("SELECT q FROM Quiz q LEFT JOIN q.questions qu WHERE q.course = :course AND q.isActive = true " +
            "GROUP BY q.id ORDER BY COUNT(qu) ASC LIMIT 1")
    Optional<Quiz> findQuizWithLeastQuestionsByCourse(@Param("course") Course course);

    /**
     * Tìm bài kiểm tra theo điểm pass
     * @param course Khóa học
     * @param minPassScore Điểm pass tối thiểu
     * @return Danh sách bài kiểm tra có điểm pass >= minPassScore
     */
    @Query("SELECT q FROM Quiz q WHERE q.course = :course AND q.isActive = true " +
            "AND q.passScore >= :minPassScore ORDER BY q.passScore ASC")
    List<Quiz> findByCourseAndPassScoreGreaterThanEqual(@Param("course") Course course,
                                                        @Param("minPassScore") Double minPassScore);

    /**
     * Lấy thống kê số lượng câu hỏi cho mỗi bài kiểm tra
     * @param course Khóa học
     * @return Danh sách Object[] với format: [Quiz, Long questionCount]
     */
    @Query("SELECT q, COUNT(qu) as questionCount FROM Quiz q LEFT JOIN q.questions qu " +
            "WHERE q.course = :course GROUP BY q.id ORDER BY questionCount DESC")
    List<Object[]> getQuizQuestionStatistics(@Param("course") Course course);

    /**
     * Lấy thống kê số lượng học viên đã làm bài cho mỗi bài kiểm tra
     * @param course Khóa học
     * @return Danh sách Object[] với format: [Quiz, Long attemptCount]
     */
    @Query("SELECT q, COUNT(qr) as attemptCount FROM Quiz q LEFT JOIN q.quizResults qr " +
            "WHERE q.course = :course GROUP BY q.id ORDER BY attemptCount DESC")
    List<Object[]> getQuizAttemptStatistics(@Param("course") Course course);

    /**
     * Tìm bài kiểm tra có điểm trung bình cao nhất
     * @param course Khóa học
     * @return Danh sách bài kiểm tra sắp xếp theo điểm trung bình
     */
    @Query("SELECT q FROM Quiz q LEFT JOIN q.quizResults qr WHERE q.course = :course AND q.isActive = true " +
            "GROUP BY q.id HAVING COUNT(qr) > 0 ORDER BY AVG(qr.score) DESC")
    List<Quiz> findQuizzesOrderByAverageScore(@Param("course") Course course);

    /**
     * Tìm bài kiểm tra có tỷ lệ đạt cao nhất
     * @param course Khóa học
     * @return Danh sách bài kiểm tra sắp xếp theo tỷ lệ đạt
     */
    @Query("SELECT q FROM Quiz q LEFT JOIN q.quizResults qr WHERE q.course = :course AND q.isActive = true " +
            "GROUP BY q.id HAVING COUNT(qr) > 0 " +
            "ORDER BY (COUNT(CASE WHEN qr.isPassed = true THEN 1 END) * 100.0 / COUNT(qr)) DESC")
    List<Quiz> findQuizzesOrderByPassRate(@Param("course") Course course);

    /**
     * Kiểm tra học viên đã làm bài kiểm tra chưa
     * @param quizId ID bài kiểm tra
     * @param studentId ID học viên
     * @return true nếu đã làm, false nếu chưa làm
     */
    @Query("SELECT CASE WHEN COUNT(qr) > 0 THEN true ELSE false END FROM QuizResult qr " +
            "WHERE qr.quiz.id = :quizId AND qr.student.id = :studentId")
    boolean hasStudentTakenQuiz(@Param("quizId") Long quizId, @Param("studentId") Long studentId);

    /**
     * Tìm bài kiểm tra học viên chưa làm trong khóa học
     * @param course Khóa học
     * @param studentId ID học viên
     * @return Danh sách bài kiểm tra chưa làm
     */
    @Query("SELECT q FROM Quiz q WHERE q.course = :course AND q.isActive = true " +
            "AND NOT EXISTS (SELECT 1 FROM QuizResult qr WHERE qr.quiz = q AND qr.student.id = :studentId) " +
            "AND EXISTS (SELECT 1 FROM Question qu WHERE qu.quiz = q) " +
            "ORDER BY q.createdAt ASC")
    List<Quiz> findAvailableQuizzesForStudent(@Param("course") Course course,
                                              @Param("studentId") Long studentId);

    /**
     * Tìm bài kiểm tra học viên đã làm trong khóa học
     * @param course Khóa học
     * @param studentId ID học viên
     * @return Danh sách bài kiểm tra đã làm
     */
    @Query("SELECT q FROM Quiz q WHERE q.course = :course " +
            "AND EXISTS (SELECT 1 FROM QuizResult qr WHERE qr.quiz = q AND qr.student.id = :studentId) " +
            "ORDER BY q.createdAt ASC")
    List<Quiz> findCompletedQuizzesForStudent(@Param("course") Course course,
                                              @Param("studentId") Long studentId);

    /**
     * Lấy thời gian làm bài trung bình của bài kiểm tra
     * @param quiz Bài kiểm tra
     * @return Thời gian trung bình (giây)
     */
    @Query("SELECT AVG(qr.timeTaken) FROM QuizResult qr WHERE qr.quiz = :quiz AND qr.timeTaken IS NOT NULL")
    Double getAverageTimeTaken(@Param("quiz") Quiz quiz);

    /**
     * Đếm số bài kiểm tra theo khoảng thời gian
     * @param minDuration Thời gian tối thiểu
     * @param maxDuration Thời gian tối đa
     * @return Số lượng bài kiểm tra
     */
    long countByDurationBetween(Integer minDuration, Integer maxDuration);
}