<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isErrorPage="true" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang không tìm thấy - EduLearn Platform</title>

    <!-- Meta tags -->
    <meta name="description" content="Trang bạn đang tìm kiếm không tồn tại hoặc đã bị di chuyển. Quay lại trang chủ EduLearn Platform để tiếp tục học tập.">
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
            --success-color: #059669;
            --warning-color: #d97706;
            --danger-color: #dc2626;
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
            max-width: 1000px;
            margin: 0 auto;
            text-align: center;
            position: relative;
        }

        /* 404 Number Animation */
        .error-number {
            font-size: 12rem;
            font-weight: 900;
            color: var(--primary-color);
            line-height: 1;
            margin-bottom: 1rem;
            position: relative;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            animation: float 3s ease-in-out infinite;
        }

        .error-number::before {
            content: '404';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            opacity: 0.3;
            z-index: -1;
            animation: float 3s ease-in-out infinite reverse;
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0px);
            }
            50% {
                transform: translateY(-20px);
            }
        }

        .error-title {
            font-size: 3rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 1rem;
        }

        .error-subtitle {
            font-size: 1.5rem;
            font-weight: 500;
            color: var(--text-secondary);
            margin-bottom: 1rem;
        }

        .error-description {
            font-size: 1.125rem;
            color: var(--text-secondary);
            margin-bottom: 3rem;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        .error-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-bottom: 3rem;
        }

        .btn-primary-custom {
            background: var(--primary-color);
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
            position: relative;
            overflow: hidden;
        }

        .btn-primary-custom:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: 0 10px 25px -5px rgba(79, 70, 229, 0.4);
            color: white;
            text-decoration: none;
        }

        .btn-primary-custom::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }

        .btn-primary-custom:hover::before {
            left: 100%;
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

        /* Helpful Links */
        .helpful-links {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
            max-width: 600px;
            margin: 0 auto 2rem;
        }

        .helpful-links h3 {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1.5rem;
            text-align: center;
        }

        .links-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }

        .link-item {
            display: flex;
            align-items: center;
            padding: 1rem;
            background: var(--light-bg);
            border-radius: 0.75rem;
            text-decoration: none;
            color: var(--text-primary);
            transition: all 0.3s ease;
            border: 1px solid var(--border-color);
        }

        .link-item:hover {
            background: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px -4px rgba(0, 0, 0, 0.1);
            color: var(--primary-color);
            text-decoration: none;
        }

        .link-icon {
            width: 40px;
            height: 40px;
            background: var(--primary-color);
            color: white;
            border-radius: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            font-size: 1rem;
        }

        .link-content .link-title {
            font-weight: 600;
            margin-bottom: 0.25rem;
        }

        .link-content .link-description {
            font-size: 0.875rem;
            color: var(--text-secondary);
        }

        /* Search Box */
        .search-box {
            max-width: 400px;
            margin: 0 auto 2rem;
        }

        .search-input {
            width: 100%;
            padding: 0.875rem 1rem;
            border: 2px solid var(--border-color);
            border-radius: 0.75rem;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .error-number {
                font-size: 8rem;
            }

            .error-title {
                font-size: 2rem;
            }

            .error-subtitle {
                font-size: 1.25rem;
            }

            .error-description {
                font-size: 1rem;
                padding: 0 1rem;
            }

            .error-actions {
                flex-direction: column;
                align-items: center;
            }

            .btn-primary-custom,
            .btn-secondary-custom {
                width: 100%;
                max-width: 280px;
            }

            .links-grid {
                grid-template-columns: 1fr;
            }

            .helpful-links {
                margin: 0 1rem 2rem;
                padding: 1.5rem;
            }
        }

        /* Dark mode support */
        @media (prefers-color-scheme: dark) {
            body {
                background: linear-gradient(135deg, #1f2937 0%, #111827 100%);
                color: #f9fafb;
            }

            .error-title {
                color: #f9fafb;
            }

            .helpful-links {
                background: #374151;
                border-color: #4b5563;
            }

            .link-item {
                background: #4b5563;
                border-color: #6b7280;
                color: #f9fafb;
            }

            .link-item:hover {
                background: #6b7280;
            }

            .search-input {
                background: #374151;
                border-color: #4b5563;
                color: #f9fafb;
            }
        }
    </style>
</head>

<body>
<div class="error-container">
    <div class="container">
        <div class="error-content">
            <!-- Error Number -->
            <div class="error-number">404</div>

            <!-- Error Messages -->
            <h1 class="error-title">Trang không tìm thấy</h1>
            <h2 class="error-subtitle">Rất tiếc, chúng tôi không tìm thấy trang này!</h2>
            <p class="error-description">
                Trang bạn đang tìm kiếm có thể đã bị xóa, đổi tên hoặc tạm thời không khả dụng.
                Đừng lo lắng, chúng tôi có thể giúp bạn tìm thấy những gì bạn cần.
            </p>

            <!-- Action Buttons -->
            <div class="error-actions">
                <!-- ✅ SỬA LỖI: đường dẫn href đúng -->
                <a href="${pageContext.request.contextPath}/" class="btn-primary-custom">
                    <i class="fas fa-home"></i>
                    Về Trang Chủ
                </a>
                <a href="${pageContext.request.contextPath}/courses" class="btn-secondary-custom">
                    <i class="fas fa-book"></i>
                    Xem Khóa Học
                </a>
            </div>

            <!-- Search Box -->
            <div class="search-box">
                <input type="text" class="search-input" id="searchInput"
                       placeholder="Tìm kiếm khóa học hoặc chủ đề...">
            </div>

            <!-- Helpful Links -->
            <div class="helpful-links">
                <h3>Liên kết hữu ích</h3>
                <div class="links-grid">
                    <!-- ✅ SỬA LỖI: tất cả đường dẫn href đúng -->
                    <a href="${pageContext.request.contextPath}/courses" class="link-item">
                        <div class="link-icon">
                            <i class="fas fa-graduation-cap"></i>
                        </div>
                        <div class="link-content">
                            <div class="link-title">Khóa học</div>
                            <div class="link-description">Khám phá các khóa học chất lượng</div>
                        </div>
                    </a>

                    <a href="${pageContext.request.contextPath}/about" class="link-item">
                        <div class="link-icon">
                            <i class="fas fa-info-circle"></i>
                        </div>
                        <div class="link-content">
                            <div class="link-title">Giới thiệu</div>
                            <div class="link-description">Tìm hiểu về EduLearn</div>
                        </div>
                    </a>

                    <a href="${pageContext.request.contextPath}/contact" class="link-item">
                        <div class="link-icon">
                            <i class="fas fa-envelope"></i>
                        </div>
                        <div class="link-content">
                            <div class="link-title">Liên hệ</div>
                            <div class="link-description">Liên hệ ngay</div>
                        </div>
                    </a>

                    <a href="${pageContext.request.contextPath}/login" class="link-item">
                        <div class="link-icon">
                            <i class="fas fa-sign-in-alt"></i>
                        </div>
                        <div class="link-content">
                            <div class="link-title">Đăng nhập</div>
                            <div class="link-description">Truy cập tài khoản của bạn</div>
                        </div>
                    </a>
                </div>
            </div>

            <!-- Additional Info -->
            <div class="text-center mt-4">
                <p class="text-muted">
                    <small>
                        Lỗi 404 - Trang không tìm thấy |
                        <a href="${pageContext.request.contextPath}/contact" class="text-primary">Báo lỗi</a> |
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
    // Handle search functionality - Xử lý chức năng tìm kiếm
    function performSearch() {
        const searchInput = document.getElementById('searchInput');
        const query = searchInput.value.trim();

        if (query) {
            // Redirect to courses page with search query - Chuyển hướng đến trang khóa học với từ khóa tìm kiếm
            const searchUrl = `${pageContext.servletContext.contextPath}/courses?search=${pageContext.request.contextPath}/courses?search=" + encodeURIComponent(query)`;
            window.location.href = searchUrl;
        }
    }

    // Handle Enter key press in search input - Xử lý phím Enter trong ô tìm kiếm
    document.getElementById('searchInput').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            performSearch();
        }
    });

    // Add floating animation to error number - Thêm hiệu ứng float cho số lỗi
    document.addEventListener('DOMContentLoaded', function() {
        const errorNumber = document.querySelector('.error-number');

        // Add click interaction for fun - Thêm tương tác click cho vui
        errorNumber.addEventListener('click', function() {
            this.style.animation = 'none';
            setTimeout(() => {
                this.style.animation = 'float 1s ease-in-out infinite';
            }, 100);
        });

        // Auto focus on search input - Tự động focus vào ô tìm kiếm
        document.getElementById('searchInput').focus();

        // Add keyboard navigation - Thêm điều hướng bàn phím
        document.addEventListener('keydown', function(e) {
            // Press 'h' to go home - Nhấn 'h' để về trang chủ
            if (e.key === 'h' && !e.ctrlKey && !e.altKey && !e.metaKey) {
                const activeElement = document.activeElement;
                if (activeElement.tagName !== 'INPUT' && activeElement.tagName !== 'TEXTAREA') {
                    window.location.href = '${pageContext.request.contextPath}/';
                }
            }

            // Press 'c' to go to courses - Nhấn 'c' để đi tới trang khóa học
            if (e.key === 'c' && !e.ctrlKey && !e.altKey && !e.metaKey) {
                const activeElement = document.activeElement;
                if (activeElement.tagName !== 'INPUT' && activeElement.tagName !== 'TEXTAREA') {
                    window.location.href = '${pageContext.request.contextPath}/courses';
                }
            }
        });
    });

    // Add some interactive effects - Thêm một số hiệu ứng tương tác
    document.querySelectorAll('.link-item').forEach(link => {
        link.addEventListener('mouseenter', function() {
            this.querySelector('.link-icon').style.transform = 'scale(1.1) rotate(5deg)';
        });

        link.addEventListener('mouseleave', function() {
            this.querySelector('.link-icon').style.transform = 'scale(1) rotate(0deg)';
        });
    });
</script>
</body>
</html>