<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%-- Utility functions để tránh NumberFormatException --%>
<c:set var="safeParseInt" value="${param.value != null and param.value != '' ? param.value : '0'}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${course.name} - EduLearn Platform</title>

    <!-- Meta tags cho SEO -->
    <meta name="description" content="${course.shortDescription}">
    <meta name="keywords" content="${course.name}, ${course.category.name}, học trực tuyến, EduLearn">
    <meta name="author" content="${course.instructor.fullName}">

    <!-- Open Graph cho social media -->
    <meta property="og:title" content="${course.name}">
    <meta property="og:description" content="${course.shortDescription}">
    <meta property="og:image" content="${pageContext.request.scheme}://${pageContext.request.serverName}${pageContext.request.contextPath}/images/courses/${course.thumbnail}">
    <meta property="og:type" content="website">

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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
            --card-shadow-hover: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--light-bg);
        }

        .course-hero {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 2rem 0;
        }

        .breadcrumb {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 0.5rem;
            padding: 0.5rem 1rem;
            margin-bottom: 1rem;
        }

        .breadcrumb-item a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
        }

        .breadcrumb-item.active {
            color: white;
        }

        .course-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            line-height: 1.2;
        }

        .course-subtitle {
            font-size: 1.2rem;
            opacity: 0.9;
            margin-bottom: 1.5rem;
            line-height: 1.4;
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
        }

        .meta-icon {
            width: 20px;
            text-align: center;
        }

        .course-badges {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }

        .course-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 2rem;
            font-size: 0.75rem;
            font-weight: 600;
            background: rgba(255, 255, 255, 0.2);
            color: white;
        }

        .badge-featured {
            background: var(--warning-color);
        }

        .badge-bestseller {
            background: var(--success-color);
        }

        .main-content {
            margin-top: -3rem;
            position: relative;
            z-index: 10;
        }

        .content-card {
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .course-sidebar {
            position: sticky;
            top: 100px;
        }

        .course-preview {
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            overflow: hidden;
            margin-bottom: 2rem;
        }

        .preview-video {
            width: 100%;
            height: 200px;
            background: #000;
            position: relative;
            cursor: pointer;
        }

        .preview-video img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .play-button {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 60px;
            height: 60px;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: var(--primary-color);
            transition: all 0.3s ease;
        }

        .play-button:hover {
            background: white;
            transform: translate(-50%, -50%) scale(1.1);
        }

        .pricing-card {
            padding: 1.5rem;
        }

        .price-section {
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .current-price {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-color);
        }

        .original-price {
            font-size: 1.2rem;
            color: #9ca3af;
            text-decoration: line-through;
            margin-left: 0.5rem;
        }

        .discount-badge {
            background: var(--danger-color);
            color: white;
            padding: 0.25rem 0.5rem;
            border-radius: 0.25rem;
            font-size: 0.75rem;
            font-weight: 600;
            margin-left: 0.5rem;
        }

        .price-free {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--success-color);
        }

        .enroll-btn {
            width: 100%;
            padding: 1rem;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 0.5rem;
            margin-bottom: 1rem;
        }

        .btn-enroll {
            background: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }

        .btn-enroll:hover {
            background: var(--primary-dark);
            border-color: var(--primary-dark);
            color: white;
        }

        .btn-enrolled {
            background: var(--success-color);
            border-color: var(--success-color);
            color: white;
        }

        .course-includes {
            list-style: none;
            padding: 0;
        }

        .course-includes li {
            display: flex;
            align-items: center;
            margin-bottom: 0.75rem;
            color: #374151;
        }

        .course-includes i {
            color: var(--success-color);
            margin-right: 0.75rem;
            width: 16px;
        }

        .instructor-card {
            display: flex;
            align-items: center;
            padding: 1.5rem;
            background: #f9fafb;
            border-radius: 0.75rem;
            margin-bottom: 1rem;
        }

        .instructor-avatar-placeholder {
            width: 60px;
            height: 60px;
            background: var(--primary-color);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            margin-right: 1rem;
        }

        .instructor-info h6 {
            margin-bottom: 0.25rem;
            color: #1f2937;
        }

        .instructor-role {
            color: #6b7280;
            font-size: 0.875rem;
            margin-bottom: 0.5rem;
        }

        .instructor-stats {
            display: flex;
            gap: 1rem;
            font-size: 0.75rem;
            color: #6b7280;
        }

        .stats-item {
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .section-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 0.75rem;
            color: var(--primary-color);
        }

        .course-description {
            line-height: 1.7;
            color: #374151;
        }

        .course-description h3 {
            color: #1f2937;
            margin-top: 2rem;
            margin-bottom: 1rem;
        }

        .course-description ul,
        .course-description ol {
            margin-bottom: 1.5rem;
        }

        .course-description li {
            margin-bottom: 0.5rem;
        }

        .curriculum-section {
            margin-bottom: 1rem;
        }

        .section-header {
            background: #f9fafb;
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 0.5rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .section-header:hover {
            background: #f3f4f6;
        }

        .section-title-curriculum {
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 0.25rem;
        }

        .section-meta {
            font-size: 0.875rem;
            color: #6b7280;
            display: flex;
            justify-content: space-between;
        }

        .lesson-list {
            background: #fafafa;
            border-radius: 0.5rem;
            overflow: hidden;
        }

        .lesson-item {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .lesson-item:last-child {
            border-bottom: none;
        }

        .lesson-info {
            display: flex;
            align-items: center;
        }

        .lesson-icon {
            width: 20px;
            margin-right: 0.75rem;
            color: #6b7280;
        }

        .lesson-title {
            color: #374151;
            font-weight: 500;
        }

        .lesson-duration {
            font-size: 0.875rem;
            color: #6b7280;
        }

        .review-card {
            background: #f9fafb;
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 1rem;
        }

        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .reviewer-info {
            display: flex;
            align-items: center;
        }

        .reviewer-avatar-placeholder {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            margin-right: 0.75rem;
        }

        .reviewer-name {
            font-weight: 600;
            color: #1f2937;
        }

        .review-date {
            font-size: 0.875rem;
            color: #6b7280;
        }

        .review-rating {
            display: flex;
            gap: 0.125rem;
        }

        .review-content {
            color: #374151;
            line-height: 1.6;
        }

        .rating-overview {
            background: #f9fafb;
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .rating-summary {
            display: flex;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .overall-rating {
            font-size: 3rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-right: 1rem;
        }

        .rating-details {
            flex: 1;
        }

        .rating-stars {
            display: flex;
            gap: 0.25rem;
            margin-bottom: 0.5rem;
        }

        .rating-text {
            color: #6b7280;
        }

        .rating-breakdown {
            list-style: none;
            padding: 0;
        }

        .rating-row {
            display: flex;
            align-items: center;
            margin-bottom: 0.5rem;
        }

        .rating-label {
            width: 60px;
            font-size: 0.875rem;
            color: #6b7280;
        }

        .rating-bar {
            flex: 1;
            height: 8px;
            background: #e5e7eb;
            border-radius: 4px;
            margin: 0 0.75rem;
            overflow: hidden;
        }

        .rating-fill {
            height: 100%;
            background: var(--warning-color);
        }

        .rating-count {
            width: 40px;
            font-size: 0.875rem;
            color: #6b7280;
            text-align: right;
        }

        .related-courses {
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            padding: 1.5rem;
        }

        .course-card-small {
            display: flex;
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #f3f4f6;
        }

        .course-card-small:last-child {
            margin-bottom: 0;
            padding-bottom: 0;
            border-bottom: none;
        }

        .course-thumbnail {
            width: 80px;
            height: 60px;
            border-radius: 0.5rem;
            margin-right: 1rem;
            object-fit: cover;
        }

        .course-info-small {
            flex: 1;
        }

        .course-title-small {
            font-size: 0.875rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 0.25rem;
            line-height: 1.4;
        }

        .course-title-small a {
            color: inherit;
            text-decoration: none;
        }

        .course-title-small a:hover {
            color: var(--primary-color);
        }

        .course-price-small {
            font-weight: 600;
            color: var(--primary-color);
        }

        .empty-reviews {
            text-align: center;
            padding: 3rem 1rem;
            color: #6b7280;
        }

        .empty-reviews i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
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

            .main-content {
                margin-top: 0;
            }

            .content-card {
                padding: 1.5rem;
            }

            .course-sidebar {
                position: static;
                margin-top: 2rem;
            }

            .instructor-card {
                flex-direction: column;
                text-align: center;
            }

            .instructor-avatar-placeholder {
                margin-right: 0;
                margin-bottom: 1rem;
            }

            .rating-summary {
                flex-direction: column;
                text-align: center;
            }

            .overall-rating {
                margin-right: 0;
                margin-bottom: 1rem;
            }
        }
    </style>
</head>

<body>
<!-- Include Header -->
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<!-- Course Hero Section -->
<section class="course-hero">
    <div class="container">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/">
                        <i class="fas fa-home me-1"></i>Trang chủ
                    </a>
                </li>
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/courses">Khóa học</a>
                </li>
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/courses?category=${course.category.name}">${course.category.name}</a>
                </li>
                <li class="breadcrumb-item active">${course.name}</li>
            </ol>
        </nav>

        <div class="row">
            <div class="col-lg-8">
                <!-- Course Badges -->
                <div class="course-badges">
                    <c:if test="${course.featured}">
                        <span class="course-badge badge-featured">
                            <i class="fas fa-star me-1"></i>Khóa học nổi bật
                        </span>
                    </c:if>
                    <c:if test="${course.enrollmentCount != null && course.enrollmentCount > 50}">
                        <span class="course-badge badge-bestseller">
                            <i class="fas fa-fire me-1"></i>Bán chạy nhất
                        </span>
                    </c:if>
                    <span class="course-badge">
                        <i class="fas fa-tag me-1"></i>${course.category.name}
                    </span>
                </div>

                <!-- Course Title -->
                <h1 class="course-title">${course.name}</h1>

                <!-- Course Subtitle -->
                <p class="course-subtitle">${course.shortDescription}</p>

                <!-- Course Meta Information -->
                <div class="course-meta">
                    <div class="meta-item">
                        <i class="fas fa-star meta-icon text-warning"></i>
                        <span>
                            <strong>${course.rating}</strong>
                            (<strong>${course.reviewCount}</strong> đánh giá)
                        </span>
                    </div>
                    <div class="meta-item">
                        <i class="fas fa-users meta-icon"></i>
                        <span><strong>${course.enrollmentCount}</strong> học viên</span>
                    </div>
                    <div class="meta-item">
                        <i class="fas fa-clock meta-icon"></i>
                        <span><strong><fmt:formatNumber value="${course.duration / 60}" maxFractionDigits="1"/></strong> giờ</span>
                    </div>
                    <div class="meta-item">
                        <i class="fas fa-layer-group meta-icon"></i>
                        <span>${course.difficultyLevel}</span>
                    </div>
                    <div class="meta-item">
                        <i class="fas fa-globe meta-icon"></i>
                        <span>${course.language}</span>
                    </div>
                    <div class="meta-item">
                        <i class="fas fa-calendar meta-icon"></i>
                        <span>Cập nhật: ${course.formattedUpdatedAt}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Main Content -->
<section class="main-content">
    <div class="container">
        <div class="row">
            <!-- Course Content -->
            <div class="col-lg-8">
                <!-- Course Description -->
                <div class="content-card">
                    <h2 class="section-title">
                        <i class="fas fa-info-circle"></i>Mô tả khóa học
                    </h2>
                    <div class="course-description">
                        ${course.description}
                    </div>
                </div>

                <!-- Course Curriculum -->
                <div class="content-card">
                    <h2 class="section-title">
                        <i class="fas fa-list"></i>Nội dung khóa học
                    </h2>

                    <c:choose>
                        <c:when test="${not empty course.lessons}">
                            <c:forEach items="${course.lessons}" var="lesson" varStatus="status">
                                <div class="curriculum-section">
                                    <div class="section-header" data-bs-toggle="collapse"
                                         data-bs-target="#section_${lesson.id}">
                                        <div class="section-title-curriculum">
                                            Bài ${status.index + 1}: ${lesson.title}
                                        </div>
                                        <div class="section-meta">
                                            <span>
                                                <c:choose>
                                                    <c:when test="${lesson.duration != null}">
                                                        <fmt:formatNumber value="${lesson.duration / 60}" maxFractionDigits="1"/> phút
                                                    </c:when>
                                                    <c:otherwise>N/A</c:otherwise>
                                                </c:choose>
                                            </span>
                                            <i class="fas fa-chevron-down"></i>
                                        </div>
                                    </div>

                                    <div class="collapse" id="section_${lesson.id}">
                                        <div class="lesson-list">
                                            <div class="lesson-item">
                                                <div class="lesson-info">
                                                    <i class="fas fa-play-circle lesson-icon"></i>
                                                    <span class="lesson-title">${lesson.title}</span>
                                                </div>
                                                <span class="lesson-duration">
                                                    <c:choose>
                                                        <c:when test="${lesson.duration != null}">
                                                            <fmt:formatNumber value="${lesson.duration / 60}" maxFractionDigits="1"/> phút
                                                        </c:when>
                                                        <c:otherwise>N/A</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <c:if test="${not empty lesson.content}">
                                                <div class="lesson-item">
                                                    <div class="lesson-info">
                                                        <i class="fas fa-file-text lesson-icon"></i>
                                                        <span class="lesson-title">Nội dung bài học</span>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-reviews">
                                <i class="fas fa-book-open"></i>
                                <p>Chưa có bài học nào cho khóa học này.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Instructor Information -->
                <div class="content-card">
                    <h2 class="section-title">
                        <i class="fas fa-chalkboard-teacher"></i>Giảng viên
                    </h2>

                    <div class="instructor-card">
                        <!-- Sử dụng icon thay vì ảnh để tránh lỗi -->
                        <div class="instructor-avatar-placeholder">
                            <i class="fas fa-user-tie"></i>
                        </div>
                        <div class="instructor-info">
                            <h6>${course.instructor.fullName}</h6>
                            <div class="instructor-role">
                                <c:choose>
                                    <c:when test="${course.instructor.role == 'INSTRUCTOR'}">Giảng viên</c:when>
                                    <c:when test="${course.instructor.role == 'ADMIN'}">Quản trị viên</c:when>
                                    <c:otherwise>Giảng viên</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="instructor-stats">
                                <div class="stats-item">
                                    <i class="fas fa-star"></i>
                                    <span>4.5 đánh giá</span>  <!-- Static value để tránh lỗi -->
                                </div>
                                <div class="stats-item">
                                    <i class="fas fa-users"></i>
                                    <span>100+ học viên</span>  <!-- Static value để tránh lỗi -->
                                </div>
                                <div class="stats-item">
                                    <i class="fas fa-play-circle"></i>
                                    <span>5+ khóa học</span>  <!-- Static value để tránh lỗi -->
                                </div>
                            </div>
                        </div>
                    </div>

                    <c:if test="${not empty course.instructor.bio}">
                        <p>${course.instructor.bio}</p>
                    </c:if>
                </div>

                <!-- Student Reviews -->
                <div class="content-card">
                    <h2 class="section-title">
                        <i class="fas fa-star"></i>Đánh giá của học viên
                    </h2>

                    <!-- Rating Overview -->
                    <div class="rating-overview">
                        <div class="rating-summary">
                            <div class="overall-rating">${course.rating}</div>
                            <div class="rating-details">
                                <div class="rating-stars">
                                    <c:forEach begin="1" end="5" var="star">
                                        <c:set var="courseRating" value="${course.ratingAverage != null ? course.ratingAverage : 0}" />
                                        <i class="fas fa-star ${star <= courseRating ? 'text-warning' : 'text-muted'}"></i>
                                    </c:forEach>
                                </div>
                                <div class="rating-text">
                                    Đánh giá trung bình từ ${course.reviewCount} học viên
                                </div>
                            </div>
                        </div>

                        <!-- Rating Breakdown -->
                        <ul class="rating-breakdown">
                            <li class="rating-row">
                                <span class="rating-label">5 sao</span>
                                <div class="rating-bar">
                                    <div class="rating-fill" style="width: 70%"></div>
                                </div>
                                <span class="rating-count">70%</span>
                            </li>
                            <li class="rating-row">
                                <span class="rating-label">4 sao</span>
                                <div class="rating-bar">
                                    <div class="rating-fill" style="width: 20%"></div>
                                </div>
                                <span class="rating-count">20%</span>
                            </li>
                            <li class="rating-row">
                                <span class="rating-label">3 sao</span>
                                <div class="rating-bar">
                                    <div class="rating-fill" style="width: 8%"></div>
                                </div>
                                <span class="rating-count">8%</span>
                            </li>
                            <li class="rating-row">
                                <span class="rating-label">2 sao</span>
                                <div class="rating-bar">
                                    <div class="rating-fill" style="width: 2%"></div>
                                </div>
                                <span class="rating-count">2%</span>
                            </li>
                            <li class="rating-row">
                                <span class="rating-label">1 sao</span>
                                <div class="rating-bar">
                                    <div class="rating-fill" style="width: 0%"></div>
                                </div>
                                <span class="rating-count">0%</span>
                            </li>
                        </ul>
                    </div>

                    <!-- Individual Reviews - SỬA: Hiển thị review từ courseReviews thay vì course.reviews -->
                    <c:choose>
                        <c:when test="${not empty courseReviews}">
                            <c:forEach items="${courseReviews}" var="enrollment">
                                <c:if test="${not empty enrollment.review}">
                                    <div class="review-card">
                                        <div class="review-header">
                                            <div class="reviewer-info">
                                                <!-- Sử dụng icon thay vì ảnh để tránh lỗi -->
                                                <div class="reviewer-avatar-placeholder bg-primary text-white d-flex align-items-center justify-content-center rounded-circle">
                                                    <i class="fas fa-user"></i>
                                                </div>
                                                <div>
                                                    <div class="reviewer-name">${enrollment.student.fullName}</div>
                                                    <div class="review-date">${enrollment.formattedReviewDate}</div>
                                                </div>
                                            </div>
                                            <div class="review-rating">
                                                <!-- Hiển thị rating từ enrollment -->
                                                <c:forEach begin="1" end="5" var="star">
                                                    <c:set var="userRating" value="${enrollment.rating != null ? enrollment.rating : 0}" />
                                                    <i class="fas fa-star ${star <= userRating ? 'text-warning' : 'text-muted'}"></i>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <div class="review-content">
                                                ${enrollment.review}
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-reviews">
                                <i class="fas fa-comment"></i>
                                <p>Chưa có đánh giá nào cho khóa học này.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Sidebar -->
            <div class="col-lg-4">
                <div class="course-sidebar">
                    <!-- Course Preview -->
                    <div class="course-preview">
                        <div class="preview-video" onclick="playPreview()">
                            <img src="${empty course.thumbnail ?
                                'https://via.placeholder.com/300x200/667eea/ffffff?text=Course' :
                                pageContext.request.contextPath}/images/courses/${course.thumbnail}"
                                 alt="${course.name}"
                                 onerror="this.src='https://via.placeholder.com/300x200/667eea/ffffff?text=Course'">
                            <div class="play-button">
                                <i class="fas fa-play"></i>
                            </div>
                        </div>

                        <div class="pricing-card">
                            <!-- Pricing -->
                            <div class="price-section">
                                <c:choose>
                                    <c:when test="${course.price == 0}">
                                        <div class="price-free">Miễn phí</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div>
                                            <span class="current-price">
                                                <fmt:formatNumber value="${course.price}" type="currency"
                                                                  currencySymbol="₫" groupingUsed="true"/>
                                            </span>
                                            <c:if test="${course.originalPrice > course.price}">
                                                <span class="original-price">
                                                    <fmt:formatNumber value="${course.originalPrice}" type="currency"
                                                                      currencySymbol="₫" groupingUsed="true"/>
                                                </span>
                                                <span class="discount-badge">
                                                    <fmt:formatNumber value="${(course.originalPrice - course.price) / course.originalPrice * 100}"
                                                                      maxFractionDigits="0"/>% OFF
                                                </span>
                                            </c:if>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Enrollment Button -->
                            <sec:authorize access="!isAuthenticated()">
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-enroll enroll-btn">
                                    <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập để đăng ký
                                </a>
                            </sec:authorize>

                            <sec:authorize access="isAuthenticated()">
                                <c:choose>
                                    <c:when test="${isEnrolled}">
                                        <a href="${pageContext.request.contextPath}/student/courses/${course.id}"
                                           class="btn btn-enrolled enroll-btn">
                                            <i class="fas fa-play me-2"></i>Tiếp tục học
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn btn-enroll enroll-btn" onclick="enrollCourse(${course.id})">
                                            <i class="fas fa-plus me-2"></i>Đăng ký khóa học
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </sec:authorize>

                            <!-- Course Includes -->
                            <h6 class="mt-3 mb-2">Khóa học này bao gồm:</h6>
                            <ul class="course-includes">
                                <li>
                                    <i class="fas fa-play-circle"></i>
                                    <c:choose>
                                        <c:when test="${not empty course.lessons}">
                                            ${fn:length(course.lessons)} bài học video
                                        </c:when>
                                        <c:otherwise>0 bài học video</c:otherwise>
                                    </c:choose>
                                </li>
                                <li>
                                    <i class="fas fa-clock"></i>
                                    <c:choose>
                                        <c:when test="${course.duration != null}">
                                            <fmt:formatNumber value="${course.duration / 60}" maxFractionDigits="1"/> giờ nội dung
                                        </c:when>
                                        <c:otherwise>Thời lượng chưa xác định</c:otherwise>
                                    </c:choose>
                                </li>
                                <li>
                                    <i class="fas fa-file-download"></i>
                                    Tài liệu có thể tải xuống
                                </li>
                                <li>
                                    <i class="fas fa-mobile-alt"></i>
                                    Truy cập trên di động
                                </li>
                                <li>
                                    <i class="fas fa-certificate"></i>
                                    Chứng chỉ hoàn thành
                                </li>
                                <li>
                                    <i class="fas fa-infinity"></i>
                                    Truy cập trọn đời
                                </li>
                            </ul>
                        </div>
                    </div>

                    <!-- Related Courses -->
                    <c:if test="${not empty relatedCourses}">
                        <div class="related-courses">
                            <h5 class="mb-3">
                                <i class="fas fa-thumbs-up me-2 text-primary"></i>
                                Khóa học liên quan
                            </h5>

                            <c:forEach items="${relatedCourses}" var="relatedCourse">
                                <div class="course-card-small">
                                    <img src="${empty relatedCourse.thumbnail ?
                                        'https://via.placeholder.com/80x60/667eea/ffffff?text=Course' :
                                        pageContext.request.contextPath}/images/courses/${relatedCourse.thumbnail}"
                                         alt="${relatedCourse.name}" class="course-thumbnail"
                                         onerror="this.src='https://via.placeholder.com/80x60/667eea/ffffff?text=Course'">
                                    <div class="course-info-small">
                                        <div class="course-title-small">
                                            <a href="${pageContext.request.contextPath}/courses/${relatedCourse.id}">
                                                    ${relatedCourse.name}
                                            </a>
                                        </div>
                                        <div class="course-price-small">
                                            <c:choose>
                                                <c:when test="${relatedCourse.price == 0}">
                                                    Miễn phí
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatNumber value="${relatedCourse.price}" type="currency"
                                                                      currencySymbol="₫" groupingUsed="true"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Include Footer -->
<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JavaScript -->
<script>
    // Play course preview
    function playPreview() {
        // Implement video preview functionality
        alert('Chức năng xem trước video sẽ được cập nhật sớm!');
    }

    // Enroll in course
    function enrollCourse(courseId) {
        const button = event.target;
        const originalText = button.innerHTML;

        // Show loading state
        button.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
        button.disabled = true;

        // Make AJAX request to enroll
        fetch(`/api/v1/enrollments`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: JSON.stringify({
                courseId: courseId
            })
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Update button to show enrolled state
                    button.innerHTML = '<i class="fas fa-play me-2"></i>Tiếp tục học';
                    button.classList.remove('btn-enroll');
                    button.classList.add('btn-enrolled');
                    button.onclick = () => window.location.href = `/student/courses/${courseId}`;

                    // Show success message
                    showNotification('Đăng ký khóa học thành công!', 'success');
                } else {
                    throw new Error(data.message || 'Có lỗi xảy ra');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                button.innerHTML = originalText;
                button.disabled = false;
                showNotification('Có lỗi xảy ra khi đăng ký khóa học. Vui lòng thử lại!', 'error');
            });
    }

    // Show notification
    function showNotification(message, type) {
        const alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
        const icon = type === 'success' ? 'fa-check-circle' : 'fa-exclamation-triangle';

        const notification = document.createElement('div');
        notification.className = `alert ${alertClass} alert-dismissible fade show position-fixed`;
        notification.style.cssText = 'top: 100px; right: 20px; z-index: 9999; min-width: 300px;';
        notification.innerHTML = `
            <i class="fas ${icon} me-2"></i>${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;

        document.body.appendChild(notification);

        // Auto-hide after 5 seconds
        setTimeout(() => {
            if (notification.parentNode) {
                notification.remove();
            }
        }, 5000);
    }

    // Smooth scrolling for curriculum sections
    document.addEventListener('DOMContentLoaded', function() {
        const sectionHeaders = document.querySelectorAll('.section-header');

        sectionHeaders.forEach(header => {
            header.addEventListener('click', function() {
                const icon = this.querySelector('.fa-chevron-down');
                if (icon) {
                    icon.classList.toggle('fa-chevron-down');
                    icon.classList.toggle('fa-chevron-up');
                }
            });
        });
    });

    // Sticky sidebar behavior
    window.addEventListener('scroll', function() {
        const sidebar = document.querySelector('.course-sidebar');
        if (sidebar) {
            const sidebarTop = sidebar.offsetTop - 100;

            if (window.pageYOffset >= sidebarTop) {
                sidebar.style.position = 'fixed';
                sidebar.style.top = '100px';
                sidebar.style.width = sidebar.parentElement.offsetWidth + 'px';
            } else {
                sidebar.style.position = 'sticky';
                sidebar.style.top = '100px';
                sidebar.style.width = 'auto';
            }
        }
    });

    // Share course functionality
    function shareCourse() {
        if (navigator.share) {
            navigator.share({
                title: '${course.name}',
                text: '${course.shortDescription}',
                url: window.location.href
            });
        } else {
            // Fallback: copy to clipboard
            navigator.clipboard.writeText(window.location.href).then(() => {
                showNotification('Đã sao chép link khóa học!', 'success');
            });
        }
    }
</script>
</body>
</html>