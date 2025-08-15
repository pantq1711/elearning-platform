<%-- File: src/main/webapp/WEB-INF/views/admin/user-form.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? 'Sửa' : 'Thêm'} Người Dùng - Admin</title>

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
            overflow: hidden;
        }

        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
        }

        .form-control, .form-select {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 12px 15px;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .btn {
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: #6c757d;
            border: none;
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-1px);
        }

        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 8px;
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

        .role-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
            margin: 2px;
            cursor: pointer;
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }

        .role-admin { background: #dc3545; color: white; }
        .role-instructor { background: #28a745; color: white; }
        .role-student { background: #007bff; color: white; }

        .role-badge:hover {
            transform: scale(1.05);
            border-color: #333;
        }

        .password-toggle {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #6c757d;
            cursor: pointer;
        }

        .text-danger {
            font-size: 0.875rem;
        }

        .input-group {
            position: relative;
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
                            <a class="nav-link active" href="/admin/users">
                                <i class="fas fa-users me-2"></i>Người dùng
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/admin/courses">
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
                            <i class="fas fa-${isEdit ? 'edit' : 'user-plus'} me-2 text-primary"></i>
                            ${isEdit ? 'Sửa' : 'Thêm'} Người Dùng
                        </h1>
                        <p class="text-muted mb-0">${isEdit ? 'Cập nhật thông tin người dùng' : 'Tạo tài khoản người dùng mới'}</p>
                    </div>
                    <a href="/admin/users" class="btn btn-secondary">
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
                                <i class="fas fa-user-circle me-2"></i>Thông tin người dùng
                            </h5>
                        </div>
                        <div class="card-body p-4">
                            <form:form method="post"
                                       action="${isEdit ? '/admin/users/'.concat(user.id).concat('/update') : '/admin/users/create'}"
                                       modelAttribute="user"
                                       class="needs-validation"
                                       novalidate="true">

                                <div class="row">
                                    <!-- Họ tên -->
                                    <div class="col-md-6 mb-3">
                                        <label for="fullName" class="form-label">
                                            Họ và tên <span class="text-danger">*</span>
                                        </label>
                                        <form:input path="fullName" cssClass="form-control" id="fullName"
                                                    required="true" maxlength="100"
                                                    placeholder="Ví dụ: Nguyễn Văn A" />
                                        <form:errors path="fullName" cssClass="text-danger small" />
                                    </div>

                                    <!-- Username -->
                                    <div class="col-md-6 mb-3">
                                        <label for="username" class="form-label">
                                            Username <span class="text-danger">*</span>
                                        </label>
                                        <form:input path="username" cssClass="form-control" id="username"
                                                    required="true" maxlength="50"
                                                    placeholder="username" />
                                        <div class="form-text">Chỉ chứa chữ cái, số và dấu gạch dưới</div>
                                        <form:errors path="username" cssClass="text-danger small" />
                                    </div>
                                </div>

                                <!-- Email -->
                                <div class="mb-3">
                                    <label for="email" class="form-label">
                                        Email <span class="text-danger">*</span>
                                    </label>
                                    <form:input path="email" cssClass="form-control" type="email" id="email"
                                                required="true" maxlength="100"
                                                placeholder="example@email.com" />
                                    <form:errors path="email" cssClass="text-danger small" />
                                </div>

                                <!-- Mật khẩu -->
                                <div class="mb-3">
                                    <label for="password" class="form-label">
                                        Mật khẩu
                                        <c:choose>
                                            <c:when test="${isEdit}">
                                                <small class="text-muted">(để trống nếu không thay đổi)</small>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-danger">*</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" name="password" id="password"
                                            ${isEdit ? '' : 'required'} minlength="6"
                                               placeholder="${isEdit ? 'Nhập mật khẩu mới nếu muốn thay đổi' : 'Tối thiểu 6 ký tự'}" />
                                        <button type="button" class="password-toggle" onclick="togglePassword()">
                                            <i class="fas fa-eye" id="passwordIcon"></i>
                                        </button>
                                    </div>
                                    <div class="form-text">Mật khẩu phải có ít nhất 6 ký tự</div>
                                </div>

                                <!-- Vai trò -->
                                <div class="mb-3">
                                    <label class="form-label">
                                        Vai trò <span class="text-danger">*</span>
                                    </label>
                                    <div class="d-flex flex-wrap gap-2 mb-2">
                                        <c:forEach var="role" items="${roles}">
                                            <label class="role-badge role-${role.name().toLowerCase()}"
                                                   onclick="selectRole('${role}')">
                                                <form:radiobutton path="role" value="${role}" cssClass="d-none" />
                                                <c:choose>
                                                    <c:when test="${role == 'ADMIN'}">
                                                        <i class="fas fa-user-shield me-1"></i>Quản trị viên
                                                    </c:when>
                                                    <c:when test="${role == 'INSTRUCTOR'}">
                                                        <i class="fas fa-chalkboard-teacher me-1"></i>Giảng viên
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-user-graduate me-1"></i>Học viên
                                                    </c:otherwise>
                                                </c:choose>
                                            </label>
                                        </c:forEach>
                                    </div>
                                    <form:errors path="role" cssClass="text-danger small" />
                                </div>

                                <!-- Trạng thái -->
                                <div class="mb-3">
                                    <div class="form-check form-switch">
                                        <form:checkbox path="active" cssClass="form-check-input" id="active" />
                                        <label class="form-check-label" for="active">
                                            <strong>Kích hoạt tài khoản</strong>
                                            <small class="d-block text-muted">Cho phép người dùng đăng nhập vào hệ thống</small>
                                        </label>
                                    </div>
                                </div>

                                <!-- Action Buttons -->
                                <div class="d-flex gap-3 mt-4 pt-3 border-top">
                                    <button type="submit" class="btn btn-primary btn-lg">
                                        <i class="fas fa-${isEdit ? 'save' : 'user-plus'} me-2"></i>
                                            ${isEdit ? 'Cập nhật' : 'Tạo'} người dùng
                                    </button>
                                    <a href="/admin/users" class="btn btn-secondary">
                                        <i class="fas fa-times me-2"></i>Hủy bỏ
                                    </a>
                                </div>
                            </form:form>
                        </div>
                    </div>
                </div>

                <!-- Sidebar thông tin -->
                <div class="col-lg-4">
                    <div class="card">
                        <div class="card-header">
                            <h6 class="mb-0">
                                <i class="fas fa-info-circle me-2"></i>Thông tin vai trò
                            </h6>
                        </div>
                        <div class="card-body">
                            <div class="small">
                                <div class="mb-3">
                                    <div class="role-badge role-admin mb-2">
                                        <i class="fas fa-user-shield me-1"></i>Quản trị viên
                                    </div>
                                    <p class="text-muted mb-0">Có toàn quyền quản lý hệ thống, người dùng, khóa học và nội dung.</p>
                                </div>

                                <div class="mb-3">
                                    <div class="role-badge role-instructor mb-2">
                                        <i class="fas fa-chalkboard-teacher me-1"></i>Giảng viên
                                    </div>
                                    <p class="text-muted mb-0">Có thể tạo và quản lý khóa học, bài giảng, quiz của riêng mình.</p>
                                </div>

                                <div class="mb-3">
                                    <div class="role-badge role-student mb-2">
                                        <i class="fas fa-user-graduate me-1"></i>Học viên
                                    </div>
                                    <p class="text-muted mb-0">Có thể đăng ký và học các khóa học có sẵn trong hệ thống.</p>
                                </div>

                                <div class="alert alert-warning">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    <strong>Lưu ý:</strong>
                                    <c:choose>
                                        <c:when test="${isEdit}">
                                            Việc thay đổi vai trò có thể ảnh hưởng đến quyền truy cập của người dùng.
                                        </c:when>
                                        <c:otherwise>
                                            Chọn vai trò phù hợp với chức năng của người dùng trong hệ thống.
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Thông tin bổ sung khi edit -->
                    <c:if test="${isEdit}">
                        <div class="card mt-3">
                            <div class="card-header">
                                <h6 class="mb-0">
                                    <i class="fas fa-clock me-2"></i>Thông tin bổ sung
                                </h6>
                            </div>
                            <div class="card-body">
                                <div class="small">
                                    <p><strong>ID:</strong> #${user.id}</p>
                                    <p><strong>Ngày tạo:</strong>
                                        <c:set var="createdDate" value="${fn:substring(user.createdAt, 0, 10)}" />
                                        <c:set var="createdTime" value="${fn:substring(user.createdAt, 11, 16)}" />
                                            ${fn:substring(createdDate, 8, 10)}/${fn:substring(createdDate, 5, 7)}/${fn:substring(createdDate, 0, 4)} ${createdTime}
                                    </p>
                                    <p><strong>Cập nhật cuối:</strong>
                                        <c:set var="updatedDate" value="${fn:substring(user.updatedAt, 0, 10)}" />
                                        <c:set var="updatedTime" value="${fn:substring(user.updatedAt, 11, 16)}" />
                                            ${fn:substring(updatedDate, 8, 10)}/${fn:substring(updatedDate, 5, 7)}/${fn:substring(updatedDate, 0, 4)} ${updatedTime}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Toggle password visibility
    function togglePassword() {
        const passwordInput = document.getElementById('password');
        const passwordIcon = document.getElementById('passwordIcon');

        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            passwordIcon.className = 'fas fa-eye-slash';
        } else {
            passwordInput.type = 'password';
            passwordIcon.className = 'fas fa-eye';
        }
    }

    // Select role function
    function selectRole(role) {
        // Uncheck all radio buttons first
        const radios = document.querySelectorAll('input[name="role"]');
        radios.forEach(radio => {
            radio.checked = false;
            radio.closest('label').style.borderColor = 'transparent';
        });

        // Check the selected radio
        const selectedRadio = document.querySelector(`input[value="${role}"]`);
        if (selectedRadio) {
            selectedRadio.checked = true;
            selectedRadio.closest('label').style.borderColor = '#333';
        }
    }

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

    // Set default values và hiển thị role đã chọn
    document.addEventListener('DOMContentLoaded', function() {
        const isEdit = ${isEdit ? 'true' : 'false'};

        if (!isEdit) {
            // Set mặc định active = true khi tạo mới
            document.getElementById('active').checked = true;
            // Set mặc định role = STUDENT
            selectRole('STUDENT');
        } else {
            // Highlight role đã chọn khi edit
            const checkedRole = document.querySelector('input[name="role"]:checked');
            if (checkedRole) {
                checkedRole.closest('label').style.borderColor = '#333';
            }
        }

        // Username validation
        const usernameInput = document.getElementById('username');
        usernameInput.addEventListener('input', function() {
            // Chỉ cho phép chữ cái, số và dấu gạch dưới
            this.value = this.value.replace(/[^a-zA-Z0-9_]/g, '');
        });
    });
</script>
</body>
</html>