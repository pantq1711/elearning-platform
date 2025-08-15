<%-- File: src/main/webapp/WEB-INF/views/admin/user-form.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Người Dùng - Admin</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>

<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar đơn giản -->
        <nav class="col-md-3 col-lg-2 d-md-block bg-dark sidebar">
            <div class="position-sticky pt-3">
                <div class="sidebar-header mb-3">
                    <h5 class="text-white">EduLearn Admin</h5>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link text-white" href="/admin/dashboard">
                            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white active" href="/admin/users">
                            <i class="fas fa-users me-2"></i>Người dùng
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="/admin/courses">
                            <i class="fas fa-book me-2"></i>Khóa học
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="/admin/categories">
                            <i class="fas fa-tags me-2"></i>Danh mục
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="/admin/analytics">
                            <i class="fas fa-chart-bar me-2"></i>Thống kê
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- Main content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Thêm Người Dùng Mới</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="/admin/users" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại
                    </a>
                </div>
            </div>

            <!-- Alert messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Form -->
            <div class="row">
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="fas fa-user-plus me-2"></i>Thông tin người dùng
                            </h5>
                        </div>
                        <div class="card-body">
                            <form:form method="post" action="/admin/users/create" modelAttribute="user" class="needs-validation" novalidate="true">
                                <div class="row">
                                    <!-- Username -->
                                    <div class="col-md-6 mb-3">
                                        <label for="username" class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
                                        <form:input path="username" cssClass="form-control" id="username" required="true" maxlength="50" />
                                        <form:errors path="username" cssClass="text-danger small" />
                                    </div>

                                    <!-- Email -->
                                    <div class="col-md-6 mb-3">
                                        <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                                        <form:input path="email" cssClass="form-control" type="email" id="email" required="true" maxlength="100" />
                                        <form:errors path="email" cssClass="text-danger small" />
                                    </div>
                                </div>

                                <div class="row">
                                    <!-- Họ tên -->
                                    <div class="col-md-6 mb-3">
                                        <label for="fullName" class="form-label">Họ và tên <span class="text-danger">*</span></label>
                                        <form:input path="fullName" cssClass="form-control" id="fullName" required="true" maxlength="100" />
                                        <form:errors path="fullName" cssClass="text-danger small" />
                                    </div>

                                    <!-- Số điện thoại -->
                                    <div class="col-md-6 mb-3">
                                        <label for="phoneNumber" class="form-label">Số điện thoại</label>
                                        <form:input path="phoneNumber" cssClass="form-control" id="phoneNumber" maxlength="15" />
                                        <form:errors path="phoneNumber" cssClass="text-danger small" />
                                    </div>
                                </div>

                                <div class="row">
                                    <!-- Mật khẩu -->
                                    <div class="col-md-6 mb-3">
                                        <label for="rawPassword" class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                                        <input type="password" class="form-control" id="rawPassword" name="rawPassword" required minlength="6" maxlength="50" />
                                        <div class="form-text">Tối thiểu 6 ký tự</div>
                                    </div>

                                    <!-- Vai trò -->
                                    <div class="col-md-6 mb-3">
                                        <label for="role" class="form-label">Vai trò <span class="text-danger">*</span></label>
                                        <form:select path="role" cssClass="form-select" id="role" required="true">
                                            <form:option value="">-- Chọn vai trò --</form:option>
                                            <c:forEach var="roleOption" items="${roles}">
                                                <form:option value="${roleOption}">
                                                    <c:choose>
                                                        <c:when test="${roleOption == 'ADMIN'}">Quản trị viên</c:when>
                                                        <c:when test="${roleOption == 'INSTRUCTOR'}">Giảng viên</c:when>
                                                        <c:when test="${roleOption == 'STUDENT'}">Học viên</c:when>
                                                        <c:otherwise>${roleOption}</c:otherwise>
                                                    </c:choose>
                                                </form:option>
                                            </c:forEach>
                                        </form:select>
                                        <form:errors path="role" cssClass="text-danger small" />
                                    </div>
                                </div>

                                <!-- Giới thiệu -->
                                <div class="mb-3">
                                    <label for="bio" class="form-label">Giới thiệu</label>
                                    <form:textarea path="bio" cssClass="form-control" id="bio" rows="3" maxlength="500" />
                                    <form:errors path="bio" cssClass="text-danger small" />
                                </div>

                                <!-- Checkboxes -->
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <div class="form-check">
                                            <form:checkbox path="active" cssClass="form-check-input" id="active" checked="true" />
                                            <label class="form-check-label" for="active">
                                                Kích hoạt tài khoản
                                            </label>
                                        </div>
                                    </div>
                                </div>

                                <!-- Action Buttons -->
                                <div class="d-flex gap-2 mt-4">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-2"></i>Tạo người dùng
                                    </button>
                                    <a href="/admin/users" class="btn btn-secondary">
                                        <i class="fas fa-arrow-left me-2"></i>Quay lại
                                    </a>
                                </div>
                            </form:form>
                        </div>
                    </div>
                </div>

                <!-- Info Card -->
                <div class="col-lg-4">
                    <div class="card">
                        <div class="card-header">
                            <h6 class="card-title mb-0">
                                <i class="fas fa-info-circle me-2"></i>Hướng dẫn
                            </h6>
                        </div>
                        <div class="card-body">
                            <ul class="list-unstyled small">
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Username phải duy nhất</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Email phải hợp lệ và duy nhất</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Mật khẩu tối thiểu 6 ký tự</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Chọn vai trò phù hợp</li>
                            </ul>

                            <div class="mt-3">
                                <h6>Vai trò:</h6>
                                <small class="text-muted">
                                    <strong>Admin:</strong> Toàn quyền quản lý hệ thống<br>
                                    <strong>Instructor:</strong> Tạo và quản lý khóa học<br>
                                    <strong>Student:</strong> Đăng ký học các khóa học
                                </small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Form validation
    (function() {
        'use strict';
        window.addEventListener('load', function() {
            var forms = document.getElementsByClassName('needs-validation');
            var validation = Array.prototype.filter.call(forms, function(form) {
                form.addEventListener('submit', function(event) {
                    if (form.checkValidity() === false) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        }, false);
    })();
</script>
</body>
</html>