<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? 'Chỉnh sửa' : 'Tạo mới'} bài giảng - ${course.name}</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- CKEditor for rich text editing -->
    <script src="https://cdn.ckeditor.com/ckeditor5/39.0.1/classic/ckeditor.js"></script>

    <style>
        /* Định nghĩa các biến màu sắc chính */
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --info-color: #17a2b8;
        }

        /* Thiết lập nền trang */
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
        }

        /* Navbar cho instructor */
        .navbar {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            box-shadow: 0 2px 20px rgba(0,0,0,0.1);
        }

        /* Container chính */
        .main-container {
            margin-top: 20px;
            margin-bottom: 40px;
        }

        /* Card chứa form */
        .form-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        /* Header của form */
        .form-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 2rem;
            text-align: center;
        }

        .form-header h2 {
            margin: 0;
            font-size: 1.8rem;
            font-weight: 700;
        }

        .form-header p {
            margin: 0.5rem 0 0;
            opacity: 0.9;
        }

        /* Body của form */
        .form-body {
            padding: 2.5rem;
        }

        /* Styling cho form controls */
        .form-floating {
            margin-bottom: 1.5rem;
        }

        .form-control {
            border: 2px solid #e9ecef;
            border-radius: 12px;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
            font-size: 1rem;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            transform: translateY(-2px);
        }

        .form-select {
            border: 2px solid #e9ecef;
            border-radius: 12px;
            transition: all 0.3s ease;
        }

        .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        /* Label styling */
        label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.5rem;
        }

        /* Checkbox và switch styling */
        .form-check {
            margin-bottom: 1.5rem;
        }

        .form-check-input:checked {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .form-check-label {
            font-weight: 500;
            margin-left: 0.5rem;
        }

        /* Error styling */
        .text-danger {
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }

        .is-invalid {
            border-color: var(--danger-color);
        }

        /* Button styling */
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            border: none;
            border-radius: 50px;
            padding: 12px 30px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }

        .btn-secondary {
            background: #6c757d;
            border: none;
            border-radius: 50px;
            padding: 12px 30px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-secondary:hover {
            transform: translateY(-2px);
            background: #5a6268;
        }

        /* Video preview */
        .video-preview {
            border: 2px dashed #dee2e6;
            border-radius: 12px;
            padding: 2rem;
            text-align: center;
            margin-top: 1rem;
            background: #f8f9fa;
        }

        .video-preview iframe {
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        /* Help text styling */
        .form-text {
            color: #6c757d;
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }

        /* Course info section */
        .course-info {
            background: #e7f3ff;
            border: 1px solid #b3d7ff;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .course-info h5 {
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        /* CKEditor custom styling */
        .ck-editor__editable {
            min-height: 300px;
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .form-body {
                padding: 1.5rem;
            }

            .form-header {
                padding: 1.5rem;
            }

            .form-header h2 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container">
        <a class="navbar-brand" href="/instructor/dashboard">
            <i class="fas fa-graduation-cap me-2"></i>
            Instructor Panel
        </a>
        <div class="navbar-nav ms-auto">
                <span class="navbar-text me-3">
                    Xin chào, <strong><sec:authentication property="principal.fullName" /></strong>
                </span>
            <a class="nav-link" href="/logout">
                <i class="fas fa-sign-out-alt"></i> Đăng xuất
            </a>
        </div>
    </div>
</nav>

<!-- Main Container -->
<div class="container main-container">
    <!-- Breadcrumb Navigation -->
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="/instructor/dashboard">
                    <i class="fas fa-home"></i> Dashboard
                </a>
            </li>
            <li class="breadcrumb-item">
                <a href="/instructor/courses">Khóa học</a>
            </li>
            <li class="breadcrumb-item">
                <a href="/instructor/courses/${course.id}/lessons">
                    ${course.name}
                </a>
            </li>
            <li class="breadcrumb-item active" aria-current="page">
                ${isEdit ? 'Chỉnh sửa' : 'Tạo mới'} bài giảng
            </li>
        </ol>
    </nav>

    <!-- Success/Error Messages -->
    <c:if test="${not empty message}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i>${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i>${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Main Form Card -->
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="form-card">
                <!-- Form Header -->
                <div class="form-header">
                    <h2>
                        <i class="fas fa-${isEdit ? 'edit' : 'plus-circle'} me-2"></i>
                        ${isEdit ? 'Chỉnh sửa' : 'Tạo mới'} bài giảng
                    </h2>
                    <p>Tạo nội dung học tập chất lượng cao cho học viên của bạn</p>
                </div>

                <!-- Form Body -->
                <div class="form-body">
                    <!-- Course Information -->
                    <div class="course-info">
                        <h5>
                            <i class="fas fa-book me-2"></i>Khóa học: ${course.name}
                        </h5>
                        <p class="mb-0">${course.description}</p>
                    </div>

                    <!-- Main Form -->
                    <form:form method="post"
                               action="${isEdit ? '/instructor/courses/' += course.id += '/lessons/' += lesson.id : '/instructor/courses/' += course.id += '/lessons'}"
                               modelAttribute="lesson"
                               class="needs-validation"
                               novalidate="true">

                        <!-- CSRF Token -->
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                        <!-- Hidden ID for edit mode -->
                        <c:if test="${isEdit}">
                            <form:hidden path="id"/>
                        </c:if>

                        <div class="row">
                            <!-- Left Column -->
                            <div class="col-lg-8">
                                <!-- Lesson Title -->
                                <div class="form-floating">
                                    <form:input path="title"
                                                class="form-control ${not empty errors.title ? 'is-invalid' : ''}"
                                                placeholder="Nhập tiêu đề bài giảng"
                                                required="true"/>
                                    <label for="title">
                                        <i class="fas fa-heading me-2"></i>Tiêu đề bài giảng *
                                    </label>
                                    <form:errors path="title" class="text-danger"/>
                                    <div class="form-text">
                                        Tiêu đề ngắn gọn, dễ hiểu và thu hút học viên
                                    </div>
                                </div>

                                <!-- Lesson Content -->
                                <div class="mb-3">
                                    <label for="content" class="form-label">
                                        <i class="fas fa-file-alt me-2"></i>Nội dung bài giảng *
                                    </label>
                                    <form:textarea path="content"
                                                   id="content-editor"
                                                   class="form-control ${not empty errors.content ? 'is-invalid' : ''}"
                                                   rows="10"
                                                   placeholder="Nhập nội dung chi tiết của bài giảng..."
                                                   required="true"/>
                                    <form:errors path="content" class="text-danger"/>
                                    <div class="form-text">
                                        Sử dụng editor để định dạng nội dung đẹp mắt với heading, list, link, v.v.
                                    </div>
                                </div>

                                <!-- Video Link -->
                                <div class="form-floating">
                                    <form:input path="videoLink"
                                                class="form-control"
                                                placeholder="https://www.youtube.com/watch?v=..."
                                                onchange="previewVideo(this.value)"/>
                                    <label for="videoLink">
                                        <i class="fas fa-video me-2"></i>Link video YouTube (tùy chọn)
                                    </label>
                                    <div class="form-text">
                                        Nhập URL video YouTube để bổ sung cho nội dung bài giảng
                                    </div>
                                </div>

                                <!-- Video Preview -->
                                <div id="video-preview" class="video-preview" style="display: none;">
                                    <h6><i class="fas fa-eye me-2"></i>Xem trước video:</h6>
                                    <div id="video-container"></div>
                                </div>
                            </div>

                            <!-- Right Column -->
                            <div class="col-lg-4">
                                <!-- Order Index -->
                                <div class="form-floating mb-3">
                                    <form:input path="orderIndex"
                                                type="number"
                                                class="form-control"
                                                min="1"
                                                placeholder="1"/>
                                    <label for="orderIndex">
                                        <i class="fas fa-sort-numeric-up me-2"></i>Thứ tự bài học
                                    </label>
                                    <div class="form-text">
                                        Số thứ tự hiển thị trong danh sách bài học
                                    </div>
                                </div>

                                <!-- Estimated Duration -->
                                <div class="form-floating mb-3">
                                    <form:input path="estimatedDuration"
                                                type="number"
                                                class="form-control"
                                                min="1"
                                                max="480"
                                                placeholder="30"/>
                                    <label for="estimatedDuration">
                                        <i class="fas fa-clock me-2"></i>Thời lượng ước tính (phút)
                                    </label>
                                    <div class="form-text">
                                        Thời gian dự kiến học viên hoàn thành bài học
                                    </div>
                                </div>

                                <!-- Preview Checkbox -->
                                <div class="form-check form-switch mb-3">
                                    <form:checkbox path="preview"
                                                   class="form-check-input"
                                                   id="preview"/>
                                    <label class="form-check-label" for="preview">
                                        <i class="fas fa-eye me-2"></i>Cho phép xem trước miễn phí
                                    </label>
                                    <div class="form-text">
                                        Học viên có thể xem bài này mà không cần đăng ký khóa học
                                    </div>
                                </div>

                                <!-- Active Checkbox -->
                                <div class="form-check form-switch mb-4">
                                    <form:checkbox path="active"
                                                   class="form-check-input"
                                                   id="active"/>
                                    <label class="form-check-label" for="active">
                                        <i class="fas fa-toggle-on me-2"></i>Kích hoạt bài học
                                    </label>
                                    <div class="form-text">
                                        Chỉ bài học được kích hoạt mới hiển thị cho học viên
                                    </div>
                                </div>

                                <!-- Action Buttons -->
                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-2"></i>
                                            ${isEdit ? 'Cập nhật' : 'Tạo mới'} bài giảng
                                    </button>

                                    <a href="/instructor/courses/${course.id}/lessons"
                                       class="btn btn-secondary">
                                        <i class="fas fa-arrow-left me-2"></i>
                                        Quay lại danh sách
                                    </a>
                                </div>
                            </div>
                        </div>
                    </form:form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Khởi tạo CKEditor cho phần nội dung
    ClassicEditor
        .create(document.querySelector('#content-editor'), {
            toolbar: [
                'heading', '|',
                'bold', 'italic', 'underline', '|',
                'bulletedList', 'numberedList', '|',
                'link', 'blockQuote', '|',
                'insertTable', '|',
                'undo', 'redo'
            ],
            heading: {
                options: [
                    { model: 'paragraph', title: 'Paragraph', class: 'ck-heading_paragraph' },
                    { model: 'heading1', view: 'h1', title: 'Heading 1', class: 'ck-heading_heading1' },
                    { model: 'heading2', view: 'h2', title: 'Heading 2', class: 'ck-heading_heading2' },
                    { model: 'heading3', view: 'h3', title: 'Heading 3', class: 'ck-heading_heading3' }
                ]
            }
        })
        .catch(error => {
            console.error('Lỗi khởi tạo CKEditor:', error);
        });

    // Hàm xem trước video YouTube
    function previewVideo(url) {
        const videoPreview = document.getElementById('video-preview');
        const videoContainer = document.getElementById('video-container');

        if (!url) {
            videoPreview.style.display = 'none';
            return;
        }

        // Trích xuất video ID từ YouTube URL
        const videoId = extractYouTubeVideoId(url);

        if (videoId) {
            const embedUrl = `https://www.youtube.com/embed/${videoId}`;
            videoContainer.innerHTML = `
                    <iframe width="100%" height="200"
                            src="${embedUrl}"
                            frameborder="0"
                            allowfullscreen>
                    </iframe>
                `;
            videoPreview.style.display = 'block';
        } else {
            videoContainer.innerHTML = `
                    <div class="text-danger">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        URL YouTube không hợp lệ. Vui lòng kiểm tra lại.
                    </div>
                `;
            videoPreview.style.display = 'block';
        }
    }

    // Hàm trích xuất video ID từ YouTube URL
    function extractYouTubeVideoId(url) {
        const regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|&v=)([^#&?]*).*/;
        const match = url.match(regExp);
        return (match && match[2].length === 11) ? match[2] : null;
    }

    // Validation cho form
    (function() {
        'use strict';

        // Lấy tất cả form có class 'needs-validation'
        var forms = document.querySelectorAll('.needs-validation');

        // Lặp qua từng form và áp dụng validation
        Array.prototype.slice.call(forms).forEach(function(form) {
            form.addEventListener('submit', function(event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    })();

    // Tự động xem trước video nếu đã có URL
    document.addEventListener('DOMContentLoaded', function() {
        const videoLinkInput = document.querySelector('input[name="videoLink"]');
        if (videoLinkInput && videoLinkInput.value) {
            previewVideo(videoLinkInput.value);
        }
    });
</script>
</body>
</html>