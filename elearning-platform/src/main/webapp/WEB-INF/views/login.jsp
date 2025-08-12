<%--
===============================
TRANG ĐĂNG NHẬP
===============================
File: /WEB-INF/views/login.jsp
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - E-Learning Platform</title>

    <%-- Bootstrap CSS --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <%-- Font Awesome --%>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <%-- Google Fonts --%>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <%-- Custom CSS --%>
    <link href="/css/auth.css" rel="stylesheet">
</head>

<body class="auth-body">
<%-- Background Animation --%>
<div class="auth-background">
    <div class="floating-shapes">
        <div class="shape shape-1"></div>
        <div class="shape shape-2"></div>
        <div class="shape shape-3"></div>
        <div class="shape shape-4"></div>
    </div>
</div>

<div class="container-fluid h-100">
    <div class="row h-100">
        <%-- Left Side - Branding --%>
        <div class="col-lg-6 d-none d-lg-flex flex-column justify-content-center auth-branding">
            <div class="text-center text-white">
                <div class="brand-logo mb-4">
                    <img src="/images/logo-white.png" alt="Logo" width="80" height="80">
                </div>
                <h1 class="display-4 fw-bold mb-4">E-Learning Platform</h1>
                <p class="lead mb-4">
                    Nền tảng học tập trực tuyến hàng đầu Việt Nam
                </p>
                <div class="features-list">
                    <div class="feature-item mb-3">
                        <i class="fas fa-graduation-cap me-3"></i>
                        Hơn 1000+ khóa học chất lượng cao
                    </div>
                    <div class="feature-item mb-3">
                        <i class="fas fa-users me-3"></i>
                        Cộng đồng học viên năng động
                    </div>
                    <div class="feature-item mb-3">
                        <i class="fas fa-certificate me-3"></i>
                        Chứng chỉ được công nhận
                    </div>
                    <div class="feature-item">
                        <i class="fas fa-clock me-3"></i>
                        Học mọi lúc, mọi nơi
                    </div>
                </div>
            </div>
        </div>

        <%-- Right Side - Login Form --%>
        <div class="col-lg-6 d-flex align-items-center justify-content-center">
            <div class="auth-form-container">
                <div class="auth-form">
                    <%-- Header --%>
                    <div class="text-center mb-4">
                        <img src="/images/logo.png" alt="Logo" width="60" height="60" class="mb-3 d-lg-none">
                        <h2 class="fw-bold text-dark">Đăng nhập</h2>
                        <p class="text-muted">Chào mừng bạn trở lại!</p>
                    </div>

                    <%-- Alert Messages --%>
                    <c:if test="${param.error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Tên đăng nhập hoặc mật khẩu không đúng!
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${param.logout}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>
                            Bạn đã đăng xuất thành công!
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${param.expired}">
                        <div class="alert alert-warning alert-dismissible fade show" role="alert">
                            <i class="fas fa-clock me-2"></i>
                            Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại!
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <%-- Login Form --%>
                    <form action="/perform_login" method="post" id="loginForm">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                        <%-- Username Field --%>
                        <div class="mb-3">
                            <label for="username" class="form-label">
                                <i class="fas fa-user me-2"></i>Tên đăng nhập
                            </label>
                            <input type="text" class="form-control form-control-lg" id="username"
                                   name="username" required autocomplete="username"
                                   placeholder="Nhập tên đăng nhập của bạn">
                            <div class="invalid-feedback">
                                Vui lòng nhập tên đăng nhập
                            </div>
                        </div>

                        <%-- Password Field --%>
                        <div class="mb-3">
                            <label for="password" class="form-label">
                                <i class="fas fa-lock me-2"></i>Mật khẩu
                            </label>
                            <div class="input-group">
                                <input type="password" class="form-control form-control-lg" id="password"
                                       name="password" required autocomplete="current-password"
                                       placeholder="Nhập mật khẩu của bạn">
                                <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                            <div class="invalid-feedback">
                                Vui lòng nhập mật khẩu
                            </div>
                        </div>

                        <%-- Remember Me & Forgot Password --%>
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="remember-me" name="remember-me">
                                <label class="form-check-label" for="remember-me">
                                    Ghi nhớ đăng nhập
                                </label>
                            </div>
                            <a href="/forgot-password" class="text-decoration-none">
                                Quên mật khẩu?
                            </a>
                        </div>

                        <%-- Submit Button --%>
                        <button type="submit" class="btn btn-primary btn-lg w-100 mb-3" id="loginBtn">
                            <i class="fas fa-sign-in-alt me-2"></i>
                            <span class="btn-text">Đăng nhập</span>
                            <span class="spinner-border spinner-border-sm d-none" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </span>
                        </button>
                    </form>

                    <%-- Demo Accounts --%>
                    <div class="demo-accounts mt-4">
                        <p class="text-center text-muted small mb-3">Tài khoản demo:</p>
                        <div class="row g-2">
                            <div class="col-4">
                                <button class="btn btn-sm btn-outline-primary w-100"
                                        onclick="fillDemoAccount('admin', 'admin123')">
                                    <i class="fas fa-crown"></i><br>
                                    <small>Admin</small>
                                </button>
                            </div>
                            <div class="col-4">
                                <button class="btn btn-sm btn-outline-success w-100"
                                        onclick="fillDemoAccount('instructor1', 'instructor123')">
                                    <i class="fas fa-chalkboard-teacher"></i><br>
                                    <small>Giảng viên</small>
                                </button>
                            </div>
                            <div class="col-4">
                                <button class="btn btn-sm btn-outline-info w-100"
                                        onclick="fillDemoAccount('student1', 'student123')">
                                    <i class="fas fa-user-graduate"></i><br>
                                    <small>Học viên</small>
                                </button>
                            </div>
                        </div>
                    </div>

                    <%-- Register Link --%>
                    <div class="text-center mt-4">
                        <p class="text-muted">
                            Chưa có tài khoản?
                            <a href="/register" class="text-decoration-none fw-medium">
                                Đăng ký ngay
                            </a>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- JavaScript --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="/js/auth.js"></script>

<script>
    // Toggle password visibility
    document.getElementById('togglePassword').addEventListener('click', function() {
        const password = document.getElementById('password');
        const icon = this.querySelector('i');

        if (password.type === 'password') {
            password.type = 'text';
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        } else {
            password.type = 'password';
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
    });

    // Fill demo account
    function fillDemoAccount(username, password) {
        document.getElementById('username').value = username;
        document.getElementById('password').value = password;
    }

    // Form validation và loading state
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        const btn = document.getElementById('loginBtn');
        const btnText = btn.querySelector('.btn-text');
        const spinner = btn.querySelector('.spinner-border');

        btn.disabled = true;
        btnText.textContent = 'Đang đăng nhập...';
        spinner.classList.remove('d-none');
    });
</script>
</body>
</html>