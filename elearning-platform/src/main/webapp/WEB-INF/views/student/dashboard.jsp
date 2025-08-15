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
    <title>Dashboard Học Viên - EduLearn Platform</title>

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

        /* Welcome Section */
        .welcome-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }

        .welcome-section::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }

        .welcome-content {
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

        .welcome-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 1.5rem;
        }

        .welcome-stat {
            text-align: center;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 0.75rem;
            padding: 1.25rem;
            backdrop-filter: blur(10px);
        }

        .welcome-stat-number {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .welcome-stat-label {
            font-size: 0.9rem;
            opacity: 0.8;
        }

        /* Progress Overview */
        .progress-overview {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: var(--card-shadow);
            margin-bottom: 2rem;
            border: 1px solid var(--border-color);
        }

        .overview-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border-color);
        }

        .overview-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            display: flex;
            align-items: center;
        }

        .overview-title i {
            margin-right: 0.75rem;
            color: var(--primary-color);
        }

        .overall-progress {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .progress-circle {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: conic-gradient(var(--primary-color) 0deg ${overallProgress * 3.6}deg, var(--border-color) ${overallProgress * 3.6}deg 360deg);
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        .progress-circle::after {
            content: '';
            width: 60px;
            height: 60px;
            background: white;
            border-radius: 50%;
            position: absolute;
        }

        .progress-percentage {
            position: relative;
            z-index: 2;
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text-primary);
        }

        .progress-info {
            flex: 1;
        }

        .progress-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .progress-details {
            color: var(--text-secondary);
            font-size: 0.9rem;
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

        /* Content Grid */
        .content-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2rem;
            margin-bottom: 2rem;
        }

        @media (max-width: 991.98px) {
            .content-grid {
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
            justify-content: space-between;
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
        }

        .section-action:hover {
            color: var(--primary-dark);
            text-decoration: none;
        }

        /* Course Progress Cards */
        .course-progress-item {
            background: var(--light-bg);
            border-radius: 0.75rem;
            padding: 1.25rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
            border: 1px solid var(--border-color);
        }

        .course-progress-item:hover {
            background: #f3f4f6;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px -4px rgba(0, 0, 0, 0.1);
        }

        .course-header {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
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
            font-size: 1rem;
        }

        .course-instructor {
            color: var(--text-secondary);
            font-size: 0.85rem;
        }

        .course-progress {
            margin-bottom: 0.75rem;
        }

        .progress-bar-container {
            background: var(--border-color);
            border-radius: 1rem;
            height: 8px;
            overflow: hidden;
            margin-bottom: 0.5rem;
        }

        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--primary-color), var(--primary-dark));
            border-radius: 1rem;
            transition: width 0.3s ease;
        }

        .progress-text {
            display: flex;
            justify-content: space-between;
            font-size: 0.8rem;
            color: var(--text-secondary);
        }

        .course-actions {
            display: flex;
            gap: 0.75rem;
        }

        .btn-continue {
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 0.5rem;
            padding: 0.5rem 1rem;
            font-size: 0.85rem;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .btn-continue:hover {
            background: var(--primary-dark);
            color: white;
            text-decoration: none;
        }

        .btn-certificate {
            background: var(--success-color);
            color: white;
            border: none;
            border-radius: 0.5rem;
            padding: 0.5rem 1rem;
            font-size: 0.85rem;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .btn-certificate:hover {
            background: #047857;
            color: white;
            text-decoration: none;
        }

        /* Achievements */
        .achievement-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
            gap: 1rem;
        }

        .achievement-item {
            text-align: center;
            padding: 1rem;
            background: var(--light-bg);
            border-radius: 0.75rem;
            transition: all 0.3s ease;
            border: 1px solid var(--border-color);
        }

        .achievement-item:hover {
            background: #f3f4f6;
            transform: scale(1.05);
        }

        .achievement-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--warning-color), #f59e0b);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            margin: 0 auto 0.75rem;
        }

        .achievement-icon.earned {
            background: linear-gradient(135deg, var(--success-color), #10b981);
        }

        .achievement-icon.locked {
            background: var(--border-color);
            color: var(--text-secondary);
        }

        .achievement-title {
            font-weight: 600;
            font-size: 0.8rem;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }

        .achievement-description {
            font-size: 0.7rem;
            color: var(--text-secondary);
        }

        /* Learning Goals */
        .goal-item {
            display: flex;
            align-items: center;
            padding: 1rem;
            background: var(--light-bg);
            border-radius: 0.75rem;
            margin-bottom: 1rem;
            border: 1px solid var(--border-color);
        }

        .goal-checkbox {
            margin-right: 1rem;
            transform: scale(1.2);
        }

        .goal-info {
            flex: 1;
        }

        .goal-title {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
            font-size: 0.95rem;
        }

        .goal-deadline {
            color: var(--text-secondary);
            font-size: 0.8rem;
        }

        .goal-progress {
            width: 60px;
            text-align: center;
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--primary-color);
        }

        /* Recent Activity */
        .activity-item {
            display: flex;
            align-items: center;
            padding: 1rem;
            border-bottom: 1px solid var(--border-color);
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--primary-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
            margin-right: 1rem;
            flex-shrink: 0;
        }

        .activity-icon.lesson {
            background: var(--success-color);
        }

        .activity-icon.quiz {
            background: var(--warning-color);
        }

        .activity-icon.certificate {
            background: var(--danger-color);
        }

        .activity-content {
            flex: 1;
        }

        .activity-title {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
            font-size: 0.9rem;
        }

        .activity-description {
            color: var(--text-secondary);
            font-size: 0.8rem;
            margin-bottom: 0.25rem;
        }

        .activity-time {
            color: var(--text-secondary);
            font-size: 0.75rem;
        }

        /* Recommended Courses */
        .recommendation-item {
            display: flex;
            align-items: center;
            padding: 1rem;
            background: var(--light-bg);
            border-radius: 0.75rem;
            margin-bottom: 1rem;
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
        }

        .recommendation-item:hover {
            background: #f3f4f6;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px -4px rgba(0, 0, 0, 0.1);
        }

        .recommendation-thumbnail {
            width: 60px;
            height: 60px;
            border-radius: 0.5rem;
            margin-right: 1rem;
            object-fit: cover;
            background: var(--border-color);
        }

        .recommendation-info {
            flex: 1;
        }

        .recommendation-title {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
            font-size: 0.95rem;
        }

        .recommendation-instructor {
            color: var(--text-secondary);
            font-size: 0.8rem;
            margin-bottom: 0.25rem;
        }

        .recommendation-rating {
            display: flex;
            align-items: center;
            font-size: 0.8rem;
            color: var(--warning-color);
        }

        .btn-enroll {
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 0.5rem;
            padding: 0.5rem 1rem;
            font-size: 0.8rem;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .btn-enroll:hover {
            background: var(--primary-dark);
            color: white;
            text-decoration: none;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .welcome-stats {
                grid-template-columns: repeat(2, 1fr);
            }

            .welcome-title {
                font-size: 1.5rem;
            }

            .quick-actions {
                grid-template-columns: repeat(2, 1fr);
            }

            .achievement-grid {
                grid-template-columns: repeat(3, 1fr);
            }
        }
    </style>
</head>

<body>
<div class="dashboard-layout">
    <!-- Include Sidebar -->
    <jsp:include page="../common/sidebar.jsp" />

    <!-- Main Content -->
    <div class="main-content">
        <!-- Welcome Section -->
        <div class="welcome-section">
            <div class="welcome-content">
                <h1 class="welcome-title">Chào mừng trở lại, ${currentUser.fullName}!</h1>
                <p class="welcome-subtitle">
                    Tiếp tục hành trình học tập của bạn. Hôm nay bạn có
                    <strong>${pendingLessons}</strong> bài học chưa hoàn thành và
                    <strong>${upcomingDeadlines}</strong> deadline sắp tới.
                </p>

                <div class="welcome-stats">
                    <div class="welcome-stat">
                        <div class="welcome-stat-number">${enrolledCourses}</div>
                        <div class="welcome-stat-label">Khóa học đã đăng ký</div>
                    </div>
                    <div class="welcome-stat">
                        <div class="welcome-stat-number">${completedCourses}</div>
                        <div class="welcome-stat-label">Khóa học hoàn thành</div>
                    </div>
                    <div class="welcome-stat">
                        <div class="welcome-stat-number">${certificates}</div>
                        <div class="welcome-stat-label">Chứng chỉ</div>
                    </div>
                    <div class="welcome-stat">
                        <div class="welcome-stat-number">${studyStreak}</div>
                        <div class="welcome-stat-label">Ngày học liên tiếp</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Progress Overview -->
        <div class="progress-overview">
            <div class="overview-header">
                <h2 class="overview-title">
                    <i class="fas fa-chart-pie"></i>
                    Tổng quan tiến độ học tập
                </h2>
                <a href="//student/progress"" class="section-action">
                    Chi tiết <i class="fas fa-arrow-right ms-1"></i>
                </a>
            </div>

            <div class="overall-progress">
                <div class="progress-circle">
                    <div class="progress-percentage">${overallProgress}%</div>
                </div>
                <div class="progress-info">
                    <div class="progress-title">Tiến độ tổng thể</div>
                    <div class="progress-details">
                        Bạn đã hoàn thành ${completedLessons} trong tổng số ${totalLessons} bài học.
                        Tiếp tục phát huy để đạt mục tiêu!
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="quick-actions">
            <a href="//courses"" class="action-card">
                <div class="action-icon">
                    <i class="fas fa-search"></i>
                </div>
                <div class="action-title">Khám phá khóa học</div>
                <div class="action-description">Tìm khóa học mới phù hợp với bạn</div>
            </a>

            <a href="//student/my-courses"" class="action-card">
                <div class="action-icon">
                    <i class="fas fa-book-reader"></i>
                </div>
                <div class="action-title">Tiếp tục học</div>
                <div class="action-description">Quay lại khóa học đang học</div>
            </a>

            <a href="//student/certificates"" class="action-card">
                <div class="action-icon">
                    <i class="fas fa-certificate"></i>
                </div>
                <div class="action-title">Chứng chỉ</div>
                <div class="action-description">Xem các chứng chỉ đã đạt được</div>
            </a>

            <a href="//student/achievements"" class="action-card">
                <div class="action-icon">
                    <i class="fas fa-trophy"></i>
                </div>
                <div class="action-title">Thành tích</div>
                <div class="action-description">Xem badges và achievements</div>
            </a>
        </div>

        <!-- Content Grid -->
        <div class="content-grid">
            <!-- Current Courses -->
            <div class="section-card">
                <div class="section-header">
                    <h3 class="section-title">
                        <i class="fas fa-play-circle"></i>
                        Khóa học đang học
                    </h3>
                    <a href="//student/my-courses"" class="section-action">
                        Xem tất cả <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>

                <div class="current-courses">
                    <c:forEach items="${currentCourses}" var="course" varStatus="status">
                        <div class="course-progress-item">
                            <div class="course-header">
                                <c:choose>
                                    <c:when test="${course.thumbnailPath != null}">
                                        <img src="${pageContext.request.contextPath}/images/courses/${course.thumbnailPath}""
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
                                    <div class="course-instructor">
                                        <i class="fas fa-user me-1"></i>${course.instructor.fullName}
                                    </div>
                                </div>
                            </div>

                            <div class="course-progress">
                                <div class="progress-bar-container">
                                    <div class="progress-bar-fill" style="width: ${course.progressPercentage}%"></div>
                                </div>
                                <div class="progress-text">
                                    <span>${course.completedLessons}/${course.totalLessons} bài học</span>
                                    <span>${course.progressPercentage}%</span>
                                </div>
                            </div>

                            <div class="course-actions">
                                <c:choose>
                                    <c:when test="${course.progressPercentage >= 100}">
                                        <a href="//student/certificates/${course.id}"" class="btn-certificate">
                                            <i class="fas fa-certificate me-1"></i>Nhận chứng chỉ
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="//student/course/${course.id}"" class="btn-continue">
                                            <i class="fas fa-play me-1"></i>Tiếp tục học
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty currentCourses}">
                        <div class="text-center py-4">
                            <i class="fas fa-book-open fa-3x text-muted mb-3"></i>
                            <p class="text-muted">Bạn chưa đăng ký khóa học nào.</p>
                            <a href="//courses"" class="btn btn-primary">
                                <i class="fas fa-search me-2"></i>Khám phá khóa học
                            </a>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Sidebar Content -->
            <div>
                <!-- Learning Goals -->
                <div class="section-card mb-3">
                    <div class="section-header">
                        <h3 class="section-title">
                            <i class="fas fa-target"></i>
                            Mục tiêu học tập
                        </h3>
                        <a href="//student/goals"" class="section-action">
                            Quản lý <i class="fas fa-cog ms-1"></i>
                        </a>
                    </div>

                    <div class="learning-goals">
                        <c:forEach items="${learningGoals}" var="goal" varStatus="status">
                            <div class="goal-item">
                                <input type="checkbox" class="form-check-input goal-checkbox"
                                    ${goal.completed ? 'checked' : ''}
                                       onchange="toggleGoal(${goal.id})">
                                <div class="goal-info">
                                    <div class="goal-title">${goal.title}</div>
                                    <div class="goal-deadline">
                                        <i class="fas fa-calendar me-1"></i>
                                        <fmt:formatDate value="${goal.deadline}" pattern="dd/MM/yyyy"/>
                                    </div>
                                </div>
                                <div class="goal-progress">${goal.progress}%</div>
                            </div>
                        </c:forEach>

                        <c:if test="${empty learningGoals}">
                            <div class="text-center py-3">
                                <i class="fas fa-target fa-2x text-muted mb-2"></i>
                                <p class="text-muted">Chưa có mục tiêu nào.</p>
                                <a href="//student/goals/new"" class="btn btn-sm btn-primary">
                                    Tạo mục tiêu
                                </a>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Achievements -->
                <div class="section-card mb-3">
                    <div class="section-header">
                        <h3 class="section-title">
                            <i class="fas fa-trophy"></i>
                            Thành tích
                        </h3>
                        <a href="//student/achievements"" class="section-action">
                            Xem tất cả <i class="fas fa-arrow-right ms-1"></i>
                        </a>
                    </div>

                    <div class="achievement-grid">
                        <c:forEach items="${recentAchievements}" var="achievement" varStatus="status">
                            <div class="achievement-item">
                                <div class="achievement-icon ${achievement.earned ? 'earned' : 'locked'}">
                                    <i class="fas ${achievement.icon}"></i>
                                </div>
                                <div class="achievement-title">${achievement.title}</div>
                                <div class="achievement-description">${achievement.description}</div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Recent Activity -->
                <div class="section-card">
                    <div class="section-header">
                        <h3 class="section-title">
                            <i class="fas fa-clock"></i>
                            Hoạt động gần đây
                        </h3>
                    </div>

                    <div class="recent-activity">
                        <c:forEach items="${recentActivities}" var="activity" varStatus="status">
                            <div class="activity-item">
                                <div class="activity-icon ${activity.type}">
                                    <c:choose>
                                        <c:when test="${activity.type == 'lesson'}">
                                            <i class="fas fa-play"></i>
                                        </c:when>
                                        <c:when test="${activity.type == 'quiz'}">
                                            <i class="fas fa-question"></i>
                                        </c:when>
                                        <c:when test="${activity.type == 'certificate'}">
                                            <i class="fas fa-certificate"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-bell"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="activity-content">
                                    <div class="activity-title">${activity.title}</div>
                                    <div class="activity-description">${activity.description}</div>
                                    <div class="activity-time">
                                        <fmt:formatDate value="${activity.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>

                        <c:if test="${empty recentActivities}">
                            <div class="text-center py-3">
                                <i class="fas fa-clock fa-2x text-muted mb-2"></i>
                                <p class="text-muted">Chưa có hoạt động nào.</p>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recommended Courses -->
        <div class="section-card">
            <div class="section-header">
                <h3 class="section-title">
                    <i class="fas fa-lightbulb"></i>
                    Khóa học được đề xuất
                </h3>
                <a href="//courses?recommended=true"" class="section-action">
                    Xem thêm <i class="fas fa-arrow-right ms-1"></i>
                </a>
            </div>

            <div class="recommendations">
                <c:forEach items="${recommendedCourses}" var="course" varStatus="status">
                    <div class="recommendation-item">
                        <c:choose>
                            <c:when test="${course.thumbnailPath != null}">
                                <img src="${pageContext.request.contextPath}/images/courses/${course.thumbnailPath}""
                                     alt="${course.name}" class="recommendation-thumbnail">
                            </c:when>
                            <c:otherwise>
                                <div class="recommendation-thumbnail d-flex align-items-center justify-content-center">
                                    <i class="fas fa-book text-muted"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <div class="recommendation-info">
                            <div class="recommendation-title">${course.name}</div>
                            <div class="recommendation-instructor">
                                <i class="fas fa-user me-1"></i>${course.instructor.fullName}
                            </div>
                            <div class="recommendation-rating">
                                <c:forEach begin="1" end="5" var="i">
                                    <i class="fas fa-star ${i <= course.averageRating ? '' : 'text-muted'}"></i>
                                </c:forEach>
                                <span class="ms-2">(${course.reviewCount} đánh giá)</span>
                            </div>
                        </div>

                        <a href="//courses/${course.id}"" class="btn-enroll">
                            <i class="fas fa-plus me-1"></i>Đăng ký
                        </a>
                    </div>
                </c:forEach>

                <c:if test="${empty recommendedCourses}">
                    <div class="text-center py-4">
                        <i class="fas fa-lightbulb fa-3x text-muted mb-3"></i>
                        <p class="text-muted">Chưa có khóa học được đề xuất.</p>
                        <a href="//courses"" class="btn btn-primary">
                            <i class="fas fa-search me-2"></i>Tìm khóa học
                        </a>
                    </div>
                </c:if>
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
    // Toggle learning goal - Chuyển trạng thái mục tiêu học tập
    function toggleGoal(goalId) {
        fetch(`/api/student/goals/${goalId}/toggle`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Update UI accordingly
                    console.log('Cập nhật mục tiêu thành công');
                } else {
                    console.error('Lỗi khi cập nhật mục tiêu:', data.message);
                }
            })
            .catch(error => {
                console.error('Lỗi khi gọi API:', error);
            });
    }

    // Initialize dashboard - Khởi tạo dashboard
    document.addEventListener('DOMContentLoaded', function() {
        // Animate progress bars
        const progressBars = document.querySelectorAll('.progress-bar-fill');
        progressBars.forEach(bar => {
            const width = bar.style.width;
            bar.style.width = '0%';
            setTimeout(() => {
                bar.style.width = width;
            }, 500);
        });

        // Animate welcome stats
        const statNumbers = document.querySelectorAll('.welcome-stat-number');
        statNumbers.forEach(stat => {
            const finalValue = parseInt(stat.textContent);
            let currentValue = 0;
            const increment = finalValue / 50;
            const timer = setInterval(() => {
                currentValue += increment;
                if (currentValue >= finalValue) {
                    currentValue = finalValue;
                    clearInterval(timer);
                }
                stat.textContent = Math.floor(currentValue);
            }, 30);
        });

        // Add hover effects to course items
        const courseItems = document.querySelectorAll('.course-progress-item');
        courseItems.forEach(item => {
            item.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-2px) scale(1.02)';
            });

            item.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
            });
        });

        // Update progress circle animation
        const progressCircle = document.querySelector('.progress-circle');
        if (progressCircle) {
            const percentage = ${overallProgress};
            setTimeout(() => {
                progressCircle.style.background = `conic-gradient(var(--primary-color) 0deg ${percentage * 3.6}deg, var(--border-color) ${percentage * 3.6}deg 360deg)`;
            }, 1000);
        }
    });

    // Auto-refresh every 5 minutes - Tự động làm mới mỗi 5 phút
    setInterval(() => {
        // Update progress and stats
        fetch('/api/student/dashboard/refresh')
            .then(response => response.json())
            .then(data => {
                // Update UI with new data
                console.log('Dashboard refreshed');
            })
            .catch(error => {
                console.log('Không thể làm mới dashboard:', error);
            });
    }, 5 * 60 * 1000);
</script>
</body>
</html>