package com.coursemanagement.service;

import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.User;
import com.coursemanagement.entity.Category;
import com.coursemanagement.repository.CourseRepository;
import com.coursemanagement.repository.EnrollmentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.Map;
import java.util.HashMap;

/**
 * Service class để xử lý business logic liên quan đến Course
 */
@Service
@Transactional
public class CourseService {

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    /**
     * Tạo khóa học mới
     * @param course Khóa học cần tạo
     * @return Course đã được tạo
     * @throws RuntimeException Nếu có lỗi validation
     */
    public Course createCourse(Course course) {
        // Validate thông tin khóa học
        validateCourse(course);

        // Đảm bảo khóa học được kích hoạt
        course.setActive(true);

        return courseRepository.save(course);
    }

    /**
     * Cập nhật thông tin khóa học
     * @param id ID của khóa học cần cập nhật
     * @param updatedCourse Thông tin khóa học mới
     * @return Course đã được cập nhật
     * @throws RuntimeException Nếu không tìm thấy khóa học hoặc có lỗi validation
     */
    public Course updateCourse(Long id, Course updatedCourse) {
        // Tìm khóa học hiện tại
        Course existingCourse = courseRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học với ID: " + id));

        // Validate thông tin khóa học mới
        validateCourse(updatedCourse);

        // Cập nhật thông tin
        existingCourse.setName(updatedCourse.getName());
        existingCourse.setDescription(updatedCourse.getDescription());
        existingCourse.setCategory(updatedCourse.getCategory());
        existingCourse.setActive(updatedCourse.isActive());

        return courseRepository.save(existingCourse);
    }

    /**
     * Xóa khóa học (chỉ khi chưa có học viên đăng ký)
     * @param id ID của khóa học cần xóa
     * @throws RuntimeException Nếu không tìm thấy khóa học hoặc không thể xóa
     */
    public void deleteCourse(Long id) {
        Course course = courseRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học với ID: " + id));

        // Kiểm tra có học viên đăng ký không
        long enrollmentCount = enrollmentRepository.countByCourse(course);
        if (enrollmentCount > 0) {
            throw new RuntimeException("Không thể xóa khóa học đã có học viên đăng ký");
        }

        courseRepository.delete(course);
    }

    /**
     * Tìm khóa học theo ID
     * @param id ID của khóa học
     * @return Optional<Course>
     */
    public Optional<Course> findById(Long id) {
        return courseRepository.findById(id);
    }

    /**
     * Tìm tất cả khóa học đang hoạt động
     * @return Danh sách khóa học đang hoạt động
     */
    public List<Course> findAllActiveCourses() {
        return courseRepository.findByIsActive(true);
    }

    /**
     * Tìm khóa học theo giảng viên
     * @param instructor Giảng viên
     * @return Danh sách khóa học của giảng viên
     */
    public List<Course> findByInstructor(User instructor) {
        if (instructor == null || instructor.getRole() != User.Role.INSTRUCTOR) {
            throw new RuntimeException("Giảng viên không hợp lệ");
        }
        return courseRepository.findByInstructor(instructor);
    }

    /**
     * Tìm khóa học theo danh mục
     * @param category Danh mục
     * @return Danh sách khóa học trong danh mục
     */
    public List<Course> findByCategory(Category category) {
        if (category == null) {
            throw new RuntimeException("Danh mục không hợp lệ");
        }
        return courseRepository.findByCategoryAndIsActive(category, true);
    }

    /**
     * Tìm kiếm khóa học theo từ khóa
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách khóa học chứa từ khóa
     */
    public List<Course> searchCourses(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return findAllActiveCourses();
        }
        return courseRepository.findByNameContainingIgnoreCaseAndIsActive(keyword.trim(), true);
    }

    /**
     * Đếm tổng số khóa học
     * @return Số lượng khóa học
     */
    public long countAllCourses() {
        return courseRepository.count();
    }

    /**
     * Đếm số khóa học đang hoạt động
     * @return Số lượng khóa học đang hoạt động
     */
    public long countActiveCourses() {
        return courseRepository.countByIsActive(true);
    }

    /**
     * Lấy khóa học phổ biến nhất (theo số lượng đăng ký)
     * @param limit Số lượng khóa học cần lấy
     * @return Danh sách khóa học phổ biến
     */
    public List<Course> findTopPopularCourses(int limit) {
        return courseRepository.findTopPopularCourses(limit);
    }

    /**
     * Lấy thống kê khóa học theo danh mục
     * @return Map<CategoryName, CourseCount>
     */
    public Map<String, Long> getCourseStatisticsByCategory() {
        List<Object[]> results = courseRepository.getCourseCountByCategory();
        Map<String, Long> stats = new HashMap<>();

        for (Object[] result : results) {
            String categoryName = (String) result[0];
            Long courseCount = (Long) result[1];
            stats.put(categoryName, courseCount);
        }

        return stats;
    }

    /**
     * Kiểm tra học viên có thể đăng ký khóa học không
     * @param courseId ID khóa học
     * @param student Học viên
     * @return true nếu có thể đăng ký, false nếu không thể
     */
    public boolean canStudentEnroll(Long courseId, User student) {
        if (student == null || student.getRole() != User.Role.STUDENT) {
            return false;
        }

        Optional<Course> courseOpt = findById(courseId);
        if (courseOpt.isEmpty() || !courseOpt.get().isActive()) {
            return false;
        }

        // Kiểm tra đã đăng ký chưa
        return !enrollmentRepository.existsByStudentAndCourse(student, courseOpt.get());
    }

    /**
     * Validate thông tin khóa học
     * @param course Khóa học cần validate
     * @throws RuntimeException Nếu validation fail
     */
    private void validateCourse(Course course) {
        if (course == null) {
            throw new RuntimeException("Thông tin khóa học không được để trống");
        }

        if (course.getName() == null || course.getName().trim().isEmpty()) {
            throw new RuntimeException("Tên khóa học không được để trống");
        }

        if (course.getName().trim().length() < 5) {
            throw new RuntimeException("Tên khóa học phải có ít nhất 5 ký tự");
        }

        if (course.getName().trim().length() > 200) {
            throw new RuntimeException("Tên khóa học không được vượt quá 200 ký tự");
        }

        if (course.getDescription() == null || course.getDescription().trim().isEmpty()) {
            throw new RuntimeException("Mô tả khóa học không được để trống");
        }

        if (course.getDescription().trim().length() < 10) {
            throw new RuntimeException("Mô tả khóa học phải có ít nhất 10 ký tự");
        }

        if (course.getCategory() == null) {
            throw new RuntimeException("Danh mục khóa học không được để trống");
        }

        if (course.getInstructor() == null) {
            throw new RuntimeException("Giảng viên không được để trống");
        }

        if (course.getInstructor().getRole() != User.Role.INSTRUCTOR) {
            throw new RuntimeException("Người được chỉ định phải có vai trò Giảng viên");
        }
    }
}