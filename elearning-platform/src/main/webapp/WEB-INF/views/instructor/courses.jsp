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
    <link href="${pageContext.request.contextPath}/css/dashboard-improved.css" rel="stylesheet">

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
            font-size: 1.1rem;
            margin-bottom: 0;
        }

        .page-actions {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary-custom:hover {
            background: linear-gradient(135deg, var(--primary-dark), var(--primary-color));
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
            color: white;
        }

        /* Stats Row */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
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

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), var(--primary-dark));
        }

        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        .stat-title {
            color: var(--text-secondary);
            font-weight: 500;
        }

        .stat-icon {
            font-size: 2.5rem;
            color: var(--primary-color);
            opacity: 0.7;
        }

        /* Filters */
        .filter-row {
            display: grid;
            grid-template-columns: 1fr auto auto;
            gap: 1.5rem;
            align-items: center;
            background: white;
            padding: 1.5rem;
            border-radius: 1rem;
            margin-bottom: 2rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
        }

        .search-box {
            position: relative;
        }

        .search-input {
            width: 100%;
            padding: 0.75rem 1rem 0.75rem 2.5rem;
            border: 2px solid var(--border-color);
            border-radius: 0.5rem;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
            outline: none;
        }

        .search-icon {
            position: absolute;
            left: 0.75rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
        }

        .filter-select {
            padding: 0.75rem 1rem;
            border: 2px solid var(--border-color);
            border-radius: 0.5rem;
            font-size: 1rem;
            transition: all 0.3s ease;
            min-width: 150px;
        }

        .filter-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
            outline: none;
        }

        /* Courses Grid */
        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 2rem;
        }

        .course-card {
            background: white;
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
        }

        .course-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
        }

        .course-image {
            height: 200px;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
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

        .course-status {
            position: absolute;
            top: 1rem;
            right: 1rem;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .status-published {
            background: var(--success-color);
            color: white;
        }

        .status-draft {
            background: var(--warning-color);
            color: white;
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

        .course-title a {
            color: inherit;
            text-decoration: none;
        }

        .course-title a:hover {
            color: var(--primary-color);
        }

        .course-description {
            color: var(--text-secondary);
            font-size: 0.9rem;
            line-height: 1.5;
            margin-bottom: 1.5rem;
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

        .meta-value {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }

        .meta-label {
            font-size: 0.8rem;
            color: var(--text-secondary);
        }

        .course-actions {
            display: flex;
            gap: 0.5rem;
        }

        .btn-action {
            flex: 1;
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 0.5rem;
            font-size: 0.85rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            color: white;
        }

        .btn-success {
            background: var(--success-color);
            color: white;
        }

        .btn-success:hover {
            background: #047857;
            color: white;
        }

        .btn-danger {
            background: var(--danger-color);
            color: white;
        }

        .btn-danger:hover {
            background: #b91c1c;
            color: white;
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
            margin-bottom: 1rem;
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
                    <a href="${pageContext.request.contextPath}/instructor/courses/new" class="btn-primary-custom">
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

            <div class="stat-card">
                <div class="stat-header">
                    <div>
                        <div class="stat-number">${totalStudents}</div>
                        <div class="stat-title">Tổng học viên</div>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-users"></i>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div>
                        <div class="stat-number">${totalRevenue}</div>
                        <div class="stat-title">Doanh thu</div>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div>
                        <div class="stat-number">4.8</div>
                        <div class="stat-title">Đánh giá TB</div>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-star"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filters -->
        <div class="filter-row">
            <div class="search-box">
                <i class="fas fa-search search-icon"></i>
                <input type="text" class="search-input" placeholder="Tìm kiếm khóa học..."
                       value="${searchQuery}" onchange="searchCourses(this.value)">
            </div>
            <select class="filter-select" onchange="filterByStatus(this.value)">
                <option value="">Tất cả trạng thái</option>
                <option value="published">Đã xuất bản</option>
                <option value="draft">Bản nháp</option>
            </select>
            <select class="filter-select" onchange="filterByCategory(this.value)">
                <option value="">Tất cả danh mục</option>
                <c:forEach items="${categories}" var="category">
                    <option value="${category.id}">${category.name}</option>
                </c:forEach>
            </select>
        </div>

        <!-- Courses Grid -->
        <c:choose>
            <c:when test="${not empty courses}">
                <div class="courses-grid">
                    <c:forEach items="${courses}" var="course">
                        <div class="course-card">
                            <!-- Course Image -->
                            <div class="course-image">
                                <c:choose>
                                    <c:when test="${not empty course.thumbnail}">
                                        <img src="${pageContext.request.contextPath}/images/courses/${course.thumbnail}"
                                             alt="${course.name}" loading="lazy">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="course-image-placeholder">
                                            <i class="fas fa-book"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <!-- Course Status -->
                                <div class="course-status ${course.active ? 'status-published' : 'status-draft'}">
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
                                <h3 class="course-title">
                                    <a href="${pageContext.request.contextPath}/instructor/courses/${course.id}">
                                            ${course.name}
                                    </a>
                                </h3>

                                <!-- Description -->
                                <p class="course-description">
                                    <c:choose>
                                        <c:when test="${not empty course.shortDescription}">
                                            ${fn:length(course.shortDescription) > 100 ?
                                              fn:substring(course.shortDescription, 0, 100).concat('...') :
                                              course.shortDescription}
                                        </c:when>
                                        <c:otherwise>
                                            ${fn:length(course.description) > 100 ?
                                              fn:substring(course.description, 0, 100).concat('...') :
                                              course.description}
                                        </c:otherwise>
                                    </c:choose>
                                </p>

                                <!-- Course Meta -->
                                <div class="course-meta">
                                    <div class="meta-item">
                                        <div class="meta-value">${course.enrollmentCount}</div>
                                        <div class="meta-label">Học viên</div>
                                    </div>
                                    <div class="meta-item">
                                        <div class="meta-value">${course.lessonCount}</div>
                                        <div class="meta-label">Bài học</div>
                                    </div>
                                    <div class="meta-item">
                                        <div class="meta-value">
                                            <fmt:formatNumber value="${course.ratingAverage != null ? course.ratingAverage : 0}"
                                                              pattern="#.#" maxFractionDigits="1"/>
                                        </div>
                                        <div class="meta-label">Đánh giá</div>
                                    </div>
                                </div>

                                <!-- Course Actions -->
                                <div class="course-actions">
                                    <a href="${pageContext.request.contextPath}/instructor/courses/${course.id}"
                                       class="btn-action btn-primary">
                                        <i class="fas fa-eye"></i>
                                        Xem
                                    </a>
                                    <a href="${pageContext.request.contextPath}/instructor/courses/${course.id}/edit"
                                       class="btn-action btn-success">
                                        <i class="fas fa-edit"></i>
                                        Sửa
                                    </a>
                                    <button onclick="deleteCourse(${course.id})" class="btn-action btn-danger">
                                        <i class="fas fa-trash"></i>
                                        Xóa
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Empty State -->
                <div class="empty-state">
                    <div class="empty-icon">
                        <i class="fas fa-book-open"></i>
                    </div>
                    <h3 class="empty-title">Chưa có khóa học nào</h3>
                    <p class="empty-description">
                        Bạn chưa tạo khóa học nào. Hãy bắt đầu tạo khóa học đầu tiên để chia sẻ kiến thức với học viên!
                    </p>
                    <a href="${pageContext.request.contextPath}/instructor/courses/new" class="btn-primary-custom">
                        <i class="fas fa-plus"></i>
                        Tạo khóa học đầu tiên
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Tìm kiếm khóa học
    function searchCourses(query) {
        const url = new URL(window.location);
        if (query.trim()) {
            url.searchParams.set('search', query.trim());
        } else {
            url.searchParams.delete('search');
        }
        window.location.href = url.toString();
    }

    // Lọc theo trạng thái
    function filterByStatus(status) {
        const url = new URL(window.location);
        if (status) {
            url.searchParams.set('status', status);
        } else {
            url.searchParams.delete('status');
        }
        window.location.href = url.toString();
    }

    // Lọc theo danh mục
    function filterByCategory(categoryId) {
        const url = new URL(window.location);
        if (categoryId) {
            url.searchParams.set('category', categoryId);
        } else {
            url.searchParams.delete('category');
        }
        window.location.href = url.toString();
    }

    // Xóa khóa học
    function deleteCourse(courseId) {
        if (confirm('Bạn có chắc chắn muốn xóa khóa học này? Hành động này không thể hoàn tác.')) {
            fetch('${pageContext.request.contextPath}/instructor/courses/' + courseId + '/delete', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest',
                    '${_csrf.headerName}': '${_csrf.token}'
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
    function showToast(message, type) {
        // Remove existing toast
        const existingToast = document.querySelector('.custom-toast');
        if (existingToast) {
            existingToast.remove();
        }

        // Create toast element
        const toast = document.createElement('div');
        toast.className = 'custom-toast toast-' + type;

        // FIX: Sử dụng == thay vì === để tương thích với JSP EL
        const iconClass = (type == 'success') ? 'fa-check-circle' : 'fa-exclamation-circle';
        const bgColor = (type == 'success') ? '#059669' : '#dc2626';

        toast.innerHTML =
            '<div class="toast-content">' +
            '<i class="fas ' + iconClass + '"></i>' +
            '<span>' + message + '</span>' +
            '</div>';

        // Add styles
        toast.style.cssText =
            'position: fixed;' +
            'top: 2rem;' +
            'right: 2rem;' +
            'z-index: 9999;' +
            'background: ' + bgColor + ';' +
            'color: white;' +
            'padding: 1rem 1.5rem;' +
            'border-radius: 0.5rem;' +
            'box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);' +
            'display: flex;' +
            'align-items: center;' +
            'gap: 0.75rem;' +
            'font-weight: 500;' +
            'transform: translateX(100%);' +
            'transition: transform 0.3s ease;';

        document.body.appendChild(toast);

        // Show toast
        setTimeout(() => {
            toast.style.transform = 'translateX(0)';
        }, 100);

        // Hide toast after 3 seconds
        setTimeout(() => {
            toast.style.transform = 'translateX(100%)';
            setTimeout(() => {
                if (toast.parentNode) {
                    toast.parentNode.removeChild(toast);
                }
            }, 300);
        }, 3000);
    }

    // Xử lý search input
    document.addEventListener('DOMContentLoaded', function() {
        const searchInput = document.querySelector('.search-input');
        let searchTimeout;

        searchInput.addEventListener('input', function() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                searchCourses(this.value);
            }, 500);
        });

        // Xử lý Enter key
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                clearTimeout(searchTimeout);
                searchCourses(this.value);
            }
        });
    });
</script>

</body>
</html>