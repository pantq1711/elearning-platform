<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Học viên - EduCourse</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        /* CSS tùy chỉnh cho dashboard học viên */
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #28a745;
            --info-color: #17a2b8;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --dark-color: #343a40;
            --light-color: #f8f9fa;
        }

        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .navbar-brand {
            font-weight: 700;
            color: var(--primary-color) !important;
        }

        .sidebar {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            min-height: 100vh;
            padding: 0;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }

        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.9);
            padding: 1rem 1.5rem;
            border-radius: 0;
            transition: all 0.3s ease;
            border-left: 4px solid transparent;
        }

        .sidebar .nav-link:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border-left-color: white;
        }

        .sidebar .nav-link.active {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border-left-color: white;
            font-weight: 600;
        }

        .sidebar .nav-link i {
            width: 20px;
            margin-right: 10px;
        }

        .main-content {
            padding: 0;
        }

        .content-header {
            background: white;
            padding: 1.5rem 2rem;
            border-bottom: 1px solid #dee2e6;
            margin-bottom: 2rem;
        }

        .page-title {
            color: var(--dark-color);
            font-weight: 700;
            margin: 0;
        }

        .breadcrumb {
            background: none;
            padding: 0;
            margin: 0;
        }

        .stats-card {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
            border-left: 4px solid;
        }

        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2);
        }

        .stats-card.primary { border-left-color: var(--primary-color); }
        .stats-card.success { border-left-color: var(--success-color); }
        .stats-card.info { border-left-color: var(--info-color); }
        .stats-card.warning { border-left-color: var(--warning-color); }

        .stats-number {
            font-size: 3rem;
            font-weight: 700;
            line-height: 1;
            margin-bottom: 0.5rem;
        }

        .stats-number.primary { color: var(--primary-color); }
        .stats-number.success { color: var(--success-color); }
        .stats-number.info { color: var(--info-color); }
        .stats-number.warning { color: var(--warning-color); }

        .stats-label {
            color: #6c757d;
            font-size: 1.1rem;
            font-weight: 500;
        }

        .stats-icon {
            font-size: 3rem;
            opacity: 0.1;
            position: absolute;
            top: 1rem;
            right: 1rem;
        }

        .chart-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }

        .chart-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 1.5rem;
        }

        .course-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: all 0.3s ease;
            margin-bottom: 1.5rem;
            border-left: 5px solid var(--primary-color);
        }

        .course-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2);
        }

        .course-header {
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
            padding: 1.5rem;
            border-bottom: 1px solid #f1f3f4;
        }

        .course-body {
            padding: 1.5rem;
        }

        .course-title {
            font-size: 1.2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: var(--dark-color);
        }

        .course-instructor {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }

        .progress-section {
            margin-top: 1rem;
        }

        .progress-label {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 0.5rem;
        }

        .progress-text {
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--dark-color);
        }

        .progress-percentage {
            font-size: 0.8rem;
            color: var(--primary-color);
            font-weight: 600;
        }

        .progress {
            height: 8px;
            border-radius: 10px;
            background: #f1f3f4;
        }

        .progress-bar {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            border-radius: 10px;
        }

        .quick-action-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: all 0.3s ease;
            border: 2px solid transparent;
            height: 100%;
        }

        .quick-action-card:hover {
            border-color: var(--primary-color);
            transform: translateY(-3px);
        }

        .quick-action-icon {
            font-size: 3rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        .content-wrapper {
            padding: 2rem;
        }

        .alert-custom {
            border: none;
            border-radius: 10px;
            padding: 1rem 1.5rem;
        }

        .welcome-card {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .welcome-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .welcome-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .achievement-badge {
            background: var(--warning-color);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
            margin: 0.25rem;
        }

        .quiz-result-item {
            display: flex;
            align-items: center;
            padding: 1rem;
            border-bottom: 1px solid #f1f3f4;
            transition: background-color 0.3s ease;
        }

        .quiz-result-item:hover {
            background-color: #f8f9fa;
        }

        .quiz-result-item:last-child {
            border-bottom: none;
        }

        .quiz-icon {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            margin-right: 1rem;
            color: white;
        }

        .quiz-icon.passed {
            background: var(--success-color);
        }

        .quiz-icon.failed {
            background: var(--danger-color);
        }

        .quiz-info {
            flex: 1;
        }

        .quiz-name {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 0.25rem;
        }

        .quiz-course {
            font-size: 0.9rem;
            color: #6c757d;
        }

        .quiz-score {
            text-align: right;
        }

        .score-value {
            font-size: 1.2rem;
            font-weight: 700;
        }

        .score-value.passed {
            color: var(--success-color);
        }

        .score-value.failed {
            color: var(--danger-color);
        }

        .score-date {
            font-size: 0.8rem;
            color: #6c757d;
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .learning-streak {
            background: linear-gradient(135deg, var(--warning-color) 0%, #fd7e14 100%);
            color: white;
            border-radius: 15px;
            padding: 1.5rem;
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .streak-number {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .streak-text {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        @media (max-width: 768px) {
            .sidebar {
                position: fixed;
                top: 0;
                left: -100%;
                width: 280px;
                z-index: 1000;
                transition: left 0.3s ease;
            }

            .sidebar.show {
                left: 0;
            }

            .main-content {
                margin-left: 0;
            }

            .content-wrapper {
                padding: 1rem;
            }

            .welcome-title {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar - Menu điều hướng -->
        <nav class="col-md-3 col-lg-2 sidebar">
            <div class="text-center py-4">
                <h4 class="text-white mb-0">
                    <i class="fas fa-graduation-cap me-2"></i>
                    EduCourse
                </h4>
                <small class="text-white-50">Student Panel</small>
            </div>

            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link active" href="/student/dashboard">
                        <i class="fas fa-tachometer-alt"></i>
                        Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/student/courses">
                        <i class="fas fa-search"></i>
                        Tìm khóa học
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/student/my-courses">
                        <i class="fas fa-book"></i>
                        Khóa học của tôi
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/student/progress">
                        <i class="fas fa-chart-line"></i>
                        Tiến độ học tập
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/student/certificates">
                        <i class="fas fa-certificate"></i>
                        Chứng chỉ
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/student/results">
                        <i class="fas fa-poll"></i>
                        Kết quả bài kiểm tra
                    </a>
                </li>
                <li class="nav-item mt-4">
                    <a class="nav-link" href="/">
                        <i class="fas fa-home"></i>
                        Về trang chủ
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/logout">
                        <i class="fas fa-sign-out-alt"></i>
                        Đăng xuất
                    </a>
                </li>
            </ul>
        </nav>

        <!-- Main Content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 main-content">
            <!-- Content Header -->
            <div class="content-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="page-title">Dashboard Học viên</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="/student/dashboard">Student</a></li>
                                <li class="breadcrumb-item active">Dashboard</li>
                            </ol>
                        </nav>
                    </div>
                    <div class="text-end">
                        <span class="text-muted">Xin chào, </span>
                        <strong>${currentUser.username}</strong>
                        <br>
                        <small class="text-muted">
                            <i class="fas fa-clock me-1"></i>
                            <span id="currentTime"></span>
                        </small>
                    </div>
                </div>
            </div>

            <div class="content-wrapper">
                <!-- Hiển thị thông báo -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-custom">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                            ${error}
                    </div>
                </c:if>

                <c:if test="${not empty message}">
                    <div class="alert alert-success alert-custom">
                        <i class="fas fa-check-circle me-2"></i>
                            ${message}
                    </div>
                </c:if>

                <!-- Welcome Card -->
                <div class="welcome-card">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h2 class="welcome-title">Chào mừng trở lại!</h2>
                            <p class="welcome-subtitle mb-0">
                                Hãy tiếp tục hành trình học tập của bạn. Mỗi ngày là một cơ hội để học hỏi điều mới mẻ!
                            </p>
                        </div>
                        <div class="text-end">
                            <i class="fas fa-user-graduate" style="font-size: 4rem; opacity: 0.3;"></i>
                        </div>
                    </div>
                </div>

                <!-- Statistics Cards - Thống kê tổng quan -->
                <div class="row mb-4">
                    <div class="col-xl-3 col-lg-6 col-md-6 mb-4">
                        <div class="stats-card primary position-relative">
                            <div class="stats-number primary">${enrollmentStats.totalEnrollments}</div>
                            <div class="stats-label">Khóa học đã đăng ký</div>
                            <i class="fas fa-book stats-icon"></i>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-6 col-md-6 mb-4">
                        <div class="stats-card success position-relative">
                            <div class="stats-number success">${enrollmentStats.completedCourses}</div>
                            <div class="stats-label">Khóa học hoàn thành</div>
                            <i class="fas fa-certificate stats-icon"></i>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-6 col-md-6 mb-4">
                        <div class="stats-card info position-relative">
                            <div class="stats-number info">${enrollmentStats.inProgressCourses}</div>
                            <div class="stats-label">Đang học</div>
                            <i class="fas fa-play-circle stats-icon"></i>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-6 col-md-6 mb-4">
                        <div class="stats-card warning position-relative">
                            <div class="stats-number warning">
                                <c:choose>
                                    <c:when test="${enrollmentStats.totalEnrollments > 0}">
                                        <fmt:formatNumber value="${(enrollmentStats.completedCourses * 100) / enrollmentStats.totalEnrollments}" maxFractionDigits="0"/>%
                                    </c:when>
                                    <c:otherwise>0%</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="stats-label">Tỷ lệ hoàn thành</div>
                            <i class="fas fa-chart-pie stats-icon"></i>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <!-- Left Column - Courses & Progress -->
                    <div class="col-lg-8 mb-4">
                        <!-- Learning Streak -->
                        <div class="learning-streak">
                            <div class="streak-number">
                                <c:choose>
                                    <c:when test="${not empty enrollmentStats.learningStreak}">
                                        ${enrollmentStats.learningStreak}
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="streak-text">
                                <i class="fas fa-fire me-2"></i>
                                Ngày học liên tiếp
                            </div>
                        </div>

                        <!-- Current Courses -->
                        <div class="chart-card">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="chart-title mb-0">
                                    <i class="fas fa-play-circle me-2"></i>
                                    Khóa học đang học
                                </h5>
                                <a href="/student/my-courses" class="btn btn-outline-primary btn-sm">
                                    <i class="fas fa-eye me-1"></i>Xem tất cả
                                </a>
                            </div>

                            <c:choose>
                                <c:when test="${not empty activeEnrollments}">
                                    <c:forEach items="${activeEnrollments}" var="enrollment" varStatus="status">
                                        <c:if test="${status.index < 3}"> <!-- Chỉ hiển thị 3 khóa học đầu -->
                                            <div class="course-card">
                                                <div class="course-body">
                                                    <h6 class="course-title">${enrollment.course.name}</h6>
                                                    <p class="course-instructor">
                                                        <i class="fas fa-user me-1"></i>
                                                            ${enrollment.course.instructor.username}
                                                    </p>

                                                    <div class="progress-section">
                                                        <div class="progress-label">
                                                            <span class="progress-text">Tiến độ học tập</span>
                                                            <span class="progress-percentage">
                                                                <c:choose>
                                                                    <c:when test="${enrollment.progressPercentage != null}">
                                                                        ${enrollment.progressPercentage}%
                                                                    </c:when>
                                                                    <c:otherwise>0%</c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </div>
                                                        <div class="progress">
                                                            <div class="progress-bar"
                                                                 style="width: ${enrollment.progressPercentage != null ? enrollment.progressPercentage : 0}%">
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="d-flex justify-content-between align-items-center mt-3">
                                                        <small class="text-muted">
                                                            <i class="fas fa-calendar me-1"></i>
                                                            Bắt đầu: <fmt:formatDate value="${enrollment.enrolledAt}" pattern="dd/MM/yyyy"/>
                                                        </small>
                                                        <a href="/student/my-courses/${enrollment.course.id}"
                                                           class="btn btn-primary btn-sm">
                                                            <i class="fas fa-play me-1"></i>Tiếp tục học
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <i class="fas fa-book-open"></i>
                                        <h5>Chưa có khóa học nào đang học</h5>
                                        <p class="mb-4">Hãy khám phá các khóa học mới và bắt đầu hành trình học tập của bạn!</p>
                                        <a href="/student/courses" class="btn btn-primary">
                                            <i class="fas fa-search me-2"></i>Tìm khóa học
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Completed Courses -->
                        <c:if test="${not empty completedEnrollments}">
                            <div class="chart-card">
                                <h5 class="chart-title">
                                    <i class="fas fa-trophy me-2"></i>
                                    Khóa học đã hoàn thành gần đây
                                </h5>

                                <c:forEach items="${completedEnrollments}" var="enrollment">
                                    <div class="d-flex align-items-center p-3 border-bottom">
                                        <div class="me-3">
                                            <div class="bg-success text-white rounded-circle d-flex align-items-center justify-content-center"
                                                 style="width: 50px; height: 50px;">
                                                <i class="fas fa-check"></i>
                                            </div>
                                        </div>
                                        <div class="flex-grow-1">
                                            <h6 class="mb-1">${enrollment.course.name}</h6>
                                            <small class="text-muted">
                                                <i class="fas fa-user me-1"></i>
                                                    ${enrollment.course.instructor.username}
                                                <span class="ms-2">
                                                    <i class="fas fa-calendar-check me-1"></i>
                                                    Hoàn thành: <fmt:formatDate value="${enrollment.completedAt}" pattern="dd/MM/yyyy"/>
                                                </span>
                                            </small>
                                        </div>
                                        <div>
                                            <span class="achievement-badge">
                                                <i class="fas fa-star me-1"></i>
                                                Hoàn thành
                                            </span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>

                    <!-- Right Column - Quick Actions & Recent Activity -->
                    <div class="col-lg-4 mb-4">
                        <!-- Quick Actions -->
                        <div class="chart-card">
                            <h5 class="chart-title">
                                <i class="fas fa-bolt me-2"></i>
                                Thao tác nhanh
                            </h5>

                            <div class="row">
                                <div class="col-6 mb-3">
                                    <a href="/student/courses" class="text-decoration-none">
                                        <div class="quick-action-card">
                                            <i class="fas fa-search quick-action-icon"></i>
                                            <h6 class="fw-bold">Tìm khóa học</h6>
                                            <small class="text-muted">Khám phá mới</small>
                                        </div>
                                    </a>
                                </div>

                                <div class="col-6 mb-3">
                                    <a href="/student/my-courses" class="text-decoration-none">
                                        <div class="quick-action-card">
                                            <i class="fas fa-book quick-action-icon"></i>
                                            <h6 class="fw-bold">Khóa học của tôi</h6>
                                            <small class="text-muted">Tiếp tục học</small>
                                        </div>
                                    </a>
                                </div>

                                <div class="col-6 mb-3">
                                    <a href="/student/progress" class="text-decoration-none">
                                        <div class="quick-action-card">
                                            <i class="fas fa-chart-line quick-action-icon"></i>
                                            <h6 class="fw-bold">Tiến độ</h6>
                                            <small class="text-muted">Theo dõi</small>
                                        </div>
                                    </a>
                                </div>

                                <div class="col-6 mb-3">
                                    <a href="/student/certificates" class="text-decoration-none">
                                        <div class="quick-action-card">
                                            <i class="fas fa-certificate quick-action-icon"></i>
                                            <h6 class="fw-bold">Chứng chỉ</h6>
                                            <small class="text-muted">Thành tích</small>
                                        </div>
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Recent Quiz Results -->
                        <div class="chart-card">
                            <h5 class="chart-title">
                                <i class="fas fa-poll me-2"></i>
                                Kết quả bài kiểm tra gần đây
                            </h5>

                            <c:choose>
                                <c:when test="${not empty recentQuizResults}">
                                    <c:forEach items="${recentQuizResults}" var="result" varStatus="status">
                                        <c:if test="${status.index < 5}"> <!-- Chỉ hiển thị 5 kết quả gần nhất -->
                                            <div class="quiz-result-item">
                                                <div class="quiz-icon ${result.passed ? 'passed' : 'failed'}">
                                                    <i class="fas fa-${result.passed ? 'check' : 'times'}"></i>
                                                </div>
                                                <div class="quiz-info">
                                                    <div class="quiz-name">${result.quiz.title}</div>
                                                    <div class="quiz-course">${result.quiz.course.name}</div>
                                                </div>
                                                <div class="quiz-score">
                                                    <div class="score-value ${result.passed ? 'passed' : 'failed'}">
                                                            ${result.score}/${result.quiz.maxScore}
                                                    </div>
                                                    <div class="score-date">
                                                        <fmt:formatDate value="${result.submittedAt}" pattern="dd/MM"/>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>

                                    <div class="text-center mt-3">
                                        <a href="/student/results" class="btn btn-outline-primary btn-sm">
                                            <i class="fas fa-poll me-1"></i>Xem tất cả kết quả
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-4">
                                        <i class="fas fa-poll fa-3x text-muted mb-3"></i>
                                        <p class="text-muted">Chưa có kết quả bài kiểm tra nào</p>
                                        <a href="/student/my-courses" class="btn btn-outline-primary btn-sm">
                                            <i class="fas fa-play me-1"></i>Bắt đầu học
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Suggested Courses -->
                        <c:if test="${not empty suggestedCourses}">
                            <div class="chart-card">
                                <h5 class="chart-title">
                                    <i class="fas fa-lightbulb me-2"></i>
                                    Khóa học gợi ý
                                </h5>

                                <c:forEach items="${suggestedCourses}" var="course" varStatus="status">
                                    <c:if test="${status.index < 3}"> <!-- Chỉ hiển thị 3 gợi ý -->
                                        <div class="d-flex align-items-center p-3 border-bottom">
                                            <div class="me-3">
                                                <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center"
                                                     style="width: 40px; height: 40px;">
                                                    <i class="fas fa-book"></i>
                                                </div>
                                            </div>
                                            <div class="flex-grow-1">
                                                <h6 class="mb-1 fs-6">${course.name}</h6>
                                                <small class="text-muted">
                                                    <i class="fas fa-user me-1"></i>
                                                        ${course.instructor.username}
                                                </small>
                                            </div>
                                            <div>
                                                <a href="/student/courses/${course.id}"
                                                   class="btn btn-outline-primary btn-sm">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>

                                <div class="text-center mt-3">
                                    <a href="/student/courses" class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-search me-1"></i>Xem thêm khóa học
                                    </a>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JavaScript -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Cập nhật thời gian hiện tại
        function updateTime() {
            const now = new Date();
            const timeString = now.toLocaleString('vi-VN', {
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit'
            });
            document.getElementById('currentTime').textContent = timeString;
        }

        updateTime();
        setInterval(updateTime, 1000);

        // Hiệu ứng hover cho stats cards
        document.querySelectorAll('.stats-card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-5px)';
            });

            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });

        // Hiệu ứng hover cho course cards
        document.querySelectorAll('.course-card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-3px)';
            });

            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });

        // Auto-hide alerts sau 5 giây
        setTimeout(function() {
            document.querySelectorAll('.alert').forEach(alert => {
                alert.style.transition = 'opacity 0.5s ease';
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 500);
            });
        }, 5000);

        // Progress bar animation
        document.querySelectorAll('.progress-bar').forEach(bar => {
            const width = bar.style.width;
            bar.style.width = '0%';
            setTimeout(() => {
                bar.style.transition = 'width 1s ease-in-out';
                bar.style.width = width;
            }, 500);
        });

        // Animation cho quiz result items
        document.querySelectorAll('.quiz-result-item').forEach((item, index) => {
            item.style.opacity = '0';
            item.style.transform = 'translateX(20px)';
            item.style.transition = 'all 0.3s ease';

            setTimeout(() => {
                item.style.opacity = '1';
                item.style.transform = 'translateX(0)';
            }, index * 100);
        });

        // Learning streak animation
        const streakNumber = document.querySelector('.streak-number');
        if (streakNumber) {
            const finalValue = parseInt(streakNumber.textContent);
            let currentValue = 0;
            const increment = finalValue / 30; // Animation trong 1 giây (30 frames)

            const animation = setInterval(() => {
                currentValue += increment;
                if (currentValue >= finalValue) {
                    currentValue = finalValue;
                    clearInterval(animation);
                }
                streakNumber.textContent = Math.floor(currentValue);
            }, 33); // ~30 FPS
        }
    });

    // Mobile sidebar toggle
    function toggleSidebar() {
        document.querySelector('.sidebar').classList.toggle('show');
    }
</script>

</body>
</html>