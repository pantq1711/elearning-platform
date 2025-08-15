<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thống kê & Báo cáo - Admin Panel</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        /* CSS cho analytics page */
        .admin-wrapper {
            display: flex;
            min-height: 100vh;
            background-color: #f8f9fa;
        }

        .admin-sidebar {
            width: 280px;
            background: linear-gradient(180deg, #4f46e5 0%, #7c3aed 100%);
            color: white;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            transition: transform 0.3s ease;
            z-index: 1000;
        }

        .admin-content {
            flex: 1;
            margin-left: 280px;
            padding: 0;
        }

        .admin-header {
            background: white;
            padding: 1rem 2rem;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #1f2937;
            margin: 0;
        }

        .sidebar-header {
            padding: 1.5rem 1rem;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .menu-section {
            padding: 1rem 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .menu-title {
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            color: rgba(255,255,255,0.7);
            padding: 0 1rem;
            margin-bottom: 0.5rem;
        }

        .menu-item {
            display: flex;
            align-items: center;
            padding: 0.75rem 1rem;
            color: rgba(255,255,255,0.8);
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .menu-item:hover,
        .menu-item.active {
            background-color: rgba(255,255,255,0.1);
            color: white;
            text-decoration: none;
        }

        .menu-item i {
            width: 20px;
            margin-right: 0.75rem;
        }

        .page-content {
            padding: 2rem;
        }

        .stats-overview {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid #e5e7eb;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #4f46e5, #7c3aed);
        }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
        }

        .stat-content h3 {
            font-size: 2rem;
            font-weight: 700;
            margin: 0;
            color: #1f2937;
        }

        .stat-content p {
            margin: 0;
            color: #6b7280;
            font-size: 0.875rem;
        }

        .stat-change {
            display: flex;
            align-items: center;
            gap: 0.25rem;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .stat-change.positive {
            color: #059669;
        }

        .stat-change.negative {
            color: #dc2626;
        }

        .chart-container {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid #e5e7eb;
            margin-bottom: 2rem;
        }

        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #e5e7eb;
        }

        .chart-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #1f2937;
            margin: 0;
        }

        .chart-filters {
            display: flex;
            gap: 0.5rem;
        }

        .filter-btn {
            padding: 0.375rem 0.75rem;
            border: 1px solid #e5e7eb;
            background: white;
            border-radius: 6px;
            font-size: 0.875rem;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .filter-btn:hover,
        .filter-btn.active {
            background: #4f46e5;
            color: white;
            border-color: #4f46e5;
        }

        .chart-wrapper {
            position: relative;
            height: 300px;
            margin: 0 -0.5rem;
        }

        .analytics-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .top-categories,
        .recent-activities {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid #e5e7eb;
        }

        .section-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: #1f2937;
            margin: 0 0 1rem 0;
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 0.5rem;
            color: #4f46e5;
        }

        .category-item {
            display: flex;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid #f3f4f6;
        }

        .category-item:last-child {
            border-bottom: none;
        }

        .category-icon {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 0.75rem;
            color: white;
            font-size: 1.25rem;
        }

        .category-info {
            flex: 1;
        }

        .category-name {
            font-weight: 500;
            color: #1f2937;
            margin: 0;
        }

        .category-stats {
            font-size: 0.875rem;
            color: #6b7280;
            margin: 0;
        }

        .category-progress {
            width: 60px;
            height: 4px;
            background: #f3f4f6;
            border-radius: 2px;
            overflow: hidden;
        }

        .category-progress-bar {
            height: 100%;
            background: #4f46e5;
            transition: width 0.3s ease;
        }

        .activity-item {
            display: flex;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid #f3f4f6;
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 0.75rem;
            font-size: 0.875rem;
        }

        .activity-content {
            flex: 1;
        }

        .activity-text {
            font-size: 0.875rem;
            color: #1f2937;
            margin: 0;
        }

        .activity-time {
            font-size: 0.75rem;
            color: #6b7280;
            margin: 0;
        }

        .export-section {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid #e5e7eb;
            margin-bottom: 2rem;
        }

        .export-options {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
        }

        .export-item {
            padding: 1rem;
            border: 2px dashed #d1d5db;
            border-radius: 8px;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .export-item:hover {
            border-color: #4f46e5;
            background-color: #f8faff;
        }

        .export-item i {
            font-size: 2rem;
            color: #4f46e5;
            margin-bottom: 0.5rem;
        }

        .export-item h6 {
            margin: 0;
            color: #1f2937;
        }

        .export-item p {
            margin: 0;
            font-size: 0.875rem;
            color: #6b7280;
        }

        @media (max-width: 768px) {
            .admin-sidebar {
                transform: translateX(-100%);
            }

            .admin-sidebar.show {
                transform: translateX(0);
            }

            .admin-content {
                margin-left: 0;
            }

            .analytics-grid {
                grid-template-columns: 1fr;
            }

            .stats-overview {
                grid-template-columns: repeat(2, 1fr);
            }

            .chart-filters {
                flex-wrap: wrap;
            }
        }
    </style>
</head>

<body>
<div class="admin-wrapper">
    <!-- Sidebar Navigation -->
    <aside class="admin-sidebar">
        <div class="sidebar-header">
            <h4 class="mb-0">
                <i class="fas fa-graduation-cap me-2"></i>
                E-Learning Admin
            </h4>
        </div>

        <!-- Navigation Menu -->
        <nav class="sidebar-nav">
            <!-- Tổng quan -->
            <div class="menu-section">
                <div class="menu-title">Tổng quan</div>
                <a href="/admin/dashboard" class="menu-item">
                    <i class="fas fa-tachometer-alt"></i>Dashboard
                </a>
                <a href="/admin/analytics"" class="menu-item active">
                    <i class="fas fa-chart-line"></i>Thống kê & Báo cáo
                </a>
            </div>

            <!-- Quản lý người dùng -->
            <div class="menu-section">
                <div class="menu-title">Quản lý người dùng</div>
                <a href="/admin/users"" class="menu-item">
                    <i class="fas fa-users"></i>Tất cả người dùng
                </a>
                <a href="/admin/users?role=INSTRUCTOR"" class="menu-item">
                    <i class="fas fa-chalkboard-teacher"></i>Giảng viên
                </a>
                <a href="/admin/users?role=STUDENT"" class="menu-item">
                    <i class="fas fa-user-graduate"></i>Học viên
                </a>
            </div>

            <!-- Quản lý khóa học -->
            <div class="menu-section">
                <div class="menu-title">Quản lý khóa học</div>
                <a href="/admin/courses"" class="menu-item">
                    <i class="fas fa-book"></i>Tất cả khóa học
                </a>
                <a href="/admin/categories"" class="menu-item">
                    <i class="fas fa-tags"></i>Danh mục
                </a>
                <a href="/admin/courses?status=pending"" class="menu-item">
                    <i class="fas fa-clock"></i>Chờ duyệt
                </a>
            </div>
        </nav>
    </aside>

    <!-- Main Content -->
    <main class="admin-content">
        <!-- Header -->
        <header class="admin-header">
            <div class="d-flex align-items-center">
                <button class="btn btn-link d-md-none me-2" onclick="toggleSidebar()">
                    <i class="fas fa-bars"></i>
                </button>
                <h1 class="header-title">Thống kê & Báo cáo</h1>
            </div>

            <div class="d-flex align-items-center gap-2">
                <button class="btn btn-outline-primary" onclick="refreshData()">
                    <i class="fas fa-sync-alt me-1"></i>Làm mới
                </button>
                <div class="dropdown">
                    <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user me-1"></i>
                        ${currentUser.fullName}
                    </button>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt me-1"></i>Đăng xuất
                        </a></li>
                    </ul>
                </div>
            </div>
        </header>

        <!-- Page Content -->
        <div class="page-content">
            <!-- Stats Overview -->
            <div class="stats-overview">
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #4f46e5, #7c3aed);">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-change positive">
                            <i class="fas fa-arrow-up"></i>
                            +12%
                        </div>
                    </div>
                    <div class="stat-content">
                        <h3>${totalUsers}</h3>
                        <p>Tổng người dùng</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #059669, #10b981);">
                            <i class="fas fa-book"></i>
                        </div>
                        <div class="stat-change positive">
                            <i class="fas fa-arrow-up"></i>
                            +8%
                        </div>
                    </div>
                    <div class="stat-content">
                        <h3>${totalCourses}</h3>
                        <p>Tổng khóa học</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #d97706, #f59e0b);">
                            <i class="fas fa-user-graduate"></i>
                        </div>
                        <div class="stat-change positive">
                            <i class="fas fa-arrow-up"></i>
                            +24%
                        </div>
                    </div>
                    <div class="stat-content">
                        <h3>${totalEnrollments}</h3>
                        <p>Lượt đăng ký</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #dc2626, #ef4444);">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                        <div class="stat-change negative">
                            <i class="fas fa-arrow-down"></i>
                            -3%
                        </div>
                    </div>
                    <div class="stat-content">
                        <h3><fmt:formatNumber value="${totalRevenue}" pattern="#,###" />₫</h3>
                        <p>Doanh thu</p>
                    </div>
                </div>
            </div>

            <!-- Enrollment Chart -->
            <div class="chart-container">
                <div class="chart-header">
                    <h2 class="chart-title">
                        <i class="fas fa-chart-line me-2"></i>Lượt đăng ký theo thời gian
                    </h2>
                    <div class="chart-filters">
                        <button class="filter-btn active" onclick="changeTimeRange('7days')">7 ngày</button>
                        <button class="filter-btn" onclick="changeTimeRange('30days')">30 ngày</button>
                        <button class="filter-btn" onclick="changeTimeRange('90days')">3 tháng</button>
                        <button class="filter-btn" onclick="changeTimeRange('1year')">1 năm</button>
                    </div>
                </div>
                <div class="chart-wrapper">
                    <canvas id="enrollmentChart"></canvas>
                </div>
            </div>

            <!-- Analytics Grid -->
            <div class="analytics-grid">
                <!-- Top Categories -->
                <div class="top-categories">
                    <h3 class="section-title">
                        <i class="fas fa-fire"></i>Danh mục phổ biến
                    </h3>

                    <c:forEach var="category" items="${topCategories}" varStatus="status">
                        <div class="category-item">
                            <div class="category-icon" style="background-color: ${category.colorCode}">
                                <i class="${category.iconClass}"></i>
                            </div>
                            <div class="category-info">
                                <p class="category-name">${category.categoryName}</p>
                                <p class="category-stats">
                                        ${category.courseCount} khóa học • ${category.totalEnrollments} học viên
                                </p>
                            </div>
                            <div class="category-progress">
                                <div class="category-progress-bar"
                                     style="width: ${category.totalEnrollments / maxEnrollments * 100}%"></div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Recent Activities -->
                <div class="recent-activities">
                    <h3 class="section-title">
                        <i class="fas fa-clock"></i>Hoạt động gần đây
                    </h3>

                    <c:forEach var="activity" items="${recentActivities}">
                        <div class="activity-item">
                            <div class="activity-icon" style="background-color: ${activity.iconColor}">
                                <i class="${activity.iconClass}"></i>
                            </div>
                            <div class="activity-content">
                                <p class="activity-text">${activity.description}</p>
                                <p class="activity-time">
                                    <fmt:formatDate value="${activity.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                </p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Category Distribution Chart -->
            <div class="chart-container">
                <div class="chart-header">
                    <h2 class="chart-title">
                        <i class="fas fa-chart-pie me-2"></i>Phân bố theo danh mục
                    </h2>
                    <div class="chart-filters">
                        <button class="filter-btn active" onclick="changeChartType('courses')">Khóa học</button>
                        <button class="filter-btn" onclick="changeChartType('enrollments')">Đăng ký</button>
                        <button class="filter-btn" onclick="changeChartType('revenue')">Doanh thu</button>
                    </div>
                </div>
                <div class="chart-wrapper">
                    <canvas id="categoryChart"></canvas>
                </div>
            </div>

            <!-- Export Section -->
            <div class="export-section">
                <h3 class="section-title">
                    <i class="fas fa-download"></i>Xuất báo cáo
                </h3>
                <p class="text-muted">Tải xuống các báo cáo thống kê theo định dạng khác nhau</p>

                <div class="export-options">
                    <div class="export-item" onclick="exportReport('pdf')">
                        <i class="fas fa-file-pdf"></i>
                        <h6>Báo cáo PDF</h6>
                        <p>Báo cáo tổng quan đầy đủ</p>
                    </div>

                    <div class="export-item" onclick="exportReport('excel')">
                        <i class="fas fa-file-excel"></i>
                        <h6>Excel Spreadsheet</h6>
                        <p>Dữ liệu chi tiết dạng bảng</p>
                    </div>

                    <div class="export-item" onclick="exportReport('csv')">
                        <i class="fas fa-file-csv"></i>
                        <h6>CSV Data</h6>
                        <p>Dữ liệu thô để phân tích</p>
                    </div>

                    <div class="export-item" onclick="exportReport('json')">
                        <i class="fas fa-code"></i>
                        <h6>JSON API</h6>
                        <p>Dữ liệu API cho ứng dụng</p>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // JavaScript cho analytics page

    // Toggle sidebar trên mobile
    function toggleSidebar() {
        document.querySelector('.admin-sidebar').classList.toggle('show');
    }

    // Charts initialization
    let enrollmentChart, categoryChart;

    document.addEventListener('DOMContentLoaded', function() {
        initializeCharts();
    });

    function initializeCharts() {
        // Enrollment Chart
        const enrollmentCtx = document.getElementById('enrollmentChart').getContext('2d');
        enrollmentChart = new Chart(enrollmentCtx, {
            type: 'line',
            data: {
                labels: ${enrollmentLabels}, // Từ controller
                datasets: [{
                    label: 'Lượt đăng ký',
                    data: ${enrollmentData}, // Từ controller
                    borderColor: '#4f46e5',
                    backgroundColor: 'rgba(79, 70, 229, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: '#4f46e5',
                    pointBorderColor: '#ffffff',
                    pointBorderWidth: 2,
                    pointRadius: 6,
                    pointHoverRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        titleColor: '#ffffff',
                        bodyColor: '#ffffff',
                        borderColor: '#4f46e5',
                        borderWidth: 1,
                        cornerRadius: 8,
                        displayColors: false
                    }
                },
                scales: {
                    x: {
                        grid: {
                            display: false
                        },
                        ticks: {
                            color: '#6b7280'
                        }
                    },
                    y: {
                        grid: {
                            color: 'rgba(107, 114, 128, 0.1)'
                        },
                        ticks: {
                            color: '#6b7280'
                        }
                    }
                },
                interaction: {
                    intersect: false,
                    mode: 'index'
                }
            }
        });

        // Category Chart
        const categoryCtx = document.getElementById('categoryChart').getContext('2d');
        categoryChart = new Chart(categoryCtx, {
            type: 'doughnut',
            data: {
                labels: ${categoryLabels}, // Từ controller
                datasets: [{
                    data: ${categoryData}, // Từ controller
                    backgroundColor: [
                        '#4f46e5',
                        '#059669',
                        '#d97706',
                        '#dc2626',
                        '#0891b2',
                        '#7c3aed',
                        '#be185d',
                        '#9333ea'
                    ],
                    borderWidth: 0,
                    hoverOffset: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right',
                        labels: {
                            padding: 20,
                            usePointStyle: true,
                            color: '#1f2937'
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        titleColor: '#ffffff',
                        bodyColor: '#ffffff',
                        borderColor: '#4f46e5',
                        borderWidth: 1,
                        cornerRadius: 8
                    }
                }
            }
        });
    }

    // Change time range for enrollment chart
    function changeTimeRange(range) {
        // Cập nhật active button
        document.querySelectorAll('.chart-filters .filter-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        event.target.classList.add('active');

        // Gọi API để lấy dữ liệu mới
        fetch(`/admin/api/enrollment-data?range=${range}`)
            .then(response => response.json())
            .then(data => {
                enrollmentChart.data.labels = data.labels;
                enrollmentChart.data.datasets[0].data = data.data;
                enrollmentChart.update('active');
            })
            .catch(error => {
                console.error('Error fetching enrollment data:', error);
            });
    }

    // Change chart type for category chart
    function changeChartType(type) {
        // Cập nhật active button
        document.querySelectorAll('.chart-container:last-of-type .chart-filters .filter-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        event.target.classList.add('active');

        // Gọi API để lấy dữ liệu mới
        fetch(`/admin/api/category-data?type=${type}`)
            .then(response => response.json())
            .then(data => {
                categoryChart.data.labels = data.labels;
                categoryChart.data.datasets[0].data = data.data;
                categoryChart.update('active');
            })
            .catch(error => {
                console.error('Error fetching category data:', error);
            });
    }

    // Refresh all data
    function refreshData() {
        const refreshBtn = document.querySelector('button[onclick="refreshData()"]');
        const originalHTML = refreshBtn.innerHTML;

        // Hiển thị loading
        refreshBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang tải...';
        refreshBtn.disabled = true;

        // Làm mới trang
        setTimeout(() => {
            window.location.reload();
        }, 1000);
    }

    // Export reports
    function exportReport(format) {
        const exportItem = event.target.closest('.export-item');
        const originalHTML = exportItem.innerHTML;

        // Hiển thị loading
        exportItem.innerHTML = `
                <i class="fas fa-spinner fa-spin"></i>
                <h6>Đang xử lý...</h6>
                <p>Vui lòng đợi</p>
            `;

        // Gọi API export
        fetch(`/admin/api/export-report?format=${format}`)
            .then(response => {
                if (response.ok) {
                    return response.blob();
                }
                throw new Error('Export failed');
            })
            .then(blob => {
                // Tạo link download
                const url = window.URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href = url;
                a.download = `analytics-report.${format}`;
                document.body.appendChild(a);
                a.click();
                window.URL.revokeObjectURL(url);
                document.body.removeChild(a);

                // Khôi phục giao diện
                exportItem.innerHTML = originalHTML;
            })
            .catch(error => {
                console.error('Export error:', error);
                alert('Có lỗi xảy ra khi xuất báo cáo');
                exportItem.innerHTML = originalHTML;
            });
    }

    // Auto-refresh data every 5 minutes
    setInterval(function() {
        fetch('/admin/api/dashboard-stats')
            .then(response => response.json())
            .then(data => {
                // Cập nhật các stat cards
                updateStatsCards(data);
            })
            .catch(error => console.error('Error refreshing stats:', error));
    }, 300000); // 5 phút

    function updateStatsCards(data) {
        // Cập nhật số liệu trong các stat cards
        const statCards = document.querySelectorAll('.stat-card');
        if (statCards[0]) statCards[0].querySelector('h3').textContent = data.totalUsers;
        if (statCards[1]) statCards[1].querySelector('h3').textContent = data.totalCourses;
        if (statCards[2]) statCards[2].querySelector('h3').textContent = data.totalEnrollments;
        if (statCards[3]) statCards[3].querySelector('h3').textContent = new Intl.NumberFormat('vi-VN').format(data.totalRevenue) + '₫';
    }
</script>
</body>
</html>