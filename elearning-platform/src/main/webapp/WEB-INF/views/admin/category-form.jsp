<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>SS
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${empty category.id}">Tạo danh mục mới</c:when>
            <c:otherwise>Chỉnh sửa danh mục: ${category.name}</c:otherwise>
        </c:choose>
        - Admin Panel
    </title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        /* CSS cho category form page */
        .admin-wrapper {
            display: flex;
            min-height: 100vh;
            background-color: #f8f9fa;
        }

        .admin-sidebar {
            width: 280px;
            background: linear-gradient(180deg, #4f46e5 0%, #7c3aed 100%);
            color: white;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            transition: transform 0.3s ease;
            z-index: 1000;
        }

        .admin-content {
            flex: 1;
            margin-left: 280px;
            padding: 0;
        }

        .admin-header {
            background: white;
            padding: 1rem 2rem;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #1f2937;
            margin: 0;
        }

        .sidebar-header {
            padding: 1.5rem 1rem;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .menu-section {
            padding: 1rem 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .menu-title {
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            color: rgba(255,255,255,0.7);
            padding: 0 1rem;
            margin-bottom: 0.5rem;
        }

        .menu-item {
            display: flex;
            align-items: center;
            padding: 0.75rem 1rem;
            color: rgba(255,255,255,0.8);
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .menu-item:hover,
        .menu-item.active {
            background-color: rgba(255,255,255,0.1);
            color: white;
            text-decoration: none;
        }

        .menu-item i {
            width: 20px;
            margin-right: 0.75rem;
        }

        .page-content {
            padding: 2rem;
        }

        .form-container {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid #e5e7eb;
            overflow: hidden;
        }

        .form-header {
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
            color: white;
            padding: 2rem;
            text-align: center;
        }

        .form-header h2 {
            margin: 0;
            font-weight: 600;
            font-size: 1.75rem;
        }

        .form-header p {
            margin: 0.5rem 0 0 0;
            opacity: 0.9;
        }

        .form-body {
            padding: 2rem;
        }

        .preview-card {
            background: #f8f9fa;
            border: 2px dashed #d1d5db;
            border-radius: 12px;
            padding: 2rem;
            text-align: center;
            margin-bottom: 2rem;
        }

        .preview-icon {
            width: 80px;
            height: 80px;
            border-radius: 16px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
            color: white;
            font-size: 2rem;
            background-color: #4f46e5;
        }

        .preview-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 0.5rem;
        }

        .preview-description {
            color: #6b7280;
            font-size: 0.875rem;
        }

        .color-palette {
            display: grid;
            grid-template-columns: repeat(6, 1fr);
            gap: 0.75rem;
            margin-top: 0.5rem;
        }

        .color-option {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            border: 3px solid transparent;
            cursor: pointer;
            transition: all 0.2s ease;
            position: relative;
        }

        .color-option:hover {
            transform: scale(1.1);
        }

        .color-option.selected {
            border-color: #1f2937;
            transform: scale(1.1);
        }

        .color-option.selected::after {
            content: '✓';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: white;
            font-weight: bold;
            text-shadow: 0 1px 2px rgba(0,0,0,0.5);
        }

        .icon-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 0.75rem;
            margin-top: 0.5rem;
        }

        .icon-option {
            padding: 0.75rem;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s ease;
            background: white;
        }

        .icon-option:hover {
            border-color: #4f46e5;
            background-color: #f8faff;
        }

        .icon-option.selected {
            border-color: #4f46e5;
            background-color: #4f46e5;
            color: white;
        }

        .icon-option i {
            font-size: 1.5rem;
            margin-bottom: 0.25rem;
        }

        .icon-option span {
            font-size: 0.75rem;
            display: block;
        }

        .form-section {
            margin-bottom: 2rem;
            padding-bottom: 2rem;
            border-bottom: 1px solid #e5e7eb;
        }

        .form-section:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }

        .section-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 0.5rem;
            color: #4f46e5;
        }

        .form-actions {
            background: #f8f9fa;
            padding: 1.5rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .breadcrumb-nav {
            background: transparent;
            padding: 0;
            margin-bottom: 2rem;
        }

        .breadcrumb {
            background: white;
            padding: 1rem 1.5rem;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .breadcrumb-item + .breadcrumb-item::before {
            content: "›";
            color: #6b7280;
        }

        @media (max-width: 768px) {
            .admin-sidebar {
                transform: translateX(-100%);
            }

            .admin-sidebar.show {
                transform: translateX(0);
            }

            .admin-content {
                margin-left: 0;
            }

            .color-palette {
                grid-template-columns: repeat(3, 1fr);
            }

            .icon-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
</head>

<body>
<div class="admin-wrapper">
    <!-- Sidebar Navigation -->
    <aside class="admin-sidebar">
        <div class="sidebar-header">
            <h4 class="mb-0">
                <i class="fas fa-graduation-cap me-2"></i>
                E-Learning Admin
            </h4>
        </div>

        <!-- Navigation Menu -->
        <nav class="sidebar-nav">
            <!-- Tổng quan -->
            <div class="menu-section">
                <div class="menu-title">Tổng quan</div>
                <a href="/admin/dashboard" class="menu-item">
                    <i class="fas fa-tachometer-alt"></i>Dashboard
                </a>
                <a href="/admin/analytics"" class="menu-item">
                    <i class="fas fa-chart-line"></i>Thống kê & Báo cáo
                </a>
            </div>

            <!-- Quản lý người dùng -->
            <div class="menu-section">
                <div class="menu-title">Quản lý người dùng</div>
                <a href="/admin/users"" class="menu-item">
                    <i class="fas fa-users"></i>Tất cả người dùng
                </a>
                <a href="/admin/users?role=INSTRUCTOR"" class="menu-item">
                    <i class="fas fa-chalkboard-teacher"></i>Giảng viên
                </a>
                <a href="/admin/users?role=STUDENT"" class="menu-item">
                    <i class="fas fa-user-graduate"></i>Học viên
                </a>
            </div>

            <!-- Quản lý khóa học -->
            <div class="menu-section">
                <div class="menu-title">Quản lý khóa học</div>
                <a href="/admin/courses"" class="menu-item">
                    <i class="fas fa-book"></i>Tất cả khóa học
                </a>
                <a href="/admin/categories"" class="menu-item active">
                    <i class="fas fa-tags"></i>Danh mục
                </a>
                <a href="/admin/courses?status=pending"" class="menu-item">
                    <i class="fas fa-clock"></i>Chờ duyệt
                </a>
            </div>
        </nav>
    </aside>

    <!-- Main Content -->
    <main class="admin-content">
        <!-- Header -->
        <header class="admin-header">
            <div class="d-flex align-items-center">
                <button class="btn btn-link d-md-none me-2" onclick="toggleSidebar()">
                    <i class="fas fa-bars"></i>
                </button>
                <h1 class="header-title">
                    <c:choose>
                        <c:when test="${empty category.id}">Tạo danh mục mới</c:when>
                        <c:otherwise>Chỉnh sửa danh mục</c:otherwise>
                    </c:choose>
                </h1>
            </div>

            <div class="d-flex align-items-center gap-2">
                <div class="dropdown">
                    <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user me-1"></i>
                        ${currentUser.fullName}
                    </button>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt me-1"></i>Đăng xuất
                        </a></li>
                    </ul>
                </div>
            </div>
        </header>

        <!-- Page Content -->
        <div class="page-content">
            <!-- Breadcrumb -->
            <nav class="breadcrumb-nav">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="/admin/dashboard">
                            <i class="fas fa-home me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="/admin/categories">Danh mục</a>
                    </li>
                    <li class="breadcrumb-item active">
                        <c:choose>
                            <c:when test="${empty category.id}">Tạo mới</c:when>
                            <c:otherwise>Chỉnh sửa</c:otherwise>
                        </c:choose>
                    </li>
                </ol>
            </nav>

            <!-- Alert Messages -->
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Form Container -->
            <div class="form-container">
                <!-- Form Header -->
                <div class="form-header">
                    <h2>
                        <c:choose>
                            <c:when test="${empty category.id}">
                                <i class="fas fa-plus me-2"></i>Tạo danh mục mới
                            </c:when>
                            <c:otherwise>
                                <i class="fas fa-edit me-2"></i>Chỉnh sửa danh mục
                            </c:otherwise>
                        </c:choose>
                    </h2>
                    <p>
                        <c:choose>
                            <c:when test="${empty category.id}">
                                Tạo danh mục mới cho các khóa học trên nền tảng
                            </c:when>
                            <c:otherwise>
                                Cập nhật thông tin danh mục ${category.name}
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>

                <!-- Form Body -->
                <form:form method="POST"
                           action="${empty category.id ? '/admin/categories' : '/admin/categories/'.concat(category.id)}"
                           modelAttribute="category"
                           class="form-body">

                    <!-- Preview Card -->
                    <div class="preview-card">
                        <div class="preview-icon" id="previewIcon"
                             style="background-color: ${not empty category.colorCode ? category.colorCode : '#4f46e5'}">
                            <i class="${not empty category.iconClass ? category.iconClass : 'fas fa-book'}" id="previewIconClass"></i>
                        </div>
                        <div class="preview-title" id="previewTitle">
                                ${not empty category.name ? category.name : 'Tên danh mục'}
                        </div>
                        <div class="preview-description" id="previewDescription">
                                ${not empty category.description ? category.description : 'Mô tả sẽ hiển thị ở đây...'}
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-lg-8">
                            <!-- Thông tin cơ bản -->
                            <div class="form-section">
                                <h3 class="section-title">
                                    <i class="fas fa-info-circle"></i>Thông tin cơ bản
                                </h3>

                                <!-- Tên danh mục -->
                                <div class="mb-3">
                                    <label for="categoryName" class="form-label">
                                        Tên danh mục <span class="text-danger">*</span>
                                    </label>
                                    <form:input path="name"
                                                class="form-control form-control-lg"
                                                id="categoryName"
                                                placeholder="Nhập tên danh mục..."
                                                required="true"
                                                onkeyup="updatePreview()" />
                                    <form:errors path="name" cssClass="text-danger small mt-1 d-block" />
                                    <div class="form-text">Tên danh mục sẽ hiển thị cho người dùng</div>
                                </div>

                                <!-- Mô tả -->
                                <div class="mb-3">
                                    <label for="categoryDescription" class="form-label">Mô tả danh mục</label>
                                    <form:textarea path="description"
                                                   class="form-control"
                                                   id="categoryDescription"
                                                   rows="4"
                                                   placeholder="Mô tả chi tiết về danh mục này..."
                                                   onkeyup="updatePreview()"/>
                                    <form:errors path="description" cssClass="text-danger small mt-1 d-block" />
                                    <div class="form-text">Mô tả ngắn gọn về nội dung danh mục</div>
                                </div>

                                <!-- Slug (tự động tạo) -->
                                <div class="mb-3">
                                    <label for="categorySlug" class="form-label">Slug URL</label>
                                    <form:input path="slug"
                                                class="form-control"
                                                id="categorySlug"
                                                readonly="true" />
                                    <div class="form-text">URL thân thiện, tự động tạo từ tên danh mục</div>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-4">
                            <!-- Giao diện -->
                            <div class="form-section">
                                <h3 class="section-title">
                                    <i class="fas fa-palette"></i>Giao diện
                                </h3>

                                <!-- Màu sắc -->
                                <div class="mb-4">
                                    <label class="form-label">Màu chủ đạo</label>
                                    <div class="color-palette">
                                        <c:forEach var="color" items="#4f46e5,#059669,#d97706,#dc2626,#0891b2,#7c3aed">
                                            <div class="color-option ${category.colorCode eq color ? 'selected' : ''}"
                                                 style="background-color: ${color}"
                                                 onclick="selectColor('${color}')"></div>
                                        </c:forEach>
                                    </div>
                                    <form:input path="colorCode"
                                                type="color"
                                                class="form-control mt-2"
                                                id="categoryColor"
                                                value="${not empty category.colorCode ? category.colorCode : '#4f46e5'}"
                                                onchange="selectCustomColor(this.value)" />
                                    <div class="form-text">Chọn màu hoặc nhập mã màu tùy chỉnh</div>
                                </div>

                                <!-- Icon -->
                                <div class="mb-4">
                                    <label class="form-label">Biểu tượng</label>
                                    <div class="icon-grid">
                                        <c:set var="icons" value="fas fa-book,fas fa-laptop-code,fas fa-paint-brush,fas fa-bullhorn,fas fa-chart-line,fas fa-language,fas fa-music,fas fa-camera" />
                                        <c:set var="iconLabels" value="Sách,Lập trình,Thiết kế,Marketing,Kinh doanh,Ngôn ngữ,Âm nhạc,Nhiếp ảnh" />
                                        <c:forTokens var="icon" items="${icons}" delims="," varStatus="status">
                                            <c:forTokens var="label" items="${iconLabels}" delims="," begin="${status.index}" end="${status.index}">
                                                <div class="icon-option ${category.iconClass eq icon ? 'selected' : ''}"
                                                     onclick="selectIcon('${icon}')">
                                                    <i class="${icon}"></i>
                                                    <span>${label}</span>
                                                </div>
                                            </c:forTokens>
                                        </c:forTokens>
                                    </div>
                                    <form:hidden path="iconClass" id="categoryIcon"
                                                 value="${not empty category.iconClass ? category.iconClass : 'fas fa-book'}" />
                                    <div class="form-text">Chọn biểu tượng đại diện cho danh mục</div>
                                </div>
                            </div>

                            <!-- Cài đặt -->
                            <div class="form-section">
                                <h3 class="section-title">
                                    <i class="fas fa-cog"></i>Cài đặt
                                </h3>

                                <!-- Featured -->
                                <div class="mb-3">
                                    <div class="form-check form-switch">
                                        <form:checkbox path="featured"
                                                       class="form-check-input"
                                                       id="categoryFeatured" />
                                        <label class="form-check-label" for="categoryFeatured">
                                            <i class="fas fa-star text-warning me-1"></i>
                                            Danh mục nổi bật
                                        </label>
                                    </div>
                                    <div class="form-text">Hiển thị trong danh sách danh mục nổi bật</div>
                                </div>

                                <!-- Active -->
                                <div class="mb-3">
                                    <div class="form-check form-switch">
                                        <form:checkbox path="active"
                                                       class="form-check-input"
                                                       id="categoryActive"
                                                       checked="checked" />
                                        <label class="form-check-label" for="categoryActive">
                                            <i class="fas fa-eye text-success me-1"></i>
                                            Kích hoạt danh mục
                                        </label>
                                    </div>
                                    <div class="form-text">Cho phép người dùng xem danh mục này</div>
                                </div>

                                <!-- Sort Order -->
                                <div class="mb-3">
                                    <label for="categorySortOrder" class="form-label">Thứ tự sắp xếp</label>
                                    <form:input path="sortOrder"
                                                type="number"
                                                class="form-control"
                                                id="categorySortOrder"
                                                value="${not empty category.sortOrder ? category.sortOrder : 0}"
                                                min="0"
                                                max="999" />
                                    <div class="form-text">Số thứ tự hiển thị (0 = đầu tiên)</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </form:form>

                <!-- Form Actions -->
                <div class="form-actions">
                    <div>
                        <a href="/admin/categories"" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-1"></i>Quay lại
                        </a>
                    </div>
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-outline-primary" onclick="previewCategory()">
                            <i class="fas fa-eye me-1"></i>Xem trước
                        </button>
                        <button type="submit" form="category" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>
                            <c:choose>
                                <c:when test="${empty category.id}">Tạo danh mục</c:when>
                                <c:otherwise>Cập nhật danh mục</c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // JavaScript cho category form

    // Toggle sidebar trên mobile
    function toggleSidebar() {
        document.querySelector('.admin-sidebar').classList.toggle('show');
    }

    // Cập nhật preview real-time
    function updatePreview() {
        const name = document.getElementById('categoryName').value || 'Tên danh mục';
        const description = document.getElementById('categoryDescription').value || 'Mô tả sẽ hiển thị ở đây...';

        document.getElementById('previewTitle').textContent = name;
        document.getElementById('previewDescription').textContent = description;

        // Tự động tạo slug
        const slug = createSlug(name);
        document.getElementById('categorySlug').value = slug;
    }

    // Tạo slug từ tên
    function createSlug(text) {
        return text
            .toLowerCase()
            .replace(/[áàảãạâấầẩẫậăắằẳẵặ]/g, 'a')
            .replace(/[éèẻẽẹêếềểễệ]/g, 'e')
            .replace(/[íìỉĩị]/g, 'i')
            .replace(/[óòỏõọôốồổỗộơớờởỡợ]/g, 'o')
            .replace(/[úùủũụưứừửữự]/g, 'u')
            .replace(/[ýỳỷỹỵ]/g, 'y')
            .replace(/đ/g, 'd')
            .replace(/[^a-z0-9 -]/g, '')
            .replace(/\s+/g, '-')
            .replace(/-+/g, '-')
            .trim();
    }

    // Chọn màu sắc
    function selectColor(color) {
        // Cập nhật màu trong form
        document.getElementById('categoryColor').value = color;

        // Cập nhật preview
        document.getElementById('previewIcon').style.backgroundColor = color;

        // Cập nhật selected state
        document.querySelectorAll('.color-option').forEach(option => {
            option.classList.remove('selected');
        });
        event.target.classList.add('selected');
    }

    // Chọn màu tùy chỉnh
    function selectCustomColor(color) {
        document.getElementById('previewIcon').style.backgroundColor = color;

        // Bỏ chọn tất cả màu preset
        document.querySelectorAll('.color-option').forEach(option => {
            option.classList.remove('selected');
        });
    }

    // Chọn icon
    function selectIcon(iconClass) {
        // Cập nhật icon trong form
        document.getElementById('categoryIcon').value = iconClass;

        // Cập nhật preview
        document.getElementById('previewIconClass').className = iconClass;

        // Cập nhật selected state
        document.querySelectorAll('.icon-option').forEach(option => {
            option.classList.remove('selected');
        });
        event.target.classList.add('selected');
    }

    // Xem trước danh mục
    function previewCategory() {
        const name = document.getElementById('categoryName').value;
        const description = document.getElementById('categoryDescription').value;
        const color = document.getElementById('categoryColor').value;
        const icon = document.getElementById('categoryIcon').value;

        if (!name) {
            alert('Vui lòng nhập tên danh mục trước khi xem trước');
            return;
        }

        // Tạo modal preview
        const previewModal = `
                <div class="modal fade" id="previewModal" tabindex="-1">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">
                                    <i class="fas fa-eye me-2"></i>Xem trước danh mục
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <div class="category-card" style="max-width: 400px; margin: 0 auto;">
                                    <div class="category-header">
                                        <div class="category-icon" style="background-color: ${color}">
                                            <i class="${icon}"></i>
                                        </div>
                                        <div class="category-info">
                                            <h5>${name}</h5>
                                            <small class="text-muted">Danh mục mới</small>
                                        </div>
                                    </div>
                                    <p class="category-description">
                                        ${description || 'Chưa có mô tả'}
                                    </p>
                                    <div class="category-stats">
                                        <div class="stat-item">
                                            <div class="stat-number">0</div>
                                            <div class="stat-label">Khóa học</div>
                                        </div>
                                        <div class="stat-item">
                                            <div class="stat-number">0</div>
                                            <div class="stat-label">Học viên</div>
                                        </div>
                                        <div class="stat-item">
                                            <div class="stat-number">
                                                <i class="far fa-star text-muted"></i>
                                            </div>
                                            <div class="stat-label">Nổi bật</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            </div>
                        </div>
                    </div>
                </div>
            `;

        // Xóa modal cũ nếu có
        const oldModal = document.getElementById('previewModal');
        if (oldModal) {
            oldModal.remove();
        }

        // Thêm modal mới
        document.body.insertAdjacentHTML('beforeend', previewModal);

        // Hiển thị modal
        new bootstrap.Modal(document.getElementById('previewModal')).show();
    }

    // Khởi tạo khi trang load
    document.addEventListener('DOMContentLoaded', function() {
        // Cập nhật preview ban đầu
        updatePreview();

        // Auto-hide alerts sau 5 giây
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert:not(.alert-permanent)');
            alerts.forEach(alert => {
                alert.style.animation = 'fadeOut 0.5s ease';
                setTimeout(() => alert.remove(), 500);
            });
        }, 5000);
    });

    // Animation cho fade out
    const style = document.createElement('style');
    style.textContent = `
            @keyframes fadeOut {
                from { opacity: 1; transform: translateY(0); }
                to { opacity: 0; transform: translateY(-20px); }
            }

            /* CSS cho category card trong preview */
            .category-card {
                background: white;
                border-radius: 12px;
                padding: 1.5rem;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                border: 1px solid #e5e7eb;
            }

            .category-header {
                display: flex;
                align-items: center;
                margin-bottom: 1rem;
            }

            .category-icon {
                width: 48px;
                height: 48px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 1rem;
                color: white;
                font-size: 1.5rem;
            }

            .category-info h5 {
                font-weight: 600;
                margin: 0;
                color: #1f2937;
            }

            .category-description {
                color: #6b7280;
                font-size: 0.875rem;
                margin-bottom: 1rem;
                line-height: 1.5;
            }

            .category-stats {
                display: flex;
                justify-content: space-between;
            }

            .stat-item {
                text-align: center;
            }

            .stat-number {
                font-size: 1.25rem;
                font-weight: 600;
                color: #1f2937;
            }

            .stat-label {
                font-size: 0.75rem;
                color: #6b7280;
                text-transform: uppercase;
            }
        `;
    document.head.appendChild(style);
</script>
</body>
</html>