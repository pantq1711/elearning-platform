package com.coursemanagement.repository;

import com.coursemanagement.entity.Category;
import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.User;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Repository interface cho Course entity
 * Chứa các custom queries cho course management và analytics
 * Extends JpaSpecificationExecutor để hỗ trợ dynamic filtering
 */
@Repository
public interface CourseRepository extends JpaRepository<Course, Long>, JpaSpecificationExecutor<Course> {

    // ===== BASIC FINDER METHODS =====

    /**
     * Tìm course theo slug
     * @param slug Slug của course
     * @return Optional chứa Course nếu tìm thấy
     */
    Optional<Course> findBySlug(String slug);

    /**
     * Tìm course theo ID và instructor (cho security)
     * @param id ID course
     * @param instructor Instructor sở hữu
     * @return Optional chứa Course nếu tìm thấy
     */
    Optional<Course> findByIdAndInstructor(Long id, User instructor);

    /**
     * Kiểm tra course name đã tồn tại chưa
     * @param n Tên course
     * @return true nếu đã tồn tại
     */
    boolean existsByName(String n);

    /**
     * Kiểm tra slug đã tồn tại chưa
     * @param slug Slug
     * @return true nếu đã tồn tại
     */
    boolean existsBySlug(String slug);

    // ===== INSTRUCTOR-RELATED QUERIES =====

    /**
     * Tìm courses của một instructor, sắp xếp theo ngày tạo
     * @param instructor Instructor
     * @return Danh sách courses
     */
    List<Course> findByInstructorOrderByCreatedAtDesc(User instructor);

    /**
     * Tìm courses của instructor với pagination
     * @param instructor Instructor
     * @param pageable Pagination info
     * @return Danh sách courses
     */
    List<Course> findByInstructor(User instructor, Pageable pageable);

    /**
     * Tìm courses của instructor theo keyword
     * @param instructor Instructor
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách courses
     */
    List<Course> findByInstructorAndNameContainingIgnoreCaseOrderByCreatedAtDesc(User instructor, String keyword);

    /**
     * Đếm courses của một instructor
     * @param instructor Instructor
     * @return Số lượng courses
     */
    Long countByInstructor(User instructor);

    // ===== STATUS-BASED QUERIES =====

    /**
     * Đếm courses theo active status
     * @param active Trạng thái active
     * @return Số lượng courses
     */
    Long countByActive(boolean active);

    /**
     * Đếm courses theo featured status
     * @param featured Trạng thái featured
     * @return Số lượng courses
     */
    Long countByFeatured(boolean featured);

    /**
     * Tìm courses active sắp xếp theo ngày tạo
     * @param active Trạng thái active
     * @return Danh sách courses
     */
    List<Course> findByActiveOrderByCreatedAtDesc(boolean active);

    /**
     * Tìm courses featured và active
     * @param featured Trạng thái featured
     * @param active Trạng thái active
     * @return Danh sách courses
     */
    List<Course> findByFeaturedAndActiveOrderByCreatedAtDesc(boolean featured, boolean active);

    // ===== CATEGORY-BASED QUERIES =====

    /**
     * Tìm courses theo category và active status
     * @param category Category
     * @param active Trạng thái active
     * @return Danh sách courses
     */
    List<Course> findByCategoryAndActiveOrderByCreatedAtDesc(Category category, boolean active);

    /**
     * Đếm courses trong một category
     * @param category Category
     * @return Số lượng courses
     */
    Long countByCategory(Category category);

    /**
     * Đếm courses active trong một category
     * @param category Category
     * @param active Trạng thái active
     * @return Số lượng courses
     */
    Long countByCategoryAndActive(Category category, boolean active);

    // ===== SEARCH QUERIES =====

    /**
     * Tìm courses theo keyword trong tên
     * @param keyword Từ khóa
     * @param active Trạng thái active
     * @return Danh sách courses
     */
    List<Course> findByNameContainingIgnoreCaseAndActiveOrderByCreatedAtDesc(String keyword, boolean active);

