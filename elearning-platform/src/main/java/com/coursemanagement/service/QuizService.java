package com.coursemanagement.service;

import com.coursemanagement.entity.*;
import com.coursemanagement.repository.QuizRepository;
import com.coursemanagement.repository.QuestionRepository;
import com.coursemanagement.repository.QuizResultRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.Map;

/**
 * Service class để xử lý business logic liên quan đến Quiz
 */
@Service
@Transactional
public class QuizService {

    @Autowired
    private QuizRepository quizRepository;

    @Autowired
    private QuestionRepository questionRepository;

    @Autowired
    private QuizResultRepository quizResultRepository;

    @Autowired
    private EnrollmentService enrollmentService;

    /**
     * Tạo bài kiểm tra mới
     * @param quiz Bài kiểm tra cần tạo
     * @return Quiz đã được tạo
     * @throws RuntimeException Nếu có lỗi validation
     */
    public Quiz createQuiz(Quiz quiz) {
        // Validate thông tin bài kiểm tra
        validateQuiz(quiz);

        // Đảm bảo bài kiểm tra được kích hoạt
        quiz.setActive(true);

        return quizRepository.save(quiz);
    }

    /**
     * Cập nhật thông tin bài kiểm tra
     * @param id ID của bài kiểm tra cần cập nhật
     * @param updatedQuiz Thông tin bài kiểm tra mới
     * @return Quiz đã được cập nhật
     * @throws RuntimeException Nếu không tìm thấy bài kiểm tra hoặc có lỗi validation
     */
    public Quiz updateQuiz(Long id, Quiz updatedQuiz) {
        // Tìm bài kiểm tra hiện tại
        Quiz existingQuiz = quizRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy bài kiểm tra với ID: " + id));

        // Validate thông tin bài kiểm tra mới
        validateQuiz(updatedQuiz);

        // Cập nhật thông tin
        existingQuiz.setTitle(updatedQuiz.getTitle());
        existingQuiz.setDescription(updatedQuiz.getDescription());
        existingQuiz.setDuration(updatedQuiz.getDuration());
        existingQuiz.setMaxScore(updatedQuiz.getMaxScore());
        existingQuiz.setPassScore(updatedQuiz.getPassScore());
        existingQuiz.setActive(updatedQuiz.isActive());

        return quizRepository.save(existingQuiz);
    }

    /**
     * Xóa bài kiểm tra (chỉ khi chưa có học viên làm bài)
     * @param id ID của bài kiểm tra cần xóa
     * @throws RuntimeException Nếu không tìm thấy bài kiểm tra hoặc không thể xóa
     */
    public void deleteQuiz(Long id) {
        Quiz quiz = quizRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy bài kiểm tra với ID: " + id));

        // Kiểm tra có học viên đã làm bài không
        long resultCount = quizResultRepository.countByQuiz(quiz);
        if (resultCount > 0) {
            throw new RuntimeException("Không thể xóa bài kiểm tra đã có học viên làm bài");
        }

        quizRepository.delete(quiz);
    }

    /**
     * Tìm bài kiểm tra theo ID
     * @param id ID của bài kiểm tra
     * @return Optional<Quiz>
     */
    public Optional<Quiz> findById(Long id) {
        return quizRepository.findById(id);
    }

    /**
     * Tìm bài kiểm tra theo khóa học
     * @param course Khóa học
     * @return Danh sách bài kiểm tra trong khóa học
     */
    public List<Quiz> findByCourse(Course course) {
        if (course == null) {
            throw new RuntimeException("Khóa học không hợp lệ");
        }
        return quizRepository.findByCourseOrderByCreatedAt(course);
    }

    /**
     * Tìm bài kiểm tra đang hoạt động theo khóa học
     * @param course Khóa học
     * @return Danh sách bài kiểm tra đang hoạt động
     */
    public List<Quiz> findActiveByCourse(Course course) {
        if (course == null) {
            throw new RuntimeException("Khóa học không hợp lệ");
        }
        return quizRepository.findByCourseAndIsActiveOrderByCreatedAt(course, true);
    }

    /**
     * Tìm bài kiểm tra theo ID và khóa học (để đảm bảo quyền truy cập)
     * @param id ID của bài kiểm tra
     * @param course Khóa học
     * @return Optional<Quiz>
     */
    public Optional<Quiz> findByIdAndCourse(Long id, Course course) {
        if (course == null) {
            return Optional.empty();
        }
        return quizRepository.findByIdAndCourse(id, course);
    }

