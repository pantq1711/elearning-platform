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
    <title>${lesson.title} - Chi Tiết Bài Học - EduLearn Platform</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Video.js CSS -->
    <link href="https://vjs.zencdn.net/8.0.4/video-js.css" rel="stylesheet">

    <style>
        /* Biến CSS cho theme */
        :root {
            --primary-color: #4f46e5;
            --primary-dark: #3730a3;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --light-bg: #f8fafc;
            --border-color: #e2e8f0;
            --text-primary: #1e293b;
            --text-secondary: #64748b;
            --sidebar-width: 280px;
        }

        body {
            background-color: var(--light-bg);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
        }

        /* Layout chính */
        .dashboard-layout {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            margin-left: var(--sidebar-width);
            padding: 2rem;
            background: var(--light-bg);
        }

        /* Header */
        .lesson-header {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            border: 1px solid var(--border-color);
            position: relative;
            overflow: hidden;
        }

        .lesson-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
        }

        .breadcrumb {
            background: transparent;
            padding: 0;
            margin-bottom: 1rem;
        }

        .breadcrumb-item a {
            color: var(--primary-color);
            text-decoration: none;
        }

        .breadcrumb-item.active {
            color: var(--text-secondary);
        }

        .lesson-title-section {
            display: flex;
            gap: 2rem;
            align-items: flex-start;
        }

        .lesson-icon-large {
            width: 80px;
            height: 80px;
            border-radius: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: white;
            flex-shrink: 0;
        }

        .lesson-icon-large.video {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
        }

        .lesson-icon-large.document {
            background: linear-gradient(135deg, var(--warning-color), #d97706);
        }

        .lesson-icon-large.text {
            background: linear-gradient(135deg, var(--success-color), #059669);
        }

        .lesson-info {
            flex: 1;
        }

        .lesson-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
            line-height: 1.3;
        }

        .lesson-meta {
            display: flex;
            gap: 2rem;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--text-secondary);
            font-size: 0.9rem;
        }

        .lesson-status {
            padding: 0.5rem 1rem;
            border-radius: 2rem;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .status-active {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success-color);
            border: 1px solid rgba(16, 185, 129, 0.3);
        }

        .status-inactive {
            background: rgba(107, 114, 128, 0.1);
            color: #6b7280;
            border: 1px solid rgba(107, 114, 128, 0.3);
        }

        .preview-badge {
            background: rgba(59, 130, 246, 0.1);
            color: #3b82f6;
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.8rem;
            font-weight: 500;
            margin-left: 1rem;
        }

        .lesson-actions {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
            flex-wrap: wrap;
        }

        .btn-custom {
            padding: 0.75rem 1.5rem;
            border-radius: 0.75rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
            border: 1px solid;
            font-size: 0.9rem;
        }

        .btn-primary-custom {
            background: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }

        .btn-primary-custom:hover {
            background: var(--primary-dark);
            border-color: var(--primary-dark);
            color: white;
            transform: translateY(-2px);
        }

        .btn-outline-custom {
            background: transparent;
            border-color: var(--border-color);
            color: var(--text-primary);
        }

        .btn-outline-custom:hover {
            background: var(--light-bg);
            color: var(--text-primary);
        }

        .btn-success-custom {
            background: var(--success-color);
            border-color: var(--success-color);
            color: white;
        }

        .btn-success-custom:hover {
            background: #059669;
            border-color: #059669;
            color: white;
        }

        .btn-danger-custom {
            background: var(--danger-color);
            border-color: var(--danger-color);
            color: white;
        }

        .btn-danger-custom:hover {
            background: #dc2626;
            border-color: #dc2626;
            color: white;
        }

        /* Content sections */
        .content-section {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            border: 1px solid var(--border-color);
            margin-bottom: 2rem;
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        /* Video section */
        .video-container {
            position: relative;
            background: #000;
            border-radius: 0.75rem;
            overflow: hidden;
            margin-bottom: 1rem;
        }

        .video-js {
            width: 100%;
            height: 400px;
        }

        .video-placeholder {
            width: 100%;
            height: 400px;
            background: linear-gradient(135deg, #1f2937, #374151);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: white;
            border-radius: 0.75rem;
        }

        .video-placeholder i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .video-info {
            background: var(--light-bg);
            padding: 1rem;
            border-radius: 0.5rem;
            margin-top: 1rem;
        }

        .video-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1rem;
            text-align: center;
        }

        .video-stat {
            background: white;
            padding: 1rem;
            border-radius: 0.5rem;
            border: 1px solid var(--border-color);
        }

        .video-stat-number {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }

        .video-stat-label {
            color: var(--text-secondary);
            font-size: 0.85rem;
        }

        /* Document section */
        .document-container {
            border: 1px solid var(--border-color);
            border-radius: 0.75rem;
            padding: 2rem;
            text-align: center;
            background: var(--light-bg);
        }

        .document-icon {
            font-size: 4rem;
            color: var(--warning-color);
            margin-bottom: 1rem;
        }

        .document-info {
            margin-bottom: 1.5rem;
        }

        .document-name {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .document-meta {
            color: var(--text-secondary);
            font-size: 0.9rem;
        }

        /* Text content */
        .lesson-content {
            line-height: 1.8;
            color: var(--text-primary);
            font-size: 1rem;
        }

        .lesson-content h1,
        .lesson-content h2,
        .lesson-content h3,
        .lesson-content h4,
        .lesson-content h5,
        .lesson-content h6 {
            color: var(--text-primary);
            margin-top: 2rem;
            margin-bottom: 1rem;
        }

        .lesson-content p {
            margin-bottom: 1.5rem;
        }

        .lesson-content ul,
        .lesson-content ol {
            margin-bottom: 1.5rem;
            padding-left: 2rem;
        }

        .lesson-content li {
            margin-bottom: 0.5rem;
        }

        .lesson-content blockquote {
            border-left: 4px solid var(--primary-color);
            padding-left: 1.5rem;
            margin: 2rem 0;
            font-style: italic;
            color: var(--text-secondary);
        }

        .lesson-content code {
            background: var(--light-bg);
            padding: 0.25rem 0.5rem;
            border-radius: 0.25rem;
            font-family: 'Courier New', monospace;
            color: var(--danger-color);
        }

        .lesson-content pre {
            background: var(--light-bg);
            padding: 1.5rem;
            border-radius: 0.5rem;
            overflow-x: auto;
            border: 1px solid var(--border-color);
        }

        /* Stats section */
        .lesson-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
        }

        .stat-card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            border: 1px solid var(--border-color);
            text-align: center;
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
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

        .stat-icon.primary {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
        }

        .stat-icon.success {
            background: linear-gradient(135deg, var(--success-color), #059669);
        }

        .stat-icon.warning {
            background: linear-gradient(135deg, var(--warning-color), #d97706);
        }

        .stat-number {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }

        .stat-label {
            color: var(--text-secondary);
            font-size: 0.9rem;
            font-weight: 500;
        }

        /* Alert messages */
        .alert-custom {
            border-radius: 0.75rem;
            border: none;
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .alert-success {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success-color);
            border-left: 4px solid var(--success-color);
        }

        .alert-danger {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger-color);
            border-left: 4px solid var(--danger-color);
        }

        .alert-warning {
            background: rgba(245, 158, 11, 0.1);
            color: var(--warning-color);
            border-left: 4px solid var(--warning-color);
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .main-content {
                margin-left: 0;
                padding: 1rem;
            }

            .lesson-title-section {
                flex-direction: column;
                gap: 1rem;
            }

            .lesson-icon-large {
                width: 60px;
                height: 60px;
                font-size: 1.5rem;
                align-self: center;
            }

            .lesson-stats {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .lesson-header {
                padding: 1.5rem;
            }

            .content-section {
                padding: 1.5rem;
            }

            .lesson-actions {
                flex-direction: column;
            }

            .btn-custom {
                justify-content: center;
            }

            .lesson-stats {
                grid-template-columns: 1fr;
            }

            .video-js {
                height: 250px;
            }

            .video-placeholder {
                height: 250px;
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
        <!-- Lesson Header -->
        <div class="lesson-header">
            <!-- Breadcrumb -->
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/instructor/dashboard">
                            <i class="fas fa-home me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/instructor/courses">Khóa học</a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/instructor/courses/${lesson.course.id}">
                            ${lesson.course.name}
                        </a>
                    </li>
                    <li class="breadcrumb-item active">${lesson.title}</li>
                </ol>
            </nav>

            <!-- Lesson Title Section -->
            <div class="lesson-title-section">
                <div class="lesson-icon-large ${fn:toLowerCase(lesson.type)}">
                    <c:choose>
                        <c:when test="${lesson.type == 'VIDEO'}">
                            <i class="fas fa-play"></i>
                        </c:when>
                        <c:when test="${lesson.type == 'DOCUMENT'}">
                            <i class="fas fa-file-alt"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-text-height"></i>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="lesson-info">
                    <h1 class="lesson-title">
                        ${lesson.title}
                        <c:if test="${lesson.preview}">
                            <span class="preview-badge">
                                <i class="fas fa-eye"></i> Xem trước
                            </span>
                        </c:if>
                    </h1>

                    <div class="lesson-meta">
                        <div class="meta-item">
                            <i class="fas fa-book"></i>
                            <span>${lesson.course.name}</span>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-sort-numeric-up"></i>
                            <span>Thứ tự: ${lesson.orderIndex}</span>
                        </div>
                        <c:if test="${lesson.duration != null && lesson.duration > 0}">
                            <div class="meta-item">
                                <i class="fas fa-clock"></i>
                                <span>${lesson.duration} phút</span>
                            </div>
                        </c:if>
                        <div class="meta-item">
                            <i class="fas fa-calendar"></i>
                            <span><fmt:formatDate value="${lesson.createdAt}" pattern="dd/MM/yyyy" /></span>
                        </div>
                        <div class="meta-item">
                            <span class="lesson-status ${lesson.active ? 'status-active' : 'status-inactive'}">
                                <i class="fas fa-${lesson.active ? 'check-circle' : 'times-circle'}"></i>
                                ${lesson.active ? 'Hoạt động' : 'Tạm dừng'}
                            </span>
                        </div>
                    </div>

                    <c:if test="${not empty lesson.description}">
                        <p style="color: var(--text-secondary); line-height: 1.6; margin-bottom: 1rem;">
                                ${lesson.description}
                        </p>
                    </c:if>

                    <div class="lesson-actions">
                        <a href="${pageContext.request.contextPath}/instructor/lessons/${lesson.id}/edit"
                           class="btn-custom btn-primary-custom">
                            <i class="fas fa-edit"></i>
                            Chỉnh sửa bài học
                        </a>

                        <c:if test="${!lesson.active}">
                            <button type="button"
                                    class="btn-custom btn-success-custom"
                                    onclick="toggleLessonStatus(${lesson.id}, true)">
                                <i class="fas fa-play"></i>
                                Kích hoạt
                            </button>
                        </c:if>

                        <c:if test="${lesson.active}">
                            <button type="button"
                                    class="btn-custom btn-outline-custom"
                                    onclick="toggleLessonStatus(${lesson.id}, false)">
                                <i class="fas fa-pause"></i>
                                Tạm dừng
                            </button>
                        </c:if>

                        <a href="${pageContext.request.contextPath}/lesson/${lesson.id}"
                           class="btn-custom btn-outline-custom"
                           target="_blank">
                            <i class="fas fa-external-link-alt"></i>
                            Xem như học viên
                        </a>

                        <button type="button"
                                class="btn-custom btn-danger-custom"
                                onclick="deleteLesson(${lesson.id}, '${lesson.title}')">
                            <i class="fas fa-trash"></i>
                            Xóa bài học
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Alert Messages -->
        <c:if test="${not empty success}">
            <div class="alert-custom alert-success">
                <i class="fas fa-check-circle"></i>
                <span>${success}</span>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert-custom alert-danger">
                <i class="fas fa-exclamation-triangle"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <c:if test="${not empty warning}">
            <div class="alert-custom alert-warning">
                <i class="fas fa-exclamation-triangle"></i>
                <span>${warning}</span>
            </div>
        </c:if>

        <!-- Statistics -->
        <div class="content-section">
            <h3 class="section-title">
                <i class="fas fa-chart-bar"></i>
                Thống kê bài học
            </h3>

            <div class="lesson-stats">
                <div class="stat-card">
                    <div class="stat-icon primary">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-number">${lessonStats.totalViews}</div>
                    <div class="stat-label">Lượt xem</div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon success">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stat-number">${lessonStats.completedViews}</div>
                    <div class="stat-label">Hoàn thành</div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon warning">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-number">${lessonStats.averageWatchTime}</div>
                    <div class="stat-label">Thời gian xem TB (phút)</div>
                </div>
            </div>
        </div>

        <!-- Lesson Content -->
        <div class="content-section">
            <h3 class="section-title">
                <i class="fas fa-${lesson.type == 'VIDEO' ? 'play' : lesson.type == 'DOCUMENT' ? 'file-alt' : 'text-height'}"></i>
                Nội dung bài học
            </h3>

            <c:choose>
                <%-- Video Content --%>
                <c:when test="${lesson.type == 'VIDEO'}">
                    <c:choose>
                        <c:when test="${not empty lesson.videoUrl}">
                            <div class="video-container">
                                <c:choose>
                                    <c:when test="${fn:contains(lesson.videoUrl, 'youtube.com') || fn:contains(lesson.videoUrl, 'youtu.be')}">
                                        <!-- YouTube Video -->
                                        <iframe width="100%" height="400"
                                                src="${lesson.videoUrl.replace('watch?v=', 'embed/').replace('youtu.be/', 'youtube.com/embed/')}"
                                                frameborder="0"
                                                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                                                allowfullscreen>
                                        </iframe>
                                    </c:when>
                                    <c:when test="${fn:contains(lesson.videoUrl, 'vimeo.com')}">
                                        <!-- Vimeo Video -->
                                        <iframe width="100%" height="400"
                                                src="${lesson.videoUrl.replace('vimeo.com/', 'player.vimeo.com/video/')}"
                                                frameborder="0"
                                                allow="autoplay; fullscreen; picture-in-picture"
                                                allowfullscreen>
                                        </iframe>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Direct Video URL -->
                                        <video class="video-js vjs-default-skin" controls preload="auto" data-setup="{}">
                                            <source src="${lesson.videoUrl}" type="video/mp4">
                                            <p class="vjs-no-js">
                                                Để xem video này, vui lòng
                                                <a href="https://videojs.com/html5-video-support/" target="_blank">
                                                    kích hoạt JavaScript
                                                </a>, và cân nhắc nâng cấp lên trình duyệt hỗ trợ
                                                <a href="https://videojs.com/html5-video-support/" target="_blank">
                                                    HTML5 video
                                                </a>.
                                            </p>
                                        </video>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="video-info">
                                <div class="video-stats">
                                    <div class="video-stat">
                                        <div class="video-stat-number">${lessonStats.totalViews}</div>
                                        <div class="video-stat-label">Lượt xem</div>
                                    </div>
                                    <div class="video-stat">
                                        <div class="video-stat-number">${lessonStats.averageWatchTime}%</div>
                                        <div class="video-stat-label">Tỷ lệ xem hết</div>
                                    </div>
                                    <div class="video-stat">
                                        <div class="video-stat-number">${lesson.duration != null ? lesson.duration : 'N/A'}</div>
                                        <div class="video-stat-label">Thời lượng (phút)</div>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="video-placeholder">
                                <i class="fas fa-video"></i>
                                <h4>Chưa có video</h4>
                                <p>Hãy chỉnh sửa bài học để thêm video</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:when>

                <%-- Document Content --%>
                <c:when test="${lesson.type == 'DOCUMENT'}">
                    <c:choose>
                        <c:when test="${not empty lesson.documentUrl}">
                            <div class="document-container">
                                <div class="document-icon">
                                    <i class="fas fa-file-alt"></i>
                                </div>
                                <div class="document-info">
                                    <div class="document-name">Tài liệu bài học</div>
                                    <div class="document-meta">
                                        <c:choose>
                                            <c:when test="${fn:contains(lesson.documentUrl, '.pdf')}">
                                                Định dạng: PDF
                                            </c:when>
                                            <c:when test="${fn:contains(lesson.documentUrl, '.doc')}">
                                                Định dạng: Microsoft Word
                                            </c:when>
                                            <c:when test="${fn:contains(lesson.documentUrl, '.ppt')}">
                                                Định dạng: PowerPoint
                                            </c:when>
                                            <c:otherwise>
                                                Tài liệu đính kèm
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <a href="${lesson.documentUrl}"
                                   class="btn-custom btn-primary-custom"
                                   target="_blank">
                                    <i class="fas fa-download"></i>
                                    Tải xuống tài liệu
                                </a>
                            </div>

                            <!-- Embed PDF nếu có thể -->
                            <c:if test="${fn:contains(lesson.documentUrl, '.pdf')}">
                                <div style="margin-top: 2rem;">
                                    <iframe src="${lesson.documentUrl}"
                                            width="100%"
                                            height="600"
                                            style="border: 1px solid var(--border-color); border-radius: 0.5rem;">
                                    </iframe>
                                </div>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <div class="document-container">
                                <div class="document-icon" style="color: var(--text-secondary);">
                                    <i class="fas fa-file"></i>
                                </div>
                                <div class="document-info">
                                    <div class="document-name">Chưa có tài liệu</div>
                                    <div class="document-meta">Hãy chỉnh sửa bài học để thêm tài liệu</div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:when>

                <%-- Text Content --%>
                <c:otherwise>
                    <c:choose>
                        <c:when test="${not empty lesson.content}">
                            <div class="lesson-content">
                                    ${lesson.content}
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="text-align: center; padding: 3rem; color: var(--text-secondary);">
                                <i class="fas fa-text-height" style="font-size: 3rem; margin-bottom: 1rem; opacity: 0.5;"></i>
                                <h4>Chưa có nội dung</h4>
                                <p>Hãy chỉnh sửa bài học để thêm nội dung</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://vjs.zencdn.net/8.0.4/video.min.js"></script>

<script>
    $(document).ready(function() {
        // Animation cho stats cards
        $('.stat-card').each(function(index) {
            $(this).css({
                'opacity': '0',
                'transform': 'translateY(20px)'
            });

            setTimeout(() => {
                $(this).css({
                    'transition': 'all 0.5s ease',
                    'opacity': '1',
                    'transform': 'translateY(0)'
                });
            }, index * 150);
        });
    });

    /**
     * Thay đổi trạng thái bài học
     */
    function toggleLessonStatus(lessonId, newStatus) {
        const statusText = newStatus ? 'kích hoạt' : 'tạm dừng';

        if (confirm(`Bạn có chắc muốn ${statusText} bài học này?`)) {
            $.ajax({
                url: `${pageContext.request.contextPath}/instructor/lessons/${lessonId}/toggle-status`,
                method: 'POST',
                data: {
                    active: newStatus,
                    '${_csrf.parameterName}': '${_csrf.token}'
                },
                success: function(response) {
                    showToast(`${statusText.charAt(0).toUpperCase() + statusText.slice(1)} bài học thành công!`, 'success');

                    // Reload page sau 1 giây
                    setTimeout(() => {
                        location.reload();
                    }, 1000);
                },
                error: function(xhr) {
                    showToast('Có lỗi xảy ra khi thay đổi trạng thái bài học!', 'error');
                }
            });
        }
    }

    /**
     * Xóa bài học
     */
    function deleteLesson(lessonId, lessonTitle) {
        if (confirm(`Bạn có chắc muốn xóa bài học "${lessonTitle}"?\n\nHành động này không thể hoàn tác!`)) {
            $.ajax({
                url: `${pageContext.request.contextPath}/instructor/lessons/${lessonId}/delete`,
                method: 'POST',
                data: {
                    '${_csrf.parameterName}': '${_csrf.token}'
                },
                success: function(response) {
                    showToast('Xóa bài học thành công!', 'success');

                    // Chuyển hướng về trang khóa học sau 1 giây
                    setTimeout(() => {
                        window.location.href = '${pageContext.request.contextPath}/instructor/courses/${lesson.course.id}';
                    }, 1000);
                },
                error: function(xhr) {
                    const errorMessage = xhr.responseJSON ? xhr.responseJSON.message : 'Có lỗi xảy ra khi xóa bài học!';
                    showToast(errorMessage, 'error');
                }
            });
        }
    }

    /**
     * Hiển thị toast notification
     */
    function showToast(message, type = 'info') {
        const bgClass = type === 'success' ? 'bg-success' :
            type === 'error' ? 'bg-danger' : 'bg-info';

        const toast = $(`
            <div class="toast align-items-center text-white ${bgClass} border-0" role="alert"
                 style="position: fixed; top: 20px; right: 20px; z-index: 1055;">
                <div class="d-flex">
                    <div class="toast-body">
                        <i class="fas fa-${type eq 'success' ? 'check' : type eq 'error' ? 'exclamation-triangle' : 'info'}-circle me-2"></i>
                        ${message}
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto"
                            onclick="$(this).closest('.toast').remove()"></button>
                </div>
            </div>
        `);

        $('body').append(toast);

        setTimeout(() => {
            toast.remove();
        }, 5000);
    }

    // Copy lesson link function
    function copyLessonLink() {
        const link = `${window.location.origin}${pageContext.request.contextPath}/lesson/${lesson.id}`;
        navigator.clipboard.writeText(link).then(function() {
            showToast('Đã copy link bài học!', 'success');
        });
    }

    // Export lesson stats function
    function exportStats() {
        window.open(`${pageContext.request.contextPath}/instructor/lessons/${lesson.id}/export-stats`, '_blank');
    }
</script>

</body>
</html>