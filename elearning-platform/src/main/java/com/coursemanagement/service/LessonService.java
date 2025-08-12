package com.coursemanagement.service;

import com.coursemanagement.entity.Lesson;
import com.coursemanagement.entity.Course;
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

    /**
     * Tạo bài giảng mới
     * @param lesson Bài giảng cần tạo
     * @return Lesson đã được tạo
     * @throws RuntimeException Nếu có lỗi validation
     */
    public Lesson createLesson(Lesson lesson) {
        // Validate thông tin bài giảng
        validateLesson(lesson);

        // Tự động set orderIndex nếu chưa có
        if (lesson.getOrderIndex() == null || lesson.getOrderIndex() == 0) {
            Integer maxOrderIndex = lessonRepository.findMaxOrderIndexByCourse(lesson.getCourse());
            lesson.setOrderIndex(maxOrderIndex + 1);
        }

        // Đảm bảo bài giảng được kích hoạt
        lesson.setActive(true);

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
     * Tìm bài giảng theo ID và khóa học (để đảm bảo quyền truy cập)
     * @param id ID của bài giảng
     * @param course Khóa học
     * @return Optional<Lesson>
     */
    public Optional<Lesson> findByIdAndCourse(Long id, Course course) {
        return lessonRepository.findByIdAndCourse(id, course);
    }

    /**
     * Lấy tất cả bài giảng của khóa học
     * @param course Khóa học
     * @return Danh sách bài giảng sắp xếp theo orderIndex
     */
    public List<Lesson> findLessonsByCourse(Course course) {
        return lessonRepository.findByCourseOrderByOrderIndex(course);
    }

    /**
     * Lấy tất cả bài giảng đang hoạt động của khóa học
     * @param course Khóa học
     * @return Danh sách bài giảng đang hoạt động sắp xếp theo orderIndex
     */
    public List<Lesson> findActiveLessonsByCourse(Course course) {
        return lessonRepository.findByCourseAndIsActiveOrderByOrderIndex(course, true);
    }

    /**
     * Lấy bài giảng theo ID khóa học
     * @param courseId ID của khóa học
     * @return Danh sách bài giảng đang hoạt động
     */
    public List<Lesson> findLessonsByCourseId(Long courseId) {
        return lessonRepository.findByCourseIdAndActiveOrderByOrderIndex(courseId);
    }

    /**
     * Lấy bài giảng có video trong khóa học
     * @param course Khóa học
     * @return Danh sách bài giảng có video
     */
    public List<Lesson> findLessonsWithVideo(Course course) {
        return lessonRepository.findByCourseWithVideo(course);
    }

    /**
     * Lấy bài giảng chỉ có text (không có video)
     * @param course Khóa học
     * @return Danh sách bài giảng chỉ có text
     */
    public List<Lesson> findLessonsWithoutVideo(Course course) {
        return lessonRepository.findByCourseWithoutVideo(course);
    }

    /**
     * Tìm kiếm bài giảng theo tiêu đề
     * @param courseId ID khóa học
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách bài giảng chứa từ khóa
     */
    public List<Lesson> searchLessonsByTitle(Long courseId, String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return lessonRepository.findByCourseIdAndActiveOrderByOrderIndex(courseId);
        }
        return lessonRepository.findByCourseIdAndTitleContaining(courseId, keyword.trim());
    }

    /**
     * Lấy bài giảng đầu tiên trong khóa học
     * @param course Khóa học
     * @return Optional<Lesson> - bài giảng đầu tiên
     */
    public Optional<Lesson> findFirstLesson(Course course) {
        return lessonRepository.findFirstLessonByCourse(course);
    }

    /**
     * Lấy bài giảng cuối cùng trong khóa học
     * @param course Khóa học
     * @return Optional<Lesson> - bài giảng cuối cùng
     */
    public Optional<Lesson> findLastLesson(Course course) {
        return lessonRepository.findLastLessonByCourse(course);
    }

    /**
     * Lấy bài giảng tiếp theo
     * @param course Khóa học
     * @param currentOrderIndex OrderIndex hiện tại
     * @return Optional<Lesson> - bài giảng tiếp theo
     */
    public Optional<Lesson> findNextLesson(Course course, Integer currentOrderIndex) {
        return lessonRepository.findNextLesson(course, currentOrderIndex);
    }

    /**
     * Lấy bài giảng trước đó
     * @param course Khóa học
     * @param currentOrderIndex OrderIndex hiện tại
     * @return Optional<Lesson> - bài giảng trước đó
     */
    public Optional<Lesson> findPreviousLesson(Course course, Integer currentOrderIndex) {
        return lessonRepository.findPreviousLesson(course, currentOrderIndex);
    }

    /**
     * Đếm số bài giảng trong khóa học
     * @param course Khóa học
     * @return Số lượng bài giảng
     */
    public long countLessonsByCourse(Course course) {
        return lessonRepository.countByCourse(course);
    }

    /**
     * Đếm số bài giảng đang hoạt động trong khóa học
     * @param course Khóa học
     * @return Số lượng bài giảng đang hoạt động
     */
    public long countActiveLessonsByCourse(Course course) {
        return lessonRepository.countByCourseAndIsActive(course, true);
    }

    /**
     * Đếm số bài giảng có video
     * @param course Khóa học
     * @return Số lượng bài giảng có video
     */
    public long countLessonsWithVideo(Course course) {
        return lessonRepository.countLessonsWithVideoByCourse(course);
    }

    /**
     * Đếm số bài giảng chỉ có text
     * @param course Khóa học
     * @return Số lượng bài giảng chỉ có text
     */
    public long countTextOnlyLessons(Course course) {
        return lessonRepository.countTextOnlyLessonsByCourse(course);
    }

    /**
     * Lấy orderIndex tiếp theo cho bài giảng mới
     * @param course Khóa học
     * @return OrderIndex tiếp theo
     */
    public Integer getNextOrderIndex(Course course) {
        Integer maxOrderIndex = lessonRepository.findMaxOrderIndexByCourse(course);
        return maxOrderIndex + 1;
    }

    /**
     * Sắp xếp lại thứ tự bài giảng
     * @param course Khóa học
     * @param lessonIds Danh sách ID bài giảng theo thứ tự mới
     */
    public void reorderLessons(Course course, List<Long> lessonIds) {
        List<Lesson> lessons = lessonRepository.findByIdIn(lessonIds);

        for (int i = 0; i < lessons.size(); i++) {
            Lesson lesson = lessons.get(i);
            if (lesson.getCourse().getId().equals(course.getId())) {
                lesson.setOrderIndex(i + 1);
                lessonRepository.save(lesson);
            }
        }
    }

    /**
     * Di chuyển bài giảng lên trên
     * @param lessonId ID bài giảng
     */
    public void moveLessonUp(Long lessonId) {
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy bài giảng"));

        Optional<Lesson> previousLesson = findPreviousLesson(lesson.getCourse(), lesson.getOrderIndex());

        if (previousLesson.isPresent()) {
            // Hoán đổi orderIndex
            Integer currentOrder = lesson.getOrderIndex();
            Integer previousOrder = previousLesson.get().getOrderIndex();

            lesson.setOrderIndex(previousOrder);
            previousLesson.get().setOrderIndex(currentOrder);

            lessonRepository.save(lesson);
            lessonRepository.save(previousLesson.get());
        }
    }

    /**
     * Di chuyển bài giảng xuống dưới
     * @param lessonId ID bài giảng
     */
    public void moveLessonDown(Long lessonId) {
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy bài giảng"));

        Optional<Lesson> nextLesson = findNextLesson(lesson.getCourse(), lesson.getOrderIndex());

        if (nextLesson.isPresent()) {
            // Hoán đổi orderIndex
            Integer currentOrder = lesson.getOrderIndex();
            Integer nextOrder = nextLesson.get().getOrderIndex();

            lesson.setOrderIndex(nextOrder);
            nextLesson.get().setOrderIndex(currentOrder);

            lessonRepository.save(lesson);
            lessonRepository.save(nextLesson.get());
        }
    }

    /**
     * Kích hoạt/vô hiệu hóa bài giảng
     * @param lessonId ID của bài giảng
     * @param isActive Trạng thái kích hoạt
     */
    public void toggleLessonStatus(Long lessonId, boolean isActive) {
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy bài giảng"));

        lesson.setActive(isActive);
        lessonRepository.save(lesson);
    }

    /**
     * Validate URL YouTube
     * @param videoLink URL cần validate
     * @return true nếu là URL YouTube hợp lệ, false nếu không
     */
    public boolean isValidYouTubeUrl(String videoLink) {
        if (videoLink == null || videoLink.trim().isEmpty()) {
            return true; // URL rỗng được phép
        }

        String url = videoLink.trim();
        return url.contains("youtube.com/watch?v=") || url.contains("youtu.be/");
    }

    /**
     * Validate thông tin bài giảng
     * @param lesson Bài giảng cần validate
     * @throws RuntimeException Nếu có lỗi validation
     */
    private void validateLesson(Lesson lesson) {
        // Kiểm tra tiêu đề bài giảng
        if (lesson.getTitle() == null || lesson.getTitle().trim().isEmpty()) {
            throw new RuntimeException("Tiêu đề bài giảng không được để trống");
        }

        if (lesson.getTitle().trim().length() < 5) {
            throw new RuntimeException("Tiêu đề bài giảng phải có ít nhất 5 ký tự");
        }

        if (lesson.getTitle().trim().length() > 200) {
            throw new RuntimeException("Tiêu đề bài giảng không được vượt quá 200 ký tự");
        }

        // Kiểm tra khóa học
        if (lesson.getCourse() == null) {
            throw new RuntimeException("Bài giảng phải thuộc về một khóa học");
        }

        // Kiểm tra nội dung hoặc video (ít nhất một trong hai)
        boolean hasContent = lesson.getContent() != null && !lesson.getContent().trim().isEmpty();
        boolean hasVideo = lesson.getVideoLink() != null && !lesson.getVideoLink().trim().isEmpty();

        if (!hasContent && !hasVideo) {
            throw new RuntimeException("Bài giảng phải có nội dung text hoặc video");
        }

        // Kiểm tra URL YouTube nếu có
        if (hasVideo && !isValidYouTubeUrl(lesson.getVideoLink())) {
            throw new RuntimeException("URL video phải là liên kết YouTube hợp lệ");
        }

        // Kiểm tra orderIndex
        if (lesson.getOrderIndex() != null && lesson.getOrderIndex() < 0) {
            throw new RuntimeException("Thứ tự bài giảng phải là số dương");
        }

        // Trim các trường text
        lesson.setTitle(lesson.getTitle().trim());
        if (lesson.getContent() != null) {
            lesson.setContent(lesson.getContent().trim());
        }
        if (lesson.getVideoLink() != null) {
            lesson.setVideoLink(lesson.getVideoLink().trim());
        }
    }

    /**
     * Lấy tất cả bài giảng có video
     * @return Danh sách tất cả bài giảng có video
     */
    public List<Lesson> findAllLessonsWithVideo() {
        return lessonRepository.findAllLessonsWithVideo();
    }
}