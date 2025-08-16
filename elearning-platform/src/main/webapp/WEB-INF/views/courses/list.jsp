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

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --info-color: #17a2b8;
            --light-bg: #f8f9fa;
            --dark-bg: #343a40;
            --border-color: #e9ecef;
            --text-primary: #2c3e50;
            --text-secondary: #6c757d;
            --card-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--light-bg);
            line-height: 1.6;
        }

        /* Header */
        .courses-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 4rem 0;
            position: relative;
            overflow: hidden;
        }

        .courses-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }

        .header-content {
            position: relative;
            z-index: 2;
            text-align: center;
        }

        .header-title {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .header-subtitle {
            font-size: 1.2rem;
            opacity: 0.9;
            margin-bottom: 0;
        }

        /* Search Section */
        .search-section {
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            margin: -3rem auto 3rem;
            max-width: 800px;
            padding: 2rem;
            position: relative;
            z-index: 3;
        }

        .search-form {
            display: grid;
            grid-template-columns: 2fr 1fr auto;
            gap: 1rem;
            align-items: end;
        }

        .form-group {
            margin-bottom: 0;
        }

        .form-label {
            font-weight: 500;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
            display: block;
        }

        .form-control, .form-select {
            border: 2px solid var(--border-color);
            border-radius: 0.5rem;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .search-btn {
            background: var(--primary-color);
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .search-btn:hover {
            background: var(--secondary-color);
            transform: translateY(-2px);
        }

        /* Filter Bar */
        .filter-bar {
            background: white;
            border-radius: 1rem;
            padding: 1rem 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--card-shadow);
        }

        .filter-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .results-info {
            color: var(--text-secondary);
        }

        .filter-tags {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .filter-tag {
            background: var(--primary-color);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.8rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .filter-tag .remove {
            cursor: pointer;
            opacity: 0.8;
        }

        .filter-tag .remove:hover {
            opacity: 1;
        }

        /* Courses Grid */
        .courses-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .course-card {
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            overflow: hidden;
            transition: all 0.3s ease;
            position: relative;
        }

        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px rgba(0,0,0,0.15);
        }

        .course-image {
            height: 200px;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            position: relative;
            overflow: hidden;
        }

        .course-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .course-image-placeholder {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100%;
            color: white;
            font-size: 3rem;
        }

        .course-badge {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: var(--success-color);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 2rem;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .course-badge-free {
            background: var(--info-color);
        }

        .course-badge-featured {
            background: var(--warning-color);
            color: #856404;
        }

        .difficulty-badge {
            position: absolute;
            top: 1rem;
            left: 1rem;
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .difficulty-easy {
            background: var(--success-color);
            color: white;
        }

        .difficulty-medium {
            background: var(--warning-color);
            color: #856404;
        }

        .difficulty-hard {
            background: var(--danger-color);
            color: white;
        }

        .course-body {
            padding: 1.5rem;
        }

        .course-category {
            display: inline-block;
            background: var(--primary-color);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.8rem;
            font-weight: 500;
            margin-bottom: 1rem;
        }

        .course-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
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
            color: var(--text-secondary);
            font-size: 0.9rem;
            line-height: 1.5;
            margin-bottom: 1rem;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .course-instructor {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 1rem;
        }

        .instructor-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: var(--primary-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 0.8rem;
        }

        .instructor-info {
            flex: 1;
        }

        .instructor-name {
            font-weight: 500;
            color: var(--text-primary);
            font-size: 0.9rem;
        }

        .instructor-title {
            font-size: 0.8rem;
            color: var(--text-secondary);
        }

        .course-meta {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1rem;
            margin-bottom: 1.5rem;
            padding: 1rem;
            background: var(--light-bg);
            border-radius: 0.5rem;
        }

        .meta-item {
            text-align: center;
        }

        .meta-number {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--primary-color);
            display: block;
        }

        .meta-label {
            font-size: 0.75rem;
            color: var(--text-secondary);
            margin-top: 0.25rem;
        }

        .course-rating {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }

        .rating-stars {
            display: flex;
            gap: 0.1rem;
        }

        .rating-number {
            font-weight: 600;
            color: var(--text-primary);
            font-size: 0.9rem;
        }

        .rating-count {
            color: var(--text-secondary);
            font-size: 0.8rem;
        }

        .course-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 1rem;
            border-top: 1px solid var(--border-color);
        }

        .course-price {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--success-color);
        }

        .course-price-free {
            color: var(--info-color);
            font-style: italic;
        }

        .btn-view-course {
            background: var(--primary-color);
            border: none;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-view-course:hover {
            background: var(--secondary-color);
            color: white;
            transform: translateY(-2px);
        }

        /* Pagination */
        .pagination-container {
            display: flex;
            justify-content: center;
            margin-top: 3rem;
        }

        .pagination {
            background: white;
            border-radius: 0.5rem;
            padding: 1rem;
            box-shadow: var(--card-shadow);
        }

        .pagination .page-link {
            border: none;
            color: var(--primary-color);
            padding: 0.5rem 1rem;
            margin: 0 0.25rem;
            border-radius: 0.5rem;
            transition: all 0.3s ease;
        }

        .pagination .page-link:hover {
            background: var(--primary-color);
            color: white;
        }

        .pagination .page-item.active .page-link {
            background: var(--primary-color);
            color: white;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
        }

        .empty-icon {
            font-size: 4rem;
            color: var(--text-secondary);
            margin-bottom: 1.5rem;
            opacity: 0.5;
        }

        .empty-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
        }

        .empty-description {
            color: var(--text-secondary);
            margin-bottom: 2rem;
            line-height: 1.6;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .header-title {
                font-size: 2rem;
            }

            .search-form {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .courses-grid {
                grid-template-columns: 1fr;
            }

            .course-meta {
                grid-template-columns: repeat(2, 1fr);
            }

            .search-section {
                margin: -2rem 1rem 2rem;
                padding: 1.5rem;
            }

            .courses-container {
                padding: 0 1rem;
            }

            .filter-info {
                flex-direction: column;
                gap: 1rem;
                align-items: stretch;
            }
        }
    </style>
</head>

<body>
<!-- Include Header -->
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<!-- Courses Header -->
<section class="courses-header">
    <div class="container">
        <div class="header-content">
            <h1 class="header-title">Khóa Học</h1>
            <p class="header-subtitle">
                Khám phá hàng nghìn khóa học chất lượng cao từ các chuyên gia hàng đầu
            </p>
        </div>
    </div>
</section>

<!-- Search Section -->
<div class="container">
    <div class="search-section">
        <form method="GET" action="${pageContext.request.contextPath}/courses" class="search-form">
            <div class="form-group">
                <label class="form-label">Tìm kiếm khóa học</label>
                <input type="text" class="form-control" name="search"
                       value="${param.search}"
                       placeholder="Tên khóa học, giảng viên, kỹ năng...">
            </div>
            <div class="form-group">
                <label class="form-label">Danh mục</label>
                <select class="form-select" name="category">
                    <option value="">Tất cả danh mục</option>
                    <c:if test="${categories != null}">
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.id}"
                                    <c:if test="${param.category eq category.id}">selected</c:if>>
                                    ${category.name}
                            </option>
                        </c:forEach>
                    </c:if>
                </select>
            </div>
            <div class="form-group">
                <button type="submit" class="search-btn">
                    <i class="fas fa-search me-1"></i>Tìm kiếm
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Filter Bar -->
<div class="container">
    <div class="filter-bar">
        <div class="filter-info">
            <div class="results-info">
                <c:choose>
                    <c:when test="${courses != null}">
                        Tìm thấy ${fn:length(courses)} khóa học
                        <c:if test="${not empty param.search}">
                            cho từ khóa "<strong>${param.search}</strong>"
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        Không tìm thấy khóa học nào
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="filter-tags">
                <c:if test="${not empty param.search}">
                        <span class="filter-tag">
                            <i class="fas fa-search me-1"></i>
                            ${param.search}
                            <span class="remove" onclick="clearFilter('search')">
                                <i class="fas fa-times"></i>
                            </span>
                        </span>
                </c:if>
                <c:if test="${not empty selectedCategory}">
                        <span class="filter-tag">
                            <i class="fas fa-tag me-1"></i>
                            ${selectedCategory}
                            <span class="remove" onclick="clearFilter('category')">
                                <i class="fas fa-times"></i>
                            </span>
                        </span>
                </c:if>
            </div>
        </div>
    </div>
</div>

<!-- Courses Container -->
<div class="courses-container">
    <c:choose>
        <c:when test="${courses != null && fn:length(courses) > 0}">
            <div class="courses-grid">
                <c:forEach var="course" items="${courses}" varStatus="courseLoop">
                    <div class="course-card">
                        <!-- Course Image -->
                        <div class="course-image">
                            <c:choose>
                                <c:when test="${course.imageUrl != null && !empty course.imageUrl}">
                                    <img src="${course.imageUrl}" alt="${course.name}">
                                </c:when>
                                <c:otherwise>
                                    <div class="course-image-placeholder">
                                        <i class="fas fa-graduation-cap"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <!-- Course Badges -->
                            <c:if test="${course.featured}">
                                <div class="course-badge course-badge-featured">
                                    <i class="fas fa-star me-1"></i>Nổi bật
                                </div>
                            </c:if>

                            <c:if test="${!course.featured}">
                                <div class="course-badge
                                        <c:if test='${course.price == null || course.price == 0}'>course-badge-free</c:if>">
                                    <c:choose>
                                        <c:when test="${course.price == null || course.price == 0}">
                                            Miễn phí
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatNumber value="${course.price}" type="number" groupingUsed="true"/>đ
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:if>

                            <!-- Difficulty Badge -->
                            <div class="difficulty-badge
                                    <c:choose>
                                        <c:when test='${course.difficultyLevel == \"EASY\"}'>difficulty-easy</c:when>
                                        <c:when test='${course.difficultyLevel == \"MEDIUM\"}'>difficulty-medium</c:when>
                                        <c:when test='${course.difficultyLevel == \"HARD\"}'>difficulty-hard</c:when>
                                        <c:otherwise>difficulty-easy</c:otherwise>
                                    </c:choose>">
                                <c:choose>
                                    <c:when test="${course.difficultyLevel == 'EASY'}">Cơ bản</c:when>
                                    <c:when test="${course.difficultyLevel == 'MEDIUM'}">Trung cấp</c:when>
                                    <c:when test="${course.difficultyLevel == 'HARD'}">Nâng cao</c:when>
                                    <c:otherwise>Cơ bản</c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Course Body -->
                        <div class="course-body">
                            <!-- Category -->
                            <span class="course-category">
                                    <i class="fas fa-tag me-1"></i>
                                    <c:choose>
                                        <c:when test="${course.category != null}">
                                            ${course.category.name}
                                        </c:when>
                                        <c:otherwise>Chưa phân loại</c:otherwise>
                                    </c:choose>
                                </span>

                            <!-- Title -->
                            <h3 class="course-title">
                                <a href="${pageContext.request.contextPath}/courses/${course.slug}">
                                        ${course.name}
                                </a>
                            </h3>

                            <!-- Description -->
                            <p class="course-description">
                                <c:choose>
                                    <c:when test="${course.shortDescription != null}">
                                        ${course.shortDescription}
                                    </c:when>
                                    <c:otherwise>
                                        ${fn:substring(course.description, 0, 120)}
                                        <c:if test="${fn:length(course.description) > 120}">...</c:if>
                                    </c:otherwise>
                                </c:choose>
                            </p>

                            <!-- Instructor -->
                            <div class="course-instructor">
                                <div class="instructor-avatar">
                                    <c:choose>
                                        <c:when test="${course.instructor != null && course.instructor.fullName != null}">
                                            ${fn:substring(course.instructor.fullName, 0, 1)}
                                        </c:when>
                                        <c:otherwise>?</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="instructor-info">
                                    <div class="instructor-name">
                                        <c:choose>
                                            <c:when test="${course.instructor != null}">
                                                ${course.instructor.fullName}
                                            </c:when>
                                            <c:otherwise>Chưa có giảng viên</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="instructor-title">Giảng viên</div>
                                </div>
                            </div>

                            <!-- Rating -->
                            <div class="course-rating">
                                <div class="rating-stars">
                                    <c:set var="rating" value="${course.ratingAverage != null ? course.ratingAverage : 0}" />
                                    <c:forEach var="starIndex" begin="1" end="5">
                                        <i class="fas fa-star
                                                <c:choose>
                                                    <c:when test='${starIndex <= rating}'>text-warning</c:when>
                                                    <c:otherwise>text-muted</c:otherwise>
                                                </c:choose>"></i>
                                    </c:forEach>
                                </div>
                                <span class="rating-number">
                                        <fmt:formatNumber value="${rating}" pattern="#.#" maxFractionDigits="1"/>
                                    </span>
                                <span class="rating-count">
                                        (<c:choose>
                                    <c:when test="${course.ratingCount != null}">${course.ratingCount}</c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>)
                                    </span>
                            </div>

                            <!-- Meta Information -->
                            <div class="course-meta">
                                <div class="meta-item">
                                        <span class="meta-number">
                                            <c:choose>
                                                <c:when test="${course.lessonCount != null}">${course.lessonCount}</c:when>
                                                <c:otherwise>0</c:otherwise>
                                            </c:choose>
                                        </span>
                                    <div class="meta-label">Bài học</div>
                                </div>
                                <div class="meta-item">
                                        <span class="meta-number">
                                            <c:choose>
                                                <c:when test="${course.duration != null}">
                                                    <fmt:formatNumber value="${course.duration / 60}" maxFractionDigits="1"/>h
                                                </c:when>
                                                <c:otherwise>0h</c:otherwise>
                                            </c:choose>
                                        </span>
                                    <div class="meta-label">Thời lượng</div>
                                </div>
                                <div class="meta-item">
                                        <span class="meta-number">
                                            <c:choose>
                                                <c:when test="${course.enrollmentCount != null}">${course.enrollmentCount}</c:when>
                                                <c:otherwise>0</c:otherwise>
                                            </c:choose>
                                        </span>
                                    <div class="meta-label">Học viên</div>
                                </div>
                            </div>

                            <!-- Footer -->
                            <div class="course-footer">
                                <div class="course-price
                                        <c:if test='${course.price == null || course.price == 0}'>course-price-free</c:if>">
                                    <c:choose>
                                        <c:when test="${course.price == null || course.price == 0}">
                                            Miễn phí
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatNumber value="${course.price}" type="number" groupingUsed="true"/>đ
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <a href="${pageContext.request.contextPath}/courses/${course.slug}"
                                   class="btn-view-course">
                                    <i class="fas fa-eye"></i>Xem chi tiết
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Empty State -->
            <div class="empty-state">
                <i class="fas fa-search empty-icon"></i>
                <h3 class="empty-title">Không tìm thấy khóa học nào</h3>
                <p class="empty-description">
                    <c:choose>
                        <c:when test="${not empty param.search}">
                            Không có khóa học nào phù hợp với từ khóa "<strong>${param.search}</strong>".
                            Hãy thử tìm kiếm với từ khóa khác hoặc thay đổi bộ lọc.
                        </c:when>
                        <c:otherwise>
                            Hiện tại chưa có khóa học nào trong danh mục này.
                            Hãy thử tìm kiếm trong các danh mục khác.
                        </c:otherwise>
                    </c:choose>
                </p>
                <a href="${pageContext.request.contextPath}/courses" class="btn-view-course">
                    <i class="fas fa-refresh me-2"></i>Xem tất cả khóa học
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- Include Footer -->
<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Auto-submit form when category changes
    document.querySelector('select[name="category"]').addEventListener('change', function() {
        this.form.submit();
    });

    // Search on Enter key
    document.querySelector('input[name="search"]').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            this.form.submit();
        }
    });

    // Clear filter function
    function clearFilter(filterType) {
        const form = document.querySelector('form');
        const currentUrl = new URL(window.location);
        currentUrl.searchParams.delete(filterType);
        window.location.href = currentUrl.toString();
    }

    // Card animations on load
    document.addEventListener('DOMContentLoaded', function() {
        const cards = document.querySelectorAll('.course-card');
        cards.forEach((card, index) => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            setTimeout(() => {
                card.style.transition = 'all 0.6s ease';
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, index * 100);
        });
    });
</script>
</body>
</html>