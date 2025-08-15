<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page isErrorPage="true" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Truy cập bị từ chối - EduLearn Platform</title>

    <!-- Meta tags -->
    <meta name="description" content="Bạn không có quyền truy cập trang này. Vui lòng đăng nhập với tài khoản có quyền phù hợp.">
    <meta name="robots" content="noindex, nofollow">

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
            --danger-color: #dc2626;
            --warning-color: #d97706;
            --light-bg: #f8fafc;
            --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            --border-color: #e5e7eb;
            --text-primary: #1f2937;
            --text-secondary: #6b7280;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, var(--light-bg) 0%, #ffffff 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            overflow-x: hidden;
        }

        .error-container {
            width: 100%;
            min-height: 100vh;
            display: flex;
            align-items: center;
            padding: 2rem 0;
        }

        .error-content {
            max-width: 900px;
            margin: 0 auto;
            text-align: center;
            position: relative;
        }

        /* 403 Number Animation */
        .error-number {
            font-size: 10rem;
            font-weight: 900;
            color: var(--danger-color);
            line-height: 1;
            margin-bottom: 1rem;
            position: relative;
            background: linear-gradient(135deg, var(--danger-color), #ef4444);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
                opacity: 1;
            }
            50% {
                transform: scale(1.05);
                opacity: 0.9;
            }
        }

        .error-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 1rem;
            line-height: 1.2;
        }

        .error-subtitle {
            font-size: 1.25rem;
            color: var(--danger-color);
            margin-bottom: 2rem;
            font-weight: 600;
        }

        .error-description {
            font-size: 1.1rem;
            color: var(--text-secondary);
            margin-bottom: 3rem;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.7;
        }

        /* Lock Illustration */
        .lock-illustration {
            width: 200px;
            height: 200px;
            margin: 0 auto 3rem;
            position: relative;
            background: linear-gradient(135deg, var(--danger-color), #ef4444);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 20px 40px -10px rgba(220, 38, 38, 0.3);
            animation: lockShake 3s ease-in-out infinite;
        }

        .lock-illustration::before {
            content: '';
            position: absolute;
            width: 120%;
            height: 120%;
            background: radial-gradient(circle, rgba(220, 38, 38, 0.1) 0%, transparent 70%);
            border-radius: 50%;
            z-index: -1;
            animation: ripple 2s ease-in-out infinite;
        }

        .lock-icon {
            font-size: 4rem;
            color: white;
            animation: lockRotate 4s ease-in-out infinite;
        }

        @keyframes lockShake {
            0%, 100% {
                transform: translateX(0);
            }
            25% {
                transform: translateX(-5px);
            }
            75% {
                transform: translateX(5px);
            }
        }

        @keyframes lockRotate {
            0%, 100% {
                transform: rotate(0deg);
            }
            50% {
                transform: rotate(10deg);
            }
        }

        @keyframes ripple {
            0% {
                transform: scale(0.8);
                opacity: 1;
            }
            100% {
                transform: scale(1.2);
                opacity: 0;
            }
        }

        /* Action Buttons */
        .error-actions {
            display: flex;
            justify-content: center;
            gap: 1rem;
            flex-wrap: wrap;
            margin-bottom: 3rem;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            border: none;
            color: white;
            padding: 0.875rem 2rem;
            font-weight: 600;
            font-size: 1rem;
            border-radius: 0.75rem;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px -5px rgba(79, 70, 229, 0.4);
            color: white;
            text-decoration: none;
        }

        .btn-danger-custom {
            background: linear-gradient(135deg, var(--danger-color), #ef4444);
            border: none;
            color: white;
            padding: 0.875rem 2rem;
            font-weight: 600;
            font-size: 1rem;
            border-radius: 0.75rem;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-danger-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px -5px rgba(220, 38, 38, 0.4);
            color: white;
            text-decoration: none;
        }

        .btn-secondary-custom {
            background: white;
            border: 2px solid var(--border-color);
            color: var(--text-primary);
            padding: 0.875rem 2rem;
            font-weight: 600;
            font-size: 1rem;
            border-radius: 0.75rem;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-secondary-custom:hover {
            border-color: var(--primary-color);
            color: var(--primary-color);
            transform: translateY(-2px);
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
            text-decoration: none;
        }

        /* Auth Status */
        .auth-status {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
            max-width: 500px;
            margin: 0 auto 2rem;
        }

        .auth-status h3 {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .auth-status h3 i {
            margin-right: 0.5rem;
            color: var(--danger-color);
        }

        .status-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem;
            background: var(--light-bg);
            border-radius: 0.5rem;
            margin-bottom: 0.75rem;
            border: 1px solid var(--border-color);
        }

        .status-label {
            font-weight: 500;
            color: var(--text-secondary);
        }

        .status-value {
            font-weight: 600;
            color: var(--text-primary);
        }

        .status-value.authenticated {
            color: var(--primary-color);
        }

        .status-value.not-authenticated {
            color: var(--danger-color);
        }

        /* Role Requirements */
        .role-requirements {
            background: #fef2f2;
            border: 1px solid #fecaca;
            border-radius: 1rem;
            padding: 1.5rem;
            margin: 2rem auto;
            max-width: 600px;
        }

        .role-requirements h4 {
            color: var(--danger-color);
            font-weight: 600;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }

        .role-requirements h4 i {
            margin-right: 0.5rem;
        }

        .required-roles {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }

        .role-badge {
            background: var(--danger-color);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.85rem;
            font-weight: 500;
        }

        /* Help Links */
        .help-links {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
            max-width: 600px;
            margin: 0 auto;
        }

        .help-links h3 {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1.5rem;
            text-align: center;
        }

        .help-item {
            display: flex;
            align-items: center;
            padding: 1rem;
            background: var(--light-bg);
            border-radius: 0.75rem;
            margin-bottom: 1rem;
            text-decoration: none;
            color: var(--text-primary);
            transition: all 0.3s ease;
            border: 1px solid var(--border-color);
        }

        .help-item:hover {
            background: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px -4px rgba(0, 0, 0, 0.1);
            color: var(--primary-color);
            text-decoration: none;
        }

        .help-icon {
            width: 40px;
            height: 40px;
            background: var(--primary-color);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            font-size: 1rem;
            flex-shrink: 0;
        }

        .help-content {
            flex: 1;
        }

        .help-title {
            font-weight: 600;
            margin-bottom: 0.25rem;
        }

        .help-description {
            color: var(--text-secondary);
            font-size: 0.9rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .error-number {
                font-size: 6rem;
            }

            .error-title {
                font-size: 2rem;
            }

            .error-subtitle {
                font-size: 1.1rem;
            }

            .error-description {
                font-size: 1rem;
                padding: 0 1rem;
            }

            .lock-illustration {
                width: 150px;
                height: 150px;
            }

            .lock-icon {
                font-size: 3rem;
            }

            .error-actions {
                flex-direction: column;
                align-items: center;
            }

            .btn-primary-custom,
            .btn-danger-custom,
            .btn-secondary-custom {
                width: 100%;
                max-width: 280px;
            }

            .auth-status,
            .role-requirements,
            .help-links {
                margin: 0 1rem 2rem;
                padding: 1.5rem;
            }
        }
    </style>
</head>

<body>
<div class="error-container">
    <div class="container">
        <div class="error-content">
            <!-- Error Number -->
            <div class="error-number">403</div>

            <!-- Lock Illustration -->
            <div class="lock-illustration">
                <i class="fas fa-lock lock-icon"></i>
            </div>

            <!-- Error Messages -->
            <h1 class="error-title">Truy cập bị từ chối</h1>
            <h2 class="error-subtitle">Bạn không có quyền truy cập trang này!</h2>
            <p class="error-description">
                Trang này yêu cầu quyền truy cập đặc biệt mà tài khoản của bạn hiện tại không có.
                Vui lòng đăng nhập với tài khoản có quyền phù hợp hoặc liên hệ quản trị viên.
            </p>

            <!-- Auth Status -->
            <div class="auth-status">
                <h3>
                    <i class="fas fa-user-shield"></i>
                    Trạng thái đăng nhập
                </h3>

                <div class="status-item">
                    <span class="status-label">Trạng thái:</span>
                    <sec:authorize access="isAuthenticated()">
                        <span class="status-value authenticated">Đã đăng nhập</span>
                    </sec:authorize>
                    <sec:authorize access="!isAuthenticated()">
                        <span class="status-value not-authenticated">Chưa đăng nhập</span>
                    </sec:authorize>
                </div>

                <sec:authorize access="isAuthenticated()">
                    <div class="status-item">
                        <span class="status-label">Tài khoản:</span>
                        <span class="status-value">
                                ${currentUser.userName}
                            </span>
                    </div>

                    <div class="status-item">
                        <span class="status-label">Vai trò hiện tại:</span>
                        <span class="status-value">
                                <sec:authorize access="hasRole('ADMIN')">Quản trị viên</sec:authorize>
                                <sec:authorize access="hasRole('INSTRUCTOR')">Giảng viên</sec:authorize>
                                <sec:authorize access="hasRole('STUDENT')">Học viên</sec:authorize>
                                <sec:authorize access="!hasAnyRole('ADMIN', 'INSTRUCTOR', 'STUDENT')">Không xác định</sec:authorize>
                            </span>
                    </div>
                </sec:authorize>
            </div>

            <!-- Role Requirements -->
            <div class="role-requirements">
                <h4>
                    <i class="fas fa-exclamation-triangle"></i>
                    Yêu cầu quyền truy cập
                </h4>
                <p>Trang này có thể yêu cầu một trong những vai trò sau:</p>
                <div class="required-roles">
                    <span class="role-badge">Quản trị viên</span>
                    <span class="role-badge">Giảng viên</span>
                    <span class="role-badge">Tài khoản đặc biệt</span>
                </div>
                <p class="mb-0">
                    <small class="text-muted">
                        Nếu bạn tin rằng đây là lỗi, vui lòng liên hệ với quản trị viên.
                    </small>
                </p>
            </div>

            <!-- Action Buttons -->
            <div class="error-actions">
                <sec:authorize access="!isAuthenticated()">
                    <a href="${pageContext.request.contextPath}/login"> class="btn-primary-custom">
                        <i class="fas fa-sign-in-alt"></i>
                        Đăng nhập
                    </a>
                </sec:authorize>

                <sec:authorize access="isAuthenticated()">
                    <!-- Logout and try different account -->
                    <form method="POST" action="logout" style="display: inline;">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" class="btn-danger-custom">
                            <i class="fas fa-sign-out-alt"></i>
                            Đăng xuất và thử tài khoản khác
                        </button>
                    </form>

                    <!-- Go to appropriate dashboard -->
                    <sec:authorize access="hasRole('ADMIN')">
                        <a href="/admin/dashboard" class="btn-primary-custom">
                            <i class="fas fa-tachometer-alt"></i>
                            Dashboard Admin
                        </a>
                    </sec:authorize>
                    <sec:authorize access="hasRole('INSTRUCTOR')">
                        <a href="${pageContext.request.contextPath}/instructor/dashboard" class="btn-primary-custom">
                            <i class="fas fa-chalkboard-teacher"></i>
                            Dashboard Giảng viên
                        </a>
                    </sec:authorize>
                    <sec:authorize access="hasRole('STUDENT')">
                        <a href="${pageContext.request.contextPath}/student/dashboard" class="btn-primary-custom">
                            <i class="fas fa-user-graduate"></i>
                            Dashboard Học viên
                        </a>
                    </sec:authorize>
                </sec:authorize>

                <a href="${pageContext.request.contextPath}/" class="btn-secondary-custom">
                    <i class="fas fa-home"></i>
                    Về trang chủ
                </a>
            </div>

            <!-- Help Links -->
            <div class="help-links">
                <h3>Cần hỗ trợ?</h3>

                <a href="${pageContext.request.contextPath}/contact"" class="help-item">
                    <div class="help-icon">
                        <i class="fas fa-envelope"></i>
                    </div>
                    <div class="help-content">
                        <div class="help-title">Liên hệ hỗ trợ</div>
                        <div class="help-description">Gửi yêu cầu hỗ trợ cho đội ngũ của chúng tôi</div>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/about"" class="help-item">
                    <div class="help-icon">
                        <i class="fas fa-info-circle"></i>
                    </div>
                    <div class="help-content">
                        <div class="help-title">Về EduLearn</div>
                        <div class="help-description">Tìm hiểu thêm về các dịch vụ và tính năng</div>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/courses"" class="help-item">
                    <div class="help-icon">
                        <i class="fas fa-book"></i>
                    </div>
                    <div class="help-content">
                        <div class="help-title">Khóa học công khai</div>
                        <div class="help-description">Xem các khóa học không yêu cầu đăng nhập</div>
                    </div>
                </a>
            </div>

            <!-- Additional Info -->
            <div class="text-center mt-4">
                <p class="text-muted">
                    <small>
                        Lỗi 403 - Truy cập bị từ chối |
                        <a href="${pageContext.request.contextPath}/contact"" class="text-primary">Báo lỗi</a> |
                        <a href="${pageContext.request.contextPath}/" class="text-primary">Trang chủ</a>
                    </small>
                </p>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JavaScript -->
<script>
    // Animation effects - Hiệu ứng animation
    document.addEventListener('DOMContentLoaded', function() {
        // Animate elements on load
        const elements = document.querySelectorAll('.error-title, .error-subtitle, .error-description, .auth-status, .role-requirements, .error-actions, .help-links');
        elements.forEach((element, index) => {
            element.style.opacity = '0';
            element.style.transform = 'translateY(30px)';
            element.style.transition = 'all 0.6s ease';

            setTimeout(() => {
                element.style.opacity = '1';
                element.style.transform = 'translateY(0)';
            }, index * 150);
        });

        // Track 403 error for analytics - Theo dõi lỗi 403 cho phân tích
        if (typeof gtag !== 'undefined') {
            gtag('event', 'access_denied', {
                'page_title': 'Error 403',
                'page_location': window.location.href,
                'custom_parameter': 'unauthorized_access'
            });
        }

        // Log error details for debugging - Ghi log chi tiết lỗi để debug
        console.info('403 Access Denied Details:', {
            timestamp: new Date().toISOString(),
            url: window.location.href,
            referrer: document.referrer,
            userAgent: navigator.userAgent,
            authenticated: document.querySelector('.status-value.authenticated') !== null
        });

        // Auto-redirect after logout for security - Tự động chuyển hướng sau logout để bảo mật
        const logoutForms = document.querySelectorAll('form[action*="logout"]');
        logoutForms.forEach(form => {
            form.addEventListener('submit', function() {
                // Show loading state
                const submitBtn = this.querySelector('button[type="submit"]');
                if (submitBtn) {
                    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang đăng xuất...';
                    submitBtn.disabled = true;
                }
            });
        });
    });

    // Keyboard shortcuts - Phím tắt
    document.addEventListener('keydown', function(e) {
        // Alt+L: Go to login page
        if (e.altKey && e.key === 'l') {
            e.preventDefault();
            window.location.href = '<c:url value="/login" />';
        }

        // Alt+H: Go to home page
        if (e.altKey && e.key === 'h') {
            e.preventDefault();
            window.location.href = '<c:url value="/home" />';
        }

        // Alt+C: Go to contact page
        if (e.altKey && e.key === 'c') {
            e.preventDefault();
            window.location.href = '<c:url value="/contact" />';
        }
    });

    // Auto-refresh auth status - Tự động làm mới trạng thái xác thực
    function checkAuthStatus() {
        fetch('/api/auth/status', {
            method: 'GET',
            credentials: 'same-origin'
        })
            .then(response => response.json())
            .then(data => {
                if (data.authenticated && data.hasRequiredRole) {
                    // User now has access, redirect
                    window.location.reload();
                }
            })
            .catch(error => {
                console.log('Không thể kiểm tra trạng thái xác thực:', error);
            });
    }

    // Check auth status every 30 seconds
    setInterval(checkAuthStatus, 30000);

    // Handle page visibility change - Xử lý khi trang được hiển thị lại
    document.addEventListener('visibilitychange', function() {
        if (!document.hidden) {
            // Page became visible, check if user might have logged in elsewhere
            setTimeout(checkAuthStatus, 1000);
        }
    });

    // Add warning for sensitive operations - Thêm cảnh báo cho các thao tác nhạy cảm
    const dangerButtons = document.querySelectorAll('.btn-danger-custom');
    dangerButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            if (!confirm('Bạn có chắc chắn muốn đăng xuất khỏi tài khoản hiện tại?')) {
                e.preventDefault();
            }
        });
    });

    // Show tooltips for role badges - Hiển thị tooltip cho role badges
    const roleBadges = document.querySelectorAll('.role-badge');
    roleBadges.forEach(badge => {
        badge.title = 'Bạn cần có vai trò này để truy cập trang';
        badge.style.cursor = 'help';
    });

    // Add smooth scroll behavior - Thêm cuộn mượt
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
</script>
</body>
</html>