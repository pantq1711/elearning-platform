package com.coursemanagement.service;

import com.coursemanagement.entity.Category;
import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.Enrollment;
import com.coursemanagement.entity.User;
import com.coursemanagement.repository.EnrollmentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Service class để xử lý business logic liên quan đến Enrollment
 * Quản lý việc đăng ký khóa học, theo dõi tiến độ học tập và certificate management
 * SỬA LỖI: Đã sửa static method calls và dependency injection issues
 */
@Service
@Transactional
public class EnrollmentService {
    /**
     * Count total students - THÊM MỚI
     */
    public long countTotalStudents() {
        return enrollmentRepository.countDistinctStudents();
    }

    /**
     * Count enrollments by course - THÊM MỚI
     */
    public long countEnrollmentsByCourse(Course course) {
        return enrollmentRepository.countByCourse(course);
    }

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    // SỬA LỖI: Inject UserService và CourseService với @Lazy để tránh circular dependency
    @Lazy
    @Autowired
    private UserService userService;

    @Lazy
    @Autowired
    private CourseService courseService;

    // ===== INNER CLASS FOR STATISTICS =====

    public static class EnrollmentStats {
        private long totalEnrollments;
        private long activeEnrollments;
        private long completedEnrollments;
        private double completionRate;
        private double averageProgress;

        // Constructor
        public EnrollmentStats(long totalEnrollments, long activeEnrollments,
                               long completedEnrollments, double averageProgress) {
            this.totalEnrollments = totalEnrollments;
            this.activeEnrollments = activeEnrollments;
            this.completedEnrollments = completedEnrollments;
            this.completionRate = totalEnrollments > 0 ?
                    (double) completedEnrollments / totalEnrollments * 100 : 0.0;
            this.averageProgress = averageProgress;
        }

        // Getters
        public long getTotalEnrollments() { return totalEnrollments; }
        public long getActiveEnrollments() { return activeEnrollments; }
        public long getCompletedEnrollments() { return completedEnrollments; }
        public double getCompletionRate() { return completionRate; }
        public double getAverageProgress() { return averageProgress; }
    }

    // ===== BASIC CRUD OPERATIONS =====

    /**
     * Tìm enrollment theo ID
     */
    public Optional<Enrollment> findById(Long id) {
        return enrollmentRepository.findById(id);
    }

    /**
     * Tìm enrollment theo student và course
     */
    public Optional<Enrollment> findByStudentAndCourse(User student, Course course) {
        return enrollmentRepository.findByStudentAndCourse(student, course);
    }

    /**
     * Đăng ký student vào course (Enhanced version)
     */
    public Enrollment enrollStudent(User student, Course course) {
        // Kiểm tra đã đăng ký chưa
        if (enrollmentRepository.existsByStudentAndCourse(student, course)) {
            throw new RuntimeException("Student đã đăng ký khóa học này rồi");
        }

        // Kiểm tra course có active không
        if (!course.isActive()) {
            throw new RuntimeException("Khóa học không còn hoạt động");
        }

        // Tạo enrollment mới
        Enrollment enrollment = new Enrollment();
        enrollment.setStudent(student);
        enrollment.setCourse(course);
        enrollment.setEnrollmentDate(LocalDateTime.now());
        enrollment.setProgress(0.0);
        enrollment.setCompleted(false);
        enrollment.setScore(0.0);

        return enrollmentRepository.save(enrollment);
    }

    /**
     * Enroll student với Long IDs
     * SỬA LỖI: Sử dụng instance method thay vì static method call
     */
    @Transactional
    public Enrollment enrollStudent(Long studentId, Long courseId) {
        User student = userService.findByIdOrThrow(studentId); // ✅ Instance method call
        Course course = courseService.findByIdOrThrow(courseId); // ✅ Instance method call
        return enrollStudent(student, course);
    }

