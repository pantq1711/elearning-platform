package com.coursemanagement.service;

import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.Question;
import com.coursemanagement.entity.Quiz;
import com.coursemanagement.entity.QuizResult;
import com.coursemanagement.entity.User;
import com.coursemanagement.repository.QuizRepository;
import com.coursemanagement.repository.QuizResultRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Dịch vụ quản lý Quiz và QuizResult
 * Xử lý logic nghiệp vụ cho việc tạo quiz, làm bài và chấm điểm
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
     * Lưu quiz
     */
    public Quiz save(Quiz quiz) {
        validateQuiz(quiz);

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
    public Quiz updateQuiz(Quiz quiz) {
        if (quiz.getId() == null) {
            throw new RuntimeException("ID quiz không được để trống khi cập nhật");
        }

        Quiz existingQuiz = quizRepository.findById(quiz.getId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy quiz với ID: " + quiz.getId()));

        // Cập nhật các trường
        existingQuiz.setTitle(quiz.getTitle());
        existingQuiz.setDescription(quiz.getDescription());
        existingQuiz.setDuration(quiz.getDuration());
        existingQuiz.setMaxScore(quiz.getMaxScore());
        existingQuiz.setPassScore(quiz.getPassScore());
        existingQuiz.setActive(quiz.isActive());
        existingQuiz.setShowCorrectAnswers(quiz.isShowCorrectAnswers());
        existingQuiz.setShuffleQuestions(quiz.isShuffleQuestions());
        existingQuiz.setShuffleAnswers(quiz.isShuffleAnswers());
        existingQuiz.setRequireLogin(quiz.isRequireLogin());
        existingQuiz.setAvailableFrom(quiz.getAvailableFrom());
        existingQuiz.setAvailableUntil(quiz.getAvailableUntil());
        existingQuiz.setUpdatedAt(LocalDateTime.now());

        return quizRepository.save(existingQuiz);
    }

    /**
     * Xóa quiz (soft delete)
     */
    public void deleteQuiz(Long quizId) {
        Quiz quiz = quizRepository.findById(quizId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy quiz với ID: " + quizId));

        quiz.setActive(false);
        quiz.setUpdatedAt(LocalDateTime.now());
        quizRepository.save(quiz);
    }

    // ===== TÌM KIẾM QUIZZES =====

    /**
     * Tìm quizzes theo course
     */
    public List<Quiz> findByCourse(Course course) {
        return quizRepository.findByCourseOrderByCreatedAtDesc(course);
    }

    /**
     * Tìm quizzes theo course ID
     */
    public List<Quiz> findByCourse(Long courseId) {
        return quizRepository.findByCourseIdAndActiveOrderByCreatedAtDesc(courseId, true);
    }

    /**
     * Tìm active quizzes theo course
     */
    public List<Quiz> findActiveQuizzesByCourse(Course course) {
        return quizRepository.findByCourseAndActiveOrderByCreatedAtDesc(course, true);
    }

    /**
     * Tìm available quizzes (trong thời gian available)
     */
    public List<Quiz> findAvailableQuizzes(Course course) {
        LocalDateTime now = LocalDateTime.now();
        return quizRepository.findAvailableQuizzes(course, now);
    }

    /**
     * Tìm quizzes theo instructor
     */
    public List<Quiz> findByInstructor(User instructor) {
        return quizRepository.findByInstructor(instructor);
    }

    /**
     * Tìm quizzes theo instructor với phân trang
     */
    public Page<Quiz> findByInstructor(User instructor, Pageable pageable) {
        return quizRepository.findByInstructor(instructor, pageable);
    }

    // ===== ĐẾM VÀ THỐNG KÊ QUIZ =====

    /**
     * Đếm quizzes theo course
     */
    public Long countByCourse(Course course) {
        return quizRepository.countByCourse(course);
    }

    /**
     * Đếm active quizzes theo course
     */
    public Long countActiveByCourse(Course course) {
        return quizRepository.countByCourseAndActive(course, true);
    }

    /**
     * Đếm tổng quizzes
     */
    public Long countAll() {
        return quizRepository.count();
    }

    // ===== QUIZ RESULT MANAGEMENT =====

    /**
     * Tìm quiz results theo student, sắp xếp theo ngày attempt
     */
    public List<QuizResult> findByStudentOrderByAttemptDateDesc(User student) {
        return quizResultRepository.findByUserOrderBySubmittedAtDesc(student);
    }

    /**
     * Tìm quiz results theo student
     */
    public List<QuizResult> findQuizResultsByStudent(User student) {
        return findByStudentOrderByAttemptDateDesc(student);
    }

    /**
     * Kiểm tra student đã attempt quiz chưa
     */
    public boolean existsByStudentAndQuiz(User student, Quiz quiz) {
        return quizResultRepository.existsByUserAndQuiz(student, quiz);
    }

    /**
     * Tìm quiz result theo student và quiz
     */
    public Optional<QuizResult> findByStudentAndQuiz(User student, Quiz quiz) {
        return quizResultRepository.findByUserAndQuiz(student, quiz);
    }

    /**
     * Tìm latest quiz result theo student và quiz
     */
    public Optional<QuizResult> findLatestByStudentAndQuiz(User student, Quiz quiz) {
        List<QuizResult> results = quizResultRepository.findByUserAndQuizOrderBySubmittedAtDesc(student, quiz);
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    /**
     * Tạo quiz result mới
     */
    public QuizResult createQuizResult(Quiz quiz, User student, double score, int correctAnswers, int totalQuestions) {
        QuizResult result = new QuizResult();
        result.setQuiz(quiz);
        result.setUser(student);
        result.setScore(score);
        result.setCorrectAnswers(correctAnswers);
        result.setTotalQuestions(totalQuestions);
        result.setStartedAt(LocalDateTime.now());
        result.setSubmittedAt(LocalDateTime.now());
        result.setPassed(score >= quiz.getPassScore());
        result.setTimeTaken(0); // Set actual time taken

        return quizResultRepository.save(result);
    }

    /**
     * Submit quiz và tính điểm
     */
    public QuizResult submitQuiz(Long quizId, User student, Map<Long, String> answers) {
        Quiz quiz = findById(quizId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy quiz"));

        // Kiểm tra đã attempt chưa (nếu chỉ cho phép 1 lần)
        if (existsByStudentAndQuiz(student, quiz)) {
            throw new RuntimeException("Bạn đã làm bài quiz này rồi");
        }

        // Lấy questions và tính điểm
        List<Question> questions = questionService.findByQuizOrderByDisplayOrder(quiz);
        int correctAnswers = 0;
        double totalPoints = 0.0;

        for (Question question : questions) {
            String studentAnswer = answers.get(question.getId());
            if (studentAnswer != null && studentAnswer.equals(question.getCorrectOption())) {
                correctAnswers++;
                totalPoints += question.getPoints() != null ? question.getPoints() : 1.0;
            }
        }

        // Tính điểm theo tỷ lệ
        double score = quiz.getMaxScore() * (totalPoints / questions.stream()
                .mapToDouble(q -> q.getPoints() != null ? q.getPoints() : 1.0)
                .sum());

        return createQuizResult(quiz, student, score, correctAnswers, questions.size());
    }

    // ===== STATISTICS VÀ ANALYTICS =====

    /**
     * Đếm quiz results theo course quizzes
     */
    public Long countByCourseQuizzes(Course course) {
        return quizResultRepository.countByCourseId(course.getId());
    }

    /**
     * Đếm passed results theo course
     */
    public Long countPassedByCourse(Course course) {
        return quizResultRepository.countByCourseIdAndPassed(course.getId(), true);
    }

    /**
     * Đếm quiz results theo quiz và điểm số tối thiểu
     */
    public Long countByQuizAndScoreGreaterThanEqual(Quiz quiz, Double minScore) {
        return quizResultRepository.countByQuizAndScoreGreaterThanEqual(quiz, minScore);
    }

    /**
     * Lấy average score của quiz
     */
    public Double getAverageScoreByQuiz(Quiz quiz) {
        return quizResultRepository.getAverageScoreByQuiz(quiz);
    }

    /**
     * Lấy thống kê quiz cho course
     */
    public Map<String, Object> getQuizStatsByCourse(Course course) {
        Map<String, Object> stats = new HashMap<>();

        Long totalQuizzes = countByCourse(course);
        Long activeQuizzes = countActiveByCourse(course);
        Long totalAttempts = countByCourseQuizzes(course);
        Long passedAttempts = countPassedByCourse(course);

        stats.put("totalQuizzes", totalQuizzes);
        stats.put("activeQuizzes", activeQuizzes);
        stats.put("totalAttempts", totalAttempts);
        stats.put("passedAttempts", passedAttempts);
        stats.put("passRate", totalAttempts > 0 ? (double) passedAttempts / totalAttempts * 100 : 0.0);

        return stats;
    }

    /**
     * Lấy thống kê quiz cho student
     */
    public Map<String, Object> getStudentQuizStats(User student) {
        Map<String, Object> stats = new HashMap<>();

        List<QuizResult> results = findQuizResultsByStudent(student);
        Long totalAttempts = (long) results.size();
        Long passedAttempts = results.stream()
                .mapToLong(result -> result.isPassed() ? 1 : 0)
                .sum();

        Double averageScore = results.stream()
                .mapToDouble(QuizResult::getScore)
                .average()
                .orElse(0.0);

        stats.put("totalAttempts", totalAttempts);
        stats.put("passedAttempts", passedAttempts);
        stats.put("passRate", totalAttempts > 0 ? (double) passedAttempts / totalAttempts * 100 : 0.0);
        stats.put("averageScore", averageScore);

        return stats;
    }

    // ===== UTILITY METHODS =====

    /**
     * Kiểm tra quiz có available không
     */
    public boolean isQuizAvailable(Quiz quiz) {
        if (!quiz.isActive()) {
            return false;
        }

        LocalDateTime now = LocalDateTime.now();

        if (quiz.getAvailableFrom() != null && now.isBefore(quiz.getAvailableFrom())) {
            return false;
        }

        if (quiz.getAvailableUntil() != null && now.isAfter(quiz.getAvailableUntil())) {
            return false;
        }

        return true;
    }

    /**
     * Kiểm tra student có thể làm quiz không
     */
    public boolean canStudentTakeQuiz(User student, Quiz quiz) {
        // Kiểm tra quiz available
        if (!isQuizAvailable(quiz)) {
            return false;
        }

        // Kiểm tra đã attempt chưa (nếu chỉ cho phép 1 lần)
        if (existsByStudentAndQuiz(student, quiz)) {
            return false;
        }

        return true;
    }

    /**
     * Get user từ QuizResult (wrapper method for compatibility)
     */
    public User getUser(QuizResult quizResult) {
        return quizResult != null ? quizResult.getUser() : null;
    }

    /**
     * Get submitted date từ QuizResult (wrapper method for compatibility)
     */
    public LocalDateTime getSubmittedAt(QuizResult quizResult) {
        return quizResult != null ? quizResult.getSubmittedAt() : null;
    }

    // ===== VALIDATION =====

    /**
     * Validate quiz trước khi lưu
     */
    private void validateQuiz(Quiz quiz) {
        if (quiz == null) {
            throw new RuntimeException("Quiz không được để trống");
        }

        if (!StringUtils.hasText(quiz.getTitle())) {
            throw new RuntimeException("Tiêu đề quiz không được để trống");
        }

        if (quiz.getCourse() == null) {
            throw new RuntimeException("Course không được để trống");
        }

        if (quiz.getDuration() != null && quiz.getDuration() < 1) {
            throw new RuntimeException("Thời gian làm bài phải ít nhất 1 phút");
        }

        if (quiz.getMaxScore() != null && quiz.getMaxScore() <= 0) {
            throw new RuntimeException("Điểm tối đa phải lớn hơn 0");
        }

        if (quiz.getPassScore() != null && quiz.getMaxScore() != null &&
                quiz.getPassScore() > quiz.getMaxScore()) {
            throw new RuntimeException("Điểm đạt không được lớn hơn điểm tối đa");
        }

        // Kiểm tra thời gian available
        if (quiz.getAvailableFrom() != null && quiz.getAvailableUntil() != null &&
                quiz.getAvailableFrom().isAfter(quiz.getAvailableUntil())) {
            throw new RuntimeException("Thời gian bắt đầu không được sau thời gian kết thúc");
        }
    }
}