<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page isErrorPage="true" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lỗi máy chủ - EduLearn Platform</title>

    <!-- Meta tags -->
    <meta name="description" content="Đã xảy ra lỗi máy chủ. Chúng tôi đang khắc phục vấn đề. Vui lòng thử lại sau ít phút.">
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
            max-width: 1000px;
            margin: 0 auto;
            text-align: center;
            position: relative;
        }

        /* 500 Number Animation */
        .error-number {
            font-size: 10rem;
            font-weight: 900;
            color: var(--warning-color);
            line-height: 1;
            margin-bottom: 1rem;
            position: relative;
            background: linear-gradient(135deg, var(--warning-color), #f59e0b);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            animation: glitch 3s ease-in-out infinite;
        }

        @keyframes glitch {
            0%, 100% {
                transform: translate(0);
                filter: hue-rotate(0deg);
            }
            20% {
                transform: translate(-2px, 2px);
                filter: hue-rotate(90deg);
            }
            40% {
                transform: translate(-2px, -2px);
                filter: hue-rotate(180deg);
            }
            60% {
                transform: translate(2px, 2px);
                filter: hue-rotate(270deg);
            }
            80% {
                transform: translate(2px, -2px);
                filter: hue-rotate(360deg);
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
            color: var(--warning-color);
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

        /* Server Illustration */
        .server-illustration {
            width: 250px;
            height: 250px;
            margin: 0 auto 3rem;
            position: relative;
            background: linear-gradient(135deg, var(--warning-color), #f59e0b);
            border-radius: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 20px 40px -10px rgba(217, 119, 6, 0.3);
            animation: serverBlink 2s ease-in-out infinite;
        }

        .server-illustration::before {
            content: '';
            position: absolute;
            width: 120%;
            height: 120%;
            background: radial-gradient(circle, rgba(217, 119, 6, 0.1) 0%, transparent 70%);
            border-radius: 1rem;
            z-index: -1;
            animation: pulse 2s ease-in-out infinite;
        }

        .server-icon {
            font-size: 5rem;
            color: white;
            animation: serverShake 3s ease-in-out infinite;
        }

        @keyframes serverBlink {
            0%, 50%, 100% {
                opacity: 1;
            }
            25%, 75% {
                opacity: 0.7;
            }
        }

        @keyframes serverShake {
            0%, 100% {
                transform: translateX(0);
            }
            10%, 30%, 50%, 70%, 90% {
                transform: translateX(-5px);
            }
            20%, 40%, 60%, 80% {
                transform: translateX(5px);
            }
        }

        @keyframes pulse {
            0% {
                transform: scale(0.8);
                opacity: 1;
            }
            100% {
                transform: scale(1.2);
                opacity: 0;
            }
        }

        /* Status Cards */
        .status-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 3rem;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
        }

        .status-card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
        }

        .status-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px -8px rgba(0, 0, 0, 0.1);
        }

        .status-header {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
        }

        .status-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            color: white;
        }

        .status-icon.checking {
            background: var(--warning-color);
            animation: spin 2s linear infinite;
        }

        .status-icon.error {
            background: var(--danger-color);
        }

        .status-icon.ok {
            background: var(--primary-color);
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .status-title {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }

        .status-description {
            color: var(--text-secondary);
            font-size: 0.9rem;
        }

        /* Error Details */
        .error-details {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
            max-width: 700px;
            margin: 0 auto 3rem;
            text-align: left;
        }

        .error-details h3 {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }

        .error-details h3 i {
            margin-right: 0.5rem;
            color: var(--warning-color);
        }

        .detail-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem;
            background: var(--light-bg);
            border-radius: 0.5rem;
            margin-bottom: 0.75rem;
            border: 1px solid var(--border-color);
        }

        .detail-label {
            font-weight: 500;
            color: var(--text-secondary);
        }

        .detail-value {
            font-weight: 600;
            color: var(--text-primary);
            font-family: monospace;
            background: white;
            padding: 0.25rem 0.5rem;
            border-radius: 0.25rem;
            border: 1px solid var(--border-color);
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

        .btn-warning-custom {
            background: linear-gradient(135deg, var(--warning-color), #f59e0b);
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

        .btn-warning-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px -5px rgba(217, 119, 6, 0.4);
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

        /* Countdown Timer */
        .countdown-timer {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
            max-width: 400px;
            margin: 0 auto 2rem;
        }

        .countdown-title {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .countdown-title i {
            margin-right: 0.5rem;
            color: var(--warning-color);
        }

        .countdown-display {
            font-size: 2rem;
            font-weight: 700;
            color: var(--warning-color);
            text-align: center;
            margin-bottom: 0.5rem;
        }

        .countdown-text {
            text-align: center;
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

            .server-illustration {
                width: 200px;
                height: 200px;
            }

            .server-icon {
                font-size: 4rem;
            }

            .error-actions {
                flex-direction: column;
                align-items: center;
            }

            .btn-primary-custom,
            .btn-warning-custom,
            .btn-secondary-custom {
                width: 100%;
                max-width: 280px;
            }

            .status-grid {
                grid-template-columns: 1fr;
            }

            .error-details,
            .countdown-timer {
                margin: 0 1rem 2rem;
                padding: 1.5rem;
            }

            .detail-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.5rem;
            }
        }
    </style>
</head>

<body>
<div class="error-container">
    <div class="container">
        <div class="error-content">
            <!-- Error Number -->
            <div class="error-number">500</div>

            <!-- Server Illustration -->
            <div class="server-illustration">
                <i class="fas fa-server server-icon"></i>
            </div>

            <!-- Error Messages -->
            <h1 class="error-title">Lỗi máy chủ nội bộ</h1>
            <h2 class="error-subtitle">Đã xảy ra sự cố với máy chủ của chúng tôi!</h2>
            <p class="error-description">
                Chúng tôi đang gặp một số vấn đề kỹ thuật tạm thời. Đội ngũ kỹ thuật của chúng tôi
                đã được thông báo và đang khắc phục sự cố. Vui lòng thử lại sau ít phút.
            </p>

            <!-- Status Cards -->
            <div class="status-grid">
                <div class="status-card">
                    <div class="status-header">
                        <div class="status-icon checking">
                            <i class="fas fa-sync-alt"></i>
                        </div>
                        <div>
                            <div class="status-title">Hệ thống đang kiểm tra</div>
                            <div class="status-description">Đang chẩn đoán sự cố</div>
                        </div>
                    </div>
                </div>

                <div class="status-card">
                    <div class="status-header">
                        <div class="status-icon error">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                        <div>
                            <div class="status-title">Dịch vụ tạm dừng</div>
                            <div class="status-description">Một số tính năng có thể không khả dụng</div>
                        </div>
                    </div>
                </div>

                <div class="status-card">
                    <div class="status-header">
                        <div class="status-icon ok">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <div>
                            <div class="status-title">Dữ liệu an toàn</div>
                            <div class="status-description">Thông tin của bạn được bảo vệ</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Error Details -->
            <div class="error-details">
                <h3>
                    <i class="fas fa-info-circle"></i>
                    Thông tin lỗi
                </h3>

                <div class="detail-item">
                    <span class="detail-label">Mã lỗi:</span>
                    <span class="detail-value">HTTP 500</span>
                </div>

                <div class="detail-item">
                    <span class="detail-label">Thời gian:</span>
                    <span class="detail-value">
                            <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy HH:mm:ss"/>
                        </span>
                </div>

                <div class="detail-item">
                    <span class="detail-label">ID phiên:</span>
                    <span class="detail-value">${pageContext.session.id}</span>
                </div>

                <div class="detail-item">
                    <span class="detail-label">Trạng thái:</span>
                    <span class="detail-value">Máy chủ gặp sự cố tạm thời</span>
                </div>
            </div>

            <!-- Countdown Timer -->
            <div class="countdown-timer">
                <div class="countdown-title">
                    <i class="fas fa-clock"></i>
                    Tự động thử lại sau
                </div>
                <div class="countdown-display" id="countdown">60</div>
                <div class="countdown-text">giây</div>
            </div>

            <!-- Action Buttons -->
            <div class="error-actions">
                <button onclick="window.location.reload()" class="btn-warning-custom">
                    <i class="fas fa-redo"></i>
                    Thử lại ngay
                </button>

                <a href="//"" class="btn-primary-custom">
                    <i class="fas fa-home"></i>
                    Về trang chủ
                </a>

                <a href="//contact"" class="btn-secondary-custom">
                    <i class="fas fa-envelope"></i>
                    Báo lỗi
                </a>
            </div>

            <!-- Additional Info -->
            <div class="text-center mt-4">
                <p class="text-muted">
                    <small>
                        Lỗi 500 - Lỗi máy chủ nội bộ |
                        <a href="//contact"" class="text-primary">Báo lỗi</a> |
                        <a href="javascript:checkServerStatus()" class="text-primary">Kiểm tra trạng thái</a>
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
    // Countdown timer functionality - Chức năng đếm ngược
    let countdownValue = 60;
    let countdownInterval;

    function startCountdown() {
        const countdownElement = document.getElementById('countdown');

        countdownInterval = setInterval(() => {
            countdownValue--;
            countdownElement.textContent = countdownValue;

            if (countdownValue <= 0) {
                clearInterval(countdownInterval);
                // Auto-refresh page
                window.location.reload();
            }
        }, 1000);
    }

    // Server status check - Kiểm tra trạng thái máy chủ
    async function checkServerStatus() {
        try {
            const response = await fetch('/api/health', {
                method: 'GET',
                cache: 'no-cache'
            });

            if (response.ok) {
                // Server is back online
                alert('Máy chủ đã hoạt động trở lại! Trang sẽ được tải lại.');
                window.location.reload();
            } else {
                alert('Máy chủ vẫn đang gặp sự cố. Vui lòng thử lại sau.');
            }
        } catch (error) {
            alert('Không thể kết nối với máy chủ. Vui lòng kiểm tra kết nối internet.');
        }
    }

    // Periodic status check - Kiểm tra trạng thái định kỳ
    function periodicStatusCheck() {
        setInterval(async () => {
            try {
                const response = await fetch('/api/health', {
                    method: 'HEAD',
                    cache: 'no-cache'
                });

                if (response.ok) {
                    // Server is back, redirect to intended page
                    window.location.reload();
                }
            } catch (error) {
                // Server still down, continue checking
                console.log('Server still unavailable');
            }
        }, 10000); // Check every 10 seconds
    }

    // Animation effects - Hiệu ứng animation
    document.addEventListener('DOMContentLoaded', function() {
        // Start countdown
        startCountdown();

        // Start periodic status checks
        periodicStatusCheck();

        // Animate elements on load
        const elements = document.querySelectorAll('.error-title, .error-subtitle, .error-description, .status-grid, .error-details, .countdown-timer, .error-actions');
        elements.forEach((element, index) => {
            element.style.opacity = '0';
            element.style.transform = 'translateY(30px)';
            element.style.transition = 'all 0.6s ease';

            setTimeout(() => {
                element.style.opacity = '1';
                element.style.transform = 'translateY(0)';
            }, index * 150);
        });

        // Track 500 error for analytics - Theo dõi lỗi 500 cho phân tích
        if (typeof gtag !== 'undefined') {
            gtag('event', 'server_error', {
                'page_title': 'Error 500',
                'page_location': window.location.href,
                'custom_parameter': 'internal_server_error'
            });
        }

        // Log error details for debugging - Ghi log chi tiết lỗi để debug
        console.error('500 Server Error Details:', {
            timestamp: new Date().toISOString(),
            url: window.location.href,
            referrer: document.referrer,
            userAgent: navigator.userAgent,
            sessionId: '${pageContext.session.id}',
            stackTrace: 'Server-side error occurred'
        });

        // Add retry functionality to all buttons - Thêm chức năng thử lại cho tất cả nút
        const retryButtons = document.querySelectorAll('.btn-warning-custom');
        retryButtons.forEach(button => {
            button.addEventListener('click', function() {
                // Clear countdown
                if (countdownInterval) {
                    clearInterval(countdownInterval);
                }

                // Show loading state
                this.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang thử lại...';
                this.disabled = true;

                // Retry after short delay
                setTimeout(() => {
                    window.location.reload();
                }, 2000);
            });
        });
    });

    // Keyboard shortcuts - Phím tắt
    document.addEventListener('keydown', function(e) {
        // F5 or Ctrl+R: Refresh page
        if (e.key === 'F5' || (e.ctrlKey && e.key === 'r')) {
            // Allow default refresh behavior
            return;
        }

        // Alt+H: Go to home page
        if (e.altKey && e.key === 'h') {
            e.preventDefault();
            window.location.href = '<c:url value="/" />';
        }

        // Alt+R: Retry/refresh
        if (e.altKey && e.key === 'r') {
            e.preventDefault();
            window.location.reload();
        }

        // Alt+S: Check server status
        if (e.altKey && e.key === 's') {
            e.preventDefault();
            checkServerStatus();
        }
    });

    // Handle page visibility change - Xử lý khi trang được hiển thị lại
    document.addEventListener('visibilitychange', function() {
        if (!document.hidden) {
            // Page became visible, check if server is back
            setTimeout(checkServerStatus, 1000);
        }
    });

    // Network connection monitoring - Giám sát kết nối mạng
    window.addEventListener('online', function() {
        // Connection restored, check server immediately
        setTimeout(checkServerStatus, 500);
    });

    window.addEventListener('offline', function() {
        // Connection lost
        if (countdownInterval) {
            clearInterval(countdownInterval);
        }

        const countdownElement = document.getElementById('countdown');
        if (countdownElement) {
            countdownElement.textContent = '∞';
            countdownElement.parentElement.querySelector('.countdown-text').textContent = 'Không có kết nối';
        }
    });

    // Add warning before leaving page - Thêm cảnh báo trước khi rời trang
    let hasTriedRefresh = false;

    window.addEventListener('beforeunload', function(e) {
        if (!hasTriedRefresh) {
            hasTriedRefresh = true;
            e.preventDefault();
            e.returnValue = 'Máy chủ có thể đã khôi phục. Bạn có muốn thử lại không?';
            return e.returnValue;
        }
    });

    // Auto-clear browser cache for this session - Tự động xóa cache trình duyệt
    if ('caches' in window) {
        caches.keys().then(function(names) {
            names.forEach(function(name) {
                if (name.includes('error-500')) {
                    caches.delete(name);
                }
            });
        });
    }
</script>
</body>
</html>