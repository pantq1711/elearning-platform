<%-- File: src/main/webapp/WEB-INF/views/admin/categories.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Danh Mục - Admin</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }

        .sidebar .nav-link {
            color: rgba(255,255,255,0.8);
            padding: 12px 20px;
            border-radius: 8px;
            margin: 2px 10px;
            transition: all 0.3s ease;
        }

        .sidebar .nav-link:hover {
            background: rgba(255,255,255,0.1);
            color: white;
            transform: translateX(5px);
        }

        .sidebar .nav-link.active {
            background: rgba(255,255,255,0.2);
            color: white;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .sidebar-header {
            padding: 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .main-content {
            background: #f8f9fa;
            min-height: 100vh;
        }

        .content-header {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            padding: 20px;
        }

        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        .table {
            margin-bottom: 0;
        }

        .table th {
            background: #f8f9fa;
            border: none;
            font-weight: 600;
            color: #495057;
            padding: 15px 12px;
        }

        .table td {
            border: none;
            padding: 15px 12px;
            vertical-align: middle;
        }

        .table tbody tr {
            border-bottom: 1px solid #e9ecef;
            transition: all 0.2s ease;
        }

        .table tbody tr:hover {
            background: #f8f9fa;
        }

        .btn {
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-sm {
            padding: 6px 12px;
            font-size: 0.875rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }

        .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .btn-outline-primary:hover {
            background: #667eea;
            border-color: #667eea;
        }

        .btn-outline-danger:hover {
            background: #dc3545;
            border-color: #dc3545;
        }

        .badge {
            font-size: 0.75rem;
            padding: 6px 10px;
            border-radius: 20px;
        }

        .badge-success {
            background: linear-gradient(135deg, #28a745, #20c997);
        }

        .badge-secondary {
            background: #6c757d;
        }

        .category-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 16px;
        }

        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 12px;
            padding: 20px;
        }

        .alert {
            border: none;
            border-radius: 10px;
            border-left: 4px solid;
        }

        .alert-success {
            background: #d1f2dd;
            border-left-color: #28a745;
            color: #155724;
        }

        .alert-danger {
            background: #f8d7da;
            border-left-color: #dc3545;
            color: #721c24;
        }

        .empty-state {
            padding: 60px 20px;
            text-align: center;
        }

        .empty-state i {
            font-size: 4rem;
            color: #dee2e6;
            margin-bottom: 20px;
        }
    </style>
</head>

<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar đẹp hơn -->
        <nav class="col-md-3 col-lg-2 d-md-block sidebar">
            <div class="position-sticky">
                <div class="sidebar-header">
                    <h4 class="text-white mb-0">
                        <i class="fas fa-graduation-cap me-2"></i>EduLearn
                    </h4>
                    <small class="text-white-50">Quản trị viên</small>
                </div>
                <div class="pt-3">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link" href="/admin/dashboard">
                                <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/admin/users">
                                <i class="fas fa-users me-2"></i>Người dùng
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/admin/courses">
                                <i class="fas fa-book me-2"></i>Khóa học
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="/admin/categories">
                                <i class="fas fa-tags me-2"></i>Danh mục
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/admin/analytics">
                                <i class="fas fa-chart-bar me-2"></i>Thống kê
                            </a>
                        </li>
                        <li class="nav-item mt-3">
                            <a class="nav-link" href="/logout">
                                <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Main content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
            <div class="content-header mt-3">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="h2 mb-2">
                            <i class="fas fa-tags me-2 text-primary"></i>Quản Lý Danh Mục
                        </h1>
                        <p class="text-muted mb-0">Quản lý các danh mục khóa học trong hệ thống</p>
                    </div>
                    <a href="/admin/categories/create" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Thêm danh mục
                    </a>
                </div>
            </div>

            <!-- Stats card -->
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="stats-card">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="mb-0">${totalCategories}</h4>
                                <p class="mb-0 opacity-75">Tổng danh mục</p>
                            </div>
                            <i class="fas fa-tags fa-2x opacity-75"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stats-card">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="mb-0">
                                    <c:set var="activeCount" value="0" />
                                    <c:forEach var="category" items="${categories}">
                                        <c:if test="${category.active}">
                                            <c:set var="activeCount" value="${activeCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${activeCount}
                                </h4>
                                <p class="mb-0 opacity-75">Đang hoạt động</p>
                            </div>
                            <i class="fas fa-check-circle fa-2x opacity-75"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stats-card">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="mb-0">
                                    <c:set var="featuredCount" value="0" />
                                    <c:forEach var="category" items="${categories}">
                                        <c:if test="${category.featured}">
                                            <c:set var="featuredCount" value="${featuredCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${featuredCount}
                                </h4>
                                <p class="mb-0 opacity-75">Nổi bật</p>
                            </div>
                            <i class="fas fa-star fa-2x opacity-75"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Alert messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Categories list -->
            <div class="card">
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${not empty categories}">
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                    <tr>
                                        <th style="width: 60px;">Icon</th>
                                        <th>Tên danh mục</th>
                                        <th>Mô tả</th>
                                        <th style="width: 100px;">Khóa học</th>
                                        <th style="width: 120px;">Trạng thái</th>
                                        <th style="width: 150px;">Thao tác</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="category" items="${categories}">
                                        <tr>
                                            <td>
                                                <div class="category-icon" style="background-color: ${category.colorCode}">
                                                    <i class="${not empty category.iconClass ? category.iconClass : 'fas fa-book'}"></i>
                                                </div>
                                            </td>
                                            <td>
                                                <div>
                                                    <h6 class="mb-1">${category.name}</h6>
                                                    <c:if test="${category.featured}">
                                                            <span class="badge bg-warning text-dark">
                                                                <i class="fas fa-star me-1"></i>Nổi bật
                                                            </span>
                                                    </c:if>
                                                </div>
                                            </td>
                                            <td>
                                                    <span class="text-muted">
                                                            ${not empty category.description ? category.description : 'Chưa có mô tả'}
                                                    </span>
                                            </td>
                                            <td>
                                                    <span class="badge bg-primary">
                                                        ${category.courseCount} khóa học
                                                    </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${category.active}">
                                                            <span class="badge badge-success">
                                                                <i class="fas fa-check me-1"></i>Hoạt động
                                                            </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                            <span class="badge badge-secondary">
                                                                <i class="fas fa-pause me-1"></i>Tạm dừng
                                                            </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <button type="button" class="btn btn-sm btn-outline-primary"
                                                            onclick="editCategory(${category.id})">
                                                        <i class="fas fa-edit me-1"></i>Sửa
                                                    </button>
                                                    <c:if test="${category.courseCount == 0}">
                                                        <button type="button" class="btn btn-sm btn-outline-danger"
                                                                onclick="deleteCategory(${category.id}, '${category.name}')">
                                                            <i class="fas fa-trash me-1"></i>Xóa
                                                        </button>
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
                                <i class="fas fa-tags"></i>
                                <h5 class="text-muted mb-3">Chưa có danh mục nào</h5>
                                <p class="text-muted mb-4">Hãy tạo danh mục đầu tiên để phân loại khóa học</p>
                                <a href="/admin/categories/create" class="btn btn-primary">
                                    <i class="fas fa-plus me-2"></i>Thêm danh mục đầu tiên
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Hàm edit category
    function editCategory(id) {
        window.location.href = '/admin/categories/' + id + '/edit';
    }

    // Hàm delete category với confirmation
    function deleteCategory(id, name) {
        // Tạo modal confirmation đẹp hơn
        const confirmMessage = `Bạn có chắc chắn muốn xóa danh mục "${name}"?\n\nHành động này không thể hoàn tác.`;

        if (confirm(confirmMessage)) {
            // Tạo form để submit DELETE request
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '/admin/categories/' + id + '/delete';

            // Thêm CSRF token nếu cần
            const csrfToken = document.querySelector('meta[name="_csrf"]');
            if (csrfToken) {
                const csrfInput = document.createElement('input');
                csrfInput.type = 'hidden';
                csrfInput.name = '_csrf';
                csrfInput.value = csrfToken.getAttribute('content');
                form.appendChild(csrfInput);
            }

            // Thêm loading state
            const deleteButtons = document.querySelectorAll('button[onclick*="deleteCategory(' + id + ',"]');
            deleteButtons.forEach(btn => {
                btn.disabled = true;
                btn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang xóa...';
            });

            document.body.appendChild(form);
            form.submit();
        }
    }

    // Animations khi load trang
    document.addEventListener('DOMContentLoaded', function() {
        // Fade in cho các rows
        const rows = document.querySelectorAll('tbody tr');
        rows.forEach((row, index) => {
            row.style.opacity = '0';
            row.style.transform = 'translateY(20px)';
            setTimeout(() => {
                row.style.transition = 'all 0.3s ease';
                row.style.opacity = '1';
                row.style.transform = 'translateY(0)';
            }, index * 100);
        });
    });
</script>
</body>
</html>