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
     * Tìm tất cả quizzes của course
     * @param course Course
     * @return Danh sách quizzes
     */
    public List<Quiz> findByCourse(Course course) {
        return quizRepository.findByCourseOrderByCreatedAtDesc(course);
    }

    /**
     * Tìm active quizzes của course
     * @param course Course
     * @return Danh sách active quizzes
     */
    public List<Quiz> findActiveByCourse(Course course) {
        return quizRepository.findByCourseAndActiveOrderByCreatedAtDesc(course, true);
    }

    /**
     * Đếm active quizzes của course
     * @param course Course
     * @return Số lượng active quizzes
     */
    public Long countActiveQuizzesByCourse(Course course) {
        return quizRepository.countByCourseAndActive(course, true);
    }

    /**
     * Tìm available quizzes cho student (chưa làm hoặc chưa pass)
     * @param student Student
     * @return Danh sách available quizzes
     */
    public List<Quiz> findAvailableQuizzesForStudent(User student) {
        return quizRepository.findAvailableQuizzesForStudent(student.getId());
    }

    /**
     * Tìm completed quizzes cho student (đã pass)
     * @param student Student
     * @return Danh sách completed quizzes
     */
    public List<Quiz> findCompletedQuizzesForStudent(User student) {
        return quizRepository.findCompletedQuizzesForStudent(student.getId());
    }

    /**
     * Tìm quiz results của student
     * @param student Student
     * @return Danh sách quiz results
     */
    public List<QuizResult> findQuizResultsByStudent(User student) {
        return quizResultRepository.findByStudentOrderByAttemptDateDesc(student);
    }

    /**
     * Kiểm tra student đã làm quiz chưa
     * @param student Student
     * @param quiz Quiz
     * @return true nếu đã làm
     */
    public boolean hasStudentTakenQuiz(User student, Quiz quiz) {
        return quizResultRepository.existsByStudentAndQuiz(student, quiz);
    }

    /**
     * Bắt đầu làm quiz
     * @param student Student
     * @param quiz Quiz
     * @return QuizResult đã tạo
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
     * Tìm quiz result
     * @param student Student
     * @param quiz Quiz
     * @return Optional chứa QuizResult
     */
    public Optional<QuizResult> findQuizResult(User student, Quiz quiz) {
        return quizResultRepository.findByStudentAndQuiz(student, quiz);
    }

    /**
     * Submit quiz
     * @param student Student
     * @param quiz Quiz
     * @param answers Map chứa câu trả lời (questionId -> answer)
     * @return QuizResult đã được chấm điểm
     */
    public QuizResult submitQuiz(User student, Quiz quiz, Map<Long, String> answers) {
        // Tìm hoặc tạo quiz result
        QuizResult quizResult = quizResultRepository.findByStudentAndQuiz(student, quiz)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy quiz attempt"));

        if (quizResult.isCompleted()) {
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
        quizResult.setAnswers(convertAnswersToJson(answers));

        return quizResultRepository.save(quizResult);
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

        // Mặc định là active
        quiz.setActive(true);

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

        // Cập nhật thông tin
        existingQuiz.setTitle(quiz.getTitle());
        existingQuiz.setDescription(quiz.getDescription());
        existingQuiz.setDuration(quiz.getDuration());
        existingQuiz.setMaxScore(quiz.getMaxScore());
        existingQuiz.setPassScore(quiz.getPassScore());
        existingQuiz.setActive(quiz.isActive());
        existingQuiz.setUpdatedAt(LocalDateTime.now());

        return quizRepository.save(existingQuiz);
    }

    /**
     * Xóa quiz (soft delete)
     * @param quizId ID của quiz
     */
    public void deleteQuiz(Long quizId) {
        Quiz quiz = quizRepository.findById(quizId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy quiz với ID: " + quizId));

        quiz.setActive(false);
        quiz.setUpdatedAt(LocalDateTime.now());
        quizRepository.save(quiz);
    }

    /**
     * Lấy thống kê quiz của course
     * @param course Course
     * @return Map chứa thống kê
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
     * Tính điểm quiz
     * @param quiz Quiz
     * @param answers Câu trả lời của student
     * @return Điểm số
     */
    private double calculateScore(Quiz quiz, Map<Long, String> answers) {
        List<Question> questions = questionService.findByQuizOrderByDisplayOrder(quiz);

        if (questions.isEmpty()) {
            return 0.0;
        }

        int correctCount = 0;
        for (Question question : questions) {
            String studentAnswer = answers.get(question.getId());
            if (studentAnswer != null && studentAnswer.equals(question.getCorrectOption())) {
                correctCount++;
            }
        }

        return (double) correctCount / questions.size() * quiz.getMaxScore();
    }

    /**
     * Convert answers map thành JSON string
     * @param answers Map câu trả lời
     * @return JSON string
     */
    private String convertAnswersToJson(Map<Long, String> answers) {
        // Simple JSON conversion (nên dùng Jackson trong thực tế)
        StringBuilder json = new StringBuilder("{");
        for (Map.Entry<Long, String> entry : answers.entrySet()) {
            if (json.length() > 1) {
                json.append(",");
            }
            json.append("\"").append(entry.getKey()).append("\":\"").append(entry.getValue()).append("\"");
        }
        json.append("}");
        return json.toString();
    }

    /**
     * Validation cho quiz
     * @param quiz Quiz cần validate
     */
    private void validateQuiz(Quiz quiz) {
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

        if (quiz.getDuration() == null || quiz.getDuration() <= 0) {
            throw new RuntimeException("Thời gian làm bài phải lớn hơn 0");
        }

        if (quiz.getMaxScore() == null || quiz.getMaxScore() <= 0) {
            throw new RuntimeException("Điểm tối đa phải lớn hơn 0");
        }

        if (quiz.getPassScore() == null || quiz.getPassScore() < 0) {
            throw new RuntimeException("Điểm đạt không được âm");
        }

        if (quiz.getPassScore() > quiz.getMaxScore()) {
            throw new RuntimeException("Điểm đạt không được lớn hơn điểm tối đa");
        }
    }
}