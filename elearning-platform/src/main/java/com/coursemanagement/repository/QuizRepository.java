package com.coursemanagement.repository;

import com.coursemanagement.entity.Quiz;
import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
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
    @Query("SELECT q FROM Quiz q WHERE q.course = :course " +
            "AND LOWER(q.title) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "ORDER BY q.createdAt ASC")
    List<Quiz> findByCourseAndTitleContainingIgnoreCase(@Param("course") Course course,
                                                        @Param("keyword") String keyword);

    /**
     * Tìm quiz theo giảng viên
     * @param instructor Giảng viên
     * @return Danh sách quiz
     */
    @Query("SELECT q FROM Quiz q WHERE q.course.instructor = :instructor " +
            "ORDER BY q.createdAt DESC")
    List<Quiz> findQuizzesByInstructor(@Param("instructor") User instructor);

    /**
     * Đếm số quiz theo giảng viên
     * @param instructor Giảng viên
     * @return Số lượng quiz
     */
    @Query("SELECT COUNT(q) FROM Quiz q WHERE q.course.instructor = :instructor")
    long countQuizzesByInstructor(@Param("instructor") User instructor);

    /**
     * Tìm quiz đang hoạt động theo giảng viên
     * @param instructor Giảng viên
     * @return Danh sách quiz đang hoạt động
     */
    @Query("SELECT q FROM Quiz q WHERE q.course.instructor = :instructor AND q.isActive = true " +
            "ORDER BY q.createdAt DESC")
    List<Quiz> findActiveQuizzesByInstructor(@Param("instructor") User instructor);

    /**
     * Đếm số quiz theo khóa học
     * @param course Khóa học
     * @return Số lượng quiz
     */
    long countByCourse(Course course);

    /**
     * Đếm số quiz đang hoạt động theo khóa học
     * @param course Khóa học
     * @param isActive Trạng thái hoạt động
     * @return Số lượng quiz đang hoạt động
     */
    long countByCourseAndIsActive(Course course, boolean isActive);

    /**
     * Tìm quiz có thời gian làm bài trong khoảng
     * @param minDuration Thời gian tối thiểu (phút)
     * @param maxDuration Thời gian tối đa (phút)
     * @return Danh sách quiz trong khoảng thời gian
     */
    @Query("SELECT q FROM Quiz q WHERE q.duration BETWEEN :minDuration AND :maxDuration " +
            "AND q.isActive = true ORDER BY q.duration ASC")
    List<Quiz> findQuizzesByDurationRange(@Param("minDuration") Integer minDuration,
                                          @Param("maxDuration") Integer maxDuration);

    /**
     * Tìm quiz có điểm đạt trong khoảng
     * @param minPassScore Điểm đạt tối thiểu
     * @param maxPassScore Điểm đạt tối đa
     * @return Danh sách quiz trong khoảng điểm đạt
     */
    @Query("SELECT q FROM Quiz q WHERE q.passScore BETWEEN :minPassScore AND :maxPassScore " +
            "AND q.isActive = true ORDER BY q.passScore ASC")
    List<Quiz> findQuizzesByPassScoreRange(@Param("minPassScore") Double minPassScore,
                                           @Param("maxPassScore") Double maxPassScore);

    /**
     * Tìm quiz được tạo gần đây nhất
     * @param limit Số lượng quiz cần lấy
     * @return Danh sách quiz mới nhất
     */
    @Query("SELECT q FROM Quiz q WHERE q.isActive = true " +
            "ORDER BY q.createdAt DESC LIMIT :limit")
    List<Quiz> findRecentQuizzes(@Param("limit") int limit);

    /**
     * Tìm quiz có nhiều câu hỏi nhất
     * @param limit Số lượng quiz cần lấy
     * @return Danh sách quiz có nhiều câu hỏi
     */
    @Query("SELECT q FROM Quiz q " +
            "LEFT JOIN q.questions qu " +
            "WHERE q.isActive = true " +
            "GROUP BY q " +
            "ORDER BY COUNT(qu) DESC " +
            "LIMIT :limit")
    List<Quiz> findQuizzesWithMostQuestions(@Param("limit") int limit);

    /**
     * Tìm quiz có nhiều lần làm bài nhất
     * @param limit Số lượng quiz cần lấy
     * @return Danh sách quiz phổ biến nhất
     */
    @Query("SELECT q FROM Quiz q " +
            "LEFT JOIN q.quizResults qr " +
            "WHERE q.isActive = true " +
            "GROUP BY q " +
            "ORDER BY COUNT(qr) DESC " +
            "LIMIT :limit")
    List<Quiz> findMostAttemptedQuizzes(@Param("limit") int limit);

    /**
     * Tìm quiz theo khoảng thời gian tạo
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Danh sách quiz trong khoảng thời gian
     */
    @Query("SELECT q FROM Quiz q WHERE q.createdAt BETWEEN :startDate AND :endDate " +
            "ORDER BY q.createdAt DESC")
    List<Quiz> findQuizzesByDateRange(@Param("startDate") LocalDateTime startDate,
                                      @Param("endDate") LocalDateTime endDate);

    /**
     * Tìm quiz theo danh mục khóa học
     * @param categoryId ID danh mục
     * @return Danh sách quiz theo danh mục
     */
    @Query("SELECT q FROM Quiz q WHERE q.course.category.id = :categoryId " +
            "AND q.isActive = true ORDER BY q.createdAt DESC")
    List<Quiz> findQuizzesByCategoryId(@Param("categoryId") Long categoryId);

    /**
     * Đếm số quiz theo danh mục
     * @param categoryId ID danh mục
     * @return Số lượng quiz
     */
    @Query("SELECT COUNT(q) FROM Quiz q WHERE q.course.category.id = :categoryId")
    long countQuizzesByCategoryId(@Param("categoryId") Long categoryId);

    /**
     * Tính điểm trung bình của tất cả quiz
     * @return Điểm trung bình
     */
    @Query("SELECT AVG(qr.score) FROM Quiz q " +
            "LEFT JOIN q.quizResults qr " +
            "WHERE qr.score IS NOT NULL")
    Double calculateAverageScore();

    /**
     * Tính điểm trung bình của quiz
     * @param quiz Quiz
     * @return Điểm trung bình của quiz
     */
    @Query("SELECT AVG(qr.score) FROM QuizResult qr WHERE qr.quiz = :quiz")
    Double calculateAverageScoreByQuiz(@Param("quiz") Quiz quiz);

    /**
     * Tìm quiz có tỷ lệ đạt cao nhất
     * @param limit Số lượng quiz cần lấy
     * @return Danh sách quiz có tỷ lệ đạt cao
     */
    @Query("SELECT q FROM Quiz q " +
            "LEFT JOIN q.quizResults qr " +
            "WHERE q.isActive = true " +
            "GROUP BY q " +
            "HAVING COUNT(qr) > 0 " +
            "ORDER BY " +
            "(CAST(SUM(CASE WHEN qr.isPassed = true THEN 1 ELSE 0 END) AS DOUBLE) / COUNT(qr)) DESC " +
            "LIMIT :limit")
    List<Quiz> findQuizzesWithHighestPassRate(@Param("limit") int limit);

    /**
     * Lấy số lượng quiz được tạo trong tháng hiện tại
     * @return Số lượng quiz mới
     */
    @Query("SELECT COUNT(q) FROM Quiz q WHERE " +
            "YEAR(q.createdAt) = YEAR(CURRENT_DATE) AND " +
            "MONTH(q.createdAt) = MONTH(CURRENT_DATE)")
    long countQuizzesCreatedThisMonth();

    /**
     * Tìm quiz không có câu hỏi nào
     * @return Danh sách quiz rỗng
     */
    @Query("SELECT q FROM Quiz q " +
            "WHERE q.id NOT IN (SELECT DISTINCT qu.quiz.id FROM Question qu) " +
            "ORDER BY q.createdAt DESC")
    List<Quiz> findEmptyQuizzes();

    /**
     * Lấy thống kê quiz theo tháng
     * @param year Năm cần thống kê
     * @return Danh sách [Month, QuizCount]
     */
    @Query("SELECT MONTH(q.createdAt), COUNT(q) FROM Quiz q " +
            "WHERE YEAR(q.createdAt) = :year " +
            "GROUP BY MONTH(q.createdAt) " +
            "ORDER BY MONTH(q.createdAt)")
    List<Object[]> getQuizStatisticsByMonth(@Param("year") int year);

    /**
     * Tìm quiz theo mô tả có chứa từ khóa
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách quiz có mô tả chứa từ khóa
     */
    @Query("SELECT q FROM Quiz q WHERE LOWER(q.description) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "AND q.isActive = true ORDER BY q.title ASC")
    List<Quiz> findQuizzesByDescriptionContaining(@Param("keyword") String keyword);
}