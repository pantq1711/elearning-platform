<%-- File: src/main/webapp/WEB-INF/views/admin/course-form.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? 'Sửa' : 'Thêm'} Khóa Học - Admin</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }

        .sidebar .nav-link {
            color: rgba(255,255,255,0.8);
            padding: 12px 20px;
            border-radius: 8px;
            margin: 2px 10px;
            transition: all 0.3s ease;
        }

        .sidebar .nav-link:hover {
            background: rgba(255,255,255,0.1);
            color: white;
            transform: translateX(5px);
        }

        .sidebar .nav-link.active {
            background: rgba(255,255,255,0.2);
            color: white;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .sidebar-header {
            padding: 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .main-content {
            background: #f8f9fa;
            min-height: 100vh;
        }

        .content-header {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            padding: 20px;
        }

        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
        }

        .form-control, .form-select {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 12px 15px;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .btn {
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: #6c757d;
            border: none;
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-1px);
        }

        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 8px;
        }

        .alert {
            border: none;
            border-radius: 10px;
            border-left: 4px solid;
        }

        .alert-success {
            background: #d1f2dd;
            border-left-color: #28a745;
            color: #155724;
        }

        .alert-danger {
            background: #f8d7da;
            border-left-color: #dc3545;
            color: #721c24;
        }

        .level-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .level-beginner { background: #28a745; color: white; }
        .level-intermediate { background: #ffc107; color: #212529; }
        .level-advanced { background: #dc3545; color: white; }

        .text-danger {
            font-size: 0.875rem;
        }
    </style>
</head>

<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <nav class="col-md-3 col-lg-2 d-md-block sidebar">
            <div class="position-sticky">
                <div class="sidebar-header">
                    <h4 class="text-white mb-0">
                        <i class="fas fa-graduation-cap me-2"></i>EduLearn
                    </h4>
                    <small class="text-white-50">Quản trị viên</small>
                </div>
                <div class="pt-3">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link" href="/admin/dashboard">
                                <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/admin/users">
                                <i class="fas fa-users me-2"></i>Người dùng
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="/admin/courses">
                                <i class="fas fa-book me-2"></i>Khóa học
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/admin/categories">
                                <i class="fas fa-tags me-2"></i>Danh mục
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/admin/analytics">
                                <i class="fas fa-chart-bar me-2"></i>Thống kê
                            </a>
                        </li>
                        <li class="nav-item mt-3">
                            <a class="nav-link" href="/logout">
                                <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Main content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
            <div class="content-header mt-3">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="h2 mb-2">
                            <i class="fas fa-${isEdit ? 'edit' : 'plus-circle'} me-2 text-primary"></i>
                            ${isEdit ? 'Sửa' : 'Thêm'} Khóa Học
                        </h1>
                        <p class="text-muted mb-0">${isEdit ? 'Cập nhật thông tin khóa học' : 'Tạo khóa học mới cho hệ thống'}</p>
                    </div>
                    <a href="/admin/courses" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại
                    </a>
                </div>
            </div>

            <!-- Alert messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Form -->
            <div class="row">
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="fas fa-info-circle me-2"></i>Thông tin khóa học
                            </h5>
                        </div>
                        <div class="card-body p-4">
                            <form:form method="post"
                                       action="${isEdit ? '/admin/courses/'.concat(course.id).concat('/update') : '/admin/courses/create'}"
                                       modelAttribute="course"
                                       class="needs-validation"
                                       novalidate="true">

                                <div class="row">
                                    <!-- Tên khóa học -->
                                    <div class="col-md-8 mb-3">
                                        <label for="name" class="form-label">
                                            Tên khóa học <span class="text-danger">*</span>
                                        </label>
                                        <form:input path="name" cssClass="form-control" id="name"
                                                    required="true" maxlength="200"
                                                    placeholder="Ví dụ: Lập trình Java từ cơ bản đến nâng cao" />
                                        <form:errors path="name" cssClass="text-danger small" />
                                    </div>

                                    <!-- Giá -->
                                    <div class="col-md-4 mb-3">
                                        <label for="price" class="form-label">Giá (VNĐ)</label>
                                        <div class="input-group">
                                            <form:input path="price" cssClass="form-control" type="number"
                                                        id="price" min="0" step="1000" placeholder="0" />
                                            <span class="input-group-text">₫</span>
                                        </div>
                                        <form:errors path="price" cssClass="text-danger small" />
                                    </div>
                                </div>

                                <!-- Mô tả ngắn -->
                                <div class="mb-3">
                                    <label for="description" class="form-label">Mô tả ngắn</label>
                                    <form:textarea path="description" cssClass="form-control" id="description"
                                                   rows="3" maxlength="500"
                                                   placeholder="Mô tả ngắn gọn về khóa học này..." />
                                    <div class="form-text">Tối đa 500 ký tự</div>
                                    <form:errors path="description" cssClass="text-danger small" />
                                </div>

                                <div class="row">
                                    <!-- Danh mục -->
                                    <div class="col-md-6 mb-3">
                                        <label for="category" class="form-label">
                                            Danh mục <span class="text-danger">*</span>
                                        </label>
                                        <form:select path="category.id" cssClass="form-select" id="category" required="true">
                                            <form:option value="">-- Chọn danh mục --</form:option>
                                            <c:forEach var="cat" items="${categories}">
                                                <form:option value="${cat.id}">${cat.name}</form:option>
                                            </c:forEach>
                                        </form:select>
                                        <form:errors path="category" cssClass="text-danger small" />
                                    </div>

                                    <!-- Cấp độ -->
                                    <div class="col-md-6 mb-3">
                                        <label for="difficultyLevel" class="form-label">Cấp độ</label>
                                        <form:select path="difficultyLevel" cssClass="form-select" id="difficultyLevel">
                                            <form:option value="EASY">Cơ bản</form:option>
                                            <form:option value="MEDIUM">Trung cấp</form:option>
                                            <form:option value="HARD">Nâng cao</form:option>
                                        </form:select>
                                        <form:errors path="difficultyLevel" cssClass="text-danger small" />
                                    </div>
                                </div>

                                <div class="row">
                                    <!-- Thời lượng -->
                                    <div class="col-md-6 mb-3">
                                        <label for="duration" class="form-label">Thời lượng (giờ)</label>
                                        <form:input path="duration" cssClass="form-control" type="number"
                                                    id="duration" min="0" step="0.5" placeholder="0" />
                                        <form:errors path="duration" cssClass="text-danger small" />
                                    </div>

                                    <!-- Giảng viên (chỉ hiện khi edit) -->
                                    <c:if test="${isEdit}">
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label">Giảng viên</label>
                                            <div class="form-control-plaintext">
                                                <strong>${course.instructor.fullName}</strong>
                                                <small class="text-muted d-block">${course.instructor.email}</small>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Checkboxes -->
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <div class="form-check form-switch">
                                            <form:checkbox path="active" cssClass="form-check-input" id="active" />
                                            <label class="form-check-label" for="active">
                                                <strong>Kích hoạt khóa học</strong>
                                                <small class="d-block text-muted">Cho phép học viên đăng ký</small>
                                            </label>
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <div class="form-check form-switch">
                                            <form:checkbox path="featured" cssClass="form-check-input" id="featured" />
                                            <label class="form-check-label" for="featured">
                                                <strong>Khóa học nổi bật</strong>
                                                <small class="d-block text-muted">Hiển thị ưu tiên trên trang chủ</small>
                                            </label>
                                        </div>
                                    </div>
                                </div>

                                <!-- Action Buttons -->
                                <div class="d-flex gap-3 mt-4 pt-3 border-top">
                                    <button type="submit" class="btn btn-primary btn-lg">
                                        <i class="fas fa-${isEdit ? 'save' : 'plus'} me-2"></i>
                                            ${isEdit ? 'Cập nhật' : 'Tạo'} khóa học
                                    </button>
                                    <a href="/admin/courses" class="btn btn-secondary">
                                        <i class="fas fa-times me-2"></i>Hủy bỏ
                                    </a>
                                </div>
                            </form:form>
                        </div>
                    </div>
                </div>

                <!-- Sidebar thông tin -->
                <div class="col-lg-4">
                    <div class="card">
                        <div class="card-header">
                            <h6 class="mb-0">
                                <i class="fas fa-lightbulb me-2"></i>Hướng dẫn
                            </h6>
                        </div>
                        <div class="card-body">
                            <div class="small">
                                <div class="mb-3">
                                    <strong>Tiêu đề khóa học:</strong>
                                    <p class="text-muted mb-2">Nên rõ ràng, súc tích và thu hút. Bao gồm từ khóa chính để dễ tìm kiếm.</p>
                                </div>

                                <div class="mb-3">
                                    <strong>Cấp độ:</strong>
                                    <div class="mt-2">
                                        <span class="level-badge level-beginner me-2">Cơ bản</span>
                                        <small class="text-muted d-block">Phù hợp với người mới bắt đầu</small>

                                        <span class="level-badge level-intermediate me-2 mt-2 d-inline-block">Trung cấp</span>
                                        <small class="text-muted d-block">Cần có kiến thức nền tảng</small>

                                        <span class="level-badge level-advanced me-2 mt-2 d-inline-block">Nâng cao</span>
                                        <small class="text-muted d-block">Dành cho chuyên gia</small>
                                    </div>
                                </div>

                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-2"></i>
                                    <strong>Lưu ý:</strong> Sau khi tạo khóa học, bạn có thể thêm bài giảng và quiz trong phần quản lý chi tiết.
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

<script>
    // Form validation
    (function() {
        'use strict';
        window.addEventListener('load', function() {
            var forms = document.getElementsByClassName('needs-validation');
            var validation = Array.prototype.filter.call(forms, function(form) {
                form.addEventListener('submit', function(event) {
                    if (form.checkValidity() === false) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        }, false);
    })();

    // Set default values khi tạo mới
    document.addEventListener('DOMContentLoaded', function() {
        const isEdit = ${isEdit ? 'true' : 'false'};

        if (!isEdit) {
            // Set mặc định active = true khi tạo mới
            document.getElementById('active').checked = true;
            // Set mặc định difficultyLevel = EASY
            document.getElementById('difficultyLevel').value = 'EASY';
        }

        // Format price input
        const priceInput = document.getElementById('price');
        if (priceInput) {
            priceInput.addEventListener('input', function() {
                // Remove non-numeric characters except decimal
                this.value = this.value.replace(/[^0-9]/g, '');

                // Format number with commas
                if (this.value) {
                    const formatted = parseInt(this.value).toLocaleString('vi-VN');
                    // Update display value but keep actual value for form submission
                }
            });
        }
    });
</script>
</body>
</html>