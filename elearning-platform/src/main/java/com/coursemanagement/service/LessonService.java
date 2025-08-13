package com.coursemanagement.service;

import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.Lesson;
import com.coursemanagement.entity.User;
import com.coursemanagement.repository.LessonRepository;
import com.coursemanagement.utils.CourseUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Service class để xử lý business logic liên quan đến Lesson
 * Quản lý CRUD operations và business rules cho lessons
 */
@Service
@Transactional
public class LessonService {

    @Autowired
    private LessonRepository lessonRepository;

    /**
     * Tìm lesson theo ID
     * @param id ID của lesson
     * @return Optional chứa Lesson nếu tìm thấy
     */
    public Optional<Lesson> findById(Long id) {
        return lessonRepository.findById(id);
    }

    /**
     * Tìm lesson theo ID và course (cho security)
     * @param id ID lesson
     * @param course Course chứa lesson
     * @return Optional chứa Lesson nếu tìm thấy
     */
    public Optional<Lesson> findByIdAndCourse(Long id, Course course) {
        return lessonRepository.findByIdAndCourse(id, course);
    }

    /**
     * Tìm lesson theo slug
     * @param slug Slug của lesson
     * @return Optional chứa Lesson nếu tìm thấy
     */
    public Optional<Lesson> findBySlug(String slug) {
        return lessonRepository.findBySlug(slug);
    }

    /**
     * Tìm tất cả lessons của course theo thứ tự
     * @param course Course
     * @return Danh sách lessons đã sắp xếp
     */
    public List<Lesson> findByCourseOrderByOrderIndex(Course course) {
        return lessonRepository.findByCourseOrderByOrderIndex(course);
    }

    /**
     * Tìm lessons theo course ID
     * @param courseId ID của course
     * @return Danh sách lessons
     */
    public List<Lesson> findByCourseId(Long courseId) {
        return lessonRepository.findByCourseIdOrderByOrderIndex(courseId);
    }

    /**
     * Tìm lessons active của course
     * @param course Course
     * @return Danh sách active lessons
     */
    public List<Lesson> findActiveLessonsByCourse(Course course) {
        return lessonRepository.findByCourseAndActiveOrderByOrderIndex(course, true);
    }

    /**
     * Đếm lessons active của course
     * @param course Course
     * @return Số lượng active lessons
     */
    public Long countActiveLessonsByCourse(Course course) {
        return lessonRepository.countByCourseAndActive(course, true);
    }

    /**
     * Đếm lessons của instructor
     * @param instructor Instructor
     * @return Số lượng lessons
     */
    public Long countLessonsByInstructor(User instructor) {
        return lessonRepository.countByInstructor(instructor);
    }

    /**
     * Tìm lesson trước đó trong course
     * @param currentLesson Lesson hiện tại
     * @return Optional chứa lesson trước đó
     */
    public Optional<Lesson> findPreviousLesson(Lesson currentLesson) {
        return lessonRepository.findPreviousLesson(
                currentLesson.getCourse(),
                currentLesson.getOrderIndex()
        );
    }

    /**
     * Tìm lesson tiếp theo trong course
     * @param currentLesson Lesson hiện tại
     * @return Optional chứa lesson tiếp theo
     */
    public Optional<Lesson> findNextLesson(Lesson currentLesson) {
        return lessonRepository.findNextLesson(
                currentLesson.getCourse(),
                currentLesson.getOrderIndex()
        );
    }

    /**
     * Tạo lesson mới
     * @param lesson Lesson cần tạo
     * @return Lesson đã được tạo
     */
    public Lesson createLesson(Lesson lesson) {
        validateLesson(lesson);

        // Tạo slug từ tiêu đề lesson
        lesson.setSlug(CourseUtils.StringUtils.createSlug(lesson.getTitle()));

        // Đảm bảo slug unique trong course
        String originalSlug = lesson.getSlug();
        int counter = 1;
        while (lessonRepository.existsBySlugAndCourse(lesson.getSlug(), lesson.getCourse())) {
            lesson.setSlug(originalSlug + "-" + counter);
            counter++;
        }

        // Set thời gian tạo
        lesson.setCreatedAt(LocalDateTime.now());
        lesson.setUpdatedAt(LocalDateTime.now());

        // Mặc định là active
        lesson.setActive(true);

        // Auto-set order index nếu chưa có
        if (lesson.getOrderIndex() == null) {
            Integer maxOrder = lessonRepository.findMaxOrderIndexByCourse(lesson.getCourse());
            lesson.setOrderIndex(maxOrder != null ? maxOrder + 1 : 1);
        }

        return lessonRepository.save(lesson);
    }

