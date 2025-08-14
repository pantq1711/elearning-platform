package com.coursemanagement.service;

import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.Lesson;
import com.coursemanagement.entity.User;
import com.coursemanagement.repository.LessonRepository;
import com.coursemanagement.utils.CourseUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Dịch vụ quản lý bài học (Lesson)
 * Xử lý logic nghiệp vụ cho việc tạo, cập nhật và quản lý các bài học trong khóa học
 */
@Service
@Transactional
public class LessonService {
    /**
     * Đếm active lessons theo course
     */
    public Long countActiveLessonsByCourse(Course course) {
        return lessonRepository.countActiveLessonsByCourse(course);
    }

    /**
     * Tìm active lessons theo course
     */
    public List<Lesson> findActiveByCourse(Course course) {
        return lessonRepository.findByCourseAndActiveOrderByOrderIndex(course, true);
    }

    /**
     * Tìm lesson trước đó
     */
    public Optional<Lesson> findPreviousLesson(Lesson lesson) {
        return lessonRepository.findPreviousLesson(lesson);
    }

    /**
     * Tìm lesson tiếp theo
     */
    public Optional<Lesson> findNextLesson(Lesson lesson) {
        return lessonRepository.findNextLesson(lesson);
    }

    /**
     * Tìm lessons theo course với order
     */
    public List<Lesson> findByCourseOrderByOrderIndex(Course course) {
        return lessonRepository.findByCourseOrderByOrderIndex(course);
    }
    /**
     * Tìm lessons theo instructor
     */
    public List<Lesson> findLessonsByInstructor(User instructor, int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return lessonRepository.findLessonsByInstructor(instructor, pageable);
    }

    /**
     * Đếm tất cả lessons active
     */
    public Long countAllActiveLessons() {
        return lessonRepository.countAllActiveLessons();
    }

    /**
     * Cập nhật order index của lesson
     */
    @Transactional
    public void updateLessonOrder(Long lessonId, Integer newOrderIndex) {
        Lesson lesson = findByIdOrThrow(lessonId);

        // Kiểm tra order index đã tồn tại chưa trong course
        Optional<Lesson> existingLesson = lessonRepository
                .findByCourseAndOrderIndex(lesson.getCourse(), newOrderIndex);

        if (existingLesson.isPresent() && !existingLesson.get().getId().equals(lessonId)) {
            // Swap order index
            Lesson conflictLesson = existingLesson.get();
            conflictLesson.setOrderIndex(lesson.getOrderIndex());
            lessonRepository.save(conflictLesson);
        }

        lesson.setOrderIndex(newOrderIndex);
        lesson.setUpdatedAt(LocalDateTime.now());
        lessonRepository.save(lesson);
    }

    /**
     * Sao chép lesson sang course khác
     */
    @Transactional
    public Lesson duplicateLesson(Long lessonId, Course targetCourse) {
        Lesson originalLesson = findByIdOrThrow(lessonId);

        Lesson duplicatedLesson = new Lesson();
        duplicatedLesson.setTitle(originalLesson.getTitle() + " (Copy)");
        duplicatedLesson.setContent(originalLesson.getContent());
        duplicatedLesson.setVideoLink(originalLesson.getVideoLink());
        duplicatedLesson.setDocumentUrl(originalLesson.getDocumentUrl());
        duplicatedLesson.setEstimatedDuration(originalLesson.getEstimatedDuration());
        duplicatedLesson.setCourse(targetCourse);
        duplicatedLesson.setPreview(originalLesson.isPreview());
        duplicatedLesson.setActive(true);

        return createLesson(duplicatedLesson);
    }

    /**
     * Tìm lesson theo ID với exception
     */
    private Lesson findByIdOrThrow(Long id) {
        return lessonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy bài học với ID: " + id));
    }


    @Autowired
    private LessonRepository lessonRepository;

    @Autowired
    private CourseService courseService;

    // ===== CÁC THAO TÁC CRUD CƠ BẢN =====

    /**
     * Tìm lesson theo ID
     */
    public Optional<Lesson> findById(Long id) {
        return lessonRepository.findById(id);
    }

