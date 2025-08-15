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
    <title>${course != null ? 'Chỉnh sửa khóa học' : 'Tạo khóa học mới'} - EduLearn Platform</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- TinyMCE Editor -->
    <script src="https://cdn.tiny.cloud/1/no-api-key/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>

    <!-- Custom CSS -->
    <style>
        :root {
            --primary-color: #4f46e5;
            --primary-dark: #3730a3;
            --success-color: #059669;
            --warning-color: #d97706;
            --danger-color: #dc2626;
            --light-bg: #f8fafc;
            --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            --border-color: #e5e7eb;
            --text-primary: #1f2937;
            --text-secondary: #6b7280;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--light-bg);
            margin: 0;
        }

        .dashboard-layout {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 2rem;
            transition: margin-left 0.3s ease;
        }

        @media (max-width: 991.98px) {
            .main-content {
                margin-left: 0;
                padding: 1rem;
            }
        }

        /* Page Header */
        .page-header {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
        }

        .breadcrumb {
            background: none;
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

        .page-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .page-subtitle {
            color: var(--text-secondary);
            margin-bottom: 0;
        }

        /* Form Container */
        .form-container {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
        }

        /* Form Sections */
        .form-section {
            margin-bottom: 3rem;
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
            padding-bottom: 0.75rem;
            border-bottom: 2px solid var(--border-color);
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 0.75rem;
            color: var(--primary-color);
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
        }

        .form-label .required {
            color: var(--danger-color);
            margin-left: 0.25rem;
        }

        .form-label .help-icon {
            margin-left: 0.5rem;
            color: var(--text-secondary);
            cursor: help;
        }

        .form-control,
        .form-select {
            border: 2px solid var(--border-color);
            border-radius: 0.75rem;
            padding: 0.875rem 1rem;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }

        .form-control.is-invalid {
            border-color: var(--danger-color);
        }

        .form-control.is-valid {
            border-color: var(--success-color);
        }

        .invalid-feedback {
            color: var(--danger-color);
            font-size: 0.875rem;
            margin-top: 0.5rem;
        }

        .valid-feedback {
            color: var(--success-color);
            font-size: 0.875rem;
            margin-top: 0.5rem;
        }

        .form-text {
            color: var(--text-secondary);
            font-size: 0.875rem;
            margin-top: 0.5rem;
        }

        /* File Upload */
        .file-upload-area {
            border: 2px dashed var(--border-color);
            border-radius: 0.75rem;
            padding: 2rem;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
            background: var(--light-bg);
        }

        .file-upload-area:hover {
            border-color: var(--primary-color);
            background: rgba(79, 70, 229, 0.05);
        }

        .file-upload-area.dragover {
            border-color: var(--primary-color);
            background: rgba(79, 70, 229, 0.1);
        }

        .upload-icon {
            font-size: 3rem;
            color: var(--text-secondary);
            margin-bottom: 1rem;
        }

        .upload-text {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .upload-hint {
            color: var(--text-secondary);
            font-size: 0.9rem;
        }

        .file-preview {
            margin-top: 1rem;
            padding: 1rem;
            background: white;
            border-radius: 0.5rem;
            border: 1px solid var(--border-color);
            display: none;
        }

        .preview-image {
            max-width: 200px;
            max-height: 150px;
            border-radius: 0.5rem;
            margin-bottom: 0.5rem;
        }

        /* Price Input */
        .price-input-group {
            position: relative;
        }

        .price-currency {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
            font-weight: 600;
            z-index: 2;
        }

        .price-input {
            padding-left: 3rem;
        }

        /* Switch Toggle */
        .form-switch {
            margin-bottom: 1rem;
        }

        .form-check-input {
            width: 3rem;
            height: 1.5rem;
            background-color: var(--border-color);
            border: none;
            border-radius: 1rem;
            transition: all 0.3s ease;
        }

        .form-check-input:checked {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .form-check-label {
            font-weight: 500;
            color: var(--text-primary);
            margin-left: 0.5rem;
        }

        /* Tags Input */
        .tags-container {
            border: 2px solid var(--border-color);
            border-radius: 0.75rem;
            padding: 0.5rem;
            min-height: 3rem;
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            align-items: center;
            cursor: text;
            transition: all 0.3s ease;
        }

        .tags-container:focus-within {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }

        .tag-item {
            background: var(--primary-color);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.875rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .tag-remove {
            background: none;
            border: none;
            color: white;
            cursor: pointer;
            font-size: 0.75rem;
            padding: 0;
            width: 16px;
            height: 16px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .tag-remove:hover {
            background: rgba(255, 255, 255, 0.2);
        }

        .tag-input {
            border: none;
            outline: none;
            flex: 1;
            min-width: 120px;
            padding: 0.5rem;
            font-size: 1rem;
        }

        /* Action Buttons */
        .form-actions {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            padding-top: 2rem;
            border-top: 1px solid var(--border-color);
            margin-top: 2rem;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            border: none;
            color: white;
            padding: 0.875rem 2rem;
            font-weight: 600;
            font-size: 1rem;
            border-radius: 0.75rem;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px -8px var(--primary-color);
            color: white;
        }

        .btn-secondary-custom {
            background: white;
            border: 2px solid var(--border-color);
            color: var(--text-primary);
            padding: 0.875rem 2rem;
            font-weight: 600;
            font-size: 1rem;
            border-radius: 0.75rem;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-secondary-custom:hover {
            border-color: var(--primary-color);
            color: var(--primary-color);
            text-decoration: none;
        }

        .btn-success-custom {
            background: linear-gradient(135deg, var(--success-color), #047857);
            border: none;
            color: white;
            padding: 0.875rem 2rem;
            font-weight: 600;
            font-size: 1rem;
            border-radius: 0.75rem;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-success-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px -8px var(--success-color);
            color: white;
        }

        /* Loading State */
        .btn-loading {
            opacity: 0.6;
            cursor: not-allowed;
        }

        .btn-loading .btn-text {
            display: none;
        }

        .btn-loading .loading-spinner {
            display: inline-block;
        }

        .loading-spinner {
            display: none;
        }

        /* Preview Section */
        .course-preview {
            background: var(--light-bg);
            border-radius: 1rem;
            padding: 1.5rem;
            margin-top: 2rem;
            border: 1px solid var(--border-color);
        }

        .preview-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }

        .preview-title i {
            margin-right: 0.5rem;
            color: var(--primary-color);
        }

        .preview-content {
            background: white;
            border-radius: 0.75rem;
            padding: 1.5rem;
            border: 1px solid var(--border-color);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-actions {
                flex-direction: column;
            }

            .btn-primary-custom,
            .btn-secondary-custom,
            .btn-success-custom {
                justify-content: center;
            }

            .main-content {
                padding: 1rem;
            }

            .page-header,
            .form-container {
                padding: 1.5rem;
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
        <!-- Page Header -->
        <div class="page-header">
            <!-- Breadcrumb -->
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="//instructor/dashboard"">
                            <i class="fas fa-home me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="//instructor/courses"">Khóa học</a>
                    </li>
                    <li class="breadcrumb-item active">
                        ${course != null ? 'Chỉnh sửa' : 'Tạo mới'}
                    </li>
                </ol>
            </nav>

            <h1 class="page-title">
                ${course != null ? 'Chỉnh sửa khóa học' : 'Tạo khóa học mới'}
            </h1>
            <p class="page-subtitle">
                ${course != null ? 'Cập nhật thông tin khóa học của bạn' : 'Tạo một khóa học mới để chia sẻ kiến thức'}
            </p>
        </div>

        <!-- Course Form -->
        <div class="form-container">
            <form method="POST"
                  action="/${course != null ? "/instructor/courses/".concat(course.id).concat("/edit") : "/instructor/courses/new"}""
                  enctype="multipart/form-data"
                  id="courseForm"
                  novalidate>

                <!-- CSRF Token -->
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <!-- Basic Information Section -->
                <div class="form-section">
                    <h2 class="section-title">
                        <i class="fas fa-info-circle"></i>
                        Thông tin cơ bản
                    </h2>

                    <div class="form-grid">
                        <!-- Course Name -->
                        <div class="form-group">
                            <label class="form-label" for="name">
                                Tên khóa học <span class="required">*</span>
                                <i class="fas fa-question-circle help-icon"
                                   title="Tên khóa học nên ngắn gọn, súc tích và thu hút"></i>
                            </label>
                            <input type="text"
                                   class="form-control"
                                   id="name"
                                   name="name"
                                   value="${course.name}"
                                   placeholder="Ví dụ: Lập trình Java từ cơ bản đến nâng cao"
                                   required
                                   maxlength="200">
                            <div class="invalid-feedback">
                                Vui lòng nhập tên khóa học (tối đa 200 ký tự)
                            </div>
                            <div class="form-text">
                                <span id="nameCount">0</span>/200 ký tự
                            </div>
                        </div>

                        <!-- Category -->
                        <div class="form-group">
                            <label class="form-label" for="category">
                                Danh mục <span class="required">*</span>
                            </label>
                            <select class="form-select" id="category" name="categoryId" required>
                                <option value="">Chọn danh mục...</option>
                                <c:forEach items="${categories}" var="category">
                                    <option value="${category.id}"
                                        ${course != null && course.category.id == category.id ? 'selected' : ''}>
                                            ${category.name}
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">
                                Vui lòng chọn danh mục cho khóa học
                            </div>
                        </div>
                    </div>

                    <!-- Short Description -->
                    <div class="form-group">
                        <label class="form-label" for="shortDescription">
                            Mô tả ngắn <span class="required">*</span>
                            <i class="fas fa-question-circle help-icon"
                               title="Mô tả ngắn gọn về khóa học, hiển thị trong danh sách khóa học"></i>
                        </label>
                        <textarea class="form-control"
                                  id="shortDescription"
                                  name="shortDescription"
                                  rows="3"
                                  placeholder="Mô tả ngắn gọn về nội dung và mục tiêu của khóa học..."
                                  required
                                  maxlength="500">${course.shortDescription}</textarea>
                        <div class="invalid-feedback">
                            Vui lòng nhập mô tả ngắn (tối đa 500 ký tự)
                        </div>
                        <div class="form-text">
                            <span id="shortDescCount">0</span>/500 ký tự
                        </div>
                    </div>

                    <!-- Full Description -->
                    <div class="form-group">
                        <label class="form-label" for="description">
                            Mô tả chi tiết <span class="required">*</span>
                        </label>
                        <textarea class="form-control"
                                  id="description"
                                  name="description"
                                  rows="8"
                                  placeholder="Mô tả chi tiết về khóa học, bao gồm mục tiêu, nội dung, đối tượng học viên...">${course.description}</textarea>
                        <div class="invalid-feedback">
                            Vui lòng nhập mô tả chi tiết
                        </div>
                    </div>
                </div>

                <!-- Media Section -->
                <div class="form-section">
                    <h2 class="section-title">
                        <i class="fas fa-image"></i>
                        Hình ảnh khóa học
                    </h2>

                    <!-- Thumbnail Upload -->
                    <div class="form-group">
                        <label class="form-label">
                            Ảnh thumbnail <span class="required">*</span>
                            <i class="fas fa-question-circle help-icon"
                               title="Kích thước đề xuất: 1280x720px, định dạng JPG/PNG"></i>
                        </label>

                        <div class="file-upload-area" id="thumbnailUpload">
                            <div class="upload-icon">
                                <i class="fas fa-cloud-upload-alt"></i>
                            </div>
                            <div class="upload-text">Kéo thả ảnh vào đây hoặc click để chọn</div>
                            <div class="upload-hint">
                                Định dạng: JPG, PNG. Kích thước tối đa: 5MB
                            </div>
                            <input type="file"
                                   name="thumbnailFile"
                                   id="thumbnailFile"
                                   accept="image/jpeg,image/png,image/jpg"
                                   style="display: none;"
                            ${course == null ? 'required' : ''}>

                            <div class="file-preview" id="thumbnailPreview">
                                <img class="preview-image" id="previewImage" alt="Preview">
                                <div class="preview-name" id="previewName"></div>
                                <button type="button" class="btn btn-sm btn-danger mt-2" onclick="clearThumbnail()">
                                    <i class="fas fa-trash me-1"></i>Xóa
                                </button>
                            </div>
                        </div>

                        <!-- Current thumbnail if editing -->
                        <c:if test="${course != null && course.thumbnailPath != null}">
                            <div class="mt-3">
                                <div class="form-text">Ảnh hiện tại:</div>
                                <img src="${pageContext.request.contextPath}/images/courses/${course.thumbnailPath}""
                                     alt="${course.name}"
                                     class="img-thumbnail mt-2"
                                     style="max-width: 200px;">
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Pricing Section -->
                <div class="form-section">
                    <h2 class="section-title">
                        <i class="fas fa-dollar-sign"></i>
                        Giá và điều kiện
                    </h2>

                    <div class="form-grid">
                        <!-- Free Course Toggle -->
                        <div class="form-group">
                            <div class="form-check form-switch">
                                <input class="form-check-input"
                                       type="checkbox"
                                       id="isFree"
                                       name="isFree"
                                       value="true"
                                ${course != null && course.price == 0 ? 'checked' : ''}>
                                <label class="form-check-label" for="isFree">
                                    Khóa học miễn phí
                                </label>
                            </div>
                            <div class="form-text">
                                Bật tùy chọn này nếu khóa học hoàn toàn miễn phí
                            </div>
                        </div>

                        <!-- Price -->
                        <div class="form-group" id="priceGroup">
                            <label class="form-label" for="price">
                                Giá khóa học
                            </label>
                            <div class="price-input-group">
                                <span class="price-currency">₫</span>
                                <input type="number"
                                       class="form-control price-input"
                                       id="price"
                                       name="price"
                                       value="${course != null && course.price > 0 ? course.price : ''}"
                                       placeholder="500000"
                                       min="0"
                                       step="1000">
                            </div>
                            <div class="form-text">
                                Nhập giá bằng VND (ví dụ: 500000 cho 500,000 VNĐ)
                            </div>
                        </div>
                    </div>

                    <!-- Prerequisites -->
                    <div class="form-group">
                        <label class="form-label" for="prerequisites">
                            Yêu cầu trước khi học
                            <i class="fas fa-question-circle help-icon"
                               title="Kiến thức hoặc kỹ năng mà học viên cần có trước khi tham gia"></i>
                        </label>
                        <textarea class="form-control"
                                  id="prerequisites"
                                  name="prerequisites"
                                  rows="3"
                                  placeholder="Ví dụ: Kiến thức cơ bản về máy tính, đã từng lập trình...">${course.prerequisites}</textarea>
                    </div>

                    <!-- What Students Will Learn -->
                    <div class="form-group">
                        <label class="form-label" for="learningOutcomes">
                            Học viên sẽ học được gì <span class="required">*</span>
                            <i class="fas fa-question-circle help-icon"
                               title="Mỗi dòng một mục tiêu học tập cụ thể"></i>
                        </label>
                        <textarea class="form-control"
                                  id="learningOutcomes"
                                  name="learningOutcomes"
                                  rows="5"
                                  placeholder="Nhập mỗi mục tiêu trên một dòng:&#10;- Nắm vững cú pháp Java cơ bản&#10;- Xây dựng ứng dụng web với Spring Boot&#10;- Tích hợp cơ sở dữ liệu MySQL..."
                                  required>${course.learningOutcomes}</textarea>
                        <div class="invalid-feedback">
                            Vui lòng nhập các mục tiêu học tập
                        </div>
                    </div>
                </div>

                <!-- Tags và SEO Section -->
                <div class="form-section">
                    <h2 class="section-title">
                        <i class="fas fa-tags"></i>
                        Tags và SEO
                    </h2>

                    <!-- Tags -->
                    <div class="form-group">
                        <label class="form-label">
                            Tags
                            <i class="fas fa-question-circle help-icon"
                               title="Nhấn Enter để thêm tag mới. Tags giúp học viên tìm kiếm khóa học dễ dàng hơn"></i>
                        </label>
                        <div class="tags-container" id="tagsContainer">
                            <input type="text"
                                   class="tag-input"
                                   id="tagInput"
                                   placeholder="Nhập tag và nhấn Enter...">
                        </div>
                        <input type="hidden" name="tags" id="tagsHidden" value="${course.tags}">
                        <div class="form-text">
                            Ví dụ: java, spring boot, web development, backend
                        </div>
                    </div>

                    <!-- Level -->
                    <div class="form-group">
                        <label class="form-label" for="level">
                            Cấp độ khóa học <span class="required">*</span>
                        </label>
                        <select class="form-select" id="level" name="level" required>
                            <option value="">Chọn cấp độ...</option>
                            <option value="BEGINNER" ${course != null && course.level == 'BEGINNER' ? 'selected' : ''}>
                                Cơ bản (Beginner)
                            </option>
                            <option value="INTERMEDIATE" ${course != null && course.level == 'INTERMEDIATE' ? 'selected' : ''}>
                                Trung cấp (Intermediate)
                            </option>
                            <option value="ADVANCED" ${course != null && course.level == 'ADVANCED' ? 'selected' : ''}>
                                Nâng cao (Advanced)
                            </option>
                        </select>
                        <div class="invalid-feedback">
                            Vui lòng chọn cấp độ khóa học
                        </div>
                    </div>
                </div>

                <!-- Course Settings -->
                <div class="form-section">
                    <h2 class="section-title">
                        <i class="fas fa-cogs"></i>
                        Cài đặt khóa học
                    </h2>

                    <div class="form-grid">
                        <!-- Status -->
                        <div class="form-group">
                            <label class="form-label" for="status">
                                Trạng thái
                            </label>
                            <select class="form-select" id="status" name="status">
                                <option value="DRAFT" ${course == null || course.status == 'DRAFT' ? 'selected' : ''}>
                                    Bản nháp
                                </option>
                                <option value="PENDING" ${course != null && course.status == 'PENDING' ? 'selected' : ''}>
                                    Chờ duyệt
                                </option>
                                <option value="PUBLISHED" ${course != null && course.status == 'PUBLISHED' ? 'selected' : ''}>
                                    Đã xuất bản
                                </option>
                            </select>
                            <div class="form-text">
                                Bản nháp: Chỉ bạn thấy được. Chờ duyệt: Gửi cho admin duyệt. Đã xuất bản: Công khai.
                            </div>
                        </div>

                        <!-- Featured -->
                        <div class="form-group">
                            <div class="form-check form-switch">
                                <input class="form-check-input"
                                       type="checkbox"
                                       id="featured"
                                       name="featured"
                                       value="true"
                                ${course != null && course.featured ? 'checked' : ''}>
                                <label class="form-check-label" for="featured">
                                    Khóa học nổi bật
                                </label>
                            </div>
                            <div class="form-text">
                                Khóa học sẽ được hiển thị trong danh sách nổi bật
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <a href="//instructor/courses"" class="btn-secondary-custom">
                        <i class="fas fa-times"></i>Hủy
                    </a>

                    <button type="submit" name="action" value="save" class="btn-secondary-custom">
                            <span class="btn-text">
                                <i class="fas fa-save"></i>Lưu nháp
                            </span>
                        <span class="loading-spinner">
                                <i class="fas fa-spinner fa-spin"></i>Đang lưu...
                            </span>
                    </button>

                    <button type="submit" name="action" value="publish" class="btn-primary-custom">
                            <span class="btn-text">
                                <i class="fas fa-paper-plane"></i>
                                ${course != null ? 'Cập nhật khóa học' : 'Tạo và xuất bản'}
                            </span>
                        <span class="loading-spinner">
                                <i class="fas fa-spinner fa-spin"></i>Đang xử lý...
                            </span>
                    </button>
                </div>
            </form>
        </div>

        <!-- Course Preview -->
        <c:if test="${course != null}">
            <div class="course-preview">
                <div class="preview-title">
                    <i class="fas fa-eye"></i>
                    Xem trước khóa học
                </div>
                <div class="preview-content">
                    <a href="//courses/${course.id}""
                       target="_blank"
                       class="btn-primary-custom">
                        <i class="fas fa-external-link-alt"></i>
                        Xem trang khóa học công khai
                    </a>
                </div>
            </div>
        </c:if>
    </div>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JavaScript -->
<script>
    // Initialize TinyMCE for description - Khởi tạo TinyMCE cho mô tả
    tinymce.init({
        selector: '#description',
        height: 300,
        menubar: false,
        plugins: [
            'advlist', 'autolink', 'lists', 'link', 'image', 'charmap',
            'preview', 'searchreplace', 'visualblocks', 'code', 'fullscreen',
            'insertdatetime', 'media', 'table', 'help', 'wordcount'
        ],
        toolbar: 'undo redo | blocks | bold italic forecolor | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | removeformat | help',
        content_style: 'body { font-family: Inter, sans-serif; font-size: 14px }'
    });

    // Character counters - Đếm ký tự
    function updateCharacterCount(inputId, countId, maxLength) {
        const input = document.getElementById(inputId);
        const counter = document.getElementById(countId);

        if (input && counter) {
            const updateCount = () => {
                const currentLength = input.value.length;
                counter.textContent = currentLength;

                if (currentLength > maxLength * 0.9) {
                    counter.style.color = 'var(--warning-color)';
                } else if (currentLength >= maxLength) {
                    counter.style.color = 'var(--danger-color)';
                } else {
                    counter.style.color = 'var(--text-secondary)';
                }
            };

            input.addEventListener('input', updateCount);
            updateCount(); // Initial count
        }
    }

    // Initialize character counters
    updateCharacterCount('name', 'nameCount', 200);
    updateCharacterCount('shortDescription', 'shortDescCount', 500);

    // File upload handling - Xử lý upload file
    function initializeFileUpload() {
        const uploadArea = document.getElementById('thumbnailUpload');
        const fileInput = document.getElementById('thumbnailFile');
        const preview = document.getElementById('thumbnailPreview');
        const previewImage = document.getElementById('previewImage');
        const previewName = document.getElementById('previewName');

        // Click to select file
        uploadArea.addEventListener('click', (e) => {
            if (e.target === uploadArea || e.target.closest('.upload-icon, .upload-text, .upload-hint')) {
                fileInput.click();
            }
        });

        // Drag and drop
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
                handleFileSelect(files[0]);
            }
        });

        // File input change
        fileInput.addEventListener('change', (e) => {
            if (e.target.files.length > 0) {
                handleFileSelect(e.target.files[0]);
            }
        });

        function handleFileSelect(file) {
            // Validate file type
            if (!file.type.match(/^image\/(jpeg|jpg|png)$/)) {
                alert('Vui lòng chọn file ảnh định dạng JPG hoặc PNG');
                return;
            }

            // Validate file size (5MB)
            if (file.size > 5 * 1024 * 1024) {
                alert('Kích thước file không được vượt quá 5MB');
                return;
            }

            // Show preview
            const reader = new FileReader();
            reader.onload = (e) => {
                previewImage.src = e.target.result;
                previewName.textContent = file.name;
                preview.style.display = 'block';
            };
            reader.readAsDataURL(file);

            // Update file input
            const dt = new DataTransfer();
            dt.items.add(file);
            fileInput.files = dt.files;
        }
    }

    function clearThumbnail() {
        document.getElementById('thumbnailFile').value = '';
        document.getElementById('thumbnailPreview').style.display = 'none';
    }

    // Price toggle handling - Xử lý toggle giá
    function initializePriceToggle() {
        const freeCheckbox = document.getElementById('isFree');
        const priceGroup = document.getElementById('priceGroup');
        const priceInput = document.getElementById('price');

        function togglePriceFields() {
            if (freeCheckbox.checked) {
                priceGroup.style.opacity = '0.5';
                priceInput.disabled = true;
                priceInput.value = '';
            } else {
                priceGroup.style.opacity = '1';
                priceInput.disabled = false;
            }
        }

        freeCheckbox.addEventListener('change', togglePriceFields);
        togglePriceFields(); // Initial state
    }

    // Tags handling - Xử lý tags
    function initializeTags() {
        const tagsContainer = document.getElementById('tagsContainer');
        const tagInput = document.getElementById('tagInput');
        const tagsHidden = document.getElementById('tagsHidden');
        let tags = [];

        // Load existing tags
        if (tagsHidden.value) {
            tags = tagsHidden.value.split(',').filter(tag => tag.trim());
            renderTags();
        }

        function renderTags() {
            // Remove existing tag elements
            const existingTags = tagsContainer.querySelectorAll('.tag-item');
            existingTags.forEach(tag => tag.remove());

            // Add tag elements before input
            tags.forEach((tag, index) => {
                const tagElement = document.createElement('div');
                tagElement.className = 'tag-item';
                tagElement.innerHTML = `
                        <span>${tag}</span>
                        <button type="button" class="tag-remove" onclick="removeTag(${index})">
                            <i class="fas fa-times"></i>
                        </button>
                    `;
                tagsContainer.insertBefore(tagElement, tagInput);
            });

            // Update hidden input
            tagsHidden.value = tags.join(',');
        }

        function addTag(tagText) {
            const trimmedTag = tagText.trim().toLowerCase();
            if (trimmedTag && !tags.includes(trimmedTag)) {
                tags.push(trimmedTag);
                renderTags();
                tagInput.value = '';
            }
        }

        // Global function for removing tags
        window.removeTag = function(index) {
            tags.splice(index, 1);
            renderTags();
        };

        tagInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                e.preventDefault();
                addTag(tagInput.value);
            } else if (e.key === 'Backspace' && tagInput.value === '' && tags.length > 0) {
                tags.pop();
                renderTags();
            }
        });
    }

    // Form validation - Validation form
    function initializeFormValidation() {
        const form = document.getElementById('courseForm');

        form.addEventListener('submit', function(e) {
            let isValid = true;

            // Validate required fields
            const requiredFields = form.querySelectorAll('[required]');
            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    field.classList.add('is-invalid');
                    isValid = false;
                } else {
                    field.classList.remove('is-invalid');
                    field.classList.add('is-valid');
                }
            });

            // Validate TinyMCE description
            const description = tinymce.get('description').getContent();
            if (!description.trim()) {
                alert('Vui lòng nhập mô tả chi tiết khóa học');
                isValid = false;
            }

            if (!isValid) {
                e.preventDefault();
                e.stopPropagation();
            } else {
                // Show loading state
                const submitBtn = e.submitter;
                if (submitBtn) {
                    submitBtn.classList.add('btn-loading');
                    submitBtn.disabled = true;
                }
            }
        });

        // Real-time validation
        const inputs = form.querySelectorAll('input, select, textarea');
        inputs.forEach(input => {
            input.addEventListener('blur', function() {
                if (this.hasAttribute('required')) {
                    if (!this.value.trim()) {
                        this.classList.add('is-invalid');
                        this.classList.remove('is-valid');
                    } else {
                        this.classList.remove('is-invalid');
                        this.classList.add('is-valid');
                    }
                }
            });
        });
    }

    // Initialize all functionality - Khởi tạo tất cả chức năng
    document.addEventListener('DOMContentLoaded', function() {
        initializeFileUpload();
        initializePriceToggle();
        initializeTags();
        initializeFormValidation();

        // Auto-save functionality (optional)
        let autoSaveTimer;
        const form = document.getElementById('courseForm');

        function autoSave() {
            const formData = new FormData(form);
            formData.append('action', 'autosave');

            fetch(form.action, {
                method: 'POST',
                body: formData
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        console.log('Auto-saved successfully');
                        showAutoSaveNotification();
                    }
                })
                .catch(error => {
                    console.log('Auto-save failed:', error);
                });
        }

        function showAutoSaveNotification() {
            // Show subtle auto-save notification
            const notification = document.createElement('div');
            notification.innerHTML = 'Đã tự động lưu';
            notification.style.cssText = `
                    position: fixed;
                    top: 2rem;
                    right: 2rem;
                    background: var(--success-color);
                    color: white;
                    padding: 0.5rem 1rem;
                    border-radius: 0.5rem;
                    font-size: 0.85rem;
                    z-index: 9999;
                    animation: fadeInOut 2s ease;
                `;

            document.body.appendChild(notification);
            setTimeout(() => notification.remove(), 2000);
        }

        // Set up auto-save every 2 minutes
        const inputs = form.querySelectorAll('input, select, textarea');
        inputs.forEach(input => {
            input.addEventListener('input', () => {
                clearTimeout(autoSaveTimer);
                autoSaveTimer = setTimeout(autoSave, 2 * 60 * 1000);
            });
        });
    });

    // Keyboard shortcuts - Phím tắt
    document.addEventListener('keydown', function(e) {
        // Ctrl/Cmd + S: Save
        if ((e.ctrlKey || e.metaKey) && e.key === 's') {
            e.preventDefault();
            document.querySelector('button[value="save"]').click();
        }

        // Ctrl/Cmd + Shift + S: Save and publish
        if ((e.ctrlKey || e.metaKey) && e.shiftKey && e.key === 'S') {
            e.preventDefault();
            document.querySelector('button[value="publish"]').click();
        }
    });

    // Add CSS for animations
    const style = document.createElement('style');
    style.textContent = `
            @keyframes fadeInOut {
                0%, 100% { opacity: 0; transform: translateX(100%); }
                10%, 90% { opacity: 1; transform: translateX(0); }
            }
        `;
    document.head.appendChild(style);
</script>
</body>
</html>