<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${empty user.id}">Tạo người dùng mới</c:when>
            <c:otherwise>Chỉnh sửa: ${user.fullName}</c:otherwise>
        </c:choose>
        - Admin Panel
    </title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        /* CSS cho user form page */
        .admin-wrapper {
            display: flex;
            min-height: 100vh;
            background-color: #f8f9fa;
        }

        .admin-sidebar {
            width: 280px;
            background: linear-gradient(180deg, #4f46e5 0%, #7c3aed 100%);
            color: white;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            transition: transform 0.3s ease;
            z-index: 1000;
        }

        .admin-content {
            flex: 1;
            margin-left: 280px;
            padding: 0;
        }

        .admin-header {
            background: white;
            padding: 1rem 2rem;
            border-bottom: 1px solid #e5e7eb;
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

        .sidebar-header {
            padding: 1.5rem 1rem;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .menu-section {
            padding: 1rem 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .menu-title {
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            color: rgba(255,255,255,0.7);
            padding: 0 1rem;
            margin-bottom: 0.5rem;
        }

        .menu-item {
            display: flex;
            align-items: center;
            padding: 0.75rem 1rem;
            color: rgba(255,255,255,0.8);
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .menu-item:hover,
        .menu-item.active {
            background-color: rgba(255,255,255,0.1);
            color: white;
            text-decoration: none;
        }

        .menu-item i {
            width: 20px;
            margin-right: 0.75rem;
        }

        .page-content {
            padding: 2rem;
        }

        .form-container {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid #e5e7eb;
            overflow: hidden;
        }

        .form-header {
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
            color: white;
            padding: 2rem;
            text-align: center;
        }

        .form-header h2 {
            margin: 0;
            font-weight: 600;
            font-size: 1.75rem;
        }

        .form-body {
            padding: 2rem;
        }

        .form-section {
            margin-bottom: 2rem;
            padding-bottom: 2rem;
            border-bottom: 1px solid #e5e7eb;
        }

        .form-section:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }

        .section-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 0.5rem;
            color: #4f46e5;
        }

        .user-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 4px solid #e5e7eb;
            margin: 0 auto 1rem auto;
            display: block;
            object-fit: cover;
        }

        .role-selector {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1rem;
            margin-top: 0.5rem;
        }

        .role-option {
            padding: 1rem;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s ease;
            background: white;
        }

        .role-option:hover {
            border-color: #4f46e5;
            background-color: #f8faff;
        }

        .role-option.selected {
            border-color: #4f46e5;
            background-color: #4f46e5;
            color: white;
        }

        .role-option i {
            font-size: 2rem;
            margin-bottom: 0.5rem;
            display: block;
        }

        .role-option h6 {
            margin: 0;
            font-weight: 600;
        }

        .role-option p {
            margin: 0;
            font-size: 0.875rem;
            opacity: 0.8;
        }

        .status-toggle {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .breadcrumb-nav {
            background: transparent;
            padding: 0;
            margin-bottom: 2rem;
        }

        .breadcrumb {
            background: white;
            padding: 1rem 1.5rem;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .breadcrumb-item + .breadcrumb-item::before {
            content: "›";
            color: #6b7280;
        }

        .form-actions {
            background: #f8f9fa;
            padding: 1.5rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

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

            .role-selector {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>
<div class="admin-wrapper">
    <!-- Sidebar Navigation -->
    <aside class="admin-sidebar">
        <div class="sidebar-header">
            <h4 class="mb-0">
                <i class="fas fa-graduation-cap me-2"></i>
                E-Learning Admin
            </h4>
        </div>

        <!-- Navigation Menu -->
        <nav class="sidebar-nav">
            <!-- Tổng quan -->
            <div class="menu-section">
                <div class="menu-title">Tổng quan</div>
                <a href="/admin/dashboard" class="menu-item">
                    <i class="fas fa-tachometer-alt"></i>Dashboard
                </a>
                <a href="/admin/analytics" class="menu-item">
                    <i class="fas fa-chart-line"></i>Thống kê & Báo cáo
                </a>
            </div>

            <!-- Quản lý người dùng -->
            <div class="menu-section">
                <div class="menu-title">Quản lý người dùng</div>
                <a href="/admin/users" class="menu-item active">
                    <i class="fas fa-users"></i>Tất cả người dùng
                </a>
                <a href="/admin/users?role=INSTRUCTOR" class="menu-item">
                    <i class="fas fa-chalkboard-teacher"></i>Giảng viên
                </a>
                <a href="/admin/users?role=STUDENT" class="menu-item">
                    <i class="fas fa-user-graduate"></i>Học viên
                </a>
            </div>

            <!-- Quản lý khóa học -->
            <div class="menu-section">
                <div class="menu-title">Quản lý khóa học</div>
                <a href="/admin/courses" class="menu-item">
                    <i class="fas fa-book"></i>Tất cả khóa học
                </a>
                <a href="/admin/categories" class="menu-item">
                    <i class="fas fa-tags"></i>Danh mục
                </a>
                <a href="/admin/courses?status=pending" class="menu-item">
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
                <h1 class="header-title">
                    <c:choose>
                        <c:when test="${empty user.id}">Tạo người dùng mới</c:when>
                        <c:otherwise>Chỉnh sửa người dùng</c:otherwise>
                    </c:choose>
                </h1>
            </div>

            <div class="d-flex align-items-center gap-2">
                <div class="dropdown">
                    <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user me-1"></i>Admin
                    </button>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="/logout">
                            <i class="fas fa-sign-out-alt me-1"></i>Đăng xuất
                        </a></li>
                    </ul>
                </div>
            </div>
        </header>

        <!-- Page Content -->
        <div class="page-content">
            <!-- Breadcrumb -->
            <nav class="breadcrumb-nav">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="/admin/dashboard">
                            <i class="fas fa-home me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="/admin/users">Người dùng</a>
                    </li>
                    <li class="breadcrumb-item active">
                        <c:choose>
                            <c:when test="${empty user.id}">Tạo mới</c:when>
                            <c:otherwise>Chỉnh sửa</c:otherwise>
                        </c:choose>
                    </li>
                </ol>
            </nav>

            <!-- Alert Messages -->
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

            <!-- Form Container -->
            <div class="form-container">
                <!-- Form Header -->
                <div class="form-header">
                    <h2>
                        <c:choose>
                            <c:when test="${empty user.id}">
                                <i class="fas fa-user-plus me-2"></i>Tạo người dùng mới
                            </c:when>
                            <c:otherwise>
                                <i class="fas fa-user-edit me-2"></i>Chỉnh sửa người dùng
                            </c:otherwise>
                        </c:choose>
                    </h2>
                    <p>
                        <c:choose>
                            <c:when test="${empty user.id}">
                                Thêm người dùng mới vào hệ thống e-learning
                            </c:when>
                            <c:otherwise>
                                Cập nhật thông tin người dùng ${user.fullName}
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>

                <!-- Form Body -->
                <form:form method="POST"
                           action="${empty user.id ? '/admin/users' : '/admin/users/'.concat(user.id)}"
                           modelAttribute="user"
                           class="form-body"
                           enctype="multipart/form-data">

                    <div class="row">
                        <div class="col-lg-4">
                            <!-- Avatar Section -->
                            <div class="form-section text-center">
                                <h3 class="section-title justify-content-center">
                                    <i class="fas fa-image"></i>Ảnh đại diện
                                </h3>

                                <img src="${not empty user.avatarUrl ? user.avatarUrl : '/images/default-avatar.png'}"
                                     alt="Avatar"
                                     class="user-avatar"
                                     id="avatarPreview">

                                <div class="mb-3">
                                    <input type="file"
                                           class="form-control"
                                           id="avatarFile"
                                           name="avatarFile"
                                           accept="image/*"
                                           onchange="previewAvatar(this)">
                                    <div class="form-text">Chọn ảnh JPG, PNG (tối đa 2MB)</div>
                                </div>
                            </div>

                            <!-- Role Section -->
                            <div class="form-section">
                                <h3 class="section-title">
                                    <i class="fas fa-user-tag"></i>Vai trò
                                </h3>

                                <div class="role-selector">
                                    <div class="role-option ${user.role == 'ADMIN' ? 'selected' : ''}"
                                         onclick="selectRole('ADMIN')">
                                        <i class="fas fa-crown"></i>
                                        <h6>Admin</h6>
                                        <p>Quản trị viên</p>
                                    </div>

                                    <div class="role-option ${user.role == 'INSTRUCTOR' ? 'selected' : ''}"
                                         onclick="selectRole('INSTRUCTOR')">
                                        <i class="fas fa-chalkboard-teacher"></i>
                                        <h6>Instructor</h6>
                                        <p>Giảng viên</p>
                                    </div>

                                    <div class="role-option ${user.role == 'STUDENT' || empty user.role ? 'selected' : ''}"
                                         onclick="selectRole('STUDENT')">
                                        <i class="fas fa-user-graduate"></i>
                                        <h6>Student</h6>
                                        <p>Học viên</p>
                                    </div>
                                </div>

                                <form:hidden path="role" id="selectedRole"
                                             value="${not empty user.role ? user.role : 'STUDENT'}" />
                            </div>
                        </div>

                        <div class="col-lg-8">
                            <!-- Thông tin cơ bản -->
                            <div class="form-section">
                                <h3 class="section-title">
                                    <i class="fas fa-user"></i>Thông tin cơ bản
                                </h3>

                                <div class="row">
                                    <div class="col-md-6">
                                        <!-- Họ và tên -->
                                        <div class="mb-3">
                                            <label for="fullName" class="form-label">
                                                Họ và tên <span class="text-danger">*</span>
                                            </label>
                                            <form:input path="fullName"
                                                        class="form-control form-control-lg"
                                                        id="fullName"
                                                        placeholder="Nhập họ và tên đầy đủ..."
                                                        required="true" />
                                            <form:errors path="fullName" cssClass="text-danger small mt-1 d-block" />
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <!-- Username -->
                                        <div class="mb-3">
                                            <label for="username" class="form-label">
                                                Tên đăng nhập <span class="text-danger">*</span>
                                            </label>
                                            <form:input path="username"
                                                        class="form-control form-control-lg"
                                                        id="username"
                                                        placeholder="Nhập tên đăng nhập..."
                                                        required="true"
                                                        readonly="${not empty user.id}" />
                                            <form:errors path="username" cssClass="text-danger small mt-1 d-block" />
                                            <c:if test="${not empty user.id}">
                                                <div class="form-text">Không thể thay đổi tên đăng nhập</div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <!-- Email -->
                                        <div class="mb-3">
                                            <label for="email" class="form-label">
                                                Email <span class="text-danger">*</span>
                                            </label>
                                            <form:input path="email"
                                                        type="email"
                                                        class="form-control"
                                                        id="email"
                                                        placeholder="Nhập địa chỉ email..."
                                                        required="true" />
                                            <form:errors path="email" cssClass="text-danger small mt-1 d-block" />
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <!-- Phone -->
                                        <div class="mb-3">
                                            <label for="phone" class="form-label">Số điện thoại</label>
                                            <form:input path="phone"
                                                        class="form-control"
                                                        id="phone"
                                                        placeholder="Nhập số điện thoại..." />
                                            <form:errors path="phone" cssClass="text-danger small mt-1 d-block" />
                                        </div>
                                    </div>
                                </div>

                                <!-- Bio -->
                                <div class="mb-3">
                                    <label for="bio" class="form-label">Giới thiệu</label>
                                    <form:textarea path="bio"
                                                   class="form-control"
                                                   id="bio"
                                                   rows="3"
                                                   placeholder="Viết giới thiệu ngắn gọn về bản thân..."/>
                                    <form:errors path="bio" cssClass="text-danger small mt-1 d-block" />
                                </div>
                            </div>

                            <!-- Bảo mật -->
                            <div class="form-section">
                                <h3 class="section-title">
                                    <i class="fas fa-lock"></i>Bảo mật
                                </h3>

                                <div class="row">
                                    <div class="col-md-6">
                                        <!-- Password -->
                                        <div class="mb-3">
                                            <label for="password" class="form-label">
                                                Mật khẩu
                                                <c:if test="${empty user.id}"><span class="text-danger">*</span></c:if>
                                            </label>
                                            <div class="input-group">
                                                <form:password path="password"
                                                               class="form-control"
                                                               id="password"
                                                               placeholder="${empty user.id ? 'Nhập mật khẩu...' : 'Để trống nếu không đổi'}"
                                                               required="${empty user.id}" />
                                                <button type="button" class="btn btn-outline-secondary" onclick="togglePassword('password')">
                                                    <i class="fas fa-eye" id="passwordToggleIcon"></i>
                                                </button>
                                            </div>
                                            <form:errors path="password" cssClass="text-danger small mt-1 d-block" />
                                            <c:if test="${not empty user.id}">
                                                <div class="form-text">Để trống nếu không muốn thay đổi mật khẩu</div>
                                            </c:if>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <!-- Confirm Password -->
                                        <div class="mb-3">
                                            <label for="confirmPassword" class="form-label">
                                                Xác nhận mật khẩu
                                                <c:if test="${empty user.id}"><span class="text-danger">*</span></c:if>
                                            </label>
                                            <input type="password"
                                                   class="form-control"
                                                   id="confirmPassword"
                                                   name="confirmPassword"
                                                   placeholder="Nhập lại mật khẩu..."
                                                   required="${empty user.id}" />
                                            <div class="invalid-feedback" id="confirmPasswordError"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Trạng thái -->
                            <div class="form-section">
                                <h3 class="section-title">
                                    <i class="fas fa-toggle-on"></i>Trạng thái tài khoản
                                </h3>

                                <div class="status-toggle">
                                    <div class="form-check form-switch">
                                        <form:checkbox path="enabled"
                                                       class="form-check-input"
                                                       id="userEnabled"
                                                       checked="checked" />
                                        <label class="form-check-label" for="userEnabled">
                                            <strong>Kích hoạt tài khoản</strong>
                                        </label>
                                    </div>
                                    <div class="form-text">
                                        Tài khoản bị vô hiệu hóa sẽ không thể đăng nhập
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </form:form>

                <!-- Form Actions -->
                <div class="form-actions">
                    <div>
                        <a href="/admin/users" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-1"></i>Quay lại
                        </a>
                    </div>
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-outline-primary" onclick="resetForm()">
                            <i class="fas fa-undo me-1"></i>Đặt lại
                        </button>
                        <button type="submit" form="user" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>
                            <c:choose>
                                <c:when test="${empty user.id}">Tạo người dùng</c:when>
                                <c:otherwise>Cập nhật</c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // JavaScript cho user form

    // Toggle sidebar trên mobile
    function toggleSidebar() {
        document.querySelector('.admin-sidebar').classList.toggle('show');
    }

    // Preview avatar khi chọn file
    function previewAvatar(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('avatarPreview').src = e.target.result;
            };
            reader.readAsDataURL(input.files[0]);
        }
    }

    // Chọn role
    function selectRole(role) {
        // Cập nhật hidden input
        document.getElementById('selectedRole').value = role;

        // Cập nhật UI
        document.querySelectorAll('.role-option').forEach(option => {
            option.classList.remove('selected');
        });
        event.target.classList.add('selected');
    }

    // Toggle hiển thị mật khẩu
    function togglePassword(fieldId) {
        const field = document.getElementById(fieldId);
        const icon = document.getElementById(fieldId + 'ToggleIcon');

        if (field.type === 'password') {
            field.type = 'text';
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        } else {
            field.type = 'password';
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
    }

    // Kiểm tra mật khẩu khớp
    function validatePasswordMatch() {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const errorDiv = document.getElementById('confirmPasswordError');

        if (confirmPassword && password !== confirmPassword) {
            document.getElementById('confirmPassword').classList.add('is-invalid');
            errorDiv.textContent = 'Mật khẩu xác nhận không khớp';
            return false;
        } else {
            document.getElementById('confirmPassword').classList.remove('is-invalid');
            errorDiv.textContent = '';
            return true;
        }
    }

    // Reset form
    function resetForm() {
        if (confirm('Bạn có chắc chắn muốn đặt lại form? Tất cả thay đổi sẽ bị mất.')) {
            document.querySelector('form').reset();
            document.getElementById('avatarPreview').src = '/images/default-avatar.png';
        }
    }

    // Khởi tạo khi trang load
    document.addEventListener('DOMContentLoaded', function() {
        // Validate password match khi nhập
        document.getElementById('confirmPassword').addEventListener('keyup', validatePasswordMatch);
        document.getElementById('password').addEventListener('keyup', validatePasswordMatch);

        // Validate form trước khi submit
        document.querySelector('form').addEventListener('submit', function(e) {
            if (!validatePasswordMatch()) {
                e.preventDefault();
                return false;
            }
        });

        // Auto-hide alerts
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert:not(.alert-permanent)');
            alerts.forEach(alert => {
                alert.style.animation = 'fadeOut 0.5s ease';
                setTimeout(() => alert.remove(), 500);
            });
        }, 5000);
    });

    // Animation cho fade out
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