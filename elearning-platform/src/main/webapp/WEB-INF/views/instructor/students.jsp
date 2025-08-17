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
    <title>Quản Lý Học Viên - EduLearn Platform</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/instructor.css" rel="stylesheet">

    <style>
        .stats-card {
            border-left: 4px solid;
            transition: all 0.3s ease;
        }
        .stats-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .stats-card.primary { border-left-color: #0d6efd; }
        .stats-card.success { border-left-color: #198754; }
        .stats-card.warning { border-left-color: #ffc107; }
        .stats-card.info { border-left-color: #0dcaf0; }

        .student-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(45deg, #0d6efd, #6610f2);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 0.9rem;
        }

        .progress-ring {
            width: 60px;
            height: 60px;
            position: relative;
        }

        .progress-ring svg {
            width: 100%;
            height: 100%;
            transform: rotate(-90deg);
        }

        .progress-ring-circle {
            fill: none;
            stroke-width: 4;
            stroke-linecap: round;
        }

        .progress-ring-bg {
            stroke: #e9ecef;
        }

        .progress-ring-fill {
            stroke: #198754;
            stroke-dasharray: 157;
            stroke-dashoffset: 157;
            transition: stroke-dashoffset 0.5s ease;
        }

        .progress-text {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 0.75rem;
            font-weight: bold;
            color: #198754;
        }

        .course-badge {
            background: linear-gradient(45deg, #0d6efd, #6610f2);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .last-activity {
            font-size: 0.8rem;
            color: #6c757d;
        }

        .action-btn {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            border: none;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .action-btn:hover {
            transform: scale(1.1);
        }

        .btn-message {
            background: #0d6efd;
            color: white;
        }

        .btn-view {
            background: #198754;
            color: white;
        }

        .btn-email {
            background: #ffc107;
            color: #212529;
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
        }

        .empty-state i {
            font-size: 4rem;
            color: #dee2e6;
            margin-bottom: 1rem;
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
                            <h1 class="h3 mb-0">
                                <i class="fas fa-user-graduate text-primary me-2"></i>
                                Quản Lý Học Viên
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
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/instructor/students/export?format=excel">
                                            <i class="fas fa-file-excel me-2 text-success"></i>Excel (.xlsx)
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/instructor/students/export?format=csv">
                                            <i class="fas fa-file-csv me-2 text-info"></i>CSV
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/instructor/students/export?format=pdf">
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
                        <div class="card stats-card primary">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="stats-icon primary me-3">
                                        <i class="fas fa-users"></i>
                                    </div>
                                    <div>
                                        <div class="stats-value">${studentStats.totalStudents}</div>
                                        <div class="stats-label">Tổng học viên</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card stats-card success">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="stats-icon success me-3">
                                        <i class="fas fa-user-check"></i>
                                    </div>
                                    <div>
                                        <div class="stats-value">${studentStats.activeStudents}</div>
                                        <div class="stats-label">Đang học</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card stats-card warning">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="stats-icon warning me-3">
                                        <i class="fas fa-certificate"></i>
                                    </div>
                                    <div>
                                        <div class="stats-value">${studentStats.completedStudents}</div>
                                        <div class="stats-label">Hoàn thành</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card stats-card info">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="stats-icon info me-3">
                                        <i class="fas fa-percentage"></i>
                                    </div>
                                    <div>
                                        <div class="stats-value">${studentStats.averageProgress}%</div>
                                        <div class="stats-label">Tiến độ TB</div>
                                    </div>
                                </div>
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

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Filters & Search -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form method="GET" action="${pageContext.request.contextPath}/instructor/students">
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

                                <!-- Progress Filter -->
                                <div class="col-md-2">
                                    <label class="form-label">Tiến độ</label>
                                    <select name="progress" class="form-select">
                                        <option value="">Tất cả</option>
                                        <option value="0-25" ${param.progress == '0-25' ? 'selected' : ''}>0-25%</option>
                                        <option value="26-50" ${param.progress == '26-50' ? 'selected' : ''}>26-50%</option>
                                        <option value="51-75" ${param.progress == '51-75' ? 'selected' : ''}>51-75%</option>
                                        <option value="76-100" ${param.progress == '76-100' ? 'selected' : ''}>76-100%</option>
                                    </select>
                                </div>

                                <!-- Status Filter -->
                                <div class="col-md-2">
                                    <label class="form-label">Trạng thái</label>
                                    <select name="status" class="form-select">
                                        <option value="">Tất cả</option>
                                        <option value="active" ${param.status == 'active' ? 'selected' : ''}>Đang học</option>
                                        <option value="completed" ${param.status == 'completed' ? 'selected' : ''}>Hoàn thành</option>
                                        <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
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

                <!-- Students List -->
                <c:choose>
                    <c:when test="${not empty enrollments}">
                        <div class="card">
                            <div class="card-header">
                                <h6 class="card-title mb-0">
                                    <i class="fas fa-list me-2"></i>Danh sách học viên
                                    <span class="badge bg-primary ms-2">${fn:length(enrollments)}</span>
                                </h6>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0" id="studentsTable">
                                        <thead class="table-light">
                                        <tr>
                                            <th>Học viên</th>
                                            <th>Khóa học</th>
                                            <th>Tiến độ</th>
                                            <th>Ngày đăng ký</th>
                                            <th>Hoạt động cuối</th>
                                            <th>Trạng thái</th>
                                            <th width="120px">Hành động</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach items="${enrollments}" var="enrollment" varStatus="status">
                                            <tr>
                                                <!-- Student Info -->
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="student-avatar me-3">
                                                                ${fn:substring(enrollment.student.fullName, 0, 1)}
                                                        </div>
                                                        <div>
                                                            <div class="fw-semibold">${enrollment.student.fullName}</div>
                                                            <small class="text-muted">${enrollment.student.email}</small>
                                                        </div>
                                                    </div>
                                                </td>

                                                <!-- Course -->
                                                <td>
                                                    <span class="course-badge">${enrollment.course.name}</span>
                                                </td>

                                                <!-- Progress -->
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="progress-ring me-2">
                                                            <svg>
                                                                <circle class="progress-ring-circle progress-ring-bg"
                                                                        cx="30" cy="30" r="25"></circle>
                                                                <circle class="progress-ring-circle progress-ring-fill"
                                                                        cx="30" cy="30" r="25"
                                                                        style="stroke-dashoffset: ${157 - (157 * enrollment.progress / 100)}"></circle>
                                                            </svg>
                                                            <div class="progress-text">${enrollment.progress}%</div>
                                                        </div>
                                                        <div>
                                                            <div class="small fw-semibold">${enrollment.progress}%</div>
                                                            <div class="small text-muted">
                                                                <c:choose>
                                                                    <c:when test="${enrollment.progress >= 100}">Hoàn thành</c:when>
                                                                    <c:when test="${enrollment.progress >= 75}">Gần hoàn thành</c:when>
                                                                    <c:when test="${enrollment.progress >= 25}">Đang học</c:when>
                                                                    <c:otherwise>Mới bắt đầu</c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>

                                                <!-- Enrollment Date -->
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${enrollment.enrollmentDate != null}">
                                                            ${enrollment.enrollmentDate.toString().substring(0, 10).replace('-', '/')}
                                                            <div class="last-activity">
                                                                    ${enrollment.enrollmentDate.toString().substring(11, 16)}
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Chưa có</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <!-- Last Activity -->
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${enrollment.lastAccessedAt != null}">
                                                            ${enrollment.lastAccessedAt.toString().substring(0, 10).replace('-', '/')}
                                                            <div class="last-activity">
                                                                    ${enrollment.lastAccessedAt.toString().substring(11, 16)}
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Chưa có</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <!-- Status -->
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${enrollment.completed}">
                                                            <span class="badge bg-success">
                                                                <i class="fas fa-check me-1"></i>Hoàn thành
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${enrollment.progress > 0}">
                                                            <span class="badge bg-primary">
                                                                <i class="fas fa-play me-1"></i>Đang học
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">
                                                                <i class="fas fa-pause me-1"></i>Chưa bắt đầu
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <!-- Actions -->
                                                <td>
                                                    <div class="d-flex gap-1">
                                                        <button class="action-btn btn-view"
                                                                onclick="viewStudentDetail('${enrollment.student.id}')"
                                                                title="Xem chi tiết">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                        <button class="action-btn btn-message"
                                                                onclick="sendMessage('${enrollment.student.id}')"
                                                                title="Gửi tin nhắn">
                                                            <i class="fas fa-comment"></i>
                                                        </button>
                                                        <a href="mailto:${enrollment.student.email}"
                                                           class="action-btn btn-email" title="Gửi email">
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
                    </c:when>
                    <c:otherwise>
                        <!-- Empty State -->
                        <div class="card">
                            <div class="card-body empty-state">
                                <i class="fas fa-users"></i>
                                <h5 class="text-muted">Chưa có học viên nào</h5>
                                <p class="text-muted mb-4">
                                    Khi có học viên đăng ký khóa học của bạn, họ sẽ xuất hiện ở đây.
                                </p>
                                <a href="${pageContext.request.contextPath}/instructor/courses" class="btn btn-primary">
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

<!-- Message Modal -->
<div class="modal fade" id="messageModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-comment me-2"></i>Gửi Tin Nhắn
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="messageForm">
                    <div class="mb-3">
                        <label for="messageSubject" class="form-label">Tiêu đề</label>
                        <input type="text" class="form-control" id="messageSubject" required>
                    </div>
                    <div class="mb-3">
                        <label for="messageContent" class="form-label">Nội dung</label>
                        <textarea class="form-control" id="messageContent" rows="5" required></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-primary" onclick="sendMessageSubmit()">
                    <i class="fas fa-paper-plane me-2"></i>Gửi tin nhắn
                </button>
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
        // Initialize DataTable
        $('#studentsTable').DataTable({
            language: {
                url: 'https://cdn.datatables.net/plug-ins/1.13.4/i18n/vi.json'
            },
            order: [[0, 'asc']], // Sort by student name
            pageLength: 25,
            responsive: true,
            columnDefs: [
                { orderable: false, targets: [6] } // Disable sorting for actions column
            ]
        });
    });

    /**
     * Xem chi tiết học viên
     */
    function viewStudentDetail(studentId) {
        $('#modalLoading').show();
        $('#modalContent').hide();
        $('#studentDetailModal').modal('show');

        // AJAX call to load student details
        $.ajax({
            url: '${pageContext.request.contextPath}/instructor/students/' + studentId + '/detail',
            method: 'GET',
            success: function(response) {
                $('#modalLoading').hide();
                $('#modalContent').html(response).show();
            },
            error: function() {
                $('#modalLoading').hide();
                $('#modalContent').html('<div class="alert alert-danger">Có lỗi xảy ra khi tải dữ liệu.</div>').show();
            }
        });
    }

    /**
     * Gửi tin nhắn cho học viên
     */
    function sendMessage(studentId) {
        $('#messageModal').modal('show');
        $('#messageForm')[0].reset();
        $('#messageModal').data('studentId', studentId);
    }

    /**
     * Submit tin nhắn
     */
    function sendMessageSubmit() {
        var studentId = $('#messageModal').data('studentId');
        var subject = $('#messageSubject').val();
        var content = $('#messageContent').val();

        if (!subject || !content) {
            alert('Vui lòng nhập đầy đủ tiêu đề và nội dung tin nhắn.');
            return;
        }

        // Disable submit button
        var submitBtn = $(event.target);
        submitBtn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Đang gửi...');

        $.ajax({
            url: '${pageContext.request.contextPath}/instructor/students/' + studentId + '/message',
            method: 'POST',
            data: {
                subject: subject,
                content: content,
                '${_csrf.parameterName}': '${_csrf.token}'
            },
            success: function(response) {
                $('#messageModal').modal('hide');
                showToast('Đã gửi tin nhắn thành công!', 'success');
            },
            error: function() {
                showToast('Có lỗi xảy ra khi gửi tin nhắn.', 'error');
            },
            complete: function() {
                submitBtn.prop('disabled', false).html('<i class="fas fa-paper-plane me-2"></i>Gửi tin nhắn');
            }
        });
    }

    /**
     * Show toast notification - FIX: Tránh === operator
     */
    function showToast(message, type) {
        var toastContainer = document.getElementById('toast-container') || createToastContainer();

        var toast = document.createElement('div');
        var bgClass = (type == 'error') ? 'danger' : 'success';
        var iconClass = (type == 'error') ? 'exclamation-circle' : 'check-circle';

        toast.className = 'toast align-items-center text-white bg-' + bgClass + ' border-0';
        toast.setAttribute('role', 'alert');
        toast.innerHTML = '<div class="d-flex">' +
            '<div class="toast-body">' +
            '<i class="fas fa-' + iconClass + ' me-2"></i>' + message +
            '</div>' +
            '<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>' +
            '</div>';

        toastContainer.appendChild(toast);
        var bsToast = new bootstrap.Toast(toast);
        bsToast.show();

        // Auto remove toast after hide
        toast.addEventListener('hidden.bs.toast', function() {
            toast.remove();
        });
    }

    /**
     * Create toast container if not exists
     */
    function createToastContainer() {
        var container = document.createElement('div');
        container.id = 'toast-container';
        container.className = 'toast-container position-fixed top-0 end-0 p-3';
        container.style.zIndex = '9999';
        document.body.appendChild(container);
        return container;
    }
</script>

</body>
</html>