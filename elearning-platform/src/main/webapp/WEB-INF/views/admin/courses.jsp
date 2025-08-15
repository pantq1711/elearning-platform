<%-- File: src/main/webapp/WEB-INF/views/admin/courses.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Khóa Học - Admin</title>

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
                        <a class="nav-link text-white" href="/admin/users">
                            <i class="fas fa-users me-2"></i>Người dùng
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white active" href="/admin/courses">
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
                <h1 class="h2">Quản Lý Khóa Học</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="/instructor/courses/create" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Thêm khóa học
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
                    <form method="get" action="/admin/courses" class="row g-3">
                        <div class="col-md-4">
                            <input type="text" class="form-control" name="search" placeholder="Tìm kiếm khóa học..." value="${search}">
                        </div>
                        <div class="col-md-3">
                            <select name="category" class="form-select">
                                <option value="">Tất cả danh mục</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.id}" ${selectedCategory == cat.id ? 'selected' : ''}>${cat.name}</option>
                                </c:forEach>
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

            <!-- Courses table -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-list me-2"></i>Danh sách khóa học
                    </h5>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty courses and not empty courses.content}">
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead class="table-dark">
                                    <tr>
                                        <th>ID</th>
                                        <th>Tên khóa học</th>
                                        <th>Danh mục</th>
                                        <th>Giảng viên</th>
                                        <th>Giá</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="course" items="${courses.content}">
                                        <tr>
                                            <td>${course.id}</td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <div class="course-thumbnail me-3" style="width: 50px; height: 50px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 8px; display: flex; align-items: center; justify-content: center;">
                                                        <i class="fas fa-book text-white"></i>
                                                    </div>
                                                    <div>
                                                        <strong>${course.name}</strong>
                                                        <c:if test="${course.featured}">
                                                            <span class="badge bg-warning ms-2">Nổi bật</span>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty course.category}">
                                                        <c:choose>
                                                            <c:when test="${not empty course.category.name}">
                                                                <span class="badge bg-info">${course.category.name}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">Chưa phân loại</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Chưa phân loại</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty course.instructor}">
                                                        <c:choose>
                                                            <c:when test="${not empty course.instructor.fullName}">
                                                                ${course.instructor.fullName}
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${course.instructor.username}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <em class="text-muted">Chưa có giảng viên</em>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${course.price == null or course.price == 0}">
                                                        <span class="badge bg-success">Miễn phí</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-primary fw-bold">${course.formattedPrice}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${course.active}">
                                                        <span class="badge bg-success">Đã xuất bản</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Bản nháp</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <a href="/admin/courses/${course.id}" class="btn btn-sm btn-outline-primary">
                                                        <i class="fas fa-eye me-1"></i>Xem
                                                    </a>
                                                    <a href="/instructor/courses/${course.id}/edit" class="btn btn-sm btn-outline-warning">
                                                        <i class="fas fa-edit me-1"></i>Sửa
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Pagination đơn giản -->
                            <c:if test="${courses.totalPages > 1}">
                                <nav aria-label="Page navigation">
                                    <ul class="pagination justify-content-center">
                                        <c:if test="${!courses.first}">
                                            <li class="page-item">
                                                <a class="page-link" href="?page=${courses.number - 1}&search=${search}">Trước</a>
                                            </li>
                                        </c:if>

                                        <li class="page-item active">
                                            <span class="page-link">${courses.number + 1} / ${courses.totalPages}</span>
                                        </li>

                                        <c:if test="${!courses.last}">
                                            <li class="page-item">
                                                <a class="page-link" href="?page=${courses.number + 1}&search=${search}">Sau</a>
                                            </li>
                                        </c:if>
                                    </ul>
                                </nav>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="fas fa-book fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">Chưa có khóa học nào</h5>
                                <p class="text-muted">Hãy tạo khóa học đầu tiên để bắt đầu</p>
                                <a href="/instructor/courses/create" class="btn btn-primary">
                                    <i class="fas fa-plus me-2"></i>Tạo khóa học đầu tiên
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