    /**
     * Tìm courses theo keyword trong tên hoặc mô tả
     * @param keyword Từ khóa
     * @param active Trạng thái active
     * @return Danh sách courses
     */
    @Query("SELECT c FROM Course c WHERE c.active = :active AND " +
            "(LOWER(c.n) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    List<Course> findByKeywordAndActive(@Param("keyword") String keyword, @Param("active") boolean active);

    /**
     * Advanced search với multiple criteria
     * @param keyword Từ khóa (có thể null)
     * @param category Category (có thể null)
     * @param instructor Instructor (có thể null)
     * @param difficulty Difficulty level (có thể null)
     * @param active Trạng thái active
     * @return Danh sách courses
     */
    @Query("SELECT c FROM Course c WHERE c.active = :active AND " +
            "(:keyword IS NULL OR " +
            " LOWER(c.n) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            " LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND " +
            "(:category IS NULL OR c.category = :category) AND " +
            "(:instructor IS NULL OR c.instructor = :instructor) AND " +
            "(:difficulty IS NULL OR c.difficultyLevel = :difficulty)")
    List<Course> findByAdvancedCriteria(@Param("keyword") String keyword,
                                        @Param("category") Category category,
                                        @Param("instructor") User instructor,
                                        @Param("difficulty") Course.DifficultyLevel difficulty,
                                        @Param("active") boolean active);

    // ===== POPULARITY AND RANKING QUERIES =====

    /**
     * Tìm courses phổ biến nhất theo số enrollments
     * @param pageable Pagination info
     * @return Danh sách popular courses
     */
    @Query("SELECT c FROM Course c WHERE c.active = true " +
            "ORDER BY (SELECT COUNT(e) FROM Enrollment e WHERE e.course = c) DESC")
    List<Course> findMostPopularCourses(Pageable pageable);

    /**
     * Tìm courses mới nhất
     * @param pageable Pagination info
     * @return Danh sách courses mới
     */
    @Query("SELECT c FROM Course c WHERE c.active = true ORDER BY c.createdAt DESC")
    List<Course> findNewestCourses(Pageable pageable);

    /**
     * Tìm courses có rating cao nhất (cần implement rating system)
     * @param pageable Pagination info
     * @return Danh sách top rated courses
     */
    @Query("SELECT c FROM Course c WHERE c.active = true " +
            "ORDER BY (SELECT AVG(r.rating) FROM CourseRating r WHERE r.course = c) DESC NULLS LAST")
    List<Course> findTopRatedCourses(Pageable pageable);

    /**
     * Tìm courses trending (nhiều enrollments gần đây)
     * @param since Thời điểm bắt đầu tính
     * @param pageable Pagination info
     * @return Danh sách trending courses
     */
    @Query("SELECT c FROM Course c WHERE c.active = true " +
            "ORDER BY (SELECT COUNT(e) FROM Enrollment e WHERE e.course = c AND e.enrollmentDate >= :since) DESC")
    List<Course> findTrendingCourses(@Param("since") LocalDateTime since, Pageable pageable);

    // ===== ANALYTICS QUERIES =====

    /**
     * Lấy thống kê courses theo tháng
     * @param startDate Ngày bắt đầu
     * @return List array [month, year, count]
     */
    @Query("SELECT MONTH(c.createdAt), YEAR(c.createdAt), COUNT(c) " +
            "FROM Course c " +
            "WHERE c.createdAt >= :startDate " +
            "GROUP BY YEAR(c.createdAt), MONTH(c.createdAt) " +
            "ORDER BY YEAR(c.createdAt), MONTH(c.createdAt)")
    List<Object[]> getCourseCreationStatsByMonth(@Param("startDate") LocalDateTime startDate);

    /**
     * Lấy thống kê courses theo category
     * @return List array [category, count]
     */
    @Query("SELECT c.category, COUNT(c) FROM Course c WHERE c.active = true " +
            "GROUP BY c.category ORDER BY COUNT(c) DESC")
    List<Object[]> getCourseStatsByCategory();

    /**
     * Lấy thống kê courses theo instructor
     * @param limit Số lượng top instructors
     * @return List array [instructor, course_count]
     */
    @Query("SELECT c.instructor, COUNT(c) FROM Course c WHERE c.active = true " +
            "GROUP BY c.instructor ORDER BY COUNT(c) DESC")
    List<Object[]> getTopInstructorsByCourseCount(Pageable pageable);

    /**
     * Lấy thống kê completion rate theo course
     * @return List array [course, completion_rate]
     */
    @Query("SELECT c, " +
            "(SELECT COUNT(e1) FROM Enrollment e1 WHERE e1.course = c AND e1.completed = true) * 100.0 / " +
            "(SELECT COUNT(e2) FROM Enrollment e2 WHERE e2.course = c) as completionRate " +
            "FROM Course c WHERE c.active = true AND " +
            "(SELECT COUNT(e) FROM Enrollment e WHERE e.course = c) >= 5 " +
            "ORDER BY completionRate DESC")
    List<Object[]> getCourseCompletionRates();

    // ===== DIFFICULTY AND LANGUAGE QUERIES =====

    /**
     * Tìm courses theo difficulty level
     * @param difficulty Difficulty level
     * @param active Trạng thái active
     * @return Danh sách courses
     */
    List<Course> findByDifficultyLevelAndActiveOrderByCreatedAtDesc(Course.DifficultyLevel difficulty, boolean active);

    /**
     * Tìm courses theo language
     * @param language Ngôn ngữ
     * @param active Trạng thái active
     * @return Danh sách courses
     */
    List<Course> findByLanguageAndActiveOrderByCreatedAtDesc(String language, boolean active);

    /**
     * Đếm courses theo difficulty level
     * @return List array [difficulty, count]
     */
    @Query("SELECT c.difficultyLevel, COUNT(c) FROM Course c WHERE c.active = true " +
            "GROUP BY c.difficultyLevel")
    List<Object[]> getCourseStatsByDifficulty();

    // ===== PERFORMANCE QUERIES =====

    /**
     * Tìm courses performance tốt (high enrollment + completion rate)
     * @param minEnrollments Số enrollments tối thiểu
     * @param minCompletionRate Completion rate tối thiểu (%)
     * @return Danh sách high-performing courses
     */
    @Query("SELECT c FROM Course c WHERE c.active = true AND " +
            "(SELECT COUNT(e1) FROM Enrollment e1 WHERE e1.course = c) >= :minEnrollments AND " +
            "((SELECT COUNT(e2) FROM Enrollment e2 WHERE e2.course = c AND e2.completed = true) * 100.0 / " +
            " (SELECT COUNT(e3) FROM Enrollment e3 WHERE e3.course = c)) >= :minCompletionRate")
    List<Course> findHighPerformingCourses(@Param("minEnrollments") long minEnrollments,
                                           @Param("minCompletionRate") double minCompletionRate);

    /**
     * Tìm courses cần attention (low enrollment hoặc completion rate)
     * @param maxEnrollments Số enrollments tối đa
     * @param maxCompletionRate Completion rate tối đa (%)
     * @return Danh sách courses cần attention
     */
    @Query("SELECT c FROM Course c WHERE c.active = true AND " +
            "c.createdAt <= :olderThan AND " +
            "((SELECT COUNT(e1) FROM Enrollment e1 WHERE e1.course = c) <= :maxEnrollments OR " +
            " (SELECT COUNT(e2) FROM Enrollment e2 WHERE e2.course = c) > 0 AND " +
            " ((SELECT COUNT(e3) FROM Enrollment e3 WHERE e3.course = c AND e3.completed = true) * 100.0 / " +
            "  (SELECT COUNT(e4) FROM Enrollment e4 WHERE e4.course = c)) <= :maxCompletionRate)")
    List<Course> findCoursesNeedingAttention(@Param("maxEnrollments") long maxEnrollments,
                                             @Param("maxCompletionRate") double maxCompletionRate,
                                             @Param("olderThan") LocalDateTime olderThan);

    // ===== RECOMMENDATION QUERIES =====

    /**
     * Tìm courses liên quan theo category
     * @param category Category
     * @param excludeCourse Course cần loại trừ
     * @param pageable Pagination info
     * @return Danh sách related courses
     */
    @Query("SELECT c FROM Course c WHERE c.category = :category AND c.active = true " +
            "AND c != :excludeCourse ORDER BY c.createdAt DESC")
    List<Course> findRelatedCoursesByCategory(@Param("category") Category category,
                                              @Param("excludeCourse") Course excludeCourse,
                                              Pageable pageable);

    /**
     * Tìm courses recommended cho student dựa vào completed courses
     * @param student Student
     * @param pageable Pagination info
     * @return Danh sách recommended courses
     */
    @Query("SELECT c FROM Course c WHERE c.active = true AND c NOT IN " +
            "(SELECT e.course FROM Enrollment e WHERE e.student = :student) AND " +
            "c.category IN (SELECT DISTINCT e2.course.category FROM Enrollment e2 " +
            "               WHERE e2.student = :student AND e2.completed = true) " +
            "ORDER BY (SELECT COUNT(e3) FROM Enrollment e3 WHERE e3.course = c) DESC")
    List<Course> findRecommendedCoursesForStudent(@Param("student") User student, Pageable pageable);

    // ===== CONTENT ANALYSIS =====

    /**
     * Tìm courses chưa có lessons
     * @return Danh sách courses without lessons
     */
    @Query("SELECT c FROM Course c WHERE c.active = true AND " +
            "(SELECT COUNT(l) FROM Lesson l WHERE l.course = c AND l.active = true) = 0")
    List<Course> findCoursesWithoutLessons();

    /**
     * Tìm courses chưa có quizzes
     * @return Danh sách courses without quizzes
     */
    @Query("SELECT c FROM Course c WHERE c.active = true AND " +
            "(SELECT COUNT(q) FROM Quiz q WHERE q.course = c AND q.active = true) = 0")
    List<Course> findCoursesWithoutQuizzes();

    /**
     * Lấy average content count per course
     * @return Object array [avg_lessons, avg_quizzes]
     */
    @Query("SELECT " +
            "AVG((SELECT COUNT(l) FROM Lesson l WHERE l.course = c AND l.active = true)), " +
            "AVG((SELECT COUNT(q) FROM Quiz q WHERE q.course = c AND q.active = true)) " +
            "FROM Course c WHERE c.active = true")
    Object[] getAverageContentStats();

    // ===== SUMMARY STATISTICS =====

    /**
     * Lấy course summary cho admin dashboard
     * @return Object array [totalCourses, activeCourses, featuredCourses, coursesWithEnrollments]
     */
    @Query("SELECT " +
            "COUNT(c), " +
            "SUM(CASE WHEN c.active = true THEN 1 ELSE 0 END), " +
            "SUM(CASE WHEN c.featured = true AND c.active = true THEN 1 ELSE 0 END), " +
            "COUNT(DISTINCT e.course) " +
            "FROM Course c LEFT JOIN Enrollment e ON c = e.course")
    Object[] getCourseSummaryStats();

    /**
     * Lấy instructor performance summary
     * @param instructor Instructor
     * @return Object array [totalCourses, totalEnrollments, avgCompletionRate, totalRevenue]
     */
    @Query("SELECT " +
            "COUNT(c), " +
            "(SELECT COUNT(e1) FROM Enrollment e1 WHERE e1.course IN (SELECT c1 FROM Course c1 WHERE c1.instructor = :instructor)), " +
            "(SELECT AVG((SELECT COUNT(e2) FROM Enrollment e2 WHERE e2.course = c2 AND e2.completed = true) * 100.0 / " +
            "             (SELECT COUNT(e3) FROM Enrollment e3 WHERE e3.course = c2)) " +
            " FROM Course c2 WHERE c2.instructor = :instructor AND " +
            " (SELECT COUNT(e4) FROM Enrollment e4 WHERE e4.course = c2) > 0), " +
            "COALESCE(SUM(c.price * (SELECT COUNT(e5) FROM Enrollment e5 WHERE e5.course = c)), 0) " +
            "FROM Course c WHERE c.instructor = :instructor")
    Object[] getInstructorPerformanceStats(@Param("instructor") User instructor);
}