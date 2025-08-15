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
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>

<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar đơn giản -->
        <nav class="col-md-3 col-lg-2 d-md-block bg-dark sidebar">
            <div class="position-sticky pt-3">
                <div class="sidebar-header mb-3">
                    <h5 class="text-white">EduLearn Admin</h5>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link text-white" href="/admin/dashboard">
                            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="/admin/users">
                            <i class="fas fa-users me-2"></i>Người dùng
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="/admin/courses">
                            <i class="fas fa-book me-2"></i>Khóa học
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white active" href="/admin/categories">
                            <i class="fas fa-tags me-2"></i>Danh mục
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="/admin/analytics">
                            <i class="fas fa-chart-bar me-2"></i>Thống kê
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- Main content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Quản Lý Danh Mục</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="/admin/categories/create" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Thêm danh mục
                    </a>
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

            <!-- Stats cards -->
            <div class="row mb-4">
                <div class="col-md-6">
                    <div class="card bg-primary text-white">
                        <div class="card-body">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <h5 class="card-title">Tổng danh mục</h5>
                                    <h2>${totalCategories}</h2>
                                </div>
                                <div class="align-self-center">
                                    <i class="fas fa-tags fa-2x"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Categories table -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-list me-2"></i>Danh sách danh mục
                    </h5>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty categories}">
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead class="table-dark">
                                    <tr>
                                        <th>ID</th>
                                        <th>Tên danh mục</th>
                                        <th>Mô tả</th>
                                        <th>Số khóa học</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="category" items="${categories}">
                                        <tr>
                                            <td>${category.id}</td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <c:if test="${not empty category.iconClass}">
                                                        <i class="${category.iconClass} me-2" style="color: ${category.colorCode}"></i>
                                                    </c:if>
                                                    <strong>${category.name}</strong>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty category.description}">
                                                        ${category.description}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <em class="text-muted">Chưa có mô tả</em>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="badge bg-info">${category.courseCount}</span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${category.active}">
                                                        <span class="badge bg-success">Hoạt động</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Ngưng hoạt động</span>
                                                    </c:otherwise>
                                                </c:choose>

                                                <c:if test="${category.featured}">
                                                    <span class="badge bg-warning ms-1">Nổi bật</span>
                                                </c:if>
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
                            <div class="text-center py-5">
                                <i class="fas fa-tags fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">Chưa có danh mục nào</h5>
                                <p class="text-muted">Hãy tạo danh mục đầu tiên để phân loại khóa học</p>
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
    function editCategory(id) {
        // Redirect to edit form
        window.location.href = '/admin/categories/' + id + '/edit';
    }

    function deleteCategory(id, name) {
        if (confirm('Bạn có chắc chắn muốn xóa danh mục "' + name + '"?')) {
            // Create form to delete
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '/admin/categories/' + id + '/delete';

            // Add CSRF token if needed
            const csrfToken = document.querySelector('meta[name="_csrf"]');
            if (csrfToken) {
                const csrfInput = document.createElement('input');
                csrfInput.type = 'hidden';
                csrfInput.name = '_csrf';
                csrfInput.value = csrfToken.getAttribute('content');
                form.appendChild(csrfInput);
            }

            document.body.appendChild(form);
            form.submit();
        }
    }
</script>
</body>
</html>