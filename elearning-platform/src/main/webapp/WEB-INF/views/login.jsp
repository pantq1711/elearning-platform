<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Hệ thống Quản lý Khóa học</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .login-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            padding: 2rem;
            max-width: 450px;
            width: 100%;
        }

        .login-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .login-header h2 {
            color: #333;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .login-header p {
            color: #666;
            margin-bottom: 0;
        }

        .form-floating {
            margin-bottom: 1rem;
        }

        .form-control {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 0.75rem;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
            padding: 0.75rem 2rem;
            font-weight: 600;
            width: 100%;
            transition: all 0.3s ease;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }

        .alert {
            border-radius: 10px;
            border: none;
            margin-bottom: 1rem;
        }

        .register-link {
            text-align: center;
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid #e9ecef;
        }

        .register-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }

        .register-link a:hover {
            color: #764ba2;
        }

        .demo-accounts {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1rem;
            margin-top: 1rem;
            font-size: 0.875rem;
        }

        .demo-accounts h6 {
            color: #495057;
            margin-bottom: 0.5rem;
        }

        .demo-account {
            background: white;
            border-radius: 5px;
            padding: 0.5rem;
            margin-bottom: 0.25rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .demo-account:last-child {
            margin-bottom: 0;
        }

        .role-badge {
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
            border-radius: 15px;
        }

        .badge-admin { background-color: #dc3545; color: white; }
        .badge-instructor { background-color: #28a745; color: white; }
        .badge-student { background-color: #007bff; color: white; }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-5 col-md-7">
            <div class="login-container">
                <!-- Header -->
                <div class="login-header">
                    <i class="fas fa-graduation-cap fa-3x text-primary mb-3"></i>
                    <h2>🎓 Đăng nhập</h2>
                    <p>Hệ thống Quản lý Khóa học</p>
                </div>

                <!-- Error Message -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                            ${error}
                    </div>
                </c:if>

                <!-- Success Message -->
                <c:if test="${not empty message}">
                    <div class="alert alert-success" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                            ${message}
                    </div>
                </c:if>

                <!-- Login Form -->
                <form action="/perform_login" method="post">
                    <div class="form-floating">
                        <input type="text" class="form-control" id="username" name="username"
                               placeholder="Tên đăng nhập" required>
                        <label for="username">
                            <i class="fas fa-user me-2"></i>Tên đăng nhập
                        </label>
                    </div>

                    <div class="form-floating">
                        <input type="password" class="form-control" id="password" name="password"
                               placeholder="Mật khẩu" required>
                        <label for="password">
                            <i class="fas fa-lock me-2"></i>Mật khẩu
                        </label>
                    </div>

                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="remember-me" name="remember-me">
                        <label class="form-check-label" for="remember-me">
                            Ghi nhớ đăng nhập
                        </label>
                    </div>

                    <button type="submit" class="btn btn-primary btn-login">
                        <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                    </button>

                    <!-- CSRF Token -->
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                </form>

                <!-- Demo Accounts -->
                <div class="demo-accounts">
                    <h6><i class="fas fa-info-circle me-2"></i>Tài khoản demo:</h6>

                    <div class="demo-account">
                        <div>
                            <strong>admin</strong> / admin123
                        </div>
                        <span class="role-badge badge-admin">Admin</span>
                    </div>

                    <div class="demo-account">
                        <div>
                            <strong>instructor1</strong> / instructor123
                        </div>
                        <span class="role-badge badge-instructor">Giảng viên</span>
                    </div>

                    <div class="demo-account">
                        <div>
                            <strong>student1</strong> / student123
                        </div>
                        <span class="role-badge badge-student">Học viên</span>
                    </div>
                </div>

                <!-- Register Link -->
                <div class="register-link">
                    <p>Chưa có tài khoản?
                        <a href="/register">
                            <i class="fas fa-user-plus me-1"></i>Đăng ký ngay
                        </a>
                    </p>
                    <p>
                        <a href="/" class="text-muted">
                            <i class="fas fa-home me-1"></i>Về trang chủ
                        </a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Auto-focus on username field -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        document.getElementById('username').focus();
    });

    // Demo account quick fill
    document.querySelectorAll('.demo-account').forEach(function(account) {
        account.addEventListener('click', function() {
            const text = this.querySelector('div strong').textContent;
            const password = text.includes('admin') ? 'admin123' :
                text.includes('instructor') ? 'instructor123' : 'student123';

            document.getElementById('username').value = text;
            document.getElementById('password').value = password;
        });
    });
</script>
</body>
</html>