package com.coursemanagement.service;

import com.coursemanagement.entity.Enrollment;
import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.User;
import com.coursemanagement.repository.EnrollmentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Service class để xử lý business logic liên quan đến Enrollment
 */
@Service
@Transactional
public class EnrollmentService {

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    /**
     * Đăng ký khóa học cho học viên
     * @param student Học viên
     * @param course Khóa học
     * @return Enrollment đã được tạo
     * @throws RuntimeException Nếu đã đăng ký hoặc có lỗi validation
     */
    public Enrollment enrollStudent(User student, Course course) {
        // Kiểm tra học viên đã đăng ký khóa học chưa
        if (enrollmentRepository.existsByStudentAndCourse(student, course)) {
            throw new RuntimeException("Học viên đã đăng ký khóa học này rồi");
        }

        // Kiểm tra khóa học có đang hoạt động không
        if (!course.isActive()) {
            throw new RuntimeException("Khóa học hiện tại không khả dụng");
        }

        // Kiểm tra vai trò của user
        if (student.getRole() != User.Role.STUDENT) {
            throw new RuntimeException("Chỉ học viên mới có thể đăng ký khóa học");
        }

        // Tạo enrollment mới
        Enrollment enrollment = new Enrollment(student, course);
        return enrollmentRepository.save(enrollment);
    }

    /**
     * Hủy đăng ký khóa học
     * @param student Học viên
     * @param course Khóa học
     * @throws RuntimeException Nếu không tìm thấy đăng ký
     */
    public void unenrollStudent(User student, Course course) {
        Enrollment enrollment = enrollmentRepository.findByStudentAndCourse(student, course)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đăng ký khóa học"));

        enrollmentRepository.delete(enrollment);
    }

