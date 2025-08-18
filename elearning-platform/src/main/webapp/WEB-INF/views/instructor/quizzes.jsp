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
    <title>Quản lý bài kiểm tra - EduLearn Platform</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/dashboard-improved.css" rel="stylesheet">

    <style>
        :root {
            --primary-color: #4f46e5;
            --primary-dark: #3730a3;
            --success-color: #059669;
            --warning-color: #d97706;
            --danger-color: #dc2626;
            --info-color: #0891b2;
            --light-bg: #f8fafc;
            --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            --border-color: #e5e7eb;
            --text-primary: #1f2937;
            --text-secondary: #6b7280;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--light-bg);
            margin: 0;
        }

        .dashboard-layout {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 2rem;
            transition: margin-left 0.3s ease;
        }

        @media (max-width: 991.98px) {
            .main-content {
                margin-left: 0;
                padding: 1rem;
            }
        }

        /* Page Header */
        .page-header {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
        }

        .page-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .page-subtitle {
            color: var(--text-secondary);
            font-size: 1.1rem;
            margin-bottom: 0;
        }

        .page-actions {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary-custom:hover {
            background: linear-gradient(135deg, var(--primary-dark), var(--primary-color));
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
            color: white;
        }

        /* Stats Row */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
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
            background: linear-gradient(90deg, var(--primary-color), var(--primary-dark));
        }

        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        .stat-title {
            color: var(--text-secondary);
            font-weight: 500;
        }

        .stat-icon {
            font-size: 2.5rem;
            color: var(--primary-color);
            opacity: 0.7;
        }

        /* Filters */
        .filter-row {
            display: grid;
            grid-template-columns: 1fr auto auto;
            gap: 1.5rem;
            align-items: center;
            background: white;
            padding: 1.5rem;
            border-radius: 1rem;
            margin-bottom: 2rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
        }

        .search-box {
            position: relative;
        }

        .search-input {
            width: 100%;
            padding: 0.75rem 1rem 0.75rem 2.5rem;
            border: 2px solid var(--border-color);
            border-radius: 0.5rem;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
            outline: none;
        }

        .search-icon {
            position: absolute;
            left: 0.75rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
        }

        .filter-select {
            padding: 0.75rem 1rem;
            border: 2px solid var(--border-color);
            border-radius: 0.5rem;
            font-size: 1rem;
            transition: all 0.3s ease;
            min-width: 150px;
        }

        .filter-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
            outline: none;
        }

        /* Quiz Table */
        .table-container {
            background: white;
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
        }

        .table {
            margin-bottom: 0;
        }

        .table thead th {
            background: var(--light-bg);
            border-bottom: 2px solid var(--border-color);
            color: var(--text-primary);
            font-weight: 600;
            padding: 1rem;
            border-top: none;
        }

        .table tbody td {
            padding: 1rem;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }

        .table tbody tr:hover {
            background-color: rgba(79, 70, 229, 0.02);
        }

        .table tbody tr:last-child td {
            border-bottom: none;
        }

        /* Quiz Item Styles */
        .quiz-title {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }

        .quiz-description {
            color: var(--text-secondary);
            font-size: 0.9rem;
        }

        .course-info {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .course-thumbnail {
            width: 32px;
            height: 24px;
            border-radius: 4px;
            object-fit: cover;
        }

        .course-name {
            font-weight: 500;
            color: var(--text-primary);
        }

        .course-category {
            color: var(--text-secondary);
            font-size: 0.85rem;
        }

        /* Badges */
        .badge {
            padding: 0.5rem 0.75rem;
            border-radius: 0.5rem;
            font-weight: 500;
            font-size: 0.8rem;
        }

        .badge-active {
            background-color: var(--success-color);
            color: white;
        }

        .badge-inactive {
            background-color: var(--text-secondary);
            color: white;
        }

        .badge-questions {
            background-color: var(--info-color);
            color: white;
        }

        .badge-duration {
            background-color: var(--warning-color);
            color: white;
        }

        /* Action Buttons */
        .btn-group {
            display: flex;
            gap: 0.25rem;
        }

        .btn-sm {
            padding: 0.375rem 0.75rem;
            font-size: 0.8rem;
            border-radius: 0.375rem;
        }

        .btn-outline-primary {
            border: 1px solid var(--primary-color);
            color: var(--primary-color);
        }

        .btn-outline-primary:hover {
            background: var(--primary-color);
            color: white;
        }

        .btn-outline-success {
            border: 1px solid var(--success-color);
            color: var(--success-color);
        }

        .btn-outline-success:hover {
            background: var(--success-color);
            color: white;
        }

        .btn-outline-warning {
            border: 1px solid var(--warning-color);
            color: var(--warning-color);
        }

        .btn-outline-warning:hover {
            background: var(--warning-color);
            color: white;
        }

        .btn-outline-secondary {
            border: 1px solid var(--text-secondary);
            color: var(--text-secondary);
        }

        .btn-outline-secondary:hover {
            background: var(--text-secondary);
            color: white;
        }

        .btn-outline-danger {
            border: 1px solid var(--danger-color);
            color: var(--danger-color);
        }

        .btn-outline-danger:hover {
            background: var(--danger-color);
            color: white;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
        }

        .empty-icon {
            font-size: 4rem;
            color: var(--text-secondary);
            margin-bottom: 1rem;
        }

        .empty-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.75rem;
        }

        .empty-description {
            color: var(--text-secondary);
            margin-bottom: 2rem;
            max-width: 400px;
            margin-left: auto;
            margin-right: auto;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .page-title {
                font-size: 1.5rem;
            }

            .page-actions {
                flex-direction: column;
            }

            .btn-primary-custom {
                justify-content: center;
            }

            .filter-row {
                grid-template-columns: 1fr;
            }

            .stats-row {
                grid-template-columns: repeat(2, 1fr);
            }

            .table-responsive {
                font-size: 0.9rem;
            }

            .btn-group {
                flex-direction: column;
            }
        }
    </style>
