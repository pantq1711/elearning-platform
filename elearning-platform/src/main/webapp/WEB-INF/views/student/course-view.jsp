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
    <title>${course.name} - EduLearn Platform</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/student.css"" rel="stylesheet">

    <style>
        .course-sidebar {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 1.5rem;
            position: sticky;
            top: 90px;
            max-height: calc(100vh - 110px);
            overflow-y: auto;
        }

        .lesson-item {
            border: 1px solid #e9ecef;
            border-radius: 8px;
            margin-bottom: 0.75rem;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .lesson-item:hover {
            border-color: #0d6efd;
            box-shadow: 0 2px 8px rgba(13, 110, 253, 0.15);
        }

        .lesson-item.active {
            border-color: #0d6efd;
            background-color: #e7f3ff;
        }

        .lesson-item.completed {
            border-color: #198754;
            background-color: #d1eddb;
        }

        .lesson-item.locked {
            opacity: 0.6;
            cursor: not-allowed;
        }

        .progress-circle {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            border: 4px solid #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            color: #0d6efd;
        }

        .video-player {
            width: 100%;
            height: 400px;
            border-radius: 12px;
            background: #000;
        }

        .quiz-card {
            border: 2px solid #ffc107;
            border-radius: 12px;
            background: linear-gradient(135deg, #fff5cd 0%, #ffe69c 100%);
        }

        .certificate-card {
            border: 2px solid #198754;
            border-radius: 12px;
            background: linear-gradient(135deg, #d1eddb 0%, #a3d977 100%);
        }

        .discussion-card {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }

        .discussion-card:hover {
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .content-tabs {
            border-bottom: 2px solid #f0f0f0;
            margin-bottom: 2rem;
        }

        .content-tabs .nav-link {
            border: none;
            border-bottom: 2px solid transparent;
            color: #6c757d;
            font-weight: 500;
        }

        .content-tabs .nav-link.active {
            color: #0d6efd;
            border-bottom-color: #0d6efd;
            background: none;
        }
    </style>
</head>

<body>
<!-- Include Header -->
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container-fluid py-4">
    <div class="row">
        <!-- Course Content -->
        <div class="col-lg-8">
            <!-- Course Header -->
            <div class="course-header mb-4">
                <div class="d-flex align-items-center mb-3">
                    <a href="${pageContext.request.contextPath}/student/my-courses"" class="btn btn-outline-secondary me-3">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại
                    </a>
                    <div class="flex-grow-1">
                        <h1 class="h3 mb-1">${course.name}</h1>
                        <p class="text-muted mb-0">bởi ${course.instructor.fullName}</p>
                    </div>
                    <div class="text-end">
                        <div class="progress-circle">
                            <fmt:formatNumber value="${enrollment.progress}" maxFractionDigits="0" />%
                        </div>
                    </div>
                </div>

                <!-- Progress Bar -->
                <div class="progress mb-3" style="height: 8px;">
                    <div class="progress-bar bg-success"
                         style="width: ${enrollment.progress}%"></div>
                </div>

                <div class="row text-center">
                    <div class="col-4">
                        <div class="fw-bold">${enrollment.completedLessons}</div>
                        <small class="text-muted">Bài hoàn thành</small>
                    </div>
                    <div class="col-4">
                        <div class="fw-bold">${enrollment.totalLessons}</div>
                        <small class="text-muted">Tổng bài học</small>
                    </div>
                    <div class="col-4">
                        <div class="fw-bold">
                            <fmt:formatNumber value="${enrollment.studyTime / 60}" maxFractionDigits="0" />h
                        </div>
                        <small class="text-muted">Thời gian học</small>
                    </div>
                </div>
            </div>

            <!-- Content Tabs -->
            <ul class="nav nav-tabs content-tabs" id="contentTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="lesson-tab" data-bs-toggle="tab"
                            data-bs-target="#lesson-content" type="button">
                        <i class="fas fa-play-circle me-2"></i>Bài học
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="quiz-tab" data-bs-toggle="tab"
                            data-bs-target="#quiz-content" type="button">
                        <i class="fas fa-question-circle me-2"></i>Bài kiểm tra
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="discussion-tab" data-bs-toggle="tab"
                            data-bs-target="#discussion-content" type="button">
                        <i class="fas fa-comments me-2"></i>Thảo luận
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="resources-tab" data-bs-toggle="tab"
                            data-bs-target="#resources-content" type="button">
                        <i class="fas fa-download me-2"></i>Tài liệu
                    </button>
                </li>
            </ul>

            <!-- Tab Content -->
            <div class="tab-content" id="contentTabsContent">

                <!-- Lesson Content -->
                <div class="tab-pane fade show active" id="lesson-content" role="tabpanel">
                    <c:choose>
                        <c:when test="${not empty currentLesson}">
                            <!-- Video Player / Content Display -->
                            <div class="lesson-display mb-4">
                                <c:choose>
                                    <c:when test="${currentLesson.type == 'VIDEO'}">
                                        <video class="video-player" controls poster="${currentLesson.thumbnailUrl}">
                                            <source src="${currentLesson.videoUrl}" type="video/mp4">
                                            Trình duyệt của bạn không hỗ trợ video HTML5.
                                        </video>
                                    </c:when>
                                    <c:when test="${currentLesson.type == 'DOCUMENT'}">
                                        <div class="document-viewer">
                                            <iframe src="${currentLesson.documentUrl}"
                                                    width="100%" height="500px"
                                                    style="border: none; border-radius: 8px;">
                                            </iframe>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-content p-4 bg-light rounded">
                                                ${currentLesson.content}
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Lesson Info -->
                            <div class="lesson-info card mb-4">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div>
                                            <h4>${currentLesson.title}</h4>
                                            <p class="text-muted mb-0">${currentLesson.description}</p>
                                        </div>
                                        <div class="text-end">
                                            <c:if test="${currentLesson.duration > 0}">
                                                <div class="lesson-duration">
                                                    <i class="fas fa-clock me-1"></i>
                                                    <fmt:formatNumber value="${currentLesson.duration / 60}" maxFractionDigits="0" /> phút
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>

                                    <!-- Lesson Actions -->
                                    <div class="lesson-actions d-flex gap-2">
                                        <c:if test="${not enrollment.lessonCompleted[currentLesson.id]}">
                                            <button class="btn btn-success" onclick="markLessonComplete(${currentLesson.id})">
                                                <i class="fas fa-check me-2"></i>Đánh dấu hoàn thành
                                            </button>
                                        </c:if>

                                        <c:if test="${currentLesson.hasNotes}">
                                            <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#notesModal">
                                                <i class="fas fa-sticky-note me-2"></i>Ghi chú
                                            </button>
                                        </c:if>

                                        <c:if test="${not empty currentLesson.downloadUrl}">
                                            <a href="${currentLesson.downloadUrl}" class="btn btn-outline-info" download>
                                                <i class="fas fa-download me-2"></i>Tải xuống
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>

                            <!-- Navigation -->
                            <div class="lesson-navigation d-flex justify-content-between">
                                <c:if test="${not empty previousLesson}">
                                    <a href="${pageContext.request.contextPath}/student/courses/${course.id}/lessons/${previousLesson.id}"
                                       class="btn btn-outline-secondary">
                                        <i class="fas fa-chevron-left me-2"></i>Bài trước
                                    </a>
                                </c:if>

                                <div class="flex-grow-1"></div>

                                <c:if test="${not empty nextLesson}">
                                    <a href="${pageContext.request.contextPath}/student/courses/${course.id}/lessons/${nextLesson.id}"
                                       class="btn btn-primary">
                                        Bài tiếp theo<i class="fas fa-chevron-right ms-2"></i>
                                    </a>
                                </c:if>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- No Lesson Selected -->
                            <div class="text-center py-5">
                                <i class="fas fa-play-circle fa-4x text-muted mb-3"></i>
                                <h5 class="text-muted">Chọn bài học để bắt đầu</h5>
                                <p class="text-muted">Chọn một bài học từ danh sách bên phải để bắt đầu học.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Quiz Content -->
                <div class="tab-pane fade" id="quiz-content" role="tabpanel">
                    <c:choose>
                        <c:when test="${not empty quizzes}">
                            <div class="row">
                                <c:forEach items="${quizzes}" var="quiz" varStatus="status">
                                    <div class="col-md-6 mb-4">
                                        <div class="quiz-card card h-100">
                                            <div class="card-body">
                                                <div class="d-flex align-items-start mb-3">
                                                    <i class="fas fa-question-circle fa-2x text-warning me-3"></i>
                                                    <div class="flex-grow-1">
                                                        <h5>${quiz.title}</h5>
                                                        <p class="text-muted mb-0">${quiz.description}</p>
                                                    </div>
                                                </div>

                                                <div class="quiz-info mb-3">
                                                    <div class="row text-center">
                                                        <div class="col-4">
                                                            <div class="fw-bold">${quiz.questionCount}</div>
                                                            <small class="text-muted">Câu hỏi</small>
                                                        </div>
                                                        <div class="col-4">
                                                            <div class="fw-bold">
                                                                <c:choose>
                                                                    <c:when test="${quiz.timeLimit > 0}">
                                                                        ${quiz.timeLimit}p
                                                                    </c:when>
                                                                    <c:otherwise>∞</c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                            <small class="text-muted">Thời gian</small>
                                                        </div>
                                                        <div class="col-4">
                                                            <div class="fw-bold">${quiz.passingScore}</div>
                                                            <small class="text-muted">Điểm đậu</small>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Quiz Status -->
                                                <c:choose>
                                                    <c:when test="${quiz.completed}">
                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <div>
                                                                <span class="badge bg-success">Đã hoàn thành</span>
                                                                <div class="small text-muted mt-1">
                                                                    Điểm: ${quiz.lastScore}/${quiz.maxScore}
                                                                </div>
                                                            </div>
                                                            <div>
                                                                <a href="${pageContext.request.contextPath}/student/quiz/${quiz.id}/result""
                                                                   class="btn btn-outline-success btn-sm">
                                                                    <i class="fas fa-eye me-1"></i>Xem kết quả
                                                                </a>
                                                                <c:if test="${quiz.allowRetake}">
                                                                    <a href="${pageContext.request.contextPath}/student/quiz/${quiz.id}"
                                                                       class="btn btn-warning btn-sm">
                                                                        <i class="fas fa-redo me-1"></i>Làm lại
                                                                    </a>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:when test="${quiz.locked}">
                                                        <div class="text-center">
                                                            <span class="badge bg-secondary">Chưa mở khóa</span>
                                                            <div class="small text-muted mt-1">
                                                                Hoàn thành các bài học trước để mở khóa
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="text-center">
                                                            <a href="${pageContext.request.contextPath}/student/quiz/${quiz.id}"
                                                               class="btn btn-warning">
                                                                <i class="fas fa-play me-2"></i>Bắt đầu làm bài
                                                            </a>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="fas fa-question-circle fa-4x text-muted mb-3"></i>
                                <h5 class="text-muted">Chưa có bài kiểm tra</h5>
                                <p class="text-muted">Khóa học này chưa có bài kiểm tra nào.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Discussion Content -->
                <div class="tab-pane fade" id="discussion-content" role="tabpanel">
                    <!-- Discussion Form -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <h6 class="card-title">Đặt câu hỏi hoặc chia sẻ ý kiến</h6>
                            <form id="discussionForm" onsubmit="submitDiscussion(event)">
                                <div class="mb-3">
                                    <textarea class="form-control" id="discussionContent" rows="3"
                                              placeholder="Viết câu hỏi hoặc ý kiến của bạn..." required></textarea>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="anonymousPost">
                                        <label class="form-check-label" for="anonymousPost">
                                            Đăng ẩn danh
                                        </label>
                                    </div>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-paper-plane me-2"></i>Gửi
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Discussion List -->
                    <div id="discussionList">
                        <c:choose>
                            <c:when test="${not empty discussions}">
                                <c:forEach items="${discussions}" var="discussion" varStatus="status">
                                    <div class="discussion-card card">
                                        <div class="card-body">
                                            <div class="d-flex align-items-start">
                                                <img src="${pageContext.request.contextPath}/images/avatars/${discussion.author.avatar}"
                                                     alt="${discussion.author.fullName}"
                                                     class="rounded-circle me-3"
                                                     style="width: 40px; height: 40px; object-fit: cover;"
                                                     onerror="this.src='/images/avatar-default.png"'">
                                                <div class="flex-grow-1">
                                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                                        <div>
                                                            <h6 class="mb-0">${discussion.author.fullName}</h6>
                                                            <small class="text-muted">
                                                                <fmt:formatDate value="${discussion.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                            </small>
                                                        </div>
                                                        <div class="dropdown">
                                                            <button class="btn btn-sm btn-outline-secondary"
                                                                    data-bs-toggle="dropdown">
                                                                <i class="fas fa-ellipsis-v"></i>
                                                            </button>
                                                            <ul class="dropdown-menu">
                                                                <li>
                                                                    <a class="dropdown-item" href="#"
                                                                       onclick="reportDiscussion(${discussion.id})">
                                                                        <i class="fas fa-flag me-2"></i>Báo cáo
                                                                    </a>
                                                                </li>
                                                            </ul>
                                                        </div>
                                                    </div>
                                                    <p class="mb-2">${discussion.content}</p>
                                                    <div class="d-flex align-items-center">
                                                        <button class="btn btn-sm btn-outline-primary me-2"
                                                                onclick="likeDiscussion(${discussion.id})">
                                                            <i class="fas fa-thumbs-up me-1"></i>
                                                            <span id="likes-${discussion.id}">${discussion.likeCount}</span>
                                                        </button>
                                                        <button class="btn btn-sm btn-outline-secondary"
                                                                onclick="toggleReply(${discussion.id})">
                                                            <i class="fas fa-reply me-1"></i>Trả lời
                                                        </button>
                                                    </div>

                                                    <!-- Reply Form -->
                                                    <div id="replyForm-${discussion.id}" class="mt-3" style="display: none;">
                                                        <form onsubmit="submitReply(event, ${discussion.id})">
                                                            <div class="input-group">
                                                                <input type="text" class="form-control"
                                                                       placeholder="Viết câu trả lời..." required>
                                                                <button type="submit" class="btn btn-primary">
                                                                    <i class="fas fa-paper-plane"></i>
                                                                </button>
                                                            </div>
                                                        </form>
                                                    </div>

                                                    <!-- Replies -->
                                                    <c:if test="${not empty discussion.replies}">
                                                        <div class="replies mt-3 ps-3 border-start">
                                                            <c:forEach items="${discussion.replies}" var="reply">
                                                                <div class="reply-item mb-2">
                                                                    <div class="d-flex align-items-start">
                                                                        <img src="${pageContext.request.contextPath}/images/avatars/${reply.author.avatar}"
                                                                             alt="${reply.author.fullName}"
                                                                             class="rounded-circle me-2"
                                                                             style="width: 24px; height: 24px; object-fit: cover;">
                                                                        <div class="flex-grow-1">
                                                                            <div class="bg-light p-2 rounded">
                                                                                <div class="d-flex justify-content-between">
                                                                                    <small class="fw-bold">${reply.author.fullName}</small>
                                                                                    <small class="text-muted">
                                                                                        <fmt:formatDate value="${reply.createdAt}" pattern="HH:mm dd/MM" />
                                                                                    </small>
                                                                                </div>
                                                                                <div>${reply.content}</div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </c:forEach>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="fas fa-comments fa-4x text-muted mb-3"></i>
                                    <h5 class="text-muted">Chưa có thảo luận</h5>
                                    <p class="text-muted">Hãy là người đầu tiên đặt câu hỏi hoặc chia sẻ ý kiến.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Resources Content -->
                <div class="tab-pane fade" id="resources-content" role="tabpanel">
                    <c:choose>
                        <c:when test="${not empty resources}">
                            <div class="row">
                                <c:forEach items="${resources}" var="resource" varStatus="status">
                                    <div class="col-md-6 mb-3">
                                        <div class="card">
                                            <div class="card-body d-flex align-items-center">
                                                <div class="resource-icon me-3">
                                                    <i class="fas fa-${resource.type == 'PDF' ? 'file-pdf text-danger' :
                                                                     resource.type == 'DOC' ? 'file-word text-primary' :
                                                                     resource.type == 'PPT' ? 'file-powerpoint text-warning' :
                                                                     'file text-secondary'} fa-2x"></i>
                                                </div>
                                                <div class="flex-grow-1">
                                                    <h6 class="mb-1">${resource.name}</h6>
                                                    <small class="text-muted">${resource.size}</small>
                                                </div>
                                                <div>
                                                    <a href="${resource.downloadUrl}" class="btn btn-outline-primary btn-sm" download>
                                                        <i class="fas fa-download"></i>
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="fas fa-download fa-4x text-muted mb-3"></i>
                                <h5 class="text-muted">Chưa có tài liệu</h5>
                                <p class="text-muted">Chưa có tài liệu nào để tải xuống.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Sidebar -->
        <div class="col-lg-4">
            <div class="course-sidebar">
                <!-- Course Progress -->
                <div class="progress-section mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <h6 class="mb-0">Tiến độ khóa học</h6>
                        <span class="fw-bold text-primary">
                            <fmt:formatNumber value="${enrollment.progress}" maxFractionDigits="0" />%
                        </span>
                    </div>
                    <div class="progress mb-2" style="height: 8px;">
                        <div class="progress-bar bg-gradient"
                             style="width: ${enrollment.progress}%"></div>
                    </div>
                    <small class="text-muted">
                        ${enrollment.completedLessons} / ${enrollment.totalLessons} bài học hoàn thành
                    </small>
                </div>

                <!-- Lessons List -->
                <div class="lessons-section">
                    <h6 class="mb-3">
                        <i class="fas fa-list me-2"></i>Nội dung khóa học
                    </h6>

                    <c:forEach items="${lessons}" var="lesson" varStatus="status">
                        <div class="lesson-item ${currentLesson.id == lesson.id ? 'active' : ''}
                                    ${enrollment.lessonCompleted[lesson.id] ? 'completed' : ''}
                                    ${lesson.locked ? 'locked' : ''}"
                             onclick="${lesson.locked ? '' : 'goToLesson(' += lesson.id += ')'}">
                            <div class="d-flex align-items-center p-3">
                                <div class="lesson-status me-3">
                                    <c:choose>
                                        <c:when test="${enrollment.lessonCompleted[lesson.id]}">
                                            <i class="fas fa-check-circle text-success"></i>
                                        </c:when>
                                        <c:when test="${lesson.locked}">
                                            <i class="fas fa-lock text-muted"></i>
                                        </c:when>
                                        <c:when test="${currentLesson.id == lesson.id}">
                                            <i class="fas fa-play-circle text-primary"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-circle text-muted"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="flex-grow-1">
                                    <div class="lesson-title fw-medium">${lesson.title}</div>
                                    <div class="lesson-meta">
                                        <c:if test="${lesson.type == 'VIDEO'}">
                                            <i class="fas fa-play me-1"></i>
                                        </c:if>
                                        <c:if test="${lesson.type == 'DOCUMENT'}">
                                            <i class="fas fa-file-alt me-1"></i>
                                        </c:if>
                                        <c:if test="${lesson.type == 'TEXT'}">
                                            <i class="fas fa-align-left me-1"></i>
                                        </c:if>
                                        <small class="text-muted">
                                            <c:if test="${lesson.duration > 0}">
                                                <fmt:formatNumber value="${lesson.duration / 60}" maxFractionDigits="0" /> phút
                                            </c:if>
                                            <c:if test="${lesson.preview}">
                                                • Xem trước
                                            </c:if>
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Certificate Section -->
                <c:if test="${enrollment.completed}">
                    <div class="certificate-section mt-4">
                        <div class="certificate-card card">
                            <div class="card-body text-center">
                                <i class="fas fa-certificate fa-3x text-success mb-3"></i>
                                <h6>Chúc mừng!</h6>
                                <p class="mb-3">Bạn đã hoàn thành khóa học</p>
                                <a href="${pageContext.request.contextPath}/student/courses/${course.id}/certificate""
                                   class="btn btn-success">
                                    <i class="fas fa-download me-2"></i>Tải chứng chỉ
                                </a>
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- Instructor Info -->
                <div class="instructor-section mt-4">
                    <h6 class="mb-3">
                        <i class="fas fa-chalkboard-teacher me-2"></i>Giảng viên
                    </h6>
                    <div class="d-flex align-items-center">
                        <img src="${pageContext.request.contextPath}/images/avatars/${course.instructor.avatar}"
                             alt="${course.instructor.fullName}"
                             class="rounded-circle me-3"
                             style="width: 50px; height: 50px; object-fit: cover;"
                             onerror="this.src='/images/avatar-default.png"'">
                        <div>
                            <div class="fw-medium">${course.instructor.fullName}</div>
                            <small class="text-muted">${course.instructor.title}</small>
                        </div>
                    </div>
                    <div class="mt-2">
                        <button class="btn btn-outline-primary btn-sm w-100" data-bs-toggle="modal" data-bs-target="#messageInstructorModal">
                            <i class="fas fa-envelope me-2"></i>Gửi tin nhắn
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Notes Modal -->
<div class="modal fade" id="notesModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-sticky-note me-2"></i>Ghi chú của tôi
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <textarea class="form-control" id="lessonNotes" rows="6"
                          placeholder="Ghi chú của bạn cho bài học này...">${currentLessonNotes}</textarea>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                <button type="button" class="btn btn-primary" onclick="saveNotes()">
                    <i class="fas fa-save me-2"></i>Lưu ghi chú
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Message Instructor Modal -->
<div class="modal fade" id="messageInstructorModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-envelope me-2"></i>Gửi tin nhắn cho giảng viên
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="messageForm">
                    <div class="mb-3">
                        <label for="messageSubject" class="form-label">Tiêu đề</label>
                        <input type="text" class="form-control" id="messageSubject"
                               placeholder="Nhập tiêu đề tin nhắn..." required>
                    </div>
                    <div class="mb-3">
                        <label for="messageContent" class="form-label">Nội dung</label>
                        <textarea class="form-control" id="messageContent" rows="5"
                                  placeholder="Nhập nội dung tin nhắn..." required></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-primary" onclick="sendMessage()">
                    <i class="fas fa-paper-plane me-2"></i>Gửi tin nhắn
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Include Footer -->
<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>

<script>
    $(document).ready(function() {
        // Auto-save video progress
        setupVideoProgress();

        // Setup auto-save for notes
        setupNotesAutoSave();
    });

    /**
     * Di chuyển đến bài học
     */
    function goToLesson(lessonId) {
        window.location.href = '<c:url value="/student/courses/${course.id}/lessons/" />' + lessonId;
    }

    /**
     * Đánh dấu bài học hoàn thành
     */
    function markLessonComplete(lessonId) {
        $.ajax({
            url: '<c:url value="/student/lessons/" />' + lessonId + '/complete',
            method: 'POST',
            success: function() {
                showToast('Đã đánh dấu bài học hoàn thành', 'success');
                // Reload page để cập nhật UI
                setTimeout(() => location.reload(), 1000);
            },
            error: function() {
                showToast('Có lỗi xảy ra khi đánh dấu hoàn thành', 'error');
            }
        });
    }

    /**
     * Lưu ghi chú
     */
    function saveNotes() {
        const notes = $('#lessonNotes').val();
        const lessonId = ${currentLesson.id};

        $.ajax({
            url: '<c:url value="/student/lessons/" />' + lessonId + '/notes',
            method: 'POST',
            data: { notes: notes },
            success: function() {
                showToast('Đã lưu ghi chú', 'success');
                $('#notesModal').modal('hide');
            },
            error: function() {
                showToast('Có lỗi xảy ra khi lưu ghi chú', 'error');
            }
        });
    }

    /**
     * Gửi tin nhắn cho giảng viên
     */
    function sendMessage() {
        const subject = $('#messageSubject').val();
        const content = $('#messageContent').val();

        if (!subject.trim() || !content.trim()) {
            showToast('Vui lòng nhập đầy đủ thông tin', 'error');
            return;
        }

        $.ajax({
            url: '<c:url value="/student/courses/${course.id}/message" />',
            method: 'POST',
            data: {
                subject: subject,
                content: content
            },
            success: function() {
                showToast('Đã gửi tin nhắn thành công', 'success');
                $('#messageInstructorModal').modal('hide');
                $('#messageForm')[0].reset();
            },
            error: function() {
                showToast('Có lỗi xảy ra khi gửi tin nhắn', 'error');
            }
        });
    }

    /**
     * Submit thảo luận
     */
    function submitDiscussion(event) {
        event.preventDefault();

        const content = $('#discussionContent').val();
        const anonymous = $('#anonymousPost').is(':checked');

        if (!content.trim()) {
            showToast('Vui lòng nhập nội dung thảo luận', 'error');
            return;
        }

        $.ajax({
            url: '<c:url value="/student/courses/${course.id}/discussions" />',
            method: 'POST',
            data: {
                content: content,
                anonymous: anonymous
            },
            success: function() {
                showToast('Đã đăng thảo luận thành công', 'success');
                $('#discussionForm')[0].reset();
                // Reload discussion list
                setTimeout(() => location.reload(), 1000);
            },
            error: function() {
                showToast('Có lỗi xảy ra khi đăng thảo luận', 'error');
            }
        });
    }

    /**
     * Toggle reply form
     */
    function toggleReply(discussionId) {
        const replyForm = $('#replyForm-' + discussionId);
        replyForm.toggle();
        if (replyForm.is(':visible')) {
            replyForm.find('input').focus();
        }
    }

    /**
     * Submit reply
     */
    function submitReply(event, discussionId) {
        event.preventDefault();

        const content = $(event.target).find('input').val();

        if (!content.trim()) {
            showToast('Vui lòng nhập nội dung trả lời', 'error');
            return;
        }

        $.ajax({
            url: '<c:url value="/student/discussions/" />' + discussionId + '/reply',
            method: 'POST',
            data: { content: content },
            success: function() {
                showToast('Đã trả lời thành công', 'success');
                setTimeout(() => location.reload(), 1000);
            },
            error: function() {
                showToast('Có lỗi xảy ra khi trả lời', 'error');
            }
        });
    }

    /**
     * Like discussion
     */
    function likeDiscussion(discussionId) {
        $.ajax({
            url: '<c:url value="/student/discussions/" />' + discussionId + '/like',
            method: 'POST',
            success: function(data) {
                $('#likes-' + discussionId).text(data.likeCount);
            },
            error: function() {
                showToast('Có lỗi xảy ra', 'error');
            }
        });
    }

    /**
     * Setup video progress tracking
     */
    function setupVideoProgress() {
        const video = document.querySelector('.video-player');
        if (video) {
            let lastSavedTime = 0;

            video.addEventListener('timeupdate', function() {
                const currentTime = Math.floor(video.currentTime);

                // Save progress every 30 seconds
                if (currentTime - lastSavedTime >= 30) {
                    saveVideoProgress(currentTime);
                    lastSavedTime = currentTime;
                }
            });

            // Save progress when video ends
            video.addEventListener('ended', function() {
                markLessonComplete(${currentLesson.id});
            });
        }
    }

    /**
     * Save video progress
     */
    function saveVideoProgress(currentTime) {
        $.ajax({
            url: '<c:url value="/student/lessons/${currentLesson.id}/progress" />',
            method: 'POST',
            data: { currentTime: currentTime },
            silent: true // Don't show error messages for background saves
        });
    }

    /**
     * Setup auto-save for notes
     */
    function setupNotesAutoSave() {
        let notesTimeout;

        $('#lessonNotes').on('input', function() {
            clearTimeout(notesTimeout);
            notesTimeout = setTimeout(() => {
                const notes = $(this).val();
                if (notes.trim()) {
                    // Auto-save notes after 2 seconds of inactivity
                    $.ajax({
                        url: '<c:url value="/student/lessons/${currentLesson.id}/notes" />',
                        method: 'POST',
                        data: { notes: notes },
                        silent: true
                    });
                }
            }, 2000);
        });
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