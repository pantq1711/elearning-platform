<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lỗi máy chủ - 500</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        /* Định nghĩa các biến màu sắc chính */
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --danger-color: #dc3545;
            --warning-color: #ffc107;
            --text-muted: #6c757d;
        }

        /* Thiết lập nền trang với gradient đỏ cam để thể hiện lỗi nghiêm trọng */
        body {
            background: linear-gradient(135deg, #ff7b7b 0%, #667eea 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* Container chứa nội dung lỗi 500 */
        .error-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            padding: 3rem;
            text-align: center;
            max-width: 650px;
            width: 100%;
        }

        /* Icon lỗi server */
        .error-icon {
            font-size: 8rem;
            color: var(--danger-color);
            margin-bottom: 1.5rem;
        }

        /* Số 500 lớn */
        .error-code {
            font-size: 6rem;
            font-weight: 900;
            color: var(--danger-color);
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
        }

        /* Tiêu đề lỗi */
        .error-title {
            font-size: 2rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 1rem;
        }

        /* Mô tả lỗi */
        .error-description {
            color: var(--text-muted);
            font-size: 1.1rem;
            margin-bottom: 2rem;
            line-height: 1.6;
        }

        /* Thông tin chi tiết lỗi (nếu có) */
        .error-details {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            text-align: left;
        }

        .error-details h5 {
            color: var(--danger-color);
            margin-bottom: 1rem;
        }

        .error-details code {
            background: #e9ecef;
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 0.9rem;
        }

        /* Nút hành động */
        .error-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        /* Nút quay về trang chủ */
        .btn-home {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            border: none;
            color: white;
            padding: 12px 30px;
            border-radius: 50px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-home:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
            color: white;
        }

        /* Nút thử lại */
        .btn-retry {
            background: transparent;
            border: 2px solid var(--warning-color);
            color: var(--warning-color);
            padding: 10px 28px;
            border-radius: 50px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-retry:hover {
            background: var(--warning-color);
            color: #212529;
            transform: translateY(-2px);
        }

        /* Nút liên hệ hỗ trợ */
        .btn-support {
            background: transparent;
            border: 2px solid var(--danger-color);
            color: var(--danger-color);
            padding: 10px 28px;
            border-radius: 50px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-support:hover {
            background: var(--danger-color);
            color: white;
            transform: translateY(-2px);
        }

        /* Hiệu ứng animation cho icon */
        .error-icon {
            animation: shake 1s infinite;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        /* Responsive design cho màn hình nhỏ */
        @media (max-width: 768px) {
            .error-container {
                margin: 1rem;
                padding: 2rem;
            }

            .error-code {
                font-size: 4rem;
            }

            .error-title {
                font-size: 1.5rem;
            }

            .error-icon {
                font-size: 5rem;
            }

            .error-actions {
                flex-direction: column;
                align-items: center;
            }
        }
    </style>
</head>
<body>
<!-- Container chính chứa nội dung lỗi 500 -->
<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="error-container">
                <!-- Icon server bị lỗi với hiệu ứng shake -->
                <div class="error-icon">
                    <i class="fas fa-server"></i>
                </div>

                <!-- Mã lỗi 500 -->
                <div class="error-code">500</div>

                <!-- Tiêu đề thông báo lỗi -->
                <h1 class="error-title">Lỗi máy chủ nội bộ!</h1>

                <!-- Mô tả chi tiết về lỗi -->
                <p class="error-description">
                    Xin lỗi, đã xảy ra lỗi không mong muốn trên máy chủ.
                    Đội ngũ kỹ thuật của chúng tôi đã được thông báo và đang khắc phục sự cố.
                    Vui lòng thử lại sau hoặc liên hệ hỗ trợ nếu sự cố vẫn tiếp diễn.
                </p>

                <!-- Hiển thị chi tiết lỗi nếu có (chỉ trong môi trường development) -->
                <c:if test="${not empty error}">
                    <div class="error-details">
                        <h5><i class="fas fa-exclamation-circle"></i> Chi tiết lỗi:</h5>
                        <p><strong>Thông báo:</strong> <code>${error}</code></p>
                        <c:if test="${not empty timestamp}">
                            <p><strong>Thời gian:</strong> ${timestamp}</p>
                        </c:if>
                        <c:if test="${not empty path}">
                            <p><strong>Đường dẫn:</strong> <code>${path}</code></p>
                        </c:if>
                    </div>
                </c:if>

                <!-- Các nút hành động -->
                <div class="error-actions">
                    <!-- Nút thử lại -->
                    <a href="javascript:location.reload()" class="btn-retry">
                        <i class="fas fa-redo"></i>
                        Thử lại
                    </a>

                    <!-- Nút quay về trang chủ -->
                    <a href="/" class="btn-home">
                        <i class="fas fa-home"></i>
                        Về trang chủ
                    </a>

                    <!-- Nút liên hệ hỗ trợ -->
                    <a href="mailto:support@coursemanagement.com" class="btn-support">
                        <i class="fas fa-life-ring"></i>
                        Liên hệ hỗ trợ
                    </a>
                </div>

                <!-- Thông tin bổ sung -->
                <div class="mt-4 pt-3" style="border-top: 1px solid #e9ecef;">
                    <p class="mb-0" style="font-size: 0.9rem; color: var(--text-muted);">
                        <i class="fas fa-info-circle"></i>
                        Mã tham chiếu: <strong>${requestId != null ? requestId : 'N/A'}</strong>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Script tự động reload sau 30 giây (tùy chọn) -->
<script>
    // Tự động thử lại sau 30 giây
    setTimeout(function() {
        if (confirm('Hệ thống sẽ tự động thử lại. Bạn có muốn tiếp tục?')) {
            location.reload();
        }
    }, 30000);
</script>
</body>
</html>