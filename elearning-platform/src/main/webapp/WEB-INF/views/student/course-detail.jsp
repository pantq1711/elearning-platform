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
    <title>
        <c:choose>
            <c:when test="${course != null}">${course.name} - EduLearn</c:when>
            <c:otherwise>Chi tiết khóa học - EduLearn</c:otherwise>
        </c:choose>
    </title>

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

        /* Course Hero */
        .course-hero {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 3rem 0;
            position: relative;
            overflow: hidden;
        }

        .course-hero::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 400px;
            height: 400px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }

        .hero-content {
            position: relative;
            z-index: 2;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .breadcrumb-nav {
            margin-bottom: 2rem;
        }

        .breadcrumb {
            background: none;
            padding: 0;
            margin: 0;
        }

        .breadcrumb-item a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
        }

        .breadcrumb-item a:hover {
            color: white;
        }

        .breadcrumb-item.active {
            color: rgba(255, 255, 255, 0.6);
        }

        .breadcrumb-item + .breadcrumb-item::before {
            color: rgba(255, 255, 255, 0.6);
        }

        .course-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            line-height: 1.2;
        }

        .course-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 2rem;
            line-height: 1.6;
        }

        .course-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.9rem;
        }

        .meta-item i {
            opacity: 0.8;
        }

        .course-badges {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .course-badge {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 2rem;
            font-size: 0.9rem;
            font-weight: 500;
            backdrop-filter: blur(10px);
        }

        .badge-free {
            background: var(--success-color);
        }

        .badge-premium {
            background: var(--warning-color);
            color: #856404;
        }

        /* Course Content */
        .course-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        .content-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 3rem;
        }

        .main-content-area {
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            overflow: hidden;
        }

        .sidebar-area {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        /* Course Image */
        .course-image-container {
            position: relative;
            height: 300px;
            overflow: hidden;
        }

        .course-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .course-image-placeholder {
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 4rem;
        }

        .play-overlay {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 80px;
            height: 80px;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .play-overlay:hover {
            background: white;
            transform: translate(-50%, -50%) scale(1.1);
        }

        .play-overlay i {
            color: var(--primary-color);
            font-size: 2rem;
            margin-left: 0.25rem;
        }

        /* Course Tabs */
        .course-tabs {
            border-bottom: 1px solid var(--border-color);
        }

        .nav-tabs {
            border: none;
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
            background: var(--light-bg);
            color: var(--text-primary);
        }

        .nav-tabs .nav-link.active {
            background: none;
            color: var(--primary-color);
            border-bottom-color: var(--primary-color);
        }

        .tab-content {
            padding: 2rem;
        }

        /* Course Description */
        .course-description {
            line-height: 1.7;
            color: var(--text-primary);
        }

        .course-description h3 {
            color: var(--text-primary);
            margin-top: 2rem;
            margin-bottom: 1rem;
            font-size: 1.25rem;
            font-weight: 600;
        }

        .course-description ul {
            padding-left: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .course-description li {
            margin-bottom: 0.5rem;
        }

        /* Instructor Info */
        .instructor-card {
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            padding: 2rem;
        }

        .instructor-header {
            display: flex;
            gap: 1rem;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .instructor-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            font-weight: 700;
        }

        .instructor-info h4 {
            margin: 0 0 0.5rem 0;
            color: var(--text-primary);
            font-weight: 600;
        }

        .instructor-title {
            color: var(--text-secondary);
            font-size: 0.9rem;
        }

        .instructor-stats {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .stat-item {
            text-align: center;
            padding: 1rem;
            background: var(--light-bg);
            border-radius: 0.5rem;
        }

        .stat-number {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
            display: block;
        }

        .stat-label {
            font-size: 0.8rem;
            color: var(--text-secondary);
            margin-top: 0.25rem;
        }

        .instructor-bio {
            color: var(--text-secondary);
            line-height: 1.6;
        }

        /* Enrollment Card */
        .enrollment-card {
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            padding: 2rem;
            position: sticky;
            top: 2rem;
        }

        .price-section {
            text-align: center;
            margin-bottom: 2rem;
            padding-bottom: 2rem;
            border-bottom: 1px solid var(--border-color);
        }

        .course-price {
            font-size: 2rem;
            font-weight: 700;
            color: var(--success-color);
            margin-bottom: 0.5rem;
        }

        .price-free {
            color: var(--info-color);
        }

        .price-note {
            color: var(--text-secondary);
            font-size: 0.9rem;
        }

        .enrollment-actions {
            display: flex;
            flex-direction: column;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .btn-enroll {
            background: var(--primary-color);
            border: none;
            color: white;
            padding: 1rem 2rem;
            border-radius: 0.75rem;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            text-decoration: none;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .btn-enroll:hover {
            background: var(--secondary-color);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }

        .btn-enrolled {
            background: var(--success-color);
            cursor: default;
        }

        .btn-enrolled:hover {
            background: var(--success-color);
            transform: none;
            box-shadow: none;
        }

        .btn-preview {
            border: 2px solid var(--primary-color);
            color: var(--primary-color);
            background: transparent;
            padding: 0.75rem 2rem;
            border-radius: 0.75rem;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .btn-preview:hover {
            background: var(--primary-color);
            color: white;
        }

        .course-includes {
            margin-bottom: 2rem;
        }

        .includes-title {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
        }

        .includes-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .includes-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.5rem 0;
            color: var(--text-secondary);
        }

        .includes-item i {
            color: var(--success-color);
            width: 16px;
        }

        /* Lessons List */
        .lessons-container {
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            overflow: hidden;
        }

        .lessons-header {
            padding: 1.5rem 2rem;
            background: var(--light-bg);
            border-bottom: 1px solid var(--border-color);
        }

        .lessons-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin: 0;
        }

        .lessons-list {
            max-height: 400px;
            overflow-y: auto;
        }

        .lesson-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem 2rem;
            border-bottom: 1px solid var(--border-color);
            transition: all 0.3s ease;
        }

        .lesson-item:hover {
            background: var(--light-bg);
        }

        .lesson-item:last-child {
            border-bottom: none;
        }

        .lesson-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--light-bg);
            color: var(--text-secondary);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .lesson-icon.preview {
            background: var(--primary-color);
            color: white;
        }

        .lesson-icon.locked {
            background: var(--border-color);
        }

        .lesson-content {
            flex: 1;
        }

        .lesson-title {
            font-weight: 500;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }

        .lesson-title.locked {
            color: var(--text-secondary);
        }

        .lesson-meta {
            font-size: 0.85rem;
            color: var(--text-secondary);
            display: flex;
            gap: 1rem;
        }

        .lesson-actions {
            display: flex;
            gap: 0.5rem;
        }

        .btn-play {
            background: var(--primary-color);
            border: none;
            color: white;
            padding: 0.5rem;
            border-radius: 0.5rem;
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .btn-play:hover {
            background: var(--secondary-color);
            transform: scale(1.1);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .course-title {
                font-size: 2rem;
            }

            .course-meta {
                flex-direction: column;
                gap: 1rem;
            }

            .content-grid {
                grid-template-columns: 1fr;
                gap: 2rem;
            }

            .course-content {
                padding: 1rem;
            }

            .tab-content {
                padding: 1.5rem;
            }

            .instructor-stats {
                grid-template-columns: 1fr;
            }

            .enrollment-card {
                position: static;
                order: -1;
            }

            .lessons-list {
                max-height: 300px;
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
        <!-- Course Hero -->
        <div class="course-hero">
            <div class="hero-content">
                <!-- Breadcrumb -->
                <nav class="breadcrumb-nav">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/student/dashboard">
                                <i class="fas fa-home me-1"></i>Dashboard
                            </a>
                        </li>
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/student/browse">Khóa học</a>
                        </li>
                        <li class="breadcrumb-item active">
                            <c:choose>
                                <c:when test="${course != null}">${course.name}</c:when>
                                <c:otherwise>Chi tiết khóa học</c:otherwise>
                            </c:choose>
                        </li>
                    </ol>
                </nav>

                <c:if test="${course != null}">
                    <!-- Course Title -->
                    <h1 class="course-title">${course.name}</h1>

                    <!-- Course Subtitle -->
                    <p class="course-subtitle">
                        <c:choose>
                            <c:when test="${course.shortDescription != null}">
                                ${course.shortDescription}
                            </c:when>
                            <c:otherwise>
                                ${fn:substring(course.description, 0, 200)}
                                <c:if test="${fn:length(course.description) > 200}">...</c:if>
                            </c:otherwise>
                        </c:choose>
                    </p>

                    <!-- Course Meta -->
                    <div class="course-meta">
                        <div class="meta-item">
                            <i class="fas fa-user"></i>
                            <span>
                                <c:choose>
                                    <c:when test="${course.instructor != null}">
                                        ${course.instructor.fullName}
                                    </c:when>
                                    <c:otherwise>Chưa có giảng viên</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-star"></i>
                            <span>
                                <c:choose>
                                    <c:when test="${course.ratingAverage != null}">
                                        <fmt:formatNumber value="${course.ratingAverage}" pattern="#.#" maxFractionDigits="1"/>
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                                (
                                <c:choose>
                                    <c:when test="${course.ratingCount != null}">${course.ratingCount}</c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                                đánh giá)
                            </span>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-users"></i>
                            <span>
                                <c:choose>
                                    <c:when test="${course.enrollmentCount != null}">${course.enrollmentCount}</c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                                học viên
                            </span>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-clock"></i>
                            <span>
                                <c:choose>
                                    <c:when test="${course.duration != null}">
                                        <fmt:formatNumber value="${course.duration / 60}" maxFractionDigits="1"/>h
                                    </c:when>
                                    <c:otherwise>0h</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-calendar"></i>
                            <span>
                                <c:if test="${course.createdAt != null}">
                                    <fmt:formatDate value="${course.createdAt}" pattern="dd/MM/yyyy"/>
                                </c:if>
                            </span>
                        </div>
                    </div>

                    <!-- Course Badges -->
                    <div class="course-badges">
                        <c:if test="${course.featured}">
                            <span class="course-badge">
                                <i class="fas fa-star me-1"></i>Nổi bật
                            </span>
                        </c:if>
                        <span class="course-badge
                            <c:choose>
                                <c:when test='${course.price == null || course.price == 0}'>badge-free</c:when>
                                <c:otherwise>badge-premium</c:otherwise>
                            </c:choose>">
                            <c:choose>
                                <c:when test="${course.price == null || course.price == 0}">
                                    <i class="fas fa-gift me-1"></i>Miễn phí
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-crown me-1"></i>Trả phí
                                </c:otherwise>
                            </c:choose>
                        </span>
                        <span class="course-badge">
                            <i class="fas fa-signal me-1"></i>
                            <c:choose>
                                <c:when test="${course.difficultyLevel == 'EASY'}">Cơ bản</c:when>
                                <c:when test="${course.difficultyLevel == 'MEDIUM'}">Trung cấp</c:when>
                                <c:when test="${course.difficultyLevel == 'HARD'}">Nâng cao</c:when>
                                <c:otherwise>Cơ bản</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Course Content -->
        <div class="course-content">
            <div class="content-grid">
                <!-- Main Content Area -->
                <div class="main-content-area">
                    <!-- Course Image/Video -->
                    <div class="course-image-container">
                        <c:choose>
                            <c:when test="${course != null && course.imageUrl != null && !empty course.imageUrl}">
                                <img src="${course.imageUrl}" alt="${course.name}" class="course-image">
                            </c:when>
                            <c:otherwise>
                                <div class="course-image-placeholder">
                                    <i class="fas fa-graduation-cap"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <c:if test="${course != null && course.videoPreviewUrl != null}">
                            <div class="play-overlay" onclick="playPreview()">
                                <i class="fas fa-play"></i>
                            </div>
                        </c:if>
                    </div>

                    <!-- Course Tabs -->
                    <div class="course-tabs">
                        <ul class="nav nav-tabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#overview" type="button">
                                    Tổng quan
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" data-bs-toggle="tab" data-bs-target="#curriculum" type="button">
                                    Chương trình học
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" data-bs-toggle="tab" data-bs-target="#instructor" type="button">
                                    Giảng viên
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" data-bs-toggle="tab" data-bs-target="#reviews" type="button">
                                    Đánh giá
                                </button>
                            </li>
                        </ul>
                    </div>

                    <!-- Tab Content -->
                    <div class="tab-content">
                        <!-- Overview Tab -->
                        <div class="tab-pane fade show active" id="overview">
                            <div class="course-description">
                                <c:if test="${course != null}">
                                    <h3>Mô tả khóa học</h3>
                                    <p>${course.description}</p>

                                    <c:if test="${course.learningObjectives != null}">
                                        <h3>Mục tiêu học tập</h3>
                                        <div>${course.learningObjectives}</div>
                                    </c:if>

                                    <c:if test="${course.prerequisites != null}">
                                        <h3>Yêu cầu</h3>
                                        <div>${course.prerequisites}</div>
                                    </c:if>

                                    <c:if test="${course.targetAudience != null}">
                                        <h3>Đối tượng học viên</h3>
                                        <div>${course.targetAudience}</div>
                                    </c:if>
                                </c:if>
                            </div>
                        </div>

                        <!-- Curriculum Tab -->
                        <div class="tab-pane fade" id="curriculum">
                            <c:choose>
                                <c:when test="${lessons != null && fn:length(lessons) > 0}">
                                    <div class="lessons-list">
                                        <c:forEach var="lesson" items="${lessons}" varStatus="lessonStatus">
                                            <div class="lesson-item">
                                                <div class="lesson-icon
                                                    <c:choose>
                                                        <c:when test='${lesson.preview}'>preview</c:when>
                                                        <c:when test='${!isEnrolled}'>locked</c:when>
                                                        <c:otherwise></c:otherwise>
                                                    </c:choose>">
                                                    <c:choose>
                                                        <c:when test="${lesson.preview}">
                                                            <i class="fas fa-play"></i>
                                                        </c:when>
                                                        <c:when test="${!isEnrolled}">
                                                            <i class="fas fa-lock"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="fas fa-play-circle"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="lesson-content">
                                                    <div class="lesson-title
                                                        <c:if test='${!lesson.preview && !isEnrolled}'>locked</c:if>">
                                                            ${lessonStatus.index + 1}. ${lesson.title}
                                                    </div>
                                                    <div class="lesson-meta">
                                                        <c:if test="${lesson.estimatedDuration != null}">
                                                            <span>
                                                                <i class="fas fa-clock me-1"></i>
                                                                ${lesson.estimatedDuration} phút
                                                            </span>
                                                        </c:if>
                                                        <c:if test="${lesson.preview}">
                                                            <span class="text-success">
                                                                <i class="fas fa-eye me-1"></i>
                                                                Xem trước miễn phí
                                                            </span>
                                                        </c:if>
                                                    </div>
                                                </div>
                                                <div class="lesson-actions">
                                                    <c:if test="${lesson.preview || isEnrolled}">
                                                        <button class="btn-play" onclick="playLesson(${lesson.id})">
                                                            <i class="fas fa-play"></i>
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-4">
                                        <i class="fas fa-book-open fa-3x text-muted mb-3"></i>
                                        <p class="text-muted">Chưa có bài học nào trong khóa học này.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Instructor Tab -->
                        <div class="tab-pane fade" id="instructor">
                            <c:if test="${course != null && course.instructor != null}">
                                <div class="instructor-header">
                                    <div class="instructor-avatar">
                                            ${fn:substring(course.instructor.fullName, 0, 1)}
                                    </div>
                                    <div class="instructor-info">
                                        <h4>${course.instructor.fullName}</h4>
                                        <div class="instructor-title">Giảng viên chuyên nghiệp</div>
                                    </div>
                                </div>

                                <div class="instructor-stats">
                                    <div class="stat-item">
                                        <span class="stat-number">5</span>
                                        <div class="stat-label">Khóa học</div>
                                    </div>
                                    <div class="stat-item">
                                        <span class="stat-number">
                                            <c:choose>
                                                <c:when test="${course.enrollmentCount != null}">${course.enrollmentCount}</c:when>
                                                <c:otherwise>0</c:otherwise>
                                            </c:choose>
                                        </span>
                                        <div class="stat-label">Học viên</div>
                                    </div>
                                </div>

                                <div class="instructor-bio">
                                    <c:choose>
                                        <c:when test="${course.instructor.bio != null}">
                                            ${course.instructor.bio}
                                        </c:when>
                                        <c:otherwise>
                                            Giảng viên giàu kinh nghiệm với nhiều năm trong lĩnh vực ${course.category.name}.
                                            Cam kết mang đến những kiến thức chất lượng và thực tế nhất cho học viên.
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:if>
                        </div>

                        <!-- Reviews Tab -->
                        <div class="tab-pane fade" id="reviews">
                            <div class="text-center py-4">
                                <i class="fas fa-star fa-3x text-muted mb-3"></i>
                                <p class="text-muted">Chức năng đánh giá sẽ được cập nhật sớm.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Sidebar Area -->
                <div class="sidebar-area">
                    <!-- Enrollment Card -->
                    <div class="enrollment-card">
                        <!-- Price Section -->
                        <div class="price-section">
                            <div class="course-price
                                <c:if test='${course != null && (course.price == null || course.price == 0)}'>price-free</c:if>">
                                <c:choose>
                                    <c:when test="${course != null && (course.price == null || course.price == 0)}">
                                        Miễn phí
                                    </c:when>
                                    <c:when test="${course != null}">
                                        <fmt:formatNumber value="${course.price}" type="number" groupingUsed="true"/>đ
                                    </c:when>
                                    <c:otherwise>
                                        Liên hệ
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="price-note">
                                <c:choose>
                                    <c:when test="${course != null && (course.price == null || course.price == 0)}">
                                        Truy cập trọn đời
                                    </c:when>
                                    <c:otherwise>
                                        Một lần thanh toán, truy cập mãi mãi
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Enrollment Actions -->
                        <div class="enrollment-actions">
                            <c:choose>
                                <c:when test="${isEnrolled}">
                                    <a href="${pageContext.request.contextPath}/student/courses/${course.id}/learn"
                                       class="btn-enroll btn-enrolled">
                                        <i class="fas fa-check me-2"></i>Đã đăng ký - Tiếp tục học
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/student/courses/${course.id}/enroll"
                                       class="btn-enroll">
                                        <i class="fas fa-plus me-2"></i>Đăng ký ngay
                                    </a>
                                </c:otherwise>
                            </c:choose>

                            <a href="${pageContext.request.contextPath}/student/browse" class="btn-preview">
                                <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                            </a>
                        </div>

                        <!-- Course Includes -->
                        <div class="course-includes">
                            <div class="includes-title">Khóa học bao gồm:</div>
                            <ul class="includes-list">
                                <li class="includes-item">
                                    <i class="fas fa-play-circle"></i>
                                    <span>
                                        <c:choose>
                                            <c:when test="${lessons != null}">${fn:length(lessons)}</c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                        bài học video
                                    </span>
                                </li>
                                <li class="includes-item">
                                    <i class="fas fa-clock"></i>
                                    <span>
                                        <c:choose>
                                            <c:when test="${course != null && course.duration != null}">
                                                <fmt:formatNumber value="${course.duration / 60}" maxFractionDigits="1"/>
                                            </c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                        giờ nội dung
                                    </span>
                                </li>
                                <li class="includes-item">
                                    <i class="fas fa-mobile-alt"></i>
                                    <span>Truy cập trên điện thoại và máy tính</span>
                                </li>
                                <li class="includes-item">
                                    <i class="fas fa-infinity"></i>
                                    <span>Truy cập trọn đời</span>
                                </li>
                                <c:if test="${course != null && course.certificateAvailable}">
                                    <li class="includes-item">
                                        <i class="fas fa-certificate"></i>
                                        <span>Chứng chỉ hoàn thành</span>
                                    </li>
                                </c:if>
                            </ul>
                        </div>
                    </div>

                    <!-- Instructor Card -->
                    <c:if test="${course != null && course.instructor != null}">
                        <div class="instructor-card">
                            <div class="instructor-header">
                                <div class="instructor-avatar">
                                        ${fn:substring(course.instructor.fullName, 0, 1)}
                                </div>
                                <div class="instructor-info">
                                    <h4>${course.instructor.fullName}</h4>
                                    <div class="instructor-title">Giảng viên</div>
                                </div>
                            </div>
                            <div class="instructor-bio">
                                <c:choose>
                                    <c:when test="${course.instructor.bio != null}">
                                        ${fn:substring(course.instructor.bio, 0, 150)}
                                        <c:if test="${fn:length(course.instructor.bio) > 150}">...</c:if>
                                    </c:when>
                                    <c:otherwise>
                                        Giảng viên có nhiều năm kinh nghiệm trong lĩnh vực ${course.category.name}.
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Play preview video
    function playPreview() {
        // Implementation for playing preview video
        alert('Chức năng xem trước video sẽ được cập nhật sớm!');
    }

    // Play lesson
    function playLesson(lessonId) {
        <c:choose>
        <c:when test="${isEnrolled}">
        window.location.href = `${pageContext.request.contextPath}/student/lesson/${lessonId}`;
        </c:when>
        <c:otherwise>
        // For preview lessons
        window.location.href = `${pageContext.request.contextPath}/lessons/${lessonId}/preview`;
        </c:otherwise>
        </c:choose>
    }

    // Enrollment confirmation
    document.querySelectorAll('.btn-enroll:not(.btn-enrolled)').forEach(btn => {
        btn.addEventListener('click', function(e) {
            if (!confirm('Bạn có chắc muốn đăng ký khóa học này?')) {
                e.preventDefault();
            }
        });
    });

    // Smooth scroll for tab navigation
    document.querySelectorAll('.nav-tabs .nav-link').forEach(tab => {
        tab.addEventListener('shown.bs.tab', function() {
            document.querySelector('.course-tabs').scrollIntoView({
                behavior: 'smooth'
            });
        });
    });

    // Animation on load
    document.addEventListener('DOMContentLoaded', function() {
        const cards = document.querySelectorAll('.enrollment-card, .instructor-card');
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
</script>
</body>
</html>