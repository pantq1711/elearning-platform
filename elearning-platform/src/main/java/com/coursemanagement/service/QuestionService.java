package com.coursemanagement.service;

import com.coursemanagement.entity.Question;
import com.coursemanagement.entity.Quiz;
import com.coursemanagement.entity.User;
import com.coursemanagement.repository.QuestionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * Service class để xử lý business logic liên quan đến Question
 */
@Service
@Transactional
public class QuestionService {

    @Autowired
    private QuestionRepository questionRepository;

    /**
     * Tạo câu hỏi mới
     * @param question Câu hỏi cần tạo
     * @return Question đã được tạo
     * @throws RuntimeException Nếu có lỗi validation
     */
    public Question createQuestion(Question question) {
        validateQuestion(question);
        return questionRepository.save(question);
    }

    /**
     * Cập nhật câu hỏi
     * @param id ID câu hỏi
     * @param updatedQuestion Thông tin câu hỏi mới
     * @return Question đã được cập nhật
     * @throws RuntimeException Nếu không tìm thấy câu hỏi hoặc có lỗi validation
     */
    public Question updateQuestion(Long id, Question updatedQuestion) {
        Question existingQuestion = questionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy câu hỏi với ID: " + id));

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
     * @param id ID câu hỏi cần xóa
     * @throws RuntimeException Nếu không tìm thấy câu hỏi
     */
    public void deleteQuestion(Long id) {
        Question question = questionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy câu hỏi với ID: " + id));
        questionRepository.delete(question);
    }

    /**
     * Tìm câu hỏi theo ID
     * @param id ID câu hỏi
     * @return Optional<Question>
     */
    public Optional<Question> findById(Long id) {
        return questionRepository.findById(id);
    }

    /**
     * Tìm câu hỏi theo quiz
     * @param quiz Quiz
     * @return Danh sách câu hỏi trong quiz
     */
    public List<Question> findByQuiz(Quiz quiz) {
        if (quiz == null) {
            throw new RuntimeException("Quiz không hợp lệ");
        }
        return questionRepository.findByQuizOrderById(quiz);
    }

    /**
     * Tìm câu hỏi theo ID và quiz (để đảm bảo quyền truy cập)
     * @param id ID câu hỏi
     * @param quiz Quiz
     * @return Optional<Question>
     */
    public Optional<Question> findByIdAndQuiz(Long id, Quiz quiz) {
        if (quiz == null) {
            return Optional.empty();
        }
        return questionRepository.findByIdAndQuiz(id, quiz);
    }

    /**
     * Tìm kiếm câu hỏi theo từ khóa
     * @param quiz Quiz
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách câu hỏi chứa từ khóa
     */
    public List<Question> searchQuestions(Quiz quiz, String keyword) {
        if (quiz == null) {
            throw new RuntimeException("Quiz không hợp lệ");
        }

        if (keyword == null || keyword.trim().isEmpty()) {
            return findByQuiz(quiz);
        }

        return questionRepository.findByQuizAndQuestionTextContaining(quiz, keyword.trim());
    }

    /**
     * Đếm số câu hỏi trong quiz
     * @param quiz Quiz
     * @return Số lượng câu hỏi
     */
    public long countByQuiz(Quiz quiz) {
        if (quiz == null) {
            return 0;
        }
        return questionRepository.countByQuiz(quiz);
    }

    /**
     * Tìm câu hỏi theo đáp án đúng
     * @param quiz Quiz
     * @param correctOption Đáp án đúng (A, B, C, D)
     * @return Danh sách câu hỏi có đáp án đúng đó
     */
    public List<Question> findByCorrectOption(Quiz quiz, String correctOption) {
        if (quiz == null) {
            throw new RuntimeException("Quiz không hợp lệ");
        }

        if (correctOption == null || !correctOption.matches("^[ABCD]$")) {
            throw new RuntimeException("Đáp án phải là A, B, C hoặc D");
        }

        return questionRepository.findByQuizAndCorrectOption(quiz, correctOption);
    }

    /**
     * Kiểm tra giảng viên có quyền chỉnh sửa câu hỏi không
     * @param question Câu hỏi
     * @param instructor Giảng viên
     * @return true nếu có quyền, false nếu không có quyền
     */
    public boolean canInstructorEditQuestion(Question question, User instructor) {
        if (question == null || instructor == null) {
            return false;
        }

        // Kiểm tra vai trò giảng viên
        if (instructor.getRole() != User.Role.INSTRUCTOR) {
            return false;
        }

        // Kiểm tra giảng viên có phải là chủ sở hữu quiz không
        return question.getQuiz().getCourse().getInstructor().getId().equals(instructor.getId());
    }

    /**
     * Sao chép câu hỏi
     * @param sourceQuestion Câu hỏi nguồn
     * @param targetQuiz Quiz đích
     * @return Question đã được sao chép
     */
    public Question copyQuestion(Question sourceQuestion, Quiz targetQuiz) {
        if (sourceQuestion == null || targetQuiz == null) {
            throw new RuntimeException("Thông tin sao chép không hợp lệ");
        }

        Question copiedQuestion = new Question();
        copiedQuestion.setQuestionText(sourceQuestion.getQuestionText());
        copiedQuestion.setOptionA(sourceQuestion.getOptionA());
        copiedQuestion.setOptionB(sourceQuestion.getOptionB());
        copiedQuestion.setOptionC(sourceQuestion.getOptionC());
        copiedQuestion.setOptionD(sourceQuestion.getOptionD());
        copiedQuestion.setCorrectOption(sourceQuestion.getCorrectOption());
        copiedQuestion.setExplanation(sourceQuestion.getExplanation());
        copiedQuestion.setQuiz(targetQuiz);

        return createQuestion(copiedQuestion);
    }

    /**
     * Thống kê câu hỏi theo đáp án đúng
     * @param quiz Quiz
     * @return Map<CorrectOption, Count>
     */
    public java.util.Map<String, Long> getAnswerDistribution(Quiz quiz) {
        if (quiz == null) {
            throw new RuntimeException("Quiz không hợp lệ");
        }

        java.util.Map<String, Long> distribution = new java.util.HashMap<>();
        distribution.put("A", (long) findByCorrectOption(quiz, "A").size());
        distribution.put("B", (long) findByCorrectOption(quiz, "B").size());
        distribution.put("C", (long) findByCorrectOption(quiz, "C").size());
        distribution.put("D", (long) findByCorrectOption(quiz, "D").size());

        return distribution;
    }

    /**
     * Import câu hỏi từ danh sách
     * @param quiz Quiz
     * @param questions Danh sách câu hỏi cần import
     * @return Số lượng câu hỏi đã import thành công
     */
    public int importQuestions(Quiz quiz, List<Question> questions) {
        if (quiz == null || questions == null || questions.isEmpty()) {
            throw new RuntimeException("Thông tin import không hợp lệ");
        }

        int successCount = 0;

        for (Question question : questions) {
            try {
                question.setQuiz(quiz);
                createQuestion(question);
                successCount++;
            } catch (Exception e) {
                // Log lỗi nhưng tiếp tục import câu hỏi khác
                System.err.println("Lỗi import câu hỏi: " + e.getMessage());
            }
        }

        return successCount;
    }

    /**
     * Validate thông tin câu hỏi
     * @param question Câu hỏi cần validate
     * @throws RuntimeException Nếu validation fail
     */
    private void validateQuestion(Question question) {
        if (question == null) {
            throw new RuntimeException("Thông tin câu hỏi không được để trống");
        }

        if (question.getQuestionText() == null || question.getQuestionText().trim().isEmpty()) {
            throw new RuntimeException("Nội dung câu hỏi không được để trống");
        }

        if (question.getQuestionText().trim().length() < 10) {
            throw new RuntimeException("Nội dung câu hỏi phải có ít nhất 10 ký tự");
        }

        if (question.getQuestionText().trim().length() > 1000) {
            throw new RuntimeException("Nội dung câu hỏi không được vượt quá 1000 ký tự");
        }

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

        // Validate độ dài các đáp án
        validateOption("A", question.getOptionA());
        validateOption("B", question.getOptionB());
        validateOption("C", question.getOptionC());
        validateOption("D", question.getOptionD());

        if (question.getCorrectOption() == null ||
                !question.getCorrectOption().matches("^[ABCD]$")) {
            throw new RuntimeException("Đáp án đúng phải là A, B, C hoặc D");
        }

        if (question.getQuiz() == null) {
            throw new RuntimeException("Câu hỏi phải thuộc về một bài kiểm tra");
        }

        // Validate explanation nếu có
        if (question.getExplanation() != null && !question.getExplanation().trim().isEmpty()) {
            if (question.getExplanation().trim().length() > 500) {
                throw new RuntimeException("Giải thích không được vượt quá 500 ký tự");
            }
        }
    }

    /**
     * Validate một đáp án
     * @param optionName Tên đáp án (A, B, C, D)
     * @param optionText Nội dung đáp án
     */
    private void validateOption(String optionName, String optionText) {
        if (optionText.trim().length() < 1) {
            throw new RuntimeException("Đáp án " + optionName + " phải có ít nhất 1 ký tự");
        }

        if (optionText.trim().length() > 200) {
            throw new RuntimeException("Đáp án " + optionName + " không được vượt quá 200 ký tự");
        }
    }
}