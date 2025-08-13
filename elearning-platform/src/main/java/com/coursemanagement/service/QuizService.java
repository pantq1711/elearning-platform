package com.coursemanagement.service;

import com.coursemanagement.entity.Course;
import com.coursemanagement.entity.Question;
import com.coursemanagement.entity.Quiz;
import com.coursemanagement.entity.QuizResult;
import com.coursemanagement.entity.User;
import com.coursemanagement.repository.QuizRepository;
import com.coursemanagement.repository.QuizResultRepository;
import com.coursemanagement.utils.CourseUtils;
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
 * Service class để xử lý business logic liên quan đến Quiz
 * Quản lý CRUD operations, quiz attempts, grading system và analytics
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

    // ===== BASIC CRUD OPERATIONS =====

    /**
     * Tìm quiz theo ID
     */
    public Optional<Quiz> findById(Long id) {
        return quizRepository.findById(id);
    }

    /**
     * Tìm quiz theo ID và course (cho security)
     */
    public Optional<Quiz> findByIdAndCourse(Long id, Course course) {
        return quizRepository.findByIdAndCourse(id, course);
    }

    /**
     * Tạo quiz mới
     */
    public Quiz createQuiz(Quiz quiz) {
        validateQuiz(quiz);

        // Set thời gian tạo
        quiz.setCreatedAt(LocalDateTime.now());
        quiz.setUpdatedAt(LocalDateTime.now());

        // Mặc định là active
        quiz.setActive(true);

        // Set default values
        if (quiz.getDuration() == null) {
            quiz.setDuration(60); // Default 60 phút
        }

        if (quiz.getMaxScore() == null) {
            quiz.setMaxScore(100.0); // Default 100 điểm
        }

        if (quiz.getPassScore() == null) {
            quiz.setPassScore(60.0); // Default 60 điểm để pass
        }

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

        validateQuiz(quiz);

        // Cập nhật thông tin
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

    // ===== COURSE-RELATED QUERIES =====

    /**
     * Tìm tất cả quizzes của course
     */
    public List<Quiz> findByCourse(Course course) {
        return quizRepository.findByCourseOrderByCreatedAtDesc(course);
    }

    /**
     * Tìm quizzes theo course sắp xếp theo ngày tạo
     */
    public List<Quiz> findByCourseOrderByCreatedAtDesc(Course course) {
        return quizRepository.findByCourseOrderByCreatedAtDesc(course);
    }

    /**
     * Tìm quizzes theo course với pagination
     */
    public Page<Quiz> findByCourse(Course course, Pageable pageable) {
        return quizRepository.findByCourse(course, pageable);
    }

    /**
     * Tìm active quizzes của course (với order by)
     */
    public List<Quiz> findActiveByCourse(Course course) {
        return quizRepository.findByCourseAndActiveOrderByCreatedAtDesc(course, true);
    }

    /**
     * Tìm active quizzes theo course (không order by)
     */
    public List<Quiz> findByCourseAndActive(Course course, boolean active) {
        return quizRepository.findByCourseAndActive(course, active);
    }

    /**
     * Đếm quizzes trong course
     */
    public Long countByCourse(Course course) {
        return quizRepository.countByCourse(course);
    }

    /**
     * Đếm active quizzes của course
     */
    public Long countActiveQuizzesByCourse(Course course) {
        return quizRepository.countByCourseAndActive(course, true);
    }

    /**
     * Đếm quiz attempts cho course
     */
    public Long countByCourseQuizzes(Course course) {
        return quizRepository.countByCourseQuizzes(course);
    }

    /**
     * Đếm passed quiz attempts cho course
     */
    public Long countPassedByCourse(Course course) {
        return quizRepository.countPassedByCourse(course);
    }

    // ===== STUDENT-RELATED QUERIES =====

    /**
     * Tìm available quizzes cho student (User object)
     */
    public List<Quiz> findAvailableQuizzesForStudent(User student) {
        return quizRepository.findAvailableQuizzesForStudent(student.getId());
    }

    /**
     * Tìm available quizzes cho student (ID)
     */
    public List<Quiz> findAvailableQuizzesForStudent(Long studentId) {
        return quizRepository.findAvailableQuizzesForStudent(studentId);
    }

    /**
     * Tìm completed quizzes cho student (User object)
     */
    public List<Quiz> findCompletedQuizzesForStudent(User student) {
        return quizRepository.findCompletedQuizzesForStudent(student.getId());
    }

    /**
     * Tìm completed quizzes cho student (ID)
     */
    public List<Quiz> findCompletedQuizzesForStudent(Long studentId) {
        return quizRepository.findCompletedQuizzesForStudent(studentId);
    }

    /**
     * Tìm quiz results của student
     */
    public List<QuizResult> findQuizResultsByStudent(User student) {
        return quizResultRepository.findByStudentOrderByAttemptDateDesc(student);
    }

    /**
     * Tìm quiz results theo student sắp xếp theo attempt date
     */
    public List<QuizResult> findByStudentOrderByAttemptDateDesc(User student) {
        return quizRepository.findByStudentOrderByAttemptDateDesc(student);
    }

    /**
     * Kiểm tra student đã làm quiz chưa (original method name)
     */
    public boolean hasStudentTakenQuiz(User student, Quiz quiz) {
        return quizResultRepository.existsByStudentAndQuiz(student, quiz);
    }

    /**
     * Kiểm tra student đã làm quiz chưa (repository method name)
     */
    public boolean existsByStudentAndQuiz(User student, Quiz quiz) {
        return quizRepository.existsByStudentAndQuiz(student, quiz);
    }

    /**
     * Tìm quiz result (original method)
     */
    public Optional<QuizResult> findQuizResult(User student, Quiz quiz) {
        return quizResultRepository.findByStudentAndQuiz(student, quiz);
    }

    /**
     * Tìm quiz result theo student và quiz
     */
    public Optional<QuizResult> findByStudentAndQuiz(User student, Quiz quiz) {
        return quizRepository.findByStudentAndQuiz(student, quiz);
    }

    // ===== INSTRUCTOR-RELATED QUERIES =====

    /**
     * Tìm quizzes theo instructor (List version)
     */
    public List<Quiz> findByInstructor(User instructor) {
        return quizRepository.findByInstructor(instructor);
    }

    /**
     * Tìm quizzes theo instructor với pagination
     */
    public Page<Quiz> findByInstructor(User instructor, Pageable pageable) {
        return quizRepository.findByInstructor(instructor, pageable);
    }

    // ===== SEARCH METHODS =====

    /**
     * Tìm quizzes theo title chứa keyword
     */
    public Page<Quiz> findByTitleContainingIgnoreCase(String keyword, Pageable pageable) {
        return quizRepository.findByTitleContainingIgnoreCase(keyword, pageable);
    }

    /**
     * Tìm quizzes sắp hết hạn
     */
    public List<Quiz> findQuizzesExpiringWithin(int days) {
        LocalDateTime expireDate = LocalDateTime.now().plusDays(days);
        return quizRepository.findQuizzesExpiringWithin(expireDate);
    }

    // ===== QUIZ ATTEMPT MANAGEMENT =====

    /**
     * Bắt đầu làm quiz
     */
    public QuizResult startQuiz(User student, Quiz quiz) {
        // Kiểm tra student đã làm quiz này chưa
        Optional<QuizResult> existingResult = quizResultRepository.findByStudentAndQuiz(student, quiz);
        if (existingResult.isPresent()) {
            throw new RuntimeException("Bạn đã làm bài kiểm tra này rồi");
        }

        // Tạo quiz result mới
        QuizResult quizResult = new QuizResult();
        quizResult.setStudent(student);
        quizResult.setQuiz(quiz);
        quizResult.setStartTime(LocalDateTime.now());
        quizResult.setScore(0.0);
        quizResult.setPassed(false);
        quizResult.setCompleted(false);

        return quizResultRepository.save(quizResult);
    }

    /**
     * Submit quiz (Enhanced version)
     */
    public QuizResult submitQuiz(User student, Quiz quiz, Map<Long, String> answers) {
        // Kiểm tra quiz có available không
        if (!quiz.isAvailable()) {
            throw new RuntimeException("Quiz không còn mở để làm bài");
        }

        // Tìm hoặc tạo quiz result
        QuizResult quizResult = quizResultRepository.findByStudentAndQuiz(student, quiz)
                .orElse(null);

        if (quizResult == null) {
            // Tạo mới nếu chưa có
            quizResult = new QuizResult();
            quizResult.setStudent(student);
            quizResult.setUser(student);
            quizResult.setQuiz(quiz);
            quizResult.setStartTime(LocalDateTime.now());
        } else if (quizResult.isCompleted()) {
            throw new RuntimeException("Bài kiểm tra này đã được hoàn thành rồi");
        }

        // Chấm điểm
        double score = calculateScore(quiz, answers);
        boolean passed = score >= quiz.getPassScore();

        // Cập nhật quiz result
        quizResult.setScore(score);
        quizResult.setPassed(passed);
        quizResult.setCompleted(true);
        quizResult.setCompletionTime(LocalDateTime.now());
        quizResult.setSubmittedAt(LocalDateTime.now());
        quizResult.setAnswers(convertAnswersToJson(answers));

        return quizResultRepository.save(quizResult);
    }

    // ===== STATISTICS & ANALYTICS =====

    /**
     * Lấy thống kê quiz của course
     */
    public Map<String, Object> getQuizStatistics(Course course) {
        Map<String, Object> stats = new HashMap<>();

        Long totalQuizzes = quizRepository.countByCourse(course);
        Long activeQuizzes = quizRepository.countByCourseAndActive(course, true);
        Long totalAttempts = quizResultRepository.countByCourseQuizzes(course);
        Long passedAttempts = quizResultRepository.countPassedByCourse(course);

        stats.put("totalQuizzes", totalQuizzes);
        stats.put("activeQuizzes", activeQuizzes);
        stats.put("totalAttempts", totalAttempts);
        stats.put("passedAttempts", passedAttempts);
        stats.put("passRate", totalAttempts > 0 ? (double) passedAttempts / totalAttempts * 100 : 0);

        return stats;
    }

    /**
     * Lấy thống kê chi tiết của quiz
     */
    public Map<String, Object> getQuizStatistics(Quiz quiz) {
        Map<String, Object> stats = new HashMap<>();

        stats.put("totalAttempts", countAttemptsByQuiz(quiz));
        stats.put("averageScore", getAverageScore(quiz));
        stats.put("highestScore", getHighestScore(quiz));
        stats.put("lowestScore", getLowestScore(quiz));
        stats.put("passRate", calculatePassRate(quiz));

        return stats;
    }

    /**
     * Lấy average score của quiz
     */
    public Double getAverageScore(Quiz quiz) {
        return quizRepository.getAverageScore(quiz);
    }

    /**
     * Lấy highest score của quiz
     */
    public Double getHighestScore(Quiz quiz) {
        return quizRepository.getHighestScore(quiz);
    }

    /**
     * Lấy lowest score của quiz
     */
    public Double getLowestScore(Quiz quiz) {
        return quizRepository.getLowestScore(quiz);
    }

    /**
     * Đếm students đã attempt quiz
     */
    public Long countAttemptsByQuiz(Quiz quiz) {
        return quizRepository.countAttemptsByQuiz(quiz);
    }

    /**
     * Tìm recent quiz results với pagination
     */
    public Page<QuizResult> findRecentResultsByQuiz(Quiz quiz, Pageable pageable) {
        return quizRepository.findRecentResultsByQuiz(quiz, pageable);
    }

    /**
     * Tính tỷ lệ pass của quiz
     */
    private double calculatePassRate(Quiz quiz) {
        Long totalAttempts = countAttemptsByQuiz(quiz);
        if (totalAttempts == 0) {
            return 0.0;
        }

        // Count passed attempts
        Long passedAttempts = quizResultRepository.countByQuizAndScoreGreaterThanEqual(quiz, quiz.getPassScore());

        return (passedAttempts.doubleValue() / totalAttempts.doubleValue()) * 100.0;
    }

    // ===== PRIVATE HELPER METHODS =====

    /**
     * Tính điểm cho quiz (Enhanced version)
     */
    private double calculateScore(Quiz quiz, Map<Long, String> answers) {
        if (answers == null || answers.isEmpty()) {
            return 0.0;
        }

        List<Question> questions = questionService.findByQuizOrderByDisplayOrder(quiz);
        if (questions.isEmpty()) {
            return 0.0;
        }

        double totalPoints = 0.0;
        double earnedPoints = 0.0;

        for (Question question : questions) {
            double questionPoints = question.getPoints() != null ? question.getPoints() : 1.0;
            totalPoints += questionPoints;

            String studentAnswer = answers.get(question.getId());
            if (studentAnswer != null && question.isCorrectAnswer(studentAnswer)) {
                earnedPoints += questionPoints;
            }
        }

        if (totalPoints == 0) {
            return 0.0;
        }

        // Tính điểm theo thang điểm maxScore của quiz
        return (earnedPoints / totalPoints) * quiz.getMaxScore();
    }

    /**
     * Convert answers map thành JSON string
     */
    private String convertAnswersToJson(Map<Long, String> answers) {
        // Simplified JSON conversion - trong thực tế nên dùng ObjectMapper
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
     * Validate quiz data (Enhanced version)
     */
    private void validateQuiz(Quiz quiz) {
        if (quiz == null) {
            throw new RuntimeException("Quiz không được để trống");
        }

        if (!StringUtils.hasText(quiz.getTitle())) {
            throw new RuntimeException("Tiêu đề quiz không được để trống");
        }

        if (quiz.getTitle().length() < 5) {
            throw new RuntimeException("Tiêu đề quiz phải có ít nhất 5 ký tự");
        }

        if (quiz.getTitle().length() > 200) {
            throw new RuntimeException("Tiêu đề quiz không được vượt quá 200 ký tự");
        }

        if (quiz.getCourse() == null) {
            throw new RuntimeException("Course không được để trống");
        }

        if (quiz.getDuration() != null && quiz.getDuration() <= 0) {
            throw new RuntimeException("Thời lượng quiz phải lớn hơn 0");
        }

        if (quiz.getMaxScore() != null && quiz.getMaxScore() <= 0) {
            throw new RuntimeException("Điểm tối đa phải lớn hơn 0");
        }

        if (quiz.getPassScore() != null && quiz.getPassScore() < 0) {
            throw new RuntimeException("Điểm đạt không được âm");
        }

        if (quiz.getPassScore() != null && quiz.getMaxScore() != null &&
                quiz.getPassScore() > quiz.getMaxScore()) {
            throw new RuntimeException("Điểm để pass không được lớn hơn điểm tối đa");
        }

        if (quiz.getAvailableFrom() != null && quiz.getAvailableUntil() != null &&
                quiz.getAvailableFrom().isAfter(quiz.getAvailableUntil())) {
            throw new RuntimeException("Thời gian bắt đầu không được sau thời gian kết thúc");
        }
    }
}