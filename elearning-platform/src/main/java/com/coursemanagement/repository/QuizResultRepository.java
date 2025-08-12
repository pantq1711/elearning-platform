package com.coursemanagement.repository;

import com.coursemanagement.entity.QuizResult;
import com.coursemanagement.entity.Quiz;
import com.coursemanagement.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Repository interface để thao tác với bảng quiz_results
 * Kế thừa JpaRepository để có sẵn các method CRUD cơ bản
 */
@Repository
public interface QuizResultRepository extends JpaRepository<QuizResult, Long> {

    /**
     * Tìm kết quả theo học viên và bài kiểm tra
     * @param student Học viên
     * @param quiz Bài kiểm tra
     * @return Optional<QuizResult> - có thể null nếu chưa làm bài
     */
    Optional<QuizResult> findByStudentAndQuiz(User student, Quiz quiz);

    /**
     * Tìm tất cả kết quả của học viên
     * @param student Học viên
     * @return Danh sách kết quả sắp xếp theo ngày làm bài mới nhất
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.student = :student ORDER BY qr.submittedAt DESC")
    List<QuizResult> findByStudentOrderBySubmittedAtDesc(@Param("student") User student);

    /**
     * Tìm tất cả kết quả của một bài kiểm tra
     * @param quiz Bài kiểm tra
     * @return Danh sách kết quả sắp xếp theo điểm cao nhất
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.quiz = :quiz ORDER BY qr.score DESC")
    List<QuizResult> findByQuizOrderByScoreDesc(@Param("quiz") Quiz quiz);

    /**
     * Tìm kết quả đạt của học viên
     * @param student Học viên
     * @param isPassed Trạng thái đạt
     * @return Danh sách kết quả đạt
     */
    List<QuizResult> findByStudentAndIsPassed(User student, boolean isPassed);

    /**
     * Tìm kết quả đạt của bài kiểm tra
     * @param quiz Bài kiểm tra
     * @param isPassed Trạng thái đạt
     * @return Danh sách kết quả đạt
     */
    List<QuizResult> findByQuizAndIsPassed(Quiz quiz, boolean isPassed);

    /**
     * Kiểm tra học viên đã làm bài kiểm tra chưa
     * @param student Học viên
     * @param quiz Bài kiểm tra
     * @return true nếu đã làm, false nếu chưa làm
     */
    boolean existsByStudentAndQuiz(User student, Quiz quiz);

    /**
     * Đếm số học viên đã làm bài kiểm tra
     * @param quiz Bài kiểm tra
     * @return Số lượng học viên đã làm bài
     */
    long countByQuiz(Quiz quiz);

    /**
     * Đếm số bài kiểm tra học viên đã làm
     * @param student Học viên
     * @return Số lượng bài kiểm tra đã làm
     */
    long countByStudent(User student);

    /**
     * Đếm số học viên đạt bài kiểm tra
     * @param quiz Bài kiểm tra
     * @return Số lượng học viên đạt
     */
    long countByQuizAndIsPassed(Quiz quiz, boolean isPassed);

    /**
     * Đếm số bài kiểm tra học viên đã đạt
     * @param student Học viên
     * @return Số lượng bài kiểm tra đã đạt
     */
    long countByStudentAndIsPassed(User student, boolean isPassed);

    /**
     * Lấy điểm cao nhất của học viên
     * @param student Học viên
     * @return Điểm cao nhất hoặc null nếu chưa làm bài nào
     */
    @Query("SELECT MAX(qr.score) FROM QuizResult qr WHERE qr.student = :student")
    Double findHighestScoreByStudent(@Param("student") User student);

    /**
     * Lấy điểm trung bình của học viên
     * @param student Học viên
     * @return Điểm trung bình hoặc 0 nếu chưa làm bài nào
     */
    @Query("SELECT COALESCE(AVG(qr.score), 0) FROM QuizResult qr WHERE qr.student = :student")
    Double findAverageScoreByStudent(@Param("student") User student);

