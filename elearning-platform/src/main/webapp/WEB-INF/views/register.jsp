<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký - EduLearn Platform</title>

    <!-- Meta tags -->
    <meta name="description" content="Đăng ký tài khoản EduLearn để bắt đầu hành trình học tập trực tuyến">
    <meta name="robots" content="noindex, nofollow">

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Custom CSS cho register page -->
    <style>
        :root {
            --primary-color: #4f46e5;
            --primary-dark: #3730a3;
            --success-color: #059669;
            --danger-color: #dc2626;
            --warning-color: #d97706;
            --light-bg: #f8fafc;
            --white: #ffffff;
            --text-dark: #1f2937;
            --text-muted: #6b7280;
            --border-color: #e5e7eb;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .register-container {
            max-width: 1000px;
            width: 100%;
            background: var(--white);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .register-left {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 60px 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .register-left::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="white" opacity="0.1"/><circle cx="75" cy="75" r="1.5" fill="white" opacity="0.05"/><circle cx="50" cy="10" r="0.8" fill="white" opacity="0.08"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            animation: float 20s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(180deg); }
        }

        .register-brand {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            z-index: 1;
            position: relative;
        }

        .register-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 2rem;
            z-index: 1;
            position: relative;
        }

        .benefits-list {
            list-style: none;
            padding: 0;
            z-index: 1;
            position: relative;
        }

        .benefits-list li {
            margin-bottom: 1.2rem;
            display: flex;
            align-items: center;
            font-size: 1rem;
        }

        .benefits-list i {
            margin-right: 0.75rem;
            width: 24px;
            height: 24px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
        }

        .register-right {
            padding: 60px 40px;
            max-height: 100vh;
            overflow-y: auto;
        }

        .register-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .register-title {
            font-size: 2rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        .register-description {
            color: var(--text-muted);
            font-size: 1rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            font-weight: 500;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
            display: block;
        }

        .form-label .required {
            color: var(--danger-color);
        }

        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid var(--border-color);
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background-color: #fff;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }

        .form-control.is-valid {
            border-color: var(--success-color);
            padding-right: 40px;
        }

        .form-control.is-invalid {
            border-color: var(--danger-color);
            padding-right: 40px;
        }

        .input-group {
            position: relative;
        }

        .input-group .form-control {
            padding-left: 50px;
        }

        .input-group-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            z-index: 10;
        }

        .password-toggle {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--text-muted);
            cursor: pointer;
            z-index: 10;
        }

        .valid-feedback, .invalid-feedback {
            display: block;
            margin-top: 0.5rem;
            font-size: 0.875rem;
        }

        .valid-feedback {
            color: var(--success-color);
        }

        .invalid-feedback {
            color: var(--danger-color);
        }

        .password-strength {
            margin-top: 0.5rem;
        }

        .strength-bar {
            height: 4px;
            background: var(--border-color);
            border-radius: 2px;
            overflow: hidden;
            margin-bottom: 0.5rem;
        }

        .strength-fill {
            height: 100%;
            transition: all 0.3s ease;
            border-radius: 2px;
        }

        .strength-weak .strength-fill {
            width: 25%;
            background: var(--danger-color);
        }

        .strength-fair .strength-fill {
            width: 50%;
            background: var(--warning-color);
        }

        .strength-good .strength-fill {
            width: 75%;
            background: #3b82f6;
        }

        .strength-strong .strength-fill {
            width: 100%;
            background: var(--success-color);
        }

        .strength-text {
            font-size: 0.8rem;
            color: var(--text-muted);
        }

        .role-selection {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1rem;
            margin-top: 0.5rem;
        }

        .role-option {
            position: relative;
        }

        .role-option input[type="radio"] {
            display: none;
        }

        .role-card {
            padding: 1rem;
            border: 2px solid var(--border-color);
            border-radius: 10px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background: #fff;
        }

        .role-card:hover {
            border-color: var(--primary-color);
            background: rgba(79, 70, 229, 0.05);
        }

        .role-option input[type="radio"]:checked + .role-card {
            border-color: var(--primary-color);
            background: rgba(79, 70, 229, 0.1);
        }

        .role-icon {
            font-size: 1.5rem;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        .role-name {
            font-weight: 500;
            color: var(--text-dark);
            margin-bottom: 0.25rem;
        }

        .role-desc {
            font-size: 0.8rem;
            color: var(--text-muted);
        }

        .terms-checkbox {
            display: flex;
            align-items: flex-start;
            margin: 1.5rem 0;
        }

        .terms-checkbox input[type="checkbox"] {
            margin-right: 0.75rem;
            margin-top: 0.25rem;
        }

        .terms-text {
            font-size: 0.9rem;
            color: var(--text-muted);
            line-height: 1.4;
        }

        .terms-text a {
            color: var(--primary-color);
            text-decoration: none;
        }

        .terms-text a:hover {
            text-decoration: underline;
        }

        .btn-register {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .btn-register:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(79, 70, 229, 0.3);
        }

        .btn-register:active {
            transform: translateY(0);
        }

        .btn-register:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        .loading-spinner {
            display: none;
        }

        .btn-register.loading .loading-spinner {
            display: inline-block;
        }

        .btn-register.loading .btn-text {
            display: none;
        }

        .login-link {
            text-align: center;
            margin-top: 2rem;
            color: var(--text-muted);
        }

        .login-link a {
            color: var(--primary-color);
            font-weight: 600;
            text-decoration: none;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        .alert {
            padding: 12px 16px;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            border: none;
        }

        .alert-danger {
            background-color: #fef2f2;
            color: var(--danger-color);
            border-left: 4px solid var(--danger-color);
        }

        .alert-success {
            background-color: #f0fdf4;
            color: var(--success-color);
            border-left: 4px solid var(--success-color);
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .register-container {
                margin: 10px;
                border-radius: 15px;
            }

            .register-left {
                display: none;
            }

            .register-right {
                padding: 40px 30px;
            }

            .register-title {
                font-size: 1.75rem;
            }

            .role-selection {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 480px) {
            body {
                padding: 10px;
            }

            .register-right {
                padding: 30px 20px;
            }
        }
    </style>
</head>

<body>
<div class="register-container">
    <div class="row g-0 h-100">
        <!-- Left Panel - Benefits -->
        <div class="col-lg-5 d-none d-lg-block">
            <div class="register-left h-100">
                <div>
                    <div class="register-brand">
                        <i class="fas fa-graduation-cap me-2"></i>
                        EduLearn
                    </div>
                    <p class="register-subtitle">
                        Tham gia cộng đồng học tập lớn nhất Việt Nam
                    </p>

                    <ul class="benefits-list">
                        <li>
                            <i class="fas fa-book"></i>
                            <span>Truy cập miễn phí 100+ khóa học cơ bản</span>
                        </li>
                        <li>
                            <i class="fas fa-certificate"></i>
                            <span>Nhận chứng chỉ sau khi hoàn thành</span>
                        </li>
                        <li>
                            <i class="fas fa-users"></i>
                            <span>Kết nối với cộng đồng học tập</span>
                        </li>
                        <li>
                            <i class="fas fa-mobile-alt"></i>
                            <span>Học mọi lúc mọi nơi trên mọi thiết bị</span>
                        </li>
                        <li>
                            <i class="fas fa-headset"></i>
                            <span>Hỗ trợ 24/7 từ đội ngũ chuyên nghiệp</span>
                        </li>
                        <li>
                            <i class="fas fa-star"></i>
                            <span>Cập nhật kiến thức mới liên tục</span>
                        </li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Right Panel - Register Form -->
        <div class="col-lg-7">
            <div class="register-right">
                <div class="register-header">
                    <h1 class="register-title">Tạo tài khoản mới</h1>
                    <p class="register-description">Bắt đầu hành trình học tập của bạn ngay hôm nay</p>
                </div>

                <!-- Error/Success Messages -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                            ${error}
                    </div>
                </c:if>

                <c:if test="${not empty message}">
                    <div class="alert alert-success" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                            ${message}
                    </div>
                </c:if>

                <!-- Register Form -->
                <form action="<c:url value='/register' />" method="POST" id="registerForm" novalidate>
                    <!-- CSRF Token -->
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <!-- Full Name -->
                    <div class="form-group">
                        <label for="fullName" class="form-label">
                            Họ và tên <span class="required">*</span>
                        </label>
                        <div class="input-group">
                            <i class="fas fa-user input-group-icon"></i>
                            <input type="text"
                                   class="form-control"
                                   id="fullName"
                                   name="fullName"
                                   placeholder="Nhập họ và tên đầy đủ"
                                   value="${param.fullName}"
                                   required
                                   autocomplete="name">
                        </div>
                        <div class="invalid-feedback">
                            Vui lòng nhập họ và tên đầy đủ!
                        </div>
                    </div>

                    <!-- Username -->
                    <div class="form-group">
                        <label for="username" class="form-label">
                            Tên đăng nhập <span class="required">*</span>
                        </label>
                        <div class="input-group">
                            <i class="fas fa-at input-group-icon"></i>
                            <input type="text"
                                   class="form-control"
                                   id="username"
                                   name="username"
                                   placeholder="Chọn tên đăng nhập (3-20 ký tự)"
                                   value="${param.username}"
                                   required
                                   autocomplete="username">
                        </div>
                        <div class="invalid-feedback">
                            Tên đăng nhập phải từ 3-20 ký tự, chỉ chứa chữ, số và dấu gạch dưới!
                        </div>
                        <div class="valid-feedback">
                            Tên đăng nhập hợp lệ!
                        </div>
                    </div>

                    <!-- Email -->
                    <div class="form-group">
                        <label for="email" class="form-label">
                            Email <span class="required">*</span>
                        </label>
                        <div class="input-group">
                            <i class="fas fa-envelope input-group-icon"></i>
                            <input type="email"
                                   class="form-control"
                                   id="email"
                                   name="email"
                                   placeholder="Nhập địa chỉ email"
                                   value="${param.email}"
                                   required
                                   autocomplete="email">
                        </div>
                        <div class="invalid-feedback">
                            Vui lòng nhập địa chỉ email hợp lệ!
                        </div>
                        <div class="valid-feedback">
                            Email hợp lệ!
                        </div>
                    </div>

                    <!-- Phone -->
                    <div class="form-group">
                        <label for="phone" class="form-label">Số điện thoại</label>
                        <div class="input-group">
                            <i class="fas fa-phone input-group-icon"></i>
                            <input type="tel"
                                   class="form-control"
                                   id="phone"
                                   name="phone"
                                   placeholder="Nhập số điện thoại (tùy chọn)"
                                   value="${param.phone}"
                                   autocomplete="tel">
                        </div>
                        <div class="invalid-feedback">
                            Số điện thoại không hợp lệ!
                        </div>
                    </div>

                    <!-- Password -->
                    <div class="form-group">
                        <label for="password" class="form-label">
                            Mật khẩu <span class="required">*</span>
                        </label>
                        <div class="input-group">
                            <i class="fas fa-lock input-group-icon"></i>
                            <input type="password"
                                   class="form-control"
                                   id="password"
                                   name="password"
                                   placeholder="Tạo mật khẩu mạnh"
                                   required
                                   autocomplete="new-password">
                            <button type="button" class="password-toggle" onclick="togglePassword('password')">
                                <i class="fas fa-eye" id="passwordToggleIcon"></i>
                            </button>
                        </div>
                        <div class="password-strength" id="passwordStrength">
                            <div class="strength-bar">
                                <div class="strength-fill"></div>
                            </div>
                            <div class="strength-text">Mật khẩu cần ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số</div>
                        </div>
                        <div class="invalid-feedback">
                            Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số!
                        </div>
                    </div>

                    <!-- Confirm Password -->
                    <div class="form-group">
                        <label for="confirmPassword" class="form-label">
                            Xác nhận mật khẩu <span class="required">*</span>
                        </label>
                        <div class="input-group">
                            <i class="fas fa-lock input-group-icon"></i>
                            <input type="password"
                                   class="form-control"
                                   id="confirmPassword"
                                   name="confirmPassword"
                                   placeholder="Nhập lại mật khẩu"
                                   required
                                   autocomplete="new-password">
                            <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')">
                                <i class="fas fa-eye" id="confirmPasswordToggleIcon"></i>
                            </button>
                        </div>
                        <div class="invalid-feedback">
                            Mật khẩu xác nhận không khớp!
                        </div>
                        <div class="valid-feedback">
                            Mật khẩu xác nhận khớp!
                        </div>
                    </div>

                    <!-- Role Selection -->
                    <div class="form-group">
                        <label class="form-label">
                            Bạn muốn tham gia với vai trò gì? <span class="required">*</span>
                        </label>
                        <div class="role-selection">
                            <div class="role-option">
                                <input type="radio" id="roleStudent" name="role" value="STUDENT" checked>
                                <label for="roleStudent" class="role-card">
                                    <div class="role-icon">
                                        <i class="fas fa-user-graduate"></i>
                                    </div>
                                    <div class="role-name">Học viên</div>
                                    <div class="role-desc">Học tập các khóa học</div>
                                </label>
                            </div>
                            <div class="role-option">
                                <input type="radio" id="roleInstructor" name="role" value="INSTRUCTOR">
                                <label for="roleInstructor" class="role-card">
                                    <div class="role-icon">
                                        <i class="fas fa-chalkboard-teacher"></i>
                                    </div>
                                    <div class="role-name">Giảng viên</div>
                                    <div class="role-desc">Tạo và dạy khóa học</div>
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- Terms and Conditions -->
                    <div class="terms-checkbox">
                        <input type="checkbox" id="agreeTerms" name="agreeTerms" required>
                        <label for="agreeTerms" class="terms-text">
                            Tôi đồng ý với
                            <a href="#" target="_blank">Điều khoản sử dụng</a> và
                            <a href="#" target="_blank">Chính sách bảo mật</a> của EduLearn Platform
                        </label>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" class="btn-register" id="registerBtn">
                            <span class="btn-text">
                                <i class="fas fa-user-plus me-2"></i>Tạo Tài Khoản
                            </span>
                        <span class="loading-spinner">
                                <i class="fas fa-spinner fa-spin me-2"></i>Đang tạo tài khoản...
                            </span>
                    </button>
                </form>

                <!-- Login Link -->
                <div class="login-link">
                    Đã có tài khoản?
                    <a href="<c:url value='/login' />">Đăng nhập ngay</a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JavaScript -->
<script>
    // Toggle password visibility
    function togglePassword(fieldId) {
        const passwordField = document.getElementById(fieldId);
        const toggleIcon = document.getElementById(fieldId + 'ToggleIcon');

        if (passwordField.type === 'password') {
            passwordField.type = 'text';
            toggleIcon.classList.remove('fa-eye');
            toggleIcon.classList.add('fa-eye-slash');
        } else {
            passwordField.type = 'password';
            toggleIcon.classList.remove('fa-eye-slash');
            toggleIcon.classList.add('fa-eye');
        }
    }

    // Password strength checker
    function checkPasswordStrength(password) {
        const strengthIndicator = document.getElementById('passwordStrength');
        const strengthBar = strengthIndicator.querySelector('.strength-fill');
        const strengthText = strengthIndicator.querySelector('.strength-text');

        let score = 0;
        let feedback = '';

        // Length check
        if (password.length >= 8) score++;
        else feedback = 'Mật khẩu cần ít nhất 8 ký tự';

        // Uppercase check
        if (/[A-Z]/.test(password)) score++;
        else if (feedback === '') feedback = 'Thêm chữ hoa để mạnh hơn';

        // Lowercase check
        if (/[a-z]/.test(password)) score++;
        else if (feedback === '') feedback = 'Thêm chữ thường để mạnh hơn';

        // Number check
        if (/\d/.test(password)) score++;
        else if (feedback === '') feedback = 'Thêm số để mạnh hơn';

        // Special character check
        if (/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) score++;

        // Update strength indicator
        strengthIndicator.className = 'password-strength';

        if (score === 0) {
            strengthIndicator.classList.add('strength-weak');
            strengthText.textContent = 'Mật khẩu rất yếu';
        } else if (score <= 2) {
            strengthIndicator.classList.add('strength-weak');
            strengthText.textContent = feedback || 'Mật khẩu yếu';
        } else if (score === 3) {
            strengthIndicator.classList.add('strength-fair');
            strengthText.textContent = 'Mật khẩu khá mạnh';
        } else if (score === 4) {
            strengthIndicator.classList.add('strength-good');
            strengthText.textContent = 'Mật khẩu mạnh';
        } else {
            strengthIndicator.classList.add('strength-strong');
            strengthText.textContent = 'Mật khẩu rất mạnh';
        }

        return score >= 3;
    }

    // Real-time validation
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('registerForm');
        const username = document.getElementById('username');
        const email = document.getElementById('email');
        const phone = document.getElementById('phone');
        const password = document.getElementById('password');
        const confirmPassword = document.getElementById('confirmPassword');
        const fullName = document.getElementById('fullName');

        // Username validation
        username.addEventListener('input', function() {
            const value = this.value.trim();
            const isValid = /^[a-zA-Z0-9_]{3,20}$/.test(value);

            this.classList.remove('is-valid', 'is-invalid');
            if (value) {
                this.classList.add(isValid ? 'is-valid' : 'is-invalid');
            }
        });

        // Email validation
        email.addEventListener('input', function() {
            const value = this.value.trim();
            const isValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);

            this.classList.remove('is-valid', 'is-invalid');
            if (value) {
                this.classList.add(isValid ? 'is-valid' : 'is-invalid');
            }
        });

        // Phone validation (optional)
        phone.addEventListener('input', function() {
            const value = this.value.trim();
            if (value) {
                const isValid = /^[0-9+\-\s()]{10,15}$/.test(value);
                this.classList.remove('is-valid', 'is-invalid');
                this.classList.add(isValid ? 'is-valid' : 'is-invalid');
            } else {
                this.classList.remove('is-valid', 'is-invalid');
            }
        });

        // Password validation
        password.addEventListener('input', function() {
            const isValid = checkPasswordStrength(this.value);
            this.classList.remove('is-valid', 'is-invalid');
            if (this.value) {
                this.classList.add(isValid ? 'is-valid' : 'is-invalid');
            }

            // Re-validate confirm password
            if (confirmPassword.value) {
                validateConfirmPassword();
            }
        });

        // Confirm password validation
        function validateConfirmPassword() {
            const isValid = confirmPassword.value === password.value && confirmPassword.value.length > 0;
            confirmPassword.classList.remove('is-valid', 'is-invalid');
            if (confirmPassword.value) {
                confirmPassword.classList.add(isValid ? 'is-valid' : 'is-invalid');
            }
            return isValid;
        }

        confirmPassword.addEventListener('input', validateConfirmPassword);

        // Full name validation
        fullName.addEventListener('input', function() {
            const value = this.value.trim();
            const isValid = value.length >= 2 && /^[a-zA-ZÀ-ỹ\s]+$/.test(value);

            this.classList.remove('is-valid', 'is-invalid');
            if (value) {
                this.classList.add(isValid ? 'is-valid' : 'is-invalid');
            }
        });
    });

    // Form submission
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        const form = e.target;
        const registerBtn = document.getElementById('registerBtn');
        const agreeTerms = document.getElementById('agreeTerms');

        // Validate all required fields
        let isValid = true;
        const requiredFields = form.querySelectorAll('[required]');

        requiredFields.forEach(field => {
            if (!field.value.trim()) {
                field.classList.add('is-invalid');
                isValid = false;
            } else if (field.type === 'email') {
                const emailValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(field.value);
                if (!emailValid) {
                    field.classList.add('is-invalid');
                    isValid = false;
                }
            } else if (field.name === 'password') {
                if (!checkPasswordStrength(field.value)) {
                    field.classList.add('is-invalid');
                    isValid = false;
                }
            } else if (field.name === 'confirmPassword') {
                if (field.value !== document.getElementById('password').value) {
                    field.classList.add('is-invalid');
                    isValid = false;
                }
            }
        });

        // Check terms agreement
        if (!agreeTerms.checked) {
            alert('Vui lòng đồng ý với điều khoản sử dụng và chính sách bảo mật!');
            isValid = false;
        }

        if (!isValid) {
            e.preventDefault();
            return false;
        }

        // Show loading state
        registerBtn.classList.add('loading');
        registerBtn.disabled = true;

        // Auto-reset loading state after 10 seconds (fallback)
        setTimeout(() => {
            registerBtn.classList.remove('loading');
            registerBtn.disabled = false;
        }, 10000);
    });

    // Auto-hide alerts after 5 seconds
    document.querySelectorAll('.alert').forEach(alert => {
        setTimeout(() => {
            alert.style.animation = 'fadeOut 0.5s ease';
            setTimeout(() => {
                alert.remove();
            }, 500);
        }, 5000);
    });

    // Add fadeOut animation
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