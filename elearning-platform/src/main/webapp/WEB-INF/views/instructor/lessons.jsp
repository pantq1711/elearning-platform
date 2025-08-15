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
    <title>Quản Lý Bài Học - EduLearn Platform</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <!-- Custom CSS - ✅ SỬA LỖI: đường dẫn CSS đúng -->
    <link href="${pageContext.request.contextPath}/css/instructor.css" rel="stylesheet">
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
                        <!-- ✅ SỬA LỖI: attribute class đúng -->
                        <div class="col-lg-6">
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
                                    <li class="breadcrumb-item active">Quản lý bài học</li>
                                </ol>
                            </nav>
                            <h1 class="h3 mb-0">
                                <i class="fas fa-play-circle text-primary me-2"></i>
                                Quản Lý Bài Học
                            </h1>
                            <p class="text-muted mb-0">Tạo và quản lý nội dung bài học cho khóa học của bạn</p>
                        </div>
                        <div class="col-lg-6 text-lg-end">
                            <a href="${pageContext.request.contextPath}/instructor/lessons/new" class="btn btn-primary">
                                <i class="fas fa-plus me-2"></i>Tạo Bài Học Mới
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Thông báo -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Filters & Search -->
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">Tìm kiếm bài học</label>
                                <div class="input-group">
                                    <input type="text" class="form-control" id="searchLesson" placeholder="Nhập tên bài học...">
                                    <button class="btn btn-outline-secondary" type="button">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Khóa học</label>
                                <select class="form-select" id="filterCourse">
                                    <option value="">Tất cả khóa học</option>
                                    <c:forEach items="${courses}" var="course">
                                        <option value="${course.id}" ${param.courseId == course.id ? 'selected' : ''}>
                                                ${course.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Loại bài học</label>
                                <select class="form-select" id="filterType">
                                    <option value="">Tất cả loại</option>
                                    <option value="VIDEO">Video</option>
                                    <option value="DOCUMENT">Tài liệu</option>
                                    <option value="TEXT">Văn bản</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">Trạng thái</label>
                                <select class="form-select" id="filterStatus">
                                    <option value="">Tất cả</option>
                                    <option value="PUBLISHED">Đã xuất bản</option>
                                    <option value="DRAFT">Bản nháp</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Lessons Table -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-list me-2"></i>Danh Sách Bài Học
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover" id="lessonsTable">
                                <thead>
                                <tr>
                                    <th>
                                        <input type="checkbox" class="form-check-input" id="selectAll">
                                    </th>
                                    <th>Bài học</th>
                                    <th>Khóa học</th>
                                    <th>Loại</th>
                                    <th>Thời lượng</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày tạo</th>
                                    <th>Thao tác</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:choose>
                                    <c:when test="${not empty lessons}">
                                        <c:forEach items="${lessons}" var="lesson" varStatus="status">
                                            <tr>
                                                <td>
                                                    <input type="checkbox" class="form-check-input lesson-checkbox" value="${lesson.id}">
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="lesson-icon me-3">
                                                            <c:choose>
                                                                <c:when test="${lesson.type == 'VIDEO'}">
                                                                    <i class="fas fa-play-circle text-primary"></i>
                                                                </c:when>
                                                                <c:when test="${lesson.type == 'DOCUMENT'}">
                                                                    <i class="fas fa-file-pdf text-danger"></i>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <i class="fas fa-file-text text-info"></i>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div>
                                                            <h6 class="mb-1">${lesson.title}</h6>
                                                            <small class="text-muted">
                                                                Thứ tự: ${lesson.orderIndex}
                                                            </small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="fw-semibold">${lesson.course.name}</span>
                                                    <br>
                                                    <small class="text-muted">${lesson.course.category.name}</small>
                                                </td>
                                                <td>
                                                    <span class="badge bg-light text-dark">
                                                        <c:choose>
                                                            <c:when test="${lesson.type == 'VIDEO'}">Video</c:when>
                                                            <c:when test="${lesson.type == 'DOCUMENT'}">Tài liệu</c:when>
                                                            <c:otherwise>Văn bản</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${lesson.duration > 0}">
                                                            <fmt:formatNumber value="${lesson.duration / 60}" maxFractionDigits="1"/> phút
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Chưa cập nhật</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${lesson.published}">
                                                            <span class="badge bg-success">Đã xuất bản</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-warning">Bản nháp</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <small class="text-muted">
                                                        <fmt:formatDate value="${lesson.createdAt}" pattern="dd/MM/yyyy"/>
                                                    </small>
                                                </td>
                                                <td>
                                                    <div class="btn-group btn-group-sm">
                                                        <button type="button" class="btn btn-outline-primary"
                                                                onclick="previewLesson(${lesson.id})"
                                                                title="Xem trước">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                        <a href="${pageContext.request.contextPath}/instructor/lessons/${lesson.id}/edit"
                                                           class="btn btn-outline-success" title="Chỉnh sửa">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <button type="button" class="btn btn-outline-danger"
                                                                onclick="deleteLesson(${lesson.id})"
                                                                title="Xóa">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="8" class="text-center py-5">
                                                <div class="empty-state">
                                                    <i class="fas fa-play-circle fa-3x text-muted mb-3"></i>
                                                    <h5 class="text-muted">Chưa có bài học nào</h5>
                                                    <p class="text-muted">Hãy tạo bài học đầu tiên cho khóa học của bạn</p>
                                                    <a href="${pageContext.request.contextPath}/instructor/lessons/new" class="btn btn-primary">
                                                        <i class="fas fa-plus me-2"></i>Tạo Bài Học Đầu Tiên
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <nav aria-label="Lessons pagination">
                                <ul class="pagination justify-content-center">
                                    <c:if test="${currentPage > 0}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage - 1}&size=${pageSize}">
                                                <i class="fas fa-chevron-left"></i>
                                            </a>
                                        </li>
                                    </c:if>

                                    <c:forEach begin="0" end="${totalPages - 1}" var="pageNum">
                                        <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                            <a class="page-link" href="?page=${pageNum}&size=${pageSize}">${pageNum + 1}</a>
                                        </li>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPages - 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage + 1}&size=${pageSize}">
                                                <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </c:if>
                    </div>
                </div>

                <!-- Bulk Actions -->
                <div class="card mt-3" id="bulkActions" style="display: none;">
                    <div class="card-body">
                        <div class="d-flex align-items-center justify-content-between">
                            <span id="selectedCount">0 bài học được chọn</span>
                            <div class="btn-group">
                                <button type="button" class="btn btn-outline-success" onclick="bulkPublish()">
                                    <i class="fas fa-check me-2"></i>Xuất bản
                                </button>
                                <button type="button" class="btn btn-outline-warning" onclick="bulkUnpublish()">
                                    <i class="fas fa-pause me-2"></i>Hủy xuất bản
                                </button>
                                <button type="button" class="btn btn-outline-danger" onclick="bulkDelete()">
                                    <i class="fas fa-trash me-2"></i>Xóa
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- DataTables JS -->
<script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>