    /**
     * Hoàn thành khóa học
     * @param enrollmentId ID đăng ký khóa học
     * @throws RuntimeException Nếu không tìm thấy đăng ký
     */
    public void completeEnrollment(Long enrollmentId) {
        Enrollment enrollment = enrollmentRepository.findById(enrollmentId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đăng ký khóa học"));

        enrollment.markAsCompleted();
        enrollmentRepository.save(enrollment);
    }

    /**
     * Đánh dấu chưa hoàn thành khóa học
     * @param enrollmentId ID đăng ký khóa học
     * @throws RuntimeException Nếu không tìm thấy đăng ký
     */
    public void markAsIncomplete(Long enrollmentId) {
        Enrollment enrollment = enrollmentRepository.findById(enrollmentId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đăng ký khóa học"));

        enrollment.markAsIncomplete();
        enrollmentRepository.save(enrollment);
    }

    /**
     * Cập nhật điểm cao nhất của học viên
     * @param student Học viên
     * @param course Khóa học
     * @param score Điểm mới
     */
    public void updateHighestScore(User student, Course course, Double score) {
        Optional<Enrollment> enrollmentOpt = enrollmentRepository.findByStudentAndCourse(student, course);

        if (enrollmentOpt.isPresent()) {
            Enrollment enrollment = enrollmentOpt.get();
            enrollment.updateHighestScore(score);
            enrollmentRepository.save(enrollment);
        }
    }

    /**
     * Tìm đăng ký theo học viên và khóa học
     * @param student Học viên
     * @param course Khóa học
     * @return Optional<Enrollment>
     */
    public Optional<Enrollment> findByStudentAndCourse(User student, Course course) {
        return enrollmentRepository.findByStudentAndCourse(student, course);
    }

    /**
     * Lấy tất cả đăng ký của học viên
     * @param student Học viên
     * @return Danh sách đăng ký sắp xếp theo ngày đăng ký mới nhất
     */
    public List<Enrollment> findEnrollmentsByStudent(User student) {
        return enrollmentRepository.findByStudentOrderByEnrolledAtDesc(student);
    }

    /**
     * Lấy tất cả đăng ký của khóa học
     * @param course Khóa học
     * @return Danh sách đăng ký sắp xếp theo ngày đăng ký
     */
    public List<Enrollment> findEnrollmentsByCourse(Course course) {
        return enrollmentRepository.findByCourseOrderByEnrolledAt(course);
    }

    /**
     * Lấy đăng ký đang học của học viên (chưa hoàn thành)
     * @param student Học viên
     * @return Danh sách đăng ký đang học
     */
    public List<Enrollment> findActiveEnrollmentsByStudent(User student) {
        return enrollmentRepository.findActiveEnrollmentsByStudent(student);
    }

    /**
     * Lấy đăng ký đã hoàn thành của học viên
     * @param student Học viên
     * @return Danh sách đăng ký đã hoàn thành
     */
    public List<Enrollment> findCompletedEnrollmentsByStudent(User student) {
        return enrollmentRepository.findCompletedEnrollmentsByStudent(student);
    }

    /**
     * Kiểm tra học viên đã đăng ký khóa học chưa
     * @param student Học viên
     * @param course Khóa học
     * @return true nếu đã đăng ký, false nếu chưa đăng ký
     */
    public boolean isStudentEnrolled(User student, Course course) {
        return enrollmentRepository.existsByStudentAndCourse(student, course);
    }

    /**
     * Đếm số học viên đăng ký khóa học
     * @param course Khóa học
     * @return Số lượng học viên đăng ký
     */
    public long countEnrollmentsByCourse(Course course) {
        return enrollmentRepository.countByCourse(course);
    }

    /**
     * Đếm số khóa học học viên đã đăng ký
     * @param student Học viên
     * @return Số lượng khóa học đã đăng ký
     */
    public long countEnrollmentsByStudent(User student) {
        return enrollmentRepository.countByStudent(student);
    }

    /**
     * Đếm số khóa học học viên đã hoàn thành
     * @param student Học viên
     * @return Số lượng khóa học đã hoàn thành
     */
    public long countCompletedEnrollmentsByStudent(User student) {
        return enrollmentRepository.countByStudentAndIsCompleted(student, true);
    }

    /**
     * Đếm số khóa học học viên đang học
     * @param student Học viên
     * @return Số lượng khóa học đang học
     */
    public long countActiveEnrollmentsByStudent(User student) {
        return enrollmentRepository.countByStudentAndIsCompleted(student, false);
    }

    /**
     * Lấy học viên đăng ký gần đây nhất của khóa học
     * @param course Khóa học
     * @param limit Số lượng học viên cần lấy
     * @return Danh sách học viên đăng ký gần đây
     */
    public List<Enrollment> getRecentEnrollmentsByCourse(Course course, int limit) {
        return enrollmentRepository.findRecentEnrollmentsByCourse(course, limit);
    }

    /**
     * Lấy khóa học phổ biến nhất (có nhiều đăng ký nhất)
     * @param limit Số lượng khóa học cần lấy
     * @return Danh sách Object[] với [Course, số lượng đăng ký]
     */
    public List<Object[]> getMostPopularCourses(int limit) {
        return enrollmentRepository.findMostPopularCourses(limit);
    }

    /**
     * Lấy học viên tích cực nhất (đăng ký nhiều khóa học nhất)
     * @param limit Số lượng học viên cần lấy
     * @return Danh sách Object[] với [User, số lượng đăng ký]
     */
    public List<Object[]> getMostActiveStudents(int limit) {
        return enrollmentRepository.findMostActiveStudents(limit);
    }

    /**
     * Lấy đăng ký trong khoảng thời gian
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Danh sách đăng ký trong khoảng thời gian
     */
    public List<Enrollment> findEnrollmentsBetweenDates(LocalDateTime startDate, LocalDateTime endDate) {
        return enrollmentRepository.findByEnrolledAtBetween(startDate, endDate);
    }

    /**
     * Đếm đăng ký trong khoảng thời gian
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Số lượng đăng ký
     */
    public long countEnrollmentsBetweenDates(LocalDateTime startDate, LocalDateTime endDate) {
        return enrollmentRepository.countByEnrolledAtBetween(startDate, endDate);
    }

    /**
     * Lấy học viên có điểm cao nhất trong khóa học
     * @param course Khóa học
     * @return Danh sách đăng ký sắp xếp theo điểm cao nhất
     */
    public List<Enrollment> findTopScoresByCourse(Course course) {
        return enrollmentRepository.findByCourseOrderByHighestScoreDesc(course);
    }

    /**
     * Lấy điểm trung bình của khóa học
     * @param course Khóa học
     * @return Điểm trung bình hoặc 0 nếu không có điểm
     */
    public Double getAverageScoreByCourse(Course course) {
        return enrollmentRepository.getAverageScoreByCourse(course);
    }

    /**
     * Lấy tất cả đăng ký của giảng viên (từ tất cả khóa học của giảng viên)
     * @param instructor Giảng viên
     * @return Danh sách đăng ký
     */
    public List<Enrollment> findEnrollmentsByInstructor(User instructor) {
        return enrollmentRepository.findByInstructor(instructor);
    }

    /**
     * Đếm tổng số học viên của giảng viên
     * @param instructor Giảng viên
     * @return Tổng số học viên đăng ký khóa học của giảng viên
     */
    public long countStudentsByInstructor(User instructor) {
        return enrollmentRepository.countStudentsByInstructor(instructor);
    }

    /**
     * Lấy khóa học học viên đã có điểm
     * @param student Học viên
     * @return Danh sách đăng ký có điểm
     */
    public List<Enrollment> findEnrollmentsWithScoresByStudent(User student) {
        return enrollmentRepository.findByStudentWithScores(student);
    }

    /**
     * Lấy học viên chưa có điểm trong khóa học
     * @param course Khóa học
     * @return Danh sách đăng ký chưa có điểm
     */
    public List<Enrollment> findEnrollmentsWithoutScoresByCourse(Course course) {
        return enrollmentRepository.findByCourseWithoutScores(course);
    }

    /**
     * Lấy thống kê đăng ký theo tháng
     * @param year Năm cần thống kê
     * @return Danh sách Object[] với [tháng, số lượng đăng ký]
     */
    public List<Object[]> getEnrollmentStatisticsByMonth(int year) {
        return enrollmentRepository.getEnrollmentStatisticsByMonth(year);
    }

    /**
     * Lấy top học viên có điểm trung bình cao nhất
     * @param limit Số lượng học viên cần lấy
     * @return Danh sách Object[] với [User, điểm trung bình]
     */
    public List<Object[]> getTopStudentsByAverageScore(int limit) {
        return enrollmentRepository.findTopStudentsByAverageScore(limit);
    }

    /**
     * Tính tỷ lệ hoàn thành khóa học
     * @param course Khóa học
     * @return Tỷ lệ hoàn thành (0-100)
     */
    public Double getCompletionRateByCourse(Course course) {
        return enrollmentRepository.getCompletionRateByCourse(course);
    }

    /**
     * Lấy thống kê tổng quát của học viên
     * @param student Học viên
     * @return Object chứa thông tin thống kê
     */
    public EnrollmentStats getStudentStats(User student) {
        long totalEnrollments = countEnrollmentsByStudent(student);
        long completedEnrollments = countCompletedEnrollmentsByStudent(student);
        long activeEnrollments = countActiveEnrollmentsByStudent(student);

        return new EnrollmentStats(totalEnrollments, completedEnrollments, activeEnrollments);
    }

    /**
     * Lấy thống kê tổng quát của khóa học
     * @param course Khóa học
     * @return Object chứa thông tin thống kê
     */
    public CourseStats getCourseStats(Course course) {
        long totalEnrollments = countEnrollmentsByCourse(course);
        Double averageScore = getAverageScoreByCourse(course);
        Double completionRate = getCompletionRateByCourse(course);

        return new CourseStats(totalEnrollments, averageScore, completionRate);
    }

    /**
     * Class để lưu thống kê học viên
     */
    public static class EnrollmentStats {
        private final long totalEnrollments;
        private final long completedEnrollments;
        private final long activeEnrollments;

        public EnrollmentStats(long totalEnrollments, long completedEnrollments, long activeEnrollments) {
            this.totalEnrollments = totalEnrollments;
            this.completedEnrollments = completedEnrollments;
            this.activeEnrollments = activeEnrollments;
        }

        public long getTotalEnrollments() { return totalEnrollments; }
        public long getCompletedEnrollments() { return completedEnrollments; }
        public long getActiveEnrollments() { return activeEnrollments; }

        public double getCompletionRate() {
            if (totalEnrollments == 0) return 0.0;
            return (double) completedEnrollments / totalEnrollments * 100;
        }
    }

    /**
     * Class để lưu thống kê khóa học
     */
    public static class CourseStats {
        private final long totalEnrollments;
        private final Double averageScore;
        private final Double completionRate;

        public CourseStats(long totalEnrollments, Double averageScore, Double completionRate) {
            this.totalEnrollments = totalEnrollments;
            this.averageScore = averageScore != null ? averageScore : 0.0;
            this.completionRate = completionRate != null ? completionRate : 0.0;
        }

        public long getTotalEnrollments() { return totalEnrollments; }
        public Double getAverageScore() { return averageScore; }
        public Double getCompletionRate() { return completionRate; }
    }
}