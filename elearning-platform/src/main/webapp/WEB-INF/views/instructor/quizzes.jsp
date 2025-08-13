<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý bài kiểm tra - ${course.name}</title>

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

        /* Nút thêm quiz mới */
        .add-quiz-btn {
            background: linear-gradient(135deg, var(--warning-color) 0%, #ff6b6b 100%);
            border: none;
            border-radius: 50px;
            padding: 12px 30px;
            font-weight: 600;
            color: #212529;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .add-quiz-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(255, 193, 7, 0.4);
            color: #212529;
        }

        /* Quizzes grid container */
        .quizzes-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
        }

        /* Quiz card styling */
        .quiz-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
            transition: all 0.3s ease;
            position: relative;
        }

        .quiz-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }

        .quiz-header {
            background: linear-gradient(135deg, var(--warning-color) 0%, #ff6b6b 100%);
            color: #212529;
            padding: 1.5rem;
            position: relative;
        }

        .quiz-title {
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            line-height: 1.3;
        }

        .quiz-description {
            font-size: 0.9rem;
            opacity: 0.8;
            margin: 0;
        }

        .quiz-status-indicator {
            position: absolute;
            top: 1rem;
            right: 1rem;
            width: 12px;
            height: 12px;
            border-radius: 50%;
        }

        .status-active {
            background: #28a745;
        }

        .status-inactive {
            background: #dc3545;
        }

        .quiz-body {
            padding: 1.5rem;
        }

        .quiz-stats {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .stat-item {
            text-align: center;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 10px;
        }

        .stat-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0.25rem;
        }

        .stat-label {
            font-size: 0.85rem;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .quiz-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 1rem;
            padding: 0.75rem;
            background: #e7f3ff;
            border-radius: 8px;
        }

        .info-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.9rem;
            color: #0c5460;
        }

        .info-item i {
            color: var(--info-color);
        }

        /* Quiz action buttons */
        .quiz-actions {
            display: flex;
            gap: 0.5rem;
            justify-content: center;
        }

        .action-btn {
            padding: 0.5rem 1rem;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.85rem;
        }

        .btn-view {
            background: var(--info-color);
            color: white;
        }

        .btn-view:hover {
            background: #138496;
            color: white;
            transform: translateY(-1px);
        }

        .btn-edit {
            background: var(--warning-color);
            color: #212529;
        }

        .btn-edit:hover {
            background: #e0a800;
            color: #212529;
            transform: translateY(-1px);
        }

        .btn-delete {
            background: var(--danger-color);
            color: white;
        }

        .btn-delete:hover {
            background: #c82333;
            color: white;
            transform: translateY(-1px);
        }

        /* Section header */
        .section-header {
            background: white;
            border-radius: 15px;
            padding: 1.5rem 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            display: flex;
            justify-content: between;
            align-items: center;
        }

        .section-title {
            color: var(--primary-color);
            font-size: 1.5rem;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .quiz-count-badge {
            background: var(--warning-color);
            color: #212529;
            padding: 0.25rem 0.75rem;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-left: 1rem;
        }

        /* Empty state */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1.5rem;
            color: #dee2e6;
        }

        .empty-state h4 {
            margin-bottom: 1rem;
            color: #495057;
        }

        .empty-state p {
            color: #6c757d;
            margin-bottom: 2rem;
            max-width: 400px;
            margin-left: auto;
            margin-right: auto;
        }

        /* Difficulty badge */
        .difficulty-badge {
            position: absolute;
            top: -8px;
            left: 1rem;
            padding: 0.25rem 0.75rem;
            border-radius: 15px;
            font-size: 0.75rem;
            font-weight: 600;
            background: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .difficulty-easy {
            color: #28a745;
            border: 2px solid #28a745;
        }

        .difficulty-medium {
            color: #ffc107;
            border: 2px solid #ffc107;
        }

        .difficulty-hard {
            color: #dc3545;
            border: 2px solid #dc3545;
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .quizzes-grid {
                grid-template-columns: 1fr;
            }

            .course-header {
                padding: 1.5rem;
            }

            .section-header {
                padding: 1rem 1.5rem;
                flex-direction: column;
                gap: 1rem;
            }

            .quiz-stats {
                grid-template-columns: 1fr;
            }

            .quiz-info {
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
                ${course.name} - Bài kiểm tra
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
                <a href="/instructor/courses/${course.id}/quizzes/new" class="add-quiz-btn">
                    <i class="fas fa-plus-circle"></i>
                    Tạo bài kiểm tra mới
                </a>
            </div>
        </div>
    </div>

    <!-- Section Header -->
    <div class="section-header">
        <h2 class="section-title">
            <i class="fas fa-clipboard-list"></i>
            Danh sách bài kiểm tra
            <span class="quiz-count-badge">
                    ${quizzes.size()} bài kiểm tra
                </span>
        </h2>
    </div>

    <!-- Quizzes Grid -->
    <c:choose>
        <c:when test="${not empty quizzes}">
            <div class="quizzes-grid">
                <c:forEach items="${quizzes}" var="quiz" varStatus="status">
                    <div class="quiz-card">
                        <!-- Quiz Header -->
                        <div class="quiz-header">
                            <!-- Status Indicator -->
                            <div class="quiz-status-indicator ${quiz.active ? 'status-active' : 'status-inactive'}"></div>

                            <!-- Difficulty Badge -->
                            <div class="difficulty-badge difficulty-medium">
                                <i class="fas fa-star me-1"></i>Trung bình
                            </div>

                            <h5 class="quiz-title">${quiz.title}</h5>
                            <p class="quiz-description">${quiz.description}</p>
                        </div>

                        <!-- Quiz Body -->
                        <div class="quiz-body">
                            <!-- Quiz Statistics -->
                            <div class="quiz-stats">
                                <div class="stat-item">
                                    <div class="stat-value">${quiz.questionCount}</div>
                                    <div class="stat-label">Câu hỏi</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-value">${quiz.resultCount}</div>
                                    <div class="stat-label">Lượt làm</div>
                                </div>
                            </div>

                            <!-- Quiz Information -->
                            <div class="quiz-info">
                                <div class="info-item">
                                    <i class="fas fa-clock"></i>
                                    <span>${quiz.duration} phút</span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-trophy"></i>
                                    <span>${quiz.maxScore} điểm</span>
                                </div>
                            </div>

                            <div class="quiz-info">
                                <div class="info-item">
                                    <i class="fas fa-check-circle"></i>
                                    <span>Điểm đạt: ${quiz.passScore}</span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-redo"></i>
                                    <span>
                                            ${quiz.maxAttempts == -1 ? 'Không giới hạn' : quiz.maxAttempts += ' lần'}
                                    </span>
                                </div>
                            </div>

                            <!-- Quiz Created Date -->
                            <div class="text-center mb-3">
                                <small class="text-muted">
                                    <i class="fas fa-calendar-alt me-1"></i>
                                    Tạo ngày: <fmt:formatDate value="${quiz.createdAt}" pattern="dd/MM/yyyy"/>
                                </small>
                            </div>

                            <!-- Action Buttons -->
                            <div class="quiz-actions">
                                <a href="/instructor/courses/${course.id}/quizzes/${quiz.id}"
                                   class="action-btn btn-view">
                                    <i class="fas fa-eye"></i>
                                    Chi tiết
                                </a>

                                <a href="/instructor/courses/${course.id}/quizzes/${quiz.id}/edit"
                                   class="action-btn btn-edit">
                                    <i class="fas fa-edit"></i>
                                    Sửa
                                </a>

                                <button type="button"
                                        class="action-btn btn-delete"
                                        onclick="confirmDeleteQuiz(${quiz.id}, '${quiz.title}')">
                                    <i class="fas fa-trash"></i>
                                    Xóa
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Empty State -->
            <div class="empty-state">
                <i class="fas fa-clipboard-list"></i>
                <h4>Chưa có bài kiểm tra nào</h4>
                <p>
                    Bạn chưa tạo bài kiểm tra nào cho khóa học này.
                    Hãy tạo bài kiểm tra đầu tiên để đánh giá kiến thức học viên!
                </p>
                <a href="/instructor/courses/${course.id}/quizzes/new" class="add-quiz-btn">
                    <i class="fas fa-plus-circle"></i>
                    Tạo bài kiểm tra đầu tiên
                </a>
            </div>
        </c:otherwise>
    </c:choose>

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
                    Xác nhận xóa bài kiểm tra
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Bạn có chắc chắn muốn xóa bài kiểm tra <strong id="quizTitle"></strong> không?</p>
                <div class="alert alert-warning">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    <strong>Cảnh báo:</strong> Thao tác này sẽ xóa:
                    <ul class="mb-0 mt-2">
                        <li>Bài kiểm tra và tất cả câu hỏi</li>
                        <li>Tất cả kết quả làm bài của học viên</li>
                        <li>Dữ liệu không thể khôi phục!</li>
                    </ul>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times me-2"></i>Hủy
                </button>
                <form id="deleteForm" method="post" class="d-inline">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-trash me-2"></i>Xóa bài kiểm tra
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Hàm xác nhận xóa bài kiểm tra
    function confirmDeleteQuiz(quizId, quizTitle) {
        // Cập nhật thông tin trong modal
        document.getElementById('quizTitle').textContent = quizTitle;
        document.getElementById('deleteForm').action =
            `/instructor/courses/${course.id}/quizzes/${quizId}/delete`;

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

    // Animation cho quiz cards khi load trang
    document.addEventListener('DOMContentLoaded', function() {
        const quizCards = document.querySelectorAll('.quiz-card');
        quizCards.forEach((card, index) => {
            setTimeout(() => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                card.style.transition = 'all 0.5s ease';

                setTimeout(() => {
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, 50);
            }, index * 100);
        });
    });
</script>
</body>
</html>