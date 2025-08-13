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
    <title>${lesson.title} - ${course.name} | E-Learning Platform</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="/css/lesson-view.css" rel="stylesheet">

    <!-- Highlight.js cho code syntax highlighting -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.8.0/styles/github.min.css">

    <style>
        :root {
            --primary-color: #007bff;
            --secondary-color: #6c757d;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --dark-color: #343a40;
            --light-color: #f8f9fa;
            --text-muted: #6c757d;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fa;
            line-height: 1.6;
        }

        /* Lesson Header */
        .lesson-header {
            background: linear-gradient(135deg, var(--primary-color), #0056b3);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }

        .lesson-header h1 {
            font-size: 2.5rem;
            font-weight: 300;
            margin-bottom: 0.5rem;
        }

        .lesson-meta {
            display: flex;
            gap: 1.5rem;
            align-items: center;
            flex-wrap: wrap;
        }

        .lesson-meta span {
            background: rgba(255, 255, 255, 0.2);
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.9rem;
        }

        /* Progress Bar */
        .lesson-progress {
            position: sticky;
            top: 0;
            z-index: 1020;
            background: white;
            border-bottom: 1px solid #e9ecef;
            padding: 0.5rem 0;
        }

        .lesson-progress-bar {
            height: 4px;
            background: var(--primary-color);
            transition: width 0.3s ease;
        }

        /* Main Content Layout */
        .lesson-layout {
            display: flex;
            gap: 2rem;
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 1rem;
        }

        .lesson-content {
            flex: 1;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 2rem;
            min-height: 800px;
        }

        .lesson-sidebar {
            width: 350px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 1.5rem;
            height: fit-content;
            position: sticky;
            top: 80px;
        }

        /* Video Container */
        .lesson-video {
            margin-bottom: 2rem;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .lesson-video iframe {
            width: 100%;
            height: 400px;
            border: none;
        }

        .video-placeholder {
            height: 400px;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-muted);
            font-size: 1.2rem;
        }

        /* Content Styles */
        .lesson-content-body {
            font-size: 1.1rem;
            line-height: 1.8;
            color: #2c3e50;
        }

        .lesson-content-body h1,
        .lesson-content-body h2,
        .lesson-content-body h3,
        .lesson-content-body h4 {
            color: var(--dark-color);
            margin-top: 2rem;
            margin-bottom: 1rem;
        }

        .lesson-content-body p {
            margin-bottom: 1.5rem;
        }

        .lesson-content-body ul,
        .lesson-content-body ol {
            margin-bottom: 1.5rem;
            padding-left: 2rem;
        }

        .lesson-content-body li {
            margin-bottom: 0.5rem;
        }

        .lesson-content-body blockquote {
            border-left: 4px solid var(--primary-color);
            background: #f8f9fa;
            padding: 1rem 1.5rem;
            margin: 1.5rem 0;
            font-style: italic;
        }

        .lesson-content-body code {
            background: #f8f9fa;
            padding: 0.2rem 0.4rem;
            border-radius: 4px;
            font-family: 'Courier New', monospace;
            color: #e83e8c;
        }

        .lesson-content-body pre {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 8px;
            overflow-x: auto;
            margin: 1.5rem 0;
        }

        /* Navigation */
        .lesson-navigation {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 3rem;
            padding-top: 2rem;
            border-top: 1px solid #e9ecef;
        }

        .nav-button {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.8rem 1.5rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .nav-button.btn-primary {
            background: var(--primary-color);
            color: white;
        }

        .nav-button.btn-outline-primary {
            border: 2px solid var(--primary-color);
            color: var(--primary-color);
        }

        .nav-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }

        /* Sidebar Styles */
        .sidebar-section {
            margin-bottom: 2rem;
        }

        .sidebar-section h5 {
            color: var(--dark-color);
            margin-bottom: 1rem;
            font-weight: 600;
        }

        .course-lessons {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .course-lessons li {
            margin-bottom: 0.5rem;
        }

        .course-lessons a {
            display: block;
            padding: 0.8rem;
            border-radius: 6px;
            text-decoration: none;
            color: var(--dark-color);
            border: 1px solid #e9ecef;
            transition: all 0.3s ease;
            position: relative;
        }

        .course-lessons a:hover {
            background: var(--light-color);
            border-color: var(--primary-color);
        }

        .course-lessons a.current {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }

        .course-lessons a.completed::before {
            content: '\f00c';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            position: absolute;
            right: 0.8rem;
            color: var(--success-color);
        }

        .lesson-meta-info {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-top: 1rem;
            padding: 1rem;
            background: var(--light-color);
            border-radius: 8px;
        }

        .lesson-actions {
            display: flex;
            gap: 0.5rem;
            margin-top: 1rem;
        }

        .lesson-actions .btn {
            flex: 1;
            padding: 0.6rem;
            font-size: 0.9rem;
        }

        /* Document Download */
        .document-section {
            background: #e8f4fd;
            border: 1px solid #b8daff;
            border-radius: 8px;
            padding: 1.5rem;
            margin: 1.5rem 0;
        }

        .document-section h6 {
            color: #0056b3;
            margin-bottom: 1rem;
        }

        /* Completion Badge */
        .completion-badge {
            display: inline-block;
            background: var(--success-color);
            color: white;
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 500;
        }

        /* Mobile Responsive */
        @media (max-width: 768px) {
            .lesson-layout {
                flex-direction: column;
                gap: 1rem;
            }

            .lesson-sidebar {
                width: 100%;
                position: static;
                order: -1;
            }

            .lesson-header h1 {
                font-size: 1.8rem;
            }

            .lesson-meta {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.5rem;
            }

            .lesson-navigation {
                flex-direction: column;
                gap: 1rem;
            }

            .nav-button {
                width: 100%;
                justify-content: center;
            }
        }

        /* Fullscreen Mode */
        body.fullscreen-reading .lesson-sidebar,
        body.fullscreen-reading .navbar {
            display: none !important;
        }

        body.fullscreen-reading .lesson-layout {
            max-width: 100%;
            margin: 0;
            padding: 1rem;
        }

        /* Toast Notifications */
        .lesson-completion-toast {
            background: linear-gradient(135deg, var(--success-color), #20c997);
            border: none;
        }

        /* Loading States */
        .loading {
            opacity: 0.6;
            pointer-events: none;
        }

        .spinner {
            width: 20px;
            height: 20px;
            border: 2px solid #f3f3f3;
            border-top: 2px solid var(--primary-color);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>

<body>
<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand" href="/">
            <i class="fas fa-graduation-cap me-2"></i>
            E-Learning Platform
        </a>

        <div class="navbar-nav ms-auto">
            <a class="nav-link" href="/student/courses/${course.id}">
                <i class="fas fa-arrow-left me-1"></i>
                Về khóa học
            </a>
        </div>
    </div>
</nav>

<!-- Progress Bar -->
<div class="lesson-progress">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-2">
            <span class="lesson-progress-text">0% hoàn thành</span>
            <div class="lesson-completion-badge">
                <c:if test="${enrollment != null && enrollment.progress >= 90}">
                        <span class="completion-badge">
                            <i class="fas fa-check-circle"></i> Đã hoàn thành
                        </span>
                </c:if>
            </div>
        </div>
        <div class="progress" style="height: 4px;">
            <div class="progress-bar lesson-progress-bar" role="progressbar"
                 style="width: ${enrollment != null ? enrollment.progress : 0}%"
                 aria-valuenow="${enrollment != null ? enrollment.progress : 0}"
                 aria-valuemin="0" aria-valuemax="100">
            </div>
        </div>
    </div>
</div>

<!-- Lesson Header -->
<div class="lesson-header">
    <div class="container">
        <div class="row">
            <div class="col-lg-8">
                <h1>${lesson.title}</h1>
                <div class="lesson-meta">
                    <span><i class="fas fa-book me-1"></i> ${course.name}</span>
                    <c:if test="${lesson.estimatedDuration != null}">
                        <span><i class="fas fa-clock me-1"></i> ${lesson.estimatedDuration} phút</span>
                    </c:if>
                    <span><i class="fas fa-list-ol me-1"></i> Bài ${lesson.orderIndex}/${totalLessons}</span>
                    <c:if test="${lesson.preview}">
                        <span><i class="fas fa-eye me-1"></i> Xem trước</span>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Main Content -->
<div class="lesson-layout">
    <!-- Lesson Content -->
    <div class="lesson-content">
        <!-- Video Section -->
        <c:if test="${not empty lesson.videoLink}">
            <div class="lesson-video">
                <c:choose>
                    <c:when test="${fn:contains(lesson.videoLink, 'youtube.com') || fn:contains(lesson.videoLink, 'youtu.be')}">
                        <c:set var="videoId" value="${fn:substringAfter(lesson.videoLink, 'v=')}" />
                        <c:if test="${fn:contains(videoId, '&')}">
                            <c:set var="videoId" value="${fn:substringBefore(videoId, '&')}" />
                        </c:if>
                        <iframe src="https://www.youtube.com/embed/${videoId}"
                                allowfullscreen>
                        </iframe>
                    </c:when>
                    <c:otherwise>
                        <video controls width="100%" height="400">
                            <source src="${lesson.videoLink}" type="video/mp4">
                            Trình duyệt của bạn không hỗ trợ video.
                        </video>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <!-- Lesson Content Body -->
        <div class="lesson-content-body">
            ${lesson.content}
        </div>

        <!-- Document Download Section -->
        <c:if test="${not empty lesson.documentUrl}">
            <div class="document-section">
                <h6><i class="fas fa-file-download me-2"></i>Tài liệu bài học</h6>
                <p>Tải xuống tài liệu để học offline và tham khảo.</p>
                <a href="${lesson.documentUrl}" class="btn btn-outline-primary" download>
                    <i class="fas fa-download me-2"></i>Tải xuống tài liệu
                </a>
            </div>
        </c:if>

        <!-- Lesson Actions -->
        <div class="lesson-meta-info">
            <div class="lesson-actions">
                <button type="button" class="btn btn-outline-primary bookmark-lesson-btn"
                        title="Đánh dấu bài học">
                    <i class="far fa-bookmark"></i>
                </button>
                <button type="button" class="btn btn-outline-info take-note-btn"
                        title="Ghi chú">
                    <i class="fas fa-sticky-note"></i>
                </button>
                <button type="button" class="btn btn-outline-success"
                        onclick="markLessonComplete()" title="Đánh dấu hoàn thành">
                    <i class="fas fa-check"></i>
                </button>
            </div>
            <div class="flex-grow-1 text-center">
                <small class="text-muted">
                    Cập nhật: <fmt:formatDate value="${lesson.updatedAt}" pattern="dd/MM/yyyy HH:mm" />
                </small>
            </div>
        </div>

        <!-- Navigation -->
        <div class="lesson-navigation">
            <div>
                <c:if test="${previousLesson != null}">
                    <a href="/student/lessons/${previousLesson.id}" class="nav-button btn-outline-primary">
                        <i class="fas fa-arrow-left"></i>
                        Bài trước: ${fn:substring(previousLesson.title, 0, 30)}${fn:length(previousLesson.title) > 30 ? '...' : ''}
                    </a>
                </c:if>
            </div>

            <div>
                <c:if test="${nextLesson != null}">
                    <a href="/student/lessons/${nextLesson.id}" class="nav-button btn-primary">
                        Bài tiếp: ${fn:substring(nextLesson.title, 0, 30)}${fn:length(nextLesson.title) > 30 ? '...' : ''}
                        <i class="fas fa-arrow-right"></i>
                    </a>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Sidebar -->
    <div class="lesson-sidebar">
        <!-- Course Info -->
        <div class="sidebar-section">
            <h5><i class="fas fa-book-open me-2"></i>Thông tin khóa học</h5>
            <div class="card border-0 bg-light">
                <div class="card-body p-3">
                    <h6 class="card-title">${course.name}</h6>
                    <p class="card-text small text-muted mb-2">
                        Giảng viên: ${course.instructor.fullName}
                    </p>
                    <div class="progress mb-2" style="height: 6px;">
                        <div class="progress-bar" role="progressbar"
                             style="width: ${enrollment != null ? enrollment.progress : 0}%">
                        </div>
                    </div>
                    <small class="text-muted">
                        Tiến độ: ${enrollment != null ? enrollment.progress : 0}%
                    </small>
                </div>
            </div>
        </div>

        <!-- Course Lessons -->
        <div class="sidebar-section">
            <h5><i class="fas fa-list me-2"></i>Danh sách bài học</h5>
            <ul class="course-lessons">
                <c:forEach items="${courseLessons}" var="courseLesson" varStatus="status">
                    <li>
                        <a href="/student/lessons/${courseLesson.id}"
                           class="${courseLesson.id == lesson.id ? 'current' : ''} ${courseLesson.completed ? 'completed' : ''}">
                            <div class="d-flex justify-content-between align-items-start">
                                <div class="flex-grow-1">
                                    <div class="fw-medium">${status.index + 1}. ${courseLesson.title}</div>
                                    <c:if test="${courseLesson.estimatedDuration != null}">
                                        <small class="text-muted">${courseLesson.estimatedDuration} phút</small>
                                    </c:if>
                                </div>
                                <c:if test="${courseLesson.preview}">
                                    <span class="badge bg-info ms-2">Preview</span>
                                </c:if>
                            </div>
                        </a>
                    </li>
                </c:forEach>
            </ul>
        </div>

        <!-- Quick Actions -->
        <div class="sidebar-section">
            <h5><i class="fas fa-tools me-2"></i>Thao tác nhanh</h5>
            <div class="d-grid gap-2">
                <button class="btn btn-outline-primary btn-sm" onclick="toggleFullscreenMode()">
                    <i class="fas fa-expand me-1"></i> Chế độ toàn màn hình
                </button>
                <a href="/student/courses/${course.id}/quizzes" class="btn btn-outline-info btn-sm">
                    <i class="fas fa-question-circle me-1"></i> Bài kiểm tra
                </a>
                <a href="/student/courses/${course.id}" class="btn btn-outline-secondary btn-sm">
                    <i class="fas fa-arrow-left me-1"></i> Về khóa học
                </a>
            </div>
        </div>

        <!-- Keyboard Shortcuts Help -->
        <div class="sidebar-section">
            <h6><i class="fas fa-keyboard me-2"></i>Phím tắt</h6>
            <small class="text-muted">
                <div>Space: Cuộn xuống</div>
                <div>Ctrl + ←: Bài trước</div>
                <div>Ctrl + →: Bài tiếp</div>
                <div>Ctrl + F: Toàn màn hình</div>
                <div>Esc: Về khóa học</div>
            </small>
        </div>
    </div>
</div>

<!-- Bootstrap JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Highlight.js -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.8.0/highlight.min.js"></script>

<!-- Custom JavaScript -->
<script>
    // Dữ liệu lesson được truyền từ server
    window.lessonData = {
        id: ${lesson.id},
        courseId: ${course.id},
        title: '${lesson.title}',
        orderIndex: ${lesson.orderIndex}
    };

    // Biến để theo dõi vị trí đọc và thời gian
    let readingPosition = 0;
    let startTime = Date.now();
    let timeSpent = 0;
    let progressInterval;

    /**
     * Khởi tạo theo dõi tiến độ bài giảng
     * Gửi thông tin về server mỗi 30 giây
     */
    function initializeProgressTracking() {
        if (!window.lessonData.id) return;

        // Gửi thông tin tiến độ mỗi 30 giây
        progressInterval = setInterval(() => {
            updateLessonProgress();
        }, 30000);

        // Gửi tiến độ khi user rời khỏi trang
        window.addEventListener('beforeunload', () => {
            updateLessonProgress();
        });

        // Gửi tiến độ khi user chuyển tab
        document.addEventListener('visibilitychange', () => {
            if (document.hidden) {
                updateLessonProgress();
            }
        });
    }

    /**
     * Cập nhật tiến độ học bài giảng lên server
     */
    function updateLessonProgress() {
        if (!window.lessonData.id) return;

        timeSpent += Math.round((Date.now() - startTime) / 1000);
        startTime = Date.now();

        // Tính phần trăm tiến độ dựa trên vị trí scroll
        const documentHeight = document.documentElement.scrollHeight - window.innerHeight;
        const scrollPercentage = documentHeight > 0 ? Math.min(100, Math.round((readingPosition / documentHeight) * 100)) : 100;

        // Gửi dữ liệu lên server
        fetch('/api/v1/lessons/' + window.lessonData.id + '/progress', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: JSON.stringify({
                progressPercentage: scrollPercentage,
                timeSpent: timeSpent,
                lastPosition: readingPosition
            })
        }).then(response => {
            if (response.ok) {
                console.log('Đã cập nhật tiến độ bài học:', scrollPercentage + '%');

                // Cập nhật progress bar nếu có
                updateProgressBar(scrollPercentage);
            }
        }).catch(error => {
            console.error('Lỗi khi cập nhật tiến độ:', error);
        });
    }

    /**
     * Cập nhật thanh progress bar trên giao diện
     */
    function updateProgressBar(percentage) {
        const progressBar = document.querySelector('.lesson-progress-bar');
        const progressText = document.querySelector('.lesson-progress-text');

        if (progressBar) {
            progressBar.style.width = percentage + '%';
            progressBar.setAttribute('aria-valuenow', percentage);
        }

        if (progressText) {
            progressText.textContent = percentage + '% hoàn thành';
        }

        // Đánh dấu bài học hoàn thành nếu đọc >= 90%
        if (percentage >= 90) {
            markLessonAsCompleted();
        }
    }

    /**
     * Đánh dấu bài học đã hoàn thành
     */
    function markLessonAsCompleted() {
        if (!window.lessonData.id) return;

        fetch('/api/v1/lessons/' + window.lessonData.id + '/complete', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        }).then(response => {
            if (response.ok) {
                // Hiển thị thông báo hoàn thành
                showCompletionNotification();

                // Cập nhật UI
                const completionBadge = document.querySelector('.lesson-completion-badge');
                if (completionBadge) {
                    completionBadge.innerHTML = '<span class="completion-badge"><i class="fas fa-check-circle"></i> Đã hoàn thành</span>';
                }
            }
        }).catch(error => {
            console.error('Lỗi khi đánh dấu hoàn thành:', error);
        });
    }

    /**
     * Hiển thị thông báo hoàn thành bài học
     */
    function showCompletionNotification() {
        // Tạo toast notification
        const toastHtml = `
                <div class="toast lesson-completion-toast" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="toast-header bg-success text-white">
                        <i class="fas fa-graduation-cap me-2"></i>
                        <strong class="me-auto">Chúc mừng!</strong>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"></button>
                    </div>
                    <div class="toast-body">
                        <p class="mb-2">🎉 Bạn đã hoàn thành bài học này!</p>
                        <div class="d-flex gap-2">
                            <button class="btn btn-sm btn-outline-primary next-lesson-btn">
                                <i class="fas fa-arrow-right"></i> Bài tiếp theo
                            </button>
                            <button class="btn btn-sm btn-outline-secondary back-to-course-btn">
                                <i class="fas fa-list"></i> Về khóa học
                            </button>
                        </div>
                    </div>
                </div>
            `;

        // Thêm toast vào container
        let toastContainer = document.querySelector('.toast-container');
        if (!toastContainer) {
            toastContainer = document.createElement('div');
            toastContainer.className = 'toast-container position-fixed top-0 end-0 p-3';
            document.body.appendChild(toastContainer);
        }

        toastContainer.insertAdjacentHTML('beforeend', toastHtml);

        // Khởi tạo và hiển thị toast
        const toast = toastContainer.querySelector('.lesson-completion-toast:last-child');
        const bsToast = new bootstrap.Toast(toast, { delay: 8000 });
        bsToast.show();

        // Xử lý sự kiện click cho các nút trong toast
        toast.querySelector('.next-lesson-btn')?.addEventListener('click', () => {
            goToNextLesson();
        });

        toast.querySelector('.back-to-course-btn')?.addEventListener('click', () => {
            window.location.href = '/student/courses/' + window.lessonData.courseId;
        });
    }

    /**
     * Chuyển đến bài học tiếp theo
     */
    function goToNextLesson() {
        const nextLessonLink = document.querySelector('a[href*="/lessons/"]:has(.fa-arrow-right)');
        if (nextLessonLink) {
            nextLessonLink.click();
        } else {
            // Nếu không có bài tiếp theo, về trang khóa học
            window.location.href = '/student/courses/' + window.lessonData.courseId;
        }
    }

    /**
     * Theo dõi vị trí scroll và lưu vào localStorage
     */
    function initializeScrollTracking() {
        // Theo dõi vị trí scroll
        window.addEventListener('scroll', function() {
            readingPosition = window.scrollY;

            // Lưu vị trí đọc sau mỗi 2 giây scroll
            clearTimeout(window.saveTimeout);
            window.saveTimeout = setTimeout(() => {
                if (window.lessonData.id) {
                    localStorage.setItem(`lesson_${window.lessonData.id}_position`, readingPosition);
                }
            }, 2000);
        });

        // Khôi phục vị trí đọc đã lưu
        const savedPosition = localStorage.getItem(`lesson_${window.lessonData.id}_position`);
        if (savedPosition && !window.location.hash) {
            setTimeout(() => {
                window.scrollTo({
                    top: parseInt(savedPosition),
                    behavior: 'smooth'
                });
            }, 100);
        }
    }

    /**
     * Khởi tạo keyboard shortcuts
     */
    function initializeKeyboardShortcuts() {
        document.addEventListener('keydown', function(e) {
            // Chỉ xử lý khi không đang focus vào input/textarea
            if (e.target.matches('input, textarea, [contenteditable]')) {
                return;
            }

            switch(e.code) {
                // Space bar để scroll xuống
                case 'Space':
                    e.preventDefault();
                    window.scrollBy({
                        top: window.innerHeight * 0.8,
                        behavior: 'smooth'
                    });
                    break;

                // Arrow keys với Ctrl để navigation
                case 'ArrowLeft':
                    if (e.ctrlKey) {
                        e.preventDefault();
                        const prevLink = document.querySelector('a[href*="/lessons/"]:has(.fa-arrow-left)');
                        if (prevLink) prevLink.click();
                    }
                    break;

                case 'ArrowRight':
                    if (e.ctrlKey) {
                        e.preventDefault();
                        const nextLink = document.querySelector('a[href*="/lessons/"]:has(.fa-arrow-right)');
                        if (nextLink) nextLink.click();
                    }
                    break;

                // Esc để về trang khóa học
                case 'Escape':
                    if (window.lessonData.courseId) {
                        window.location.href = '/student/courses/' + window.lessonData.courseId;
                    }
                    break;

                // F để toggle fullscreen reading mode
                case 'KeyF':
                    if (e.ctrlKey) {
                        e.preventDefault();
                        toggleFullscreenMode();
                    }
                    break;
            }
        });
    }

    /**
     * Toggle chế độ đọc fullscreen
     */
    function toggleFullscreenMode() {
        const body = document.body;
        const sidebar = document.querySelector('.lesson-sidebar');
        const navbar = document.querySelector('.navbar');

        if (body.classList.contains('fullscreen-reading')) {
            // Thoát chế độ fullscreen
            body.classList.remove('fullscreen-reading');
            if (sidebar) sidebar.style.display = '';
            if (navbar) navbar.style.display = '';
        } else {
            // Vào chế độ fullscreen
            body.classList.add('fullscreen-reading');
            if (sidebar) sidebar.style.display = 'none';
            if (navbar) navbar.style.display = 'none';
        }
    }

    /**
     * Xử lý auto-close sidebar trên mobile
     */
    function initializeMobileSidebar() {
        const sidebar = document.querySelector('.lesson-sidebar');
        const content = document.querySelector('.lesson-content');

        if (sidebar && content && window.innerWidth <= 768) {
            // Đóng sidebar khi click vào content trên mobile
            content.addEventListener('click', () => {
                if (sidebar.classList.contains('show')) {
                    const sidebarCollapse = bootstrap.Collapse.getInstance(sidebar);
                    if (sidebarCollapse) {
                        sidebarCollapse.hide();
                    }
                }
            });
        }
    }

    /**
     * Xử lý bookmark/favorite lesson
     */
    function initializeBookmarkFeature() {
        const bookmarkBtn = document.querySelector('.bookmark-lesson-btn');
        if (bookmarkBtn && window.lessonData.id) {
            bookmarkBtn.addEventListener('click', () => {
                toggleLessonBookmark();
            });
        }
    }

    /**
     * Toggle bookmark cho bài học
     */
    function toggleLessonBookmark() {
        fetch('/api/v1/lessons/' + window.lessonData.id + '/bookmark', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        }).then(response => response.json())
            .then(data => {
                const bookmarkBtn = document.querySelector('.bookmark-lesson-btn');
                const bookmarkIcon = bookmarkBtn.querySelector('i');

                if (data.bookmarked) {
                    bookmarkIcon.className = 'fas fa-bookmark text-warning';
                    bookmarkBtn.title = 'Bỏ đánh dấu';
                } else {
                    bookmarkIcon.className = 'far fa-bookmark';
                    bookmarkBtn.title = 'Đánh dấu bài học';
                }
            }).catch(error => {
            console.error('Lỗi khi toggle bookmark:', error);
        });
    }

    /**
     * Khởi tạo chức năng note-taking
     */
    function initializeNoteTaking() {
        const noteBtn = document.querySelector('.take-note-btn');
        if (noteBtn) {
            noteBtn.addEventListener('click', () => {
                openNoteModal();
            });
        }
    }

    /**
     * Mở modal ghi chú
     */
    function openNoteModal() {
        // Tạo modal ghi chú nếu chưa có
        let noteModal = document.querySelector('#lessonNoteModal');
        if (!noteModal) {
            const modalHtml = `
                    <div class="modal fade" id="lessonNoteModal" tabindex="-1">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">
                                        <i class="fas fa-sticky-note"></i> Ghi chú bài học
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <textarea class="form-control" id="lessonNoteContent" rows="8"
                                        placeholder="Viết ghi chú của bạn về bài học này..."></textarea>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                    <button type="button" class="btn btn-primary" id="saveNoteBtn">
                                        <i class="fas fa-save"></i> Lưu ghi chú
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                `;
            document.body.insertAdjacentHTML('beforeend', modalHtml);
            noteModal = document.querySelector('#lessonNoteModal');

            // Xử lý lưu ghi chú
            noteModal.querySelector('#saveNoteBtn').addEventListener('click', () => {
                saveLessonNote();
            });
        }

        // Load ghi chú đã có (nếu có)
        loadLessonNote();

        // Hiển thị modal
        const bsModal = new bootstrap.Modal(noteModal);
        bsModal.show();
    }

    /**
     * Load ghi chú đã lưu
     */
    function loadLessonNote() {
        const noteContent = localStorage.getItem(`lesson_${window.lessonData.id}_note`);
        const textarea = document.querySelector('#lessonNoteContent');
        if (textarea && noteContent) {
            textarea.value = noteContent;
        }
    }

    /**
     * Lưu ghi chú bài học
     */
    function saveLessonNote() {
        const textarea = document.querySelector('#lessonNoteContent');
        const content = textarea.value.trim();

        // Lưu vào localStorage
        localStorage.setItem(`lesson_${window.lessonData.id}_note`, content);

        // Gửi lên server (optional)
        if (content) {
            fetch('/api/v1/lessons/' + window.lessonData.id + '/notes', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: JSON.stringify({ content: content })
            }).then(response => {
                if (response.ok) {
                    console.log('Đã lưu ghi chú lên server');
                }
            }).catch(error => {
                console.error('Lỗi khi lưu ghi chú:', error);
            });
        }

        // Đóng modal
        const modal = bootstrap.Modal.getInstance(document.querySelector('#lessonNoteModal'));
        modal.hide();

        // Hiển thị thông báo
        showToast('Đã lưu ghi chú thành công!', 'success');
    }

    /**
     * Hiển thị toast notification
     */
    function showToast(message, type = 'info') {
        const toastHtml = `
                <div class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="toast-header bg-${type} text-white">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong class="me-auto">Thông báo</strong>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"></button>
                    </div>
                    <div class="toast-body">
                        ${message}
                    </div>
                </div>
            `;

        let toastContainer = document.querySelector('.toast-container');
        if (!toastContainer) {
            toastContainer = document.createElement('div');
            toastContainer.className = 'toast-container position-fixed top-0 end-0 p-3';
            document.body.appendChild(toastContainer);
        }

        toastContainer.insertAdjacentHTML('beforeend', toastHtml);
        const toast = toastContainer.querySelector('.toast:last-child');
        const bsToast = new bootstrap.Toast(toast);
        bsToast.show();
    }

    /**
     * Đánh dấu bài học hoàn thành manually
     */
    function markLessonComplete() {
        fetch('/api/v1/lessons/' + window.lessonData.id + '/complete', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        }).then(response => {
            if (response.ok) {
                showToast('Đã đánh dấu bài học hoàn thành!', 'success');
                updateProgressBar(100);
                showCompletionNotification();
            }
        }).catch(error => {
            console.error('Lỗi khi đánh dấu hoàn thành:', error);
            showToast('Có lỗi xảy ra. Vui lòng thử lại!', 'danger');
        });
    }

    // Khởi tạo tất cả các chức năng khi DOM ready
    document.addEventListener('DOMContentLoaded', function() {
        // Highlight code blocks
        document.querySelectorAll('pre code').forEach((block) => {
            hljs.highlightBlock(block);
        });

        // Khởi tạo tất cả features
        initializeProgressTracking();
        initializeScrollTracking();
        initializeKeyboardShortcuts();
        initializeMobileSidebar();
        initializeBookmarkFeature();
        initializeNoteTaking();

        console.log('Lesson view JavaScript đã khởi tạo thành công');
    });
