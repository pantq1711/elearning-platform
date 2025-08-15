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
    <title>Khóa Học - EduLearn Platform</title>

    <!-- Meta tags cho SEO -->
    <meta name="description" content="Khám phá hàng nghìn khóa học trực tuyến chất lượng cao tại EduLearn Platform. Lập trình, Thiết kế, Kinh doanh, Marketing và nhiều lĩnh vực khác.">
    <meta name="keywords" content="khóa học online, học trực tuyến, lập trình, thiết kế, kinh doanh, marketing, EduLearn">

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

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
            --card-shadow-hover: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--light-bg);
        }

        .page-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 4rem 0 2rem;
        }

        .breadcrumb {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 0.5rem;
            padding: 0.75rem 1rem;
        }

        .breadcrumb-item a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
        }

        .breadcrumb-item.active {
            color: white;
        }

        .filter-sidebar {
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            padding: 1.5rem;
            height: fit-content;
            position: sticky;
            top: 100px;
        }

        .filter-section {
            margin-bottom: 2rem;
        }

        .filter-section:last-child {
            margin-bottom: 0;
        }

        .filter-title {
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }

        .filter-title i {
            margin-right: 0.5rem;
            color: var(--primary-color);
        }

        .form-check {
            margin-bottom: 0.75rem;
        }

        .form-check-input:checked {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .form-check-label {
            color: #4b5563;
            font-weight: 500;
        }

        .course-count {
            color: #9ca3af;
            font-size: 0.875rem;
            margin-left: auto;
        }

        .price-range {
            margin-top: 1rem;
        }

        .price-inputs {
            display: flex;
            gap: 0.5rem;
            align-items: center;
        }

        .price-inputs input {
            flex: 1;
            font-size: 0.875rem;
        }

        .courses-container {
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            overflow: hidden;
        }

        .courses-header {
            background: #f9fafb;
            padding: 1.5rem;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .results-info {
            color: #4b5563;
            font-weight: 500;
        }

        .sort-controls {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .view-toggle {
            display: flex;
            background: #e5e7eb;
            border-radius: 0.5rem;
            padding: 0.25rem;
        }

        .view-toggle button {
            background: none;
            border: none;
            padding: 0.5rem;
            border-radius: 0.25rem;
            color: #6b7280;
            cursor: pointer;
            transition: all 0.2s;
        }

        .view-toggle button.active {
            background: white;
            color: var(--primary-color);
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
        }

        .courses-grid {
            padding: 1.5rem;
        }

        .course-card {
            background: white;
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: var(--card-shadow);
            transition: all 0.3s ease;
            height: 100%;
            border: 1px solid #e5e7eb;
        }

        .course-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--card-shadow-hover);
        }

        .course-image {
            position: relative;
            overflow: hidden;
            height: 200px;
        }

        .course-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .course-card:hover .course-image img {
            transform: scale(1.05);
        }

        .course-badges {
            position: absolute;
            top: 1rem;
            left: 1rem;
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .course-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 2rem;
            font-size: 0.75rem;
            font-weight: 600;
            background: rgba(255, 255, 255, 0.95);
            color: var(--primary-color);
        }

        .badge-featured {
            background: var(--primary-color);
            color: white;
        }

        .badge-free {
            background: var(--success-color);
            color: white;
        }

        .badge-bestseller {
            background: var(--warning-color);
            color: white;
        }

        .course-content {
            padding: 1.5rem;
        }

        .course-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.75rem;
            font-size: 0.875rem;
            color: #6b7280;
        }

        .course-category {
            background: var(--primary-color);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-weight: 500;
        }

        .course-duration {
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .course-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 0.75rem;
            line-height: 1.4;
        }

        .course-title a {
            color: inherit;
            text-decoration: none;
        }

        .course-title a:hover {
            color: var(--primary-color);
        }

        .course-description {
            color: #6b7280;
            font-size: 0.875rem;
            line-height: 1.6;
            margin-bottom: 1rem;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .course-instructor {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #f3f4f6;
        }

        .instructor-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            margin-right: 0.75rem;
            object-fit: cover;
        }

        .instructor-name {
            font-weight: 500;
            color: #374151;
            font-size: 0.875rem;
        }

        .course-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .course-rating {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .stars {
            display: flex;
            gap: 0.125rem;
        }

        .stars i {
            font-size: 0.875rem;
        }

        .rating-text {
            font-size: 0.75rem;
            color: #6b7280;
        }

        .course-price {
            text-align: right;
        }

        .price-current {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--primary-color);
        }

        .price-original {
            font-size: 0.875rem;
            color: #9ca3af;
            text-decoration: line-through;
            display: block;
        }

        .price-free {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--success-color);
        }

        .course-list .course-card {
            display: flex;
            margin-bottom: 1.5rem;
        }

        .course-list .course-image {
            width: 280px;
            flex-shrink: 0;
        }

        .course-list .course-content {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .pagination-container {
            padding: 2rem;
            display: flex;
            justify-content: center;
        }

        .pagination {
            margin: 0;
        }

        .page-link {
            color: var(--primary-color);
            border-color: #e5e7eb;
        }

        .page-link:hover {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }

        .page-item.active .page-link {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .filter-mobile {
            display: none;
        }

        .mobile-filter-btn {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 0.75rem 1rem;
            border-radius: 0.5rem;
            font-weight: 500;
        }

        .clear-filters {
            background: #f3f4f6;
            color: #374151;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-size: 0.875rem;
            width: 100%;
            margin-top: 1rem;
        }

        .no-courses {
            text-align: center;
            padding: 4rem 2rem;
            color: #6b7280;
        }

        .no-courses i {
            font-size: 4rem;
            color: #d1d5db;
            margin-bottom: 1rem;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .filter-sidebar {
                display: none;
            }

            .filter-mobile {
                display: block;
                margin-bottom: 1rem;
            }

            .courses-header {
                flex-direction: column;
                align-items: stretch;
            }

            .sort-controls {
                justify-content: space-between;
            }

            .course-list .course-card {
                flex-direction: column;
            }

            .course-list .course-image {
                width: 100%;
                height: 200px;
            }
        }
    </style>
</head>

<body>
<!-- Include Header -->
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<!-- Page Header -->
<section class="page-header">
    <div class="container">
        <div class="row">
            <div class="col-12">
                <!-- Breadcrumb -->
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/">
                                <i class="fas fa-home me-1"></i>Trang chủ
                            </a>
                        </li>
                        <li class="breadcrumb-item active">Khóa học</li>
                    </ol>
                </nav>

                <h1 class="display-4 fw-bold mb-3">Khám Phá Khóa Học</h1>
                <p class="lead mb-0">
                    Tìm kiếm khóa học phù hợp với mục tiêu học tập của bạn từ hơn ${totalCourses} khóa học chất lượng cao
                </p>
            </div>
        </div>
    </div>
</section>

<!-- Main Content -->
<section class="py-5">
    <div class="container">
        <div class="row">
            <!-- Sidebar Filters -->
            <div class="col-lg-3">
                <!-- Mobile Filter Button -->
                <div class="filter-mobile">
                    <button class="mobile-filter-btn w-100" data-bs-toggle="modal" data-bs-target="#filterModal">
                        <i class="fas fa-filter me-2"></i>Bộ lọc
                    </button>
                </div>

                <!-- Desktop Filter Sidebar -->
                <div class="filter-sidebar" id="filterSidebar">
                    <h5 class="fw-bold mb-3">
                        <i class="fas fa-sliders-h me-2"></i>Bộ Lọc
                    </h5>

                    <form method="GET" action="/courses" id="filterForm">
                        <!-- Search Input (Hidden, maintained from URL) -->
                        <input type="hidden" name="search" value="${param.search}">

                        <!-- Category Filter -->
                        <div class="filter-section">
                            <h6 class="filter-title">
                                <i class="fas fa-tags"></i>Danh Mục
                            </h6>
                            <c:forEach items="${categories}" var="category">
                                <div class="form-check d-flex justify-content-between align-items-center">
                                    <div>
                                        <input class="form-check-input" type="checkbox"
                                               name="categories" value="${category.name}"
                                               id="cat_${category.id}"
                                            ${fn:contains(paramValues.categories, category.name) ? 'checked' : ''}>
                                        <label class="form-check-label" for="cat_${category.id}">
                                                ${category.name}
                                        </label>
                                    </div>
                                    <span class="course-count">${category.courseCount}</span>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Level Filter -->
                        <div class="filter-section">
                            <h6 class="filter-title">
                                <i class="fas fa-layer-group"></i>Mức Độ
                            </h6>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox"
                                       name="levels" value="BEGINNER" id="level_beginner"
                                ${fn:contains(paramValues.levels, 'BEGINNER') ? 'checked' : ''}>
                                <label class="form-check-label" for="level_beginner">
                                    Cơ bản
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox"
                                       name="levels" value="INTERMEDIATE" id="level_intermediate"
                                ${fn:contains(paramValues.levels, 'INTERMEDIATE') ? 'checked' : ''}>
                                <label class="form-check-label" for="level_intermediate">
                                    Trung cấp
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox"
                                       name="levels" value="ADVANCED" id="level_advanced"
                                ${fn:contains(paramValues.levels, 'ADVANCED') ? 'checked' : ''}>
                                <label class="form-check-label" for="level_advanced">
                                    Nâng cao
                                </label>
                            </div>
                        </div>

                        <!-- Price Filter -->
                        <div class="filter-section">
                            <h6 class="filter-title">
                                <i class="fas fa-dollar-sign"></i>Giá
                            </h6>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox"
                                       name="isFree" value="true" id="price_free"
                                ${param.isFree == 'true' ? 'checked' : ''}>
                                <label class="form-check-label" for="price_free">
                                    Miễn phí
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox"
                                       name="isPaid" value="true" id="price_paid"
                                ${param.isPaid == 'true' ? 'checked' : ''}>
                                <label class="form-check-label" for="price_paid">
                                    Có phí
                                </label>
                            </div>

                            <div class="price-range">
                                <label class="form-label">Khoảng giá (VNĐ)</label>
                                <div class="price-inputs">
                                    <input type="number" class="form-control form-control-sm"
                                           name="minPrice" placeholder="Từ" value="${param.minPrice}">
                                    <span>-</span>
                                    <input type="number" class="form-control form-control-sm"
                                           name="maxPrice" placeholder="Đến" value="${param.maxPrice}">
                                </div>
                            </div>
                        </div>

                        <!-- Duration Filter -->
                        <div class="filter-section">
                            <h6 class="filter-title">
                                <i class="fas fa-clock"></i>Thời Lượng
                            </h6>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox"
                                       name="durations" value="short" id="duration_short"
                                ${fn:contains(paramValues.durations, 'short') ? 'checked' : ''}>
                                <label class="form-check-label" for="duration_short">
                                    Dưới 3 giờ
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox"
                                       name="durations" value="medium" id="duration_medium"
                                ${fn:contains(paramValues.durations, 'medium') ? 'checked' : ''}>
                                <label class="form-check-label" for="duration_medium">
                                    3-10 giờ
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox"
                                       name="durations" value="long" id="duration_long"
                                ${fn:contains(paramValues.durations, 'long') ? 'checked' : ''}>
                                <label class="form-check-label" for="duration_long">
                                    Hơn 10 giờ
                                </label>
                            </div>
                        </div>

                        <!-- Rating Filter -->
                        <div class="filter-section">
                            <h6 class="filter-title">
                                <i class="fas fa-star"></i>Đánh Giá
                            </h6>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox"
                                       name="ratings" value="4" id="rating_4"
                                ${fn:contains(paramValues.ratings, '4') ? 'checked' : ''}>
                                <label class="form-check-label" for="rating_4">
                                        <span class="stars">
                                            <i class="fas fa-star text-warning"></i>
                                            <i class="fas fa-star text-warning"></i>
                                            <i class="fas fa-star text-warning"></i>
                                            <i class="fas fa-star text-warning"></i>
                                            <i class="far fa-star text-muted"></i>
                                        </span>
                                    4+ sao
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox"
                                       name="ratings" value="3" id="rating_3"
                                ${fn:contains(paramValues.ratings, '3') ? 'checked' : ''}>
                                <label class="form-check-label" for="rating_3">
                                        <span class="stars">
                                            <i class="fas fa-star text-warning"></i>
                                            <i class="fas fa-star text-warning"></i>
                                            <i class="fas fa-star text-warning"></i>
                                            <i class="far fa-star text-muted"></i>
                                            <i class="far fa-star text-muted"></i>
                                        </span>
                                    3+ sao
                                </label>
                            </div>
                        </div>

                        <!-- Apply Filters Button -->
                        <button type="submit" class="btn btn-primary w-100 mb-2">
                            <i class="fas fa-search me-2"></i>Áp dụng bộ lọc
                        </button>

                        <!-- Clear Filters Button -->
                        <button type="button" class="clear-filters" onclick="clearFilters()">
                            <i class="fas fa-times me-2"></i>Xóa bộ lọc
                        </button>
                    </form>
                </div>
            </div>

            <!-- Courses Content -->
            <div class="col-lg-9">
                <div class="courses-container">
                    <!-- Courses Header -->
                    <div class="courses-header">
                        <div class="results-info">
                            <strong>${coursePage.totalElements}</strong> khóa học được tìm thấy
                            <c:if test="${not empty param.search}">
                                cho "<strong>${param.search}</strong>"
                            </c:if>
                        </div>

                        <div class="sort-controls">
                            <!-- Sort Dropdown -->
                            <select class="form-select" onchange="changeSorting(this.value)" style="width: auto;">
                                <option value="newest" ${param.sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                                <option value="popular" ${param.sort == 'popular' ? 'selected' : ''}>Phổ biến</option>
                                <option value="rating" ${param.sort == 'rating' ? 'selected' : ''}>Đánh giá cao</option>
                                <option value="price-low" ${param.sort == 'price-low' ? 'selected' : ''}>Giá thấp</option>
                                <option value="price-high" ${param.sort == 'price-high' ? 'selected' : ''}>Giá cao</option>
                                <option value="name" ${param.sort == 'name' ? 'selected' : ''}>Tên A-Z</option>
                            </select>

                            <!-- View Toggle -->
                            <div class="view-toggle">
                                <button type="button" class="grid-view ${param.view != 'list' ? 'active' : ''}"
                                        onclick="changeView('grid')" title="Xem dạng lưới">
                                    <i class="fas fa-th"></i>
                                </button>
                                <button type="button" class="list-view ${param.view == 'list' ? 'active' : ''}"
                                        onclick="changeView('list')" title="Xem dạng danh sách">
                                    <i class="fas fa-list"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Courses Grid/List -->
                    <div class="courses-grid">
                        <c:choose>
                            <c:when test="${not empty coursePage.content}">
                                <div class="row ${param.view == 'list' ? 'course-list' : ''}">
                                    <c:forEach items="${coursePage.content}" var="course">
                                        <div class="${param.view == 'list' ? 'col-12' : 'col-xl-4 col-md-6'} mb-4">
                                            <div class="course-card">
                                                <!-- Course Image -->
                                                <div class="course-image">
                                                    <img src="${pageContext.request.contextPath}/images/courses/${course.thumbnail}"
                                                         alt="${course.name}"
                                                         onerror="this.src='/images/course-default.jpg"'">

                                                    <!-- Course Badges -->
                                                    <div class="course-badges">
                                                        <c:if test="${course.featured}">
                                                            <span class="course-badge badge-featured">Nổi bật</span>
                                                        </c:if>
                                                        <c:if test="${course.price == 0}">
                                                            <span class="course-badge badge-free">Miễn phí</span>
                                                        </c:if>
                                                        <c:if test="${course.bestSeller}">
                                                            <span class="course-badge badge-bestseller">Bán chạy</span>
                                                        </c:if>
                                                    </div>
                                                </div>

                                                <!-- Course Content -->
                                                <div class="course-content">
                                                    <!-- Course Meta -->
                                                    <div class="course-meta">
                                                        <span class="course-category">${course.category.name}</span>
                                                        <span class="course-duration">
                                                                <i class="fas fa-clock"></i>
                                                                <fmt:formatNumber value="${course.duration / 60}" maxFractionDigits="1"/>h
                                                            </span>
                                                    </div>

                                                    <!-- Course Title -->
                                                    <h5 class="course-title">
                                                        <a href="${pageContext.request.contextPath}/courses/${course.id}">
                                                                ${course.name}
                                                        </a>
                                                    </h5>

                                                    <!-- Course Description -->
                                                    <p class="course-description">
                                                            ${course.shortDescription}
                                                    </p>

                                                    <!-- Course Instructor -->
                                                    <div class="course-instructor">
                                                        <img src="${pageContext.request.contextPath}/images/avatars/${course.instructor.avatar}"
                                                             alt="${course.instructor.fullName}"
                                                             class="instructor-avatar"
                                                             onerror="this.src='/images/avatar-default.png"'">
                                                        <span class="instructor-name">${course.instructor.fullName}</span>
                                                    </div>

                                                    <!-- Course Footer -->
                                                    <div class="course-footer">
                                                        <!-- Rating -->
                                                        <div class="course-rating">
                                                            <div class="stars">
                                                                <c:forEach begin="1" end="5" var="i">
                                                                    <i class="fas fa-star ${i <= course.rating ? 'text-warning' : 'text-muted'}"></i>
                                                                </c:forEach>
                                                            </div>
                                                            <span class="rating-text">(${course.reviewCount})</span>
                                                        </div>

                                                        <!-- Price -->
                                                        <div class="course-price">
                                                            <c:choose>
                                                                <c:when test="${course.price == 0}">
                                                                    <span class="price-free">Miễn phí</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <c:if test="${course.originalPrice > course.price}">
                                                                            <span class="price-original">
                                                                                <fmt:formatNumber value="${course.originalPrice}" type="currency"
                                                                                                  currencySymbol="₫" groupingUsed="true"/>
                                                                            </span>
                                                                    </c:if>
                                                                    <span class="price-current">
                                                                            <fmt:formatNumber value="${course.price}" type="currency"
                                                                                              currencySymbol="₫" groupingUsed="true"/>
                                                                        </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- No Courses Found -->
                                <div class="no-courses">
                                    <i class="fas fa-search"></i>
                                    <h4>Không tìm thấy khóa học</h4>
                                    <p>Thử thay đổi bộ lọc hoặc từ khóa tìm kiếm để có kết quả tốt hơn.</p>
                                    <button class="btn btn-primary" onclick="clearFilters()">
                                        <i class="fas fa-refresh me-2"></i>Xóa bộ lọc
                                    </button>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${coursePage.totalPages > 1}">
                        <div class="pagination-container">
                            <nav aria-label="Phân trang khóa học">
                                <ul class="pagination">
                                    <!-- Previous Page -->
                                    <c:if test="${coursePage.hasPrevious()}">
                                        <li class="page-item">
                                            <a class="page-link" href="${pageContext.request.contextPath}/courses?page=${coursePage.number - 1}&${queryString}">
                                                <i class="fas fa-chevron-left"></i>
                                            </a>
                                        </li>
                                    </c:if>

                                    <!-- Page Numbers -->
                                    <c:forEach begin="0" end="${coursePage.totalPages - 1}" var="pageNum">
                                        <c:if test="${pageNum >= coursePage.number - 2 && pageNum <= coursePage.number + 2}">
                                            <li class="page-item ${pageNum == coursePage.number ? 'active' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/courses?page=${pageNum}&${queryString}">
                                                        ${pageNum + 1}
                                                </a>
                                            </li>
                                        </c:if>
                                    </c:forEach>

                                    <!-- Next Page -->
                                    <c:if test="${coursePage.hasNext()}">
                                        <li class="page-item">
                                            <a class="page-link" href="${pageContext.request.contextPath}/courses?page=${coursePage.number + 1}&${queryString}">
                                                <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Mobile Filter Modal -->
<div class="modal fade" id="filterModal" tabindex="-1">
    <div class="modal-dialog modal-fullscreen-sm-down">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Bộ Lọc Khóa Học</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <!-- Copy of filter sidebar content for mobile -->
                <div id="mobileFilterContent">
                    <!-- Content will be cloned from desktop sidebar -->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                <button type="button" class="btn btn-primary" onclick="applyMobileFilters()">Áp dụng</button>
            </div>
        </div>
    </div>
</div>

<!-- Include Footer -->
<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JavaScript -->
<script>
    // Change sorting
    function changeSorting(sortValue) {
        const url = new URL(window.location);
        url.searchParams.set('sort', sortValue);
        url.searchParams.delete('page'); // Reset page when sorting
        window.location.href = url.toString();
    }

    // Change view (grid/list)
    function changeView(viewType) {
        const url = new URL(window.location);
        url.searchParams.set('view', viewType);
        window.location.href = url.toString();
    }

    // Clear all filters
    function clearFilters() {
        const url = new URL(window.location);
        // Keep only search parameter if exists
        const search = url.searchParams.get('search');
        url.search = '';
        if (search) {
            url.searchParams.set('search', search);
        }
        window.location.href = url.toString();
    }

    // Auto-submit filters on change
    document.addEventListener('DOMContentLoaded', function() {
        const filterInputs = document.querySelectorAll('#filterForm input[type="checkbox"], #filterForm input[type="number"]');

        filterInputs.forEach(input => {
            input.addEventListener('change', function() {
                // Debounce for number inputs
                if (this.type === 'number') {
                    clearTimeout(this.timeout);
                    this.timeout = setTimeout(() => {
                        document.getElementById('filterForm').submit();
                    }, 1000);
                } else {
                    document.getElementById('filterForm').submit();
                }
            });
        });

        // Clone filter content for mobile modal
        const filterSidebar = document.getElementById('filterSidebar');
        const mobileFilterContent = document.getElementById('mobileFilterContent');
        if (filterSidebar && mobileFilterContent) {
            mobileFilterContent.innerHTML = filterSidebar.innerHTML;
        }
    });

    // Apply mobile filters
    function applyMobileFilters() {
        // Copy checked states from modal to main form
        const modalInputs = document.querySelectorAll('#mobileFilterContent input');
        const mainInputs = document.querySelectorAll('#filterForm input');

        modalInputs.forEach((modalInput, index) => {
            if (mainInputs[index]) {
                if (modalInput.type === 'checkbox' || modalInput.type === 'radio') {
                    mainInputs[index].checked = modalInput.checked;
                } else {
                    mainInputs[index].value = modalInput.value;
                }
            }
        });

        // Submit main form
        document.getElementById('filterForm').submit();
    }

    // Smooth scrolling for course cards
    document.querySelectorAll('.course-card').forEach(card => {
        card.addEventListener('click', function(e) {
            if (e.target.tagName !== 'A' && e.target.tagName !== 'BUTTON') {
                const link = this.querySelector('.course-title a');
                if (link) {
                    window.location.href = link.href;
                }
            }
        });
    });

    // Lazy loading for course images
    if ('IntersectionObserver' in window) {
        const imageObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    img.src = img.dataset.src || img.src;
                    img.classList.remove('lazy');
                    observer.unobserve(img);
                }
            });
        });

        document.querySelectorAll('img[data-src]').forEach(img => {
            imageObserver.observe(img);
        });
    }
</script>
</body>
</html>