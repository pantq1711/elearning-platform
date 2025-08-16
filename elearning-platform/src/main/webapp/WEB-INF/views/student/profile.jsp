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
    <title>Hồ Sơ Cá Nhân - EduLearn</title>

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

        /* Profile Header */
        .profile-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 3rem 0;
            position: relative;
            overflow: hidden;
        }

        .profile-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }

        .header-content {
            position: relative;
            z-index: 2;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .profile-info {
            display: flex;
            align-items: center;
            gap: 2rem;
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            font-weight: 700;
            border: 4px solid rgba(255, 255, 255, 0.3);
            position: relative;
            overflow: hidden;
        }

        .profile-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
        }

        .avatar-upload {
            position: absolute;
            bottom: 0;
            right: 0;
            width: 36px;
            height: 36px;
            background: var(--primary-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            border: 3px solid white;
            transition: all 0.3s ease;
        }

        .avatar-upload:hover {
            background: var(--secondary-color);
            transform: scale(1.1);
        }

        .profile-details h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .profile-role {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 1rem;
        }

        .profile-stats {
            display: flex;
            gap: 2rem;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 1.5rem;
            font-weight: 700;
            display: block;
        }

        .stat-label {
            font-size: 0.9rem;
            opacity: 0.8;
        }

        /* Profile Content */
        .profile-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        .content-tabs {
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            overflow: hidden;
            margin-bottom: 2rem;
        }

        .nav-tabs {
            border: none;
            background: var(--light-bg);
            padding: 0 2rem;
        }

        .nav-tabs .nav-link {
            border: none;
            background: none;
            color: var(--text-secondary);
            font-weight: 500;
            padding: 1rem 2rem;
            border-bottom: 3px solid transparent;
            transition: all 0.3s ease;
        }

        .nav-tabs .nav-link:hover {
            background: white;
            color: var(--text-primary);
        }

        .nav-tabs .nav-link.active {
            background: white;
            color: var(--primary-color);
            border-bottom-color: var(--primary-color);
        }

        .tab-content {
            padding: 2rem;
        }

        /* Profile Form */
        .profile-form {
            max-width: 600px;
        }

        .form-group {
            margin-bottom: 2rem;
        }

        .form-label {
            font-weight: 500;
            color: var(--text-primary);
            margin-bottom: 0.75rem;
            display: block;
        }

        .form-control {
            border: 2px solid var(--border-color);
            border-radius: 0.75rem;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
            font-size: 0.95rem;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .form-control:disabled {
            background: var(--light-bg);
            color: var(--text-secondary);
        }

        .btn-save {
            background: var(--primary-color);
            border: none;
            color: white;
            padding: 0.75rem 2rem;
            border-radius: 0.75rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-save:hover {
            background: var(--secondary-color);
            color: white;
            transform: translateY(-2px);
        }

        .btn-edit {
            background: var(--info-color);
            border: none;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
            margin-left: 1rem;
        }

        .btn-edit:hover {
            background: #138496;
            color: white;
        }

        /* Learning Progress */
        .progress-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .progress-card {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: var(--card-shadow);
            text-align: center;
            transition: all 0.3s ease;
        }

        .progress-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
        }

        .progress-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            margin: 0 auto 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
        }

        .progress-icon.courses {
            background: var(--primary-color);
        }

        .progress-icon.certificates {
            background: var(--success-color);
        }

        .progress-icon.hours {
            background: var(--info-color);
        }

        .progress-icon.streak {
            background: var(--warning-color);
        }

        .progress-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .progress-label {
            color: var(--text-secondary);
            font-weight: 500;
        }

        .progress-description {
            font-size: 0.85rem;
            color: var(--text-secondary);
            margin-top: 0.5rem;
        }

        /* Certificates Grid */
        .certificates-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
        }

        .certificate-card {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: var(--card-shadow);
            text-align: center;
            border: 2px solid var(--border-color);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .certificate-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
        }

        .certificate-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px rgba(0,0,0,0.15);
            border-color: var(--primary-color);
        }

        .certificate-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--warning-color), #ffa000);
            border-radius: 50%;
            margin: 0 auto 1.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: white;
        }

        .certificate-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .certificate-course {
            color: var(--text-secondary);
            margin-bottom: 1rem;
        }

        .certificate-date {
            font-size: 0.85rem;
            color: var(--text-secondary);
            margin-bottom: 1.5rem;
        }

        .certificate-actions {
            display: flex;
            gap: 0.75rem;
            justify-content: center;
        }

        .btn-download {
            background: var(--primary-color);
            border: none;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-size: 0.85rem;
            transition: all 0.3s ease;
        }

        .btn-download:hover {
            background: var(--secondary-color);
            color: white;
        }

        .btn-share {
            border: 2px solid var(--primary-color);
            color: var(--primary-color);
            background: transparent;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-size: 0.85rem;
            transition: all 0.3s ease;
        }

        .btn-share:hover {
            background: var(--primary-color);
            color: white;
        }

        /* Recent Activity */
        .activity-list {
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            overflow: hidden;
        }

        .activity-header {
            background: var(--light-bg);
            padding: 1.5rem 2rem;
            border-bottom: 1px solid var(--border-color);
        }

        .activity-title {
            font-weight: 600;
            color: var(--text-primary);
            margin: 0;
        }

        .activity-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1.5rem 2rem;
            border-bottom: 1px solid var(--border-color);
            transition: all 0.3s ease;
        }

        .activity-item:hover {
            background: var(--light-bg);
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            flex-shrink: 0;
        }

        .activity-icon.lesson {
            background: var(--primary-color);
        }

        .activity-icon.certificate {
            background: var(--success-color);
        }

        .activity-icon.quiz {
            background: var(--info-color);
        }

        .activity-icon.course {
            background: var(--warning-color);
        }

        .activity-content {
            flex: 1;
        }

        .activity-action {
            font-weight: 500;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }

        .activity-details {
            font-size: 0.9rem;
            color: var(--text-secondary);
        }

        .activity-time {
            font-size: 0.85rem;
            color: var(--text-secondary);
            white-space: nowrap;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--text-secondary);
        }

        .empty-icon {
            font-size: 4rem;
            margin-bottom: 1.5rem;
            opacity: 0.5;
        }

        .empty-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .empty-description {
            margin-bottom: 2rem;
            line-height: 1.6;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .profile-info {
                flex-direction: column;
                text-align: center;
                gap: 1.5rem;
            }

            .profile-details h1 {
                font-size: 2rem;
            }

            .profile-stats {
                justify-content: center;
            }

            .profile-content {
                padding: 1rem;
            }

            .tab-content {
                padding: 1.5rem;
            }

            .progress-cards {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .certificates-grid {
                grid-template-columns: 1fr;
            }

            .activity-item {
                padding: 1rem;
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
        <!-- Profile Header -->
        <div class="profile-header">
            <div class="header-content">
                <div class="profile-info">
                    <div class="profile-avatar">
                        <c:choose>
                            <c:when test="${currentUser.profileImageUrl != null}">
                                <img src="${currentUser.profileImageUrl}" alt="Avatar">
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${currentUser.fullName != null}">
                                        ${fn:substring(currentUser.fullName, 0, 1)}
                                    </c:when>
                                    <c:otherwise>U</c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                        <div class="avatar-upload" onclick="uploadAvatar()">
                            <i class="fas fa-camera"></i>
                        </div>
                    </div>
                    <div class="profile-details">
                        <h1>
                            <c:choose>
                                <c:when test="${currentUser.fullName != null}">
                                    ${currentUser.fullName}
                                </c:when>
                                <c:otherwise>Học viên EduLearn</c:otherwise>
                            </c:choose>
                        </h1>
                        <div class="profile-role">
                            <i class="fas fa-graduation-cap me-2"></i>
                            Học viên
                        </div>
                        <div class="profile-stats">
                            <div class="stat-item">
                                <span class="stat-number">
                                    <c:choose>
                                        <c:when test="${stats != null && stats.totalEnrollments != null}">
                                            ${stats.totalEnrollments}
                                        </c:when>
                                        <c:otherwise>0</c:otherwise>
                                    </c:choose>
                                </span>
                                <div class="stat-label">Khóa học</div>
                            </div>
                            <div class="stat-item">
                                <span class="stat-number">
                                    <c:choose>
                                        <c:when test="${stats != null && stats.completedEnrollments != null}">
                                            ${stats.completedEnrollments}
                                        </c:when>
                                        <c:otherwise>0</c:otherwise>
                                    </c:choose>
                                </span>
                                <div class="stat-label">Hoàn thành</div>
                            </div>
                            <div class="stat-item">
                                <span class="stat-number">
                                    <c:choose>
                                        <c:when test="${stats != null && stats.completedEnrollments != null}">
                                            ${stats.completedEnrollments}
                                        </c:when>
                                        <c:otherwise>0</c:otherwise>
                                    </c:choose>
                                </span>
                                <div class="stat-label">Chứng chỉ</div>
                            </div>
                            <div class="stat-item">
                                <span class="stat-number">7</span>
                                <div class="stat-label">Ngày streak</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Profile Content -->
        <div class="profile-content">
            <!-- Content Tabs -->
            <div class="content-tabs">
                <ul class="nav nav-tabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#overview" type="button">
                            <i class="fas fa-chart-pie me-2"></i>Tổng quan
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#profile-edit" type="button">
                            <i class="fas fa-user-edit me-2"></i>Chỉnh sửa hồ sơ
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#certificates" type="button">
                            <i class="fas fa-certificate me-2"></i>Chứng chỉ
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#activity" type="button">
                            <i class="fas fa-history me-2"></i>Hoạt động
                        </button>
                    </li>
                </ul>

                <div class="tab-content">
                    <!-- Overview Tab -->
                    <div class="tab-pane fade show active" id="overview">
                        <!-- Progress Cards -->
                        <div class="progress-cards">
                            <div class="progress-card">
                                <div class="progress-icon courses">
                                    <i class="fas fa-book"></i>
                                </div>
                                <div class="progress-number">
                                    <c:choose>
                                        <c:when test="${stats != null && stats.totalEnrollments != null}">
                                            ${stats.totalEnrollments}
                                        </c:when>
                                        <c:otherwise>0</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="progress-label">Khóa học đã đăng ký</div>
                                <div class="progress-description">
                                    <c:choose>
                                        <c:when test="${stats != null && stats.activeEnrollments != null}">
                                            ${stats.activeEnrollments} đang học
                                        </c:when>
                                        <c:otherwise>0 đang học</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="progress-card">
                                <div class="progress-icon certificates">
                                    <i class="fas fa-certificate"></i>
                                </div>
                                <div class="progress-number">
                                    <c:choose>
                                        <c:when test="${stats != null && stats.completedEnrollments != null}">
                                            ${stats.completedEnrollments}
                                        </c:when>
                                        <c:otherwise>0</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="progress-label">Chứng chỉ đạt được</div>
                                <div class="progress-description">
                                    <c:choose>
                                        <c:when test="${stats != null && stats.completionRate != null}">
                                            <fmt:formatNumber value="${stats.completionRate}" maxFractionDigits="1"/>% tỷ lệ hoàn thành
                                        </c:when>
                                        <c:otherwise>0% tỷ lệ hoàn thành</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="progress-card">
                                <div class="progress-icon hours">
                                    <i class="fas fa-clock"></i>
                                </div>
                                <div class="progress-number">48</div>
                                <div class="progress-label">Giờ học tập</div>
                                <div class="progress-description">Tuần này: 8 giờ</div>
                            </div>

                            <div class="progress-card">
                                <div class="progress-icon streak">
                                    <i class="fas fa-fire"></i>
                                </div>
                                <div class="progress-number">7</div>
                                <div class="progress-label">Ngày học liên tiếp</div>
                                <div class="progress-description">Kỷ lục: 15 ngày</div>
                            </div>
                        </div>

                        <!-- Recent Courses -->
                        <div class="activity-list">
                            <div class="activity-header">
                                <h3 class="activity-title">Khóa học gần đây</h3>
                            </div>
                            <c:choose>
                                <c:when test="${recentEnrollments != null && fn:length(recentEnrollments) > 0}">
                                    <c:forEach var="enrollment" items="${recentEnrollments}" varStatus="status">
                                        <div class="activity-item">
                                            <div class="activity-icon course">
                                                <i class="fas fa-play"></i>
                                            </div>
                                            <div class="activity-content">
                                                <div class="activity-action">${enrollment.course.name}</div>
                                                <div class="activity-details">
                                                    Tiến độ: <strong>
                                                    <c:choose>
                                                        <c:when test="${enrollment.progress != null}">
                                                            <fmt:formatNumber value="${enrollment.progress}" maxFractionDigits="1"/>%
                                                        </c:when>
                                                        <c:otherwise>0%</c:otherwise>
                                                    </c:choose>
                                                </strong>
                                                    - Giảng viên: ${enrollment.course.instructor.fullName}
                                                </div>
                                            </div>
                                            <div class="activity-time">
                                                <c:if test="${enrollment.enrollmentDate != null}">
                                                    <fmt:formatDate value="${enrollment.enrollmentDate}" pattern="dd/MM/yyyy"/>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="activity-item">
                                        <div class="text-center w-100 py-3">
                                            <i class="fas fa-book-open fa-2x text-muted mb-2"></i>
                                            <p class="text-muted mb-0">Chưa có khóa học nào.</p>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Profile Edit Tab -->
                    <div class="tab-pane fade" id="profile-edit">
                        <form class="profile-form" action="${pageContext.request.contextPath}/student/profile/update" method="post">
                            <div class="form-group">
                                <label class="form-label">Họ và tên</label>
                                <input type="text" class="form-control" name="fullName"
                                       value="${currentUser.fullName}" required>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" name="email"
                                       value="${currentUser.email}" disabled>
                                <small class="text-muted">Email không thể thay đổi</small>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Username</label>
                                <input type="text" class="form-control" name="username"
                                       value="${currentUser.username}" disabled>
                                <small class="text-muted">Username không thể thay đổi</small>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Số điện thoại</label>
                                <input type="tel" class="form-control" name="phoneNumber"
                                       value="${currentUser.phoneNumber}">
                            </div>

                            <div class="form-group">
                                <label class="form-label">Giới thiệu</label>
                                <textarea class="form-control" name="bio" rows="4"
                                          placeholder="Viết vài dòng giới thiệu về bản thân...">${currentUser.bio}</textarea>
                            </div>

                            <div class="form-group">
                                <button type="submit" class="btn-save">
                                    <i class="fas fa-save me-2"></i>Lưu thay đổi
                                </button>
                            </div>
                        </form>

                        <!-- Change Password Section -->
                        <hr class="my-4">
                        <h4>Đổi mật khẩu</h4>
                        <form class="profile-form" action="${pageContext.request.contextPath}/student/profile/change-password" method="post">
                            <div class="form-group">
                                <label class="form-label">Mật khẩu hiện tại</label>
                                <input type="password" class="form-control" name="currentPassword" required>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Mật khẩu mới</label>
                                <input type="password" class="form-control" name="newPassword" required>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Xác nhận mật khẩu mới</label>
                                <input type="password" class="form-control" name="confirmPassword" required>
                            </div>

                            <div class="form-group">
                                <button type="submit" class="btn-save">
                                    <i class="fas fa-key me-2"></i>Đổi mật khẩu
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Certificates Tab -->
                    <div class="tab-pane fade" id="certificates">
                        <c:choose>
                            <c:when test="${certificates != null && fn:length(certificates) > 0}">
                                <div class="certificates-grid">
                                    <c:forEach var="certificate" items="${certificates}">
                                        <div class="certificate-card">
                                            <div class="certificate-icon">
                                                <i class="fas fa-award"></i>
                                            </div>
                                            <div class="certificate-title">${certificate.course.name}</div>
                                            <div class="certificate-course">
                                                Giảng viên: ${certificate.course.instructor.fullName}
                                            </div>
                                            <div class="certificate-date">
                                                Hoàn thành ngày:
                                                <c:if test="${certificate.issuedDate != null}">
                                                    <fmt:formatDate value="${certificate.issuedDate}" pattern="dd/MM/yyyy"/>
                                                </c:if>
                                            </div>
                                            <div class="certificate-actions">
                                                <a href="${pageContext.request.contextPath}/student/certificates/${certificate.id}/download"
                                                   class="btn-download">
                                                    <i class="fas fa-download me-1"></i>Tải về
                                                </a>
                                                <button class="btn-share" onclick="shareCertificate(${certificate.id})">
                                                    <i class="fas fa-share me-1"></i>Chia sẻ
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-certificate empty-icon"></i>
                                    <h3 class="empty-title">Chưa có chứng chỉ</h3>
                                    <p class="empty-description">
                                        Hoàn thành các khóa học để nhận chứng chỉ từ EduLearn.
                                        Chứng chỉ sẽ được cấp tự động khi bạn hoàn thành 100% khóa học.
                                    </p>
                                    <a href="${pageContext.request.contextPath}/student/browse" class="btn-save">
                                        <i class="fas fa-search me-2"></i>Khám phá khóa học
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Activity Tab -->
                    <div class="tab-pane fade" id="activity">
                        <div class="activity-list">
                            <div class="activity-header">
                                <h3 class="activity-title">Hoạt động gần đây</h3>
                            </div>

                            <!-- Sample activities -->
                            <div class="activity-item">
                                <div class="activity-icon lesson">
                                    <i class="fas fa-play"></i>
                                </div>
                                <div class="activity-content">
                                    <div class="activity-action">Hoàn thành bài học "Giới thiệu về Java"</div>
                                    <div class="activity-details">Khóa học: Lập trình Java cơ bản</div>
                                </div>
                                <div class="activity-time">2 giờ trước</div>
                            </div>

                            <div class="activity-item">
                                <div class="activity-icon certificate">
                                    <i class="fas fa-certificate"></i>
                                </div>
                                <div class="activity-content">
                                    <div class="activity-action">Nhận chứng chỉ "HTML & CSS Fundamentals"</div>
                                    <div class="activity-details">Điểm số: 95/100</div>
                                </div>
                                <div class="activity-time">1 ngày trước</div>
                            </div>

                            <div class="activity-item">
                                <div class="activity-icon quiz">
                                    <i class="fas fa-question-circle"></i>
                                </div>
                                <div class="activity-content">
                                    <div class="activity-action">Hoàn thành bài kiểm tra</div>
                                    <div class="activity-details">JavaScript Basics - Điểm: 87/100</div>
                                </div>
                                <div class="activity-time">2 ngày trước</div>
                            </div>

                            <div class="activity-item">
                                <div class="activity-icon course">
                                    <i class="fas fa-plus"></i>
                                </div>
                                <div class="activity-content">
                                    <div class="activity-action">Đăng ký khóa học mới</div>
                                    <div class="activity-details">React.js cho người mới bắt đầu</div>
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
    // Upload avatar
    function uploadAvatar() {
        const input = document.createElement('input');
        input.type = 'file';
        input.accept = 'image/*';
        input.onchange = function(e) {
            const file = e.target.files[0];
            if (file) {
                const formData = new FormData();
                formData.append('avatar', file);

                fetch('${pageContext.request.contextPath}/student/profile/upload-avatar', {
                    method: 'POST',
                    body: formData
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            location.reload();
                        } else {
                            alert('Có lỗi xảy ra khi tải ảnh lên: ' + data.message);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Có lỗi xảy ra khi tải ảnh lên.');
                    });
            }
        };
        input.click();
    }

    // Share certificate
    function shareCertificate(certificateId) {
        const shareUrl = `${window.location.origin}${pageContext.request.contextPath}/certificates/${certificateId}/public`;

        if (navigator.share) {
            navigator.share({
                title: 'Chứng chỉ từ EduLearn',
                text: 'Tôi vừa hoàn thành khóa học và nhận được chứng chỉ từ EduLearn!',
                url: shareUrl
            });
        } else {
            // Fallback - copy to clipboard
            navigator.clipboard.writeText(shareUrl).then(() => {
                alert('Đã sao chép link chứng chỉ vào clipboard!');
            });
        }
    }

    // Form validation
    document.querySelectorAll('form').forEach(form => {
        form.addEventListener('submit', function(e) {
            const requiredFields = form.querySelectorAll('[required]');
            let isValid = true;

            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    isValid = false;
                    field.classList.add('is-invalid');
                } else {
                    field.classList.remove('is-invalid');
                }
            });

            if (!isValid) {
                e.preventDefault();
                alert('Vui lòng điền đầy đủ thông tin bắt buộc.');
            }
        });
    });

    // Password confirmation validation
    const changePasswordForm = document.querySelector('form[action*="change-password"]');
    if (changePasswordForm) {
        const newPassword = changePasswordForm.querySelector('input[name="newPassword"]');
        const confirmPassword = changePasswordForm.querySelector('input[name="confirmPassword"]');

        confirmPassword.addEventListener('input', function() {
            if (newPassword.value !== confirmPassword.value) {
                confirmPassword.setCustomValidity('Mật khẩu xác nhận không khớp');
            } else {
                confirmPassword.setCustomValidity('');
            }
        });
    }

    // Card animations on load
    document.addEventListener('DOMContentLoaded', function() {
        const cards = document.querySelectorAll('.progress-card, .certificate-card');
        cards.forEach((card, index) => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            setTimeout(() => {
                card.style.transition = 'all 0.6s ease';
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, index * 100);
        });
    });

    // Tab change tracking
    document.querySelectorAll('.nav-tabs .nav-link').forEach(tab => {
        tab.addEventListener('shown.bs.tab', function(e) {
            const tabId = e.target.getAttribute('data-bs-target');
            console.log('Switched to tab:', tabId);

            // Track analytics if needed
            if (typeof gtag !== 'undefined') {
                gtag('event', 'page_view', {
                    page_title: 'Profile - ' + tabId.replace('#', ''),
                    page_location: window.location.href + tabId
                });
            }
        });
    });
</script>
</body>
</html>