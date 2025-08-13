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
 * Quản lý CRUD operations, quiz attempts và grading system
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

    /**
     * Tìm quiz theo ID
     * @param id ID của quiz
     * @return Optional chứa Quiz nếu tìm thấy
     */
    public Optional<Quiz> findById(Long id) {
        return quizRepository.findById(id);
    }

    /**
     * Tìm quiz theo ID và course (cho security)
     * @param id ID quiz
     * @param course Course chứa quiz
     * @return Optional chứa Quiz nếu tìm thấy
     */
    public Optional<Quiz> findByIdAndCourse(Long id, Course course) {
        return quizRepository.findByIdAndCourse(id, course);
    }

    /**
     * Tìm tất cả quizzes của một course
     * @param course Course chứa quizzes
     * @return Danh sách quizzes
     */
    public List<Quiz> findByCourse(Course course) {
        return quizRepository.findByCourseOrderByCreatedAtDesc(course);
    }

    /**
     * Đếm số quizzes trong một course
     * @param course Course cần đếm
     * @return Số lượng quizzes
     */
    public Long countQuizzesByCourse(Course course) {
        return quizRepository.countByCourse(course);
    }

    /**
     * Tạo quiz mới
     * @param quiz Quiz cần tạo
     * @return Quiz đã được tạo
     */
    public Quiz createQuiz(Quiz quiz) {
        validateQuiz(quiz);

        // Set thời gian tạo
        quiz.setCreatedAt(LocalDateTime.now());
        quiz.setUpdatedAt(LocalDateTime.now());

        // Mặc định active = true
        quiz.setActive(true);

        // Mặc định không show correct answers
        if (quiz.isShowCorrectAnswers() == null) {
            quiz.setShowCorrectAnswers(false);
        }

        // Mặc định không shuffle
        if (quiz.isShuffleQuestions() == null) {
            quiz.setShuffleQuestions(false);
        }
        if (quiz.isShuffleAnswers() == null) {
            quiz.setShuffleAnswers(false);
        }

        return quizRepository.save(quiz);
    }

    /**
     * Cập nhật quiz
     * @param quiz Quiz cần cập nhật
     * @return Quiz đã được cập nhật
     */
    public Quiz updateQuiz(Quiz quiz) {
        if (quiz.getId() == null) {
            throw new RuntimeException("ID quiz không được để trống khi cập nhật");
        }

        Quiz existingQuiz = quizRepository.findById(quiz.getId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy quiz với ID: " + quiz.getId()));

        validateQuiz(quiz);

        // Giữ nguyên thời gian tạo
        quiz.setCreatedAt(existingQuiz.getCreatedAt());
        quiz.setUpdatedAt(LocalDateTime.now());

        return quizRepository.save(quiz);
    }

    /**
     * Soft delete quiz
     * @param quizId ID quiz cần xóa
     */
    public void softDeleteQuiz(Long quizId) {
        Quiz quiz = quizRepository.findById(quizId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy quiz"));

        quiz.setActive(false);
        quiz.setUpdatedAt(LocalDateTime.now());
        quizRepository.save(quiz);
    }

    /**
     * Hard delete quiz
     * @param quizId ID quiz cần xóa
     */
    public void deleteQuiz(Long quizId) {
        Quiz quiz = quizRepository.findById(quizId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy quiz"));

        // Kiểm tra xem có quiz results nào không
        Long resultCount = quizResultRepository.countByQuiz(quiz);
        if (resultCount > 0) {
            throw new RuntimeException("Không thể xóa quiz đã có " + resultCount +
                    " kết quả làm bài. Vui lòng ẩn quiz thay vì xóa.");
        }

        quizRepository.delete(quiz);
    }

    /**
     * Lấy questions của một quiz
     * @param quiz Quiz
     * @return Danh sách questions
     */
    public List<Question> findQuestionsByQuiz(Quiz quiz) {
        return questionService.findByQuizOrderByDisplayOrder(quiz);
    }

    /**
     * Lấy quiz results của một quiz
     * @param quiz Quiz
     * @return Danh sách quiz results
     */
    public List<QuizResult> findQuizResultsByQuiz(Quiz quiz) {
        return quizResultRepository.findByQuizOrderBySubmittedAtDesc(quiz);
    }

    /**
     * Submit quiz attempt
     * @param quiz Quiz
     * @param user User làm bài
     * @param answers Map chứa answers (questionId -> selectedOption)
     * @return QuizResult
     */
    public QuizResult submitQuizAttempt(Quiz quiz, User user, Map<Long, String> answers) {
        if (quiz == null || user == null || answers == null) {
            throw new RuntimeException("Thông tin submit quiz không hợp lệ");
        }

        // Kiểm tra quiz còn available không
        if (!isQuizAvailable(quiz)) {
            throw new RuntimeException("Quiz này hiện không khả dụng");
        }

        // Lấy tất cả questions của quiz
        List<Question> questions = findQuestionsByQuiz(quiz);
        if (questions.isEmpty()) {
            throw new RuntimeException("Quiz chưa có câu hỏi nào");
        }

        // Tính điểm
        double totalScore = 0;
        int correctAnswers = 0;
        double maxPossibleScore = 0;

        for (Question question : questions) {
            maxPossibleScore += question.getPoints();

            String userAnswer = answers.get(question.getId());
            if (userAnswer != null && userAnswer.equals(question.getCorrectOption())) {
                totalScore += question.getPoints();
                correctAnswers++;
            }
        }

        // Tạo QuizResult
        QuizResult result = new QuizResult();
        result.setQuiz(quiz);
        result.setUser(user);
        result.setScore(totalScore);
        result.setMaxScore(maxPossibleScore);
        result.setCorrectAnswers(correctAnswers);
        result.setTotalQuestions(questions.size());
        result.setStartedAt(LocalDateTime.now().minusMinutes(quiz.getDuration() != null ? quiz.getDuration() : 60));
        result.setSubmittedAt(LocalDateTime.now());
        result.setTimeTaken(quiz.getDuration() != null ? quiz.getDuration() : 60);
        result.setPassed(totalScore >= (quiz.getPassScore() != null ? quiz.getPassScore() : maxPossibleScore * 0.6));

        return quizResultRepository.save(result);
    }

    /**
     * Kiểm tra quiz có available không
     * @param quiz Quiz
     * @return true nếu available
     */
    public boolean isQuizAvailable(Quiz quiz) {
        if (!quiz.isActive()) {
            return false;
        }

        LocalDateTime now = LocalDateTime.now();

        // Kiểm tra available from
        if (quiz.getAvailableFrom() != null && now.isBefore(quiz.getAvailableFrom())) {
            return false;
        }

        // Kiểm tra available until
        if (quiz.getAvailableUntil() != null && now.isAfter(quiz.getAvailableUntil())) {
            return false;
        }

        return true;
    }

    /**
     * Lấy thống kê của quiz
     * @param quiz Quiz
     * @return QuizStats object
     */
    public QuizStats getQuizStatistics(Quiz quiz) {
        List<QuizResult> results = findQuizResultsByQuiz(quiz);

        if (results.isEmpty()) {
            return new QuizStats(quiz.getId(), 0L, 0L, 0.0, 0.0, 0.0, 0);
        }

        long totalAttempts = results.size();
        long passedAttempts = results.stream().mapToLong(r -> r.isPassed() ? 1 : 0).sum();
        double passRate = (double) passedAttempts / totalAttempts * 100;

        double averageScore = results.stream().mapToDouble(QuizResult::getScore).average().orElse(0.0);
        double maxScore = results.stream().mapToDouble(QuizResult::getScore).max().orElse(0.0);
        double minScore = results.stream().mapToDouble(QuizResult::getScore).min().orElse(0.0);

        int averageTime = (int) results.stream().mapToInt(QuizResult::getTimeTaken).average().orElse(0.0);

        return new QuizStats(quiz.getId(), totalAttempts, passedAttempts, passRate,
                averageScore, maxScore, minScore, averageTime);
    }

    /**
     * Lấy quiz results của một user
     * @param user User
     * @return Danh sách quiz results
     */
    public List<QuizResult> findQuizResultsByUser(User user) {
        return quizResultRepository.findByUserOrderBySubmittedAtDesc(user);
    }

    /**
     * Lấy quiz result của user cho một quiz cụ thể
     * @param quiz Quiz
     * @param user User
     * @return Optional chứa QuizResult nếu tìm thấy
     */
    public Optional<QuizResult> findQuizResultByQuizAndUser(Quiz quiz, User user) {
        return quizResultRepository.findByQuizAndUser(quiz, user);
    }

    /**
     * Kiểm tra user đã làm quiz chưa
     * @param quiz Quiz
     * @param user User
     * @return true nếu đã làm
     */
    public boolean hasUserTakenQuiz(Quiz quiz, User user) {
        return quizResultRepository.existsByQuizAndUser(quiz, user);
    }

    /**
     * Lấy best score của user cho một quiz
     * @param quiz Quiz
     * @param user User
     * @return Best score hoặc 0 nếu chưa làm
     */
    public double getBestScoreByQuizAndUser(Quiz quiz, User user) {
        return quizResultRepository.findBestScoreByQuizAndUser(quiz, user).orElse(0.0);
    }

    /**
     * Lấy quizzes của một instructor
     * @param instructor Instructor
     * @return Danh sách quizzes
     */
    public List<Quiz> findQuizzesByInstructor(User instructor) {
        return quizRepository.findByInstructorOrderByCreatedAtDesc(instructor);
    }

    /**
     * Lấy recent quiz results cho instructor
     * @param instructor Instructor
     * @param limit Số lượng cần lấy
     * @return Danh sách recent results
     */
    public List<QuizResult> findRecentQuizResultsByInstructor(User instructor, int limit) {
        Pageable pageable = PageRequest.of(0, limit, Sort.by("submittedAt").descending());
        return quizResultRepository.findByInstructorOrderBySubmittedAtDesc(instructor, pageable);
    }

    /**
     * Lấy top students trong một quiz
     * @param quiz Quiz
     * @param limit Số lượng cần lấy
     * @return Danh sách top students
     */
    public List<QuizResult> getTopStudentsByQuiz(Quiz quiz, int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return quizResultRepository.findByQuizOrderByScoreDesc(quiz, pageable);
    }

    /**
     * Regrade quiz (tính lại điểm cho tất cả attempts)
     * @param quizId ID quiz
     * @return Số lượng results đã được regrade
     */
    public int regradeQuiz(Long quizId) {
        Quiz quiz = quizRepository.findById(quizId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy quiz"));

        List<QuizResult> results = findQuizResultsByQuiz(quiz);
        if (results.isEmpty()) {
            return 0;
        }

        // Lấy questions hiện tại
        List<Question> questions = findQuestionsByQuiz(quiz);
        if (questions.isEmpty()) {
            return 0;
        }

        int regradedCount = 0;

        for (QuizResult result : results) {
            // Tính lại điểm dựa trên correct answers và points hiện tại
            double newScore = 0;
            double maxPossibleScore = questions.stream().mapToDouble(Question::getPoints).sum();

            // Giả sử ta có cách lưu user answers (cần implement)
            // Ở đây tạm thời tính dựa trên tỷ lệ correct answers
            double correctRatio = (double) result.getCorrectAnswers() / result.getTotalQuestions();
            newScore = correctRatio * maxPossibleScore;

            result.setScore(newScore);
            result.setMaxScore(maxPossibleScore);
            result.setPassed(newScore >= (quiz.getPassScore() != null ? quiz.getPassScore() : maxPossibleScore * 0.6));

            quizResultRepository.save(result);
            regradedCount++;
        }

        return regradedCount;
    }

    /**
     * Export quiz results to CSV format
     * @param quiz Quiz
     * @return CSV content as string
     */
    public String exportQuizResultsToCSV(Quiz quiz) {
        List<QuizResult> results = findQuizResultsByQuiz(quiz);

        StringBuilder csv = new StringBuilder();

        // Header
        csv.append("User,Email,Score,Max Score,Percentage,Correct Answers,Total Questions,Time Taken,Passed,Submitted At\n");

        // Data rows
        for (QuizResult result : results) {
            csv.append(String.format("%s,%s,%.2f,%.2f,%.1f%%,%d,%d,%d,%s,%s\n",
                    result.getUser().getFullName(),
                    result.getUser().getEmail(),
                    result.getScore(),
                    result.getMaxScore(),
                    (result.getScore() / result.getMaxScore()) * 100,
                    result.getCorrectAnswers(),
                    result.getTotalQuestions(),
                    result.getTimeTaken(),
                    result.isPassed() ? "Yes" : "No",
                    CourseUtils.DateTimeUtils.formatDateTime(result.getSubmittedAt())
            ));
        }

        return csv.toString();
    }

    // ===== PRIVATE HELPER METHODS =====

    /**
     * Validate thông tin quiz
     * @param quiz Quiz cần validate
     */
    private void validateQuiz(Quiz quiz) {
        if (quiz == null) {
            throw new RuntimeException("Thông tin quiz không được để trống");
        }

        // Validate title
        if (!StringUtils.hasText(quiz.getTitle())) {
            throw new RuntimeException("Tiêu đề quiz không được để trống");
        }
        if (quiz.getTitle().length() < 3) {
            throw new RuntimeException("Tiêu đề quiz phải có ít nhất 3 ký tự");
        }
        if (quiz.getTitle().length() > 200) {
            throw new RuntimeException("Tiêu đề quiz không được vượt quá 200 ký tự");
        }

        // Validate description
        if (StringUtils.hasText(quiz.getDescription()) && quiz.getDescription().length() > 1000) {
            throw new RuntimeException("Mô tả quiz không được vượt quá 1000 ký tự");
        }

        // Validate course
        if (quiz.getCourse() == null) {
            throw new RuntimeException("Quiz phải thuộc về một khóa học");
        }

        // Validate duration
        if (quiz.getDuration() != null && quiz.getDuration() <= 0) {
            throw new RuntimeException("Thời lượng quiz phải là số dương");
        }

        // Validate max score
        if (quiz.getMaxScore() != null && quiz.getMaxScore() <= 0) {
            throw new RuntimeException("Điểm tối đa phải là số dương");
        }

        // Validate pass score
        if (quiz.getPassScore() != null) {
            if (quiz.getPassScore() <= 0) {
                throw new RuntimeException("Điểm đạt phải là số dương");
            }
            if (quiz.getMaxScore() != null && quiz.getPassScore() > quiz.getMaxScore()) {
                throw new RuntimeException("Điểm đạt không được lớn hơn điểm tối đa");
            }
        }

        // Validate availability dates
        if (quiz.getAvailableFrom() != null && quiz.getAvailableUntil() != null) {
            if (quiz.getAvailableFrom().isAfter(quiz.getAvailableUntil())) {
                throw new RuntimeException("Thời gian bắt đầu không được sau thời gian kết thúc");
            }
        }
    }

    // ===== INNER CLASSES =====

    /**
     * Quiz statistics data class
     */
    public static class QuizStats {
        private final Long quizId;
        private final Long totalAttempts;
        private final Long passedAttempts;
        private final Double passRate;
        private final Double averageScore;
        private final Double maxScore;
        private final Double minScore;
        private final Integer averageTime;

        public QuizStats(Long quizId, Long totalAttempts, Long passedAttempts, Double passRate,
                         Double averageScore, Double maxScore, Double minScore, Integer averageTime) {
            this.quizId = quizId;
            this.totalAttempts = totalAttempts;
            this.passedAttempts = passedAttempts;
            this.passRate = passRate;
            this.averageScore = averageScore;
            this.maxScore = maxScore;
            this.minScore = minScore;
            this.averageTime = averageTime;
        }

        // Overloaded constructor for simpler stats
        public QuizStats(Long quizId, Long totalAttempts, Long passedAttempts, Double passRate,
                         Double averageScore, Double maxScore, Integer averageTime) {
            this(quizId, totalAttempts, passedAttempts, passRate, averageScore, maxScore, 0.0, averageTime);
        }

        // Getters
        public Long getQuizId() { return quizId; }
        public Long getTotalAttempts() { return totalAttempts; }
        public Long getPassedAttempts() { return passedAttempts; }
        public Double getPassRate() { return passRate; }
        public Double getAverageScore() { return averageScore; }
        public Double getMaxScore() { return maxScore; }
        public Double getMinScore() { return minScore; }
        public Integer getAverageTime() { return averageTime; }
    }
}