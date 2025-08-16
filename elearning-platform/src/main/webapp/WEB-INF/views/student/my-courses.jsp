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
    <title>Khóa Học Của Tôi - EduLearn</title>

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

        /* Header */
        .page-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 2rem 2rem 4rem;
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
            max-width: 1200px;
            margin: 0 auto;
        }

        .page-title {
            font-size: 2.5rem;
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
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-top: 2rem;
        }

        .header-stat {
            text-align: center;
            background: rgba(255, 255, 255, 0.15);
            border-radius: 1rem;
            padding: 1.5rem;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .header-stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            display: block;
        }

        .header-stat-label {
            font-size: 0.95rem;
            opacity: 0.85;
        }

        /* Filter Section */
        .filter-section {
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            margin: -3rem auto 2rem;
            max-width: 1200px;
            position: relative;
            z-index: 3;
            padding: 2rem;
        }

        .filter-tabs {
            border-bottom: 2px solid var(--border-color);
            margin-bottom: 1.5rem;
        }

        .filter-tab {
            background: none;
            border: none;
            padding: 1rem 1.5rem;
            margin-right: 1rem;
            color: var(--text-secondary);
            font-weight: 500;
            border-radius: 0.5rem 0.5rem 0 0;
            transition: all 0.3s ease;
            position: relative;
        }

        .filter-tab:hover {
            background: var(--light-bg);
            color: var(--text-primary);
        }

        .filter-tab.active {
            background: var(--primary-color);
            color: white;
        }

        .search-controls {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr auto;
            gap: 1rem;
            align-items: end;
        }

        .form-group {
            margin-bottom: 0;
        }

        .form-label {
            font-weight: 500;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .form-control, .form-select {
            border: 2px solid var(--border-color);
            border-radius: 0.5rem;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        /* Course Cards */
        .courses-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .course-card {
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            overflow: hidden;
            transition: all 0.3s ease;
            position: relative;
        }

        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
        }

        .course-image {
            height: 200px;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            position: relative;
            overflow: hidden;
        }

        .course-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .course-image-placeholder {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100%;
            color: white;
            font-size: 3rem;
        }

        .course-progress-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: rgba(0, 0, 0, 0.8);
            color: white;
            padding: 1rem;
        }

        .progress-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }

        .progress-bar-container {
            height: 6px;
            background: rgba(255, 255, 255, 0.3);
            border-radius: 3px;
            overflow: hidden;
        }

        .progress-bar-fill {
            height: 100%;
            background: var(--success-color);
            border-radius: 3px;
            transition: width 0.3s ease;
        }

        .course-body {
            padding: 1.5rem;
        }

        .course-category {
            display: inline-block;
            background: var(--primary-color);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.8rem;
            font-weight: 500;
            margin-bottom: 1rem;
        }

        .course-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.75rem;
            line-height: 1.4;
        }

        .course-instructor {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--text-secondary);
            margin-bottom: 1rem;
            font-size: 0.9rem;
        }

        .course-meta {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1rem;
            margin-bottom: 1.5rem;
            padding: 1rem;
            background: var(--light-bg);
            border-radius: 0.5rem;
        }

        .meta-item {
            text-align: center;
        }

        .meta-number {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
            display: block;
        }

        .meta-label {
            font-size: 0.8rem;
            color: var(--text-secondary);
            margin-top: 0.25rem;
        }

        .course-status {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            border-radius: 2rem;
            font-size: 0.85rem;
            font-weight: 500;
            margin-bottom: 1rem;
        }

        .status-completed {
            background: #d4edda;
            color: #155724;
        }

        .status-in-progress {
            background: #fff3cd;
            color: #856404;
        }

        .status-not-started {
            background: #f8d7da;
            color: #721c24;
        }

        .course-actions {
            display: flex;
            gap: 0.75rem;
        }

        .btn-primary-custom {
            background: var(--primary-color);
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary-custom:hover {
            background: var(--secondary-color);
            color: white;
            transform: translateY(-2px);
        }

        .btn-outline-custom {
            border: 2px solid var(--primary-color);
            color: var(--primary-color);
            background: transparent;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-outline-custom:hover {
            background: var(--primary-color);
            color: white;
        }

        .btn-success-custom {
            background: var(--success-color);
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-success-custom:hover {
            background: #218838;
            color: white;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
        }

        .empty-icon {
            font-size: 4rem;
            color: var(--text-secondary);
            margin-bottom: 1.5rem;
            opacity: 0.5;
        }

        .empty-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
        }

        .empty-description {
            color: var(--text-secondary);
            margin-bottom: 2rem;
            line-height: 1.6;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .page-title {
                font-size: 2rem;
            }

            .header-stats {
                grid-template-columns: repeat(2, 1fr);
            }

            .search-controls {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .courses-grid {
                grid-template-columns: 1fr;
            }

            .course-meta {
                grid-template-columns: repeat(2, 1fr);
            }

            .course-actions {
                flex-direction: column;
            }

            .filter-section {
                margin: -2rem 1rem 1rem;
                padding: 1.5rem;
            }

            .courses-container {
                padding: 0 1rem;
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
                <h1 class="page-title">Khóa Học Của Tôi</h1>
                <p class="page-subtitle">
                    Tiếp tục hành trình học tập và theo dõi tiến độ của bạn
                </p>

                <div class="header-stats">
                    <div class="header-stat">
                        <span class="header-stat-number">
                            <c:choose>
                                <c:when test="${enrollments != null}">
                                    ${fn:length(enrollments)}
                                </c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </span>
                        <div class="header-stat-label">Đã đăng ký</div>
                    </div>
                    <div class="header-stat">
                        <span class="header-stat-number">
                            <c:set var="completedCount" value="0" />
                            <c:if test="${enrollments != null}">
                                <c:forEach var="enrollment" items="${enrollments}">
                                    <c:if test="${enrollment.completed}">
                                        <c:set var="completedCount" value="${completedCount + 1}" />
                                    </c:if>
                                </c:forEach>
                            </c:if>
                            ${completedCount}
                        </span>
                        <div class="header-stat-label">Hoàn thành</div>
                    </div>
                    <div class="header-stat">
                        <span class="header-stat-number">
                            <c:set var="inProgressCount" value="0" />
                            <c:if test="${enrollments != null}">
                                <c:forEach var="enrollment" items="${enrollments}">
                                    <c:if test="${enrollment.progress > 0 && !enrollment.completed}">
                                        <c:set var="inProgressCount" value="${inProgressCount + 1}" />
                                    </c:if>
                                </c:forEach>
                            </c:if>
                            ${inProgressCount}
                        </span>
                        <div class="header-stat-label">Đang học</div>
                    </div>
                    <div class="header-stat">
                        <span class="header-stat-number">${completedCount}</span>
                        <div class="header-stat-label">Chứng chỉ</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filter Section -->
        <div class="filter-section">
            <!-- Filter Tabs -->
            <div class="filter-tabs">
                <button class="filter-tab active" onclick="filterCourses('all')">
                    <i class="fas fa-list me-2"></i>Tất cả
                </button>
                <button class="filter-tab" onclick="filterCourses('in-progress')">
                    <i class="fas fa-play me-2"></i>Đang học
                </button>
                <button class="filter-tab" onclick="filterCourses('completed')">
                    <i class="fas fa-check-circle me-2"></i>Hoàn thành
                </button>
                <button class="filter-tab" onclick="filterCourses('not-started')">
                    <i class="fas fa-clock me-2"></i>Chưa bắt đầu
                </button>
            </div>

            <!-- Search Controls -->
            <form method="GET" action="${pageContext.request.contextPath}/student/my-courses" id="filterForm">
                <input type="hidden" name="status" value="${param.status}" id="statusInput">
                <div class="search-controls">
                    <div class="form-group">
                        <label class="form-label">Tìm kiếm khóa học</label>
                        <input type="text" class="form-control" name="search"
                               value="${param.search}"
                               placeholder="Tên khóa học, giảng viên...">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Danh mục</label>
                        <select class="form-select" name="category">
                            <option value="">Tất cả danh mục</option>
                            <c:if test="${categories != null}">
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.id}"
                                            <c:if test="${param.category eq category.id}">selected</c:if>>
                                            ${category.name}
                                    </option>
                                </c:forEach>
                            </c:if>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Sắp xếp</label>
                        <select class="form-select" name="sort">
                            <option value="recent" <c:if test="${param.sort eq 'recent'}">selected</c:if>>
                                Mới nhất
                            </option>
                            <option value="progress" <c:if test="${param.sort eq 'progress'}">selected</c:if>>
                                Tiến độ
                            </option>
                            <option value="name" <c:if test="${param.sort eq 'name'}">selected</c:if>>
                                Tên A-Z
                            </option>
                        </select>
                    </div>
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary-custom">
                            <i class="fas fa-search me-1"></i>Lọc
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Courses Container -->
        <div class="courses-container">
            <c:choose>
                <c:when test="${enrollments != null && fn:length(enrollments) > 0}">
                    <div class="courses-grid">
                        <c:forEach var="enrollment" items="${enrollments}" varStatus="courseLoop">
                            <div class="course-card">
                                <!-- Course Image -->
                                <div class="course-image">
                                    <c:choose>
                                        <c:when test="${enrollment.course.imageUrl != null && !empty enrollment.course.imageUrl}">
                                            <img src="${enrollment.course.imageUrl}" alt="${enrollment.course.name}">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="course-image-placeholder">
                                                <i class="fas fa-graduation-cap"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- Progress Overlay -->
                                    <div class="course-progress-overlay">
                                        <div class="progress-info">
                                            <span>Tiến độ:
                                                <c:choose>
                                                    <c:when test="${enrollment.progress != null}">
                                                        <fmt:formatNumber value="${enrollment.progress}" maxFractionDigits="1"/>%
                                                    </c:when>
                                                    <c:otherwise>0%</c:otherwise>
                                                </c:choose>
                                            </span>
                                            <span>
                                                <c:set var="completedLessons" value="0" />
                                                <c:set var="totalLessons" value="${enrollment.course.lessonCount != null ? enrollment.course.lessonCount : 0}" />
                                                ${completedLessons}/${totalLessons} bài
                                            </span>
                                        </div>
                                        <div class="progress-bar-container">
                                            <div class="progress-bar-fill"
                                                 style="width: <c:choose><c:when test='${enrollment.progress != null}'>${enrollment.progress}</c:when><c:otherwise>0</c:otherwise></c:choose>%"></div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Course Body -->
                                <div class="course-body">
                                    <!-- Category -->
                                    <span class="course-category">
                                        <i class="fas fa-tag me-1"></i>
                                        <c:choose>
                                            <c:when test="${enrollment.course.category != null}">
                                                ${enrollment.course.category.name}
                                            </c:when>
                                            <c:otherwise>Chưa phân loại</c:otherwise>
                                        </c:choose>
                                    </span>

                                    <!-- Title -->
                                    <h3 class="course-title">${enrollment.course.name}</h3>

                                    <!-- Instructor -->
                                    <div class="course-instructor">
                                        <i class="fas fa-user"></i>
                                        <c:choose>
                                            <c:when test="${enrollment.course.instructor != null}">
                                                ${enrollment.course.instructor.fullName}
                                            </c:when>
                                            <c:otherwise>Chưa có giảng viên</c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Meta Information -->
                                    <div class="course-meta">
                                        <div class="meta-item">
                                            <span class="meta-number">
                                                <c:choose>
                                                    <c:when test="${enrollment.progress != null}">
                                                        <fmt:formatNumber value="${enrollment.progress}" maxFractionDigits="1"/>%
                                                    </c:when>
                                                    <c:otherwise>0%</c:otherwise>
                                                </c:choose>
                                            </span>
                                            <div class="meta-label">Hoàn thành</div>
                                        </div>
                                        <div class="meta-item">
                                            <span class="meta-number">${totalLessons}</span>
                                            <div class="meta-label">Bài giảng</div>
                                        </div>
                                        <div class="meta-item">
                                            <span class="meta-number">
                                                <c:choose>
                                                    <c:when test="${enrollment.course.ratingAverage != null}">
                                                        <fmt:formatNumber value="${enrollment.course.ratingAverage}" pattern="#.#" maxFractionDigits="1"/>
                                                    </c:when>
                                                    <c:otherwise>0</c:otherwise>
                                                </c:choose>
                                            </span>
                                            <div class="meta-label">Đánh giá</div>
                                        </div>
                                    </div>

                                    <!-- Status -->
                                    <div class="course-status
                                        <c:choose>
                                            <c:when test='${enrollment.completed}'>status-completed</c:when>
                                            <c:when test='${enrollment.progress != null && enrollment.progress > 0}'>status-in-progress</c:when>
                                            <c:otherwise>status-not-started</c:otherwise>
                                        </c:choose>">
                                        <c:choose>
                                            <c:when test="${enrollment.completed}">
                                                <i class="fas fa-check-circle"></i>
                                                Đã hoàn thành
                                            </c:when>
                                            <c:when test="${enrollment.progress != null && enrollment.progress > 0}">
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
                                            <c:when test="${enrollment.completed}">
                                                <!-- Show certificate if completed -->
                                                <a href="${pageContext.request.contextPath}/student/certificates/${enrollment.course.id}"
                                                   class="btn-success-custom">
                                                    <i class="fas fa-certificate"></i>Xem chứng chỉ
                                                </a>
                                                <!-- Review course -->
                                                <a href="${pageContext.request.contextPath}/student/courses/${enrollment.course.id}/review"
                                                   class="btn-outline-custom">
                                                    <i class="fas fa-star"></i>Đánh giá
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- Continue learning -->
                                                <a href="${pageContext.request.contextPath}/student/courses/${enrollment.course.id}/learn"
                                                   class="btn-primary-custom">
                                                    <i class="fas fa-play"></i>
                                                    <c:choose>
                                                        <c:when test="${enrollment.progress != null && enrollment.progress > 0}">
                                                            Tiếp tục học
                                                        </c:when>
                                                        <c:otherwise>Bắt đầu học</c:otherwise>
                                                    </c:choose>
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
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
                        <a href="${pageContext.request.contextPath}/student/browse" class="btn-primary-custom">
                            <i class="fas fa-search me-2"></i>Khám phá khóa học
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
    // Filter courses function - Hàm lọc khóa học
    function filterCourses(status) {
        // Update active tab
        document.querySelectorAll('.filter-tab').forEach(tab => {
            tab.classList.remove('active');
        });
        event.target.classList.add('active');

        // Update form and submit
        document.getElementById('statusInput').value = status;
        document.getElementById('filterForm').submit();
    }

    // Auto-submit form when search/filter changes
    document.querySelectorAll('select[name="category"], select[name="sort"]').forEach(select => {
        select.addEventListener('change', function() {
            document.getElementById('filterForm').submit();
        });
    });

    // Search on Enter key
    document.querySelector('input[name="search"]').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            document.getElementById('filterForm').submit();
        }
    });

    // Card animations on load
    document.addEventListener('DOMContentLoaded', function() {
        const cards = document.querySelectorAll('.course-card');
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
</script>
</body>
</html>