    /**
     * Hủy đăng ký student khỏi course
     */
    public void unenrollStudent(User student, Course course) {
        Enrollment enrollment = findByStudentAndCourse(student, course)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đăng ký khóa học"));

        enrollmentRepository.delete(enrollment);
    }

    // ===== EXISTENCE CHECKS =====

    /**
     * Kiểm tra student đã đăng ký course chưa (User objects)
     */
    public boolean isStudentEnrolled(User student, Course course) {
        return enrollmentRepository.existsByStudentAndCourse(student, course);
    }

    /**
     * Kiểm tra student đã đăng ký course chưa (IDs)
     */
    public boolean isStudentEnrolled(Long studentId, Long courseId) {
        return enrollmentRepository.existsByStudentIdAndCourseId(studentId, courseId);
    }

    /**
     * Kiểm tra enrollment exists với Long IDs
     */
    public boolean isEnrolled(Long studentId, Long courseId) {
        return enrollmentRepository.existsByStudentIdAndCourseId(studentId, courseId);
    }

    /**
     * Kiểm tra student đã đăng ký course theo ID không
     */
    public boolean existsByStudentIdAndCourseId(Long studentId, Long courseId) {
        return enrollmentRepository.existsByStudentIdAndCourseId(studentId, courseId);
    }

    /**
     * Tạo enrollment với Long IDs
     */
    /**
     * Tạo enrollment với Long IDs - Cập nhật enrollment count
     */
    @Transactional
    public Enrollment createEnrollment(Long studentId, Long courseId) {
        User student = userService.findByIdOrThrow(studentId);
        Course course = courseService.findByIdOrThrow(courseId);

        // Kiểm tra đã đăng ký chưa
        if (enrollmentRepository.existsByStudentAndCourse(student, course)) {
            throw new RuntimeException("Student đã đăng ký khóa học này rồi");
        }

        // Kiểm tra course có active không
        if (!course.isActive()) {
            throw new RuntimeException("Khóa học không còn hoạt động");
        }

        // Tạo enrollment mới
        Enrollment enrollment = new Enrollment();
        enrollment.setStudent(student);
        enrollment.setCourse(course);
        enrollment.setEnrollmentDate(LocalDateTime.now());
        enrollment.setProgress(0.0);
        enrollment.setCompleted(false);
        enrollment.setScore(0.0);

        Enrollment savedEnrollment = enrollmentRepository.save(enrollment);

        // 🔥 THÊM: Cập nhật enrollment count trong course
        int currentCount = course.getEnrollmentCount() != 0 ? course.getEnrollmentCount() : 0;
        course.setEnrollmentCount(currentCount + 1);
        courseService.updateCourse(course); // Lưu course với enrollment count mới

        return savedEnrollment;
    }
    /**
     * Tìm enrollment theo student và course IDs
     */
    public Optional<Enrollment> findByStudentIdAndCourseId(Long studentId, Long courseId) {
        return enrollmentRepository.findByStudentIdAndCourseId(studentId, courseId);
    }

    // ===== STUDENT-RELATED QUERIES =====

    /**
     * Tìm tất cả enrollments của student
     */
    public List<Enrollment> findEnrollmentsByStudent(User student) {
        return enrollmentRepository.findByStudentOrderByEnrollmentDateDesc(student);
    }

    /**
     * Tìm enrollments theo student ID
     */
    public List<Enrollment> findByStudentId(Long studentId) {
        return enrollmentRepository.findByStudentId(studentId);
    }

    /**
     * Tìm active enrollments của student
     */
    public List<Enrollment> findActiveEnrollmentsByStudent(User student) {
        return enrollmentRepository.findByStudentAndCompletedOrderByEnrollmentDateDesc(student, false);
    }

    /**
     * Tìm completed enrollments của student
     */
    public List<Enrollment> findCompletedEnrollmentsByStudent(User student) {
        return enrollmentRepository.findByStudentAndCompletedOrderByCompletionDateDesc(student, true);
    }

