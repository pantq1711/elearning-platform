<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>403 - Không có quyền truy cập | EduLearn</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-color: #4f46e5;
            --primary-dark: #3730a3;
            --danger-color: #dc2626;
            --warning-color: #d97706;
            --light-bg: #f8fafc;
            --text-muted: #64748b;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, var(--light-bg) 0%, #e2e8f0 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .error-container {
            max-width: 600px;
            text-align: center;
            padding: 2rem;
        }

        .error-icon {
            font-size: 8rem;
            color: var(--danger-color);
            margin-bottom: 2rem;
            animation: bounce 2s infinite;
        }

        .error-code {
            font-size: 4rem;
            font-weight: 700;
            color: var(--danger-color);
            margin-bottom: 1rem;
        }

        .error-title {
            font-size: 2rem;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 1rem;
        }

        .error-message {
            font-size: 1.1rem;
            color: var(--text-muted);
            margin-bottom: 2rem;
            line-height: 1.6;
        }

        .user-info {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            margin: 2rem 0;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .role-badge {
            display: inline-block;
            padding: 0.375rem 0.75rem;
            border-radius: 0.5rem;
            font-size: 0.875rem;
            font-weight: 500;
            margin-top: 0.5rem;
        }

        .role-admin { background-color: #fef3c7; color: #92400e; }
        .role-instructor { background-color: #d1fae5; color: #065f46; }
        .role-student { background-color: #dbeafe; color: #1e40af; }

        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 2rem;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            border: none;
            padding: 0.75rem 2rem;
            border-radius: 0.75rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(79, 70, 229, 0.3);
        }

        .btn-outline-custom {
            border: 2px solid var(--primary-color);
            color: var(--primary-color);
            padding: 0.75rem 2rem;
            border-radius: 0.75rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-outline-custom:hover {
            background: var(--primary-color);
            color: white;
            transform: translateY(-2px);
        }

        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-10px);
            }
            60% {
                transform: translateY(-5px);
            }
        }

        .suggestions {
            background: #f0f9ff;
            border: 1px solid #0ea5e9;
            border-radius: 12px;
            padding: 1.5rem;
            margin-top: 2rem;
        }

        .suggestions h6 {
            color: #0369a1;
            margin-bottom: 1rem;
        }

        .suggestion-links {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .suggestion-links a {
            color: #0369a1;
            text-decoration: none;
            padding: 0.5rem;
            border-radius: 0.5rem;
            transition: background-color 0.3s ease;
        }

        .suggestion-links a:hover {
            background-color: #bae6fd;
        }

        @media (max-width: 768px) {
            .error-container {
                padding: 1rem;
            }

            .error-icon {
                font-size: 6rem;
            }

            .error-code {
                font-size: 3rem;
            }

            .error-title {
                font-size: 1.5rem;
            }

            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
        }
    </style>
</head>
<body>
<div class="error-container">
    <!-- Error Icon -->
    <div class="error-icon">
        <i class="fas fa-shield-alt"></i>
    </div>

    <!-- Error Code -->
    <div class="error-code">403</div>

    <!-- Error Title -->
    <h1 class="error-title">Không có quyền truy cập</h1>

    <!-- Error Message -->
    <p class="error-message">
        Xin lỗi, bạn không có quyền truy cập vào trang này.
        Vui lòng kiểm tra lại URL hoặc liên hệ quản trị viên để được hỗ trợ.
    </p>

    <!-- User Info (nếu đã đăng nhập) -->
    <sec:authorize access="isAuthenticated()">
        <div class="user-info">
            <h6>Thông tin tài khoản hiện tại:</h6>
            <p class="mb-2">
                <strong>Họ tên:</strong>
                <sec:authentication property="principal.fullName" />
            </p>
            <p class="mb-2">
                <strong>Username:</strong>
                <sec:authentication property="principal.username" />
            </p>
            <div>
                <strong>Vai trò:</strong>
                <sec:authorize access="hasRole('ADMIN')">
                        <span class="role-badge role-admin">
                            <i class="fas fa-crown me-1"></i>Quản trị viên
                        </span>
                </sec:authorize>
                <sec:authorize access="hasRole('INSTRUCTOR')">
                        <span class="role-badge role-instructor">
                            <i class="fas fa-chalkboard-teacher me-1"></i>Giảng viên
                        </span>
                </sec:authorize>
                <sec:authorize access="hasRole('STUDENT')">
                        <span class="role-badge role-student">
                            <i class="fas fa-user-graduate me-1"></i>Học viên
                        </span>
                </sec:authorize>
            </div>
        </div>
    </sec:authorize>

    <!-- Action Buttons -->
    <div class="action-buttons">
        <sec:authorize access="isAuthenticated()">
            <!-- Nút về dashboard phù hợp với role -->
            <sec:authorize access="hasRole('ADMIN')">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-primary-custom">
                    <i class="fas fa-tachometer-alt me-2"></i>Dashboard Admin
                </a>
            </sec:authorize>
            <sec:authorize access="hasRole('INSTRUCTOR')">
                <a href="${pageContext.request.contextPath}/instructor/dashboard" class="btn btn-primary-custom">
                    <i class="fas fa-chalkboard-teacher me-2"></i>Dashboard Giảng viên
                </a>
            </sec:authorize>
            <sec:authorize access="hasRole('STUDENT')">
                <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-primary-custom">
                    <i class="fas fa-user-graduate me-2"></i>Dashboard Học viên
                </a>
            </sec:authorize>
        </sec:authorize>

        <sec:authorize access="!isAuthenticated()">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary-custom">
                <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
            </a>
        </sec:authorize>

        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-custom">
            <i class="fas fa-home me-2"></i>Trang chủ
        </a>

        <a href="javascript:history.back()" class="btn btn-outline-custom">
            <i class="fas fa-arrow-left me-2"></i>Quay lại
        </a>
    </div>

    <!-- Suggestions Box -->
    <div class="suggestions">
        <h6><i class="fas fa-lightbulb me-2"></i>Gợi ý:</h6>
        <div class="suggestion-links">
            <a href="${pageContext.request.contextPath}/courses">
                <i class="fas fa-book me-2"></i>Xem danh sách khóa học
            </a>
            <a href="${pageContext.request.contextPath}/categories">
                <i class="fas fa-tags me-2"></i>Duyệt theo danh mục
            </a>
            <sec:authorize access="!isAuthenticated()">
                <a href="${pageContext.request.contextPath}/register">
                    <i class="fas fa-user-plus me-2"></i>Đăng ký tài khoản mới
                </a>
            </sec:authorize>
        </div>
    </div>

    <!-- Contact Info -->
    <div class="mt-4">
        <p class="text-muted">
            <small>
                Nếu bạn cho rằng đây là lỗi, vui lòng liên hệ:
                <a href="mailto:support@elearning.vn" class="text-decoration-none">support@elearning.vn</a>
            </small>
        </p>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>