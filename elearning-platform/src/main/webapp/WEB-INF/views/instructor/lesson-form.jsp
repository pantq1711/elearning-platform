<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${lesson.id != null ? 'Chỉnh sửa' : 'Tạo mới'} Bài Học - EduLearn Platform</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- TinyMCE CSS -->
    <link href="https://cdn.tiny.cloud/1/no-api-key/tinymce/6/tinymce.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/instructor.css" rel="stylesheet">
    <style>
        .video-preview {
            max-width: 100%;
            max-height: 300px;
            border-radius: 8px;
        }
        .file-upload-area {
            border: 2px dashed #dee2e6;
            border-radius: 8px;
            padding: 2rem;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .file-upload-area:hover {
            border-color: #0d6efd;
            background-color: #f8f9fa;
        }
        .file-upload-area.dragover {
            border-color: #0d6efd;
            background-color: #e7f3ff;
        }
        .lesson-type-card {
            border: 2px solid transparent;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .lesson-type-card:hover {
            border-color: #0d6efd;
            box-shadow: 0 4px 12px rgba(13, 110, 253, 0.15);
        }
        .lesson-type-card.active {
            border-color: #0d6efd;
            background-color: #e7f3ff;
        }
        .content-editor {
            min-height: 300px;
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
            <div class="main-content p-4">

                <!-- Page Header -->
                <div class="page-header mb-4">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/instructor/dashboard">
                                    <i class="fas fa-home"></i> Dashboard
                                </a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/instructor/courses">Khóa học</a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/instructor/lessons?courseId=${course.id}">Bài học</a>
                            </li>
                            <li class="breadcrumb-item active">
                                ${lesson.id != null ? 'Chỉnh sửa' : 'Tạo mới'}
                            </li>
                        </ol>
                    </nav>
                    <h1 class="h3 mb-0">
                        <i class="fas fa-${lesson.id != null ? 'edit' : 'plus-circle'} text-primary me-2"></i>
                        ${lesson.id != null ? 'Chỉnh Sửa' : 'Tạo Mới'} Bài Học
                    </h1>
                    <p class="text-muted mb-0">
                        ${lesson.id != null ? 'Cập nhật thông tin bài học' : 'Thêm bài học mới cho khóa học'}
                    </p>
                </div>

                <!-- Course Info -->
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="row align-items-center">
                            <div class="col-auto">
                                <img src="${pageContext.request.contextPath}/images/courses/${course.imageUrl}"
                                     alt="${course.name}"
                                     class="course-thumbnail"
                                     style="width: 60px; height: 45px; object-fit: cover; border-radius: 6px;"
                                     onerror="this.src='/images/course-default.png'">
                            </div>
                            <div class="col">
                                <h6 class="mb-1">${course.name}</h6>
                                <small class="text-muted">
                                    <i class="fas fa-layer-group me-1"></i>${course.category.name}
                                </small>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Thông báo lỗi -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Form Tạo/Sửa Bài Học -->
                <form:form method="POST" modelAttribute="lesson" enctype="multipart/form-data"
                           action="${lesson.id != null ? '/instructor/lessons/'.concat(lesson.id).concat('/edit') : '/instructor/lessons/create'}"
                           cssClass="needs-validation" novalidate="true">

                    <!-- Hidden fields -->
                    <form:hidden path="id" />
                    <input type="hidden" name="courseId" value="${course.id}" />

                    <div class="row">
                        <!-- Left Column - Main Content -->
                        <div class="col-lg-8">

                            <!-- Lesson Type Selection -->
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-layer-group me-2"></i>Loại Bài Học
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="row g-3">
                                        <div class="col-md-4">
                                            <div class="lesson-type-card card h-100 ${lesson.type == 'VIDEO' ? 'active' : ''}"
                                                 onclick="selectLessonType('VIDEO')">
                                                <div class="card-body text-center">
                                                    <i class="fas fa-play-circle fa-3x text-primary mb-3"></i>
                                                    <h6>Video</h6>
                                                    <p class="text-muted small mb-0">Bài học video trực tuyến</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="lesson-type-card card h-100 ${lesson.type == 'DOCUMENT' ? 'active' : ''}"
                                                 onclick="selectLessonType('DOCUMENT')">
                                                <div class="card-body text-center">
                                                    <i class="fas fa-file-alt fa-3x text-info mb-3"></i>
                                                    <h6>Tài liệu</h6>
                                                    <p class="text-muted small mb-0">Tài liệu văn bản, PDF</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="lesson-type-card card h-100 ${lesson.type == 'TEXT' ? 'active' : ''}"
                                                 onclick="selectLessonType('TEXT')">
                                                <div class="card-body text-center">
                                                    <i class="fas fa-align-left fa-3x text-success mb-3"></i>
                                                    <h6>Văn bản</h6>
                                                    <p class="text-muted small mb-0">Nội dung văn bản</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <form:hidden path="type" id="lessonType" />
                                </div>
                            </div>

                            <!-- Basic Information -->
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-info-circle me-2"></i>Thông Tin Cơ Bản
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="row g-3">
                                        <!-- Tên bài học -->
                                        <div class="col-12">
                                            <label for="title" class="form-label">
                                                Tên bài học <span class="text-danger">*</span>
                                            </label>
                                            <form:input path="title" cssClass="form-control"
                                                        placeholder="Nhập tên bài học..." required="true" />
                                            <form:errors path="title" cssClass="text-danger small" />
                                        </div>

                                        <!-- Mô tả ngắn -->
                                        <div class="col-12">
                                            <label for="description" class="form-label">Mô tả ngắn</label>
                                            <form:textarea path="description" cssClass="form-control" rows="3"
                                                           placeholder="Mô tả ngắn gọn về nội dung bài học..." />
                                            <form:errors path="description" cssClass="text-danger small" />
                                        </div>

                                        <!-- Thời lượng -->
                                        <div class="col-md-6">
                                            <label for="duration" class="form-label">
                                                Thời lượng (phút)
                                            </label>
                                            <div class="input-group">
                                                <form:input path="duration" type="number" cssClass="form-control"
                                                            min="0" step="1" placeholder="0" />
                                                <span class="input-group-text">phút</span>
                                            </div>
                                            <form:errors path="duration" cssClass="text-danger small" />
                                        </div>

                                        <!-- Thứ tự -->
                                        <div class="col-md-6">
                                            <label for="orderIndex" class="form-label">
                                                Thứ tự trong khóa học
                                            </label>
                                            <form:input path="orderIndex" type="number" cssClass="form-control"
                                                        min="1" step="1" placeholder="1" />
                                            <form:errors path="orderIndex" cssClass="text-danger small" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Content Based on Type -->

                            <!-- Video Content -->
                            <div class="card mb-4" id="videoContent" style="display: none;">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-video me-2"></i>Nội Dung Video
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <!-- Video URL -->
                                    <div class="mb-3">
                                        <label for="videoUrl" class="form-label">URL Video</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-link"></i>
                                            </span>
                                            <form:input path="videoUrl" cssClass="form-control"
                                                        placeholder="https://youtube.com/watch?v=... hoặc link video khác" />
                                        </div>
                                        <div class="form-text">
                                            Hỗ trợ YouTube, Vimeo hoặc link video trực tiếp
                                        </div>
                                        <form:errors path="videoUrl" cssClass="text-danger small" />
                                    </div>

                                    <!-- Video Upload -->
                                    <div class="mb-3">
                                        <label class="form-label">Hoặc upload video</label>
                                        <div class="file-upload-area" id="videoUploadArea">
                                            <i class="fas fa-cloud-upload-alt fa-3x text-muted mb-3"></i>
                                            <h6>Kéo thả video vào đây</h6>
                                            <p class="text-muted mb-2">hoặc nhấn để chọn file</p>
                                            <input type="file" name="videoFile" id="videoFile"
                                                   accept="video/*" style="display: none;">
                                            <small class="text-muted">
                                                Định dạng: MP4, AVI, MOV. Tối đa 500MB
                                            </small>
                                        </div>
                                        <div id="videoPreview" class="mt-3" style="display: none;">
                                            <video id="videoPreviewPlayer" class="video-preview" controls>
                                                <c:if test="${not empty lesson.videoUrl}">
                                                    <source src="${lesson.videoUrl}" type="video/mp4">
                                                </c:if>
                                            </video>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Document Content -->
                            <div class="card mb-4" id="documentContent" style="display: none;">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-file-alt me-2"></i>Tài Liệu
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <!-- Document Upload -->
                                    <div class="mb-3">
                                        <label class="form-label">Upload tài liệu</label>
                                        <div class="file-upload-area" id="documentUploadArea">
                                            <i class="fas fa-file-upload fa-3x text-muted mb-3"></i>
                                            <h6>Kéo thả tài liệu vào đây</h6>
                                            <p class="text-muted mb-2">hoặc nhấn để chọn file</p>
                                            <input type="file" name="documentFile" id="documentFile"
                                                   accept=".pdf,.doc,.docx,.ppt,.pptx,.xls,.xlsx" style="display: none;">
                                            <small class="text-muted">
                                                Định dạng: PDF, DOC, DOCX, PPT, PPTX, XLS, XLSX. Tối đa 50MB
                                            </small>
                                        </div>
                                    </div>

                                    <!-- Document URL -->
                                    <div class="mb-3">
                                        <label for="documentUrl" class="form-label">Hoặc URL tài liệu</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-link"></i>
                                            </span>
                                            <form:input path="documentUrl" cssClass="form-control"
                                                        placeholder="https://drive.google.com/... hoặc link tài liệu khác" />
                                        </div>
                                        <form:errors path="documentUrl" cssClass="text-danger small" />
                                    </div>
                                </div>
                            </div>

                            <!-- Text Content -->
                            <div class="card mb-4" id="textContent" style="display: none;">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-align-left me-2"></i>Nội Dung Văn Bản
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <form:textarea path="content" cssClass="form-control content-editor"
                                                   id="contentEditor" rows="15"
                                                   placeholder="Nhập nội dung bài học..." />
                                    <form:errors path="content" cssClass="text-danger small" />
                                </div>
                            </div>

                        </div>

                        <!-- Right Column - Settings -->
                        <div class="col-lg-4">

                            <!-- Publish Settings -->
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">
                                        <i class="fas fa-cog me-2"></i>Cài Đặt
                                    </h6>
                                </div>
                                <div class="card-body">
                                    <!-- Trạng thái hoạt động -->
                                    <div class="mb-3">
                                        <div class="form-check form-switch">
                                            <form:checkbox path="active" cssClass="form-check-input" />
                                            <label class="form-check-label" for="active">
                                                Kích hoạt bài học
                                            </label>
                                        </div>
                                        <small class="text-muted">
                                            Cho phép học viên truy cập bài học này
                                        </small>
                                    </div>

                                    <!-- Cho phép xem trước -->
                                    <div class="mb-3">
                                        <div class="form-check form-switch">
                                            <form:checkbox path="preview" cssClass="form-check-input" />
                                            <label class="form-check-label" for="preview">
                                                Cho phép xem trước
                                            </label>
                                        </div>
                                        <small class="text-muted">
                                            Người dùng chưa đăng ký có thể xem trước
                                        </small>
                                    </div>

                                    <!-- Yêu cầu hoàn thành -->
                                    <div class="mb-3">
                                        <div class="form-check form-switch">
                                            <form:checkbox path="required" cssClass="form-check-input" />
                                            <label class="form-check-label" for="required">
                                                Bắt buộc hoàn thành
                                            </label>
                                        </div>
                                        <small class="text-muted">
                                            Học viên phải hoàn thành bài này để tiếp tục
                                        </small>
                                    </div>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="card">
                                <div class="card-body">
                                    <div class="d-grid gap-2">
                                        <!-- Save Button -->
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-2"></i>
                                                ${lesson.id != null ? 'Cập nhật bài học' : 'Tạo bài học'}
                                        </button>

                                        <!-- Save & Add Another -->
                                        <c:if test="${lesson.id == null}">
                                            <button type="submit" name="saveAndAddAnother" value="true"
                                                    class="btn btn-outline-primary">
                                                <i class="fas fa-plus me-2"></i>
                                                Lưu và thêm bài học khác
                                            </button>
                                        </c:if>

                                        <!-- Preview Button -->
                                        <c:if test="${lesson.id != null}">
                                            <a href="${pageContext.request.contextPath}/instructor/lessons/${lesson.id}/preview""
                                               class="btn btn-outline-info" target="_blank">
                                                <i class="fas fa-eye me-2"></i>
                                                Xem trước
                                            </a>
                                        </c:if>

                                        <!-- Cancel Button -->
                                        <a href="${pageContext.request.contextPath}/instructor/lessons?courseId=${course.id}"
                                           class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-2"></i>
                                            Hủy
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <!-- Help Tips -->
                            <div class="card mt-4">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">
                                        <i class="fas fa-lightbulb me-2"></i>Gợi Ý
                                    </h6>
                                </div>
                                <div class="card-body">
                                    <div class="small text-muted">
                                        <div class="mb-2">
                                            <i class="fas fa-check-circle text-success me-1"></i>
                                            <strong>Tên bài học:</strong> Nên ngắn gọn, súc tích
                                        </div>
                                        <div class="mb-2">
                                            <i class="fas fa-check-circle text-success me-1"></i>
                                            <strong>Thời lượng:</strong> Giúp học viên lên kế hoạch học
                                        </div>
                                        <div class="mb-2">
                                            <i class="fas fa-check-circle text-success me-1"></i>
                                            <strong>Mô tả:</strong> Tóm tắt nội dung chính
                                        </div>
                                        <div>
                                            <i class="fas fa-check-circle text-success me-1"></i>
                                            <strong>Thứ tự:</strong> Sắp xếp logic từ dễ đến khó
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                </form:form>

            </div>
        </div>
    </div>
</div>

<!-- Include Footer -->
<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.tiny.cloud/1/no-api-key/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>

<script>
    $(document).ready(function() {
        // Khởi tạo TinyMCE cho content editor
        tinymce.init({
            selector: '#contentEditor',
            height: 400,
            menubar: false,
            plugins: [
                'advlist', 'autolink', 'lists', 'link', 'image', 'charmap', 'preview',
                'anchor', 'searchreplace', 'visualblocks', 'code', 'fullscreen',
                'insertdatetime', 'media', 'table', 'help', 'wordcount'
            ],
            toolbar: 'undo redo | blocks | bold italic backcolor | ' +
                'alignleft aligncenter alignright alignjustify | ' +
                'bullist numlist outdent indent | removeformat | help',
            content_style: 'body { font-family: Arial, sans-serif; font-size: 14px }',
            language: 'vi'
        });

        // Khởi tạo lesson type từ server
        const currentType = '${lesson.type}' || 'VIDEO';
        selectLessonType(currentType);

        // Setup file upload areas
        setupFileUpload('videoUploadArea', 'videoFile', handleVideoFile);
        setupFileUpload('documentUploadArea', 'documentFile', handleDocumentFile);

        // Form validation
        setupFormValidation();
    });

    /**
     * Chọn loại bài học
     */
    function selectLessonType(type) {
        // Cập nhật UI
        $('.lesson-type-card').removeClass('active');
        $(`.lesson-type-card:has(h6:contains('${type === 'VIDEO' ? 'Video' : type === 'DOCUMENT' ? 'Tài liệu' : 'Văn bản'}'))`).addClass('active');

        // Cập nhật hidden input
        $('#lessonType').val(type);

        // Hiển thị/ẩn content sections
        $('#videoContent, #documentContent, #textContent').hide();

        switch(type) {
            case 'VIDEO':
                $('#videoContent').show();
                break;
            case 'DOCUMENT':
                $('#documentContent').show();
                break;
            case 'TEXT':
                $('#textContent').show();
                break;
        }
    }

    /**
     * Setup file upload với drag & drop
     */
    function setupFileUpload(areaId, inputId, handler) {
        const area = document.getElementById(areaId);
        const input = document.getElementById(inputId);

        if (!area || !input) return;

        // Click to select
        area.addEventListener('click', () => input.click());

        // Drag & drop events
        area.addEventListener('dragover', (e) => {
            e.preventDefault();
            area.classList.add('dragover');
        });

        area.addEventListener('dragleave', () => {
            area.classList.remove('dragover');
        });

        area.addEventListener('drop', (e) => {
            e.preventDefault();
            area.classList.remove('dragover');

            const files = e.dataTransfer.files;
            if (files.length > 0) {
                input.files = files;
                handler(files[0]);
            }
        });

        // File input change
        input.addEventListener('change', (e) => {
            if (e.target.files.length > 0) {
                handler(e.target.files[0]);
            }
        });
    }

    /**
     * Xử lý file video được chọn
     */
    function handleVideoFile(file) {
        const preview = document.getElementById('videoPreview');
        const player = document.getElementById('videoPreviewPlayer');

        if (file.type.startsWith('video/')) {
            const url = URL.createObjectURL(file);
            player.src = url;
            preview.style.display = 'block';

            // Update upload area text
            document.querySelector('#videoUploadArea h6').textContent = file.name;
            document.querySelector('#videoUploadArea p').textContent = formatFileSize(file.size);
        } else {
            alert('Vui lòng chọn file video hợp lệ.');
        }
    }

    /**
     * Xử lý file document được chọn
     */
    function handleDocumentFile(file) {
        const allowedTypes = [
            'application/pdf',
            'application/msword',
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            'application/vnd.ms-powerpoint',
            'application/vnd.openxmlformats-officedocument.presentationml.presentation',
            'application/vnd.ms-excel',
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        ];

        if (allowedTypes.includes(file.type)) {
            // Update upload area text
            document.querySelector('#documentUploadArea h6').textContent = file.name;
            document.querySelector('#documentUploadArea p').textContent = formatFileSize(file.size);
            document.querySelector('#documentUploadArea i').className = 'fas fa-file-check fa-3x text-success mb-3';
        } else {
            alert('Vui lòng chọn file tài liệu hợp lệ (PDF, DOC, PPT, XLS).');
        }
    }

    /**
     * Format file size
     */
    function formatFileSize(bytes) {
        if (bytes === 0) return '0 Bytes';
        const k = 1024;
        const sizes = ['Bytes', 'KB', 'MB', 'GB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
    }

    /**
     * Setup form validation
     */
    function setupFormValidation() {
        const form = document.querySelector('.needs-validation');

        form.addEventListener('submit', function(event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }

            // Validation bổ sung
            const lessonType = $('#lessonType').val();
            let isValid = true;

            if (lessonType === 'VIDEO') {
                const videoUrl = $('input[name="videoUrl"]').val();
                const videoFile = document.getElementById('videoFile').files.length;
                if (!videoUrl && videoFile === 0) {
                    alert('Vui lòng nhập URL video hoặc upload file video.');
                    isValid = false;
                }
            } else if (lessonType === 'DOCUMENT') {
                const documentUrl = $('input[name="documentUrl"]').val();
                const documentFile = document.getElementById('documentFile').files.length;
                if (!documentUrl && documentFile === 0) {
                    alert('Vui lòng nhập URL tài liệu hoặc upload file tài liệu.');
                    isValid = false;
                }
            } else if (lessonType === 'TEXT') {
                const content = tinymce.get('contentEditor').getContent();
                if (!content.trim()) {
                    alert('Vui lòng nhập nội dung bài học.');
                    isValid = false;
                }
            }

            if (!isValid) {
                event.preventDefault();
                event.stopPropagation();
            }

            form.classList.add('was-validated');
        });
    }
</script>

</body>
</html>