    /**
     * Tìm enrollments theo student và trạng thái completed
     */
    public List<Enrollment> findByStudentAndCompletedOrderByEnrollmentDateDesc(User student, boolean completed) {
        return enrollmentRepository.findByStudentAndCompletedOrderByEnrollmentDateDesc(student, completed);
    }

    /**
     * Tìm completed enrollments theo completion date
     */
    public List<Enrollment> findByStudentAndCompletedOrderByCompletionDateDesc(User student, boolean completed) {
        return enrollmentRepository.findByStudentAndCompletedOrderByCompletionDateDesc(student, completed);
    }

    /**
     * Tìm enrollments với scores của student
     */
    public List<Enrollment> findEnrollmentsWithScoresByStudent(User student) {
        return enrollmentRepository.findByStudentAndFinalScoreGreaterThanOrderByFinalScoreDesc(student, 0.0);
    }

    /**
     * Tìm enrollments theo student và score lớn hơn threshold
     */
    public List<Enrollment> findByStudentAndScoreGreaterThanOrderByScoreDesc(User student, double minScore) {
        return enrollmentRepository.findByStudentAndFinalScoreGreaterThanOrderByFinalScoreDesc(student, minScore);
    }

    /**
     * Lấy điểm trung bình của student
     */
    public Double getAverageScoreByStudent(User student) {
        return enrollmentRepository.getAverageScoreByStudent(student);
    }

    // ===== COURSE-RELATED QUERIES =====

    /**
     * Tìm enrollments theo course ID
     */
    public List<Enrollment> findByCourseId(Long courseId) {
        return enrollmentRepository.findByCourseId(courseId);
    }

    /**
     * Tìm enrollments theo course với pagination
     */
    public Page<Enrollment> findEnrollmentsByCourse(Course course, Pageable pageable) {
        return enrollmentRepository.findByCourseOrderByEnrollmentDateDesc(course, pageable);
    }

    /**
     * Tìm enrollments theo course sắp xếp theo enrollment date
     */
    public Page<Enrollment> findByCourseOrderByEnrollmentDateDesc(Course course, Pageable pageable) {
        return enrollmentRepository.findByCourseOrderByEnrollmentDateDesc(course, pageable);
    }

    /**
     * Đếm enrollments theo course
     */
    public Long countByCourse(Course course) {
        return enrollmentRepository.countByCourse(course);
    }

    /**
     * Đếm enrollments theo category
     */
    public Long countEnrollmentsByCategory(Category category) {
        return enrollmentRepository.countEnrollmentsByCategory(category);
    }

    // ===== INSTRUCTOR-RELATED QUERIES =====

    /**
     * Đếm số students của một instructor
     */
    public Long countStudentsByInstructor(User instructor) {
        return enrollmentRepository.countStudentsByInstructor(instructor);
    }

    /**
     * Tính tổng revenue của instructor (Long return for compatibility)
     */
    public Long calculateRevenueByInstructor(User instructor) {
        Double revenue = enrollmentRepository.calculateRevenueByInstructor(instructor);
        return revenue != null ? revenue.longValue() : 0L;
    }

    /**
     * Tính tổng revenue của instructor (Double return)
     */
    public Double calculateRevenueByInstructorDouble(User instructor) {
        return enrollmentRepository.calculateRevenueByInstructor(instructor);
    }

    /**
     * Tìm recent enrollments của instructor (List version)
     */
    public List<Enrollment> findRecentEnrollmentsByInstructor(User instructor, int limit) {
        Pageable pageable = PageRequest.of(0, limit, Sort.by(Sort.Direction.DESC, "enrollmentDate"));
        return enrollmentRepository
                .findRecentEnrollmentsByInstructor(instructor, pageable)
                .getContent(); // Lấy danh sách từ Page
    }

    /**
     * Tìm recent enrollments của instructor (Page version)
     */
    public Page<Enrollment> findRecentEnrollmentsByInstructor(User instructor, Pageable pageable) {
        return enrollmentRepository.findRecentEnrollmentsByInstructor(instructor, pageable);
    }

