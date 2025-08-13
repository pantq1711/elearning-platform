<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý bài giảng - ${course.name}</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        /* Định nghĩa các biến màu sắc chính */
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --info-color: #17a2b8;
        }

        /* Thiết lập nền trang */
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
        }

        /* Navbar cho instructor */
        .navbar {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            box-shadow: 0 2px 20px rgba(0,0,0,0.1);
        }

        /* Container chính */
        .main-container {
            margin-top: 20px;
            margin-bottom: 40px;
        }

        /* Header section với thông tin khóa học */
        .course-header {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .course-title {
            color: var(--primary-color);
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .course-description {
            color: #6c757d;
            margin-bottom: 1rem;
        }

        /* Nút thêm bài giảng mới */
        .add-lesson-btn {
            background: linear-gradient(135deg, var(--success-color) 0%, #20c997 100%);
            border: none;
            border-radius: 50px;
            padding: 12px 30px;
            font-weight: 600;
            color: white;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .add-lesson-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.3);
            color: white;
        }

        /* Lessons list container */
        .lessons-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .lessons-header {
            background: linear-gradient(135deg, var(--info-color) 0%, #20c997 100%);
            color: white;
            padding: 1.5rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .lessons-header h3 {
            margin: 0;
            font-size: 1.5rem;
            font-weight: 700;
        }

        .lessons-count {
            background: rgba(255,255,255,0.2);
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
        }

        /* Lesson item styling */
        .lesson-item {
            border-bottom: 1px solid #e9ecef;
            padding: 1.5rem 2rem;
            transition: all 0.3s ease;
            position: relative;
        }

        .lesson-item:last-child {
            border-bottom: none;
        }

        .lesson-item:hover {
            background: #f8f9fa;
            transform: translateX(5px);
        }

        .lesson-order {
            background: var(--primary-color);
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 1.1rem;
            margin-right: 1rem;
            flex-shrink: 0;
        }

        .lesson-content {
            flex: 1;
        }

        .lesson-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 0.5rem;
            line-height: 1.4;
        }

        .lesson-meta {
            display: flex;
            gap: 1.5rem;
            margin-bottom: 0.75rem;
            flex-wrap: wrap;
        }

        .lesson-meta-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: #6c757d;
            font-size: 0.9rem;
        }

        .lesson-meta-item i {
            color: var(--primary-color);
        }

        /* Lesson status badges */
        .lesson-status {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            margin-top: 0.5rem;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .status-active {
            background: #d1ecf1;
            color: #0c5460;
        }

        .status-inactive {
            background: #f8d7da;
            color: #721c24;
        }

        .status-preview {
            background: #fff3cd;
            color: #856404;
        }

        /* Action buttons */
        .lesson-actions {
            display: flex;
            gap: 0.5rem;
            align-items: center;
        }

        .action-btn {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            border: none;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .btn-edit {
            background: var(--warning-color);
            color: #212529;
        }

        .btn-edit:hover {
            background: #e0a800;
            transform: scale(1.1);
        }

        .btn-delete {
            background: var(--danger-color);
            color: white;
        }

        .btn-delete:hover {
            background: #c82333;
            transform: scale(1.1);
        }

        .btn-view {
            background: var(--info-color);
            color: white;
        }

        .btn-view:hover {
            background: #138496;
            transform: scale(1.1);
        }

        /* Empty state */
        .empty-state {
            text-align: center;
            padding: 3rem 2rem;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            color: #dee2e6;
        }

        .empty-state h4 {
            margin-bottom: 1rem;
            color: #495057;
        }

        /* Video indicator */
        .video-indicator {
            background: #dc3545;
            color: white;
            padding: 0.2rem 0.6rem;
            border-radius: 10px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .course-header {
                padding: 1.5rem;
            }

            .lessons-header {
                padding: 1rem 1.5rem;
                flex-direction: column;
                gap: 1rem;
            }

            .lesson-item {
                padding: 1rem 1.5rem;
            }

            .lesson-meta {
                flex-direction: column;
                gap: 0.5rem;
            }

            .lesson-actions {
                flex-direction: column;
                gap: 0.5rem;
            }
        }
    </style>
</head>
<body>
<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container">
        <a class="navbar-brand" href="/instructor/dashboard">
            <i class="fas fa-graduation-cap me-2"></i>
            Instructor Panel
        </a>
        <div class="navbar-nav ms-auto">
                <span class="navbar-text me-3">
                    Xin chào, <strong><sec:authentication property="principal.fullName" /></strong>
                </span>
            <a class="nav-link" href="/logout">
                <i class="fas fa-sign-out-alt"></i> Đăng xuất
            </a>
        </div>
    </div>
</nav>

<!-- Main Container -->
<div class="container main-container">
    <!-- Breadcrumb Navigation -->
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="/instructor/dashboard">
                    <i class="fas fa-home"></i> Dashboard
                </a>
            </li>
            <li class="breadcrumb-item">
                <a href="/instructor/courses">Khóa học</a>
            </li>
            <li class="breadcrumb-item active" aria-current="page">
                ${course.name} - Bài giảng
            </li>
        </ol>
    </nav>

    <!-- Success/Error Messages -->
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

    <!-- Course Header -->
    <div class="course-header">
        <div class="d-flex justify-content-between align-items-start">
            <div class="flex-grow-1">
                <h1 class="course-title">
                    <i class="fas fa-book me-2"></i>${course.name}
                </h1>
                <p class="course-description">${course.description}</p>
                <div class="d-flex gap-3 text-muted">
                    <span><i class="fas fa-user me-1"></i>Giảng viên: ${course.instructor.fullName}</span>
                    <span><i class="fas fa-tag me-1"></i>Danh mục: ${course.category.name}</span>
                </div>
            </div>
            <div>
                <a href="/instructor/courses/${course.id}/lessons/new" class="add-lesson-btn">
                    <i class="fas fa-plus-circle"></i>
                    Thêm bài giảng mới
                </a>
            </div>
        </div>
    </div>

    <!-- Lessons Container -->
    <div class="lessons-container">
        <div class="lessons-header">
            <h3>
                <i class="fas fa-list me-2"></i>Danh sách bài giảng
            </h3>
            <div class="lessons-count">
                <i class="fas fa-book-open me-1"></i>
                ${lessons.size()} bài giảng
            </div>
        </div>

        <!-- Lessons List -->
        <c:choose>
            <c:when test="${not empty lessons}">
                <c:forEach items="${lessons}" var="lesson" varStatus="status">
                    <div class="lesson-item d-flex align-items-start">
                        <!-- Lesson Order Number -->
                        <div class="lesson-order">
                                ${lesson.orderIndex}
                        </div>

                        <!-- Lesson Content -->
                        <div class="lesson-content">
                            <h5 class="lesson-title">${lesson.title}</h5>

                            <!-- Lesson Meta Information -->
                            <div class="lesson-meta">
                                <div class="lesson-meta-item">
                                    <i class="fas fa-clock"></i>
                                    <span>${lesson.estimatedDuration} phút</span>
                                </div>

                                <c:if test="${not empty lesson.videoLink}">
                                    <div class="lesson-meta-item">
                                        <i class="fab fa-youtube"></i>
                                        <span class="video-indicator">Có video</span>
                                    </div>
                                </c:if>

                                <div class="lesson-meta-item">
                                    <i class="fas fa-calendar-alt"></i>
                                    <span>
                                            <fmt:formatDate value="${lesson.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </span>
                                </div>
                            </div>

                            <!-- Lesson Status -->
                            <div class="lesson-status">
                                <c:choose>
                                    <c:when test="${lesson.active}">
                                            <span class="status-badge status-active">
                                                <i class="fas fa-check-circle me-1"></i>Đã kích hoạt
                                            </span>
                                    </c:when>
                                    <c:otherwise>
                                            <span class="status-badge status-inactive">
                                                <i class="fas fa-times-circle me-1"></i>Chưa kích hoạt
                                            </span>
                                    </c:otherwise>
                                </c:choose>

                                <c:if test="${lesson.preview}">
                                        <span class="status-badge status-preview">
                                            <i class="fas fa-eye me-1"></i>Xem trước miễn phí
                                        </span>
                                </c:if>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="lesson-actions">
                            <!-- Nút xem -->
                            <a href="/instructor/courses/${course.id}/lessons/${lesson.id}"
                               class="action-btn btn-view"
                               title="Xem chi tiết">
                                <i class="fas fa-eye"></i>
                            </a>

                            <!-- Nút sửa -->
                            <a href="/instructor/courses/${course.id}/lessons/${lesson.id}/edit"
                               class="action-btn btn-edit"
                               title="Chỉnh sửa">
                                <i class="fas fa-edit"></i>
                            </a>

                            <!-- Nút xóa -->
                            <button type="button"
                                    class="action-btn btn-delete"
                                    title="Xóa bài giảng"
                                    onclick="confirmDeleteLesson(${lesson.id}, '${lesson.title}')">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <!-- Empty State -->
                <div class="empty-state">
                    <i class="fas fa-book-open"></i>
                    <h4>Chưa có bài giảng nào</h4>
                    <p>Bạn chưa tạo bài giảng nào cho khóa học này. Hãy thêm bài giảng đầu tiên để bắt đầu!</p>
                    <a href="/instructor/courses/${course.id}/lessons/new" class="add-lesson-btn">
                        <i class="fas fa-plus-circle"></i>
                        Tạo bài giảng đầu tiên
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Back Button -->
    <div class="text-center mt-4">
        <a href="/instructor/courses" class="btn btn-outline-primary">
            <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách khóa học
        </a>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-exclamation-triangle text-warning me-2"></i>
                    Xác nhận xóa bài giảng
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Bạn có chắc chắn muốn xóa bài giảng <strong id="lessonTitle"></strong> không?</p>
                <div class="alert alert-warning">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    <strong>Cảnh báo:</strong> Thao tác này không thể hoàn tác!
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times me-2"></i>Hủy
                </button>
                <form id="deleteForm" method="post" class="d-inline">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-trash me-2"></i>Xóa bài giảng
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Hàm xác nhận xóa bài giảng
    function confirmDeleteLesson(lessonId, lessonTitle) {
        // Cập nhật thông tin trong modal
        document.getElementById('lessonTitle').textContent = lessonTitle;
        document.getElementById('deleteForm').action =
            `/instructor/courses/${course.id}/lessons/${lessonId}/delete`;

        // Hiển thị modal xác nhận
        const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
        deleteModal.show();
    }

    // Tự động ẩn alert sau 5 giây
    document.addEventListener('DOMContentLoaded', function() {
        const alerts = document.querySelectorAll('.alert[role="alert"]');
        alerts.forEach(function(alert) {
            setTimeout(function() {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }, 5000);
        });
    });

    // Tooltip cho các nút action
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[title]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
</script>
</body>
</html>