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
    <title>Dashboard Học Viên - EduLearn</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --info-color: #17a2b8;
            --light-bg: #f8f9fa;
            --dark-bg: #343a40;
            --border-color: #e9ecef;
            --text-primary: #2c3e50;
            --text-secondary: #6c757d;
            --card-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        body {
            background: var(--light-bg);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
        }

        .dashboard-layout {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            padding: 0;
            background: var(--light-bg);
        }

        /* Welcome Section */
        .welcome-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 3rem 2rem;
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
            max-width: 1200px;
            margin: 0 auto;
        }

        .welcome-title {
            font-size: 2.5rem;
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
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
        }

        .welcome-stat {
            text-align: center;
            background: rgba(255, 255, 255, 0.15);
            border-radius: 1rem;
            padding: 1.5rem;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .welcome-stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            display: block;
        }

        .welcome-stat-label {
            font-size: 0.95rem;
            opacity: 0.85;
        }

        /* Dashboard Content */
        .dashboard-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        .section-card {
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            margin-bottom: 2rem;
            overflow: hidden;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.5rem 2rem;
            border-bottom: 1px solid var(--border-color);
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .section-title i {
            color: var(--primary-color);
        }

        .section-action {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }

        .section-action:hover {
            color: var(--secondary-color);
        }

        .section-body {
            padding: 2rem;
        }

        /* Progress Overview */
        .progress-overview {
            display: grid;
            grid-template-columns: auto 1fr;
            gap: 2rem;
            align-items: center;
        }

        .progress-circle {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: conic-gradient(var(--primary-color) 0%, var(--primary-color) var(--progress, 0%), var(--border-color) var(--progress, 0%));
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        .progress-circle::before {
            content: '';
            width: 80px;
            height: 80px;
            background: white;
            border-radius: 50%;
            position: absolute;
        }

        .progress-percentage {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
            position: relative;
            z-index: 2;
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
            line-height: 1.6;
        }

        /* Current Courses */
        .current-courses {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem;
        }

        .course-progress-item {
            background: var(--light-bg);
            border-radius: 0.75rem;
            padding: 1.5rem;
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
        }

        .course-progress-item:hover {
            background: white;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .course-header {
            display: flex;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .course-thumbnail {
            width: 60px;
            height: 60px;
            border-radius: 0.5rem;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
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

        .course-instructor {
            color: var(--text-secondary);
            font-size: 0.85rem;
        }

        .course-progress {
            margin-bottom: 1rem;
        }

        .progress-label {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5rem;
            font-size: 0.85rem;
        }

        .progress-percentage-text {
            font-weight: 600;
            color: var(--primary-color);
        }

        .progress-bar-container {
            height: 6px;
            background: var(--border-color);
            border-radius: 3px;
            overflow: hidden;
        }

        .progress-bar-fill {
            height: 100%;
            background: var(--primary-color);
            border-radius: 3px;
            transition: width 0.3s ease;
        }

        .course-actions {
            display: flex;
            gap: 0.75rem;
        }

        .btn-continue {
            background: var(--primary-color);
            border: none;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.85rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-continue:hover {
            background: var(--secondary-color);
            color: white;
            transform: translateY(-1px);
        }

        .btn-view {
            border: 1px solid var(--primary-color);
            color: var(--primary-color);
            background: transparent;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.85rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-view:hover {
            background: var(--primary-color);
            color: white;
        }

        /* Recommended Courses */
        .recommended-courses {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.5rem;
        }

        .recommendation-item {
            background: white;
            border: 1px solid var(--border-color);
            border-radius: 0.75rem;
            padding: 1.5rem;
            text-align: center;
            transition: all 0.3s ease;
        }

        .recommendation-item:hover {
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }

        .recommendation-thumbnail {
            width: 80px;
            height: 80px;
            border-radius: 0.75rem;
            background: linear-gradient(135deg, var(--info-color) 0%, var(--primary-color) 100%);
            margin: 0 auto 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2rem;
        }

        .recommendation-title {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
            font-size: 0.95rem;
        }

        .recommendation-instructor {
            color: var(--text-secondary);
            font-size: 0.85rem;
            margin-bottom: 0.75rem;
        }

        .recommendation-rating {
            display: flex;
            justify-content: center;
            gap: 0.25rem;
            margin-bottom: 1rem;
        }

        .btn-explore {
            background: var(--info-color);
            border: none;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.85rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-explore:hover {
            background: var(--primary-color);
            color: white;
            transform: translateY(-1px);
        }

        /* Activity Feed */
        .activity-feed {
            max-height: 400px;
            overflow-y: auto;
        }

        .activity-item {
            display: flex;
            gap: 1rem;
            padding: 1rem 0;
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
            flex-shrink: 0;
        }

        .activity-content {
            flex: 1;
        }

        .activity-title {
            font-weight: 500;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
            font-size: 0.9rem;
        }

        .activity-description {
            color: var(--text-secondary);
            font-size: 0.85rem;
            line-height: 1.4;
        }

        .activity-time {
            color: var(--text-secondary);
            font-size: 0.8rem;
            margin-top: 0.25rem;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
            color: var(--text-secondary);
        }

        .empty-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .empty-title {
            font-size: 1.1rem;
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .empty-description {
            font-size: 0.9rem;
            line-height: 1.5;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .welcome-title {
                font-size: 2rem;
            }

            .welcome-stats {
                grid-template-columns: repeat(2, 1fr);
            }

            .dashboard-content {
                padding: 1rem;
            }

            .section-header {
                padding: 1rem 1.5rem;
                flex-direction: column;
                gap: 1rem;
                align-items: stretch;
                text-align: center;
            }

            .section-body {
                padding: 1.5rem;
            }

            .progress-overview {
                grid-template-columns: 1fr;
                text-align: center;
                gap: 1rem;
            }

            .current-courses {
                grid-template-columns: 1fr;
            }

            .recommended-courses {
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
        <!-- Welcome Section -->
        <div class="welcome-section">
            <div class="welcome-content">
                <h1 class="welcome-title">
                    Chào mừng trở lại,
                    <c:choose>
                        <c:when test="${currentUser != null && currentUser.fullName != null}">
                            ${currentUser.fullName}!
                        </c:when>
                        <c:otherwise>Học viên!</c:otherwise>
                    </c:choose>
                </h1>
                <p class="welcome-subtitle">
                    Hôm nay bạn đã sẵn sàng để tiếp tục hành trình học tập chưa?
                    <c:if test="${currentUser != null}">
                        Hãy cùng xem tiến độ và những khóa học mới nhé!
                    </c:if>
                </p>

                <div class="welcome-stats">
                    <div class="welcome-stat">
                        <span class="welcome-stat-number">
                            <c:choose>
                                <c:when test="${activeEnrollments != null}">
                                    ${fn:length(activeEnrollments)}
                                </c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </span>
                        <div class="welcome-stat-label">Khóa học đang học</div>
                    </div>
                    <div class="welcome-stat">
                        <span class="welcome-stat-number">
                            <c:choose>
                                <c:when test="${completedEnrollments != null}">
                                    ${fn:length(completedEnrollments)}
                                </c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </span>
                        <div class="welcome-stat-label">Khóa học hoàn thành</div>
                    </div>
                    <div class="welcome-stat">
                        <span class="welcome-stat-number">
                            <c:choose>
                                <c:when test="${completedEnrollments != null}">
                                    ${fn:length(completedEnrollments)}
                                </c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </span>
                        <div class="welcome-stat-label">Chứng chỉ</div>
                    </div>
                    <div class="welcome-stat">
                        <span class="welcome-stat-number">7</span>
                        <div class="welcome-stat-label">Ngày học liên tiếp</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Dashboard Content -->
        <div class="dashboard-content">
            <!-- Progress Overview -->
            <div class="section-card">
                <div class="section-header">
                    <h3 class="section-title">
                        <i class="fas fa-chart-pie"></i>
                        Tổng quan tiến độ học tập
                    </h3>
                    <a href="${pageContext.request.contextPath}/student/progress" class="section-action">
                        Chi tiết <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
                <div class="section-body">
                    <div class="progress-overview">
                        <div class="progress-circle" style="--progress: 65%;">
                            <div class="progress-percentage">65%</div>
                        </div>
                        <div class="progress-info">
                            <div class="progress-title">Tiến độ tổng thể</div>
                            <div class="progress-details">
                                Bạn đã hoàn thành <strong>13</strong> trong tổng số <strong>20</strong> bài học.
                                Tiếp tục phát huy để đạt mục tiêu của bạn!
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Current Courses -->
            <div class="section-card">
                <div class="section-header">
                    <h3 class="section-title">
                        <i class="fas fa-play-circle"></i>
                        Khóa học đang học
                    </h3>
                    <a href="${pageContext.request.contextPath}/student/my-courses" class="section-action">
                        Xem tất cả <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
                <div class="section-body">
                    <c:choose>
                        <c:when test="${activeEnrollments != null && fn:length(activeEnrollments) > 0}">
                            <div class="current-courses">
                                <c:forEach var="enrollment" items="${activeEnrollments}" varStatus="courseStatus">
                                    <div class="course-progress-item">
                                        <div class="course-header">
                                            <div class="course-thumbnail">
                                                <i class="fas fa-graduation-cap"></i>
                                            </div>
                                            <div class="course-info">
                                                <div class="course-title">${enrollment.course.name}</div>
                                                <div class="course-instructor">
                                                    <c:choose>
                                                        <c:when test="${enrollment.course.instructor != null}">
                                                            ${enrollment.course.instructor.fullName}
                                                        </c:when>
                                                        <c:otherwise>Chưa có giảng viên</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="course-progress">
                                            <div class="progress-label">
                                                <span>Tiến độ</span>
                                                <span class="progress-percentage-text">
                                                    <c:choose>
                                                        <c:when test="${enrollment.progress != null}">
                                                            <fmt:formatNumber value="${enrollment.progress}" maxFractionDigits="1"/>%
                                                        </c:when>
                                                        <c:otherwise>0%</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="progress-bar-container">
                                                <div class="progress-bar-fill"
                                                     style="width: <c:choose><c:when test='${enrollment.progress != null}'>${enrollment.progress}</c:when><c:otherwise>0</c:otherwise></c:choose>%"></div>
                                            </div>
                                        </div>

                                        <div class="course-actions">
                                            <a href="${pageContext.request.contextPath}/student/courses/${enrollment.course.id}/learn"
                                               class="btn-continue">
                                                <i class="fas fa-play"></i>
                                                <c:choose>
                                                    <c:when test="${enrollment.progress != null && enrollment.progress > 0}">
                                                        Tiếp tục học
                                                    </c:when>
                                                    <c:otherwise>Bắt đầu học</c:otherwise>
                                                </c:choose>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/student/course/${enrollment.course.id}"
                                               class="btn-view">
                                                <i class="fas fa-eye"></i>Chi tiết
                                            </a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="fas fa-book-open empty-icon"></i>
                                <div class="empty-title">Chưa có khóa học đang học</div>
                                <div class="empty-description">
                                    Khám phá và đăng ký các khóa học thú vị để bắt đầu hành trình học tập của bạn.
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Recommended Courses -->
            <div class="section-card">
                <div class="section-header">
                    <h3 class="section-title">
                        <i class="fas fa-lightbulb"></i>
                        Khóa học đề xuất
                    </h3>
                    <a href="${pageContext.request.contextPath}/student/browse" class="section-action">
                        Xem thêm <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
                <div class="section-body">
                    <c:choose>
                        <c:when test="${suggestedCourses != null && fn:length(suggestedCourses) > 0}">
                            <div class="recommended-courses">
                                <c:forEach var="course" items="${suggestedCourses}" varStatus="recStatus">
                                    <div class="recommendation-item">
                                        <div class="recommendation-thumbnail">
                                            <i class="fas fa-book"></i>
                                        </div>
                                        <div class="recommendation-title">${course.name}</div>
                                        <div class="recommendation-instructor">
                                            <i class="fas fa-user me-1"></i>
                                            <c:choose>
                                                <c:when test="${course.instructor != null}">
                                                    ${course.instructor.fullName}
                                                </c:when>
                                                <c:otherwise>Chưa có giảng viên</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="recommendation-rating">
                                            <c:set var="rating" value="${course.ratingAverage != null ? course.ratingAverage : 0}" />
                                            <c:forEach var="starNum" begin="1" end="5">
                                                <i class="fas fa-star
                                                    <c:choose>
                                                        <c:when test='${starNum <= rating}'>text-warning</c:when>
                                                        <c:otherwise>text-muted</c:otherwise>
                                                    </c:choose>"></i>
                                            </c:forEach>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/student/course/${course.id}"
                                           class="btn-explore">
                                            <i class="fas fa-search"></i>Khám phá
                                        </a>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="fas fa-lightbulb empty-icon"></i>
                                <div class="empty-title">Chưa có đề xuất</div>
                                <div class="empty-description">
                                    Hệ thống sẽ đưa ra các đề xuất phù hợp sau khi bạn tham gia một số khóa học.
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Recent Activity -->
            <div class="section-card">
                <div class="section-header">
                    <h3 class="section-title">
                        <i class="fas fa-history"></i>
                        Hoạt động gần đây
                    </h3>
                    <a href="${pageContext.request.contextPath}/student/activity" class="section-action">
                        Xem tất cả <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
                <div class="section-body">
                    <div class="activity-feed">
                        <!-- Sample activities - these would come from the controller -->
                        <div class="activity-item">
                            <div class="activity-icon">
                                <i class="fas fa-play"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-title">Hoàn thành bài học "Giới thiệu về Java"</div>
                                <div class="activity-description">
                                    Trong khóa học Lập trình Java cơ bản
                                </div>
                                <div class="activity-time">2 giờ trước</div>
                            </div>
                        </div>

                        <div class="activity-item">
                            <div class="activity-icon">
                                <i class="fas fa-certificate"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-title">Nhận chứng chỉ "HTML & CSS Fundamentals"</div>
                                <div class="activity-description">
                                    Hoàn thành xuất sắc với điểm số 95/100
                                </div>
                                <div class="activity-time">1 ngày trước</div>
                            </div>
                        </div>

                        <div class="activity-item">
                            <div class="activity-icon">
                                <i class="fas fa-plus"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-title">Đăng ký khóa học mới</div>
                                <div class="activity-description">
                                    React.js cho người mới bắt đầu
                                </div>
                                <div class="activity-time">3 ngày trước</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Update progress circles on load
    document.addEventListener('DOMContentLoaded', function() {
        // Animate progress circles
        const progressCircles = document.querySelectorAll('.progress-circle');
        progressCircles.forEach(circle => {
            const progress = circle.style.getPropertyValue('--progress');
            if (progress) {
                circle.style.setProperty('--progress', '0%');
                setTimeout(() => {
                    circle.style.transition = 'all 1s ease';
                    circle.style.setProperty('--progress', progress);
                }, 500);
            }
        });

        // Animate progress bars
        const progressBars = document.querySelectorAll('.progress-bar-fill');
        progressBars.forEach((bar, index) => {
            const width = bar.style.width;
            bar.style.width = '0%';
            setTimeout(() => {
                bar.style.transition = 'width 1s ease';
                bar.style.width = width;
            }, 500 + (index * 200));
        });

        // Animate cards
        const cards = document.querySelectorAll('.section-card');
        cards.forEach((card, index) => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            setTimeout(() => {
                card.style.transition = 'all 0.6s ease';
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, index * 200);
        });
    });

    // Continue learning function
    function continueLearning(courseId) {
        window.location.href = `${pageContext.request.contextPath}/student/courses/${courseId}/learn`;
    }

    // Quick navigation shortcuts
    document.addEventListener('keydown', function(e) {
        if (e.ctrlKey || e.metaKey) {
            switch(e.key) {
                case 'm':
                    e.preventDefault();
                    window.location.href = '${pageContext.request.contextPath}/student/my-courses';
                    break;
                case 'b':
                    e.preventDefault();
                    window.location.href = '${pageContext.request.contextPath}/student/browse';
                    break;
            }
        }
    });
</script>
</body>
</html>