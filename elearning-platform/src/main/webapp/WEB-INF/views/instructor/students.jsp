<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Học Viên - EduLearn Platform</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/instructor.css"" rel="stylesheet">

    <style>
        .student-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }
        .progress-ring {
            width: 60px;
            height: 60px;
        }
        .progress-ring-circle {
            stroke: #e9ecef;
            fill: transparent;
            stroke-width: 4;
        }
        .progress-ring-bar {
            stroke: #0d6efd;
            fill: transparent;
            stroke-width: 4;
            stroke-linecap: round;
            transition: stroke-dasharray 0.3s ease;
        }
        .student-card {
            border: 1px solid #dee2e6;
            border-radius: 12px;
            transition: all 0.3s ease;
        }
        .student-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        .badge-status {
            font-size: 0.75rem;
            padding: 0.35rem 0.65rem;
        }
        .activity-timeline {
            position: relative;
            padding-left: 1.5rem;
        }
        .activity-timeline::before {
            content: '';
            position: absolute;
            left: 0.5rem;
            top: 0;
            bottom: 0;
            width: 2px;
            background: #dee2e6;
        }
        .timeline-item {
            position: relative;
            margin-bottom: 1rem;
        }
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -0.75rem;
            top: 0.25rem;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #0d6efd;
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
                                        <a href="${pageContext.request.contextPath}/instructor/dashboard"">
                                            <i class="fas fa-home"></i> Dashboard
                                        </a>
                                    </li>
                                    <li class="breadcrumb-item active">Học viên</li>
                                </ol>
                            </nav>
                            <h1 class="h3 mb-0">
                                <i class="fas fa-users text-info me-2"></i>
                                Danh Sách Học Viên
                            </h1>
                            <p class="text-muted mb-0">Quản lý và theo dõi tiến độ học tập của học viên</p>
                        </div>
                        <div class="col-auto">
                            <!-- Export Button -->
                            <div class="btn-group">
                                <button type="button" class="btn btn-outline-primary dropdown-toggle"
                                        data-bs-toggle="dropdown">
                                    <i class="fas fa-download me-2"></i>Xuất dữ liệu
                                </button>
                                <ul class="dropdown-menu">
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/instructor/students/export?format=excel"">
                                            <i class="fas fa-file-excel me-2 text-success"></i>Excel (.xlsx)
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/instructor/students/export?format=csv"">
                                            <i class="fas fa-file-csv me-2 text-info"></i>CSV
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/instructor/students/export?format=pdf"">
                                            <i class="fas fa-file-pdf me-2 text-danger"></i>PDF
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Stats Overview -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card text-center h-100">
                            <div class="card-body">
                                <i class="fas fa-users fa-2x text-info mb-3"></i>
                                <h3 class="mb-0">${totalStudents}</h3>
                                <p class="text-muted mb-0">Tổng học viên</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card text-center h-100">
                            <div class="card-body">
                                <i class="fas fa-user-check fa-2x text-success mb-3"></i>
                                <h3 class="mb-0">${activeStudents}</h3>
                                <p class="text-muted mb-0">Đang học</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card text-center h-100">
                            <div class="card-body">
                                <i class="fas fa-graduation-cap fa-2x text-warning mb-3"></i>
                                <h3 class="mb-0">${completedStudents}</h3>
                                <p class="text-muted mb-0">Hoàn thành</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card text-center h-100">
                            <div class="card-body">
                                <i class="fas fa-chart-line fa-2x text-primary mb-3"></i>
                                <h3 class="mb-0">
                                    <fmt:formatNumber value="${averageProgress}" maxFractionDigits="1" />%
                                </h3>
                                <p class="text-muted mb-0">Tiến độ TB</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Thông báo -->
                <c:if test="${not empty message}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Filters & Search -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form method="GET" action="//instructor/students"">
                            <div class="row align-items-end g-3">
                                <!-- Search -->
                                <div class="col-md-4">
                                    <label class="form-label">Tìm kiếm</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-search"></i>
                                        </span>
                                        <input type="text" class="form-control" name="search"
                                               value="${param.search}" placeholder="Tên, email học viên...">
                                    </div>
                                </div>

                                <!-- Course Filter -->
                                <div class="col-md-3">
                                    <label class="form-label">Khóa học</label>
                                    <select name="courseId" class="form-select">
                                        <option value="">Tất cả khóa học</option>
                                        <c:forEach items="${courses}" var="course">
                                            <option value="${course.id}"
                                                ${param.courseId == course.id ? 'selected' : ''}>
                                                    ${course.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <!-- Status Filter -->
                                <div class="col-md-2">
                                    <label class="form-label">Trạng thái</label>
                                    <select name="status" class="form-select">
                                        <option value="">Tất cả</option>
                                        <option value="active" ${param.status == 'active' ? 'selected' : ''}>
                                            Đang học
                                        </option>
                                        <option value="completed" ${param.status == 'completed' ? 'selected' : ''}>
                                            Hoàn thành
                                        </option>
                                        <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>
                                            Tạm dừng
                                        </option>
                                    </select>
                                </div>

                                <!-- Progress Filter -->
                                <div class="col-md-2">
                                    <label class="form-label">Tiến độ</label>
                                    <select name="progressRange" class="form-select">
                                        <option value="">Tất cả</option>
                                        <option value="0-25" ${param.progressRange == '0-25' ? 'selected' : ''}>
                                            0-25%
                                        </option>
                                        <option value="26-50" ${param.progressRange == '26-50' ? 'selected' : ''}>
                                            26-50%
                                        </option>
                                        <option value="51-75" ${param.progressRange == '51-75' ? 'selected' : ''}>
                                            51-75%
                                        </option>
                                        <option value="76-100" ${param.progressRange == '76-100' ? 'selected' : ''}>
                                            76-100%
                                        </option>
                                    </select>
                                </div>

                                <!-- Filter Button -->
                                <div class="col-md-1">
                                    <button type="submit" class="btn btn-primary w-100">
                                        <i class="fas fa-filter"></i>
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- View Toggle -->
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <span class="text-muted">Hiển thị ${fn:length(students)} học viên</span>
                    </div>
                    <div class="btn-group" role="group">
                        <input type="radio" class="btn-check" name="viewMode" id="cardView"
                               autocomplete="off" ${param.view != 'table' ? 'checked' : ''}>
                        <label class="btn btn-outline-secondary" for="cardView">
                            <i class="fas fa-th-large"></i>
                        </label>

                        <input type="radio" class="btn-check" name="viewMode" id="tableView"
                               autocomplete="off" ${param.view == 'table' ? 'checked' : ''}>
                        <label class="btn btn-outline-secondary" for="tableView">
                            <i class="fas fa-table"></i>
                        </label>
                    </div>
                </div>

                <!-- Students List -->
                <c:choose>
                    <c:when test="${not empty students}">

                        <!-- Card View -->
                        <div id="cardViewContent" style="display: ${param.view == 'table' ? 'none' : 'block'};">
                            <div class="row">
                                <c:forEach items="${students}" var="enrollment" varStatus="status">
                                    <div class="col-lg-6 col-xl-4 mb-4">
                                        <div class="student-card card h-100">
                                            <div class="card-body">
                                                <!-- Student Header -->
                                                <div class="d-flex align-items-center mb-3">
                                                    <img src="${pageContext.request.contextPath}/images/avatars/${enrollment.student.avatar}""
                                                         alt="${enrollment.student.fullName}"
                                                         class="student-avatar me-3"
                                                         onerror="this.src='/images/avatar-default.png"'">
                                                    <div class="flex-grow-1">
                                                        <h6 class="mb-1">${enrollment.student.fullName}</h6>
                                                        <small class="text-muted">${enrollment.student.email}</small>
                                                    </div>
                                                    <div class="dropdown">
                                                        <button class="btn btn-sm btn-outline-secondary"
                                                                data-bs-toggle="dropdown">
                                                            <i class="fas fa-ellipsis-v"></i>
                                                        </button>
                                                        <ul class="dropdown-menu">
                                                            <li>
                                                                <a class="dropdown-item"
                                                                   href="${pageContext.request.contextPath}/instructor/students/${enrollment.student.id}/profile"">
                                                                    <i class="fas fa-user me-2"></i>Xem hồ sơ
                                                                </a>
                                                            </li>
                                                            <li>
                                                                <a class="dropdown-item"
                                                                   href="${pageContext.request.contextPath}/instructor/students/${enrollment.student.id}/progress"">
                                                                    <i class="fas fa-chart-line me-2"></i>Tiến độ học tập
                                                                </a>
                                                            </li>
                                                            <li>
                                                                <a class="dropdown-item"
                                                                   href="mailto:${enrollment.student.email}">
                                                                    <i class="fas fa-envelope me-2"></i>Gửi email
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>

                                                <!-- Course Info -->
                                                <div class="mb-3">
                                                    <small class="text-muted">Khóa học:</small>
                                                    <div class="fw-medium">${enrollment.course.name}</div>
                                                </div>

                                                <!-- Progress -->
                                                <div class="d-flex align-items-center mb-3">
                                                    <div class="me-3">
                                                        <svg class="progress-ring" width="60" height="60">
                                                            <circle class="progress-ring-circle"
                                                                    cx="30" cy="30" r="26"></circle>
                                                            <circle class="progress-ring-bar"
                                                                    cx="30" cy="30" r="26"
                                                                    style="stroke-dasharray: ${enrollment.progress * 163.36 / 100} 163.36;
                                                                            stroke-dashoffset: 0;
                                                                            transform: rotate(-90deg);
                                                                            transform-origin: 30px 30px;"></circle>
                                                            <text x="30" y="35" text-anchor="middle"
                                                                  class="small fw-bold fill-primary">
                                                                <fmt:formatNumber value="${enrollment.progress}" maxFractionDigits="0" />%
                                                            </text>
                                                        </svg>
                                                    </div>
                                                    <div class="flex-grow-1">
                                                        <div class="fw-medium">Tiến độ học tập</div>
                                                        <div class="progress" style="height: 6px;">
                                                            <div class="progress-bar bg-${enrollment.progress >= 75 ? 'success' : enrollment.progress >= 50 ? 'info' : enrollment.progress >= 25 ? 'warning' : 'danger'}"
                                                                 style="width: ${enrollment.progress}%"></div>
                                                        </div>
                                                        <small class="text-muted">
                                                                ${enrollment.completedLessons}/${enrollment.totalLessons} bài học
                                                        </small>
                                                    </div>
                                                </div>

                                                <!-- Status & Dates -->
                                                <div class="row text-center">
                                                    <div class="col-6">
                                                        <span class="badge badge-status bg-${enrollment.completed ? 'success' : 'primary'}">
                                                                ${enrollment.completed ? 'Hoàn thành' : 'Đang học'}
                                                        </span>
                                                    </div>
                                                    <div class="col-6">
                                                        <small class="text-muted">
                                                            Đăng ký: <fmt:formatDate value="${enrollment.enrollmentDate}" pattern="dd/MM/yyyy" />
                                                        </small>
                                                    </div>
                                                </div>

                                                <!-- Recent Activity -->
                                                <c:if test="${not empty enrollment.lastActivity}">
                                                    <div class="mt-3 pt-3 border-top">
                                                        <small class="text-muted">
                                                            <i class="fas fa-clock me-1"></i>
                                                            Hoạt động cuối: <fmt:formatDate value="${enrollment.lastActivity}" pattern="dd/MM HH:mm" />
                                                        </small>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Table View -->
                        <div id="tableViewContent" style="display: ${param.view == 'table' ? 'block' : 'none'};">
                            <div class="card">
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0" id="studentsTable">
                                            <thead class="table-light">
                                            <tr>
                                                <th width="25%">Học viên</th>
                                                <th width="20%">Khóa học</th>
                                                <th width="15%">Tiến độ</th>
                                                <th width="10%">Trạng thái</th>
                                                <th width="15%">Ngày đăng ký</th>
                                                <th width="15%">Hoạt động cuối</th>
                                                <th width="10%">Hành động</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach items="${students}" var="enrollment" varStatus="status">
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <img src="${pageContext.request.contextPath}/images/avatars/${enrollment.student.avatar}""
                                                                 alt="${enrollment.student.fullName}"
                                                                 class="student-avatar me-3"
                                                                 onerror="this.src='/images/avatar-default.png"'">
                                                            <div>
                                                                <div class="fw-medium">${enrollment.student.fullName}</div>
                                                                <small class="text-muted">${enrollment.student.email}</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div>
                                                            <div class="fw-medium">${enrollment.course.name}</div>
                                                            <small class="text-muted">${enrollment.course.category.name}</small>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <div class="progress me-2" style="width: 60px; height: 8px;">
                                                                <div class="progress-bar bg-${enrollment.progress >= 75 ? 'success' : enrollment.progress >= 50 ? 'info' : enrollment.progress >= 25 ? 'warning' : 'danger'}"
                                                                     style="width: ${enrollment.progress}%"></div>
                                                            </div>
                                                            <small class="text-nowrap">
                                                                <fmt:formatNumber value="${enrollment.progress}" maxFractionDigits="0" />%
                                                            </small>
                                                        </div>
                                                        <small class="text-muted">
                                                                ${enrollment.completedLessons}/${enrollment.totalLessons} bài
                                                        </small>
                                                    </td>
                                                    <td>
                                                            <span class="badge bg-${enrollment.completed ? 'success' : 'primary'}">
                                                                    ${enrollment.completed ? 'Hoàn thành' : 'Đang học'}
                                                            </span>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${enrollment.enrollmentDate}" pattern="dd/MM/yyyy" />
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty enrollment.lastActivity}">
                                                                <fmt:formatDate value="${enrollment.lastActivity}" pattern="dd/MM HH:mm" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">Chưa có</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <a href="${pageContext.request.contextPath}/instructor/students/${enrollment.student.id}/profile""
                                                               class="btn btn-sm btn-outline-info" title="Xem hồ sơ">
                                                                <i class="fas fa-user"></i>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/instructor/students/${enrollment.student.id}/progress""
                                                               class="btn btn-sm btn-outline-primary" title="Tiến độ">
                                                                <i class="fas fa-chart-line"></i>
                                                            </a>
                                                            <a href="mailto:${enrollment.student.email}"
                                                               class="btn btn-sm btn-outline-success" title="Gửi email">
                                                                <i class="fas fa-envelope"></i>
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

                    </c:when>
                    <c:otherwise>
                        <!-- Empty State -->
                        <div class="card">
                            <div class="card-body text-center py-5">
                                <i class="fas fa-users text-muted mb-3" style="font-size: 4rem;"></i>
                                <h5 class="text-muted">Chưa có học viên nào</h5>
                                <p class="text-muted mb-4">
                                    Khi có học viên đăng ký khóa học của bạn, họ sẽ xuất hiện ở đây.
                                </p>
                                <a href="${pageContext.request.contextPath}/instructor/courses"" class="btn btn-primary">
                                    <i class="fas fa-plus me-2"></i>Quản lý khóa học
                                </a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>

            </div>
        </div>
    </div>
