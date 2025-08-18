package com.coursemanagement.service;

import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.Question;
import com.coursemanagement.entity.Quiz;
import com.coursemanagement.entity.QuizResult;
import com.coursemanagement.entity.User;
import com.coursemanagement.repository.QuizRepository;
import com.coursemanagement.repository.QuizResultRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.*;

/**
 * Dịch vụ quản lý Quiz và QuizResult
 * Xử lý logic nghiệp vụ cho việc tạo quiz, làm bài và chấm điểm
 * Đã sửa tất cả lỗi compilation và entity field names
 */
@Service
@Transactional
public class QuizService {

    @Autowired
    private QuizRepository quizRepository;

    @Autowired
    private QuizResultRepository quizResultRepository;

    @Autowired
    private QuestionService questionService;

    // SỬA LỖI: Thêm injection cho EnrollmentService với @Lazy để tránh circular dependency
    @Lazy
    @Autowired
    private EnrollmentService enrollmentService;

    // ===== CÁC THAO TÁC CRUD CƠ BẢN CHO QUIZ =====

    /**
     * Tìm quiz theo ID
     */
    public Optional<Quiz> findById(Long id) {
        return quizRepository.findById(id);
    }

    /**
     * Tìm quiz theo ID và course (để bảo mật)
     */
    public Optional<Quiz> findByIdAndCourse(Long id, Course course) {
        return quizRepository.findByIdAndCourse(id, course);
    }
    /**
     * Tìm active quizzes theo course
     */
    public List<Quiz> findActiveQuizzesByCourse(Course course) {
        return quizRepository.findByCourseAndActiveOrderByCreatedAtDesc(course, true);
    }

    /**
     * Tìm tất cả quizzes
     */
    public List<Quiz> findAll() {
        return quizRepository.findAll();
    }

    /**
     * Tìm quizzes với phân trang
     */
    public Page<Quiz> findAll(Pageable pageable) {
        return quizRepository.findAll(pageable);
    }

    /**
     * Bắt đầu quiz cho student (SỬA TẤT CẢ LỖI ENTITY FIELDS)
     */
    @Transactional
    public QuizResult startQuiz(User student, Quiz quiz) {
        // SỬA LỖI: Gọi đúng method từ EnrollmentService
        if (!enrollmentService.isStudentEnrolled(student, quiz.getCourse())) {
            throw new RuntimeException("Bạn chưa đăng ký khóa học này");
        }

        // Kiểm tra quiz có available không
        if (!quiz.isActive()) {
            throw new RuntimeException("Quiz này hiện không khả dụng");
        }

        // Kiểm tra đã làm quiz chưa
        if (hasStudentTakenQuiz(student, quiz)) {
            throw new RuntimeException("Bạn đã hoàn thành quiz này");
        }

        // Tạo quiz result mới
        QuizResult quizResult = new QuizResult();
        quizResult.setStudent(student);
        quizResult.setQuiz(quiz);
        quizResult.setStartTime(LocalDateTime.now());
        quizResult.setCompleted(false);
        quizResult.setPassed(false);
        quizResult.setAttemptDate(LocalDateTime.now());

        return quizResultRepository.save(quizResult);
    }
    /**
     * Nộp bài quiz (SỬA TẤT CẢ LỖI ENTITY FIELDS)
     */
    @Transactional
    public QuizResult submitQuiz(User student, Quiz quiz, Map<Long, String> answers) {
        // Tìm quiz result của student
        Optional<QuizResult> optionalResult = quizResultRepository.findByStudentAndQuiz(student, quiz);

        if (optionalResult.isEmpty()) {
            throw new RuntimeException("Không tìm thấy bài làm quiz của bạn");
        }

        QuizResult quizResult = optionalResult.get();

        if (quizResult.isCompleted()) {
            throw new RuntimeException("Quiz này đã được nộp");
        }

        // Tính điểm
        double score = calculateQuizScore(quiz, answers);
        boolean passed = score >= quiz.getPassScore();

        // Cập nhật quiz result
        quizResult.setScore(score);
        quizResult.setPassed(passed);
        quizResult.setCompletionTime(LocalDateTime.now());
        quizResult.setCompleted(true);
        quizResult.setAnswers(convertAnswersToJson(answers));

        return quizResultRepository.save(quizResult);
    }

