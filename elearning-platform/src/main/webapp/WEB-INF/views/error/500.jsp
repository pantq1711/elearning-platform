<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Có lỗi xảy ra - E-Learning Platform</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            font-family: 'Inter', sans-serif;
        }
        .error-container {
            background: white;
            border-radius: 20px;
            padding: 60px 40px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 500px;
            margin: 0 auto;
        }
        .error-icon {
            font-size: 5rem;
            color: #dc3545;
            margin-bottom: 20px;
        }
        .error-title {
            font-size: 2rem;
            font-weight: 700;
            color: #343a40;
            margin-bottom: 15px;
        }
        .error-message {
            color: #6c757d;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        .btn-home {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }
        .btn-home:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            color: white;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="error-container">
        <div class="error-icon">
            <i class="fas fa-exclamation-triangle"></i>
        </div>

        <h1 class="error-title">Oops! Có lỗi xảy ra</h1>

        <div class="error-message">
            <c:choose>
                <c:when test="${not empty error}">
                    <p>${error}</p>
                </c:when>
                <c:when test="${not empty exception}">
                    <p>Hệ thống đang gặp sự cố. Vui lòng thử lại sau.</p>
                    <small class="text-muted d-block mt-2">
                        Error: ${exception.message}
                    </small>
                </c:when>
                <c:otherwise>
                    <p>Đã xảy ra lỗi không mong muốn. Vui lòng thử lại hoặc liên hệ với chúng tôi nếu vấn đề vẫn tiếp tục.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="d-flex gap-3 justify-content-center">
            <a href="/" class="btn-home">
                <i class="fas fa-home me-2"></i>Về trang chủ
            </a>
            <button onclick="history.back()" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-2"></i>Quay lại
            </button>
        </div>

        <div class="mt-4">
            <small class="text-muted">
                Mã lỗi: <span id="error-code">${status != null ? status : '500'}</span> |
                Thời gian: <span id="timestamp"></span>
            </small>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Hiển thị thời gian hiện tại
    document.getElementById('timestamp').textContent = new Date().toLocaleString('vi-VN');

    // Tự động reload sau 30 giây (optional)
    setTimeout(function() {
        const reloadBtn = document.createElement('button');
        reloadBtn.className = 'btn btn-outline-primary btn-sm mt-3';
        reloadBtn.innerHTML = '<i class="fas fa-sync-alt me-1"></i>Tải lại trang';
        reloadBtn.onclick = function() { location.reload(); };
        document.querySelector('.error-container').appendChild(reloadBtn);
    }, 30000);
</script>

</body>
</html>