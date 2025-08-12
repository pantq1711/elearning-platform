package com.coursemanagement.service;

import com.coursemanagement.entity.Lesson;
import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.User;
import com.coursemanagement.repository.LessonRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * Service class để xử lý business logic liên quan đến Lesson
 */
@Service
@Transactional
public class LessonService {

    @Autowired
    private LessonRepository lessonRepository;

    @Autowired
    private EnrollmentService enrollmentService;

    /**
     * Tạo bài giảng mới
     * @param lesson Bài giảng cần tạo
     * @return Lesson đã được tạo
     * @throws RuntimeException Nếu có lỗi validation
     */
    public Lesson createLesson(Lesson lesson) {
        // Validate thông tin bài giảng
        validateLesson(lesson);

        // Đảm bảo bài giảng được kích hoạt
        lesson.setActive(true);

        // Tự động set order index nếu chưa có
        if (lesson.getOrderIndex() == null || lesson.getOrderIndex() <= 0) {
            int nextOrder = getNextOrderIndex(lesson.getCourse());
            lesson.setOrderIndex(nextOrder);
        }

        return lessonRepository.save(lesson);
    }

    /**
     * Cập nhật thông tin bài giảng
     * @param id ID của bài giảng cần cập nhật
     * @param updatedLesson Thông tin bài giảng mới
     * @return Lesson đã được cập nhật
     * @throws RuntimeException Nếu không tìm thấy bài giảng hoặc có lỗi validation
     */
    public Lesson updateLesson(Long id, Lesson updatedLesson) {
        // Tìm bài giảng hiện tại
        Lesson existingLesson = lessonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy bài giảng với ID: " + id));

        // Validate thông tin bài giảng mới
        validateLesson(updatedLesson);

        // Cập nhật thông tin
        existingLesson.setTitle(updatedLesson.getTitle());
        existingLesson.setContent(updatedLesson.getContent());
        existingLesson.setVideoLink(updatedLesson.getVideoLink());
        existingLesson.setOrderIndex(updatedLesson.getOrderIndex());
        existingLesson.setActive(updatedLesson.isActive());

        return lessonRepository.save(existingLesson);
    }

    /**
     * Xóa bài giảng
     * @param id ID của bài giảng cần xóa
     * @throws RuntimeException Nếu không tìm thấy bài giảng
     */
    public void deleteLesson(Long id) {
        Lesson lesson = lessonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy bài giảng với ID: " + id));

        lessonRepository.delete(lesson);
    }

    /**
     * Tìm bài giảng theo ID
     * @param id ID của bài giảng
     * @return Optional<Lesson>
     */
    public Optional<Lesson> findById(Long id) {
        return lessonRepository.findById(id);
    }

    /**
     * Tìm bài giảng theo khóa học
     * @param course Khóa học
     * @return Danh sách bài giảng trong khóa học
     */
    public List<Lesson> findByCourse(Course course) {
        if (course == null) {
            throw new RuntimeException("Khóa học không hợp lệ");
        }
        return lessonRepository.findByCourseOrderByOrderIndexAsc(course);
    }

    /**
     * Tìm bài giảng đang hoạt động theo khóa học
     * @param course Khóa học
     * @return Danh sách bài giảng đang hoạt động
     */
    public List<Lesson> findActiveByCourse(Course course) {
        if (course == null) {
            throw new RuntimeException("Khóa học không hợp lệ");
        }
        return lessonRepository.findByCourseAndIsActiveOrderByOrderIndexAsc(course, true);
    }

    /**
     * Tìm bài giảng theo ID và khóa học (để đảm bảo quyền truy cập)
     * @param id ID của bài giảng
     * @param course Khóa học
     * @return Optional<Lesson>
     */
    public Optional<Lesson> findByIdAndCourse(Long id, Course course) {
        if (course == null) {
            return Optional.empty();
        }
        return lessonRepository.findByIdAndCourse(id, course);
    }