    /**
     * Tìm lesson theo ID và course (để bảo mật)
     */
    public Optional<Lesson> findByIdAndCourse(Long id, Course course) {
        return lessonRepository.findByIdAndCourse(id, course);
    }

    /**
     * Tìm tất cả lessons
     */
    public List<Lesson> findAll() {
        return lessonRepository.findAll();
    }

    /**
     * Tìm lessons với phân trang
     */
    public Page<Lesson> findAll(Pageable pageable) {
        return lessonRepository.findAll(pageable);
    }

    /**
     * Lưu lesson
     */
    public Lesson save(Lesson lesson) {
        validateLesson(lesson);

        // Set thời gian tạo/cập nhật
        if (lesson.getId() == null) {
            lesson.setCreatedAt(LocalDateTime.now());
        }
        lesson.setUpdatedAt(LocalDateTime.now());

        return lessonRepository.save(lesson);
    }

    /**
     * Tạo lesson mới
     */
    public Lesson createLesson(Lesson lesson) {
        validateLesson(lesson);

        // Tự động set order index nếu chưa có
        if (lesson.getOrderIndex() == null) {
            Integer maxOrder = lessonRepository.getMaxOrderIndexByCourse(lesson.getCourse());
            lesson.setOrderIndex(maxOrder != null ? maxOrder + 1 : 1);
        }

        // Tạo slug từ title
        lesson.setSlug(CourseUtils.StringUtils.createSlug(lesson.getTitle()));

        lesson.setCreatedAt(LocalDateTime.now());
        lesson.setUpdatedAt(LocalDateTime.now());
        lesson.setActive(true);

        return lessonRepository.save(lesson);
    }

