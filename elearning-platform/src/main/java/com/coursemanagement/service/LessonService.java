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

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Service class để xử lý business logic liên quan đến Lesson
 * Quản lý CRUD operations, order management và business rules cho lessons
 */
@Service
@Transactional
public class LessonService {

    @Autowired
    private LessonRepository lessonRepository;

    // ===== BASIC CRUD OPERATIONS =====

    /**
     * Tìm lesson theo ID
     */
    public Optional<Lesson> findById(Long id) {
        return lessonRepository.findById(id);
    }

    /**
     * Tìm lesson theo ID và course (cho security)
     */
    public Optional<Lesson> findByIdAndCourse(Long id, Course course) {
        return lessonRepository.findByIdAndCourse(id, course);
    }

    /**
     * Tìm lesson theo slug
     */
    public Optional<Lesson> findBySlug(String slug) {
        return lessonRepository.findBySlug(slug);
    }

    /**
     * Tạo lesson mới
     */
    public Lesson createLesson(Lesson lesson) {
        validateLesson(lesson);

        // Tạo slug từ title
        lesson.setSlug(CourseUtils.StringUtils.createSlug(lesson.getTitle()));

        // Đảm bảo slug unique trong course
        String originalSlug = lesson.getSlug();
        int counter = 1;
        while (lessonRepository.existsBySlugAndCourse(lesson.getSlug(), lesson.getCourse())) {
            lesson.setSlug(originalSlug + "-" + counter);
            counter++;
        }

        // Set order index mới (cuối cùng)
        if (lesson.getOrderIndex() == null) {
            lesson.setOrderIndex(getNextOrderIndex(lesson.getCourse()));
        } else {
            // Kiểm tra order index đã tồn tại chưa
            if (existsByCourseAndOrderIndex(lesson.getCourse(), lesson.getOrderIndex())) {
                // Shift các lessons sau lên 1 vị trí
                incrementOrderIndex(lesson.getCourse(), lesson.getOrderIndex(), 1);
            }
        }

        // Set thời gian tạo
        lesson.setCreatedAt(LocalDateTime.now());
        lesson.setUpdatedAt(LocalDateTime.now());

        // Mặc định là active
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

        validateLesson(lesson);

        // Kiểm tra order index có thay đổi không
        if (!existingLesson.getOrderIndex().equals(lesson.getOrderIndex())) {
            if (existsByCourseAndOrderIndex(lesson.getCourse(), lesson.getOrderIndex(), lesson.getId())) {
                throw new RuntimeException("Order index đã tồn tại trong course này");
            }
        }

        // Cập nhật thông tin
        existingLesson.setTitle(lesson.getTitle());
        existingLesson.setContent(lesson.getContent());
        existingLesson.setVideoLink(lesson.getVideoLink());
        existingLesson.setVideoUrl(lesson.getVideoUrl());
        existingLesson.setDocumentUrl(lesson.getDocumentUrl());
        existingLesson.setDuration(lesson.getDuration());
        existingLesson.setEstimatedDuration(lesson.getEstimatedDuration());
        existingLesson.setOrderIndex(lesson.getOrderIndex());
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
     */
    public void deleteLesson(Long lessonId) {
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lesson với ID: " + lessonId));

        lesson.setActive(false);
        lesson.setUpdatedAt(LocalDateTime.now());
        lessonRepository.save(lesson);
    }

    /**
     * Xóa lesson vĩnh viễn (hard delete với order index management)
     */
    public void permanentDeleteLesson(Long id) {
        Lesson lesson = lessonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lesson với ID: " + id));

        // Giảm order index của các lessons sau
        decrementOrderIndex(lesson.getCourse(), lesson.getOrderIndex(),
                findMaxOrderIndexByCourse(lesson.getCourse()));

        // Xóa lesson
        lessonRepository.delete(lesson);
    }

    // ===== COURSE-RELATED QUERIES =====

    /**
     * Tìm tất cả lessons của course theo thứ tự
     */
    public List<Lesson> findByCourseOrderByOrderIndex(Course course) {
        return lessonRepository.findByCourseOrderByOrderIndex(course);
    }

    /**
     * Tìm lessons theo course ID
     */
    public List<Lesson> findByCourseId(Long courseId) {
        return lessonRepository.findByCourseIdOrderByOrderIndex(courseId);
    }

    /**
     * Tìm lessons theo course ID sắp xếp theo order index
     */
    public List<Lesson> findByCourseIdOrderByOrderIndex(Long courseId) {
        return lessonRepository.findByCourseIdOrderByOrderIndex(courseId);
    }

    /**
     * Tìm lessons active của course
     */
    public List<Lesson> findActiveLessonsByCourse(Course course) {
        return lessonRepository.findByCourseAndActiveOrderByOrderIndex(course, true);
    }

    /**
     * Tìm lessons theo course với pagination
     */
    public Page<Lesson> findByCourseOrderByOrderIndex(Course course, Pageable pageable) {
        return lessonRepository.findByCourseOrderByOrderIndex(course, pageable);
    }

    /**
     * Tìm lessons có video content
     */
    public List<Lesson> findLessonsWithVideo(Course course) {
        return lessonRepository.findLessonsWithVideo(course);
    }

    // ===== COUNT OPERATIONS =====

    /**
     * Đếm lessons active của course
     */
    public Long countActiveLessonsByCourse(Course course) {
        return lessonRepository.countByCourseAndActive(course, true);
    }

    /**
     * Đếm lessons trong course
     */
    public Long countByCourse(Course course) {
        return lessonRepository.countByCourse(course);
    }

    /**
     * Đếm lessons active trong course
     */
    public Long countByCourseAndActive(Course course, boolean active) {
        return lessonRepository.countByCourseAndActive(course, active);
    }

    /**
     * Đếm lessons của instructor
     */
    public Long countLessonsByInstructor(User instructor) {
        return lessonRepository.countByInstructor(instructor);
    }

    /**
     * Tính tổng duration của course
     */
    public Integer getTotalDurationByCourse(Course course) {
        Integer totalDuration = lessonRepository.getTotalDurationByCourse(course);
        return totalDuration != null ? totalDuration : 0;
    }

    // ===== NAVIGATION METHODS =====

    /**
     * Tìm lesson trước đó trong course (từ lesson object)
     */
    public Optional<Lesson> findPreviousLesson(Lesson currentLesson) {
        return lessonRepository.findPreviousLesson(
                currentLesson.getCourse(),
                currentLesson.getOrderIndex()
        );
    }

    /**
     * Tìm lesson tiếp theo trong course (từ lesson object)
     */
    public Optional<Lesson> findNextLesson(Lesson currentLesson) {
        return lessonRepository.findNextLesson(
                currentLesson.getCourse(),
                currentLesson.getOrderIndex()
        );
    }

    /**
     * Tìm lesson tiếp theo trong course (từ course và order index)
     */
    public Optional<Lesson> findNextLesson(Course course, Integer currentOrderIndex) {
        return lessonRepository.findNextLesson(course, currentOrderIndex);
    }

    /**
     * Tìm lesson trước đó trong course (từ course và order index)
     */
    public Optional<Lesson> findPreviousLesson(Course course, Integer currentOrderIndex) {
        return lessonRepository.findPreviousLesson(course, currentOrderIndex);
    }

    /**
     * Tìm lesson đầu tiên trong course
     */
    public Optional<Lesson> findFirstLessonByCourse(Course course) {
        return lessonRepository.findFirstLessonByCourse(course);
    }

    /**
     * Tìm lesson cuối cùng trong course
     */
    public Optional<Lesson> findLastLessonByCourse(Course course) {
        return lessonRepository.findLastLessonByCourse(course);
    }

    // ===== ORDER INDEX MANAGEMENT =====

    /**
     * Tìm max order index trong course
     */
    public Integer findMaxOrderIndexByCourse(Course course) {
        Integer maxIndex = lessonRepository.findMaxOrderIndexByCourse(course);
        return maxIndex != null ? maxIndex : 0;
    }

    /**
     * Lấy next order index cho lesson mới
     */
    public Integer getNextOrderIndex(Course course) {
        return findMaxOrderIndexByCourse(course) + 1;
    }

    /**
     * Tăng order index của các lessons từ vị trí cho trước
     */
    public void incrementOrderIndex(Course course, Integer fromIndex, int incrementBy) {
        lessonRepository.incrementOrderIndex(course, fromIndex, incrementBy);
    }

    /**
     * Giảm order index của các lessons trong khoảng
     */
    public void decrementOrderIndex(Course course, int fromIndex, Integer toIndex) {
        lessonRepository.decrementOrderIndex(course, fromIndex, toIndex);
    }

    /**
     * Thay đổi thứ tự lesson trong course (original version)
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
     * Thay đổi thứ tự lesson trong course (enhanced version)
     */
    public Lesson changeOrder(Long lessonId, Integer newOrderIndex) {
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lesson với ID: " + lessonId));

        Integer currentOrderIndex = lesson.getOrderIndex();

        if (currentOrderIndex.equals(newOrderIndex)) {
            return lesson; // Không thay đổi
        }

        Course course = lesson.getCourse();

        if (newOrderIndex < currentOrderIndex) {
            // Di chuyển lên trước - tăng order index của các lessons từ newOrderIndex đến currentOrderIndex-1
            incrementOrderIndex(course, newOrderIndex, 1);
        } else {
            // Di chuyển xuống sau - giảm order index của các lessons từ currentOrderIndex+1 đến newOrderIndex
            decrementOrderIndex(course, currentOrderIndex, newOrderIndex);
        }

        // Cập nhật order index mới
        lesson.setOrderIndex(newOrderIndex);
        lesson.setUpdatedAt(LocalDateTime.now());

        return lessonRepository.save(lesson);
    }

    // ===== INSTRUCTOR-RELATED QUERIES =====

    /**
     * Tìm lessons theo instructor (List version)
     */
    public List<Lesson> findByInstructor(User instructor) {
        return lessonRepository.findByInstructor(instructor);
    }

    /**
     * Tìm lessons theo instructor với pagination
     */
    public Page<Lesson> findByInstructor(User instructor, Pageable pageable) {
        return lessonRepository.findByInstructor(instructor, pageable);
    }

    // ===== SEARCH METHODS =====

    /**
     * Tìm lessons active sắp xếp theo ngày tạo
     */
    public Page<Lesson> findByActiveOrderByCreatedAtDesc(boolean active, Pageable pageable) {
        return lessonRepository.findByActiveOrderByCreatedAtDesc(active, pageable);
    }

    /**
     * Tìm lessons theo title chứa keyword
     */
    public Page<Lesson> findByTitleContainingIgnoreCaseAndActiveOrderByCreatedAtDesc(String keyword,
                                                                                     boolean active,
                                                                                     Pageable pageable) {
        return lessonRepository.findByTitleContainingIgnoreCaseAndActiveOrderByCreatedAtDesc(keyword, active, pageable);
    }

    /**
     * Tìm lessons theo keyword
     */
    public Page<Lesson> searchLessonsByKeyword(String keyword, Pageable pageable) {
        if (!StringUtils.hasText(keyword)) {
            return lessonRepository.findByActiveOrderByCreatedAtDesc(true, pageable);
        }
        return lessonRepository.findByTitleContainingIgnoreCaseAndActiveOrderByCreatedAtDesc(keyword, true, pageable);
    }

    // ===== FILE OPERATIONS =====

    /**
     * Upload tài liệu cho lesson
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
     * Lưu video cho lesson
     */
    public String saveVideo(Lesson lesson, MultipartFile videoFile) throws IOException {
        if (videoFile == null || videoFile.isEmpty()) {
            return null;
        }

        // Validate file
        if (!CourseUtils.isValidFileSize(videoFile, 100)) { // Max 100MB
            throw new IOException("File video quá lớn (tối đa 100MB)");
        }

        if (!CourseUtils.isValidFileExtension(videoFile.getOriginalFilename(),
                CourseUtils.getAllowedVideoExtensions())) {
            throw new IOException("File video không đúng định dạng (chỉ cho phép: mp4, avi, mov, wmv, flv, webm)");
        }

        // Tạo tên file unique
        String fileName = CourseUtils.generateUniqueFilename(videoFile.getOriginalFilename());

        // Lưu file
        String filePath = CourseUtils.saveFile(videoFile, CourseUtils.getLessonVideoDir(), fileName);

        return filePath;
    }

    /**
     * Xóa video của lesson
     */
    public void deleteVideo(Lesson lesson) {
        if (lesson != null && StringUtils.hasText(lesson.getVideoUrl())) {
            CourseUtils.deleteFile(lesson.getVideoUrl());
        }
    }

    // ===== VALIDATION & EXISTENCE CHECKS =====

    /**
     * Kiểm tra có lesson nào với order index không
     */
    public boolean existsByCourseAndOrderIndex(Course course, Integer orderIndex) {
        return lessonRepository.existsByCourseAndOrderIndex(course, orderIndex);
    }

    /**
     * Kiểm tra có lesson nào với order index (exclude ID hiện tại)
     */
    public boolean existsByCourseAndOrderIndex(Course course, Integer orderIndex, Long excludeId) {
        return lessonRepository.existsByCourseAndOrderIndexAndIdNot(course, orderIndex, excludeId);
    }

    // ===== PRIVATE VALIDATION METHODS =====

    /**
     * Validate lesson data (Enhanced version)
     */
    private void validateLesson(Lesson lesson) {
        if (lesson == null) {
            throw new RuntimeException("Lesson không được để trống");
        }

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

        if (lesson.getDuration() != null && lesson.getDuration() <= 0) {
            throw new RuntimeException("Thời lượng lesson phải lớn hơn 0");
        }

        if (lesson.getEstimatedDuration() != null && lesson.getEstimatedDuration() < 1) {
            throw new RuntimeException("Thời lượng ước tính phải lớn hơn 0");
        }

        if (lesson.getOrderIndex() != null && lesson.getOrderIndex() <= 0) {
            throw new RuntimeException("Thứ tự lesson phải lớn hơn 0");
        }
    }
}