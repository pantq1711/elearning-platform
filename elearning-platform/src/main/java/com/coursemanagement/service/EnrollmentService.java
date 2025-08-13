package com.coursemanagement.service;

import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.Enrollment;
import com.coursemanagement.entity.User;
import com.coursemanagement.repository.EnrollmentRepository;
import org.springframework.beans.factory.annotation.Autowired;
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

/**
 * Service class để xử lý business logic liên quan đến Enrollment
 * Quản lý việc đăng ký khóa học của students và tracking progress
 */
@Service
@Transactional
public class EnrollmentService {

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    /**
     * Tạo enrollment mới (student đăng ký khóa học)
     * @param student Student đăng ký
     * @param course Khóa học được đăng ký
     * @return Enrollment đã được tạo
     */
    public Enrollment createEnrollment(User student, Course course) {
        // Kiểm tra đã đăng ký chưa
        if (enrollmentRepository.existsByStudentAndCourse(student, course)) {
            throw new RuntimeException("Bạn đã đăng ký khóa học này rồi");
        }

        Enrollment enrollment = new Enrollment();
        enrollment.setStudent(student);
        enrollment.setCourse(course);
        enrollment.setEnrollmentDate(LocalDateTime.now());
        enrollment.setProgress(0.0);
        enrollment.setCompleted(false);

        return enrollmentRepository.save(enrollment);
    }

