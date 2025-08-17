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
    <title>${course.name} - Chi tiết Khóa học</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-color: #4f46e5;
            --primary-dark: #3730a3;
            --success-color: #059669;
            --warning-color: #d97706;
            --danger-color: #dc2626;
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

        .main-content {
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

        /* Course Header */
        .course-header {
            background: white;
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
            margin-bottom: 2rem;
        }

        .course-banner {
            height: 300px;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            position: relative;
            overflow: hidden;
        }

        .course-banner img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .course-banner-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(transparent, rgba(0,0,0,0.7));
            padding: 2rem;
            color: white;
        }

        .course-info {
            padding: 2rem;
        }

        .course-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 1rem;
        }

        .course-meta-badges {
            display: flex;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
        }

        .meta-badge {
            padding: 0.5rem 1rem;
            border-radius: 2rem;
            font-size: 0.875rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .badge-category {
            background: rgba(79, 70, 229, 0.1);
            color: var(--primary-color);
        }

        .badge-difficulty {
            background: rgba(217, 119, 6, 0.1);
            color: var(--warning-color);
        }

        .badge-status {
            background: rgba(5, 150, 105, 0.1);
            color: var(--success-color);
        }

        .badge-featured {
            background: rgba(217, 119, 6, 0.1);
            color: var(--warning-color);
        }

        /* Tabs */
        .custom-tabs {
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
            margin-bottom: 2rem;
        }

        .nav-tabs {
            border-bottom: 1px solid var(--border-color);
            padding: 0 2rem;
        }

        .nav-tabs .nav-link {
            border: none;
            color: var(--text-secondary);
            font-weight: 500;
            padding: 1.5rem 2rem;
            position: relative;
        }

        .nav-tabs .nav-link.active {
            color: var(--primary-color);
            background: none;
            border-bottom: 3px solid var(--primary-color);
        }

        .tab-content {
            padding: 2rem;
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            text-align: center;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 1rem;
            margin: 0 auto 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: var(--text-secondary);
            font-weight: 500;
        }

        /* Lesson List */
        .lesson-item {
            background: white;
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
            transition: all 0.2s ease;
        }

        .lesson-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .lesson-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1rem;
        }

        .lesson-title {
            font-weight: 600;
            color: var(--text-primary);
            font-size: 1.1rem;
        }

        .lesson-type {
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .type-video {
            background: rgba(220, 38, 38, 0.1);
            color: var(--danger-color);
        }

        .type-document {
            background: rgba(79, 70, 229, 0.1);
            color: var(--primary-color);
        }

        .type-text {
            background: rgba(5, 150, 105, 0.1);
            color: var(--success-color);
        }

        .lesson-meta {
            display: flex;
            gap: 1rem;
            font-size: 0.875rem;
            color: var(--text-secondary);
            margin-bottom: 1rem;
        }

        .lesson-actions {
            display: flex;
            gap: 0.5rem;
        }

        /* Quiz List */
        .quiz-item {
            background: white;
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
        }

        .quiz-header {
            display: flex;
            align-items: center;
            justify-content: between;
            margin-bottom: 1rem;
        }

        .quiz-title {
            font-weight: 600;
            color: var(--text-primary);
            font-size: 1.1rem;
        }

        .quiz-stats {
            display: flex;
            gap: 1.5rem;
            font-size: 0.875rem;
            color: var(--text-secondary);
        }

        /* Student List */
        .student-item {
            display: flex;
            align-items: center;
            padding: 1rem;
            background: white;
            border-radius: 0.75rem;
            margin-bottom: 0.75rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
        }

        .student-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: var(--primary-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            margin-right: 1rem;
        }

        .student-info {
            flex: 1;
        }

        .student-name {
            font-weight: 600;
            color: var(--text-primary);
        }

        .student-progress {
            font-size: 0.875rem;
            color: var(--text-secondary);
        }

        .progress-bar-container {
            width: 100%;
            height: 6px;
            background: var(--border-color);
            border-radius: 3px;
            overflow: hidden;
            margin-top: 0.5rem;
        }

        .progress-bar {
            height: 100%;
            background: var(--success-color);
            transition: width 0.3s ease;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }

        .btn-icon {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        /* Empty States */
        .empty-state {
            text-align: center;
            padding: 3rem 2rem;
            color: var(--text-secondary);
        }

        .empty-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
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
            <div class="main-content">

                <!-- Breadcrumb -->
                <nav aria-label="breadcrumb" class="mb-4">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/instructor/dashboard">Dashboard</a>
                        </li>
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/instructor/courses">Khóa học</a>
                        </li>
                        <li class="breadcrumb-item active">${course.name}</li>
                    </ol>
                </nav>

                <!-- Course Header -->
                <div class="course-header">
                    <div class="course-banner">
                        <c:choose>
                            <c:when test="${not empty course.imageUrl}">
                                <img src="${course.imageUrl}" alt="${course.name}">
                            </c:when>
                            <c:otherwise>
                                <div class="d-flex align-items-center justify-content-center h-100">
                                    <i class="fas fa-book text-white" style="font-size: 4rem; opacity: 0.3;"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div class="course-banner-overlay">
                            <div class="course-meta-badges">
                                    <span class="meta-badge badge-category">
                                        <i class="fas fa-folder"></i>
                                        ${course.category.name}
                                    </span>
                                <span class="meta-badge badge-difficulty">
                                        <i class="fas fa-signal"></i>
                                        ${course.difficultyLevel.displayName}
                                    </span>
                                <c:if test="${course.active}">
                                        <span class="meta-badge badge-status">
                                            <i class="fas fa-check-circle"></i>
                                            Đang hoạt động
                                        </span>
                                </c:if>
                                <c:if test="${course.featured}">
                                        <span class="meta-badge badge-featured">
                                            <i class="fas fa-star"></i>
                                            Nổi bật
                                        </span>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <div class="course-info">
                        <h1 class="course-title">${course.name}</h1>

                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <p class="text-muted mb-0">${course.shortDescription}</p>
                            </div>
                            <div class="col-md-4 text-end">
                                <div class="action-buttons">
                                    <a href="${pageContext.request.contextPath}/instructor/courses/${course.id}/edit"
                                       class="btn btn-primary btn-icon">
                                        <i class="fas fa-edit"></i>
                                        Chỉnh sửa
                                    </a>
                                    <div class="dropdown">
                                        <button class="btn btn-outline-secondary dropdown-toggle" type="button"
                                                data-bs-toggle="dropdown">
                                            <i class="fas fa-ellipsis-v"></i>
                                        </button>
                                        <ul class="dropdown-menu">
                                            <li>
                                                <a class="dropdown-item" href="${pageContext.request.contextPath}/courses/${course.slug}">
                                                    <i class="fas fa-eye me-2"></i>Xem như học viên
                                                </a>
                                            </li>
                                            <li>
                                                <a class="dropdown-item" href="${pageContext.request.contextPath}/instructor/courses/${course.id}/analytics">
                                                    <i class="fas fa-chart-bar me-2"></i>Thống kê chi tiết
                                                </a>
                                            </li>
                                            <li><hr class="dropdown-divider"></li>
                                            <li>
                                                <a class="dropdown-item text-danger" href="#"
                                                   onclick="confirmDelete(${course.id}, '${course.name}')">
                                                    <i class="fas fa-trash me-2"></i>Xóa khóa học
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Stats Overview -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon" style="background: var(--primary-color);">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-number">${course.enrollmentCount}</div>
                        <div class="stat-label">Học viên</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon" style="background: var(--success-color);">
                            <i class="fas fa-play-circle"></i>
                        </div>
                        <div class="stat-number">${fn:length(course.lessons)}</div>
                        <div class="stat-label">Bài học</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon" style="background: var(--warning-color);">
                            <i class="fas fa-question-circle"></i>
                        </div>
                        <div class="stat-number">${fn:length(course.quizzes)}</div>
                        <div class="stat-label">Bài kiểm tra</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon" style="background: var(--danger-color);">
                            <i class="fas fa-star"></i>
                        </div>
                        <div class="stat-number">${course.averageRating}</div>
                        <div class="stat-label">Đánh giá TB</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon" style="background: var(--text-secondary);">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="stat-number">${course.formattedDuration}</div>
                        <div class="stat-label">Thời lượng</div>
                    </div>

                    <c:if test="${course.price > 0}">
                        <div class="stat-card">
                            <div class="stat-icon" style="background: var(--success-color);">
                                <i class="fas fa-dollar-sign"></i>
                            </div>
                            <div class="stat-number">${course.formattedPrice}</div>
                            <div class="stat-label">Giá bán</div>
                        </div>
                    </c:if>
                </div>

                <!-- Tabs Content -->
                <div class="custom-tabs">
                    <ul class="nav nav-tabs" id="courseDetailTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="lessons-tab" data-bs-toggle="tab"
                                    data-bs-target="#lessons" type="button" role="tab">
                                <i class="fas fa-play-circle me-2"></i>
                                Bài học (${fn:length(course.lessons)})
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="quizzes-tab" data-bs-toggle="tab"
                                    data-bs-target="#quizzes" type="button" role="tab">
                                <i class="fas fa-question-circle me-2"></i>
                                Quiz (${fn:length(course.quizzes)})
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="students-tab" data-bs-toggle="tab"
                                    data-bs-target="#students" type="button" role="tab">
                                <i class="fas fa-users me-2"></i>
                                Học viên (${course.enrollmentCount})
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="description-tab" data-bs-toggle="tab"
                                    data-bs-target="#description" type="button" role="tab">
                                <i class="fas fa-info-circle me-2"></i>
                                Mô tả
                            </button>
                        </li>
                    </ul>

                    <div class="tab-content" id="courseDetailTabContent">
                        <!-- Lessons Tab -->
                        <div class="tab-pane fade show active" id="lessons" role="tabpanel">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h4>Danh sách bài học</h4>
                                <a href="${pageContext.request.contextPath}/instructor/lessons/new?courseId=${course.id}"
                                   class="btn btn-primary btn-icon">
                                    <i class="fas fa-plus"></i>
                                    Thêm bài học
                                </a>
                            </div>

                            <c:choose>
                                <c:when test="${not empty course.lessons}">
                                    <c:forEach var="lesson" items="${course.lessons}" varStatus="status">
                                        <div class="lesson-item">
                                            <div class="lesson-header">
                                                <div class="d-flex align-items-center">
                                                    <span class="badge bg-secondary me-3">${lesson.orderIndex}</span>
                                                    <h5 class="lesson-title mb-0">${lesson.title}</h5>
                                                </div>
                                                <span class="lesson-type type-${lesson.type.name().toLowerCase()}">
                                                        <i class="${lesson.iconClass} me-1"></i>
                                                        ${lesson.typeDisplayName}
                                                    </span>
                                            </div>

                                            <div class="lesson-meta">
                                                    <span>
                                                        <i class="fas fa-clock me-1"></i>
                                                        ${lesson.estimatedDuration} phút
                                                    </span>
                                                <span>
                                                        <i class="fas fa-eye me-1"></i>
                                                        ${lesson.preview ? 'Xem trước' : 'Yêu cầu đăng ký'}
                                                    </span>
                                                <span>
                                                        <i class="fas fa-calendar me-1"></i>
                                                        <fmt:formatDate value="${lesson.createdAt}" pattern="dd/MM/yyyy" />
                                                    </span>
                                            </div>

                                            <div class="lesson-actions">
                                                <a href="${pageContext.request.contextPath}/instructor/lessons/${lesson.id}"
                                                   class="btn btn-outline-primary btn-sm">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/instructor/lessons/${lesson.id}/edit"
                                                   class="btn btn-outline-secondary btn-sm">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <button type="button" class="btn btn-outline-danger btn-sm"
                                                        onclick="confirmDeleteLesson(${lesson.id}, '${lesson.title}')">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <i class="fas fa-play-circle empty-icon"></i>
                                        <h5>Chưa có bài học nào</h5>
                                        <p>Hãy thêm bài học đầu tiên cho khóa học này</p>
                                        <a href="${pageContext.request.contextPath}/instructor/lessons/new?courseId=${course.id}"
                                           class="btn btn-primary">
                                            <i class="fas fa-plus me-2"></i>Thêm bài học
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Quizzes Tab -->
                        <div class="tab-pane fade" id="quizzes" role="tabpanel">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h4>Danh sách bài kiểm tra</h4>
                                <a href="${pageContext.request.contextPath}/instructor/quizzes/new?courseId=${course.id}"
                                   class="btn btn-primary btn-icon">
                                    <i class="fas fa-plus"></i>
                                    Thêm quiz
                                </a>
                            </div>

                            <c:choose>
                                <c:when test="${not empty course.quizzes}">
                                    <c:forEach var="quiz" items="${course.quizzes}">
                                        <div class="quiz-item">
                                            <div class="quiz-header">
                                                <h5 class="quiz-title">${quiz.title}</h5>
                                                <div class="quiz-actions">
                                                    <a href="${pageContext.request.contextPath}/instructor/quizzes/${quiz.id}"
                                                       class="btn btn-outline-primary btn-sm">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/instructor/quizzes/${quiz.id}/edit"
                                                       class="btn btn-outline-secondary btn-sm">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-outline-danger btn-sm"
                                                            onclick="confirmDeleteQuiz(${quiz.id}, '${quiz.title}')">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </div>
                                            </div>

                                            <p class="text-muted">${quiz.description}</p>

                                            <div class="quiz-stats">
                                                    <span>
                                                        <i class="fas fa-question me-1"></i>
                                                        ${fn:length(quiz.questions)} câu hỏi
                                                    </span>
                                                <span>
                                                        <i class="fas fa-clock me-1"></i>
                                                        ${quiz.duration} phút
                                                    </span>
                                                <span>
                                                        <i class="fas fa-trophy me-1"></i>
                                                        Điểm đạt: ${quiz.passScore}/${quiz.maxScore}
                                                    </span>
                                                <span>
                                                        <i class="fas fa-users me-1"></i>
                                                        ${fn:length(quiz.quizResults)} lượt làm
                                                    </span>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <i class="fas fa-question-circle empty-icon"></i>
                                        <h5>Chưa có bài kiểm tra nào</h5>
                                        <p>Thêm quiz để đánh giá kiến thức học viên</p>
                                        <a href="${pageContext.request.contextPath}/instructor/quizzes/new?courseId=${course.id}"
                                           class="btn btn-primary">
                                            <i class="fas fa-plus me-2"></i>Thêm quiz
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Students Tab -->
                        <div class="tab-pane fade" id="students" role="tabpanel">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h4>Danh sách học viên</h4>
                                <button type="button" class="btn btn-outline-primary" onclick="exportStudents()">
                                    <i class="fas fa-download me-2"></i>Xuất danh sách
                                </button>
                            </div>

                            <c:choose>
                                <c:when test="${not empty enrollments}">
                                    <c:forEach var="enrollment" items="${enrollments}">
                                        <div class="student-item">
                                            <div class="student-avatar">
                                                    ${fn:substring(enrollment.student.fullName, 0, 1)}
                                            </div>
                                            <div class="student-info">
                                                <div class="student-name">${enrollment.student.fullName}</div>
                                                <div class="student-progress">
                                                    Đăng ký: <fmt:formatDate value="${enrollment.enrollmentDate}" pattern="dd/MM/yyyy" />
                                                    • Tiến độ: ${enrollment.progressPercentage}%
                                                </div>
                                                <div class="progress-bar-container">
                                                    <div class="progress-bar" style="width: ${enrollment.progressPercentage}%"></div>
                                                </div>
                                            </div>
                                            <div class="student-actions">
                                                <a href="${pageContext.request.contextPath}/instructor/students/${enrollment.student.id}"
                                                   class="btn btn-outline-primary btn-sm">
                                                    Xem chi tiết
                                                </a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <i class="fas fa-users empty-icon"></i>
                                        <h5>Chưa có học viên nào</h5>
                                        <p>Khóa học chưa có học viên đăng ký</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Description Tab -->
                        <div class="tab-pane fade" id="description" role="tabpanel">
                            <div class="row">
                                <div class="col-lg-8">
                                    <h4>Mô tả khóa học</h4>
                                    <div class="content-description">
                                        ${course.description}
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="card">
                                        <div class="card-header">
                                            <h6 class="card-title mb-0">Thông tin khóa học</h6>
                                        </div>
                                        <div class="card-body">
                                            <div class="info-item mb-3">
                                                <strong>Danh mục:</strong> ${course.category.name}
                                            </div>
                                            <div class="info-item mb-3">
                                                <strong>Độ khó:</strong> ${course.difficultyLevel.displayName}
                                            </div>
                                            <div class="info-item mb-3">
                                                <strong>Thời lượng:</strong> ${course.formattedDuration}
                                            </div>
                                            <c:if test="${course.price > 0}">
                                                <div class="info-item mb-3">
                                                    <strong>Giá:</strong> ${course.formattedPrice}
                                                </div>
                                            </c:if>
                                            <div class="info-item mb-3">
                                                <strong>Tạo lúc:</strong>
                                                <fmt:formatDate value="${course.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                            </div>
                                            <div class="info-item">
                                                <strong>Cập nhật:</strong>
                                                <fmt:formatDate value="${course.updatedAt}" pattern="dd/MM/yyyy HH:mm" />
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
</div>

<!-- Include Footer -->
<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>

<script>
    // Hàm xác nhận xóa khóa học
    function confirmDelete(courseId, courseName) {
        if (confirm('Bạn có chắc chắn muốn xóa khóa học "' + courseName + '"?\n\nHành động này không thể hoàn tác!')) {
            window.location.href = '${pageContext.request.contextPath}/instructor/courses/' + courseId + '/delete';
        }
    }

    // Hàm xác nhận xóa bài học
    function confirmDeleteLesson(lessonId, lessonTitle) {
        if (confirm('Bạn có chắc chắn muốn xóa bài học "' + lessonTitle + '"?')) {
            window.location.href = '${pageContext.request.contextPath}/instructor/lessons/' + lessonId + '/delete';
        }
    }

    // Hàm xác nhận xóa quiz
    function confirmDeleteQuiz(quizId, quizTitle) {
        if (confirm('Bạn có chắc chắn muốn xóa quiz "' + quizTitle + '"?')) {
            window.location.href = '${pageContext.request.contextPath}/instructor/quizzes/' + quizId + '/delete';
        }
    }

    // Hàm xuất danh sách học viên
    function exportStudents() {
        window.location.href = '${pageContext.request.contextPath}/instructor/courses/${course.id}/export-students';
    }

    // Active tab based on URL hash
    document.addEventListener('DOMContentLoaded', function() {
        const hash = window.location.hash;
        if (hash) {
            const tabTrigger = document.querySelector('[data-bs-target="' + hash + '"]');
            if (tabTrigger) {
                const tab = new bootstrap.Tab(tabTrigger);
                tab.show();
            }
        }
    });
</script>
</body>
</html>