<%--
===============================
TRANG ĐĂNG KÝ
===============================
File: /WEB-INF/views/register.jsp
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - E-Learning Platform</title>

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
                <h1 class="display-4 fw-bold mb-4">Tham gia cùng chúng tôi</h1>
                <p class="lead mb-4">
                    Bắt đầu hành trình học tập của bạn ngay hôm nay
                </p>
                <div class="stats-row">
                    <div class="stat-item">
                        <h3 class="fw-bold">10,000+</h3>
                        <p>Học viên</p>
                    </div>
                    <div class="stat-item">
                        <h3 class="fw-bold">500+</h3>
                        <p>Khóa học</p>
                    </div>
                    <div class="stat-item">
                        <h3 class="fw-bold">50+</h3>
                        <p>Giảng viên</p>
                    </div>
                </div>
            </div>
        </div>

        <%-- Right Side - Register Form --%>
        <div class="col-lg-6 d-flex align-items-center justify-content-center">
            <div class="auth-form-container">
                <div class="auth-form">
                    <%-- Header --%>
                    <div class="text-center mb-4">
                        <img src="/images/logo.png" alt="Logo" width="60" height="60" class="mb-3 d-lg-none">
                        <h2 class="fw-bold text-dark">Đăng ký tài khoản</h2>
                        <p class="text-muted">Tạo tài khoản để bắt đầu học tập</p>
                    </div>

                    <%-- Alert Messages --%>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                                ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>
                                ${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <%-- Register Form --%>
                    <form:form action="/register" method="post" modelAttribute="userDto"
                               id="registerForm" novalidate="true">

                        <%-- Full Name Field --%>
                        <div class="mb-3">
                            <label for="fullName" class="form-label">
                                <i class="fas fa-user me-2"></i>Họ và tên *
                            </label>
                            <form:input path="fullName" class="form-control form-control-lg"
                                        id="fullName" required="true" autocomplete="name"
                                        placeholder="Nhập họ và tên của bạn" />
                            <form:errors path="fullName" cssClass="invalid-feedback d-block" />
                        </div>

                        <div class="row">
                                <%-- Username Field --%>
                            <div class="col-md-6 mb-3">
                                <label for="username" class="form-label">
                                    <i class="fas fa-at me-2"></i>Tên đăng nhập *
                                </label>
                                <form:input path="username" class="form-control form-control-lg"
                                            id="username" required="true" autocomplete="username"
                                            placeholder="Tên đăng nhập" />
                                <div class="form-text">3-20 ký tự, chỉ chứa chữ, số và ._-</div>
                                <form:errors path="username" cssClass="invalid-feedback d-block" />
                            </div>

                                <%-- Email Field --%>
                            <div class="col-md-6 mb-3">
                                <label for="email" class="form-label">
                                    <i class="fas fa-envelope me-2"></i>Email *
                                </label>
                                <form:input path="email" type="email" class="form-control form-control-lg"
                                            id="email" required="true" autocomplete="email"
                                            placeholder="your@email.com" />
                                <form:errors path="email" cssClass="invalid-feedback d-block" />
                            </div>
                        </div>

                        <div class="row">
                                <%-- Password Field --%>
                            <div class="col-md-6 mb-3">
                                <label for="password" class="form-label">
                                    <i class="fas fa-lock me-2"></i>Mật khẩu *
                                </label>
                                <div class="input-group">
                                    <form:password path="password" class="form-control form-control-lg"
                                                   id="password" required="true" autocomplete="new-password"
                                                   placeholder="Mật khẩu" />
                                    <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <div class="form-text">Tối thiểu 6 ký tự, có ít nhất 1 số</div>
                                <form:errors path="password" cssClass="invalid-feedback d-block" />
                            </div>

                                <%-- Confirm Password Field --%>
                            <div class="col-md-6 mb-3">
                                <label for="confirmPassword" class="form-label">
                                    <i class="fas fa-lock me-2"></i>Xác nhận mật khẩu *
                                </label>
                                <div class="input-group">
                                    <form:password path="confirmPassword" class="form-control form-control-lg"
                                                   id="confirmPassword" required="true" autocomplete="new-password"
                                                   placeholder="Nhập lại mật khẩu" />
                                    <button class="btn btn-outline-secondary" type="button" id="toggleConfirmPassword">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <form:errors path="confirmPassword" cssClass="invalid-feedback d-block" />
                            </div>
                        </div>

                        <%-- Phone Number Field --%>
                        <div class="mb-3">
                            <label for="phoneNumber" class="form-label">
                                <i class="fas fa-phone me-2"></i>Số điện thoại
                            </label>
                            <form:input path="phoneNumber" class="form-control form-control-lg"
                                        id="phoneNumber" autocomplete="tel"
                                        placeholder="0901234567" />
                            <form:errors path="phoneNumber" cssClass="invalid-feedback d-block" />
                        </div>

                        <%-- Bio Field --%>
                        <div class="mb-3">
                            <label for="bio" class="form-label">
                                <i class="fas fa-info-circle me-2"></i>Giới thiệu về bản thân
                            </label>
                            <form:textarea path="bio" class="form-control" id="bio" rows="3"
                                           placeholder="Chia sẻ về bản thân, mục tiêu học tập của bạn..." />
                            <form:errors path="bio" cssClass="invalid-feedback d-block" />
                        </div>

                        <%-- Terms and Conditions --%>
                        <div class="mb-4">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="terms" required>
                                <label class="form-check-label" for="terms">
                                    Tôi đồng ý với
                                    <a href="/terms" target="_blank" class="text-decoration-none">
                                        Điều khoản sử dụng
                                    </a>
                                    và
                                    <a href="/privacy" target="_blank" class="text-decoration-none">
                                        Chính sách bảo mật
                                    </a>
                                </label>
                                <div class="invalid-feedback">
                                    Bạn phải đồng ý với điều khoản để tiếp tục
                                </div>
                            </div>
                        </div>

                        <%-- Submit Button --%>
                        <button type="submit" class="btn btn-primary btn-lg w-100 mb-3" id="registerBtn">
                            <i class="fas fa-user-plus me-2"></i>
                            <span class="btn-text">Tạo tài khoản</span>
                            <span class="spinner-border spinner-border-sm d-none" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </span>
                        </button>
                    </form:form>

                    <%-- Login Link --%>
                    <div class="text-center mt-4">
                        <p class="text-muted">
                            Đã có tài khoản?
                            <a href="/login" class="text-decoration-none fw-medium">
                                Đăng nhập ngay
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
    function setupPasswordToggle(passwordId, toggleId) {
        document.getElementById(toggleId).addEventListener('click', function() {
            const password = document.getElementById(passwordId);
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
    }

    setupPasswordToggle('password', 'togglePassword');
    setupPasswordToggle('confirmPassword', 'toggleConfirmPassword');

    // Form validation
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        const form = this;
        const btn = document.getElementById('registerBtn');
        const btnText = btn.querySelector('.btn-text');
        const spinner = btn.querySelector('.spinner-border');

        // Validate passwords match
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        if (password !== confirmPassword) {
            e.preventDefault();
            document.getElementById('confirmPassword').classList.add('is-invalid');
            return;
        }

        // Check terms
        const terms = document.getElementById('terms');
        if (!terms.checked) {
            e.preventDefault();
            terms.classList.add('is-invalid');
            return;
        }

        // Show loading state
        btn.disabled = true;
        btnText.textContent = 'Đang tạo tài khoản...';
        spinner.classList.remove('d-none');
    });

    // Real-time password confirmation validation
    document.getElementById('confirmPassword').addEventListener('input', function() {
        const password = document.getElementById('password').value;
        const confirmPassword = this.value;

        if (confirmPassword && password !== confirmPassword) {
            this.classList.add('is-invalid');
        } else {
            this.classList.remove('is-invalid');
        }
    });
</script>
</body>
</html>