    /**
     * Tìm kiếm bài giảng theo từ khóa
     * @param course Khóa học
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách bài giảng chứa từ khóa
     */
    public List<Lesson> searchLessons(Course course, String keyword) {
        if (course == null) {
            throw new RuntimeException("Khóa học không hợp lệ");
        }

        if (keyword == null || keyword.trim().isEmpty()) {
            return findByCourse(course);
        }

        return lessonRepository.findByCourseAndTitleContainingIgnoreCaseOrderByOrderIndexAsc(
                course, keyword.trim());
    }

    /**
     * Kiểm tra học viên có thể xem bài giảng không
     * @param lesson Bài giảng
     * @param student Học viên
     * @return true nếu có thể xem, false nếu không thể
     */
    public boolean canStudentViewLesson(Lesson lesson, User student) {
        if (lesson == null || student == null) {
            return false;
        }

        // Kiểm tra vai trò học viên
        if (student.getRole() != User.Role.STUDENT) {
            return false;
        }

        // Kiểm tra bài giảng có đang hoạt động không
        if (!lesson.isActive()) {
            return false;
        }

        // Kiểm tra khóa học có đang hoạt động không
        if (!lesson.getCourse().isActive()) {
            return false;
        }

        // Kiểm tra học viên có đăng ký khóa học không
        return enrollmentService.isStudentEnrolled(student, lesson.getCourse());
    }

    /**
     * Kiểm tra giảng viên có quyền chỉnh sửa bài giảng không
     * @param lesson Bài giảng
     * @param instructor Giảng viên
     * @return true nếu có quyền, false nếu không có quyền
     */
    public boolean canInstructorEditLesson(Lesson lesson, User instructor) {
        if (lesson == null || instructor == null) {
            return false;
        }

        // Kiểm tra vai trò giảng viên
        if (instructor.getRole() != User.Role.INSTRUCTOR) {
            return false;
        }

        // Kiểm tra giảng viên có phải là chủ sở hữu khóa học không
        return lesson.getCourse().getInstructor().getId().equals(instructor.getId());
    }

    /**
     * Đếm số bài giảng trong khóa học
     * @param course Khóa học
     * @return Số lượng bài giảng
     */
    public long countByCourse(Course course) {
        if (course == null) {
            return 0;
        }
        return lessonRepository.countByCourse(course);
    }

    /**
     * Đếm số bài giảng đang hoạt động trong khóa học
     * @param course Khóa học
     * @return Số lượng bài giảng đang hoạt động
     */
    public long countActiveLessonsByCourse(Course course) {
        if (course == null) {
            return 0;
        }
        return lessonRepository.countByCourseAndIsActive(course, true);
    }

    /**
     * Lấy bài giảng đầu tiên của khóa học
     * @param course Khóa học
     * @return Optional<Lesson>
     */
    public Optional<Lesson> getFirstLesson(Course course) {
        if (course == null) {
            return Optional.empty();
        }

        List<Lesson> lessons = findActiveByCourse(course);
        return lessons.isEmpty() ? Optional.empty() : Optional.of(lessons.get(0));
    }

    /**
     * Lấy bài giảng tiếp theo
     * @param currentLesson Bài giảng hiện tại
     * @return Optional<Lesson>
     */
    public Optional<Lesson> getNextLesson(Lesson currentLesson) {
        if (currentLesson == null) {
            return Optional.empty();
        }

        return lessonRepository.findNextLesson(
                currentLesson.getCourse(),
                currentLesson.getOrderIndex());
    }

    /**
     * Lấy bài giảng trước đó
     * @param currentLesson Bài giảng hiện tại
     * @return Optional<Lesson>
     */
    public Optional<Lesson> getPreviousLesson(Lesson currentLesson) {
        if (currentLesson == null) {
            return Optional.empty();
        }

        return lessonRepository.findPreviousLesson(
                currentLesson.getCourse(),
                currentLesson.getOrderIndex());
    }

