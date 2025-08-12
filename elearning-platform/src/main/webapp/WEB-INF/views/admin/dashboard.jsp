<%--
===============================
ADMIN DASHBOARD
===============================
File: /WEB-INF/views/admin/dashboard.jsp
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="Admin Dashboard" />
<c:set var="currentPage" value="admin-dashboard" />
<c:set var="bodyClass" value="admin-layout" />

<div class="admin-dashboard">
    <%-- Dashboard Header --%>
    <div class="dashboard-header mb-4">
        <div class="row align-items-center">
            <div class="col">
                <h1 class="h3 mb-0 text-gray-800">
                    <i class="fas fa-tachometer-alt me-2"></i>
                    Dashboard Quản Trị
                </h1>
                <p class="text-muted mb-0">Tổng quan hệ thống e-learning</p>
            </div>
            <div class="col-auto">
                <div class="d-flex gap-2">
                    <button class="btn btn-outline-primary" onclick="refreshData()">
                        <i class="fas fa-sync-alt me-1"></i>Làm mới
                    </button>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#quickActionModal">
                        <i class="fas fa-plus me-1"></i>Thao tác nhanh
                    </button>
                </div>
            </div>
        </div>
    </div>

    <%-- Statistics Cards --%>
    <div class="row mb-4">
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-primary shadow h-100 py-2 stats-card">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                Tổng người dùng
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <fmt:formatNumber value="${totalUsers}" />
                            </div>
                            <div class="text-success small">
                                <i class="fas fa-arrow-up"></i> +12% so với tháng trước
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-users fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-success shadow h-100 py-2 stats-card">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                Khóa học
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <fmt:formatNumber value="${totalCourses}" />
                            </div>
                            <div class="text-info small">
                                <fmt:formatNumber value="${activeCourses}" /> đang hoạt động
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-book fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-info shadow h-100 py-2 stats-card">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                Đăng ký khóa học
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <fmt:formatNumber value="${totalEnrollments}" />
                            </div>
                            <div class="row no-gutters align-items-center">
                                <div class="col-auto">
                                    <div class="h5 mb-0 mr-3 font-weight-bold text-gray-800">
                                        ${completionRate}%
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="progress progress-sm mr-2">
                                        <div class="progress-bar bg-info" role="progressbar"
                                             style="width: ${completionRate}%"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-clipboard-list fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-warning shadow h-100 py-2 stats-card">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                Doanh thu
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <fmt:formatNumber value="${totalRevenue}" type="currency"
                                                  currencySymbol="₫" maxFractionDigits="0" />
                            </div>
                            <div class="text-warning small">
                                <i class="fas fa-arrow-up"></i> +8% so với tháng trước
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-dollar-sign fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- Charts Row --%>
    <div class="row mb-4">
        <%-- Enrollment Chart --%>
        <div class="col-xl-8 col-lg-7">
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-chart-area me-2"></i>
                        Thống kê đăng ký theo tháng
                    </h6>
                    <div class="dropdown no-arrow">
                        <a class="dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-ellipsis-v fa-sm fa-fw text-gray-400"></i>
                        </a>
                        <div class="dropdown-menu dropdown-menu-right shadow">
                            <a class="dropdown-item" href="#" onclick="exportChart('enrollment')">Xuất Excel</a>
                            <a class="dropdown-item" href="#" onclick="printChart('enrollment')">In biểu đồ</a>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="chart-area">
                        <canvas id="enrollmentChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <%-- Course Categories Pie Chart --%>
        <div class="col-xl-4 col-lg-5">
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-chart-pie me-2"></i>
                        Phân bố danh mục
                    </h6>
                </div>
                <div class="card-body">
                    <div class="chart-pie pt-4 pb-2">
                        <canvas id="categoryChart"></canvas>
                    </div>
                    <div class="mt-4 text-center small">
                        <c:forEach var="stat" items="${categoryStats}" varStatus="status">
                            <span class="mr-2">
                                <i class="fas fa-circle" style="color: ${stat.color}"></i> ${stat.name}
                            </span>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- Recent Activities & Popular Courses --%>
    <div class="row">
        <%-- Recent Users --%>
        <div class="col-lg-6 mb-4">
            <div class="card shadow">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-users me-2"></i>
                        Người dùng mới
                    </h6>
                    <a href="/admin/users" class="btn btn-sm btn-primary">Xem tất cả</a>
                </div>
                <div class="card-body">
                    <c:forEach var="user" items="${recentUsers}">
                        <div class="d-flex align-items-center py-2">
                            <div class="mr-3">
                                <img src="${user.profileImageUrl}" alt="Avatar"
                                     class="rounded-circle" width="40" height="40"
                                     onerror="this.src='/images/default-avatar.png'">
                            </div>
                            <div class="flex-grow-1">
                                <div class="fw-bold">${user.fullName}</div>
                                <div class="text-muted small">
                                    <span class="badge bg-${user.role == 'STUDENT' ? 'info' : user.role == 'INSTRUCTOR' ? 'success' : 'primary'}">
                                            ${user.role}
                                    </span>
                                    - <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy" />
                                </div>
                            </div>
                            <div>
                                <span class="badge bg-${user.active ? 'success' : 'secondary'}">
                                        ${user.active ? 'Hoạt động' : 'Không hoạt động'}
                                </span>
                            </div>
                        </div>
                        <c:if test="${!status.last}"><hr class="my-2"></c:if>
                    </c:forEach>
                </div>
            </div>
        </div>

        <%-- Popular Courses --%>
        <div class="col-lg-6 mb-4">
            <div class="card shadow">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-fire me-2"></i>
                        Khóa học phổ biến
                    </h6>
                    <a href="/admin/courses" class="btn btn-sm btn-primary">Xem tất cả</a>
                </div>
                <div class="card-body">
                    <c:forEach var="course" items="${popularCourses}" varStatus="status">
                        <div class="d-flex align-items-center py-2">
                            <div class="mr-3">
                                <img src="${course.imageUrl}" alt="Course"
                                     class="rounded" width="50" height="40"
                                     onerror="this.src='/images/default-course.png'">
                            </div>
                            <div class="flex-grow-1">
                                <div class="fw-bold">${course.name}</div>
                                <div class="text-muted small">
                                    Giảng viên: ${course.instructor.fullName}
                                </div>
                                <div class="text-muted small">
                                    <i class="fas fa-users me-1"></i>
                                        ${course.enrollmentCount} học viên
                                </div>
                            </div>
                            <div class="text-end">
                                <div class="fw-bold text-${course.price > 0 ? 'success' : 'info'}">
                                    <c:choose>
                                        <c:when test="${course.price > 0}">
                                            <fmt:formatNumber value="${course.price}" type="currency"
                                                              currencySymbol="₫" maxFractionDigits="0" />
                                        </c:when>
                                        <c:otherwise>Miễn phí</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="small">
                                    <span class="badge bg-${course.featured ? 'warning' : 'secondary'}">
                                            ${course.featured ? 'Nổi bật' : 'Thường'}
                                    </span>
                                </div>
                            </div>
                        </div>
                        <c:if test="${!status.last}"><hr class="my-2"></c:if>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <%-- System Alerts --%>
    <div class="row">
        <div class="col-12">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        Cảnh báo hệ thống
                    </h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="alert alert-warning mb-2" role="alert">
                                <i class="fas fa-database me-2"></i>
                                <strong>Dung lượng DB:</strong> 85% (4.2GB/5GB)
                                <a href="/admin/maintenance" class="alert-link">Dọn dẹp</a>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="alert alert-info mb-2" role="alert">
                                <i class="fas fa-clock me-2"></i>
                                <strong>Backup cuối:</strong> 2 ngày trước
                                <a href="/admin/backup" class="alert-link">Backup ngay</a>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="alert alert-success mb-2" role="alert">
                                <i class="fas fa-check-circle me-2"></i>
                                <strong>Hệ thống:</strong> Hoạt động bình thường
                                <span class="badge bg-success">99.9% uptime</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- Quick Action Modal --%>
