<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý khóa học - Admin Panel</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        /* CSS cho admin courses page */
        .admin-wrapper {
            display: flex;
            min-height: 100vh;
            background-color: #f8f9fa;
        }

        .admin-sidebar {
            width: 280px;
            background: linear-gradient(180deg, #4f46e5 0%, #7c3aed 100%);
            color: white;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            transition: transform 0.3s ease;
            z-index: 1000;
        }

        .admin-content {
            flex: 1;
            margin-left: 280px;
            padding: 0;
        }

        .admin-header {
            background: white;
            padding: 1rem 2rem;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #1f2937;
            margin: 0;
        }

        .sidebar-header {
            padding: 1.5rem 1rem;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .menu-section {
            padding: 1rem 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .menu-title {
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            color: rgba(255,255,255,0.7);
            padding: 0 1rem;
            margin-bottom: 0.5rem;
        }

        .menu-item {
            display: flex;
            align-items: center;
            padding: 0.75rem 1rem;
            color: rgba(255,255,255,0.8);
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .menu-item:hover,
        .menu-item.active {
            background-color: rgba(255,255,255,0.1);
            color: white;
            text-decoration: none;
        }

        .menu-item i {
            width: 20px;
            margin-right: 0.75rem;
        }

        .page-content {
            padding: 2rem;
        }

        .stats-overview {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid #e5e7eb;
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
            background: linear-gradient(90deg, #4f46e5, #7c3aed);
        }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
        }

        .stat-content h3 {
            font-size: 2rem;
            font-weight: 700;
            margin: 0;
            color: #1f2937;
        }

        .stat-content p {
            margin: 0;
            color: #6b7280;
            font-size: 0.875rem;
        }

        .filters-section {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid #e5e7eb;
            margin-bottom: 2rem;
        }

        .filter-row {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            align-items: end;
        }

        .filter-group {
            flex: 1;
            min-width: 200px;
        }

        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
        }

        .course-card {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid #e5e7eb;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .course-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .course-image {
            height: 200px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            position: relative;
            overflow: hidden;
        }

        .course-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .course-badge {
            position: absolute;
            top: 1rem;
            right: 1rem;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            color: white;
        }

        .badge-featured {
            background: #f59e0b;
        }

        .badge-draft {
            background: #6b7280;
        }

        .badge-published {
            background: #059669;
        }

        .badge-pending {
            background: #d97706;
        }

        .course-content {
            padding: 1.5rem;
        }

        .course-category {
            color: #4f46e5;
            font-size: 0.875rem;
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .course-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 0.75rem;
            line-height: 1.4;
        }

        .course-instructor {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }

        .instructor-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            object-fit: cover;
        }

        .instructor-name {
            font-size: 0.875rem;
            color: #6b7280;
        }

        .course-stats {
            display: flex;
            justify-content: space-between;
            margin-bottom: 1rem;
            padding-top: 1rem;
            border-top: 1px solid #f3f4f6;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 1.125rem;
            font-weight: 600;
            color: #1f2937;
        }

        .stat-label {
            font-size: 0.75rem;
            color: #6b7280;
        }

        .course-actions {
            display: flex;
            gap: 0.5rem;
        }

        .btn-sm {
            padding: 0.375rem 0.75rem;
            font-size: 0.875rem;
        }

        .difficulty-badge {
            padding: 0.25rem 0.5rem;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .difficulty-beginner {
            background: #dcfce7;
            color: #059669;
        }

        .difficulty-intermediate {
            background: #fef3c7;
            color: #d97706;
        }

        .difficulty-advanced {
            background: #fee2e2;
            color: #dc2626;
        }

        @media (max-width: 768px) {
            .admin-sidebar {
                transform: translateX(-100%);
            }

            .admin-sidebar.show {
                transform: translateX(0);
            }

            .admin-content {
                margin-left: 0;
            }

            .courses-grid {
                grid-template-columns: 1fr;
            }

            .filter-row {
                flex-direction: column;
            }

            .filter-group {
                min-width: 100%;
            }
        }
    </style>
</head>

<body>
<div class="admin-wrapper">
    <!-- Sidebar Navigation -->
    <aside class="admin-sidebar">
        <div class="sidebar-header">
            <h4 class="mb-0">
                <i class="fas fa-graduation-cap me-2"></i>
                E-Learning Admin
            </h4>
        </div>

        <!-- Navigation Menu -->
        <nav class="sidebar-nav">
            <!-- Tổng quan -->
            <div class="menu-section">
                <div class="menu-title">Tổng quan</div>
                <a href="/admin/dashboard" class="menu-item">
                    <i class="fas fa-tachometer-alt"></i>Dashboard
                </a>
                <a href="/admin/analytics" class="menu-item">
                    <i class="fas fa-chart-line"></i>Thống kê & Báo cáo
                </a>
            </div>

            <!-- Quản lý người dùng -->
            <div class="menu-section">
                <div class="menu-title">Quản lý người dùng</div>
                <a href="/admin/users" class="menu-item">
                    <i class="fas fa-users"></i>Tất cả người dùng
                </a>
                <a href="/admin/users?role=INSTRUCTOR" class="menu-item">
                    <i class="fas fa-chalkboard-teacher"></i>Giảng viên
                </a>
                <a href="/admin/users?role=STUDENT" class="menu-item">
                    <i class="fas fa-user-graduate"></i>Học viên
                </a>
            </div>

            <!-- Quản lý khóa học -->
            <div class="menu-section">
                <div class="menu-title">Quản lý khóa học</div>
                <a href="/admin/courses" class="menu-item active">
                    <i class="fas fa-book"></i>Tất cả khóa học
                </a>
                <a href="/admin/categories" class="menu-item">
                    <i class="fas fa-tags"></i>Danh mục
                </a>
                <a href="/admin/courses?status=pending" class="menu-item">
                    <i class="fas fa-clock"></i>Chờ duyệt
                </a>
            </div>
        </nav>
    </aside>

    <!-- Main Content -->
    <main class="admin-content">
        <!-- Header -->
        <header class="admin-header">
            <div class="d-flex align-items-center">
                <button class="btn btn-link d-md-none me-2" onclick="toggleSidebar()">
                    <i class="fas fa-bars"></i>
                </button>
                <h1 class="header-title">Quản lý khóa học</h1>
            </div>

            <div class="d-flex align-items-center gap-2">
                <button class="btn btn-success" onclick="createCourse()">
                    <i class="fas fa-plus me-1"></i>Tạo khóa học
                </button>
                <button class="btn btn-outline-primary" onclick="exportCourses()">
                    <i class="fas fa-download me-1"></i>Xuất Excel
                </button>
                <div class="dropdown">
                    <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user me-1"></i>
                        ${currentUser.fullName}
                    </button>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="/logout">
                            <i class="fas fa-sign-out-alt me-1"></i>Đăng xuất
                        </a></li>
                    </ul>
                </div>
            </div>
        </header>

        <!-- Page Content -->
        <div class="page-content">
            <!-- Alert Messages -->
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Stats Overview -->
            <div class="stats-overview">
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #4f46e5, #7c3aed);">
                            <i class="fas fa-book"></i>
                        </div>
                    </div>
                    <div class="stat-content">
                        <h3>${totalCourses}</h3>
                        <p>Tổng khóa học</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #059669, #10b981);">
                            <i class="fas fa-check-circle"></i>
                        </div>
                    </div>
                    <div class="stat-content">
                        <h3>${activeCourses}</h3>
                        <p>Đã xuất bản</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #d97706, #f59e0b);">
                            <i class="fas fa-clock"></i>
                        </div>
                    </div>
                    <div class="stat-content">
                        <h3>${pendingCourses}</h3>
                        <p>Chờ duyệt</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #dc2626, #ef4444);">
                            <i class="fas fa-star"></i>
                        </div>
                    </div>
                    <div class="stat-content">
                        <h3>${featuredCourses}</h3>
                        <p>Nổi bật</p>
                    </div>
                </div>
            </div>

            <!-- Filters Section -->
            <div class="filters-section">
                <form method="GET" action="admin/courses" id="filterForm">
                    <div class="filter-row">
                        <div class="filter-group">
                            <label class="form-label">Tìm kiếm</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-search"></i></span>
                                <input type="text" class="form-control" name="search"
                                       placeholder="Tên khóa học, giảng viên..."
                                       value="${param.search}">
                            </div>
                        </div>

                        <div class="filter-group" style="flex: 0 0 150px;">
                            <label class="form-label">Danh mục</label>
                            <select class="form-select" name="category" onchange="submitForm()">
                                <option value="">Tất cả danh mục</option>
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.id}" ${param.category == category.id ? 'selected' : ''}>
                                            ${category.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="filter-group" style="flex: 0 0 150px;">
                            <label class="form-label">Trạng thái</label>
                            <select class="form-select" name="status" onchange="submitForm()">
                                <option value="">Tất cả trạng thái</option>
                                <option value="PUBLISHED" ${param.status == 'PUBLISHED' ? 'selected' : ''}>Đã xuất bản</option>
                                <option value="DRAFT" ${param.status == 'DRAFT' ? 'selected' : ''}>Bản nháp</option>
                                <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>Chờ duyệt</option>
                            </select>
                        </div>

                        <div class="filter-group" style="flex: 0 0 150px;">
                            <label class="form-label">Giảng viên</label>
                            <select class="form-select" name="instructor" onchange="submitForm()">
                                <option value="">Tất cả giảng viên</option>
                                <c:forEach var="instructor" items="${instructors}">
                                    <option value="${instructor.id}" ${param.instructor == instructor.id ? 'selected' : ''}>
                                            ${instructor.fullName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="filter-group" style="flex: 0 0 auto;">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-search me-1"></i>Tìm kiếm
                            </button>
                        </div>

                        <div class="filter-group" style="flex: 0 0 auto;">
                            <button type="button" class="btn btn-outline-secondary" onclick="clearFilters()">
                                <i class="fas fa-times me-1"></i>Xóa bộ lọc
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Courses Grid -->
            <div class="courses-grid">
                <c:choose>
                    <c:when test="${not empty courses.content}">
                        <c:forEach var="course" items="${courses.content}">
                            <div class="course-card">
                                <!-- Course Image -->
                                <div class="course-image">
                                    <c:choose>
                                        <c:when test="${not empty course.thumbnail}">
                                            <img src="${pageContext.request.contextPath}/images/courses/${course.thumbnail}" alt="${course.name}">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="d-flex align-items-center justify-content-center h-100">
                                                <i class="fas fa-book text-white" style="font-size: 3rem; opacity: 0.7;"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- Course Status Badge -->
                                    <div class="course-badge badge-${fn:toLowerCase(course.status)}">
                                        <c:choose>
                                            <c:when test="${course.status == 'PUBLISHED'}">
                                                <i class="fas fa-check me-1"></i>Đã xuất bản
                                            </c:when>
                                            <c:when test="${course.status == 'DRAFT'}">
                                                <i class="fas fa-edit me-1"></i>Bản nháp
                                            </c:when>
                                            <c:when test="${course.status == 'PENDING'}">
                                                <i class="fas fa-clock me-1"></i>Chờ duyệt
                                            </c:when>
                                        </c:choose>
                                    </div>

                                    <!-- Featured Badge -->
                                    <c:if test="${course.featured}">
                                        <div class="course-badge badge-featured" style="top: 3rem;">
                                            <i class="fas fa-star me-1"></i>Nổi bật
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Course Content -->
                                <div class="course-content">
                                    <!-- Category -->
                                    <div class="course-category">
                                        <i class="${course.category.iconClass} me-1"></i>
                                            ${course.category.name}
                                    </div>

                                    <!-- Title -->
                                    <h3 class="course-title">${course.name}</h3>

                                    <!-- Instructor -->
                                    <div class="course-instructor">
                                        <img src="${pageContext.request.contextPath}/images/avatars/${course.instructor.avatar}"
                                             alt="${course.instructor.fullName}"
                                             class="instructor-avatar"
                                             onerror="this.src='/images/default-avatar.png'">
                                        <span class="instructor-name">${course.instructor.fullName}</span>
                                    </div>

                                    <!-- Course Stats -->
                                    <div class="course-stats">
                                        <div class="stat-item">
                                            <div class="stat-number">${fn:length(course.enrollments)}</div>
                                            <div class="stat-label">Học viên</div>
                                        </div>
                                        <div class="stat-item">
                                            <div class="stat-number">${course.duration}</div>
                                            <div class="stat-label">Phút</div>
                                        </div>
                                        <div class="stat-item">
                                            <div class="stat-number">
                                                <c:choose>
                                                    <c:when test="${not empty course.averageRating}">
                                                        <fmt:formatNumber value="${course.averageRating}" maxFractionDigits="1" />
                                                    </c:when>
                                                    <c:otherwise>0</c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="stat-label">
                                                <i class="fas fa-star text-warning"></i>
                                            </div>
                                        </div>
                                        <div class="stat-item">
                                            <div class="stat-number">
                                                    <span class="difficulty-badge difficulty-${fn:toLowerCase(course.difficultyLevel)}">
                                                        <c:choose>
                                                            <c:when test="${course.difficultyLevel == 'BEGINNER'}">Cơ bản</c:when>
                                                            <c:when test="${course.difficultyLevel == 'INTERMEDIATE'}">Trung bình</c:when>
                                                            <c:when test="${course.difficultyLevel == 'ADVANCED'}">Nâng cao</c:when>
                                                        </c:choose>
                                                    </span>
                                            </div>
                                            <div class="stat-label">Độ khó</div>
                                        </div>
                                    </div>

                                    <!-- Price -->
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <div>
                                            <strong class="text-primary">
                                                <c:choose>
                                                    <c:when test="${course.price == 0}">Miễn phí</c:when>
                                                    <c:otherwise>
                                                        <fmt:formatNumber value="${course.price}" pattern="#,###" />₫
                                                    </c:otherwise>
                                                </c:choose>
                                            </strong>
                                        </div>
                                        <small class="text-muted">
                                            <fmt:formatDate value="${course.createdAt}" pattern="dd/MM/yyyy" />
                                        </small>
                                    </div>

                                    <!-- Actions -->
                                    <div class="course-actions">
                                        <button class="btn btn-outline-primary btn-sm flex-fill"
                                                onclick="viewCourse(${course.id})">
                                            <i class="fas fa-eye me-1"></i>Xem
                                        </button>
                                        <button class="btn btn-outline-warning btn-sm"
                                                onclick="editCourse(${course.id})">
                                            <i class="fas fa-edit me-1"></i>Sửa
                                        </button>
                                        <div class="dropdown">
                                            <button class="btn btn-outline-secondary btn-sm dropdown-toggle"
                                                    type="button" data-bs-toggle="dropdown">
                                                <i class="fas fa-ellipsis-v"></i>
                                            </button>
                                            <ul class="dropdown-menu">
                                                <c:if test="${course.status == 'PENDING'}">
                                                    <li>
                                                        <a class="dropdown-item" href="#"
                                                           onclick="approveCourse(${course.id})">
                                                            <i class="fas fa-check me-2"></i>Duyệt khóa học
                                                        </a>
                                                    </li>
                                                    <li>
                                                        <a class="dropdown-item" href="#"
                                                           onclick="rejectCourse(${course.id})">
                                                            <i class="fas fa-times me-2"></i>Từ chối
                                                        </a>
                                                    </li>
                                                    <li><hr class="dropdown-divider"></li>
                                                </c:if>
                                                <li>
                                                    <a class="dropdown-item" href="#"
                                                       onclick="toggleFeatured(${course.id}, ${course.featured})">
                                                        <i class="fas fa-star me-2"></i>
                                                            ${course.featured ? 'Bỏ nổi bật' : 'Đặt nổi bật'}
                                                    </a>
                                                </li>
                                                <li>
                                                    <a class="dropdown-item" href="#"
                                                       onclick="duplicateCourse(${course.id})">
                                                        <i class="fas fa-copy me-2"></i>Nhân bản
                                                    </a>
                                                </li>
                                                <li><hr class="dropdown-divider"></li>
                                                <li>
                                                    <a class="dropdown-item text-danger" href="#"
                                                       onclick="deleteCourse(${course.id}, '${course.name}')">
                                                        <i class="fas fa-trash me-2"></i>Xóa khóa học
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-12">
                            <div class="text-center py-5">
                                <i class="fas fa-book fa-4x text-muted mb-3"></i>
                                <h4 class="text-muted">Không tìm thấy khóa học nào</h4>
                                <p class="text-muted">Thử thay đổi bộ lọc hoặc tạo khóa học mới.</p>
                                <button class="btn btn-primary" onclick="createCourse()">
                                    <i class="fas fa-plus me-1"></i>Tạo khóa học đầu tiên
                                </button>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Pagination -->
            <c:if test="${courses.totalPages > 1}">
                <nav aria-label="Course pagination" class="mt-4">
                    <ul class="pagination justify-content-center">
                        <c:if test="${courses.hasPrevious()}">
                            <li class="page-item">
                                <a class="page-link" href="/admin/courses?page=${courses.number - 1}&${queryString}">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                            </li>
                        </c:if>

                        <c:forEach begin="0" end="${courses.totalPages - 1}" var="pageNum">
                            <c:if test="${pageNum >= courses.number - 2 && pageNum <= courses.number + 2}">
                                <li class="page-item ${pageNum == courses.number ? 'active' : ''}">
                                    <a class="page-link" href="/admin/courses?page=${pageNum}&${queryString}">
                                            ${pageNum + 1}
                                    </a>
                                </li>
                            </c:if>
                        </c:forEach>

                        <c:if test="${courses.hasNext()}">
                            <li class="page-item">
                                <a class="page-link" href="/admin/courses?page=${courses.number + 1}&${queryString}">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </c:if>
        </div>
    </main>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // JavaScript cho courses management

    // Toggle sidebar trên mobile
    function toggleSidebar() {
        document.querySelector('.admin-sidebar').classList.toggle('show');
    }

    // Submit form khi thay đổi filter
    function submitForm() {
        document.getElementById('filterForm').submit();
    }

    // Xóa tất cả filters
    function clearFilters() {
        const url = new URL(window.location);
        url.search = '';
        window.location.href = url.toString();
    }

    // Tạo khóa học mới
    function createCourse() {
        window.location.href = '/instructor/courses/new';
    }

    // Xem chi tiết khóa học
    function viewCourse(courseId) {
        window.location.href = `/admin/courses/${courseId}`;
    }

    // Chỉnh sửa khóa học
    function editCourse(courseId) {
        window.location.href = `/instructor/courses/${courseId}/edit`;
    }

    // Duyệt khóa học
    function approveCourse(courseId) {
        if (confirm('Bạn có chắc chắn muốn duyệt khóa học này?')) {
            fetch(`/admin/api/courses/${courseId}/approve`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert(data.message || 'Có lỗi xảy ra!');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi duyệt khóa học!');
                });
        }
    }

    // Từ chối khóa học
    function rejectCourse(courseId) {
        const reason = prompt('Nhập lý do từ chối:');
        if (reason && reason.trim()) {
            fetch(`/admin/api/courses/${courseId}/reject`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: JSON.stringify({ reason: reason })
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert(data.message || 'Có lỗi xảy ra!');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi từ chối khóa học!');
                });
        }
    }

    // Toggle featured status
    function toggleFeatured(courseId, currentStatus) {
        const action = currentStatus ? 'bỏ nổi bật' : 'đặt nổi bật';
        if (confirm(`Bạn có chắc chắn muốn ${action} khóa học này?`)) {
            fetch(`/admin/api/courses/${courseId}/toggle-featured`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert(data.message || 'Có lỗi xảy ra!');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi cập nhật trạng thái!');
                });
        }
    }

    // Nhân bản khóa học
    function duplicateCourse(courseId) {
        if (confirm('Bạn có chắc chắn muốn nhân bản khóa học này?')) {
            fetch(`/admin/api/courses/${courseId}/duplicate`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Nhân bản khóa học thành công!');
                        location.reload();
                    } else {
                        alert(data.message || 'Có lỗi xảy ra!');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi nhân bản khóa học!');
                });
        }
    }

    // Xóa khóa học
    function deleteCourse(courseId, courseName) {
        if (confirm(`Bạn có chắc chắn muốn xóa khóa học "${courseName}"?\nThao tác này không thể hoàn tác!`)) {
            fetch(`/admin/api/courses/${courseId}/delete`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert(data.message || 'Có lỗi xảy ra!');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi xóa khóa học!');
                });
        }
    }

    // Export courses
    function exportCourses() {
        const params = new URLSearchParams(window.location.search);
        window.location.href = `/admin/courses/export?${params.toString()}`;
    }

    // Auto-hide alerts sau 5 giây
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert:not(.alert-permanent)');
        alerts.forEach(alert => {
            alert.style.animation = 'fadeOut 0.5s ease';
            setTimeout(() => alert.remove(), 500);
        });
    }, 5000);

    // Animation cho fade out
    const style = document.createElement('style');
    style.textContent = `
            @keyframes fadeOut {
                from { opacity: 1; transform: translateY(0); }
                to { opacity: 0; transform: translateY(-20px); }
            }
        `;
    document.head.appendChild(style);
</script>
</body>
</html>