    /**
     * Cập nhật lesson
     */
    public Lesson updateLesson(Lesson lesson) {
        if (lesson.getId() == null) {
            throw new RuntimeException("ID lesson không được để trống khi cập nhật");
        }

        Lesson existingLesson = lessonRepository.findById(lesson.getId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lesson với ID: " + lesson.getId()));

        // Cập nhật các trường
        existingLesson.setTitle(lesson.getTitle());
        existingLesson.setContent(lesson.getContent());
        existingLesson.setVideoLink(lesson.getVideoLink());
        existingLesson.setDocumentUrl(lesson.getDocumentUrl());
        existingLesson.setOrderIndex(lesson.getOrderIndex());
        existingLesson.setEstimatedDuration(lesson.getEstimatedDuration());
        existingLesson.setPreview(lesson.isPreview());
        existingLesson.setActive(lesson.isActive());
        existingLesson.setUpdatedAt(LocalDateTime.now());

        // Cập nhật slug nếu title thay đổi
        if (!existingLesson.getTitle().equals(lesson.getTitle())) {
            existingLesson.setSlug(CourseUtils.StringUtils.createSlug(lesson.getTitle()));
        }

        return lessonRepository.save(existingLesson);
    }

    /**
     * Xóa lesson (soft delete)
     */
    public void deleteLesson(Long lessonId) {
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lesson với ID: " + lessonId));

        lesson.setActive(false);
        lesson.setUpdatedAt(LocalDateTime.now());
        lessonRepository.save(lesson);
    }

    /**
     * Xóa lesson hoàn toàn
     */
    public void hardDeleteLesson(Long lessonId) {
        lessonRepository.deleteById(lessonId);
    }

    // ===== TÌM KIẾM LESSONS =====

    /**
     * Tìm lessons theo course
     */
    public List<Lesson> findByCourse(Course course) {
        return lessonRepository.findByCourseOrderByOrderIndex(course);
    }

    /**
     * Tìm lessons theo course ID
     */
    public List<Lesson> findByCourseId(Long courseId) {
        return lessonRepository.findByCourseIdOrderByOrderIndex(courseId);
    }

    /**
     * Tìm lessons theo course ID và active, sắp xếp theo order
     */
    public List<Lesson> findByCourseIdAndActiveOrderByOrder(Long courseId, boolean active) {
        return lessonRepository.findByCourseIdAndActiveOrderByOrderIndex(courseId, active);
    }

    /**
     * Tìm lessons theo course ID, preview và active, sắp xếp theo order
     */
    public List<Lesson> findByCourseIdAndPreviewAndActiveOrderByOrder(Long courseId, boolean preview, boolean active) {
        return lessonRepository.findByCourseIdAndPreviewAndActiveOrderByOrderIndex(courseId, preview, active);
    }

    /**
     * Tìm lessons active của course
     */
    public List<Lesson> findActiveLessonsByCourse(Course course) {
        return lessonRepository.findByCourseAndActiveOrderByOrderIndex(course, true);
    }

    /**
     * Tìm preview lessons của course
     */
    public List<Lesson> findPreviewLessonsByCourse(Course course) {
        return lessonRepository.findByCourseAndPreviewAndActiveOrderByOrderIndex(course, true, true);
    }

    /**
     * Tìm lessons theo instructor
     */
    public List<Lesson> findByInstructor(User instructor) {
        return lessonRepository.findByInstructor(instructor);
    }

    /**
     * Tìm lessons theo instructor với phân trang
     */
    public Page<Lesson> findByInstructor(User instructor, Pageable pageable) {
        return lessonRepository.findByInstructor(instructor, pageable);
    }

    /**
     * Tìm lessons theo course với phân trang
     */
    public Page<Lesson> findByCourse(Course course, Pageable pageable) {
        return lessonRepository.findByCourse(course, pageable);
    }

    // ===== TÌM KIẾM VÀ LỌC =====

    /**
     * Tìm kiếm lessons theo keyword
     */
    public List<Lesson> searchLessons(String keyword) {
        if (!StringUtils.hasText(keyword)) {
            return findAll();
        }
        return lessonRepository.findByTitleContainingIgnoreCaseAndActiveOrderByCreatedAtDesc(keyword,true);
    }

    /**
     * Tìm kiếm lessons theo keyword với phân trang
     */
    public Page<Lesson> searchLessons(String keyword, Pageable pageable) {
        if (!StringUtils.hasText(keyword)) {
            return findAll(pageable);
        }
        return lessonRepository.findByTitleContainingIgnoreCaseAndActiveOrderByCreatedAtDesc(keyword, true, pageable);
    }

    /**
     * Tìm lessons có video
     */
    public List<Lesson> findLessonsWithVideo(Course course) {
        return lessonRepository.findLessonsWithVideo(course);
    }

    /**
     * Tìm lessons có document
     */
    public List<Lesson> findLessonsWithDocument(Course course) {
        return lessonRepository.findLessonsWithDocument(course);
    }

    // ===== ĐẾM VÀ THỐNG KÊ =====

    /**
     * Đếm lessons theo course
     */
    public Long countByCourse(Course course) {
        return lessonRepository.countByCourse(course);
    }

    /**
     * Đếm lessons active theo course
     */
    public Long countActiveByCourse(Course course) {
        return lessonRepository.countByCourseAndActive(course, true);
    }

    /**
     * Đếm lessons theo instructor
     */
    public Long countLessonsByInstructor(User instructor) {
        return lessonRepository.countByInstructor(instructor);
    }

    /**
     * Đếm tổng lessons
     */
    public Long countAll() {
        return lessonRepository.count();
    }

    /**
     * Đếm lessons có video
     */
    public Long countLessonsWithVideo(Course course) {
        return lessonRepository.countLessonsWithVideo(course);
    }

    /**
     * Đếm lessons có document
     */
    public Long countLessonsWithDocument(Course course) {
        return lessonRepository.countLessonsWithDocument(course);
    }

    /**
     * Tính tổng estimated duration của course
     */
    public Integer getTotalDurationByCourse(Course course) {
        return lessonRepository.getTotalEstimatedDurationByCourse(course);
    }

    // ===== VIDEO VÀ DOCUMENT MANAGEMENT =====

    /**
     * Get videoUrl từ lesson (compatibility method)
     */
    public String getVideoUrl(Lesson lesson) {
        if (lesson == null) {
            return null;
        }

        // Nếu entity có videoUrl field riêng
        if (hasVideoUrlField(lesson)) {
            return getVideoUrlField(lesson);
        }

        // Fallback về videoLink
        return lesson.getVideoLink();
    }

    /**
     * Get duration từ lesson (compatibility method)
     */
    public Integer getDuration(Lesson lesson) {
        if (lesson == null) {
            return null;
        }

        // Nếu entity có duration field riêng
        if (hasDurationField(lesson)) {
            return getDurationField(lesson);
        }

        // Fallback về estimatedDuration
        return lesson.getEstimatedDuration();
    }

    /**
     * Upload tài liệu cho lesson
     */
    public String uploadLessonDocument(Long lessonId, MultipartFile file) {
        try {
            if (file == null || file.isEmpty()) {
                throw new RuntimeException("File không được để trống");
            }

            // Validate file
            if (!CourseUtils.FileUtils.isDocumentFile(file.getOriginalFilename())) {
                throw new RuntimeException("File phải là document (pdf, doc, docx, ppt, etc.)");
            }

            // Generate filename
            String fileName = CourseUtils.generateUniqueFilename(file.getOriginalFilename());
            String documentUrl = "/documents/lessons/" + fileName;

            // Save file (implement actual file saving logic)
            String filePath = CourseUtils.saveFile(file, CourseUtils.getDocumentDir(), fileName);

            // Cập nhật lesson
            Lesson lesson = findById(lessonId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy lesson"));
            lesson.setDocumentUrl(documentUrl);
            lesson.setUpdatedAt(LocalDateTime.now());
            save(lesson);

            return documentUrl;
        } catch (Exception e) {
            throw new RuntimeException("Lỗi upload tài liệu: " + e.getMessage());
        }
    }

    /**
     * Upload video cho lesson
     */
    public String uploadLessonVideo(Long lessonId, MultipartFile file) {
        try {
            if (file == null || file.isEmpty()) {
                throw new RuntimeException("File video không được để trống");
            }

            // Validate file
            if (!CourseUtils.FileUtils.isVideoFile(file.getOriginalFilename())) {
                throw new RuntimeException("File phải là video (mp4, avi, mov, etc.)");
            }

            // Check file size (max 100MB)
            if (!CourseUtils.isValidFileSize(file, 100)) {
                throw new RuntimeException("File video quá lớn (tối đa 100MB)");
            }

            // Generate filename
            String fileName = CourseUtils.generateUniqueFilename(file.getOriginalFilename());
            String videoUrl = "/videos/lessons/" + fileName;

            // Save file
            String filePath = CourseUtils.saveFile(file, CourseUtils.getLessonVideoDir(), fileName);

            // Cập nhật lesson
            Lesson lesson = findById(lessonId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy lesson"));

            // Set videoUrl field nếu có, ngược lại set videoLink
            if (hasVideoUrlField(lesson)) {
                setVideoUrlField(lesson, videoUrl);
            } else {
                lesson.setVideoLink(videoUrl);
            }

            lesson.setUpdatedAt(LocalDateTime.now());
            save(lesson);

            return videoUrl;
        } catch (Exception e) {
            throw new RuntimeException("Lỗi upload video: " + e.getMessage());
        }
    }

    // ===== ORDER MANAGEMENT =====

    /**
     * Reorder lessons trong course
     */
    public void reorderLessons(Long courseId, List<Long> lessonIds) {
        Course course = courseService.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy course"));

        for (int i = 0; i < lessonIds.size(); i++) {
            Long lessonId = lessonIds.get(i);
            Optional<Lesson> lessonOpt = findByIdAndCourse(lessonId, course);

            if (lessonOpt.isPresent()) {
                Lesson lesson = lessonOpt.get();
                lesson.setOrderIndex(i + 1);
                lesson.setUpdatedAt(LocalDateTime.now());
                lessonRepository.save(lesson);
            }
        }
    }

    /**
     * Move lesson lên trên
     */
    public void moveLessonUp(Long lessonId) {
        Lesson lesson = findById(lessonId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lesson"));

        if (lesson.getOrderIndex() > 1) {
            // Tìm lesson có order index - 1
            Optional<Lesson> prevLesson = lessonRepository
                    .findByCourseAndOrderIndex(lesson.getCourse(), lesson.getOrderIndex() - 1);

            if (prevLesson.isPresent()) {
                // Swap order index
                int currentOrder = lesson.getOrderIndex();
                lesson.setOrderIndex(prevLesson.get().getOrderIndex());
                prevLesson.get().setOrderIndex(currentOrder);

                lessonRepository.save(lesson);
                lessonRepository.save(prevLesson.get());
            }
        }
    }

    /**
     * Move lesson xuống dưới
     */
    public void moveLessonDown(Long lessonId) {
        Lesson lesson = findById(lessonId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lesson"));

        // Tìm lesson có order index + 1
        Optional<Lesson> nextLesson = lessonRepository
                .findByCourseAndOrderIndex(lesson.getCourse(), lesson.getOrderIndex() + 1);

        if (nextLesson.isPresent()) {
            // Swap order index
            int currentOrder = lesson.getOrderIndex();
            lesson.setOrderIndex(nextLesson.get().getOrderIndex());
            nextLesson.get().setOrderIndex(currentOrder);

            lessonRepository.save(lesson);
            lessonRepository.save(nextLesson.get());
        }
    }

    // ===== VALIDATION =====

    /**
     * Validate lesson trước khi lưu
     */
    private void validateLesson(Lesson lesson) {
        if (lesson == null) {
            throw new RuntimeException("Lesson không được để trống");
        }

        if (!StringUtils.hasText(lesson.getTitle())) {
            throw new RuntimeException("Tiêu đề lesson không được để trống");
        }

        if (!StringUtils.hasText(lesson.getContent())) {
            throw new RuntimeException("Nội dung lesson không được để trống");
        }

        if (lesson.getCourse() == null) {
            throw new RuntimeException("Course không được để trống");
        }

        // Kiểm tra độ dài title
        if (lesson.getTitle().length() < 5 || lesson.getTitle().length() > 200) {
            throw new RuntimeException("Tiêu đề lesson phải từ 5-200 ký tự");
        }

        // Kiểm tra estimated duration
        if (lesson.getEstimatedDuration() != null && lesson.getEstimatedDuration() < 1) {
            throw new RuntimeException("Thời lượng ước tính phải ít nhất 1 phút");
        }
    }

    // ===== HELPER METHODS CHO REFLECTION =====

    /**
     * Kiểm tra lesson có videoUrl field không
     */
    private boolean hasVideoUrlField(Lesson lesson) {
        try {
            lesson.getClass().getDeclaredField("videoUrl");
            return true;
        } catch (NoSuchFieldException e) {
            return false;
        }
    }

    /**
     * Kiểm tra lesson có duration field không
     */
    private boolean hasDurationField(Lesson lesson) {
        try {
            lesson.getClass().getDeclaredField("duration");
            return true;
        } catch (NoSuchFieldException e) {
            return false;
        }
    }

    /**
     * Get videoUrl field value
     */
    private String getVideoUrlField(Lesson lesson) {
        try {
            java.lang.reflect.Field field = lesson.getClass().getDeclaredField("videoUrl");
            field.setAccessible(true);
            return (String) field.get(lesson);
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Set videoUrl field value
     */
    private void setVideoUrlField(Lesson lesson, String videoUrl) {
        try {
            java.lang.reflect.Field field = lesson.getClass().getDeclaredField("videoUrl");
            field.setAccessible(true);
            field.set(lesson, videoUrl);
        } catch (Exception e) {
            // Ignore reflection errors
        }
    }

    /**
     * Get duration field value
     */
    private Integer getDurationField(Lesson lesson) {
        try {
            java.lang.reflect.Field field = lesson.getClass().getDeclaredField("duration");
            field.setAccessible(true);
            return (Integer) field.get(lesson);
        } catch (Exception e) {
            return null;
        }
    }
}