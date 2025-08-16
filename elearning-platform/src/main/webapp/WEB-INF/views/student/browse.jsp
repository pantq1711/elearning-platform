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
    <title>Khám Phá Khóa Học - EduLearn</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

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
            background: var(--light-bg);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
        }

        .dashboard-layout {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            padding: 0;
            background: var(--light-bg);
        }

        /* Header */
        .page-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 2rem 2rem 3rem;
            position: relative;
            overflow: hidden;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            transform: translate(30%, -30%);
        }

        .header-content {
            position: relative;
            z-index: 2;
            max-width: 1200px;
            margin: 0 auto;
        }

        .page-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .page-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 0;
        }

        /* Search Section */
        .search-section {
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            margin: -2rem auto 2rem;
            max-width: 1200px;
            position: relative;
            z-index: 3;
            padding: 2rem;
        }

        .search-form {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr auto;
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

        /* Courses Container */
        .courses-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .courses-header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid var(--border-color);
        }

        .courses-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--text-primary);
            margin: 0;
        }

        .courses-count {
            color: var(--text-secondary);
            font-size: 0.9rem;
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
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
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

        .course-price-badge {
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

        .course-free-badge {
            background: var(--info-color);
        }

        .course-difficulty-badge {
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
        }

        .course-instructor {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--text-secondary);
            margin-bottom: 1rem;
            font-size: 0.9rem;
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
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--primary-color);
            display: block;
        }

        .meta-label {
            font-size: 0.8rem;
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
        }

        .rating-count {
            color: var(--text-secondary);
            font-size: 0.9rem;
        }

        .course-actions {
            display: flex;
            gap: 0.75rem;
            justify-content: space-between;
            align-items: center;
        }

        .course-price {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--success-color);
        }

        .course-price-free {
            color: var(--info-color);
        }

        .btn-enroll {
            background: var(--primary-color);
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-enroll:hover {
            background: var(--secondary-color);
            color: white;
            transform: translateY(-2px);
        }

        .btn-view {
            border: 2px solid var(--primary-color);
            color: var(--primary-color);
            background: transparent;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-view:hover {
            background: var(--primary-color);
            color: white;
        }

        .btn-enrolled {
            background: var(--success-color);
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            text-decoration: none;
            font-weight: 500;
            cursor: default;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
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
            .page-title {
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

            .course-actions {
                flex-direction: column;
                gap: 0.5rem;
            }

            .search-section {
                margin: -1.5rem 1rem 1rem;
                padding: 1.5rem;
            }

            .courses-container {
                padding: 0 1rem;
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
            <div class="header-content">
                <h1 class="page-title">Khám Phá Khóa Học</h1>
                <p class="page-subtitle">
                    Tìm kiếm và đăng ký các khóa học phù hợp với mục tiêu học tập của bạn
                </p>
            </div>
        </div>

        <!-- Search Section -->
        <div class="search-section">
            <form method="GET" action="${pageContext.request.contextPath}/student/browse" class="search-form">
                <div class="form-group">
                    <label class="form-label">Tìm kiếm khóa học</label>
                    <input type="text" class="form-control" name="search"
                           value="${param.search}"
                           placeholder="Tên khóa học, giảng viên, kỹ năng...">
                </div>
                <div class="form-group">
                    <label class="form-label">Danh mục</label>
                    <select class="form-select" name="categoryId">
                        <option value="">Tất cả danh mục</option>
                        <c:if test="${categories != null}">
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.id}"
                                        <c:if test="${param.categoryId eq category.id}">selected</c:if>>
                                        ${category.name}
                                </option>
                            </c:forEach>
                        </c:if>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Cấp độ</label>
                    <select class="form-select" name="level">
                        <option value="">Tất cả cấp độ</option>
                        <option value="EASY" <c:if test="${param.level eq 'EASY'}">selected</c:if>>
                            Cơ bản
                        </option>
                        <option value="MEDIUM" <c:if test="${param.level eq 'MEDIUM'}">selected</c:if>>
                            Trung cấp
                        </option>
                        <option value="HARD" <c:if test="${param.level eq 'HARD'}">selected</c:if>>
                            Nâng cao
                        </option>
                    </select>
                </div>
                <div class="form-group">
                    <button type="submit" class="search-btn">
                        <i class="fas fa-search me-1"></i>Tìm kiếm
                    </button>
                </div>
            </form>
        </div>

        <!-- Courses Container -->
        <div class="courses-container">
            <!-- Courses Header -->
            <div class="courses-header">
                <div>
                    <h2 class="courses-title">
                        <c:choose>
                            <c:when test="${not empty param.search}">
                                Kết quả tìm kiếm: "${param.search}"
                            </c:when>
                            <c:when test="${selectedCategory != null}">
                                Khóa học ${selectedCategory.name}
                            </c:when>
                            <c:otherwise>
                                Tất cả khóa học
                            </c:otherwise>
                        </c:choose>
                    </h2>
                    <div class="courses-count">
                        <c:choose>
                            <c:when test="${courses != null}">
                                Tìm thấy ${fn:length(courses)} khóa học
                            </c:when>
                            <c:otherwise>
                                Không tìm thấy khóa học nào
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Courses Grid -->
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

                                    <!-- Price Badge -->
                                    <div class="course-price-badge
                                        <c:if test='${course.price == null || course.price == 0}'>course-free-badge</c:if>">
                                        <c:choose>
                                            <c:when test="${course.price == null || course.price == 0}">
                                                Miễn phí
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatNumber value="${course.price}" type="number" groupingUsed="true"/>đ
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Difficulty Badge -->
                                    <div class="course-difficulty-badge
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
                                        <a href="${pageContext.request.contextPath}/student/course/${course.id}">
                                                ${course.name}
                                        </a>
                                    </h3>

                                    <!-- Description -->
                                    <p class="course-description">
                                        <c:choose>
                                            <c:when test="${course.shortDescription != null}">
                                                ${fn:substring(course.shortDescription, 0, 150)}
                                                <c:if test="${fn:length(course.shortDescription) > 150}">...</c:if>
                                            </c:when>
                                            <c:otherwise>
                                                ${fn:substring(course.description, 0, 150)}
                                                <c:if test="${fn:length(course.description) > 150}">...</c:if>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>

                                    <!-- Instructor -->
                                    <div class="course-instructor">
                                        <i class="fas fa-user"></i>
                                        <c:choose>
                                            <c:when test="${course.instructor != null}">
                                                ${course.instructor.fullName}
                                            </c:when>
                                            <c:otherwise>Chưa có giảng viên</c:otherwise>
                                        </c:choose>
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

                                    <!-- Actions -->
                                    <div class="course-actions">
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

                                        <!-- Check if enrolled -->
                                        <c:set var="isEnrolled" value="false" />
                                        <c:if test="${currentUser != null}">
                                            <!-- Note: This would need to be set by the controller -->
                                            <!-- For now, we'll assume not enrolled -->
                                        </c:if>

                                        <c:choose>
                                            <c:when test="${isEnrolled}">
                                                <a href="${pageContext.request.contextPath}/student/courses/${course.id}/learn"
                                                   class="btn-enrolled">
                                                    <i class="fas fa-check"></i>Đã đăng ký
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/student/courses/${course.id}/enroll"
                                                   class="btn-enroll">
                                                    <i class="fas fa-plus"></i>Đăng ký
                                                </a>
                                            </c:otherwise>
                                        </c:choose>

                                        <a href="${pageContext.request.contextPath}/student/course/${course.id}"
                                           class="btn-view">
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
                                    Không có khóa học nào phù hợp với từ khóa "${param.search}".
                                    Hãy thử tìm kiếm với từ khóa khác hoặc thay đổi bộ lọc.
                                </c:when>
                                <c:otherwise>
                                    Hiện tại chưa có khóa học nào trong danh mục này.
                                    Hãy thử tìm kiếm trong các danh mục khác.
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <a href="${pageContext.request.contextPath}/student/browse" class="btn-enroll">
                            <i class="fas fa-refresh me-2"></i>Xem tất cả khóa học
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Auto-submit form when filter changes
    document.querySelectorAll('select[name="categoryId"], select[name="level"]').forEach(select => {
        select.addEventListener('change', function() {
            this.form.submit();
        });
    });

    // Search on Enter key
    document.querySelector('input[name="search"]').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            this.form.submit();
        }
    });

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

    // Enroll confirmation
    document.querySelectorAll('.btn-enroll').forEach(btn => {
        btn.addEventListener('click', function(e) {
            if (!confirm('Bạn có chắc muốn đăng ký khóa học này?')) {
                e.preventDefault();
            }
        });
    });
</script>
</body>
</html>