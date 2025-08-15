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
    <title>Kết Quả Quiz - ${quiz.title} - EduLearn Platform</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Chart.js -->
    <link href="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/student.css" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }

        .result-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 2rem 0;
        }

        .result-header {
            background: white;
            border-radius: 20px 20px 0 0;
            padding: 3rem 2rem 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .result-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 6px;
            background: linear-gradient(90deg, #28a745 0%, #20c997 50%, #17a2b8 100%);
        }

        .score-display {
            font-size: 4rem;
            font-weight: bold;
            margin: 1rem 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .result-badge {
            display: inline-block;
            padding: 0.75rem 2rem;
            border-radius: 50px;
            font-size: 1.2rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin: 1rem 0;
        }

        .badge-pass {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }

        .badge-fail {
            background: linear-gradient(135deg, #dc3545 0%, #fd7e14 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(220, 53, 69, 0.3);
        }

        .badge-perfect {
            background: linear-gradient(135deg, #ffd700 0%, #ffed4e 100%);
            color: #333;
            box-shadow: 0 4px 15px rgba(255, 215, 0, 0.4);
            animation: sparkle 2s infinite;
        }

        @keyframes sparkle {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            padding: 2rem;
            background: white;
        }

        .stat-card {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 1.5rem;
            text-align: center;
            border-left: 4px solid;
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .stat-card.correct { border-left-color: #28a745; }
        .stat-card.incorrect { border-left-color: #dc3545; }
        .stat-card.time { border-left-color: #17a2b8; }
        .stat-card.accuracy { border-left-color: #ffc107; }

        .stat-value {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: #6c757d;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .performance-chart {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .question-review {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .question-item {
            border: 1px solid #e9ecef;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .question-item:hover {
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .question-header {
            padding: 1rem 1.5rem;
            background: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
            display: flex;
            justify-content: between;
            align-items: center;
        }

        .question-body {
            padding: 1.5rem;
        }

        .question-correct .question-header {
            background: linear-gradient(135deg, #d1eddb 0%, #c3e6cb 100%);
            border-left: 4px solid #28a745;
        }

        .question-incorrect .question-header {
            background: linear-gradient(135deg, #f8d7da 0%, #f1b0b7 100%);
            border-left: 4px solid #dc3545;
        }

        .answer-option {
            padding: 0.75rem 1rem;
            margin: 0.5rem 0;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .answer-correct {
            background: #d1eddb;
            border: 2px solid #28a745;
            color: #155724;
            font-weight: 600;
        }

        .answer-incorrect {
            background: #f8d7da;
            border: 2px solid #dc3545;
            color: #721c24;
            text-decoration: line-through;
        }

        .answer-selected {
            background: #fff3cd;
            border: 2px solid #ffc107;
            color: #856404;
        }

        .feedback-section {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 1rem 1.5rem;
            margin-top: 1rem;
            border-radius: 0 8px 8px 0;
        }

        .improvement-suggestions {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .suggestion-item {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
            border-left: 4px solid #17a2b8;
        }

        .action-buttons {
            background: white;
            border-radius: 0 0 20px 20px;
            padding: 2rem;
            text-align: center;
        }

        .celebration-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 9999;
        }

        .confetti {
            position: absolute;
            width: 10px;
            height: 10px;
            background: #ffd700;
            animation: confetti-fall 3s linear infinite;
        }

        @keyframes confetti-fall {
            0% {
                transform: translateY(-100vh) rotate(0deg);
                opacity: 1;
            }
            100% {
                transform: translateY(100vh) rotate(720deg);
                opacity: 0;
            }
        }

        .progress-ring {
            transform: rotate(-90deg);
        }

        .progress-ring-circle {
            fill: none;
            stroke: #e9ecef;
            stroke-width: 8;
        }

        .progress-ring-progress {
            fill: none;
            stroke-width: 8;
            stroke-linecap: round;
            transition: stroke-dasharray 1s ease;
        }

        .certificate-preview {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border: 2px dashed #dee2e6;
            border-radius: 12px;
            padding: 2rem;
            text-align: center;
            margin: 1.5rem 0;
        }
    </style>
</head>

<body>
<!-- Celebration Overlay (chỉ hiển thị nếu đạt điểm cao) -->
<c:if test="${quizResult.score >= quiz.maxScore * 0.9}">
    <div class="celebration-overlay" id="celebrationOverlay"></div>
</c:if>

<!-- Include Header -->
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container-fluid py-4">
    <div class="result-container">

        <!-- Result Header -->
        <div class="result-header">
            <h1 class="h2 mb-3">${quiz.title}</h1>
            <p class="text-muted mb-4">${quiz.course.name}</p>

            <!-- Score Display -->
            <div class="score-display">
                <fmt:formatNumber value="${quizResult.score}" maxFractionDigits="1" />
                <span style="font-size: 2rem;">/ ${quiz.maxScore}</span>
            </div>

            <!-- Result Badge -->
            <div>
                <c:choose>
                    <c:when test="${quizResult.score == quiz.maxScore}">
                        <span class="result-badge badge-perfect">
                            <i class="fas fa-crown me-2"></i>Hoàn hảo!
                        </span>
                    </c:when>
                    <c:when test="${quizResult.passed}">
                        <span class="result-badge badge-pass">
                            <i class="fas fa-check-circle me-2"></i>Đạt
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span class="result-badge badge-fail">
                            <i class="fas fa-times-circle me-2"></i>Chưa đạt
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Percentage Score -->
            <div class="mt-3">
                <h4 class="text-muted">
                    <fmt:formatNumber value="${quizResult.score / quiz.maxScore * 100}" maxFractionDigits="1" />%
                    <small>(Cần ${quiz.passingScore}% để đạt)</small>
                </h4>
            </div>

            <!-- Completion Time -->
            <div class="mt-3">
                <p class="text-muted">
                    <i class="fas fa-clock me-2"></i>
                    Hoàn thành lúc: <fmt:formatDate value="${quizResult.completionTime}" pattern="dd/MM/yyyy HH:mm" />
                </p>
                <c:if test="${quizResult.timeSpent > 0}">
                    <p class="text-muted">
                        <i class="fas fa-stopwatch me-2"></i>
                        Thời gian làm bài:
                        <fmt:formatNumber value="${quizResult.timeSpent / 60}" maxFractionDigits="0" /> phút
                    </p>
                </c:if>
            </div>
        </div>

        <!-- Statistics Grid -->
        <div class="stats-grid">
            <div class="stat-card correct">
                <div class="stat-value text-success">${quizResult.correctAnswers}</div>
                <div class="stat-label">Câu đúng</div>
            </div>
            <div class="stat-card incorrect">
                <div class="stat-value text-danger">${quizResult.incorrectAnswers}</div>
                <div class="stat-label">Câu sai</div>
            </div>
            <div class="stat-card accuracy">
                <div class="stat-value text-warning">
                    <fmt:formatNumber value="${quizResult.correctAnswers * 100.0 / (quizResult.correctAnswers + quizResult.incorrectAnswers)}" maxFractionDigits="1" />%
                </div>
                <div class="stat-label">Độ chính xác</div>
            </div>
            <div class="stat-card time">
                <div class="stat-value text-info">
                    <c:choose>
                        <c:when test="${quizResult.timeSpent > 0}">
                            <fmt:formatNumber value="${quizResult.timeSpent / 60}" maxFractionDigits="0" />m
                        </c:when>
                        <c:otherwise>--</c:otherwise>
                    </c:choose>
                </div>
                <div class="stat-label">Thời gian</div>
            </div>
        </div>

        <!-- Performance Chart -->
        <div class="performance-chart">
            <h5 class="mb-4">
                <i class="fas fa-chart-pie me-2"></i>Phân Tích Kết Quả
            </h5>
            <div class="row">
                <div class="col-md-6">
                    <canvas id="scoreChart" width="300" height="300"></canvas>
                </div>
                <div class="col-md-6">
                    <div class="performance-details">
                        <h6 class="mb-3">Chi Tiết Hiệu Suất</h6>

                        <!-- Progress Ring -->
                        <div class="text-center mb-4">
                            <svg width="120" height="120" class="progress-ring">
                                <circle class="progress-ring-circle"
                                        cx="60" cy="60" r="50"></circle>
                                <circle class="progress-ring-progress"
                                        cx="60" cy="60" r="50"
                                        stroke="#28a745"
                                        stroke-dasharray="${(quizResult.score / quiz.maxScore) * 314} 314"></circle>
                                <text x="60" y="65" text-anchor="middle"
                                      class="h4 fw-bold" fill="#333">
                                    <fmt:formatNumber value="${quizResult.score / quiz.maxScore * 100}" maxFractionDigits="0" />%
                                </text>
                            </svg>
                        </div>

                        <!-- Performance Metrics -->
                        <div class="performance-metrics">
                            <div class="metric-item d-flex justify-content-between mb-2">
                                <span>Điểm số:</span>
                                <strong>${quizResult.score}/${quiz.maxScore}</strong>
                            </div>
                            <div class="metric-item d-flex justify-content-between mb-2">
                                <span>Tỷ lệ đúng:</span>
                                <strong>
                                    <fmt:formatNumber value="${quizResult.correctAnswers * 100.0 / (quizResult.correctAnswers + quizResult.incorrectAnswers)}" maxFractionDigits="1" />%
                                </strong>
                            </div>
                            <div class="metric-item d-flex justify-content-between mb-2">
                                <span>Xếp hạng:</span>
                                <strong>
                                    <c:choose>
                                        <c:when test="${quizResult.score / quiz.maxScore >= 0.95}">Xuất sắc</c:when>
                                        <c:when test="${quizResult.score / quiz.maxScore >= 0.85}">Giỏi</c:when>
                                        <c:when test="${quizResult.score / quiz.maxScore >= 0.75}">Khá</c:when>
                                        <c:when test="${quizResult.score / quiz.maxScore >= 0.65}">Trung bình</c:when>
                                        <c:otherwise>Cần cải thiện</c:otherwise>
                                    </c:choose>
                                </strong>
                            </div>
                            <c:if test="${not empty quizResult.rank}">
                                <div class="metric-item d-flex justify-content-between mb-2">
                                    <span>Thứ hạng lớp:</span>
                                    <strong>#${quizResult.rank}</strong>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Certificate Section (nếu đạt) -->
        <c:if test="${quizResult.passed && quiz.issuesCertificate}">
            <div class="performance-chart">
                <h5 class="mb-4">
                    <i class="fas fa-certificate me-2"></i>Chứng Nhận Hoàn Thành
                </h5>
                <div class="certificate-preview">
                    <i class="fas fa-award fa-3x text-warning mb-3"></i>
                    <h6>Chúc mừng bạn đã hoàn thành quiz!</h6>
                    <p class="text-muted mb-3">
                        Bạn đã đạt được ${quizResult.score}/${quiz.maxScore} điểm trong bài kiểm tra "${quiz.title}"
                    </p>
                    <a href="${pageContext.request.contextPath}/student/quiz/${quiz.id}/certificate""
                       class="btn btn-warning">
                        <i class="fas fa-download me-2"></i>Tải Chứng Nhận
                    </a>
                </div>
            </div>
        </c:if>

        <!-- Question Review -->
        <div class="question-review">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5>
                    <i class="fas fa-list-check me-2"></i>Xem Lại Câu Hỏi
                </h5>
                <div class="btn-group" role="group">
                    <input type="radio" class="btn-check" name="filterOptions" id="showAll" checked>
                    <label class="btn btn-outline-secondary" for="showAll">Tất cả</label>

                    <input type="radio" class="btn-check" name="filterOptions" id="showIncorrect">
                    <label class="btn btn-outline-danger" for="showIncorrect">Câu sai</label>

                    <input type="radio" class="btn-check" name="filterOptions" id="showCorrect">
                    <label class="btn btn-outline-success" for="showCorrect">Câu đúng</label>
                </div>
            </div>

            <!-- Questions List -->
            <c:forEach items="${quiz.questions}" var="question" varStatus="status">
                <c:set var="userAnswer" value="${quizResult.userAnswers[question.id]}" />
                <c:set var="isCorrect" value="${userAnswer.correct}" />

                <div class="question-item ${isCorrect ? 'question-correct' : 'question-incorrect'}"
                     data-correct="${isCorrect}">

                    <!-- Question Header -->
                    <div class="question-header">
                        <div>
                            <h6 class="mb-0">
                                Câu ${status.index + 1}
                                <c:if test="${isCorrect}">
                                    <i class="fas fa-check-circle text-success ms-2"></i>
                                </c:if>
                                <c:if test="${not isCorrect}">
                                    <i class="fas fa-times-circle text-danger ms-2"></i>
                                </c:if>
                            </h6>
                        </div>
                        <div>
                            <c:if test="${question.points > 0}">
                                <span class="badge bg-light text-dark">${question.points} điểm</span>
                            </c:if>
                        </div>
                    </div>

                    <!-- Question Body -->
                    <div class="question-body">
                        <!-- Question Text -->
                        <div class="question-text mb-3">
                            <p class="fw-medium">${question.questionText}</p>
                            <c:if test="${not empty question.imageUrl}">
                                <img src="${question.imageUrl}" alt="Hình ảnh câu hỏi"
                                     class="img-fluid rounded mt-2" style="max-height: 200px;">
                            </c:if>
                        </div>

                        <!-- Answer Options -->
                        <div class="answer-options">
                            <c:choose>
                                <!-- Multiple Choice / True False -->
                                <c:when test="${question.type == 'MULTIPLE_CHOICE' || question.type == 'TRUE_FALSE'}">
                                    <c:forEach items="${question.answers}" var="answer" varStatus="answerStatus">
                                        <div class="answer-option
                                            ${answer.correct ? 'answer-correct' : ''}
                                            ${userAnswer.selectedAnswerId == answer.id && not answer.correct ? 'answer-incorrect' : ''}
                                            ${userAnswer.selectedAnswerId == answer.id ? 'answer-selected' : ''}">
                                            <div class="d-flex align-items-center">
                                                <div class="me-3">
                                                    <c:if test="${answer.correct}">
                                                        <i class="fas fa-check-circle text-success"></i>
                                                    </c:if>
                                                    <c:if test="${userAnswer.selectedAnswerId == answer.id && not answer.correct}">
                                                        <i class="fas fa-times-circle text-danger"></i>
                                                    </c:if>
                                                    <c:if test="${userAnswer.selectedAnswerId == answer.id && answer.correct}">
                                                        <i class="fas fa-check-circle text-success"></i>
                                                    </c:if>
                                                </div>
                                                <div class="flex-grow-1">
                                                    <span class="answer-letter fw-bold me-2">
                                                        ${fn:substring("ABCDEFGH", answerStatus.index, answerStatus.index + 1)}.
                                                    </span>
                                                        ${answer.answerText}
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>

                                <!-- Short Answer -->
                                <c:when test="${question.type == 'SHORT_ANSWER'}">
                                    <div class="answer-option answer-selected">
                                        <strong>Câu trả lời của bạn:</strong>
                                        <div class="mt-2">${userAnswer.textAnswer}</div>
                                    </div>
                                    <c:if test="${not empty question.modelAnswer}">
                                        <div class="answer-option answer-correct">
                                            <strong>Câu trả lời mẫu:</strong>
                                            <div class="mt-2">${question.modelAnswer}</div>
                                        </div>
                                    </c:if>
                                </c:when>
                            </c:choose>
                        </div>

                        <!-- Feedback -->
                        <c:if test="${not empty question.explanation}">
                            <div class="feedback-section">
                                <h6><i class="fas fa-lightbulb me-2"></i>Giải thích</h6>
                                <p class="mb-0">${question.explanation}</p>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Improvement Suggestions -->
        <c:if test="${not quizResult.passed || quizResult.score < quiz.maxScore * 0.8}">
            <div class="improvement-suggestions">
                <h5 class="mb-4">
                    <i class="fas fa-lightbulb me-2"></i>Gợi Ý Cải Thiện
                </h5>

                <c:if test="${quizResult.weakTopics.size() > 0}">
                    <div class="suggestion-item">
                        <h6><i class="fas fa-target me-2"></i>Chủ đề cần ôn tập</h6>
                        <p class="mb-2">Bạn nên dành thời gian ôn tập các chủ đề sau:</p>
                        <ul class="mb-0">
                            <c:forEach items="${quizResult.weakTopics}" var="topic">
                                <li>${topic}</li>
                            </c:forEach>
                        </ul>
                    </div>
                </c:if>

                <div class="suggestion-item">
                    <h6><i class="fas fa-book me-2"></i>Tài liệu tham khảo</h6>
                    <p class="mb-2">Xem lại các bài học liên quan:</p>
                    <div class="d-flex gap-2">
                        <c:forEach items="${relatedLessons}" var="lesson" varStatus="status">
                            <a href="${pageContext.request.contextPath}/student/lessons/${lesson.id}"
                               class="btn btn-sm btn-outline-primary">
                                    ${lesson.title}
                            </a>
                            <c:if test="${status.index >= 2}">
                                <span class="text-muted">...</span>
                                <c:set var="break" value="true" />
                            </c:if>
                            <c:if test="${break}"><c:set var="break" value="false" /></c:if>
                        </c:forEach>
                    </div>
                </div>

                <c:if test="${quiz.allowRetake && quizResult.attemptCount < quiz.maxAttempts}">
                    <div class="suggestion-item">
                        <h6><i class="fas fa-redo me-2"></i>Làm lại bài kiểm tra</h6>
                        <p class="mb-2">
                            Bạn có thể làm lại bài kiểm tra này.
                            Còn lại: ${quiz.maxAttempts - quizResult.attemptCount} lần thử
                        </p>
                    </div>
                </c:if>
            </div>
        </c:if>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <div class="d-flex justify-content-center gap-3 flex-wrap">
                <!-- Back to Course -->
                <a href="${pageContext.request.contextPath}/student/courses/${quiz.course.id}"
                   class="btn btn-outline-primary">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại khóa học
                </a>

                <!-- Retake Quiz -->
                <c:if test="${quiz.allowRetake && quizResult.attemptCount < quiz.maxAttempts}">
                    <a href="${pageContext.request.contextPath}/student/quiz/${quiz.id}"
                       class="btn btn-warning">
                        <i class="fas fa-redo me-2"></i>Làm lại bài kiểm tra
                    </a>
                </c:if>

                <!-- Share Result -->
                <button class="btn btn-outline-success" onclick="shareResult()">
                    <i class="fas fa-share me-2"></i>Chia sẻ kết quả
                </button>

                <!-- Print Result -->
                <button class="btn btn-outline-info" onclick="printResult()">
                    <i class="fas fa-print me-2"></i>In kết quả
                </button>

                <!-- Download PDF -->
                <a href="${pageContext.request.contextPath}/student/quiz/${quiz.id}/result/pdf""
                   class="btn btn-outline-secondary">
                    <i class="fas fa-file-pdf me-2"></i>Tải PDF
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Include Footer -->
<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.js"></script>

<script>
    $(document).ready(function() {
        // Khởi tạo biểu đồ
        initializeChart();

        // Hiệu ứng celebration nếu đạt điểm cao
        <c:if test="${quizResult.score >= quiz.maxScore * 0.9}">
        startCelebration();
        </c:if>

        // Setup filter buttons
        setupQuestionFilter();

        // Smooth scroll to anchors
        $('a[href^="#"]').on('click', function(e) {
            e.preventDefault();
            const target = $($(this).attr('href'));
            if (target.length) {
                $('html, body').animate({
                    scrollTop: target.offset().top - 100
                }, 500);
            }
        });
    });

    /**
     * Khởi tạo biểu đồ điểm số
     */
    function initializeChart() {
        const ctx = document.getElementById('scoreChart').getContext('2d');

        const correctCount = ${quizResult.correctAnswers};
        const incorrectCount = ${quizResult.incorrectAnswers};

        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Câu đúng', 'Câu sai'],
                datasets: [{
                    data: [correctCount, incorrectCount],
                    backgroundColor: ['#28a745', '#dc3545'],
                    borderWidth: 0,
                    hoverOffset: 10
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
                            usePointStyle: true
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                const total = correctCount + incorrectCount;
                                const percentage = ((context.parsed / total) * 100).toFixed(1);
                                return context.label + ': ' + context.parsed + ' (' + percentage + '%)';
                            }
                        }
                    }
                },
                cutout: '60%'
            }
        });
    }

    /**
     * Bắt đầu hiệu ứng celebration
     */
    function startCelebration() {
        const overlay = document.getElementById('celebrationOverlay');
        if (!overlay) return;

        // Tạo confetti
        for (let i = 0; i < 50; i++) {
            setTimeout(() => {
                createConfetti(overlay);
            }, i * 100);
        }

        // Tự động tắt sau 5 giây
        setTimeout(() => {
            overlay.style.display = 'none';
        }, 5000);
    }

    /**
     * Tạo confetti
     */
    function createConfetti(container) {
        const confetti = document.createElement('div');
        confetti.className = 'confetti';
        confetti.style.left = Math.random() * 100 + '%';
        confetti.style.backgroundColor = getRandomColor();
        confetti.style.animationDelay = Math.random() * 2 + 's';

        container.appendChild(confetti);

        // Xóa confetti sau khi animation hoàn thành
        setTimeout(() => {
            confetti.remove();
        }, 3000);
    }

    /**
     * Lấy màu ngẫu nhiên cho confetti
     */
    function getRandomColor() {
        const colors = ['#ff6b6b', '#4ecdc4', '#45b7d1', '#96ceb4', '#ffd93d', '#ff9ff3', '#a8e6cf'];
        return colors[Math.floor(Math.random() * colors.length)];
    }

    /**
     * Setup filter cho câu hỏi
     */
    function setupQuestionFilter() {
        $('input[name="filterOptions"]').change(function() {
            const filter = $(this).attr('id');

            $('.question-item').show();

            if (filter === 'showCorrect') {
                $('.question-item[data-correct="false"]').hide();
            } else if (filter === 'showIncorrect') {
                $('.question-item[data-correct="true"]').hide();
            }
        });
    }

    /**
     * Chia sẻ kết quả
     */
    function shareResult() {
        const scorePercentage = Math.round(${quizResult.score} / ${quiz.maxScore} * 100);
        const text = `Tôi vừa hoàn thành bài kiểm tra "${quiz.title}" với điểm số ${quizResult.score}/${quiz.maxScore} (${scorePercentage}%) trên EduLearn Platform!`;

        if (navigator.share) {
            navigator.share({
                title: 'Kết quả Quiz - ${quiz.title}',
                text: text,
                url: window.location.href
            });
        } else {
            // Fallback - copy to clipboard
            navigator.clipboard.writeText(text + '\n' + window.location.href);
            showToast('Đã sao chép kết quả vào clipboard', 'success');
        }
    }

    /**
     * In kết quả
     */
    function printResult() {
        // Ẩn các elements không cần in
        $('.action-buttons, .navbar, .footer').hide();

        // In trang
        window.print();

        // Hiện lại các elements
        $('.action-buttons, .navbar, .footer').show();
    }

    /**
     * Scroll to top smooth
     */
    function scrollToTop() {
        $('html, body').animate({ scrollTop: 0 }, 500);
    }

    /**
     * Hiển thị thông báo toast
     */
    function showToast(message, type = 'info') {
        const toastContainer = document.getElementById('toast-container') || createToastContainer();

        const toast = document.createElement('div');
        toast.className = `toast align-items-center text-white bg-${type === 'error' ? 'danger' : 'success'} border-0`;
        toast.setAttribute('role', 'alert');
        toast.innerHTML = `
        <div class="d-flex">
            <div class="toast-body">
                <i class="fas fa-${type === 'error' ? 'exclamation-circle' : 'check-circle'} me-2"></i>
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

    // Floating action button cho scroll to top
    $(window).scroll(function() {
        if ($(this).scrollTop() > 200) {
            if (!$('#scrollTopBtn').length) {
                $('body').append(`
                <button id="scrollTopBtn" class="btn btn-primary rounded-circle"
                        style="position: fixed; bottom: 20px; right: 20px; width: 50px; height: 50px; z-index: 999;"
                        onclick="scrollToTop()">
                    <i class="fas fa-arrow-up"></i>
                </button>
            `);
            }
        } else {
            $('#scrollTopBtn').remove();
        }
    });
</script>

</body>
</html>