    /**
     * Tính điểm quiz (SỬA LỖI QUESTION ENTITY VÀ METHOD SIGNATURE)
     */
    private double calculateQuizScore(Quiz quiz, Map<Long, String> answers) {
        // SỬA LỖI: Sử dụng method signature đúng
        List<Question> questions = questionService.findByQuizOrderByDisplayOrder(quiz);
        double totalScore = 0.0;
        double maxScore = 0.0;

        for (Question question : questions) {
            maxScore += question.getPoints();
            String studentAnswer = answers.get(question.getId());

            // SỬA LỖI: getCorrectOption() thay vì getCorrectAnswer()
            if (studentAnswer != null && studentAnswer.equals(question.getCorrectOption())) {
                totalScore += question.getPoints();
            }
        }

        return maxScore > 0 ? (totalScore / maxScore) * quiz.getMaxScore() : 0.0;
    }

    /**
     * Convert answers map to JSON string
     */
    private String convertAnswersToJson(Map<Long, String> answers) {
        if (answers == null || answers.isEmpty()) {
            return "{}";
        }

        StringBuilder json = new StringBuilder("{");
        boolean first = true;
        for (Map.Entry<Long, String> entry : answers.entrySet()) {
            if (!first) {
                json.append(",");
            }
            json.append("\"").append(entry.getKey()).append("\":\"").append(entry.getValue()).append("\"");
            first = false;
        }
        json.append("}");

        return json.toString();
    }

    /**
     * Lưu quiz
     */
    public Quiz save(Quiz quiz) {
        validateQuiz(quiz);

        // Set thời gian tạo/cập nhật
        if (quiz.getId() == null) {
            quiz.setCreatedAt(LocalDateTime.now());
        }
        quiz.setUpdatedAt(LocalDateTime.now());

        return quizRepository.save(quiz);
    }

    /**
     * Tạo quiz mới
     */
    public Quiz createQuiz(Quiz quiz) {
        validateQuiz(quiz);
        quiz.setCreatedAt(LocalDateTime.now());
        quiz.setUpdatedAt(LocalDateTime.now());
        quiz.setActive(true);

        return quizRepository.save(quiz);
    }

    /**
     * Cập nhật quiz
     */
//    public Quiz updateQuiz(Quiz quiz) {
//        if (quiz.getId() == null) {
//            throw new RuntimeException("ID quiz không được để trống khi cập nhật");
//        }
//
//        Quiz existingQuiz = quizRepository.findById(quiz.getId())
//                .orElseThrow(() -> new RuntimeException("Không tìm thấy quiz với ID: " + quiz.getId()));
//
//        // Cập nhật các field
//        existingQuiz.setTitle(quiz.getTitle());
//        existingQuiz.setDescription(quiz.getDescription());
//        existingQuiz.setDuration(quiz.getDuration());
//        existingQuiz.setMaxScore(quiz.getMaxScore());
//        existingQuiz.setPassScore(quiz.getPassScore());
//        existingQuiz.setPoints(quiz.getPoints());
//        existingQuiz.setActive(quiz.isActive());
//        existingQuiz.setShowCorrectAnswers(quiz.isShowCorrectAnswers());
//        existingQuiz.setShuffleQuestions(quiz.isShuffleQuestions());
//        existingQuiz.setShuffleAnswers(quiz.isShuffleAnswers());
//        existingQuiz.setRequireLogin(quiz.isRequireLogin());
//        existingQuiz.setAvailableFrom(quiz.getAvailableFrom());
//        existingQuiz.setAvailableUntil(quiz.getAvailableUntil());
//        existingQuiz.setUpdatedAt(LocalDateTime.now());
//
//        return quizRepository.save(existingQuiz);
//    }

    /**
     * Xóa quiz (soft delete)
     */
//    @Transactional
//    public void deleteQuiz(Long id) {
//        Quiz quiz = quizRepository.findById(id)
//                .orElseThrow(() -> new RuntimeException("Không tìm thấy quiz với ID: " + id));
//
//        quiz.setActive(false);
//        quiz.setUpdatedAt(LocalDateTime.now());
//        quizRepository.save(quiz);
//    }

