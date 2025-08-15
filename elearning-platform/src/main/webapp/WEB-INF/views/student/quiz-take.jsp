<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${quiz.title} - EduLearn Platform</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/student.css"" rel="stylesheet">

    <style>
        body {
            background: #f8f9fa;
        }

        .quiz-container {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .quiz-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            text-align: center;
        }

        .timer-display {
            background: rgba(255,255,255,0.2);
            border-radius: 50px;
            padding: 0.75rem 1.5rem;
            display: inline-block;
            margin-top: 1rem;
            font-size: 1.2rem;
            font-weight: bold;
        }

        .timer-warning {
            background: rgba(255,193,7,0.9) !important;
            color: #000 !important;
            animation: pulse 1s infinite;
        }

        .timer-danger {
            background: rgba(220,53,69,0.9) !important;
            animation: flash 0.5s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        @keyframes flash {
            0%, 50% { opacity: 1; }
            25%, 75% { opacity: 0.7; }
        }

        .progress-tracker {
            background: #fff;
            border-bottom: 1px solid #dee2e6;
            padding: 1rem 2rem;
        }

        .question-container {
            padding: 2rem;
            min-height: 400px;
        }

        .question-card {
            background: #f8f9fa;
            border: 2px solid #e9ecef;
            border-radius: 12px;
            padding: 2rem;
            margin-bottom: 2rem;
            transition: all 0.3s ease;
        }

        .question-number {
            background: #667eea;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 1rem;
        }

        .answer-option {
            border: 2px solid #e9ecef;
            border-radius: 12px;
            padding: 1rem 1.5rem;
            margin-bottom: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            background: white;
        }

        .answer-option:hover {
            border-color: #667eea;
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.2);
        }

        .answer-option.selected {
            border-color: #667eea;
            background: #e7f3ff;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }

        .answer-option .form-check-input {
            margin-right: 1rem;
            transform: scale(1.2);
        }

        .navigation-controls {
            background: #f8f9fa;
            border-top: 1px solid #dee2e6;
            padding: 1.5rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .question-nav {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .question-nav-btn {
            width: 40px;
            height: 40px;
            border: 2px solid #dee2e6;
            background: white;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: bold;
        }

        .question-nav-btn:hover {
            border-color: #667eea;
        }

        .question-nav-btn.answered {
            background: #28a745;
            color: white;
            border-color: #28a745;
        }

        .question-nav-btn.current {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }

        .question-nav-btn.flagged {
            background: #ffc107;
            color: #000;
            border-color: #ffc107;
        }

        .sidebar-panel {
            position: fixed;
            top: 0;
            right: -320px;
            width: 320px;
            height: 100vh;
            background: white;
            box-shadow: -4px 0 20px rgba(0,0,0,0.1);
            transition: right 0.3s ease;
            z-index: 1000;
            overflow-y: auto;
        }

        .sidebar-panel.show {
            right: 0;
        }

        .sidebar-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 999;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
        }

        .sidebar-overlay.show {
            opacity: 1;
            visibility: visible;
        }

        .confidence-slider {
            margin: 1rem 0;
        }

        .auto-save-indicator {
            position: fixed;
            top: 20px;
            right: 20px;
            background: rgba(40, 167, 69, 0.9);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-size: 0.875rem;
            z-index: 1001;
            transform: translateY(-100px);
            opacity: 0;
            transition: all 0.3s ease;
        }

        .auto-save-indicator.show {
            transform: translateY(0);
            opacity: 1;
        }

        .quiz-summary-card {
            border: 1px solid #dee2e6;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            background: white;
        }

        .flag-button {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: none;
            border: none;
            color: #6c757d;
            font-size: 1.2rem;
            cursor: pointer;
            transition: color 0.3s ease;
        }

        .flag-button:hover {
            color: #ffc107;
        }

        .flag-button.flagged {
            color: #ffc107;
        }

        .question-text {
            font-size: 1.1rem;
            line-height: 1.6;
            margin-bottom: 1.5rem;
        }

        .quiz-instructions {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 1rem 1.5rem;
            margin-bottom: 2rem;
            border-radius: 0 8px 8px 0;
        }
    </style>
</head>

<body>
<!-- Auto Save Indicator -->
<div class="auto-save-indicator" id="autoSaveIndicator">
    <i class="fas fa-check-circle me-2"></i>Đã tự động lưu
</div>

<!-- Include Header -->
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container-fluid py-4">
    <!-- Quiz Container -->
    <div class="quiz-container">

        <!-- Quiz Header -->
        <div class="quiz-header">
            <h1 class="h2 mb-2">${quiz.title}</h1>
            <p class="mb-0">${quiz.description}</p>

            <!-- Timer (chỉ hiển thị nếu có giới hạn thời gian) -->
            <c:if test="${quiz.timeLimit > 0}">
                <div class="timer-display" id="timerDisplay">
                    <i class="fas fa-clock me-2"></i>
                    <span id="timeRemaining">${quiz.timeLimit}:00</span>
                </div>
            </c:if>
        </div>

        <!-- Progress Tracker -->
        <div class="progress-tracker">
            <div class="d-flex justify-content-between align-items-center mb-2">
                <span class="text-muted">Tiến độ làm bài</span>
                <span class="fw-bold" id="progressText">1 / ${fn:length(quiz.questions)}</span>
            </div>
            <div class="progress" style="height: 8px;">
                <div class="progress-bar bg-success" id="progressBar"
                     style="width: ${100.0 / fn:length(quiz.questions)}%"></div>
            </div>
        </div>

        <!-- Question Container -->
        <div class="question-container">
            <form id="quizForm" method="POST" action="//student/quiz/${quiz.id}/submit"">
                <input type="hidden" name="quizResultId" value="${quizResult.id}" />

                <!-- Quiz Instructions -->
                <div class="quiz-instructions">
                    <h6><i class="fas fa-info-circle me-2"></i>Hướng dẫn làm bài</h6>
                    <ul class="mb-0">
                        <li>Đọc kỹ câu hỏi trước khi chọn đáp án</li>
                        <li>Bạn có thể di chuyển tự do giữa các câu hỏi</li>
                        <li>Đáp án sẽ được tự động lưu khi bạn chọn</li>
                        <li>Nhấn vào biểu tượng cờ để đánh dấu câu hỏi cần xem lại</li>
                        <c:if test="${quiz.timeLimit > 0}">
                            <li class="text-warning">
                                <i class="fas fa-exclamation-triangle me-1"></i>
                                Bài kiểm tra có giới hạn thời gian: ${quiz.timeLimit} phút
                            </li>
                        </c:if>
                    </ul>
                </div>

                <!-- Questions -->
                <c:forEach items="${quiz.questions}" var="question" varStatus="status">
                    <div class="question-slide" id="question${status.index}"
                         style="display: ${status.index == 0 ? 'block' : 'none'};">

                        <div class="question-card position-relative">
                            <!-- Flag Button -->
                            <button type="button" class="flag-button"
                                    onclick="toggleFlag(${status.index})"
                                    id="flagBtn${status.index}">
                                <i class="fas fa-flag"></i>
                            </button>

                            <!-- Question Header -->
                            <div class="d-flex align-items-center mb-3">
                                <div class="question-number">${status.index + 1}</div>
                                <div>
                                    <h5 class="mb-1">Câu ${status.index + 1}</h5>
                                    <small class="text-muted">
                                        <c:if test="${question.points > 0}">
                                            ${question.points} điểm
                                        </c:if>
                                        <c:if test="${not empty question.difficultyLevel}">
                                            • Độ khó:
                                            <c:choose>
                                                <c:when test="${question.difficultyLevel == 'EASY'}">Dễ</c:when>
                                                <c:when test="${question.difficultyLevel == 'MEDIUM'}">Trung bình</c:when>
                                                <c:when test="${question.difficultyLevel == 'HARD'}">Khó</c:when>
                                            </c:choose>
                                        </c:if>
                                    </small>
                                </div>
                            </div>

                            <!-- Question Text -->
                            <div class="question-text">
                                    ${question.questionText}
                            </div>

                            <!-- Question Image (nếu có) -->
                            <c:if test="${not empty question.imageUrl}">
                                <div class="question-image mb-3">
                                    <img src="${question.imageUrl}" alt="Hình ảnh câu hỏi"
                                         class="img-fluid rounded" style="max-height: 300px;">
                                </div>
                            </c:if>

                            <!-- Answer Options -->
                            <div class="answer-options">
                                <c:choose>
                                    <!-- Multiple Choice -->
                                    <c:when test="${question.type == 'MULTIPLE_CHOICE'}">
                                        <c:forEach items="${question.answers}" var="answer" varStatus="answerStatus">
                                            <div class="answer-option" onclick="selectAnswer(${status.index}, '${answer.id}', this)">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio"
                                                           name="question_${question.id}"
                                                           value="${answer.id}"
                                                           id="q${status.index}_a${answerStatus.index}">
                                                    <label class="form-check-label" for="q${status.index}_a${answerStatus.index}">
                                                        <span class="answer-letter">${fn:substring("ABCDEFGH", answerStatus.index, answerStatus.index + 1)}.</span>
                                                            ${answer.answerText}
                                                    </label>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>

                                    <!-- True/False -->
                                    <c:when test="${question.type == 'TRUE_FALSE'}">
                                        <div class="answer-option" onclick="selectAnswer(${status.index}, 'true', this)">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio"
                                                       name="question_${question.id}"
                                                       value="true"
                                                       id="q${status.index}_true">
                                                <label class="form-check-label" for="q${status.index}_true">
                                                    <i class="fas fa-check-circle text-success me-2"></i>Đúng
                                                </label>
                                            </div>
                                        </div>
                                        <div class="answer-option" onclick="selectAnswer(${status.index}, 'false', this)">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio"
                                                       name="question_${question.id}"
                                                       value="false"
                                                       id="q${status.index}_false">
                                                <label class="form-check-label" for="q${status.index}_false">
                                                    <i class="fas fa-times-circle text-danger me-2"></i>Sai
                                                </label>
                                            </div>
                                        </div>
                                    </c:when>

                                    <!-- Short Answer -->
                                    <c:when test="${question.type == 'SHORT_ANSWER'}">
                                        <div class="mb-3">
                                            <textarea class="form-control"
                                                      name="question_${question.id}"
                                                      rows="4"
                                                      placeholder="Nhập câu trả lời của bạn..."
                                                      onchange="saveAnswer(${status.index})"></textarea>
                                        </div>
                                    </c:when>
                                </c:choose>
                            </div>

                            <!-- Confidence Level (tùy chọn) -->
                            <c:if test="${quiz.showConfidenceLevel}">
                                <div class="confidence-section mt-3">
                                    <label class="form-label">Mức độ tự tin về câu trả lời:</label>
                                    <div class="confidence-slider">
                                        <input type="range" class="form-range" min="1" max="5" value="3"
                                               name="confidence_${question.id}"
                                               id="confidence${status.index}"
                                               onchange="updateConfidenceLabel(${status.index})">
                                        <div class="d-flex justify-content-between">
                                            <small>Không chắc</small>
                                            <small id="confidenceLabel${status.index}">Bình thường</small>
                                            <small>Rất chắc</small>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>

            </form>
        </div>

        <!-- Navigation Controls -->
        <div class="navigation-controls">
            <button class="btn btn-outline-secondary" id="prevBtn" onclick="previousQuestion()" disabled>
                <i class="fas fa-chevron-left me-2"></i>Câu trước
            </button>

            <div class="d-flex align-items-center gap-3">
                <!-- Question Navigation Pills -->
                <div class="question-nav d-none d-md-flex">
                    <c:forEach begin="0" end="${fn:length(quiz.questions) - 1}" var="i">
                        <div class="question-nav-btn ${i == 0 ? 'current' : ''}"
                             id="navBtn${i}" onclick="goToQuestion(${i})">
                                ${i + 1}
                        </div>
                    </c:forEach>
                </div>

                <!-- Mobile Question Navigator -->
                <button class="btn btn-outline-info d-md-none" onclick="showQuestionNavigator()">
                    <i class="fas fa-list me-2"></i>Câu hỏi
                </button>

                <!-- Summary Button -->
                <button class="btn btn-outline-primary" onclick="showSummary()">
                    <i class="fas fa-list-check me-2"></i>Tổng quan
                </button>
            </div>

            <div class="d-flex gap-2">
                <button class="btn btn-outline-primary" id="nextBtn" onclick="nextQuestion()">
                    Câu tiếp<i class="fas fa-chevron-right ms-2"></i>
                </button>
                <button class="btn btn-success d-none" id="submitBtn" onclick="showSubmitConfirmation()">
                    <i class="fas fa-paper-plane me-2"></i>Nộp bài
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Sidebar Panel -->
<div class="sidebar-overlay" id="sidebarOverlay" onclick="hideSidebar()"></div>
<div class="sidebar-panel" id="sidebarPanel">
    <div class="p-3 border-bottom">
        <div class="d-flex justify-content-between align-items-center">
            <h6 class="mb-0">Điều hướng</h6>
            <button class="btn btn-sm btn-outline-secondary" onclick="hideSidebar()">
                <i class="fas fa-times"></i>
            </button>
        </div>
    </div>
    <div class="p-3" id="sidebarContent">
        <!-- Content sẽ được load bằng JavaScript -->
    </div>
</div>

<!-- Submit Confirmation Modal -->
<div class="modal fade" id="submitModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-paper-plane me-2"></i>Nộp bài kiểm tra
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div id="submitSummary">
                    <!-- Summary content sẽ được tạo bằng JavaScript -->
                </div>
                <div class="alert alert-warning mt-3">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    <strong>Chú ý:</strong> Sau khi nộp bài, bạn không thể thay đổi câu trả lời.
                    Hãy kiểm tra kỹ trước khi nộp.
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Kiểm tra lại</button>
                <button type="button" class="btn btn-success" onclick="submitQuiz()">
                    <i class="fas fa-paper-plane me-2"></i>Xác nhận nộp bài
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

<script>
    // Quiz state variables
    let currentQuestion = 0;
    let totalQuestions = ${fn:length(quiz.questions)};
    let answeredQuestions = new Set();
    let flaggedQuestions = new Set();
    let timeRemaining = ${quiz.timeLimit > 0 ? quiz.timeLimit * 60 : 0}; // in seconds
    let timerInterval;
    let autoSaveTimeout;

    $(document).ready(function() {
        // Khởi tạo timer nếu có giới hạn thời gian
        <c:if test="${quiz.timeLimit > 0}">
        startTimer();
        </c:if>

        // Load saved answers nếu có
        loadSavedAnswers();

        // Setup auto-save
        setupAutoSave();

        // Prevent page unload without warning
        setupUnloadWarning();

        // Update UI
        updateUI();
    });

    /**
     * Bắt đầu timer
     */
    function startTimer() {
        timerInterval = setInterval(() => {
            timeRemaining--;
            updateTimerDisplay();

            if (timeRemaining <= 0) {
                // Hết thời gian - tự động nộp bài
                clearInterval(timerInterval);
                autoSubmitQuiz();
            }
        }, 1000);
    }

    /**
     * Cập nhật hiển thị timer
     */
    function updateTimerDisplay() {
        const minutes = Math.floor(timeRemaining / 60);
        const seconds = timeRemaining % 60;
        const timeString = minutes + ':' + (seconds < 10 ? '0' : '') + seconds;

        $('#timeRemaining').text(timeString);

        // Thay đổi màu sắc dựa trên thời gian còn lại
        const timerDisplay = $('#timerDisplay');
        if (timeRemaining <= 300) { // 5 phút cuối
            timerDisplay.addClass('timer-danger');
        } else if (timeRemaining <= 600) { // 10 phút cuối
            timerDisplay.addClass('timer-warning');
        }
    }

    /**
     * Di chuyển đến câu hỏi tiếp theo
     */
    function nextQuestion() {
        if (currentQuestion < totalQuestions - 1) {
            currentQuestion++;
            showQuestion(currentQuestion);
            updateUI();
        }
    }

    /**
     * Di chuyển đến câu hỏi trước
     */
    function previousQuestion() {
        if (currentQuestion > 0) {
            currentQuestion--;
            showQuestion(currentQuestion);
            updateUI();
        }
    }

    /**
     * Di chuyển đến câu hỏi cụ thể
     */
    function goToQuestion(questionIndex) {
        currentQuestion = questionIndex;
        showQuestion(currentQuestion);
        updateUI();
        hideSidebar();
    }

    /**
     * Hiển thị câu hỏi
     */
    function showQuestion(index) {
        $('.question-slide').hide();
        $('#question' + index).show();
    }

    /**
     * Chọn đáp án
     */
    function selectAnswer(questionIndex, value, element) {
        // Update UI
        $(element).siblings().removeClass('selected');
        $(element).addClass('selected');

        // Check radio button
        $(element).find('input[type="radio"]').prop('checked', true);

        // Mark as answered
        answeredQuestions.add(questionIndex);

        // Update navigation button
        $('#navBtn' + questionIndex).addClass('answered');

        // Auto-save
        saveAnswer(questionIndex);

        // Update progress
        updateProgress();

        // Auto advance to next question (optional)
        if (currentQuestion < totalQuestions - 1) {
            setTimeout(() => {
                nextQuestion();
            }, 1000);
        }
    }

    /**
     * Lưu câu trả lời
     */
    function saveAnswer(questionIndex) {
        // Show auto-save indicator
        showAutoSaveIndicator();

        // Clear previous timeout
        clearTimeout(autoSaveTimeout);

        // Set new timeout
        autoSaveTimeout = setTimeout(() => {
            const formData = new FormData($('#quizForm')[0]);

            $.ajax({
                url: '<c:url value="/student/quiz/${quiz.id}/save-answer" />',
                method: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function() {
                    hideAutoSaveIndicator();
                },
                error: function() {
                    showToast('Có lỗi xảy ra khi lưu câu trả lời', 'error');
                }
            });
        }, 1000);
    }

    /**
     * Toggle flag cho câu hỏi
     */
    function toggleFlag(questionIndex) {
        const flagBtn = $('#flagBtn' + questionIndex);
        const navBtn = $('#navBtn' + questionIndex);

        if (flaggedQuestions.has(questionIndex)) {
            flaggedQuestions.delete(questionIndex);
            flagBtn.removeClass('flagged');
            navBtn.removeClass('flagged');
        } else {
            flaggedQuestions.add(questionIndex);
            flagBtn.addClass('flagged');
            navBtn.addClass('flagged');
        }
    }

    /**
     * Cập nhật UI
     */
    function updateUI() {
        // Update progress text
        $('#progressText').text((currentQuestion + 1) + ' / ' + totalQuestions);

        // Update navigation buttons
        $('#prevBtn').prop('disabled', currentQuestion === 0);

        if (currentQuestion === totalQuestions - 1) {
            $('#nextBtn').addClass('d-none');
            $('#submitBtn').removeClass('d-none');
        } else {
            $('#nextBtn').removeClass('d-none');
            $('#submitBtn').addClass('d-none');
        }

        // Update question navigation
        $('.question-nav-btn').removeClass('current');
        $('#navBtn' + currentQuestion).addClass('current');

        // Update progress bar
        updateProgress();
    }

    /**
     * Cập nhật thanh tiến độ
     */
    function updateProgress() {
        const progress = ((currentQuestion + 1) / totalQuestions) * 100;
        $('#progressBar').css('width', progress + '%');
    }

    /**
     * Hiển thị tổng quan bài làm
     */
    function showSummary() {
        const summaryContent = generateSummaryContent();
        $('#sidebarContent').html(summaryContent);
        showSidebar();
    }

    /**
     * Tạo nội dung tổng quan
     */
    function generateSummaryContent() {
        let html = '<div class="quiz-summary">';
        html += '<h6 class="mb-3">Tổng quan bài làm</h6>';

        // Statistics
        html += '<div class="quiz-summary-card">';
        html += '<div class="row text-center">';
        html += '<div class="col-6">';
        html += '<div class="fw-bold text-success">' + answeredQuestions.size + '</div>';
        html += '<small class="text-muted">Đã trả lời</small>';
        html += '</div>';
        html += '<div class="col-6">';
        html += '<div class="fw-bold text-warning">' + flaggedQuestions.size + '</div>';
        html += '<small class="text-muted">Đánh dấu</small>';
        html += '</div>';
        html += '</div>';
        html += '</div>';

        // Question list
        html += '<div class="question-list mt-3">';
        for (let i = 0; i < totalQuestions; i++) {
            const isAnswered = answeredQuestions.has(i);
            const isFlagged = flaggedQuestions.has(i);
            const isCurrent = i === currentQuestion;

            html += '<div class="d-flex align-items-center justify-content-between p-2 border-bottom">';
            html += '<div class="d-flex align-items-center">';
            html += '<span class="badge bg-' + (isCurrent ? 'primary' : isAnswered ? 'success' : 'secondary') + ' me-2">' + (i + 1) + '</span>';
            html += '<span class="small">Câu ' + (i + 1) + '</span>';
            html += '</div>';
            html += '<div>';
            if (isFlagged) {
                html += '<i class="fas fa-flag text-warning me-1"></i>';
            }
            if (isAnswered) {
                html += '<i class="fas fa-check text-success"></i>';
            }
            html += '</div>';
            html += '</div>';
        }
        html += '</div>';

        html += '</div>';
        return html;
    }

    /**
     * Hiển thị navigator câu hỏi
     */
    function showQuestionNavigator() {
        let html = '<div class="question-navigator">';
        html += '<h6 class="mb-3">Danh sách câu hỏi</h6>';
        html += '<div class="question-nav" style="display: grid; grid-template-columns: repeat(5, 1fr); gap: 0.5rem;">';

        for (let i = 0; i < totalQuestions; i++) {
            const isAnswered = answeredQuestions.has(i);
            const isFlagged = flaggedQuestions.has(i);
            const isCurrent = i === currentQuestion;

            let classes = 'question-nav-btn';
            if (isCurrent) classes += ' current';
            else if (isAnswered) classes += ' answered';
            if (isFlagged) classes += ' flagged';

            html += '<div class="' + classes + '" onclick="goToQuestion(' + i + ')">' + (i + 1) + '</div>';
        }

        html += '</div>';
        html += '</div>';

        $('#sidebarContent').html(html);
        showSidebar();
    }

    /**
     * Hiển thị sidebar
     */
    function showSidebar() {
        $('#sidebarOverlay').addClass('show');
        $('#sidebarPanel').addClass('show');
    }

    /**
     * Ẩn sidebar
     */
    function hideSidebar() {
        $('#sidebarOverlay').removeClass('show');
        $('#sidebarPanel').removeClass('show');
    }

    /**
     * Hiển thị xác nhận nộp bài
     */
    function showSubmitConfirmation() {
        const unansweredCount = totalQuestions - answeredQuestions.size;

        let summaryHtml = '<div class="submit-summary">';
        summaryHtml += '<div class="row text-center mb-3">';
        summaryHtml += '<div class="col-4">';
        summaryHtml += '<div class="fw-bold text-success h4">' + answeredQuestions.size + '</div>';
        summaryHtml += '<small class="text-muted">Đã trả lời</small>';
        summaryHtml += '</div>';
        summaryHtml += '<div class="col-4">';
        summaryHtml += '<div class="fw-bold text-danger h4">' + unansweredCount + '</div>';
        summaryHtml += '<small class="text-muted">Chưa trả lời</small>';
        summaryHtml += '</div>';
        summaryHtml += '<div class="col-4">';
        summaryHtml += '<div class="fw-bold text-warning h4">' + flaggedQuestions.size + '</div>';
        summaryHtml += '<small class="text-muted">Đánh dấu</small>';
        summaryHtml += '</div>';
        summaryHtml += '</div>';

        if (unansweredCount > 0) {
            summaryHtml += '<div class="alert alert-warning">';
            summaryHtml += '<i class="fas fa-exclamation-triangle me-2"></i>';
            summaryHtml += 'Bạn còn <strong>' + unansweredCount + '</strong> câu chưa trả lời.';
            summaryHtml += '</div>';
        }

        summaryHtml += '</div>';

        $('#submitSummary').html(summaryHtml);
        $('#submitModal').modal('show');
    }

    /**
     * Nộp bài kiểm tra
     */
    function submitQuiz() {
        // Disable submit button to prevent double submission
        $('#submitModal .btn-success').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Đang nộp bài...');

        // Clear timer
        if (timerInterval) {
            clearInterval(timerInterval);
        }

        // Submit form
        $('#quizForm').submit();
    }

    /**
     * Tự động nộp bài khi hết thời gian
     */
    function autoSubmitQuiz() {
        showToast('Hết thời gian! Bài kiểm tra sẽ được tự động nộp.', 'warning');
        setTimeout(() => {
            $('#quizForm').submit();
        }, 2000);
    }

    /**
     * Load câu trả lời đã lưu
     */
    function loadSavedAnswers() {
        // Load từ server hoặc localStorage
        // Implementation tùy thuộc vào backend
    }

    /**
     * Setup auto-save
     */
    function setupAutoSave() {
        // Auto-save mỗi 30 giây
        setInterval(() => {
            saveAnswer(currentQuestion);
        }, 30000);
    }

    /**
     * Setup warning khi rời khỏi trang
     */
    function setupUnloadWarning() {
        window.addEventListener('beforeunload', function(e) {
            e.preventDefault();
            e.returnValue = 'Bạn có chắc chắn muốn rời khỏi trang? Dữ liệu có thể bị mất.';
        });
    }

    /**
     * Update confidence label
     */
    function updateConfidenceLabel(questionIndex) {
        const value = $('#confidence' + questionIndex).val();
        const labels = ['Không chắc', 'Hơi chắc', 'Bình thường', 'Khá chắc', 'Rất chắc'];
        $('#confidenceLabel' + questionIndex).text(labels[value - 1]);
    }

    /**
     * Hiển thị auto-save indicator
     */
    function showAutoSaveIndicator() {
        $('#autoSaveIndicator').addClass('show');
    }

    /**
     * Ẩn auto-save indicator
     */
    function hideAutoSaveIndicator() {
        setTimeout(() => {
            $('#autoSaveIndicator').removeClass('show');
        }, 1500);
    }

    /**
     * Keyboard shortcuts
     */
    $(document).keydown(function(e) {
        // Chỉ hoạt động khi không focus vào input/textarea
        if ($(e.target).is('input, textarea, select')) return;

        switch(e.key) {
            case 'ArrowLeft':
                e.preventDefault();
                if (currentQuestion > 0) previousQuestion();
                break;
            case 'ArrowRight':
                e.preventDefault();
                if (currentQuestion < totalQuestions - 1) nextQuestion();
                break;
            case 'f':
            case 'F':
                e.preventDefault();
                toggleFlag(currentQuestion);
                break;
            case 'Enter':
                if (currentQuestion === totalQuestions - 1) {
                    e.preventDefault();
                    showSubmitConfirmation();
                }
                break;
        }
    });

    /**
     * Hiển thị thông báo toast
     */
    function showToast(message, type = 'info') {
        const toastContainer = document.getElementById('toast-container') || createToastContainer();

        const toast = document.createElement('div');
        toast.className = `toast align-items-center text-white bg-${type === 'error' ? 'danger' : type === 'warning' ? 'warning' : 'success'} border-0`;
        toast.setAttribute('role', 'alert');
        toast.innerHTML = `
        <div class="d-flex">
            <div class="toast-body">
                <i class="fas fa-${type === 'error' ? 'exclamation-circle' : type === 'warning' ? 'exclamation-triangle' : 'check-circle'} me-2"></i>
                ${message}
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    `;

        toastContainer.appendChild(toast);
        const bsToast = new bootstrap.Toast(toast);
        bsToast.show();

        // Tự động xóa toast sau khi ẩn
        toast.addEventListener('hidden.bs.toast', function() {
            toast.remove();
        });
    }

    /**
     * Tạo container cho toast nếu chưa có
     */
    function createToastContainer() {
        const container = document.createElement('div');
        container.id = 'toast-container';
        container.className = 'toast-container position-fixed top-0 end-0 p-3';
        container.style.zIndex = '9999';
        document.body.appendChild(container);
        return container;
    }
</script>

</body>
</html>