    /**
     * Cập nhật lesson
     * @param lesson Lesson cần cập nhật
     * @return Lesson đã được cập nhật
     */
    public Lesson updateLesson(Lesson lesson) {
        if (lesson.getId() == null) {
            throw new RuntimeException("ID lesson không được để trống khi cập nhật");
        }

        Lesson existingLesson = lessonRepository.findById(lesson.getId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lesson với ID: " + lesson.getId()));

        // Cập nhật thông tin
        existingLesson.setTitle(lesson.getTitle());
        existingLesson.setContent(lesson.getContent());
        existingLesson.setVideoLink(lesson.getVideoLink());
        existingLesson.setDocumentUrl(lesson.getDocumentUrl());
        existingLesson.setOrderIndex(lesson.getOrderIndex());
        existingLesson.setEstimatedDuration(lesson.getEstimatedDuration());
        existingLesson.setPreview(lesson.isPreview());
        existingLesson.setActive(lesson.isActive());
        existingLesson.setUpdatedAt(LocalDateTime.now());

        // Cập nhật slug nếu tiêu đề thay đổi
        if (!existingLesson.getTitle().equals(lesson.getTitle())) {
            String newSlug = CourseUtils.StringUtils.createSlug(lesson.getTitle());
            String originalSlug = newSlug;
            int counter = 1;

            while (lessonRepository.existsBySlugAndCourseAndIdNot(newSlug, lesson.getCourse(), lesson.getId())) {
                newSlug = originalSlug + "-" + counter;
                counter++;
            }
            existingLesson.setSlug(newSlug);
        }

        return lessonRepository.save(existingLesson);
    }

    /**
     * Xóa lesson (soft delete)
     * @param lessonId ID của lesson
     */
    public void deleteLesson(Long lessonId) {
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lesson với ID: " + lessonId));

        lesson.setActive(false);
        lesson.setUpdatedAt(LocalDateTime.now());
        lessonRepository.save(lesson);
    }

    /**
     * Upload tài liệu cho lesson
     * @param lessonId ID lesson
     * @param file File tài liệu
     * @return URL của tài liệu đã upload
     */
    public String uploadLessonDocument(Long lessonId, MultipartFile file) {
        try {
            // Logic upload file (sẽ implement sau)
            String fileName = "lesson_" + lessonId + "_" + System.currentTimeMillis() + "_" + file.getOriginalFilename();
            String documentUrl = "/documents/lessons/" + fileName;

            // Cập nhật documentUrl cho lesson
            Lesson lesson = findById(lessonId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy lesson"));
            lesson.setDocumentUrl(documentUrl);
            updateLesson(lesson);

            return documentUrl;
        } catch (Exception e) {
            throw new RuntimeException("Lỗi upload tài liệu: " + e.getMessage());
        }
    }

    /**
     * Thay đổi thứ tự lesson trong course
     * @param lessonId ID lesson
     * @param newOrderIndex Thứ tự mới
     */
    public void reorderLesson(Long lessonId, Integer newOrderIndex) {
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lesson"));

        Integer oldOrderIndex = lesson.getOrderIndex();

        if (oldOrderIndex.equals(newOrderIndex)) {
            return; // Không thay đổi
        }

        // Cập nhật thứ tự các lessons khác
        if (newOrderIndex < oldOrderIndex) {
            // Di chuyển lên trên
            lessonRepository.incrementOrderIndex(lesson.getCourse(), newOrderIndex, oldOrderIndex - 1);
        } else {
            // Di chuyển xuống dưới
            lessonRepository.decrementOrderIndex(lesson.getCourse(), oldOrderIndex + 1, newOrderIndex);
        }

        // Cập nhật lesson hiện tại
        lesson.setOrderIndex(newOrderIndex);
        lesson.setUpdatedAt(LocalDateTime.now());
        lessonRepository.save(lesson);
    }

    /**
     * Tìm lessons theo keyword
     * @param keyword Từ khóa tìm kiếm
     * @param pageable Pagination info
     * @return Page lessons
     */
    public Page<Lesson> searchLessonsByKeyword(String keyword, Pageable pageable) {
        if (!StringUtils.hasText(keyword)) {
            return lessonRepository.findByActiveOrderByCreatedAtDesc(true, pageable);
        }
        return lessonRepository.findByTitleContainingIgnoreCaseAndActiveOrderByCreatedAtDesc(keyword, true, pageable);
    }

    /**
     * Validation cho lesson
     * @param lesson Lesson cần validate
     */
    private void validateLesson(Lesson lesson) {
        if (!StringUtils.hasText(lesson.getTitle())) {
            throw new RuntimeException("Tiêu đề lesson không được để trống");
        }

        if (lesson.getTitle().length() < 5) {
            throw new RuntimeException("Tiêu đề lesson phải có ít nhất 5 ký tự");
        }

        if (lesson.getTitle().length() > 200) {
            throw new RuntimeException("Tiêu đề lesson không được vượt quá 200 ký tự");
        }

        if (!StringUtils.hasText(lesson.getContent())) {
            throw new RuntimeException("Nội dung lesson không được để trống");
        }

        if (lesson.getContent().length() < 20) {
            throw new RuntimeException("Nội dung lesson phải có ít nhất 20 ký tự");
        }

        if (lesson.getCourse() == null) {
            throw new RuntimeException("Course không được để trống");
        }

        if (lesson.getOrderIndex() != null && lesson.getOrderIndex() < 1) {
            throw new RuntimeException("Thứ tự lesson phải lớn hơn 0");
        }

        if (lesson.getEstimatedDuration() != null && lesson.getEstimatedDuration() < 1) {
            throw new RuntimeException("Thời lượng ước tính phải lớn hơn 0");
        }
    }
}