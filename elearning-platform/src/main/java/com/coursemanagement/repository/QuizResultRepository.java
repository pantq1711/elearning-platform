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
     * Kiểm tra học viên đã làm bài kiểm tra chưa
     * @param student Học viên
     * @param quiz Bài kiểm tra
     * @return true nếu đã làm, false nếu chưa làm
     */
    boolean existsByStudentAndQuiz(User student, Quiz quiz);

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
     * Đếm số kết quả theo bài kiểm tra
     * @param quiz Bài kiểm tra
     * @return Số lượng kết quả
     */
    long countByQuiz(Quiz quiz);

    /**
     * Đếm số kết quả theo bài kiểm tra và trạng thái đạt
     * @param quiz Bài kiểm tra
     * @param isPassed Trạng thái đạt
     * @return Số lượng kết quả
     */
    long countByQuizAndIsPassed(Quiz quiz, boolean isPassed);

    /**
     * Đếm số kết quả theo học viên
     * @param student Học viên
     * @return Số lượng kết quả
     */
    long countByStudent(User student);

    /**
     * Đếm số kết quả đạt của học viên
     * @param student Học viên
     * @param isPassed Trạng thái đạt
     * @return Số lượng kết quả đạt
     */
    long countByStudentAndIsPassed(User student, boolean isPassed);

    /**
     * Tìm kết quả theo điểm trong khoảng
     * @param minScore Điểm tối thiểu
     * @param maxScore Điểm tối đa
     * @return Danh sách kết quả trong khoảng điểm
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.score BETWEEN :minScore AND :maxScore " +
            "ORDER BY qr.score DESC")
    List<QuizResult> findByScoreRange(@Param("minScore") Double minScore,
                                      @Param("maxScore") Double maxScore);

    /**
     * Tìm kết quả có điểm cao nhất
     * @param limit Số lượng kết quả cần lấy
     * @return Danh sách kết quả có điểm cao nhất
     */
    @Query("SELECT qr FROM QuizResult qr ORDER BY qr.score DESC LIMIT :limit")
    List<QuizResult> findTopScoreResults(@Param("limit") int limit);

    /**
     * Tìm kết quả gần đây nhất
     * @param limit Số lượng kết quả cần lấy
     * @return Danh sách kết quả gần đây
     */
    @Query("SELECT qr FROM QuizResult qr ORDER BY qr.submittedAt DESC LIMIT :limit")
    List<QuizResult> findRecentResults(@Param("limit") int limit);

    /**
     * Tìm kết quả theo khoảng thời gian làm bài
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Danh sách kết quả trong khoảng thời gian
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.submittedAt BETWEEN :startDate AND :endDate " +
            "ORDER BY qr.submittedAt DESC")
    List<QuizResult> findResultsByDateRange(@Param("startDate") LocalDateTime startDate,
                                            @Param("endDate") LocalDateTime endDate);

    /**
     * Tính điểm trung bình của tất cả kết quả
     * @return Điểm trung bình
     */
    @Query("SELECT AVG(qr.score) FROM QuizResult qr")
    Double calculateOverallAverageScore();

    /**
     * Tính điểm trung bình của học viên
     * @param student Học viên
     * @return Điểm trung bình của học viên
     */
    @Query("SELECT AVG(qr.score) FROM QuizResult qr WHERE qr.student = :student")
    Double calculateAverageScoreByStudent(@Param("student") User student);

    /**
     * Tính điểm trung bình của bài kiểm tra
     * @param quiz Bài kiểm tra
     * @return Điểm trung bình của bài kiểm tra
     */
    @Query("SELECT AVG(qr.score) FROM QuizResult qr WHERE qr.quiz = :quiz")
    Double calculateAverageScoreByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Tính tỷ lệ đạt tổng thể
     * @return Tỷ lệ đạt (0-1)
     */
    @Query("SELECT CASE WHEN COUNT(qr) > 0 THEN " +
            "CAST(SUM(CASE WHEN qr.isPassed = true THEN 1 ELSE 0 END) AS DOUBLE) / COUNT(qr) " +
            "ELSE 0 END FROM QuizResult qr")
    Double calculateOverallPassRate();

    /**
     * Tính tỷ lệ đạt của bài kiểm tra
     * @param quiz Bài kiểm tra
     * @return Tỷ lệ đạt của bài kiểm tra
     */
    @Query("SELECT CASE WHEN COUNT(qr) > 0 THEN " +
            "CAST(SUM(CASE WHEN qr.isPassed = true THEN 1 ELSE 0 END) AS DOUBLE) / COUNT(qr) " +
            "ELSE 0 END FROM QuizResult qr WHERE qr.quiz = :quiz")
    Double calculatePassRateByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Tìm kết quả theo giảng viên
     * @param instructor Giảng viên
     * @return Danh sách kết quả của các quiz do giảng viên tạo
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.quiz.course.instructor = :instructor " +
            "ORDER BY qr.submittedAt DESC")
    List<QuizResult> findResultsByInstructor(@Param("instructor") User instructor);

    /**
     * Đếm số kết quả theo giảng viên
     * @param instructor Giảng viên
     * @return Số lượng kết quả
     */
    @Query("SELECT COUNT(qr) FROM QuizResult qr WHERE qr.quiz.course.instructor = :instructor")
    long countResultsByInstructor(@Param("instructor") User instructor);

    /**
     * Tìm kết quả theo danh mục khóa học
     * @param categoryId ID danh mục
     * @return Danh sách kết quả theo danh mục
     */
    @Query("SELECT qr FROM QuizResult qr WHERE qr.quiz.course.category.id = :categoryId " +
            "ORDER BY qr.submittedAt DESC")
    List<QuizResult> findResultsByCategoryId(@Param("categoryId") Long categoryId);

    /**
     * Đếm số kết quả theo danh mục
     * @param categoryId ID danh mục
     * @return Số lượng kết quả
     */
    @Query("SELECT COUNT(qr) FROM QuizResult qr WHERE qr.quiz.course.category.id = :categoryId")
    long countResultsByCategoryId(@Param("categoryId") Long categoryId);

    /**
     * Tìm học viên có điểm cao nhất
     * @param limit Số lượng học viên cần lấy
     * @return Danh sách học viên có điểm cao nhất
     */
    @Query("SELECT qr.student FROM QuizResult qr " +
            "GROUP BY qr.student " +
            "ORDER BY AVG(qr.score) DESC " +
            "LIMIT :limit")
    List<User> findTopStudentsByAverageScore(@Param("limit") int limit);

    /**
     * Tìm bài kiểm tra có điểm trung bình cao nhất
     * @param limit Số lượng bài kiểm tra cần lấy
     * @return Danh sách bài kiểm tra có điểm cao
     */
    @Query("SELECT qr.quiz FROM QuizResult qr " +
            "GROUP BY qr.quiz " +
            "HAVING COUNT(qr) >= 3 " +
            "ORDER BY AVG(qr.score) DESC " +
            "LIMIT :limit")
    List<Quiz> findQuizzesWithHighestAverageScore(@Param("limit") int limit);

    /**
     * Lấy số lượng kết quả được tạo trong tháng hiện tại
     * @return Số lượng kết quả mới
     */
    @Query("SELECT COUNT(qr) FROM QuizResult qr WHERE " +
            "YEAR(qr.submittedAt) = YEAR(CURRENT_DATE) AND " +
            "MONTH(qr.submittedAt) = MONTH(CURRENT_DATE)")
    long countResultsThisMonth();

    /**
     * Lấy số lượng kết quả đạt trong tháng hiện tại
     * @return Số lượng kết quả đạt mới
     */
    @Query("SELECT COUNT(qr) FROM QuizResult qr WHERE qr.isPassed = true AND " +
            "YEAR(qr.submittedAt) = YEAR(CURRENT_DATE) AND " +
            "MONTH(qr.submittedAt) = MONTH(CURRENT_DATE)")
    long countPassedResultsThisMonth();

    /**
     * Lấy thống kê kết quả theo tháng
     * @param year Năm cần thống kê
     * @return Danh sách [Month, ResultCount]
     */
    @Query("SELECT MONTH(qr.submittedAt), COUNT(qr) FROM QuizResult qr " +
            "WHERE YEAR(qr.submittedAt) = :year " +
            "GROUP BY MONTH(qr.submittedAt) " +
            "ORDER BY MONTH(qr.submittedAt)")
    List<Object[]> getResultStatisticsByMonth(@Param("year") int year);

    /**
     * Lấy thống kê điểm số theo khoảng
     * @return Danh sách [ScoreRange, ResultCount]
     */
    @Query("SELECT " +
            "CASE " +
            "WHEN qr.score < 50 THEN '0-49' " +
            "WHEN qr.score < 60 THEN '50-59' " +
            "WHEN qr.score < 70 THEN '60-69' " +
            "WHEN qr.score < 80 THEN '70-79' " +
            "WHEN qr.score < 90 THEN '80-89' " +
            "ELSE '90-100' " +
            "END, COUNT(qr) " +
            "FROM QuizResult qr " +
            "GROUP BY " +
            "CASE " +
            "WHEN qr.score < 50 THEN '0-49' " +
            "WHEN qr.score < 60 THEN '50-59' " +
            "WHEN qr.score < 70 THEN '60-69' " +
            "WHEN qr.score < 80 THEN '70-79' " +
            "WHEN qr.score < 90 THEN '80-89' " +
            "ELSE '90-100' " +
            "END " +
            "ORDER BY " +
            "CASE " +
            "WHEN qr.score < 50 THEN 1 " +
            "WHEN qr.score < 60 THEN 2 " +
            "WHEN qr.score < 70 THEN 3 " +
            "WHEN qr.score < 80 THEN 4 " +
            "WHEN qr.score < 90 THEN 5 " +
            "ELSE 6 " +
            "END")
    List<Object[]> getScoreDistributionStatistics();

    /**
     * Tìm điểm cao nhất và thấp nhất của quiz
     * @param quiz Quiz
     * @return [MinScore, MaxScore]
     */
    @Query("SELECT MIN(qr.score), MAX(qr.score) FROM QuizResult qr WHERE qr.quiz = :quiz")
    Object[] findMinMaxScoreByQuiz(@Param("quiz") Quiz quiz);
}