</head>

<body>
<div class="dashboard-layout">
    <!-- Include Sidebar -->
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

    <!-- Main Content -->
    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <div class="d-flex justify-content-between align-items-start flex-wrap">
                <div>
                    <h1 class="page-title">Quản lý bài kiểm tra</h1>
                    <p class="page-subtitle">
                        Tạo, chỉnh sửa và quản lý các bài kiểm tra cho học viên
                    </p>
                </div>
                <div class="page-actions">
                    <a href="${pageContext.request.contextPath}/instructor/quizzes/new" class="btn-primary-custom">
                        <i class="fas fa-plus"></i>
                        Tạo quiz mới
                    </a>
                </div>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-header">
                    <div>
                        <div class="stat-number">${fn:length(quizzes)}</div>
                        <div class="stat-title">Tổng quiz</div>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-question-circle"></i>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div>
                        <div class="stat-number">
                            <c:set var="activeQuizzes" value="0" />
                            <c:forEach items="${quizzes}" var="quiz">
                                <c:if test="${quiz.active}">
                                    <c:set var="activeQuizzes" value="${activeQuizzes + 1}" />
                                </c:if>
                            </c:forEach>
                            ${activeQuizzes}
                        </div>
                        <div class="stat-title">Quiz đang hoạt động</div>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-play-circle"></i>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div>
                        <div class="stat-number">
                            <c:set var="totalQuestions" value="0" />
                            <c:forEach items="${quizzes}" var="quiz">
                                <c:set var="totalQuestions" value="${totalQuestions + fn:length(quiz.questions)}" />
                            </c:forEach>
                            ${totalQuestions}
                        </div>
                        <div class="stat-title">Tổng câu hỏi</div>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-list"></i>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div>
                        <div class="stat-number">
                            <c:set var="totalAttempts" value="0" />
                            <c:forEach items="${quizzes}" var="quiz">
                                <c:set var="totalAttempts" value="${totalAttempts + fn:length(quiz.quizResults)}" />
                            </c:forEach>
                            ${totalAttempts}
                        </div>
                        <div class="stat-title">Lượt làm bài</div>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-users"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filters -->
        <div class="filter-row">
            <div class="search-box">
                <i class="fas fa-search search-icon"></i>
                <input type="text" class="search-input" placeholder="Tìm kiếm quiz..."
                       value="${searchQuery}" onchange="searchQuizzes(this.value)">
            </div>
            <select class="filter-select" onchange="filterByStatus(this.value)">
                <option value="">Tất cả trạng thái</option>
                <option value="active">Đang hoạt động</option>
                <option value="inactive">Không hoạt động</option>
            </select>
            <select class="filter-select" onchange="filterByCourse(this.value)">
                <option value="">Tất cả khóa học</option>
                <c:forEach items="${courses}" var="course">
                    <option value="${course.id}">${course.name}</option>
                </c:forEach>
            </select>
        </div>

        <!-- Quiz Table -->
        <c:choose>
            <c:when test="${not empty quizzes}">
                <div class="table-container">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                            <tr>
                                <th width="25%">Tiêu đề</th>
                                <th width="20%">Khóa học</th>
                                <th width="10%">Câu hỏi</th>
                                <th width="10%">Thời gian</th>
                                <th width="10%">Lượt làm</th>
                                <th width="10%">Trạng thái</th>
                                <th width="15%">Hành động</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${quizzes}" var="quiz" varStatus="status">
                                <tr>
                                    <!-- Quiz Title & Description -->
                                    <td>
                                        <div class="quiz-title">${quiz.title}</div>
                                        <c:if test="${not empty quiz.description}">
                                            <div class="quiz-description">
                                                    ${fn:substring(quiz.description, 0, 80)}
                                                <c:if test="${fn:length(quiz.description) > 80}">...</c:if>
                                            </div>
                                        </c:if>
                                    </td>

                                    <!-- Course Info -->
                                    <td>
                                        <div class="course-info">
                                            <c:choose>
                                                <c:when test="${not empty quiz.course.thumbnail}">
                                                    <img src="${pageContext.request.contextPath}/images/courses/${quiz.course.thumbnail}"
                                                         alt="${quiz.course.name}" class="course-thumbnail"
                                                         onerror="this.style.display='none'">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="course-thumbnail" style="background: var(--primary-color); display: flex; align-items: center; justify-content: center;">
                                                        <i class="fas fa-book" style="color: white; font-size: 0.7rem;"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                            <div>
                                                <div class="course-name">${quiz.course.name}</div>
                                                <div class="course-category">${quiz.course.category.name}</div>
                                            </div>
                                        </div>
                                    </td>

                                    <!-- Questions Count -->
                                    <td>
                                            <span class="badge badge-questions">
                                                <i class="fas fa-list me-1"></i>
                                                ${fn:length(quiz.questions)} câu
                                            </span>
                                    </td>

                                    <!-- Duration -->
                                    <td>
                                            <span class="badge badge-duration">
                                                <i class="fas fa-clock me-1"></i>
                                                <c:choose>
                                                    <c:when test="${quiz.duration != null && quiz.duration > 0}">
                                                        ${quiz.duration} phút
                                                    </c:when>
                                                    <c:otherwise>
                                                        Không giới hạn
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                    </td>

                                    <!-- Attempts -->
                                    <td>
                                        <span class="fw-medium">${fn:length(quiz.quizResults)}</span>
                                        <c:if test="${fn:length(quiz.quizResults) > 0}">
                                            <br>
                                            <small class="text-muted">
                                                <c:set var="passedCount" value="0" />
                                                <c:forEach items="${quiz.quizResults}" var="result">
                                                    <c:if test="${result.passed}">
                                                        <c:set var="passedCount" value="${passedCount + 1}" />
                                                    </c:if>
                                                </c:forEach>
                                                    ${passedCount} đậu
                                            </small>
                                        </c:if>
                                    </td>

                                    <!-- Status -->
                                    <td>
                                            <span class="badge ${quiz.active ? 'badge-active' : 'badge-inactive'}">
                                                <c:choose>
                                                    <c:when test="${quiz.active}">
                                                        <i class="fas fa-check-circle me-1"></i>Hoạt động
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-pause-circle me-1"></i>Tạm dừng
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                    </td>

                                    <!-- Actions -->
                                    <td>
                                        <div class="btn-group">
                                            <!-- View Details -->
                                            <a href="${pageContext.request.contextPath}/instructor/quizzes/${quiz.id}"
                                               class="btn btn-sm btn-outline-primary" title="Xem chi tiết">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <!-- Edit -->
                                            <a href="${pageContext.request.contextPath}/instructor/quizzes/${quiz.id}/edit"
                                               class="btn btn-sm btn-outline-success" title="Chỉnh sửa">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <!-- Results -->
                                            <a href="${pageContext.request.contextPath}/instructor/quizzes/${quiz.id}/results"
                                               class="btn btn-sm btn-outline-warning" title="Xem kết quả">
                                                <i class="fas fa-chart-bar"></i>
                                            </a>
                                            <!-- Copy -->
                                            <button type="button" class="btn btn-sm btn-outline-secondary"
                                                    onclick="copyQuiz(${quiz.id})" title="Sao chép">
                                                <i class="fas fa-copy"></i>
                                            </button>
                                            <!-- Delete -->
                                            <button type="button" class="btn btn-sm btn-outline-danger"
                                                    onclick="deleteQuiz(${quiz.id})" title="Xóa">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Empty State -->
                <div class="empty-state">
                    <div class="empty-icon">
                        <i class="fas fa-question-circle"></i>
                    </div>
                    <h3 class="empty-title">Chưa có quiz nào</h3>
                    <p class="empty-description">
                        Bạn chưa tạo quiz nào. Hãy bắt đầu tạo quiz đầu tiên để kiểm tra kiến thức của học viên!
                    </p>
                    <a href="${pageContext.request.contextPath}/instructor/quizzes/new" class="btn-primary-custom">
                        <i class="fas fa-plus"></i>
                        Tạo quiz đầu tiên
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Tìm kiếm quiz
    function searchQuizzes(query) {
        const url = new URL(window.location);
        if (query.trim()) {
            url.searchParams.set('search', query.trim());
        } else {
            url.searchParams.delete('search');
        }
        window.location.href = url.toString();
    }

    // Lọc theo trạng thái
    function filterByStatus(status) {
        const url = new URL(window.location);
        if (status) {
            url.searchParams.set('status', status);
        } else {
            url.searchParams.delete('status');
        }
        window.location.href = url.toString();
    }

    // Lọc theo khóa học
    function filterByCourse(courseId) {
        const url = new URL(window.location);
        if (courseId) {
            url.searchParams.set('course', courseId);
        } else {
            url.searchParams.delete('course');
        }
        window.location.href = url.toString();
    }

    // Sao chép quiz
    function copyQuiz(quizId) {
        if (confirm('Bạn có muốn sao chép quiz này?')) {
            fetch('${pageContext.request.contextPath}/instructor/quizzes/' + quizId + '/copy', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest',
                    '${_csrf.headerName}': '${_csrf.token}'
                }
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showToast('Sao chép quiz thành công!', 'success');
                        setTimeout(() => window.location.reload(), 1500);
                    } else {
                        showToast(data.message || 'Có lỗi xảy ra!', 'error');
                    }
                })
                .catch(error => {
                    showToast('Có lỗi xảy ra khi sao chép quiz!', 'error');
                    console.error('Error:', error);
                });
        }
    }

    // Xóa quiz
    function deleteQuiz(quizId) {
        if (confirm('Bạn có chắc chắn muốn xóa quiz này? Hành động này không thể hoàn tác và sẽ xóa tất cả kết quả làm bài.')) {
            fetch('${pageContext.request.contextPath}/instructor/quizzes/' + quizId + '/delete', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest',
                    '${_csrf.headerName}': '${_csrf.token}'
                }
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showToast('Xóa quiz thành công!', 'success');
                        setTimeout(() => window.location.reload(), 1500);
                    } else {
                        showToast(data.message || 'Có lỗi xảy ra!', 'error');
                    }
                })
                .catch(error => {
                    showToast('Có lỗi xảy ra khi xóa quiz!', 'error');
                    console.error('Error:', error);
                });
        }
    }

    // Toast notification system
    function showToast(message, type) {
        // Remove existing toast
        const existingToast = document.querySelector('.custom-toast');
        if (existingToast) {
            existingToast.remove();
        }

        // Create toast element
        const toast = document.createElement('div');
        toast.className = 'custom-toast toast-' + type;

        // Use == instead of === for JSP compatibility
        const iconClass = (type == 'success') ? 'fa-check-circle' : 'fa-exclamation-circle';
        const bgColor = (type == 'success') ? '#059669' : '#dc2626';

        toast.innerHTML =
            '<div class="toast-content">' +
            '<i class="fas ' + iconClass + '"></i>' +
            '<span>' + message + '</span>' +
            '</div>';

        // Add styles
        toast.style.cssText =
            'position: fixed;' +
            'top: 2rem;' +
            'right: 2rem;' +
            'z-index: 9999;' +
            'background: ' + bgColor + ';' +
            'color: white;' +
            'padding: 1rem 1.5rem;' +
            'border-radius: 0.5rem;' +
            'box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);' +
            'display: flex;' +
            'align-items: center;' +
            'gap: 0.75rem;' +
            'font-weight: 500;' +
            'transform: translateX(100%);' +
            'transition: transform 0.3s ease;';

        document.body.appendChild(toast);

        // Show toast
        setTimeout(() => {
            toast.style.transform = 'translateX(0)';
        }, 100);

        // Hide toast after 3 seconds
        setTimeout(() => {
            toast.style.transform = 'translateX(100%)';
            setTimeout(() => {
                if (toast.parentNode) {
                    toast.parentNode.removeChild(toast);
                }
            }, 300);
        }, 3000);
    }

    // Handle search input
    document.addEventListener('DOMContentLoaded', function() {
        const searchInput = document.querySelector('.search-input');
        let searchTimeout;

        if (searchInput) {
            searchInput.addEventListener('input', function() {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    searchQuizzes(this.value);
                }, 500);
            });

            // Handle Enter key
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    clearTimeout(searchTimeout);
                    searchQuizzes(this.value);
                }
            });
        }
    });
</script>

</body>
</html>