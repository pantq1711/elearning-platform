<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
                                <c:choose>
                                    <c:when test="${not empty course.imageUrl}">
                                        <img src="${pageContext.request.contextPath}/images/courses/${course.imageUrl}"
                                             alt="${course.name}"
                                             class="course-thumbnail"
                                             style="width: 60px; height: 45px; object-fit: cover; border-radius: 6px;"
                                             onerror="this.src='${pageContext.request.contextPath}/images/course-default.png'">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="course-thumbnail d-flex align-items-center justify-content-center bg-primary text-white"
                                             style="width: 60px; height: 45px; border-radius: 6px;">
                                            <i class="fas fa-book"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
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
                           action="${lesson.id != null ?
                                    pageContext.request.contextPath.concat('/instructor/lessons/').concat(lesson.id).concat('/edit') :
                                    pageContext.request.contextPath.concat('/instructor/lessons/new')}"
                           id="lessonForm">

                    <!-- CSRF Token -->
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <!-- Course ID hidden field -->
                    <form:hidden path="course.id" value="${course.id}"/>

                    <div class="row">
                        <!-- Left Column - Content -->
                        <div class="col-lg-8">

                            <!-- Basic Information -->
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">
                                        <i class="fas fa-info-circle me-2"></i>Thông Tin Cơ Bản
                                    </h6>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <!-- Tiêu đề bài học -->
                                        <div class="col-12 mb-3">
                                            <label for="title" class="form-label">
                                                Tiêu đề bài học <span class="text-danger">*</span>
                                            </label>
                                            <form:input path="title" cssClass="form-control"
                                                        placeholder="Nhập tên bài học..." required="true" />
                                            <form:errors path="title" cssClass="text-danger small" />
                                        </div>

                                        <!-- Thời lượng ước tính - FIX: duration → estimatedDuration -->
                                        <div class="col-md-6 mb-3">
                                            <label for="estimatedDuration" class="form-label">
                                                Thời lượng ước tính (phút)
                                            </label>
                                            <div class="input-group">
                                                <form:input path="estimatedDuration" type="number" cssClass="form-control"
                                                            min="0" step="1" placeholder="0" />
                                                <span class="input-group-text">phút</span>
                                            </div>
                                            <form:errors path="estimatedDuration" cssClass="text-danger small" />
                                        </div>

                                        <!-- Thứ tự - FIX: orderNumber → orderIndex -->
                                        <div class="col-md-6 mb-3">
                                            <label for="orderIndex" class="form-label">
                                                Thứ tự trong khóa học <span class="text-danger">*</span>
                                            </label>
                                            <form:input path="orderIndex" type="number" cssClass="form-control"
                                                        min="1" step="1" placeholder="1" required="true"/>
                                            <form:errors path="orderIndex" cssClass="text-danger small" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Lesson Type Selection -->
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">
                                        <i class="fas fa-layer-group me-2"></i>Loại Bài Học
                                    </h6>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <!-- Video Type -->
                                        <div class="col-md-4 mb-3">
                                            <div class="card lesson-type-card h-100" onclick="selectLessonType('VIDEO')">
                                                <div class="card-body text-center">
                                                    <i class="fas fa-play-circle fa-3x text-primary mb-3"></i>
                                                    <h6 class="card-title">Video</h6>
                                                    <p class="card-text small">Bài học với video hướng dẫn</p>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Document Type -->
                                        <div class="col-md-4 mb-3">
                                            <div class="card lesson-type-card h-100" onclick="selectLessonType('DOCUMENT')">
                                                <div class="card-body text-center">
                                                    <i class="fas fa-file-alt fa-3x text-info mb-3"></i>
                                                    <h6 class="card-title">Tài Liệu</h6>
                                                    <p class="card-text small">Bài học với tài liệu PDF/Word</p>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Text Type -->
                                        <div class="col-md-4 mb-3">
                                            <div class="card lesson-type-card h-100" onclick="selectLessonType('TEXT')">
                                                <div class="card-body text-center">
                                                    <i class="fas fa-align-left fa-3x text-success mb-3"></i>
                                                    <h6 class="card-title">Văn Bản</h6>
                                                    <p class="card-text small">Bài học chỉ có nội dung văn bản</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

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
                                        <label for="videoLink" class="form-label">URL Video</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-link"></i>
                                            </span>
                                            <form:input path="videoLink" cssClass="form-control"
                                                        placeholder="https://youtube.com/watch?v=... hoặc link video khác" />
                                        </div>
                                        <form:errors path="videoLink" cssClass="text-danger small" />
                                        <div class="form-text">
                                            Hỗ trợ YouTube, Vimeo, và các link video trực tiếp
                                        </div>
                                    </div>

                                    <!-- Video Upload (Optional) -->
                                    <div class="mb-3">
                                        <label class="form-label">Hoặc tải lên video</label>
                                        <div class="file-upload-area" id="videoUploadArea">
                                            <i class="fas fa-cloud-upload-alt fa-3x text-muted mb-3"></i>
                                            <h6>Kéo thả video vào đây</h6>
                                            <p class="text-muted mb-2">hoặc <span class="text-primary">chọn file</span></p>
                                            <small class="text-muted">
                                                Định dạng: MP4, AVI, MOV. Tối đa 100MB
                                            </small>
                                        </div>
                                        <input type="file" id="videoFile" name="videoFile"
                                               accept="video/*" style="display: none;">
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
                                        <label class="form-label">Tải lên tài liệu</label>
                                        <div class="file-upload-area" id="documentUploadArea">
                                            <i class="fas fa-file-upload fa-3x text-muted mb-3"></i>
                                            <h6>Kéo thả tài liệu vào đây</h6>
                                            <p class="text-muted mb-2">hoặc <span class="text-primary">chọn file</span></p>
                                            <small class="text-muted">
                                                Định dạng: PDF, DOC, DOCX, PPT, PPTX. Tối đa 50MB
                                            </small>
                                        </div>
                                        <input type="file" id="documentFile" name="documentFile"
                                               accept=".pdf,.doc,.docx,.ppt,.pptx" style="display: none;">
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

                            <!-- Text Content - FIX: Không dùng description, dùng content -->
                            <div class="card mb-4" id="textContent">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-align-left me-2"></i>Nội Dung Bài Học
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <form:textarea path="content" cssClass="form-control content-editor"
                                                   id="contentEditor" rows="15"
                                                   placeholder="Nhập nội dung chi tiết của bài học..."
                                                   required="true"/>
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

                                    <!-- Cho phép xem trước - FIX: freePreview → preview -->
                                    <div class="mb-3">
                                        <div class="form-check form-switch">
                                            <form:checkbox path="preview" cssClass="form-check-input" />
                                            <label class="form-check-label" for="preview">
                                                Cho phép xem trước miễn phí
                                            </label>
                                        </div>
                                        <small class="text-muted">
                                            Người dùng chưa đăng ký có thể xem trước bài học này
                                        </small>
                                    </div>

                                    <!-- Ghi chú: Xóa bỏ property "required" vì không tồn tại -->
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="card">
                                <div class="card-body">
                                    <div class="d-grid gap-2">
                                        <!-- Save Button -->
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-2"></i>
                                                ${lesson.id != null ? 'Cập Nhật' : 'Tạo'} Bài Học
                                        </button>

                                        <!-- Preview Button -->
                                        <c:if test="${lesson.id != null}">
                                            <a href="${pageContext.request.contextPath}/lessons/${lesson.slug}"
                                               class="btn btn-outline-info" target="_blank">
                                                <i class="fas fa-eye me-2"></i>Xem Trước
                                            </a>
                                        </c:if>

                                        <!-- Cancel Button -->
                                        <a href="${pageContext.request.contextPath}/instructor/lessons?courseId=${course.id}"
                                           class="btn btn-outline-secondary">
                                            <i class="fas fa-arrow-left me-2"></i>Quay Lại
                                        </a>

                                        <!-- Delete Button (chỉ khi edit) -->
                                        <c:if test="${lesson.id != null}">
                                            <button type="button" class="btn btn-outline-danger"
                                                    onclick="confirmDelete('${lesson.id}')">
                                                <i class="fas fa-trash me-2"></i>Xóa Bài Học
                                            </button>
                                        </c:if>
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
        const currentType = '${lesson.typeString}' || 'TEXT';
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
        $('[onclick="selectLessonType(\'' + type + '\')"]').addClass('active');

        // Ẩn tất cả content sections
        $('#videoContent, #documentContent, #textContent').hide();

        // Hiện section tương ứng
        if (type === 'VIDEO') {
            $('#videoContent, #textContent').show();
        } else if (type === 'DOCUMENT') {
            $('#documentContent, #textContent').show();
        } else {
            $('#textContent').show();
        }
    }

    /**
     * Setup file upload functionality
     */
    function setupFileUpload(uploadAreaId, fileInputId, handleFunction) {
        const uploadArea = document.getElementById(uploadAreaId);
        const fileInput = document.getElementById(fileInputId);

        uploadArea.addEventListener('click', () => fileInput.click());

        uploadArea.addEventListener('dragover', (e) => {
            e.preventDefault();
            uploadArea.classList.add('dragover');
        });

        uploadArea.addEventListener('dragleave', () => {
            uploadArea.classList.remove('dragover');
        });

        uploadArea.addEventListener('drop', (e) => {
            e.preventDefault();
            uploadArea.classList.remove('dragover');
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                fileInput.files = files;
                handleFunction(files[0]);
            }
        });

        fileInput.addEventListener('change', (e) => {
            if (e.target.files.length > 0) {
                handleFunction(e.target.files[0]);
            }
        });
    }

    /**
     * Handle video file selection
     */
    function handleVideoFile(file) {
        console.log('Video file selected:', file.name);
        // TODO: Implement video file handling
    }

    /**
     * Handle document file selection
     */
    function handleDocumentFile(file) {
        console.log('Document file selected:', file.name);
        // TODO: Implement document file handling
    }

    /**
     * Setup form validation
     */
    function setupFormValidation() {
        $('#lessonForm').on('submit', function(e) {
            let isValid = true;

            // Validate title
            const title = $('#title').val().trim();
            if (title.length < 5) {
                isValid = false;
                $('#title').addClass('is-invalid');
            } else {
                $('#title').removeClass('is-invalid');
            }

            // Validate content
            const content = tinymce.get('contentEditor').getContent();
            if (content.length < 20) {
                isValid = false;
                alert('Nội dung bài học phải có ít nhất 20 ký tự');
            }

            if (!isValid) {
                e.preventDefault();
            }
        });
    }

    /**
     * Confirm delete lesson
     */
    function confirmDelete(lessonId) {
        if (confirm('Bạn có chắc chắn muốn xóa bài học này? Hành động này không thể hoàn tác.')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/instructor/lessons/' + lessonId + '/delete';

            const csrfToken = document.createElement('input');
            csrfToken.type = 'hidden';
            csrfToken.name = '${_csrf.parameterName}';
            csrfToken.value = '${_csrf.token}';

            form.appendChild(csrfToken);
            document.body.appendChild(form);
            form.submit();
        }
    }
</script>
</body>
</html>