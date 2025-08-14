<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - EduLearn Platform</title>

    <!-- Meta tags -->
    <meta name="description" content="Đăng nhập vào EduLearn Platform để tiếp tục hành trình học tập của bạn">
    <meta name="robots" content="noindex, nofollow">

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Custom CSS cho login page -->
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

        .login-container {
            max-width: 900px;
            width: 100%;
            background: var(--white);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .login-left {
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

        .login-left::before {
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

        .login-brand {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            z-index: 1;
            position: relative;
        }

        .login-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 2rem;
            z-index: 1;
            position: relative;
        }

        .feature-list {
            list-style: none;
            padding: 0;
            z-index: 1;
            position: relative;
        }

        .feature-list li {
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }

        .feature-list i {
            margin-right: 0.75rem;
            width: 20px;
            text-align: center;
        }

        .login-right {
            padding: 60px 40px;
        }

        .login-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .login-title {
            font-size: 2rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        .login-description {
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

        .btn-login {
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

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(79, 70, 229, 0.3);
        }

        .btn-login:active {
            transform: translateY(0);
        }

        .btn-login:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        .loading-spinner {
            display: none;
        }

        .btn-login.loading .loading-spinner {
            display: inline-block;
        }

        .btn-login.loading .btn-text {
            display: none;
        }

        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 1.5rem 0;
            font-size: 0.9rem;
        }

        .remember-me {
            display: flex;
            align-items: center;
        }

        .remember-me input[type="checkbox"] {
            margin-right: 0.5rem;
        }

        .forgot-password {
            color: var(--primary-color);
            text-decoration: none;
        }

        .forgot-password:hover {
            text-decoration: underline;
        }

        .divider {
            text-align: center;
            margin: 2rem 0;
            position: relative;
        }

        .divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: var(--border-color);
        }

        .divider span {
            background: white;
            padding: 0 1rem;
            color: var(--text-muted);
            font-size: 0.9rem;
        }

        .register-link {
            text-align: center;
            margin-top: 2rem;
            color: var(--text-muted);
        }

        .register-link a {
            color: var(--primary-color);
            font-weight: 600;
            text-decoration: none;
        }

        .register-link a:hover {
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

        .alert-info {
            background-color: #eff6ff;
            color: var(--primary-color);
            border-left: 4px solid var(--primary-color);
        }

        .demo-accounts {
            background: #f8fafc;
            border-radius: 10px;
            padding: 1rem;
            margin-top: 1.5rem;
        }

        .demo-accounts h6 {
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 0.75rem;
            color: var(--text-dark);
        }

        .demo-account {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5rem;
            font-size: 0.85rem;
        }

        .demo-account:last-child {
            margin-bottom: 0;
        }

        .demo-role {
            font-weight: 500;
            color: var(--text-dark);
        }

        .demo-credentials {
            color: var(--text-muted);
            font-family: monospace;
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .login-container {
                margin: 10px;
                border-radius: 15px;
            }

            .login-left {
                display: none;
            }

            .login-right {
                padding: 40px 30px;
            }

            .login-title {
                font-size: 1.75rem;
            }

            .form-options {
                flex-direction: column;
                gap: 1rem;
                align-items: flex-start;
            }
        }

        @media (max-width: 480px) {
            body {
                padding: 10px;
            }

            .login-right {
                padding: 30px 20px;
            }
        }
    </style>
</head>

<body>
<div class="login-container">
    <div class="row g-0 h-100">
        <!-- Left Panel - Brand Info -->
        <div class="col-lg-5 d-none d-lg-block">
            <div class="login-left h-100">
                <div>
                    <div class="login-brand">
                        <i class="fas fa-graduation-cap me-2"></i>
                        EduLearn
                    </div>
                    <p class="login-subtitle">
                        Nền tảng học trực tuyến hàng đầu Việt Nam
                    </p>

                    <ul class="feature-list">
                        <li>
                            <i class="fas fa-check-circle"></i>
                            <span>Hơn 1000+ khóa học chất lượng cao</span>
                        </li>
                        <li>
                            <i class="fas fa-check-circle"></i>
                            <span>Giảng viên chuyên nghiệp</span>
                        </li>
                        <li>
                            <i class="fas fa-check-circle"></i>
                            <span>Chứng chỉ được công nhận</span>
                        </li>
                        <li>
                            <i class="fas fa-check-circle"></i>
                            <span>Học mọi lúc, mọi nơi</span>
                        </li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Right Panel - Login Form -->
        <div class="col-lg-7">
            <div class="login-right">
                <div class="login-header">
                    <h1 class="login-title">Chào mừng trở lại!</h1>
                    <p class="login-description">Đăng nhập để tiếp tục hành trình học tập của bạn</p>
                </div>

                <!-- Error/Success Messages -->
                <c:if test="${param.error != null}">
                    <div class="alert alert-danger" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <c:choose>
                            <c:when test="${param.error == 'bad-credentials'}">
                                Tên đăng nhập hoặc mật khẩu không chính xác!
                            </c:when>
                            <c:when test="${param.error == 'account-locked'}">
                                Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên.
                            </c:when>
                            <c:when test="${param.error == 'account-disabled'}">
                                Tài khoản của bạn đã bị vô hiệu hóa.
                            </c:when>
                            <c:when test="${param.error == 'session-expired'}">
                                Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.
                            </c:when>
                            <c:otherwise>
                                Đăng nhập thất bại. Vui lòng thử lại!
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>

                <c:if test="${param.logout != null}">
                    <div class="alert alert-success" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        Bạn đã đăng xuất thành công!
                    </div>
                </c:if>

                <c:if test="${param.registered != null}">
                    <div class="alert alert-success" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        Đăng ký thành công! Vui lòng đăng nhập để tiếp tục.
                    </div>
                </c:if>

                <c:if test="${not empty message}">
                    <div class="alert alert-info" role="alert">
                        <i class="fas fa-info-circle me-2"></i>
                            ${message}
                    </div>
                </c:if>

                <!-- Login Form -->
                <form action="<c:url value='/login' />" method="POST" id="loginForm" novalidate>
                    <!-- CSRF Token -->
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <!-- Username Field -->
                    <div class="form-group">
                        <label for="username" class="form-label">Tên đăng nhập hoặc Email</label>
                        <div class="input-group">
                            <i class="fas fa-user input-group-icon"></i>
                            <input type="text"
                                   class="form-control"
                                   id="username"
                                   name="username"
                                   placeholder="Nhập tên đăng nhập hoặc email"
                                   value="${param.username}"
                                   required
                                   autocomplete="username"
                                   autofocus>
                        </div>
                        <div class="invalid-feedback">
                            Vui lòng nhập tên đăng nhập hoặc email!
                        </div>
                    </div>

                    <!-- Password Field -->
                    <div class="form-group">
                        <label for="password" class="form-label">Mật khẩu</label>
                        <div class="input-group">
                            <i class="fas fa-lock input-group-icon"></i>
                            <input type="password"
                                   class="form-control"
                                   id="password"
                                   name="password"
                                   placeholder="Nhập mật khẩu"
                                   required
                                   autocomplete="current-password">
                            <button type="button" class="password-toggle" onclick="togglePassword()">
                                <i class="fas fa-eye" id="passwordToggleIcon"></i>
                            </button>
                        </div>
                        <div class="invalid-feedback">
                            Vui lòng nhập mật khẩu!
                        </div>
                    </div>

                    <!-- Form Options -->
                    <div class="form-options">
                        <div class="remember-me">
                            <input type="checkbox" id="remember-me" name="remember-me">
                            <label for="remember-me">Ghi nhớ đăng nhập</label>
                        </div>
                        <a href="<c:url value='/forgot-password' />" class="forgot-password">
                            Quên mật khẩu?
                        </a>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" class="btn-login" id="loginBtn">
                            <span class="btn-text">
                                <i class="fas fa-sign-in-alt me-2"></i>Đăng Nhập
                            </span>
                        <span class="loading-spinner">
                                <i class="fas fa-spinner fa-spin me-2"></i>Đang đăng nhập...
                            </span>
                    </button>
                </form>

                <!-- Register Link -->
                <div class="register-link">
                    Chưa có tài khoản?
                    <a href="<c:url value='/register' />">Đăng ký ngay</a>
                </div>

                <!-- Demo Accounts -->
                <div class="demo-accounts">
                    <h6><i class="fas fa-info-circle me-2"></i>Tài khoản demo để trải nghiệm:</h6>
                    <div class="demo-account">
                        <span class="demo-role">Admin:</span>
                        <span class="demo-credentials">admin / admin123</span>
                    </div>
                    <div class="demo-account">
                        <span class="demo-role">Giảng viên:</span>
                        <span class="demo-credentials">instructor1 / instructor123</span>
                    </div>
                    <div class="demo-account">
                        <span class="demo-role">Học viên:</span>
                        <span class="demo-credentials">student1 / student123</span>
                    </div>
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
    function togglePassword() {
        const passwordField = document.getElementById('password');
        const toggleIcon = document.getElementById('passwordToggleIcon');

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

    // Form validation and submission
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        const form = e.target;
        const username = document.getElementById('username');
        const password = document.getElementById('password');
        const loginBtn = document.getElementById('loginBtn');

        // Remove previous validation states
        form.classList.remove('was-validated');
        username.classList.remove('is-invalid');
        password.classList.remove('is-invalid');

        let isValid = true;

        // Validate username
        if (!username.value.trim()) {
            username.classList.add('is-invalid');
            isValid = false;
        }

        // Validate password
        if (!password.value.trim()) {
            password.classList.add('is-invalid');
            isValid = false;
        }

        if (!isValid) {
            e.preventDefault();
            return false;
        }

        // Show loading state
        loginBtn.classList.add('loading');
        loginBtn.disabled = true;

        // Auto-reset loading state after 10 seconds (fallback)
        setTimeout(() => {
            loginBtn.classList.remove('loading');
            loginBtn.disabled = false;
        }, 10000);
    });

    // Auto-fill demo credentials
    document.addEventListener('DOMContentLoaded', function() {
        const demoAccounts = document.querySelectorAll('.demo-account');

        demoAccounts.forEach(account => {
            account.addEventListener('click', function() {
                const credentials = this.querySelector('.demo-credentials').textContent.split(' / ');
                document.getElementById('username').value = credentials[0];
                document.getElementById('password').value = credentials[1];

                // Add visual feedback
                this.style.backgroundColor = '#e0f2fe';
                setTimeout(() => {
                    this.style.backgroundColor = '';
                }, 300);
            });

            // Add cursor pointer
            account.style.cursor = 'pointer';
            account.title = 'Click để điền tự động';
        });
    });

    // Input field animations
    document.querySelectorAll('.form-control').forEach(input => {
        input.addEventListener('focus', function() {
            this.parentElement.style.transform = 'scale(1.02)';
            this.parentElement.style.transition = 'transform 0.2s ease';
        });

        input.addEventListener('blur', function() {
            this.parentElement.style.transform = 'scale(1)';
        });
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

    // Focus management
    window.addEventListener('load', function() {
        const usernameField = document.getElementById('username');
        if (usernameField && !usernameField.value) {
            usernameField.focus();
        }
    });
</script>
</body>
</html>