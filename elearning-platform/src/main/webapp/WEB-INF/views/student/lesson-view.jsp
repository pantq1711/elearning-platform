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
    <title>${lesson.title} - ${course.name} - EduLearn Platform</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Plyr CSS for video player -->
    <link rel="stylesheet" href="https://cdn.plyr.io/3.7.8/plyr.css" />
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/student.css" rel="stylesheet">
    <style>
        .lesson-container {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .video-container {
            position: relative;
            background: #000;
            aspect-ratio: 16/9;
        }

        .lesson-content {
            padding: 2rem;
            line-height: 1.8;
        }

        .lesson-content h1, .lesson-content h2, .lesson-content h3 {
            margin-top: 2rem;
            margin-bottom: 1rem;
            color: #2c3e50;
        }

        .lesson-content p {
            margin-bottom: 1.2rem;
        }

        .lesson-content pre {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 1rem;
            overflow-x: auto;
        }

        .lesson-content blockquote {
            border-left: 4px solid #0d6efd;
            background: #f8f9fa;
            padding: 1rem 1.5rem;
            margin: 1.5rem 0;
            font-style: italic;
        }

        .lesson-sidebar {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 1.5rem;
            position: sticky;
            top: 90px;
            max-height: calc(100vh - 110px);
            overflow-y: auto;
        }

        .notes-section {
            background: #fff;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }

        .notes-textarea {
            border: none;
            resize: vertical;
            min-height: 100px;
        }

        .notes-textarea:focus {
            outline: none;
            box-shadow: none;
        }

        .lesson-navigation {
            background: #f8f9fa;
            border-top: 1px solid #dee2e6;
            padding: 1.5rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .completion-badge {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-size: 0.875rem;
            font-weight: 600;
        }

        .lesson-meta {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }

        .bookmark-btn {
            position: absolute;
            top: 1rem;
            right: 1rem;
            z-index: 10;
            background: rgba(255,255,255,0.9);
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            transition: all 0.3s ease;
        }

        .bookmark-btn:hover {
            background: rgba(255,255,255,1);
            transform: scale(1.1);
        }

        .bookmark-btn.bookmarked {
            background: #ffc107;
            color: white;
        }

        .speed-controls {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }

        .speed-btn {
            padding: 0.25rem 0.5rem;
            border: 1px solid #dee2e6;
            background: white;
            border-radius: 4px;
            font-size: 0.75rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .speed-btn.active {
            background: #0d6efd;
            color: white;
            border-color: #0d6efd;
        }

        .progress-indicator {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: rgba(13, 110, 253, 0.2);
            z-index: 1000;
        }

        .progress-bar-reading {
            height: 100%;
            background: linear-gradient(90deg, #0d6efd 0%, #20c997 100%);
            transition: width 0.3s ease;
        }

        .floating-actions {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            z-index: 999;
        }

        .floating-btn {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            border: none;
            color: white;
            font-size: 1.2rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .floating-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(0,0,0,0.3);
        }

        .transcript-container {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 1.5rem;
            margin-top: 1.5rem;
            max-height: 400px;
            overflow-y: auto;
        }

        .transcript-item {
            padding: 0.5rem;
            margin-bottom: 0.25rem;
            cursor: pointer;
            border-radius: 4px;
            transition: background 0.3s ease;
        }

        .transcript-item:hover {
            background: rgba(13, 110, 253, 0.1);
        }

        .transcript-time {
            color: #0d6efd;
            font-weight: 600;
            margin-right: 0.5rem;
        }
    </style>
</head>

<body>
<!-- Reading Progress Indicator -->
<div class="progress-indicator">
    <div class="progress-bar-reading" id="readingProgress"></div>
</div>

<!-- Include Header -->
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container-fluid py-4">
    <div class="row">
        <!-- Main Content -->
        <div class="col-lg-8">
            <!-- Lesson Container -->
            <div class="lesson-container">

                <!-- Bookmark Button -->
                <button class="bookmark-btn ${lesson.bookmarked ? 'bookmarked' : ''}"
                        onclick="toggleBookmark()" title="Đánh dấu bài học">
                    <i class="fas fa-bookmark"></i>
                </button>

                <!-- Video Content -->
                <c:if test="${lesson.type == 'VIDEO'}">
                    <div class="video-container">
                        <video id="player" playsinline controls
                               data-poster="${lesson.thumbnailUrl}">
                            <source src="${lesson.videoUrl}" type="video/mp4" />
                            <track kind="captions" label="Tiếng Việt" src="${lesson.captionsUrl}" srclang="vi" default />
                        </video>
                    </div>
                </c:if>

                <!-- Document Content -->
                <c:if test="${lesson.type == 'DOCUMENT'}">
                    <div class="document-container">
                        <c:choose>
                            <c:when test="${fn:endsWith(lesson.documentUrl, '.pdf')}">
                                <iframe src="${lesson.documentUrl}"
                                        width="100%" height="600px"
                                        style="border: none;">
                                </iframe>
                            </c:when>
                            <c:otherwise>
                                <div class="p-4 text-center">
                                    <i class="fas fa-file-alt fa-3x text-muted mb-3"></i>
                                    <h5>Tài liệu đính kèm</h5>
                                    <p class="text-muted">${lesson.title}</p>
                                    <a href="${lesson.documentUrl}" class="btn btn-primary" download>
                                        <i class="fas fa-download me-2"></i>Tải xuống
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>

                <!-- Lesson Header -->
                <div class="p-4 border-bottom">
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="flex-grow-1">
                            <h1 class="h3 mb-2">${lesson.title}</h1>
                            <p class="text-muted mb-3">${lesson.description}</p>

                            <!-- Lesson Meta Info -->
                            <div class="lesson-meta">
                                <div class="row">
                                    <div class="col-md-3 col-6 mb-2">
                                        <div class="d-flex align-items-center">
                                            <i class="fas fa-clock text-primary me-2"></i>
                                            <div>
                                                <div class="fw-medium">
                                                    <c:choose>
                                                        <c:when test="${lesson.duration > 0}">
                                                            <fmt:formatNumber value="${lesson.duration / 60}" maxFractionDigits="0" /> phút
                                                        </c:when>
                                                        <c:otherwise>Không giới hạn</c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <small class="text-muted">Thời lượng</small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3 col-6 mb-2">
                                        <div class="d-flex align-items-center">
                                            <i class="fas fa-layer-group text-info me-2"></i>
                                            <div>
                                                <div class="fw-medium">
                                                    <c:choose>
                                                        <c:when test="${lesson.type == 'VIDEO'}">Video</c:when>
                                                        <c:when test="${lesson.type == 'DOCUMENT'}">Tài liệu</c:when>
                                                        <c:when test="${lesson.type == 'TEXT'}">Văn bản</c:when>
                                                        <c:otherwise>Khác</c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <small class="text-muted">Loại nội dung</small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3 col-6 mb-2">
                                        <div class="d-flex align-items-center">
                                            <i class="fas fa-signal text-warning me-2"></i>
                                            <div>
                                                <div class="fw-medium">
                                                    <c:choose>
                                                        <c:when test="${lesson.difficultyLevel == 'EASY'}">Dễ</c:when>
                                                        <c:when test="${lesson.difficultyLevel == 'MEDIUM'}">Trung bình</c:when>
                                                        <c:when test="${lesson.difficultyLevel == 'HARD'}">Khó</c:when>
                                                        <c:otherwise>Không xác định</c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <small class="text-muted">Độ khó</small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3 col-6 mb-2">
                                        <div class="d-flex align-items-center">
                                            <i class="fas fa-list-ol text-success me-2"></i>
                                            <div>
                                                <div class="fw-medium">Bài ${lesson.orderIndex}</div>
                                                <small class="text-muted">Thứ tự</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Completion Status -->
                        <div class="text-end">
                            <c:choose>
                                <c:when test="${lessonProgress.completed}">
                                    <div class="completion-badge">
                                        <i class="fas fa-check-circle me-2"></i>Đã hoàn thành
                                    </div>
                                    <div class="small text-muted mt-1">
                                        <fmt:formatDate value="${lessonProgress.completedAt}" pattern="dd/MM/yyyy HH:mm" />
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-success" onclick="markAsCompleted()">
                                        <i class="fas fa-check me-2"></i>Đánh dấu hoàn thành
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Text Content -->
                <c:if test="${lesson.type == 'TEXT' || not empty lesson.content}">
                    <div class="lesson-content">
                            ${lesson.content}
                    </div>
                </c:if>

                <!-- Video Transcript -->
                <c:if test="${lesson.type == 'VIDEO' && not empty lesson.transcript}">
                    <div class="transcript-container">
                        <h6 class="mb-3">
                            <i class="fas fa-closed-captioning me-2"></i>Bản ghi âm
                        </h6>
                        <div id="transcript">
                            <c:forEach items="${lesson.transcript}" var="item" varStatus="status">
                                <div class="transcript-item" onclick="seekTo(${item.startTime})">
                                    <span class="transcript-time">${item.timeFormatted}</span>
                                    <span>${item.text}</span>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>

                <!-- Lesson Navigation -->
                <div class="lesson-navigation">
                    <div>
                        <c:if test="${not empty previousLesson}">
                            <a href="${pageContext.request.contextPath}/student/lessons/${previousLesson.id}"
                               class="btn btn-outline-secondary">
                                <i class="fas fa-chevron-left me-2"></i>${previousLesson.title}
                            </a>
                        </c:if>
                    </div>

                    <div class="text-center">
                        <a href="${pageContext.request.contextPath}/student/courses/${course.id}"
                           class="btn btn-outline-primary">
                            <i class="fas fa-list me-2"></i>Danh sách bài học
                        </a>
                    </div>

                    <div class="text-end">
                        <c:if test="${not empty nextLesson}">
                            <a href="${pageContext.request.contextPath}/student/lessons/${nextLesson.id}"
                               class="btn btn-primary">
                                    ${nextLesson.title}<i class="fas fa-chevron-right ms-2"></i>
                            </a>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sidebar -->
        <div class="col-lg-4">
            <div class="lesson-sidebar">

                <!-- Video Controls (chỉ hiển thị khi có video) -->
                <c:if test="${lesson.type == 'VIDEO'}">
                    <div class="video-controls mb-4">
                        <h6 class="mb-3">
                            <i class="fas fa-play-circle me-2"></i>Điều khiển video
                        </h6>

                        <!-- Playback Speed -->
                        <div class="mb-3">
                            <label class="form-label small fw-medium">Tốc độ phát</label>
                            <div class="speed-controls">
                                <button class="speed-btn" data-speed="0.5">0.5x</button>
                                <button class="speed-btn" data-speed="0.75">0.75x</button>
                                <button class="speed-btn active" data-speed="1">1x</button>
                                <button class="speed-btn" data-speed="1.25">1.25x</button>
                                <button class="speed-btn" data-speed="1.5">1.5x</button>
                                <button class="speed-btn" data-speed="2">2x</button>
                            </div>
                        </div>

                        <!-- Video Progress -->
                        <div class="mb-3">
                            <label class="form-label small fw-medium">Tiến độ video</label>
                            <div class="progress mb-2" style="height: 8px;">
                                <div class="progress-bar bg-primary"
                                     id="videoProgress"
                                     style="width: ${lessonProgress.progressPercentage}%"></div>
                            </div>
                            <div class="d-flex justify-content-between small text-muted">
                                <span id="currentTime">
                                    <fmt:formatNumber value="${lessonProgress.currentTime / 60}" maxFractionDigits="1" />m
                                </span>
                                <span id="totalTime">
                                    <fmt:formatNumber value="${lesson.duration / 60}" maxFractionDigits="1" />m
                                </span>
                            </div>
                        </div>

                        <!-- Video Quality -->
                        <div class="mb-3">
                            <label class="form-label small fw-medium">Chất lượng</label>
                            <select class="form-select form-select-sm" id="qualitySelect">
                                <option value="auto">Tự động</option>
                                <option value="1080">1080p HD</option>
                                <option value="720">720p</option>
                                <option value="480">480p</option>
                                <option value="360">360p</option>
                            </select>
                        </div>
                    </div>
                </c:if>

                <!-- Personal Notes -->
                <div class="notes-section">
                    <h6 class="mb-3">
                        <i class="fas fa-sticky-note me-2"></i>Ghi chú cá nhân
                    </h6>
                    <textarea class="form-control notes-textarea"
                              id="personalNotes"
                              placeholder="Viết ghi chú của bạn về bài học này..."
                    >${lessonProgress.notes}</textarea>
                    <div class="mt-2 d-flex justify-content-between align-items-center">
                        <small class="text-muted" id="notesStatus">Tự động lưu</small>
                        <button class="btn btn-sm btn-outline-primary" onclick="saveNotes()">
                            <i class="fas fa-save me-1"></i>Lưu
                        </button>
                    </div>
                </div>

                <!-- Related Lessons -->
                <c:if test="${not empty relatedLessons}">
                    <div class="related-lessons mb-4">
                        <h6 class="mb-3">
                            <i class="fas fa-link me-2"></i>Bài học liên quan
                        </h6>
                        <c:forEach items="${relatedLessons}" var="relatedLesson" varStatus="status">
                            <div class="related-lesson-item mb-2">
                                <a href="${pageContext.request.contextPath}/student/lessons/${relatedLesson.id}"
                                   class="text-decoration-none">
                                    <div class="d-flex align-items-center p-2 border rounded hover-bg-light">
                                        <div class="me-2">
                                            <i class="fas fa-${relatedLesson.type == 'VIDEO' ? 'play-circle text-primary' :
                                                              relatedLesson.type == 'DOCUMENT' ? 'file-alt text-info' :
                                                              'align-left text-success'}"></i>
                                        </div>
                                        <div class="flex-grow-1">
                                            <div class="fw-medium small">${relatedLesson.title}</div>
                                            <div class="text-muted small">
                                                <c:if test="${relatedLesson.duration > 0}">
                                                    <fmt:formatNumber value="${relatedLesson.duration / 60}" maxFractionDigits="0" />p
                                                </c:if>
                                            </div>
                                        </div>
                                        <c:if test="${relatedLesson.completed}">
                                            <i class="fas fa-check-circle text-success"></i>
                                        </c:if>
                                    </div>
                                </a>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>

                <!-- Course Info -->
                <div class="course-info">
                    <h6 class="mb-3">
                        <i class="fas fa-book me-2"></i>Thông tin khóa học
                    </h6>
                    <div class="d-flex align-items-center mb-3">
                        <img src="${pageContext.request.contextPath}/images/courses/${course.imageUrl}"
                             alt="${course.name}"
                             class="me-3"
                             style="width: 60px; height: 45px; object-fit: cover; border-radius: 8px;"
                             onerror="this.src='/images/course-default.png'">
                        <div>
                            <div class="fw-medium">${course.name}</div>
                            <small class="text-muted">bởi ${course.instructor.fullName}</small>
                        </div>
                    </div>

                    <!-- Course Progress -->
                    <div class="mb-3">
                        <div class="d-flex justify-content-between mb-1">
                            <small class="text-muted">Tiến độ khóa học</small>
                            <small class="fw-medium">
                                <fmt:formatNumber value="${courseProgress.percentage}" maxFractionDigits="0" />%
                            </small>
                        </div>
                        <div class="progress" style="height: 6px;">
                            <div class="progress-bar bg-success"
                                 style="width: ${courseProgress.percentage}%"></div>
                        </div>
                        <small class="text-muted">
                            ${courseProgress.completedLessons} / ${courseProgress.totalLessons} bài học
                        </small>
                    </div>

                    <!-- Quick Actions -->
                    <div class="d-grid gap-2">
                        <a href="${pageContext.request.contextPath}/student/courses/${course.id}"
                           class="btn btn-outline-primary btn-sm">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại khóa học
                        </a>
                        <button class="btn btn-outline-secondary btn-sm"
                                data-bs-toggle="modal" data-bs-target="#reportModal">
                            <i class="fas fa-flag me-2"></i>Báo cáo vấn đề
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Floating Action Buttons -->
<div class="floating-actions">
    <button class="floating-btn bg-primary" onclick="scrollToTop()" title="Lên đầu trang">
        <i class="fas fa-arrow-up"></i>
    </button>
    <button class="floating-btn bg-info" onclick="toggleFullscreen()" title="Toàn màn hình">
        <i class="fas fa-expand"></i>
    </button>
    <button class="floating-btn bg-success" onclick="shareLesson()" title="Chia sẻ">
        <i class="fas fa-share"></i>
    </button>
</div>

<!-- Report Modal -->
<div class="modal fade" id="reportModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-flag me-2"></i>Báo cáo vấn đề
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="reportForm">
                    <div class="mb-3">
                        <label for="reportType" class="form-label">Loại vấn đề</label>
                        <select class="form-select" id="reportType" required>
                            <option value="">Chọn loại vấn đề...</option>
                            <option value="content_error">Lỗi nội dung</option>
                            <option value="technical_issue">Lỗi kỹ thuật</option>
                            <option value="audio_video">Lỗi âm thanh/video</option>
                            <option value="inappropriate">Nội dung không phù hợp</option>
                            <option value="other">Khác</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="reportDescription" class="form-label">Mô tả chi tiết</label>
                        <textarea class="form-control" id="reportDescription" rows="4"
                                  placeholder="Mô tả chi tiết vấn đề bạn gặp phải..." required></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-primary" onclick="submitReport()">
                    <i class="fas fa-paper-plane me-2"></i>Gửi báo cáo
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
<script src="https://cdn.plyr.io/3.7.8/plyr.polyfilled.js"></script>

<script>
    let player;
    let notesTimeout;
    let progressSaveInterval;

    $(document).ready(function() {
        // Khởi tạo video player nếu có
        <c:if test="${lesson.type == 'VIDEO'}">
        initializeVideoPlayer();
        </c:if>

        // Setup reading progress indicator
        setupReadingProgress();

        // Setup auto-save notes
        setupNotesAutoSave();

        // Setup keyboard shortcuts
        setupKeyboardShortcuts();

        // Load saved video position
        <c:if test="${lesson.type == 'VIDEO' && lessonProgress.currentTime > 0}">
        setTimeout(() => {
            if (player) {
                player.currentTime = ${lessonProgress.currentTime};
            }
        }, 1000);
        </c:if>
    });

    /**
     * Khởi tạo video player
     */
    function initializeVideoPlayer() {
        player = new Plyr('#player', {
            controls: [
                'play-large', 'restart', 'rewind', 'play', 'fast-forward',
                'progress', 'current-time', 'duration', 'mute', 'volume',
                'captions', 'settings', 'pip', 'airplay', 'fullscreen'
            ],
            settings: ['captions', 'quality', 'speed'],
            captions: { active: true, update: true },
            keyboard: { focused: true, global: true }
        });

        // Video events
        player.on('ready', function() {
            console.log('Video player ready');
            setupVideoControls();
        });

        player.on('timeupdate', function() {
            updateVideoProgress();
            saveProgressPeriodically();
        });

        player.on('ended', function() {
            markAsCompleted();
        });

        player.on('play', function() {
            console.log('Video playing');
        });

        player.on('pause', function() {
            saveVideoProgress();
        });
    }

    /**
     * Setup video controls
     */
    function setupVideoControls() {
        // Speed controls
        $('.speed-btn').click(function() {
            const speed = parseFloat($(this).data('speed'));
            player.speed = speed;
            $('.speed-btn').removeClass('active');
            $(this).addClass('active');
        });

        // Quality controls
        $('#qualitySelect').change(function() {
            const quality = $(this).val();
            if (quality !== 'auto') {
                player.quality = parseInt(quality);
            }
        });
    }

    /**
     * Cập nhật tiến độ video
     */
    function updateVideoProgress() {
        if (!player) return;

        const currentTime = player.currentTime;
        const duration = player.duration;
        const percentage = (currentTime / duration) * 100;

        $('#videoProgress').css('width', percentage + '%');
        $('#currentTime').text(formatTime(currentTime));
        $('#totalTime').text(formatTime(duration));
    }

    /**
     * Lưu tiến độ video định kỳ
     */
    function saveProgressPeriodically() {
        if (!progressSaveInterval) {
            progressSaveInterval = setInterval(() => {
                if (player && player.currentTime > 0) {
                    saveVideoProgress();
                }
            }, 30000); // Lưu mỗi 30 giây
        }
    }

    /**
     * Lưu tiến độ video
     */
    function saveVideoProgress() {
        if (!player) return;

        const currentTime = Math.floor(player.currentTime);
        const duration = Math.floor(player.duration);
        const percentage = Math.floor((currentTime / duration) * 100);

        $.ajax({
            url: '<c:url value="/student/lessons/${lesson.id}/progress" />',
            method: 'POST',
            data: {
                currentTime: currentTime,
                percentage: percentage
            },
            silent: true // Không hiển thị lỗi cho background saves
        });
    }

    /**
     * Tìm đến thời điểm cụ thể trong video
     */
    function seekTo(seconds) {
        if (player) {
            player.currentTime = seconds;
            player.play();
        }
    }

    /**
     * Setup reading progress indicator
     */
    function setupReadingProgress() {
        $(window).scroll(function() {
            const scrollTop = $(window).scrollTop();
            const docHeight = $(document).height() - $(window).height();
            const scrollPercent = (scrollTop / docHeight) * 100;

            $('#readingProgress').css('width', scrollPercent + '%');
        });
    }

    /**
     * Setup auto-save notes
     */
    function setupNotesAutoSave() {
        $('#personalNotes').on('input', function() {
            $('#notesStatus').text('Đang lưu...');

            clearTimeout(notesTimeout);
            notesTimeout = setTimeout(() => {
                saveNotes(true); // Silent save
            }, 2000);
        });
    }

    /**
     * Lưu ghi chú
     */
    function saveNotes(silent = false) {
        const notes = $('#personalNotes').val();

        $.ajax({
            url: '<c:url value="/student/lessons/${lesson.id}/notes" />',
            method: 'POST',
            data: { notes: notes },
            success: function() {
                if (!silent) {
                    showToast('Đã lưu ghi chú', 'success');
                }
                $('#notesStatus').text('Đã lưu');
            },
            error: function() {
                if (!silent) {
                    showToast('Có lỗi xảy ra khi lưu ghi chú', 'error');
                }
                $('#notesStatus').text('Lỗi lưu');
            }
        });
    }

    /**
     * Đánh dấu bài học hoàn thành
     */
    function markAsCompleted() {
        $.ajax({
            url: '<c:url value="/student/lessons/${lesson.id}/complete" />',
            method: 'POST',
            success: function() {
                showToast('Đã đánh dấu bài học hoàn thành!', 'success');
                setTimeout(() => {
                    location.reload();
                }, 1500);
            },
            error: function() {
                showToast('Có lỗi xảy ra khi đánh dấu hoàn thành', 'error');
            }
        });
    }

    /**
     * Toggle bookmark
     */
    function toggleBookmark() {
        const isBookmarked = $('.bookmark-btn').hasClass('bookmarked');

        $.ajax({
            url: '<c:url value="/student/lessons/${lesson.id}/bookmark" />',
            method: 'POST',
            data: { bookmarked: !isBookmarked },
            success: function() {
                $('.bookmark-btn').toggleClass('bookmarked');
                const message = isBookmarked ? 'Đã bỏ đánh dấu' : 'Đã đánh dấu bài học';
                showToast(message, 'success');
            },
            error: function() {
                showToast('Có lỗi xảy ra', 'error');
            }
        });
    }

    /**
     * Submit report
     */
    function submitReport() {
        const type = $('#reportType').val();
        const description = $('#reportDescription').val();

        if (!type || !description.trim()) {
            showToast('Vui lòng điền đầy đủ thông tin', 'error');
            return;
        }

        $.ajax({
            url: '<c:url value="/student/lessons/${lesson.id}/report" />',
            method: 'POST',
            data: {
                type: type,
                description: description
            },
            success: function() {
                showToast('Đã gửi báo cáo thành công', 'success');
                $('#reportModal').modal('hide');
                $('#reportForm')[0].reset();
            },
            error: function() {
                showToast('Có lỗi xảy ra khi gửi báo cáo', 'error');
            }
        });
    }

    /**
     * Setup keyboard shortcuts
     */
    function setupKeyboardShortcuts() {
        $(document).keydown(function(e) {
            // Chỉ hoạt động khi không focus vào input/textarea
            if ($(e.target).is('input, textarea')) return;

            switch(e.key) {
                case ' ': // Space - play/pause
                    e.preventDefault();
                    if (player) {
                        player.togglePlay();
                    }
                    break;
                case 'ArrowLeft': // Left arrow - rewind 10s
                    e.preventDefault();
                    if (player) {
                        player.rewind(10);
                    }
                    break;
                case 'ArrowRight': // Right arrow - forward 10s
                    e.preventDefault();
                    if (player) {
                        player.forward(10);
                    }
                    break;
                case 'f': // F - fullscreen
                    if (player) {
                        player.fullscreen.toggle();
                    }
                    break;
                case 'm': // M - mute
                    if (player) {
                        player.muted = !player.muted;
                    }
                    break;
            }
        });
    }

    /**
     * Scroll to top
     */
    function scrollToTop() {
        $('html, body').animate({ scrollTop: 0 }, 500);
    }

    /**
     * Toggle fullscreen
     */
    function toggleFullscreen() {
        if (document.fullscreenElement) {
            document.exitFullscreen();
        } else {
            document.documentElement.requestFullscreen();
        }
    }

    /**
     * Share lesson
     */
    function shareLesson() {
        if (navigator.share) {
            navigator.share({
                title: '${lesson.title}',
                text: 'Bài học: ${lesson.title} - ${course.name}',
                url: window.location.href
            });
        } else {
            // Fallback - copy to clipboard
            navigator.clipboard.writeText(window.location.href);
            showToast('Đã sao chép link vào clipboard', 'success');
        }
    }

    /**
     * Format time (seconds to mm:ss)
     */
    function formatTime(seconds) {
        const mins = Math.floor(seconds / 60);
        const secs = Math.floor(seconds % 60);
        return mins + ':' + (secs < 10 ? '0' : '') + secs;
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

    // Cleanup khi rời khỏi trang
    $(window).on('beforeunload', function() {
        if (player) {
            saveVideoProgress();
        }
        if (progressSaveInterval) {
            clearInterval(progressSaveInterval);
        }
    });
</script>

</body>
</html>