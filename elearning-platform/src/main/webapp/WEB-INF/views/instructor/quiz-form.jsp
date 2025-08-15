<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${quiz.id != null ? 'Chỉnh Sửa' : 'Tạo Mới'} Quiz - EduLearn Platform</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- TinyMCE CSS -->
    <link href="https://cdn.tiny.cloud/1/no-api-key/tinymce/6/tinymce.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/instructor.css"" rel="stylesheet">

    <style>
        .question-card {
            border: 1px solid #dee2e6;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            transition: all 0.3s ease;
        }
        .question-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .question-header {
            background: #f8f9fa;
            border-radius: 12px 12px 0 0;
            padding: 1rem;
            border-bottom: 1px solid #dee2e6;
        }
        .answer-option {
            border: 1px solid #e9ecef;
            border-radius: 8px;
            margin-bottom: 0.5rem;
            padding: 0.75rem;
            transition: all 0.3s ease;
        }
        .answer-option:hover {
            border-color: #0d6efd;
            background-color: #f8f9fa;
        }
        .answer-option.correct {
            border-color: #198754;
            background-color: #d1eddb;
        }
        .quiz-type-card {
            border: 2px solid transparent;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .quiz-type-card:hover {
            border-color: #0d6efd;
            box-shadow: 0 4px 12px rgba(13, 110, 253, 0.15);
        }
        .quiz-type-card.active {
            border-color: #0d6efd;
            background-color: #e7f3ff;
        }
        .question-type-selector {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 0.5rem;
        }
        .sortable-ghost {
            opacity: 0.5;
        }
        .drag-handle {
            cursor: move;
        }
    </style>
</head>

<body>
<!-- Include Header -->
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <!-- Include Sidebar -->
        <div class="col-md-3 col-lg-2">
            <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
        </div>

        <!-- Main Content -->
        <div class="col-md-9 col-lg-10">
            <div class="main-content p-4">

                <!-- Page Header -->
                <div class="page-header mb-4">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/instructor/dashboard"">
                                    <i class="fas fa-home"></i> Dashboard
                                </a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/instructor/quizzes"">Quiz</a>
                            </li>
                            <li class="breadcrumb-item active">
                                ${quiz.id != null ? 'Chỉnh sửa' : 'Tạo mới'}
                            </li>
                        </ol>
                    </nav>
                    <h1 class="h3 mb-0">
                        <i class="fas fa-${quiz.id != null ? 'edit' : 'plus-circle'} text-warning me-2"></i>
                        ${quiz.id != null ? 'Chỉnh Sửa' : 'Tạo Mới'} Quiz
                    </h1>
                    <p class="text-muted mb-0">
                        ${quiz.id != null ? 'Cập nhật thông tin và câu hỏi quiz' : 'Tạo quiz mới với câu hỏi tương tác'}
                    </p>
                </div>

                <!-- Thông báo lỗi -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Form Tạo/Sửa Quiz -->
                <form:form method="POST" modelAttribute="quiz"
                           action="${quiz.id != null ? '/instructor/quizzes/'.concat(quiz.id).concat('/edit') : '/instructor/quizzes/create'}"
                           cssClass="needs-validation" novalidate="true">

                    <!-- Hidden fields -->
                    <form:hidden path="id" />

                    <div class="row">
                        <!-- Left Column - Main Content -->
                        <div class="col-lg-8">

                            <!-- Quiz Type Selection -->
                            <c:if test="${quiz.id == null}">
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">
                                            <i class="fas fa-layer-group me-2"></i>Loại Quiz
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row g-3">
                                            <div class="col-md-4">
                                                <div class="quiz-type-card card h-100 ${quiz.type == 'PRACTICE' ? 'active' : ''}"
                                                     onclick="selectQuizType('PRACTICE')">
                                                    <div class="card-body text-center">
                                                        <i class="fas fa-dumbbell fa-3x text-info mb-3"></i>
                                                        <h6>Luyện Tập</h6>
                                                        <p class="text-muted small mb-0">Cho phép làm nhiều lần, không giới hạn thời gian</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="quiz-type-card card h-100 ${quiz.type == 'EXAM' ? 'active' : ''}"
                                                     onclick="selectQuizType('EXAM')">
                                                    <div class="card-body text-center">
                                                        <i class="fas fa-graduation-cap fa-3x text-warning mb-3"></i>
                                                        <h6>Kiểm Tra</h6>
                                                        <p class="text-muted small mb-0">Giới hạn thời gian, chỉ làm một lần</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="quiz-type-card card h-100 ${quiz.type == 'SURVEY' ? 'active' : ''}"
                                                     onclick="selectQuizType('SURVEY')">
                                                    <div class="card-body text-center">
                                                        <i class="fas fa-poll fa-3x text-success mb-3"></i>
                                                        <h6>Khảo Sát</h6>
                                                        <p class="text-muted small mb-0">Thu thập ý kiến, không có đáp án đúng/sai</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <form:hidden path="type" id="quizType" />
                                    </div>
                                </div>
                            </c:if>

                            <!-- Basic Information -->
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-info-circle me-2"></i>Thông Tin Cơ Bản
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="row g-3">
                                        <!-- Tên quiz -->
                                        <div class="col-12">
                                            <label for="title" class="form-label">
                                                Tên quiz <span class="text-danger">*</span>
                                            </label>
                                            <form:input path="title" cssClass="form-control"
                                                        placeholder="Nhập tên quiz..." required="true" />
                                            <form:errors path="title" cssClass="text-danger small" />
                                        </div>

                                        <!-- Mô tả -->
                                        <div class="col-12">
                                            <label for="description" class="form-label">Mô tả</label>
                                            <form:textarea path="description" cssClass="form-control" rows="3"
                                                           placeholder="Mô tả ngắn gọn về nội dung quiz..." />
                                            <form:errors path="description" cssClass="text-danger small" />
                                        </div>

                                        <!-- Khóa học -->
                                        <div class="col-md-6">
                                            <label for="course" class="form-label">
                                                Khóa học <span class="text-danger">*</span>
                                            </label>
                                            <form:select path="course.id" cssClass="form-select" required="true">
                                                <form:option value="">Chọn khóa học...</form:option>
                                                <form:options items="${courses}" itemValue="id" itemLabel="name" />
                                            </form:select>
                                            <form:errors path="course" cssClass="text-danger small" />
                                        </div>

                                        <!-- Độ khó -->
                                        <div class="col-md-6">
                                            <label for="difficultyLevel" class="form-label">Độ khó</label>
                                            <form:select path="difficultyLevel" cssClass="form-select">
                                                <form:option value="EASY">Dễ</form:option>
                                                <form:option value="MEDIUM">Trung bình</form:option>
                                                <form:option value="HARD">Khó</form:option>
                                            </form:select>
                                            <form:errors path="difficultyLevel" cssClass="text-danger small" />
                                        </div>

                                        <!-- Điểm tối đa -->
                                        <div class="col-md-4">
                                            <label for="maxScore" class="form-label">Điểm tối đa</label>
                                            <form:input path="maxScore" type="number" cssClass="form-control"
                                                        min="1" step="1" placeholder="100" />
                                            <form:errors path="maxScore" cssClass="text-danger small" />
                                        </div>

                                        <!-- Điểm đậu -->
                                        <div class="col-md-4">
                                            <label for="passingScore" class="form-label">Điểm đậu</label>
                                            <form:input path="passingScore" type="number" cssClass="form-control"
                                                        min="0" step="1" placeholder="60" />
                                            <form:errors path="passingScore" cssClass="text-danger small" />
                                        </div>

                                        <!-- Thời gian (phút) -->
                                        <div class="col-md-4">
                                            <label for="timeLimit" class="form-label">Thời gian (phút)</label>
                                            <div class="input-group">
                                                <form:input path="timeLimit" type="number" cssClass="form-control"
                                                            min="0" step="1" placeholder="0" />
                                                <span class="input-group-text">phút</span>
                                            </div>
                                            <small class="text-muted">Để trống = không giới hạn</small>
                                            <form:errors path="timeLimit" cssClass="text-danger small" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Questions Section -->
                            <div class="card mb-4">
                                <div class="card-header">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <h5 class="card-title mb-0">
                                            <i class="fas fa-question-circle me-2"></i>Câu Hỏi
                                            <span class="badge bg-warning ms-2" id="questionCount">
                                                    ${fn:length(quiz.questions)}
                                            </span>
                                        </h5>
                                        <button type="button" class="btn btn-primary" onclick="addQuestion()">
                                            <i class="fas fa-plus me-2"></i>Thêm Câu Hỏi
                                        </button>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <!-- Questions List -->
                                    <div id="questionsList">
                                        <c:choose>
                                            <c:when test="${not empty quiz.questions}">
                                                <c:forEach items="${quiz.questions}" var="question" varStatus="status">
                                                    <!-- Question template sẽ được tạo bằng JavaScript -->
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="text-center py-4" id="emptyQuestionsState">
                                                    <i class="fas fa-question-circle text-muted mb-3" style="font-size: 3rem;"></i>
                                                    <h6 class="text-muted">Chưa có câu hỏi nào</h6>
                                                    <p class="text-muted mb-3">Nhấn "Thêm Câu Hỏi" để bắt đầu tạo quiz</p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                        </div>

                        <!-- Right Column - Settings -->
                        <div class="col-lg-4">

                            <!-- Publish Settings -->
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">
                                        <i class="fas fa-cog me-2"></i>Cài Đặt Quiz
                                    </h6>
                                </div>
                                <div class="card-body">
                                    <!-- Trạng thái hoạt động -->
                                    <div class="mb-3">
                                        <div class="form-check form-switch">
                                            <form:checkbox path="active" cssClass="form-check-input" />
                                            <label class="form-check-label" for="active">
                                                Kích hoạt quiz
                                            </label>
                                        </div>
                                        <small class="text-muted">
                                            Cho phép học viên làm quiz này
                                        </small>
                                    </div>

                                    <!-- Số lần làm bài -->
                                    <div class="mb-3">
                                        <label for="maxAttempts" class="form-label">Số lần làm tối đa</label>
                                        <form:input path="maxAttempts" type="number" cssClass="form-control"
                                                    min="1" step="1" placeholder="1" />
                                        <small class="text-muted">
                                            Số lần học viên được phép làm quiz
                                        </small>
                                        <form:errors path="maxAttempts" cssClass="text-danger small" />
                                    </div>

                                    <!-- Xáo trộn câu hỏi -->
                                    <div class="mb-3">
                                        <div class="form-check form-switch">
                                            <form:checkbox path="shuffleQuestions" cssClass="form-check-input" />
                                            <label class="form-check-label" for="shuffleQuestions">
                                                Xáo trộn câu hỏi
                                            </label>
                                        </div>
                                        <small class="text-muted">
                                            Hiển thị câu hỏi theo thứ tự ngẫu nhiên
                                        </small>
                                    </div>

                                    <!-- Xáo trộn đáp án -->
                                    <div class="mb-3">
                                        <div class="form-check form-switch">
                                            <form:checkbox path="shuffleAnswers" cssClass="form-check-input" />
                                            <label class="form-check-label" for="shuffleAnswers">
                                                Xáo trộn đáp án
                                            </label>
                                        </div>
                                        <small class="text-muted">
                                            Hiển thị đáp án theo thứ tự ngẫu nhiên
                                        </small>
                                    </div>

                                    <!-- Hiển thị kết quả ngay -->
                                    <div class="mb-3">
                                        <div class="form-check form-switch">
                                            <form:checkbox path="showResultsImmediately" cssClass="form-check-input" />
                                            <label class="form-check-label" for="showResultsImmediately">
                                                Hiển thị kết quả ngay
                                            </label>
                                        </div>
                                        <small class="text-muted">
                                            Học viên xem kết quả ngay sau khi nộp
                                        </small>
                                    </div>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="card">
                                <div class="card-body">
                                    <div class="d-grid gap-2">
                                        <!-- Save Button -->
                                        <button type="submit" class="btn btn-warning">
                                            <i class="fas fa-save me-2"></i>
                                                ${quiz.id != null ? 'Cập nhật quiz' : 'Tạo quiz'}
                                        </button>

                                        <!-- Save & Preview -->
                                        <button type="submit" name="saveAndPreview" value="true"
                                                class="btn btn-outline-warning">
                                            <i class="fas fa-eye me-2"></i>
                                            Lưu và xem trước
                                        </button>

                                        <!-- Cancel Button -->
                                        <a href="${pageContext.request.contextPath}/instructor/quizzes""
                                           class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-2"></i>
                                            Hủy
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <!-- Help Tips -->
                            <div class="card mt-4">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">
                                        <i class="fas fa-lightbulb me-2"></i>Gợi Ý
                                    </h6>
                                </div>
                                <div class="card-body">
                                    <div class="small text-muted">
                                        <div class="mb-2">
                                            <i class="fas fa-check-circle text-success me-1"></i>
                                            <strong>Tên quiz:</strong> Nên rõ ràng, dễ hiểu
                                        </div>
                                        <div class="mb-2">
                                            <i class="fas fa-check-circle text-success me-1"></i>
                                            <strong>Câu hỏi:</strong> Ít nhất 5 câu cho một quiz
                                        </div>
                                        <div class="mb-2">
                                            <i class="fas fa-check-circle text-success me-1"></i>
                                            <strong>Thời gian:</strong> Tính khoảng 1-2 phút/câu
                                        </div>
                                        <div>
                                            <i class="fas fa-check-circle text-success me-1"></i>
                                            <strong>Điểm đậu:</strong> Thường là 60-80% tổng điểm
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                </form:form>

            </div>
        </div>
    </div>
</div>

<!-- Question Modal -->
<div class="modal fade" id="questionModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-question-circle me-2"></i>
                    <span id="questionModalTitle">Thêm Câu Hỏi</span>
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="questionForm">
                    <input type="hidden" id="questionIndex" value="">

                    <!-- Question Text -->
                    <div class="mb-3">
                        <label for="questionText" class="form-label">
                            Câu hỏi <span class="text-danger">*</span>
                        </label>
                        <textarea id="questionText" class="form-control" rows="3"
                                  placeholder="Nhập nội dung câu hỏi..." required></textarea>
                    </div>

                    <!-- Question Type -->
                    <div class="mb-3">
                        <label class="form-label">Loại câu hỏi</label>
                        <div class="question-type-selector">
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="questionType"
                                       id="multipleChoice" value="MULTIPLE_CHOICE" checked>
                                <label class="form-check-label" for="multipleChoice">
                                    Trắc nghiệm
                                </label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="questionType"
                                       id="trueFalse" value="TRUE_FALSE">
                                <label class="form-check-label" for="trueFalse">
                                    Đúng/Sai
                                </label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="questionType"
                                       id="shortAnswer" value="SHORT_ANSWER">
                                <label class="form-check-label" for="shortAnswer">
                                    Tự luận ngắn
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- Answers Section -->
                    <div id="answersSection">
                        <!-- Sẽ được tạo bằng JavaScript -->
                    </div>

                    <!-- Question Score -->
                    <div class="mb-3">
                        <label for="questionScore" class="form-label">Điểm</label>
                        <input type="number" id="questionScore" class="form-control"
                               min="1" step="1" value="1" required>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-primary" onclick="saveQuestion()">
                    <i class="fas fa-save me-2"></i>Lưu câu hỏi
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Include Footer -->
<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.tiny.cloud/1/no-api-key/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>
<script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>

<script>
    let questions = [];
    let currentQuestionIndex = -1;

    $(document).ready(function() {
        // Khởi tạo quiz type nếu đã có
        const currentType = '${quiz.type}' || 'PRACTICE';
        if (currentType) {
            selectQuizType(currentType);
        }

        // Khởi tạo Sortable cho questions list
        const questionsList = document.getElementById('questionsList');
        if (questionsList) {
            new Sortable(questionsList, {
                animation: 150,
                handle: '.drag-handle',
                onEnd: function(evt) {
                    updateQuestionOrder();
                }
            });
        }

        // Load existing questions nếu có
        loadExistingQuestions();

        // Setup form validation
        setupFormValidation();
    });

    /**
     * Chọn loại quiz
     */
    function selectQuizType(type) {
        // Cập nhật UI
        $('.quiz-type-card').removeClass('active');
        $(`.quiz-type-card:has(h6:contains('${type === 'PRACTICE' ? 'Luyện Tập' : type === 'EXAM' ? 'Kiểm Tra' : 'Khảo Sát'}'))`).addClass('active');

        // Cập nhật hidden input
        $('#quizType').val(type);
    }

    /**
     * Thêm câu hỏi mới
     */
    function addQuestion() {
        currentQuestionIndex = -1;
        $('#questionModalTitle').text('Thêm Câu Hỏi');
        $('#questionForm')[0].reset();
        $('input[name="questionType"][value="MULTIPLE_CHOICE"]').prop('checked', true);
        generateAnswersSection('MULTIPLE_CHOICE');
        $('#questionModal').modal('show');
    }

    /**
     * Chỉnh sửa câu hỏi
     */
    function editQuestion(index) {
        currentQuestionIndex = index;
        const question = questions[index];

        $('#questionModalTitle').text('Chỉnh Sửa Câu Hỏi');
        $('#questionText').val(question.text);
        $('#questionScore').val(question.score);
        $(`input[name="questionType"][value="${question.type}"]`).prop('checked', true);

        generateAnswersSection(question.type);

        // Load answers
        if (question.answers) {
            question.answers.forEach((answer, i) => {
                $(`#answer${i}`).val(answer.text);
                if (answer.correct) {
                    $(`input[name="correctAnswer"][value="${i}"]`).prop('checked', true);
                }
            });
        }

        $('#questionModal').modal('show');
    }

    /**
     * Xóa câu hỏi
     */
    function deleteQuestion(index) {
        if (confirm('Bạn có chắc chắn muốn xóa câu hỏi này không?')) {
            questions.splice(index, 1);
            renderQuestions();
            updateQuestionCount();
        }
    }

    /**
     * Lưu câu hỏi
     */
    function saveQuestion() {
        const questionText = $('#questionText').val().trim();
        const questionType = $('input[name="questionType"]:checked').val();
        const questionScore = parseInt($('#questionScore').val()) || 1;

        if (!questionText) {
            alert('Vui lòng nhập nội dung câu hỏi');
            return;
        }

        const question = {
            text: questionText,
            type: questionType,
            score: questionScore,
            answers: []
        };

        // Collect answers based on question type
        if (questionType === 'MULTIPLE_CHOICE') {
            for (let i = 0; i < 4; i++) {
                const answerText = $(`#answer${i}`).val().trim();
                if (answerText) {
                    question.answers.push({
                        text: answerText,
                        correct: $(`input[name="correctAnswer"][value="${i}"]`).is(':checked')
                    });
                }
            }

            // Validate at least one correct answer
            const hasCorrectAnswer = question.answers.some(a => a.correct);
            if (!hasCorrectAnswer) {
                alert('Vui lòng chọn ít nhất một đáp án đúng');
                return;
            }
        } else if (questionType === 'TRUE_FALSE') {
            const correctAnswer = $('input[name="trueFalseAnswer"]:checked').val();
            if (!correctAnswer) {
                alert('Vui lòng chọn đáp án đúng');
                return;
            }
            question.answers = [
                { text: 'Đúng', correct: correctAnswer === 'true' },
                { text: 'Sai', correct: correctAnswer === 'false' }
            ];
        }
        // For SHORT_ANSWER, no predefined answers needed

        // Save or update question
        if (currentQuestionIndex >= 0) {
            questions[currentQuestionIndex] = question;
        } else {
            questions.push(question);
        }

        renderQuestions();
        updateQuestionCount();
        $('#questionModal').modal('hide');
    }

    /**
     * Generate answers section based on question type
     */
    function generateAnswersSection(type) {
        const answersSection = $('#answersSection');
        answersSection.empty();

        if (type === 'MULTIPLE_CHOICE') {
            let html = '<div class="mb-3"><label class="form-label">Đáp án <span class="text-danger">*</span></label>';

            for (let i = 0; i < 4; i++) {
                html += `
                <div class="answer-option d-flex align-items-center mb-2">
                    <div class="form-check me-3">
                        <input class="form-check-input" type="radio" name="correctAnswer"
                               value="${i}" id="correct${i}">
                        <label class="form-check-label" for="correct${i}">Đúng</label>
                    </div>
                    <input type="text" id="answer${i}" class="form-control"
                           placeholder="Đáp án ${String.fromCharCode(65 + i)}" ${i < 2 ? 'required' : ''}>
                </div>
            `;
            }

            html += '</div>';
            answersSection.html(html);

        } else if (type === 'TRUE_FALSE') {
            answersSection.html(`
            <div class="mb-3">
                <label class="form-label">Đáp án đúng <span class="text-danger">*</span></label>
                <div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="trueFalseAnswer"
                               id="answerTrue" value="true" required>
                        <label class="form-check-label" for="answerTrue">Đúng</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="trueFalseAnswer"
                               id="answerFalse" value="false" required>
                        <label class="form-check-label" for="answerFalse">Sai</label>
                    </div>
                </div>
            </div>
        `);

        } else if (type === 'SHORT_ANSWER') {
            answersSection.html(`
            <div class="alert alert-info">
                <i class="fas fa-info-circle me-2"></i>
                Câu hỏi tự luận sẽ được chấm điểm thủ công bởi giảng viên.
            </div>
        `);
        }
    }

    /**
     * Render questions list
     */
    function renderQuestions() {
        const questionsList = $('#questionsList');

        if (questions.length === 0) {
            questionsList.html(`
            <div class="text-center py-4" id="emptyQuestionsState">
                <i class="fas fa-question-circle text-muted mb-3" style="font-size: 3rem;"></i>
                <h6 class="text-muted">Chưa có câu hỏi nào</h6>
                <p class="text-muted mb-3">Nhấn "Thêm Câu Hỏi" để bắt đầu tạo quiz</p>
            </div>
        `);
            return;
        }

        let html = '';
        questions.forEach((question, index) => {
            html += `
            <div class="question-card" data-index="${index}">
                <div class="question-header">
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="flex-grow-1">
                            <div class="d-flex align-items-center mb-2">
                                <i class="fas fa-grip-vertical text-muted me-2 drag-handle"
                                   style="cursor: move;" title="Kéo để sắp xếp"></i>
                                <h6 class="mb-0">Câu ${index + 1}</h6>
                                <span class="badge bg-secondary ms-2">${question.score} điểm</span>
                                <span class="badge bg-info ms-1">
                                    ${question.type === 'MULTIPLE_CHOICE' ? 'Trắc nghiệm' :
                                      question.type === 'TRUE_FALSE' ? 'Đúng/Sai' : 'Tự luận'}
                                </span>
                            </div>
                            <p class="mb-2">${question.text}</p>
                        </div>
                        <div class="btn-group">
                            <button type="button" class="btn btn-sm btn-outline-primary"
                                    onclick="editQuestion(${index})" title="Chỉnh sửa">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-danger"
                                    onclick="deleteQuestion(${index})" title="Xóa">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    ${renderQuestionAnswers(question)}
                </div>
            </div>
        `;
        });

        questionsList.html(html);
    }

    /**
     * Render question answers
     */
    function renderQuestionAnswers(question) {
        if (question.type === 'SHORT_ANSWER') {
            return '<p class="text-muted mb-0"><i class="fas fa-pen me-2"></i>Câu trả lời tự luận</p>';
        }

        if (!question.answers || question.answers.length === 0) {
            return '<p class="text-muted mb-0">Chưa có đáp án</p>';
        }

        let html = '<div class="row">';
        question.answers.forEach((answer, index) => {
            const isCorrect = answer.correct;
            html += `
            <div class="col-md-6 mb-2">
                <div class="answer-option ${isCorrect ? 'correct' : ''}">
                    <div class="d-flex align-items-center">
                        <span class="me-2">${String.fromCharCode(65 + index)}.</span>
                        <span class="flex-grow-1">${answer.text}</span>
                        ${isCorrect ? '<i class="fas fa-check text-success ms-2"></i>' : ''}
                    </div>
                </div>
            </div>
        `;
        });
        html += '</div>';

        return html;
    }

    /**
     * Update question count badge
     */
    function updateQuestionCount() {
        $('#questionCount').text(questions.length);
    }

    /**
     * Update question order after drag & drop
     */
    function updateQuestionOrder() {
        const newOrder = [];
        $('#questionsList .question-card').each(function(index) {
            const oldIndex = parseInt($(this).data('index'));
            newOrder.push(questions[oldIndex]);
        });
        questions = newOrder;
        renderQuestions();
    }

    /**
     * Load existing questions if editing
     */
    function loadExistingQuestions() {
        // Nếu đang chỉnh sửa quiz, load questions từ server
        // Đây chỉ là ví dụ, cần implement theo backend
        <c:if test="${not empty quiz.questions}">
        // Load questions from server data
        questions = [
            // Dữ liệu questions sẽ được load từ server
        ];
        renderQuestions();
        updateQuestionCount();
        </c:if>
    }

    /**
     * Setup form validation
     */
    function setupFormValidation() {
        const form = document.querySelector('.needs-validation');

        form.addEventListener('submit', function(event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }

            // Custom validation
            if (questions.length === 0) {
                alert('Vui lòng thêm ít nhất một câu hỏi cho quiz.');
                event.preventDefault();
                event.stopPropagation();
            }

            // Add questions to form data
            if (questions.length > 0) {
                // Tạo hidden inputs để submit questions
                questions.forEach((question, index) => {
                    const questionData = JSON.stringify(question);
                    $('<input>').attr({
                        type: 'hidden',
                        name: `questions[${index}]`,
                        value: questionData
                    }).appendTo(form);
                });
            }

            form.classList.add('was-validated');
        });
    }

    // Event listeners cho question type changes
    $(document).on('change', 'input[name="questionType"]', function() {
        generateAnswersSection($(this).val());
    });
</script>

</body>
</html>