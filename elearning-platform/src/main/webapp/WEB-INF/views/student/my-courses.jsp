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
    <title>Khóa học của tôi - EduLearn Platform</title>

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

        /* Page Header */
        .page-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }

        .page-header::before {
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

        .header-content {
            position: relative;
            z-index: 2;
        }

        .page-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .page-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 2rem;
        }

        .header-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1.5rem;
        }

        .header-stat {
            text-align: center;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 0.75rem;
            padding: 1.25rem;
            backdrop-filter: blur(10px);
        }

        .header-stat-number {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.25rem;
        }

        .header-stat-label {
            font-size: 0.9rem;
            opacity: 0.8;
        }

        /* Filter Tabs */
        .filter-tabs {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
        }

        .nav-tabs {
            border: none;
            margin-bottom: 1rem;
        }

        .nav-tabs .nav-link {
            border: none;
            background: none;
            color: var(--text-secondary);
            font-weight: 500;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            margin-right: 0.5rem;
            transition: all 0.3s ease;
        }

        .nav-tabs .nav-link:hover {
            background: var(--light-bg);
            color: var(--text-primary);
        }

        .nav-tabs .nav-link.active {
            background: var(--primary-color);
            color: white;
        }

        .search-filter {
            display: flex;
            gap: 1rem;
            align-items: end;
            flex-wrap: wrap;
        }

        .search-group {
            flex: 1;
            min-width: 250px;
        }

        .form-label {
            font-weight: 500;
            color: var(--text-secondary);
            margin-bottom: 0.5rem;
        }

        .form-control,
        .form-select {
            border: 2px solid var(--border-color);
            border-radius: 0.5rem;
            padding: 0.75rem;
            transition: all 0.3s ease;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }

        /* Course Grid */
        .courses-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 1.5rem;
        }

        .course-card {
            background: white;
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
            position: relative;
        }

        .course-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 25px -3px rgba(0, 0, 0, 0.1);
        }

        .course-thumbnail {
            width: 100%;
            height: 200px;
            object-fit: cover;
            background: var(--light-bg);
            position: relative;
        }

        .course-progress-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: rgba(0, 0, 0, 0.8);
            color: white;
            padding: 0.75rem;
            font-size: 0.85rem;
        }

        .progress-bar-container {
            background: rgba(255, 255, 255, 0.3);
            border-radius: 1rem;
            height: 6px;
            overflow: hidden;
            margin-top: 0.5rem;
        }

        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--success-color), #10b981);
            border-radius: 1rem;
            transition: width 0.3s ease;
        }

        .course-body {
            padding: 1.5rem;
        }

        .course-category {
            display: inline-block;
            background: var(--light-bg);
            color: var(--primary-color);
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.75rem;
            font-weight: 500;
            margin-bottom: 1rem;
        }

        .course-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.75rem;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .course-instructor {
            color: var(--text-secondary);
            font-size: 0.9rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }

        .course-instructor i {
            margin-right: 0.5rem;
            color: var(--primary-color);
        }

        .course-meta {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1rem;
            padding: 1rem;
            background: var(--light-bg);
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
        }

        .meta-item {
            text-align: center;
        }

        .meta-number {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }

        .meta-label {
            font-size: 0.75rem;
            color: var(--text-secondary);
            font-weight: 500;
        }

        .course-status {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
            padding: 0.75rem;
            border-radius: 0.5rem;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .status-in-progress {
            background: #dbeafe;
            color: #1e40af;
        }

        .status-completed {
            background: #dcfce7;
            color: #166534;
        }

        .status-not-started {
            background: #f3f4f6;
            color: #374151;
        }

        .course-actions {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            border-radius: 0.5rem;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            flex: 1;
            justify-content: center;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px -8px var(--primary-color);
            color: white;
            text-decoration: none;
        }

        .btn-success-custom {
            background: linear-gradient(135deg, var(--success-color), #047857);
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            border-radius: 0.5rem;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            flex: 1;
            justify-content: center;
        }

        .btn-success-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px -8px var(--success-color);
            color: white;
            text-decoration: none;
        }

        .btn-outline-custom {
            background: white;
            color: var(--text-secondary);
            border: 2px solid var(--border-color);
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            border-radius: 0.5rem;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            justify-content: center;
        }

        .btn-outline-custom:hover {
            border-color: var(--primary-color);
            color: var(--primary-color);
            text-decoration: none;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
        }

        .empty-icon {
            font-size: 4rem;
            color: var(--text-secondary);
            margin-bottom: 1.5rem;
        }

        .empty-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.75rem;
        }

        .empty-description {
            color: var(--text-secondary);
            margin-bottom: 2rem;
            max-width: 400px;
            margin-left: auto;
            margin-right: auto;
        }

        /* Achievement Modal */
        .achievement-celebration {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.8);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
        }

        .achievement-celebration.show {
            opacity: 1;
            visibility: visible;
        }

        .achievement-card {
            background: white;
            border-radius: 1rem;
            padding: 3rem;
            text-align: center;
            max-width: 400px;
            transform: scale(0.8);
            transition: transform 0.3s ease;
        }

        .achievement-celebration.show .achievement-card {
            transform: scale(1);
        }

        .achievement-icon {
            font-size: 4rem;
            color: var(--warning-color);
            margin-bottom: 1rem;
            animation: bounce 2s infinite;
        }

        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-20px);
            }
            60% {
                transform: translateY(-10px);
            }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .page-title {
                font-size: 1.5rem;
            }

            .header-stats {
                grid-template-columns: repeat(2, 1fr);
            }

            .search-filter {
                flex-direction: column;
            }

            .search-group {
                min-width: auto;
            }

            .courses-container {
                grid-template-columns: 1fr;
            }

            .course-meta {
                grid-template-columns: repeat(2, 1fr);
            }

            .course-actions {
                flex-direction: column;
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
        <!-- Page Header -->
        <div class="page-header">
            <div class="header-content">
                <h1 class="page-title">Khóa học của tôi</h1>
                <p class="page-subtitle">
                    Tiếp tục hành trình học tập và theo dõi tiến độ của bạn
                </p>

                <div class="header-stats">
                    <div class="header-stat">
                        <div class="header-stat-number">${totalEnrolled}</div>
                        <div class="header-stat-label">Đã đăng ký</div>
                    </div>
                    <div class="header-stat">
                        <div class="header-stat-number">${totalCompleted}</div>
                        <div class="header-stat-label">Hoàn thành</div>
                    </div>
                    <div class="header-stat">
                        <div class="header-stat-number">${totalInProgress}</div>
                        <div class="header-stat-label">Đang học</div>
                    </div>
                    <div class="header-stat">
                        <div class="header-stat-number">${totalCertificates}</div>
                        <div class="header-stat-label">Chứng chỉ</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filter Tabs -->
        <div class="filter-tabs">
            <!-- Navigation Tabs -->
            <ul class="nav nav-tabs" id="coursesTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link ${param.status == null || param.status == 'all' ? 'active' : ''}"
                            id="all-tab"
                            data-bs-toggle="tab"
                            data-bs-target="#all-courses"
                            type="button"
                            role="tab">
                        <i class="fas fa-list me-2"></i>Tất cả (${totalEnrolled})
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link ${param.status == 'in-progress' ? 'active' : ''}"
                            id="progress-tab"
                            data-bs-toggle="tab"
                            data-bs-target="#progress-courses"
                            type="button"
                            role="tab">
                        <i class="fas fa-play me-2"></i>Đang học (${totalInProgress})
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link ${param.status == 'completed' ? 'active' : ''}"
                            id="completed-tab"
                            data-bs-toggle="tab"
                            data-bs-target="#completed-courses"
                            type="button"
                            role="tab">
                        <i class="fas fa-check-circle me-2"></i>Hoàn thành (${totalCompleted})
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link ${param.status == 'not-started' ? 'active' : ''}"
                            id="new-tab"
                            data-bs-toggle="tab"
                            data-bs-target="#new-courses"
                            type="button"
                            role="tab">
                        <i class="fas fa-clock me-2"></i>Chưa bắt đầu (${totalNotStarted})
                    </button>
                </li>
            </ul>

            <!-- Search and Filter -->
            <form method="GET" action="/student/my-courses"" id="filterForm">
                <input type="hidden" name="status" value="${param.status}" id="statusInput">
                <div class="search-filter">
                    <div class="search-group">
                        <label class="form-label">Tìm kiếm khóa học</label>
                        <input type="text"
                               class="form-control"
                               name="search"
                               value="${param.search}"
                               placeholder="Tên khóa học, giảng viên...">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Danh mục</label>
                        <select class="form-select" name="category" style="min-width: 150px;">
                            <option value="">Tất cả danh mục</option>
                            <c:forEach items="${categories}" var="category">
                                <option value="${category.id}"
                                    ${param.category == category.id ? 'selected' : ''}>
                                        ${category.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Sắp xếp</label>
                        <select class="form-select" name="sort" style="min-width: 150px;">
                            <option value="enrolledAt,desc" ${param.sort == 'enrolledAt,desc' ? 'selected' : ''}>
                                Mới đăng ký
                            </option>
                            <option value="lastAccessed,desc" ${param.sort == 'lastAccessed,desc' ? 'selected' : ''}>
                                Học gần đây
                            </option>
                            <option value="progress,desc" ${param.sort == 'progress,desc' ? 'selected' : ''}>
                                Tiến độ cao
                            </option>
                            <option value="name,asc" ${param.sort == 'name,asc' ? 'selected' : ''}>
                                Tên A-Z
                            </option>
                        </select>
                    </div>
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search me-2"></i>Lọc
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Courses Content -->
        <c:choose>
            <c:when test="${not empty enrollments}">
                <div class="courses-container">
                    <c:forEach items="${enrollments}" var="enrollment">
                        <div class="course-card">
                            <!-- Course Thumbnail -->
                            <div class="course-thumbnail">
                                <c:choose>
                                    <c:when test="${enrollment.course.thumbnailPath != null}">
                                        <img src="${pageContext.request.contextPath}/images/courses/${enrollment.course.thumbnailPath}""
                                             alt="${enrollment.course.name}"
                                             class="course-thumbnail">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="course-thumbnail d-flex align-items-center justify-content-center text-muted">
                                            <i class="fas fa-book fa-3x"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <!-- Progress Overlay -->
                                <div class="course-progress-overlay">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span>Tiến độ: ${enrollment.progressPercentage}%</span>
                                        <span>${enrollment.completedLessons}/${enrollment.totalLessons} bài</span>
                                    </div>
                                    <div class="progress-bar-container">
                                        <div class="progress-bar-fill"
                                             style="width: ${enrollment.progressPercentage}%"></div>
                                    </div>
                                </div>
                            </div>

                            <!-- Course Body -->
                            <div class="course-body">
                                <!-- Category -->
                                <span class="course-category">
                                        <i class="fas fa-tag me-1"></i>
                                        ${enrollment.course.category.name}
                                    </span>

                                <!-- Title -->
                                <h3 class="course-title">${enrollment.course.name}</h3>

                                <!-- Instructor -->
                                <div class="course-instructor">
                                    <i class="fas fa-user"></i>
                                        ${enrollment.course.instructor.fullName}
                                </div>

                                <!-- Meta Information -->
                                <div class="course-meta">
                                    <div class="meta-item">
                                        <div class="meta-number">${enrollment.progressPercentage}%</div>
                                        <div class="meta-label">Hoàn thành</div>
                                    </div>
                                    <div class="meta-item">
                                        <div class="meta-number">${enrollment.totalLessons}</div>
                                        <div class="meta-label">Bài giảng</div>
                                    </div>
                                    <div class="meta-item">
                                        <div class="meta-number">
                                            <fmt:formatNumber value="${enrollment.course.averageRating}"
                                                              pattern="#.#" maxFractionDigits="1"/>
                                        </div>
                                        <div class="meta-label">Đánh giá</div>
                                    </div>
                                </div>

                                <!-- Status -->
                                <div class="course-status ${enrollment.status == 'COMPLETED' ? 'status-completed' :
                                                               (enrollment.progressPercentage > 0 ? 'status-in-progress' : 'status-not-started')}">
                                    <c:choose>
                                        <c:when test="${enrollment.status == 'COMPLETED'}">
                                            <i class="fas fa-check-circle"></i>
                                            Đã hoàn thành
                                        </c:when>
                                        <c:when test="${enrollment.progressPercentage > 0}">
                                            <i class="fas fa-play-circle"></i>
                                            Đang học
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-clock"></i>
                                            Chưa bắt đầu
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- Actions -->
                                <div class="course-actions">
                                    <c:choose>
                                        <c:when test="${enrollment.status == 'COMPLETED'}">
                                            <!-- Show certificate if completed -->
                                            <a href="${pageContext.request.contextPath}/student/certificates/${enrollment.course.id}""
                                               class="btn-success-custom">
                                                <i class="fas fa-certificate"></i>Xem chứng chỉ
                                            </a>
                                            <!-- Review course -->
                                            <a href="${pageContext.request.contextPath}/student/courses/${enrollment.course.id}/review""
                                               class="btn-outline-custom">
                                                <i class="fas fa-star"></i>Đánh giá
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- Continue learning -->
                                            <a href="${pageContext.request.contextPath}/student/courses/${enrollment.course.id}/learn""
                                               class="btn-primary-custom">
                                                <i class="fas fa-play"></i>
                                                    ${enrollment.progressPercentage > 0 ? 'Tiếp tục học' : 'Bắt đầu học'}
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Pagination -->
                <div class="mt-4">
                    <jsp:include page="/WEB-INF/views/common/pagination.jsp">
                        <jsp:param name="page" value="${enrollments.number}" />
                        <jsp:param name="totalPages" value="${enrollments.totalPages}" />
                        <jsp:param name="size" value="${enrollments.size}" />
                        <jsp:param name="totalElements" value="${enrollments.totalElements}" />
                        <jsp:param name="baseUrl" value="/student/my-courses" />
                        <jsp:param name="additionalParams" value="${param.search != null ? 'search='.concat(param.search) : ''}${param.status != null ? '&status='.concat(param.status) : ''}${param.category != null ? '&category='.concat(param.category) : ''}${param.sort != null ? '&sort='.concat(param.sort) : ''}" />
                    </jsp:include>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Empty State -->
                <div class="empty-state">
                    <i class="fas fa-book-reader empty-icon"></i>
                    <h3 class="empty-title">
                        <c:choose>
                            <c:when test="${param.status == 'completed'}">
                                Chưa hoàn thành khóa học nào
                            </c:when>
                            <c:when test="${param.status == 'in-progress'}">
                                Chưa có khóa học đang học
                            </c:when>
                            <c:when test="${param.status == 'not-started'}">
                                Không có khóa học chưa bắt đầu
                            </c:when>
                            <c:otherwise>
                                Chưa đăng ký khóa học nào
                            </c:otherwise>
                        </c:choose>
                    </h3>
                    <p class="empty-description">
                        <c:choose>
                            <c:when test="${not empty param.search}">
                                Không tìm thấy khóa học nào với từ khóa "${param.search}".
                                Hãy thử tìm kiếm với từ khóa khác.
                            </c:when>
                            <c:otherwise>
                                Khám phá hàng nghìn khóa học chất lượng cao và bắt đầu
                                hành trình học tập của bạn ngay hôm nay.
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <a href="${pageContext.request.contextPath}/courses"" class="btn-primary-custom">
                        <i class="fas fa-search me-2"></i>Khám phá khóa học
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Achievement Celebration Modal -->
<div class="achievement-celebration" id="achievementModal">
    <div class="achievement-card">
        <div class="achievement-icon">
            <i class="fas fa-trophy"></i>
        </div>
        <h3>Chúc mừng!</h3>
        <p>Bạn vừa hoàn thành một khóa học!</p>
        <button onclick="closeAchievement()" class="btn-primary-custom">
            <i class="fas fa-times me-2"></i>Đóng
        </button>
    </div>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JavaScript -->
<script>
    // Tab functionality - Chức năng tab
    document.addEventListener('DOMContentLoaded', function() {
        const tabs = document.querySelectorAll('#coursesTabs .nav-link');
        const statusInput = document.getElementById('statusInput');

        tabs.forEach(tab => {
            tab.addEventListener('click', function() {
                const tabId = this.id;
                let status = '';

                switch(tabId) {
                    case 'progress-tab':
                        status = 'in-progress';
                        break;
                    case 'completed-tab':
                        status = 'completed';
                        break;
                    case 'new-tab':
                        status = 'not-started';
                        break;
                    default:
                        status = 'all';
                }

                statusInput.value = status;

                // Update URL without page reload
                const url = new URL(window.location);
                if (status === 'all') {
                    url.searchParams.delete('status');
                } else {
                    url.searchParams.set('status', status);
                }
                url.searchParams.delete('page'); // Reset page
                window.history.pushState({}, '', url);

                // Submit form
                document.getElementById('filterForm').submit();
            });
        });

        // Auto-submit form khi thay đổi filter
        const filterSelects = document.querySelectorAll('#filterForm select');
        filterSelects.forEach(select => {
            select.addEventListener('change', function() {
                document.getElementById('filterForm').submit();
            });
        });

        // Search với debounce
        const searchInput = document.querySelector('input[name="search"]');
        let searchTimeout;

        searchInput.addEventListener('input', function() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                document.getElementById('filterForm').submit();
            }, 1000);
        });

        // Initialize progress bar animations
        initializeProgressBars();

        // Check for achievement celebration
        checkForAchievements();
    });

    // Progress bar animation - Animation thanh tiến độ
    function initializeProgressBars() {
        const progressBars = document.querySelectorAll('.progress-bar-fill');
        progressBars.forEach((bar, index) => {
            const width = bar.style.width;
            bar.style.width = '0%';

            setTimeout(() => {
                bar.style.width = width;
            }, index * 100 + 500);
        });
    }

    // Achievement system - Hệ thống thành tích
    function checkForAchievements() {
        // Check URL parameters for achievement celebration
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('achievement') === 'completed') {
            showAchievement();
        }
    }

    function showAchievement() {
        const modal = document.getElementById('achievementModal');
        modal.classList.add('show');

        // Add confetti effect
        createConfetti();

        // Auto close after 5 seconds
        setTimeout(() => {
            closeAchievement();
        }, 5000);
    }

    function closeAchievement() {
        const modal = document.getElementById('achievementModal');
        modal.classList.remove('show');

        // Remove achievement parameter from URL
        const url = new URL(window.location);
        url.searchParams.delete('achievement');
        window.history.replaceState({}, '', url);
    }

    function createConfetti() {
        // Simple confetti effect
        for (let i = 0; i < 50; i++) {
            setTimeout(() => {
                const confetti = document.createElement('div');
                confetti.style.cssText = `
                        position: fixed;
                        top: -10px;
                        left: ${Math.random() * 100}%;
                        width: 10px;
                        height: 10px;
                        background: hsl(${Math.random() * 360}, 70%, 60%);
                        pointer-events: none;
                        z-index: 10000;
                        animation: confetti-fall 3s linear forwards;
                    `;

                document.body.appendChild(confetti);

                setTimeout(() => confetti.remove(), 3000);
            }, i * 50);
        }
    }

    // Add confetti animation
    const style = document.createElement('style');
    style.textContent = `
            @keyframes confetti-fall {
                to {
                    transform: translateY(100vh) rotate(360deg);
                }
            }
        `;
    document.head.appendChild(style);

    // Continue learning function - Hàm tiếp tục học
    function continueLearning(courseId, lessonId) {
        // Track learning activity
        fetch('/api/student/track-access', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                courseId: courseId,
                lessonId: lessonId,
                action: 'continue_learning'
            })
        }).catch(error => {
            console.log('Tracking error:', error);
        });

        // Navigate to learning page
        window.location.href = `/student/courses/${courseId}/learn`;
    }

    // Keyboard shortcuts - Phím tắt
    document.addEventListener('keydown', function(e) {
        // Ctrl/Cmd + F: Focus search
        if ((e.ctrlKey || e.metaKey) && e.key === 'f') {
            e.preventDefault();
            document.querySelector('input[name="search"]').focus();
        }

        // Number keys for tabs
        if (e.key >= '1' && e.key <= '4') {
            e.preventDefault();
            const tabs = document.querySelectorAll('#coursesTabs .nav-link');
            const tabIndex = parseInt(e.key) - 1;
            if (tabs[tabIndex]) {
                tabs[tabIndex].click();
            }
        }
    });

    // Card animation on load - Animation card khi load
    document.addEventListener('DOMContentLoaded', function() {
        const cards = document.querySelectorAll('.course-card');
        cards.forEach((card, index) => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            card.style.transition = 'all 0.6s ease';

            setTimeout(() => {
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, index * 100);
        });
    });

    // Auto-refresh progress periodically - Tự động cập nhật tiến độ
    setInterval(() => {
        // Only refresh if user is active on the page
        if (!document.hidden) {
            fetch('/api/student/progress-update', {
                method: 'GET',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
                .then(response => response.json())
                .then(data => {
                    if (data.hasUpdates) {
                        // Subtle notification that progress has been updated
                        showProgressUpdate();
                    }
                })
                .catch(error => {
                    console.log('Progress update check failed:', error);
                });
        }
    }, 5 * 60 * 1000); // Check every 5 minutes

    function showProgressUpdate() {
        // Show a subtle notification
        const notification = document.createElement('div');
        notification.innerHTML = `
                <div style="
                    position: fixed;
                    top: 2rem;
                    right: 2rem;
                    background: var(--success-color);
                    color: white;
                    padding: 1rem 1.5rem;
                    border-radius: 0.75rem;
                    z-index: 9999;
                    animation: slideIn 0.3s ease;
                ">
                    <i class="fas fa-sync-alt me-2"></i>Tiến độ đã được cập nhật
                </div>
            `;

        document.body.appendChild(notification);

        setTimeout(() => {
            notification.remove();
        }, 3000);
    }
</script>
</body>
</html>