    /**
     * Tìm enrollments cần attention (low progress, overdue)
     */
    public List<Enrollment> findEnrollmentsNeedingAttention(User instructor) {
        LocalDateTime oneWeekAgo = LocalDateTime.now().minusWeeks(1);
        return enrollmentRepository.findLowProgressEnrollments(instructor, 25.0, oneWeekAgo);
    }

    /**
     * Tìm students có low progress
     */
    public List<Enrollment> findLowProgressEnrollments(User instructor, double maxProgress, LocalDateTime enrolledAfter) {
        return enrollmentRepository.findLowProgressEnrollments(instructor, maxProgress, enrolledAfter);
    }

    /**
     * Tìm most active instructors
     */
    public List<User> findMostActiveInstructors(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        List<Object[]> results = enrollmentRepository.findMostActiveInstructors(pageable);

        return results.stream()
                .map(result -> (User) result[0])
                .collect(Collectors.toList());
    }

    // ===== PROGRESS & COMPLETION MANAGEMENT =====

    /**
     * Cập nhật progress của enrollment (Object version)
     */
    public void updateProgress(Enrollment enrollment, Double progress) {
        enrollment.setProgress(progress);

        // Tự động mark completed nếu progress = 100%
        if (progress >= 100.0 && !enrollment.isCompleted()) {
            enrollment.setCompleted(true);
            enrollment.setCompletionDate(LocalDateTime.now());
        }

        enrollmentRepository.save(enrollment);
    }