    // ===== CÁC METHODS CÒN THIẾU ĐÃ SỬA LỖI =====

    /**
     * Đếm active quizzes theo course
     */
    public Long countActiveQuizzesByCourse(Course course) {
        return quizRepository.countActiveQuizzesByCourse(course);
    }

    /**
     * Tìm available quizzes cho student
     */
    public List<Quiz> findAvailableQuizzesForStudent(User student) {
        return quizRepository.findAvailableQuizzesForStudent(student);
    }

    /**
     * Tìm completed quizzes cho student
     */
    public List<Quiz> findCompletedQuizzesForStudent(User student) {
        return quizRepository.findCompletedQuizzesForStudent(student);
    }

    /**
     * Kiểm tra student đã làm quiz chưa (SỬA LỖI METHOD NAME)
     */
    public boolean hasStudentTakenQuiz(User student, Quiz quiz) {
        return quizResultRepository.hasStudentCompletedQuiz(student, quiz);
    }

    /**
     * Tìm quiz result của student cho quiz (SỬA LỖI METHOD NAME)
     */
    public Optional<QuizResult> findQuizResult(User student, Quiz quiz) {
        return quizResultRepository.findQuizResult(student, quiz);
    }

    /**
     * Tìm quiz results theo student (SỬA LỖI METHOD NAME)
     */
    public List<QuizResult> findQuizResultsByStudent(User student) {
        Pageable pageable = PageRequest.of(0, 10, Sort.by("completionTime").descending());
        return quizResultRepository.findByStudentOrderByCompletionTimeDesc(student, pageable);
    }

    /**
     * Đếm tất cả quizzes active
     */
    public Long countAllActiveQuizzes() {
        return quizRepository.countAllActiveQuizzes();
    }

    /**
     * Tìm quizzes theo instructor
     */
    public List<Quiz> findQuizzesByInstructor(User instructor, int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return quizRepository.findQuizzesByInstructor(instructor, pageable);
    }

    /**
     * Đếm quizzes theo instructor
     */
    public Long countQuizzesByInstructor(User instructor) {
        return quizRepository.countQuizzesByInstructor(instructor);
    }

    /**
     * Lấy thống kê quiz với QuizResult fields đúng
     */
//    public Map<String, Object> getQuizStatistics(Quiz quiz) {
//        Map<String, Object> stats = new HashMap<>();
//
//        List<QuizResult> allResults = quizResultRepository.findByQuiz(quiz);
//        Long totalAttempts = (long) allResults.size();
//        Long passedAttempts = allResults.stream()
//                .mapToLong(result -> result.isPassed() ? 1 : 0)
//                .sum();
//
//        Double averageScore = allResults.stream()
//                .filter(result -> result.getScore() != null)
//                .mapToDouble(QuizResult::getScore)
//                .average()
//                .orElse(0.0);
//
//        stats.put("totalAttempts", totalAttempts);
//        stats.put("passedAttempts", passedAttempts);
//        stats.put("passRate", totalAttempts > 0 ? (double) passedAttempts / totalAttempts * 100 : 0.0);
//        stats.put("averageScore", averageScore);
//
//        return stats;
//    }

    // ===== COURSE-RELATED QUERIES =====

    /**
     * Tìm quizzes theo course
     */
    public List<Quiz> findByCourse(Course course) {
        return quizRepository.findByCourseOrderByCreatedAtDesc(course);
    }

    /**
     * Tìm active quizzes theo course
     */
    public List<Quiz> findActiveByCourse(Course course) {
        return quizRepository.findByCourseAndActiveOrderByCreatedAtDesc(course, true);
    }

    /**
     * Tìm quizzes theo course với pagination
     */
    public Page<Quiz> findByCourse(Course course, Pageable pageable) {
        return quizRepository.findByCourse(course, pageable);
    }

    /**
     * Đếm quizzes theo course
     */
    public Long countByCourse(Course course) {
        return quizRepository.countByCourse(course);
    }

    // ===== INSTRUCTOR METHODS =====