</script>
</body>
</html><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${lesson.title} - ${course.name} | E-Learning Platform</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="/css/lesson-view.css" rel="stylesheet">

    <!-- Highlight.js cho code syntax highlighting -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.8.0/styles/github.min.css">

    <style>
        :root {
            --primary-color: #007bff;
            --secondary-color: #6c757d;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --dark-color: #343a40;
            --light-color: #f8f9fa;
            --text-muted: #6c757d;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fa;
            line-height: 1.6;
        }

        /* Lesson Header */
        .lesson-header {
            background: linear-gradient(135deg, var(--primary-color), #0056b3);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }

        .lesson-header h1 {
            font-size: 2.5rem;
            font-weight: 300;
            margin-bottom: 0.5rem;
        }

        .lesson-meta {
            display: flex;
            gap: 1.5rem;
            align-items: center;
            flex-wrap: wrap;
        }

        .lesson-meta span {
            background: rgba(255, 255, 255, 0.2);
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.9rem;
        }

        /* Progress Bar */
        .lesson-progress {
            position: sticky;
            top: 0;
            z-index: 1020;
            background: white;
            border-bottom: 1px solid #e9ecef;
            padding: 0.5rem 0;
        }

        .lesson-progress-bar {
            height: 4px;
            background: var(--primary-color);
            transition: width 0.3s ease;
        }

        /* Main Content Layout */
        .lesson-layout {
            display: flex;
            gap: 2rem;
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 1rem;
        }

        .lesson-content {
            flex: 1;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 2rem;
            min-height: 800px;
        }

        .lesson-sidebar {
            width: 350px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 1.5rem;
            height: fit-content;
            position: sticky;
            top: 80px;
        }

        /* Video Container */
        .lesson-video {
            margin-bottom: 2rem;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .lesson-video iframe {
            width: 100%;
            height: 400px;
            border: none;
        }

        .video-placeholder {
            height: 400px;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-muted);
            font-size: 1.2rem;
        }

        /* Content Styles */
        .lesson-content-body {
            font-size: 1.1rem;
            line-height: 1.8;
            color: #2c3e50;
        }

        .lesson-content-body h1,
        .lesson-content-body h2,
        .lesson-content-body h3,
        .lesson-content-body h4 {
            color: var(--dark-color);
            margin-top: 2rem;
            margin-bottom: 1rem;
        }

        .lesson-content-body p {
            margin-bottom: 1.5rem;
        }

        .lesson-content-body ul,
        .lesson-content-body ol {
            margin-bottom: 1.5rem;
            padding-left: 2rem;
        }

        .lesson-content-body li {
            margin-bottom: 0.5rem;
        }

        .lesson-content-body blockquote {
            border-left: 4px solid var(--primary-color);
            background: #f8f9fa;
            padding: 1rem 1.5rem;
            margin: 1.5rem 0;
            font-style: italic;
        }

        .lesson-content-body code {
            background: #f8f9fa;
            padding: 0.2rem 0.4rem;
            border-radius: 4px;
            font-family: 'Courier New', monospace;
            color: #e83e8c;
        }

        .lesson-content-body pre {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 8px;
            overflow-x: auto;
            margin: 1.5rem 0;
        }

        /* Navigation */
        .lesson-navigation {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 3rem;
            padding-top: 2rem;
            border-top: 1px solid #e9ecef;
        }

        .nav-button {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.8rem 1.5rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .nav-button.btn-primary {
            background: var(--primary-color);
            color: white;
        }

        .nav-button.btn-outline-primary {
            border: 2px solid var(--primary-color);
            color: var(--primary-color);
        }

        .nav-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }

        /* Sidebar Styles */
        .sidebar-section {
            margin-bottom: 2rem;
        }

        .sidebar-section h5 {
            color: var(--dark-color);
            margin-bottom: 1rem;
            font-weight: 600;
        }

        .course-lessons {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .course-lessons li {
            margin-bottom: 0.5rem;
        }

        .course-lessons a {
            display: block;
            padding: 0.8rem;
            border-radius: 6px;
            text-decoration: none;
            color: var(--dark-color);
            border: 1px solid #e9ecef;
            transition: all 0.3s ease;
            position: relative;
        }

        .course-lessons a:hover {
            background: var(--light-color);
            border-color: var(--primary-color);
        }

        .course-lessons a.current {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }

        .course-lessons a.completed::before {
            content: '\f00c';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            position: absolute;
            right: 0.8rem;
            color: var(--success-color);
        }

        .lesson-meta-info {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-top: 1rem;
            padding: 1rem;
            background: var(--light-color);
            border-radius: 8px;
        }

        .lesson-actions {
            display: flex;
            gap: 0.5rem;
            margin-top: 1rem;
        }

        .lesson-actions .btn {
            flex: 1;
            padding: 0.6rem;
            font-size: 0.9rem;
        }

        /* Document Download */
        .document-section {
            background: #e8f4fd;
            border: 1px solid #b8daff;
            border-radius: 8px;
            padding: 1.5rem;
            margin: 1.5rem 0;
        }

        .document-section h6 {
            color: #0056b3;
            margin-bottom: 1rem;
        }

        /* Completion Badge */
        .completion-badge {
            display: inline-block;
            background: var(--success-color);
            color: white;
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 500;
        }

        /* Mobile Responsive */
        @media (max-width: 768px) {
            .lesson-layout {
                flex-direction: column;
                gap: 1rem;
            }

            .lesson-sidebar {
                width: 100%;
                position: static;
                order: -1;
            }

            .lesson-header h1 {
                font-size: 1.8rem;
            }

            .lesson-meta {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.5rem;
            }

            .lesson-navigation {
                flex-direction: column;
                gap: 1rem;
            }

            .nav-button {
                width: 100%;
                justify-content: center;
            }
        }

        /* Fullscreen Mode */
        body.fullscreen-reading .lesson-sidebar,
        body.fullscreen-reading .navbar {
            display: none !important;
        }

        body.fullscreen-reading .lesson-layout {
            max-width: 100%;
            margin: 0;
            padding: 1rem;
        }

        /* Toast Notifications */
        .lesson-completion-toast {
            background: linear-gradient(135deg, var(--success-color), #20c997);
            border: none;
        }

        /* Loading States */
        .loading {
            opacity: 0.6;
            pointer-events: none;
        }

        .spinner {
            width: 20px;
            height: 20px;
            border: 2px solid #f3f3f3;
            border-top: 2px solid var(--primary-color);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>

<body>
<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand" href="/">
            <i class="fas fa-graduation-cap me-2"></i>
            E-Learning Platform
        </a>

        <div class="navbar-nav ms-auto">
            <a class="nav-link" href="/student/courses/${course.id}">
                <i class="fas fa-arrow-left me-1"></i>
                Về khóa học
            </a>
        </div>
    </div>
</nav>

<!-- Progress Bar -->
<div class="lesson-progress">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-2">
            <span class="lesson-progress-text">0% hoàn thành</span>
            <div class="lesson-completion-badge">
                <c:if test="${enrollment != null && enrollment.progress >= 90}">
                        <span class="completion-badge">
                            <i class="fas fa-check-circle"></i> Đã hoàn thành
                        </span>
                </c:if>
            </div>
        </div>
        <div class="progress" style="height: 4px;">
            <div class="progress-bar lesson-progress-bar" role="progressbar"
                 style="width: ${enrollment != null ? enrollment.progress : 0}%"
                 aria-valuenow="${enrollment != null ? enrollment.progress : 0}"
                 aria-valuemin="0" aria-valuemax="100">
            </div>
        </div>
    </div>
</div>

<!-- Lesson Header -->
<div class="lesson-header">
    <div class="container">
        <div class="row">
            <div class="col-lg-8">
                <h1>${lesson.title}</h1>
                <div class="lesson-meta">
                    <span><i class="fas fa-book me-1"></i> ${course.name}</span>
                    <c:if test="${lesson.estimatedDuration != null}">
                        <span><i class="fas fa-clock me-1"></i> ${lesson.estimatedDuration} phút</span>
                    </c:if>
                    <span><i class="fas fa-list-ol me-1"></i> Bài ${lesson.orderIndex}/${totalLessons}</span>
                    <c:if test="${lesson.preview}">
                        <span><i class="fas fa-eye me-1"></i> Xem trước</span>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Main Content -->
<div class="lesson-layout">
    <!-- Lesson Content -->
    <div class="lesson-content">
        <!-- Video Section -->
        <c:if test="${not empty lesson.videoLink}">
            <div class="lesson-video">
                <c:choose>
                    <c:when test="${fn:contains(lesson.videoLink, 'youtube.com') || fn:contains(lesson.videoLink, 'youtu.be')}">
                        <c:set var="videoId" value="${fn:substringAfter(lesson.videoLink, 'v=')}" />
                        <c:if test="${fn:contains(videoId, '&')}">
                            <c:set var="videoId" value="${fn:substringBefore(videoId, '&')}" />
                        </c:if>
                        <iframe src="https://www.youtube.com/embed/${videoId}"
                                allowfullscreen>
                        </iframe>
                    </c:when>
                    <c:otherwise>
                        <video controls width="100%" height="400">
                            <source src="${lesson.videoLink}" type="video/mp4">
                            Trình duyệt của bạn không hỗ trợ video.
                        </video>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <!-- Lesson Content Body -->
        <div class="lesson-content-body">
            ${lesson.content}
        </div>

        <!-- Document Download Section -->
        <c:if test="${not empty lesson.documentUrl}">
            <div class="document-section">
                <h6><i class="fas fa-file-download me-2"></i>Tài liệu bài học</h6>
                <p>Tải xuống tài liệu để học offline và tham khảo.</p>
                <a href="${lesson.documentUrl}" class="btn btn-outline-primary" download>
                    <i class="fas fa-download me-2"></i>Tải xuống tài liệu
                </a>
            </div>
        </c:if>

        <!-- Lesson Actions -->
        <div class="lesson-meta-info">
            <div class="lesson-actions">
                <button type="button" class="btn btn-outline-primary bookmark-lesson-btn"
                        title="Đánh dấu bài học">
                    <i class="far fa-bookmark"></i>
                </button>
                <button type="button" class="btn btn-outline-info take-note-btn"
                        title="Ghi chú">
                    <i class="fas fa-sticky-note"></i>
                </button>
                <button type="button" class="btn btn-outline-success"
                        onclick="markLessonComplete()" title="Đánh dấu hoàn thành">
                    <i class="fas fa-check"></i>
                </button>
            </div>
            <div class="flex-grow-1 text-center">
                <small class="text-muted">
                    Cập nhật: <fmt:formatDate value="${lesson.updatedAt}" pattern="dd/MM/yyyy HH:mm" />
                </small>
            </div>
        </div>

        <!-- Navigation -->
        <div class="lesson-navigation">
            <div>
                <c:if test="${previousLesson != null}">
                    <a href="/student/lessons/${previousLesson.id}" class="nav-button btn-outline-primary">
                        <i class="fas fa-arrow-left"></i>
                        Bài trước: ${fn:substring(previousLesson.title, 0, 30)}${fn:length(previousLesson.title) > 30 ? '...' : ''}
                    </a>
                </c:if>
            </div>

            <div>
                <c:if test="${nextLesson != null}">
                    <a href="/student/lessons/${nextLesson.id}" class="nav-button btn-primary">
                        Bài tiếp: ${fn:substring(nextLesson.title, 0, 30)}${fn:length(nextLesson.title) > 30 ? '...' : ''}
                        <i class="fas fa-arrow-right"></i>
                    </a>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Sidebar -->
    <div class="lesson-sidebar">
        <!-- Course Info -->
        <div class="sidebar-section">
            <h5><i class="fas fa-book-open me-2"></i>Thông tin khóa học</h5>
            <div class="card border-0 bg-light">
                <div class="card-body p-3">
                    <h6 class="card-title">${course.name}</h6>
                    <p class="card-text small text-muted mb-2">
                        Giảng viên: ${course.instructor.fullName}
                    </p>
                    <div class="progress mb-2" style="height: 6px;">
                        <div class="progress-bar" role="progressbar"
                             style="width: ${enrollment != null ? enrollment.progress : 0}%">
                        </div>
                    </div>
                    <small class="text-muted">
                        Tiến độ: ${enrollment != null ? enrollment.progress : 0}%
                    </small>
                </div>
            </div>
        </div>

        <!-- Course Lessons -->
        <div class="sidebar-section">
            <h5><i class="fas fa-list me-2"></i>Danh sách bài học</h5>
            <ul class="course-lessons">
                <c:forEach items="${courseLessons}" var="courseLesson" varStatus="status">
                    <li>
                        <a href="/student/lessons/${courseLesson.id}"
                           class="${courseLesson.id == lesson.id ? 'current' : ''} ${courseLesson.completed ? 'completed' : ''}">
                            <div class="d-flex justify-content-between align-items-start">
                                <div class="flex-grow-1">
                                    <div class="fw-medium">${status.index + 1}. ${courseLesson.title}</div>
                                    <c:if test="${courseLesson.estimatedDuration != null}">
                                        <small class="text-muted">${courseLesson.estimatedDuration} phút</small>
                                    </c:if>
                                </div>
                                <c:if test="${courseLesson.preview}">
                                    <span class="badge bg-info ms-2">Preview</span>
                                </c:if>
                            </div>
                        </a>
                    </li>
                </c:forEach>
            </ul>
        </div>

        <!-- Quick Actions -->
        <div class="sidebar-section">
            <h5><i class="fas fa-tools me-2"></i>Thao tác nhanh</h5>
            <div class="d-grid gap-2">
                <button class="btn btn-outline-primary btn-sm" onclick="toggleFullscreenMode()">
                    <i class="fas fa-expand me-1"></i> Chế độ toàn màn hình
                </button>
                <a href="/student/courses/${course.id}/quizzes" class="btn btn-outline-info btn-sm">
                    <i class="fas fa-question-circle me-1"></i> Bài kiểm tra
                </a>
                <a href="/student/courses/${course.id}" class="btn btn-outline-secondary btn-sm">
                    <i class="fas fa-arrow-left me-1"></i> Về khóa học
                </a>
            </div>
        </div>

        <!-- Keyboard Shortcuts Help -->
        <div class="sidebar-section">
            <h6><i class="fas fa-keyboard me-2"></i>Phím tắt</h6>
            <small class="text-muted">
                <div>Space: Cuộn xuống</div>
                <div>Ctrl + ←: Bài trước</div>
                <div>Ctrl + →: Bài tiếp</div>
                <div>Ctrl + F: Toàn màn hình</div>
                <div>Esc: Về khóa học</div>
            </small>
        </div>
    </div>
</div>

<!-- Bootstrap JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Highlight.js -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.8.0/highlight.min.js"></script>

<!-- Custom JavaScript -->
<script>
    // Dữ liệu lesson được truyền từ server
    window.lessonData = {
        id: ${lesson.id},
        courseId: ${course.id},
        title: '${lesson.title}',
        orderIndex: ${lesson.orderIndex}
    };

    // Biến để theo dõi vị trí đọc và thời gian
    let readingPosition = 0;
    let startTime = Date.now();
    let timeSpent = 0;
    let progressInterval;

    /**
     * Khởi tạo theo dõi tiến độ bài giảng
     * Gửi thông tin về server mỗi 30 giây
     */
    function initializeProgressTracking() {
        if (!window.lessonData.id) return;

        // Gửi thông tin tiến độ mỗi 30 giây
        progressInterval = setInterval(() => {
            updateLessonProgress();
        }, 30000);

        // Gửi tiến độ khi user rời khỏi trang
        window.addEventListener('beforeunload', () => {
            updateLessonProgress();
        });

        // Gửi tiến độ khi user chuyển tab
        document.addEventListener('visibilitychange', () => {
            if (document.hidden) {
                updateLessonProgress();
            }
        });
    }

    /**
     * Cập nhật tiến độ học bài giảng lên server
     */
    function updateLessonProgress() {
        if (!window.lessonData.id) return;

        timeSpent += Math.round((Date.now() - startTime) / 1000);
        startTime = Date.now();

        // Tính phần trăm tiến độ dựa trên vị trí scroll
        const documentHeight = document.documentElement.scrollHeight - window.innerHeight;
        const scrollPercentage = documentHeight > 0 ? Math.min(100, Math.round((readingPosition / documentHeight) * 100)) : 100;

        // Gửi dữ liệu lên server
        fetch('/api/v1/lessons/' + window.lessonData.id + '/progress', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: JSON.stringify({
                progressPercentage: scrollPercentage,
                timeSpent: timeSpent,
                lastPosition: readingPosition
            })
        }).then(response => {
            if (response.ok) {
                console.log('Đã cập nhật tiến độ bài học:', scrollPercentage + '%');

                // Cập nhật progress bar nếu có
                updateProgressBar(scrollPercentage);
            }
        }).catch(error => {
            console.error('Lỗi khi cập nhật tiến độ:', error);
        });
    }

    /**
     * Cập nhật thanh progress bar trên giao diện
     */
    function updateProgressBar(percentage) {
        const progressBar = document.querySelector('.lesson-progress-bar');
        const progressText = document.querySelector('.lesson-progress-text');

        if (progressBar) {
            progressBar.style.width = percentage + '%';
            progressBar.setAttribute('aria-valuenow', percentage);
        }

        if (progressText) {
            progressText.textContent = percentage + '% hoàn thành';
        }

        // Đánh dấu bài học hoàn thành nếu đọc >= 90%
        if (percentage >= 90) {
            markLessonAsCompleted();
        }
    }

    /**
     * Đánh dấu bài học đã hoàn thành
     */
    function markLessonAsCompleted() {
        if (!window.lessonData.id) return;

        fetch('/api/v1/lessons/' + window.lessonData.id + '/complete', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        }).then(response => {
            if (response.ok) {
                // Hiển thị thông báo hoàn thành
                showCompletionNotification();

                // Cập nhật UI
                const completionBadge = document.querySelector('.lesson-completion-badge');
                if (completionBadge) {
                    completionBadge.innerHTML = '<span class="completion-badge"><i class="fas fa-check-circle"></i> Đã hoàn thành</span>';
                }
            }
        }).catch(error => {
            console.error('Lỗi khi đánh dấu hoàn thành:', error);
        });
    }

    /**
     * Hiển thị thông báo hoàn thành bài học
     */
    function showCompletionNotification() {
        // Tạo toast notification
        const toastHtml = `
                <div class="toast lesson-completion-toast" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="toast-header bg-success text-white">
                        <i class="fas fa-graduation-cap me-2"></i>
                        <strong class="me-auto">Chúc mừng!</strong>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"></button>
                    </div>
                    <div class="toast-body">
                        <p class="mb-2">🎉 Bạn đã hoàn thành bài học này!</p>
                        <div class="d-flex gap-2">
                            <button class="btn btn-sm btn-outline-primary next-lesson-btn">
                                <i class="fas fa-arrow-right"></i> Bài tiếp theo
                            </button>
                            <button class="btn btn-sm btn-outline-secondary back-to-course-btn">
                                <i class="fas fa-list"></i> Về khóa học
                            </button>
                        </div>
                    </div>
                </div>
            `;

        // Thêm toast vào container
        let toastContainer = document.querySelector('.toast-container');
        if (!toastContainer) {
            toastContainer = document.createElement('div');
            toastContainer.className = 'toast-container position-fixed top-0 end-0 p-3';
            document.body.appendChild(toastContainer);
        }

        toastContainer.insertAdjacentHTML('beforeend', toastHtml);

        // Khởi tạo và hiển thị toast
        const toast = toastContainer.querySelector('.lesson-completion-toast:last-child');
        const bsToast = new bootstrap.Toast(toast, { delay: 8000 });
        bsToast.show();

        // Xử lý sự kiện click cho các nút trong toast
        toast.querySelector('.next-lesson-btn')?.addEventListener('click', () => {
            goToNextLesson();
        });

        toast.querySelector('.back-to-course-btn')?.addEventListener('click', () => {
            window.location.href = '/student/courses/' + window.lessonData.courseId;
        });
    }

    /**
     * Chuyển đến bài học tiếp theo
     */
    function goToNextLesson() {
        const nextLessonLink = document.querySelector('a[href*="/lessons/"]:has(.fa-arrow-right)');
        if (nextLessonLink) {
            nextLessonLink.click();
        } else {
            // Nếu không có bài tiếp theo, về trang khóa học
            window.location.href = '/student/courses/' + window.lessonData.courseId;
        }
    }

    /**
     * Theo dõi vị trí scroll và lưu vào localStorage
     */
    function initializeScrollTracking() {
        // Theo dõi vị trí scroll
        window.addEventListener('scroll', function() {
            readingPosition = window.scrollY;

            // Lưu vị trí đọc sau mỗi 2 giây scroll
            clearTimeout(window.saveTimeout);
            window.saveTimeout = setTimeout(() => {
                if (window.lessonData.id) {
                    localStorage.setItem(`lesson_${window.lessonData.id}_position`, readingPosition);
                }
            }, 2000);
        });

        // Khôi phục vị trí đọc đã lưu
        const savedPosition = localStorage.getItem(`lesson_${window.lessonData.id}_position`);
        if (savedPosition && !window.location.hash) {
            setTimeout(() => {
                window.scrollTo({
                    top: parseInt(savedPosition),
                    behavior: 'smooth'
                });
            }, 100);
        }
    }

    /**
     * Khởi tạo keyboard shortcuts
     */
    function initializeKeyboardShortcuts() {
        document.addEventListener('keydown', function(e) {
            // Chỉ xử lý khi không đang focus vào input/textarea
            if (e.target.matches('input, textarea, [contenteditable]')) {
                return;
            }

            switch(e.code) {
                // Space bar để scroll xuống
                case 'Space':
                    e.preventDefault();
                    window.scrollBy({
                        top: window.innerHeight * 0.8,
                        behavior: 'smooth'
                    });
                    break;

                // Arrow keys với Ctrl để navigation
                case 'ArrowLeft':
                    if (e.ctrlKey) {
                        e.preventDefault();
                        const prevLink = document.querySelector('a[href*="/lessons/"]:has(.fa-arrow-left)');
                        if (prevLink) prevLink.click();
                    }
                    break;

                case 'ArrowRight':
                    if (e.ctrlKey) {
                        e.preventDefault();
                        const nextLink = document.querySelector('a[href*="/lessons/"]:has(.fa-arrow-right)');
                        if (nextLink) nextLink.click();
                    }
                    break;

                // Esc để về trang khóa học
                case 'Escape':
                    if (window.lessonData.courseId) {
                        window.location.href = '/student/courses/' + window.lessonData.courseId;
                    }
                    break;

                // F để toggle fullscreen reading mode
                case 'KeyF':
                    if (e.ctrlKey) {
                        e.preventDefault();
                        toggleFullscreenMode();
                    }
                    break;
            }
        });
    }

    /**
     * Toggle chế độ đọc fullscreen
     */
    function toggleFullscreenMode() {
        const body = document.body;
        const sidebar = document.querySelector('.lesson-sidebar');
        const navbar = document.querySelector('.navbar');

        if (body.classList.contains('fullscreen-reading')) {
            // Thoát chế độ fullscreen
            body.classList.remove('fullscreen-reading');
            if (sidebar) sidebar.style.display = '';
            if (navbar) navbar.style.display = '';
        } else {
            // Vào chế độ fullscreen
            body.classList.add('fullscreen-reading');
            if (sidebar) sidebar.style.display = 'none';
            if (navbar) navbar.style.display = 'none';
        }
    }

    /**
     * Xử lý auto-close sidebar trên mobile
     */
    function initializeMobileSidebar() {
        const sidebar = document.querySelector('.lesson-sidebar');
        const content = document.querySelector('.lesson-content');

        if (sidebar && content && window.innerWidth <= 768) {
            // Đóng sidebar khi click vào content trên mobile
            content.addEventListener('click', () => {
                if (sidebar.classList.contains('show')) {
                    const sidebarCollapse = bootstrap.Collapse.getInstance(sidebar);
                    if (sidebarCollapse) {
                        sidebarCollapse.hide();
                    }
                }
            });
        }
    }

    /**
     * Xử lý bookmark/favorite lesson
     */
    function initializeBookmarkFeature() {
        const bookmarkBtn = document.querySelector('.bookmark-lesson-btn');
        if (bookmarkBtn && window.lessonData.id) {
            bookmarkBtn.addEventListener('click', () => {
                toggleLessonBookmark();
            });
        }
    }

    /**
     * Toggle bookmark cho bài học
     */
    function toggleLessonBookmark() {
        fetch('/api/v1/lessons/' + window.lessonData.id + '/bookmark', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        }).then(response => response.json())
            .then(data => {
                const bookmarkBtn = document.querySelector('.bookmark-lesson-btn');
                const bookmarkIcon = bookmarkBtn.querySelector('i');

                if (data.bookmarked) {
                    bookmarkIcon.className = 'fas fa-bookmark text-warning';
                    bookmarkBtn.title = 'Bỏ đánh dấu';
                } else {
                    bookmarkIcon.className = 'far fa-bookmark';
                    bookmarkBtn.title = 'Đánh dấu bài học';
                }
            }).catch(error => {
            console.error('Lỗi khi toggle bookmark:', error);
        });
    }

    /**
     * Khởi tạo chức năng note-taking
     */
    function initializeNoteTaking() {
        const noteBtn = document.querySelector('.take-note-btn');
        if (noteBtn) {
            noteBtn.addEventListener('click', () => {
                openNoteModal();
            });
        }
    }

    /**
     * Mở modal ghi chú
     */
    function openNoteModal() {
        // Tạo modal ghi chú nếu chưa có
        let noteModal = document.querySelector('#lessonNoteModal');
        if (!noteModal) {
            const modalHtml = `
                    <div class="modal fade" id="lessonNoteModal" tabindex="-1">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">
                                        <i class="fas fa-sticky-note"></i> Ghi chú bài học
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <textarea class="form-control" id="lessonNoteContent" rows="8"
                                        placeholder="Viết ghi chú của bạn về bài học này..."></textarea>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                    <button type="button" class="btn btn-primary" id="saveNoteBtn">
                                        <i class="fas fa-save"></i> Lưu ghi chú
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                `;
            document.body.insertAdjacentHTML('beforeend', modalHtml);
            noteModal = document.querySelector('#lessonNoteModal');

            // Xử lý lưu ghi chú
            noteModal.querySelector('#saveNoteBtn').addEventListener('click', () => {
                saveLessonNote();
            });
        }

        // Load ghi chú đã có (nếu có)
        loadLessonNote();

        // Hiển thị modal
        const bsModal = new bootstrap.Modal(noteModal);
        bsModal.show();
    }

    /**
     * Load ghi chú đã lưu
     */
    function loadLessonNote() {
        const noteContent = localStorage.getItem(`lesson_${window.lessonData.id}_note`);
        const textarea = document.querySelector('#lessonNoteContent');
        if (textarea && noteContent) {
            textarea.value = noteContent;
        }
    }

    /**
     * Lưu ghi chú bài học
     */
    function saveLessonNote() {
        const textarea = document.querySelector('#lessonNoteContent');
        const content = textarea.value.trim();

        // Lưu vào localStorage
        localStorage.setItem(`lesson_${window.lessonData.id}_note`, content);

        // Gửi lên server (optional)
        if (content) {
            fetch('/api/v1/lessons/' + window.lessonData.id + '/notes', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: JSON.stringify({ content: content })
            }).then(response => {
                if (response.ok) {
                    console.log('Đã lưu ghi chú lên server');
                }
            }).catch(error => {
                console.error('Lỗi khi lưu ghi chú:', error);
            });
        }

        // Đóng modal
        const modal = bootstrap.Modal.getInstance(document.querySelector('#lessonNoteModal'));
        modal.hide();

        // Hiển thị thông báo
        showToast('Đã lưu ghi chú thành công!', 'success');
    }

    /**
     * Hiển thị toast notification
     */
    function showToast(message, type = 'info') {
        const toastHtml = `
                <div class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="toast-header bg-${type} text-white">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong class="me-auto">Thông báo</strong>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"></button>
                    </div>
                    <div class="toast-body">
                        ${message}
                    </div>
                </div>
            `;

        let toastContainer = document.querySelector('.toast-container');
        if (!toastContainer) {
            toastContainer = document.createElement('div');
            toastContainer.className = 'toast-container position-fixed top-0 end-0 p-3';
            document.body.appendChild(toastContainer);
        }

        toastContainer.insertAdjacentHTML('beforeend', toastHtml);
        const toast = toastContainer.querySelector('.toast:last-child');
        const bsToast = new bootstrap.Toast(toast);
        bsToast.show();
    }

    /**
     * Đánh dấu bài học hoàn thành manually
     */
    function markLessonComplete() {
        fetch('/api/v1/lessons/' + window.lessonData.id + '/complete', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        }).then(response => {
            if (response.ok) {
                showToast('Đã đánh dấu bài học hoàn thành!', 'success');
                updateProgressBar(100);
                showCompletionNotification();
            }
        }).catch(error => {
            console.error('Lỗi khi đánh dấu hoàn thành:', error);
            showToast('Có lỗi xảy ra. Vui lòng thử lại!', 'danger');
        });
    }

    // Khởi tạo tất cả các chức năng khi DOM ready
    document.addEventListener('DOMContentLoaded', function() {
        // Highlight code blocks
        document.querySelectorAll('pre code').forEach((block) => {
            hljs.highlightBlock(block);
        });

        // Khởi tạo tất cả features
        initializeProgressTracking();
        initializeScrollTracking();
        initializeKeyboardShortcuts();
        initializeMobileSidebar();
        initializeBookmarkFeature();
        initializeNoteTaking();

        console.log('Lesson view JavaScript đã khởi tạo thành công');
    });
</script>
</body>
</html>