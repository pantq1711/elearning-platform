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
        // Validate đầu vào
        validateEnrollmentInput(student, course);

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
        // Validate đầu vào
        validateEnrollmentInput(student, course);

        Enrollment enrollment = enrollmentRepository.findByStudentAndCourse(student, course)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đăng ký khóa học"));

        // Kiểm tra khóa học đã hoàn thành chưa
        if (enrollment.isCompleted()) {
            throw new RuntimeException("Không thể hủy đăng ký khóa học đã hoàn thành");
        }

        enrollmentRepository.delete(enrollment);
    }

    /**
     * Hoàn thành khóa học
     * @param enrollmentId ID của enrollment
     * @param finalScore Điểm cuối khóa
     * @throws RuntimeException Nếu không tìm thấy enrollment
     */
    public void completeEnrollment(Long enrollmentId, Double finalScore) {
        Enrollment enrollment = enrollmentRepository.findById(enrollmentId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đăng ký khóa học với ID: " + enrollmentId));

        // Kiểm tra khóa học đã hoàn thành chưa
        if (enrollment.isCompleted()) {
            throw new RuntimeException("Khóa học đã được hoàn thành trước đó");
        }

        // Cập nhật thông tin hoàn thành
        enrollment.setCompleted(true);
        enrollment.setCompletedAt(LocalDateTime.now());

        if (finalScore != null) {
            // Cập nhật điểm cao nhất nếu điểm mới cao hơn
            if (enrollment.getHighestScore() == null || finalScore > enrollment.getHighestScore()) {
                enrollment.setHighestScore(finalScore);
            }
        }

        enrollmentRepository.save(enrollment);
    }

    /**
     * Cập nhật điểm cao nhất cho enrollment
     * @param enrollmentId ID của enrollment
     * @param score Điểm mới
     */
    public void updateHighestScore(Long enrollmentId, Double score) {
        if (score == null || score < 0 || score > 100) {
            throw new RuntimeException("Điểm số phải nằm trong khoảng 0-100");
        }

        Enrollment enrollment = enrollmentRepository.findById(enrollmentId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đăng ký khóa học với ID: " + enrollmentId));

        // Cập nhật điểm cao nhất nếu điểm mới cao hơn
        if (enrollment.getHighestScore() == null || score > enrollment.getHighestScore()) {
            enrollment.setHighestScore(score);
            enrollmentRepository.save(enrollment);
        }
    }

    /**
     * Tìm enrollment theo học viên và khóa học
     * @param student Học viên
     * @param course Khóa học
     * @return Optional<Enrollment>
     */
    public Optional<Enrollment> findByStudentAndCourse(User student, Course course) {
        if (student == null || course == null) {
            return Optional.empty();
        }
        return enrollmentRepository.findByStudentAndCourse(student, course);
    }

    /**
     * Tìm tất cả enrollment của học viên
     * @param student Học viên
     * @return Danh sách enrollment của học viên
     */
    public List<Enrollment> findByStudent(User student) {
        if (student == null || student.getRole() != User.Role.STUDENT) {
            throw new RuntimeException("Học viên không hợp lệ");
        }
        return enrollmentRepository.findByStudentOrderByEnrolledAtDesc(student);
    }

    /**
     * Tìm tất cả enrollment của khóa học
     * @param course Khóa học
     * @return Danh sách enrollment của khóa học
     */
    public List<Enrollment> findByCourse(Course course) {
        if (course == null) {
            throw new RuntimeException("Khóa học không hợp lệ");
        }
        return enrollmentRepository.findByCourseOrderByEnrolledAt(course);
    }

    /**
     * Tìm enrollment đang học của học viên (chưa hoàn thành)
     * @param student Học viên
     * @return Danh sách enrollment đang học
     */
    public List<Enrollment> findActiveEnrollmentsByStudent(User student) {
        if (student == null || student.getRole() != User.Role.STUDENT) {
            throw new RuntimeException("Học viên không hợp lệ");
        }
        return enrollmentRepository.findActiveEnrollmentsByStudent(student);
    }

    /**
     * Tìm enrollment đã hoàn thành của học viên
     * @param student Học viên
     * @return Danh sách enrollment đã hoàn thành
     */
    public List<Enrollment> findCompletedEnrollmentsByStudent(User student) {
        if (student == null || student.getRole() != User.Role.STUDENT) {
            throw new RuntimeException("Học viên không hợp lệ");
        }
        return enrollmentRepository.findByStudentAndIsCompleted(student, true);
    }

    /**
     * Kiểm tra học viên có đăng ký khóa học không
     * @param student Học viên
     * @param course Khóa học
     * @return true nếu đã đăng ký, false nếu chưa
     */
    public boolean isStudentEnrolled(User student, Course course) {
        if (student == null || course == null) {
            return false;
        }
        return enrollmentRepository.existsByStudentAndCourse(student, course);
    }

    /**
     * Đếm số học viên đã đăng ký khóa học
     * @param course Khóa học
     * @return Số lượng học viên đã đăng ký
     */
    public long countStudentsByCourse(Course course) {
        if (course == null) {
            return 0;
        }
        return enrollmentRepository.countByCourse(course);
    }

    /**
     * Đếm số khóa học học viên đã đăng ký
     * @param student Học viên
     * @return Số lượng khóa học đã đăng ký
     */
    public long countCoursesByStudent(User student) {
        if (student == null || student.getRole() != User.Role.STUDENT) {
            return 0;
        }
        return enrollmentRepository.countByStudent(student);
    }

    /**
     * Đếm số khóa học đã hoàn thành của học viên
     * @param student Học viên
     * @return Số lượng khóa học đã hoàn thành
     */
    public long countCompletedCoursesByStudent(User student) {
        if (student == null || student.getRole() != User.Role.STUDENT) {
            return 0;
        }
        return enrollmentRepository.countByStudentAndIsCompleted(student, true);
    }

    /**
     * Tính điểm trung bình của học viên
     * @param student Học viên
     * @return Điểm trung bình (null nếu chưa có điểm nào)
     */
    public Double calculateAverageScore(User student) {
        if (student == null || student.getRole() != User.Role.STUDENT) {
            return null;
        }

        List<Enrollment> enrollments = findByStudent(student);
        return enrollments.stream()
                .filter(e -> e.getHighestScore() != null)
                .mapToDouble(Enrollment::getHighestScore)
                .average()
                .orElse(0.0);
    }

    /**
     * Lấy enrollment gần đây nhất
     * @param limit Số lượng enrollment cần lấy
     * @return Danh sách enrollment gần đây
     */
    public List<Enrollment> getRecentEnrollments(int limit) {
        return enrollmentRepository.findTopByOrderByEnrolledAtDesc(limit);
    }

    /**
     * Validate đầu vào cho enrollment operations
     * @param student Học viên
     * @param course Khóa học
     */
    private void validateEnrollmentInput(User student, Course course) {
        if (student == null) {
            throw new RuntimeException("Thông tin học viên không được để trống");
        }

        if (course == null) {
            throw new RuntimeException("Thông tin khóa học không được để trống");
        }

        if (student.getRole() != User.Role.STUDENT) {
            throw new RuntimeException("Chỉ học viên mới có thể thực hiện thao tác này");
        }

        if (!student.isActive()) {
            throw new RuntimeException("Tài khoản học viên đã bị khóa");
        }
    }
}