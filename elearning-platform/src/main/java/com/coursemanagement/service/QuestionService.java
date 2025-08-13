package com.coursemanagement.service;

import com.coursemanagement.entity.Question;
import com.coursemanagement.entity.Quiz;
import com.coursemanagement.repository.QuestionRepository;
import com.coursemanagement.utils.CourseUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Service class cho việc quản lý câu hỏi trong bài kiểm tra
 * Xử lý CRUD operations, validation và business logic cho Question entity
 */
@Service
@Transactional
public class QuestionService {

    @Autowired
    private QuestionRepository questionRepository;

    /**
     * Tìm tất cả câu hỏi của một quiz theo thứ tự display order
     * @param quiz Quiz cần tìm câu hỏi
     * @return Danh sách câu hỏi đã sắp xếp
     */
    public List<Question> findByQuizOrderByDisplayOrder(Quiz quiz) {
        if (quiz == null) {
            throw new RuntimeException("Quiz không hợp lệ");
        }
        return questionRepository.findByQuizOrderByDisplayOrder(quiz);
    }

    /**
     * Tìm câu hỏi theo ID và Quiz (để đảm bảo security)
     * @param id ID của câu hỏi
     * @param quiz Quiz chứa câu hỏi
     * @return Optional chứa câu hỏi nếu tìm thấy
     */
    public Optional<Question> findByIdAndQuiz(Long id, Quiz quiz) {
        if (id == null || quiz == null) {
            return Optional.empty();
        }
        return questionRepository.findByIdAndQuiz(id, quiz);
    }

    /**
     * Đếm số câu hỏi trong một quiz
     * @param quiz Quiz cần đếm
     * @return Số lượng câu hỏi
     */
    public long countByQuiz(Quiz quiz) {
        if (quiz == null) {
            return 0;
        }
        return questionRepository.countByQuiz(quiz);
    }

    /**
     * Tìm câu hỏi theo độ khó
     * @param quiz Quiz
     * @param difficultyLevel Độ khó
     * @return Danh sách câu hỏi theo độ khó
     */
    public List<Question> findByQuizAndDifficultyLevel(Quiz quiz, Question.DifficultyLevel difficultyLevel) {
        if (quiz == null || difficultyLevel == null) {
            return new ArrayList<>();
        }
        return questionRepository.findByQuizAndDifficultyLevel(quiz, difficultyLevel);
    }

    /**
     * Tìm câu hỏi theo đáp án đúng
     * @param quiz Quiz
     * @param correctOption Đáp án đúng (A, B, C, D)
     * @return Danh sách câu hỏi có đáp án đúng tương ứng
     */
    public List<Question> findByCorrectOption(Quiz quiz, String correctOption) {
        if (quiz == null || !StringUtils.hasText(correctOption)) {
            return new ArrayList<>();
        }
        return questionRepository.findByQuizAndCorrectOption(quiz, correctOption);
    }

    /**
     * Tạo câu hỏi mới với validation đầy đủ
     * @param question Câu hỏi cần tạo
     * @return Câu hỏi đã được tạo
     */
    public Question createQuestion(Question question) {
        // Validate dữ liệu đầu vào
        validateQuestion(question);

        // Set thời gian tạo
        question.setCreatedAt(LocalDateTime.now());
        question.setUpdatedAt(LocalDateTime.now());

        // Tự động set display order nếu chưa có
        if (question.getDisplayOrder() == null) {
            int nextOrder = getNextDisplayOrder(question.getQuiz());
            question.setDisplayOrder(nextOrder);
        }

        // Chuẩn hóa dữ liệu
        normalizeQuestionData(question);

        return questionRepository.save(question);
    }

