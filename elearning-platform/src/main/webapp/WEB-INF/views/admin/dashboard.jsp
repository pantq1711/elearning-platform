<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - EduLearn Platform</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <!-- Custom CSS -->
    <style>
        :root {
            --primary-color: #4f46e5;
            --primary-dark: #3730a3;
            --success-color: #059669;
            --warning-color: #d97706;
            --danger-color: #dc2626;
            --info-color: #0891b2;
            --light-bg: #f8fafc;
            --sidebar-bg: #1f2937;
            --sidebar-hover: #374151;
            --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--light-bg);
        }

        .admin-wrapper {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar Styles */
        .admin-sidebar {
            width: 280px;
            background: var(--sidebar-bg);
            color: white;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .sidebar-header {
            padding: 1.5rem;
            border-bottom: 1px solid #374151;
        }

        .sidebar-brand {
            font-size: 1.5rem;
            font-weight: 700;
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
        }

        .sidebar-brand i {
            margin-right: 0.75rem;
            color: var(--primary-color);
        }

        .sidebar-menu {
            padding: 1rem 0;
        }

        .menu-section {
            margin-bottom: 2rem;
        }

        .menu-title {
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            color: #9ca3af;
            padding: 0 1.5rem;
            margin-bottom: 0.5rem;
            letter-spacing: 0.05em;
        }

        .menu-item {
            display: block;
            padding: 0.75rem 1.5rem;
            color: #d1d5db;
            text-decoration: none;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
        }

        .menu-item:hover,
        .menu-item.active {
            background: var(--sidebar-hover);
            color: white;
            border-left-color: var(--primary-color);
        }

        .menu-item i {
            width: 20px;
            margin-right: 0.75rem;
            text-align: center;
        }

        .menu-badge {
            background: var(--danger-color);
            color: white;
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
            border-radius: 1rem;
            margin-left: auto;
        }

        /* Main Content */
        .admin-content {
            flex: 1;
            margin-left: 280px;
            transition: all 0.3s ease;
        }

        .admin-header {
            background: white;
            padding: 1rem 2rem;
            box-shadow: var(--card-shadow);
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

        .header-actions {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .user-dropdown {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            color: #374151;
            text-decoration: none;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }

        .main-content {
            padding: 2rem;
        }

        /* Stats Cards */
        .stats-grid {
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
            border-left: 4px solid var(--primary-color);
            transition: transform 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-2px);
        }

        .stat-card.success {
            border-left-color: var(--success-color);
        }

        .stat-card.warning {
            border-left-color: var(--warning-color);
        }

        .stat-card.danger {
            border-left-color: var(--danger-color);
        }

        .stat-card.info {
            border-left-color: var(--info-color);
        }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .stat-title {
            font-size: 0.875rem;
            font-weight: 500;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 0.75rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
        }

        .stat-icon.primary {
            background: var(--primary-color);
        }

        .stat-icon.success {
            background: var(--success-color);
        }

        .stat-icon.warning {
            background: var(--warning-color);
        }

        .stat-icon.danger {
            background: var(--danger-color);
        }

        .stat-icon.info {
            background: var(--info-color);
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 0.5rem;
        }

        .stat-change {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.875rem;
        }

        .stat-change.positive {
            color: var(--success-color);
        }

        .stat-change.negative {
            color: var(--danger-color);
        }

        /* Content Cards */
        .content-card {
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            margin-bottom: 2rem;
        }

        .card-header {
            padding: 1.5rem 1.5rem 0;
            border-bottom: 1px solid #f3f4f6;
            margin-bottom: 1.5rem;
        }

        .card-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #1f2937;
            margin: 0;
        }

        .card-subtitle {
            color: #6b7280;
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }

        .card-body {
            padding: 0 1.5rem 1.5rem;
        }

        /* Charts */
        .chart-container {
            position: relative;
            height: 300px;
            margin-bottom: 1rem;
        }

        /* Tables */
        .table-responsive {
            border-radius: 0.75rem;
            overflow: hidden;
        }

        .table {
            margin: 0;
        }

        .table th {
            background: #f9fafb;
            border: none;
            font-weight: 600;
            color: #374151;
            padding: 1rem;
        }

        .table td {
            border: none;
            padding: 1rem;
            border-bottom: 1px solid #f3f4f6;
        }

        .table tbody tr:hover {
            background: #f9fafb;
        }

        /* Status Badges */
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 2rem;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .status-active {
            background: #dcfce7;
            color: var(--success-color);
        }

        .status-inactive {
            background: #fee2e2;
            color: var(--danger-color);
        }

        .status-pending {
            background: #fef3c7;
            color: var(--warning-color);
        }

        /* Quick Actions */
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .action-btn {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 1rem;
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 0.75rem;
            text-decoration: none;
            color: #374151;
            transition: all 0.3s ease;
        }

        .action-btn:hover {
            border-color: var(--primary-color);
            color: var(--primary-color);
            transform: translateY(-2px);
            box-shadow: var(--card-shadow);
        }

        .action-icon {
            width: 40px;
            height: 40px;
            border-radius: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f3f4f6;
            color: #6b7280;
        }

        .action-btn:hover .action-icon {
            background: var(--primary-color);
            color: white;
        }

        /* Responsive */
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

            .admin-header {
                padding: 1rem;
            }

            .main-content {
                padding: 1rem;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>
<div class="admin-wrapper">
    <!-- Sidebar -->
    <aside class="admin-sidebar" id="adminSidebar">
        <div class="sidebar-header">
            <a href="<c:url value='/admin/dashboard' />" class="sidebar-brand">
                <i class="fas fa-graduation-cap"></i>
                EduLearn Admin
            </a>
        </div>

        <nav class="sidebar-menu">
            <!-- Main Navigation -->
            <div class="menu-section">
                <div class="menu-title">Tổng quan</div>
                <a href="<c:url value='/admin/dashboard' />" class="menu-item active">
                    <i class="fas fa-tachometer-alt"></i>Dashboard
                </a>
                <a href="<c:url value='/admin/analytics' />" class="menu-item">
                    <i class="fas fa-chart-line"></i>Thống kê & Báo cáo
                </a>
            </div>

            <!-- User Management -->
            <div class="menu-section">
                <div class="menu-title">Quản lý người dùng</div>
                <a href="<c:url value='/admin/users' />" class="menu-item">
                    <i class="fas fa-users"></i>Tất cả người dùng
                    <span class="menu-badge">${totalUsers}</span>
                </a>
                <a href="<c:url value='/admin/users?role=INSTRUCTOR' />" class="menu-item">
                    <i class="fas fa-chalkboard-teacher"></i>Giảng viên
                    <span class="menu-badge">${totalInstructors}</span>
                </a>
                <a href="<c:url value='/admin/users?role=STUDENT' />" class="menu-item">
                    <i class="fas fa-user-graduate"></i>Học viên
                    <span class="menu-badge">${totalStudents}</span>
                </a>
            </div>

            <!-- Course Management -->
            <div class="menu-section">
                <div class="menu-title">Quản lý khóa học</div>
                <a href="<c:url value='/admin/courses' />" class="menu-item">
                    <i class="fas fa-book"></i>Tất cả khóa học
                    <span class="menu-badge">${totalCourses}</span>
                </a>
                <a href="<c:url value='/admin/categories' />" class="menu-item">
                    <i class="fas fa-tags"></i>Danh mục
                </a>
                <a href="<c:url value='/admin/courses?status=pending' />" class="menu-item">
                    <i class="fas fa-clock"></i>Chờ duyệt
                    <c:if test="${pendingCourses > 0}">
                        <span class="menu-badge">${pendingCourses}</span>
                    </c:if>
                </a>
            </div>

            <!-- Content Management -->
            <div class="menu-section">
                <div class="menu-title">Nội dung</div>
                <a href="<c:url value='/admin/enrollments' />" class="menu-item">
                    <i class="fas fa-user-plus"></i>Đăng ký khóa học
                </a>
                <a href="<c:url value='/admin/reviews' />" class="menu-item">
                    <i class="fas fa-star"></i>Đánh giá & Phản hồi
                </a>
                <a href="<c:url value='/admin/quizzes' />" class="menu-item">
                    <i class="fas fa-question-circle"></i>Bài kiểm tra
                </a>
            </div>

            <!-- System Settings -->
            <div class="menu-section">
                <div class="menu-title">Hệ thống</div>
                <a href="<c:url value='/admin/settings' />" class="menu-item">
                    <i class="fas fa-cog"></i>Cài đặt
                </a>
                <a href="<c:url value='/admin/backups' />" class="menu-item">
                    <i class="fas fa-database"></i>Sao lưu dữ liệu
                </a>
                <a href="<c:url value='/admin/logs' />" class="menu-item">
                    <i class="fas fa-file-alt"></i>Nhật ký hệ thống
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
                <h1 class="header-title">Dashboard</h1>
            </div>

            <div class="header-actions">
                <!-- Notifications -->
                <div class="dropdown">
                    <button class="btn btn-link position-relative" data-bs-toggle="dropdown">
                        <i class="fas fa-bell fa-lg"></i>
                        <c:if test="${notifications > 0}">
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                        ${notifications}
                                </span>
                        </c:if>
                    </button>
                    <div class="dropdown-menu dropdown-menu-end" style="width: 300px;">
                        <h6 class="dropdown-header">Thông báo mới</h6>
                        <a class="dropdown-item" href="#">
                            <div class="d-flex">
                                <i class="fas fa-user-plus text-primary me-3 mt-1"></i>
                                <div>
                                    <div class="fw-bold">Học viên mới đăng ký</div>
                                    <small class="text-muted">5 phút trước</small>
                                </div>
                            </div>
                        </a>
                        <a class="dropdown-item" href="#">
                            <div class="d-flex">
                                <i class="fas fa-book text-success me-3 mt-1"></i>
                                <div>
                                    <div class="fw-bold">Khóa học mới chờ duyệt</div>
                                    <small class="text-muted">15 phút trước</small>
                                </div>
                            </div>
                        </a>
                        <div class="dropdown-divider"></div>
                        <a class="dropdown-item text-center" href="<c:url value='/admin/notifications' />">
                            Xem tất cả thông báo
                        </a>
                    </div>
                </div>

                <!-- User Dropdown -->
                <div class="dropdown">
                    <a href="#" class="user-dropdown" data-bs-toggle="dropdown">
                        <img src="<c:url value='/images/avatars/${currentUser.avatar}' />"
                             alt="${currentUser.fullName}" class="user-avatar"
                             onerror="this.src='<c:url value='/images/avatar-default.png' />'">
                        <div>
                            <div class="fw-bold">${currentUser.fullName}</div>
                            <small class="text-muted">Quản trị viên</small>
                        </div>
                        <i class="fas fa-chevron-down ms-2"></i>
                    </a>
                    <div class="dropdown-menu dropdown-menu-end">
                        <a class="dropdown-item" href="<c:url value='/profile' />">
                            <i class="fas fa-user me-2"></i>Hồ sơ cá nhân
                        </a>
                        <a class="dropdown-item" href="<c:url value='/admin/settings' />">
                            <i class="fas fa-cog me-2"></i>Cài đặt
                        </a>
                        <div class="dropdown-divider"></div>
                        <form method="POST" action="<c:url value='/logout' />" class="d-inline">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <button type="submit" class="dropdown-item text-danger">
                                <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </header>

        <!-- Content -->
        <div class="main-content">
            <!-- Welcome Message -->
            <div class="alert alert-primary border-0 mb-4" role="alert">
                <div class="d-flex align-items-center">
                    <i class="fas fa-info-circle fa-2x me-3"></i>
                    <div>
                        <h5 class="alert-heading mb-1">Chào mừng trở lại, ${currentUser.fullName}!</h5>
                        <p class="mb-0">Hôm nay có <strong>${todayStats.newUsers}</strong> người dùng mới và <strong>${todayStats.newEnrollments}</strong> đăng ký khóa học mới.</p>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="quick-actions">
                <a href="<c:url value='/admin/users/new' />" class="action-btn">
                    <div class="action-icon">
                        <i class="fas fa-user-plus"></i>
                    </div>
                    <div>
                        <div class="fw-bold">Thêm người dùng</div>
                        <small class="text-muted">Tạo tài khoản mới</small>
                    </div>
                </a>

                <a href="<c:url value='/admin/categories/new' />" class="action-btn">
                    <div class="action-icon">
                        <i class="fas fa-tags"></i>
                    </div>
                    <div>
                        <div class="fw-bold">Thêm danh mục</div>
                        <small class="text-muted">Tạo danh mục khóa học</small>
                    </div>
                </a>

                <a href="<c:url value='/admin/courses?status=pending' />" class="action-btn">
                    <div class="action-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div>
                        <div class="fw-bold">Duyệt khóa học</div>
                        <small class="text-muted">${pendingCourses} chờ duyệt</small>
                    </div>
                </a>

                <a href="<c:url value='/admin/analytics' />" class="action-btn">
                    <div class="action-icon">
                        <i class="fas fa-chart-bar"></i>
                    </div>
                    <div>
                        <div class="fw-bold">Xem báo cáo</div>
                        <small class="text-muted">Thống kê chi tiết</small>
                    </div>
                </a>
            </div>

            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-title">Tổng người dùng</div>
                        <div class="stat-icon primary">
                            <i class="fas fa-users"></i>
                        </div>
                    </div>
                    <div class="stat-number">${totalUsers}</div>
                    <div class="stat-change positive">
                        <i class="fas fa-arrow-up"></i>
                        <span>+${userGrowth}% so với tháng trước</span>
                    </div>
                </div>

                <div class="stat-card success">
                    <div class="stat-header">
                        <div class="stat-title">Tổng khóa học</div>
                        <div class="stat-icon success">
                            <i class="fas fa-book"></i>
                        </div>
                    </div>
                    <div class="stat-number">${totalCourses}</div>
                    <div class="stat-change positive">
                        <i class="fas fa-arrow-up"></i>
                        <span>+${courseGrowth}% so với tháng trước</span>
                    </div>
                </div>

                <div class="stat-card warning">
                    <div class="stat-header">
                        <div class="stat-title">Đăng ký khóa học</div>
                        <div class="stat-icon warning">
                            <i class="fas fa-user-plus"></i>
                        </div>
                    </div>
                    <div class="stat-number">${totalEnrollments}</div>
                    <div class="stat-change positive">
                        <i class="fas fa-arrow-up"></i>
                        <span>+${enrollmentGrowth}% so với tháng trước</span>
                    </div>
                </div>

                <div class="stat-card info">
                    <div class="stat-header">
                        <div class="stat-title">Doanh thu tháng</div>
                        <div class="stat-icon info">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                    </div>
                    <div class="stat-number">
                        <fmt:formatNumber value="${monthlyRevenue}" type="currency"
                                          currencySymbol="" groupingUsed="true"/>₫
                    </div>
                    <div class="stat-change positive">
                        <i class="fas fa-arrow-up"></i>
                        <span>+${revenueGrowth}% so với tháng trước</span>
                    </div>
                </div>
            </div>

            <!-- Charts Row -->
            <div class="row">
                <!-- User Growth Chart -->
                <div class="col-lg-8 mb-4">
                    <div class="content-card">
                        <div class="card-header">
                            <h3 class="card-title">Biểu đồ tăng trưởng người dùng</h3>
                            <p class="card-subtitle">Số lượng người dùng mới trong 30 ngày qua</p>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="userGrowthChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Course Categories Chart -->
                <div class="col-lg-4 mb-4">
                    <div class="content-card">
                        <div class="card-header">
                            <h3 class="card-title">Phân bố danh mục</h3>
                            <p class="card-subtitle">Khóa học theo danh mục</p>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="categoryChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Activities and Top Courses -->
            <div class="row">
                <!-- Recent Activities -->
                <div class="col-lg-6 mb-4">
                    <div class="content-card">
                        <div class="card-header">
                            <h3 class="card-title">Hoạt động gần đây</h3>
                            <p class="card-subtitle">Cập nhật từ hệ thống</p>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table">
                                    <tbody>
                                    <c:forEach items="${recentActivities}" var="activity">
                                        <tr>
                                            <td style="width: 50px;">
                                                <i class="fas fa-${activity.icon} text-${activity.type}"></i>
                                            </td>
                                            <td>
                                                <div class="fw-bold">${activity.description}</div>
                                                <small class="text-muted">
                                                    <fmt:formatDate value="${activity.timestamp}" pattern="dd/MM/yyyy HH:mm"/>
                                                </small>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Top Courses -->
                <div class="col-lg-6 mb-4">
                    <div class="content-card">
                        <div class="card-header">
                            <h3 class="card-title">Khóa học phổ biến</h3>
                            <p class="card-subtitle">Top 5 khóa học có nhiều đăng ký nhất</p>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                    <tr>
                                        <th>Khóa học</th>
                                        <th>Học viên</th>
                                        <th>Đánh giá</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${topCourses}" var="course">
                                        <tr>
                                            <td>
                                                <div class="fw-bold">${course.name}</div>
                                                <small class="text-muted">${course.instructor.fullName}</small>
                                            </td>
                                            <td>
                                                <span class="badge bg-primary">${course.enrollmentCount}</span>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <i class="fas fa-star text-warning me-1"></i>
                                                    <span>${course.rating}</span>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- System Status -->
            <div class="content-card">
                <div class="card-header">
                    <h3 class="card-title">Trạng thái hệ thống</h3>
                    <p class="card-subtitle">Thông tin về hiệu suất và tài nguyên hệ thống</p>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="text-center">
                                <h4 class="text-success">99.9%</h4>
                                <p class="text-muted mb-0">Uptime</p>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="text-center">
                                <h4 class="text-primary">${systemStats.activeUsers}</h4>
                                <p class="text-muted mb-0">Users online</p>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="text-center">
                                <h4 class="text-warning">${systemStats.diskUsage}%</h4>
                                <p class="text-muted mb-0">Disk Usage</p>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="text-center">
                                <h4 class="text-info">${systemStats.memoryUsage}%</h4>
                                <p class="text-muted mb-0">Memory Usage</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JavaScript -->
<script>
    // Toggle sidebar on mobile
    function toggleSidebar() {
        const sidebar = document.getElementById('adminSidebar');
        sidebar.classList.toggle('show');
    }

    // Close sidebar when clicking outside on mobile
    document.addEventListener('click', function(e) {
        const sidebar = document.getElementById('adminSidebar');
        const toggleBtn = e.target.closest('[onclick="toggleSidebar()"]');

        if (!sidebar.contains(e.target) && !toggleBtn && window.innerWidth <= 768) {
            sidebar.classList.remove('show');
        }
    });

    // Initialize Charts
    document.addEventListener('DOMContentLoaded', function() {
        // User Growth Chart
        const userGrowthCtx = document.getElementById('userGrowthChart').getContext('2d');
        new Chart(userGrowthCtx, {
            type: 'line',
            data: {
                labels: ${userGrowthLabels}, // Từ controller
                datasets: [{
                    label: 'Người dùng mới',
                    data: ${userGrowthData}, // Từ controller
                    borderColor: '#4f46e5',
                    backgroundColor: 'rgba(79, 70, 229, 0.1)',
                    borderWidth: 2,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: '#f3f4f6'
                        }
                    },
                    x: {
                        grid: {
                            color: '#f3f4f6'
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });

        // Category Distribution Chart
        const categoryCtx = document.getElementById('categoryChart').getContext('2d');
        new Chart(categoryCtx, {
            type: 'doughnut',
            data: {
                labels: ${categoryLabels}, // Từ controller
                datasets: [{
                    data: ${categoryData}, // Từ controller
                    backgroundColor: [
                        '#4f46e5',
                        '#059669',
                        '#d97706',
                        '#dc2626',
                        '#0891b2',
                        '#7c3aed'
                    ],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            padding: 20,
                            usePointStyle: true
                        }
                    }
                }
            }
        });
    });

    // Auto-refresh data every 5 minutes
    setInterval(function() {
        // Refresh statistics without page reload
        fetch('/admin/api/dashboard-stats')
            .then(response => response.json())
            .then(data => {
                // Update stats cards
                updateStatsCards(data);
            })
            .catch(error => console.error('Error refreshing stats:', error));
    }, 300000); // 5 minutes

    function updateStatsCards(data) {
        // Update stat numbers
        document.querySelector('.stat-card:nth-child(1) .stat-number').textContent = data.totalUsers;
        document.querySelector('.stat-card:nth-child(2) .stat-number').textContent = data.totalCourses;
        document.querySelector('.stat-card:nth-child(3) .stat-number').textContent = data.totalEnrollments;
        // Update other stats...
    }

    // Notification auto-hide
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert:not(.alert-permanent)');
        alerts.forEach(alert => {
            alert.style.animation = 'fadeOut 0.5s ease';
            setTimeout(() => alert.remove(), 500);
        });
    }, 5000);

    // Add fadeOut animation
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