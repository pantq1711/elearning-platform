package com.coursemanagement.service;

import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.Enrollment;
import com.coursemanagement.entity.User;
import com.coursemanagement.repository.EnrollmentRepository;
import org.springframework.beans.factory.annotation.Autowired;
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

/**
 * Service class để xử lý business logic liên quan đến Enrollment
 * Quản lý việc đăng ký khóa học và theo dõi tiến độ học tập
 */
@Service
@Transactional
public class EnrollmentService {

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    /**
     * Class để chứa thống kê enrollment của student
     */
    public static class EnrollmentStats {
        private Long totalEnrollments;
        private Long activeEnrollments;
        private Long completedEnrollments;
        private Double completionRate;
        private Double averageScore;
        private Long totalStudyHours;

        public EnrollmentStats() {}

        public EnrollmentStats(Long totalEnrollments, Long activeEnrollments,
                               Long completedEnrollments, Double averageScore) {
            this.totalEnrollments = totalEnrollments;
            this.activeEnrollments = activeEnrollments;
            this.completedEnrollments = completedEnrollments;
            this.averageScore = averageScore;

            // Tính completion rate
            if (totalEnrollments > 0) {
                this.completionRate = (double) completedEnrollments / totalEnrollments * 100;
            } else {
                this.completionRate = 0.0;
            }
        }

        // Getters và Setters
        public Long getTotalEnrollments() { return totalEnrollments; }
        public void setTotalEnrollments(Long totalEnrollments) { this.totalEnrollments = totalEnrollments; }

        public Long getActiveEnrollments() { return activeEnrollments; }
        public void setActiveEnrollments(Long activeEnrollments) { this.activeEnrollments = activeEnrollments; }

        public Long getCompletedEnrollments() { return completedEnrollments; }
        public void setCompletedEnrollments(Long completedEnrollments) { this.completedEnrollments = completedEnrollments; }

        public Double getCompletionRate() { return completionRate; }
        public void setCompletionRate(Double completionRate) { this.completionRate = completionRate; }

        public Double getAverageScore() { return averageScore; }
        public void setAverageScore(Double averageScore) { this.averageScore = averageScore; }

        public Long getTotalStudyHours() { return totalStudyHours; }
        public void setTotalStudyHours(Long totalStudyHours) { this.totalStudyHours = totalStudyHours; }
    }

