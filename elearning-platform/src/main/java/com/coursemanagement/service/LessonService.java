package com.coursemanagement.service;

import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.Lesson;
import com.coursemanagement.entity.User;
import com.coursemanagement.repository.LessonRepository;
import com.coursemanagement.utils.CourseUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Service class để xử lý business logic liên quan đến Lesson
 * Quản lý CRUD operations, file uploads và business rules cho lessons
 */
@Service
@Transactional
public class LessonService {

    @Autowired
    private LessonRepository lessonRepository;

    private static final String UPLOAD_DIR = "uploads/lessons/";

    /**
     * Tìm lesson theo ID
     * @param id ID của lesson
     * @return Optional chứa Lesson nếu tìm thấy
     */
    public Optional<Lesson> findById(Long id) {
        return lessonRepository.findById(id);
    }

    /**
     * Tìm lessons theo course, sắp xếp theo order index
     * @param course Course chứa lessons
     * @return Danh sách lessons đã sắp xếp
     */
    public List<Lesson> findByCourseOrderByOrderIndex(Course course) {
        return lessonRepository.findByCourseOrderByOrderIndex(course);
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
     * Đếm số lessons trong một course
     * @param course Course cần đếm
     * @return Số lượng lessons
     */
    public Long countLessonsByCourse(Course course) {
        return lessonRepository.countByCourse(course);
    }

    /**
     * Đếm số lessons của một instructor
     * @param instructor Instructor
     * @return Số lượng lessons
     */
    public Long countLessonsByInstructor(User instructor) {
        return lessonRepository.countByInstructor(instructor);
    }

    /**
     * Tạo lesson mới
     * @param lesson Lesson cần tạo
     * @return Lesson đã được tạo
     */
    public Lesson createLesson(Lesson lesson) {
        validateLesson(lesson);

        // Tạo slug từ title
        lesson.setSlug(CourseUtils.StringUtils.createSlug(lesson.getTitle()));

        // Set thời gian tạo
        lesson.setCreatedAt(LocalDateTime.now());
        lesson.setUpdatedAt(LocalDateTime.now());

        // Mặc định active = true
        lesson.setActive(true);

        // Auto-set order index nếu chưa có
        if (lesson.getOrderIndex() == null) {
            lesson.setOrderIndex(getNextOrderIndex(lesson.getCourse()));
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

        validateLesson(lesson);

        // Cập nhật slug nếu title thay đổi
        if (!existingLesson.getTitle().equals(lesson.getTitle())) {
            lesson.setSlug(CourseUtils.StringUtils.createSlug(lesson.getTitle()));
        } else {
            lesson.setSlug(existingLesson.getSlug());
        }

        // Giữ nguyên thời gian tạo
        lesson.setCreatedAt(existingLesson.getCreatedAt());
        lesson.setUpdatedAt(LocalDateTime.now());

        return lessonRepository.save(lesson);
    }

    /**
     * Upload lesson document
     * @param documentFile File document
     * @return URL của document đã upload
     * @throws IOException Nếu có lỗi I/O
     */
    public String uploadLessonDocument(MultipartFile documentFile) throws IOException {
        if (!CourseUtils.FileUtils.isValidDocumentFile(documentFile)) {
            throw new RuntimeException("File không hợp lệ. Chỉ chấp nhận PDF, DOC, DOCX, TXT dưới 10MB");
        }

        String filename = CourseUtils.FileUtils.generateUniqueFilename(documentFile.getOriginalFilename());
        String savedPath = CourseUtils.FileUtils.saveFile(documentFile, UPLOAD_DIR + "documents/", filename);

        // Trả về relative URL
        return "/uploads/lessons/documents/" + filename;
    }

    /**
     * Upload lesson video
     * @param videoFile File video
     * @return URL của video đã upload
     * @throws IOException Nếu có lỗi I/O
     */
    public String uploadLessonVideo(MultipartFile videoFile) throws IOException {
        if (!CourseUtils.FileUtils.isValidVideoFile(videoFile)) {
            throw new RuntimeException("File không hợp lệ. Chỉ chấp nhận MP4, AVI, MOV dưới 100MB");
        }

        String filename = CourseUtils.FileUtils.generateUniqueFilename(videoFile.getOriginalFilename());
        String savedPath = CourseUtils.FileUtils.saveFile(videoFile, UPLOAD_DIR + "videos/", filename);

        // Trả về relative URL
        return "/uploads/lessons/videos/" + filename;
    }

    /**
     * Lấy order index tiếp theo cho course
     * @param course Course
     * @return Order index tiếp theo
     */
    public Integer getNextOrderIndex(Course course) {
        List<Lesson> existingLessons = findByCourseOrderByOrderIndex(course);
        if (existingLessons.isEmpty()) {
            return 1;
        }

        return existingLessons.get(existingLessons.size() - 1).getOrderIndex() + 1;
    }

    /**
     * Reorder lessons trong course
     * @param lessonId ID lesson cần di chuyển
     * @param newOrderIndex Vị trí mới
     */
    public void reorderLesson(Long lessonId, int newOrderIndex) {
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lesson"));

        if (newOrderIndex <= 0) {
            throw new RuntimeException("Order index phải lớn hơn 0");
        }

        Course course = lesson.getCourse();
        List<Lesson> allLessons = findByCourseOrderByOrderIndex(course);

        // Remove lesson khỏi vị trí cũ
        allLessons.remove(lesson);

        // Insert vào vị trí mới
        int insertIndex = Math.min(newOrderIndex - 1, allLessons.size());
        allLessons.add(insertIndex, lesson);

        // Cập nhật order index cho tất cả lessons
        for (int i = 0; i < allLessons.size(); i++) {
            allLessons.get(i).setOrderIndex(i + 1);
            allLessons.get(i).setUpdatedAt(LocalDateTime.now());
        }

        lessonRepository.saveAll(allLessons);
    }

    /**
     * Soft delete lesson
     * @param lessonId ID lesson cần xóa
     */
    public void softDeleteLesson(Long lessonId) {
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lesson"));

        lesson.setActive(false);
        lesson.setUpdatedAt(LocalDateTime.now());
        lessonRepository.save(lesson);
    }

    /**
     * Hard delete lesson
     * @param lessonId ID lesson cần xóa
     */
    public void deleteLesson(Long lessonId) {
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lesson"));

        Course course = lesson.getCourse();

        // Xóa lesson
        lessonRepository.delete(lesson);

        // Reorder các lessons còn lại
        reorderRemainingLessons(course);
    }

    /**
     * Tìm lesson trước/sau trong course
     * @param lesson Lesson hiện tại
     * @return Array [previous, next] lessons
     */
    public Lesson[] findAdjacentLessons(Lesson lesson) {
        List<Lesson> courseLessons = findByCourseOrderByOrderIndex(lesson.getCourse());

        Lesson previous = null;
        Lesson next = null;

        for (int i = 0; i < courseLessons.size(); i++) {
            if (courseLessons.get(i).getId().equals(lesson.getId())) {
                if (i > 0) {
                    previous = courseLessons.get(i - 1);
                }
                if (i < courseLessons.size() - 1) {
                    next = courseLessons.get(i + 1);
                }
                break;
            }
        }

        return new Lesson[]{previous, next};
    }

    /**
     * Tìm lessons theo keyword
     * @param course Course
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách lessons phù hợp
     */
    public List<Lesson> searchLessons(Course course, String keyword) {
        if (!StringUtils.hasText(keyword)) {
            return findByCourseOrderByOrderIndex(course);
        }

        return lessonRepository.findByCourseAndTitleContainingIgnoreCaseOrderByOrderIndex(course, keyword);
    }

    /**
     * Lấy lessons active của course
     * @param course Course
     * @return Danh sách active lessons
     */
    public List<Lesson> findActiveLessonsByCourse(Course course) {
        return lessonRepository.findByCourseAndActiveOrderByOrderIndex(course, true);
    }

    /**
     * Kiểm tra lesson có thuộc về course không
     * @param lessonId ID lesson
     * @param courseId ID course
     * @return true nếu lesson thuộc course
     */
    public boolean isLessonInCourse(Long lessonId, Long courseId) {
        return lessonRepository.existsByIdAndCourseId(lessonId, courseId);
    }

    /**
     * Duplicate lesson trong cùng course hoặc course khác
     * @param originalLessonId ID lesson gốc
     * @param targetCourse Course đích
     * @return Lesson mới đã được tạo
     */
    public Lesson duplicateLesson(Long originalLessonId, Course targetCourse) {
        Lesson originalLesson = lessonRepository.findById(originalLessonId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lesson gốc"));

        Lesson duplicatedLesson = new Lesson();
        duplicatedLesson.setCourse(targetCourse);
        duplicatedLesson.setTitle(originalLesson.getTitle() + " (Copy)");
        duplicatedLesson.setContent(originalLesson.getContent());
        duplicatedLesson.setVideoLink(originalLesson.getVideoLink());
        duplicatedLesson.setDocumentUrl(originalLesson.getDocumentUrl());
        duplicatedLesson.setEstimatedDuration(originalLesson.getEstimatedDuration());
        duplicatedLesson.setPreview(originalLesson.isPreview());

        return createLesson(duplicatedLesson);
    }

    /**
     * Lấy lesson statistics
     * @param lesson Lesson
     * @return Lesson statistics
     */
    public LessonStats getLessonStatistics(Lesson lesson) {
        // Placeholder - cần implement với view/completion tracking
        return new LessonStats(lesson.getId(), 0L, 0L, 0.0);
    }

    // ===== PRIVATE HELPER METHODS =====

    /**
     * Reorder lại các lessons còn lại sau khi xóa
     * @param course Course
     */
    private void reorderRemainingLessons(Course course) {
        List<Lesson> remainingLessons = findByCourseOrderByOrderIndex(course);

        for (int i = 0; i < remainingLessons.size(); i++) {
            remainingLessons.get(i).setOrderIndex(i + 1);
            remainingLessons.get(i).setUpdatedAt(LocalDateTime.now());
        }

        lessonRepository.saveAll(remainingLessons);
    }

    /**
     * Validate thông tin lesson
     * @param lesson Lesson cần validate
     */
    private void validateLesson(Lesson lesson) {
        if (lesson == null) {
            throw new RuntimeException("Thông tin lesson không được để trống");
        }

        // Validate title
        if (!StringUtils.hasText(lesson.getTitle())) {
            throw new RuntimeException("Tiêu đề bài học không được để trống");
        }
        if (lesson.getTitle().length() < 3) {
            throw new RuntimeException("Tiêu đề bài học phải có ít nhất 3 ký tự");
        }
        if (lesson.getTitle().length() > 200) {
            throw new RuntimeException("Tiêu đề bài học không được vượt quá 200 ký tự");
        }

        // Validate content
        if (!StringUtils.hasText(lesson.getContent())) {
            throw new RuntimeException("Nội dung bài học không được để trống");
        }
        if (lesson.getContent().length() < 10) {
            throw new RuntimeException("Nội dung bài học phải có ít nhất 10 ký tự");
        }

        // Validate course
        if (lesson.getCourse() == null) {
            throw new RuntimeException("Bài học phải thuộc về một khóa học");
        }

        // Validate estimated duration
        if (lesson.getEstimatedDuration() != null && lesson.getEstimatedDuration() <= 0) {
            throw new RuntimeException("Thời lượng ước tính phải là số dương");
        }

        // Validate video link format (nếu có)
        if (StringUtils.hasText(lesson.getVideoLink())) {
            if (!CourseUtils.ValidationUtils.isValidUrl(lesson.getVideoLink()) &&
                    !CourseUtils.ValidationUtils.isValidYouTubeUrl(lesson.getVideoLink())) {
                throw new RuntimeException("Link video không hợp lệ");
            }
        }

        // Validate order index
        if (lesson.getOrderIndex() != null && lesson.getOrderIndex() <= 0) {
            throw new RuntimeException("Thứ tự bài học phải là số dương");
        }
    }

    // ===== INNER CLASSES =====

    /**
     * Lesson statistics data class
     */
    public static class LessonStats {
        private final Long lessonId;
        private final Long viewCount;
        private final Long completionCount;
        private final Double averageRating;

        public LessonStats(Long lessonId, Long viewCount, Long completionCount, Double averageRating) {
            this.lessonId = lessonId;
            this.viewCount = viewCount;
            this.completionCount = completionCount;
            this.averageRating = averageRating;
        }

        // Getters
        public Long getLessonId() { return lessonId; }
        public Long getViewCount() { return viewCount; }
        public Long getCompletionCount() { return completionCount; }
        public Double getAverageRating() { return averageRating; }
    }
}