    /**
     * Cập nhật câu hỏi
     * @param question Câu hỏi cần cập nhật
     * @return Câu hỏi đã được cập nhật
     */
    public Question updateQuestion(Question question) {
        if (question.getId() == null) {
            throw new RuntimeException("ID câu hỏi không được để trống khi cập nhật");
        }

        // Kiểm tra câu hỏi có tồn tại không
        Question existingQuestion = questionRepository.findById(question.getId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy câu hỏi với ID: " + question.getId()));

        // Validate dữ liệu
        validateQuestion(question);

        // Giữ lại thời gian tạo, cập nhật thời gian sửa
        question.setCreatedAt(existingQuestion.getCreatedAt());
        question.setUpdatedAt(LocalDateTime.now());

        // Chuẩn hóa dữ liệu
        normalizeQuestionData(question);

        return questionRepository.save(question);
    }

    /**
     * Xóa câu hỏi (với kiểm tra ràng buộc)
     * @param questionId ID câu hỏi cần xóa
     */
    public void deleteQuestion(Long questionId) {
        if (questionId == null) {
            throw new RuntimeException("ID câu hỏi không hợp lệ");
        }

        Question question = questionRepository.findById(questionId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy câu hỏi với ID: " + questionId));

        // Kiểm tra xem có kết quả bài thi nào liên quan không
        // (Có thể implement thêm logic kiểm tra ở đây)

        questionRepository.delete(question);

        // Cập nhật lại display order cho các câu hỏi còn lại
        reorderQuestions(question.getQuiz());
    }

    /**
     * Thay đổi thứ tự câu hỏi
     * @param questionId ID câu hỏi
     * @param newOrder Thứ tự mới
     */
    public void reorderQuestion(Long questionId, int newOrder) {
        Question question = questionRepository.findById(questionId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy câu hỏi"));

        if (newOrder < 1) {
            throw new RuntimeException("Thứ tự câu hỏi phải >= 1");
        }

        Quiz quiz = question.getQuiz();
        List<Question> allQuestions = findByQuizOrderByDisplayOrder(quiz);

        // Tính toán lại thứ tự cho tất cả câu hỏi
        allQuestions.remove(question);
        allQuestions.add(Math.min(newOrder - 1, allQuestions.size()), question);

        // Cập nhật display order
        for (int i = 0; i < allQuestions.size(); i++) {
            allQuestions.get(i).setDisplayOrder(i + 1);
            allQuestions.get(i).setUpdatedAt(LocalDateTime.now());
        }

        questionRepository.saveAll(allQuestions);
    }

    /**
     * Lấy thống kê phân bố đáp án cho quiz
     * @param quiz Quiz cần thống kê
     * @return Map chứa phân bố đáp án
     */
    public Map<String, Long> getAnswerDistribution(Quiz quiz) {
        if (quiz == null) {
            throw new RuntimeException("Quiz không hợp lệ");
        }

        Map<String, Long> distribution = new HashMap<>();
        distribution.put("A", (long) findByCorrectOption(quiz, "A").size());
        distribution.put("B", (long) findByCorrectOption(quiz, "B").size());
        distribution.put("C", (long) findByCorrectOption(quiz, "C").size());
        distribution.put("D", (long) findByCorrectOption(quiz, "D").size());

        return distribution;
    }

    /**
     * Lấy thống kê độ khó câu hỏi
     * @param quiz Quiz cần thống kê
     * @return Map chứa thống kê độ khó
     */
    public Map<String, Long> getDifficultyDistribution(Quiz quiz) {
        if (quiz == null) {
            throw new RuntimeException("Quiz không hợp lệ");
        }

        Map<String, Long> distribution = new HashMap<>();
        for (Question.DifficultyLevel level : Question.DifficultyLevel.values()) {
            long count = findByQuizAndDifficultyLevel(quiz, level).size();
            distribution.put(level.toString(), count);
        }

        return distribution;
    }

    /**
     * Import câu hỏi từ danh sách
     * @param quiz Quiz đích
     * @param questions Danh sách câu hỏi cần import
     * @return Số lượng câu hỏi đã import thành công
     */
    public int importQuestions(Quiz quiz, List<Question> questions) {
        if (quiz == null || questions == null || questions.isEmpty()) {
            throw new RuntimeException("Thông tin import không hợp lệ");
        }

        int successCount = 0;
        int startOrder = getNextDisplayOrder(quiz);

        for (int i = 0; i < questions.size(); i++) {
            try {
                Question question = questions.get(i);
                question.setQuiz(quiz);
                question.setDisplayOrder(startOrder + i);

                createQuestion(question);
                successCount++;

            } catch (Exception e) {
                // Log lỗi nhưng tiếp tục import câu hỏi khác
                System.err.println("Lỗi import câu hỏi thứ " + (i + 1) + ": " + e.getMessage());
            }
        }

        return successCount;
    }

    /**
     * Tạo câu hỏi mẫu cho quiz
     * @param quiz Quiz cần tạo câu hỏi mẫu
     * @param count Số lượng câu hỏi mẫu
     */
    public void createSampleQuestions(Quiz quiz, int count) {
        if (quiz == null || count <= 0) {
            throw new RuntimeException("Thông tin không hợp lệ");
        }

        for (int i = 1; i <= count; i++) {
            Question question = new Question();
            question.setQuiz(quiz);
            question.setQuestionText("Câu hỏi mẫu số " + i + " cho bài kiểm tra: " + quiz.getTitle());
            question.setOptionA("Đáp án A");
            question.setOptionB("Đáp án B");
            question.setOptionC("Đáp án C");
            question.setOptionD("Đáp án D");
            question.setCorrectOption("A");
            question.setExplanation("Giải thích cho câu hỏi mẫu số " + i);
            question.setPoints(1.0);
            question.setDifficultyLevel(Question.DifficultyLevel.EASY);
            question.setQuestionType(Question.QuestionType.MULTIPLE_CHOICE);

            createQuestion(question);
        }
    }

    /**
     * Nhân bản câu hỏi từ quiz khác
     * @param sourceQuiz Quiz nguồn
     * @param targetQuiz Quiz đích
     * @return Số lượng câu hỏi đã nhân bản
     */
    public int duplicateQuestionsFromQuiz(Quiz sourceQuiz, Quiz targetQuiz) {
        if (sourceQuiz == null || targetQuiz == null) {
            throw new RuntimeException("Quiz không hợp lệ");
        }

        List<Question> sourceQuestions = findByQuizOrderByDisplayOrder(sourceQuiz);
        int startOrder = getNextDisplayOrder(targetQuiz);
        int successCount = 0;

        for (int i = 0; i < sourceQuestions.size(); i++) {
            try {
                Question originalQuestion = sourceQuestions.get(i);
                Question newQuestion = new Question();

                // Copy tất cả thuộc tính trừ ID và Quiz
                newQuestion.setQuiz(targetQuiz);
                newQuestion.setQuestionText(originalQuestion.getQuestionText());
                newQuestion.setOptionA(originalQuestion.getOptionA());
                newQuestion.setOptionB(originalQuestion.getOptionB());
                newQuestion.setOptionC(originalQuestion.getOptionC());
                newQuestion.setOptionD(originalQuestion.getOptionD());
                newQuestion.setCorrectOption(originalQuestion.getCorrectOption());
                newQuestion.setExplanation(originalQuestion.getExplanation());
                newQuestion.setPoints(originalQuestion.getPoints());
                newQuestion.setDifficultyLevel(originalQuestion.getDifficultyLevel());
                newQuestion.setQuestionType(originalQuestion.getQuestionType());
                newQuestion.setTags(originalQuestion.getTags());
                newQuestion.setImageUrl(originalQuestion.getImageUrl());
                newQuestion.setDisplayOrder(startOrder + i);

                createQuestion(newQuestion);
                successCount++;

            } catch (Exception e) {
                System.err.println("Lỗi nhân bản câu hỏi: " + e.getMessage());
            }
        }

        return successCount;
    }

    /**
     * Validate thông tin câu hỏi một cách đầy đủ
     * @param question Câu hỏi cần validate
     * @throws RuntimeException Nếu validation fail
     */
    private void validateQuestion(Question question) {
        if (question == null) {
            throw new RuntimeException("Thông tin câu hỏi không được để trống");
        }

        // Validate quiz
        if (question.getQuiz() == null) {
            throw new RuntimeException("Câu hỏi phải thuộc về một bài kiểm tra");
        }

        // Validate question text
        if (!StringUtils.hasText(question.getQuestionText())) {
            throw new RuntimeException("Nội dung câu hỏi không được để trống");
        }

        if (question.getQuestionText().trim().length() < 10) {
            throw new RuntimeException("Nội dung câu hỏi phải có ít nhất 10 ký tự");
        }

        if (question.getQuestionText().trim().length() > 1000) {
            throw new RuntimeException("Nội dung câu hỏi không được vượt quá 1000 ký tự");
        }

        // Validate options cho multiple choice
        if (question.getQuestionType() == Question.QuestionType.MULTIPLE_CHOICE) {
            validateMultipleChoiceOptions(question);
        }

        // Validate points
        if (question.getPoints() == null || question.getPoints() <= 0) {
            throw new RuntimeException("Điểm số phải là số dương");
        }

        if (question.getPoints() > 10) {
            throw new RuntimeException("Điểm số không được vượt quá 10");
        }

        // Validate difficulty level
        if (question.getDifficultyLevel() == null) {
            question.setDifficultyLevel(Question.DifficultyLevel.MEDIUM); // Default value
        }

        // Validate question type
        if (question.getQuestionType() == null) {
            question.setQuestionType(Question.QuestionType.MULTIPLE_CHOICE); // Default value
        }

        // Validate display order
        if (question.getDisplayOrder() != null && question.getDisplayOrder() <= 0) {
            throw new RuntimeException("Thứ tự hiển thị phải là số dương");
        }
    }

    /**
     * Validate các lựa chọn cho câu hỏi trắc nghiệm
     */
    private void validateMultipleChoiceOptions(Question question) {
        // Validate options A, B, C, D
        if (!StringUtils.hasText(question.getOptionA())) {
            throw new RuntimeException("Đáp án A không được để trống");
        }
        if (!StringUtils.hasText(question.getOptionB())) {
            throw new RuntimeException("Đáp án B không được để trống");
        }
        if (!StringUtils.hasText(question.getOptionC())) {
            throw new RuntimeException("Đáp án C không được để trống");
        }
        if (!StringUtils.hasText(question.getOptionD())) {
            throw new RuntimeException("Đáp án D không được để trống");
        }

        // Validate correct option
        if (!StringUtils.hasText(question.getCorrectOption())) {
            throw new RuntimeException("Đáp án đúng không được để trống");
        }

        String correctOption = question.getCorrectOption().toUpperCase().trim();
        if (!Arrays.asList("A", "B", "C", "D").contains(correctOption)) {
            throw new RuntimeException("Đáp án đúng phải là A, B, C hoặc D");
        }

        question.setCorrectOption(correctOption); // Chuẩn hóa thành uppercase

        // Check độ dài các option
        if (question.getOptionA().length() > 500) {
            throw new RuntimeException("Đáp án A quá dài (tối đa 500 ký tự)");
        }
        if (question.getOptionB().length() > 500) {
            throw new RuntimeException("Đáp án B quá dài (tối đa 500 ký tự)");
        }
        if (question.getOptionC().length() > 500) {
            throw new RuntimeException("Đáp án C quá dài (tối đa 500 ký tự)");
        }
        if (question.getOptionD().length() > 500) {
            throw new RuntimeException("Đáp án D quá dài (tối đa 500 ký tự)");
        }
    }

    /**
     * Chuẩn hóa dữ liệu câu hỏi
     */
    private void normalizeQuestionData(Question question) {
        // Trim tất cả text fields
        if (question.getQuestionText() != null) {
            question.setQuestionText(question.getQuestionText().trim());
        }

        if (question.getOptionA() != null) {
            question.setOptionA(question.getOptionA().trim());
        }

        if (question.getOptionB() != null) {
            question.setOptionB(question.getOptionB().trim());
        }

        if (question.getOptionC() != null) {
            question.setOptionC(question.getOptionC().trim());
        }

        if (question.getOptionD() != null) {
            question.setOptionD(question.getOptionD().trim());
        }

        if (question.getCorrectOption() != null) {
            question.setCorrectOption(question.getCorrectOption().toUpperCase().trim());
        }

        if (question.getExplanation() != null) {
            question.setExplanation(question.getExplanation().trim());
        }

        if (question.getTags() != null) {
            question.setTags(question.getTags().trim().toLowerCase());
        }
    }

    /**
     * Lấy display order tiếp theo cho quiz
     */
    private int getNextDisplayOrder(Quiz quiz) {
        List<Question> existingQuestions = findByQuizOrderByDisplayOrder(quiz);
        if (existingQuestions.isEmpty()) {
            return 1;
        }

        return existingQuestions.get(existingQuestions.size() - 1).getDisplayOrder() + 1;
    }

    /**
     * Sắp xếp lại thứ tự câu hỏi sau khi xóa
     */
    private void reorderQuestions(Quiz quiz) {
        List<Question> questions = findByQuizOrderByDisplayOrder(quiz);

        for (int i = 0; i < questions.size(); i++) {
            questions.get(i).setDisplayOrder(i + 1);
            questions.get(i).setUpdatedAt(LocalDateTime.now());
        }

        questionRepository.saveAll(questions);
    }

    /**
     * Tìm kiếm câu hỏi theo từ khóa
     * @param quiz Quiz cần tìm
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách câu hỏi phù hợp
     */
    public List<Question> searchQuestions(Quiz quiz, String keyword) {
        if (quiz == null || !StringUtils.hasText(keyword)) {
            return findByQuizOrderByDisplayOrder(quiz);
        }

        return questionRepository.findByQuizAndQuestionTextContainingIgnoreCase(quiz, keyword.trim());
    }

    /**
     * Lấy câu hỏi ngẫu nhiên từ quiz
     * @param quiz Quiz
     * @param count Số lượng câu hỏi cần lấy
     * @return Danh sách câu hỏi ngẫu nhiên
     */
    public List<Question> getRandomQuestions(Quiz quiz, int count) {
        if (quiz == null || count <= 0) {
            return new ArrayList<>();
        }

        List<Question> allQuestions = findByQuizOrderByDisplayOrder(quiz);

        if (allQuestions.size() <= count) {
            return allQuestions;
        }

        Collections.shuffle(allQuestions);
        return allQuestions.subList(0, count);
    }
}