package com.coursemanagement.service;

import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.User;
import com.coursemanagement.entity.Category;
import com.coursemanagement.repository.CourseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * Service class để xử lý business logic liên quan đến Course
 */
@Service
@Transactional
public class CourseService {

    @Autowired
    private CourseRepository courseRepository;

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
     * Xóa khóa học
     * @param id ID của khóa học cần xóa
     * @throws RuntimeException Nếu không tìm thấy khóa học hoặc không thể xóa
     */
    public void deleteCourse(Long id) {
        Course course = courseRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học với ID: " + id));

        // Kiểm tra có thể xóa khóa học không (chưa có học viên đăng ký)
        if (!courseRepository.canDeleteCourse(id)) {
            throw new RuntimeException("Không thể xóa khóa học vì đã có học viên đăng ký");
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
     * Tìm khóa học theo ID và giảng viên (để đảm bảo quyền truy cập)
     * @param id ID của khóa học
     * @param instructor Giảng viên
     * @return Optional<Course>
     */
    public Optional<Course> findByIdAndInstructor(Long id, User instructor) {
        return courseRepository.findByIdAndInstructor(id, instructor);
    }

    /**
     * Lấy tất cả khóa học
     * @return Danh sách tất cả khóa học
     */
    public List<Course> findAll() {
        return courseRepository.findAll();
    }

    /**
     * Lấy tất cả khóa học đang hoạt động
     * @return Danh sách khóa học đang hoạt động
     */
    public List<Course> findAllActiveCourses() {
        return courseRepository.findByIsActive(true);
    }

    /**
     * Lấy khóa học đang hoạt động sắp xếp theo ngày tạo mới nhất
     * @return Danh sách khóa học mới nhất
     */
    public List<Course> findActiveCoursesOrderByLatest() {
        return courseRepository.findAllActiveOrderByCreatedAtDesc();
    }

    /**
     * Lấy khóa học của giảng viên
     * @param instructor Giảng viên
     * @return Danh sách khóa học của giảng viên đó
     */
    public List<Course> findCoursesByInstructor(User instructor) {
        return courseRepository.findByInstructor(instructor);
    }

    /**
     * Lấy khóa học đang hoạt động của giảng viên
     * @param instructor Giảng viên
     * @return Danh sách khóa học đang hoạt động của giảng viên
     */
    public List<Course> findActiveCoursesByInstructor(User instructor) {
        return courseRepository.findByInstructorAndIsActive(instructor, true);
    }

    /**
     * Lấy khóa học theo danh mục
     * @param category Danh mục
     * @return Danh sách khóa học trong danh mục
     */
    public List<Course> findCoursesByCategory(Category category) {
        return courseRepository.findByCategory(category);
    }

    /**
     * Lấy khóa học đang hoạt động theo danh mục
     * @param category Danh mục
     * @return Danh sách khóa học đang hoạt động trong danh mục
     */
    public List<Course> findActiveCoursesByCategory(Category category) {
        return courseRepository.findByCategoryAndIsActive(category, true);
    }

    /**
     * Tìm kiếm khóa học theo từ khóa
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách khóa học chứa từ khóa
     */
    public List<Course> searchCourses(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return courseRepository.findAllActiveOrderByCreatedAtDesc();
        }
        return courseRepository.findByNameOrDescriptionContaining(keyword.trim());
    }

    /**
     * Tìm kiếm khóa học theo tên
     * @param keyword Từ khóa tìm kiếm trong tên
     * @return Danh sách khóa học có tên chứa từ khóa
     */
    public List<Course> searchCoursesByName(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return courseRepository.findAllActiveOrderByCreatedAtDesc();
        }
        return courseRepository.findByNameContainingIgnoreCase(keyword.trim());
    }

    /**
     * Lấy khóa học phổ biến nhất
     * @return Danh sách khóa học sắp xếp theo số lượng đăng ký giảm dần
     */
    public List<Course> findPopularCourses() {
        return courseRepository.findPopularCourses();
    }

    /**
     * Lấy top khóa học phổ biến nhất
     * @param limit Số lượng khóa học cần lấy
     * @return Danh sách top khóa học phổ biến
     */
    public List<Course> findTopPopularCourses(int limit) {
        return courseRepository.findTopPopularCourses(limit);
    }

    /**
     * Lấy khóa học mà học viên đã đăng ký
     * @param studentId ID của học viên
     * @return Danh sách khóa học đã đăng ký
     */
    public List<Course> findEnrolledCoursesByStudent(Long studentId) {
        return courseRepository.findEnrolledCoursesByStudentId(studentId);
    }

    /**
     * Lấy khóa học mà học viên chưa đăng ký
     * @param studentId ID của học viên
     * @return Danh sách khóa học chưa đăng ký
     */
    public List<Course> findAvailableCoursesForStudent(Long studentId) {
        return courseRepository.findAvailableCoursesForStudent(studentId);
    }

    /**
     * Kiểm tra học viên đã đăng ký khóa học chưa
     * @param courseId ID của khóa học
     * @param studentId ID của học viên
     * @return true nếu đã đăng ký, false nếu chưa đăng ký
     */
    public boolean isStudentEnrolled(Long courseId, Long studentId) {
        return courseRepository.isStudentEnrolled(courseId, studentId);
    }

