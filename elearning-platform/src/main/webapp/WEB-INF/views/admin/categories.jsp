<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Danh mục - Admin</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        /* CSS tùy chỉnh cho quản lý danh mục */
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

        .category-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .category-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            overflow: hidden;
            border-left: 5px solid;
        }

        .category-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2);
        }

        .category-header {
            padding: 1.5rem;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
            border-bottom: 1px solid #f1f3f4;
        }

        .category-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
            margin-bottom: 1rem;
        }

        .category-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }

        .category-description {
            color: #6c757d;
            font-size: 0.9rem;
            line-height: 1.5;
        }

        .category-body {
            padding: 1.5rem;
        }

        .category-stats {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 1.5rem;
            background: #f8f9fa;
            border-top: 1px solid #e9ecef;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
        }

        .stat-label {
            font-size: 0.8rem;
            color: #6c757d;
            font-weight: 500;
        }

        .category-actions {
            padding: 1rem 1.5rem;
            background: white;
            border-top: 1px solid #e9ecef;
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

        .search-filter-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
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

        .featured-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: var(--warning-color);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 15px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .color-preview {
            width: 20px;
            height: 20px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 0.5rem;
            border: 2px solid #fff;
            box-shadow: 0 0 3px rgba(0,0,0,0.3);
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 5rem;
            margin-bottom: 1.5rem;
            opacity: 0.5;
        }

        .stats-summary {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 1.5rem;
            border-radius: 15px;
            margin-bottom: 2rem;
        }

        .stats-summary .row {
            text-align: center;
        }

        .summary-number {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .summary-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        @media (max-width: 768px) {
            .category-grid {
                grid-template-columns: 1fr;
            }

            .category-stats {
                flex-direction: column;
                gap: 1rem;
            }

            .stat-item {
                display: flex;
                align-items: center;
                gap: 0.5rem;
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
                    <a class="nav-link" href="/admin/users">
                        <i class="fas fa-users me-2"></i>
                        Quản lý người dùng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="/admin/categories">
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
                        <h1 class="page-title">Quản lý Danh mục</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="/admin/dashboard">Admin</a></li>
                                <li class="breadcrumb-item active">Danh mục</li>
                            </ol>
                        </nav>
                    </div>
                    <div>
                        <a href="/admin/categories/new" class="btn btn-primary-custom">
                            <i class="fas fa-plus me-2"></i>
                            Thêm danh mục
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
                    <form method="get" action="/admin/categories" class="row g-3">
                        <div class="col-md-6">
                            <label for="search" class="form-label fw-bold">
                                <i class="fas fa-search me-1"></i>Tìm kiếm danh mục
                            </label>
                            <input type="text"
                                   class="form-control"
                                   id="search"
                                   name="search"
                                   placeholder="Tên danh mục hoặc mô tả..."
                                   value="${search}">
                        </div>

                        <div class="col-md-3">
                            <label for="statusFilter" class="form-label fw-bold">
                                <i class="fas fa-filter me-1"></i>Trạng thái
                            </label>
                            <select class="form-select" id="statusFilter" name="status">
                                <option value="">Tất cả trạng thái</option>
                                <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>Hoạt động</option>
                                <option value="inactive" ${statusFilter == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                            </select>
                        </div>

                        <div class="col-md-3 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary-custom w-100">
                                <i class="fas fa-search me-1"></i>Tìm kiếm
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Statistics Summary -->
                <div class="stats-summary">
                    <div class="row">
                        <div class="col-3">
                            <div class="summary-number">${categories.size()}</div>
                            <div class="summary-label">Tổng danh mục</div>
                        </div>
                        <div class="col-3">
                            <div class="summary-number">
                                <c:set var="activeCount" value="0"/>
                                <c:forEach items="${categories}" var="category">
                                    <c:if test="${category.active}">
                                        <c:set var="activeCount" value="${activeCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${activeCount}
                            </div>
                            <div class="summary-label">Đang hoạt động</div>
                        </div>
                        <div class="col-3">
                            <div class="summary-number">
                                <c:set var="featuredCount" value="0"/>
                                <c:forEach items="${categories}" var="category">
                                    <c:if test="${category.featured}">
                                        <c:set var="featuredCount" value="${featuredCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${featuredCount}
                            </div>
                            <div class="summary-label">Nổi bật</div>
                        </div>
                        <div class="col-3">
                            <div class="summary-number">
                                <c:set var="totalCourses" value="0"/>
                                <c:forEach items="${categories}" var="category">
                                    <c:set var="totalCourses" value="${totalCourses + category.courseCount}"/>
                                </c:forEach>
                                ${totalCourses}
                            </div>
                            <div class="summary-label">Tổng khóa học</div>
                        </div>
                    </div>
                </div>

                <!-- Categories Grid -->
                <c:choose>
                    <c:when test="${not empty categories}">
                        <div class="category-grid">
                            <c:forEach items="${categories}" var="category">
                                <div class="category-card position-relative"
                                     style="border-left-color: ${category.colorCode}">

                                    <!-- Featured Badge -->
                                    <c:if test="${category.featured}">
                                        <div class="featured-badge">
                                            <i class="fas fa-star me-1"></i>Nổi bật
                                        </div>
                                    </c:if>

                                    <!-- Category Header -->
                                    <div class="category-header">
                                        <div class="category-icon" style="background-color: ${category.colorCode}">
                                            <i class="${category.iconClass}"></i>
                                        </div>
                                        <h5 class="category-title">${category.name}</h5>
                                        <p class="category-description">${category.description}</p>
                                    </div>

                                    <!-- Category Body -->
                                    <div class="category-body">
                                        <div class="d-flex align-items-center mb-2">
                                            <span class="color-preview" style="background-color: ${category.colorCode}"></span>
                                            <small class="text-muted">Màu sắc: ${category.colorCode}</small>
                                        </div>

                                        <div class="d-flex align-items-center mb-2">
                                            <i class="${category.iconClass} me-2 text-muted"></i>
                                            <small class="text-muted">Icon: ${category.iconClass}</small>
                                        </div>

                                        <div class="d-flex align-items-center">
                                            <span class="status-badge ${category.active ? 'status-active' : 'status-inactive'}">
                                                <i class="fas fa-circle me-1" style="font-size: 0.5rem;"></i>
                                                ${category.active ? 'Hoạt động' : 'Không hoạt động'}
                                            </span>
                                        </div>
                                    </div>

                                    <!-- Category Stats -->
                                    <div class="category-stats">
                                        <div class="stat-item">
                                            <div class="stat-number">${category.courseCount}</div>
                                            <div class="stat-label">Khóa học</div>
                                        </div>
                                        <div class="stat-item">
                                            <div class="stat-number">${category.studentCount}</div>
                                            <div class="stat-label">Học viên</div>
                                        </div>
                                        <div class="stat-item">
                                            <div class="stat-number">
                                                <fmt:formatDate value="${category.createdAt}" pattern="dd/MM"/>
                                            </div>
                                            <div class="stat-label">Ngày tạo</div>
                                        </div>
                                    </div>

                                    <!-- Category Actions -->
                                    <div class="category-actions">
                                        <div class="d-flex justify-content-between">
                                            <div class="btn-group" role="group">
                                                <a href="/admin/categories/${category.id}"
                                                   class="btn btn-outline-info btn-action"
                                                   title="Xem chi tiết">
                                                    <i class="fas fa-eye"></i>
                                                </a>

                                                <a href="/admin/categories/${category.id}/edit"
                                                   class="btn btn-outline-primary btn-action"
                                                   title="Chỉnh sửa">
                                                    <i class="fas fa-edit"></i>
                                                </a>

                                                <form method="post"
                                                      action="/admin/categories/${category.id}/toggle-featured"
                                                      class="d-inline">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                    <button type="submit"
                                                            class="btn btn-outline-${category.featured ? 'warning' : 'success'} btn-action"
                                                            title="${category.featured ? 'Bỏ nổi bật' : 'Đặt nổi bật'}">
                                                        <i class="fas fa-star"></i>
                                                    </button>
                                                </form>
                                            </div>

                                            <div class="btn-group" role="group">
                                                <form method="post"
                                                      action="/admin/categories/${category.id}/toggle-status"
                                                      class="d-inline">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                    <button type="submit"
                                                            class="btn btn-outline-${category.active ? 'warning' : 'success'} btn-action"
                                                            title="${category.active ? 'Vô hiệu hóa' : 'Kích hoạt'}">
                                                        <i class="fas fa-${category.active ? 'ban' : 'check'}"></i>
                                                    </button>
                                                </form>

                                                <c:if test="${category.courseCount == 0}">
                                                    <form method="post"
                                                          action="/admin/categories/${category.id}/delete"
                                                          class="d-inline"
                                                          onsubmit="return confirm('Bạn có chắc muốn xóa danh mục này? Hành động này không thể hoàn tác!')">
                                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                        <button type="submit"
                                                                class="btn btn-outline-danger btn-action"
                                                                title="Xóa">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-tags"></i>
                            <h4>Không tìm thấy danh mục nào</h4>
                            <p class="mb-4">
                                <c:choose>
                                    <c:when test="${not empty search or not empty statusFilter}">
                                        Không có danh mục nào phù hợp với điều kiện tìm kiếm.
                                    </c:when>
                                    <c:otherwise>
                                        Hệ thống chưa có danh mục nào.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <c:if test="${not empty search or not empty statusFilter}">
                                <a href="/admin/categories" class="btn btn-outline-primary me-2">
                                    <i class="fas fa-refresh me-2"></i>Xem tất cả
                                </a>
                            </c:if>
                            <a href="/admin/categories/new" class="btn btn-primary-custom">
                                <i class="fas fa-plus me-2"></i>Thêm danh mục đầu tiên
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
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
        document.getElementById('statusFilter').addEventListener('change', function() {
            this.form.submit();
        });

        // Xác nhận trước khi thực hiện các hành động quan trọng
        document.querySelectorAll('form[onsubmit]').forEach(form => {
            form.addEventListener('submit', function(e) {
                const confirmMessage = this.getAttribute('onsubmit').match(/confirm\('([^']*)'\)/);
                if (confirmMessage && !confirm(confirmMessage[1])) {
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
            document.querySelectorAll('.category-title, .category-description').forEach(element => {
                element.innerHTML = element.innerHTML.replace(regex, '<mark>$1</mark>');
            });
        }

        // Tooltip cho các nút action
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[title]'));
        tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });

        // Animation khi hover category cards
        document.querySelectorAll('.category-card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-8px)';
            });

            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });

        // Color preview click to copy
        document.querySelectorAll('.color-preview').forEach(preview => {
            preview.addEventListener('click', function() {
                const color = this.style.backgroundColor;
                const hex = rgbToHex(color);
                navigator.clipboard.writeText(hex).then(() => {
                    // Hiển thị tooltip ngắn
                    const tooltip = new bootstrap.Tooltip(this, {
                        title: 'Đã copy: ' + hex,
                        trigger: 'manual'
                    });
                    tooltip.show();
                    setTimeout(() => tooltip.dispose(), 1500);
                });
            });
        });
    });

    // Chuyển đổi RGB sang HEX
    function rgbToHex(rgb) {
        if (rgb.charAt(0) === '#') return rgb;

        const values = rgb.match(/\d+/g);
        if (!values || values.length < 3) return rgb;

        const hex = values.slice(0, 3).map(val => {
            const hex = parseInt(val).toString(16);
            return hex.length === 1 ? '0' + hex : hex;
        }).join('');

        return '#' + hex;
    }
</script>

</body>
</html>