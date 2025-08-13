<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm khóa học - Student</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        /* CSS tùy chỉnh cho trang tìm khóa học */
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
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
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

        .search-hero {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 3rem 2rem;
            border-radius: 15px;
            margin-bottom: 2rem;
            text-align: center;
        }

        .search-hero h2 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .search-hero p {
            font-size: 1.2rem;
            opacity: 0.9;
            margin-bottom: 2rem;
        }

        .search-box {
            max-width: 600px;
            margin: 0 auto;
            position: relative;
        }

        .search-input {
            width: 100%;
            padding: 1rem 4rem 1rem 1.5rem;
            border: none;
            border-radius: 50px;
            font-size: 1.1rem;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .search-btn {
            position: absolute;
            right: 8px;
            top: 50%;
            transform: translateY(-50%);
            background: var(--primary-color);
            border: none;
            color: white;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .search-btn:hover {
            background: var(--secondary-color);
            transform: translateY(-50%) scale(1.05);
        }

        .filter-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }

        .category-filter {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
        }

        .category-chip {
            background: #f8f9fa;
            border: 2px solid #e9ecef;
            color: #6c757d;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            text-decoration: none;
            transition: all 0.3s ease;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .category-chip:hover,
        .category-chip.active {
            background: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
            transform: translateY(-2px);
        }

        .course-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .course-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            overflow: hidden;
            border-left: 5px solid var(--primary-color);
        }

        .course-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 25px rgba(0, 0, 0, 0.15);
        }

        .course-thumbnail {
            width: 100%;
            height: 200px;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
            position: relative;
        }

        .course-level {
            position: absolute;
            top: 15px;
            right: 15px;
            background: rgba(255, 255, 255, 0.9);
            color: var(--primary-color);
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .course-category {
            position: absolute;
            top: 15px;
            left: 15px;
            background: var(--warning-color);
            color: white;
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .course-info {
            padding: 1.5rem;
        }

        .course-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 0.5rem;
            line-height: 1.3;
        }

        .course-instructor {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }

        .course-description {
            color: #6c757d;
            font-size: 0.95rem;
            line-height: 1.5;
            margin-bottom: 1rem;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .course-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.85rem;
            color: #6c757d;
            margin-bottom: 1rem;
        }

        .course-stats {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .course-actions {
            padding: 1rem 1.5rem;
            background: #f8f9fa;
            border-top: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            border: none;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }

        .form-control, .form-select {
            border-radius: 8px;
            border: 2px solid #e9ecef;
            transition: border-color 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.25);
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 5rem;
            margin-bottom: 1.5rem;
            opacity: 0.5;
        }

        .pagination {
            justify-content: center;
            margin-top: 2rem;
        }

        .page-link {
            border: none;
            padding: 0.75rem 1rem;
            margin: 0 0.125rem;
            border-radius: 8px;
            font-weight: 500;
            color: var(--primary-color);
        }

        .page-link:hover {
            background: var(--primary-color);
            color: white;
        }

        .page-item.active .page-link {
            background: var(--primary-color);
            border-color: var(--primary-color);
        }

        .filter-summary {
            background: #e7f3ff;
            border: 1px solid #b3d9ff;
            color: #0066cc;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
        }

        .sort-options {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .results-count {
            color: #6c757d;
            font-size: 0.9rem;
        }

        .enrolled-badge {
            background: var(--success-color);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .rating-stars {
            color: var(--warning-color);
        }

        .quick-filters {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }

        .quick-filter {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            color: #6c757d;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            text-decoration: none;
            font-size: 0.85rem;
            transition: all 0.3s ease;
        }

        .quick-filter:hover,
        .quick-filter.active {
            background: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }

        @media (max-width: 768px) {
            .course-grid {
                grid-template-columns: 1fr;
            }

            .search-hero h2 {
                font-size: 2rem;
            }

            .search-hero {
                padding: 2rem 1rem;
            }

            .category-filter {
                justify-content: center;
            }

            .sort-options {
                flex-direction: column;
                align-items: stretch;
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
                <small class="text-white-50">Student Panel</small>
            </div>

            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link" href="/student/dashboard">
                        <i class="fas fa-tachometer-alt me-2"></i>
                        Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="/student/courses">
                        <i class="fas fa-search me-2"></i>
                        Tìm khóa học
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/student/my-courses">
                        <i class="fas fa-book me-2"></i>
                        Khóa học của tôi
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/student/progress">
                        <i class="fas fa-chart-line me-2"></i>
                        Tiến độ học tập
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/student/certificates">
                        <i class="fas fa-certificate me-2"></i>
                        Chứng chỉ
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/student/results">
                        <i class="fas fa-poll me-2"></i>
                        Kết quả bài kiểm tra
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
                        <h1 class="page-title">Tìm khóa học</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="/student/dashboard">Student</a></li>
                                <li class="breadcrumb-item active">Tìm khóa học</li>
                            </ol>
                        </nav>
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

                <!-- Search Hero Section -->
                <div class="search-hero">
                    <h2>Khám phá kiến thức mới</h2>
                    <p>Tìm kiếm trong hàng ngàn khóa học chất lượng cao từ các chuyên gia</p>

                    <form method="get" action="/student/courses" class="search-box">
                        <input type="text"
                               class="search-input"
                               name="search"
                               placeholder="Tìm kiếm khóa học, chủ đề, kỹ năng..."
                               value="${search}">
                        <button type="submit" class="search-btn">
                            <i class="fas fa-search"></i>
                        </button>

                        <!-- Preserve other filter parameters -->
                        <c:if test="${not empty categoryFilter}">
                            <input type="hidden" name="category" value="${categoryFilter}">
                        </c:if>
                        <c:if test="${not empty levelFilter}">
                            <input type="hidden" name="level" value="${levelFilter}">
                        </c:if>
                        <c:if test="${not empty sortBy}">
                            <input type="hidden" name="sort" value="${sortBy}">
                        </c:if>
                    </form>
                </div>

                <!-- Filter Section -->
                <div class="filter-card">
                    <!-- Category Filter -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">
                            <i class="fas fa-tags me-2"></i>Danh mục
                        </label>
                        <div class="category-filter">
                            <a href="/student/courses"
                               class="category-chip ${empty categoryFilter ? 'active' : ''}">
                                Tất cả
                            </a>
                            <c:forEach items="${categories}" var="category">
                                <a href="/student/courses?category=${category.id}&search=${search}&level=${levelFilter}&sort=${sortBy}"
                                   class="category-chip ${categoryFilter == category.id ? 'active' : ''}">
                                    <i class="${category.iconClass} me-1"></i>
                                        ${category.name}
                                </a>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Quick Filters -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">
                            <i class="fas fa-filter me-2"></i>Lọc nhanh
                        </label>
                        <div class="quick-filters">
                            <a href="/student/courses?level=BEGINNER&search=${search}&category=${categoryFilter}&sort=${sortBy}"
                               class="quick-filter ${levelFilter == 'BEGINNER' ? 'active' : ''}">
                                <i class="fas fa-seedling me-1"></i>Cơ bản
                            </a>
                            <a href="/student/courses?level=INTERMEDIATE&search=${search}&category=${categoryFilter}&sort=${sortBy}"
                               class="quick-filter ${levelFilter == 'INTERMEDIATE' ? 'active' : ''}">
                                <i class="fas fa-layer-group me-1"></i>Trung cấp
                            </a>
                            <a href="/student/courses?level=ADVANCED&search=${search}&category=${categoryFilter}&sort=${sortBy}"
                               class="quick-filter ${levelFilter == 'ADVANCED' ? 'active' : ''}">
                                <i class="fas fa-rocket me-1"></i>Nâng cao
                            </a>
                            <a href="/student/courses?featured=true&search=${search}&category=${categoryFilter}&sort=${sortBy}"
                               class="quick-filter">
                                <i class="fas fa-star me-1"></i>Nổi bật
                            </a>
                            <a href="/student/courses?new=true&search=${search}&category=${categoryFilter}&sort=${sortBy}"
                               class="quick-filter">
                                <i class="fas fa-sparkles me-1"></i>Mới nhất
                            </a>
                        </div>
                    </div>

                    <!-- Sort and Results Info -->
                    <div class="sort-options">
                        <div class="results-count">
                            Tìm thấy <strong>${courses.size()}</strong> khóa học
                            <c:if test="${not empty search || not empty categoryFilter || not empty levelFilter}">
                                phù hợp với bộ lọc
                            </c:if>
                        </div>

                        <div class="ms-auto">
                            <form method="get" action="/student/courses" class="d-flex align-items-center">
                                <!-- Preserve search and filter parameters -->
                                <c:if test="${not empty search}">
                                    <input type="hidden" name="search" value="${search}">
                                </c:if>
                                <c:if test="${not empty categoryFilter}">
                                    <input type="hidden" name="category" value="${categoryFilter}">
                                </c:if>
                                <c:if test="${not empty levelFilter}">
                                    <input type="hidden" name="level" value="${levelFilter}">
                                </c:if>

                                <label class="form-label me-2 mb-0">Sắp xếp:</label>
                                <select name="sort" class="form-select" style="width: auto;" onchange="this.form.submit()">
                                    <option value="newest" ${sortBy == 'newest' ? 'selected' : ''}>Mới nhất</option>
                                    <option value="popular" ${sortBy == 'popular' ? 'selected' : ''}>Phổ biến</option>
                                    <option value="name" ${sortBy == 'name' ? 'selected' : ''}>Tên A-Z</option>
                                    <option value="rating" ${sortBy == 'rating' ? 'selected' : ''}>Đánh giá cao</option>
                                </select>
                            </form>
                        </div>
                    </div>

                    <!-- Active Filters Summary -->
                    <c:if test="${not empty search || not empty categoryFilter || not empty levelFilter}">
                        <div class="filter-summary">
                            <strong>Bộ lọc đang áp dụng:</strong>
                            <c:if test="${not empty search}">
                                <span class="me-2">Từ khóa: "${search}"</span>
                            </c:if>
                            <c:if test="${not empty categoryFilter}">
                                <span class="me-2">Danh mục: ${selectedCategory.name}</span>
                            </c:if>
                            <c:if test="${not empty levelFilter}">
                                <span class="me-2">Độ khó:
                                    <c:choose>
                                        <c:when test="${levelFilter == 'BEGINNER'}">Cơ bản</c:when>
                                        <c:when test="${levelFilter == 'INTERMEDIATE'}">Trung cấp</c:when>
                                        <c:when test="${levelFilter == 'ADVANCED'}">Nâng cao</c:when>
                                    </c:choose>
                                </span>
                            </c:if>
                            <a href="/student/courses" class="text-decoration-none">
                                <i class="fas fa-times-circle me-1"></i>Xóa bộ lọc
                            </a>
                        </div>
                    </c:if>
                </div>

                <!-- Courses Grid -->
                <c:choose>
                    <c:when test="${not empty courses}">
                        <div class="course-grid">
                            <c:forEach items="${courses}" var="course">
                                <div class="course-card">
                                    <!-- Course Thumbnail -->
                                    <div class="course-thumbnail">
                                        <span class="course-category">${course.category.name}</span>
                                        <span class="course-level">
                                            <c:choose>
                                                <c:when test="${course.level == 'BEGINNER'}">Cơ bản</c:when>
                                                <c:when test="${course.level == 'INTERMEDIATE'}">Trung cấp</c:when>
                                                <c:when test="${course.level == 'ADVANCED'}">Nâng cao</c:when>
                                                <c:otherwise>Tất cả</c:otherwise>
                                            </c:choose>
                                        </span>
                                        <i class="fas fa-book"></i>
                                    </div>

                                    <!-- Course Info -->
                                    <div class="course-info">
                                        <h5 class="course-title">${course.name}</h5>
                                        <p class="course-instructor">
                                            <i class="fas fa-user me-1"></i>
                                                ${course.instructor.username}
                                        </p>
                                        <p class="course-description">${course.description}</p>

                                        <div class="course-meta">
                                            <div class="course-stats">
                                                <span>
                                                    <i class="fas fa-users me-1"></i>
                                                    ${course.enrollmentCount} học viên
                                                </span>
                                                <span>
                                                    <i class="fas fa-play-circle me-1"></i>
                                                    ${course.lessonCount} bài giảng
                                                </span>
                                                <c:if test="${course.estimatedDuration > 0}">
                                                    <span>
                                                        <i class="fas fa-clock me-1"></i>
                                                        ${course.estimatedDuration} giờ
                                                    </span>
                                                </c:if>
                                            </div>

                                            <div class="rating-stars">
                                                <c:forEach begin="1" end="5" var="star">
                                                    <i class="fas fa-star"></i>
                                                </c:forEach>
                                                <small class="text-muted">(4.8)</small>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Course Actions -->
                                    <div class="course-actions">
                                        <div>
                                            <small class="text-muted">
                                                <i class="fas fa-calendar me-1"></i>
                                                <fmt:formatDate value="${course.createdAt}" pattern="dd/MM/yyyy"/>
                                            </small>
                                        </div>

                                        <div>
                                            <!-- Kiểm tra xem đã đăng ký chưa -->
                                            <c:set var="isEnrolled" value="false"/>
                                            <c:forEach items="${enrolledCourseIds}" var="enrolledId">
                                                <c:if test="${enrolledId == course.id}">
                                                    <c:set var="isEnrolled" value="true"/>
                                                </c:if>
                                            </c:forEach>

                                            <c:choose>
                                                <c:when test="${isEnrolled}">
                                                    <span class="enrolled-badge me-2">
                                                        <i class="fas fa-check me-1"></i>Đã đăng ký
                                                    </span>
                                                    <a href="/student/my-courses/${course.id}"
                                                       class="btn btn-outline-primary btn-sm">
                                                        <i class="fas fa-play me-1"></i>Học ngay
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="/student/courses/${course.id}"
                                                       class="btn btn-outline-primary btn-sm me-2">
                                                        <i class="fas fa-eye me-1"></i>Xem chi tiết
                                                    </a>
                                                    <form method="post"
                                                          action="/student/courses/${course.id}/enroll"
                                                          class="d-inline">
                                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                        <button type="submit" class="btn btn-primary-custom btn-sm">
                                                            <i class="fas fa-plus me-1"></i>Đăng ký
                                                        </button>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Pagination (nếu cần) -->
                        <nav aria-label="Course pagination" class="mt-4">
                            <ul class="pagination">
                                <li class="page-item disabled">
                                    <a class="page-link" href="#" aria-label="Previous">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>
                                <li class="page-item active">
                                    <a class="page-link" href="#">1</a>
                                </li>
                                <li class="page-item">
                                    <a class="page-link" href="#">2</a>
                                </li>
                                <li class="page-item">
                                    <a class="page-link" href="#">3</a>
                                </li>
                                <li class="page-item">
                                    <a class="page-link" href="#" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-search"></i>
                            <h4>Không tìm thấy khóa học nào</h4>
                            <p class="mb-4">
                                <c:choose>
                                    <c:when test="${not empty search || not empty categoryFilter || not empty levelFilter}">
                                        Không có khóa học nào phù hợp với điều kiện tìm kiếm của bạn.
                                        <br>Hãy thử điều chỉnh bộ lọc hoặc từ khóa tìm kiếm.
                                    </c:when>
                                    <c:otherwise>
                                        Hiện tại chưa có khóa học nào trong hệ thống.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <c:if test="${not empty search || not empty categoryFilter || not empty levelFilter}">
                                <a href="/student/courses" class="btn btn-primary-custom">
                                    <i class="fas fa-refresh me-2"></i>Xem tất cả khóa học
                                </a>
                            </c:if>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JavaScript -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Animation cho course cards khi load
        const courseCards = document.querySelectorAll('.course-card');
        courseCards.forEach((card, index) => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            card.style.transition = 'all 0.6s ease';

            setTimeout(() => {
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, index * 100);
        });

        // Smooth scroll cho anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth'
                    });
                }
            });
        });

        // Tự động ẩn alerts
        setTimeout(function() {
            document.querySelectorAll('.alert').forEach(alert => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);

        // Highlight search terms
        const searchTerm = '${search}';
        if (searchTerm) {
            const regex = new RegExp(`(${searchTerm})`, 'gi');
            document.querySelectorAll('.course-title, .course-description').forEach(element => {
                element.innerHTML = element.innerHTML.replace(regex, '<mark>$1</mark>');
            });
        }

        // Loading animation cho enroll forms
        document.querySelectorAll('form[action*="/enroll"]').forEach(form => {
            form.addEventListener('submit', function() {
                const button = this.querySelector('button[type="submit"]');
                button.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang đăng ký...';
                button.disabled = true;
            });
        });

        // Lazy loading cho course thumbnails (if needed)
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('loaded');
                }
            });
        });

        document.querySelectorAll('.course-thumbnail').forEach(thumbnail => {
            observer.observe(thumbnail);
        });

        // Bookmark functionality (for future implementation)
        document.querySelectorAll('[data-bookmark]').forEach(button => {
            button.addEventListener('click', function(e) {
                e.preventDefault();
                // Toggle bookmark state
                this.classList.toggle('bookmarked');
                const icon = this.querySelector('i');
                icon.className = this.classList.contains('bookmarked') ?
                    'fas fa-bookmark' : 'far fa-bookmark';
            });
        });
    });

    // Search suggestions (for future enhancement)
    function initSearchSuggestions() {
        const searchInput = document.querySelector('.search-input');
        if (!searchInput) return;

        searchInput.addEventListener('input', function() {
            const query = this.value.trim();
            if (query.length > 2) {
                // Fetch search suggestions via AJAX
                // Implementation for autocomplete
            }
        });
    }

    // Filter persistence in localStorage
    function saveFilters() {
        const filters = {
            search: new URLSearchParams(window.location.search).get('search') || '',
            category: new URLSearchParams(window.location.search).get('category') || '',
            level: new URLSearchParams(window.location.search).get('level') || '',
            sort: new URLSearchParams(window.location.search).get('sort') || 'newest'
        };
        localStorage.setItem('courseFilters', JSON.stringify(filters));
    }

    // Call on page load
    saveFilters();
</script>

</body>
</html>