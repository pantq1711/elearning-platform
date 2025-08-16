<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thống Kê & Báo Cáo - EduLearn Platform</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Chart.js CSS -->
    <link href="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/instructor.css" rel="stylesheet">

    <style>
        .stats-card {
            border-left: 4px solid;
            transition: all 0.3s ease;
        }
        .stats-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        .stats-card.primary { border-left-color: #0d6efd; }
        .stats-card.success { border-left-color: #198754; }
        .stats-card.warning { border-left-color: #ffc107; }
        .stats-card.info { border-left-color: #0dcaf0; }
        .stats-card.danger { border-left-color: #dc3545; }

        .chart-container {
            position: relative;
            height: 300px;
            margin-bottom: 1rem;
        }
        .chart-container.large {
            height: 400px;
        }

        .metric-item {
            display: flex;
            justify-content: between;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .metric-item:last-child {
            border-bottom: none;
        }

        .trend-indicator {
            font-size: 0.875rem;
            padding: 0.25rem 0.5rem;
            border-radius: 12px;
        }
        .trend-up { background: #d1f2eb; color: #0f5132; }
        .trend-down { background: #f8d7da; color: #721c24; }
        .trend-stable { background: #e2e3e5; color: #41464b; }

        .performance-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .date-range-picker {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 1rem;
        }
    </style>
</head>

<body>
<!-- Include Header -->
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <!-- Include Sidebar -->
        <div class="col-md-3 col-lg-2">
            <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
        </div>

        <!-- Main Content -->
        <div class="col-md-9 col-lg-10">
            <div class="main-content p-4">

                <!-- Page Header -->
                <div class="page-header mb-4">
                    <div class="row align-items-center">
                        <div class="col">
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item">
                                        <a href="${pageContext.request.contextPath}/instructor/dashboard">
                                            <i class="fas fa-home"></i> Dashboard
                                        </a>
                                    </li>
                                    <li class="breadcrumb-item active">Thống kê</li>
                                </ol>
                            </nav>
                            <h1 class="h3 mb-0">
                                <i class="fas fa-chart-line text-primary me-2"></i>
                                Thống Kê & Báo Cáo
                            </h1>
                            <p class="text-muted mb-0">Phân tích hiệu suất giảng dạy và hoạt động học viên</p>
                        </div>
                        <div class="col-auto">
                            <!-- Export Options -->
                            <div class="btn-group">
                                <button type="button" class="btn btn-outline-primary dropdown-toggle"
                                        data-bs-toggle="dropdown">
                                    <i class="fas fa-download me-2"></i>Xuất báo cáo
                                </button>
                                <ul class="dropdown-menu">
                                    <li>
                                        <a class="dropdown-item" href="#" onclick="exportReport('pdf')">
                                            <i class="fas fa-file-pdf me-2 text-danger"></i>PDF
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="#" onclick="exportReport('excel')">
                                            <i class="fas fa-file-excel me-2 text-success"></i>Excel
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="#" onclick="exportReport('csv')">
                                            <i class="fas fa-file-csv me-2 text-info"></i>CSV
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Date Range Filter -->
                <div class="date-range-picker mb-4">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <h6 class="mb-3">Chọn Khoảng Thời Gian</h6>
                            <div class="btn-group" role="group">
                                <input type="radio" class="btn-check" name="dateRange" id="last7days" autocomplete="off" checked>
                                <label class="btn btn-outline-primary" for="last7days">7 ngày</label>

                                <input type="radio" class="btn-check" name="dateRange" id="last30days" autocomplete="off">
                                <label class="btn btn-outline-primary" for="last30days">30 ngày</label>

                                <input type="radio" class="btn-check" name="dateRange" id="last90days" autocomplete="off">
                                <label class="btn btn-outline-primary" for="last90days">3 tháng</label>

                                <input type="radio" class="btn-check" name="dateRange" id="last1year" autocomplete="off">
                                <label class="btn btn-outline-primary" for="last1year">1 năm</label>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <h6 class="mb-3">Hoặc Chọn Thủ Công</h6>
                            <div class="row">
                                <div class="col-6">
                                    <input type="date" class="form-control" id="startDate" value="${startDate}">
                                </div>
                                <div class="col-6">
                                    <input type="date" class="form-control" id="endDate" value="${endDate}">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Overview Stats -->
                <div class="row mb-4">
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="card stats-card primary h-100">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="flex-shrink-0">
                                        <i class="fas fa-users fa-2x text-primary"></i>
                                    </div>
                                    <div class="flex-grow-1 ms-3">
                                        <div class="fw-bold h4 mb-0">${totalStudents}</div>
                                        <div class="text-muted">Tổng Học Viên</div>
                                        <div class="trend-indicator trend-${studentsTrend >= 0 ? 'up' : 'down'}">
                                            <i class="fas fa-arrow-${studentsTrend >= 0 ? 'up' : 'down'} me-1"></i>
                                            <fmt:formatNumber value="${Math.abs(studentsTrend)}" maxFractionDigits="1" />%
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="card stats-card success h-100">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="flex-shrink-0">
                                        <i class="fas fa-graduation-cap fa-2x text-success"></i>
                                    </div>
                                    <div class="flex-grow-1 ms-3">
                                        <div class="fw-bold h4 mb-0">${completedEnrollments}</div>
                                        <div class="text-muted">Hoàn Thành</div>
                                        <div class="trend-indicator trend-${completionTrend >= 0 ? 'up' : 'down'}">
                                            <i class="fas fa-arrow-${completionTrend >= 0 ? 'up' : 'down'} me-1"></i>
                                            <fmt:formatNumber value="${Math.abs(completionTrend)}" maxFractionDigits="1" />%
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="card stats-card warning h-100">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="flex-shrink-0">
                                        <i class="fas fa-dollar-sign fa-2x text-warning"></i>
                                    </div>
                                    <div class="flex-grow-1 ms-3">
                                        <div class="fw-bold h4 mb-0">
                                            <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" />
                                        </div>
                                        <div class="text-muted">Doanh Thu</div>
                                        <div class="trend-indicator trend-${revenueTrend >= 0 ? 'up' : 'down'}">
                                            <i class="fas fa-arrow-${revenueTrend >= 0 ? 'up' : 'down'} me-1"></i>
                                            <fmt:formatNumber value="${Math.abs(revenueTrend)}" maxFractionDigits="1" />%
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="card stats-card info h-100">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="flex-shrink-0">
                                        <i class="fas fa-star fa-2x text-info"></i>
                                    </div>
                                    <div class="flex-grow-1 ms-3">
                                        <div class="fw-bold h4 mb-0">
                                            <fmt:formatNumber value="${averageRating}" maxFractionDigits="1" />
                                        </div>
                                        <div class="text-muted">Đánh Giá TB</div>
                                        <div class="trend-indicator trend-${ratingTrend >= 0 ? 'up' : 'down'}">
                                            <i class="fas fa-arrow-${ratingTrend >= 0 ? 'up' : 'down'} me-1"></i>
                                            <fmt:formatNumber value="${Math.abs(ratingTrend)}" maxFractionDigits="2" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Charts Row -->
                <div class="row mb-4">
                    <!-- Enrollment Trend Chart -->
                    <div class="col-lg-8 mb-4">
                        <div class="card h-100">
                            <div class="card-header">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-chart-area me-2"></i>Xu Hướng Đăng Ký
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="chart-container large">
                                    <canvas id="enrollmentTrendChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Course Performance -->
                    <div class="col-lg-4 mb-4">
                        <div class="card h-100">
                            <div class="card-header">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-trophy me-2"></i>Top Khóa Học
                                </h5>
                            </div>
                            <div class="card-body">
                                <c:forEach items="${topCourses}" var="course" varStatus="status">
                                    <div class="metric-item">
                                        <div class="flex-grow-1">
                                            <div class="fw-medium">${course.name}</div>
                                            <small class="text-muted">${course.enrollmentCount} học viên</small>
                                        </div>
                                        <div class="text-end">
                                            <div class="performance-badge bg-${status.index == 0 ? 'warning' : status.index == 1 ? 'light' : 'secondary'} text-${status.index <= 1 ? 'dark' : 'white'}">
                                                #${status.index + 1}
                                            </div>
                                            <div class="small text-muted">
                                                <fmt:formatNumber value="${course.rating}" maxFractionDigits="1" />★
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Additional Charts Row -->
                <div class="row mb-4">
                    <!-- Revenue Chart -->
                    <div class="col-lg-6 mb-4">
                        <div class="card h-100">
                            <div class="card-header">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-chart-bar me-2"></i>Doanh Thu Theo Tháng
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="chart-container">
                                    <canvas id="revenueChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Student Progress Chart -->
                    <div class="col-lg-6 mb-4">
                        <div class="card h-100">
                            <div class="card-header">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-chart-pie me-2"></i>Phân Bố Tiến Độ
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="chart-container">
                                    <canvas id="progressChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Detailed Analytics -->
                <div class="row mb-4">
                    <!-- Quiz Performance -->
                    <div class="col-lg-6 mb-4">
                        <div class="card h-100">
                            <div class="card-header">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-question-circle me-2"></i>Hiệu Suất Quiz
                                </h5>
                            </div>
                            <div class="card-body">
                                <c:forEach items="${quizStats}" var="quiz" varStatus="status">
                                    <div class="metric-item">
                                        <div class="flex-grow-1">
                                            <div class="fw-medium">${quiz.title}</div>
                                            <small class="text-muted">${quiz.attemptCount} lượt làm</small>
                                        </div>
                                        <div class="text-end">
                                            <div class="fw-bold text-${quiz.passRate >= 80 ? 'success' : quiz.passRate >= 60 ? 'warning' : 'danger'}">
                                                <fmt:formatNumber value="${quiz.passRate}" maxFractionDigits="0" />%
                                            </div>
                                            <small class="text-muted">Tỷ lệ đậu</small>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Activity -->
                    <div class="col-lg-6 mb-4">
                        <div class="card h-100">
                            <div class="card-header">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-clock me-2"></i>Hoạt Động Gần Đây
                                </h5>
                            </div>
                            <div class="card-body">
                                <c:forEach items="${recentActivities}" var="activity" varStatus="status">
                                    <div class="metric-item">
                                        <div class="flex-grow-1">
                                            <div class="fw-medium">${activity.description}</div>
                                            <small class="text-muted">
                                                <fmt:formatDate value="${activity.timestamp}" pattern="dd/MM/yyyy HH:mm" />
                                            </small>
                                        </div>
                                        <div class="text-end">
                                            <i class="fas fa-${activity.type == 'ENROLLMENT' ? 'user-plus text-success' :
                                                              activity.type == 'COMPLETION' ? 'graduation-cap text-primary' :
                                                              activity.type == 'QUIZ' ? 'question-circle text-warning' :
                                                              'eye text-info'}"></i>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Engagement Metrics -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-chart-line me-2"></i>Chỉ Số Tương Tác
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-lg-3 col-md-6 mb-3">
                                        <div class="text-center">
                                            <div class="h3 text-primary mb-1">${avgSessionDuration}</div>
                                            <div class="text-muted">Thời gian học TB (phút)</div>
                                        </div>
                                    </div>
                                    <div class="col-lg-3 col-md-6 mb-3">
                                        <div class="text-center">
                                            <div class="h3 text-success mb-1">
                                                <fmt:formatNumber value="${lessonCompletionRate}" maxFractionDigits="1" />%
                                            </div>
                                            <div class="text-muted">Tỷ lệ hoàn thành bài học</div>
                                        </div>
                                    </div>
                                    <div class="col-lg-3 col-md-6 mb-3">
                                        <div class="text-center">
                                            <div class="h3 text-warning mb-1">
                                                <fmt:formatNumber value="${avgQuizScore}" maxFractionDigits="1" />
                                            </div>
                                            <div class="text-muted">Điểm quiz trung bình</div>
                                        </div>
                                    </div>
                                    <div class="col-lg-3 col-md-6 mb-3">
                                        <div class="text-center">
                                            <div class="h3 text-info mb-1">
                                                <fmt:formatNumber value="${returnRate}" maxFractionDigits="1" />%
                                            </div>
                                            <div class="text-muted">Tỷ lệ quay lại</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<!-- Include Footer -->
<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.js"></script>

<script>
    $(document).ready(function() {
        // Khởi tạo các biểu đồ
        initializeCharts();

        // Event handlers cho date range
        $('input[name="dateRange"]').change(function() {
            updateDateRange($(this).attr('id'));
        });

        $('#startDate, #endDate').change(function() {
            updateCharts();
        });
    });

    /**
     * Khởi tạo tất cả biểu đồ
     */
    function initializeCharts() {
        initEnrollmentTrendChart();
        initRevenueChart();
        initProgressChart();
    }

    /**
     * Biểu đồ xu hướng đăng ký
     */
    function initEnrollmentTrendChart() {
        const ctx = document.getElementById('enrollmentTrendChart').getContext('2d');

        new Chart(ctx, {
            type: 'line',
            data: {
                labels: ${enrollmentLabels}, // Dữ liệu từ server
                datasets: [{
                    label: 'Đăng ký mới',
                    data: ${enrollmentData},
                    borderColor: '#0d6efd',
                    backgroundColor: 'rgba(13, 110, 253, 0.1)',
                    tension: 0.4,
                    fill: true
                }, {
                    label: 'Hoàn thành',
                    data: ${completionData},
                    borderColor: '#198754',
                    backgroundColor: 'rgba(25, 135, 84, 0.1)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top',
                    },
                    title: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            precision: 0
                        }
                    }
                },
                interaction: {
                    intersect: false,
                    mode: 'index'
                }
            }
        });
    }

    /**
     * Biểu đồ doanh thu
     */
    function initRevenueChart() {
        const ctx = document.getElementById('revenueChart').getContext('2d');

        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ${revenueLabels},
                datasets: [{
                    label: 'Doanh thu (₫)',
                    data: ${revenueData},
                    backgroundColor: 'rgba(255, 193, 7, 0.8)',
                    borderColor: '#ffc107',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return new Intl.NumberFormat('vi-VN', {
                                    style: 'currency',
                                    currency: 'VND'
                                }).format(value);
                            }
                        }
                    }
                }
            }
        });
    }

    /**
     * Biểu đồ phân bố tiến độ
     */
    function initProgressChart() {
        const ctx = document.getElementById('progressChart').getContext('2d');

        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['0-25%', '26-50%', '51-75%', '76-100%'],
                datasets: [{
                    data: ${progressDistribution},
                    backgroundColor: [
                        '#dc3545',
                        '#ffc107',
                        '#0dcaf0',
                        '#198754'
                    ],
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    }

    /**
     * Cập nhật khoảng thời gian
     */
    function updateDateRange(range) {
        const today = new Date();
        let startDate, endDate = today;

        switch(range) {
            case 'last7days':
                startDate = new Date(today.getTime() - 7 * 24 * 60 * 60 * 1000);
                break;
            case 'last30days':
                startDate = new Date(today.getTime() - 30 * 24 * 60 * 60 * 1000);
                break;
            case 'last90days':
                startDate = new Date(today.getTime() - 90 * 24 * 60 * 60 * 1000);
                break;
            case 'last1year':
                startDate = new Date(today.getTime() - 365 * 24 * 60 * 60 * 1000);
                break;
        }

        if (startDate) {
            $('#startDate').val(formatDate(startDate));
            $('#endDate').val(formatDate(endDate));
            updateCharts();
        }
    }

    /**
     * Cập nhật biểu đồ với dữ liệu mới
     */
    function updateCharts() {
        const startDate = $('#startDate').val();
        const endDate = $('#endDate').val();

        if (!startDate || !endDate) return;

        // Gửi AJAX request để lấy dữ liệu mới
        $.ajax({
            url: '<c:url value="/instructor/analytics/data" />',
            method: 'GET',
            data: {
                startDate: startDate,
                endDate: endDate
            },
            success: function(data) {
                // Cập nhật dữ liệu biểu đồ
                // Implement logic cập nhật charts ở đây
                console.log('Updated data:', data);
            },
            error: function() {
                showToast('Có lỗi xảy ra khi tải dữ liệu', 'error');
            }
        });
    }

    /**
     * Xuất báo cáo
     */
    function exportReport(format) {
        const startDate = $('#startDate').val();
        const endDate = $('#endDate').val();

        const params = new URLSearchParams({
            format: format,
            startDate: startDate,
            endDate: endDate
        });

        window.open('<c:url value="/instructor/analytics/export" />?' + params.toString(), '_blank');
    }

    /**
     * Format date to YYYY-MM-DD
     */
    function formatDate(date) {
        return date.toISOString().split('T')[0];
    }

    /**
     * Hiển thị thông báo toast
     */
    function showToast(message, type = 'info') {
        const toastContainer = document.getElementById('toast-container') || createToastContainer();

        const toast = document.createElement('div');
        toast.className = `toast align-items-center text-white bg-${type === 'error' ? 'danger' : 'success'} border-0`;
        toast.setAttribute('role', 'alert');
        toast.innerHTML = `
        <div class="d-flex">
            <div class="toast-body">
                <i class="fas fa-${type === 'error' ? 'exclamation-circle' : 'check-circle'} me-2"></i>
                ${message}
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    `;

        toastContainer.appendChild(toast);
        const bsToast = new bootstrap.Toast(toast);
        bsToast.show();

        // Tự động xóa toast sau khi ẩn
        toast.addEventListener('hidden.bs.toast', function() {
            toast.remove();
        });
    }

    /**
     * Tạo container cho toast nếu chưa có
     */
    function createToastContainer() {
        const container = document.createElement('div');
        container.id = 'toast-container';
        container.className = 'toast-container position-fixed top-0 end-0 p-3';
        container.style.zIndex = '9999';
        document.body.appendChild(container);
        return container;
    }
</script>

</body>
</html>