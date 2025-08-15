<%-- File: src/main/webapp/WEB-INF/views/admin/courses.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Khóa Học - Admin</title>

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

        .search-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.06);
            padding: 20px;
            margin-bottom: 20px;
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

        .status-active { background: #28a745; color: white; }
        .status-inactive { background: #6c757d; color: white; }
        .status-featured { background: #ffc107; color: #212529; }

        .level-beginner { background: #28a745; color: white; }
        .level-intermediate { background: #ffc107; color: #212529; }
        .level-advanced { background: #dc3545; color: white; }

        .course-thumbnail {
            width: 60px;
            height: 40px;
            border-radius: 6px;
            object-fit: cover;
            border: 1px solid #e9ecef;
        }

        .course-info h6 {
            margin-bottom: 2px;
            font-weight: 600;
            line-height: 1.2;
        }

        .course-info small {
            color: #6c757d;
        }

        .instructor-info {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .instructor-avatar {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            object-fit: cover;
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

        .pagination {
            justify-content: center;
        }

        .pagination .page-link {
            border-radius: 6px;
            margin: 0 2px;
            border: none;
            color: #667eea;
        }

        .pagination .page-link:hover {
            background: #667eea;
            color: white;
        }

        .pagination .page-item.active .page-link {
            background: #667eea;
            border-color: #667eea;
        }

        .price-format {
            font-weight: 600;
            color: #28a745;
        }

        .free-course {
            color: #6c757d;
            font-style: italic;
        }
    </style>
</head>

<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
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
                            <a class="nav-link active" href="/admin/courses">
                                <i class="fas fa-book me-2"></i>Khóa học
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/admin/categories">
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
                            <i class="fas fa-book me-2 text-primary"></i>Quản Lý Khóa Học
                        </h1>
                        <p class="text-muted mb-0">Quản lý tất cả khóa học trong hệ thống</p>
                    </div>
                    <a href="/admin/courses/create" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Thêm khóa học
                    </a>
                </div>
            </div>

            <!-- Stats cards -->
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="stats-card">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="mb-0">${courses.totalElements}</h4>
                                <p class="mb-0 opacity-75">Tổng khóa học</p>
                            </div>
                            <i class="fas fa-book fa-2x opacity-75"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stats-card">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="mb-0">
                                    <c:set var="activeCount" value="0" />
                                    <c:forEach var="course" items="${courses.content}">
                                        <c:if test="${course.active}">
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
                                    <c:forEach var="course" items="${courses.content}">
                                        <c:if test="${course.featured}">
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

            <!-- Search form -->
            <div class="search-card">
                <form method="get" action="/admin/courses" class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label">Tìm kiếm</label>
                        <input type="text" class="form-control" name="search"
                               placeholder="Tên khóa học..." value="${search}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Danh mục</label>
                        <select name="category" class="form-select">
                            <option value="">Tất cả danh mục</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.id}" ${selectedCategory == cat.id ? 'selected' : ''}>${cat.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Trạng thái</label>
                        <select name="status" class="form-select">
                            <option value="">Tất cả trạng thái</option>
                            <option value="active" ${selectedStatus == 'active' ? 'selected' : ''}>Hoạt động</option>
                            <option value="inactive" ${selectedStatus == 'inactive' ? 'selected' : ''}>Tạm dừng</option>
                            <option value="featured" ${selectedStatus == 'featured' ? 'selected' : ''}>Nổi bật</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">&nbsp;</label>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-search me-1"></i>Tìm
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Courses table -->
            <div class="card">
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${not empty courses.content}">
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                    <tr>
                                        <th>Khóa học</th>
                                        <th>Giảng viên</th>
                                        <th>Danh mục</th>
                                        <th>Cấp độ</th>
                                        <th>Giá</th>
                                        <th>Trạng thái</th>
                                        <th style="width: 150px;">Thao tác</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="course" items="${courses.content}">
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <c:choose>
                                                        <c:when test="${not empty course.imageUrl}">
                                                            <img src="${course.imageUrl}" alt="Thumbnail" class="course-thumbnail me-3">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="course-thumbnail me-3 d-flex align-items-center justify-content-center"
                                                                 style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;">
                                                                <i class="fas fa-book"></i>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <div class="course-info">
                                                        <h6 class="mb-1">${course.name}</h6>
                                                        <small class="text-muted">
                                                            <c:set var="createdDate" value="${fn:substring(course.createdAt, 0, 10)}" />
                                                                ${fn:substring(createdDate, 8, 10)}/${fn:substring(createdDate, 5, 7)}/${fn:substring(createdDate, 0, 4)}
                                                        </small>
                                                        <div class="mt-1">
                                                            <c:if test="${course.featured}">
                                                                    <span class="badge status-featured me-1">
                                                                        <i class="fas fa-star me-1"></i>Nổi bật
                                                                    </span>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="instructor-info">
                                                    <c:choose>
                                                        <c:when test="${not empty course.instructor.profileImageUrl}">
                                                            <img src="${course.instructor.profileImageUrl}" alt="Avatar" class="instructor-avatar">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="instructor-avatar d-flex align-items-center justify-content-center"
                                                                 style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; font-weight: bold; font-size: 12px;">
                                                                    ${fn:substring(course.instructor.fullName, 0, 1)}
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <div>
                                                        <div class="fw-medium">${course.instructor.fullName}</div>
                                                        <small class="text-muted">${course.instructor.email}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="badge bg-secondary">${course.category.name}</span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${course.difficultyLevel == 'EASY'}">
                                                        <span class="badge level-beginner">Cơ bản</span>
                                                    </c:when>
                                                    <c:when test="${course.difficultyLevel == 'MEDIUM'}">
                                                        <span class="badge level-intermediate">Trung cấp</span>
                                                    </c:when>
                                                    <c:when test="${course.difficultyLevel == 'HARD'}">
                                                        <span class="badge level-advanced">Nâng cao</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Chưa xác định</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${course.price == 0}">
                                                        <span class="free-course">Miễn phí</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                            <span class="price-format">
                                                                <fmt:formatNumber value="${course.price}" type="number" groupingUsed="true" />₫
                                                            </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${course.active}">
                                                            <span class="badge status-active">
                                                                <i class="fas fa-check me-1"></i>Hoạt động
                                                            </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                            <span class="badge status-inactive">
                                                                <i class="fas fa-pause me-1"></i>Tạm dừng
                                                            </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <button type="button" class="btn btn-sm btn-outline-primary"
                                                            onclick="editCourse(${course.id})">
                                                        <i class="fas fa-edit me-1"></i>Sửa
                                                    </button>
                                                    <button type="button" class="btn btn-sm btn-outline-danger"
                                                            onclick="deleteCourse(${course.id}, '${course.name}')">>
                                                        <i class="fas fa-trash me-1"></i>Xóa
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Pagination -->
                            <c:if test="${courses.totalPages > 1}">
                                <div class="card-footer bg-white">
                                    <nav aria-label="Page navigation">
                                        <ul class="pagination mb-0">
                                            <c:if test="${courses.number > 0}">
                                                <li class="page-item">
                                                    <a class="page-link" href="?page=${courses.number - 1}&search=${search}&category=${selectedCategory}&status=${selectedStatus}">
                                                        <i class="fas fa-chevron-left"></i>
                                                    </a>
                                                </li>
                                            </c:if>

                                            <c:forEach begin="0" end="${courses.totalPages - 1}" var="i">
                                                <li class="page-item ${i == courses.number ? 'active' : ''}">
                                                    <a class="page-link" href="?page=${i}&search=${search}&category=${selectedCategory}&status=${selectedStatus}">
                                                            ${i + 1}
                                                    </a>
                                                </li>
                                            </c:forEach>

                                            <c:if test="${courses.number < courses.totalPages - 1}">
                                                <li class="page-item">
                                                    <a class="page-link" href="?page=${courses.number + 1}&search=${search}&category=${selectedCategory}&status=${selectedStatus}">
                                                        <i class="fas fa-chevron-right"></i>
                                                    </a>
                                                </li>
                                            </c:if>
                                        </ul>
                                    </nav>
                                </div>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="fas fa-book"></i>
                                <h5 class="text-muted mb-3">Không tìm thấy khóa học nào</h5>
                                <p class="text-muted mb-4">Thử thay đổi bộ lọc hoặc tạo khóa học mới</p>
                                <a href="/admin/courses/create" class="btn btn-primary">
                                    <i class="fas fa-plus me-2"></i>Thêm khóa học mới
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
    // Hàm edit course
    function editCourse(id) {
        window.location.href = '/admin/courses/' + id + '/edit';
    }

    // Hàm delete course với confirmation
    function deleteCourse(id, name) {
        const confirmMessage = `Bạn có chắc chắn muốn xóa khóa học "${name}"?\n\nTất cả dữ liệu liên quan sẽ bị mất và không thể khôi phục.`;

        if (confirm(confirmMessage)) {
            // Tạo form để submit DELETE request
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '/admin/courses/' + id + '/delete';

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
            const deleteButtons = document.querySelectorAll('button[onclick*="deleteCourse(' + id + ',"]');
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
            }, index * 50);
        });
    });
</script>
</body>
</html>