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
    <title>
        <c:choose>
            <c:when test="${course != null}">Học: ${course.name} - EduLearn</c:when>
            <c:otherwise>Học khóa học - EduLearn</c:otherwise>
        </c:choose>
    </title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --info-color: #17a2b8;
            --light-bg: #f8f9fa;
            --dark-bg: #343a40;
            --border-color: #e9ecef;
            --text-primary: #2c3e50;
            --text-secondary: #6c757d;
            --card-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        body {
            background: var(--light-bg);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            overflow-x: hidden;
        }

        /* Learning Layout */
        .learning-layout {
            display: flex;
            height: 100vh;
            position: relative;
        }

        .video-area {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: #000;
            position: relative;
        }

        .sidebar-area {
            width: 400px;
            background: white;
            border-left: 1px solid var(--border-color);
            display: flex;
            flex-direction: column;
            transition: all 0.3s ease;
        }

        .sidebar-collapsed {
            width: 0;
            overflow: hidden;
        }

        /* Top Bar */
        .top-bar {
            background: white;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
            z-index: 10;
        }

        .course-info {
            display: flex;
            align-items: center;
            gap: 1rem;
            flex: 1;
        }

        .course-title {
            font-weight: 600;
            color: var(--text-primary);
            margin: 0;
            font-size: 1.1rem;
        }

        .course-progress {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .progress-text {
            font-size: 0.9rem;
            color: var(--text-secondary);
            white-space: nowrap;
        }

        .progress-bar-container {
            width: 200px;
            height: 6px;
            background: var(--border-color);
            border-radius: 3px;
            overflow: hidden;
        }

        .progress-bar-fill {
            height: 100%;
            background: var(--primary-color);
            border-radius: 3px;
            transition: width 0.3s ease;
        }

        .top-actions {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .btn-toggle-sidebar {
            background: none;
            border: none;
            color: var(--text-secondary);
            font-size: 1.2rem;
            padding: 0.5rem;
            border-radius: 0.5rem;
            transition: all 0.3s ease;
        }

        .btn-toggle-sidebar:hover {
            background: var(--light-bg);
            color: var(--text-primary);
        }

        .btn-back {
            background: var(--light-bg);
            border: none;
            color: var(--text-primary);
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-back:hover {
            background: var(--primary-color);
            color: white;
        }

        /* Video Player */
        .video-container {
            flex: 1;
            position: relative;
            background: #000;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .video-player {
            width: 100%;
            height: 100%;
            background: #000;
        }

        .video-placeholder {
            color: #fff;
            text-align: center;
            padding: 2rem;
        }

        .video-placeholder i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .video-placeholder h3 {
            margin-bottom: 1rem;
            opacity: 0.8;
        }

        .video-placeholder p {
            opacity: 0.6;
            margin-bottom: 0;
        }

        /* Video Controls */
        .video-controls {
            background: rgba(0, 0, 0, 0.8);
            color: white;
            padding: 1rem 1.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .lesson-navigation {
            display: flex;
            gap: 0.5rem;
        }

        .btn-nav {
            background: rgba(255, 255, 255, 0.2);
            border: none;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }

        .btn-nav:hover:not(:disabled) {
            background: rgba(255, 255, 255, 0.3);
            color: white;
        }

        .btn-nav:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .lesson-info {
            flex: 1;
            text-align: center;
        }

        .current-lesson {
            font-weight: 600;
            margin-bottom: 0.25rem;
        }

        .lesson-meta {
            font-size: 0.85rem;
            opacity: 0.8;
        }

        .lesson-actions {
            display: flex;
            gap: 0.5rem;
        }

        .btn-complete {
            background: var(--success-color);
            border: none;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-complete:hover {
            background: #218838;
            color: white;
        }

        .btn-note {
            background: var(--info-color);
            border: none;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            transition: all 0.3s ease;
        }

        .btn-note:hover {
            background: #138496;
            color: white;
        }

        /* Sidebar Content */
        .sidebar-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--border-color);
            background: var(--light-bg);
        }

        .sidebar-title {
            font-weight: 600;
            color: var(--text-primary);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .sidebar-tabs {
            display: flex;
            background: white;
            border-bottom: 1px solid var(--border-color);
        }

        .sidebar-tab {
            flex: 1;
            background: none;
            border: none;
            padding: 1rem;
            color: var(--text-secondary);
            font-weight: 500;
            transition: all 0.3s ease;
            border-bottom: 3px solid transparent;
        }

        .sidebar-tab:hover {
            background: var(--light-bg);
            color: var(--text-primary);
        }

        .sidebar-tab.active {
            color: var(--primary-color);
            border-bottom-color: var(--primary-color);
        }

        .sidebar-content {
            flex: 1;
            overflow-y: auto;
        }

        .tab-pane {
            display: none;
            height: 100%;
        }

        .tab-pane.active {
            display: block;
        }

        /* Lessons List */
        .lessons-list {
            padding: 0;
        }

        .lesson-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid var(--border-color);
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .lesson-item:hover {
            background: var(--light-bg);
        }

        .lesson-item.active {
            background: var(--primary-color);
            color: white;
        }

        .lesson-item.completed {
            background: #e8f5e8;
        }

        .lesson-item.active.completed {
            background: var(--success-color);
        }

        .lesson-number {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: var(--border-color);
            color: var(--text-secondary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 0.85rem;
            flex-shrink: 0;
        }

        .lesson-item.active .lesson-number {
            background: rgba(255, 255, 255, 0.2);
            color: white;
        }

        .lesson-item.completed .lesson-number {
            background: var(--success-color);
            color: white;
        }

        .lesson-content {
            flex: 1;
            min-width: 0;
        }

        .lesson-title {
            font-weight: 500;
            margin-bottom: 0.25rem;
            font-size: 0.9rem;
            line-height: 1.4;
        }

        .lesson-duration {
            font-size: 0.8rem;
            opacity: 0.8;
        }

        .lesson-item.active .lesson-duration {
            opacity: 0.9;
        }

        .lesson-status {
            flex-shrink: 0;
        }

        .lesson-item.completed .lesson-status i {
            color: var(--success-color);
        }

        .lesson-item.active.completed .lesson-status i {
            color: white;
        }

        /* Notes Tab */
        .notes-container {
            padding: 1.5rem;
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .notes-form {
            margin-bottom: 2rem;
        }

        .notes-textarea {
            width: 100%;
            min-height: 120px;
            border: 2px solid var(--border-color);
            border-radius: 0.5rem;
            padding: 1rem;
            font-family: inherit;
            resize: vertical;
            transition: all 0.3s ease;
        }

        .notes-textarea:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .notes-actions {
            display: flex;
            gap: 0.75rem;
            margin-top: 1rem;
        }

        .btn-save {
            background: var(--primary-color);
            border: none;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-save:hover {
            background: var(--secondary-color);
            color: white;
        }

        .notes-list {
            flex: 1;
            overflow-y: auto;
        }

        .note-item {
            background: var(--light-bg);
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1rem;
            border-left: 4px solid var(--primary-color);
        }

        .note-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5rem;
            font-size: 0.8rem;
            color: var(--text-secondary);
        }

        .note-content {
            line-height: 1.5;
            color: var(--text-primary);
        }

        /* Resources Tab */
        .resources-container {
            padding: 1.5rem;
        }

        .resource-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            background: var(--light-bg);
            border-radius: 0.5rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }

        .resource-item:hover {
            background: #e3f2fd;
        }

        .resource-icon {
            width: 40px;
            height: 40px;
            border-radius: 0.5rem;
            background: var(--primary-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .resource-info {
            flex: 1;
        }

        .resource-title {
            font-weight: 500;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }

        .resource-description {
            font-size: 0.85rem;
            color: var(--text-secondary);
        }

        .resource-actions {
            display: flex;
            gap: 0.5rem;
        }

        .btn-download {
            background: var(--info-color);
            border: none;
            color: white;
            padding: 0.5rem;
            border-radius: 0.5rem;
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .btn-download:hover {
            background: #138496;
            transform: scale(1.1);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .learning-layout {
                flex-direction: column;
            }

            .sidebar-area {
                width: 100%;
                height: 40vh;
                border-left: none;
                border-top: 1px solid var(--border-color);
            }

            .sidebar-collapsed {
                height: 0;
            }

            .top-bar {
                padding: 0.75rem 1rem;
            }

            .course-title {
                font-size: 1rem;
            }

            .progress-bar-container {
                width: 100px;
            }

            .video-controls {
                padding: 0.75rem 1rem;
                flex-wrap: wrap;
                gap: 0.75rem;
            }

            .lesson-navigation {
                order: 2;
                width: 100%;
                justify-content: center;
            }

            .lesson-info {
                order: 1;
                width: 100%;
            }

            .lesson-actions {
                order: 3;
                width: 100%;
                justify-content: center;
            }
        }

        /* Loading States */
        .loading {
            opacity: 0.6;
            pointer-events: none;
        }

        .skeleton {
            background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
            background-size: 200% 100%;
            animation: loading 1.5s infinite;
        }

        @keyframes loading {
            0% {
                background-position: 200% 0;
            }
            100% {
                background-position: -200% 0;
            }
        }
    </style>
</head>

<body>
<div class="learning-layout">
    <!-- Video Area -->
    <div class="video-area">
        <!-- Top Bar -->
        <div class="top-bar">
            <div class="course-info">
                <h1 class="course-title">
                    <c:choose>
                        <c:when test="${course != null}">${course.name}</c:when>
                        <c:otherwise>Khóa học</c:otherwise>
                    </c:choose>
                </h1>
                <div class="course-progress">
                    <span class="progress-text">
                        Tiến độ:
                        <c:choose>
                            <c:when test="${enrollment != null && enrollment.progress != null}">
                                <fmt:formatNumber value="${enrollment.progress}" maxFractionDigits="1"/>%
                            </c:when>
                            <c:otherwise>0%</c:otherwise>
                        </c:choose>
                    </span>
                    <div class="progress-bar-container">
                        <div class="progress-bar-fill"
                             style="width: <c:choose><c:when test='${enrollment != null && enrollment.progress != null}'>${enrollment.progress}</c:when><c:otherwise>0</c:otherwise></c:choose>%"></div>
                    </div>
                </div>
            </div>
            <div class="top-actions">
                <a href="${pageContext.request.contextPath}/student/course/${course.id}" class="btn-back">
                    <i class="fas fa-arrow-left"></i>Quay lại
                </a>
                <button class="btn-toggle-sidebar" onclick="toggleSidebar()">
                    <i class="fas fa-bars"></i>
                </button>
            </div>
        </div>

        <!-- Video Container -->
        <div class="video-container">
            <c:choose>
                <c:when test="${currentLesson != null && currentLesson.videoLink != null}">
                    <video class="video-player" controls>
                        <source src="${currentLesson.videoLink}" type="video/mp4">
                        Trình duyệt của bạn không hỗ trợ video.
                    </video>
                </c:when>
                <c:otherwise>
                    <div class="video-placeholder">
                        <i class="fas fa-play-circle"></i>
                        <h3>
                            <c:choose>
                                <c:when test="${currentLesson != null}">${currentLesson.title}</c:when>
                                <c:otherwise>Chọn một bài học để bắt đầu</c:otherwise>
                            </c:choose>
                        </h3>
                        <p>
                            <c:choose>
                                <c:when test="${currentLesson != null}">
                                    Video cho bài học này sẽ được cập nhật sớm.
                                </c:when>
                                <c:otherwise>
                                    Sử dụng danh sách bài học bên phải để điều hướng.
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Video Controls -->
        <div class="video-controls">
            <div class="lesson-navigation">
                <c:set var="hasPrevious" value="false" />
                <c:set var="hasNext" value="false" />

                <c:if test="${lessons != null && currentLesson != null}">
                    <c:forEach var="lesson" items="${lessons}" varStatus="lessonStatus">
                        <c:if test="${lesson.id == currentLesson.id}">
                            <c:if test="${lessonStatus.index > 0}">
                                <c:set var="hasPrevious" value="true" />
                                <c:set var="previousLesson" value="${lessons[lessonStatus.index - 1]}" />
                            </c:if>
                            <c:if test="${lessonStatus.index < fn:length(lessons) - 1}">
                                <c:set var="hasNext" value="true" />
                                <c:set var="nextLesson" value="${lessons[lessonStatus.index + 1]}" />
                            </c:if>
                        </c:if>
                    </c:forEach>
                </c:if>

                <button class="btn-nav" onclick="previousLesson()"
                        <c:if test="${!hasPrevious}">disabled</c:if>>
                    <i class="fas fa-step-backward me-1"></i>Trước
                </button>
                <button class="btn-nav" onclick="nextLesson()"
                        <c:if test="${!hasNext}">disabled</c:if>>
                    Sau<i class="fas fa-step-forward ms-1"></i>
                </button>
            </div>

            <div class="lesson-info">
                <c:if test="${currentLesson != null}">
                    <div class="current-lesson">${currentLesson.title}</div>
                    <div class="lesson-meta">
                        <c:if test="${currentLesson.estimatedDuration != null}">
                            <i class="fas fa-clock me-1"></i>
                            ${currentLesson.estimatedDuration} phút
                        </c:if>
                    </div>
                </c:if>
            </div>

            <div class="lesson-actions">
                <c:if test="${currentLesson != null}">
                    <button class="btn-complete" onclick="markComplete()">
                        <i class="fas fa-check me-1"></i>Hoàn thành
                    </button>
                </c:if>
                <button class="btn-note" onclick="showNotesTab()">
                    <i class="fas fa-sticky-note me-1"></i>Ghi chú
                </button>
            </div>
        </div>
    </div>

    <!-- Sidebar Area -->
    <div class="sidebar-area" id="sidebar">
        <!-- Sidebar Header -->
        <div class="sidebar-header">
            <h3 class="sidebar-title">
                <i class="fas fa-list-ul"></i>
                Nội dung khóa học
            </h3>
        </div>

        <!-- Sidebar Tabs -->
        <div class="sidebar-tabs">
            <button class="sidebar-tab active" onclick="showTab('lessons')">
                <i class="fas fa-play me-1"></i>Bài học
            </button>
            <button class="sidebar-tab" onclick="showTab('notes')">
                <i class="fas fa-sticky-note me-1"></i>Ghi chú
            </button>
            <button class="sidebar-tab" onclick="showTab('resources')">
                <i class="fas fa-download me-1"></i>Tài liệu
            </button>
        </div>

        <!-- Sidebar Content -->
        <div class="sidebar-content">
            <!-- Lessons Tab -->
            <div class="tab-pane active" id="lessons-tab">
                <div class="lessons-list">
                    <c:choose>
                        <c:when test="${lessons != null && fn:length(lessons) > 0}">
                            <c:forEach var="lesson" items="${lessons}" varStatus="lessonStatus">
                                <div class="lesson-item
                                    <c:if test='${currentLesson != null && lesson.id == currentLesson.id}'>active</c:if>
                                    <c:if test='${lesson.completed}'>completed</c:if>"
                                     onclick="loadLesson(${lesson.id})">
                                    <div class="lesson-number">${lessonStatus.index + 1}</div>
                                    <div class="lesson-content">
                                        <div class="lesson-title">${lesson.title}</div>
                                        <div class="lesson-duration">
                                            <c:if test="${lesson.estimatedDuration != null}">
                                                <i class="fas fa-clock me-1"></i>
                                                ${lesson.estimatedDuration} phút
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="lesson-status">
                                        <c:if test="${lesson.completed}">
                                            <i class="fas fa-check-circle"></i>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4">
                                <i class="fas fa-book-open fa-3x text-muted mb-3"></i>
                                <p class="text-muted">Chưa có bài học nào.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Notes Tab -->
            <div class="tab-pane" id="notes-tab">
                <div class="notes-container">
                    <div class="notes-form">
                        <textarea class="notes-textarea"
                                  placeholder="Viết ghi chú của bạn tại đây..."
                                  id="noteContent"></textarea>
                        <div class="notes-actions">
                            <button class="btn-save" onclick="saveNote()">
                                <i class="fas fa-save me-1"></i>Lưu ghi chú
                            </button>
                        </div>
                    </div>
                    <div class="notes-list" id="notesList">
                        <!-- Sample notes - these would come from the backend -->
                        <div class="note-item">
                            <div class="note-meta">
                                <span>Bài 1: Giới thiệu</span>
                                <span>2 giờ trước</span>
                            </div>
                            <div class="note-content">
                                Cần nhớ các khái niệm cơ bản về lập trình Java...
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Resources Tab -->
            <div class="tab-pane" id="resources-tab">
                <div class="resources-container">
                    <c:choose>
                        <c:when test="${currentLesson != null && currentLesson.documentUrl != null}">
                            <div class="resource-item">
                                <div class="resource-icon">
                                    <i class="fas fa-file-pdf"></i>
                                </div>
                                <div class="resource-info">
                                    <div class="resource-title">Tài liệu bài học</div>
                                    <div class="resource-description">PDF - ${currentLesson.title}</div>
                                </div>
                                <div class="resource-actions">
                                    <a href="${currentLesson.documentUrl}"
                                       class="btn-download"
                                       download
                                       title="Tải xuống">
                                        <i class="fas fa-download"></i>
                                    </a>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4">
                                <i class="fas fa-download fa-3x text-muted mb-3"></i>
                                <p class="text-muted">Chưa có tài liệu cho bài học này.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Toggle sidebar
    function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        sidebar.classList.toggle('sidebar-collapsed');
    }

    // Show tab
    function showTab(tabName) {
        // Update tab buttons
        document.querySelectorAll('.sidebar-tab').forEach(tab => {
            tab.classList.remove('active');
        });
        event.target.closest('.sidebar-tab').classList.add('active');

        // Update tab content
        document.querySelectorAll('.tab-pane').forEach(pane => {
            pane.classList.remove('active');
        });
        document.getElementById(tabName + '-tab').classList.add('active');
    }

    // Load lesson
    function loadLesson(lessonId) {
        // Add loading state
        document.body.classList.add('loading');

        // Navigate to lesson
        const courseId = '${course.id}';
        window.location.href = `${pageContext.request.contextPath}/student/courses/${courseId}/learn?lesson=${lessonId}`;
    }

    // Navigation functions
    function previousLesson() {
        <c:if test="${hasPrevious && previousLesson != null}">
        loadLesson(${previousLesson.id});
        </c:if>
    }

    function nextLesson() {
        <c:if test="${hasNext && nextLesson != null}">
        loadLesson(${nextLesson.id});
        </c:if>
    }

    // Mark lesson as complete
    function markComplete() {
        <c:if test="${currentLesson != null}">
        if (confirm('Đánh dấu bài học này là đã hoàn thành?')) {
            fetch(`${pageContext.request.contextPath}/api/student/lessons/${currentLesson.id}/complete`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Update UI
                        const currentLessonItem = document.querySelector('.lesson-item.active');
                        if (currentLessonItem) {
                            currentLessonItem.classList.add('completed');
                            const statusElement = currentLessonItem.querySelector('.lesson-status');
                            statusElement.innerHTML = '<i class="fas fa-check-circle"></i>';
                        }

                        // Update progress
                        const progressBar = document.querySelector('.progress-bar-fill');
                        const progressText = document.querySelector('.progress-text');
                        if (data.newProgress) {
                            progressBar.style.width = data.newProgress + '%';
                            progressText.textContent = `Tiến độ: ${data.newProgress}%`;
                        }

                        // Show success message
                        alert('Đã đánh dấu hoàn thành bài học!');
                    } else {
                        alert('Có lỗi xảy ra: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi đánh dấu hoàn thành.');
                });
        }
        </c:if>
    }

    // Show notes tab
    function showNotesTab() {
        showTab('notes');
        document.getElementById('noteContent').focus();
    }

    // Save note
    function saveNote() {
        const content = document.getElementById('noteContent').value.trim();
        if (!content) {
            alert('Vui lòng nhập nội dung ghi chú.');
            return;
        }

        <c:if test="${currentLesson != null}">
        fetch(`${pageContext.request.contextPath}/api/student/lessons/${currentLesson.id}/notes`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                content: content
            })
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Clear form
                    document.getElementById('noteContent').value = '';

                    // Add to notes list
                    const notesList = document.getElementById('notesList');
                    const noteItem = document.createElement('div');
                    noteItem.className = 'note-item';
                    noteItem.innerHTML = `
                        <div class="note-meta">
                            <span>${currentLesson.title}</span>
                            <span>Vừa xong</span>
                        </div>
                        <div class="note-content">${content}</div>
                    `;
                    notesList.insertBefore(noteItem, notesList.firstChild);

                    alert('Đã lưu ghi chú thành công!');
                } else {
                    alert('Có lỗi xảy ra: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra khi lưu ghi chú.');
            });
        </c:if>
    }

    // Keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        if (e.altKey) {
            switch(e.key) {
                case 'ArrowLeft':
                    e.preventDefault();
                    previousLesson();
                    break;
                case 'ArrowRight':
                    e.preventDefault();
                    nextLesson();
                    break;
                case 'Enter':
                    e.preventDefault();
                    markComplete();
                    break;
                case 'n':
                    e.preventDefault();
                    showNotesTab();
                    break;
            }
        }

        // Escape to toggle sidebar
        if (e.key === 'Escape') {
            toggleSidebar();
        }
    });

    // Auto-save progress on video time update
    document.addEventListener('DOMContentLoaded', function() {
        const video = document.querySelector('.video-player');
        if (video) {
            let lastSaveTime = 0;

            video.addEventListener('timeupdate', function() {
                const currentTime = Math.floor(video.currentTime);

                // Save progress every 30 seconds
                if (currentTime - lastSaveTime >= 30) {
                    lastSaveTime = currentTime;
                    saveVideoProgress(currentTime, video.duration);
                }
            });

            video.addEventListener('ended', function() {
                // Mark as complete when video ends
                markComplete();
            });
        }
    });

    // Save video progress
    function saveVideoProgress(currentTime, duration) {
        <c:if test="${currentLesson != null}">
        const progress = duration > 0 ? (currentTime / duration) * 100 : 0;

        fetch(`${pageContext.request.contextPath}/api/student/lessons/${currentLesson.id}/progress`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                currentTime: currentTime,
                duration: duration,
                progress: progress
            })
        })
            .catch(error => {
                console.error('Error saving progress:', error);
            });
        </c:if>
    }

    // Prevent accidental page refresh
    window.addEventListener('beforeunload', function(e) {
        const video = document.querySelector('.video-player');
        if (video && !video.paused) {
            e.preventDefault();
            e.returnValue = 'Bạn có chắc muốn rời khỏi trang? Video đang phát sẽ bị dừng.';
        }
    });
</script>
</body>
</html>