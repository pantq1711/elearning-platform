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
    <title>Quản Lý Quiz - EduLearn Platform</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/instructor.css" rel="stylesheet">
    <style>
        .quiz-stats-card {
            border-left: 4px solid #0d6efd;
            transition: all 0.3s ease;
        }
        .quiz-stats-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        .difficulty-badge {
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
        }
        .quiz-actions .btn {
            margin: 0.125rem;
        }
        .question-count {
            background: #e9ecef;
            border-radius: 50px;
            padding: 0.25rem 0.75rem;
            font-size: 0.875rem;
        }
        .pass-rate-bar {
            height: 8px;
            background: #e9ecef;
            border-radius: 4px;
            overflow: hidden;
        }
        .pass-rate-fill {
            height: 100%;
            transition: width 0.3s ease;
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
                                    <li class="breadcrumb-item">
                                        <a href="${pageContext.request.contextPath}/instructor/courses">Khóa học</a>
                                    </li>
                                    <li class="breadcrumb-item active">Quiz</li>
                                </ol>
                            </nav>
                            <h1 class="h3 mb-0">
                                <i class="fas fa-question-circle text-warning me-2"></i>
                                Quản Lý Quiz
                            </h1>
                            <p class="text-muted mb-0">Tạo và quản lý bài kiểm tra cho khóa học của bạn</p>
                        </div>
                        <div class="col-auto">
                            <!-- Nút tạo quiz mới -->
                            <div class="btn-group">
                                <a href="${pageContext.request.contextPath}/instructor/quizzes/create""
                                   class="btn btn-warning">
                                    <i class="fas fa-plus me-2"></i>Tạo Quiz
                                </a>
                                <button type="button" class="btn btn-warning dropdown-toggle dropdown-toggle-split"
                                        data-bs-toggle="dropdown">
                                    <span class="visually-hidden">Toggle Dropdown</span>
                                </button>
                                <ul class="dropdown-menu">
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/instructor/quizzes/create?type=PRACTICE">
                                            <i class="fas fa-dumbbell me-2"></i>Quiz luyện tập
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/instructor/quizzes/create?type=EXAM">
                                            <i class="fas fa-graduation-cap me-2"></i>Bài kiểm tra
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/instructor/quizzes/create?type=SURVEY">
                                            <i class="fas fa-poll me-2"></i>Khảo sát
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
                        <div class="card quiz-stats-card h-100">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="flex-shrink-0">
                                        <i class="fas fa-question-circle fa-2x text-warning"></i>
                                    </div>
                                    <div class="flex-grow-1 ms-3">
                                        <h3 class="mb-0">${totalQuizzes}</h3>
                                        <p class="text-muted mb-0">Tổng Quiz</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card quiz-stats-card h-100">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="flex-shrink-0">
                                        <i class="fas fa-users fa-2x text-info"></i>
                                    </div>
                                    <div class="flex-grow-1 ms-3">
                                        <h3 class="mb-0">${totalAttempts}</h3>
                                        <p class="text-muted mb-0">Lượt làm bài</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card quiz-stats-card h-100">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="flex-shrink-0">
                                        <i class="fas fa-chart-line fa-2x text-success"></i>
                                    </div>
                                    <div class="flex-grow-1 ms-3">
                                        <h3 class="mb-0">
                                            <fmt:formatNumber value="${averageScore}" maxFractionDigits="1" />%
                                        </h3>
                                        <p class="text-muted mb-0">Điểm trung bình</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card quiz-stats-card h-100">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="flex-shrink-0">
                                        <i class="fas fa-trophy fa-2x text-primary"></i>
                                    </div>
                                    <div class="flex-grow-1 ms-3">
                                        <h3 class="mb-0">
                                            <fmt:formatNumber value="${passRate}" maxFractionDigits="1" />%
                                        </h3>
                                        <p class="text-muted mb-0">Tỷ lệ đậu</p>
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
                        <form method="GET" action="/instructor/quizzes">
                            <div class="row align-items-end g-3">
                                <!-- Search -->
                                <div class="col-md-4">
                                    <label class="form-label">Tìm kiếm</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-search"></i>
                                        </span>
                                        <input type="text" class="form-control" name="search"
                                               value="${param.search}" placeholder="Tìm kiếm quiz...">
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

                                <!-- Type Filter -->
                                <div class="col-md-2">
                                    <label class="form-label">Loại</label>
                                    <select name="type" class="form-select">
                                        <option value="">Tất cả</option>
                                        <option value="PRACTICE" ${param.type == 'PRACTICE' ? 'selected' : ''}>
                                            Luyện tập
                                        </option>
                                        <option value="EXAM" ${param.type == 'EXAM' ? 'selected' : ''}>
                                            Kiểm tra
                                        </option>
                                        <option value="SURVEY" ${param.type == 'SURVEY' ? 'selected' : ''}>
                                            Khảo sát
                                        </option>
                                    </select>
                                </div>

                                <!-- Status Filter -->
                                <div class="col-md-2">
                                    <label class="form-label">Trạng thái</label>
                                    <select name="status" class="form-select">
                                        <option value="">Tất cả</option>
                                        <option value="active" ${param.status == 'active' ? 'selected' : ''}>
                                            Hoạt động
                                        </option>
                                        <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>
                                            Tạm dừng
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

                <!-- Quizzes List -->
                <div class="card">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-list me-2"></i>Danh Sách Quiz
                                <span class="badge bg-warning ms-2">${fn:length(quizzes)}</span>
                            </h5>
                            <div class="btn-group" role="group">
                                <button type="button" class="btn btn-outline-secondary dropdown-toggle"
                                        data-bs-toggle="dropdown">
                                    <i class="fas fa-sort me-1"></i>Sắp xếp
                                </button>
                                <ul class="dropdown-menu">
                                    <li>
                                        <a class="dropdown-item" href="?sort=name">
                                            <i class="fas fa-sort-alpha-up me-2"></i>Tên A-Z
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="?sort=course">
                                            <i class="fas fa-book me-2"></i>Theo khóa học
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="?sort=attempts">
                                            <i class="fas fa-users me-2"></i>Lượt làm bài
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="?sort=created">
                                            <i class="fas fa-calendar me-2"></i>Mới nhất
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${not empty quizzes}">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0" id="quizzesTable">
                                        <thead class="table-light">
                                        <tr>
                                            <th width="35%">Quiz</th>
                                            <th width="20%">Khóa học</th>
                                            <th width="10%">Loại</th>
                                            <th width="10%">Câu hỏi</th>
                                            <th width="10%">Lượt làm</th>
                                            <th width="10%">Tỷ lệ đậu</th>
                                            <th width="5%">Trạng thái</th>
                                            <th width="15%">Hành động</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach items="${quizzes}" var="quiz" varStatus="status">
                                            <tr>
                                                <td>
                                                    <div>
                                                        <div class="fw-semibold mb-1">${quiz.title}</div>
                                                        <c:if test="${not empty quiz.description}">
                                                            <small class="text-muted">
                                                                    ${fn:substring(quiz.description, 0, 60)}
                                                                <c:if test="${fn:length(quiz.description) > 60}">...</c:if>
                                                            </small>
                                                        </c:if>
                                                        <div class="mt-1">
                                                                <span class="difficulty-badge badge bg-${quiz.difficultyLevel == 'EASY' ? 'success' : quiz.difficultyLevel == 'MEDIUM' ? 'warning' : 'danger'}">
                                                                    <c:choose>
                                                                        <c:when test="${quiz.difficultyLevel == 'EASY'}">Dễ</c:when>
                                                                        <c:when test="${quiz.difficultyLevel == 'MEDIUM'}">Trung bình</c:when>
                                                                        <c:when test="${quiz.difficultyLevel == 'HARD'}">Khó</c:when>
                                                                        <c:otherwise>Không xác định</c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                            <c:if test="${quiz.timeLimit > 0}">
                                                                    <span class="badge bg-info ms-1">
                                                                        <i class="fas fa-clock me-1"></i>
                                                                        ${quiz.timeLimit} phút
                                                                    </span>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <img src="${pageContext.request.contextPath}/images/courses/${quiz.course.imageUrl}""
                                                             alt="${quiz.course.name}"
                                                             class="me-2"
                                                             style="width: 32px; height: 24px; object-fit: cover; border-radius: 4px;"
                                                             onerror="this.src='/images/course-default.png"'">
                                                        <div>
                                                            <div class="fw-medium">${quiz.course.name}</div>
                                                            <small class="text-muted">${quiz.course.category.name}</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                        <span class="badge bg-light text-dark">
                                                            <c:choose>
                                                                <c:when test="${quiz.type == 'PRACTICE'}">
                                                                    <i class="fas fa-dumbbell me-1"></i>Luyện tập
                                                                </c:when>
                                                                <c:when test="${quiz.type == 'EXAM'}">
                                                                    <i class="fas fa-graduation-cap me-1"></i>Kiểm tra
                                                                </c:when>
                                                                <c:when test="${quiz.type == 'SURVEY'}">
                                                                    <i class="fas fa-poll me-1"></i>Khảo sát
                                                                </c:when>
                                                                <c:otherwise>Khác</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                </td>
                                                <td>
                                                        <span class="question-count">
                                                            <i class="fas fa-question me-1"></i>
                                                            ${quiz.questionCount} câu
                                                        </span>
                                                </td>
                                                <td>
                                                    <div class="text-center">
                                                        <div class="fw-semibold">${quiz.attemptCount}</div>
                                                        <small class="text-muted">lượt</small>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div>
                                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                                            <small>
                                                                <fmt:formatNumber value="${quiz.passRate}" maxFractionDigits="0" />%
                                                            </small>
                                                        </div>
                                                        <div class="pass-rate-bar">
                                                            <div class="pass-rate-fill bg-${quiz.passRate >= 80 ? 'success' : quiz.passRate >= 60 ? 'warning' : 'danger'}"
                                                                 style="width: ${quiz.passRate}%"></div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                        <span class="badge bg-${quiz.active ? 'success' : 'secondary'}">
                                                                ${quiz.active ? 'Hoạt động' : 'Tạm dừng'}
                                                        </span>
                                                </td>
                                                <td>
                                                    <div class="quiz-actions">
                                                        <!-- Xem chi tiết -->
                                                        <a href="${pageContext.request.contextPath}/instructor/quizzes/${quiz.id}""
                                                           class="btn btn-sm btn-outline-info" title="Xem chi tiết">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <!-- Chỉnh sửa -->
                                                        <a href="${pageContext.request.contextPath}/instructor/quizzes/${quiz.id}/edit""
                                                           class="btn btn-sm btn-outline-primary" title="Chỉnh sửa">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <!-- Xem kết quả -->
                                                        <a href="${pageContext.request.contextPath}/instructor/quizzes/${quiz.id}/results""
                                                           class="btn btn-sm btn-outline-success" title="Xem kết quả">
                                                            <i class="fas fa-chart-bar"></i>
                                                        </a>
                                                        <!-- Preview -->
                                                        <a href="${pageContext.request.contextPath}/instructor/quizzes/${quiz.id}/preview""
                                                           class="btn btn-sm btn-outline-warning" title="Xem trước" target="_blank">
                                                            <i class="fas fa-play"></i>
                                                        </a>
                                                        <!-- Sao chép -->
                                                        <button type="button" class="btn btn-sm btn-outline-secondary"
                                                                onclick="copyQuiz(${quiz.id})" title="Sao chép">
                                                            <i class="fas fa-copy"></i>
                                                        </button>
                                                        <!-- Xóa -->
                                                        <button type="button" class="btn btn-sm btn-outline-danger"
                                                                onclick="deleteQuiz(${quiz.id}, '${quiz.title}')"
                                                                title="Xóa">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Empty State -->
                                <div class="text-center py-5">
                                    <div class="empty-state">
                                        <i class="fas fa-question-circle text-muted mb-3" style="font-size: 4rem;"></i>
                                        <h5 class="text-muted">Chưa có quiz nào</h5>
                                        <p class="text-muted mb-4">
                                            Tạo quiz đầu tiên để kiểm tra kiến thức của học viên.
                                        </p>
                                        <a href="${pageContext.request.contextPath}/instructor/quizzes/create""
                                           class="btn btn-warning">
                                            <i class="fas fa-plus me-2"></i>Tạo Quiz Đầu Tiên
                                        </a>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-exclamation-triangle text-warning me-2"></i>
                    Xác nhận xóa
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Bạn có chắc chắn muốn xóa quiz <strong id="quizNameToDelete"></strong> không?</p>
                <div class="alert alert-warning">
                    <i class="fas fa-warning me-2"></i>
                    Hành động này sẽ xóa tất cả câu hỏi và kết quả liên quan! Không thể hoàn tác!
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <form id="deleteForm" method="POST" style="display: inline;">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-trash me-2"></i>Xóa quiz
                    </button>
                </form>
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
        // Khởi tạo DataTable
        $('#quizzesTable').DataTable({
            language: {
                url: 'https://cdn.datatables.net/plug-ins/1.13.4/i18n/vi.json'
            },
            order: [[0, 'asc']], // Sắp xếp theo tên quiz
            pageLength: 25,
            responsive: true,
            columnDefs: [
                { orderable: false, targets: [7] } // Không cho phép sắp xếp cột hành động
            ]
        });
    });

    /**
     * Xóa quiz
     */
    function deleteQuiz(quizId, quizTitle) {
        $('#quizNameToDelete').text(quizTitle);
        $('#deleteForm').attr('action', '<c:url value="/instructor/quizzes/" />' + quizId + '/delete');
        $('#deleteModal').modal('show');
    }

    /**
     * Sao chép quiz
     */
    function copyQuiz(quizId) {
        if (confirm('Bạn có muốn tạo bản sao của quiz này không? Bản sao sẽ bao gồm tất cả câu hỏi.')) {
            $.ajax({
                url: '<c:url value="/instructor/quizzes/" />' + quizId + '/copy',
                method: 'POST',
                success: function(response) {
                    showToast('Đã sao chép quiz thành công', 'success');
                    setTimeout(() => location.reload(), 1000);
                },
                error: function() {
                    showToast('Có lỗi xảy ra khi sao chép quiz', 'error');
                }
            });
        }
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