    /**
     * Sắp xếp lại thứ tự bài giảng
     * @param course Khóa học
     * @param lessonIds Danh sách ID bài giảng theo thứ tự mới
     */
    public void reorderLessons(Course course, List<Long> lessonIds) {
        if (course == null || lessonIds == null || lessonIds.isEmpty()) {
            throw new RuntimeException("Thông tin sắp xếp không hợp lệ");
        }

        for (int i = 0; i < lessonIds.size(); i++) {
            Long lessonId = lessonIds.get(i);
            Optional<Lesson> lessonOpt = findByIdAndCourse(lessonId, course);

            if (lessonOpt.isPresent()) {
                Lesson lesson = lessonOpt.get();
                lesson.setOrderIndex(i + 1);
                lessonRepository.save(lesson);
            }
        }
    }

    /**
     * Sao chép bài giảng
     * @param sourceLesson Bài giảng nguồn
     * @param targetCourse Khóa học đích
     * @return Lesson đã được sao chép
     */
    public Lesson copyLesson(Lesson sourceLesson, Course targetCourse) {
        if (sourceLesson == null || targetCourse == null) {
            throw new RuntimeException("Thông tin sao chép không hợp lệ");
        }

        Lesson copiedLesson = new Lesson();
        copiedLesson.setTitle(sourceLesson.getTitle() + " (Copy)");
        copiedLesson.setContent(sourceLesson.getContent());
        copiedLesson.setVideoLink(sourceLesson.getVideoLink());
        copiedLesson.setCourse(targetCourse);
        copiedLesson.setOrderIndex(getNextOrderIndex(targetCourse));
        copiedLesson.setActive(true);

        return createLesson(copiedLesson);
    }

    /**
     * Lấy index tiếp theo cho bài giảng mới
     * @param course Khóa học
     * @return Index tiếp theo
     */
    private int getNextOrderIndex(Course course) {
        Integer maxOrder = lessonRepository.findMaxOrderIndexByCourse(course);
        return (maxOrder != null) ? maxOrder + 1 : 1;
    }

    /**
     * Validate thông tin bài giảng
     * @param lesson Bài giảng cần validate
     * @throws RuntimeException Nếu validation fail
     */
    private void validateLesson(Lesson lesson) {
        if (lesson == null) {
            throw new RuntimeException("Thông tin bài giảng không được để trống");
        }

        if (lesson.getTitle() == null || lesson.getTitle().trim().isEmpty()) {
            throw new RuntimeException("Tiêu đề bài giảng không được để trống");
        }

        if (lesson.getTitle().trim().length() < 3) {
            throw new RuntimeException("Tiêu đề bài giảng phải có ít nhất 3 ký tự");
        }

        if (lesson.getTitle().trim().length() > 200) {
            throw new RuntimeException("Tiêu đề bài giảng không được vượt quá 200 ký tự");
        }

        if (lesson.getContent() == null || lesson.getContent().trim().isEmpty()) {
            throw new RuntimeException("Nội dung bài giảng không được để trống");
        }

        if (lesson.getContent().trim().length() < 10) {
            throw new RuntimeException("Nội dung bài giảng phải có ít nhất 10 ký tự");
        }

        if (lesson.getCourse() == null) {
            throw new RuntimeException("Bài giảng phải thuộc về một khóa học");
        }

        // Validate video link nếu có
        if (lesson.getVideoLink() != null && !lesson.getVideoLink().trim().isEmpty()) {
            String videoLink = lesson.getVideoLink().trim();
            if (!isValidYouTubeUrl(videoLink)) {
                throw new RuntimeException("Link video phải là URL YouTube hợp lệ");
            }
        }

        // Validate order index
        if (lesson.getOrderIndex() != null && lesson.getOrderIndex() <= 0) {
            throw new RuntimeException("Thứ tự bài giảng phải lớn hơn 0");
        }
    }

    /**
     * Kiểm tra URL YouTube có hợp lệ không
     * @param url URL cần kiểm tra
     * @return true nếu hợp lệ, false nếu không hợp lệ
     */
    private boolean isValidYouTubeUrl(String url) {
        return url.matches("^(https?://)?(www\\.)?(youtube\\.com|youtu\\.be)/.+");
    }
}