    /**
     * Tìm kiếm bài kiểm tra theo từ khóa
     * @param course Khóa học
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách bài kiểm tra chứa từ khóa
     */
    public List<Quiz> searchQuizzes(Course course, String keyword) {
        if (course == null) {
            throw new RuntimeException("Khóa học không hợp lệ");
        }

        if (keyword == null || keyword.trim().isEmpty()) {
            return findByCourse(course);
        }

        return quizRepository.findByCourseAndTitleContainingIgnoreCase(course, keyword.trim());
    }

    /**
     * Kiểm tra học viên có thể làm bài kiểm tra không
     * @param quiz Bài kiểm tra
     * @param student Học viên
     * @return true nếu có thể làm bài, false nếu không thể
     */
    public boolean canStudentTakeQuiz(Quiz quiz, User student) {
        if (quiz == null || student == null) {
            return false;
        }

        // Kiểm tra vai trò học viên
        if (student.getRole() != User.Role.STUDENT) {
            return false;
        }

        // Kiểm tra bài kiểm tra có đang hoạt động không
        if (!quiz.isActive()) {
            return false;
        }

        // Kiểm tra học viên có đăng ký khóa học không
        if (!enrollmentService.isStudentEnrolled(student, quiz.getCourse())) {
            return false;
        }

        // Kiểm tra đã làm bài chưa (chỉ được làm 1 lần)
        Optional<QuizResult> existingResult = quizResultRepository.findByStudentAndQuiz(student, quiz);
        return existingResult.isEmpty();
    }

    /**
     * Nộp bài kiểm tra và tính điểm
     * @param quiz Bài kiểm tra
     * @param student Học viên
     * @param answers Map<QuestionId, SelectedOption> - đáp án đã chọn
     * @return QuizResult với điểm số và kết quả
     */
    public QuizResult submitQuiz(Quiz quiz, User student, Map<Long, String> answers) {
        // Validate đầu vào
        if (!canStudentTakeQuiz(quiz, student)) {
            throw new RuntimeException("Bạn không thể làm bài kiểm tra này");
        }

        if (answers == null || answers.isEmpty()) {
            throw new RuntimeException("Phải trả lời ít nhất một câu hỏi");
        }

        // Lấy tất cả câu hỏi của bài kiểm tra
        List<Question> questions = questionRepository.findByQuizOrderById(quiz);
        if (questions.isEmpty()) {
            throw new RuntimeException("Bài kiểm tra chưa có câu hỏi nào");
        }

        // Tính điểm
        int correctAnswers = 0;
        int totalQuestions = questions.size();

        for (Question question : questions) {
            String selectedAnswer = answers.get(question.getId());
            if (selectedAnswer != null && selectedAnswer.equals(question.getCorrectOption())) {
                correctAnswers++;
            }
        }

        // Tính điểm số theo thang 100
        double score = (double) correctAnswers / totalQuestions * quiz.getMaxScore();
        boolean isPassed = score >= quiz.getPassScore();

        // Tạo QuizResult
        QuizResult result = new QuizResult(student, quiz, score, correctAnswers, totalQuestions, isPassed);
        result = quizResultRepository.save(result);

        // Cập nhật điểm cao nhất cho enrollment
        Optional<Enrollment> enrollmentOpt = enrollmentService.findByStudentAndCourse(student, quiz.getCourse());
        if (enrollmentOpt.isPresent()) {
            enrollmentService.updateHighestScore(enrollmentOpt.get().getId(), score);
        }

        return result;
    }

    /**
     * Lấy kết quả bài kiểm tra của học viên
     * @param quiz Bài kiểm tra
     * @param student Học viên
     * @return Optional<QuizResult>
     */
    public Optional<QuizResult> getQuizResult(Quiz quiz, User student) {
        if (quiz == null || student == null) {
            return Optional.empty();
        }
        return quizResultRepository.findByStudentAndQuiz(student, quiz);
    }