    /**
     * Lấy điểm cao nhất của bài kiểm tra
     * @param quiz Bài kiểm tra
     * @return Điểm cao nhất hoặc null nếu chưa có ai làm
     */
    @Query("SELECT MAX(qr.score) FROM QuizResult qr WHERE qr.quiz = :quiz")
    Double findHighestScoreByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Lấy điểm trung bình của bài kiểm tra
     * @param quiz Bài kiểm tra
     * @return Điểm trung bình hoặc 0 nếu chưa có ai làm
     */
    @Query("SELECT COALESCE(AVG(qr.score), 0) FROM QuizResult qr WHERE qr.quiz = :quiz")
    Double findAverageScoreByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Tìm top học viên có điểm cao nhất trong bài kiểm tra
     * @param quiz Bài kiểm tra
     * @param limit Số lượng học viên cần lấy
     * @return Danh sách kết quả top điểm cao
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.quiz = :quiz " +
            "ORDER BY qr.score DESC, qr.timeTaken ASC LIMIT :limit")
    List<QuizResult> findTopResultsByQuiz(@Param("quiz") Quiz quiz, @Param("limit") int limit);

    /**
     * Tìm kết quả trong khoảng thời gian
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Danh sách kết quả trong khoảng thời gian
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.submittedAt BETWEEN :startDate AND :endDate " +
            "ORDER BY qr.submittedAt DESC")
    List<QuizResult> findBySubmittedAtBetween(@Param("startDate") LocalDateTime startDate,
                                              @Param("endDate") LocalDateTime endDate);

    /**
     * Đếm số kết quả trong khoảng thời gian
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Số lượng kết quả
     */
    long countBySubmittedAtBetween(LocalDateTime startDate, LocalDateTime endDate);

    /**
     * Tìm kết quả theo khoảng điểm
     * @param quiz Bài kiểm tra
     * @param minScore Điểm tối thiểu
     * @param maxScore Điểm tối đa
     * @return Danh sách kết quả trong khoảng điểm
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.quiz = :quiz " +
            "AND qr.score BETWEEN :minScore AND :maxScore ORDER BY qr.score DESC")
    List<QuizResult> findByQuizAndScoreBetween(@Param("quiz") Quiz quiz,
                                               @Param("minScore") Double minScore,
                                               @Param("maxScore") Double maxScore);

    /**
     * Lấy tỷ lệ đạt của bài kiểm tra
     * @param quiz Bài kiểm tra
     * @return Tỷ lệ đạt (0-100)
     */
    @Query("SELECT CASE WHEN COUNT(qr) = 0 THEN 0 ELSE " +
            "(COUNT(CASE WHEN qr.isPassed = true THEN 1 END) * 100.0 / COUNT(qr)) END " +
            "FROM QuizResult qr WHERE qr.quiz = :quiz")
    Double getPassRateByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Lấy tỷ lệ đạt của học viên
     * @param student Học viên
     * @return Tỷ lệ đạt (0-100)
     */
    @Query("SELECT CASE WHEN COUNT(qr) = 0 THEN 0 ELSE " +
            "(COUNT(CASE WHEN qr.isPassed = true THEN 1 END) * 100.0 / COUNT(qr)) END " +
            "FROM QuizResult qr WHERE qr.student = :student")
    Double getPassRateByStudent(@Param("student") User student);

    /**
     * Tìm kết quả theo khóa học (thông qua bài kiểm tra)
     * @param courseId ID khóa học
     * @return Danh sách kết quả của tất cả bài kiểm tra trong khóa học
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.quiz.course.id = :courseId " +
            "ORDER BY qr.submittedAt DESC")
    List<QuizResult> findByCourseId(@Param("courseId") Long courseId);

    /**
     * Tìm kết quả của học viên trong khóa học
     * @param student Học viên
     * @param courseId ID khóa học
     * @return Danh sách kết quả của học viên trong khóa học đó
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.student = :student " +
            "AND qr.quiz.course.id = :courseId ORDER BY qr.submittedAt DESC")
    List<QuizResult> findByStudentAndCourseId(@Param("student") User student,
                                              @Param("courseId") Long courseId);

    /**
     * Lấy thời gian làm bài trung bình của bài kiểm tra
     * @param quiz Bài kiểm tra
     * @return Thời gian trung bình (giây)
     */
    @Query("SELECT COALESCE(AVG(qr.timeTaken), 0) FROM QuizResult qr " +
            "WHERE qr.quiz = :quiz AND qr.timeTaken IS NOT NULL")
    Double getAverageTimeTakenByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Tìm kết quả có thời gian làm bài nhanh nhất
     * @param quiz Bài kiểm tra
     * @return Optional<QuizResult> - kết quả nhanh nhất
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.quiz = :quiz AND qr.timeTaken IS NOT NULL " +
            "ORDER BY qr.timeTaken ASC LIMIT 1")
    Optional<QuizResult> findFastestResultByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Tìm kết quả có thời gian làm bài chậm nhất
     * @param quiz Bài kiểm tra
     * @return Optional<QuizResult> - kết quả chậm nhất
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.quiz = :quiz AND qr.timeTaken IS NOT NULL " +
            "ORDER BY qr.timeTaken DESC LIMIT 1")
    Optional<QuizResult> findSlowestResultByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Lấy thống kê kết quả theo tháng
     * @param year Năm cần thống kê
     * @return Danh sách Object[] với format: [Month, Long resultCount]
     */
    @Query("SELECT MONTH(qr.submittedAt) as month, COUNT(qr) as resultCount " +
            "FROM QuizResult qr WHERE YEAR(qr.submittedAt) = :year " +
            "GROUP BY MONTH(qr.submittedAt) ORDER BY month")
    List<Object[]> getResultStatisticsByMonth(@Param("year") int year);

    /**
     * Lấy thống kê điểm số
     * @param quiz Bài kiểm tra
     * @return Danh sách Object[] với format: [Double scoreRange, Long count]
     */
    @Query("SELECT " +
            "CASE " +
            "  WHEN qr.score < 50 THEN 'Dưới 50' " +
            "  WHEN qr.score < 60 THEN '50-59' " +
            "  WHEN qr.score < 70 THEN '60-69' " +
            "  WHEN qr.score < 80 THEN '70-79' " +
            "  WHEN qr.score < 90 THEN '80-89' " +
            "  ELSE '90-100' " +
            "END as scoreRange, " +
            "COUNT(qr) as count " +
            "FROM QuizResult qr WHERE qr.quiz = :quiz " +
            "GROUP BY scoreRange ORDER BY scoreRange")
    List<Object[]> getScoreDistributionByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Tìm học viên có kết quả tốt nhất trong nhiều bài kiểm tra
     * @param limit Số lượng học viên cần lấy
     * @return Danh sách học viên với điểm trung bình cao nhất
     */
    @Query("SELECT qr.student, AVG(qr.score) as avgScore, COUNT(qr) as quizCount " +
            "FROM QuizResult qr GROUP BY qr.student " +
            "ORDER BY avgScore DESC LIMIT :limit")
    List<Object[]> findTopStudentsByAverageScore(@Param("limit") int limit);

    /**
     * Tìm bài kiểm tra khó nhất (tỷ lệ đạt thấp nhất)
     * @param limit Số lượng bài kiểm tra cần lấy
     * @return Danh sách bài kiểm tra khó nhất
     */
    @Query("SELECT qr.quiz, " +
            "(COUNT(CASE WHEN qr.isPassed = true THEN 1 END) * 100.0 / COUNT(qr)) as passRate " +
            "FROM QuizResult qr GROUP BY qr.quiz HAVING COUNT(qr) >= 3 " +
            "ORDER BY passRate ASC LIMIT :limit")
    List<Object[]> findHardestQuizzes(@Param("limit") int limit);

    /**
     * Tìm bài kiểm tra dễ nhất (tỷ lệ đạt cao nhất)
     * @param limit Số lượng bài kiểm tra cần lấy
     * @return Danh sách bài kiểm tra dễ nhất
     */
    @Query("SELECT qr.quiz, " +
            "(COUNT(CASE WHEN qr.isPassed = true THEN 1 END) * 100.0 / COUNT(qr)) as passRate " +
            "FROM QuizResult qr GROUP BY qr.quiz HAVING COUNT(qr) >= 3 " +
            "ORDER BY passRate DESC LIMIT :limit")
    List<Object[]> findEasiestQuizzes(@Param("limit") int limit);
}