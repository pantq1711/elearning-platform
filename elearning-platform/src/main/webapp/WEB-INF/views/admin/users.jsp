<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Người Dùng - EduLearn Admin</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Custom CSS (sử dụng lại CSS từ dashboard) -->
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

        /* Sidebar Styles - giống dashboard */
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

        .main-content {
            padding: 2rem;
        }

        /* Content Cards */
        .content-card {
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            margin-bottom: 2rem;
        }

        .card-header {
            padding: 1.5rem;
            border-bottom: 1px solid #f3f4f6;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #1f2937;
            margin: 0;
        }

        .card-body {
            padding: 1.5rem;
        }

        /* Search and Filters */
        .search-filters {
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .filter-row {
            display: flex;
            gap: 1rem;
            align-items: end;
            flex-wrap: wrap;
        }

        .filter-group {
            flex: 1;
            min-width: 200px;
        }

        /* User Table */
        .user-table {
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
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
            vertical-align: middle;
        }

        .table tbody tr:hover {
            background: #f9fafb;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }

        .user-details h6 {
            margin: 0;
            font-weight: 600;
            color: #1f2937;
        }

        .user-details small {
            color: #6b7280;
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

        .role-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 0.375rem;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .role-admin {
            background: #fef3c7;
            color: var(--warning-color);
        }

        .role-instructor {
            background: #dbeafe;
            color: var(--primary-color);
        }

        .role-student {
            background: #dcfce7;
            color: var(--success-color);
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .btn-sm {
            padding: 0.375rem 0.75rem;
            font-size: 0.75rem;
        }

        /* Pagination */
        .pagination-container {
            padding: 1.5rem;
            display: flex;
            justify-content: between;
            align-items: center;
            border-top: 1px solid #f3f4f6;
        }

        .pagination-info {
            color: #6b7280;
            font-size: 0.875rem;
        }

        .pagination {
            margin: 0;
        }

        .page-link {
            color: var(--primary-color);
            border-color: #e5e7eb;
        }

        .page-link:hover {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }

        .page-item.active .page-link {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
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

            .main-content {
                padding: 1rem;
            }

            .filter-row {
                flex-direction: column;
            }

            .filter-group {
                min-width: 100%;
            }

            .table-responsive {
                font-size: 0.875rem;
            }

            .user-info {
                flex-direction: column;
                text-align: center;
                gap: 0.5rem;
            }

            .action-buttons {
                flex-direction: column;
            }
        }

        /* Modal Styles */
        .modal-header {
            background: var(--light-bg);
            border-bottom: 1px solid #e5e7eb;
        }

        .modal-title {
            font-weight: 600;
            color: #1f2937;
        }
    </style>
</head>

<body>
<div class="admin-wrapper">
    <!-- Sidebar - include từ dashboard -->
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
                <a href="<c:url value='/admin/dashboard' />" class="menu-item">
                    <i class="fas fa-tachometer-alt"></i>Dashboard
                </a>
                <a href="<c:url value='/admin/analytics' />" class="menu-item">
                    <i class="fas fa-chart-line"></i>Thống kê & Báo cáo
                </a>
            </div>

            <!-- User Management -->
            <div class="menu-section">
                <div class="menu-title">Quản lý người dùng</div>
                <a href="<c:url value='/admin/users' />" class="menu-item active">
                    <i class="fas fa-users"></i>Tất cả người dùng
                </a>
                <a href="<c:url value='/admin/users?role=INSTRUCTOR' />" class="menu-item">
                    <i class="fas fa-chalkboard-teacher"></i>Giảng viên
                </a>
                <a href="<c:url value='/admin/users?role=STUDENT' />" class="menu-item">
                    <i class="fas fa-user-graduate"></i>Học viên
                </a>
            </div>

            <!-- Course Management -->
            <div class="menu-section">
                <div class="menu-title">Quản lý khóa học</div>
                <a href="<c:url value='/admin/courses' />" class="menu-item">
                    <i class="fas fa-book"></i>Tất cả khóa học
                </a>
                <a href="<c:url value='/admin/categories' />" class="menu-item">
                    <i class="fas fa-tags"></i>Danh mục
                </a>
                <a href="<c:url value='/admin/courses?status=pending' />" class="menu-item">
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
                <h1 class="header-title">Quản lý người dùng</h1>
            </div>

            <div class="d-flex align-items-center gap-2">
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                    <i class="fas fa-plus me-2"></i>Thêm người dùng
                </button>
                <button class="btn btn-outline-primary" onclick="exportUsers()">
                    <i class="fas fa-download me-2"></i>Xuất Excel
                </button>
            </div>
        </header>

        <!-- Content -->
        <div class="main-content">
            <!-- Success/Error Messages -->
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

            <!-- Search and Filters -->
            <div class="search-filters">
                <form method="GET" action="<c:url value='/admin/users' />" id="filterForm">
                    <div class="filter-row">
                        <div class="filter-group">
                            <label class="form-label">Tìm kiếm</label>
                            <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-search"></i>
                                    </span>
                                <input type="text" class="form-control" name="search"
                                       placeholder="Tên, email, tên đăng nhập..."
                                       value="${param.search}">
                            </div>
                        </div>

                        <div class="filter-group" style="flex: 0 0 150px;">
                            <label class="form-label">Vai trò</label>
                            <select class="form-select" name="role" onchange="submitForm()">
                                <option value="">Tất cả vai trò</option>
                                <option value="ADMIN" ${param.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                                <option value="INSTRUCTOR" ${param.role == 'INSTRUCTOR' ? 'selected' : ''}>Giảng viên</option>
                                <option value="STUDENT" ${param.role == 'STUDENT' ? 'selected' : ''}>Học viên</option>
                            </select>
                        </div>

                        <div class="filter-group" style="flex: 0 0 150px;">
                            <label class="form-label">Trạng thái</label>
                            <select class="form-select" name="status" onchange="submitForm()">
                                <option value="">Tất cả trạng thái</option>
                                <option value="ACTIVE" ${param.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                                <option value="INACTIVE" ${param.status == 'INACTIVE' ? 'selected' : ''}>Không hoạt động</option>
                            </select>
                        </div>

                        <div class="filter-group" style="flex: 0 0 150px;">
                            <label class="form-label">Sắp xếp</label>
                            <select class="form-select" name="sort" onchange="submitForm()">
                                <option value="newest" ${param.sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                                <option value="oldest" ${param.sort == 'oldest' ? 'selected' : ''}>Cũ nhất</option>
                                <option value="name" ${param.sort == 'name' ? 'selected' : ''}>Tên A-Z</option>
                                <option value="email" ${param.sort == 'email' ? 'selected' : ''}>Email A-Z</option>
                            </select>
                        </div>

                        <div class="filter-group" style="flex: 0 0 auto;">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-search me-2"></i>Tìm kiếm
                            </button>
                        </div>

                        <div class="filter-group" style="flex: 0 0 auto;">
                            <button type="button" class="btn btn-outline-secondary" onclick="clearFilters()">
                                <i class="fas fa-times me-2"></i>Xóa bộ lọc
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- User Table -->
            <div class="user-table">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                        <tr>
                            <th>
                                <input type="checkbox" id="selectAll" onchange="toggleSelectAll()">
                            </th>
                            <th>Người dùng</th>
                            <th>Vai trò</th>
                            <th>Trạng thái</th>
                            <th>Ngày tham gia</th>
                            <th>Lần đăng nhập cuối</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty userPage.content}">
                                <c:forEach items="${userPage.content}" var="user">
                                    <tr>
                                        <td>
                                            <input type="checkbox" class="user-checkbox" value="${user.id}">
                                        </td>
                                        <td>
                                            <div class="user-info">
                                                <img src="<c:url value='/images/avatars/${user.avatar}' />"
                                                     alt="${user.fullName}" class="user-avatar"
                                                     onerror="this.src='<c:url value='/images/avatar-default.png' />'">
                                                <div class="user-details">
                                                    <h6>${user.fullName}</h6>
                                                    <small>${user.email}</small>
                                                    <c:if test="${not empty user.phone}">
                                                        <br><small>${user.phone}</small>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                                    <span class="role-badge role-${fn:toLowerCase(user.role)}">
                                                        <c:choose>
                                                            <c:when test="${user.role == 'ADMIN'}">
                                                                <i class="fas fa-crown me-1"></i>Admin
                                                            </c:when>
                                                            <c:when test="${user.role == 'INSTRUCTOR'}">
                                                                <i class="fas fa-chalkboard-teacher me-1"></i>Giảng viên
                                                            </c:when>
                                                            <c:when test="${user.role == 'STUDENT'}">
                                                                <i class="fas fa-user-graduate me-1"></i>Học viên
                                                            </c:when>
                                                        </c:choose>
                                                    </span>
                                        </td>
                                        <td>
                                                    <span class="status-badge status-${user.active ? 'active' : 'inactive'}">
                                                        <i class="fas fa-circle me-1"></i>
                                                        ${user.active ? 'Hoạt động' : 'Không hoạt động'}
                                                    </span>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy"/>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty user.lastLogin}">
                                                    <fmt:formatDate value="${user.lastLogin}" pattern="dd/MM/yyyy HH:mm"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Chưa đăng nhập</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <button class="btn btn-sm btn-outline-primary"
                                                        onclick="viewUser(${user.id})" title="Xem chi tiết">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-warning"
                                                        onclick="editUser(${user.id})" title="Chỉnh sửa">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <c:if test="${user.id != currentUser.id}">
                                                    <button class="btn btn-sm btn-outline-${user.active ? 'danger' : 'success'}"
                                                            onclick="toggleUserStatus(${user.id}, ${user.active})"
                                                            title="${user.active ? 'Vô hiệu hóa' : 'Kích hoạt'}">
                                                        <i class="fas fa-${user.active ? 'ban' : 'check'}"></i>
                                                    </button>
                                                </c:if>
                                                <c:if test="${user.role == 'INSTRUCTOR'}">
                                                    <button class="btn btn-sm btn-outline-info"
                                                            onclick="viewInstructorStats(${user.id})" title="Thống kê giảng viên">
                                                        <i class="fas fa-chart-bar"></i>
                                                    </button>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="text-center py-4">
                                        <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">Không tìm thấy người dùng nào</h5>
                                        <p class="text-muted">Thử thay đổi bộ lọc để tìm kiếm người dùng khác.</p>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <c:if test="${userPage.totalPages > 1}">
                    <div class="pagination-container">
                        <div class="pagination-info">
                            Hiển thị ${(userPage.number * userPage.size) + 1} -
                                ${((userPage.number + 1) * userPage.size) > userPage.totalElements ? userPage.totalElements : (userPage.number + 1) * userPage.size}
                            trong tổng số ${userPage.totalElements} người dùng
                        </div>

                        <nav aria-label="Phân trang người dùng">
                            <ul class="pagination">
                                <!-- Previous Page -->
                                <c:if test="${userPage.hasPrevious()}">
                                    <li class="page-item">
                                        <a class="page-link" href="<c:url value='/admin/users?page=${userPage.number - 1}&${queryString}' />">
                                            <i class="fas fa-chevron-left"></i>
                                        </a>
                                    </li>
                                </c:if>

                                <!-- Page Numbers -->
                                <c:forEach begin="0" end="${userPage.totalPages - 1}" var="pageNum">
                                    <c:if test="${pageNum >= userPage.number - 2 && pageNum <= userPage.number + 2}">
                                        <li class="page-item ${pageNum == userPage.number ? 'active' : ''}">
                                            <a class="page-link" href="<c:url value='/admin/users?page=${pageNum}&${queryString}' />">
                                                    ${pageNum + 1}
                                            </a>
                                        </li>
                                    </c:if>
                                </c:forEach>

                                <!-- Next Page -->
                                <c:if test="${userPage.hasNext()}">
                                    <li class="page-item">
                                        <a class="page-link" href="<c:url value='/admin/users?page=${userPage.number + 1}&${queryString}' />">
                                            <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </div>
                </c:if>
            </div>

            <!-- Bulk Actions -->
            <div class="mt-3">
                <div class="d-flex align-items-center gap-3">
                    <span class="text-muted">Với các mục đã chọn:</span>
                    <button class="btn btn-sm btn-outline-success" onclick="bulkActivate()" disabled id="bulkActivateBtn">
                        <i class="fas fa-check me-1"></i>Kích hoạt
                    </button>
                    <button class="btn btn-sm btn-outline-warning" onclick="bulkDeactivate()" disabled id="bulkDeactivateBtn">
                        <i class="fas fa-ban me-1"></i>Vô hiệu hóa
                    </button>
                    <button class="btn btn-sm btn-outline-primary" onclick="bulkExport()" disabled id="bulkExportBtn">
                        <i class="fas fa-download me-1"></i>Xuất dữ liệu
                    </button>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- Add User Modal -->
<div class="modal fade" id="addUserModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-user-plus me-2"></i>Thêm người dùng mới
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<c:url value='/admin/users/create' />" method="POST" id="addUserForm">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="fullName" class="form-label">Họ và tên <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="fullName" name="fullName" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="username" class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="username" name="username" required>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="phone" class="form-label">Số điện thoại</label>
                                <input type="tel" class="form-control" id="phone" name="phone">
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="password" class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label">Xác nhận mật khẩu <span class="text-danger">*</span></label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="role" class="form-label">Vai trò <span class="text-danger">*</span></label>
                                <select class="form-select" id="role" name="role" required>
                                    <option value="">Chọn vai trò</option>
                                    <option value="STUDENT">Học viên</option>
                                    <option value="INSTRUCTOR">Giảng viên</option>
                                    <option value="ADMIN">Quản trị viên</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="active" class="form-label">Trạng thái</label>
                                <select class="form-select" id="active" name="active">
                                    <option value="true">Hoạt động</option>
                                    <option value="false">Không hoạt động</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i>Lưu người dùng
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- User Detail Modal -->
<div class="modal fade" id="userDetailModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-user me-2"></i>Chi tiết người dùng
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="userDetailContent">
                <!-- Content will be loaded via AJAX -->
            </div>
        </div>
    </div>
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

    // Submit form on filter change
    function submitForm() {
        document.getElementById('filterForm').submit();
    }

    // Clear all filters
    function clearFilters() {
        const url = new URL(window.location);
        url.search = '';
        window.location.href = url.toString();
    }

    // Select all users
    function toggleSelectAll() {
        const selectAll = document.getElementById('selectAll');
        const checkboxes = document.querySelectorAll('.user-checkbox');

        checkboxes.forEach(checkbox => {
            checkbox.checked = selectAll.checked;
        });

        updateBulkActions();
    }

    // Update bulk action buttons based on selection
    function updateBulkActions() {
        const checkedBoxes = document.querySelectorAll('.user-checkbox:checked');
        const bulkButtons = document.querySelectorAll('[id^="bulk"]');

        bulkButtons.forEach(btn => {
            btn.disabled = checkedBoxes.length === 0;
        });
    }

    // Add event listeners to checkboxes
    document.addEventListener('DOMContentLoaded', function() {
        const checkboxes = document.querySelectorAll('.user-checkbox');
        checkboxes.forEach(checkbox => {
            checkbox.addEventListener('change', updateBulkActions);
        });
    });

    // View user details
    function viewUser(userId) {
        fetch(`/admin/api/users/${userId}`)
            .then(response => response.json())
            .then(data => {
                document.getElementById('userDetailContent').innerHTML = `
                        <div class="row">
                            <div class="col-md-4 text-center">
                                <img src="/images/avatars/${data.avatar || 'default.png'}"
                                     class="img-fluid rounded-circle mb-3" style="max-width: 150px;">
                                <h5>${data.fullName}</h5>
                                <span class="badge bg-primary">${data.role}</span>
                            </div>
                            <div class="col-md-8">
                                <table class="table table-borderless">
                                    <tr><th>Email:</th><td>${data.email}</td></tr>
                                    <tr><th>Số điện thoại:</th><td>${data.phone || 'Chưa cập nhật'}</td></tr>
                                    <tr><th>Ngày tham gia:</th><td>${new Date(data.createdAt).toLocaleDateString('vi-VN')}</td></tr>
                                    <tr><th>Lần đăng nhập cuối:</th><td>${data.lastLogin ? new Date(data.lastLogin).toLocaleString('vi-VN') : 'Chưa đăng nhập'}</td></tr>
                                    <tr><th>Trạng thái:</th><td><span class="badge bg-${data.active ? 'success' : 'danger'}">${data.active ? 'Hoạt động' : 'Không hoạt động'}</span></td></tr>
                                </table>
                            </div>
                        </div>
                    `;

                const modal = new bootstrap.Modal(document.getElementById('userDetailModal'));
                modal.show();
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra khi tải thông tin người dùng!');
            });
    }

    // Edit user
    function editUser(userId) {
        window.location.href = `/admin/users/${userId}/edit`;
    }

    // Toggle user status
    function toggleUserStatus(userId, currentStatus) {
        const action = currentStatus ? 'vô hiệu hóa' : 'kích hoạt';

        if (confirm(`Bạn có chắc chắn muốn ${action} người dùng này?`)) {
            fetch(`/admin/api/users/${userId}/toggle-status`, {
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

    // View instructor statistics
    function viewInstructorStats(instructorId) {
        window.location.href = `/admin/instructors/${instructorId}/stats`;
    }

    // Bulk operations
    function bulkActivate() {
        bulkOperation('activate', 'kích hoạt');
    }

    function bulkDeactivate() {
        bulkOperation('deactivate', 'vô hiệu hóa');
    }

    function bulkExport() {
        const checkedBoxes = document.querySelectorAll('.user-checkbox:checked');
        const userIds = Array.from(checkedBoxes).map(cb => cb.value);

        window.location.href = `/admin/users/export?ids=${userIds.join(',')}`;
    }

    function bulkOperation(operation, operationText) {
        const checkedBoxes = document.querySelectorAll('.user-checkbox:checked');
        const userIds = Array.from(checkedBoxes).map(cb => cb.value);

        if (userIds.length === 0) {
            alert('Vui lòng chọn ít nhất một người dùng!');
            return;
        }

        if (confirm(`Bạn có chắc chắn muốn ${operationText} ${userIds.length} người dùng đã chọn?`)) {
            fetch(`/admin/api/users/bulk-${operation}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: JSON.stringify({ userIds: userIds })
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
                    alert('Có lỗi xảy ra khi thực hiện thao tác!');
                });
        }
    }

    // Export all users
    function exportUsers() {
        const params = new URLSearchParams(window.location.search);
        window.location.href = `/admin/users/export?${params.toString()}`;
    }

    // Form validation
    document.getElementById('addUserForm').addEventListener('submit', function(e) {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        if (password !== confirmPassword) {
            e.preventDefault();
            alert('Mật khẩu xác nhận không khớp!');
            return false;
        }

        if (password.length < 6) {
            e.preventDefault();
            alert('Mật khẩu phải có ít nhất 6 ký tự!');
            return false;
        }
    });

    // Auto-hide alerts
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(alert => {
            alert.style.animation = 'fadeOut 0.5s ease';
            setTimeout(() => alert.remove(), 500);
        });
    }, 5000);
</script>
</body>
</html>