</div>

<!-- Student Detail Modal -->
<div class="modal fade" id="studentDetailModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-user me-2"></i>Chi Tiết Học Viên
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <!-- Content sẽ được load bằng AJAX -->
                <div class="text-center py-4" id="modalLoading">
                    <i class="fas fa-spinner fa-spin fa-2x text-muted"></i>
                    <p class="text-muted mt-2">Đang tải...</p>
                </div>
                <div id="modalContent" style="display: none;">
                    <!-- Nội dung chi tiết học viên -->
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
<script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>

<script>
    $(document).ready(function() {
        // Khởi tạo DataTable cho table view
        $('#studentsTable').DataTable({
            language: {
                url: 'https://cdn.datatables.net/plug-ins/1.13.4/i18n/vi.json'
            },
            order: [[4, 'desc']], // Sắp xếp theo ngày đăng ký mới nhất
            pageLength: 25,
            responsive: true,
            columnDefs: [
                { orderable: false, targets: [6] } // Không cho phép sắp xếp cột hành động
            ]
        });

        // View mode toggle
        $('input[name="viewMode"]').change(function() {
            const isTableView = $('#tableView').is(':checked');

            if (isTableView) {
                $('#cardViewContent').hide();
                $('#tableViewContent').show();
            } else {
                $('#tableViewContent').hide();
                $('#cardViewContent').show();
            }

            // Update URL parameter
            const url = new URL(window.location);
            if (isTableView) {
                url.searchParams.set('view', 'table');
            } else {
                url.searchParams.delete('view');
            }
            window.history.replaceState({}, '', url);
        });

        // Load student detail modal
        $(document).on('click', '[data-student-id]', function(e) {
            e.preventDefault();
            const studentId = $(this).data('student-id');
            loadStudentDetail(studentId);
        });
    });

    /**
     * Load chi tiết học viên vào modal
     */
    function loadStudentDetail(studentId) {
        $('#modalLoading').show();
        $('#modalContent').hide();
        $('#studentDetailModal').modal('show');

        $.ajax({
            url: '<c:url value="/instructor/students/" />' + studentId + '/detail',
            method: 'GET',
            success: function(data) {
                $('#modalContent').html(data);
                $('#modalLoading').hide();
                $('#modalContent').show();
            },
            error: function() {
                $('#modalContent').html(`
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    Có lỗi xảy ra khi tải thông tin học viên.
                </div>
            `);
                $('#modalLoading').hide();
                $('#modalContent').show();
            }
        });
    }

    /**
     * Send message to student
     */
    function sendMessage(studentId, studentName) {
        const message = prompt(`Gửi tin nhắn đến ${studentName}:`);
        if (message && message.trim()) {
            $.ajax({
                url: '<c:url value="/instructor/students/" />' + studentId + '/message',
                method: 'POST',
                data: {
                    message: message.trim()
                },
                success: function() {
                    showToast('Đã gửi tin nhắn thành công', 'success');
                },
                error: function() {
                    showToast('Có lỗi xảy ra khi gửi tin nhắn', 'error');
                }
            });
        }
    }

    /**
     * Export students data
     */
    function exportData(format) {
        const params = new URLSearchParams(window.location.search);
        params.set('format', format);

        window.open('<c:url value="/instructor/students/export" />?' + params.toString(), '_blank');
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