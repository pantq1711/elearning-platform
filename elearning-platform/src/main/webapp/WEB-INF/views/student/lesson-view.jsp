<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${lesson.title} - ${course.name}</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        /* CSS tùy chỉnh cho trang xem bài giảng */
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #28a745;
            --info-color: #17a2b8;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --dark-color: #2c3e50;
        }

        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .lesson-layout {
            min-height: 100vh;
            display: flex;
        }

        .lesson-sidebar {
            width: 350px;
            background: white;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
            overflow-y: auto;
            max-height: 100vh;
            position: sticky;
            top: 0;
        }

        .lesson-main {
            flex: 1;
            background: #fff;
            overflow-y: auto;
        }

        .course-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 1.5rem;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .course-title {
            font-size: 1.2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .course-instructor {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        .progress-section {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #e9ecef;
        }

        .progress-label {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--dark-color);
        }

        .progress-percentage {
            color: var(--primary-color);
            font-weight: 700;
        }

        .progress {
            height: 8px;
            border-radius: 10px;
            background: #f1f3f4;
        }

        .progress-bar {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            border-radius: 10px;
        }

        .lesson-list {
            padding: 0;
        }

        .lesson-item {
            border-bottom: 1px solid #f1f3f4;
            transition: all 0.3s ease;
        }

        .lesson-item:last-child {
            border-bottom: none;
        }

        .lesson-link {
            display: block;
            padding: 1rem 1.5rem;
            text-decoration: none;
            color: inherit;
            transition: all 0.3s ease;
        }

        .lesson-link:hover {
            background: #f8f9fa;
            color: inherit;
        }

        .lesson-item.active .lesson-link {
            background: rgba(102, 126, 234, 0.1);
            border-left: 4px solid var(--primary-color);
            color: var(--primary-color);
        }

        .lesson-number {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: #e9ecef;
            color: #6c757d;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            font-weight: 600;
            margin-right: 1rem;
            flex-shrink: 0;
        }

        .lesson-item.completed .lesson-number {
            background: var(--success-color);
            color: white;
        }

        .lesson-item.active .lesson-number {
            background: var(--primary-color);
            color: white;
        }

        .lesson-info {
            flex: 1;
        }

        .lesson-title-sidebar {
            font-weight: 600;
            margin-bottom: 0.25rem;
            font-size: 0.9rem;
            line-height: 1.3;
        }

        .lesson-meta {
            font-size: 0.8rem;
            color: #6c757d;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .lesson-status {
            margin-left: auto;
            font-size: 1rem;
        }

        .lesson-status.completed {
            color: var(--success-color);
        }

        .lesson-status.current {
            color: var(--primary-color);
        }

        .lesson-content {
            padding: 2rem;
        }

        .lesson-header {
            border-bottom: 1px solid #e9ecef;
            padding-bottom: 1.5rem;
            margin-bottom: 2rem;
        }

        .lesson-title-main {
            font-size: 2rem;
            font-weight: 700;
            color: var(--dark-color);
            margin-bottom: 1rem;
        }

        .lesson-meta-main {
            display: flex;
            align-items: center;
            gap: 2rem;
            font-size: 0.95rem;
            color: #6c757d;
        }

        .video-container {
            position: relative;
            width: 100%;
            padding-bottom: 56.25%; /* 16:9 aspect ratio */
            height: 0;
            margin-bottom: 2rem;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .video-container iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }

        .video-placeholder {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 4rem;
        }

        .lesson-content-text {
            font-size: 1.1rem;
            line-height: 1.8;
            color: #2c3e50;
            margin-bottom: 2rem;
        }

        .lesson-content-text h1,
        .lesson-content-text h2,
        .lesson-content-text h3 {
            color: var(--dark-color);
            margin-top: 2rem;
            margin-bottom: 1rem;
        }

        .lesson-content-text p {
            margin-bottom: 1.5rem;
        }

        .lesson-content-text ul,
        .lesson-content-text ol {
            margin-bottom: 1.5rem;
            padding-left: 2rem;
        }

        .lesson-content-text li {
            margin-bottom: 0.5rem;
        }

        .lesson-actions {
            position: sticky;
            bottom: 0;
            background: white;
            padding: 1.5rem 2rem;
            border-top: 1px solid #e9ecef;
            box-shadow: 0 -2px 10px rgba(0,0,0,0.1);
        }

        .lesson-navigation {
            display: flex;
            justify-content: between;
            align-items: center;
            gap: 1rem;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            border: none;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }

        .completion-status {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 1rem;
            background: rgba(40, 167, 69, 0.1);
            border: 1px solid rgba(40, 167, 69, 0.2);
            border-radius: 8px;
            color: var(--success-color);
            margin-bottom: 1rem;
        }

        .resources-section {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .resources-title {
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--dark-color);
        }

        .resource-item {
            display: flex;
            align-items: center;
            padding: 0.5rem 0;
            border-bottom: 1px solid #e9ecef;
        }

        .resource-item:last-child {
            border-bottom: none;
        }

        .resource-icon {
            width: 30px;
            text-align: center;
            margin-right: 1rem;
            color: var(--primary-color);
        }

        .notes-section {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 2rem;
        }

        .notes-title {
            font-weight: 600;
            color: #856404;
            margin-bottom: 0.5rem;
        }

        .notes-content {
            color: #856404;
            font-size: 0.95rem;
        }

        .quiz-prompt {
            background: rgba(102, 126, 234, 0.1);
            border: 1px solid rgba(102, 126, 234, 0.2);
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .quiz-prompt-title {
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        .mobile-sidebar-toggle {
            display: none;
            position: fixed;
            top: 20px;
            left: 20px;
            z-index: 1000;
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        @media (max-width: 768px) {
            .lesson-layout {
                flex-direction: column;
            }

            .lesson-sidebar {
                width: 100%;
                max-height: none;
                position: fixed;
                top: 0;
                left: -100%;
                z-index: 999;
                transition: left 0.3s ease;
            }

            .lesson-sidebar.show {
                left: 0;
            }

            .lesson-main {
                width: 100%;
            }

            .mobile-sidebar-toggle {
                display: block;
            }

            .lesson-content {
                padding: 1rem;
                padding-top: 80px; /* Space for mobile toggle button */
            }

            .lesson-actions {
                padding: 1rem;
            }

            .lesson-title-main {
                font-size: 1.5rem;
            }

            .lesson-meta-main {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.5rem;
            }
        }
    </style>
</head>
<body>

<!-- Mobile Sidebar Toggle -->
<button class="mobile-sidebar-toggle" onclick="toggleSidebar()">
    <i class="fas fa-bars"></i>
</button>

<div class="lesson-layout">
    <!-- Lesson Sidebar -->
    <div class="lesson-sidebar" id="lessonSidebar">
        <!-- Course Header -->
        <div class="course-header">
            <h5 class="course-title">${course.name}</h5>
            <p class="course-instructor mb-0">
                <i class="fas fa-user me-1"></i>
                ${course.instructor.username}
            </p>
        </div>

        <!-- Progress Section -->
        <div class="progress-section">
            <div class="progress-label">
                <span>Tiến độ khóa học</span>
                <span class="progress-percentage">
                    ${enrollment.progressPercentage != null ? enrollment.progressPercentage : 0}%
                </span>
            </div>
            <div class="progress">
                <div class="progress-bar"
                     style="width: ${enrollment.progressPercentage != null ? enrollment.progressPercentage : 0}%">
                </div>
            </div>
        </div>

        <!-- Lesson List -->
        <div class="lesson-list">
            <c:forEach items="${lessons}" var="lessonItem" varStatus="status">
                <div class="lesson-item ${lessonItem.id == lesson.id ? 'active' : ''} ${lessonItem.completed ? 'completed' : ''}">
                    <a href="/student/my-courses/${course.id}/lessons/${lessonItem.id}" class="lesson-link">
                        <div class="d-flex align-items-center">
                            <div class="lesson-number">
                                <c:choose>
                                    <c:when test="${lessonItem.completed}">
                                        <i class="fas fa-check"></i>
                                    </c:when>
                                    <c:when test="${lessonItem.id == lesson.id}">
                                        <i class="fas fa-play"></i>
                                    </c:when>
                                    <c:otherwise>
                                        ${lessonItem.orderIndex}
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="lesson-info">
                                <div class="lesson-title-sidebar">${lessonItem.title}</div>
                                <div class="lesson-meta">
                                    <span>
                                        <i class="fas fa-clock me-1"></i>
                                        ${lessonItem.estimatedDuration} phút
                                    </span>
                                    <c:if test="${lessonItem.videoLink != null}">
                                        <span>
                                            <i class="fas fa-play-circle me-1"></i>
                                            Video
                                        </span>
                                    </c:if>
                                </div>
                            </div>

                            <div class="lesson-status ${lessonItem.completed ? 'completed' : (lessonItem.id == lesson.id ? 'current' : '')}">
                                <c:choose>
                                    <c:when test="${lessonItem.completed}">
                                        <i class="fas fa-check-circle"></i>
                                    </c:when>
                                    <c:when test="${lessonItem.id == lesson.id}">
                                        <i class="fas fa-dot-circle"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="far fa-circle"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>

        <!-- Back to Course -->
        <div class="p-3 border-top">
            <a href="/student/my-courses/${course.id}" class="btn btn-outline-primary w-100">
                <i class="fas fa-arrow-left me-2"></i>
                Về tổng quan khóa học
            </a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="lesson-main">
        <div class="lesson-content">
            <!-- Lesson Header -->
            <div class="lesson-header">
                <h1 class="lesson-title-main">${lesson.title}</h1>
                <div class="lesson-meta-main">
                    <span>
                        <i class="fas fa-list-ol me-1"></i>
                        Bài ${lesson.orderIndex} / ${lessons.size()}
                    </span>
                    <span>
                        <i class="fas fa-clock me-1"></i>
                        Thời lượng: ${lesson.estimatedDuration} phút
                    </span>
                    <span>
                        <i class="fas fa-calendar me-1"></i>
                        <fmt:formatDate value="${lesson.createdAt}" pattern="dd/MM/yyyy"/>
                    </span>
                </div>
            </div>

            <!-- Completion Status (if completed) -->
            <c:if test="${lesson.completed}">
                <div class="completion-status">
                    <i class="fas fa-check-circle"></i>
                    <span>Bạn đã hoàn thành bài học này!</span>
                </div>
            </c:if>

            <!-- Video Section -->
            <c:if test="${not empty lesson.videoLink}">
                <div class="video-container">
                    <c:choose>
                        <c:when test="${lesson.videoLink.contains('youtube.com') || lesson.videoLink.contains('youtu.be')}">
                            <!-- YouTube video embed -->
                            <c:set var="videoId" value="${lesson.videoLink.contains('youtube.com/watch?v=') ?
                                lesson.videoLink.substring(lesson.videoLink.indexOf('v=') + 2) :
                                lesson.videoLink.substring(lesson.videoLink.lastIndexOf('/') + 1)}"/>
                            <iframe src="https://www.youtube.com/embed/${videoId}"
                                    frameborder="0"
                                    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                                    allowfullscreen>
                            </iframe>
                        </c:when>
                        <c:otherwise>
                            <!-- Other video types or placeholder -->
                            <div class="video-placeholder">
                                <div class="text-center">
                                    <i class="fas fa-play-circle mb-3"></i>
                                    <br>
                                    <a href="${lesson.videoLink}" target="_blank" class="btn btn-light">
                                        <i class="fas fa-external-link-alt me-2"></i>
                                        Xem video
                                    </a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <!-- Lesson Content -->
            <div class="lesson-content-text">
                ${lesson.content}
            </div>

            <!-- Resources Section (if any) -->
            <c:if test="${not empty lesson.resources}">
                <div class="resources-section">
                    <h5 class="resources-title">
                        <i class="fas fa-download me-2"></i>
                        Tài liệu tham khảo
                    </h5>
                    <c:forEach items="${lesson.resources}" var="resource">
                        <div class="resource-item">
                            <div class="resource-icon">
                                <i class="fas fa-file-pdf"></i>
                            </div>
                            <div class="flex-grow-1">
                                <a href="${resource.url}" target="_blank" class="text-decoration-none">
                                        ${resource.name}
                                </a>
                                <small class="text-muted d-block">${resource.description}</small>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <!-- Notes Section -->
            <c:if test="${not empty lesson.notes}">
                <div class="notes-section">
                    <h6 class="notes-title">
                        <i class="fas fa-sticky-note me-2"></i>
                        Ghi chú quan trọng
                    </h6>
                    <div class="notes-content">
                            ${lesson.notes}
                    </div>
                </div>
            </c:if>

            <!-- Quiz Prompt (if quiz available) -->
            <c:if test="${not empty nextQuiz}">
                <div class="quiz-prompt">
                    <h5 class="quiz-prompt-title">
                        <i class="fas fa-question-circle me-2"></i>
                        Bài kiểm tra: ${nextQuiz.title}
                    </h5>
                    <p class="mb-3">${nextQuiz.description}</p>
                    <div class="d-flex align-items-center justify-content-between">
                        <div class="text-muted">
                            <small>
                                <i class="fas fa-clock me-1"></i>
                                Thời gian: ${nextQuiz.duration} phút |
                                <i class="fas fa-star me-1"></i>
                                Điểm tối đa: ${nextQuiz.maxScore}
                            </small>
                        </div>
                        <a href="/student/my-courses/${course.id}/quizzes/${nextQuiz.id}"
                           class="btn btn-warning">
                            <i class="fas fa-play me-2"></i>
                            Làm bài kiểm tra
                        </a>
                    </div>
                </div>
            </c:if>
        </div>

        <!-- Lesson Actions -->
        <div class="lesson-actions">
            <div class="lesson-navigation">
                <!-- Previous Lesson -->
                <div>
                    <c:if test="${not empty previousLesson}">
                        <a href="/student/my-courses/${course.id}/lessons/${previousLesson.id}"
                           class="btn btn-outline-primary">
                            <i class="fas fa-arrow-left me-2"></i>
                            Bài trước
                        </a>
                    </c:if>
                </div>

                <!-- Mark as Complete / Continue -->
                <div class="d-flex align-items-center gap-2">
                    <c:choose>
                        <c:when test="${lesson.completed}">
                            <span class="text-success">
                                <i class="fas fa-check-circle me-2"></i>
                                Đã hoàn thành
                            </span>
                        </c:when>
                        <c:otherwise>
                            <form method="post" action="/student/my-courses/${course.id}/lessons/${lesson.id}/complete" class="d-inline">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-check me-2"></i>
                                    Hoàn thành bài học
                                </button>
                            </form>
                        </c:otherwise>
                    </c:choose>

                    <!-- Next Lesson -->
                    <c:if test="${not empty nextLesson}">
                        <a href="/student/my-courses/${course.id}/lessons/${nextLesson.id}"
                           class="btn btn-primary-custom">
                            Bài tiếp theo
                            <i class="fas fa-arrow-right ms-2"></i>
                        </a>
                    </c:if>

                    <!-- If no next lesson, show completion or quiz -->
                    <c:if test="${empty nextLesson}">
                        <c:choose>
                            <c:when test="${not empty courseQuizzes}">
                                <a href="/student/my-courses/${course.id}/quizzes"
                                   class="btn btn-warning">
                                    <i class="fas fa-question-circle me-2"></i>
                                    Làm bài kiểm tra
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="/student/my-courses/${course.id}/complete"
                                   class="btn btn-success">
                                    <i class="fas fa-trophy me-2"></i>
                                    Hoàn thành khóa học
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JavaScript -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Auto-mark lesson as viewed after 30 seconds
        setTimeout(function() {
            if (!document.querySelector('.completion-status')) {
                // Send AJAX request to mark as viewed
                fetch(`/student/my-courses/${course.id}/lessons/${lesson.id}/view`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest',
                        '${_csrf.headerName}': '${_csrf.token}'
                    }
                }).catch(error => console.log('View tracking failed:', error));
            }
        }, 30000);

        // Progress bar animation
        const progressBar = document.querySelector('.progress-bar');
        if (progressBar) {
            const width = progressBar.style.width;
            progressBar.style.width = '0%';
            setTimeout(() => {
                progressBar.style.transition = 'width 1s ease-in-out';
                progressBar.style.width = width;
            }, 500);
        }

        // Video progress tracking (for YouTube videos)
        const iframe = document.querySelector('iframe[src*="youtube.com"]');
        if (iframe) {
            // YouTube Player API for progress tracking
            const tag = document.createElement('script');
            tag.src = "https://www.youtube.com/iframe_api";
            const firstScriptTag = document.getElementsByTagName('script')[0];
            firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

            let player;
            window.onYouTubeIframeAPIReady = function() {
                const videoId = iframe.src.match(/embed\/([^?]*)/)[1];
                player = new YT.Player(iframe, {
                    videoId: videoId,
                    events: {
                        'onStateChange': onPlayerStateChange
                    }
                });
            };

            function onPlayerStateChange(event) {
                if (event.data == YT.PlayerState.ENDED) {
                    // Video completed, mark lesson as viewed
                    fetch(`/student/my-courses/${course.id}/lessons/${lesson.id}/video-complete`, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            '${_csrf.headerName}': '${_csrf.token}'
                        }
                    });
                }
            }
        }

        // Smooth scrolling for lesson navigation
        document.querySelectorAll('a[href*="/lessons/"]').forEach(link => {
            link.addEventListener('click', function(e) {
                // Add loading state
                const btn = this;
                const originalText = btn.innerHTML;
                btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang tải...';
                btn.disabled = true;

                // Let the normal navigation proceed
                setTimeout(() => {
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                }, 1000);
            });
        });

        // Auto-save reading position
        let readingPosition = 0;
        window.addEventListener('scroll', function() {
            readingPosition = window.scrollY;

            // Save position every 5 seconds of scrolling
            clearTimeout(window.saveTimeout);
            window.saveTimeout = setTimeout(() => {
                localStorage.setItem(`lesson_${lesson.id}_position`, readingPosition);
            }, 2000);
        });

        // Restore reading position
        const savedPosition = localStorage.getItem(`lesson_${lesson.id}_position`);
        if (savedPosition && !window.location.hash) {
            setTimeout(() => {
                window.scrollTo(0, parseInt(savedPosition));
            }, 100);
        }

        // Keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            // Space bar to scroll down
            if (e.code === 'Space' && !e.target.matches('input, textarea, [contenteditable]')) {
                e.preventDefault();
                window.scrollBy(0, window.innerHeight * 0.8);
            }

            // Arrow keys for navigation
            if (e.code === 'ArrowLeft' && e.ctrlKey) {
                const prevLink = document.querySelector('a[href*="/lessons/"]:has(.fa-arrow-left)');
                if (prevLink) prevLink.click();
            }

            if (e.code === 'ArrowRight' && e.ctrlKey) {
                const nextLink = document.querySelector('a[href*="/lessons/"]:has(.fa-arrow-right)');
                if (nextLink) nextLink.click();
            }
        });

        // Mobile sidebar auto-close when clicking lesson links
        if (window.innerWidth <= 768) {
            document.querySelectorAll('.lesson-link').forEach(link => {
                link.addEventListener('click', function() {
                    toggleSidebar();
                });
            });
        }
    });

    // Toggle mobile sidebar
    function toggleSidebar() {
        const sidebar = document.getElementById('lessonSidebar');
        sidebar.classList.toggle('show');
    }

    // Close sidebar when clicking outside (mobile)
    document.addEventListener('click', function(e) {
        const sidebar = document.getElementById('lessonSidebar');
        const toggle = document.querySelector('.mobile-sidebar-toggle');

        if (window.innerWidth <= 768 &&
            sidebar.classList.contains('show') &&
            !sidebar.contains(e.target) &&
            !toggle.contains(e.target)) {
            sidebar.classList.remove('show');
        }
    });

    // Mark lesson as complete
    function markLessonComplete() {
        const form = document.querySelector('form[action*="/complete"]');
        if (form) {
            form.submit();
        }
    }

    // Notes functionality (future enhancement)
    function toggleNotes() {
        // Implementation for student notes feature
        console.log('Notes feature to be implemented');
    }

    // Bookmark lesson (future enhancement)
    function bookmarkLesson() {
        // Implementation for bookmarking lessons
        console.log('Bookmark feature to be implemented');
    }
</script>

</body>
</html>