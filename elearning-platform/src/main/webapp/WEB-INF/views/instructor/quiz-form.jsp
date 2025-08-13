<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? 'Chỉnh sửa' : 'Tạo mới'} bài kiểm tra - ${course.name}</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

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
            background: linear-gradient(135deg, var(--warning-color) 0%, #ff6b6b 100%);
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
            border-color: var(--warning-color);
            box-shadow: 0 0 0 0.2rem rgba(255, 193, 7, 0.25);
            transform: translateY(-2px);
        }

        .form-select {
            border: 2px solid #e9ecef;
            border-radius: 12px;
            transition: all 0.3s ease;
        }

        .form-select:focus {
            border-color: var(--warning-color);
            box-shadow: 0 0 0 0.2rem rgba(255, 193, 7, 0.25);
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
            background-color: var(--warning-color);
            border-color: var(--warning-color);
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
            background: linear-gradient(135deg, var(--warning-color) 0%, #ff6b6b 100%);
            border: none;
            border-radius: 50px;
            padding: 12px 30px;
            font-weight: 600;
            transition: all 0.3s ease;
            color: #212529;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(255, 193, 7, 0.4);
            color: #212529;
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

        /* Course info section */
        .course-info {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .course-info h5 {
            color: #856404;
            margin-bottom: 0.5rem;
        }

        /* Settings section */
        .settings-section {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .settings-section h6 {
            color: var(--primary-color);
            margin-bottom: 1rem;
            font-weight: 600;
        }

        /* Help text styling */
        .form-text {
            color: #6c757d;
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }

        /* Score input group */
        .score-group {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .score-input {
            flex: 1;
        }

        /* Duration selector */
        .duration-selector {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .duration-input {
            flex: 1;
        }

        .duration-unit {
            background: var(--warning-color);
            color: #212529;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-weight: 600;
            white-space: nowrap;
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

            .score-group,
            .duration-selector {
                flex-direction: column;
                gap: 0.5rem;
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
                <a href="/instructor/courses/${course.id}/quizzes">
                    ${course.name} - Quiz
                </a>
            </li>
            <li class="breadcrumb-item active" aria-current="page">
                ${isEdit ? 'Chỉnh sửa' : 'Tạo mới'} bài kiểm tra
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
                        ${isEdit ? 'Chỉnh sửa' : 'Tạo mới'} bài kiểm tra
                    </h2>
                    <p>Tạo bài kiểm tra trắc nghiệm để đánh giá kiến thức học viên</p>
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
                               action="${isEdit ? '/instructor/courses/' += course.id += '/quizzes/' += quiz.id : '/instructor/courses/' += course.id += '/quizzes'}"
                               modelAttribute="quiz"
                               class="needs-validation"
                               novalidate="true">

                        <!-- CSRF Token -->
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                        <!-- Hidden ID for edit mode -->
                        <c:if test="${isEdit}">
                            <form:hidden path="id"/>
                        </c:if>

                        <div class="row">
                            <!-- Left Column - Basic Information -->
                            <div class="col-lg-8">
                                <!-- Quiz Title -->
                                <div class="form-floating">
                                    <form:input path="title"
                                                class="form-control ${not empty errors.title ? 'is-invalid' : ''}"
                                                placeholder="Nhập tiêu đề bài kiểm tra"
                                                required="true"/>
                                    <label for="title">
                                        <i class="fas fa-heading me-2"></i>Tiêu đề bài kiểm tra *
                                    </label>
                                    <form:errors path="title" class="text-danger"/>
                                    <div class="form-text">
                                        Tên bài kiểm tra ngắn gọn, dễ hiểu
                                    </div>
                                </div>

                                <!-- Quiz Description -->
                                <div class="form-floating">
                                    <form:textarea path="description"
                                                   class="form-control ${not empty errors.description ? 'is-invalid' : ''}"
                                                   style="height: 120px"
                                                   placeholder="Mô tả ngắn về nội dung và mục đích của bài kiểm tra..."
                                                   required="true"/>
                                    <label for="description">
                                        <i class="fas fa-file-alt me-2"></i>Mô tả bài kiểm tra *
                                    </label>
                                    <form:errors path="description" class="text-danger"/>
                                    <div class="form-text">
                                        Giải thích mục đích và nội dung của bài kiểm tra
                                    </div>
                                </div>

                                <!-- Instructions -->
                                <div class="form-floating">
                                    <form:textarea path="instructions"
                                                   class="form-control"
                                                   style="height: 100px"
                                                   placeholder="Hướng dẫn làm bài cho học viên..."/>
                                    <label for="instructions">
                                        <i class="fas fa-list-ul me-2"></i>Hướng dẫn làm bài
                                    </label>
                                    <div class="form-text">
                                        Hướng dẫn chi tiết cách thức làm bài và lưu ý quan trọng
                                    </div>
                                </div>
                            </div>

                            <!-- Right Column - Settings -->
                            <div class="col-lg-4">
                                <!-- Time Settings -->
                                <div class="settings-section">
                                    <h6><i class="fas fa-clock me-2"></i>Cài đặt thời gian</h6>

                                    <div class="duration-selector">
                                        <div class="duration-input">
                                            <form:input path="duration"
                                                        type="number"
                                                        class="form-control"
                                                        min="5"
                                                        max="480"
                                                        placeholder="30"/>
                                        </div>
                                        <div class="duration-unit">phút</div>
                                    </div>
                                    <div class="form-text">
                                        Thời gian tối đa để hoàn thành bài kiểm tra
                                    </div>
                                </div>

                                <!-- Score Settings -->
                                <div class="settings-section">
                                    <h6><i class="fas fa-trophy me-2"></i>Cài đặt điểm số</h6>

                                    <div class="mb-3">
                                        <label class="form-label">Điểm tối đa</label>
                                        <div class="score-group">
                                            <form:input path="maxScore"
                                                        type="number"
                                                        class="form-control score-input"
                                                        min="10"
                                                        max="1000"
                                                        step="0.1"
                                                        placeholder="100"/>
                                            <span class="duration-unit">điểm</span>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Điểm đạt</label>
                                        <div class="score-group">
                                            <form:input path="passScore"
                                                        type="number"
                                                        class="form-control score-input"
                                                        min="1"
                                                        max="1000"
                                                        step="0.1"
                                                        placeholder="60"/>
                                            <span class="duration-unit">điểm</span>
                                        </div>
                                        <div class="form-text">
                                            Điểm tối thiểu để vượt qua bài kiểm tra
                                        </div>
                                    </div>
                                </div>

                                <!-- Attempt Settings -->
                                <div class="settings-section">
                                    <h6><i class="fas fa-redo me-2"></i>Số lần làm bài</h6>

                                    <form:select path="maxAttempts" class="form-select">
                                        <form:option value="1">1 lần (mặc định)</form:option>
                                        <form:option value="2">2 lần</form:option>
                                        <form:option value="3">3 lần</form:option>
                                        <form:option value="5">5 lần</form:option>
                                        <form:option value="-1">Không giới hạn</form:option>
                                    </form:select>
                                    <div class="form-text">
                                        Số lần tối đa học viên có thể làm bài kiểm tra
                                    </div>
                                </div>

                                <!-- Display Settings -->
                                <div class="settings-section">
                                    <h6><i class="fas fa-cog me-2"></i>Cài đặt hiển thị</h6>

                                    <div class="form-check form-switch mb-3">
                                        <form:checkbox path="showResultImmediately"
                                                       class="form-check-input"
                                                       id="showResultImmediately"/>
                                        <label class="form-check-label" for="showResultImmediately">
                                            Hiển thị kết quả ngay lập tức
                                        </label>
                                    </div>

                                    <div class="form-check form-switch mb-3">
                                        <form:checkbox path="showCorrectAnswers"
                                                       class="form-check-input"
                                                       id="showCorrectAnswers"/>
                                        <label class="form-check-label" for="showCorrectAnswers">
                                            Hiển thị đáp án đúng
                                        </label>
                                    </div>

                                    <div class="form-check form-switch mb-3">
                                        <form:checkbox path="active"
                                                       class="form-check-input"
                                                       id="active"/>
                                        <label class="form-check-label" for="active">
                                            <i class="fas fa-toggle-on me-2"></i>Kích hoạt bài kiểm tra
                                        </label>
                                    </div>
                                </div>

                                <!-- Action Buttons -->
                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-2"></i>
                                            ${isEdit ? 'Cập nhật' : 'Tạo'} bài kiểm tra
                                    </button>

                                    <a href="/instructor/courses/${course.id}/quizzes"
                                       class="btn btn-secondary">
                                        <i class="fas fa-arrow-left me-2"></i>
                                        Quay lại danh sách
                                    </a>
                                </div>
                            </div>
                        </div>
                    </form:form>

                    <!-- Next Steps Info -->
                    <c:if test="${not isEdit}">
                        <div class="alert alert-info mt-4">
                            <h6><i class="fas fa-info-circle me-2"></i>Bước tiếp theo</h6>
                            <p class="mb-0">
                                Sau khi tạo bài kiểm tra, bạn sẽ được chuyển đến trang quản lý câu hỏi
                                để thêm các câu hỏi trắc nghiệm cho bài kiểm tra này.
                            </p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
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

    // Tự động cập nhật passScore khi maxScore thay đổi
    document.addEventListener('DOMContentLoaded', function() {
        const maxScoreInput = document.querySelector('input[name="maxScore"]');
        const passScoreInput = document.querySelector('input[name="passScore"]');

        if (maxScoreInput && passScoreInput) {
            maxScoreInput.addEventListener('input', function() {
                const maxScore = parseFloat(this.value);
                if (maxScore && maxScore > 0) {
                    // Đặt passScore mặc định là 60% của maxScore
                    const suggestedPassScore = Math.round(maxScore * 0.6 * 10) / 10;
                    if (!passScoreInput.value || parseFloat(passScoreInput.value) > maxScore) {
                        passScoreInput.value = suggestedPassScore;
                    }
                    passScoreInput.max = maxScore;
                }
            });
        }
    });

    // Tooltip cho các trường có giải thích
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
</script>
</body>
</html>