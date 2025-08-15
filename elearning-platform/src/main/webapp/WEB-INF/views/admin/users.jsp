<%-- File: src/main/webapp/WEB-INF/views/admin/users.jsp --%>
<%-- Tạo file JSP đơn giản để test trước khi làm phức tạp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Người Dùng - Admin</title>

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
                <h1 class="h2">Quản Lý Người Dùng</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="/admin/users/create" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Thêm người dùng
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

            <!-- Search form đơn giản -->
            <div class="card mb-3">
                <div class="card-body">
                    <form method="get" action="/admin/users" class="row g-3">
                        <div class="col-md-4">
                            <input type="text" class="form-control" name="search" placeholder="Tìm kiếm..." value="${search}">
                        </div>
                        <div class="col-md-3">
                            <select name="role" class="form-select">
                                <option value="">Tất cả vai trò</option>
                                <option value="ADMIN" ${selectedRole == 'ADMIN' ? 'selected' : ''}>Admin</option>
                                <option value="INSTRUCTOR" ${selectedRole == 'INSTRUCTOR' ? 'selected' : ''}>Giảng viên</option>
                                <option value="STUDENT" ${selectedRole == 'STUDENT' ? 'selected' : ''}>Học viên</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-search me-1"></i>Tìm
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Users table -->
            <div class="card">
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty users and not empty users.content}">
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead class="table-dark">
                                    <tr>
                                        <th>ID</th>
                                        <th>Tên đăng nhập</th>
                                        <th>Họ tên</th>
                                        <th>Email</th>
                                        <th>Vai trò</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="user" items="${users.content}">
                                        <tr>
                                            <td>${user.id}</td>
                                            <td>${user.username}</td>
                                            <td>${user.fullName}</td>
                                            <td>${user.email}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.role == 'ADMIN'}">
                                                        <span class="badge bg-danger">Admin</span>
                                                    </c:when>
                                                    <c:when test="${user.role == 'INSTRUCTOR'}">
                                                        <span class="badge bg-warning">Giảng viên</span>
                                                    </c:when>
                                                    <c:when test="${user.role == 'STUDENT'}">
                                                        <span class="badge bg-info">Học viên</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">${user.role}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.active}">
                                                        <span class="badge bg-success">Hoạt động</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Ngưng hoạt động</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="/admin/users/${user.id}" class="btn btn-sm btn-outline-primary">
                                                    <i class="fas fa-eye me-1"></i>Xem
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Pagination đơn giản -->
                            <c:if test="${users.totalPages > 1}">
                                <nav aria-label="Page navigation">
                                    <ul class="pagination justify-content-center">
                                        <c:if test="${!users.first}">
                                            <li class="page-item">
                                                <a class="page-link" href="?page=${users.number - 1}&search=${search}&role=${selectedRole}">Trước</a>
                                            </li>
                                        </c:if>

                                        <li class="page-item active">
                                            <span class="page-link">${users.number + 1} / ${users.totalPages}</span>
                                        </li>

                                        <c:if test="${!users.last}">
                                            <li class="page-item">
                                                <a class="page-link" href="?page=${users.number + 1}&search=${search}&role=${selectedRole}">Sau</a>
                                            </li>
                                        </c:if>
                                    </ul>
                                </nav>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">Không có người dùng nào</h5>
                                <p class="text-muted">Hãy thêm người dùng mới để bắt đầu</p>
                                <a href="/admin/users/create" class="btn btn-primary">
                                    <i class="fas fa-plus me-2"></i>Thêm người dùng đầu tiên
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>