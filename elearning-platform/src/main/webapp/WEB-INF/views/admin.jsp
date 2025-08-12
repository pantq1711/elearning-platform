<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - Hệ thống Quản lý Khóa học</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --info-color: #17a2b8;
        }

        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }

        .sidebar .nav-link {
            color: rgba(255,255,255,0.8);
            padding: 15px 20px;
            border-radius: 0;
            transition: all 0.3s ease;
        }

        .sidebar .nav-link:hover {
            background-color: rgba(255,255,255,0.1);
            color: white;
            transform: translateX(5px);
        }

        .sidebar .nav-link.active {
            background-color: rgba(255,255,255,0.2);
            color: white;
        }

        .main-content {
            padding: 20px;
        }

        .stats-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            height: 100%;
        }

        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }

        .stats-icon {
            width: 60px;
            height: 60px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
            margin-bottom: 15px;
        }

        .stats-number {
            font-size: 2rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 5px;
        }

        .stats-label {
            color: #666;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .card-custom {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }

        .card-header-custom {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            border-radius: 15px 15px 0 0 !important;
            padding: 20px;
            border: none;
        }

        .table-custom {
            border-radius: 10px;
            overflow: hidden;
        }

        .table-custom thead {
            background-color: #f8f9fa;
        }

        .badge-role {
            padding: 8px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .badge-admin { background-color: var(--danger-color); }
        .badge-instructor { background-color: var(--success-color); }
        .badge-student { background-color: var(--info-color); }
        .badge-active { background-color: var(--success-color); }
        .badge-inactive { background-color: var(--warning-color); color: #333; }

        .chart-container {
            position: relative;
            height: 300px;
            width: 100%;
        }

        .progress-custom {
            height: 8px;
            border-radius: 10px;
        }

        .quick-action-btn {
            width: 100%;
            padding: 15px;
            border-radius: 10px;
            border: 2px solid #e9ecef;
            background: white;
            color: #666;
            transition: all 0.3s ease;
            text-decoration: none;
            display: block;
            margin-bottom: 10px;
        }

        .quick-action-btn:hover {
            border-color: var(--primary-color);
            background-color: var(--primary-color);
            color: white;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-md-3 col-lg-2 sidebar">
            <div class="py-4">
                <h4 class="text-white text-center mb-4">
                    <i class="fas fa-graduation-cap me-2"></i>
                    CourseHub
                </h4>

                <div class="text-center text-white mb-4">
                    <i class="fas fa-user-shield fa-2x mb-2"></i>
                    <div>Xin chào, <strong>${currentUser.username}</strong></div>
                    <small class="text-white-50">Quản trị viên</small>
                </div>

                <nav class="nav flex-column">
                    <a class="nav-link active" href="/admin/dashboard">
                        <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                    </a>
                    <a class="nav-link" href="/admin/users">
                        <i class="fas fa-users me-2"></i>Quản lý Người dùng
                    </a>
                    <a class="nav-link" href="/admin/categories">
                        <i class="fas fa-tags me-2"></i>Quản lý Danh mục
                    </a>
                    <a class="nav-link" href="/admin/courses">
                        <i class="fas fa-book me-2"></i>Quản lý Khóa học
                    </a>
                    <hr class="my-3 bg-white">
                    <a class="nav-link" href="/profile">
                        <i class="fas fa-user me-2"></i>Hồ sơ cá nhân
                    </a>
                    <a class="nav-link" href="/logout">
                        <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                    </a>
                </nav>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col-md-9 col-lg-10 main-content">
            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-tachometer-alt me-3"></i>Dashboard Admin</h2>
                <div class="text-muted">
                    <i class="fas fa-calendar me-1"></i>
                    <fmt:formatDate value="${now}" pattern="dd/MM/yyyy HH:mm" />
                </div>
            </div>

            <!-- Statistics Cards -->
            <div class="row mb-4">
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card">
                        <div class="stats-icon" style="background: linear-gradient(45deg, #667eea, #764ba2);">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stats-number">${totalUsers}</div>
                        <div class="stats-label">Tổng số người dùng</div>
                        <div class="mt-2">
                            <small class="text-success">
                                <i class="fas fa-arrow-up me-1"></i>
                                12% từ tháng trước
                            </small>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card">
                        <div class="stats-icon" style="background: linear-gradient(45deg, #28a745, #20c997);">
                            <i class="fas fa-graduation-cap"></i>
                        </div>
                        <div class="stats-number">${totalStudents}</div>
                        <div class="stats-label">Học viên</div>
                        <div class="mt-2">
                            <small class="text-success">
                                <i class="fas fa-arrow-up me-1"></i>
                                8% từ tháng trước
                            </small>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card">
                        <div class="stats-icon" style="background: linear-gradient(45deg, #fd7e14, #e83e8c);">
                            <i class="fas fa-chalkboard-teacher"></i>
                        </div>
                        <div class="stats-number">${totalInstructors}</div>
                        <div class="stats-label">Giảng viên</div>
                        <div class="mt-2">
                            <small class="text-success">
                                <i class="fas fa-arrow-up me-1"></i>
                                5% từ tháng trước
                            </small>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card">
                        <div class="stats-icon" style="background: linear-gradient(45deg, #6f42c1, #e83e8c);">
                            <i class="fas fa-book-open"></i>
                        </div>
                        <div class="stats-number">${totalCourses}</div>
                        <div class="stats-label">Khóa học</div>
                        <div class="mt-2">
                            <small class="text-info">
                                <i class="fas fa-eye me-1"></i>
                                ${activeCourses} đang hoạt động
                            </small>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <!-- Recent Users -->
                <div class="col-lg-8 mb-4">
                    <div class="card card-custom">
                        <div class="card-header card-header-custom">
                            <h5 class="mb-0">
                                <i class="fas fa-user-plus me-2"></i>
                                Người dùng mới đăng ký
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-custom">
                                    <thead>
                                    <tr>
                                        <th>Tên đăng nhập</th>
                                        <th>Email</th>
                                        <th>Vai trò</th>
                                        <th>Trạng thái</th>
                                        <th>Ngày tạo</th>
                                        <th>Thao tác</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${recentUsers}" var="user">
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <div class="avatar-sm me-2">
                                                        <i class="fas fa-user-circle fa-2x text-muted"></i>
                                                    </div>
                                                    <strong>${user.username}</strong>
                                                </div>
                                            </td>
                                            <td>${user.email}</td>
                                            <td>
                                                        <span class="badge badge-role badge-${user.role.name().toLowerCase()}">
                                                                ${user.role.displayName}
                                                        </span>
                                            </td>
                                            <td>
                                                        <span class="badge badge-${user.active ? 'active' : 'inactive'}">
                                                                ${user.active ? 'Hoạt động' : 'Không hoạt động'}
                                                        </span>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy" />
                                            </td>
                                            <td>
                                                <a href="/admin/users/${user.id}/edit" class="btn btn-sm btn-outline-primary">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <div class="text-center mt-3">
                                <a href="/admin/users" class="btn btn-outline-primary">
                                    Xem tất cả người dùng <i class="fas fa-arrow-right ms-2"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions & Stats -->
                <div class="col-lg-4 mb-4">
                    <div class="card card-custom mb-4">
                        <div class="card-header card-header-custom">
                            <h5 class="mb-0">
                                <i class="fas fa-bolt me-2"></i>
                                Thao tác nhanh
                            </h5>
                        </div>
                        <div class="card-body">
                            <a href="/admin/users/new" class="quick-action-btn">
                                <i class="fas fa-user-plus me-2"></i>
                                Thêm người dùng mới
                            </a>
                            <a href="/admin/categories/new" class="quick-action-btn">
                                <i class="fas fa-plus me-2"></i>
                                Thêm danh mục mới
                            </a>
                            <a href="/admin/courses" class="quick-action-btn">
                                <i class="fas fa-search me-2"></i>
                                Duyệt khóa học
                            </a>
                            <a href="/admin/reports" class="quick-action-btn">
                                <i class="fas fa-chart-bar me-2"></i>
                                Xem báo cáo
                            </a>
                        </div>
                    </div>

                    <!-- Category Statistics -->
                    <div class="card card-custom">
                        <div class="card-header card-header-custom">
                            <h5 class="mb-0">
                                <i class="fas fa-chart-pie me-2"></i>
                                Thống kê danh mục
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="categoryChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Popular Courses -->
            <div class="row">
                <div class="col-12">
                    <div class="card card-custom">
                        <div class="card-header card-header-custom">
                            <h5 class="mb-0">
                                <i class="fas fa-star me-2"></i>
                                Khóa học phổ biến nhất
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <c:forEach items="${popularCourses}" var="course" varStatus="status">
                                    <div class="col-md-4 mb-3">
                                        <div class="d-flex align-items-center p-3 bg-light rounded">
                                            <div class="me-3">
                                                <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center" style="width: 50px; height: 50px;">
                                                    <i class="fas fa-book"></i>
                                                </div>
                                            </div>
                                            <div class="flex-grow-1">
                                                <h6 class="mb-1">${course.name}</h6>
                                                <small class="text-muted">
                                                    <i class="fas fa-user me-1"></i>${course.instructor.username}
                                                    <span class="ms-2">
                                                            <i class="fas fa-users me-1"></i>${course.enrollmentCount} học viên
                                                        </span>
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Chart.js Script -->
<script>
    // Category Chart
    const ctx = document.getElementById('categoryChart').getContext('2d');

    // Sample data - trong thực tế sẽ lấy từ server
    const categoryData = {
        labels: [
            <c:forEach items="${categoryStats}" var="stat" varStatus="status">
            '${stat[0].name}'<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ],
        datasets: [{
            data: [
                <c:forEach items="${categoryStats}" var="stat" varStatus="status">
                ${stat[1]}<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ],
            backgroundColor: [
                '#667eea',
                '#764ba2',
                '#f093fb',
                '#f5576c',
                '#4facfe',
                '#00f2fe'
            ],
            borderWidth: 2,
            borderColor: '#fff'
        }]
    };

    new Chart(ctx, {
        type: 'doughnut',
        data: categoryData,
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return context.label + ': ' + context.parsed + ' khóa học';
                        }
                    }
                }
            }
        }
    });

    // Auto refresh page every 5 minutes
    setTimeout(function(){
        location.reload();
    }, 300000);
</script>
</body>
</html>