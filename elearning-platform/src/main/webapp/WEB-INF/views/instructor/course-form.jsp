<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? 'Chỉnh sửa' : 'Tạo'} Khóa học - Instructor</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- TinyMCE cho rich text editor -->
    <script src="https://cdn.tiny.cloud/1/no-api-key/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>

    <style>
        /* CSS tùy chỉnh cho form khóa học */
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #28a745;
            --info-color: #17a2b8;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
        }

        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .sidebar {
            background: linear-gradient(135deg, var(--success-color) 0%, var(--info-color) 100%);
            min-height: 100vh;
            padding: 0;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }

        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.9);
            padding: 1rem 1.5rem;
            transition: all 0.3s ease;
            border-left: 4px solid transparent;
        }

        .sidebar .nav-link:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border-left-color: white;
        }

        .sidebar .nav-link.active {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border-left-color: white;
            font-weight: 600;
        }

        .content-header {
            background: white;
            padding: 1.5rem 2rem;
            border-bottom: 1px solid #dee2e6;
            margin-bottom: 2rem;
        }

        .page-title {
            color: #2c3e50;
            font-weight: 700;
            margin: 0;
        }

        .breadcrumb {
            background: none;
            padding: 0;
            margin: 0;
        }

        .form-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 2rem;
        }

        .form-card .card-header {
            background: linear-gradient(135deg, var(--success-color) 0%, var(--info-color) 100%);
            color: white;
            padding: 1.5rem;
            border: none;
        }

        .form-card .card-body {
            padding: 2rem;
        }

        .form-floating {
            margin-bottom: 1.5rem;
        }

        .form-floating > .form-control,
        .form-floating > .form-select {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            height: 58px;
            transition: all 0.3s ease;
        }

        .form-floating > .form-control:focus,
        .form-floating > .form-select:focus {
            border-color: var(--success-color);
            box-shadow: 0 0 0 0.25rem rgba(40, 167, 69, 0.25);
        }

        .form-floating > label {
            color: #6c757d;
            font-weight: 500;
        }

        .form-control.description-editor {
            min-height: 120px;
            resize: vertical;
        }

        .btn-success-custom {
            background: linear-gradient(135deg, var(--success-color) 0%, var(--info-color) 100%);
            border: none;
            padding: 0.75rem 2rem;
            font-weight: 600;
            border-radius: 10px;
            transition: all 0.3s ease;
        }

        .btn-success-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
        }

        .form-check {
            margin-bottom: 1rem;
        }

        .form-check-input:checked {
            background-color: var(--success-color);
            border-color: var(--success-color);
        }

        .form-check-input:focus {
            border-color: var(--success-color);
            box-shadow: 0 0 0 0.25rem rgba(40, 167, 69, 0.25);
        }

        .is-invalid {
            border-color: var(--danger-color) !important;
        }

        .invalid-feedback {
            display: block;
            font-size: 0.875rem;
            margin-top: 0.25rem;
            color: var(--danger-color);
        }

        .form-actions {
            background: #f8f9fa;
            padding: 1.5rem 2rem;
            border-top: 1px solid #dee2e6;
        }

        .course-preview {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .preview-thumbnail {
            width: 100%;
            height: 200px;
            background: linear-gradient(135deg, var(--success-color) 0%, var(--info-color) 100%);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 4rem;
            margin-bottom: 1rem;
        }

        .preview-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }

        .preview-category {
            background: var(--success-color);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 500;
            display: inline-block;
            margin-bottom: 1rem;
        }

        .preview-description {
            color: #6c757d;
            line-height: 1.6;
        }

        .required-field::after {
            content: " *";
            color: var(--danger-color);
        }

        .character-count {
            font-size: 0.8rem;
            color: #6c757d;
            text-align: right;
            margin-top: 0.25rem;
        }

        .character-count.warning {
            color: var(--warning-color);
        }

        .character-count.danger {
            color: var(--danger-color);
        }

        .form-section {
            margin-bottom: 2rem;
            padding-bottom: 2rem;
            border-bottom: 1px solid #e9ecef;
        }

        .form-section:last-child {
            border-bottom: none;
            padding-bottom: 0;
            margin-bottom: 0;
        }

        .section-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 0.5rem;
            color: var(--success-color);
        }

        .help-text {
            font-size: 0.9rem;
            color: #6c757d;
            margin-top: 0.5rem;
        }

        .category-selector {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
        }

        .category-option {
            background: white;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 0.5rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
        }

        .category-option:hover {
            border-color: var(--success-color);
            background: rgba(40, 167, 69, 0.05);
        }

        .category-option.selected {
            border-color: var(--success-color);
            background: rgba(40, 167, 69, 0.1);
        }

        .category-option input[type="radio"] {
            display: none;
        }

        .category-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            color: white;
        }

        .category-info {
            flex: 1;
        }

        .category-name {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 0.25rem;
        }

        .category-desc {
            font-size: 0.85rem;
            color: #6c757d;
            margin: 0;
        }

        @media (max-width: 768px) {
            .form-card .card-body {
                padding: 1rem;
            }

            .preview-thumbnail {
                height: 150px;
                font-size: 3rem;
            }

            .category-option {
                flex-direction: column;
                text-align: center;
            }

            .category-icon {
                margin-right: 0;
                margin-bottom: 0.5rem;
            }
        }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <nav class="col-md-3 col-lg-2 sidebar">
            <div class="text-center py-4">
                <h4 class="text-white mb-0">
                    <i class="fas fa-graduation-cap me-2"></i>
                    EduCourse
                </h4>
                <small class="text-white-50">Instructor Panel</small>
            </div>

            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link" href="/instructor/dashboard">
                        <i class="fas fa-tachometer-alt me-2"></i>
                        Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="/instructor/courses">
                        <i class="fas fa-book me-2"></i>
                        Khóa học của tôi
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/instructor/courses/new">
                        <i class="fas fa-plus-circle me-2"></i>
                        Tạo khóa học mới
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/instructor/students">
                        <i class="fas fa-users me-2"></i>
                        Học viên của tôi
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/instructor/analytics">
                        <i class="fas fa-chart-line me-2"></i>
                        Thống kê & Báo cáo
                    </a>
                </li>
                <li class="nav-item mt-4">
                    <a class="nav-link" href="/">
                        <i class="fas fa-home me-2"></i>
                        Về trang chủ
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/logout">
                        <i class="fas fa-sign-out-alt me-2"></i>
                        Đăng xuất
                    </a>
                </li>
            </ul>
        </nav>

        <!-- Main Content -->
        <main class="col-md-9 ms-sm-auto col-lg-10">
            <!-- Content Header -->
            <div class="content-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="page-title">
                            ${isEdit ? 'Chỉnh sửa' : 'Tạo'} Khóa học
                        </h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="/instructor/dashboard">Instructor</a></li>
                                <li class="breadcrumb-item"><a href="/instructor/courses">Khóa học</a></li>
                                <li class="breadcrumb-item active">
                                    ${isEdit ? 'Chỉnh sửa' : 'Tạo mới'}
                                </li>
                            </ol>
                        </nav>
                    </div>
                    <div>
                        <a href="/instructor/courses" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-2"></i>
                            Quay lại
                        </a>
                    </div>
                </div>
            </div>

            <div class="container-fluid px-4">
                <!-- Hiển thị thông báo -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                            ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty message}">
                    <div class="alert alert-success alert-dismissible fade show">
                        <i class="fas fa-check-circle me-2"></i>
                            ${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <div class="row">
                    <!-- Form Column -->
                    <div class="col-lg-8">
                        <div class="form-card">
                            <div class="card-header">
                                <h5 class="mb-0">
                                    <i class="fas fa-${isEdit ? 'edit' : 'plus-circle'} me-2"></i>
                                    ${isEdit ? 'Cập nhật thông tin khóa học' : 'Tạo khóa học mới'}
                                </h5>
                            </div>

                            <form method="post"
                                  action="${isEdit ? '/instructor/courses/'.concat(course.id).concat('/update') : '/instructor/courses'}"
                                  id="courseForm"
                                  novalidate>
                                <!-- CSRF Token -->
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                                <div class="card-body">
                                    <!-- Thông tin cơ bản -->
                                    <div class="form-section">
                                        <h6 class="section-title">
                                            <i class="fas fa-info-circle"></i>
                                            Thông tin cơ bản
                                        </h6>

                                        <!-- Tên khóa học -->
                                        <div class="form-floating">
                                            <input type="text"
                                                   class="form-control ${not empty nameError ? 'is-invalid' : ''}"
                                                   id="name"
                                                   name="name"
                                                   placeholder="Tên khóa học"
                                                   value="${course.name}"
                                                   maxlength="100"
                                                   required>
                                            <label for="name" class="required-field">
                                                <i class="fas fa-book me-2"></i>Tên khóa học
                                            </label>
                                            <c:if test="${not empty nameError}">
                                                <div class="invalid-feedback">${nameError}</div>
                                            </c:if>
                                            <div class="character-count" id="nameCount">0/100</div>
                                        </div>

                                        <!-- Mô tả ngắn -->
                                        <div class="form-floating">
                                            <textarea class="form-control description-editor ${not empty descriptionError ? 'is-invalid' : ''}"
                                                      id="description"
                                                      name="description"
                                                      placeholder="Mô tả ngắn về khóa học"
                                                      maxlength="500"
                                                      required>${course.description}</textarea>
                                            <label for="description" class="required-field">
                                                <i class="fas fa-align-left me-2"></i>Mô tả ngắn
                                            </label>
                                            <c:if test="${not empty descriptionError}">
                                                <div class="invalid-feedback">${descriptionError}</div>
                                            </c:if>
                                            <div class="character-count" id="descriptionCount">0/500</div>
                                            <div class="help-text">
                                                Viết mô tả ngắn gọn, thu hút để học viên hiểu rõ nội dung khóa học
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Chọn danh mục -->
                                    <div class="form-section">
                                        <h6 class="section-title">
                                            <i class="fas fa-tags"></i>
                                            Danh mục khóa học
                                        </h6>

                                        <div class="category-selector">
                                            <c:forEach items="${categories}" var="category">
                                                <div class="category-option" data-category="${category.id}">
                                                    <input type="radio"
                                                           name="categoryId"
                                                           value="${category.id}"
                                                           id="category${category.id}"
                                                        ${course.category.id == category.id ? 'checked' : ''}>
                                                    <div class="category-icon" style="background-color: ${category.colorCode}">
                                                        <i class="${category.iconClass}"></i>
                                                    </div>
                                                    <div class="category-info">
                                                        <div class="category-name">${category.name}</div>
                                                        <p class="category-desc">${category.description}</p>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>

                                        <div class="help-text">
                                            Chọn danh mục phù hợp giúp học viên dễ dàng tìm thấy khóa học của bạn
                                        </div>
                                    </div>

                                    <!-- Mô tả chi tiết -->
                                    <div class="form-section">
                                        <h6 class="section-title">
                                            <i class="fas fa-file-alt"></i>
                                            Mô tả chi tiết
                                        </h6>

                                        <div class="mb-3">
                                            <label for="detailedDescription" class="form-label">
                                                Mô tả chi tiết về khóa học
                                            </label>
                                            <textarea class="form-control"
                                                      id="detailedDescription"
                                                      name="detailedDescription"
                                                      rows="6"
                                                      placeholder="Viết mô tả chi tiết về nội dung, mục tiêu học tập, đối tượng học viên...">${course.detailedDescription}</textarea>
                                            <div class="help-text">
                                                Sử dụng rich text editor để định dạng nội dung một cách đẹp mắt
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Cài đặt khóa học -->
                                    <div class="form-section">
                                        <h6 class="section-title">
                                            <i class="fas fa-cog"></i>
                                            Cài đặt khóa học
                                        </h6>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <!-- Độ khó -->
                                                <div class="form-floating">
                                                    <select class="form-select" id="level" name="level">
                                                        <option value="BEGINNER" ${course.level == 'BEGINNER' ? 'selected' : ''}>Cơ bản</option>
                                                        <option value="INTERMEDIATE" ${course.level == 'INTERMEDIATE' ? 'selected' : ''}>Trung cấp</option>
                                                        <option value="ADVANCED" ${course.level == 'ADVANCED' ? 'selected' : ''}>Nâng cao</option>
                                                    </select>
                                                    <label for="level">
                                                        <i class="fas fa-layer-group me-2"></i>Độ khó
                                                    </label>
                                                </div>
                                            </div>

                                            <div class="col-md-6">
                                                <!-- Thời lượng ước tính -->
                                                <div class="form-floating">
                                                    <input type="number"
                                                           class="form-control"
                                                           id="estimatedDuration"
                                                           name="estimatedDuration"
                                                           placeholder="Thời lượng (giờ)"
                                                           value="${course.estimatedDuration}"
                                                           min="1"
                                                           max="1000">
                                                    <label for="estimatedDuration">
                                                        <i class="fas fa-clock me-2"></i>Thời lượng ước tính (giờ)
                                                    </label>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Yêu cầu tiên quyết -->
                                        <div class="mb-3">
                                            <label for="prerequisites" class="form-label">
                                                <i class="fas fa-list-check me-2"></i>Yêu cầu tiên quyết
                                            </label>
                                            <textarea class="form-control"
                                                      id="prerequisites"
                                                      name="prerequisites"
                                                      rows="3"
                                                      placeholder="Ví dụ: Kiến thức cơ bản về lập trình, Đã học HTML/CSS...">${course.prerequisites}</textarea>
                                            <div class="help-text">
                                                Liệt kê những kiến thức hoặc kỹ năng cần thiết trước khi học khóa học này
                                            </div>
                                        </div>

                                        <!-- Mục tiêu học tập -->
                                        <div class="mb-3">
                                            <label for="learningObjectives" class="form-label">
                                                <i class="fas fa-bullseye me-2"></i>Mục tiêu học tập
                                            </label>
                                            <textarea class="form-control"
                                                      id="learningObjectives"
                                                      name="learningObjectives"
                                                      rows="4"
                                                      placeholder="Sau khi hoàn thành khóa học, học viên sẽ có thể...">${course.learningObjectives}</textarea>
                                            <div class="help-text">
                                                Mô tả những gì học viên sẽ đạt được sau khi hoàn thành khóa học
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Trạng thái -->
                                    <div class="form-section">
                                        <h6 class="section-title">
                                            <i class="fas fa-toggle-on"></i>
                                            Trạng thái khóa học
                                        </h6>

                                        <div class="form-check form-switch">
                                            <input class="form-check-input"
                                                   type="checkbox"
                                                   id="active"
                                                   name="active"
                                            ${course.active != false ? 'checked' : ''}>
                                            <label class="form-check-label fw-bold" for="active">
                                                Kích hoạt khóa học
                                            </label>
                                            <div class="help-text">
                                                Khóa học chỉ hiển thị với học viên khi được kích hoạt
                                            </div>
                                        </div>

                                        <c:if test="${isEdit}">
                                            <div class="alert alert-info mt-3">
                                                <i class="fas fa-info-circle me-2"></i>
                                                <strong>Lưu ý:</strong>
                                                <ul class="mb-0 mt-2">
                                                    <li>Tạm ngưng khóa học sẽ ẩn khóa học với người dùng mới</li>
                                                    <li>Học viên đã đăng ký vẫn có thể tiếp tục học</li>
                                                    <li>Để xóa khóa học, cần đảm bảo chưa có học viên nào đăng ký</li>
                                                </ul>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>

                                <!-- Form Actions -->
                                <div class="form-actions">
                                    <div class="d-flex justify-content-between">
                                        <a href="/instructor/courses" class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-2"></i>
                                            Hủy bỏ
                                        </a>

                                        <div>
                                            <c:if test="${isEdit}">
                                                <button type="button"
                                                        class="btn btn-outline-warning me-2"
                                                        onclick="resetForm()">
                                                    <i class="fas fa-undo me-2"></i>
                                                    Khôi phục
                                                </button>
                                            </c:if>

                                            <button type="submit" class="btn btn-success-custom">
                                                <i class="fas fa-save me-2"></i>
                                                ${isEdit ? 'Cập nhật khóa học' : 'Tạo khóa học'}
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Preview Column -->
                    <div class="col-lg-4">
                        <div class="form-card">
                            <div class="card-header">
                                <h5 class="mb-0">
                                    <i class="fas fa-eye me-2"></i>
                                    Xem trước
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="course-preview">
                                    <div class="preview-thumbnail" id="previewThumbnail">
                                        <i class="fas fa-book"></i>
                                    </div>

                                    <span class="preview-category" id="previewCategory">
                                        ${not empty course.category ? course.category.name : 'Chọn danh mục'}
                                    </span>

                                    <h5 class="preview-title" id="previewTitle">
                                        ${not empty course.name ? course.name : 'Tên khóa học sẽ hiển thị ở đây'}
                                    </h5>

                                    <p class="preview-description" id="previewDescription">
                                        ${not empty course.description ? course.description : 'Mô tả khóa học sẽ hiển thị ở đây...'}
                                    </p>

                                    <div class="d-flex justify-content-between text-muted">
                                        <small>
                                            <i class="fas fa-user me-1"></i>
                                            ${currentUser.username}
                                        </small>
                                        <small>
                                            <i class="fas fa-clock me-1"></i>
                                            <span id="previewDuration">-- giờ</span>
                                        </small>
                                    </div>
                                </div>

                                <div class="mt-3">
                                    <h6 class="fw-bold mb-2">
                                        <i class="fas fa-lightbulb me-2"></i>
                                        Mẹo tạo khóa học tốt
                                    </h6>
                                    <ul class="list-unstyled small text-muted">
                                        <li class="mb-2">
                                            <i class="fas fa-check text-success me-2"></i>
                                            Tên khóa học ngắn gọn, dễ hiểu
                                        </li>
                                        <li class="mb-2">
                                            <i class="fas fa-check text-success me-2"></i>
                                            Mô tả rõ ràng về nội dung và lợi ích
                                        </li>
                                        <li class="mb-2">
                                            <i class="fas fa-check text-success me-2"></i>
                                            Chọn danh mục phù hợp với nội dung
                                        </li>
                                        <li class="mb-2">
                                            <i class="fas fa-check text-success me-2"></i>
                                            Thiết lập mục tiêu học tập cụ thể
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JavaScript -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Initialize TinyMCE for detailed description
        tinymce.init({
            selector: '#detailedDescription',
            height: 300,
            menubar: false,
            plugins: [
                'advlist', 'autolink', 'lists', 'link', 'image', 'charmap', 'preview',
                'anchor', 'searchreplace', 'visualblocks', 'code', 'fullscreen',
                'insertdatetime', 'media', 'table', 'help', 'wordcount'
            ],
            toolbar: 'undo redo | blocks | bold italic forecolor | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | removeformat | help',
            content_style: 'body { font-family:Segoe UI,Arial,sans-serif; font-size:14px }'
        });

        // Character counters
        function updateCharacterCount(inputId, countId, maxLength) {
            const input = document.getElementById(inputId);
            const counter = document.getElementById(countId);

            function updateCount() {
                const currentLength = input.value.length;
                counter.textContent = `${currentLength}/${maxLength}`;

                // Update styling based on character count
                counter.classList.remove('warning', 'danger');
                if (currentLength > maxLength * 0.8) {
                    counter.classList.add('warning');
                }
                if (currentLength >= maxLength) {
                    counter.classList.add('danger');
                }
            }

            input.addEventListener('input', updateCount);
            updateCount(); // Initial count
        }

        updateCharacterCount('name', 'nameCount', 100);
        updateCharacterCount('description', 'descriptionCount', 500);

        // Live preview updates
        function updatePreview() {
            const name = document.getElementById('name').value || 'Tên khóa học sẽ hiển thị ở đây';
            const description = document.getElementById('description').value || 'Mô tả khóa học sẽ hiển thị ở đây...';
            const duration = document.getElementById('estimatedDuration').value || '--';

            document.getElementById('previewTitle').textContent = name;
            document.getElementById('previewDescription').textContent = description;
            document.getElementById('previewDuration').textContent = duration + ' giờ';
        }

        // Update preview when inputs change
        document.getElementById('name').addEventListener('input', updatePreview);
        document.getElementById('description').addEventListener('input', updatePreview);
        document.getElementById('estimatedDuration').addEventListener('input', updatePreview);

        // Category selection
        const categoryOptions = document.querySelectorAll('.category-option');
        const categoryInputs = document.querySelectorAll('input[name="categoryId"]');

        categoryOptions.forEach(option => {
            option.addEventListener('click', function() {
                // Remove selected class from all options
                categoryOptions.forEach(opt => opt.classList.remove('selected'));
                categoryInputs.forEach(input => input.checked = false);

                // Add selected class to current option
                this.classList.add('selected');
                const categoryId = this.dataset.category;
                document.getElementById('category' + categoryId).checked = true;

                // Update preview
                const categoryName = this.querySelector('.category-name').textContent;
                const categoryColor = this.querySelector('.category-icon').style.backgroundColor;
                const previewCategory = document.getElementById('previewCategory');
                previewCategory.textContent = categoryName;
                previewCategory.style.backgroundColor = categoryColor;
            });
        });

        // Set initial selected category
        const checkedCategory = document.querySelector('input[name="categoryId"]:checked');
        if (checkedCategory) {
            const categoryOption = document.querySelector(`[data-category="${checkedCategory.value}"]`);
            if (categoryOption) {
                categoryOption.classList.add('selected');
            }
        }

        // Form validation
        const form = document.getElementById('courseForm');
        form.addEventListener('submit', function(e) {
            let isValid = true;

            // Validate course name
            const name = document.getElementById('name').value.trim();
            if (name.length < 10) {
                document.getElementById('name').classList.add('is-invalid');
                isValid = false;
            } else {
                document.getElementById('name').classList.remove('is-invalid');
            }

            // Validate description
            const description = document.getElementById('description').value.trim();
            if (description.length < 20) {
                document.getElementById('description').classList.add('is-invalid');
                isValid = false;
            } else {
                document.getElementById('description').classList.remove('is-invalid');
            }

            // Validate category selection
            const categorySelected = document.querySelector('input[name="categoryId"]:checked');
            if (!categorySelected) {
                alert('Vui lòng chọn danh mục cho khóa học');
                isValid = false;
            }

            if (!isValid) {
                e.preventDefault();
            } else {
                // Show loading state
                const submitBtn = form.querySelector('button[type="submit"]');
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
                submitBtn.disabled = true;
            }
        });

        // Real-time validation
        const inputs = document.querySelectorAll('input[required], textarea[required]');
        inputs.forEach(input => {
            input.addEventListener('blur', function() {
                if (this.value.trim() === '') {
                    this.classList.add('is-invalid');
                } else {
                    this.classList.remove('is-invalid');
                }
            });

            input.addEventListener('input', function() {
                if (this.classList.contains('is-invalid') && this.value.trim() !== '') {
                    this.classList.remove('is-invalid');
                }
            });
        });

        // Initial preview update
        updatePreview();
    });

    // Reset form function
    function resetForm() {
        if (confirm('Bạn có chắc muốn khôi phục tất cả thay đổi về trạng thái ban đầu?')) {
            location.reload();
        }
    }
</script>

</body>
</html>