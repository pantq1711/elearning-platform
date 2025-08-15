<%-- File: src/main/webapp/WEB-INF/views/admin/category-form.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Danh Mục - Admin</title>

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
                <h1 class="h2">Thêm Danh Mục Mới</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="/admin/categories" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại
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

            <!-- Form -->
            <div class="row">
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="fas fa-plus-circle me-2"></i>Thông tin danh mục
                            </h5>
                        </div>
                        <div class="card-body">
                            <form:form method="post" action="/admin/categories/create" modelAttribute="category" class="needs-validation" novalidate="true">
                                <div class="row">
                                    <!-- Tên danh mục -->
                                    <div class="col-md-6 mb-3">
                                        <label for="name" class="form-label">Tên danh mục <span class="text-danger">*</span></label>
                                        <form:input path="name" cssClass="form-control" id="name" required="true" maxlength="100" />
                                        <form:errors path="name" cssClass="text-danger small" />
                                    </div>

                                    <!-- Slug -->
                                    <div class="col-md-6 mb-3">
                                        <label for="slug" class="form-label">Slug</label>
                                        <form:input path="slug" cssClass="form-control" id="slug" maxlength="100" />
                                        <div class="form-text">Để trống để tự động tạo từ tên danh mục</div>
                                        <form:errors path="slug" cssClass="text-danger small" />
                                    </div>
                                </div>

                                <!-- Mô tả -->
                                <div class="mb-3">
                                    <label for="description" class="form-label">Mô tả</label>
                                    <form:textarea path="description" cssClass="form-control" id="description" rows="4" maxlength="500" />
                                    <form:errors path="description" cssClass="text-danger small" />
                                </div>

                                <div class="row">
                                    <!-- Màu sắc -->
                                    <div class="col-md-4 mb-3">
                                        <label for="colorCode" class="form-label">Màu sắc</label>
                                        <form:input path="colorCode" cssClass="form-control" type="color" id="colorCode" value="#007bff" />
                                        <form:errors path="colorCode" cssClass="text-danger small" />
                                    </div>

                                    <!-- Icon -->
                                    <div class="col-md-4 mb-3">
                                        <label for="iconClass" class="form-label">Icon CSS Class</label>
                                        <form:input path="iconClass" cssClass="form-control" id="iconClass" placeholder="fas fa-book" maxlength="50" />
                                        <div class="form-text">Ví dụ: fas fa-book, fas fa-code</div>
                                        <form:errors path="iconClass" cssClass="text-danger small" />
                                    </div>

                                    <!-- Thứ tự sắp xếp -->
                                    <div class="col-md-4 mb-3">
                                        <label for="sortOrder" class="form-label">Thứ tự hiển thị</label>
                                        <form:input path="sortOrder" cssClass="form-control" type="number" id="sortOrder" min="0" max="999" value="0" />
                                        <form:errors path="sortOrder" cssClass="text-danger small" />
                                    </div>
                                </div>

                                <!-- Checkboxes -->
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <div class="form-check">
                                            <form:checkbox path="active" cssClass="form-check-input" id="active" checked="true" />
                                            <label class="form-check-label" for="active">
                                                Kích hoạt danh mục
                                            </label>
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <div class="form-check">
                                            <form:checkbox path="featured" cssClass="form-check-input" id="featured" />
                                            <label class="form-check-label" for="featured">
                                                Danh mục nổi bật
                                            </label>
                                        </div>
                                    </div>
                                </div>

                                <!-- Action Buttons -->
                                <div class="d-flex gap-2 mt-4">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-2"></i>Tạo danh mục
                                    </button>
                                    <a href="/admin/categories" class="btn btn-secondary">
                                        <i class="fas fa-arrow-left me-2"></i>Quay lại
                                    </a>
                                </div>
                            </form:form>
                        </div>
                    </div>
                </div>

                <!-- Preview Card -->
                <div class="col-lg-4">
                    <div class="card">
                        <div class="card-header">
                            <h6 class="card-title mb-0">
                                <i class="fas fa-eye me-2"></i>Xem trước
                            </h6>
                        </div>
                        <div class="card-body">
                            <div class="category-preview">
                                <div class="d-flex align-items-center mb-3">
                                    <div class="category-icon me-3" style="background-color: #007bff; width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white;">
                                        <i class="fas fa-book"></i>
                                    </div>
                                    <div>
                                        <h6 class="mb-0" id="preview-name">Tên danh mục</h6>
                                        <small class="text-muted" id="preview-slug">slug-danh-muc</small>
                                    </div>
                                </div>
                                <p class="text-muted small" id="preview-description">Mô tả danh mục sẽ hiển thị ở đây...</p>
                            </div>
                        </div>
                    </div>

                    <!-- Hướng dẫn -->
                    <div class="card mt-3">
                        <div class="card-header">
                            <h6 class="card-title mb-0">
                                <i class="fas fa-info-circle me-2"></i>Hướng dẫn
                            </h6>
                        </div>
                        <div class="card-body">
                            <ul class="list-unstyled small">
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Tên danh mục phải duy nhất</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Slug tự động tạo nếu để trống</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Chọn màu phù hợp với nội dung</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Icon từ Font Awesome 6</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Auto-generate slug từ name
    document.getElementById('name').addEventListener('input', function() {
        const name = this.value;
        const slug = name.toLowerCase()
            .replace(/[^a-z0-9\s-]/g, '')
            .replace(/\s+/g, '-')
            .replace(/-+/g, '-')
            .trim('-');

        document.getElementById('slug').value = slug;

        // Update preview
        document.getElementById('preview-name').textContent = name || 'Tên danh mục';
        document.getElementById('preview-slug').textContent = slug || 'slug-danh-muc';
    });

    // Update preview color
    document.getElementById('colorCode').addEventListener('input', function() {
        document.querySelector('.category-icon').style.backgroundColor = this.value;
    });

    // Update preview icon
    document.getElementById('iconClass').addEventListener('input', function() {
        const iconElement = document.querySelector('.category-icon i');
        iconElement.className = this.value || 'fas fa-book';
    });

    // Update preview description
    document.getElementById('description').addEventListener('input', function() {
        document.getElementById('preview-description').textContent =
            this.value || 'Mô tả danh mục sẽ hiển thị ở đây...';
    });

    // Form validation
    (function() {
        'use strict';
        window.addEventListener('load', function() {
            var forms = document.getElementsByClassName('needs-validation');
            var validation = Array.prototype.filter.call(forms, function(form) {
                form.addEventListener('submit', function(event) {
                    if (form.checkValidity() === false) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        }, false);
    })();
</script>
</body>
</html>