    /**
     * Đếm số học viên đăng ký khóa học
     * @param courseId ID của khóa học
     * @return Số lượng học viên đăng ký
     */
    public long countEnrollmentsByCourse(Long courseId) {
        return courseRepository.countEnrollmentsByCourseId(courseId);
    }

    /**
     * Đếm số bài giảng trong khóa học
     * @param courseId ID của khóa học
     * @return Số lượng bài giảng
     */
    public long countLessonsByCourse(Long courseId) {
        return courseRepository.countLessonsByCourseId(courseId);
    }

    /**
     * Đếm số bài kiểm tra trong khóa học
     * @param courseId ID của khóa học
     * @return Số lượng bài kiểm tra
     */
    public long countQuizzesByCourse(Long courseId) {
        return courseRepository.countQuizzesByCourseId(courseId);
    }

    /**
     * Kiểm tra khóa học có thể xóa được không
     * @param id ID của khóa học
     * @return true nếu có thể xóa, false nếu không thể
     */
    public boolean canDelete(Long id) {
        return courseRepository.canDeleteCourse(id);
    }

    /**
     * Lấy khóa học mới nhất của giảng viên
     * @param instructorId ID của giảng viên
     * @param limit Số lượng khóa học cần lấy
     * @return Danh sách khóa học mới nhất
     */
    public List<Course> findLatestCoursesByInstructor(Long instructorId, int limit) {
        return courseRepository.findLatestCoursesByInstructor(instructorId, limit);
    }

    /**
     * Đếm tổng số khóa học
     * @return Tổng số khóa học
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
     * Đếm số khóa học của giảng viên
     * @param instructor Giảng viên
     * @return Số lượng khóa học
     */
    public long countCoursesByInstructor(User instructor) {
        return courseRepository.countByInstructor(instructor);
    }

    /**
     * Lấy thống kê khóa học theo danh mục
     * @return Danh sách Object[] với [Category, số lượng khóa học]
     */
    public List<Object[]> getCourseStatisticsByCategory() {
        return courseRepository.getCourseStatisticsByCategory();
    }

    /**
     * Lấy thống kê khóa học theo giảng viên
     * @return Danh sách Object[] với [User, số lượng khóa học]
     */
    public List<Object[]> getCourseStatisticsByInstructor() {
        return courseRepository.getCourseStatisticsByInstructor();
    }

    /**
     * Lấy khóa học có nhiều bài giảng nhất
     * @param limit Số lượng khóa học cần lấy
     * @return Danh sách khóa học có nhiều bài giảng nhất
     */
    public List<Course> findCoursesWithMostLessons(int limit) {
        return courseRepository.findCoursesWithMostLessons(limit);
    }

    /**
     * Kích hoạt/vô hiệu hóa khóa học
     * @param courseId ID của khóa học
     * @param isActive Trạng thái kích hoạt
     */
    public void toggleCourseStatus(Long courseId, boolean isActive) {
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy khóa học"));

        course.setActive(isActive);
        courseRepository.save(course);
    }

    /**
     * Validate thông tin khóa học
     * @param course Khóa học cần validate
     * @throws RuntimeException Nếu có lỗi validation
     */
    private void validateCourse(Course course) {
        // Kiểm tra tên khóa học
        if (course.getName() == null || course.getName().trim().isEmpty()) {
            throw new RuntimeException("Tên khóa học không được để trống");
        }

        if (course.getName().trim().length() < 5) {
            throw new RuntimeException("Tên khóa học phải có ít nhất 5 ký tự");
        }

        if (course.getName().trim().length() > 200) {
            throw new RuntimeException("Tên khóa học không được vượt quá 200 ký tự");
        }

        // Kiểm tra danh mục
        if (course.getCategory() == null) {
            throw new RuntimeException("Phải chọn danh mục cho khóa học");
        }

        // Kiểm tra giảng viên
        if (course.getInstructor() == null) {
            throw new RuntimeException("Phải có giảng viên cho khóa học");
        }

        // Kiểm tra vai trò của giảng viên
        if (course.getInstructor().getRole() != User.Role.INSTRUCTOR) {
            throw new RuntimeException("Chỉ có giảng viên mới có thể tạo khóa học");
        }

        // Trim các trường text
        course.setName(course.getName().trim());
        if (course.getDescription() != null) {
            course.setDescription(course.getDescription().trim());
        }
    }

    /**
     * Kiểm tra quyền truy cập khóa học
     * @param courseId ID khóa học
     * @param userId ID người dùng
     * @param role Vai trò người dùng
     * @return true nếu có quyền truy cập, false nếu không có
     */
    public boolean hasAccessToCourse(Long courseId, Long userId, User.Role role) {
        Optional<Course> courseOpt = courseRepository.findById(courseId);
        if (courseOpt.isEmpty()) {
            return false;
        }

        Course course = courseOpt.get();

        // Admin có quyền truy cập tất cả
        if (role == User.Role.ADMIN) {
            return true;
        }

        // Giảng viên chỉ truy cập được khóa học của mình
        if (role == User.Role.INSTRUCTOR) {
            return course.getInstructor().getId().equals(userId);
        }

        // Học viên chỉ truy cập được khóa học đã đăng ký và đang hoạt động
        if (role == User.Role.STUDENT) {
            return course.isActive() && isStudentEnrolled(courseId, userId);
        }

        return false;
    }
}