<div class="modal fade" id="quickActionModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-bolt me-2"></i>Thao tác nhanh
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row g-3">
                    <div class="col-6">
                        <a href="/admin/users/new" class="btn btn-outline-primary w-100">
                            <i class="fas fa-user-plus d-block mb-2 fa-2x"></i>
                            Thêm người dùng
                        </a>
                    </div>
                    <div class="col-6">
                        <a href="/admin/categories/new" class="btn btn-outline-success w-100">
                            <i class="fas fa-tag d-block mb-2 fa-2x"></i>
                            Thêm danh mục
                        </a>
                    </div>
                    <div class="col-6">
                        <a href="/admin/courses" class="btn btn-outline-info w-100">
                            <i class="fas fa-book d-block mb-2 fa-2x"></i>
                            Duyệt khóa học
                        </a>
                    </div>
                    <div class="col-6">
                        <a href="/admin/reports" class="btn btn-outline-warning w-100">
                            <i class="fas fa-chart-bar d-block mb-2 fa-2x"></i>
                            Xem báo cáo
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Chart configurations và JavaScript functions cho admin dashboard
    document.addEventListener('DOMContentLoaded', function() {
        // Enrollment Chart
        const enrollmentCtx = document.getElementById('enrollmentChart').getContext('2d');
        new Chart(enrollmentCtx, {
            type: 'line',
            data: {
                labels: ${enrollmentChartLabels},
                datasets: [{
                    label: 'Đăng ký mới',
                    data: ${enrollmentChartData},
                    borderColor: '#4e73df',
                    backgroundColor: 'rgba(78, 115, 223, 0.1)',
                    borderWidth: 2,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });

        // Category Chart
        const categoryCtx = document.getElementById('categoryChart').getContext('2d');
        new Chart(categoryCtx, {
            type: 'doughnut',
            data: {
                labels: ${categoryChartLabels},
                datasets: [{
                    data: ${categoryChartData},
                    backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc', '#f6c23e', '#e74a3b', '#858796']
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });

        // Auto refresh mỗi 5 phút
        setInterval(function() {
            refreshData();
        }, 300000);
    });

    function refreshData() {
        // Show loading spinner
        document.body.style.cursor = 'wait';

        // Reload page hoặc fetch data mới qua AJAX
        location.reload();
    }

    function exportChart(chartType) {
        // Export chart data to Excel
        console.log('Exporting chart:', chartType);
    }

    function printChart(chartType) {
        // Print chart
        window.print();
    }
</script>

<%--
===============================
INSTRUCTOR DASHBOARD
===============================
File: /WEB-INF/views/instructor/dashboard.jsp
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Instructor Dashboard" />
<c:set var="currentPage" value="instructor-dashboard" />
<c:set var="bodyClass" value="instructor-layout" />

<div class="instructor-dashboard">
    <%-- Welcome Header --%>
    <div class="dashboard-header mb-4">
        <div class="row align-items-center">
            <div class="col">
                <h1 class="h3 mb-0">
                    <i class="fas fa-chalkboard-teacher me-2"></i>
                    Chào mừng, ${currentUser.fullName}!
                </h1>
                <p class="text-muted mb-0">Hôm nay bạn có ${newStudents} học viên mới và ${pendingQuizzes} quiz cần chấm</p>
            </div>
            <div class="col-auto">
                <a href="/instructor/courses/new" class="btn btn-primary">
                    <i class="fas fa-plus me-1"></i>Tạo khóa học mới
                </a>
            </div>
        </div>
    </div>

    <%-- Quick Stats --%>
    <div class="row mb-4">
        <div class="col-lg-3 col-md-6 mb-4">
            <div class="card bg-gradient-primary text-white shadow">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-white-50 text-uppercase mb-1">
                                Khóa học của tôi
                            </div>
                            <div class="h5 mb-0 font-weight-bold">
                                ${myCourses}
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-book fa-2x text-white-50"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-3 col-md-6 mb-4">
            <div class="card bg-gradient-success text-white shadow">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-white-50 text-uppercase mb-1">
                                Tổng học viên
                            </div>
                            <div class="h5 mb-0 font-weight-bold">
                                ${totalStudents}
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-user-graduate fa-2x text-white-50"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-3 col-md-6 mb-4">
            <div class="card bg-gradient-info text-white shadow">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-white-50 text-uppercase mb-1">
                                Đánh giá trung bình
                            </div>
                            <div class="h5 mb-0 font-weight-bold">
                                ${averageRating}/5.0
                                <div class="text-white-50 small">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="fas fa-star ${i <= averageRating ? '' : 'text-white-25'}"></i>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-star fa-2x text-white-50"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-3 col-md-6 mb-4">
            <div class="card bg-gradient-warning text-white shadow">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-white-50 text-uppercase mb-1">
                                Thu nhập tháng này
                            </div>
                            <div class="h5 mb-0 font-weight-bold">
                                <fmt:formatNumber value="${monthlyEarnings}" type="currency"
                                                  currencySymbol="₫" maxFractionDigits="0" />
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-dollar-sign fa-2x text-white-50"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- Charts & Course Performance --%>
    <div class="row mb-4">
        <%-- Course Performance Chart --%>
        <div class="col-xl-8 col-lg-7">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-chart-area me-2"></i>
                        Hiệu suất khóa học 30 ngày qua
                    </h6>
                </div>
                <div class="card-body">
                    <div class="chart-area">
                        <canvas id="coursePerformanceChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <%-- Student Progress --%>
        <div class="col-xl-4 col-lg-5">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-graduation-cap me-2"></i>
                        Tiến độ học viên
                    </h6>
                </div>
                <div class="card-body">
                    <c:forEach var="progress" items="${studentProgress}" varStatus="status">
                        <div class="mb-3">
                            <div class="small text-gray-500">${progress.courseName}</div>
                            <div class="progress">
                                <div class="progress-bar bg-${progress.percentage >= 80 ? 'success' : progress.percentage >= 50 ? 'warning' : 'danger'}"
                                     role="progressbar" style="width: ${progress.percentage}%"
                                     aria-valuenow="${progress.percentage}" aria-valuemin="0" aria-valuemax="100">
                                        ${progress.percentage}%
                                </div>
                            </div>
                            <div class="small text-muted">${progress.completedStudents}/${progress.totalStudents} hoàn thành</div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <%-- My Courses & Recent Activities --%>
    <div class="row">
        <%-- Recent Courses --%>
        <div class="col-lg-8 mb-4">
            <div class="card shadow">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-book me-2"></i>
                        Khóa học của tôi
                    </h6>
                    <a href="/instructor/courses" class="btn btn-sm btn-primary">Xem tất cả</a>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                            <tr>
                                <th>Khóa học</th>
                                <th>Học viên</th>
                                <th>Trạng thái</th>
                                <th>Cập nhật</th>
                                <th>Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="course" items="${myCoursesList}">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="${course.imageUrl}" alt="Course"
                                                 class="rounded me-3" width="40" height="30"
                                                 onerror="this.src='/images/default-course.png'">
                                            <div>
                                                <div class="fw-bold">${course.name}</div>
                                                <div class="text-muted small">${course.category.name}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge bg-info">${course.enrollmentCount}</span>
                                    </td>
                                    <td>
                                            <span class="badge bg-${course.active ? 'success' : 'secondary'}">
                                                    ${course.active ? 'Đang mở' : 'Đã đóng'}
                                            </span>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${course.updatedAt}" pattern="dd/MM/yyyy" />
                                    </td>
                                    <td>
                                        <div class="btn-group btn-group-sm" role="group">
                                            <a href="/instructor/courses/${course.id}" class="btn btn-outline-primary">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="/instructor/courses/${course.id}/edit" class="btn btn-outline-success">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="/instructor/courses/${course.id}/lessons" class="btn btn-outline-info">
                                                <i class="fas fa-list"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <%-- Recent Activities --%>
        <div class="col-lg-4 mb-4">
            <div class="card shadow">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-clock me-2"></i>
                        Hoạt động gần đây
                    </h6>
                </div>
                <div class="card-body">
                    <div class="timeline">
                        <c:forEach var="activity" items="${recentActivities}">
                            <div class="timeline-item">
                                <div class="timeline-marker bg-${activity.type == 'NEW_ENROLLMENT' ? 'success' : activity.type == 'QUIZ_SUBMITTED' ? 'info' : 'warning'}"></div>
                                <div class="timeline-content">
                                    <h6 class="timeline-title">${activity.title}</h6>
                                    <p class="timeline-text">${activity.description}</p>
                                    <small class="text-muted">
                                        <i class="fas fa-clock me-1"></i>
                                        <fmt:formatDate value="${activity.createdAt}" pattern="HH:mm dd/MM" />
                                    </small>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Course Performance Chart
        const ctx = document.getElementById('coursePerformanceChart').getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: ${performanceChartLabels},
                datasets: [{
                    label: 'Đăng ký mới',
                    data: ${enrollmentData},
                    borderColor: '#4e73df',
                    backgroundColor: 'rgba(78, 115, 223, 0.1)',
                    borderWidth: 2,
                    fill: true
                }, {
                    label: 'Hoàn thành',
                    data: ${completionData},
                    borderColor: '#1cc88a',
                    backgroundColor: 'rgba(28, 200, 138, 0.1)',
                    borderWidth: 2,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top'
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    });
</script>

<%--
===============================
STUDENT DASHBOARD
===============================
File: /WEB-INF/views/student/dashboard.jsp
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Student Dashboard" />
<c:set var="currentPage" value="student-dashboard" />
<c:set var="bodyClass" value="student-layout" />

<div class="student-dashboard">
    <%-- Welcome Header --%>
    <div class="dashboard-header mb-4">
        <div class="row align-items-center">
            <div class="col">
                <h1 class="h3 mb-0">
                    <i class="fas fa-user-graduate me-2"></i>
                    Xin chào, ${currentUser.fullName}!
                </h1>
                <p class="text-muted mb-0">Hôm nay là ngày tuyệt vời để học thêm điều gì đó mới 🚀</p>
            </div>
            <div class="col-auto">
                <a href="/student/courses" class="btn btn-primary">
                    <i class="fas fa-search me-1"></i>Tìm khóa học mới
                </a>
            </div>
        </div>
    </div>

    <%-- Learning Stats --%>
    <div class="row mb-4">
        <div class="col-lg-3 col-md-6 mb-4">
            <div class="card bg-gradient-primary text-white shadow">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-white-50 text-uppercase mb-1">
                                Khóa học đang học
                            </div>
                            <div class="h5 mb-0 font-weight-bold">
                                ${enrollmentStats.activeEnrollments}
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-book-open fa-2x text-white-50"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-3 col-md-6 mb-4">
            <div class="card bg-gradient-success text-white shadow">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-white-50 text-uppercase mb-1">
                                Đã hoàn thành
                            </div>
                            <div class="h5 mb-0 font-weight-bold">
                                ${enrollmentStats.completedEnrollments}
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-check-circle fa-2x text-white-50"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-3 col-md-6 mb-4">
            <div class="card bg-gradient-info text-white shadow">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-white-50 text-uppercase mb-1">
                                Chứng chỉ đạt được
                            </div>
                            <div class="h5 mb-0 font-weight-bold">
                                ${enrollmentStats.certificatesEarned}
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-certificate fa-2x text-white-50"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-3 col-md-6 mb-4">
            <div class="card bg-gradient-warning text-white shadow">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-white-50 text-uppercase mb-1">
                                Thời gian học tuần này
                            </div>
                            <div class="h5 mb-0 font-weight-bold">
                                ${enrollmentStats.weeklyStudyHours}h
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-clock fa-2x text-white-50"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- Continue Learning & Progress --%>
    <div class="row mb-4">
        <%-- Continue Learning --%>
        <div class="col-lg-8 mb-4">
            <div class="card shadow">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-play me-2"></i>
                        Tiếp tục học tập
                    </h6>
                </div>
                <div class="card-body">
                    <c:forEach var="enrollment" items="${activeEnrollments}" varStatus="status">
                        <div class="course-continue-item mb-3 p-3 border rounded">
                            <div class="row align-items-center">
                                <div class="col-md-2">
                                    <img src="${enrollment.course.imageUrl}" alt="Course"
                                         class="img-fluid rounded"
                                         onerror="this.src='/images/default-course.png'">
                                </div>
                                <div class="col-md-6">
                                    <h5 class="mb-1">${enrollment.course.name}</h5>
                                    <p class="text-muted mb-2">${enrollment.course.instructor.fullName}</p>
                                    <div class="progress mb-2">
                                        <div class="progress-bar bg-success" role="progressbar"
                                             style="width: ${enrollment.progress}%"
                                             aria-valuenow="${enrollment.progress}" aria-valuemin="0" aria-valuemax="100">
                                                ${enrollment.progress}%
                                        </div>
                                    </div>
                                    <small class="text-muted">
                                        Bài tiếp theo: ${enrollment.nextLesson.title}
                                    </small>
                                </div>
                                <div class="col-md-4 text-md-end">
                                    <div class="mb-2">
                                        <span class="badge bg-${enrollment.course.difficultyLevel == 'BEGINNER' ? 'success' : enrollment.course.difficultyLevel == 'INTERMEDIATE' ? 'warning' : 'danger'}">
                                                ${enrollment.course.difficultyLevel == 'BEGINNER' ? 'Cơ bản' : enrollment.course.difficultyLevel == 'INTERMEDIATE' ? 'Trung bình' : 'Nâng cao'}
                                        </span>
                                    </div>
                                    <a href="/student/my-courses/${enrollment.course.id}/lessons/${enrollment.nextLesson.id}"
                                       class="btn btn-primary">
                                        <i class="fas fa-play me-1"></i>Tiếp tục học
                                    </a>
                                </div>
                            </div>
                        </div>
                        <c:if test="${!status.last}"><hr></c:if>
                    </c:forEach>

                    <c:if test="${empty activeEnrollments}">
                        <div class="text-center py-5">
                            <i class="fas fa-book-open fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">Bạn chưa đăng ký khóa học nào</h5>
                            <p class="text-muted">Hãy bắt đầu hành trình học tập của bạn ngay bây giờ!</p>
                            <a href="/student/courses" class="btn btn-primary">
                                <i class="fas fa-search me-1"></i>Khám phá khóa học
                            </a>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <%-- Quick Actions & Achievements --%>
        <div class="col-lg-4 mb-4">
            <%-- Quick Actions --%>
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-bolt me-2"></i>
                        Thao tác nhanh
                    </h6>
                </div>
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <a href="/student/courses" class="btn btn-outline-primary">
                            <i class="fas fa-search me-2"></i>Tìm khóa học
                        </a>
                        <a href="/student/my-courses" class="btn btn-outline-success">
                            <i class="fas fa-book me-2"></i>Khóa học của tôi
                        </a>
                        <a href="/student/certificates" class="btn btn-outline-info">
                            <i class="fas fa-certificate me-2"></i>Chứng chỉ
                        </a>
                        <a href="/student/progress" class="btn btn-outline-warning">
                            <i class="fas fa-chart-line me-2"></i>Tiến độ học tập
                        </a>
                    </div>
                </div>
            </div>

            <%-- Recent Achievements --%>
            <div class="card shadow">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-trophy me-2"></i>
                        Thành tích gần đây
                    </h6>
                </div>
                <div class="card-body">
                    <c:forEach var="achievement" items="${recentAchievements}">
                        <div class="achievement-item d-flex align-items-center mb-3">
                            <div class="achievement-icon me-3">
                                <i class="fas fa-${achievement.icon} fa-2x text-${achievement.color}"></i>
                            </div>
                            <div>
                                <div class="fw-bold">${achievement.title}</div>
                                <div class="text-muted small">${achievement.description}</div>
                                <div class="text-muted small">
                                    <fmt:formatDate value="${achievement.earnedAt}" pattern="dd/MM/yyyy" />
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty recentAchievements}">
                        <div class="text-center text-muted">
                            <i class="fas fa-trophy fa-3x mb-3"></i>
                            <p>Chưa có thành tích nào<br>Hãy hoàn thành khóa học đầu tiên!</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <%-- Recommended Courses --%>
    <div class="row">
        <div class="col-12">
            <div class="card shadow">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-star me-2"></i>
                        Khóa học đề xuất cho bạn
                    </h6>
                    <a href="/student/courses" class="btn btn-sm btn-primary">Xem tất cả</a>
                </div>
                <div class="card-body">
                    <div class="row">
                        <c:forEach var="course" items="${suggestedCourses}">
                            <div class="col-lg-4 col-md-6 mb-4">
                                <div class="card h-100 shadow-sm course-card">
                                    <img src="${course.imageUrl}" class="card-img-top" alt="Course Image" style="height: 200px; object-fit: cover;"
                                         onerror="this.src='/images/default-course.png'">
                                    <div class="card-body d-flex flex-column">
                                        <h6 class="card-title">${course.name}</h6>
                                        <p class="card-text text-muted small flex-grow-1">
                                                ${fn:substring(course.description, 0, 100)}...
                                        </p>
                                        <div class="course-info mb-3">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <small class="text-muted">
                                                    <i class="fas fa-user me-1"></i>
                                                        ${course.instructor.fullName}
                                                </small>
                                                <span class="badge bg-${course.difficultyLevel == 'BEGINNER' ? 'success' : course.difficultyLevel == 'INTERMEDIATE' ? 'warning' : 'danger'}">
                                                        ${course.difficultyLevel == 'BEGINNER' ? 'Cơ bản' : course.difficultyLevel == 'INTERMEDIATE' ? 'Trung bình' : 'Nâng cao'}
                                                </span>
                                            </div>
                                            <div class="d-flex justify-content-between align-items-center mt-2">
                                                <small class="text-muted">
                                                    <i class="fas fa-users me-1"></i>
                                                        ${course.enrollmentCount} học viên
                                                </small>
                                                <div class="fw-bold text-${course.price > 0 ? 'success' : 'info'}">
                                                    <c:choose>
                                                        <c:when test="${course.price > 0}">
                                                            <fmt:formatNumber value="${course.price}" type="currency"
                                                                              currencySymbol="₫" maxFractionDigits="0" />
                                                        </c:when>
                                                        <c:otherwise>Miễn phí</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                        <a href="/courses/${course.id}" class="btn btn-primary btn-sm">
                                            <i class="fas fa-eye me-1"></i>Xem chi tiết
                                        </a>
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

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Animate progress bars
        document.querySelectorAll('.progress-bar').forEach(bar => {
            const width = bar.style.width;
            bar.style.width = '0%';
            setTimeout(() => {
                bar.style.transition = 'width 1s ease-in-out';
                bar.style.width = width;
            }, 100);
        });

        // Auto-refresh notifications
        setInterval(function() {
            checkNewNotifications();
        }, 60000); // Check mỗi phút
    });

    function checkNewNotifications() {
        // Check for new notifications via AJAX
        fetch('/api/v1/notifications/check', {
            method: 'GET',
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
            .then(response => response.json())
            .then(data => {
                if (data.hasNew) {
                    // Update notification badge
                    updateNotificationBadge(data.count);
                }
            })
            .catch(error => console.log('Error checking notifications:', error));
    }

    function updateNotificationBadge(count) {
        const badge = document.querySelector('.notification-badge');
        if (badge) {
            badge.textContent = count;
            badge.classList.add('pulse');
        }
    }
</script>