<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Người dùng - Admin</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        /* CSS tùy chỉnh cho quản lý người dùng */
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #28a745;
            --danger-color: #dc3545;
            --warning-color: #ffc107;
            --info-color: #17a2b8;
        }

        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .sidebar {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            min-height: 100vh;
            padding: 0;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }

        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.9);
            padding: 1rem 1.5rem;
            transition: all 0.3s ease;
            border-left: 4px solid transparent;
        }

        .sidebar .nav-link:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border-left-color: white;
        }

        .sidebar .nav-link.active {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border-left-color: white;
            font-weight: 600;
        }

        .content-header {
            background: white;
            padding: 1.5rem 2rem;
            border-bottom: 1px solid #dee2e6;
            margin-bottom: 2rem;
        }

        .page-title {
            color: #2c3e50;
            font-weight: 700;
            margin: 0;
        }

        .breadcrumb {
            background: none;
            padding: 0;
            margin: 0;
        }

        .search-filter-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }

        .table-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .table-card .card-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 1.5rem;
            border: none;
        }

        .table {
            margin: 0;
        }

        .table th {
            background: #f8f9fa;
            font-weight: 600;
            color: #2c3e50;
            border-top: none;
            padding: 1rem;
            white-space: nowrap;
        }

        .table td {
            padding: 1rem;
            vertical-align: middle;
        }

        .user-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: var(--primary-color);
            color: white;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 1.2rem;
            margin-right: 1rem;
        }

        .status-badge {
            padding: 0.375rem 0.75rem;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .status-active {
            background: rgba(40, 167, 69, 0.1);
            color: var(--success-color);
            border: 1px solid rgba(40, 167, 69, 0.2);
        }

        .status-inactive {
            background: rgba(108, 117, 125, 0.1);
            color: #6c757d;
            border: 1px solid rgba(108, 117, 125, 0.2);
        }

        .role-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .role-admin {
            background: rgba(220, 53, 69, 0.1);
            color: var(--danger-color);
        }

        .role-instructor {
            background: rgba(23, 162, 184, 0.1);
            color: var(--info-color);
        }

        .role-student {
            background: rgba(40, 167, 69, 0.1);
            color: var(--success-color);
        }

        .btn-action {
            padding: 0.375rem 0.75rem;
            border-radius: 8px;
            font-size: 0.875rem;
            margin: 0 0.125rem;
            transition: all 0.3s ease;
        }

        .btn-action:hover {
            transform: translateY(-2px);
        }

        .search-form {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 10px;
            margin-bottom: 1rem;
        }

        .form-control, .form-select {
            border-radius: 8px;
            border: 2px solid #e9ecef;
            transition: border-color 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.25);
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            border: none;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }

        .stats-row {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 1rem;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
        }

        .stat-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .pagination {
            justify-content: center;
            margin-top: 2rem;
        }

        .page-link {
            border: none;
            padding: 0.75rem 1rem;
            margin: 0 0.125rem;
            border-radius: 8px;
            font-weight: 500;
        }

        .page-link:hover {
            background: var(--primary-color);
            color: white;
        }

        .page-item.active .page-link {
            background: var(--primary-color);
            border-color: var(--primary-color);
        }

        @media (max-width: 768px) {
            .table-responsive {
                font-size: 0.875rem;
            }

            .user-avatar {
                width: 40px;
                height: 40px;
                font-size: 1rem;
            }

            .btn-action {
                padding: 0.25rem 0.5rem;
                font-size: 0.75rem;
            }
        }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <nav class="col-md-3 col-lg-2 sidebar">
            <div class="text-center py-4">
                <h4 class="text-white mb-0">
                    <i class="fas fa-graduation-cap me-2"></i>
                    EduCourse
                </h4>
                <small class="text-white-50">Admin Panel</small>
            </div>

            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link" href="/admin/dashboard">
                        <i class="fas fa-tachometer-alt me-2"></i>
                        Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="/admin/users">
                        <i class="fas fa-users me-2"></i>
                        Quản lý người dùng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/admin/categories">
                        <i class="fas fa-tags me-2"></i>
                        Quản lý danh mục
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/admin/courses">
                        <i class="fas fa-book me-2"></i>
                        Quản lý khóa học
                    </a>
                </li>
                <li class="nav-item mt-4">
                    <a class="nav-link" href="/">
                        <i class="fas fa-home me-2"></i>
                        Về trang chủ
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/logout">
                        <i class="fas fa-sign-out-alt me-2"></i>
                        Đăng xuất
                    </a>
                </li>
            </ul>
        </nav>

        <!-- Main Content -->
        <main class="col-md-9 ms-sm-auto col-lg-10">
            <!-- Content Header -->
            <div class="content-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="page-title">Quản lý Người dùng</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="/admin/dashboard">Admin</a></li>
                                <li class="breadcrumb-item active">Người dùng</li>
                            </ol>
                        </nav>
                    </div>
                    <div>
                        <a href="/admin/users/new" class="btn btn-primary-custom">
                            <i class="fas fa-user-plus me-2"></i>
                            Thêm người dùng
                        </a>
                    </div>
                </div>
            </div>

            <div class="container-fluid px-4">
                <!-- Hiển thị thông báo -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                            ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty message}">
                    <div class="alert alert-success alert-dismissible fade show">
                        <i class="fas fa-check-circle me-2"></i>
                            ${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Search and Filter -->
                <div class="search-filter-card">
                    <form method="get" action="/admin/users" class="row g-3">
                        <div class="col-md-4">
                            <label for="search" class="form-label fw-bold">
                                <i class="fas fa-search me-1"></i>Tìm kiếm
                            </label>
                            <input type="text"
                                   class="form-control"
                                   id="search"
                                   name="search"
                                   placeholder="Tên đăng nhập hoặc email..."
                                   value="${search}">
                        </div>

                        <div class="col-md-3">
                            <label for="roleFilter" class="form-label fw-bold">
                                <i class="fas fa-filter me-1"></i>Lọc theo vai trò
                            </label>
                            <select class="form-select" id="roleFilter" name="role">
                                <option value="">Tất cả vai trò</option>
                                <c:forEach items="${roles}" var="role">
                                    <option value="${role.name()}" ${roleFilter == role.name() ? 'selected' : ''}>
                                        <c:choose>
                                            <c:when test="${role.name() == 'ADMIN'}">Admin</c:when>
                                            <c:when test="${role.name() == 'INSTRUCTOR'}">Giảng viên</c:when>
                                            <c:otherwise>Học viên</c:otherwise>
                                        </c:choose>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label for="statusFilter" class="form-label fw-bold">
                                <i class="fas fa-toggle-on me-1"></i>Trạng thái
                            </label>
                            <select class="form-select" id="statusFilter" name="status">
                                <option value="">Tất cả trạng thái</option>
                                <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>Hoạt động</option>
                                <option value="inactive" ${statusFilter == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                            </select>
                        </div>

                        <div class="col-md-2 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary-custom w-100">
                                <i class="fas fa-search me-1"></i>Tìm kiếm
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Statistics Row -->
                <div class="stats-row">
                    <div class="row text-center">
                        <div class="col-3">
                            <div class="stat-item">
                                <div class="stat-number">${users.size()}</div>
                                <div class="stat-label">Tổng hiển thị</div>
                            </div>
                        </div>
                        <div class="col-3">
                            <div class="stat-item">
                                <div class="stat-number">
                                    <c:set var="adminCount" value="0"/>
                                    <c:forEach items="${users}" var="user">
                                        <c:if test="${user.role.name() == 'ADMIN'}">
                                            <c:set var="adminCount" value="${adminCount + 1}"/>
                                        </c:if>
                                    </c:forEach>
                                    ${adminCount}
                                </div>
                                <div class="stat-label">Admin</div>
                            </div>
                        </div>
                        <div class="col-3">
                            <div class="stat-item">
                                <div class="stat-number">
                                    <c:set var="instructorCount" value="0"/>
                                    <c:forEach items="${users}" var="user">
                                        <c:if test="${user.role.name() == 'INSTRUCTOR'}">
                                            <c:set var="instructorCount" value="${instructorCount + 1}"/>
                                        </c:if>
                                    </c:forEach>
                                    ${instructorCount}
                                </div>
                                <div class="stat-label">Giảng viên</div>
                            </div>
                        </div>
                        <div class="col-3">
                            <div class="stat-item">
                                <div class="stat-number">
                                    <c:set var="studentCount" value="0"/>
                                    <c:forEach items="${users}" var="user">
                                        <c:if test="${user.role.name() == 'STUDENT'}">
                                            <c:set var="studentCount" value="${studentCount + 1}"/>
                                        </c:if>
                                    </c:forEach>
                                    ${studentCount}
                                </div>
                                <div class="stat-label">Học viên</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Users Table -->
                <div class="table-card">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">
                                <i class="fas fa-users me-2"></i>
                                Danh sách người dùng
                            </h5>
                            <span class="badge bg-light text-dark">
                                ${users.size()} người dùng
                            </span>
                        </div>
                    </div>

                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${not empty users}">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                        <tr>
                                            <th>Người dùng</th>
                                            <th>Vai trò</th>
                                            <th>Trạng thái</th>
                                            <th>Ngày tạo</th>
                                            <th>Cập nhật cuối</th>
                                            <th class="text-center">Thao tác</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach items="${users}" var="user">
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="user-avatar">
                                                                ${user.username.substring(0,1).toUpperCase()}
                                                        </div>
                                                        <div>
                                                            <div class="fw-bold">${user.username}</div>
                                                            <small class="text-muted">${user.email}</small>
                                                            <c:if test="${user.id == currentUser.id}">
                                                                <span class="badge bg-warning ms-2">Bạn</span>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${user.role.name() == 'ADMIN'}">
                                                                <span class="role-badge role-admin">
                                                                    <i class="fas fa-crown me-1"></i>Admin
                                                                </span>
                                                        </c:when>
                                                        <c:when test="${user.role.name() == 'INSTRUCTOR'}">
                                                                <span class="role-badge role-instructor">
                                                                    <i class="fas fa-chalkboard-teacher me-1"></i>Giảng viên
                                                                </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                                <span class="role-badge role-student">
                                                                    <i class="fas fa-user-graduate me-1"></i>Học viên
                                                                </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                        <span class="status-badge ${user.active ? 'status-active' : 'status-inactive'}">
                                                            <i class="fas fa-circle me-1" style="font-size: 0.5rem;"></i>
                                                            ${user.active ? 'Hoạt động' : 'Không hoạt động'}
                                                        </span>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy"/>
                                                    <br>
                                                    <small class="text-muted">
                                                        <fmt:formatDate value="${user.createdAt}" pattern="HH:mm"/>
                                                    </small>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${user.updatedAt}" pattern="dd/MM/yyyy"/>
                                                    <br>
                                                    <small class="text-muted">
                                                        <fmt:formatDate value="${user.updatedAt}" pattern="HH:mm"/>
                                                    </small>
                                                </td>
                                                <td class="text-center">
                                                    <div class="btn-group" role="group">
                                                        <!-- Nút xem chi tiết -->
                                                        <a href="/admin/users/${user.id}"
                                                           class="btn btn-outline-info btn-action"
                                                           title="Xem chi tiết">
                                                            <i class="fas fa-eye"></i>
                                                        </a>

                                                        <!-- Nút chỉnh sửa -->
                                                        <a href="/admin/users/${user.id}/edit"
                                                           class="btn btn-outline-primary btn-action"
                                                           title="Chỉnh sửa">
                                                            <i class="fas fa-edit"></i>
                                                        </a>

                                                        <!-- Nút toggle trạng thái -->
                                                        <c:if test="${user.id != currentUser.id}">
                                                            <form method="post"
                                                                  action="/admin/users/${user.id}/toggle-status"
                                                                  class="d-inline"
                                                                  onsubmit="return confirm('Bạn có chắc muốn thay đổi trạng thái của người dùng này?')">
                                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                                <button type="submit"
                                                                        class="btn btn-outline-${user.active ? 'warning' : 'success'} btn-action"
                                                                        title="${user.active ? 'Vô hiệu hóa' : 'Kích hoạt'}">
                                                                    <i class="fas fa-${user.active ? 'ban' : 'check'}"></i>
                                                                </button>
                                                            </form>
                                                        </c:if>

                                                        <!-- Nút reset mật khẩu -->
                                                        <form method="post"
                                                              action="/admin/users/${user.id}/reset-password"
                                                              class="d-inline"
                                                              onsubmit="return confirm('Bạn có chắc muốn reset mật khẩu cho người dùng này?')">
                                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                            <button type="submit"
                                                                    class="btn btn-outline-warning btn-action"
                                                                    title="Reset mật khẩu">
                                                                <i class="fas fa-key"></i>
                                                            </button>
                                                        </form>

                                                        <!-- Nút xóa (chỉ với user không phải admin hiện tại) -->
                                                        <c:if test="${user.id != currentUser.id && user.role.name() != 'ADMIN'}">
                                                            <form method="post"
                                                                  action="/admin/users/${user.id}/delete"
                                                                  class="d-inline"
                                                                  onsubmit="return confirm('Bạn có chắc muốn xóa người dùng này? Hành động này không thể hoàn tác!')">
                                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                                <button type="submit"
                                                                        class="btn btn-outline-danger btn-action"
                                                                        title="Xóa">
                                                                    <i class="fas fa-trash"></i>
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-users"></i>
                                    <h4>Không tìm thấy người dùng nào</h4>
                                    <p class="mb-4">
                                        <c:choose>
                                            <c:when test="${not empty search or not empty roleFilter}">
                                                Không có người dùng nào phù hợp với điều kiện tìm kiếm.
                                            </c:when>
                                            <c:otherwise>
                                                Hệ thống chưa có người dùng nào.
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    <c:if test="${not empty search or not empty roleFilter}">
                                        <a href="/admin/users" class="btn btn-outline-primary">
                                            <i class="fas fa-refresh me-2"></i>Xem tất cả
                                        </a>
                                    </c:if>
                                    <a href="/admin/users/new" class="btn btn-primary-custom ms-2">
                                        <i class="fas fa-user-plus me-2"></i>Thêm người dùng đầu tiên
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Pagination (sẽ implement sau khi có phân trang) -->
                <c:if test="${not empty users && users.size() > 0}">
                    <nav aria-label="Page navigation" class="mt-4">
                        <ul class="pagination">
                            <li class="page-item disabled">
                                <a class="page-link" href="#" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                            <li class="page-item active">
                                <a class="page-link" href="#">1</a>
                            </li>
                            <li class="page-item">
                                <a class="page-link" href="#">2</a>
                            </li>
                            <li class="page-item">
                                <a class="page-link" href="#">3</a>
                            </li>
                            <li class="page-item">
                                <a class="page-link" href="#" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </main>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JavaScript -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Auto submit form khi thay đổi filter
        document.getElementById('roleFilter').addEventListener('change', function() {
            this.form.submit();
        });

        document.getElementById('statusFilter').addEventListener('change', function() {
            this.form.submit();
        });

        // Xác nhận trước khi thực hiện các hành động quan trọng
        document.querySelectorAll('[data-confirm]').forEach(element => {
            element.addEventListener('click', function(e) {
                if (!confirm(this.dataset.confirm)) {
                    e.preventDefault();
                }
            });
        });

        // Tự động ẩn alert sau 5 giây
        setTimeout(function() {
            document.querySelectorAll('.alert').forEach(alert => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);

        // Highlight search terms
        const searchTerm = '${search}';
        if (searchTerm) {
            const regex = new RegExp(`(${searchTerm})`, 'gi');
            document.querySelectorAll('table tbody td').forEach(td => {
                td.innerHTML = td.innerHTML.replace(regex, '<mark>$1</mark>');
            });
        }

        // Tooltip cho các nút action
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[title]'));
        tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    });
</script>

</body>
</html>