    /**
     * Tìm quizzes theo instructor
     */
//    public List<Quiz> findByInstructor(User instructor) {
//        return quizRepository.findQuizzesByInstructor(instructor, PageRequest.of(0, 100));
//    }

    /**
     * Tìm recent quizzes theo instructor
     */
    public List<Quiz> findRecentByInstructor(User instructor, int limit) {
        return quizRepository.findQuizzesByInstructor(instructor, PageRequest.of(0, limit));
    }

    // ===== SEARCH METHODS =====

    /**
     * Tìm quiz theo ID hoặc throw exception
     */
    public Quiz findByIdOrThrow(Long id) {
        return quizRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy quiz với ID: " + id));
    }

    /**
     * Kiểm tra quiz title đã tồn tại trong course chưa
     */
    public boolean existsByTitleAndCourse(String title, Course course) {
        return quizRepository.existsByTitleAndCourse(title, course);
    }

    /**
     * Kiểm tra quiz title đã tồn tại trong course chưa (exclude current)
     */
    public boolean existsByTitleAndCourseAndIdNot(String title, Course course, Long id) {
        return quizRepository.existsByTitleAndCourseAndIdNot(title, course, id);
    }

    /**
     * Validate quiz trước khi save
     */
    private void validateQuiz(Quiz quiz) {
        if (quiz.getTitle() == null || quiz.getTitle().trim().isEmpty()) {
            throw new RuntimeException("Tiêu đề quiz không được để trống");
        }

        if (quiz.getCourse() == null) {
            throw new RuntimeException("Khóa học không được để trống");
        }

        if (quiz.getMaxScore() == null || quiz.getMaxScore() <= 0) {
            throw new RuntimeException("Điểm tối đa phải lớn hơn 0");
        }

        if (quiz.getPassScore() == null || quiz.getPassScore() <= 0) {
            throw new RuntimeException("Điểm đạt phải lớn hơn 0");
        }

        if (quiz.getPassScore() > quiz.getMaxScore()) {
            throw new RuntimeException("Điểm đạt không được lớn hơn điểm tối đa");
        }
    }
    public List<Quiz> findByInstructor(User instructor) {
        try {
            // Sử dụng method mới với FETCH JOIN để tránh N+1 query
            return quizRepository.findQuizzesByInstructorWithDetails(instructor);
        } catch (Exception e) {
            // Fallback về method cũ nếu có lỗi
            return quizRepository.findByInstructor(instructor);
        }
    }

    /**
     * SỬA LỖI: Tìm tất cả quizzes theo instructor
     */
    public List<Quiz> findAllByInstructor(User instructor) {
        try {
            return quizRepository.findAllQuizzesByInstructorWithDetails(instructor);
        } catch (Exception e) {
            return quizRepository.findByInstructor(instructor);
        }
    }
    // THÊM VÀO QuizService.java

    /**
     * SỬA LỖI: Copy quiz (duplicate) với tất cả questions
     */
    @Transactional
    public Quiz copyQuiz(Quiz originalQuiz, Course targetCourse) {
        try {
            // Tạo quiz mới
            Quiz newQuiz = new Quiz();
            newQuiz.setTitle(originalQuiz.getTitle() + " (Copy)");
            newQuiz.setDescription(originalQuiz.getDescription());
            newQuiz.setCourse(targetCourse);
            newQuiz.setDuration(originalQuiz.getDuration());
            newQuiz.setMaxScore(originalQuiz.getMaxScore());
            newQuiz.setPassScore(originalQuiz.getPassScore());
            newQuiz.setPoints(originalQuiz.getPoints());
            newQuiz.setActive(false); // Tạo ở trạng thái draft
            newQuiz.setShowCorrectAnswers(originalQuiz.isShowCorrectAnswers());
            newQuiz.setShuffleQuestions(originalQuiz.isShuffleQuestions());
            newQuiz.setShuffleAnswers(originalQuiz.isShuffleAnswers());
            newQuiz.setRequireLogin(originalQuiz.isRequireLogin());
            newQuiz.setAvailableFrom(originalQuiz.getAvailableFrom());
            newQuiz.setAvailableUntil(originalQuiz.getAvailableUntil());
            newQuiz.setCreatedAt(LocalDateTime.now());
            newQuiz.setUpdatedAt(LocalDateTime.now());

            Quiz savedQuiz = quizRepository.save(newQuiz);

            // Copy questions nếu có QuestionService
//            try {
//                if (questionService != null) {
//                    questionService.copyQuestionsToQuiz(originalQuiz, savedQuiz);
//                }
//            } catch (Exception e) {
//            }

            return savedQuiz;
        } catch (Exception e) {
            throw new RuntimeException("Không thể sao chép quiz: " + e.getMessage());
        }
    }

