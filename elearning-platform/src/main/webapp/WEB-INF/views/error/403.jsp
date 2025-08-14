<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Truy cập bị từ chối - 403</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        /* Định nghĩa các biến màu sắc chính */
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --text-muted: #6c757d;
        }

        /* Thiết lập nền trang với gradient vàng cam để thể hiện cảnh báo */
        body {
            background: linear-gradient(135deg, #ffd89b 0%, #19547b 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* Container chứa nội dung lỗi access denied */
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

        /* Icon khóa với hiệu ứng */
        .error-icon {
            font-size: 8rem;
            color: var(--warning-color);
            margin-bottom: 1.5rem;
        }

        /* Số 403 lớn */
        .error-code {
            font-size: 6rem;
            font-weight: 900;
            color: var(--warning-color);
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

        /* Thông tin quyền truy cập hiện tại */
        .access-info {
            background: #e7f3ff;
            border: 1px solid #b3d7ff;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            text-align: left;
        }

        .access-info h5 {
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        .access-info .user-role {
            background: var(--primary-color);
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        /* Danh sách quyền cần thiết */
        .required-permissions {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            text-align: left;
        }

        .required-permissions h5 {
            color: var(--warning-color);
            margin-bottom: 1rem;
        }

        .required-permissions ul {
            margin-bottom: 0;
            padding-left: 1.2rem;
        }

        .required-permissions li {
            margin-bottom: 0.5rem;
            color: #856404;
        }

        /* Nút hành động */
        .error-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        /* Nút đăng nhập */
        .btn-login {
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

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
            color: white;
        }

        /* Nút quay về trang chủ */
        .btn-home {
            background: transparent;
            border: 2px solid var(--primary-color);
            color: var(--primary-color);
            padding: 10px 28px;
            border-radius: 50px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-home:hover {
            background: var(--primary-color);
            color: white;
            transform: translateY(-2px);
        }

        /* Nút đăng xuất */
        .btn-logout {
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

        .btn-logout:hover {
            background: var(--danger-color);
            color: white;
            transform: translateY(-2px);
        }

        /* Hiệu ứng animation cho icon khóa */
        .error-icon {
            animation: swing 2s infinite ease-in-out;
        }

        @keyframes swing {
            0%, 100% { transform: rotate(0deg); }
            25% { transform: rotate(10deg); }
            75% { transform: rotate(-10deg); }
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
<!-- Container chính chứa nội dung lỗi access denied -->
<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="error-container">
                <!-- Icon khóa với hiệu ứng swing -->
                <div class="error-icon">
                    <i class="fas fa-lock"></i>
                </div>

                <!-- Mã lỗi 403 -->
                <div class="error-code">403</div>

                <!-- Tiêu đề thông báo lỗi -->
                <h1 class="error-title">Truy cập bị từ chối!</h1>

                <!-- Mô tả chi tiết về lỗi -->
                <p class="error-description">
                    Bạn không có quyền truy cập vào trang này. Vui lòng kiểm tra quyền tài khoản
                    hoặc liên hệ quản trị viên để được cấp quyền phù hợp.
                </p>

                <!-- Thông tin tài khoản hiện tại -->
                <sec:authorize access="isAuthenticated()">
                    <div class="access-info">
                        <h5><i class="fas fa-user-circle"></i> Thông tin tài khoản</h5>
                        <p><strong>Tên đăng nhập:</strong> <sec:authentication property="principal.username" /></p>
                        <p><strong>Quyền hiện tại:</strong>
                            <span class="user-role">
                                    <sec:authentication property="principal.authorities" />
                                </span>
                        </p>
                    </div>
                </sec:authorize>

                <!-- Thông tin quyền cần thiết -->
                <div class="required-permissions">
                    <h5><i class="fas fa-key"></i> Quyền cần thiết</h5>
                    <p>Để truy cập trang này, bạn cần có một trong các quyền sau:</p>
                    <ul>
                        <li><strong>ADMIN</strong> - Quyền quản trị viên hệ thống</li>
                        <li><strong>INSTRUCTOR</strong> - Quyền giảng viên</li>
                        <li><strong>STUDENT</strong> - Quyền học viên (một số trang)</li>
                    </ul>
                </div>

                <!-- Các nút hành động dựa trên trạng thái đăng nhập -->
                <div class="error-actions">
                    <sec:authorize access="!isAuthenticated()">
                        <!-- Nút đăng nhập cho người dùng chưa đăng nhập -->
                        <a href="/login" class="btn-login">
                            <i class="fas fa-sign-in-alt"></i>
                            Đăng nhập
                        </a>
                    </sec:authorize>

                    <sec:authorize access="isAuthenticated()">
                        <!-- Nút đăng xuất để thử tài khoản khác -->
                        <form action="/logout" method="post" style="display: inline;">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <button type="submit" class="btn-logout">
                                <i class="fas fa-sign-out-alt"></i>
                                Đăng xuất
                            </button>
                        </form>
                    </sec:authorize>

                    <!-- Nút quay về trang chủ -->
                    <a href="/" class="btn-home">
                        <i class="fas fa-home"></i>
                        Về trang chủ
                    </a>
                </div>

                <!-- Thông tin liên hệ hỗ trợ -->
                <div class="mt-4 pt-3" style="border-top: 1px solid #e9ecef;">
                    <p class="mb-1" style="font-size: 0.9rem; color: var(--text-muted);">
                        <i class="fas fa-question-circle"></i>
                        Cần hỗ trợ? Liên hệ quản trị viên
                    </p>
                    <p class="mb-0" style="font-size: 0.85rem; color: var(--text-muted);">
                        <i class="fas fa-envelope"></i>
                        <a href="mailto:admin@coursemanagement.com" style="color: var(--primary-color);">
                            admin@coursemanagement.com
                        </a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>