    /**
     * Tìm enrollment theo ID
     * @param id ID của enrollment
     * @return Optional chứa Enrollment nếu tìm thấy
     */
    public Optional<Enrollment> findById(Long id) {
        return enrollmentRepository.findById(id);
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
     * Kiểm tra student đã đăng ký course chưa
     * @param studentId ID của student
     * @param courseId ID của course
     * @return true nếu đã đăng ký
     */
    public boolean isStudentEnrolled(Long studentId, Long courseId) {
        return enrollmentRepository.existsByStudentIdAndCourseId(studentId, courseId);
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
     * Đăng ký student vào course
     * @param student Student
     * @param course Course
     * @return Enrollment đã được tạo
     */
    public Enrollment enrollStudent(User student, Course course) {
        // Kiểm tra đã đăng ký chưa
        if (isStudentEnrolled(student, course)) {
            throw new RuntimeException("Bạn đã đăng ký khóa học này rồi");
        }

        // Tạo enrollment mới
        Enrollment enrollment = new Enrollment();
        enrollment.setStudent(student);
        enrollment.setCourse(course);
        enrollment.setEnrollmentDate(LocalDateTime.now());
        enrollment.setCompleted(false);
        enrollment.setProgress(0.0);
        enrollment.setScore(0.0);

        return enrollmentRepository.save(enrollment);
    }

    /**
     * Hủy đăng ký student khỏi course
     * @param student Student
     * @param course Course
     */
    public void unenrollStudent(User student, Course course) {
        Enrollment enrollment = findByStudentAndCourse(student, course)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đăng ký khóa học"));

        enrollmentRepository.delete(enrollment);
    }

    /**
     * Lấy thống kê enrollment của student
     * @param student Student
     * @return EnrollmentStats
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
     * Tìm active enrollments của student
     * @param student Student
     * @return Danh sách active enrollments
     */
    public List<Enrollment> findActiveEnrollmentsByStudent(User student) {
        return enrollmentRepository.findByStudentAndCompletedOrderByEnrollmentDateDesc(student, false);
    }

    /**
     * Tìm completed enrollments của student
     * @param student Student
     * @return Danh sách completed enrollments
     */
    public List<Enrollment> findCompletedEnrollmentsByStudent(User student) {
        return enrollmentRepository.findByStudentAndCompletedOrderByCompletionDateDesc(student, true);
    }

    /**
     * Tìm tất cả enrollments của student
     * @param student Student
     * @return Danh sách enrollments
     */
    public List<Enrollment> findEnrollmentsByStudent(User student) {
        return enrollmentRepository.findByStudentOrderByEnrollmentDateDesc(student);
    }

    /**
     * Tìm enrollments với scores của student
     * @param student Student
     * @return Danh sách enrollments có điểm số
     */
    public List<Enrollment> findEnrollmentsWithScoresByStudent(User student) {
        return enrollmentRepository.findByStudentAndScoreGreaterThanOrderByScoreDesc(student, 0.0);
    }

    /**
     * Đếm tất cả enrollments
     * @return Tổng số enrollments
     */
    public Long countAllEnrollments() {
        return enrollmentRepository.count();
    }

    /**
     * Đếm students của instructor
     * @param instructor Instructor
     * @return Số lượng students
     */
    public Long countStudentsByInstructor(User instructor) {
        return enrollmentRepository.countStudentsByInstructor(instructor);
    }

    /**
     * Tính revenue của instructor
     * @param instructor Instructor
     * @return Tổng revenue
     */
    public Long calculateRevenueByInstructor(User instructor) {
        Double revenue = enrollmentRepository.calculateRevenueByInstructor(instructor);
        return revenue != null ? revenue.longValue() : 0L;
    }

    /**
     * Tìm recent enrollments của instructor
     * @param instructor Instructor
     * @param limit Số lượng giới hạn
     * @return Danh sách recent enrollments
     */
    public List<Enrollment> findRecentEnrollmentsByInstructor(User instructor, int limit) {
        Pageable pageable = PageRequest.of(0, limit, Sort.by(Sort.Direction.DESC, "enrollmentDate"));
        return enrollmentRepository.findRecentEnrollmentsByInstructor(instructor, pageable);
    }

    /**
     * Cập nhật progress của enrollment
     * @param enrollment Enrollment
     * @param progress Progress percentage (0-100)
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
     * Cập nhật score của enrollment
     * @param enrollment Enrollment
     * @param score Score
     */
    public void updateScore(Enrollment enrollment, Double score) {
        enrollment.setScore(score);
        enrollmentRepository.save(enrollment);
    }

    /**
     * Hoàn thành enrollment
     * @param enrollment Enrollment
     * @param finalScore Điểm cuối khóa
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
     * Tìm enrollments theo course với pagination
     * @param course Course
     * @param pageable Pagination info
     * @return Page enrollments
     */
    public Page<Enrollment> findEnrollmentsByCourse(Course course, Pageable pageable) {
        return enrollmentRepository.findByCourseOrderByEnrollmentDateDesc(course, pageable);
    }

    /**
     * Lấy thống kê enrollments theo tháng
     * @return Map chứa thống kê theo tháng
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
     * Lấy top students theo điểm số
     * @param limit Số lượng giới hạn
     * @return Danh sách top students
     */
    public List<Object[]> findTopStudentsByScore(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return enrollmentRepository.findTopStudentsByAverageScore(pageable);
    }

    /**
     * Tìm enrollments cần attention (low progress, overdue)
     * @param instructor Instructor
     * @return Danh sách enrollments cần attention
     */
    public List<Enrollment> findEnrollmentsNeedingAttention(User instructor) {
        LocalDateTime oneWeekAgo = LocalDateTime.now().minusWeeks(1);
        return enrollmentRepository.findLowProgressEnrollments(instructor, 25.0, oneWeekAgo);
    }
}