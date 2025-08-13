<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả bài kiểm tra - ${quiz.title}</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Chart.js for progress charts -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        /* Định nghĩa các biến màu sắc chính */
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --info-color: #17a2b8;
        }

        /* Thiết lập nền trang */
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
        }

        /* Navbar cho student */
        .navbar {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            box-shadow: 0 2px 20px rgba(0,0,0,0.1);
        }

        /* Container chính */
        .main-container {
            margin-top: 20px;
            margin-bottom: 40px;
        }

        /* Result header với animation */
        .result-header {
            background: white;
            border-radius: 20px;
            padding: 2.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .result-header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: ${quizResult.passed ? 'radial-gradient(circle, rgba(40,167,69,0.1) 0%, transparent 70%)' : 'radial-gradient(circle, rgba(220,53,69,0.1) 0%, transparent 70%)'};
            animation: rotate 20s linear infinite;
        }

        @keyframes rotate {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .result-content {
            position: relative;
            z-index: 2;
        }

        .result-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            animation: bounce 1s infinite;
        }

        .result-icon.success {
            color: var(--success-color);
        }

        .result-icon.failed {
            color: var(--danger-color);
        }

        @keyframes bounce {
            0%, 20%, 60%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-10px);
            }
            80% {
                transform: translateY(-5px);
            }
        }

        .result-title {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
        }

        .result-title.success {
            color: var(--success-color);
        }

        .result-title.failed {
            color: var(--danger-color);
        }

        .result-subtitle {
            font-size: 1.1rem;
            color: #6c757d;
            margin-bottom: 2rem;
        }

        /* Score display */
        .score-display {
            display: inline-flex;
            align-items: center;
            gap: 1rem;
            background: #f8f9fa;
            border-radius: 50px;
            padding: 1rem 2rem;
            margin-bottom: 1.5rem;
        }

        .score-value {
            font-size: 2.5rem;
            font-weight: 900;
            margin: 0;
        }

        .score-value.success {
            color: var(--success-color);
        }

        .score-value.failed {
            color: var(--danger-color);
        }

        /* Stats grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            text-align: center;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 35px rgba(0,0,0,0.15);
        }

        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Progress chart container */
        .progress-container {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .progress-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            text-align: center;
        }

        /* Questions review section */
        .questions-review {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .questions-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .question-item {
            border: 2px solid #e9ecef;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            transition: all 0.3s ease;
        }

        .question-item.correct {
            border-color: var(--success-color);
            background: rgba(40, 167, 69, 0.05);
        }

        .question-item.incorrect {
            border-color: var(--danger-color);
            background: rgba(220, 53, 69, 0.05);
        }

        .question-header {
            display: flex;
            justify-content: between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .question-number {
            background: var(--primary-color);
            color: white;
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            margin-right: 1rem;
            flex-shrink: 0;
        }

        .question-status {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
        }

        .question-status.correct {
            color: var(--success-color);
        }

        .question-status.incorrect {
            color: var(--danger-color);
        }

        .question-text {
            font-size: 1.1rem;
            font-weight: 600;
            line-height: 1.5;
            margin-bottom: 1rem;
        }

        .answer-options {
            display: grid;
            gap: 0.75rem;
        }

        .answer-option {
            padding: 0.75rem 1rem;
            border-radius: 10px;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            transition: all 0.3s ease;
        }

        .answer-option.correct {
            background: rgba(40, 167, 69, 0.1);
            border: 2px solid var(--success-color);
        }

        .answer-option.incorrect {
            background: rgba(220, 53, 69, 0.1);
            border: 2px solid var(--danger-color);
        }

        .answer-option.user-answer {
            background: rgba(255, 193, 7, 0.1);
            border: 2px solid var(--warning-color);
        }

        .option-letter {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            color: white;
            flex-shrink: 0;
        }

        .option-letter.correct {
            background: var(--success-color);
        }

        .option-letter.incorrect {
            background: var(--danger-color);
        }

        .option-letter.user-answer {
            background: var(--warning-color);
            color: #212529;
        }

        .option-letter.default {
            background: #6c757d;
        }

        /* Action buttons */
        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 2rem;
        }

        .action-btn {
            padding: 12px 30px;
            border-radius: 50px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: none;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
            color: white;
        }

        .btn-success {
            background: linear-gradient(135deg, var(--success-color) 0%, #20c997 100%);
            color: white;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.3);
            color: white;
        }

        .btn-outline-secondary {
            border: 2px solid #6c757d;
            color: #6c757d;
            background: transparent;
        }

        .btn-outline-secondary:hover {
            background: #6c757d;
            color: white;
            transform: translateY(-2px);
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .result-header {
                padding: 2rem 1.5rem;
            }

            .result-title {
                font-size: 2rem;
            }

            .score-display {
                flex-direction: column;
                gap: 0.5rem;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .action-buttons {
                flex-direction: column;
                align-items: center;
            }

            .question-header {
                flex-direction: column;
                gap: 1rem;
            }
        }
    </style>
</head>
<body>
<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container">
        <a class="navbar-brand" href="/student/dashboard">
            <i class="fas fa-user-graduate me-2"></i>
            Student Portal
        </a>
        <div class="navbar-nav ms-auto">
                <span class="navbar-text me-3">
                    Xin chào, <strong><sec:authentication property="principal.fullName" /></strong>
                </span>
            <a class="nav-link" href="/logout">
                <i class="fas fa-sign-out-alt"></i> Đăng xuất
            </a>
        </div>
    </div>
</nav>

<!-- Main Container -->
<div class="container main-container">
    <!-- Breadcrumb Navigation -->
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="/student/dashboard">
                    <i class="fas fa-home"></i> Dashboard
                </a>
            </li>
            <li class="breadcrumb-item">
                <a href="/student/my-courses">Khóa học của tôi</a>
            </li>
            <li class="breadcrumb-item">
                <a href="/student/my-courses/${quiz.course.id}">
                    ${quiz.course.name}
                </a>
            </li>
            <li class="breadcrumb-item active" aria-current="page">
                Kết quả: ${quiz.title}
            </li>
        </ol>
    </nav>

    <!-- Result Header -->
    <div class="result-header">
        <div class="result-content">
            <div class="result-icon ${quizResult.passed ? 'success' : 'failed'}">
                <c:choose>
                    <c:when test="${quizResult.passed}">
                        <i class="fas fa-trophy"></i>
                    </c:when>
                    <c:otherwise>
                        <i class="fas fa-times-circle"></i>
                    </c:otherwise>
                </c:choose>
            </div>

            <h1 class="result-title ${quizResult.passed ? 'success' : 'failed'}">
                <c:choose>
                    <c:when test="${quizResult.passed}">
                        Chúc mừng! Bạn đã vượt qua!
                    </c:when>
                    <c:otherwise>
                        Chưa đạt yêu cầu
                    </c:otherwise>
                </c:choose>
            </h1>

            <p class="result-subtitle">
                Kết quả bài kiểm tra: <strong>${quiz.title}</strong>
            </p>

            <!-- Score Display -->
            <div class="score-display">
                <div>
                    <h2 class="score-value ${quizResult.passed ? 'success' : 'failed'}">
                        <fmt:formatNumber value="${quizResult.score}" maxFractionDigits="1"/>
                    </h2>
                    <small class="text-muted">/ ${quiz.maxScore} điểm</small>
                </div>
                <div class="text-muted">
                    <i class="fas fa-percentage"></i>
                    <strong>
                        <fmt:formatNumber value="${(quizResult.score / quiz.maxScore) * 100}" maxFractionDigits="1"/>%
                    </strong>
                </div>
            </div>

            <p class="mb-0">
                <c:choose>
                    <c:when test="${quizResult.passed}">
                            <span class="text-success">
                                <i class="fas fa-check-circle me-1"></i>
                                Bạn đã đạt điểm tối thiểu ${quiz.passScore} để vượt qua bài kiểm tra!
                            </span>
                    </c:when>
                    <c:otherwise>
                            <span class="text-danger">
                                <i class="fas fa-exclamation-circle me-1"></i>
                                Bạn cần đạt tối thiểu ${quiz.passScore} điểm để vượt qua bài kiểm tra.
                            </span>
                    </c:otherwise>
                </c:choose>
            </p>
        </div>
    </div>

    <!-- Stats Grid -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon" style="color: var(--success-color);">
                <i class="fas fa-check-circle"></i>
            </div>
            <div class="stat-value" style="color: var(--success-color);">
                ${quizResult.correctAnswers}
            </div>
            <div class="stat-label">Câu đúng</div>
        </div>

        <div class="stat-card">
            <div class="stat-icon" style="color: var(--danger-color);">
                <i class="fas fa-times-circle"></i>
            </div>
            <div class="stat-value" style="color: var(--danger-color);">
                ${quizResult.totalQuestions - quizResult.correctAnswers}
            </div>
            <div class="stat-label">Câu sai</div>
        </div>

        <div class="stat-card">
            <div class="stat-icon" style="color: var(--info-color);">
                <i class="fas fa-clock"></i>
            </div>
            <div class="stat-value" style="color: var(--info-color);">
                <c:choose>
                    <c:when test="${not empty quizResult.timeSpent}">
                        ${quizResult.timeSpent}
                    </c:when>
                    <c:otherwise>
                        N/A
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="stat-label">Thời gian</div>
        </div>

        <div class="stat-card">
            <div class="stat-icon" style="color: var(--warning-color);">
                <i class="fas fa-redo"></i>
            </div>
            <div class="stat-value" style="color: var(--warning-color);">
                ${quizResult.attemptNumber}
            </div>
            <div class="stat-label">Lần thử</div>
        </div>
    </div>

    <!-- Progress Chart -->
    <div class="progress-container">
        <h3 class="progress-title">
            <i class="fas fa-chart-pie me-2"></i>
            Phân tích kết quả
        </h3>
        <div class="row">
            <div class="col-md-6">
                <canvas id="resultChart" width="300" height="300"></canvas>
            </div>
            <div class="col-md-6 d-flex align-items-center">
                <div class="w-100">
                    <h5>Tóm tắt:</h5>
                    <ul class="list-unstyled">
                        <li class="mb-2">
                            <i class="fas fa-star text-warning me-2"></i>
                            Điểm số: <strong><fmt:formatNumber value="${quizResult.score}" maxFractionDigits="1"/>/${quiz.maxScore}</strong>
                        </li>
                        <li class="mb-2">
                            <i class="fas fa-percentage text-info me-2"></i>
                            Tỷ lệ đúng: <strong><fmt:formatNumber value="${(quizResult.correctAnswers / quizResult.totalQuestions) * 100}" maxFractionDigits="1"/>%</strong>
                        </li>
                        <li class="mb-2">
                            <i class="fas fa-target text-success me-2"></i>
                            Trạng thái:
                            <strong class="${quizResult.passed ? 'text-success' : 'text-danger'}">
                                ${quizResult.passed ? 'ĐẠT' : 'CHƯA ĐẠT'}
                            </strong>
                        </li>
                        <li class="mb-2">
                            <i class="fas fa-calendar-alt text-muted me-2"></i>
                            Hoàn thành: <strong><fmt:formatDate value="${quizResult.completedAt}" pattern="dd/MM/yyyy HH:mm"/></strong>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <!-- Questions Review (if enabled) -->
    <c:if test="${quiz.showCorrectAnswers and not empty questions}">
        <div class="questions-review">
            <h3 class="questions-title">
                <i class="fas fa-list-ul"></i>
                Xem lại câu trả lời
            </h3>

            <c:forEach items="${questions}" var="question" varStatus="status">
                <div class="question-item ${userAnswers[question.id] eq question.correctOption ? 'correct' : 'incorrect'}">
                    <div class="question-header">
                        <div class="d-flex align-items-start">
                            <div class="question-number">${status.index + 1}</div>
                            <div class="flex-grow-1">
                                <h5 class="question-text">${question.questionText}</h5>
                            </div>
                        </div>
                        <div class="question-status ${userAnswers[question.id] eq question.correctOption ? 'correct' : 'incorrect'}">
                            <c:choose>
                                <c:when test="${userAnswers[question.id] eq question.correctOption}">
                                    <i class="fas fa-check-circle"></i>
                                    <span>Đúng</span>
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-times-circle"></i>
                                    <span>Sai</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="answer-options">
                        <!-- Option A -->
                        <div class="answer-option
                                ${question.correctOption eq 'A' ? 'correct' : ''}
                                ${userAnswers[question.id] eq 'A' and question.correctOption ne 'A' ? 'user-answer' : ''}">
                            <div class="option-letter
                                    ${question.correctOption eq 'A' ? 'correct' :
                                      userAnswers[question.id] eq 'A' and question.correctOption ne 'A' ? 'user-answer' : 'default'}">
                                A
                            </div>
                            <span>${question.optionA}</span>
                            <c:if test="${question.correctOption eq 'A'}">
                                <i class="fas fa-check ms-auto text-success"></i>
                            </c:if>
                            <c:if test="${userAnswers[question.id] eq 'A' and question.correctOption ne 'A'}">
                                <i class="fas fa-times ms-auto text-danger"></i>
                            </c:if>
                        </div>

                        <!-- Option B -->
                        <div class="answer-option
                                ${question.correctOption eq 'B' ? 'correct' : ''}
                                ${userAnswers[question.id] eq 'B' and question.correctOption ne 'B' ? 'user-answer' : ''}">
                            <div class="option-letter
                                    ${question.correctOption eq 'B' ? 'correct' :
                                      userAnswers[question.id] eq 'B' and question.correctOption ne 'B' ? 'user-answer' : 'default'}">
                                B
                            </div>
                            <span>${question.optionB}</span>
                            <c:if test="${question.correctOption eq 'B'}">
                                <i class="fas fa-check ms-auto text-success"></i>
                            </c:if>
                            <c:if test="${userAnswers[question.id] eq 'B' and question.correctOption ne 'B'}">
                                <i class="fas fa-times ms-auto text-danger"></i>
                            </c:if>
                        </div>

                        <!-- Option C -->
                        <div class="answer-option
                                ${question.correctOption eq 'C' ? 'correct' : ''}
                                ${userAnswers[question.id] eq 'C' and question.correctOption ne 'C' ? 'user-answer' : ''}">
                            <div class="option-letter
                                    ${question.correctOption eq 'C' ? 'correct' :
                                      userAnswers[question.id] eq 'C' and question.correctOption ne 'C' ? 'user-answer' : 'default'}">
                                C
                            </div>
                            <span>${question.optionC}</span>
                            <c:if test="${question.correctOption eq 'C'}">
                                <i class="fas fa-check ms-auto text-success"></i>
                            </c:if>
                            <c:if test="${userAnswers[question.id] eq 'C' and question.correctOption ne 'C'}">
                                <i class="fas fa-times ms-auto text-danger"></i>
                            </c:if>
                        </div>

                        <!-- Option D -->
                        <div class="answer-option
                                ${question.correctOption eq 'D' ? 'correct' : ''}
                                ${userAnswers[question.id] eq 'D' and question.correctOption ne 'D' ? 'user-answer' : ''}">
                            <div class="option-letter
                                    ${question.correctOption eq 'D' ? 'correct' :
                                      userAnswers[question.id] eq 'D' and question.correctOption ne 'D' ? 'user-answer' : 'default'}">
                                D
                            </div>
                            <span>${question.optionD}</span>
                            <c:if test="${question.correctOption eq 'D'}">
                                <i class="fas fa-check ms-auto text-success"></i>
                            </c:if>
                            <c:if test="${userAnswers[question.id] eq 'D' and question.correctOption ne 'D'}">
                                <i class="fas fa-times ms-auto text-danger"></i>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>

    <!-- Action Buttons -->
    <div class="action-buttons">
        <c:if test="${not quizResult.passed and (quiz.maxAttempts eq -1 or quizResult.attemptNumber lt quiz.maxAttempts)}">
            <a href="/student/my-courses/${quiz.course.id}/quizzes/${quiz.id}" class="action-btn btn-success">
                <i class="fas fa-redo"></i>
                Làm lại bài kiểm tra
            </a>
        </c:if>

        <a href="/student/my-courses/${quiz.course.id}" class="action-btn btn-primary">
            <i class="fas fa-book"></i>
            Quay lại khóa học
        </a>

        <a href="/student/dashboard" class="action-btn btn-outline-secondary">
            <i class="fas fa-home"></i>
            Về trang chính
        </a>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Khởi tạo biểu đồ kết quả
    document.addEventListener('DOMContentLoaded', function() {
        const ctx = document.getElementById('resultChart').getContext('2d');

        const correctAnswers = ${quizResult.correctAnswers};
        const totalQuestions = ${quizResult.totalQuestions};
        const incorrectAnswers = totalQuestions - correctAnswers;

        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Câu đúng', 'Câu sai'],
                datasets: [{
                    data: [correctAnswers, incorrectAnswers],
                    backgroundColor: [
                        'rgba(40, 167, 69, 0.8)',
                        'rgba(220, 53, 69, 0.8)'
                    ],
                    borderColor: [
                        'rgba(40, 167, 69, 1)',
                        'rgba(220, 53, 69, 1)'
                    ],
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            padding: 20,
                            font: {
                                size: 14,
                                weight: 'bold'
                            }
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                const percentage = ((context.parsed / totalQuestions) * 100).toFixed(1);
                                return context.label + ': ' + context.parsed + ' câu (' + percentage + '%)';
                            }
                        }
                    }
                }
            }
        });

        // Animation cho stat cards
        const statCards = document.querySelectorAll('.stat-card');
        statCards.forEach((card, index) => {
            setTimeout(() => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                card.style.transition = 'all 0.6s ease';

                setTimeout(() => {
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, 50);
            }, index * 150);
        });
    });

    // Hiệu ứng confetti nếu đậu
    <c:if test="${quizResult.passed}">
    // Simple confetti effect (you can add a library for better effect)
    function createConfetti() {
        const colors = ['#f39c12', '#e74c3c', '#9b59b6', '#3498db', '#2ecc71'];
        for (let i = 0; i < 50; i++) {
            const confetti = document.createElement('div');
            confetti.style.position = 'fixed';
            confetti.style.top = '-10px';
            confetti.style.left = Math.random() * 100 + 'vw';
            confetti.style.width = '10px';
            confetti.style.height = '10px';
            confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
            confetti.style.borderRadius = '50%';
            confetti.style.pointerEvents = 'none';
            confetti.style.zIndex = '9999';
            confetti.style.animation = 'fall 3s linear infinite';
            document.body.appendChild(confetti);

            setTimeout(() => {
                confetti.remove();
            }, 3000);
        }
    }

    // CSS for confetti animation
    const style = document.createElement('style');
    style.textContent = `
                @keyframes fall {
                    0% { transform: translateY(-100vh) rotate(0deg); }
                    100% { transform: translateY(100vh) rotate(360deg); }
                }
            `;
    document.head.appendChild(style);

    // Trigger confetti after page load
    setTimeout(createConfetti, 500);
    </c:if>
</script>
</body>
</html>