    /**
     * Cập nhật tiến độ học tập
     * @param enrollmentId ID enrollment
     * @param progress Tiến độ mới (0-100)
     */
    public void updateProgress(Long enrollmentId, double progress) {
        Enrollment enrollment = enrollmentRepository.findById(enrollmentId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy enrollment"));

        enrollment.setProgress(Math.max(0, Math.min(100, progress))); // Clamp 0-100

        // Tự động đánh dấu completed nếu progress >= 90%
        if (progress >= 90.0 && !enrollment.isCompleted()) {
            enrollment.setCompleted(true);
            enrollment.setCompletionDate(LocalDateTime.now());
        }

        enrollmentRepository.save(enrollment);
    }

    /**
     * Đánh dấu khóa học hoàn thành
     * @param enrollmentId ID enrollment
     */
    public void markAsCompleted(Long enrollmentId) {
        Enrollment enrollment = enrollmentRepository.findById(enrollmentId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy enrollment"));

        enrollment.setCompleted(true);
        enrollment.setProgress(100.0);
        enrollment.setCompletionDate(LocalDateTime.now());

        enrollmentRepository.save(enrollment);
    }

    /**
     * Tìm enrollment theo student và course
     * @param student Student
     * @param course Course
     * @return Optional chứa Enrollment nếu tìm thấy
     */
    public Optional<Enrollment> findByStudentAndCourse(User student, Course course) {
        return enrollmentRepository.findByStudentAndCourse(student, course);
    }

    /**
     * Tìm tất cả enrollments của một student
     * @param student Student
     * @return Danh sách enrollments
     */
    public List<Enrollment> findByStudent(User student) {
        return enrollmentRepository.findByStudentOrderByEnrollmentDateDesc(student);
    }

    /**
     * Tìm tất cả enrollments của một course
     * @param course Course
     * @return Danh sách enrollments
     */
    public List<Enrollment> findByCourse(Course course) {
        return enrollmentRepository.findByCourseOrderByEnrollmentDateDesc(course);
    }

    // ===== ADMIN & ANALYTICS METHODS =====

    /**
     * Đếm tổng số enrollments trong hệ thống
     * @return Số lượng enrollments
     */
    public Long countAllEnrollments() {
        return enrollmentRepository.count();
    }

    /**
     * Đếm số enrollments đã hoàn thành
     * @return Số lượng completed enrollments
     */
    public Long countCompletedEnrollments() {
        return enrollmentRepository.countByCompleted(true);
    }

    /**
     * Đếm số enrollments cho một course
     * @param course Course cần đếm
     * @return Số lượng enrollments
     */
    public Long countEnrollmentsByCourse(Course course) {
        return enrollmentRepository.countByCourse(course);
    }

    /**
     * Đếm số students của một instructor
     * @param instructor Instructor
     * @return Số lượng students
     */
    public Long countStudentsByInstructor(User instructor) {
        return enrollmentRepository.countDistinctStudentsByInstructor(instructor);
    }

    /**
     * Tính revenue của một instructor (giả sử có giá khóa học)
     * @param instructor Instructor
     * @return Tổng revenue
     */
    public Long calculateRevenueByInstructor(User instructor) {
        // Placeholder implementation - cần có price field trong Course
        // return enrollmentRepository.sumRevenueByInstructor(instructor);
        return 0L; // Tạm thời trả về 0
    }

    /**
     * Lấy enrollments gần đây
     * @param limit Số lượng cần lấy
     * @return Danh sách recent enrollments
     */
    public List<Enrollment> findRecentEnrollments(int limit) {
        Pageable pageable = PageRequest.of(0, limit, Sort.by("enrollmentDate").descending());
        return enrollmentRepository.findAll(pageable).getContent();
    }

    /**
     * Lấy enrollments gần đây của một instructor
     * @param instructor Instructor
     * @param limit Số lượng cần lấy
     * @return Danh sách recent enrollments
     */
    public List<Enrollment> findRecentEnrollmentsByInstructor(User instructor, int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return enrollmentRepository.findByInstructorOrderByEnrollmentDateDesc(instructor, pageable);
    }

    /**
     * Lấy enrollments gần đây của một course
     * @param course Course
     * @param limit Số lượng cần lấy
     * @return Danh sách recent enrollments
     */
    public List<Enrollment> getRecentEnrollmentsByCourse(Course course, int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return enrollmentRepository.findByCourseOrderByEnrollmentDateDesc(course, pageable);
    }

    /**
     * Lấy top students theo tiến độ của một course
     * @param course Course
     * @param limit Số lượng cần lấy
     * @return Danh sách top students
     */
    public List<Enrollment> getTopStudentsByCourse(Course course, int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return enrollmentRepository.findByCourseOrderByProgressDesc(course, pageable);
    }

    /**
     * Lấy thống kê enrollments theo tháng
     * @return Map chứa thống kê theo tháng
     */
    public Map<String, Long> getMonthlyEnrollmentStats() {
        Map<String, Long> stats = new HashMap<>();

        LocalDateTime now = LocalDateTime.now();

        for (int i = 11; i >= 0; i--) {
            LocalDateTime monthStart = now.minusMonths(i).withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0);
            LocalDateTime monthEnd = monthStart.plusMonths(1).minusSeconds(1);

            Long count = enrollmentRepository.countByEnrollmentDateBetween(monthStart, monthEnd);
            String monthKey = monthStart.getMonth().toString() + " " + monthStart.getYear();
            stats.put(monthKey, count);
        }

        return stats;
    }

    /**
     * Lấy thống kê chi tiết theo tháng cho instructor
     * @param instructor Instructor
     * @return Map chứa thống kê theo tháng
     */
    public Map<String, Object> getMonthlyStatsByInstructor(User instructor) {
        Map<String, Object> stats = new HashMap<>();

        LocalDateTime now = LocalDateTime.now();
        Map<String, Long> enrollmentsByMonth = new HashMap<>();
        Map<String, Long> completionsByMonth = new HashMap<>();

        for (int i = 11; i >= 0; i--) {
            LocalDateTime monthStart = now.minusMonths(i).withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0);
            LocalDateTime monthEnd = monthStart.plusMonths(1).minusSeconds(1);

            Long enrollments = enrollmentRepository.countByInstructorAndEnrollmentDateBetween(instructor, monthStart, monthEnd);
            Long completions = enrollmentRepository.countByInstructorAndCompletionDateBetween(instructor, monthStart, monthEnd);

            String monthKey = monthStart.getMonth().toString() + " " + monthStart.getYear();
            enrollmentsByMonth.put(monthKey, enrollments);
            completionsByMonth.put(monthKey, completions);
        }

        stats.put("enrollments", enrollmentsByMonth);
        stats.put("completions", completionsByMonth);

        return stats;
    }

