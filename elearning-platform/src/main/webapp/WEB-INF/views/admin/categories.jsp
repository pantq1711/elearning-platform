<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý danh mục - Admin Panel</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        /* CSS dành cho admin categories page */
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

        .category-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-top: 1.5rem;
        }

        .category-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            border: 1px solid #e5e7eb;
        }

        .category-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
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
            margin-bottom: 1rem;
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

        .category-actions {
            display: flex;
            gap: 0.5rem;
            padding-top: 1rem;
            border-top: 1px solid #e5e7eb;
        }

        .btn-sm {
            padding: 0.375rem 0.75rem;
            font-size: 0.875rem;
        }

        .quick-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            border: 1px solid #e5e7eb;
        }

        .stat-card h3 {
            font-size: 2rem;
            font-weight: 700;
            margin: 0;
            color: #1f2937;
        }

        .stat-card p {
            color: #6b7280;
            margin: 0;
            font-size: 0.875rem;
        }

        .create-category-card {
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
            color: white;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 200px;
            cursor: pointer;
            transition: transform 0.2s ease;
        }

        .create-category-card:hover {
            transform: translateY(-2px);
        }

        .create-category-card i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.8;
        }

        .create-category-card h5 {
            color: white;
            font-weight: 600;
        }

        .color-picker {
            display: inline-block;
            width: 30px;
            height: 30px;
            border-radius: 6px;
            border: 2px solid #e5e7eb;
            cursor: pointer;
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

            .category-grid {
                grid-template-columns: 1fr;
            }

            .quick-stats {
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
                <h1 class="header-title">Quản lý danh mục</h1>
            </div>

            <div class="d-flex align-items-center gap-2">
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createCategoryModal">
                    <i class="fas fa-plus me-1"></i>Tạo danh mục mới
                </button>
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

            <!-- Quick Stats -->
            <div class="quick-stats">
                <div class="stat-card">
                    <h3>${totalCategories}</h3>
                    <p>Tổng số danh mục</p>
                </div>
                <div class="stat-card">
                    <h3>${totalCoursesInCategories}</h3>
                    <p>Tổng khóa học</p>
                </div>
                <div class="stat-card">
                    <h3><fmt:formatNumber value="${averageCoursesPerCategory}" maxFractionDigits="1" /></h3>
                    <p>Trung bình khóa học/danh mục</p>
                </div>
                <div class="stat-card">
                    <h3>${totalEnrollmentsInCategories}</h3>
                    <p>Tổng lượt đăng ký</p>
                </div>
            </div>

            <!-- Categories Grid -->
            <div class="category-grid">
                <!-- Create New Category Card -->
                <div class="category-card create-category-card" data-bs-toggle="modal" data-bs-target="#createCategoryModal">
                    <i class="fas fa-plus"></i>
                    <h5>Tạo danh mục mới</h5>
                    <p class="mb-0">Thêm danh mục khóa học</p>
                </div>

                <!-- Existing Categories -->
                <c:forEach var="category" items="${categories}">
                    <div class="category-card">
                        <div class="category-header">
                            <div class="category-icon" style="background-color: ${category.colorCode}">
                                <i class="${not empty category.iconClass ? category.iconClass : 'fas fa-book'}"></i>
                            </div>
                            <div class="category-info">
                                <h5>${category.name}</h5>
                                <small class="text-muted">
                                    Tạo: <fmt:formatDate value="${category.createdAt}" pattern="dd/MM/yyyy" />
                                </small>
                            </div>
                        </div>

                        <p class="category-description">
                                ${not empty category.description ? category.description : 'Chưa có mô tả'}
                        </p>

                        <div class="category-stats">
                            <div class="stat-item">
                                <div class="stat-number">${category.courseCount}</div>
                                <div class="stat-label">Khóa học</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-number">
                                    <c:set var="totalEnrollments" value="0" />
                                    <c:forEach var="course" items="${category.courses}">
                                        <c:set var="totalEnrollments" value="${totalEnrollments + fn:length(course.enrollments)}" />
                                    </c:forEach>
                                        ${totalEnrollments}
                                </div>
                                <div class="stat-label">Học viên</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-number">
                                    <c:choose>
                                        <c:when test="${category.featured}">
                                            <i class="fas fa-star text-warning"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="far fa-star text-muted"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="stat-label">Nổi bật</div>
                            </div>
                        </div>

                        <div class="category-actions">
                            <button type="button"
                                    class="btn btn-outline-primary btn-sm flex-fill"
                                    onclick="editCategory(${category.id})">
                                <i class="fas fa-edit me-1"></i>Sửa
                            </button>
                            <button type="button"
                                    class="btn btn-outline-danger btn-sm"
                                    onclick="deleteCategory(${category.id}, '${category.name}', ${category.courseCount})">
                                <i class="fas fa-trash me-1"></i>Xóa
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </main>
</div>

<!-- Create Category Modal -->
<div class="modal fade" id="createCategoryModal" tabindex="-1" aria-labelledby="createCategoryModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="createCategoryModalLabel">
                    <i class="fas fa-plus me-2"></i>Tạo danh mục mới
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form:form method="POST" action="admin/categories" modelAttribute="newCategory">                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-8">
                            <!-- Tên danh mục -->
                            <div class="mb-3">
                                <label for="categoryName" class="form-label">Tên danh mục *</label>
                                <form:input path="name" class="form-control" id="categoryName"
                                            placeholder="Nhập tên danh mục..." required="true" />
                                <form:errors path="name" cssClass="text-danger small" />
                            </div>

                            <!-- Mô tả -->
                            <div class="mb-3">
                                <label for="categoryDescription" class="form-label">Mô tả</label>
                                <form:textarea path="description" class="form-control" id="categoryDescription"
                                               rows="3" placeholder="Mô tả chi tiết về danh mục..."/>
                                <form:errors path="description" cssClass="text-danger small" />
                            </div>
                        </div>

                        <div class="col-md-4">
                            <!-- Màu sắc -->
                            <div class="mb-3">
                                <label for="categoryColor" class="form-label">Màu sắc</label>
                                <div class="d-flex gap-2 mb-2">
                                    <c:forEach var="color" items="#4f46e5,#059669,#d97706,#dc2626,#0891b2,#7c3aed">
                                        <div class="color-picker"
                                             style="background-color: ${color}"
                                             onclick="selectColor('${color}')"></div>
                                    </c:forEach>
                                </div>
                                <form:input path="colorCode" class="form-control" id="categoryColor"
                                            value="#4f46e5" type="color" />
                            </div>

                            <!-- Icon -->
                            <div class="mb-3">
                                <label for="categoryIcon" class="form-label">Icon</label>
                                <form:select path="iconClass" class="form-control" id="categoryIcon">
                                    <form:option value="fas fa-book">📚 Sách</form:option>
                                    <form:option value="fas fa-laptop-code">💻 Lập trình</form:option>
                                    <form:option value="fas fa-paint-brush">🎨 Thiết kế</form:option>
                                    <form:option value="fas fa-bullhorn">📢 Marketing</form:option>
                                    <form:option value="fas fa-chart-line">📈 Kinh doanh</form:option>
                                    <form:option value="fas fa-language">🌐 Ngôn ngữ</form:option>
                                    <form:option value="fas fa-music">🎵 Âm nhạc</form:option>
                                    <form:option value="fas fa-camera">📷 Nhiếp ảnh</form:option>
                                </form:select>
                            </div>

                            <!-- Featured checkbox -->
                            <div class="mb-3">
                                <div class="form-check">
                                    <form:checkbox path="featured" class="form-check-input" id="categoryFeatured" />
                                    <label class="form-check-label" for="categoryFeatured">
                                        Danh mục nổi bật
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i>Tạo danh mục
                    </button>
                </div>
            </form:form>
        </div>
    </div>
</div>

<!-- Edit Category Modal -->
<div class="modal fade" id="editCategoryModal" tabindex="-1" aria-labelledby="editCategoryModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editCategoryModalLabel">
                    <i class="fas fa-edit me-2"></i>Chỉnh sửa danh mục
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form id="editCategoryForm" method="POST">
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-8">
                            <!-- Tên danh mục -->
                            <div class="mb-3">
                                <label for="editCategoryName" class="form-label">Tên danh mục *</label>
                                <input type="text" class="form-control" id="editCategoryName" name="name" required>
                            </div>

                            <!-- Mô tả -->
                            <div class="mb-3">
                                <label for="editCategoryDescription" class="form-label">Mô tả</label>
                                <textarea class="form-control" id="editCategoryDescription" name="description" rows="3"></textarea>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <!-- Màu sắc -->
                            <div class="mb-3">
                                <label for="editCategoryColor" class="form-label">Màu sắc</label>
                                <input type="color" class="form-control" id="editCategoryColor" name="colorCode">
                            </div>

                            <!-- Icon -->
                            <div class="mb-3">
                                <label for="editCategoryIcon" class="form-label">Icon</label>
                                <select class="form-control" id="editCategoryIcon" name="iconClass">
                                    <option value="fas fa-book">📚 Sách</option>
                                    <option value="fas fa-laptop-code">💻 Lập trình</option>
                                    <option value="fas fa-paint-brush">🎨 Thiết kế</option>
                                    <option value="fas fa-bullhorn">📢 Marketing</option>
                                    <option value="fas fa-chart-line">📈 Kinh doanh</option>
                                    <option value="fas fa-language">🌐 Ngôn ngữ</option>
                                    <option value="fas fa-music">🎵 Âm nhạc</option>
                                    <option value="fas fa-camera">📷 Nhiếp ảnh</option>
                                </select>
                            </div>

                            <!-- Featured checkbox -->
                            <div class="mb-3">
                                <div class="form-check">
                                    <input type="checkbox" class="form-check-input" id="editCategoryFeatured" name="featured">
                                    <label class="form-check-label" for="editCategoryFeatured">
                                        Danh mục nổi bật
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i>Cập nhật
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteCategoryModal" tabindex="-1" aria-labelledby="deleteCategoryModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title text-danger" id="deleteCategoryModalLabel">
                    <i class="fas fa-exclamation-triangle me-2"></i>Xác nhận xóa
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Bạn có chắc chắn muốn xóa danh mục <strong id="deleteCategoryName"></strong>?</p>
                <div id="deleteCategoryWarning" class="alert alert-warning" style="display: none;">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    Danh mục này đang có <span id="deleteCourseCount"></span> khóa học.
                    Vui lòng di chuyển các khóa học trước khi xóa.
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <form id="deleteCategoryForm" method="POST" style="display: inline;">
                    <button type="submit" class="btn btn-danger" id="confirmDeleteBtn">
                        <i class="fas fa-trash me-1"></i>Xóa danh mục
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // JavaScript cho quản lý danh mục

    // Toggle sidebar trên mobile
    function toggleSidebar() {
        document.querySelector('.admin-sidebar').classList.toggle('show');
    }

    // Chọn màu sắc
    function selectColor(color) {
        document.getElementById('categoryColor').value = color;
        // Highlight selected color
        document.querySelectorAll('.color-picker').forEach(picker => {
            picker.style.border = '2px solid #e5e7eb';
        });
        event.target.style.border = '2px solid #000';
    }

    // Chỉnh sửa danh mục
    function editCategory(categoryId) {
        // Lấy thông tin category từ server
        fetch(`/admin/categories/${categoryId}/edit`)
            .then(response => response.json())
            .then(data => {
                // Điền dữ liệu vào form
                document.getElementById('editCategoryName').value = data.name;
                document.getElementById('editCategoryDescription').value = data.description || '';
                document.getElementById('editCategoryColor').value = data.colorCode || '#4f46e5';
                document.getElementById('editCategoryIcon').value = data.iconClass || 'fas fa-book';
                document.getElementById('editCategoryFeatured').checked = data.featured || false;

                // Set form action
                document.getElementById('editCategoryForm').action = `/admin/categories/${categoryId}`;

                // Hiển thị modal
                new bootstrap.Modal(document.getElementById('editCategoryModal')).show();
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra khi tải thông tin danh mục');
            });
    }

    // Xóa danh mục
    function deleteCategory(categoryId, categoryName, courseCount) {
        document.getElementById('deleteCategoryName').textContent = categoryName;
        document.getElementById('deleteCategoryForm').action = `/admin/categories/${categoryId}/delete`;

        // Kiểm tra nếu có khóa học trong danh mục
        if (courseCount > 0) {
            document.getElementById('deleteCourseCount').textContent = courseCount;
            document.getElementById('deleteCategoryWarning').style.display = 'block';
            document.getElementById('confirmDeleteBtn').disabled = true;
            document.getElementById('confirmDeleteBtn').innerHTML =
                '<i class="fas fa-ban me-1"></i>Không thể xóa';
        } else {
            document.getElementById('deleteCategoryWarning').style.display = 'none';
            document.getElementById('confirmDeleteBtn').disabled = false;
            document.getElementById('confirmDeleteBtn').innerHTML =
                '<i class="fas fa-trash me-1"></i>Xóa danh mục';
        }

        new bootstrap.Modal(document.getElementById('deleteCategoryModal')).show();
    }

    // Auto-hide alerts sau 5 giây
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert:not(.alert-permanent)');
        alerts.forEach(alert => {
            alert.style.animation = 'fadeOut 0.5s ease';
            setTimeout(() => alert.remove(), 500);
        });
    }, 5000);

    // Animation cho fade out
    const style = document.createElement('style');
    style.textContent = `
            @keyframes fadeOut {
                from { opacity: 1; transform: translateY(0); }
                to { opacity: 0; transform: translateY(-20px); }
            }
        `;
    document.head.appendChild(style);
</script>
</body>
</html>