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
    <title>Dashboard Giảng Viên - EduLearn Platform</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Chart.js CSS -->
    <link href="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Custom CSS -->
    <style>
        :root {
            --primary-color: #4f46e5;
            --primary-dark: #3730a3;
            --success-color: #059669;
            --warning-color: #d97706;
            --danger-color: #dc2626;
            --light-bg: #f8fafc;
            --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            --border-color: #e5e7eb;
            --text-primary: #1f2937;
            --text-secondary: #6b7280;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--light-bg);
            margin: 0;
        }

        .dashboard-layout {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 2rem;
            transition: margin-left 0.3s ease;
        }

        @media (max-width: 991.98px) {
            .main-content {
                margin-left: 0;
                padding: 1rem;
            }
        }

        /* Dashboard Header */
        .dashboard-header {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--card-shadow);
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            position: relative;
            overflow: hidden;
        }

        .dashboard-header::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 200px;
            height: 200px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            transform: translate(50%, -50%);
        }

        .welcome-section {
            position: relative;
            z-index: 2;
        }

        .welcome-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .welcome-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 2rem;
        }

        .quick-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-top: 2rem;
        }

        .stat-item {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 0.75rem;
            padding: 1.5rem;
            text-align: center;
            backdrop-filter: blur(10px);
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            font-size: 0.9rem;
            opacity: 0.8;
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 25px -3px rgba(0, 0, 0, 0.1);
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: var(--primary-color);
        }

        .stat-card.success::before {
            background: var(--success-color);
        }

        .stat-card.warning::before {
            background: var(--warning-color);
        }

        .stat-card.danger::before {
            background: var(--danger-color);
        }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 0.75rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            color: white;
            background: var(--primary-color);
        }

        .stat-icon.success {
            background: var(--success-color);
        }

        .stat-icon.warning {
            background: var(--warning-color);
        }

        .stat-icon.danger {
            background: var(--danger-color);
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .stat-title {
            color: var(--text-secondary);
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 0.75rem;
        }

        .stat-change {
            display: flex;
            align-items: center;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .stat-change.positive {
            color: var(--success-color);
        }

        .stat-change.negative {
            color: var(--danger-color);
        }

        .stat-change i {
            margin-right: 0.25rem;
        }

        /* Content Sections */
        .content-row {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2rem;
            margin-bottom: 2rem;
        }

        @media (max-width: 991.98px) {
            .content-row {
                grid-template-columns: 1fr;
            }
        }

        .section-card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
        }

        .section-header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border-color);
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 0.75rem;
            color: var(--primary-color);
        }

        .section-action {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
            font-size: 0.9rem;
            transition: color 0.3s ease;
        }

        .section-action:hover {
            color: var(--primary-dark);
            text-decoration: none;
        }

        /* Course List */
        .course-item {
            display: flex;
            align-items: center;
            padding: 1rem;
            border-radius: 0.75rem;
            margin-bottom: 1rem;
            background: var(--light-bg);
            transition: all 0.3s ease;
        }

        .course-item:hover {
            background: #f3f4f6;
            transform: translateX(4px);
        }

        .course-thumbnail {
            width: 60px;
            height: 60px;
            border-radius: 0.5rem;
            margin-right: 1rem;
            object-fit: cover;
            background: var(--border-color);
        }

        .course-info {
            flex: 1;
        }

        .course-title {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
            font-size: 0.95rem;
        }

        .course-meta {
            color: var(--text-secondary);
            font-size: 0.8rem;
            display: flex;
            gap: 1rem;
        }

        .course-status {
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.7rem;
            font-weight: 500;
        }

        .status-published {
            background: #dcfce7;
            color: #166534;
        }

        .status-draft {
            background: #fef3c7;
            color: #92400e;
        }

        .status-pending {
            background: #dbeafe;
            color: #1e40af;
        }

        /* Activity Timeline */
        .activity-timeline {
            position: relative;
        }

        .timeline-item {
            display: flex;
            margin-bottom: 1.5rem;
            position: relative;
        }

        .timeline-item::before {
            content: '';
            position: absolute;
            left: 15px;
            top: 30px;
            bottom: -15px;
            width: 2px;
            background: var(--border-color);
        }

        .timeline-item:last-child::before {
            display: none;
        }

        .timeline-marker {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: var(--primary-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            margin-right: 1rem;
            flex-shrink: 0;
            z-index: 2;
            position: relative;
        }

        .timeline-content {
            flex: 1;
            background: var(--light-bg);
            padding: 1rem;
            border-radius: 0.75rem;
        }

        .timeline-title {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
            font-size: 0.9rem;
        }

        .timeline-description {
            color: var(--text-secondary);
            font-size: 0.85rem;
            margin-bottom: 0.5rem;
        }

        .timeline-time {
            color: var(--text-secondary);
            font-size: 0.75rem;
        }

        /* Quick Actions */
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .action-card {
            background: white;
            border: 2px solid var(--border-color);
            border-radius: 1rem;
            padding: 1.5rem;
            text-align: center;
            text-decoration: none;
            color: var(--text-primary);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .action-card:hover {
            border-color: var(--primary-color);
            transform: translateY(-4px);
            box-shadow: 0 10px 25px -3px rgba(79, 70, 229, 0.1);
            color: var(--text-primary);
            text-decoration: none;
        }

        .action-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin: 0 auto 1rem;
        }

        .action-title {
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .action-description {
            color: var(--text-secondary);
            font-size: 0.85rem;
        }

        /* Chart Container */
        .chart-container {
            position: relative;
            height: 300px;
            margin-top: 1rem;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }

            .quick-stats {
                grid-template-columns: repeat(2, 1fr);
            }

            .welcome-title {
                font-size: 1.5rem;
            }

            .stat-number {
                font-size: 2rem;
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
        <!-- Dashboard Header -->
        <div class="dashboard-header">
            <div class="welcome-section">
                <h1 class="welcome-title">Xin chào, ${currentUser.fullName}!</h1>
                <p class="welcome-subtitle">
                    Chào mừng trở lại với EduLearn Platform. Hôm nay bạn có
                    <strong>${pendingQuizzes}</strong> bài kiểm tra cần chấm và
                    <strong>${newEnrollments}</strong> học viên mới đăng ký.
                </p>

                <!-- Quick Stats trong Header -->
                <div class="quick-stats">
                    <div class="stat-item">
                        <div class="stat-value">${totalCourses}</div>
                        <div class="stat-label">Khóa học</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">${totalStudents}</div>
                        <div class="stat-label">Học viên</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">${totalLessons}</div>
                        <div class="stat-label">Bài giảng</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">
                            <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                        </div>
                        <div class="stat-label">Doanh thu</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="quick-actions">
            <a href="${pageContext.request.contextPath}/instructor/courses/new"" class="action-card">
                <div class="action-icon">
                    <i class="fas fa-plus"></i>
                </div>
                <div class="action-title">Tạo khóa học mới</div>
                <div class="action-description">Bắt đầu tạo một khóa học mới</div>
            </a>

            <a href="${pageContext.request.contextPath}/instructor/lessons/new"" class="action-card">
                <div class="action-icon">
                    <i class="fas fa-video"></i>
                </div>
                <div class="action-title">Thêm bài giảng</div>
                <div class="action-description">Tạo bài giảng cho khóa học</div>
            </a>

            <a href="${pageContext.request.contextPath}/instructor/quizzes/new"" class="action-card">
                <div class="action-icon">
                    <i class="fas fa-question-circle"></i>
                </div>
                <div class="action-title">Tạo bài kiểm tra</div>
                <div class="action-description">Thêm quiz cho học viên</div>
            </a>

            <a href="${pageContext.request.contextPath}/instructor/students"" class="action-card">
                <div class="action-icon">
                    <i class="fas fa-users"></i>
                </div>
                <div class="action-title">Quản lý học viên</div>
                <div class="action-description">Xem tiến độ học viên</div>
            </a>
        </div>

        <!-- Detailed Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-header">
                    <div>
                        <div class="stat-number">${totalCourses}</div>
                        <div class="stat-title">Tổng số khóa học</div>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-book"></i>
                    </div>
                </div>
                <div class="stat-change positive">
                    <i class="fas fa-arrow-up"></i>
                    +${coursesThisMonth} khóa học trong tháng
                </div>
            </div>

            <div class="stat-card success">
                <div class="stat-header">
                    <div>
                        <div class="stat-number">${totalStudents}</div>
                        <div class="stat-title">Tổng học viên</div>
                    </div>
                    <div class="stat-icon success">
                        <i class="fas fa-user-graduate"></i>
                    </div>
                </div>
                <div class="stat-change positive">
                    <i class="fas fa-arrow-up"></i>
                    +${newStudentsThisMonth} học viên mới
                </div>
            </div>

            <div class="stat-card warning">
                <div class="stat-header">
                    <div>
                        <div class="stat-number">${averageRating}</div>
                        <div class="stat-title">Đánh giá trung bình</div>
                    </div>
                    <div class="stat-icon warning">
                        <i class="fas fa-star"></i>
                    </div>
                </div>
                <div class="stat-change positive">
                    <i class="fas fa-arrow-up"></i>
                    +0.2 điểm so với tháng trước
                </div>
            </div>

            <div class="stat-card danger">
                <div class="stat-header">
                    <div>
                        <div class="stat-number">
                            <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                        </div>
                        <div class="stat-title">Doanh thu tháng này</div>
                    </div>
                    <div class="stat-icon danger">
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                </div>
                <div class="stat-change positive">
                    <i class="fas fa-arrow-up"></i>
                    +15% so với tháng trước
                </div>
            </div>
        </div>

        <!-- Content Row -->
        <div class="content-row">
            <!-- Recent Courses -->
            <div class="section-card">
                <div class="section-header">
                    <h3 class="section-title">
                        <i class="fas fa-book"></i>
                        Khóa học gần đây
                    </h3>
                    <a href="${pageContext.request.contextPath}/instructor/courses"" class="section-action">
                        Xem tất cả <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>

                <div class="courses-list">
                    <c:forEach items="${recentCourses}" var="course" varStatus="status">
                        <div class="course-item">
                            <c:choose>
                                <c:when test="${course.thumbnailPath != null}">
                                    <img src="${pageContext.request.contextPath}/images/courses/${course.thumbnailPath}"
                                         alt="${course.name}" class="course-thumbnail">
                                </c:when>
                                <c:otherwise>
                                    <div class="course-thumbnail d-flex align-items-center justify-content-center">
                                        <i class="fas fa-book text-muted"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <div class="course-info">
                                <div class="course-title">${course.name}</div>
                                <div class="course-meta">
                                    <span><i class="fas fa-users me-1"></i>${course.enrollmentCount} học viên</span>
                                    <span><i class="fas fa-clock me-1"></i>
                                            <c:if test="${course.createdAt != null}">
    ${course.createdAt.toString().substring(0, 10).replace('-', '/')}
</c:if>
                                        </span>
                                </div>
                            </div>

                            <div class="course-status status-${course.status.name().toLowerCase()}">
                                <c:choose>
                                    <c:when test="${course.status == 'PUBLISHED'}">Đã xuất bản</c:when>
                                    <c:when test="${course.status == 'DRAFT'}">Bản nháp</c:when>
                                    <c:when test="${course.status == 'PENDING'}">Chờ duyệt</c:when>
                                    <c:otherwise>${course.status}</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty recentCourses}">
                        <div class="text-center py-4">
                            <i class="fas fa-book fa-3x text-muted mb-3"></i>
                            <p class="text-muted">Bạn chưa có khóa học nào.</p>
                            <a href="${pageContext.request.contextPath}/instructor/courses/new"" class="btn btn-primary">
                                <i class="fas fa-plus me-2"></i>Tạo khóa học đầu tiên
                            </a>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Recent Activity -->
            <div class="section-card">
                <div class="section-header">
                    <h3 class="section-title">
                        <i class="fas fa-clock"></i>
                        Hoạt động gần đây
                    </h3>
                    <a href="${pageContext.request.contextPath}/instructor/activity"" class="section-action">
                        Xem tất cả <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>

                <div class="activity-timeline">
                    <c:forEach items="${recentActivities}" var="activity" varStatus="status">
                        <div class="timeline-item">
                            <div class="timeline-marker">
                                <c:choose>
                                    <c:when test="${activity.type == 'COURSE_CREATED'}">
                                        <i class="fas fa-plus"></i>
                                    </c:when>
                                    <c:when test="${activity.type == 'LESSON_ADDED'}">
                                        <i class="fas fa-video"></i>
                                    </c:when>
                                    <c:when test="${activity.type == 'STUDENT_ENROLLED'}">
                                        <i class="fas fa-user-plus"></i>
                                    </c:when>
                                    <c:when test="${activity.type == 'QUIZ_COMPLETED'}">
                                        <i class="fas fa-check"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-bell"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-title">${activity.title}</div>
                                <div class="timeline-description">${activity.description}</div>
                                <div class="timeline-time">
                                    <i class="fas fa-clock me-1"></i>
                                    <fmt:formatDate value="${activity.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty recentActivities}">
                        <div class="text-center py-4">
                            <i class="fas fa-clock fa-2x text-muted mb-3"></i>
                            <p class="text-muted">Chưa có hoạt động nào gần đây.</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Charts Section -->
        <div class="content-row">
            <div class="section-card">
                <div class="section-header">
                    <h3 class="section-title">
                        <i class="fas fa-chart-line"></i>
                        Thống kê đăng ký khóa học
                    </h3>
                    <select class="form-select w-auto" onchange="updateEnrollmentChart(this.value)">
                        <option value="7">7 ngày qua</option>
                        <option value="30" selected>30 ngày qua</option>
                        <option value="90">3 tháng qua</option>
                    </select>
                </div>
                <div class="chart-container">
                    <canvas id="enrollmentChart"></canvas>
                </div>
            </div>

            <div class="section-card">
                <div class="section-header">
                    <h3 class="section-title">
                        <i class="fas fa-chart-pie"></i>
                        Khóa học theo danh mục
                    </h3>
                </div>
                <div class="chart-container">
                    <canvas id="categoryChart"></canvas>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.min.js"></script>

<!-- Custom JavaScript -->
<script>
    // Chart.js configuration - Cấu hình biểu đồ
    const chartConfig = {
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
                    color: '#f3f4f6'
                }
            },
            x: {
                grid: {
                    color: '#f3f4f6'
                }
            }
        }
    };

    // Enrollment Chart - Biểu đồ đăng ký
    const enrollmentCtx = document.getElementById('enrollmentChart').getContext('2d');
    const enrollmentChart = new Chart(enrollmentCtx, {
        type: 'line',
        data: {
            labels: ${enrollmentChartLabels},
            datasets: [{
                label: 'Đăng ký mới',
                data: ${enrollmentChartData},
                borderColor: '#4f46e5',
                backgroundColor: 'rgba(79, 70, 229, 0.1)',
                fill: true,
                tension: 0.4
            }]
        },
        options: {
            ...chartConfig,
            plugins: {
                ...chartConfig.plugins,
                title: {
                    display: true,
                    text: 'Số lượng đăng ký theo ngày'
                }
            }
        }
    });

    // Category Chart - Biểu đồ danh mục
    const categoryCtx = document.getElementById('categoryChart').getContext('2d');
    const categoryChart = new Chart(categoryCtx, {
        type: 'doughnut',
        data: {
            labels: ${categoryChartLabels},
            datasets: [{
                data: ${categoryChartData},
                backgroundColor: [
                    '#4f46e5',
                    '#059669',
                    '#d97706',
                    '#dc2626',
                    '#7c3aed',
                    '#0891b2'
                ],
                borderWidth: 2,
                borderColor: '#ffffff'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: true,
                    position: 'bottom'
                }
            }
        }
    });

    // Update enrollment chart - Cập nhật biểu đồ đăng ký
    function updateEnrollmentChart(days) {
        fetch(`/api/instructor/enrollment-stats?days=${days}`)
            .then(response => response.json())
            .then(data => {
                enrollmentChart.data.labels = data.labels;
                enrollmentChart.data.datasets[0].data = data.data;
                enrollmentChart.update();
            })
            .catch(error => {
                console.error('Lỗi khi tải dữ liệu biểu đồ:', error);
            });
    }

    // Initialize dashboard - Khởi tạo dashboard
    document.addEventListener('DOMContentLoaded', function() {
        // Add animation to stat cards
        const statCards = document.querySelectorAll('.stat-card');
        statCards.forEach((card, index) => {
            setTimeout(() => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                card.style.transition = 'all 0.5s ease';

                requestAnimationFrame(() => {
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                });
            }, index * 100);
        });

        // Refresh data every 5 minutes
        setInterval(() => {
            updateEnrollmentChart(30);
        }, 5 * 60 * 1000);

        // Add hover effects to action cards
        const actionCards = document.querySelectorAll('.action-card');
        actionCards.forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-4px) scale(1.02)';
            });

            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
            });
        });
    });

    // Mobile responsive handling - Xử lý responsive mobile
    window.addEventListener('resize', function() {
        if (window.innerWidth < 768) {
            enrollmentChart.options.scales.x.display = false;
        } else {
            enrollmentChart.options.scales.x.display = true;
        }
        enrollmentChart.update();
    });
</script>
</body>
</html>