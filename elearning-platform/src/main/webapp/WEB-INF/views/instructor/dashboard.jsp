<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Giảng viên - EduCourse</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        /* CSS tùy chỉnh cho dashboard giảng viên */
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
            background: linear-gradient(135deg, var(--success-color) 0%, var(--info-color) 100%);
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

        .stats-card.success { border-left-color: var(--success-color); }
        .stats-card.info { border-left-color: var(--info-color); }
        .stats-card.warning { border-left-color: var(--warning-color); }
        .stats-card.primary { border-left-color: var(--primary-color); }

        .stats-number {
            font-size: 3rem;
            font-weight: 700;
            line-height: 1;
            margin-bottom: 0.5rem;
        }

        .stats-number.success { color: var(--success-color); }
        .stats-number.info { color: var(--info-color); }
        .stats-number.warning { color: var(--warning-color); }
        .stats-number.primary { color: var(--primary-color); }

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
        }

        .course-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2);
        }

        .course-header {
            background: linear-gradient(135deg, var(--success-color) 0%, var(--info-color) 100%);
            color: white;
            padding: 1.5rem;
        }

        .course-body {
            padding: 1.5rem;
        }

        .course-title {
            font-size: 1.2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .course-stats {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid #e9ecef;
        }

        .stat-item {
            text-align: center;
        }

        .stat-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--success-color);
        }

        .stat-text {
            font-size: 0.8rem;
            color: #6c757d;
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
            border-color: var(--success-color);
            transform: translateY(-3px);
        }

        .quick-action-icon {
            font-size: 3rem;
            color: var(--success-color);
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

        .enrollment-item {
            display: flex;
            align-items: center;
            padding: 1rem;
            border-bottom: 1px solid #f1f3f4;
            transition: background-color 0.3s ease;
        }

        .enrollment-item:hover {
            background-color: #f8f9fa;
        }

        .enrollment-item:last-child {
            border-bottom: none;
        }

        .student-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: var(--success-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            margin-right: 1rem;
        }

        .enrollment-info {
            flex: 1;
        }

        .student-name {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 0.25rem;
        }

        .course-name {
            font-size: 0.9rem;
            color: #6c757d;
        }

        .enrollment-date {
            font-size: 0.8rem;
            color: #6c757d;
            text-align: right;
        }

        .progress-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 1.5rem;
        }

        .progress-header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .progress-title {
            font-weight: 600;
            color: var(--dark-color);
        }

        .progress-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--success-color);
        }

        .welcome-card {
            background: linear-gradient(135deg, var(--success-color) 0%, var(--info-color) 100%);
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

            .course-stats {
                flex-direction: column;
                gap: 1rem;
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
                <small class="text-white-50">Instructor Panel</small>
            </div>

            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link active" href="/instructor/dashboard">
                        <i class="fas fa-tachometer-alt"></i>
                        Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/instructor/courses">
                        <i class="fas fa-book"></i>
                        Khóa học của tôi
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/instructor/courses/new">
                        <i class="fas fa-plus-circle"></i>
                        Tạo khóa học mới
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/instructor/students">
                        <i class="fas fa-users"></i>
                        Học viên của tôi
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/instructor/analytics">
                        <i class="fas fa-chart-line"></i>
                        Thống kê & Báo cáo
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
                        <h1 class="page-title">Dashboard Giảng viên</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="/instructor/dashboard">Instructor</a></li>
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
                                Hôm nay là một ngày tuyệt vời để truyền cảm hứng và chia sẻ kiến thức
                            </p>
                        </div>
                        <div class="text-end">
                            <i class="fas fa-chalkboard-teacher" style="font-size: 4rem; opacity: 0.3;"></i>
                        </div>
                    </div>
                </div>

                <!-- Statistics Cards - Thống kê tổng quan -->
                <div class="row mb-4">
                    <div class="col-xl-3 col-lg-6 col-md-6 mb-4">
                        <div class="stats-card success position-relative">
                            <div class="stats-number success">${totalCourses}</div>
                            <div class="stats-label">Khóa học của tôi</div>
                            <i class="fas fa-book stats-icon"></i>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-6 col-md-6 mb-4">
                        <div class="stats-card info position-relative">
                            <div class="stats-number info">${totalStudents}</div>
                            <div class="stats-label">Tổng học viên</div>
                            <i class="fas fa-users stats-icon"></i>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-6 col-md-6 mb-4">
                        <div class="stats-card warning position-relative">
                            <div class="stats-number warning">
                                <c:set var="totalLessons" value="0"/>
                                <c:forEach items="${myCourses}" var="course">
                                    <c:set var="totalLessons" value="${totalLessons + course.lessonCount}"/>
                                </c:forEach>
                                ${totalLessons}
                            </div>
                            <div class="stats-label">Bài giảng</div>
                            <i class="fas fa-play-circle stats-icon"></i>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-6 col-md-6 mb-4">
                        <div class="stats-card primary position-relative">
                            <div class="stats-number primary">
                                <c:set var="totalQuizzes" value="0"/>
                                <c:forEach items="${myCourses}" var="course">
                                    <c:set var="totalQuizzes" value="${totalQuizzes + course.quizCount}"/>
                                </c:forEach>
                                ${totalQuizzes}
                            </div>
                            <div class="stats-label">Bài kiểm tra</div>
                            <i class="fas fa-question-circle stats-icon"></i>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <!-- My Courses Section -->
                    <div class="col-lg-8 mb-4">
                        <!-- Chart Section -->
                        <div class="chart-card">
                            <h5 class="chart-title">
                                <i class="fas fa-chart-bar me-2"></i>
                                Thống kê đăng ký theo khóa học
                            </h5>
                            <canvas id="enrollmentChart" height="300"></canvas>
                        </div>

                        <!-- Khóa học của tôi -->
                        <div class="chart-card">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="chart-title mb-0">
                                    <i class="fas fa-book me-2"></i>
                                    Khóa học của tôi
                                </h5>
                                <a href="/instructor/courses" class="btn btn-outline-success btn-sm">
                                    <i class="fas fa-eye me-1"></i>Xem tất cả
                                </a>
                            </div>

                            <c:choose>
                                <c:when test="${not empty myCourses}">
                                    <c:forEach items="${myCourses}" var="course" varStatus="status">
                                        <c:if test="${status.index < 3}"> <!-- Chỉ hiển thị 3 khóa học đầu -->
                                            <div class="course-card">
                                                <div class="course-body">
                                                    <h6 class="course-title">${course.name}</h6>
                                                    <p class="text-muted mb-3">${course.description}</p>

                                                    <div class="course-stats">
                                                        <div class="stat-item">
                                                            <div class="stat-value">${course.enrollmentCount}</div>
                                                            <div class="stat-text">Học viên</div>
                                                        </div>
                                                        <div class="stat-item">
                                                            <div class="stat-value">${course.lessonCount}</div>
                                                            <div class="stat-text">Bài giảng</div>
                                                        </div>
                                                        <div class="stat-item">
                                                            <div class="stat-value">${course.quizCount}</div>
                                                            <div class="stat-text">Bài kiểm tra</div>
                                                        </div>
                                                        <div class="stat-item">
                                                            <a href="/instructor/courses/${course.id}"
                                                               class="btn btn-outline-success btn-sm">
                                                                <i class="fas fa-cog me-1"></i>Quản lý
                                                            </a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-4">
                                        <i class="fas fa-book fa-3x text-muted mb-3"></i>
                                        <h5>Chưa có khóa học nào</h5>
                                        <p class="text-muted mb-4">Hãy tạo khóa học đầu tiên để bắt đầu chia sẻ kiến thức</p>
                                        <a href="/instructor/courses/new" class="btn btn-success">
                                            <i class="fas fa-plus me-2"></i>Tạo khóa học đầu tiên
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Quick Actions & Recent Activity -->
                    <div class="col-lg-4 mb-4">
                        <!-- Quick Actions -->
                        <div class="chart-card">
                            <h5 class="chart-title">
                                <i class="fas fa-bolt me-2"></i>
                                Thao tác nhanh
                            </h5>

                            <div class="row">
                                <div class="col-6 mb-3">
                                    <a href="/instructor/courses/new" class="text-decoration-none">
                                        <div class="quick-action-card">
                                            <i class="fas fa-plus-circle quick-action-icon"></i>
                                            <h6 class="fw-bold">Tạo khóa học</h6>
                                            <small class="text-muted">Khóa học mới</small>
                                        </div>
                                    </a>
                                </div>

                                <div class="col-6 mb-3">
                                    <a href="/instructor/courses" class="text-decoration-none">
                                        <div class="quick-action-card">
                                            <i class="fas fa-book quick-action-icon"></i>
                                            <h6 class="fw-bold">Quản lý khóa học</h6>
                                            <small class="text-muted">Chỉnh sửa nội dung</small>
                                        </div>
                                    </a>
                                </div>

                                <div class="col-6 mb-3">
                                    <a href="/instructor/students" class="text-decoration-none">
                                        <div class="quick-action-card">
                                            <i class="fas fa-users quick-action-icon"></i>
                                            <h6 class="fw-bold">Xem học viên</h6>
                                            <small class="text-muted">Theo dõi tiến độ</small>
                                        </div>
                                    </a>
                                </div>

                                <div class="col-6 mb-3">
                                    <a href="/instructor/analytics" class="text-decoration-none">
                                        <div class="quick-action-card">
                                            <i class="fas fa-chart-line quick-action-icon"></i>
                                            <h6 class="fw-bold">Báo cáo</h6>
                                            <small class="text-muted">Thống kê chi tiết</small>
                                        </div>
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Recent Enrollments -->
                        <div class="chart-card">
                            <h5 class="chart-title">
                                <i class="fas fa-user-plus me-2"></i>
                                Đăng ký gần đây
                            </h5>

                            <c:choose>
                                <c:when test="${not empty recentEnrollments}">
                                    <c:forEach items="${recentEnrollments}" var="enrollment" varStatus="status">
                                        <c:if test="${status.index < 5}"> <!-- Chỉ hiển thị 5 đăng ký gần nhất -->
                                            <div class="enrollment-item">
                                                <div class="student-avatar">
                                                        ${enrollment.student.username.substring(0,1).toUpperCase()}
                                                </div>
                                                <div class="enrollment-info">
                                                    <div class="student-name">${enrollment.student.username}</div>
                                                    <div class="course-name">${enrollment.course.name}</div>
                                                </div>
                                                <div class="enrollment-date">
                                                    <fmt:formatDate value="${enrollment.enrolledAt}" pattern="dd/MM"/>
                                                    <br>
                                                    <fmt:formatDate value="${enrollment.enrolledAt}" pattern="HH:mm"/>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>

                                    <div class="text-center mt-3">
                                        <a href="/instructor/students" class="btn btn-outline-success btn-sm">
                                            <i class="fas fa-users me-1"></i>Xem tất cả học viên
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-4">
                                        <i class="fas fa-user-plus fa-3x text-muted mb-3"></i>
                                        <p class="text-muted">Chưa có đăng ký nào gần đây</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
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

        // Biểu đồ thống kê đăng ký theo khóa học
        const enrollmentCtx = document.getElementById('enrollmentChart').getContext('2d');

        // Dữ liệu từ server
        const courseNames = [
            <c:forEach items="${myCourses}" var="course" varStatus="status">
            '${course.name.length() > 20 ? course.name.substring(0,20).concat("...") : course.name}'${!status.last ? ',' : ''}
            </c:forEach>
        ];

        const enrollmentData = [
            <c:forEach items="${myCourses}" var="course" varStatus="status">
            ${course.enrollmentCount}${!status.last ? ',' : ''}
            </c:forEach>
        ];

        const colors = [
            '#28a745', '#17a2b8', '#ffc107', '#dc3545', '#6f42c1',
            '#fd7e14', '#20c997', '#e83e8c', '#6c757d', '#007bff'
        ];

        const chartData = {
            labels: courseNames,
            datasets: [{
                label: 'Số học viên đăng ký',
                data: enrollmentData,
                backgroundColor: colors.slice(0, courseNames.length),
                borderColor: colors.slice(0, courseNames.length),
                borderWidth: 2,
                borderRadius: 5,
                borderSkipped: false,
            }]
        };

        new Chart(enrollmentCtx, {
            type: 'bar',
            data: chartData,
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
                            color: 'rgba(0,0,0,0.1)'
                        },
                        ticks: {
                            stepSize: 1
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

        // Animation cho enrollment items
        document.querySelectorAll('.enrollment-item').forEach((item, index) => {
            item.style.opacity = '0';
            item.style.transform = 'translateX(20px)';
            item.style.transition = 'all 0.3s ease';

            setTimeout(() => {
                item.style.opacity = '1';
                item.style.transform = 'translateX(0)';
            }, index * 100);
        });
    });

    // Mobile sidebar toggle
    function toggleSidebar() {
        document.querySelector('.sidebar').classList.toggle('show');
    }
</script>

</body>
</html>