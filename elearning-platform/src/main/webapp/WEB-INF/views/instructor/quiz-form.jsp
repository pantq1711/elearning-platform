<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${quiz.id != null ? 'Chỉnh sửa' : 'Tạo mới'} Quiz - EduLearn Platform</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- TinyMCE CSS -->
    <link href="https://cdn.tiny.cloud/1/no-api-key/tinymce/6/tinymce.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/instructor.css" rel="stylesheet">

    <style>
        .question-card {
            border: 1px solid #dee2e6;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            transition: all 0.3s ease;
            background: white;
        }
        .question-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .question-header {
            background: #f8f9fa;
            border-radius: 12px 12px 0 0;
            padding: 1rem;
            border-bottom: 1px solid #dee2e6;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .answer-option {
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 0.75rem;
            margin-bottom: 0.5rem;
            transition: all 0.3s ease;
        }
        .answer-option:hover {
            border-color: #0d6efd;
            background-color: #f8f9ff;
        }
        .answer-option.correct {
            border-color: #198754;
            background-color: #d1e7dd;
        }
        .quiz-settings-card {
            position: sticky;
            top: 20px;
        }
        .datetime-input {
            width: 100%;
        }
        .points-display {
            background: linear-gradient(45deg, #0d6efd, #6610f2);
            color: white;
            padding: 1rem;
            border-radius: 8px;
            text-align: center;
        }
        .question-type-selector {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }
        .question-type-btn {
            flex: 1;
            padding: 0.5rem;
            border: 2px solid #dee2e6;
            border-radius: 6px;
            background: white;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .question-type-btn.active {
            border-color: #0d6efd;
            background-color: #e7f3ff;
            color: #0d6efd;
        }
        .drag-handle {
            cursor: grab;
            color: #6c757d;
        }
        .drag-handle:hover {
            color: #0d6efd;
        }
        .question-counter {
            background: #0d6efd;
            color: white;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 0.9rem;
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
                                <a href="${pageContext.request.contextPath}/instructor/dashboard">
                                    <i class="fas fa-home"></i> Dashboard
                                </a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/instructor/courses">Khóa học</a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/instructor/quizzes?courseId=${course.id}">Quiz</a>
                            </li>
                            <li class="breadcrumb-item active">
                                ${quiz.id != null ? 'Chỉnh sửa' : 'Tạo mới'}
                            </li>
                        </ol>
                    </nav>
                    <h1 class="h3 mb-0">
                        <i class="fas fa-${quiz.id != null ? 'edit' : 'plus-circle'} text-primary me-2"></i>
                        ${quiz.id != null ? 'Chỉnh Sửa' : 'Tạo Mới'} Quiz
                    </h1>
                    <p class="text-muted mb-0">
                        ${quiz.id != null ? 'Cập nhật thông tin quiz' : 'Thêm quiz mới cho khóa học'}
                    </p>
                </div>

                <!-- Course Info -->
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="row align-items-center">
                            <div class="col-auto">
                                <c:choose>
                                    <c:when test="${not empty course.imageUrl}">
                                        <img src="${pageContext.request.contextPath}/images/courses/${course.imageUrl}"
                                             alt="${course.name}"
                                             class="course-thumbnail"
                                             style="width: 60px; height: 45px; object-fit: cover; border-radius: 6px;"
                                             onerror="this.src='${pageContext.request.contextPath}/images/course-default.png'">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="course-thumbnail d-flex align-items-center justify-content-center bg-primary text-white"
                                             style="width: 60px; height: 45px; border-radius: 6px;">
                                            <i class="fas fa-book"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="col">
                                <h6 class="mb-1">${course.name}</h6>
                                <small class="text-muted">
                                    <i class="fas fa-layer-group me-1"></i>${course.category.name}
                                </small>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Thông báo lỗi -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Thông báo thành công -->
                <c:if test="${not empty message}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Form Tạo/Sửa Quiz -->
                <form:form method="POST" modelAttribute="quiz"
                           action="${quiz.id != null ?
                                    pageContext.request.contextPath.concat('/instructor/quizzes/').concat(quiz.id.toString()) :
                                    pageContext.request.contextPath.concat('/instructor/quizzes')}"
                           id="quizForm">

                    <!-- CSRF Token -->
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <!-- Course ID hidden field -->
                    <form:hidden path="course.id" value="${course.id}"/>

                    <div class="row">
                        <!-- Left Column - Content -->
                        <div class="col-lg-8">

                            <!-- Basic Information -->
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">
                                        <i class="fas fa-info-circle me-2"></i>Thông Tin Cơ Bản
                                    </h6>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <!-- Tiêu đề quiz -->
                                        <div class="col-12 mb-3">
                                            <label for="title" class="form-label">
                                                Tiêu đề quiz <span class="text-danger">*</span>
                                            </label>
                                            <form:input path="title" cssClass="form-control"
                                                        placeholder="Nhập tên quiz..." required="true" />
                                            <form:errors path="title" cssClass="text-danger small" />
                                        </div>

                                        <!-- Mô tả quiz -->
                                        <div class="col-12 mb-3">
                                            <label for="description" class="form-label">
                                                Mô tả quiz
                                            </label>
                                            <form:textarea path="description" cssClass="form-control" rows="3"
                                                           placeholder="Mô tả ngắn gọn về nội dung quiz..." />
                                            <form:errors path="description" cssClass="text-danger small" />
                                        </div>

                                        <!-- Thời lượng và điểm -->
                                        <div class="col-md-4 mb-3">
                                            <label for="duration" class="form-label">
                                                Thời gian làm bài (phút) <span class="text-danger">*</span>
                                            </label>
                                            <div class="input-group">
                                                <form:input path="duration" type="number" cssClass="form-control"
                                                            min="1" step="1" placeholder="60" required="true" />
                                                <span class="input-group-text">phút</span>
                                            </div>
                                            <form:errors path="duration" cssClass="text-danger small" />
                                        </div>

                                        <div class="col-md-4 mb-3">
                                            <label for="maxScore" class="form-label">
                                                Điểm tối đa <span class="text-danger">*</span>
                                            </label>
                                            <form:input path="maxScore" type="number" cssClass="form-control"
                                                        min="1" step="0.5" placeholder="100" required="true" />
                                            <form:errors path="maxScore" cssClass="text-danger small" />
                                        </div>

                                        <div class="col-md-4 mb-3">
                                            <label for="passScore" class="form-label">
                                                Điểm đậu <span class="text-danger">*</span>
                                            </label>
                                            <form:input path="passScore" type="number" cssClass="form-control"
                                                        min="0" step="0.5" placeholder="60" required="true" />
                                            <form:errors path="passScore" cssClass="text-danger small" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Quiz Availability -->
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">
                                        <i class="fas fa-calendar-alt me-2"></i>Thời Gian Khả Dụng
                                    </h6>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="availableFrom" class="form-label">
                                                Bắt đầu từ
                                            </label>
                                            <form:input path="availableFrom" type="datetime-local"
                                                        cssClass="form-control datetime-input" />
                                            <form:errors path="availableFrom" cssClass="text-danger small" />
                                            <div class="form-text">Để trống nếu không giới hạn</div>
                                        </div>

                                        <div class="col-md-6 mb-3">
                                            <label for="availableUntil" class="form-label">
                                                Kết thúc lúc
                                            </label>
                                            <form:input path="availableUntil" type="datetime-local"
                                                        cssClass="form-control datetime-input" />
                                            <form:errors path="availableUntil" cssClass="text-danger small" />
                                            <div class="form-text">Để trống nếu không giới hạn</div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Questions Section -->
                            <div class="card mb-4">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h6 class="card-title mb-0">
                                        <i class="fas fa-question-circle me-2"></i>Câu Hỏi
                                        <span class="badge bg-primary ms-2" id="questionCount">0</span>
                                    </h6>
                                    <button type="button" class="btn btn-sm btn-outline-primary" onclick="addQuestion()">
                                        <i class="fas fa-plus me-1"></i>Thêm Câu Hỏi
                                    </button>
                                </div>
                                <div class="card-body">
                                    <div id="questionsContainer">
                                        <!-- Questions sẽ được thêm động bằng JavaScript -->
                                        <div class="text-center text-muted py-4" id="noQuestionsMessage">
                                            <i class="fas fa-question-circle fa-3x mb-3"></i>
                                            <p>Chưa có câu hỏi nào. Nhấn "Thêm Câu Hỏi" để bắt đầu.</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>

                        <!-- Right Column - Settings -->
                        <div class="col-lg-4">

                            <!-- Quiz Settings -->
                            <div class="card quiz-settings-card mb-4">
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

                                    <!-- Hiển thị đáp án -->
                                    <div class="mb-3">
                                        <div class="form-check form-switch">
                                            <form:checkbox path="showCorrectAnswers" cssClass="form-check-input" />
                                            <label class="form-check-label" for="showCorrectAnswers">
                                                Hiển thị đáp án đúng
                                            </label>
                                        </div>
                                        <small class="text-muted">
                                            Hiển thị đáp án sau khi nộp bài
                                        </small>
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
                                            Thay đổi thứ tự câu hỏi mỗi lần làm
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
                                            Thay đổi thứ tự đáp án mỗi lần làm
                                        </small>
                                    </div>

                                    <!-- Yêu cầu đăng nhập -->
                                    <div class="mb-3">
                                        <div class="form-check form-switch">
                                            <form:checkbox path="requireLogin" cssClass="form-check-input" />
                                            <label class="form-check-label" for="requireLogin">
                                                Yêu cầu đăng nhập
                                            </label>
                                        </div>
                                        <small class="text-muted">
                                            Chỉ cho phép user đã đăng nhập làm quiz
                                        </small>
                                    </div>

                                    <!-- Tổng điểm -->
                                    <div class="points-display">
                                        <div class="h4 mb-1" id="totalPoints">${quiz.points != null ? quiz.points : 0}</div>
                                        <div class="small">Tổng điểm quiz</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="card">
                                <div class="card-body">
                                    <div class="d-grid gap-2">
                                        <!-- Save Button -->
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-2"></i>
                                                ${quiz.id != null ? 'Cập Nhật' : 'Tạo'} Quiz
                                        </button>

                                        <!-- Preview Button -->
                                        <c:if test="${quiz.id != null}">
                                            <a href="${pageContext.request.contextPath}/quizzes/${quiz.id}/preview"
                                               class="btn btn-outline-info" target="_blank">
                                                <i class="fas fa-eye me-2"></i>Xem Trước
                                            </a>
                                        </c:if>

                                        <!-- Cancel Button -->
                                        <a href="${pageContext.request.contextPath}/instructor/quizzes?courseId=${course.id}"
                                           class="btn btn-outline-secondary">
                                            <i class="fas fa-arrow-left me-2"></i>Quay Lại
                                        </a>

                                        <!-- Delete Button (chỉ khi edit) -->
                                        <c:if test="${quiz.id != null}">
                                            <button type="button" class="btn btn-outline-danger"
                                                    onclick="confirmDelete('${quiz.id}')">
                                                <i class="fas fa-trash me-2"></i>Xóa Quiz
                                            </button>
                                        </c:if>
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

<!-- Include Footer -->
<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.tiny.cloud/1/no-api-key/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>

<script>
    let questionCounter = 0;
    let totalPoints = 0;

    $(document).ready(function() {
        // Load existing questions if editing
        <c:if test="${quiz.id != null && not empty quiz.questions}">
        <c:forEach items="${quiz.questions}" var="question" varStatus="status">
        addExistingQuestion(
            '${question.questionText}',
            '${question.optionA}',
            '${question.optionB}',
            '${question.optionC}',
            '${question.optionD}',
            '${question.correctOption}',
            '${question.points}',
            '${question.explanation}',
            '${question.difficultyLevel}'
        );
        </c:forEach>
        </c:if>

        // Form validation
        setupFormValidation();

        // Update total points display
        updateTotalPoints();
    });

    /**
     * Thêm câu hỏi mới
     */
    function addQuestion() {
        questionCounter++;
        const questionHtml = createQuestionHtml(questionCounter, '', '', '', '', '', 'A', 1.0, '', 'MEDIUM');

        if ($('#questionsContainer .question-card').length === 0) {
            $('#noQuestionsMessage').hide();
        }

        $('#questionsContainer').append(questionHtml);
        updateQuestionCount();
        updateTotalPoints();

        // Initialize TinyMCE for new question
        initQuestionEditor(questionCounter);
    }

    /**
     * Thêm câu hỏi có sẵn (khi edit)
     */
    function addExistingQuestion(text, optA, optB, optC, optD, correct, points, explanation, difficulty) {
        questionCounter++;
        const questionHtml = createQuestionHtml(questionCounter, text, optA, optB, optC, optD, correct, points, explanation, difficulty);

        $('#noQuestionsMessage').hide();
        $('#questionsContainer').append(questionHtml);
        updateQuestionCount();
        updateTotalPoints();

        // Initialize TinyMCE for question
        initQuestionEditor(questionCounter);
    }

    /**
     * Tạo HTML cho một câu hỏi - FIX: Tránh template literals và === operator
     */
    function createQuestionHtml(index, text, optA, optB, optC, optD, correct, points, explanation, difficulty) {
        var correctA = (correct == 'A') ? 'checked' : '';
        var correctB = (correct == 'B') ? 'checked' : '';
        var correctC = (correct == 'C') ? 'checked' : '';
        var correctD = (correct == 'D') ? 'checked' : '';
        var difficultyEasy = (difficulty == 'EASY') ? 'selected' : '';
        var difficultyMedium = (difficulty == 'MEDIUM') ? 'selected' : '';
        var difficultyHard = (difficulty == 'HARD') ? 'selected' : '';

        return '<div class="question-card" data-index="' + index + '">' +
            '<div class="question-header">' +
            '<div class="d-flex align-items-center">' +
            '<i class="fas fa-grip-vertical drag-handle me-2"></i>' +
            '<div class="question-counter">' + index + '</div>' +
            '<span class="ms-2 fw-bold">Câu hỏi ' + index + '</span>' +
            '</div>' +
            '<div>' +
            '<button type="button" class="btn btn-sm btn-outline-danger" onclick="removeQuestion(' + index + ')">' +
            '<i class="fas fa-trash"></i>' +
            '</button>' +
            '</div>' +
            '</div>' +
            '<div class="card-body">' +
            '<div class="mb-3">' +
            '<label class="form-label">Nội dung câu hỏi <span class="text-danger">*</span></label>' +
            '<textarea class="form-control question-editor" id="questionText_' + index + '" ' +
            'name="questions[' + (index-1) + '].questionText" required rows="3" ' +
            'placeholder="Nhập nội dung câu hỏi...">' + text + '</textarea>' +
            '</div>' +
            '<div class="row mb-3">' +
            '<div class="col-md-6 mb-2">' +
            '<label class="form-label">Đáp án A <span class="text-danger">*</span></label>' +
            '<div class="input-group">' +
            '<span class="input-group-text">' +
            '<input type="radio" name="questions[' + (index-1) + '].correctOption" value="A" ' + correctA + '>' +
            '</span>' +
            '<input type="text" class="form-control" name="questions[' + (index-1) + '].optionA" ' +
            'value="' + optA + '" placeholder="Nhập đáp án A..." required>' +
            '</div>' +
            '</div>' +
            '<div class="col-md-6 mb-2">' +
            '<label class="form-label">Đáp án B <span class="text-danger">*</span></label>' +
            '<div class="input-group">' +
            '<span class="input-group-text">' +
            '<input type="radio" name="questions[' + (index-1) + '].correctOption" value="B" ' + correctB + '>' +
            '</span>' +
            '<input type="text" class="form-control" name="questions[' + (index-1) + '].optionB" ' +
            'value="' + optB + '" placeholder="Nhập đáp án B..." required>' +
            '</div>' +
            '</div>' +
            '<div class="col-md-6 mb-2">' +
            '<label class="form-label">Đáp án C <span class="text-danger">*</span></label>' +
            '<div class="input-group">' +
            '<span class="input-group-text">' +
            '<input type="radio" name="questions[' + (index-1) + '].correctOption" value="C" ' + correctC + '>' +
            '</span>' +
            '<input type="text" class="form-control" name="questions[' + (index-1) + '].optionC" ' +
            'value="' + optC + '" placeholder="Nhập đáp án C..." required>' +
            '</div>' +
            '</div>' +
            '<div class="col-md-6 mb-2">' +
            '<label class="form-label">Đáp án D <span class="text-danger">*</span></label>' +
            '<div class="input-group">' +
            '<span class="input-group-text">' +
            '<input type="radio" name="questions[' + (index-1) + '].correctOption" value="D" ' + correctD + '>' +
            '</span>' +
            '<input type="text" class="form-control" name="questions[' + (index-1) + '].optionD" ' +
            'value="' + optD + '" placeholder="Nhập đáp án D..." required>' +
            '</div>' +
            '</div>' +
            '</div>' +
            '<div class="row mb-3">' +
            '<div class="col-md-4">' +
            '<label class="form-label">Điểm</label>' +
            '<input type="number" class="form-control question-points" ' +
            'name="questions[' + (index-1) + '].points" value="' + points + '" ' +
            'min="0.5" step="0.5" onchange="updateTotalPoints()">' +
            '</div>' +
            '<div class="col-md-8">' +
            '<label class="form-label">Độ khó</label>' +
            '<select class="form-select" name="questions[' + (index-1) + '].difficultyLevel">' +
            '<option value="EASY" ' + difficultyEasy + '>Dễ</option>' +
            '<option value="MEDIUM" ' + difficultyMedium + '>Trung bình</option>' +
            '<option value="HARD" ' + difficultyHard + '>Khó</option>' +
            '</select>' +
            '</div>' +
            '</div>' +
            '<div class="mb-3">' +
            '<label class="form-label">Giải thích (tuỳ chọn)</label>' +
            '<textarea class="form-control" name="questions[' + (index-1) + '].explanation" ' +
            'rows="2" placeholder="Giải thích tại sao đáp án này đúng...">' + explanation + '</textarea>' +
            '</div>' +
            '<input type="hidden" name="questions[' + (index-1) + '].displayOrder" value="' + index + '">' +
            '<input type="hidden" name="questions[' + (index-1) + '].questionType" value="MULTIPLE_CHOICE">' +
            '</div>' +
            '</div>';
    }

    /**
     * Initialize TinyMCE for question editor
     */
    function initQuestionEditor(index) {
        tinymce.init({
            selector: `#questionText_${index}`,
            height: 200,
            menubar: false,
            plugins: ['lists', 'link', 'code'],
            toolbar: 'undo redo | bold italic | bullist numlist | link | code',
            content_style: 'body { font-family: Arial, sans-serif; font-size: 14px }'
        });
    }

    /**
     * Xóa câu hỏi
     */
    function removeQuestion(index) {
        if (confirm('Bạn có chắc chắn muốn xóa câu hỏi này?')) {
            $(`.question-card[data-index="${index}"]`).remove();
            updateQuestionCount();
            updateTotalPoints();

            if ($('#questionsContainer .question-card').length === 0) {
                $('#noQuestionsMessage').show();
            }
        }
    }

    /**
     * Cập nhật số lượng câu hỏi
     */
    function updateQuestionCount() {
        const count = $('#questionsContainer .question-card').length;
        $('#questionCount').text(count);
    }

    /**
     * Cập nhật tổng điểm
     */
    function updateTotalPoints() {
        let total = 0;
        $('.question-points').each(function() {
            const value = parseFloat($(this).val()) || 0;
            total += value;
        });
        $('#totalPoints').text(total.toFixed(1));
        totalPoints = total;
    }

    /**
     * Setup form validation
     */
    function setupFormValidation() {
        $('#quizForm').on('submit', function(e) {
            let isValid = true;

            // Validate title
            const title = $('#title').val().trim();
            if (title.length < 5) {
                isValid = false;
                $('#title').addClass('is-invalid');
                alert('Tiêu đề quiz phải có ít nhất 5 ký tự');
            } else {
                $('#title').removeClass('is-invalid');
            }

            // Validate questions
            const questionCount = $('#questionsContainer .question-card').length;
            if (questionCount === 0) {
                isValid = false;
                alert('Quiz phải có ít nhất 1 câu hỏi');
            }

            // Validate each question has correct answer selected
            $('.question-card').each(function() {
                const hasCorrectAnswer = $(this).find('input[type="radio"]:checked').length > 0;
                if (!hasCorrectAnswer) {
                    isValid = false;
                    $(this).find('.question-header').addClass('border-danger');
                    alert('Vui lòng chọn đáp án đúng cho tất cả câu hỏi');
                    return false;
                }
            });

            // Validate pass score not greater than max score
            const maxScore = parseFloat($('#maxScore').val()) || 0;
            const passScore = parseFloat($('#passScore').val()) || 0;
            if (passScore > maxScore) {
                isValid = false;
                $('#passScore').addClass('is-invalid');
                alert('Điểm đậu không được lớn hơn điểm tối đa');
            }

            if (!isValid) {
                e.preventDefault();
            }
        });
    }

    /**
     * Confirm delete quiz
     */
    function confirmDelete(quizId) {
        if (confirm('Bạn có chắc chắn muốn xóa quiz này? Hành động này sẽ xóa tất cả câu hỏi và kết quả làm bài. Không thể hoàn tác.')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/instructor/quizzes/' + quizId + '/delete';

            const csrfToken = document.createElement('input');
            csrfToken.type = 'hidden';
            csrfToken.name = '${_csrf.parameterName}';
            csrfToken.value = '${_csrf.token}';

            form.appendChild(csrfToken);
            document.body.appendChild(form);
            form.submit();
        }
    }
</script>
</body>
</html>