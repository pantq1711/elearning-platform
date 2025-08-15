<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ Cá Nhân - EduLearn Platform</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Chart.js CSS -->
    <link href="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/student.css" rel="stylesheet">

    <style>
        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }

        .profile-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 100%;
            height: 100%;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            transform: rotate(45deg);
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 4px solid rgba(255,255,255,0.3);
            object-fit: cover;
            position: relative;
            z-index: 2;
        }

        .profile-avatar-upload {
            position: absolute;
            bottom: -5px;
            right: -5px;
            background: #28a745;
            color: white;
            border: 3px solid white;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .profile-avatar-upload:hover {
            background: #218838;
            transform: scale(1.1);
        }

        .profile-info {
            position: relative;
            z-index: 2;
        }

        .stats-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            overflow: hidden;
        }

        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.15);
        }

        .stats-card .card-body {
            padding: 2rem;
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }

        .stat-value {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }

        .progress-chart {
            height: 300px;
        }

        .achievement-badge {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            margin-bottom: 1rem;
            position: relative;
            transition: all 0.3s ease;
        }

        .achievement-badge:hover {
            transform: scale(1.1);
        }

        .achievement-badge.earned {
            background: linear-gradient(135deg, #ffd700 0%, #ffed4e 100%);
            color: #333;
            box-shadow: 0 4px 15px rgba(255, 215, 0, 0.4);
        }

        .achievement-badge.locked {
            background: #e9ecef;
            color: #6c757d;
        }

        .course-progress-item {
            border: 1px solid #e9ecef;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }

        .course-progress-item:hover {
            border-color: #0d6efd;
            box-shadow: 0 2px 10px rgba(13, 110, 253, 0.1);
        }

        .progress-ring {
            transform: rotate(-90deg);
        }

        .activity-timeline {
            position: relative;
            padding-left: 2rem;
        }

        .activity-timeline::before {
            content: '';
            position: absolute;
            left: 1rem;
            top: 0;
            bottom: 0;
            width: 2px;
            background: #e9ecef;
        }

        .timeline-item {
            position: relative;
            margin-bottom: 2rem;
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .timeline-item::before {
            content: '';
            position: absolute;
            left: -2.5rem;
            top: 1.5rem;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #0d6efd;
            border: 3px solid white;
            box-shadow: 0 0 0 3px #e9ecef;
        }

        .form-floating-custom {
            position: relative;
        }

        .form-floating-custom .form-control {
            border-radius: 12px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
        }

        .form-floating-custom .form-control:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.25);
        }

        .notification-item {
            border-left: 4px solid;
            background: white;
            border-radius: 0 8px 8px 0;
            padding: 1rem 1.5rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }

        .notification-item:hover {
            transform: translateX(5px);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .notification-item.info { border-left-color: #17a2b8; }
        .notification-item.success { border-left-color: #28a745; }
        .notification-item.warning { border-left-color: #ffc107; }
        .notification-item.danger { border-left-color: #dc3545; }

        .certificate-preview {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border: 2px dashed #dee2e6;
            border-radius: 12px;
            padding: 2rem;
            text-align: center;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }

        .certificate-preview:hover {
            border-color: #0d6efd;
            background: linear-gradient(135deg, #e7f3ff 0%, #cce7ff 100%);
        }

        .tab-content-custom {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            padding: 2rem;
        }

        .nav-pills-custom .nav-link {
            border-radius: 12px;
            padding: 0.75rem 1.5rem;
            margin-right: 0.5rem;
            color: #6c757d;
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }

        .nav-pills-custom .nav-link:hover {
            background: #f8f9fa;
            color: #0d6efd;
        }

        .nav-pills-custom .nav-link.active {
            background: #0d6efd;
            color: white;
            border-color: #0d6efd;
        }
    </style>
</head>

<body>
<!-- Include Header -->
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container py-4">

    <!-- Profile Header -->
    <div class="profile-header">
        <div class="row align-items-center">
            <div class="col-md-3 text-center">
                <div class="position-relative d-inline-block">
                    <img src="${pageContext.request.contextPath}/images/avatars/${user.avatar}""
                         alt="Avatar" class="profile-avatar" id="avatarImage"
                         onerror="this.src='/images/avatar-default.png"'">
                    <div class="profile-avatar-upload" onclick="document.getElementById('avatarUpload').click()">
                        <i class="fas fa-camera"></i>
                    </div>
                    <input type="file" id="avatarUpload" accept="image/*" style="display: none;"
                           onchange="uploadAvatar(this)">
                </div>
            </div>
            <div class="col-md-9">
                <div class="profile-info">
                    <h1 class="h2 mb-2">${user.fullName}</h1>
                    <p class="h5 opacity-75 mb-3">${user.email}</p>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="d-flex align-items-center mb-2">
                                <i class="fas fa-calendar-alt me-2"></i>
                                <span>Tham gia: <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy" /></span>
                            </div>
                            <div class="d-flex align-items-center mb-2">
                                <i class="fas fa-map-marker-alt me-2"></i>
                                <span>${user.address != null ? user.address : 'Chưa cập nhật'}</span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="d-flex align-items-center mb-2">
                                <i class="fas fa-phone me-2"></i>
                                <span>${user.phone != null ? user.phone : 'Chưa cập nhật'}</span>
                            </div>
                            <div class="d-flex align-items-center mb-2">
                                <i class="fas fa-birthday-cake me-2"></i>
                                <span>
                                    <c:choose>
                                        <c:when test="${user.dateOfBirth != null}">
                                            <fmt:formatDate value="${user.dateOfBirth}" pattern="dd/MM/yyyy" />
                                        </c:when>
                                        <c:otherwise>Chưa cập nhật</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Stats Cards -->
    <div class="row mb-4">
        <div class="col-lg-3 col-md-6 mb-3">
            <div class="stats-card card h-100">
                <div class="card-body text-center">
                    <div class="stat-icon bg-primary bg-opacity-10 text-primary mx-auto">
                        <i class="fas fa-book"></i>
                    </div>
                    <div class="stat-value text-primary">${stats.totalCourses}</div>
                    <div class="text-muted">Khóa học đã đăng ký</div>
                </div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6 mb-3">
            <div class="stats-card card h-100">
                <div class="card-body text-center">
                    <div class="stat-icon bg-success bg-opacity-10 text-success mx-auto">
                        <i class="fas fa-graduation-cap"></i>
                    </div>
                    <div class="stat-value text-success">${stats.completedCourses}</div>
                    <div class="text-muted">Khóa học hoàn thành</div>
                </div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6 mb-3">
            <div class="stats-card card h-100">
                <div class="card-body text-center">
                    <div class="stat-icon bg-warning bg-opacity-10 text-warning mx-auto">
                        <i class="fas fa-trophy"></i>
                    </div>
                    <div class="stat-value text-warning">${stats.totalCertificates}</div>
                    <div class="text-muted">Chứng chỉ</div>
                </div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6 mb-3">
            <div class="stats-card card h-100">
                <div class="card-body text-center">
                    <div class="stat-icon bg-info bg-opacity-10 text-info mx-auto">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-value text-info">
                        <fmt:formatNumber value="${stats.totalStudyTime / 60}" maxFractionDigits="0" />h
                    </div>
                    <div class="text-muted">Thời gian học</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content Tabs -->
    <ul class="nav nav-pills nav-pills-custom mb-4" id="profileTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" id="overview-tab" data-bs-toggle="pill"
                    data-bs-target="#overview" type="button">
                <i class="fas fa-chart-line me-2"></i>Tổng quan
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="courses-tab" data-bs-toggle="pill"
                    data-bs-target="#courses" type="button">
                <i class="fas fa-book me-2"></i>Khóa học
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="achievements-tab" data-bs-toggle="pill"
                    data-bs-target="#achievements" type="button">
                <i class="fas fa-trophy me-2"></i>Thành tích
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="activity-tab" data-bs-toggle="pill"
                    data-bs-target="#activity" type="button">
                <i class="fas fa-history me-2"></i>Hoạt động
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="settings-tab" data-bs-toggle="pill"
                    data-bs-target="#settings" type="button">
                <i class="fas fa-cog me-2"></i>Cài đặt
            </button>
        </li>
    </ul>

    <!-- Tab Content -->
    <div class="tab-content tab-content-custom" id="profileTabsContent">

        <!-- Overview Tab -->
        <div class="tab-pane fade show active" id="overview" role="tabpanel">
            <div class="row">
                <!-- Learning Progress Chart -->
                <div class="col-lg-8 mb-4">
                    <h5 class="mb-4">
                        <i class="fas fa-chart-area me-2"></i>Tiến Độ Học Tập
                    </h5>
                    <div class="progress-chart">
                        <canvas id="progressChart"></canvas>
                    </div>
                </div>

                <!-- Recent Notifications -->
                <div class="col-lg-4 mb-4">
                    <h5 class="mb-4">
                        <i class="fas fa-bell me-2"></i>Thông Báo Gần Đây
                    </h5>
                    <div class="notifications-list">
                        <c:choose>
                            <c:when test="${not empty notifications}">
                                <c:forEach items="${notifications}" var="notification" varStatus="status">
                                    <div class="notification-item ${notification.type}">
                                        <div class="d-flex align-items-start">
                                            <div class="me-3">
                                                <i class="fas fa-${notification.type == 'success' ? 'check-circle' :
                                                                   notification.type == 'warning' ? 'exclamation-triangle' :
                                                                   notification.type == 'danger' ? 'exclamation-circle' :
                                                                   'info-circle'}"></i>
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="fw-medium">${notification.title}</div>
                                                <div class="small text-muted mt-1">${notification.message}</div>
                                                <div class="small text-muted">
                                                    <fmt:formatDate value="${notification.createdAt}" pattern="dd/MM HH:mm" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-4">
                                    <i class="fas fa-bell-slash text-muted fa-2x mb-2"></i>
                                    <p class="text-muted">Không có thông báo mới</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Quick Stats -->
            <div class="row">
                <div class="col-12">
                    <h5 class="mb-4">
                        <i class="fas fa-tachometer-alt me-2"></i>Thống Kê Nhanh
                    </h5>
                    <div class="row">
                        <div class="col-md-3 mb-3">
                            <div class="card border-0 bg-light">
                                <div class="card-body text-center">
                                    <i class="fas fa-calendar-week text-primary fa-2x mb-2"></i>
                                    <h6>Tuần này</h6>
                                    <p class="mb-0">${stats.thisWeekProgress} bài học</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="card border-0 bg-light">
                                <div class="card-body text-center">
                                    <i class="fas fa-fire text-danger fa-2x mb-2"></i>
                                    <h6>Streak</h6>
                                    <p class="mb-0">${stats.learningStreak} ngày</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="card border-0 bg-light">
                                <div class="card-body text-center">
                                    <i class="fas fa-star text-warning fa-2x mb-2"></i>
                                    <h6>Điểm trung bình</h6>
                                    <p class="mb-0">
                                        <fmt:formatNumber value="${stats.averageScore}" maxFractionDigits="1" />%
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="card border-0 bg-light">
                                <div class="card-body text-center">
                                    <i class="fas fa-chart-line text-success fa-2x mb-2"></i>
                                    <h6>Tiến độ tổng</h6>
                                    <p class="mb-0">
                                        <fmt:formatNumber value="${stats.overallProgress}" maxFractionDigits="0" />%
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Courses Tab -->
        <div class="tab-pane fade" id="courses" role="tabpanel">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="mb-0">
                    <i class="fas fa-book me-2"></i>Khóa Học Của Tôi
                </h5>
                <div class="btn-group" role="group">
                    <input type="radio" class="btn-check" name="courseFilter" id="allCourses" checked>
                    <label class="btn btn-outline-primary" for="allCourses">Tất cả</label>

                    <input type="radio" class="btn-check" name="courseFilter" id="inProgress">
                    <label class="btn btn-outline-primary" for="inProgress">Đang học</label>

                    <input type="radio" class="btn-check" name="courseFilter" id="completed">
                    <label class="btn btn-outline-primary" for="completed">Hoàn thành</label>
                </div>
            </div>

            <!-- Courses List -->
            <div class="courses-grid">
                <c:choose>
                    <c:when test="${not empty enrollments}">
                        <c:forEach items="${enrollments}" var="enrollment" varStatus="status">
                            <div class="course-progress-item"
                                 data-status="${enrollment.completed ? 'completed' : 'in-progress'}">
                                <div class="row align-items-center">
                                    <div class="col-md-2">
                                        <img src="${pageContext.request.contextPath}/images/courses/${enrollment.course.imageUrl}""
                                             alt="${enrollment.course.name}"
                                             class="img-fluid rounded"
                                             style="width: 80px; height: 60px; object-fit: cover;"
                                             onerror="this.src='/images/course-default.png"'">
                                    </div>
                                    <div class="col-md-6">
                                        <h6 class="mb-1">${enrollment.course.name}</h6>
                                        <p class="text-muted small mb-1">${enrollment.course.instructor.fullName}</p>
                                        <small class="text-muted">
                                            Đăng ký: <fmt:formatDate value="${enrollment.enrollmentDate}" pattern="dd/MM/yyyy" />
                                        </small>
                                    </div>
                                    <div class="col-md-2 text-center">
                                        <svg width="60" height="60" class="progress-ring">
                                            <circle cx="30" cy="30" r="25"
                                                    fill="none" stroke="#e9ecef" stroke-width="4"></circle>
                                            <circle cx="30" cy="30" r="25"
                                                    fill="none" stroke="#28a745" stroke-width="4"
                                                    stroke-linecap="round"
                                                    stroke-dasharray="${enrollment.progress * 157 / 100} 157"
                                                    transform="rotate(-90 30 30)"></circle>
                                            <text x="30" y="35" text-anchor="middle"
                                                  class="small fw-bold" fill="#333">
                                                <fmt:formatNumber value="${enrollment.progress}" maxFractionDigits="0" />%
                                            </text>
                                        </svg>
                                    </div>
                                    <div class="col-md-2 text-end">
                                        <div class="btn-group-vertical">
                                            <a href="${pageContext.request.contextPath}/student/courses/${enrollment.course.id}""
                                               class="btn btn-sm btn-primary mb-1">
                                                <i class="fas fa-play me-1"></i>Tiếp tục
                                            </a>
                                            <c:if test="${enrollment.completed}">
                                                <a href="${pageContext.request.contextPath}/student/courses/${enrollment.course.id}/certificate""
                                                   class="btn btn-sm btn-warning">
                                                    <i class="fas fa-certificate me-1"></i>Chứng chỉ
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5">
                            <i class="fas fa-book-open text-muted fa-3x mb-3"></i>
                            <h6 class="text-muted">Chưa có khóa học nào</h6>
                            <p class="text-muted">Khám phá và đăng ký các khóa học hấp dẫn</p>
                            <a href="${pageContext.request.contextPath}/courses"" class="btn btn-primary">
                                <i class="fas fa-search me-2"></i>Tìm khóa học
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Achievements Tab -->
        <div class="tab-pane fade" id="achievements" role="tabpanel">
            <h5 class="mb-4">
                <i class="fas fa-trophy me-2"></i>Thành Tích & Huy Hiệu
            </h5>

            <!-- Achievement Badges -->
            <div class="row mb-4">
                <c:forEach items="${achievements}" var="achievement" varStatus="status">
                    <div class="col-lg-3 col-md-4 col-6 mb-3">
                        <div class="text-center">
                            <div class="achievement-badge ${achievement.earned ? 'earned' : 'locked'} mx-auto">
                                <i class="fas fa-${achievement.icon}"></i>
                            </div>
                            <h6 class="mb-1">${achievement.name}</h6>
                            <p class="small text-muted mb-0">${achievement.description}</p>
                            <c:if test="${achievement.earned}">
                                <small class="text-success">
                                    <i class="fas fa-check me-1"></i>
                                    <fmt:formatDate value="${achievement.earnedDate}" pattern="dd/MM/yyyy" />
                                </small>
                            </c:if>
                            <c:if test="${not achievement.earned && not empty achievement.progress}">
                                <div class="progress mt-2" style="height: 4px;">
                                    <div class="progress-bar" style="width: ${achievement.progress}%"></div>
                                </div>
                                <small class="text-muted">${achievement.progress}% hoàn thành</small>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Certificates -->
            <h6 class="mb-3">
                <i class="fas fa-certificate me-2"></i>Chứng Chỉ
            </h6>
            <div class="row">
                <c:choose>
                    <c:when test="${not empty certificates}">
                        <c:forEach items="${certificates}" var="certificate" varStatus="status">
                            <div class="col-lg-4 col-md-6 mb-3">
                                <div class="certificate-preview">
                                    <i class="fas fa-award fa-2x text-warning mb-2"></i>
                                    <h6>${certificate.courseName}</h6>
                                    <p class="small text-muted mb-2">
                                        Hoàn thành: <fmt:formatDate value="${certificate.issuedDate}" pattern="dd/MM/yyyy" />
                                    </p>
                                    <div class="btn-group">
                                        <a href="${certificate.downloadUrl}" class="btn btn-sm btn-primary">
                                            <i class="fas fa-download me-1"></i>Tải xuống
                                        </a>
                                        <button class="btn btn-sm btn-outline-secondary"
                                                onclick="shareCertificate('${certificate.id}')">
                                            <i class="fas fa-share me-1"></i>Chia sẻ
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-12">
                            <div class="text-center py-4">
                                <i class="fas fa-certificate text-muted fa-3x mb-3"></i>
                                <h6 class="text-muted">Chưa có chứng chỉ nào</h6>
                                <p class="text-muted">Hoàn thành các khóa học để nhận chứng chỉ</p>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Activity Tab -->
        <div class="tab-pane fade" id="activity" role="tabpanel">
            <h5 class="mb-4">
                <i class="fas fa-history me-2"></i>Lịch Sử Hoạt Động
            </h5>

            <!-- Activity Timeline -->
            <div class="activity-timeline">
                <c:choose>
                    <c:when test="${not empty activities}">
                        <c:forEach items="${activities}" var="activity" varStatus="status">
                            <div class="timeline-item">
                                <div class="d-flex align-items-start">
                                    <div class="me-3">
                                        <i class="fas fa-${activity.type == 'ENROLLMENT' ? 'user-plus text-success' :
                                                           activity.type == 'COMPLETION' ? 'graduation-cap text-primary' :
                                                           activity.type == 'QUIZ' ? 'question-circle text-warning' :
                                                           activity.type == 'LESSON' ? 'play-circle text-info' :
                                                           'eye text-secondary'} fa-lg"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="fw-medium">${activity.title}</div>
                                        <p class="text-muted mb-1">${activity.description}</p>
                                        <small class="text-muted">
                                            <fmt:formatDate value="${activity.timestamp}" pattern="dd/MM/yyyy HH:mm" />
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5">
                            <i class="fas fa-history text-muted fa-3x mb-3"></i>
                            <h6 class="text-muted">Chưa có hoạt động nào</h6>
                            <p class="text-muted">Bắt đầu học để xem lịch sử hoạt động</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Settings Tab -->
        <div class="tab-pane fade" id="settings" role="tabpanel">
            <h5 class="mb-4">
                <i class="fas fa-cog me-2"></i>Cài Đặt Tài Khoản
            </h5>

            <!-- Profile Update Form -->
            <form:form method="POST" modelAttribute="user" student/profile/update"
                       cssClass="needs-validation" novalidate="true">
                <form:hidden path="id" />

                <div class="row">
                    <!-- Personal Information -->
                    <div class="col-lg-6">
                        <h6 class="mb-3">Thông tin cá nhân</h6>

                        <div class="form-floating-custom mb-3">
                            <form:input path="fullName" cssClass="form-control" placeholder="Họ và tên" required="true" />
                            <label for="fullName">Họ và tên *</label>
                            <form:errors path="fullName" cssClass="text-danger small" />
                        </div>

                        <div class="form-floating-custom mb-3">
                            <form:input path="email" type="email" cssClass="form-control"
                                        placeholder="Email" required="true" readonly="true" />
                            <label for="email">Email</label>
                            <small class="text-muted">Email không thể thay đổi</small>
                        </div>

                        <div class="form-floating-custom mb-3">
                            <form:input path="phone" cssClass="form-control" placeholder="Số điện thoại" />
                            <label for="phone">Số điện thoại</label>
                            <form:errors path="phone" cssClass="text-danger small" />
                        </div>

                        <div class="form-floating-custom mb-3">
                            <form:input path="dateOfBirth" type="date" cssClass="form-control" />
                            <label for="dateOfBirth">Ngày sinh</label>
                            <form:errors path="dateOfBirth" cssClass="text-danger small" />
                        </div>

                        <div class="form-floating-custom mb-3">
                            <form:select path="gender" cssClass="form-select">
                                <form:option value="">Chọn giới tính</form:option>
                                <form:option value="MALE">Nam</form:option>
                                <form:option value="FEMALE">Nữ</form:option>
                                <form:option value="OTHER">Khác</form:option>
                            </form:select>
                            <label for="gender">Giới tính</label>
                        </div>
                    </div>

                    <!-- Contact Information -->
                    <div class="col-lg-6">
                        <h6 class="mb-3">Thông tin liên hệ</h6>

                        <div class="form-floating-custom mb-3">
                            <form:textarea path="address" cssClass="form-control"
                                           placeholder="Địa chỉ" rows="3" />
                            <label for="address">Địa chỉ</label>
                            <form:errors path="address" cssClass="text-danger small" />
                        </div>

                        <div class="form-floating-custom mb-3">
                            <form:textarea path="bio" cssClass="form-control"
                                           placeholder="Giới thiệu bản thân" rows="4" />
                            <label for="bio">Giới thiệu bản thân</label>
                            <small class="text-muted">Tối đa 500 ký tự</small>
                            <form:errors path="bio" cssClass="text-danger small" />
                        </div>

                        <!-- Notification Preferences -->
                        <h6 class="mb-3 mt-4">Tùy chọn thông báo</h6>

                        <div class="form-check form-switch mb-2">
                            <form:checkbox path="emailNotifications" cssClass="form-check-input" />
                            <label class="form-check-label" for="emailNotifications">
                                Nhận thông báo qua email
                            </label>
                        </div>

                        <div class="form-check form-switch mb-2">
                            <form:checkbox path="courseReminders" cssClass="form-check-input" />
                            <label class="form-check-label" for="courseReminders">
                                Nhắc nhở khóa học
                            </label>
                        </div>

                        <div class="form-check form-switch mb-3">
                            <form:checkbox path="marketingEmails" cssClass="form-check-input" />
                            <label class="form-check-label" for="marketingEmails">
                                Nhận email marketing
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="text-end mt-4">
                    <button type="button" class="btn btn-outline-secondary me-2" onclick="resetForm()">
                        <i class="fas fa-undo me-2"></i>Đặt lại
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i>Lưu thay đổi
                    </button>
                </div>
            </form:form>

            <!-- Change Password Section -->
            <hr class="my-5">
            <h6 class="mb-3">Đổi mật khẩu</h6>

            <form id="changePasswordForm" class="row">
                <div class="col-lg-6">
                    <div class="form-floating-custom mb-3">
                        <input type="password" class="form-control" id="currentPassword"
                               placeholder="Mật khẩu hiện tại" required>
                        <label for="currentPassword">Mật khẩu hiện tại *</label>
                    </div>
                    <div class="form-floating-custom mb-3">
                        <input type="password" class="form-control" id="newPassword"
                               placeholder="Mật khẩu mới" required minlength="6">
                        <label for="newPassword">Mật khẩu mới *</label>
                        <small class="text-muted">Tối thiểu 6 ký tự</small>
                    </div>
                    <div class="form-floating-custom mb-3">
                        <input type="password" class="form-control" id="confirmPassword"
                               placeholder="Xác nhận mật khẩu mới" required>
                        <label for="confirmPassword">Xác nhận mật khẩu mới *</label>
                    </div>
                    <button type="submit" class="btn btn-warning">
                        <i class="fas fa-key me-2"></i>Đổi mật khẩu
                    </button>
                </div>
            </form>
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
        initProgressChart();

        // Setup course filter
        setupCourseFilter();

        // Setup form validation
        setupFormValidation();

        // Setup change password form
        setupChangePasswordForm();
    });

    /**
     * Khởi tạo biểu đồ tiến độ
     */
    function initProgressChart() {
        const ctx = document.getElementById('progressChart');
        if (!ctx) return;

        // Dữ liệu mẫu - thực tế sẽ lấy từ server
        const data = {
            labels: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
            datasets: [{
                label: 'Thời gian học (phút)',
                data: [${weeklyProgress}], // Từ server
                borderColor: '#0d6efd',
                backgroundColor: 'rgba(13, 110, 253, 0.1)',
                tension: 0.4,
                fill: true
            }]
        };

        new Chart(ctx, {
            type: 'line',
            data: data,
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
                        ticks: {
                            callback: function(value) {
                                return value + 'p';
                            }
                        }
                    }
                }
            }
        });
    }

    /**
     * Setup course filter
     */
    function setupCourseFilter() {
        $('input[name="courseFilter"]').change(function() {
            const filter = $(this).attr('id');

            $('.course-progress-item').show();

            if (filter === 'inProgress') {
                $('.course-progress-item[data-status="completed"]').hide();
            } else if (filter === 'completed') {
                $('.course-progress-item[data-status="in-progress"]').hide();
            }
        });
    }

    /**
     * Upload avatar
     */
    function uploadAvatar(input) {
        if (input.files && input.files[0]) {
            const file = input.files[0];

            // Validate file type
            if (!file.type.match('image.*')) {
                showToast('Vui lòng chọn file hình ảnh', 'error');
                return;
            }

            // Validate file size (max 2MB)
            if (file.size > 2 * 1024 * 1024) {
                showToast('Kích thước file không được vượt quá 2MB', 'error');
                return;
            }

            const formData = new FormData();
            formData.append('avatar', file);

            $.ajax({
                url: '<c:url value="/student/profile/upload-avatar" />',
                method: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function(response) {
                    $('#avatarImage').attr('src', response.avatarUrl);
                    showToast('Đã cập nhật avatar thành công', 'success');
                },
                error: function() {
                    showToast('Có lỗi xảy ra khi upload avatar', 'error');
                }
            });
        }
    }

    /**
     * Setup form validation
     */
    function setupFormValidation() {
        const form = document.querySelector('.needs-validation');

        form.addEventListener('submit', function(event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }

            form.classList.add('was-validated');
        });
    }

    /**
     * Setup change password form
     */
    function setupChangePasswordForm() {
        $('#changePasswordForm').submit(function(e) {
            e.preventDefault();

            const currentPassword = $('#currentPassword').val();
            const newPassword = $('#newPassword').val();
            const confirmPassword = $('#confirmPassword').val();

            // Validate passwords match
            if (newPassword !== confirmPassword) {
                showToast('Mật khẩu mới không khớp', 'error');
                return;
            }

            // Validate password strength
            if (newPassword.length < 6) {
                showToast('Mật khẩu phải có ít nhất 6 ký tự', 'error');
                return;
            }

            $.ajax({
                url: '<c:url value="/student/profile/change-password" />',
                method: 'POST',
                data: {
                    currentPassword: currentPassword,
                    newPassword: newPassword
                },
                success: function() {
                    showToast('Đổi mật khẩu thành công', 'success');
                    $('#changePasswordForm')[0].reset();
                },
                error: function(xhr) {
                    const message = xhr.responseJSON?.message || 'Có lỗi xảy ra khi đổi mật khẩu';
                    showToast(message, 'error');
                }
            });
        });
    }

    /**
     * Reset form
     */
    function resetForm() {
        if (confirm('Bạn có chắc chắn muốn đặt lại form không?')) {
            location.reload();
        }
    }

    /**
     * Share certificate
     */
    function shareCertificate(certificateId) {
        const text = 'Tôi vừa nhận được chứng chỉ từ EduLearn Platform!';
        const url = '<c:url value="/certificates/" />' + certificateId;

        if (navigator.share) {
            navigator.share({
                title: 'Chứng chỉ EduLearn',
                text: text,
                url: url
            });
        } else {
            // Fallback - copy to clipboard
            navigator.clipboard.writeText(text + '\n' + url);
            showToast('Đã sao chép link chứng chỉ', 'success');
        }
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
</script>

</body>
</html>