    /**
     * Cập nhật progress của enrollment (ID version)
     */
    public Enrollment updateProgress(Long enrollmentId, double progress) {
        Enrollment enrollment = enrollmentRepository.findById(enrollmentId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy enrollment với ID: " + enrollmentId));

        // Validate progress
        if (progress < 0 || progress > 100) {
            throw new RuntimeException("Progress phải trong khoảng 0-100");
        }

        enrollment.setProgress(progress);

        // Nếu progress = 100% thì mark as completed
        if (progress >= 100.0) {
            enrollment.setCompleted(true);
            enrollment.setCompletionDate(LocalDateTime.now());
        }

        return enrollmentRepository.save(enrollment);
    }

    /**
     * Cập nhật score của enrollment
     */
    public void updateScore(Enrollment enrollment, Double score) {
        enrollment.setScore(score);
        enrollmentRepository.save(enrollment);
    }

    /**
     * Hoàn thành enrollment (Object version)
     */
    public void completeEnrollment(Enrollment enrollment, Double finalScore) {
        enrollment.setCompleted(true);
        enrollment.setCompletionDate(LocalDateTime.now());
        enrollment.setProgress(100.0);
        if (finalScore != null) {
            enrollment.setScore(finalScore);
        }

        enrollmentRepository.save(enrollment);
    }

    /**
     * Mark enrollment as completed (ID version with certificate)
     */
    public Enrollment completeEnrollment(Long enrollmentId, Double finalScore) {
        Enrollment enrollment = enrollmentRepository.findById(enrollmentId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy enrollment với ID: " + enrollmentId));

        enrollment.setCompleted(true);
        enrollment.setCompletionDate(LocalDateTime.now());
        enrollment.setProgress(100.0);

        if (finalScore != null) {
            enrollment.setFinalScore(finalScore);
        }

        // Issue certificate nếu đạt điểm pass
        if (shouldIssueCertificate(enrollment)) {
            enrollment.setCertificateIssued(true);
            enrollment.setCertificateIssuedDate(LocalDateTime.now());
        }

        return enrollmentRepository.save(enrollment);
    }

    // ===== COUNT OPERATIONS =====

    /**
     * Đếm tất cả enrollments
     */
    public Long countAllEnrollments() {
        return enrollmentRepository.count();
    }

    /**
     * Đếm enrollments theo trạng thái completed
     */
    public Long countByCompleted(boolean completed) {
        return enrollmentRepository.countByCompleted(completed);
    }

    /**
     * Đếm completed enrollments
     */
    public Long countCompletedEnrollments() {
        return enrollmentRepository.countCompletedEnrollments();
    }

    // ===== ANALYTICS & STATISTICS =====

    /**
     * Lấy thống kê enrollment của student (Original version)
     */
    public EnrollmentStats getStudentStats(User student) {
        Long totalEnrollments = enrollmentRepository.countByStudent(student);
        Long completedEnrollments = enrollmentRepository.countByStudentAndCompleted(student, true);
        Long activeEnrollments = totalEnrollments - completedEnrollments;

        // Tính điểm trung bình
        Double averageScore = enrollmentRepository.getAverageScoreByStudent(student);
        if (averageScore == null) {
            averageScore = 0.0;
        }

        return new EnrollmentStats(totalEnrollments, activeEnrollments,
                completedEnrollments, averageScore);
    }

    /**
     * Lấy thống kê enrollment cho student (Enhanced Map version)
     */
    public Map<String, Object> getStudentEnrollmentStats(User student) {
        Map<String, Object> stats = new HashMap<>();

        List<Enrollment> allEnrollments = enrollmentRepository.findByStudent(student);

        stats.put("totalEnrollments", allEnrollments.size());
        stats.put("completedEnrollments", allEnrollments.stream()
                .mapToLong(e -> e.isCompleted() ? 1 : 0).sum());
        stats.put("inProgressEnrollments", allEnrollments.stream()
                .mapToLong(e -> !e.isCompleted() ? 1 : 0).sum());

        // Tính average progress
        double avgProgress = allEnrollments.stream()
                .mapToDouble(e -> e.getProgress() != null ? e.getProgress() : 0.0)
                .average().orElse(0.0);
        stats.put("averageProgress", avgProgress);

        // Tính average score
        Double avgScore = getAverageScoreByStudent(student);
        stats.put("averageScore", avgScore != null ? avgScore : 0.0);

        // Số certificates
        long certificates = allEnrollments.stream()
                .mapToLong(e -> e.isCertificateIssued() ? 1 : 0).sum();
        stats.put("certificatesEarned", certificates);

        return stats;
    }

    /**
     * Lấy thống kê enrollment cho instructor
     */
    public Map<String, Object> getInstructorEnrollmentStats(User instructor) {
        Map<String, Object> stats = new HashMap<>();

        stats.put("totalStudents", countStudentsByInstructor(instructor));
        stats.put("totalRevenue", calculateRevenueByInstructorDouble(instructor));

        // Lấy recent enrollments để tính thêm stats
        List<Enrollment> recentEnrollments = findRecentEnrollmentsByInstructor(instructor,
                PageRequest.of(0, 100)).getContent();

        long completedCount = recentEnrollments.stream()
                .mapToLong(e -> e.isCompleted() ? 1 : 0).sum();
        stats.put("completedEnrollments", completedCount);

        long certificatesIssued = recentEnrollments.stream()
                .mapToLong(e -> e.isCertificateIssued() ? 1 : 0).sum();
        stats.put("certificatesIssued", certificatesIssued);

        return stats;
    }

    /**
     * Lấy thống kê enrollment cho course
     */
    public Map<String, Object> getCourseEnrollmentStats(Course course) {
        Map<String, Object> stats = new HashMap<>();

        List<Enrollment> courseEnrollments = enrollmentRepository.findByCourse(course);

        stats.put("totalEnrollments", courseEnrollments.size());
        stats.put("completedEnrollments", courseEnrollments.stream()
                .mapToLong(e -> e.isCompleted() ? 1 : 0).sum());

        // Completion rate
        double completionRate = courseEnrollments.isEmpty() ? 0.0 :
                (courseEnrollments.stream().mapToLong(e -> e.isCompleted() ? 1 : 0).sum() * 100.0) / courseEnrollments.size();
        stats.put("completionRate", completionRate);

        // Average progress
        double avgProgress = courseEnrollments.stream()
                .mapToDouble(e -> e.getProgress() != null ? e.getProgress() : 0.0)
                .average().orElse(0.0);
        stats.put("averageProgress", avgProgress);

        return stats;
    }

    /**
     * Lấy thống kê enrollments theo tháng (Original version)
     */
    public Map<String, Object> getEnrollmentStatisticsByMonth() {
        LocalDateTime oneYearAgo = LocalDateTime.now().minusYears(1);
        List<Object[]> stats = enrollmentRepository.getEnrollmentStatsByMonth(oneYearAgo);

        Map<String, Object> result = new HashMap<>();
        result.put("monthlyStats", stats);
        result.put("totalEnrollments", countAllEnrollments());
        result.put("completedEnrollments", enrollmentRepository.countByCompleted(true));

        return result;
    }

    /**
     * Lấy thống kê enrollments theo tháng từ thời điểm cho trước
     */
    public List<Object[]> getEnrollmentStatsByMonth(LocalDateTime fromDate) {
        return enrollmentRepository.getEnrollmentStatsByMonth(fromDate);
    }

    /**
     * Lấy monthly enrollment stats
     */
    public List<Object[]> getMonthlyEnrollmentStats() {
        LocalDateTime fromDate = LocalDateTime.now().minusMonths(12);
        return enrollmentRepository.getMonthlyEnrollmentStats(fromDate);
    }

    /**
     * Tính average completion rate
     */
    public Double getAverageCompletionRate() {
        return enrollmentRepository.getAverageCompletionRate();
    }

    /**
     * Lấy thống kê dashboard tổng quát
     */
    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();

        stats.put("totalEnrollments", enrollmentRepository.count());
        stats.put("completedEnrollments", countByCompleted(true));
        stats.put("inProgressEnrollments", countByCompleted(false));

        // Enrollments trong 30 ngày qua
        LocalDateTime thirtyDaysAgo = LocalDateTime.now().minusDays(30);
        List<Object[]> monthlyStats = getEnrollmentStatsByMonth(thirtyDaysAgo);
        long recentEnrollments = monthlyStats.stream()
                .mapToLong(stat -> (Long) stat[2])
                .sum();
        stats.put("recentEnrollments", recentEnrollments);

        return stats;
    }

    /**
     * Lấy top students theo điểm số (List version)
     */
    public List<Object[]> findTopStudentsByScore(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return enrollmentRepository
                .findTopStudentsByAverageScore(pageable)
                .getContent(); // Lấy List từ Page
    }

    /**
     * Tìm top students theo average score (Page version)
     */
    public Page<Object[]> findTopStudentsByAverageScore(Pageable pageable) {
        return enrollmentRepository.findTopStudentsByAverageScore(pageable);
    }

    /**
     * Lấy top students theo course
     */
    public List<Enrollment> getTopStudentsByCourse(Course course, Pageable pageable) {
        return enrollmentRepository.getTopStudentsByCourse(course, pageable);
    }

    /**
     * Tìm recent enrollments
     */
    public List<Enrollment> findRecentEnrollments(int limit) {
        Pageable pageable = PageRequest.of(0, limit, Sort.by("enrollmentDate").descending());
        return enrollmentRepository.findRecentEnrollments(pageable);
    }

    // ===== CERTIFICATE MANAGEMENT =====

    /**
     * Kiểm tra có nên issue certificate không
     */
    private boolean shouldIssueCertificate(Enrollment enrollment) {
        // Kiểm tra completed và có điểm
        if (!enrollment.isCompleted() || enrollment.getFinalScore() == null) {
            return false;
        }

        // Kiểm tra điểm đạt yêu cầu (tùy theo business rule)
        double minScoreForCertificate = 70.0; // Điểm tối thiểu để có certificate
        return enrollment.getFinalScore() >= minScoreForCertificate;
    }
}