    /**
     * Lấy tất cả kết quả của bài kiểm tra
     * @param quiz Bài kiểm tra
     * @return Danh sách kết quả sắp xếp theo điểm cao nhất
     */
    public List<QuizResult> getAllQuizResults(Quiz quiz) {
        if (quiz == null) {
            throw new RuntimeException("Bài kiểm tra không hợp lệ");
        }
        return quizResultRepository.findByQuizOrderByScoreDesc(quiz);
    }

    /**
     * Lấy kết quả đạt của bài kiểm tra
     * @param quiz Bài kiểm tra
     * @return Danh sách kết quả đạt
     */
    public List<QuizResult> getPassedResults(Quiz quiz) {
        if (quiz == null) {
            throw new RuntimeException("Bài kiểm tra không hợp lệ");
        }
        return quizResultRepository.findByQuizAndIsPassed(quiz, true);
    }

    /**
     * Đếm số học viên đã làm bài
     * @param quiz Bài kiểm tra
     * @return Số lượng học viên đã làm bài
     */
    public long countStudentsTaken(Quiz quiz) {
        if (quiz == null) {
            return 0;
        }
        return quizResultRepository.countByQuiz(quiz);
    }

    /**
     * Đếm số học viên đạt bài kiểm tra
     * @param quiz Bài kiểm tra
     * @return Số lượng học viên đạt
     */
    public long countStudentsPassed(Quiz quiz) {
        if (quiz == null) {
            return 0;
        }
        return quizResultRepository.countByQuizAndIsPassed(quiz, true);
    }

    /**
     * Tính tỷ lệ đạt của bài kiểm tra
     * @param quiz Bài kiểm tra
     * @return Tỷ lệ đạt (0-100%)
     */
    public double getPassRate(Quiz quiz) {
        long totalTaken = countStudentsTaken(quiz);
        if (totalTaken == 0) {
            return 0.0;
        }

        long totalPassed = countStudentsPassed(quiz);
        return (double) totalPassed / totalTaken * 100.0;
    }

    /**
     * Tính điểm trung bình của bài kiểm tra
     * @param quiz Bài kiểm tra
     * @return Điểm trung bình
     */
    public double getAverageScore(Quiz quiz) {
        List<QuizResult> results = getAllQuizResults(quiz);
        if (results.isEmpty()) {
            return 0.0;
        }

        return results.stream()
                .mapToDouble(QuizResult::getScore)
                .average()
                .orElse(0.0);
    }

    /**
     * Validate thông tin bài kiểm tra
     * @param quiz Bài kiểm tra cần validate
     * @throws RuntimeException Nếu validation fail
     */
    private void validateQuiz(Quiz quiz) {
        if (quiz == null) {
            throw new RuntimeException("Thông tin bài kiểm tra không được để trống");
        }

        if (quiz.getTitle() == null || quiz.getTitle().trim().isEmpty()) {
            throw new RuntimeException("Tiêu đề bài kiểm tra không được để trống");
        }

        if (quiz.getTitle().trim().length() < 5) {
            throw new RuntimeException("Tiêu đề bài kiểm tra phải có ít nhất 5 ký tự");
        }

        if (quiz.getTitle().trim().length() > 200) {
            throw new RuntimeException("Tiêu đề bài kiểm tra không được vượt quá 200 ký tự");
        }

        if (quiz.getDuration() == null || quiz.getDuration() < 1) {
            throw new RuntimeException("Thời gian làm bài phải ít nhất 1 phút");
        }

        if (quiz.getDuration() > 300) { // Tối đa 5 giờ
            throw new RuntimeException("Thời gian làm bài không được vượt quá 300 phút");
        }

        if (quiz.getMaxScore() == null || quiz.getMaxScore() <= 0) {
            throw new RuntimeException("Điểm tối đa phải lớn hơn 0");
        }

        if (quiz.getMaxScore() > 1000) {
            throw new RuntimeException("Điểm tối đa không được vượt quá 1000");
        }

        if (quiz.getPassScore() == null || quiz.getPassScore() < 0) {
            throw new RuntimeException("Điểm đạt không được nhỏ hơn 0");
        }

        if (quiz.getPassScore() > quiz.getMaxScore()) {
            throw new RuntimeException("Điểm đạt không được lớn hơn điểm tối đa");
        }

        if (quiz.getCourse() == null) {
            throw new RuntimeException("Bài kiểm tra phải thuộc về một khóa học");
        }
    }
}