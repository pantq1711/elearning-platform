<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Học viên - Hệ thống Quản lý Khóa học</title>

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
        }

        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
        }

        .navbar {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            box-shadow: 0 2px 20px rgba(0,0,0,0.1);
        }

        .container {
            margin-top: 20px;
        }

        .welcome-section {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            position: relative;
            overflow: hidden;
        }

        .welcome-section::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 200px;
            height: 200px;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            border-radius: 50%;
            transform: translate(50%, -50%);
            opacity: 0.1;
        }

        .welcome-content {
            position: relative;
            z-index: 2;
        }

        .stats-row {
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            height: 100%;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }

        .stat-icon {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            color: white;
            margin: 0 auto 15px;
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .stat-label {
            color: #666;
            font-weight: 500;
        }

        .progress-ring {
            width: 100px;
            height: 100px;
            margin: 0 auto 15px;
        }

        .course-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            margin-bottom: 20px;
        }

        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }

        .course-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 20px;
            position: relative;
        }

        .course-body {
            padding: 20px;
        }

        .progress-bar-custom {
            height: 8px;
            border-radius: 10px;
            background-color: #e9ecef;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--success-color), #20c997);
            border-radius: 10px;
            transition: width 0.5s ease;
        }

        .quiz-result-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            border-left: 4px solid;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .quiz-passed {
            border-left-color: var(--success-color);
        }

        .quiz-failed {
            border-left-color: var(--danger-color);
        }

        .btn-course {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border: none;
            color: white;
            padding: 12px 25px;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .btn-course:hover {
            background: linear-gradient(135deg, var(--secondary-color), var(--primary-color));
            color: white;
            transform: translateY(-2px);
        }

        .section-title {
            color: #333;
            font-weight: 700;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 10px;
            color: var(--primary-color);
        }

        .empty-state {
            text-align: center;
            padding: 40px;
            color: #666;
        }

        .empty-state i {
            font-size: 4rem;
            color: #ddd;
            margin-bottom: 20px;
        }

        .suggested-course {
            background: white;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }

        .suggested-course:hover {
            transform: translateX(5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }

        .badge-custom {
            padding: 8px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .badge-completed { background-color: var(--success-color); color: white; }
        .badge-in-progress { background-color: var(--info-color); color: white; }
        .badge-passed { background-color: var(--success-color); color: white; }
        .badge-failed { background-color: var(--danger-color); color: white; }
    </style>
</head>
<body>
<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container">
        <a class="navbar-brand" href="/student/dashboard">
            <i class="fas fa-graduation-cap me-2"></i>
            CourseHub
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link active" href="/student/dashboard">
                        <i class="fas fa-home me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/student/courses">
                        <i class="fas fa-search me-1"></i>Tìm khóa học
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/student/my-courses">
                        <i class="fas fa-book me-1"></i>Khóa học của tôi
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/student/results">
                        <i class="fas fa-chart-line me-1"></i>Kết quả học tập
                    </a>
                </li>
            </ul>

            <ul class="navbar-nav">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user me-1"></i>
                        ${currentUser.username}
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="/profile">
                            <i class="fas fa-user me-2"></i>Hồ sơ cá nhân
                        </a></li>
                        <li><a class="dropdown-item" href="/change-password">
                            <i class="fas fa-lock me-2"></i>Đổi mật khẩu
                        </a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="/logout">
                            <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                        </a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container">
    <!-- Welcome Section -->
    <div class="welcome-section">
        <div class="welcome-content">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h2 class="mb-3">
                        <i class="fas fa-wave-square me-2 text-primary"></i>
                        Chào mừng trở lại, ${currentUser.username}!
                    </h2>
                    <p class="lead mb-0 text-muted">
                        Sẵn sàng tiếp tục hành trình học tập của bạn? Hãy khám phá những khóa học mới và nâng cao kỹ năng!
                    </p>
                </div>
                <div class="col-md-4 text-center">
                    <i class="fas fa-user-graduate fa-5x text-primary opacity-50"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Statistics Row -->
    <div class="row stats-row">
        <div class="col-lg-3 col-md-6 mb-4">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(45deg, var(--info-color), #6f42c1);">
                    <i class="fas fa-book-open"></i>
                </div>
                <div class="stat-number text-info">${enrollmentStats.totalEnrollments}</div>
                <div class="stat-label">Khóa học đã đăng ký</div>
            </div>
        </div>

        <div class="col-lg-3 col-md-6 mb-4">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(45deg, var(--warning-color), #fd7e14);">
                    <i class="fas fa-play-circle"></i>
                </div>
                <div class="stat-number text-warning">${enrollmentStats.activeEnrollments}</div>
                <div class="stat-label">Đang học</div>
            </div>
        </div>

        <div class="col-lg-3 col-md-6 mb-4">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(45deg, var(--success-color), #20c997);">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-number text-success">${enrollmentStats.completedEnrollments}</div>
                <div class="stat-label">Đã hoàn thành</div>
            </div>
        </div>

        <div class="col-lg-3 col-md-6 mb-4">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));">
                    <i class="fas fa-percentage"></i>
                </div>
                <div class="stat-number text-primary">
                    <fmt:formatNumber value="${enrollmentStats.completionRate}" maxFractionDigits="0"/>%
                </div>
                <div class="stat-label">Tỷ lệ hoàn thành</div>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- Active Courses -->
        <div class="col-lg-8">
            <h3 class="section-title">
                <i class="fas fa-play-circle"></i>
                Khóa học đang học (${activeEnrollments.size()})
            </h3>

            <c:choose>
                <c:when test="${not empty activeEnrollments}">
                    <c:forEach items="${activeEnrollments}" var="enrollment">
                        <div class="course-card">
                            <div class="course-header">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h5 class="mb-1">${enrollment.course.name}</h5>
                                        <p class="mb-0 opacity-75">
                                            <i class="fas fa-user me-1"></i>
                                                ${enrollment.course.instructor.username}
                                        </p>
                                    </div>
                                    <div class="col-md-4 text-end">
                                            <span class="badge badge-custom badge-in-progress">
                                                Đang học
                                            </span>
                                    </div>
                                </div>
                            </div>
                            <div class="course-body">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <p class="text-muted mb-2">
                                            Đăng ký từ:
                                            <fmt:formatDate value="${enrollment.enrolledAt}" pattern="dd/MM/yyyy" />
                                        </p>
                                        <c:if test="${enrollment.hasScore()}">
                                            <p class="mb-2">
                                                <i class="fas fa-star text-warning me-1"></i>
                                                Điểm cao nhất: <strong>${enrollment.scoreText}</strong>
                                            </p>
                                        </c:if>
                                        <!-- Progress bar placeholder -->
                                        <div class="progress-bar-custom mb-2">
                                            <div class="progress-fill" style="width: 65%;"></div>
                                        </div>
                                        <small class="text-muted">Tiến độ: 65%</small>
                                    </div>
                                    <div class="col-md-4 text-end">
                                        <a href="/student/my-courses/${enrollment.course.id}" class="btn btn-course">
                                            <i class="fas fa-play me-1"></i>
                                            Tiếp tục học
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-book-open"></i>
                        <h4>Chưa có khóa học nào đang học</h4>
                        <p>Hãy khám phá các khóa học mới và bắt đầu hành trình học tập của bạn!</p>
                        <a href="/student/courses" class="btn btn-course">
                            <i class="fas fa-search me-2"></i>
                            Tìm khóa học
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- Completed Courses -->
            <c:if test="${not empty completedEnrollments}">
                <h3 class="section-title mt-5">
                    <i class="fas fa-trophy"></i>
                    Khóa học đã hoàn thành gần đây
                </h3>

                <c:forEach items="${completedEnrollments}" var="enrollment">
                    <div class="course-card">
                        <div class="course-body">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <h6 class="mb-2">${enrollment.course.name}</h6>
                                    <p class="text-muted mb-1">
                                        <i class="fas fa-user me-1"></i>
                                            ${enrollment.course.instructor.username}
                                    </p>
                                    <p class="mb-0">
                                        <i class="fas fa-calendar-check me-1 text-success"></i>
                                        Hoàn thành:
                                        <fmt:formatDate value="${enrollment.completedAt}" pattern="dd/MM/yyyy" />
                                    </p>
                                    <c:if test="${enrollment.hasScore()}">
                                        <p class="mb-0">
                                            <i class="fas fa-star text-warning me-1"></i>
                                            Điểm: <strong>${enrollment.scoreText}</strong>
                                        </p>
                                    </c:if>
                                </div>
                                <div class="col-md-4 text-end">
                                        <span class="badge badge-custom badge-completed mb-2">
                                            Đã hoàn thành
                                        </span>
                                    <br>
                                    <a href="/student/my-courses/${enrollment.course.id}" class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-eye me-1"></i>
                                        Xem lại
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:if>
        </div>

        <!-- Sidebar -->
        <div class="col-lg-4">
            <!-- Recent Quiz Results -->
            <c:if test="${not empty recentQuizResults}">
                <h4 class="section-title">
                    <i class="fas fa-chart-bar"></i>
                    Kết quả kiểm tra gần đây
                </h4>

                <c:forEach items="${recentQuizResults}" var="result">
                    <div class="quiz-result-card ${result.passed ? 'quiz-passed' : 'quiz-failed'}">
                        <h6 class="mb-2">${result.quiz.title}</h6>
                        <p class="text-muted mb-2 small">${result.quiz.course.name}</p>
                        <div class="d-flex justify-content-between align-items-center">
                                <span class="badge badge-custom ${result.passed ? 'badge-passed' : 'badge-failed'}">
                                        ${result.resultText}
                                </span>
                            <strong>${result.percentageText}</strong>
                        </div>
                        <small class="text-muted">
                            <i class="fas fa-clock me-1"></i>
                                ${result.submittedAtText}
                        </small>
                    </div>
                </c:forEach>

                <div class="text-center mb-4">
                    <a href="/student/results" class="btn btn-outline-primary btn-sm">
                        Xem tất cả kết quả <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </c:if>

            <!-- Suggested Courses -->
            <h4 class="section-title">
                <i class="fas fa-lightbulb"></i>
                Khóa học đề xuất
            </h4>

            <c:choose>
                <c:when test="${not empty suggestedCourses}">
                    <c:forEach items="${suggestedCourses}" var="course">
                        <div class="suggested-course">
                            <h6 class="mb-2">${course.name}</h6>
                            <p class="text-muted mb-2 small">
                                <i class="fas fa-user me-1"></i>
                                    ${course.instructor.username}
                                <span class="ms-2">
                                        <i class="fas fa-users me-1"></i>
                                        ${course.enrollmentCount} học viên
                                    </span>
                            </p>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="text-success fw-bold small">Miễn phí</span>
                                <a href="/student/courses/${course.id}" class="btn btn-outline-primary btn-sm">
                                    Xem chi tiết
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="text-center text-muted">
                        <i class="fas fa-search fa-2x mb-2"></i>
                        <p>Không có khóa học đề xuất</p>
                        <a href="/student/courses" class="btn btn-outline-primary btn-sm">
                            Khám phá tất cả
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Add some interactive features
    document.addEventListener('DOMContentLoaded', function() {
        // Animate progress bars
        const progressBars = document.querySelectorAll('.progress-fill');
        progressBars.forEach(function(bar) {
            const width = bar.style.width;
            bar.style.width = '0%';
            setTimeout(function() {
                bar.style.width = width;
            }, 500);
        });

        // Add hover effects to course cards
        const courseCards = document.querySelectorAll('.course-card');
        courseCards.forEach(function(card) {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-5px)';
            });

            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });
    });
</script>
</body>
</html>