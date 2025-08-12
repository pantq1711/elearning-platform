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
     * Xóa bài kiểm tra
     * @param id ID của bài kiểm tra cần xóa
     * @throws RuntimeException Nếu không tìm thấy bài kiểm tra
     */
    public void deleteQuiz(Long id) {
        Quiz quiz = quizRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy bài kiểm tra với ID: " + id));

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
     * Tìm bài kiểm tra theo ID và khóa học (để đảm bảo quyền truy cập)
     * @param id ID của bài kiểm tra
     * @param course Khóa học
     * @return Optional<Quiz>
     */
    public Optional<Quiz> findByIdAndCourse(Long id, Course course) {
        return quizRepository.findByIdAndCourse(id, course);
    }

    /**
     * Lấy tất cả bài kiểm tra của khóa học
     * @param course Khóa học
     * @return Danh sách bài kiểm tra sắp xếp theo ngày tạo
     */
    public List<Quiz> findQuizzesByCourse(Course course) {
        return quizRepository.findByCourseOrderByCreatedAt(course);
    }

    /**
     * Lấy tất cả bài kiểm tra đang hoạt động của khóa học
     * @param course Khóa học
     * @return Danh sách bài kiểm tra đang hoạt động
     */
    public List<Quiz> findActiveQuizzesByCourse(Course course) {
        return quizRepository.findByCourseAndIsActiveOrderByCreatedAt(course, true);
    }

    /**
     * Lấy bài kiểm tra có thể làm được (đang hoạt động và có câu hỏi)
     * @param course Khóa học
     * @return Danh sách bài kiểm tra có thể làm
     */
    public List<Quiz> findAvailableQuizzesByCourse(Course course) {
        return quizRepository.findAvailableQuizzesByCourse(course);
    }

    /**
     * Lấy bài kiểm tra chưa có câu hỏi
     * @param course Khóa học
     * @return Danh sách bài kiểm tra chưa có câu hỏi
     */
    public List<Quiz> findQuizzesWithoutQuestions(Course course) {
        return quizRepository.findQuizzesWithoutQuestions(course);
    }

    /**
     * Tìm kiếm bài kiểm tra theo tiêu đề
     * @param course Khóa học
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách bài kiểm tra chứa từ khóa
     */
    public List<Quiz> searchQuizzesByTitle(Course course, String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return quizRepository.findByCourseOrderByCreatedAt(course);
        }
        return quizRepository.findByCourseAndTitleContaining(course, keyword.trim());
    }

    /**
     * Đếm số bài kiểm tra trong khóa học
     * @param course Khóa học
     * @return Số lượng bài kiểm tra
     */
    public long countQuizzesByCourse(Course course) {
        return quizRepository.countByCourse(course);
    }

    /**
     * Đếm số bài kiểm tra đang hoạt động trong khóa học
     * @param course Khóa học
     * @return Số lượng bài kiểm tra đang hoạt động
     */
    public long countActiveQuizzesByCourse(Course course) {
        return quizRepository.countByCourseAndIsActive(course, true);
    }

    /**
     * Thêm câu hỏi vào bài kiểm tra
     * @param quiz Bài kiểm tra
     * @param question Câu hỏi cần thêm
     * @return Question đã được tạo
     */
    public Question addQuestionToQuiz(Quiz quiz, Question question) {
        // Validate câu hỏi
        validateQuestion(question);

        // Set quiz cho câu hỏi
        question.setQuiz(quiz);

        return questionRepository.save(question);
    }

    /**
     * Cập nhật câu hỏi
     * @param questionId ID câu hỏi
     * @param updatedQuestion Thông tin câu hỏi mới
     * @return Question đã được cập nhật
     */
    public Question updateQuestion(Long questionId, Question updatedQuestion) {
        Question existingQuestion = questionRepository.findById(questionId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy câu hỏi với ID: " + questionId));

        // Validate câu hỏi mới
        validateQuestion(updatedQuestion);

        // Cập nhật thông tin
        existingQuestion.setQuestionText(updatedQuestion.getQuestionText());
        existingQuestion.setOptionA(updatedQuestion.getOptionA());
        existingQuestion.setOptionB(updatedQuestion.getOptionB());
        existingQuestion.setOptionC(updatedQuestion.getOptionC());
        existingQuestion.setOptionD(updatedQuestion.getOptionD());
        existingQuestion.setCorrectOption(updatedQuestion.getCorrectOption());
        existingQuestion.setExplanation(updatedQuestion.getExplanation());

        return questionRepository.save(existingQuestion);
    }

    /**
     * Xóa câu hỏi
     * @param questionId ID câu hỏi cần xóa
     */
    public void deleteQuestion(Long questionId) {
        Question question = questionRepository.findById(questionId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy câu hỏi với ID: " + questionId));

        questionRepository.delete(question);
    }

    /**
     * Lấy tất cả câu hỏi của bài kiểm tra
     * @param quiz Bài kiểm tra
     * @return Danh sách câu hỏi
     */
    public List<Question> findQuestionsByQuiz(Quiz quiz) {
        return questionRepository.findByQuizOrderById(quiz);
    }

    /**
     * Bắt đầu làm bài kiểm tra
     * @param quiz Bài kiểm tra
     * @param student Học viên
     * @return QuizResult đã được tạo
     * @throws RuntimeException Nếu có lỗi validation
     */
    public QuizResult startQuiz(Quiz quiz, User student) {
        // Kiểm tra học viên đã làm bài này chưa
        if (quizResultRepository.existsByStudentAndQuiz(student, quiz)) {
            throw new RuntimeException("Bạn đã làm bài kiểm tra này rồi");
        }

        // Kiểm tra học viên đã đăng ký khóa học chưa
        if (!enrollmentService.isStudentEnrolled(student, quiz.getCourse())) {
            throw new RuntimeException("Bạn chưa đăng ký khóa học này");
        }

        // Kiểm tra bài kiểm tra có thể làm được không
        if (!quiz.canStart()) {
            throw new RuntimeException("Bài kiểm tra hiện tại không khả dụng");
        }

        // Tạo quiz result mới
        QuizResult quizResult = new QuizResult(quiz, student);
        return quizResultRepository.save(quizResult);
    }

    /**
     * Nộp bài kiểm tra
     * @param quizResultId ID kết quả bài kiểm tra
     * @param answers Map chứa câu trả lời (questionId -> selectedOption)
     * @return QuizResult đã được cập nhật
     */
    public QuizResult submitQuiz(Long quizResultId, Map<Long, String> answers) {
        QuizResult quizResult = quizResultRepository.findById(quizResultId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy kết quả bài kiểm tra"));

        // Kiểm tra đã nộp bài chưa
        if (quizResult.isCompleted()) {
            throw new RuntimeException("Bài kiểm tra đã được nộp rồi");
        }

        // Lấy tất cả câu hỏi của bài kiểm tra
        List<Question> questions = questionRepository.findByQuizOrderById(quizResult.getQuiz());

        // Tính điểm
        int correctAnswers = 0;
        for (Question question : questions) {
            String selectedOption = answers.get(question.getId());
            if (question.isCorrectAnswer(selectedOption)) {
                correctAnswers++;
            }
        }

        // Hoàn thành bài kiểm tra
        quizResult.complete(correctAnswers);
        quizResultRepository.save(quizResult);

        // Cập nhật điểm cao nhất trong enrollment
        enrollmentService.updateHighestScore(
                quizResult.getStudent(),
                quizResult.getQuiz().getCourse(),
                quizResult.getScore()
        );

        return quizResult;
    }

    /**
     * Lấy kết quả bài kiểm tra của học viên
     * @param quiz Bài kiểm tra
     * @param student Học viên
     * @return Optional<QuizResult>
     */
    public Optional<QuizResult> findQuizResult(Quiz quiz, User student) {
        return quizResultRepository.findByStudentAndQuiz(student, quiz);
    }

    /**
     * Lấy tất cả kết quả của bài kiểm tra
     * @param quiz Bài kiểm tra
     * @return Danh sách kết quả sắp xếp theo điểm cao nhất
     */
    public List<QuizResult> findQuizResultsByQuiz(Quiz quiz) {
        return quizResultRepository.findByQuizOrderByScoreDesc(quiz);
    }

    /**
     * Lấy tất cả kết quả của học viên
     * @param student Học viên
     * @return Danh sách kết quả sắp xếp theo ngày làm bài
     */
    public List<QuizResult> findQuizResultsByStudent(User student) {
        return quizResultRepository.findByStudentOrderBySubmittedAtDesc(student);
    }

    /**
     * Kiểm tra học viên đã làm bài kiểm tra chưa
     * @param quiz Bài kiểm tra
     * @param student Học viên
     * @return true nếu đã làm, false nếu chưa làm
     */
    public boolean hasStudentTakenQuiz(Quiz quiz, User student) {
        return quizResultRepository.existsByStudentAndQuiz(student, quiz);
    }

    /**
     * Lấy bài kiểm tra học viên chưa làm trong khóa học
     * @param course Khóa học
     * @param studentId ID học viên
     * @return Danh sách bài kiểm tra chưa làm
     */
    public List<Quiz> findAvailableQuizzesForStudent(Course course, Long studentId) {
        return quizRepository.findAvailableQuizzesForStudent(course, studentId);
    }

    /**
     * Lấy bài kiểm tra học viên đã làm trong khóa học
     * @param course Khóa học
     * @param studentId ID học viên
     * @return Danh sách bài kiểm tra đã làm
     */
    public List<Quiz> findCompletedQuizzesForStudent(Course course, Long studentId) {
        return quizRepository.findCompletedQuizzesForStudent(course, studentId);
    }

    /**
     * Lấy thống kê bài kiểm tra
     * @param quiz Bài kiểm tra
     * @return Object chứa thông tin thống kê
     */
    public QuizStats getQuizStatistics(Quiz quiz) {
        long attemptCount = quizResultRepository.countByQuiz(quiz);
        long passCount = quizResultRepository.countByQuizAndIsPassed(quiz, true);
        Double averageScore = quizResultRepository.findAverageScoreByQuiz(quiz);
        Double passRate = quizResultRepository.getPassRateByQuiz(quiz);

        return new QuizStats(attemptCount, passCount, averageScore, passRate);
    }

    /**
     * Kích hoạt/vô hiệu hóa bài kiểm tra
     * @param quizId ID của bài kiểm tra
     * @param isActive Trạng thái kích hoạt
     */
    public void toggleQuizStatus(Long quizId, boolean isActive) {
        Quiz quiz = quizRepository.findById(quizId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy bài kiểm tra"));

        quiz.setActive(isActive);
        quizRepository.save(quiz);
    }

    /**
     * Validate thông tin bài kiểm tra
     * @param quiz Bài kiểm tra cần validate
     * @throws RuntimeException Nếu có lỗi validation
     */
    private void validateQuiz(Quiz quiz) {
        // Kiểm tra tiêu đề
        if (quiz.getTitle() == null || quiz.getTitle().trim().isEmpty()) {
            throw new RuntimeException("Tiêu đề bài kiểm tra không được để trống");
        }

        if (quiz.getTitle().trim().length() < 5) {
            throw new RuntimeException("Tiêu đề bài kiểm tra phải có ít nhất 5 ký tự");
        }

        if (quiz.getTitle().trim().length() > 200) {
            throw new RuntimeException("Tiêu đề bài kiểm tra không được vượt quá 200 ký tự");
        }

        // Kiểm tra thời gian làm bài
        if (quiz.getDuration() == null || quiz.getDuration() < 1) {
            throw new RuntimeException("Thời gian làm bài phải ít nhất 1 phút");
        }

        if (quiz.getDuration() > 300) { // 5 giờ
            throw new RuntimeException("Thời gian làm bài không được vượt quá 300 phút");
        }

        // Kiểm tra điểm tối đa
        if (quiz.getMaxScore() == null || quiz.getMaxScore() <= 0) {
            throw new RuntimeException("Điểm tối đa phải lớn hơn 0");
        }

        // Kiểm tra điểm pass
        if (quiz.getPassScore() == null || quiz.getPassScore() < 0) {
            throw new RuntimeException("Điểm pass phải lớn hơn hoặc bằng 0");
        }

        if (quiz.getPassScore() > quiz.getMaxScore()) {
            throw new RuntimeException("Điểm pass không được lớn hơn điểm tối đa");
        }

        // Kiểm tra khóa học
        if (quiz.getCourse() == null) {
            throw new RuntimeException("Bài kiểm tra phải thuộc về một khóa học");
        }

        // Trim các trường text
        quiz.setTitle(quiz.getTitle().trim());
        if (quiz.getDescription() != null) {
            quiz.setDescription(quiz.getDescription().trim());
        }
    }

    /**
     * Validate thông tin câu hỏi
     * @param question Câu hỏi cần validate
     * @throws RuntimeException Nếu có lỗi validation
     */
    private void validateQuestion(Question question) {
        // Kiểm tra nội dung câu hỏi
        if (question.getQuestionText() == null || question.getQuestionText().trim().isEmpty()) {
            throw new RuntimeException("Nội dung câu hỏi không được để trống");
        }

        // Kiểm tra các đáp án
        if (question.getOptionA() == null || question.getOptionA().trim().isEmpty()) {
            throw new RuntimeException("Đáp án A không được để trống");
        }

        if (question.getOptionB() == null || question.getOptionB().trim().isEmpty()) {
            throw new RuntimeException("Đáp án B không được để trống");
        }

        if (question.getOptionC() == null || question.getOptionC().trim().isEmpty()) {
            throw new RuntimeException("Đáp án C không được để trống");
        }

        if (question.getOptionD() == null || question.getOptionD().trim().isEmpty()) {
            throw new RuntimeException("Đáp án D không được để trống");
        }

        // Kiểm tra đáp án đúng
        if (!Question.isValidCorrectOption(question.getCorrectOption())) {
            throw new RuntimeException("Đáp án đúng phải là A, B, C hoặc D");
        }

        // Trim các trường text
        question.setQuestionText(question.getQuestionText().trim());
        question.setOptionA(question.getOptionA().trim());
        question.setOptionB(question.getOptionB().trim());
        question.setOptionC(question.getOptionC().trim());
        question.setOptionD(question.getOptionD().trim());
        question.setCorrectOption(question.getCorrectOption().toUpperCase());

        if (question.getExplanation() != null) {
            question.setExplanation(question.getExplanation().trim());
        }
    }

    /**
     * Class để lưu thống kê bài kiểm tra
     */
    public static class QuizStats {
        private final long attemptCount;
        private final long passCount;
        private final Double averageScore;
        private final Double passRate;

        public QuizStats(long attemptCount, long passCount, Double averageScore, Double passRate) {
            this.attemptCount = attemptCount;
            this.passCount = passCount;
            this.averageScore = averageScore != null ? averageScore : 0.0;
            this.passRate = passRate != null ? passRate : 0.0;
        }

        public long getAttemptCount() { return attemptCount; }
        public long getPassCount() { return passCount; }
        public Double getAverageScore() { return averageScore; }
        public Double getPassRate() { return passRate; }
        public long getFailCount() { return attemptCount - passCount; }
    }
}