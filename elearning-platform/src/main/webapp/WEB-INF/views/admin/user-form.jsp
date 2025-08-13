<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? 'Chỉnh sửa' : 'Thêm'} Người dùng - Admin</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        /* CSS tùy chỉnh cho form người dùng */
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

        .form-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .form-card .card-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 1.5rem;
            border: none;
        }

        .form-card .card-body {
            padding: 2rem;
        }

        .form-floating {
            margin-bottom: 1.5rem;
        }

        .form-floating > .form-control,
        .form-floating > .form-select {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            height: 58px;
            transition: all 0.3s ease;
        }

        .form-floating > .form-control:focus,
        .form-floating > .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.25);
        }

        .form-floating > label {
            color: #6c757d;
            font-weight: 500;
        }

        .role-selector {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .role-option {
            background: white;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .role-option:hover {
            border-color: var(--primary-color);
            background: rgba(102, 126, 234, 0.05);
        }

        .role-option.selected {
            border-color: var(--primary-color);
            background: rgba(102, 126, 234, 0.1);
        }

        .role-option input[type="radio"] {
            display: none;
        }

        .role-title {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }

        .role-description {
            font-size: 0.9rem;
            color: #6c757d;
            margin: 0;
        }

        .role-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }

        .role-admin .role-icon { color: var(--danger-color); }
        .role-instructor .role-icon { color: var(--info-color); }
        .role-student .role-icon { color: var(--success-color); }

        .btn-primary-custom {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            border: none;
            padding: 0.75rem 2rem;
            font-weight: 600;
            border-radius: 10px;
            transition: all 0.3s ease;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }

        .form-check {
            margin-bottom: 1rem;
        }

        .form-check-input:checked {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .form-check-input:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.25);
        }

        .is-invalid {
            border-color: var(--danger-color) !important;
        }

        .invalid-feedback {
            display: block;
            font-size: 0.875rem;
            margin-top: 0.25rem;
            color: var(--danger-color);
        }

        .password-strength {
            margin-top: 0.5rem;
        }

        .strength-bar {
            height: 5px;
            border-radius: 3px;
            background: #e9ecef;
            overflow: hidden;
            margin-bottom: 0.5rem;
        }

        .strength-fill {
            height: 100%;
            transition: all 0.3s ease;
        }

        .strength-weak { background: var(--danger-color); width: 25%; }
        .strength-fair { background: var(--warning-color); width: 50%; }
        .strength-good { background: var(--info-color); width: 75%; }
        .strength-strong { background: var(--success-color); width: 100%; }

        .form-actions {
            background: #f8f9fa;
            padding: 1.5rem 2rem;
            border-top: 1px solid #dee2e6;
        }

        .user-avatar-preview {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: var(--primary-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            font-weight: 700;
            margin: 0 auto 1rem;
        }

        .required-field::after {
            content: " *";
            color: var(--danger-color);
        }

        @media (max-width: 768px) {
            .form-card .card-body {
                padding: 1rem;
            }

            .role-option {
                padding: 1rem;
            }

            .role-icon {
                font-size: 2rem;
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
                        <h1 class="page-title">
                            ${isEdit ? 'Chỉnh sửa' : 'Thêm'} Người dùng
                        </h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="/admin/dashboard">Admin</a></li>
                                <li class="breadcrumb-item"><a href="/admin/users">Người dùng</a></li>
                                <li class="breadcrumb-item active">
                                    ${isEdit ? 'Chỉnh sửa' : 'Thêm mới'}
                                </li>
                            </ol>
                        </nav>
                    </div>
                    <div>
                        <a href="/admin/users" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-2"></i>
                            Quay lại
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

                <!-- Form Card -->
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <div class="form-card">
                            <div class="card-header">
                                <h5 class="mb-0">
                                    <i class="fas fa-${isEdit ? 'edit' : 'user-plus'} me-2"></i>
                                    ${isEdit ? 'Cập nhật thông tin người dùng' : 'Tạo người dùng mới'}
                                </h5>
                            </div>

                            <form method="post"
                                  action="${isEdit ? '/admin/users/'.concat(user.id).concat('/update') : '/admin/users'}"
                                  id="userForm"
                                  novalidate>
                                <!-- CSRF Token -->
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                                <div class="card-body">
                                    <!-- Avatar Preview -->
                                    <div class="text-center mb-4">
                                        <div class="user-avatar-preview" id="avatarPreview">
                                            ${not empty user.username ? user.username.substring(0,1).toUpperCase() : 'U'}
                                        </div>
                                        <h6 class="text-muted">Preview Avatar</h6>
                                    </div>

                                    <div class="row">
                                        <!-- Tên đăng nhập -->
                                        <div class="col-md-6">
                                            <div class="form-floating">
                                                <input type="text"
                                                       class="form-control ${not empty usernameError ? 'is-invalid' : ''}"
                                                       id="username"
                                                       name="username"
                                                       placeholder="Tên đăng nhập"
                                                       value="${user.username}"
                                                ${isEdit ? 'readonly' : ''}
                                                       required>
                                                <label for="username" class="required-field">
                                                    <i class="fas fa-user me-2"></i>Tên đăng nhập
                                                </label>
                                                <c:if test="${not empty usernameError}">
                                                    <div class="invalid-feedback">${usernameError}</div>
                                                </c:if>
                                                <c:if test="${isEdit}">
                                                    <small class="text-muted">Tên đăng nhập không thể thay đổi</small>
                                                </c:if>
                                            </div>
                                        </div>

                                        <!-- Email -->
                                        <div class="col-md-6">
                                            <div class="form-floating">
                                                <input type="email"
                                                       class="form-control ${not empty emailError ? 'is-invalid' : ''}"
                                                       id="email"
                                                       name="email"
                                                       placeholder="Email"
                                                       value="${user.email}"
                                                       required>
                                                <label for="email" class="required-field">
                                                    <i class="fas fa-envelope me-2"></i>Email
                                                </label>
                                                <c:if test="${not empty emailError}">
                                                    <div class="invalid-feedback">${emailError}</div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Họ và tên -->
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-floating">
                                                <input type="text"
                                                       class="form-control"
                                                       id="firstName"
                                                       name="firstName"
                                                       placeholder="Họ"
                                                       value="${user.firstName}">
                                                <label for="firstName">
                                                    <i class="fas fa-user me-2"></i>Họ
                                                </label>
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-floating">
                                                <input type="text"
                                                       class="form-control"
                                                       id="lastName"
                                                       name="lastName"
                                                       placeholder="Tên"
                                                       value="${user.lastName}">
                                                <label for="lastName">
                                                    <i class="fas fa-user me-2"></i>Tên
                                                </label>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Mật khẩu (chỉ hiển thị khi tạo mới) -->
                                    <c:if test="${not isEdit}">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-floating">
                                                    <input type="password"
                                                           class="form-control ${not empty passwordError ? 'is-invalid' : ''}"
                                                           id="password"
                                                           name="password"
                                                           placeholder="Mật khẩu"
                                                           required>
                                                    <label for="password" class="required-field">
                                                        <i class="fas fa-lock me-2"></i>Mật khẩu
                                                    </label>
                                                    <c:if test="${not empty passwordError}">
                                                        <div class="invalid-feedback">${passwordError}</div>
                                                    </c:if>

                                                    <!-- Password Strength Indicator -->
                                                    <div class="password-strength" id="passwordStrength" style="display: none;">
                                                        <div class="strength-bar">
                                                            <div class="strength-fill" id="strengthFill"></div>
                                                        </div>
                                                        <small class="text-muted" id="strengthText">Nhập mật khẩu để kiểm tra độ mạnh</small>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="col-md-6">
                                                <div class="form-floating">
                                                    <input type="password"
                                                           class="form-control"
                                                           id="confirmPassword"
                                                           name="confirmPassword"
                                                           placeholder="Xác nhận mật khẩu"
                                                           required>
                                                    <label for="confirmPassword" class="required-field">
                                                        <i class="fas fa-lock me-2"></i>Xác nhận mật khẩu
                                                    </label>
                                                    <div class="invalid-feedback" id="confirmPasswordError"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- Chọn vai trò -->
                                    <div class="role-selector">
                                        <label class="form-label fw-bold mb-3">
                                            <i class="fas fa-user-tag me-2"></i>Vai trò người dùng
                                            <span class="text-danger">*</span>
                                        </label>

                                        <div class="row">
                                            <!-- Admin Role -->
                                            <div class="col-md-4">
                                                <div class="role-option role-admin" data-role="ADMIN">
                                                    <input type="radio"
                                                           name="role"
                                                           value="ADMIN"
                                                           id="roleAdmin"
                                                    ${user.role.name() == 'ADMIN' ? 'checked' : ''}>
                                                    <div class="text-center">
                                                        <i class="fas fa-crown role-icon"></i>
                                                        <div class="role-title">Admin</div>
                                                        <p class="role-description">
                                                            Quản trị toàn hệ thống, có toàn quyền truy cập
                                                        </p>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Instructor Role -->
                                            <div class="col-md-4">
                                                <div class="role-option role-instructor" data-role="INSTRUCTOR">
                                                    <input type="radio"
                                                           name="role"
                                                           value="INSTRUCTOR"
                                                           id="roleInstructor"
                                                    ${user.role.name() == 'INSTRUCTOR' ? 'checked' : ''}>
                                                    <div class="text-center">
                                                        <i class="fas fa-chalkboard-teacher role-icon"></i>
                                                        <div class="role-title">Giảng viên</div>
                                                        <p class="role-description">
                                                            Tạo và quản lý khóa học, bài giảng và bài kiểm tra
                                                        </p>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Student Role -->
                                            <div class="col-md-4">
                                                <div class="role-option role-student" data-role="STUDENT">
                                                    <input type="radio"
                                                           name="role"
                                                           value="STUDENT"
                                                           id="roleStudent"
                                                    ${user.role.name() == 'STUDENT' || empty user.role ? 'checked' : ''}>
                                                    <div class="text-center">
                                                        <i class="fas fa-user-graduate role-icon"></i>
                                                        <div class="role-title">Học viên</div>
                                                        <p class="role-description">
                                                            Đăng ký khóa học, học bài và làm bài kiểm tra
                                                        </p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Trạng thái hoạt động -->
                                    <div class="form-check form-switch">
                                        <input class="form-check-input"
                                               type="checkbox"
                                               id="active"
                                               name="active"
                                        ${user.active != false ? 'checked' : ''}>
                                        <label class="form-check-label fw-bold" for="active">
                                            <i class="fas fa-toggle-on me-2"></i>
                                            Kích hoạt tài khoản
                                        </label>
                                        <small class="form-text text-muted">
                                            Tài khoản được kích hoạt mới có thể đăng nhập hệ thống
                                        </small>
                                    </div>

                                    <!-- Ghi chú bổ sung cho admin -->
                                    <c:if test="${isEdit}">
                                        <div class="alert alert-info mt-3">
                                            <i class="fas fa-info-circle me-2"></i>
                                            <strong>Lưu ý:</strong>
                                            <ul class="mb-0 mt-2">
                                                <li>Tên đăng nhập không thể thay đổi sau khi tạo</li>
                                                <li>Để thay đổi mật khẩu, vui lòng sử dụng chức năng "Reset mật khẩu"</li>
                                                <li>Thay đổi vai trò có thể ảnh hưởng đến quyền truy cập của người dùng</li>
                                            </ul>
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Form Actions -->
                                <div class="form-actions">
                                    <div class="d-flex justify-content-between">
                                        <a href="/admin/users" class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-2"></i>
                                            Hủy bỏ
                                        </a>

                                        <div>
                                            <c:if test="${isEdit}">
                                                <button type="button"
                                                        class="btn btn-outline-warning me-2"
                                                        onclick="resetForm()">
                                                    <i class="fas fa-undo me-2"></i>
                                                    Khôi phục
                                                </button>
                                            </c:if>

                                            <button type="submit" class="btn btn-primary-custom">
                                                <i class="fas fa-save me-2"></i>
                                                ${isEdit ? 'Cập nhật' : 'Tạo mới'}
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JavaScript -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Xử lý chọn vai trò
        const roleOptions = document.querySelectorAll('.role-option');
        const roleInputs = document.querySelectorAll('input[name="role"]');

        roleOptions.forEach(option => {
            option.addEventListener('click', function() {
                // Bỏ chọn tất cả
                roleOptions.forEach(opt => opt.classList.remove('selected'));
                roleInputs.forEach(input => input.checked = false);

                // Chọn option hiện tại
                this.classList.add('selected');
                const role = this.dataset.role;
                document.getElementById('role' + role.charAt(0) + role.slice(1).toLowerCase()).checked = true;
            });
        });

        // Đặt role được chọn ban đầu
        const checkedRole = document.querySelector('input[name="role"]:checked');
        if (checkedRole) {
            const roleValue = checkedRole.value;
            document.querySelector(`.role-option[data-role="${roleValue}"]`).classList.add('selected');
        }

        // Cập nhật avatar preview khi thay đổi username
        const usernameInput = document.getElementById('username');
        const avatarPreview = document.getElementById('avatarPreview');

        usernameInput.addEventListener('input', function() {
            const firstChar = this.value.charAt(0).toUpperCase() || 'U';
            avatarPreview.textContent = firstChar;
        });

        <c:if test="${not isEdit}">
        // Password strength checker (chỉ cho form tạo mới)
        const passwordInput = document.getElementById('password');
        const passwordStrength = document.getElementById('passwordStrength');
        const strengthFill = document.getElementById('strengthFill');
        const strengthText = document.getElementById('strengthText');

        passwordInput.addEventListener('input', function() {
            const password = this.value;

            if (password.length === 0) {
                passwordStrength.style.display = 'none';
                return;
            }

            passwordStrength.style.display = 'block';

            // Tính toán độ mạnh mật khẩu
            let strength = 0;
            let strengthClass = '';
            let strengthLabel = '';

            if (password.length >= 6) strength++;
            if (password.match(/[a-z]/)) strength++;
            if (password.match(/[A-Z]/)) strength++;
            if (password.match(/[0-9]/)) strength++;
            if (password.match(/[^a-zA-Z0-9]/)) strength++;

            switch (strength) {
                case 1:
                    strengthClass = 'strength-weak';
                    strengthLabel = 'Rất yếu';
                    break;
                case 2:
                    strengthClass = 'strength-fair';
                    strengthLabel = 'Yếu';
                    break;
                case 3:
                    strengthClass = 'strength-good';
                    strengthLabel = 'Trung bình';
                    break;
                case 4:
                case 5:
                    strengthClass = 'strength-strong';
                    strengthLabel = 'Mạnh';
                    break;
                default:
                    strengthClass = 'strength-weak';
                    strengthLabel = 'Rất yếu';
            }

            strengthFill.className = 'strength-fill ' + strengthClass;
            strengthText.textContent = strengthLabel;
        });

        // Validation mật khẩu xác nhận
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const confirmPasswordError = document.getElementById('confirmPasswordError');

        function validatePasswordConfirm() {
            if (confirmPasswordInput.value === '') {
                confirmPasswordInput.classList.remove('is-invalid');
                confirmPasswordError.textContent = '';
                return true;
            }

            if (passwordInput.value !== confirmPasswordInput.value) {
                confirmPasswordInput.classList.add('is-invalid');
                confirmPasswordError.textContent = 'Mật khẩu xác nhận không khớp';
                return false;
            } else {
                confirmPasswordInput.classList.remove('is-invalid');
                confirmPasswordError.textContent = '';
                return true;
            }
        }

        confirmPasswordInput.addEventListener('input', validatePasswordConfirm);
        passwordInput.addEventListener('input', validatePasswordConfirm);
        </c:if>

        // Form validation trước khi submit
        const form = document.getElementById('userForm');
        form.addEventListener('submit', function(e) {
            let isValid = true;

            // Validate username
            const username = document.getElementById('username').value.trim();
            if (username.length < 3) {
                document.getElementById('username').classList.add('is-invalid');
                isValid = false;
            }

            // Validate email
            const email = document.getElementById('email').value.trim();
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                document.getElementById('email').classList.add('is-invalid');
                isValid = false;
            }

            <c:if test="${not isEdit}">
            // Validate password (chỉ cho form tạo mới)
            const password = document.getElementById('password').value;
            if (password.length < 6) {
                document.getElementById('password').classList.add('is-invalid');
                isValid = false;
            }

            // Validate confirm password
            if (!validatePasswordConfirm()) {
                isValid = false;
            }
            </c:if>

            // Validate role selection
            const roleSelected = document.querySelector('input[name="role"]:checked');
            if (!roleSelected) {
                alert('Vui lòng chọn vai trò cho người dùng');
                isValid = false;
            }

            if (!isValid) {
                e.preventDefault();
            } else {
                // Hiệu ứng loading
                const submitBtn = form.querySelector('button[type="submit"]');
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
                submitBtn.disabled = true;
            }
        });

        // Real-time validation
        const inputs = document.querySelectorAll('input[required]');
        inputs.forEach(input => {
            input.addEventListener('blur', function() {
                if (this.value.trim() === '') {
                    this.classList.add('is-invalid');
                } else {
                    this.classList.remove('is-invalid');
                }
            });

            input.addEventListener('input', function() {
                if (this.classList.contains('is-invalid') && this.value.trim() !== '') {
                    this.classList.remove('is-invalid');
                }
            });
        });
    });

    // Hàm reset form về trạng thái ban đầu
    function resetForm() {
        if (confirm('Bạn có chắc muốn khôi phục tất cả thay đổi về trạng thái ban đầu?')) {
            location.reload();
        }
    }
</script>

</body>
</html>