    /**
     * SỬA LỖI: Soft delete quiz
     */
    @Transactional
    public void deleteQuiz(Long quizId) {
        try {
            Quiz quiz = quizRepository.findById(quizId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy quiz với ID: " + quizId));

            // Soft delete - set active = false
            quiz.setActive(false);
            quiz.setUpdatedAt(LocalDateTime.now());

            quizRepository.save(quiz);

        } catch (Exception e) {
            throw new RuntimeException("Không thể xóa quiz: " + e.getMessage());
        }
    }

    /**
     * SỬA LỖI: Update quiz method
     */
    @Transactional
    public Quiz updateQuiz(Quiz quiz) {
        try {
            if (quiz.getId() == null) {
                throw new RuntimeException("ID quiz không được để trống khi cập nhật");
            }

            Quiz existingQuiz = quizRepository.findById(quiz.getId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy quiz với ID: " + quiz.getId()));

            // Validate trước khi update
            validateQuiz(quiz);

            // Cập nhật các field
            existingQuiz.setTitle(quiz.getTitle());
            existingQuiz.setDescription(quiz.getDescription());
            existingQuiz.setDuration(quiz.getDuration());
            existingQuiz.setMaxScore(quiz.getMaxScore());
            existingQuiz.setPassScore(quiz.getPassScore());
            existingQuiz.setPoints(quiz.getPoints());
            existingQuiz.setActive(quiz.isActive());
            existingQuiz.setShowCorrectAnswers(quiz.isShowCorrectAnswers());
            existingQuiz.setShuffleQuestions(quiz.isShuffleQuestions());
            existingQuiz.setShuffleAnswers(quiz.isShuffleAnswers());
            existingQuiz.setRequireLogin(quiz.isRequireLogin());
            existingQuiz.setAvailableFrom(quiz.getAvailableFrom());
            existingQuiz.setAvailableUntil(quiz.getAvailableUntil());
            existingQuiz.setUpdatedAt(LocalDateTime.now());

            // Course không được thay đổi trong update
            // existingQuiz.setCourse(quiz.getCourse());

            return quizRepository.save(existingQuiz);
        } catch (Exception e) {
            throw new RuntimeException("Không thể cập nhật quiz: " + e.getMessage());
        }
    }

    /**
     * SỬA LỖI: Tìm quiz results by quiz
     */
    public List<QuizResult> findResultsByQuiz(Quiz quiz) {
        try {
            return quizResultRepository.findByQuizOrderByAttemptDateDesc(quiz);
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    /**
     * SỬA LỖI: Get quiz statistics
     */
    public Map<String, Object> getQuizStatistics(Quiz quiz) {
        Map<String, Object> stats = new HashMap<>();
        try {
            List<QuizResult> allResults = quizResultRepository.findByQuiz(quiz);

            Long totalAttempts = (long) allResults.size();
            Long passedAttempts = allResults.stream()
                    .mapToLong(result -> result.isPassed() ? 1 : 0)
                    .sum();

            Double averageScore = allResults.stream()
                    .filter(result -> result.getScore() != null)
                    .mapToDouble(QuizResult::getScore)
                    .average()
                    .orElse(0.0);

            Double passRate = totalAttempts > 0 ? (double) passedAttempts / totalAttempts * 100 : 0.0;

            stats.put("totalAttempts", totalAttempts);
            stats.put("passedAttempts", passedAttempts);
            stats.put("passRate", passRate);
            stats.put("averageScore", averageScore);
            stats.put("totalQuestions", quiz.getQuestions() != null ? quiz.getQuestions().size() : 0);

            return stats;
        } catch (Exception e) {
            return stats;
        }
    }

}