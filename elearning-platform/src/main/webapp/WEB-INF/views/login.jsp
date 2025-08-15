<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - EduLearn Platform</title>

    <!-- Meta tags cho SEO -->
    <meta name="description" content="Đăng nhập vào EduLearn Platform để truy cập hàng nghìn khóa học trực tuyến chất lượng cao">
    <meta name="keywords" content="đăng nhập, e-learning, học trực tuyến, EduLearn">

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Custom CSS -->
    <style>
        :root {
            --primary-color: #4f46e5;
            --primary-dark: #3730a3;
            --primary-light: #818cf8;
            --success-color: #059669;
            --warning-color: #d97706;
            --danger-color: #dc2626;
            --light-bg: #f8fafc;
            --card-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
        }

        .login-container {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }

        .login-card {
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            overflow: hidden;
            min-height: 600px;
        }

        .login-left {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 3rem;
            position: relative;
        }

        .login-left::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grid" width="10" height="10" patternUnits="userSpaceOnUse"><path d="M 10 0 L 0 0 0 10" fill="none" stroke="rgba(255,255,255,0.1)" stroke-width="0.5"/></pattern></defs><rect width="100" height="100" fill="url(%23grid)"/></svg>');
            opacity: 0.3;
        }

        .login-right {
            padding: 3rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .brand-logo {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }

        .brand-logo i {
            margin-right: 0.75rem;
            color: rgba(255, 255, 255, 0.9);
        }

        .brand-tagline {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 2rem;
            line-height: 1.6;
        }

        .feature-list {
            list-style: none;
            padding: 0;
        }

        .feature-item {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
            font-size: 0.95rem;
        }

        .feature-item i {
            margin-right: 0.75rem;
            color: rgba(255, 255, 255, 0.8);
            width: 20px;
        }

        .login-form-container h2 {
            color: #1f2937;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .login-subtitle {
            color: #6b7280;
            margin-bottom: 2rem;
        }

        .form-floating {
            margin-bottom: 1.5rem;
        }

        .form-floating .form-control {
            border: 2px solid #e5e7eb;
            border-radius: 0.75rem;
            padding: 1rem 0.75rem;
            height: auto;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-floating .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }

        .form-floating label {
            color: #6b7280;
            font-weight: 500;
        }

        .password-toggle {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #6b7280;
            cursor: pointer;
            z-index: 10;
        }

        .password-toggle:hover {
            color: var(--primary-color);
        }

        .form-check {
            margin-bottom: 1.5rem;
        }

        .form-check-input:checked {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-login {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            border: none;
            border-radius: 0.75rem;
            padding: 0.875rem 2rem;
            font-weight: 600;
            font-size: 1rem;
            color: white;
            width: 100%;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px -8px var(--primary-color);
        }

        .btn-login:focus {
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.3);
        }

        .btn-login .loading-spinner {
            display: none;
        }

        .btn-login.loading .btn-text {
            display: none;
        }

        .btn-login.loading .loading-spinner {
            display: inline-block;
        }

        .divider {
            text-align: center;
            margin: 2rem 0;
            position: relative;
            color: #6b7280;
        }

        .divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: #e5e7eb;
        }

        .divider span {
            background: white;
            padding: 0 1rem;
        }

        .demo-accounts {
            background: #f9fafb;
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .demo-title {
            font-weight: 600;
            color: #374151;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }

        .demo-title i {
            margin-right: 0.5rem;
            color: var(--primary-color);
        }

        .demo-account {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem;
            background: white;
            border-radius: 0.5rem;
            margin-bottom: 0.75rem;
            border: 1px solid #e5e7eb;
            transition: all 0.3s ease;
        }

        .demo-account:hover {
            border-color: var(--primary-color);
            transform: translateY(-1px);
        }

        .demo-info {
            display: flex;
            align-items: center;
        }

        .demo-role {
            display: inline-flex;
            align-items: center;
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.75rem;
            font-weight: 500;
            margin-right: 0.75rem;
        }

        .role-admin {
            background: #fef3c7;
            color: #92400e;
        }

        .role-instructor {
            background: #dbeafe;
            color: #1e40af;
        }

        .role-student {
            background: #d1fae5;
            color: #065f46;
        }

        .btn-demo {
            background: transparent;
            border: 1px solid var(--primary-color);
            color: var(--primary-color);
            border-radius: 0.5rem;
            padding: 0.375rem 0.75rem;
            font-size: 0.75rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-demo:hover {
            background: var(--primary-color);
            color: white;
        }

        .register-link {
            text-align: center;
            padding-top: 1.5rem;
            border-top: 1px solid #e5e7eb;
            margin-top: 2rem;
        }

        .register-link a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        .alert {
            border-radius: 0.75rem;
            border: none;
            margin-bottom: 1.5rem;
        }

        .alert-danger {
            background: #fef2f2;
            color: #991b1b;
        }

        .alert-success {
            background: #f0fdf4;
            color: #166534;
        }

        .alert-info {
            background: #eff6ff;
            color: #1e40af;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .login-left {
                display: none;
            }

            .login-right {
                padding: 2rem 1.5rem;
            }

            .brand-logo {
                font-size: 2rem;
            }

            .demo-accounts {
                padding: 1rem;
            }

            .demo-account {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.75rem;
            }

            .demo-info {
                width: 100%;
                justify-content: space-between;
            }

            .btn-demo {
                align-self: stretch;
                text-align: center;
            }
        }
    </style>
</head>

<body>
<div class="login-container">
    <div class="login-card">
        <div class="row g-0 h-100">
            <!-- Left Side - Branding & Features -->
            <div class="col-lg-5 login-left">
                <div class="position-relative">
                    <div class="brand-logo">
                        <i class="fas fa-graduation-cap"></i>
                        EduLearn
                    </div>
                    <p class="brand-tagline">
                        Nền tảng học trực tuyến hàng đầu Việt Nam với hàng nghìn khóa học chất lượng cao từ các chuyên gia trong ngành.
                    </p>

                    <ul class="feature-list">
                        <li class="feature-item">
                            <i class="fas fa-check-circle"></i>
                            Hơn 10,000+ khóa học đa dạng lĩnh vực
                        </li>
                        <li class="feature-item">
                            <i class="fas fa-users"></i>
                            1000+ giảng viên chuyên nghiệp
                        </li>
                        <li class="feature-item">
                            <i class="fas fa-certificate"></i>
                            Chứng chỉ hoàn thành được công nhận
                        </li>
                        <li class="feature-item">
                            <i class="fas fa-clock"></i>
                            Học mọi lúc, mọi nơi theo lịch trình riêng
                        </li>
                        <li class="feature-item">
                            <i class="fas fa-mobile-alt"></i>
                            Tương thích mọi thiết bị di động
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Right Side - Login Form -->
            <div class="col-lg-7 login-right">
                <div class="login-form-container">
                    <h2>Chào mừng trở lại!</h2>
                    <p class="login-subtitle">Đăng nhập để tiếp tục hành trình học tập của bạn</p>

                    <!-- Hiển thị thông báo lỗi nếu có -->
                    <c:if test="${param.error != null}">
                        <div class="alert alert-danger" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            <c:choose>
                                <c:when test="${param.error == 'invalid_credentials'}">
                                    Tên đăng nhập hoặc mật khẩu không chính xác!
                                </c:when>
                                <c:when test="${param.error == 'account_disabled'}">
                                    Tài khoản của bạn đã bị vô hiệu hóa. Vui lòng liên hệ quản trị viên.
                                </c:when>
                                <c:when test="${param.error == 'account_locked'}">
                                    Tài khoản của bạn đã bị khóa do đăng nhập sai quá nhiều lần.
                                </c:when>
                                <c:when test="${param.error == 'session_expired'}">
                                    Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.
                                </c:when>
                                <c:otherwise>
                                    Có lỗi xảy ra trong quá trình đăng nhập. Vui lòng thử lại.
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <!-- Hiển thị thông báo thành công -->
                    <c:if test="${param.logout != null}">
                        <div class="alert alert-success" role="alert">
                            <i class="fas fa-check-circle me-2"></i>
                            Bạn đã đăng xuất thành công!
                        </div>
                    </c:if>

                    <c:if test="${param.registered != null}">
                        <div class="alert alert-success" role="alert">
                            <i class="fas fa-check-circle me-2"></i>
                            Đăng ký tài khoản thành công! Vui lòng đăng nhập.
                        </div>
                    </c:if>

                    <!-- Tài khoản demo -->
                    <div class="demo-accounts">
                        <div class="demo-title">
                            <i class="fas fa-info-circle"></i>
                            Tài khoản demo để trải nghiệm
                        </div>

                        <div class="demo-account">
                            <div class="demo-info">
                                <span class="demo-role role-admin">Admin</span>
                                <span><strong>admin</strong> / admin123</span>
                            </div>
                            <button type="button" class="btn-demo" onclick="fillDemoAccount('admin', 'admin123')">
                                Sử dụng
                            </button>
                        </div>

                        <div class="demo-account">
                            <div class="demo-info">
                                <span class="demo-role role-instructor">Giảng viên</span>
                                <span><strong>instructor1</strong> / instructor123</span>
                            </div>
                            <button type="button" class="btn-demo" onclick="fillDemoAccount('instructor1', 'instructor123')">
                                Sử dụng
                            </button>
                        </div>

                        <div class="demo-account">
                            <div class="demo-info">
                                <span class="demo-role role-student">Học viên</span>
                                <span><strong>student1</strong> / student123</span>
                            </div>
                            <button type="button" class="btn-demo" onclick="fillDemoAccount('student1', 'student123')">
                                Sử dụng
                            </button>
                        </div>
                    </div>

                    <!-- Form đăng nhập -->
                    <form method="POST"${pageContext.request.contextPath}/login" id="loginForm" novalidate>
                    <!-- CSRF Token -->
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <!-- Tên đăng nhập -->
                    <div class="form-floating">
                        <input type="text"
                               class="form-control"
                               id="username"
                               name="username"
                               placeholder="Tên đăng nhập"
                               required
                               autocomplete="username">
                        <label for="username">
                            <i class="fas fa-user me-2"></i>Tên đăng nhập hoặc Email
                        </label>
                        <div class="invalid-feedback">
                            Vui lòng nhập tên đăng nhập hoặc email
                        </div>
                    </div>

                    <!-- Mật khẩu -->
                    <div class="form-floating position-relative">
                        <input type="password"
                               class="form-control"
                               id="password"
                               name="password"
                               placeholder="Mật khẩu"
                               required
                               autocomplete="current-password">
                        <label for="password">
                            <i class="fas fa-lock me-2"></i>Mật khẩu
                        </label>
                        <button type="button" class="password-toggle" onclick="togglePassword()">
                            <i class="fas fa-eye" id="passwordToggleIcon"></i>
                        </button>
                        <div class="invalid-feedback">
                            Vui lòng nhập mật khẩu
                        </div>
                    </div>

                    <!-- Remember me và Forgot password -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div class="form-check">
                            <input type="checkbox" class="form-check-input" id="remember-me" name="remember-me">
                            <label class="form-check-label" for="remember-me">
                                Ghi nhớ đăng nhập
                            </label>
                        </div>
                        <a href="${pageContext.request.contextPath}/forgot-password" class="text-decoration-none">
                            Quên mật khẩu?
                        </a>
                    </div>

                    <!-- Submit button -->
                    <button type="submit" class="btn-login" id="loginBtn">
                                <span class="btn-text">
                                    <i class="fas fa-sign-in-alt me-2"></i>Đăng Nhập
                                </span>
                        <span class="loading-spinner">
                                    <i class="fas fa-spinner fa-spin me-2"></i>Đang đăng nhập...
                                </span>
                    </button>
                    </form>

                    <!-- Register link -->
                    <div class="register-link">
                        Chưa có tài khoản?
                        <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
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
    // Toggle password visibility - Hiển thị/ẩn mật khẩu
    function togglePassword() {
        const passwordInput = document.getElementById('password');
        const toggleIcon = document.getElementById('passwordToggleIcon');

        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            toggleIcon.classList.remove('fa-eye');
            toggleIcon.classList.add('fa-eye-slash');
        } else {
            passwordInput.type = 'password';
            toggleIcon.classList.remove('fa-eye-slash');
            toggleIcon.classList.add('fa-eye');
        }
    }

    // Fill demo account credentials - Điền thông tin tài khoản demo
    function fillDemoAccount(username, password) {
        document.getElementById('username').value = username;
        document.getElementById('password').value = password;

        // Trigger validation
        document.getElementById('username').classList.add('is-valid');
        document.getElementById('password').classList.add('is-valid');
    }

    // Form validation - Validation form
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        const form = this;

        if (!form.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();
        } else {
            // Show loading state
            const loginBtn = document.getElementById('loginBtn');
            loginBtn.classList.add('loading');
            loginBtn.disabled = true;
        }

        form.classList.add('was-validated');
    });

    // Real-time validation - Validation theo thời gian thực
    document.getElementById('username').addEventListener('input', function() {
        validateField(this);
    });

    document.getElementById('password').addEventListener('input', function() {
        validateField(this);
    });

    function validateField(field) {
        if (field.value.trim() !== '') {
            field.classList.remove('is-invalid');
            field.classList.add('is-valid');
        } else {
            field.classList.remove('is-valid');
            field.classList.add('is-invalid');
        }
    }

    // Auto focus on first input - Tự động focus vào input đầu tiên
    window.addEventListener('load', function() {
        document.getElementById('username').focus();
    });

    // Handle enter key in form - Xử lý phím Enter trong form
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Enter') {
            const activeElement = document.activeElement;
            if (activeElement.id === 'username') {
                document.getElementById('password').focus();
                e.preventDefault();
            } else if (activeElement.id === 'password') {
                document.getElementById('loginForm').submit();
            }
        }
    });

    // Clear loading state if there's an error - Xóa trạng thái loading nếu có lỗi
    if (window.location.search.includes('error=')) {
        const loginBtn = document.getElementById('loginBtn');
        loginBtn.classList.remove('loading');
        loginBtn.disabled = false;
    }
</script>
</body>
</html>