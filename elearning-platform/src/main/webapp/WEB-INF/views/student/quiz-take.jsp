<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${quiz.title} - ${course.name}</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        /* CSS tùy chỉnh cho trang làm bài kiểm tra */
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #28a745;
            --info-color: #17a2b8;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --dark-color: #2c3e50;
        }

        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .quiz-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }

        .quiz-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            text-align: center;
        }

        .quiz-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .quiz-description {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 1.5rem;
        }

        .quiz-meta {
            display: flex;
            justify-content: center;
            gap: 2rem;
            font-size: 1rem;
        }

        .quiz-meta-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .timer-section {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
            text-align: center;
        }

        .timer-display {
            font-size: 3rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
            font-family: 'Courier New', monospace;
        }

        .timer-display.warning {
            color: var(--warning-color);
            animation: pulse 1s infinite;
        }

        .timer-display.danger {
            color: var(--danger-color);
            animation: pulse 0.5s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        .timer-label {
            color: #6c757d;
            font-size: 1rem;
        }

        .progress-section {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }

        .progress-header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .progress-label {
            font-weight: 600;
            color: var(--dark-color);
        }

        .progress-count {
            color: var(--primary-color);
            font-weight: 700;
        }

        .progress {
            height: 12px;
            border-radius: 10px;
            background: #f1f3f4;
        }

        .progress-bar {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            border-radius: 10px;
            transition: width 0.3s ease;
        }

        .question-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .question-card.answered {
            border-left: 5px solid var(--success-color);
        }

        .question-header {
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
            padding: 1.5rem;
            border-bottom: 1px solid #f1f3f4;
        }

        .question-number {
            display: inline-block;
            background: var(--primary-color);
            color: white;
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .question-text {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--dark-color);
            line-height: 1.5;
        }

        .question-body {
            padding: 2rem;
        }

        .option-item {
            background: #f8f9fa;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 1rem 1.5rem;
            margin-bottom: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
        }

        .option-item:hover {
            background: rgba(102, 126, 234, 0.05);
            border-color: var(--primary-color);
        }

        .option-item.selected {
            background: rgba(102, 126, 234, 0.1);
            border-color: var(--primary-color);
            color: var(--primary-color);
        }

        .option-radio {
            margin-right: 1rem;
            width: 20px;
            height: 20px;
        }

        .option-label {
            font-weight: 500;
            margin-right: 1rem;
            min-width: 30px;
            text-align: center;
            background: #6c757d;
            color: white;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
        }

        .option-item.selected .option-label {
            background: var(--primary-color);
        }

        .option-text {
            flex: 1;
            font-size: 1rem;
            line-height: 1.4;
        }

        .question-navigation {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }

        .nav-buttons {
            display: flex;
            justify-content: between;
            align-items: center;
            gap: 1rem;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            border: none;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }

        .question-overview {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }

        .overview-title {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 1rem;
        }

        .question-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(50px, 1fr));
            gap: 0.5rem;
        }

        .question-dot {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: 2px solid #e9ecef;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            color: #6c757d;
        }

        .question-dot:hover {
            border-color: var(--primary-color);
            color: var(--primary-color);
        }

        .question-dot.answered {
            background: var(--success-color);
            border-color: var(--success-color);
            color: white;
        }

        .question-dot.current {
            background: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }

        .submit-section {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .submit-warning {
            background: rgba(255, 193, 7, 0.1);
            border: 1px solid rgba(255, 193, 7, 0.3);
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }

        .submit-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .stat-item {
            text-align: center;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .stat-number.answered { color: var(--success-color); }
        .stat-number.unanswered { color: var(--danger-color); }
        .stat-number.total { color: var(--primary-color); }

        .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
        }

        .floating-timer {
            position: fixed;
            top: 20px;
            right: 20px;
            background: white;
            border-radius: 10px;
            padding: 1rem;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            z-index: 1000;
            display: none;
        }

        .floating-timer.show {
            display: block;
        }

        .auto-save-indicator {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: var(--success-color);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .auto-save-indicator.show {
            opacity: 1;
        }

        @media (max-width: 768px) {
            .quiz-container {
                padding: 1rem 0.5rem;
            }

            .quiz-title {
                font-size: 1.5rem;
            }

            .quiz-meta {
                flex-direction: column;
                gap: 1rem;
            }

            .timer-display {
                font-size: 2rem;
            }

            .question-body {
                padding: 1rem;
            }

            .nav-buttons {
                flex-direction: column;
            }

            .question-grid {
                grid-template-columns: repeat(auto-fill, minmax(40px, 1fr));
            }

            .floating-timer {
                top: 10px;
                right: 10px;
                padding: 0.5rem;
            }
        }
    </style>
</head>
<body>

<div class="quiz-container">
    <!-- Quiz Header -->
    <div class="quiz-header">
        <h1 class="quiz-title">${quiz.title}</h1>
        <p class="quiz-description">${quiz.description}</p>
        <div class="quiz-meta">
            <div class="quiz-meta-item">
                <i class="fas fa-question-circle"></i>
                <span>${questions.size()} câu hỏi</span>
            </div>
            <div class="quiz-meta-item">
                <i class="fas fa-clock"></i>
                <span>${quiz.duration} phút</span>
            </div>
            <div class="quiz-meta-item">
                <i class="fas fa-star"></i>
                <span>Điểm tối đa: ${quiz.maxScore}</span>
            </div>
        </div>
    </div>

    <!-- Timer Section -->
    <div class="timer-section">
        <div class="timer-display" id="timerDisplay">--:--</div>
        <div class="timer-label">Thời gian còn lại</div>
    </div>

    <!-- Floating Timer (shows when scrolling) -->
    <div class="floating-timer" id="floatingTimer">
        <div class="text-center">
            <div id="floatingTimerDisplay" style="font-size: 1.2rem; font-weight: 700; color: var(--primary-color);">--:--</div>
            <small class="text-muted">Còn lại</small>
        </div>
    </div>

    <!-- Progress Section -->
    <div class="progress-section">
        <div class="progress-header">
            <span class="progress-label">Tiến độ làm bài</span>
            <span class="progress-count" id="progressCount">0/${questions.size()}</span>
        </div>
        <div class="progress">
            <div class="progress-bar" id="progressBar" style="width: 0%"></div>
        </div>
    </div>

    <!-- Question Overview -->
    <div class="question-overview">
        <div class="overview-title">
            <i class="fas fa-th me-2"></i>
            Tổng quan câu hỏi - Nhấp để chuyển câu
        </div>
        <div class="question-grid" id="questionGrid">
            <c:forEach items="${questions}" var="question" varStatus="status">
                <div class="question-dot"
                     data-question="${status.index}"
                     onclick="goToQuestion(${status.index})">
                        ${status.index + 1}
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- Quiz Form -->
    <form id="quizForm" method="post" action="/student/my-courses/${course.id}/quizzes/${quiz.id}/submit">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

        <!-- Questions -->
        <c:forEach items="${questions}" var="question" varStatus="status">
            <div class="question-card" id="question_${status.index}" style="display: ${status.index == 0 ? 'block' : 'none'}">
                <div class="question-header">
                    <div class="question-number">${status.index + 1}</div>
                    <div class="question-text">${question.questionText}</div>
                </div>

                <div class="question-body">
                    <div class="options">
                        <!-- Option A -->
                        <div class="option-item" onclick="selectOption(${status.index}, 'A')">
                            <input type="radio"
                                   class="option-radio"
                                   name="question_${question.id}"
                                   value="A"
                                   id="q${status.index}_a"
                                   style="display: none;">
                            <div class="option-label">A</div>
                            <div class="option-text">${question.optionA}</div>
                        </div>

                        <!-- Option B -->
                        <div class="option-item" onclick="selectOption(${status.index}, 'B')">
                            <input type="radio"
                                   class="option-radio"
                                   name="question_${question.id}"
                                   value="B"
                                   id="q${status.index}_b"
                                   style="display: none;">
                            <div class="option-label">B</div>
                            <div class="option-text">${question.optionB}</div>
                        </div>

                        <!-- Option C -->
                        <div class="option-item" onclick="selectOption(${status.index}, 'C')">
                            <input type="radio"
                                   class="option-radio"
                                   name="question_${question.id}"
                                   value="C"
                                   id="q${status.index}_c"
                                   style="display: none;">
                            <div class="option-label">C</div>
                            <div class="option-text">${question.optionC}</div>
                        </div>

                        <!-- Option D -->
                        <div class="option-item" onclick="selectOption(${status.index}, 'D')">
                            <input type="radio"
                                   class="option-radio"
                                   name="question_${question.id}"
                                   value="D"
                                   id="q${status.index}_d"
                                   style="display: none;">
                            <div class="option-label">D</div>
                            <div class="option-text">${question.optionD}</div>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>

        <!-- Question Navigation -->
        <div class="question-navigation">
            <div class="nav-buttons">
                <button type="button"
                        class="btn btn-outline-primary"
                        id="prevBtn"
                        onclick="previousQuestion()"
                        disabled>
                    <i class="fas fa-arrow-left me-2"></i>
                    Câu trước
                </button>

                <div class="d-flex align-items-center gap-2">
                    <button type="button"
                            class="btn btn-outline-secondary"
                            onclick="clearAnswer()">
                        <i class="fas fa-eraser me-2"></i>
                        Xóa đáp án
                    </button>

                    <button type="button"
                            class="btn btn-warning"
                            onclick="markForReview()">
                        <i class="fas fa-flag me-2"></i>
                        Đánh dấu
                    </button>
                </div>

                <button type="button"
                        class="btn btn-primary-custom"
                        id="nextBtn"
                        onclick="nextQuestion()">
                    Câu tiếp theo
                    <i class="fas fa-arrow-right ms-2"></i>
                </button>
            </div>
        </div>
    </form>

    <!-- Submit Section (shows when reaching last question) -->
    <div class="submit-section" id="submitSection" style="display: none;">
        <h4 class="mb-3">
            <i class="fas fa-check-circle me-2"></i>
            Hoàn thành bài kiểm tra
        </h4>

        <div class="submit-warning">
            <i class="fas fa-exclamation-triangle me-2"></i>
            <strong>Lưu ý:</strong> Sau khi nộp bài, bạn không thể chỉnh sửa đáp án. Hãy kiểm tra lại các câu trả lời trước khi nộp.
        </div>

        <div class="submit-stats">
            <div class="stat-item">
                <div class="stat-number answered" id="answeredCount">0</div>
                <div class="stat-label">Đã trả lời</div>
            </div>
            <div class="stat-item">
                <div class="stat-number unanswered" id="unansweredCount">${questions.size()}</div>
                <div class="stat-label">Chưa trả lời</div>
            </div>
            <div class="stat-item">
                <div class="stat-number total">${questions.size()}</div>
                <div class="stat-label">Tổng số câu</div>
            </div>
        </div>

        <div class="d-flex justify-content-center gap-3">
            <button type="button"
                    class="btn btn-outline-primary"
                    onclick="reviewAnswers()">
                <i class="fas fa-eye me-2"></i>
                Xem lại đáp án
            </button>

            <button type="button"
                    class="btn btn-success btn-lg"
                    onclick="submitQuiz()"
                    id="submitBtn">
                <i class="fas fa-paper-plane me-2"></i>
                Nộp bài kiểm tra
            </button>
        </div>
    </div>
</div>

<!-- Auto-save Indicator -->
<div class="auto-save-indicator" id="autoSaveIndicator">
    <i class="fas fa-save me-2"></i>
    Đã tự động lưu
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JavaScript -->
<script>
    // Quiz state management
    let currentQuestion = 0;
    let totalQuestions = ${questions.size()};
    let timeRemaining = ${quiz.duration} * 60; // Convert to seconds
    let answers = {};
    let timerInterval;
    let autoSaveInterval;

    document.addEventListener('DOMContentLoaded', function() {
        // Initialize quiz
        initializeQuiz();
        startTimer();
        setupAutoSave();
        updateProgress();

        // Load saved answers if any
        loadSavedAnswers();

        // Prevent accidental page leave
        window.addEventListener('beforeunload', function(e) {
            if (Object.keys(answers).length > 0) {
                e.preventDefault();
                e.returnValue = 'Bạn có chắc muốn rời khỏi trang? Tiến độ làm bài có thể bị mất.';
            }
        });

        // Show floating timer when scrolling
        window.addEventListener('scroll', function() {
            const floatingTimer = document.getElementById('floatingTimer');
            if (window.scrollY > 300) {
                floatingTimer.classList.add('show');
            } else {
                floatingTimer.classList.remove('show');
            }
        });
    });

    // Initialize quiz
    function initializeQuiz() {
        updateNavigationButtons();
        updateQuestionOverview();
    }

    // Timer functions
    function startTimer() {
        updateTimerDisplay();

        timerInterval = setInterval(function() {
            timeRemaining--;
            updateTimerDisplay();

            // Warning states
            const timerDisplay = document.getElementById('timerDisplay');
            const floatingDisplay = document.getElementById('floatingTimerDisplay');

            if (timeRemaining <= 300) { // 5 minutes
                timerDisplay.classList.add('warning');
            }

            if (timeRemaining <= 60) { // 1 minute
                timerDisplay.classList.remove('warning');
                timerDisplay.classList.add('danger');
            }

            // Auto submit when time runs out
            if (timeRemaining <= 0) {
                clearInterval(timerInterval);
                autoSubmitQuiz();
            }
        }, 1000);
    }

    function updateTimerDisplay() {
        const minutes = Math.floor(timeRemaining / 60);
        const seconds = timeRemaining % 60;
        const timeString = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;

        document.getElementById('timerDisplay').textContent = timeString;
        document.getElementById('floatingTimerDisplay').textContent = timeString;
    }

    // Question navigation
    function goToQuestion(questionIndex) {
        // Hide current question
        document.getElementById(`question_${currentQuestion}`).style.display = 'none';

        // Show target question
        currentQuestion = questionIndex;
        document.getElementById(`question_${currentQuestion}`).style.display = 'block';

        // Update UI
        updateNavigationButtons();
        updateQuestionOverview();

        // Scroll to top
        window.scrollTo(0, 0);

        // Show/hide submit section
        if (currentQuestion === totalQuestions - 1) {
            document.getElementById('submitSection').style.display = 'block';
        } else {
            document.getElementById('submitSection').style.display = 'none';
        }
    }

    function nextQuestion() {
        if (currentQuestion < totalQuestions - 1) {
            goToQuestion(currentQuestion + 1);
        }
    }

    function previousQuestion() {
        if (currentQuestion > 0) {
            goToQuestion(currentQuestion - 1);
        }
    }

    function updateNavigationButtons() {
        const prevBtn = document.getElementById('prevBtn');
        const nextBtn = document.getElementById('nextBtn');

        // Previous button
        prevBtn.disabled = currentQuestion === 0;

        // Next button
        if (currentQuestion === totalQuestions - 1) {
            nextBtn.style.display = 'none';
        } else {
            nextBtn.style.display = 'block';
        }
    }

    // Answer selection
    function selectOption(questionIndex, option) {
        const questionId = getQuestionId(questionIndex);
        const optionItems = document.querySelectorAll(`#question_${questionIndex} .option-item`);

        // Clear all selections
        optionItems.forEach(item => item.classList.remove('selected'));

        // Select current option
        const selectedItem = document.querySelector(`#question_${questionIndex} .option-item:nth-child(${getOptionIndex(option)})`);
        selectedItem.classList.add('selected');

        // Update radio button
        document.getElementById(`q${questionIndex}_${option.toLowerCase()}`).checked = true;

        // Save answer
        answers[questionId] = option;

        // Update UI
        updateProgress();
        updateQuestionOverview();

        // Auto-advance to next question (optional)
        setTimeout(() => {
            if (currentQuestion < totalQuestions - 1) {
                nextQuestion();
            }
        }, 500);
    }

    function clearAnswer() {
        const questionId = getQuestionId(currentQuestion);
        const optionItems = document.querySelectorAll(`#question_${currentQuestion} .option-item`);
        const radioButtons = document.querySelectorAll(`#question_${currentQuestion} input[type="radio"]`);

        // Clear visual selection
        optionItems.forEach(item => item.classList.remove('selected'));

        // Clear radio buttons
        radioButtons.forEach(radio => radio.checked = false);

        // Remove from answers
        delete answers[questionId];

        // Update UI
        updateProgress();
        updateQuestionOverview();
    }

    function getOptionIndex(option) {
        switch(option) {
            case 'A': return 1;
            case 'B': return 2;
            case 'C': return 3;
            case 'D': return 4;
            default: return 1;
        }
    }

    function getQuestionId(questionIndex) {
        const radioButton = document.querySelector(`#question_${questionIndex} input[type="radio"]`);
        return radioButton.name.replace('question_', '');
    }

    // Progress tracking
    function updateProgress() {
        const answeredCount = Object.keys(answers).length;
        const progressPercentage = (answeredCount / totalQuestions) * 100;

        // Update progress bar
        document.getElementById('progressBar').style.width = `${progressPercentage}%`;

        // Update progress count
        document.getElementById('progressCount').textContent = `${answeredCount}/${totalQuestions}`;

        // Update submit section stats
        document.getElementById('answeredCount').textContent = answeredCount;
        document.getElementById('unansweredCount').textContent = totalQuestions - answeredCount;
    }

    function updateQuestionOverview() {
        const questionDots = document.querySelectorAll('.question-dot');

        questionDots.forEach((dot, index) => {
            const questionId = getQuestionId(index);

            // Reset classes
            dot.classList.remove('answered', 'current');

            // Set current
            if (index === currentQuestion) {
                dot.classList.add('current');
            }

            // Set answered
            if (answers[questionId]) {
                dot.classList.add('answered');
            }
        });
    }

    // Auto-save functionality
    function setupAutoSave() {
        autoSaveInterval = setInterval(function() {
            saveProgress();
        }, 30000); // Save every 30 seconds
    }

    function saveProgress() {
        const data = {
            answers: answers,
            currentQuestion: currentQuestion,
            timeRemaining: timeRemaining
        };

        fetch(`/student/my-courses/${course.id}/quizzes/${quiz.id}/auto-save`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                '${_csrf.headerName}': '${_csrf.token}'
            },
            body: JSON.stringify(data)
        })
            .then(response => {
                if (response.ok) {
                    showAutoSaveIndicator();
                }
            })
            .catch(error => console.log('Auto-save failed:', error));
    }

    function showAutoSaveIndicator() {
        const indicator = document.getElementById('autoSaveIndicator');
        indicator.classList.add('show');
        setTimeout(() => {
            indicator.classList.remove('show');
        }, 2000);
    }

    function loadSavedAnswers() {
        // Load saved progress if exists
        fetch(`/student/my-courses/${course.id}/quizzes/${quiz.id}/load-progress`)
            .then(response => response.json())
            .then(data => {
                if (data.answers) {
                    answers = data.answers;

                    // Restore visual state
                    Object.keys(answers).forEach(questionId => {
                        const questionIndex = findQuestionIndex(questionId);
                        const answer = answers[questionId];

                        if (questionIndex !== -1) {
                            // Restore visual selection
                            const selectedItem = document.querySelector(`#question_${questionIndex} .option-item:nth-child(${getOptionIndex(answer)})`);
                            if (selectedItem) {
                                selectedItem.classList.add('selected');
                            }

                            // Restore radio button
                            const radioButton = document.getElementById(`q${questionIndex}_${answer.toLowerCase()}`);
                            if (radioButton) {
                                radioButton.checked = true;
                            }
                        }
                    });

                    updateProgress();
                    updateQuestionOverview();
                }
            })
            .catch(error => console.log('Load progress failed:', error));
    }

    function findQuestionIndex(questionId) {
        for (let i = 0; i < totalQuestions; i++) {
            const radioButton = document.querySelector(`#question_${i} input[type="radio"]`);
            if (radioButton && radioButton.name === `question_${questionId}`) {
                return i;
            }
        }
        return -1;
    }

    // Submit quiz
    function submitQuiz() {
        if (confirm('Bạn có chắc muốn nộp bài? Sau khi nộp bài, bạn không thể chỉnh sửa đáp án.')) {
            // Disable submit button
            const submitBtn = document.getElementById('submitBtn');
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang nộp bài...';
            submitBtn.disabled = true;

            // Clear intervals
            clearInterval(timerInterval);
            clearInterval(autoSaveInterval);

            // Submit form
            document.getElementById('quizForm').submit();
        }
    }

    function autoSubmitQuiz() {
        alert('Hết thời gian! Bài kiểm tra sẽ được tự động nộp.');

        // Clear intervals
        clearInterval(timerInterval);
        clearInterval(autoSaveInterval);

        // Submit form
        document.getElementById('quizForm').submit();
    }

    function reviewAnswers() {
        // Show all unanswered questions
        const unansweredQuestions = [];

        for (let i = 0; i < totalQuestions; i++) {
            const questionId = getQuestionId(i);
            if (!answers[questionId]) {
                unansweredQuestions.push(i + 1);
            }
        }

        if (unansweredQuestions.length > 0) {
            alert(`Bạn chưa trả lời câu: ${unansweredQuestions.join(', ')}`);
            // Go to first unanswered question
            goToQuestion(unansweredQuestions[0] - 1);
        } else {
            alert('Bạn đã trả lời tất cả các câu hỏi!');
        }
    }

    function markForReview() {
        // Mark current question for review
        const questionDot = document.querySelector(`.question-dot[data-question="${currentQuestion}"]`);
        questionDot.style.background = 'orange';
        questionDot.style.borderColor = 'orange';

        // Show indicator
        alert('Đã đánh dấu câu hỏi để xem lại!');
    }

    // Keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        // Number keys to select options
        if (e.key >= '1' && e.key <= '4') {
            const options = ['A', 'B', 'C', 'D'];
            const optionIndex = parseInt(e.key) - 1;
            if (optionIndex < options.length) {
                selectOption(currentQuestion, options[optionIndex]);
            }
        }

        // Arrow keys for navigation
        if (e.key === 'ArrowLeft' && currentQuestion > 0) {
            previousQuestion();
        }

        if (e.key === 'ArrowRight' && currentQuestion < totalQuestions - 1) {
            nextQuestion();
        }

        // Enter to submit (when on last question)
        if (e.key === 'Enter' && currentQuestion === totalQuestions - 1) {
            e.preventDefault();
            submitQuiz();
        }
    });

    // Prevent right-click (optional security measure)
    document.addEventListener('contextmenu', function(e) {
        e.preventDefault();
        return false;
    });

    // Prevent copy/paste (optional security measure)
    document.addEventListener('keydown', function(e) {
        if (e.ctrlKey && (e.key === 'c' || e.key === 'v' || e.key === 'a' || e.key === 'x')) {
            e.preventDefault();
            return false;
        }
    });
</script>

</body>
</html>