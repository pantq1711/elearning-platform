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
    <title>${quiz.title} - Chi Tiết Bài Kiểm Tra - EduLearn Platform</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        /* Biến CSS cho theme */
        :root {
            --primary-color: #4f46e5;
            --primary-dark: #3730a3;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --light-bg: #f8fafc;
            --border-color: #e2e8f0;
            --text-primary: #1e293b;
            --text-secondary: #64748b;
            --sidebar-width: 280px;
        }

        body {
            background-color: var(--light-bg);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
        }

        /* Layout chính */
        .dashboard-layout {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            margin-left: var(--sidebar-width);
            padding: 2rem;
            background: var(--light-bg);
        }

        /* Header */
        .quiz-header {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            border: 1px solid var(--border-color);
            position: relative;
            overflow: hidden;
        }

        .quiz-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, var(--warning-color), #d97706);
        }

        .breadcrumb {
            background: transparent;
            padding: 0;
            margin-bottom: 1rem;
        }

        .breadcrumb-item a {
            color: var(--primary-color);
            text-decoration: none;
        }

        .breadcrumb-item.active {
            color: var(--text-secondary);
        }

        .quiz-title-section {
            display: flex;
            gap: 2rem;
            align-items: flex-start;
        }

        .quiz-icon-large {
            width: 80px;
            height: 80px;
            border-radius: 1rem;
            background: linear-gradient(135deg, var(--warning-color), #d97706);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: white;
            flex-shrink: 0;
        }

        .quiz-info {
            flex: 1;
        }

        .quiz-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
            line-height: 1.3;
        }

        .quiz-meta {
            display: flex;
            gap: 2rem;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--text-secondary);
            font-size: 0.9rem;
        }

        .quiz-status {
            padding: 0.5rem 1rem;
            border-radius: 2rem;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .status-active {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success-color);
            border: 1px solid rgba(16, 185, 129, 0.3);
        }

        .status-inactive {
            background: rgba(107, 114, 128, 0.1);
            color: #6b7280;
            border: 1px solid rgba(107, 114, 128, 0.3);
        }

        .quiz-actions {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
            flex-wrap: wrap;
        }

        .btn-custom {
            padding: 0.75rem 1.5rem;
            border-radius: 0.75rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
            border: 1px solid;
            font-size: 0.9rem;
        }

        .btn-primary-custom {
            background: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }

        .btn-primary-custom:hover {
            background: var(--primary-dark);
            border-color: var(--primary-dark);
            color: white;
            transform: translateY(-2px);
        }

        .btn-outline-custom {
            background: transparent;
            border-color: var(--border-color);
            color: var(--text-primary);
        }

        .btn-outline-custom:hover {
            background: var(--light-bg);
            color: var(--text-primary);
        }

        .btn-success-custom {
            background: var(--success-color);
            border-color: var(--success-color);
            color: white;
        }

        .btn-success-custom:hover {
            background: #059669;
            border-color: #059669;
            color: white;
        }

        .btn-warning-custom {
            background: var(--warning-color);
            border-color: var(--warning-color);
            color: white;
        }

        .btn-warning-custom:hover {
            background: #d97706;
            border-color: #d97706;
            color: white;
        }

        .btn-danger-custom {
            background: var(--danger-color);
            border-color: var(--danger-color);
            color: white;
        }

        .btn-danger-custom:hover {
            background: #dc2626;
            border-color: #dc2626;
            color: white;
        }

        /* Content sections */
        .content-section {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            border: 1px solid var(--border-color);
            margin-bottom: 2rem;
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        /* Statistics cards */
        .quiz-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            border: 1px solid var(--border-color);
            text-align: center;
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 1rem;
            margin: 0 auto 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
        }

        .stat-icon.primary {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
        }

        .stat-icon.success {
            background: linear-gradient(135deg, var(--success-color), #059669);
        }

        .stat-icon.warning {
            background: linear-gradient(135deg, var(--warning-color), #d97706);
        }

        .stat-icon.danger {
            background: linear-gradient(135deg, var(--danger-color), #dc2626);
        }

        .stat-number {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }

        .stat-label {
            color: var(--text-secondary);
            font-size: 0.9rem;
            font-weight: 500;
        }

        /* Tabs */
        .nav-tabs-custom {
            border: none;
            margin-bottom: 2rem;
            background: white;
            border-radius: 1rem;
            padding: 0.5rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .nav-tabs-custom .nav-link {
            border: none;
            border-radius: 0.75rem;
            color: var(--text-secondary);
            font-weight: 500;
            padding: 1rem 1.5rem;
            transition: all 0.3s ease;
        }

        .nav-tabs-custom .nav-link:hover {
            color: var(--primary-color);
            background: rgba(79, 70, 229, 0.05);
        }

        .nav-tabs-custom .nav-link.active {
            background: var(--primary-color);
            color: white;
        }

        /* Questions section */
        .questions-list {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .question-card {
            background: var(--light-bg);
            border: 1px solid var(--border-color);
            border-radius: 1rem;
            padding: 1.5rem;
            transition: all 0.3s ease;
        }

        .question-card:hover {
            background: white;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .question-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .question-number {
            background: var(--warning-color);
            color: white;
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .question-type {
            padding: 0.25rem 0.75rem;
            border-radius: 2rem;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .type-multiple-choice {
            background: rgba(79, 70, 229, 0.1);
            color: var(--primary-color);
        }

        .type-true-false {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success-color);
        }

        .type-short-answer {
            background: rgba(245, 158, 11, 0.1);
            color: var(--warning-color);
        }

        .question-content {
            margin-bottom: 1rem;
        }

        .question-text {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
            line-height: 1.6;
        }

        .question-options {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .option-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem;
            background: white;
            border-radius: 0.5rem;
            border: 1px solid var(--border-color);
        }

        .option-item.correct {
            background: rgba(16, 185, 129, 0.05);
            border-color: var(--success-color);
        }

        .option-indicator {
            width: 20px;
            height: 20px;
            border-radius: 50%;
            border: 2px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .option-item.correct .option-indicator {
            background: var(--success-color);
            border-color: var(--success-color);
            color: white;
        }

        .option-text {
            flex: 1;
            color: var(--text-primary);
        }

        /* Results table */
        .results-table-container {
            overflow-x: auto;
        }

        .table-custom {
            margin-bottom: 0;
        }

        .table-custom th {
            background: var(--light-bg);
            border: none;
            font-weight: 600;
            color: var(--text-primary);
            padding: 1rem;
            border-bottom: 2px solid var(--border-color);
        }

        .table-custom td {
            border: none;
            padding: 1rem;
            vertical-align: middle;
            border-bottom: 1px solid var(--border-color);
        }

        .table-custom tbody tr:hover {
            background: rgba(79, 70, 229, 0.02);
        }

        .student-info {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .student-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            flex-shrink: 0;
        }

        .student-name {
            font-weight: 600;
            color: var(--text-primary);
        }

        .student-email {
            color: var(--text-secondary);
            font-size: 0.85rem;
        }

        .score-badge {
            padding: 0.375rem 0.75rem;
            border-radius: 2rem;
            font-weight: 600;
            font-size: 0.85rem;
        }

        .score-excellent {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success-color);
        }

        .score-good {
            background: rgba(79, 70, 229, 0.1);
            color: var(--primary-color);
        }

        .score-average {
            background: rgba(245, 158, 11, 0.1);
            color: var(--warning-color);
        }

        .score-poor {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger-color);
        }

        /* Charts */
        .charts-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .chart-card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            border: 1px solid var(--border-color);
        }

        .chart-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .chart-container {
            position: relative;
            height: 300px;
        }

        /* Alert messages */
        .alert-custom {
            border-radius: 0.75rem;
            border: none;
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .alert-success {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success-color);
            border-left: 4px solid var(--success-color);
        }

        .alert-danger {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger-color);
            border-left: 4px solid var(--danger-color);
        }

        .alert-warning {
            background: rgba(245, 158, 11, 0.1);
            color: var(--warning-color);
            border-left: 4px solid var(--warning-color);
        }

        /* Empty state */
        .empty-state {
            text-align: center;
            padding: 3rem 2rem;
            color: var(--text-secondary);
        }

        .empty-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .empty-title {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--text-primary);
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .main-content {
                margin-left: 0;
                padding: 1rem;
            }

            .quiz-title-section {
                flex-direction: column;
                gap: 1rem;
            }

            .quiz-icon-large {
                width: 60px;
                height: 60px;
                font-size: 1.5rem;
                align-self: center;
            }

            .quiz-stats {
                grid-template-columns: repeat(2, 1fr);
            }

            .charts-section {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .quiz-header {
                padding: 1.5rem;
            }

            .content-section {
                padding: 1.5rem;
            }

            .quiz-actions {
                flex-direction: column;
            }

            .btn-custom {
                justify-content: center;
            }

            .quiz-stats {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>
<div class="dashboard-layout">
    <!-- Include Sidebar -->
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

    <!-- Main Content -->
    <div class="main-content">
        <!-- Quiz Header -->
        <div class="quiz-header">
            <!-- Breadcrumb -->
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/instructor/dashboard">
                            <i class="fas fa-home me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/instructor/courses">Khóa học</a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/instructor/courses/${quiz.course.id}">
                            ${quiz.course.name}
                        </a>
                    </li>
                    <li class="breadcrumb-item active">${quiz.title}</li>
                </ol>
            </nav>

            <!-- Quiz Title Section -->
            <div class="quiz-title-section">
                <div class="quiz-icon-large">
                    <i class="fas fa-question-circle"></i>
                </div>

                <div class="quiz-info">
                    <h1 class="quiz-title">${quiz.title}</h1>

                    <div class="quiz-meta">
                        <div class="meta-item">
                            <i class="fas fa-book"></i>
                            <span>${quiz.course.name}</span>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-question"></i>
                            <span>${quiz.questionCount != null ? quiz.questionCount : fn:length(quiz.questions)} câu hỏi</span>
                        </div>
                        <c:if test="${quiz.timeLimit != null && quiz.timeLimit > 0}">
                            <div class="meta-item">
                                <i class="fas fa-clock"></i>
                                <span>${quiz.timeLimit} phút</span>
                            </div>
                        </c:if>
                        <div class="meta-item">
                            <i class="fas fa-target"></i>
                            <span>Điểm đạt: ${quiz.passingScore != null ? quiz.passingScore : 70}%</span>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-calendar"></i>
                            <span><fmt:formatDate value="${quiz.createdAt}" pattern="dd/MM/yyyy" /></span>
                        </div>
                        <div class="meta-item">
                            <span class="quiz-status ${quiz.active ? 'status-active' : 'status-inactive'}">
                                <i class="fas fa-${quiz.active ? 'check-circle' : 'times-circle'}"></i>
                                ${quiz.active ? 'Hoạt động' : 'Tạm dừng'}
                            </span>
                        </div>
                    </div>

                    <c:if test="${not empty quiz.description}">
                        <p style="color: var(--text-secondary); line-height: 1.6; margin-bottom: 1rem;">
                                ${quiz.description}
                        </p>
                    </c:if>

                    <div class="quiz-actions">
                        <a href="${pageContext.request.contextPath}/instructor/quizzes/${quiz.id}/edit"
                           class="btn-custom btn-primary-custom">
                            <i class="fas fa-edit"></i>
                            Chỉnh sửa bài kiểm tra
                        </a>

                        <c:if test="${!quiz.active}">
                            <button type="button"
                                    class="btn-custom btn-success-custom"
                                    onclick="toggleQuizStatus(${quiz.id}, true)">
                                <i class="fas fa-play"></i>
                                Kích hoạt
                            </button>
                        </c:if>

                        <c:if test="${quiz.active}">
                            <button type="button"
                                    class="btn-custom btn-warning-custom"
                                    onclick="toggleQuizStatus(${quiz.id}, false)">
                                <i class="fas fa-pause"></i>
                                Tạm dừng
                            </button>
                        </c:if>

                        <a href="${pageContext.request.contextPath}/quiz/${quiz.id}"
                           class="btn-custom btn-outline-custom"
                           target="_blank">
                            <i class="fas fa-external-link-alt"></i>
                            Xem như học viên
                        </a>

                        <button type="button"
                                class="btn-custom btn-outline-custom"
                                onclick="exportResults()">
                            <i class="fas fa-download"></i>
                            Xuất kết quả
                        </button>

                        <button type="button"
                                class="btn-custom btn-danger-custom"
                                onclick="deleteQuiz(${quiz.id}, '${quiz.title}')">
                            <i class="fas fa-trash"></i>
                            Xóa bài kiểm tra
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Alert Messages -->
        <c:if test="${not empty success}">
            <div class="alert-custom alert-success">
                <i class="fas fa-check-circle"></i>
                <span>${success}</span>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert-custom alert-danger">
                <i class="fas fa-exclamation-triangle"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <c:if test="${not empty warning}">
            <div class="alert-custom alert-warning">
                <i class="fas fa-exclamation-triangle"></i>
                <span>${warning}</span>
            </div>
        </c:if>

        <!-- Statistics -->
        <div class="quiz-stats">
            <div class="stat-card">
                <div class="stat-icon primary">
                    <i class="fas fa-users"></i>
                </div>
                <div class="stat-number">${quizStats.totalAttempts}</div>
                <div class="stat-label">Lượt làm bài</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon success">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-number">${quizStats.passedAttempts}</div>
                <div class="stat-label">Bài đạt</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon warning">
                    <i class="fas fa-percentage"></i>
                </div>
                <div class="stat-number">${quizStats.averageScore}%</div>
                <div class="stat-label">Điểm trung bình</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon danger">
                    <i class="fas fa-chart-line"></i>
                </div>
                <div class="stat-number">${quizStats.passRate}%</div>
                <div class="stat-label">Tỷ lệ đạt</div>
            </div>
        </div>

        <!-- Charts -->
        <div class="charts-section">
            <!-- Score Distribution -->
            <div class="chart-card">
                <h3 class="chart-title">
                    <i class="fas fa-chart-bar"></i>
                    Phân bố điểm số
                </h3>
                <div class="chart-container">
                    <canvas id="scoreChart"></canvas>
                </div>
            </div>

            <!-- Performance Trends -->
            <div class="chart-card">
                <h3 class="chart-title">
                    <i class="fas fa-chart-line"></i>
                    Xu hướng hiệu suất
                </h3>
                <div class="chart-container">
                    <canvas id="performanceChart"></canvas>
                </div>
            </div>
        </div>

        <!-- Tabs Navigation -->
        <ul class="nav nav-tabs nav-tabs-custom" id="quizDetailTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="questions-tab" data-bs-toggle="tab"
                        data-bs-target="#questions" type="button" role="tab">
                    <i class="fas fa-list me-2"></i>Câu hỏi (${fn:length(quiz.questions)})
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="results-tab" data-bs-toggle="tab"
                        data-bs-target="#results" type="button" role="tab">
                    <i class="fas fa-chart-bar me-2"></i>Kết quả (${fn:length(quizResults)})
                </button>
            </li>
        </ul>

        <!-- Tab Content -->
        <div class="tab-content" id="quizDetailTabsContent">
            <!-- Questions Tab -->
            <div class="tab-pane fade show active" id="questions" role="tabpanel">
                <div class="content-section">
                    <h3 class="section-title">
                        <i class="fas fa-question-circle"></i>
                        Danh sách câu hỏi
                    </h3>

                    <c:choose>
                        <c:when test="${not empty quiz.questions}">
                            <div class="questions-list">
                                <c:forEach items="${quiz.questions}" var="question" varStatus="status">
                                    <div class="question-card">
                                        <div class="question-header">
                                            <div class="question-number">${status.index + 1}</div>
                                            <div class="question-type type-${fn:toLowerCase(fn:replace(question.type, '_', '-'))}">
                                                <c:choose>
                                                    <c:when test="${question.type == 'MULTIPLE_CHOICE'}">
                                                        <i class="fas fa-list"></i> Trắc nghiệm
                                                    </c:when>
                                                    <c:when test="${question.type == 'TRUE_FALSE'}">
                                                        <i class="fas fa-check-circle"></i> Đúng/Sai
                                                    </c:when>
                                                    <c:when test="${question.type == 'SHORT_ANSWER'}">
                                                        <i class="fas fa-keyboard"></i> Tự luận ngắn
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${question.type}
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div class="question-content">
                                            <div class="question-text">
                                                    ${question.question}
                                            </div>

                                            <c:if test="${question.type == 'MULTIPLE_CHOICE' || question.type == 'TRUE_FALSE'}">
                                                <div class="question-options">
                                                    <c:forEach items="${question.options}" var="option" varStatus="optionStatus">
                                                        <div class="option-item ${option.correct ? 'correct' : ''}">
                                                            <div class="option-indicator">
                                                                <c:if test="${option.correct}">
                                                                    <i class="fas fa-check"></i>
                                                                </c:if>
                                                            </div>
                                                            <div class="option-text">
                                                                <strong>${String.fromCharCode(65 + optionStatus.index)}.</strong> ${option.text}
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:if>

                                            <c:if test="${question.type == 'SHORT_ANSWER'}">
                                                <div class="question-options">
                                                    <div class="option-item correct">
                                                        <div class="option-indicator">
                                                            <i class="fas fa-key"></i>
                                                        </div>
                                                        <div class="option-text">
                                                            <strong>Đáp án mẫu:</strong>
                                                                ${not empty question.options && fn:length(question.options) > 0 ? question.options[0].text : 'Chưa có đáp án mẫu'}
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <div class="empty-icon">
                                    <i class="fas fa-question-circle"></i>
                                </div>
                                <div class="empty-title">Chưa có câu hỏi nào</div>
                                <p>Hãy chỉnh sửa bài kiểm tra để thêm câu hỏi!</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Results Tab -->
            <div class="tab-pane fade" id="results" role="tabpanel">
                <div class="content-section">
                    <h3 class="section-title">
                        <i class="fas fa-chart-bar"></i>
                        Kết quả làm bài
                    </h3>

                    <c:choose>
                        <c:when test="${not empty quizResults}">
                            <div class="results-table-container">
                                <table class="table table-custom" id="resultsTable">
                                    <thead>
                                    <tr>
                                        <th>Học viên</th>
                                        <th>Điểm số</th>
                                        <th>Trạng thái</th>
                                        <th>Thời gian làm bài</th>
                                        <th>Ngày làm</th>
                                        <th>Hành động</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${quizResults}" var="result">
                                        <tr>
                                            <!-- Student Info -->
                                            <td>
                                                <div class="student-info">
                                                    <div class="student-avatar">
                                                            ${fn:substring(result.student.fullName, 0, 1)}
                                                    </div>
                                                    <div>
                                                        <div class="student-name">${result.student.fullName}</div>
                                                        <div class="student-email">${result.student.email}</div>
                                                    </div>
                                                </div>
                                            </td>

                                            <!-- Score -->
                                            <td>
                                                    <span class="score-badge ${result.score >= 90 ? 'score-excellent' : result.score >= 70 ? 'score-good' : result.score >= 50 ? 'score-average' : 'score-poor'}">
                                                        ${result.score}%
                                                    </span>
                                            </td>

                                            <!-- Status -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${result.passed}">
                                                            <span class="badge bg-success">
                                                                <i class="fas fa-check"></i> Đạt
                                                            </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                            <span class="badge bg-danger">
                                                                <i class="fas fa-times"></i> Không đạt
                                                            </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Duration -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${result.timeSpent != null}">
                                                            <span class="text-muted">
                                                                <i class="fas fa-clock me-1"></i>
                                                                ${result.timeSpent} phút
                                                            </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">--</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Date -->
                                            <td>
                                                    <span class="text-muted">
                                                        <fmt:formatDate value="${result.submittedAt}" pattern="dd/MM/yyyy HH:mm" />
                                                    </span>
                                            </td>

                                            <!-- Actions -->
                                            <td>
                                                <a href="${pageContext.request.contextPath}/instructor/quiz-results/${result.id}"
                                                   class="btn btn-sm btn-outline-primary">
                                                    <i class="fas fa-eye"></i>
                                                    Chi tiết
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <div class="empty-icon">
                                    <i class="fas fa-chart-bar"></i>
                                </div>
                                <div class="empty-title">Chưa có kết quả nào</div>
                                <p>Chưa có học viên nào làm bài kiểm tra này.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>

<script>
    $(document).ready(function() {
        // Khởi tạo DataTable cho bảng kết quả
        if ($('#resultsTable tbody tr').length > 0) {
            $('#resultsTable').DataTable({
                language: {
                    url: 'https://cdn.datatables.net/plug-ins/1.13.4/i18n/vi.json'
                },
                pageLength: 15,
                order: [[4, 'desc']], // Sắp xếp theo ngày làm bài
                columnDefs: [
                    { orderable: false, targets: [5] } // Không sắp xếp cột hành động
                ]
            });
        }

        // Khởi tạo biểu đồ
        initCharts();

        // Animation cho stats cards
        $('.stat-card').each(function(index) {
            $(this).css({
                'opacity': '0',
                'transform': 'translateY(20px)'
            });

            setTimeout(() => {
                $(this).css({
                    'transition': 'all 0.5s ease',
                    'opacity': '1',
                    'transform': 'translateY(0)'
                });
            }, index * 150);
        });

        // Animation cho question cards
        $('.question-card').each(function(index) {
            $(this).css({
                'opacity': '0',
                'transform': 'translateY(20px)'
            });

            setTimeout(() => {
                $(this).css({
                    'transition': 'all 0.5s ease',
                    'opacity': '1',
                    'transform': 'translateY(0)'
                });
            }, index * 100);
        });
    });

    /**
     * Khởi tạo biểu đồ
     */
    function initCharts() {
        // Score Distribution Chart
        const scoreCtx = document.getElementById('scoreChart').getContext('2d');
        const scoreChart = new Chart(scoreCtx, {
            type: 'bar',
            data: {
                labels: ['0-39%', '40-59%', '60-79%', '80-89%', '90-100%'],
                datasets: [{
                    label: 'Số lượng',
                    data: [${scoreDistribution}], // Dữ liệu từ controller
                    backgroundColor: [
                        '#ef4444',
                        '#f59e0b',
                        '#10b981',
                        '#3b82f6',
                        '#8b5cf6'
                    ],
                    borderWidth: 0,
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: '#e2e8f0'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });

        // Performance Trends Chart
        const performanceCtx = document.getElementById('performanceChart').getContext('2d');
        const performanceChart = new Chart(performanceCtx, {
            type: 'line',
            data: {
                labels: ['Tuần 1', 'Tuần 2', 'Tuần 3', 'Tuần 4'],
                datasets: [{
                    label: 'Điểm trung bình',
                    data: [${performanceTrends}], // Dữ liệu từ controller
                    borderColor: '#4f46e5',
                    backgroundColor: 'rgba(79, 70, 229, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 100,
                        grid: {
                            color: '#e2e8f0'
                        }
                    },
                    x: {
                        grid: {
                            color: '#e2e8f0'
                        }
                    }
                }
            }
        });
    }

    /**
     * Thay đổi trạng thái bài kiểm tra
     */
    function toggleQuizStatus(quizId, newStatus) {
        const statusText = newStatus ? 'kích hoạt' : 'tạm dừng';

        if (confirm(`Bạn có chắc muốn ${statusText} bài kiểm tra này?`)) {
            $.ajax({
                url: `${pageContext.request.contextPath}/instructor/quizzes/${quizId}/toggle-status`,
                method: 'POST',
                data: {
                    active: newStatus,
                    '${_csrf.parameterName}': '${_csrf.token}'
                },
                success: function(response) {
                    showToast(`${statusText.charAt(0).toUpperCase() + statusText.slice(1)} bài kiểm tra thành công!`, 'success');

                    // Reload page sau 1 giây
                    setTimeout(() => {
                        location.reload();
                    }, 1000);
                },
                error: function(xhr) {
                    showToast('Có lỗi xảy ra khi thay đổi trạng thái bài kiểm tra!', 'error');
                }
            });
        }
    }

    /**
     * Xóa bài kiểm tra
     */
    function deleteQuiz(quizId, quizTitle) {
        if (confirm(`Bạn có chắc muốn xóa bài kiểm tra "${quizTitle}"?\n\nHành động này sẽ xóa tất cả câu hỏi và kết quả làm bài. Không thể hoàn tác!`)) {
            $.ajax({
                url: `${pageContext.request.contextPath}/instructor/quizzes/${quizId}/delete`,
                method: 'POST',
                data: {
                    '${_csrf.parameterName}': '${_csrf.token}'
                },
                success: function(response) {
                    showToast('Xóa bài kiểm tra thành công!', 'success');

                    // Chuyển hướng về trang khóa học sau 1 giây
                    setTimeout(() => {
                        window.location.href = '${pageContext.request.contextPath}/instructor/courses/${quiz.course.id}';
                    }, 1000);
                },
                error: function(xhr) {
                    const errorMessage = xhr.responseJSON ? xhr.responseJSON.message : 'Có lỗi xảy ra khi xóa bài kiểm tra!';
                    showToast(errorMessage, 'error');
                }
            });
        }
    }

    /**
     * Xuất kết quả
     */
    function exportResults() {
        window.open(`${pageContext.request.contextPath}/instructor/quizzes/${quiz.id}/export-results`, '_blank');
    }

    /**
     * Hiển thị toast notification
     */
    function showToast(message, type = 'info') {
        const bgClass = type === 'success' ? 'bg-success' :
            type === 'error' ? 'bg-danger' : 'bg-info';

        const toast = $(`
            <div class="toast align-items-center text-white ${bgClass} border-0" role="alert"
                 style="position: fixed; top: 20px; right: 20px; z-index: 1055;">
                <div class="d-flex">
                    <div class="toast-body">
                        <i class="fas fa-${type eq 'success' ? 'check' : type eq 'error' ? 'exclamation-triangle' : 'info'}-circle me-2"></i>
                        ${message}
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto"
                            onclick="$(this).closest('.toast').remove()"></button>
                </div>
            </div>
        `);

        $('body').append(toast);

        setTimeout(() => {
            toast.remove();
        }, 5000);
    }

    // Copy quiz link function
    function copyQuizLink() {
        const link = `${window.location.origin}${pageContext.request.contextPath}/quiz/${quiz.id}`;
        navigator.clipboard.writeText(link).then(function() {
            showToast('Đã copy link bài kiểm tra!', 'success');
        });
    }

    // Reset quiz attempts function
    function resetQuizAttempts() {
        if (confirm('Bạn có chắc muốn xóa tất cả kết quả làm bài?\n\nHành động này không thể hoàn tác!')) {
            $.ajax({
                url: `${pageContext.request.contextPath}/instructor/quizzes/${quiz.id}/reset-attempts`,
                method: 'POST',
                data: {
                    '${_csrf.parameterName}': '${_csrf.token}'
                },
                success: function(response) {
                    showToast('Đã xóa tất cả kết quả làm bài!', 'success');
                    setTimeout(() => {
                        location.reload();
                    }, 1000);
                },
                error: function(xhr) {
                    showToast('Có lỗi xảy ra!', 'error');
                }
            });
        }
    }
</script>

</body>
</html>