<script>
    $(document).ready(function() {
        // Initialize DataTable - Khởi tạo bảng dữ liệu
        $('#lessonsTable').DataTable({
            "language": {
                "url": "//cdn.datatables.net/plug-ins/1.13.4/i18n/vi.json"
            },
            "pageLength": 10,
            "order": [[6, "desc"]], // Sắp xếp theo ngày tạo
            "columnDefs": [
                { "orderable": false, "targets": [0, 7] } // Không sắp xếp checkbox và actions
            ]
        });

        // Select all functionality - Chức năng chọn tất cả
        $('#selectAll').change(function() {
            $('.lesson-checkbox').prop('checked', this.checked);
            updateBulkActions();
        });

        $('.lesson-checkbox').change(function() {
            updateBulkActions();
        });

        // Search functionality - Chức năng tìm kiếm
        $('#searchLesson').on('keyup', function() {
            $('#lessonsTable').DataTable().search(this.value).draw();
        });

        // Filter functionality - Chức năng lọc
        $('#filterCourse, #filterType, #filterStatus').change(function() {
            applyFilters();
        });
    });

    /**
     * Cập nhật bulk actions dựa trên số lượng checkbox được chọn
     */
    function updateBulkActions() {
        const checkedCount = $('.lesson-checkbox:checked').length;
        const bulkActions = document.getElementById('bulkActions');
        const selectedCount = document.getElementById('selectedCount');

        if (checkedCount > 0) {
            bulkActions.style.display = 'block';
            selectedCount.textContent = `${checkedCount} bài học được chọn`;
        } else {
            bulkActions.style.display = 'none';
        }
    }

    /**
     * Áp dụng các bộ lọc
     */
    function applyFilters() {
        const courseFilter = $('#filterCourse').val();
        const typeFilter = $('#filterType').val();
        const statusFilter = $('#filterStatus').val();

        // Redirect với query parameters
        const params = new URLSearchParams();
        if (courseFilter) params.append('courseId', courseFilter);
        if (typeFilter) params.append('type', typeFilter);
        if (statusFilter) params.append('status', statusFilter);

        window.location.href = `${window.location.pathname}?${params.toString()}`;
    }

    /**
     * Xem trước bài học
     */
    function previewLesson(lessonId) {
        window.open(`${window.location.origin}${pageContext.servletContext.contextPath}/instructor/lessons/${lessonId}/preview`, '_blank');
    }

    /**
     * Xóa bài học
     */
    function deleteLesson(lessonId) {
        if (confirm('Bạn có chắc chắn muốn xóa bài học này không? Hành động này không thể hoàn tác.')) {
            // Submit form xóa hoặc gọi API
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = `${pageContext.servletContext.contextPath}/instructor/lessons/${lessonId}/delete`;

            const csrfToken = document.createElement('input');
            csrfToken.type = 'hidden';
            csrfToken.name = '_token';
            csrfToken.value = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') || '';

            form.appendChild(csrfToken);
            document.body.appendChild(form);
            form.submit();
        }
    }

    /**
     * Xuất bản hàng loạt
     */
    function bulkPublish() {
        const selectedIds = $('.lesson-checkbox:checked').map(function() {
            return this.value;
        }).get();

        if (selectedIds.length === 0) {
            alert('Vui lòng chọn ít nhất một bài học');
            return;
        }

        if (confirm(`Bạn có chắc chắn muốn xuất bản ${selectedIds.length} bài học đã chọn?`)) {
            // Gọi API hoặc submit form
            bulkAction('publish', selectedIds);
        }
    }

    /**
     * Hủy xuất bản hàng loạt
     */
    function bulkUnpublish() {
        const selectedIds = $('.lesson-checkbox:checked').map(function() {
            return this.value;
        }).get();

        if (selectedIds.length === 0) {
            alert('Vui lòng chọn ít nhất một bài học');
            return;
        }

        if (confirm(`Bạn có chắc chắn muốn hủy xuất bản ${selectedIds.length} bài học đã chọn?`)) {
            bulkAction('unpublish', selectedIds);
        }
    }

    /**
     * Xóa hàng loạt
     */
    function bulkDelete() {
        const selectedIds = $('.lesson-checkbox:checked').map(function() {
            return this.value;
        }).get();

        if (selectedIds.length === 0) {
            alert('Vui lòng chọn ít nhất một bài học');
            return;
        }

        if (confirm(`Bạn có chắc chắn muốn xóa ${selectedIds.length} bài học đã chọn? Hành động này không thể hoàn tác.`)) {
            bulkAction('delete', selectedIds);
        }
    }

    /**
     * Thực hiện hành động hàng loạt
     */
    function bulkAction(action, ids) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = `${pageContext.servletContext.contextPath}/instructor/lessons/bulk-${action}`;

        // CSRF token
        const csrfToken = document.createElement('input');
        csrfToken.type = 'hidden';
        csrfToken.name = '_token';
        csrfToken.value = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') || '';
        form.appendChild(csrfToken);

        // IDs
        ids.forEach(id => {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'lessonIds';
            input.value = id;
            form.appendChild(input);
        });

        document.body.appendChild(form);
        form.submit();
    }
</script>
</body>
</html>