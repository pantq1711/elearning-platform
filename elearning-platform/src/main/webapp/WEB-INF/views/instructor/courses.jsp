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
    <title>Quản lý khóa học - EduLearn Platform</title>

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
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
        }

        .page-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .page-subtitle {
            color: var(--text-secondary);
            margin-bottom: 1.5rem;
        }

        .page-actions {
            display: flex;
            gap: 1rem;
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
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px -8px var(--primary-color);
            color: white;
            text-decoration: none;
        }

        /* Filter Section */
        .filter-section {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
        }

        .filter-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            align-items: end;
        }

        .form-group {
            margin-bottom: 0;
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
            font-size: 0.95rem;
            transition: all 0.3s ease;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }

        /* Stats Cards */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
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

        .stat-card.published::before {
            background: var(--success-color);
        }

        .stat-card.draft::before {
            background: var(--warning-color);
        }

        .stat-card.pending::before {
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

        .stat-icon.published {
            background: var(--success-color);
        }

        .stat-icon.draft {
            background: var(--warning-color);
        }

        .stat-icon.pending {
            background: var(--danger-color);
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }

        .stat-title {
            color: var(--text-secondary);
            font-size: 0.9rem;
            font-weight: 500;
        }

        /* Course Grid */
        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
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

        .course-status-badge {
            position: absolute;
            top: 1rem;
            right: 1rem;
            padding: 0.375rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
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
            background: #fecaca;
            color: #991b1b;
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

        .course-description {
            color: var(--text-secondary);
            font-size: 0.9rem;
            line-height: 1.5;
            margin-bottom: 1rem;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
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
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }

        .meta-label {
            font-size: 0.75rem;
            color: var(--text-secondary);
            font-weight: 500;
        }

        .course-actions {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        .btn-sm-custom {
            padding: 0.5rem 1rem;
            font-size: 0.85rem;
            font-weight: 500;
            border-radius: 0.5rem;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.375rem;
            border: none;
        }

        .btn-primary-sm {
            background: var(--primary-color);
            color: white;
        }

        .btn-primary-sm:hover {
            background: var(--primary-dark);
            color: white;
            text-decoration: none;
        }

        .btn-success-sm {
            background: var(--success-color);
            color: white;
        }

        .btn-success-sm:hover {
            background: #047857;
            color: white;
            text-decoration: none;
        }

        .btn-warning-sm {
            background: var(--warning-color);
            color: white;
        }

        .btn-warning-sm:hover {
            background: #b45309;
            color: white;
            text-decoration: none;
        }

        .btn-danger-sm {
            background: var(--danger-color);
            color: white;
        }

        .btn-danger-sm:hover {
            background: #b91c1c;
            color: white;
            text-decoration: none;
        }

        .btn-outline-sm {
            background: white;
            color: var(--text-secondary);
            border: 1px solid var(--border-color);
        }

        .btn-outline-sm:hover {
            background: var(--light-bg);
            color: var(--text-primary);
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

        /* Responsive */
        @media (max-width: 768px) {
            .page-title {
                font-size: 1.5rem;
            }

            .page-actions {
                flex-direction: column;
            }

            .btn-primary-custom {
                justify-content: center;
            }

            .filter-row {
                grid-template-columns: 1fr;
            }

            .stats-row {
                grid-template-columns: repeat(2, 1fr);
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
            <div class="d-flex justify-content-between align-items-start flex-wrap">
                <div>
                    <h1 class="page-title">Quản lý khóa học</h1>
                    <p class="page-subtitle">
                        Tạo, chỉnh sửa và quản lý các khóa học của bạn
                    </p>
                </div>
                <div class="page-actions">
                    <a href="${pageContext.request.contextPath}/instructor/courses/new"" class="btn-primary-custom">
                        <i class="fas fa-plus"></i>
                        Tạo khóa học mới
                    </a>
                </div>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-header">
                    <div>
                        <div class="stat-number">${totalCourses}</div>
                        <div class="stat-title">Tổng khóa học</div>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-book"></i>
                    </div>
                </div>
            </div>

            <div class="stat-card published">
                <div class="stat-header">
                    <div>
                        <div class="stat-number">${publishedCourses}</div>
                        <div class="stat-title">Đã xuất bản</div>
                    </div>
                    <div class="stat-icon published">
                        <i class="fas fa-check-circle"></i>
                    </div>
                </div>
            </div>

            <div class="stat-card draft">
                <div class="stat-header">
                    <div>
                        <div class="stat-number">${draftCourses}</div>
                        <div class="stat-title">Bản nháp</div>
                    </div>
                    <div class="stat-icon draft">
                        <i class="fas fa-edit"></i>
                    </div>
                </div>
            </div>

            <div class="stat-card pending">
                <div class="stat-header">
                    <div>
                        <div class="stat-number">${pendingCourses}</div>
                        <div class="stat-title">Chờ duyệt</div>
                    </div>
                    <div class="stat-icon pending">
                        <i class="fas fa-clock"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filter Section -->
        <div class="filter-section">
            <form method="GET" action="action="/instructor/courses" id="filterForm">
                <div class="filter-row">
                    <!-- Search -->
                    <div class="form-group">
                        <label class="form-label">Tìm kiếm</label>
                        <input type="text"
                               class="form-control"
                               name="search"
                               value="${param.search}"
                               placeholder="Tên khóa học, mô tả...">
                    </div>

                    <!-- Status Filter -->
                    <div class="form-group">
                        <label class="form-label">Trạng thái</label>
                        <select class="form-select" name="status">
                            <option value="">Tất cả trạng thái</option>
                            <option value="PUBLISHED" ${param.status == 'PUBLISHED' ? 'selected' : ''}>
                                Đã xuất bản
                            </option>
                            <option value="DRAFT" ${param.status == 'DRAFT' ? 'selected' : ''}>
                                Bản nháp
                            </option>
                            <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>
                                Chờ duyệt
                            </option>
                        </select>
                    </div>

                    <!-- Category Filter -->
                    <div class="form-group">
                        <label class="form-label">Danh mục</label>
                        <select class="form-select" name="category">
                            <option value="">Tất cả danh mục</option>
                            <c:forEach items="${categories}" var="category">
                                <option value="${category.id}" ${param.category != null && param.category eq category.id.toString() ? 'selected' : ''}>
                                        ${category.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Sort -->
                    <div class="form-group">
                        <label class="form-label">Sắp xếp</label>
                        <select class="form-select" name="sort">
                            <option value="createdAt,desc" ${param.sort == 'createdAt,desc' ? 'selected' : ''}>
                                Mới nhất
                            </option>
                            <option value="createdAt,asc" ${param.sort == 'createdAt,asc' ? 'selected' : ''}>
                                Cũ nhất
                            </option>
                            <option value="name,asc" ${param.sort == 'name,asc' ? 'selected' : ''}>
                                Tên A-Z
                            </option>
                            <option value="name,desc" ${param.sort == 'name,desc' ? 'selected' : ''}>
                                Tên Z-A
                            </option>
                            <option value="enrollmentCount,desc" ${param.sort == 'enrollmentCount,desc' ? 'selected' : ''}>
                                Nhiều học viên nhất
                            </option>
                        </select>
                    </div>

                    <!-- Filter Actions -->
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-search me-2"></i>Lọc
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Courses Grid -->
        <c:choose>
            <c:when test="${not empty courses}">
                <div class="courses-grid">
                    <c:forEach items="${courses}" var="course">
                        <div class="course-card">
                            <!-- Course Thumbnail -->
                            <div class="course-thumbnail">
                                <c:choose>
                                    <c:when test="${course.thumbnailPath != null}">
                                        <img src="${pageContext.request.contextPath}/images/courses/${course.thumbnailPath}"
                                             alt="${course.name}"
                                             class="course-thumbnail">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="course-thumbnail d-flex align-items-center justify-content-center text-muted">
                                            <i class="fas fa-image fa-3x"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <!-- Status Badge -->
                                <div class="course-status-badge ${course.active ? 'status-published' : 'status-draft'}">
                                    <c:choose>
                                        <c:when test="${course.active}">
                                            <i class="fas fa-check-circle me-1"></i>Đã xuất bản
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-edit me-1"></i>Bản nháp
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                            </div>

                            <!-- Course Body -->
                            <div class="course-body">
                                <!-- Category -->
                                <span class="course-category">
                                        <i class="fas fa-tag me-1"></i>
                                        ${course.category.name}
                                    </span>

                                <!-- Title -->
                                <h3 class="course-title">${course.name}</h3>

                                <!-- Description -->
                                <p class="course-description">
                                        ${fn:length(course.shortDescription) > 100 ?
                                                fn:substring(course.shortDescription, 0, 100) += '...' :
                                                course.shortDescription}
                                </p>

                                <!-- Meta Information -->
                                <div class="course-meta">
                                    <div class="meta-item">
                                        <div class="meta-number">${course.enrollmentCount}</div>
                                        <div class="meta-label">Học viên</div>
                                    </div>
                                    <div class="meta-item">
                                        <div class="meta-number">${course.lessonCount}</div>
                                        <div class="meta-label">Bài giảng</div>
                                    </div>
                                    <div class="meta-item">
                                        <div class="meta-number">
                                            <fmt:formatNumber value="${course.averageRating}"
                                                              pattern="#.#" maxFractionDigits="1"/>
                                        </div>
                                        <div class="meta-label">Đánh giá</div>
                                    </div>
                                </div>

                                <!-- Actions -->
                                <div class="course-actions">
                                    <!-- Edit Course -->
                                    <a href="${pageContext.request.contextPath}/instructor/courses/${course.id}/edit""
                                       class="btn-sm-custom btn-primary-sm">
                                        <i class="fas fa-edit"></i>Chỉnh sửa
                                    </a>

                                    <!-- Manage Lessons -->
                                    <a href="${pageContext.request.contextPath}/instructor/courses/${course.id}/lessons""
                                       class="btn-sm-custom btn-success-sm">
                                        <i class="fas fa-play-circle"></i>Bài giảng
                                    </a>

                                    <!-- View Course -->
                                    <a href="${pageContext.request.contextPath}/courses/${course.id}"
                                       class="btn-sm-custom btn-outline-sm"
                                       target="_blank">
                                        <i class="fas fa-eye"></i>Xem
                                    </a>

                                    <!-- Conditional Actions -->
                                    <c:choose>
                                        <c:when test="${course.status == 'DRAFT'}">
                                            <button onclick="publishCourse(${course.id})"
                                                    class="btn-sm-custom btn-success-sm">
                                                <i class="fas fa-paper-plane"></i>Xuất bản
                                            </button>
                                        </c:when>
                                        <c:when test="${course.status == 'PUBLISHED'}">
                                            <button onclick="unpublishCourse(${course.id})"
                                                    class="btn-sm-custom btn-warning-sm">
                                                <i class="fas fa-pause"></i>Tạm dừng
                                            </button>
                                        </c:when>
                                    </c:choose>

                                    <!-- Delete Course -->
                                    <button onclick="deleteCourse(${course.id}, '${course.name}')"
                                            class="btn-sm-custom btn-danger-sm">
                                        <i class="fas fa-trash"></i>Xóa
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Pagination -->
                <div class="mt-4">
                    <jsp:include page="/WEB-INF/views/common/pagination.jsp">
                        <jsp:param name="page" value="${courses.number}" />
                        <jsp:param name="totalPages" value="${courses.totalPages}" />
                        <jsp:param name="size" value="${courses.size}" />
                        <jsp:param name="totalElements" value="${courses.totalElements}" />
                        <jsp:param name="baseUrl" value="/instructor/courses" />
                        <jsp:param name="additionalParams" value="${not empty param.search ? 'search='.concat(fn:escapeXml(param.search)) : ''}${not empty param.status ? '&status='.concat(fn:escapeXml(param.status)) : ''}${not empty param.category ? '&category='.concat(fn:escapeXml(param.category)) : ''}${not empty param.sort ? '&sort='.concat(fn:escapeXml(param.sort)) : ''}" />
                    </jsp:include>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Empty State -->
                <div class="empty-state">
                    <i class="fas fa-book-open empty-icon"></i>
                    <h3 class="empty-title">Chưa có khóa học nào</h3>
                    <p class="empty-description">
                        Bạn chưa tạo khóa học nào. Hãy bắt đầu tạo khóa học đầu tiên
                        để chia sẻ kiến thức của mình với học viên.
                    </p>
                    <a href="${pageContext.request.contextPath}/instructor/courses/new"" class="btn-primary-custom">
                        <i class="fas fa-plus me-2"></i>Tạo khóa học đầu tiên
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JavaScript -->
<script>
    // Auto-submit form khi thay đổi filter - Tự động submit form khi thay đổi bộ lọc
    document.addEventListener('DOMContentLoaded', function() {
        const filterForm = document.getElementById('filterForm');
        const selectElements = filterForm.querySelectorAll('select');

        selectElements.forEach(select => {
            select.addEventListener('change', function() {
                filterForm.submit();
            });
        });

        // Add debounce to search input
        const searchInput = filterForm.querySelector('input[name="search"]');
        let searchTimeout;

        searchInput.addEventListener('input', function() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                filterForm.submit();
            }, 1000); // Delay 1 second
        });
    });

    // Publish course - Xuất bản khóa học
    function publishCourse(courseId) {
        if (confirm('Bạn có chắc chắn muốn xuất bản khóa học này?')) {
            fetch(`/api/instructor/courses/${courseId}/publish`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showToast('Xuất bản khóa học thành công!', 'success');
                        setTimeout(() => window.location.reload(), 1500);
                    } else {
                        showToast(data.message || 'Có lỗi xảy ra!', 'error');
                    }
                })
                .catch(error => {
                    showToast('Có lỗi xảy ra khi xuất bản khóa học!', 'error');
                    console.error('Error:', error);
                });
        }
    }

    // Unpublish course - Tạm dừng khóa học
    function unpublishCourse(courseId) {
        if (confirm('Bạn có chắc chắn muốn tạm dừng khóa học này?')) {
            fetch(`/api/instructor/courses/${courseId}/unpublish`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showToast('Tạm dừng khóa học thành công!', 'success');
                        setTimeout(() => window.location.reload(), 1500);
                    } else {
                        showToast(data.message || 'Có lỗi xảy ra!', 'error');
                    }
                })
                .catch(error => {
                    showToast('Có lỗi xảy ra khi tạm dừng khóa học!', 'error');
                    console.error('Error:', error);
                });
        }
    }

    // Delete course - Xóa khóa học
    function deleteCourse(courseId, courseName) {
        if (confirm(`Bạn có chắc chắn muốn xóa khóa học "${courseName}"?\n\nHành động này không thể hoàn tác!`)) {
            fetch(`/api/instructor/courses/${courseId}`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showToast('Xóa khóa học thành công!', 'success');
                        setTimeout(() => window.location.reload(), 1500);
                    } else {
                        showToast(data.message || 'Có lỗi xảy ra!', 'error');
                    }
                })
                .catch(error => {
                    showToast('Có lỗi xảy ra khi xóa khóa học!', 'error');
                    console.error('Error:', error);
                });
        }
    }

    // Toast notification system - Hệ thống thông báo toast
    function showToast(message, type = 'success') {
        // Remove existing toast
        const existingToast = document.querySelector('.custom-toast');
        if (existingToast) {
            existingToast.remove();
        }

        // Create toast element
        const toast = document.createElement('div');
        toast.className = `custom-toast toast-${type}`;
        toast.innerHTML = `
                <div class="toast-content">
                    <i class="fas ${type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle'}"></i>
                    <span>${message}</span>
                </div>
            `;

        // Add styles
        toast.style.cssText = `
                position: fixed;
                top: 2rem;
                right: 2rem;
                z-index: 9999;
                background: ${type == 'success' ? 'var(--success-color)' : 'var(--danger-color)'};
                color: white;
                padding: 1rem 1.5rem;
                border-radius: 0.75rem;
                box-shadow: 0 10px 25px -3px rgba(0, 0, 0, 0.3);
                transform: translateX(100%);
                transition: transform 0.3s ease;
            `;

        document.body.appendChild(toast);

        // Show toast
        setTimeout(() => {
            toast.style.transform = 'translateX(0)';
        }, 100);

        // Hide toast
        setTimeout(() => {
            toast.style.transform = 'translateX(100%)';
            setTimeout(() => toast.remove(), 300);
        }, 3000);
    }

    // Initialize page - Khởi tạo trang
    document.addEventListener('DOMContentLoaded', function() {
        // Add loading states to action buttons
        const actionButtons = document.querySelectorAll('.course-actions button');
        actionButtons.forEach(button => {
            button.addEventListener('click', function() {
                if (!this.disabled) {
                    const originalText = this.innerHTML;
                    this.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang xử lý...';
                    this.disabled = true;

                    // Re-enable after 5 seconds as fallback
                    setTimeout(() => {
                        this.innerHTML = originalText;
                        this.disabled = false;
                    }, 5000);
                }
            });
        });

        // Add animation to cards
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

    // Keyboard shortcuts - Phím tắt
    document.addEventListener('keydown', function(e) {
        // Ctrl/Cmd + N: Create new course
        if ((e.ctrlKey || e.metaKey) && e.key === 'n') {
            e.preventDefault();
            window.location.href = '<c:url value="/instructor/courses/new" />';
        }

        // Ctrl/Cmd + F: Focus search
        if ((e.ctrlKey || e.metaKey) && e.key === 'f') {
            e.preventDefault();
            document.querySelector('input[name="search"]').focus();
        }
    });
</script>
</body>
</html>