    /**
     * Lấy thống kê chi tiết tổng hợp
     * @return Map chứa thống kê chi tiết
     */
    public Map<String, Object> getDetailedMonthlyStats() {
        Map<String, Object> stats = new HashMap<>();

        // Thống kê enrollments và completions theo tháng
        stats.put("monthlyEnrollments", getMonthlyEnrollmentStats());
        stats.put("monthlyCompletions", getMonthlyCompletionStats());

        // Thống kê tổng quan
        stats.put("totalEnrollments", countAllEnrollments());
        stats.put("totalCompletions", countCompletedEnrollments());
        stats.put("averageCompletionRate", getAverageCompletionRate());

        return stats;
    }

    /**
     * Lấy thống kê completions theo tháng
     * @return Map chứa thống kê completions
     */
    private Map<String, Long> getMonthlyCompletionStats() {
        Map<String, Long> stats = new HashMap<>();

        LocalDateTime now = LocalDateTime.now();

        for (int i = 11; i >= 0; i--) {
            LocalDateTime monthStart = now.minusMonths(i).withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0);
            LocalDateTime monthEnd = monthStart.plusMonths(1).minusSeconds(1);

            Long count = enrollmentRepository.countByCompletedAndCompletionDateBetween(true, monthStart, monthEnd);
            String monthKey = monthStart.getMonth().toString() + " " + monthStart.getYear();
            stats.put(monthKey, count);
        }

        return stats;
    }

    /**
     * Lấy tỷ lệ hoàn thành trung bình
     * @return Average completion rate
     */
    public Double getAverageCompletionRate() {
        Long totalEnrollments = countAllEnrollments();
        Long completedEnrollments = countCompletedEnrollments();

        if (totalEnrollments == 0) {
            return 0.0;
        }

        return (completedEnrollments.doubleValue() / totalEnrollments.doubleValue()) * 100.0;
    }

    /**
     * Lấy completion rate cho một course
     * @param course Course
     * @return Completion rate của course
     */
    public Double getCompletionRateByCourse(Course course) {
        Long totalEnrollments = countEnrollmentsByCourse(course);
        Long completedEnrollments = enrollmentRepository.countByCourseAndCompleted(course, true);

        if (totalEnrollments == 0) {
            return 0.0;
        }

        return (completedEnrollments.doubleValue() / totalEnrollments.doubleValue()) * 100.0;
    }

    /**
     * Kiểm tra student đã đăng ký course chưa
     * @param student Student
     * @param course Course
     * @return true nếu đã đăng ký
     */
    public boolean isStudentEnrolled(User student, Course course) {
        return enrollmentRepository.existsByStudentAndCourse(student, course);
    }

    /**
     * Lấy enrollment với student và course
     * @param student Student
     * @param course Course
     * @return Enrollment object hoặc null
     */
    public Enrollment getEnrollmentByStudentAndCourse(User student, Course course) {
        return enrollmentRepository.findByStudentAndCourse(student, course).orElse(null);
    }

    /**
     * Xóa enrollment (unroll from course)
     * @param enrollmentId ID enrollment
     */
    public void deleteEnrollment(Long enrollmentId) {
        Enrollment enrollment = enrollmentRepository.findById(enrollmentId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy enrollment"));

        enrollmentRepository.delete(enrollment);
    }

    /**
     * Lấy tất cả enrollments với pagination
     * @param page Trang
     * @param size Kích thước trang
     * @return Danh sách enrollments
     */
    public List<Enrollment> findAllEnrollments(int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("enrollmentDate").descending());
        return enrollmentRepository.findAll(pageable).getContent();
    }
}