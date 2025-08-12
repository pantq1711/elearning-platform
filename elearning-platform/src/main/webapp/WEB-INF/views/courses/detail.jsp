<%--
===============================
COURSE DETAIL PAGE
===============================
File: /WEB-INF/views/courses/detail.jsp
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="pageTitle" value="${course.name}" />
<c:set var="pageCSS" value="course-detail.css" />
<c:set var="pageJS" value="course-detail.js" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${course.name} - E-Learning Platform</title>

    <%-- SEO Meta Tags --%>
    <meta name="description" content="${fn:substring(course.description, 0, 160)}">
    <meta name="keywords" content="${course.category.name}, ${course.instructor.fullName}, online course">

    <%-- Open Graph Tags --%>
    <meta property="og:title" content="${course.name}">
    <meta property="og:description" content="${fn:substring(course.description, 0, 160)}">
    <meta property="og:image" content="${course.imageUrl}">
    <meta property="og:type" content="article">

    <%-- CSS --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="/css/main.css" rel="stylesheet">
    <link href="/css/components.css" rel="stylesheet">
    <link href="/css/course-detail.css" rel="stylesheet">

    <%-- JSON-LD Structured Data --%>
    <script type="application/ld+json">
        {
          "@context": "https://schema.org",
          "@type": "Course",
          "name": "${course.name}",
      "description": "${course.description}",
      "image": "${course.imageUrl}",
      "provider": {
        "@type": "Organization",
        "name": "E-Learning Platform"
      },
      "instructor": {
        "@type": "Person",
        "name": "${course.instructor.fullName}"
      },
      "coursePrerequisites": "${course.prerequisites}",
      "educationalLevel": "${course.difficultyLevel}",
      "offers": {
        "@type": "Offer",
        "price": "${course.price}",
        "priceCurrency": "VND"
      }
    }
    </script>
</head>

<body class="course-detail-page">
<%-- Header --%>
<jsp:include page="../layout/header.jsp" />

<%-- Course Hero Section --%>
<section class="course-hero">
    <div class="course-hero-bg">
        <img src="${course.imageUrl}" alt="${course.name}" class="hero-bg-image"
             onerror="this.src='/images/default-course-hero.jpg'">
        <div class="hero-overlay"></div>
    </div>

    <div class="container">
        <div class="row">
            <div class="col-lg-8">
                <div class="course-hero-content">
                    <%-- Breadcrumb --%>
                    <nav aria-label="breadcrumb" class="mb-3">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="/" class="text-white-50">Trang chủ</a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="/courses" class="text-white-50">Khóa học</a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="/courses?category=${course.category.id}" class="text-white-50">
                                    ${course.category.name}
                                </a>
                            </li>
                            <li class="breadcrumb-item active text-white">${course.name}</li>
                        </ol>
                    </nav>

                    <%-- Course Info --%>
                    <div class="course-badges mb-3">
                        <span class="badge bg-primary">${course.category.name}</span>
                        <span class="badge bg-${course.difficultyLevel == 'BEGINNER' ? 'success' : course.difficultyLevel == 'INTERMEDIATE' ? 'warning' : 'danger'}">
                            ${course.difficultyLevel == 'BEGINNER' ? 'Cơ bản' : course.difficultyLevel == 'INTERMEDIATE' ? 'Trung bình' : 'Nâng cao'}
                        </span>
                        <c:if test="${course.featured}">
                                <span class="badge bg-warning">
                                    <i class="fas fa-star me-1"></i>Nổi bật
                                </span>
                        </c:if>
                    </div>

                    <h1 class="course-title text-white mb-3">${course.name}</h1>
                    <p class="course-subtitle text-white-50 mb-4">${course.description}</p>

                    <%-- Course Stats --%>
                    <div class="course-stats">
                        <div class="stat-item">
                            <div class="rating">
                                <div class="stars">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="fas fa-star ${i <= course.averageRating ? 'text-warning' : 'text-muted'}"></i>
                                    </c:forEach>
                                </div>
                                <span class="rating-text">${course.averageRating} (${course.reviewCount} đánh giá)</span>
                            </div>
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-users me-2"></i>
                            ${course.enrollmentCount} học viên
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-clock me-2"></i>
                            ${course.formattedDuration}
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-play-circle me-2"></i>
                            ${course.lessonCount} bài học
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-language me-2"></i>
                            ${course.language}
                        </div>
                    </div>

                    <%-- Instructor Info --%>
                    <div class="instructor-info mt-4">
                        <div class="d-flex align-items-center">
                            <img src="${course.instructor.profileImageUrl}" alt="Instructor"
                                 class="instructor-avatar me-3"
                                 onerror="this.src='/images/default-avatar.png'">
                            <div>
                                <div class="instructor-label text-white-50">Giảng viên</div>
                                <div class="instructor-name text-white fw-bold">${course.instructor.fullName}</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<%-- Course Content --%>
<div class="course-content">
    <div class="container">
        <div class="row">
            <%-- Main Content --%>
            <div class="col-lg-8">
                <%-- Course Tabs --%>
                <div class="course-tabs">
                    <ul class="nav nav-tabs nav-fill" id="courseTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="overview-tab" data-bs-toggle="tab"
                                    data-bs-target="#overview" type="button" role="tab">
                                <i class="fas fa-info-circle me-2"></i>Tổng quan
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="curriculum-tab" data-bs-toggle="tab"
                                    data-bs-target="#curriculum" type="button" role="tab">
                                <i class="fas fa-list me-2"></i>Nội dung khóa học
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="instructor-tab" data-bs-toggle="tab"
                                    data-bs-target="#instructor" type="button" role="tab">
                                <i class="fas fa-user me-2"></i>Giảng viên
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="reviews-tab" data-bs-toggle="tab"
                                    data-bs-target="#reviews" type="button" role="tab">
                                <i class="fas fa-star me-2"></i>Đánh giá
                            </button>
                        </li>
                    </ul>

                    <div class="tab-content" id="courseTabsContent">
                        <%-- Overview Tab --%>
                        <div class="tab-pane fade show active" id="overview" role="tabpanel">
                            <div class="overview-content p-4">
                                <h4>Về khóa học này</h4>
                                <div class="course-description">
                                    ${course.detailedDescription}
                                </div>

                                <c:if test="${not empty course.learningObjectives}">
                                    <h5 class="mt-4">Bạn sẽ học được gì</h5>
                                    <div class="learning-objectives">
                                        <ul class="objectives-list">
                                            <c:forEach var="objective" items="${fn:split(course.learningObjectives, '|')}">
                                                <li>
                                                    <i class="fas fa-check text-success me-2"></i>
                                                        ${objective}
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                </c:if>

                                <c:if test="${not empty course.prerequisites}">
                                    <h5 class="mt-4">Yêu cầu</h5>
                                    <div class="prerequisites">
                                        <ul class="prerequisites-list">
                                            <c:forEach var="prerequisite" items="${fn:split(course.prerequisites, '|')}">
                                                <li>
                                                    <i class="fas fa-exclamation-circle text-warning me-2"></i>
                                                        ${prerequisite}
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                </c:if>

                                <%-- Course Features --%>
                                <h5 class="mt-4">Đặc điểm khóa học</h5>
                                <div class="course-features">
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <div class="feature-item">
                                                <i class="fas fa-infinity text-primary me-2"></i>
                                                Truy cập trọn đời
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="feature-item">
                                                <i class="fas fa-mobile-alt text-primary me-2"></i>
                                                Học trên mọi thiết bị
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="feature-item">
                                                <i class="fas fa-certificate text-primary me-2"></i>
                                                Chứng chỉ hoàn thành
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="feature-item">
                                                <i class="fas fa-question-circle text-primary me-2"></i>
                                                Hỗ trợ Q&A
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- Curriculum Tab --%>
                        <div class="tab-pane fade" id="curriculum" role="tabpanel">
                            <div class="curriculum-content p-4">
                                <div class="curriculum-header mb-4">
                                    <h4>Nội dung khóa học</h4>
                                    <p class="text-muted">
                                        ${course.lessonCount} bài học • ${course.formattedDuration} •
                                        ${course.quizCount} bài kiểm tra
                                    </p>
                                </div>

                                <div class="lessons-list">
                                    <c:forEach var="lesson" items="${course.lessons}" varStatus="status">
                                        <div class="lesson-item ${lesson.preview ? 'preview' : isEnrolled ? 'accessible' : 'locked'}">
                                            <div class="lesson-header">
                                                <div class="lesson-info">
                                                    <div class="lesson-number">${status.index + 1}</div>
                                                    <div class="lesson-content">
                                                        <h6 class="lesson-title">${lesson.title}</h6>
                                                        <p class="lesson-description">${lesson.content}</p>
                                                    </div>
                                                </div>
                                                <div class="lesson-meta">
                                                    <div class="lesson-duration">
                                                        <i class="fas fa-clock me-1"></i>
                                                            ${lesson.estimatedDuration} phút
                                                    </div>
                                                    <c:if test="${lesson.preview}">
                                                        <span class="badge bg-success">Preview</span>
                                                    </c:if>
                                                    <c:if test="${not lesson.preview and not isEnrolled}">
                                                        <i class="fas fa-lock text-muted"></i>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <c:if test="${lesson.preview or isEnrolled}">
                                                <div class="lesson-actions">
                                                    <c:choose>
                                                        <c:when test="${lesson.preview}">
                                                            <button class="btn btn-sm btn-outline-primary"
                                                                    onclick="previewLesson(${lesson.id})">
                                                                <i class="fas fa-play me-1"></i>Preview
                                                            </button>
                                                        </c:when>
                                                        <c:when test="${isEnrolled}">
                                                            <a href="/student/courses/${course.id}/lessons/${lesson.id}"
                                                               class="btn btn-sm btn-primary">
                                                                <i class="fas fa-play me-1"></i>Học bài
                                                            </a>
                                                        </c:when>
                                                    </c:choose>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <%-- Instructor Tab --%>
                        <div class="tab-pane fade" id="instructor" role="tabpanel">
                            <div class="instructor-detail p-4">
                                <div class="instructor-profile">
                                    <div class="row">
                                        <div class="col-md-3">
                                            <img src="${course.instructor.profileImageUrl}"
                                                 alt="${course.instructor.fullName}"
                                                 class="instructor-photo"
                                                 onerror="this.src='/images/default-avatar.png'">
                                        </div>
                                        <div class="col-md-9">
                                            <h4>${course.instructor.fullName}</h4>
                                            <p class="instructor-title text-muted">${course.instructor.jobTitle}</p>
                                            <div class="instructor-bio">
                                                ${course.instructor.bio}
                                            </div>

                                            <div class="instructor-stats mt-3">
                                                <div class="row g-3">
                                                    <div class="col-auto">
                                                        <div class="stat-item">
                                                            <div class="stat-number">${course.instructor.totalCourses}</div>
                                                            <div class="stat-label">Khóa học</div>
                                                        </div>
                                                    </div>
                                                    <div class="col-auto">
                                                        <div class="stat-item">
                                                            <div class="stat-number">${course.instructor.totalStudents}</div>
                                                            <div class="stat-label">Học viên</div>
                                                        </div>
                                                    </div>
                                                    <div class="col-auto">
                                                        <div class="stat-item">
                                                            <div class="stat-number">${course.instructor.averageRating}</div>
                                                            <div class="stat-label">Đánh giá</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <%-- Other Courses by Instructor --%>
                                <c:if test="${not empty instructorOtherCourses}">
                                    <h5 class="mt-4">Khóa học khác của giảng viên</h5>
                                    <div class="row g-3">
                                        <c:forEach var="otherCourse" items="${instructorOtherCourses}">
                                            <div class="col-md-6">
                                                <div class="mini-course-card">
                                                    <img src="${otherCourse.imageUrl}" alt="${otherCourse.name}"
                                                         onerror="this.src='/images/default-course.png'">
                                                    <div class="mini-course-info">
                                                        <h6>${otherCourse.name}</h6>
                                                        <div class="mini-course-meta">
                                                                <span class="rating">
                                                                    <i class="fas fa-star text-warning"></i>
                                                                    ${otherCourse.averageRating}
                                                                </span>
                                                            <span class="price">
                                                                    <c:choose>
                                                                        <c:when test="${otherCourse.price > 0}">
                                                                            <fmt:formatNumber value="${otherCourse.price}"
                                                                                              type="currency" currencySymbol="₫" />
                                                                        </c:when>
                                                                        <c:otherwise>Miễn phí</c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                        </div>
                                                        <a href="/courses/${otherCourse.id}" class="stretched-link"></a>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <%-- Reviews Tab --%>
                        <div class="tab-pane fade" id="reviews" role="tabpanel">
                            <div class="reviews-content p-4">
                                <%-- Reviews Summary --%>
                                <div class="reviews-summary">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="rating-overview text-center">
                                                <div class="overall-rating">${course.averageRating}</div>
                                                <div class="stars mb-2">
                                                    <c:forEach begin="1" end="5" var="i">
                                                        <i class="fas fa-star ${i <= course.averageRating ? 'text-warning' : 'text-muted'}"></i>
                                                    </c:forEach>
                                                </div>
                                                <div class="rating-count">${course.reviewCount} đánh giá</div>
                                            </div>
                                        </div>
                                        <div class="col-md-8">
                                            <div class="rating-breakdown">
                                                <c:forEach begin="5" end="1" step="-1" var="star">
                                                    <div class="rating-row">
                                                        <span class="rating-label">${star} sao</span>
                                                        <div class="rating-bar">
                                                            <div class="rating-fill" style="width: ${course.ratingDistribution[star-1]}%"></div>
                                                        </div>
                                                        <span class="rating-percent">${course.ratingDistribution[star-1]}%</span>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <%-- Reviews List --%>
                                <div class="reviews-list mt-4">
                                    <c:forEach var="review" items="${courseReviews}">
                                        <div class="review-item">
                                            <div class="review-header">
                                                <div class="reviewer-info">
                                                    <img src="${review.user.profileImageUrl}"
                                                         alt="${review.user.fullName}" class="reviewer-avatar"
                                                         onerror="this.src='/images/default-avatar.png'">
                                                    <div>
                                                        <div class="reviewer-name">${review.user.fullName}</div>
                                                        <div class="review-date">
                                                            <fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy" />
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="review-rating">
                                                    <c:forEach begin="1" end="5" var="i">
                                                        <i class="fas fa-star ${i <= review.rating ? 'text-warning' : 'text-muted'}"></i>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div class="review-content">
                                                    ${review.comment}
                                            </div>
                                            <div class="review-actions">
                                                <button class="btn btn-sm btn-outline-secondary">
                                                    <i class="fas fa-thumbs-up me-1"></i>
                                                    Hữu ích (${review.helpfulCount})
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <%-- Load More Reviews --%>
                                <c:if test="${hasMoreReviews}">
                                    <div class="text-center mt-4">
                                        <button class="btn btn-outline-primary" onclick="loadMoreReviews()">
                                            <i class="fas fa-plus me-2"></i>Xem thêm đánh giá
                                        </button>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Sidebar --%>
            <div class="col-lg-4">
                <div class="course-sidebar sticky-top">
                    <%-- Course Card --%>
                    <div class="course-card">
                        <div class="course-preview">
                            <img src="${course.imageUrl}" alt="${course.name}" class="course-image"
                                 onerror="this.src='/images/default-course.png'">
                            <div class="preview-overlay">
                                <button class="btn btn-lg btn-light" onclick="openPreviewModal()">
                                    <i class="fas fa-play me-2"></i>Xem trước
                                </button>
                            </div>
                        </div>

                        <div class="course-card-body">
                            <%-- Price --%>
                            <div class="course-price mb-3">
                                <c:choose>
                                    <c:when test="${course.price > 0}">
                                        <div class="current-price">
                                            <fmt:formatNumber value="${course.price}" type="currency"
                                                              currencySymbol="₫" maxFractionDigits="0" />
                                        </div>
                                        <c:if test="${not empty course.originalPrice and course.originalPrice > course.price}">
                                            <div class="original-price">
                                                <fmt:formatNumber value="${course.originalPrice}" type="currency"
                                                                  currencySymbol="₫" maxFractionDigits="0" />
                                            </div>
                                            <div class="discount-percent">
                                                -${course.discountPercent}%
                                            </div>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="free-price">Miễn phí</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <%-- Action Buttons --%>
                            <div class="course-actions">
                                <sec:authorize access="!isAuthenticated()">
                                    <a href="/login" class="btn btn-primary btn-lg w-100 mb-2">
                                        <i class="fas fa-shopping-cart me-2"></i>Đăng ký khóa học
                                    </a>
                                    <a href="/register" class="btn btn-outline-primary w-100">
                                        Tạo tài khoản miễn phí
                                    </a>
                                </sec:authorize>

                                <sec:authorize access="isAuthenticated()">
                                    <c:choose>
                                        <c:when test="${isEnrolled}">
                                            <a href="/student/courses/${course.id}" class="btn btn-success btn-lg w-100 mb-2">
                                                <i class="fas fa-play me-2"></i>Tiếp tục học
                                            </a>
                                            <div class="enrollment-info">
                                                <div class="progress mb-2">
                                                    <div class="progress-bar" style="width: ${enrollmentProgress}%"></div>
                                                </div>
                                                <small class="text-muted">Hoàn thành ${enrollmentProgress}%</small>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-primary btn-lg w-100 mb-2" onclick="enrollCourse()">
                                                <i class="fas fa-shopping-cart me-2"></i>Đăng ký khóa học
                                            </button>
                                            <button class="btn btn-outline-secondary w-100" onclick="addToWishlist()">
                                                <i class="fas fa-heart me-2"></i>Thêm vào yêu thích
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </sec:authorize>
                            </div>

                            <%-- Course Includes --%>
                            <div class="course-includes mt-4">
                                <h6>Khóa học bao gồm:</h6>
                                <ul class="includes-list">
                                    <li>
                                        <i class="fas fa-play-circle me-2"></i>
                                        ${course.lessonCount} bài học video
                                    </li>
                                    <li>
                                        <i class="fas fa-question-circle me-2"></i>
                                        ${course.quizCount} bài kiểm tra
                                    </li>
                                    <li>
                                        <i class="fas fa-infinity me-2"></i>
                                        Truy cập trọn đời
                                    </li>
                                    <li>
                                        <i class="fas fa-mobile-alt me-2"></i>
                                        Học trên mọi thiết bị
                                    </li>
                                    <li>
                                        <i class="fas fa-certificate me-2"></i>
                                        Chứng chỉ hoàn thành
                                    </li>
                                </ul>
                            </div>

                            <%-- Share Buttons --%>
                            <div class="share-buttons mt-4">
                                <h6>Chia sẻ khóa học:</h6>
                                <div class="d-flex gap-2">
                                    <button class="btn btn-outline-primary" onclick="shareOnFacebook()">
                                        <i class="fab fa-facebook-f"></i>
                                    </button>
                                    <button class="btn btn-outline-info" onclick="shareOnTwitter()">
                                        <i class="fab fa-twitter"></i>
                                    </button>
                                    <button class="btn btn-outline-success" onclick="shareOnWhatsapp()">
                                        <i class="fab fa-whatsapp"></i>
                                    </button>
                                    <button class="btn btn-outline-secondary" onclick="copyLink()">
                                        <i class="fas fa-link"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- Related Courses --%>
<section class="related-courses py-5 bg-light">
    <div class="container">
        <h3 class="mb-4">Khóa học liên quan</h3>
        <div class="row g-4">
            <c:forEach var="relatedCourse" items="${relatedCourses}">
                <div class="col-lg-3 col-md-6">
                    <div class="course-card">
                        <img src="${relatedCourse.imageUrl}" alt="${relatedCourse.name}"
                             class="card-img-top"
                             onerror="this.src='/images/default-course.png'">
                        <div class="card-body">
                            <h6 class="card-title">${relatedCourse.name}</h6>
                            <p class="card-text text-muted small">${relatedCourse.instructor.fullName}</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="rating">
                                    <i class="fas fa-star text-warning"></i>
                                        ${relatedCourse.averageRating}
                                </div>
                                <div class="price">
                                    <c:choose>
                                        <c:when test="${relatedCourse.price > 0}">
                                            <fmt:formatNumber value="${relatedCourse.price}" type="currency"
                                                              currencySymbol="₫" maxFractionDigits="0" />
                                        </c:when>
                                        <c:otherwise>Miễn phí</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <a href="/courses/${relatedCourse.id}" class="stretched-link"></a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<%-- Footer --%>
<jsp:include page="../layout/footer.jsp" />

<%-- Preview Modal --%>
<div class="modal fade" id="previewModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Xem trước khóa học</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="video-container">
                    <video id="previewVideo" controls class="w-100">
                        <source src="${course.previewVideoUrl}" type="video/mp4">
                        Trình duyệt không hỗ trợ video.
                    </video>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- JavaScript --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="/js/main.js"></script>
<script src="/js/course-detail.js"></script>

<script>
    // Course enrollment
    function enrollCourse() {
        <sec:authorize access="!isAuthenticated()">
        window.location.href = '/login?redirect=' + encodeURIComponent(window.location.href);
        return;
        </sec:authorize>

        const courseId = ${course.id};

        // Show loading state
        const btn = event.target;
        const originalText = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
        btn.disabled = true;

        fetch('/api/v1/enrollments', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                [window.APP_CONFIG.csrfHeader]: window.APP_CONFIG.csrfToken
            },
            body: 'courseId=' + courseId
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Show success message
                    btn.innerHTML = '<i class="fas fa-check me-2"></i>Đăng ký thành công!';
                    btn.classList.remove('btn-primary');
                    btn.classList.add('btn-success');

                    // Redirect after delay
                    setTimeout(() => {
                        window.location.href = '/student/courses/' + courseId;
                    }, 2000);
                } else {
                    throw new Error(data.message || 'Có lỗi xảy ra');
                }
            })
            .catch(error => {
                btn.innerHTML = originalText;
                btn.disabled = false;
                alert('Lỗi: ' + error.message);
            });
    }

    // Preview modal
    function openPreviewModal() {
        const modal = new bootstrap.Modal(document.getElementById('previewModal'));
        modal.show();
    }

    // Preview lesson
    function previewLesson(lessonId) {
        // Implementation for lesson preview
        window.open('/lessons/' + lessonId + '/preview', '_blank');
    }

    // Share functions
    function shareOnFacebook() {
        const url = encodeURIComponent(window.location.href);
        window.open('https://www.facebook.com/sharer/sharer.php?u=' + url, '_blank');
    }

    function shareOnTwitter() {
        const url = encodeURIComponent(window.location.href);
        const text = encodeURIComponent('${course.name} - E-Learning Platform');
        window.open('https://twitter.com/intent/tweet?url=' + url + '&text=' + text, '_blank');
    }

    function shareOnWhatsapp() {
        const url = encodeURIComponent(window.location.href);
        const text = encodeURIComponent('${course.name} - E-Learning Platform: ' + window.location.href);
        window.open('https://wa.me/?text=' + text, '_blank');
    }

    function copyLink() {
        navigator.clipboard.writeText(window.location.href).then(() => {
            // Show toast notification
            showToast('Đã sao chép link!', 'success');
        });
    }

    function addToWishlist() {
        // Implementation for wishlist
        console.log('Added to wishlist');
    }

    // Load more reviews
    function loadMoreReviews() {
        // Implementation for loading more reviews
        console.log('Loading more reviews...');
    }
</script>
</body>
</html>

/*
===============================
MAIN JAVASCRIPT FILE
===============================
File: /static/js/main.js
*/

/**
* Main JavaScript file cho E-Learning Platform
* Chứa các functions và utilities chung cho toàn bộ ứng dụng
*/

// Global App Object
window.ELearningApp = {
// Configuration
config: {
apiBaseUrl: '/api/v1',
toastDuration: 3000,
scrollOffset: 100
},

// Utility functions
utils: {},

// Components
components: {},

// Modules
modules: {}
};

// Document Ready
document.addEventListener('DOMContentLoaded', function() {
console.log('🚀 E-Learning Platform initialized');

// Initialize common features
initializeCommonFeatures();
initializeBootstrapComponents();
initializeScrollBehavior();
initializeToastNotifications();
initializeFormValidation();
initializeLazyLoading();

// Initialize page-specific features
const bodyClass = document.body.className;
if (bodyClass.includes('homepage')) {
initializeHomepage();
} else if (bodyClass.includes('course-detail')) {
initializeCourseDetail();
} else if (bodyClass.includes('dashboard')) {
initializeDashboard();
}
});

/**
* Initialize common features
*/
function initializeCommonFeatures() {
// Back to top button
initializeBackToTop();

// Search functionality
initializeSearch();

// Navigation features
initializeNavigation();

// Loading states
initializeLoadingStates();
}

/**
* Back to top button functionality
*/
function initializeBackToTop() {
const backToTopBtn = document.getElementById('back-to-top');
if (!backToTopBtn) return;

// Show/hide button based on scroll position
window.addEventListener('scroll', function() {
if (window.pageYOffset > 300) {
backToTopBtn.classList.add('show');
} else {
backToTopBtn.classList.remove('show');
}
});

// Scroll to top on click
backToTopBtn.addEventListener('click', function(e) {
e.preventDefault();
window.scrollTo({
top: 0,
behavior: 'smooth'
});
});
}

/**
* Search functionality
*/
function initializeSearch() {
const searchInput = document.querySelector('input[name="q"]');
if (!searchInput) return;

let searchTimeout;

searchInput.addEventListener('input', function() {
clearTimeout(searchTimeout);
const query = this.value.trim();

if (query.length >= 2) {
searchTimeout = setTimeout(() => {
performSearch(query);
}, 300);
} else {
hideSearchResults();
}
});

// Hide results when clicking outside
document.addEventListener('click', function(e) {
if (!e.target.closest('.search-container')) {
hideSearchResults();
}
});
}

/**
* Perform search and show results
*/
function performSearch(query) {
const resultsContainer = getOrCreateSearchResults();
resultsContainer.innerHTML = '<div class="p-3 text-center"><i class="fas fa-spinner fa-spin"></i> Đang tìm...</div>';

fetch(`/api/v1/search?query=${encodeURIComponent(query)}&limit=5`)
.then(response => response.json())
.then(data => {
if (data.success) {
displaySearchResults(data.data);
} else {
throw new Error(data.message);
}
})
.catch(error => {
console.error('Search error:', error);
resultsContainer.innerHTML = '<div class="p-3 text-muted">Có lỗi xảy ra khi tìm kiếm</div>';
});
}

/**
* Display search results
*/
function displaySearchResults(results) {
const resultsContainer = getOrCreateSearchResults();
let html = '';

if (results.courses && results.courses.length > 0) {
html += '<div class="search-section"><h6 class="px-3 py-2 mb-0 bg-light">Khóa học</h6>';
results.courses.forEach(course => {
html += `
<div class="search-result-item">
    <div class="search-result-title">${course.name}</div>
    <div class="search-result-description">${course.instructor.fullName}</div>
    <a href="/courses/${course.id}" class="stretched-link"></a>
</div>
`;
});
html += '</div>';
}

if (results.instructors && results.instructors.length > 0) {
html += '<div class="search-section"><h6 class="px-3 py-2 mb-0 bg-light">Giảng viên</h6>';
results.instructors.forEach(instructor => {
html += `
<div class="search-result-item">
    <div class="search-result-title">${instructor.fullName}</div>
    <div class="search-result-description">Giảng viên</div>
    <a href="/instructors/${instructor.id}" class="stretched-link"></a>
</div>
`;
});
html += '</div>';
}

if (html === '') {
html = '<div class="p-3 text-muted">Không tìm thấy kết quả nào</div>';
}

resultsContainer.innerHTML = html;
}

/**
* Get or create search results container
*/
function getOrCreateSearchResults() {
let container = document.querySelector('.search-results');
if (!container) {
container = document.createElement('div');
container.className = 'search-results';
const searchContainer = document.querySelector('.search-container') ||
document.querySelector('input[name="q"]').closest('.input-group');
if (searchContainer) {
searchContainer.appendChild(container);
}
}
return container;
}

/**
* Hide search results
*/
function hideSearchResults() {
const resultsContainer = document.querySelector('.search-results');
if (resultsContainer) {
resultsContainer.remove();
}
}

/**
* Initialize navigation features
*/
function initializeNavigation() {
// Mobile menu toggle
const sidebarToggle = document.getElementById('sidebar-toggle');
const sidebar = document.getElementById('sidebar');
const overlay = document.getElementById('sidebar-overlay');

if (sidebarToggle && sidebar) {
sidebarToggle.addEventListener('click', function() {
sidebar.classList.toggle('show');
overlay?.classList.toggle('active');
});
}

if (overlay) {
overlay.addEventListener('click', function() {
sidebar?.classList.remove('show');
this.classList.remove('active');
});
}

// Dropdown hover effect for desktop
if (window.innerWidth >= 992) {
const dropdowns = document.querySelectorAll('.dropdown');
dropdowns.forEach(dropdown => {
dropdown.addEventListener('mouseenter', function() {
const dropdownToggle = this.querySelector('.dropdown-toggle');
const dropdownMenu = this.querySelector('.dropdown-menu');
if (dropdownToggle && dropdownMenu) {
dropdownToggle.click();
}
});

dropdown.addEventListener('mouseleave', function() {
const dropdownToggle = this.querySelector('.dropdown-toggle');
if (dropdownToggle) {
const dropdown = bootstrap.Dropdown.getInstance(dropdownToggle);
if (dropdown) {
dropdown.hide();
}
}
});
});
}
}

/**
* Initialize Bootstrap components
*/
function initializeBootstrapComponents() {
// Initialize tooltips
const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
tooltipTriggerList.map(function(tooltipTriggerEl) {
return new bootstrap.Tooltip(tooltipTriggerEl);
});

// Initialize popovers
const popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
popoverTriggerList.map(function(popoverTriggerEl) {
return new bootstrap.Popover(popoverTriggerEl);
});
}

/**
* Initialize scroll behavior
*/
function initializeScrollBehavior() {
// Smooth scrolling for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
anchor.addEventListener('click', function(e) {
const target = document.querySelector(this.getAttribute('href'));
if (target) {
e.preventDefault();
target.scrollIntoView({
behavior: 'smooth',
block: 'start'
});
}
});
});

// Navbar scroll effect
const navbar = document.querySelector('.navbar');
if (navbar) {
window.addEventListener('scroll', function() {
if (window.scrollY > 100) {
navbar.classList.add('scrolled');
} else {
navbar.classList.remove('scrolled');
}
});
}
}

/**
* Toast notification system
*/
function initializeToastNotifications() {
// Create toast container if not exists
if (!document.querySelector('.toast-container')) {
const container = document.createElement('div');
container.className = 'toast-container position-fixed top-0 end-0 p-3';
container.style.zIndex = '9999';
document.body.appendChild(container);
}
}

/**
* Show toast notification
*/
function showToast(message, type = 'info', duration = 3000) {
const container = document.querySelector('.toast-container');
if (!container) return;

const toastId = 'toast-' + Date.now();
const iconMap = {
success: 'fa-check-circle',
error: 'fa-exclamation-circle',
warning: 'fa-exclamation-triangle',
info: 'fa-info-circle'
};

const colorMap = {
success: 'text-success',
error: 'text-danger',
warning: 'text-warning',
info: 'text-primary'
};

const toastHTML = `
<div id="${toastId}" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
    <div class="toast-header">
        <i class="fas ${iconMap[type]} ${colorMap[type]} me-2"></i>
        <strong class="me-auto">Thông báo</strong>
        <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
    </div>
    <div class="toast-body">
        ${message}
    </div>
</div>
`;

container.insertAdjacentHTML('beforeend', toastHTML);

const toastElement = document.getElementById(toastId);
const toast = new bootstrap.Toast(toastElement, {
delay: duration
});

toast.show();

// Remove element after hiding
toastElement.addEventListener('hidden.bs.toast', function() {
this.remove();
});
}

/**
* Initialize form validation
*/
function initializeFormValidation() {
// Custom validation for forms
const forms = document.querySelectorAll('.needs-validation');
forms.forEach(form => {
form.addEventListener('submit', function(event) {
if (!form.checkValidity()) {
event.preventDefault();
event.stopPropagation();

// Focus on first invalid field
const firstInvalid = form.querySelector(':invalid');
if (firstInvalid) {
firstInvalid.focus();
}
}
form.classList.add('was-validated');
});
});

// Real-time validation
const inputs = document.querySelectorAll('input[required], textarea[required], select[required]');
inputs.forEach(input => {
input.addEventListener('blur', function() {
if (this.checkValidity()) {
this.classList.remove('is-invalid');
this.classList.add('is-valid');
} else {
this.classList.remove('is-valid');
this.classList.add('is-invalid');
}
});
});
}

/**
* Initialize lazy loading for images
*/
function initializeLazyLoading() {
if ('IntersectionObserver' in window) {
const imageObserver = new IntersectionObserver((entries, observer) => {
entries.forEach(entry => {
if (entry.isIntersecting) {
const img = entry.target;
img.src = img.dataset.src;
img.classList.remove('lazy');
imageObserver.unobserve(img);
}
});
});

document.querySelectorAll('img[data-src]').forEach(img => {
imageObserver.observe(img);
});
}
}

/**
* Initialize loading states
*/
function initializeLoadingStates() {
// Show loading overlay
window.showLoading = function() {
const overlay = document.getElementById('loading-spinner');
if (overlay) {
overlay.classList.add('active');
}
};

// Hide loading overlay
window.hideLoading = function() {
const overlay = document.getElementById('loading-spinner');
if (overlay) {
overlay.classList.remove('active');
}
};

// Auto-hide loading on page load
window.addEventListener('load', function() {
hideLoading();
});
}

/**
* AJAX Setup with CSRF token
*/
if (window.jQuery) {
$.ajaxSetup({
beforeSend: function(xhr) {
if (window.APP_CONFIG && window.APP_CONFIG.csrfToken) {
xhr.setRequestHeader(window.APP_CONFIG.csrfHeader, window.APP_CONFIG.csrfToken);
}
}
});
}

/**
* Utility Functions
*/
window.ELearningApp.utils = {
// Format currency
formatCurrency: function(amount) {
return new Intl.NumberFormat('vi-VN', {
style: 'currency',
currency: 'VND'
}).format(amount);
},

// Format duration
formatDuration: function(minutes) {
if (minutes < 60) {
return minutes + ' phút';
}
const hours = Math.floor(minutes / 60);
const mins = minutes % 60;
return hours + 'h' + (mins > 0 ? ' ' + mins + 'm' : '');
},

// Debounce function
debounce: function(func, wait) {
let timeout;
return function executedFunction(...args) {
const later = () => {
clearTimeout(timeout);
func(...args);
};
clearTimeout(timeout);
timeout = setTimeout(later, wait);
};
},

// Throttle function
throttle: function(func, limit) {
let inThrottle;
return function() {
const args = arguments;
const context = this;
if (!inThrottle) {
func.apply(context, args);
inThrottle = true;
setTimeout(() => inThrottle = false, limit);
}
};
}
};

/**
* Export functions to global scope
*/
window.showToast = showToast;
window.showLoading = window.ELearningApp.showLoading || function() {};
window.hideLoading = window.ELearningApp.hideLoading || function() {};

console.log('✅ Main.js loaded successfully');<%--
===============================
COURSE DETAIL PAGE
===============================
File: /WEB-INF/views/courses/detail.jsp
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="pageTitle" value="${course.name}" />
<c:set var="pageCSS" value="course-detail.css" />
<c:set var="pageJS" value="course-detail.js" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${course.name} - E-Learning Platform</title>

    <%-- SEO Meta Tags --%>
    <meta name="description" content="${fn:substring(course.description, 0, 160)}">
    <meta name="keywords" content="${course.category.name}, ${course.instructor.fullName}, online course">

    <%-- Open Graph Tags --%>
    <meta property="og:title" content="${course.name}">
    <meta property="og:description" content="${fn:substring(course.description, 0, 160)}">
    <meta property="og:image" content="${course.imageUrl}">
    <meta property="og:type" content="article">

    <%-- CSS --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="/css/main.css" rel="stylesheet">
    <link href="/css/components.css" rel="stylesheet">
    <link href="/css/course-detail.css" rel="stylesheet">

    <%-- JSON-LD Structured Data --%>
    <script type="application/ld+json">
        {
          "@context": "https://schema.org",
          "@type": "Course",
          "name": "${course.name}",
      "description": "${course.description}",
      "image": "${course.imageUrl}",
      "provider": {
        "@type": "Organization",
        "name": "E-Learning Platform"
      },
      "instructor": {
        "@type": "Person",
        "name": "${course.instructor.fullName}"
      },
      "coursePrerequisites": "${course.prerequisites}",
      "educationalLevel": "${course.difficultyLevel}",
      "offers": {
        "@type": "Offer",
        "price": "${course.price}",
        "priceCurrency": "VND"
      }
    }
    </script>
</head>

<body class="course-detail-page">
<%-- Header --%>
<jsp:include page="../layout/header.jsp" />

<%-- Course Hero Section --%>
<section class="course-hero">
    <div class="course-hero-bg">
        <img src="${course.imageUrl}" alt="${course.name}" class="hero-bg-image"
             onerror="this.src='/images/default-course-hero.jpg'">
        <div class="hero-overlay"></div>
    </div>

    <div class="container">
        <div class="row">
            <div class="col-lg-8">
                <div class="course-hero-content">
                    <%-- Breadcrumb --%>
                    <nav aria-label="breadcrumb" class="mb-3">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="/" class="text-white-50">Trang chủ</a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="/courses" class="text-white-50">Khóa học</a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="/courses?category=${course.category.id}" class="text-white-50">
                                    ${course.category.name}
                                </a>
                            </li>
                            <li class="breadcrumb-item active text-white">${course.name}</li>
                        </ol>
                    </nav>

                    <%-- Course Info --%>
                    <div class="course-badges mb-3">
                        <span class="badge bg-primary">${course.category.name}</span>
                        <span class="badge bg-${course.difficultyLevel == 'BEGINNER' ? 'success' : course.difficultyLevel == 'INTERMEDIATE' ? 'warning' : 'danger'}">
                            ${course.difficultyLevel == 'BEGINNER' ? 'Cơ bản' : course.difficultyLevel == 'INTERMEDIATE' ? 'Trung bình' : 'Nâng cao'}
                        </span>
                        <c:if test="${course.featured}">
                                <span class="badge bg-warning">
                                    <i class="fas fa-star me-1"></i>Nổi bật
                                </span>
                        </c:if>
                    </div>

                    <h1 class="course-title text-white mb-3">${course.name}</h1>
                    <p class="course-subtitle text-white-50 mb-4">${course.description}</p>

                    <%-- Course Stats --%>
                    <div class="course-stats">
                        <div class="stat-item">
                            <div class="rating">
                                <div class="stars">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="fas fa-star ${i <= course.averageRating ? 'text-warning' : 'text-muted'}"></i>
                                    </c:forEach>
                                </div>
                                <span class="rating-text">${course.averageRating} (${course.reviewCount} đánh giá)</span>
                            </div>
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-users me-2"></i>
                            ${course.enrollmentCount} học viên
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-clock me-2"></i>
                            ${course.formattedDuration}
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-play-circle me-2"></i>
                            ${course.lessonCount} bài học
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-language me-2"></i>
                            ${course.language}
                        </div>
                    </div>

                    <%-- Instructor Info --%>
                    <div class="instructor-info mt-4">
                        <div class="d-flex align-items-center">
                            <img src="${course.instructor.profileImageUrl}" alt="Instructor"
                                 class="instructor-avatar me-3"
                                 onerror="this.src='/images/default-avatar.png'">
                            <div>
                                <div class="instructor-label text-white-50">Giảng viên</div>
                                <div class="instructor-name text-white fw-bold">${course.instructor.fullName}</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<%-- Course Content --%>
<div class="course-content">
    <div class="container">
        <div class="row">
            <%-- Main Content --%>
            <div class="col-lg-8">
                <%-- Course Tabs --%>
                <div class="course-tabs">
                    <ul class="nav nav-tabs nav-fill" id="courseTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="overview-tab" data-bs-toggle="tab"
                                    data-bs-target="#overview" type="button" role="tab">
                                <i class="fas fa-info-circle me-2"></i>Tổng quan
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="curriculum-tab" data-bs-toggle="tab"
                                    data-bs-target="#curriculum" type="button" role="tab">
                                <i class="fas fa-list me-2"></i>Nội dung khóa học
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="instructor-tab" data-bs-toggle="tab"
                                    data-bs-target="#instructor" type="button" role="tab">
                                <i class="fas fa-user me-2"></i>Giảng viên
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="reviews-tab" data-bs-toggle="tab"
                                    data-bs-target="#reviews" type="button" role="tab">
                                <i class="fas fa-star me-2"></i>Đánh giá
                            </button>
                        </li>
                    </ul>

                    <div class="tab-content" id="courseTabsContent">
                        <%-- Overview Tab --%>
                        <div class="tab-pane fade show active" id="overview" role="tabpanel">
                            <div class="overview-content p-4">
                                <h4>Về khóa học này</h4>
                                <div class="course-description">
                                    ${course.detailedDescription}
                                </div>

                                <c:if test="${not empty course.learningObjectives}">
                                    <h5 class="mt-4">Bạn sẽ học được gì</h5>
                                    <div class="learning-objectives">
                                        <ul class="objectives-list">
                                            <c:forEach var="objective" items="${fn:split(course.learningObjectives, '|')}">
                                                <li>
                                                    <i class="fas fa-check text-success me-2"></i>
                                                        ${objective}
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                </c:if>

                                <c:if test="${not empty course.prerequisites}">
                                    <h5 class="mt-4">Yêu cầu</h5>
                                    <div class="prerequisites">
                                        <ul class="prerequisites-list">
                                            <c:forEach var="prerequisite" items="${fn:split(course.prerequisites, '|')}">
                                                <li>
                                                    <i class="fas fa-exclamation-circle text-warning me-2"></i>
                                                        ${prerequisite}
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                </c:if>

                                <%-- Course Features --%>
                                <h5 class="mt-4">Đặc điểm khóa học</h5>
                                <div class="course-features">
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <div class="feature-item">
                                                <i class="fas fa-infinity text-primary me-2"></i>
                                                Truy cập trọn đời
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="feature-item">
                                                <i class="fas fa-mobile-alt text-primary me-2"></i>
                                                Học trên mọi thiết bị
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="feature-item">
                                                <i class="fas fa-certificate text-primary me-2"></i>
                                                Chứng chỉ hoàn thành
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="feature-item">
                                                <i class="fas fa-question-circle text-primary me-2"></i>
                                                Hỗ trợ Q&A
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- Curriculum Tab --%>
                        <div class="tab-pane fade" id="curriculum" role="tabpanel">
                            <div class="curriculum-content p-4">
                                <div class="curriculum-header mb-4">
                                    <h4>Nội dung khóa học</h4>
                                    <p class="text-muted">
                                        ${course.lessonCount} bài học • ${course.formattedDuration} •
                                        ${course.quizCount} bài kiểm tra
                                    </p>
                                </div>

                                <div class="lessons-list">
                                    <c:forEach var="lesson" items="${course.lessons}" varStatus="status">
                                        <div class="lesson-item ${lesson.preview ? 'preview' : isEnrolled ? 'accessible' : 'locked'}">
                                            <div class="lesson-header">
                                                <div class="lesson-info">
                                                    <div class="lesson-number">${status.index + 1}</div>
                                                    <div class="lesson-content">
                                                        <h6 class="lesson-title">${lesson.title}</h6>
                                                        <p class="lesson-description">${lesson.content}</p>
                                                    </div>
                                                </div>
                                                <div class="lesson-meta">
                                                    <div class="lesson-duration">
                                                        <i class="fas fa-clock me-1"></i>
                                                            ${lesson.estimatedDuration} phút
                                                    </div>
                                                    <c:if test="${lesson.preview}">
                                                        <span class="badge bg-success">Preview</span>
                                                    </c:if>
                                                    <c:if test="${not lesson.preview and not isEnrolled}">
                                                        <i class="fas fa-lock text-muted"></i>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <c:if test="${lesson.preview or isEnrolled}">
                                                <div class="lesson-actions">
                                                    <c:choose>
                                                        <c:when test="${lesson.preview}">
                                                            <button class="btn btn-sm btn-outline-primary"
                                                                    onclick="previewLesson(${lesson.id})">
                                                                <i class="fas fa-play me-1"></i>Preview
                                                            </button>
                                                        </c:when>
                                                        <c:when test="${isEnrolled}">
                                                            <a href="/student/courses/${course.id}/lessons/${lesson.id}"
                                                               class="btn btn-sm btn-primary">
                                                                <i class="fas fa-play me-1"></i>Học bài
                                                            </a>
                                                        </c:when>
                                                    </c:choose>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <%-- Instructor Tab --%>
                        <div class="tab-pane fade" id="instructor" role="tabpanel">
                            <div class="instructor-detail p-4">
                                <div class="instructor-profile">
                                    <div class="row">
                                        <div class="col-md-3">
                                            <img src="${course.instructor.profileImageUrl}"
                                                 alt="${course.instructor.fullName}"
                                                 class="instructor-photo"
                                                 onerror="this.src='/images/default-avatar.png'">
                                        </div>
                                        <div class="col-md-9">
                                            <h4>${course.instructor.fullName}</h4>
                                            <p class="instructor-title text-muted">${course.instructor.jobTitle}</p>
                                            <div class="instructor-bio">
                                                ${course.instructor.bio}
                                            </div>

                                            <div class="instructor-stats mt-3">
                                                <div class="row g-3">
                                                    <div class="col-auto">
                                                        <div class="stat-item">
                                                            <div class="stat-number">${course.instructor.totalCourses}</div>
                                                            <div class="stat-label">Khóa học</div>
                                                        </div>
                                                    </div>
                                                    <div class="col-auto">
                                                        <div class="stat-item">
                                                            <div class="stat-number">${course.instructor.totalStudents}</div>
                                                            <div class="stat-label">Học viên</div>
                                                        </div>
                                                    </div>
                                                    <div class="col-auto">
                                                        <div class="stat-item">
                                                            <div class="stat-number">${course.instructor.averageRating}</div>
                                                            <div class="stat-label">Đánh giá</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <%-- Other Courses by Instructor --%>
                                <c:if test="${not empty instructorOtherCourses}">
                                    <h5 class="mt-4">Khóa học khác của giảng viên</h5>
                                    <div class="row g-3">
                                        <c:forEach var="otherCourse" items="${instructorOtherCourses}">
                                            <div class="col-md-6">
                                                <div class="mini-course-card">
                                                    <img src="${otherCourse.imageUrl}" alt="${otherCourse.name}"
                                                         onerror="this.src='/images/default-course.png'">
                                                    <div class="mini-course-info">
                                                        <h6>${otherCourse.name}</h6>
                                                        <div class="mini-course-meta">
                                                                <span class="rating">
                                                                    <i class="fas fa-star text-warning"></i>
                                                                    ${otherCourse.averageRating}
                                                                </span>
                                                            <span class="price">
                                                                    <c:choose>
                                                                        <c:when test="${otherCourse.price > 0}">
                                                                            <fmt:formatNumber value="${otherCourse.price}"
                                                                                              type="currency" currencySymbol="₫" />
                                                                        </c:when>
                                                                        <c:otherwise>Miễn phí</c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                        </div>
                                                        <a href="/courses/${otherCourse.id}" class="stretched-link"></a>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <%-- Reviews Tab --%>
                        <div class="tab-pane fade" id="reviews" role="tabpanel">
                            <div class="reviews-content p-4">
                                <%-- Reviews Summary --%>
                                <div class="reviews-summary">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="rating-overview text-center">
                                                <div class="overall-rating">${course.averageRating}</div>
                                                <div class="stars mb-2">
                                                    <c:forEach begin="1" end="5" var="i">
                                                        <i class="fas fa-star ${i <= course.averageRating ? 'text-warning' : 'text-muted'}"></i>
                                                    </c:forEach>
                                                </div>
                                                <div class="rating-count">${course.reviewCount} đánh giá</div>
                                            </div>
                                        </div>
                                        <div class="col-md-8">
                                            <div class="rating-breakdown">
                                                <c:forEach begin="5" end="1" step="-1" var="star">
                                                    <div class="rating-row">
                                                        <span class="rating-label">${star} sao</span>
                                                        <div class="rating-bar">
                                                            <div class="rating-fill" style="width: ${course.ratingDistribution[star-1]}%"></div>
                                                        </div>
                                                        <span class="rating-percent">${course.ratingDistribution[star-1]}%</span>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <%-- Reviews List --%>
                                <div class="reviews-list mt-4">
                                    <c:forEach var="review" items="${courseReviews}">
                                        <div class="review-item">
                                            <div class="review-header">
                                                <div class="reviewer-info">
                                                    <img src="${review.user.profileImageUrl}"
                                                         alt="${review.user.fullName}" class="reviewer-avatar"
                                                         onerror="this.src='/images/default-avatar.png'">
                                                    <div>
                                                        <div class="reviewer-name">${review.user.fullName}</div>
                                                        <div class="review-date">
                                                            <fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy" />
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="review-rating">
                                                    <c:forEach begin="1" end="5" var="i">
                                                        <i class="fas fa-star ${i <= review.rating ? 'text-warning' : 'text-muted'}"></i>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div class="review-content">
                                                    ${review.comment}
                                            </div>
                                            <div class="review-actions">
                                                <button class="btn btn-sm btn-outline-secondary">
                                                    <i class="fas fa-thumbs-up me-1"></i>
                                                    Hữu ích (${review.helpfulCount})
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <%-- Load More Reviews --%>
                                <c:if test="${hasMoreReviews}">
                                    <div class="text-center mt-4">
                                        <button class="btn btn-outline-primary" onclick="loadMoreReviews()">
                                            <i class="fas fa-plus me-2"></i>Xem thêm đánh giá
                                        </button>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Sidebar --%>
            <div class="col-lg-4">
                <div class="course-sidebar sticky-top">
                    <%-- Course Card --%>
                    <div class="course-card">
                        <div class="course-preview">
                            <img src="${course.imageUrl}" alt="${course.name}" class="course-image"
                                 onerror="this.src='/images/default-course.png'">
                            <div class="preview-overlay">
                                <button class="btn btn-lg btn-light" onclick="openPreviewModal()">
                                    <i class="fas fa-play me-2"></i>Xem trước
                                </button>
                            </div>
                        </div>

                        <div class="course-card-body">
                            <%-- Price --%>
                            <div class="course-price mb-3">
                                <c:choose>
                                    <c:when test="${course.price > 0}">
                                        <div class="current-price">
                                            <fmt:formatNumber value="${course.price}" type="currency"
                                                              currencySymbol="₫" maxFractionDigits="0" />
                                        </div>
                                        <c:if test="${not empty course.originalPrice and course.originalPrice > course.price}">
                                            <div class="original-price">
                                                <fmt:formatNumber value="${course.originalPrice}" type="currency"
                                                                  currencySymbol="₫" maxFractionDigits="0" />
                                            </div>
                                            <div class="discount-percent">
                                                -${course.discountPercent}%
                                            </div>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="free-price">Miễn phí</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <%-- Action Buttons --%>
                            <div class="course-actions">
                                <sec:authorize access="!isAuthenticated()">
                                    <a href="/login" class="btn btn-primary btn-lg w-100 mb-2">
                                        <i class="fas fa-shopping-cart me-2"></i>Đăng ký khóa học
                                    </a>
                                    <a href="/register" class="btn btn-outline-primary w-100">
                                        Tạo tài khoản miễn phí
                                    </a>
                                </sec:authorize>

                                <sec:authorize access="isAuthenticated()">
                                    <c:choose>
                                        <c:when test="${isEnrolled}">
                                            <a href="/student/courses/${course.id}" class="btn btn-success btn-lg w-100 mb-2">
                                                <i class="fas fa-play me-2"></i>Tiếp tục học
                                            </a>
                                            <div class="enrollment-info">
                                                <div class="progress mb-2">
                                                    <div class="progress-bar" style="width: ${enrollmentProgress}%"></div>
                                                </div>
                                                <small class="text-muted">Hoàn thành ${enrollmentProgress}%</small>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-primary btn-lg w-100 mb-2" onclick="enrollCourse()">
                                                <i class="fas fa-shopping-cart me-2"></i>Đăng ký khóa học
                                            </button>
                                            <button class="btn btn-outline-secondary w-100" onclick="addToWishlist()">
                                                <i class="fas fa-heart me-2"></i>Thêm vào yêu thích
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </sec:authorize>
                            </div>

                            <%-- Course Includes --%>
                            <div class="course-includes mt-4">
                                <h6>Khóa học bao gồm:</h6>
                                <ul class="includes-list">
                                    <li>
                                        <i class="fas fa-play-circle me-2"></i>
                                        ${course.lessonCount} bài học video
                                    </li>
                                    <li>
                                        <i class="fas fa-question-circle me-2"></i>
                                        ${course.quizCount} bài kiểm tra
                                    </li>
                                    <li>
                                        <i class="fas fa-infinity me-2"></i>
                                        Truy cập trọn đời
                                    </li>
                                    <li>
                                        <i class="fas fa-mobile-alt me-2"></i>
                                        Học trên mọi thiết bị
                                    </li>
                                    <li>
                                        <i class="fas fa-certificate me-2"></i>
                                        Chứng chỉ hoàn thành
                                    </li>
                                </ul>
                            </div>

                            <%-- Share Buttons --%>
                            <div class="share-buttons mt-4">
                                <h6>Chia sẻ khóa học:</h6>
                                <div class="d-flex gap-2">
                                    <button class="btn btn-outline-primary" onclick="shareOnFacebook()">
                                        <i class="fab fa-facebook-f"></i>
                                    </button>
                                    <button class="btn btn-outline-info" onclick="shareOnTwitter()">
                                        <i class="fab fa-twitter"></i>
                                    </button>
                                    <button class="btn btn-outline-success" onclick="shareOnWhatsapp()">
                                        <i class="fab fa-whatsapp"></i>
                                    </button>
                                    <button class="btn btn-outline-secondary" onclick="copyLink()">
                                        <i class="fas fa-link"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- Related Courses --%>
<section class="related-courses py-5 bg-light">
    <div class="container">
        <h3 class="mb-4">Khóa học liên quan</h3>
        <div class="row g-4">
            <c:forEach var="relatedCourse" items="${relatedCourses}">
                <div class="col-lg-3 col-md-6">
                    <div class="course-card">
                        <img src="${relatedCourse.imageUrl}" alt="${relatedCourse.name}"
                             class="card-img-top"
                             onerror="this.src='/images/default-course.png'">
                        <div class="card-body">
                            <h6 class="card-title">${relatedCourse.name}</h6>
                            <p class="card-text text-muted small">${relatedCourse.instructor.fullName}</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="rating">
                                    <i class="fas fa-star text-warning"></i>
                                        ${relatedCourse.averageRating}
                                </div>
                                <div class="price">
                                    <c:choose>
                                        <c:when test="${relatedCourse.price > 0}">
                                            <fmt:formatNumber value="${relatedCourse.price}" type="currency"
                                                              currencySymbol="₫" maxFractionDigits="0" />
                                        </c:when>
                                        <c:otherwise>Miễn phí</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <a href="/courses/${relatedCourse.id}" class="stretched-link"></a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<%-- Footer --%>
<jsp:include page="../layout/footer.jsp" />

<%-- Preview Modal --%>
<div class="modal fade" id="previewModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Xem trước khóa học</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="video-container">
                    <video id="previewVideo" controls class="w-100">
                        <source src="${course.previewVideoUrl}" type="video/mp4">
                        Trình duyệt không hỗ trợ video.
                    </video>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- JavaScript --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="/js/main.js"></script>
<script src="/js/course-detail.js"></script>

<script>
    // Course enrollment
    function enrollCourse() {
        <sec:authorize access="!isAuthenticated()">
        window.location.href = '/login?redirect=' + encodeURIComponent(window.location.href);
        return;
        </sec:authorize>

        const courseId = ${course.id};

        // Show loading state
        const btn = event.target;
        const originalText = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
        btn.disabled = true;

        fetch('/api/v1/enrollments', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                [window.APP_CONFIG.csrfHeader]: window.APP_CONFIG.csrfToken
            },
            body: 'courseId=' + courseId
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Show success message
                    btn.innerHTML = '<i class="fas fa-check me-2"></i>Đăng ký thành công!';
                    btn.classList.remove('btn-primary');
                    btn.classList.add('btn-success');

                    // Redirect after delay
                    setTimeout(() => {
                        window.location.href = '/student/courses/' + courseId;
                    }, 2000);
                } else {
                    throw new Error(data.message || 'Có lỗi xảy ra');
                }
            })
            .catch(error => {
                btn.innerHTML = originalText;
                btn.disabled = false;
                alert('Lỗi: ' + error.message);
            });
    }

    // Preview modal
    function openPreviewModal() {
        const modal = new bootstrap.Modal(document.getElementById('previewModal'));
        modal.show();
    }

    // Preview lesson
    function previewLesson(lessonId) {
        // Implementation for lesson preview
        window.open('/lessons/' + lessonId + '/preview', '_blank');
    }

    // Share functions
    function shareOnFacebook() {
        const url = encodeURIComponent(window.location.href);
        window.open('https://www.facebook.com/sharer/sharer.php?u=' + url, '_blank');
    }

    function shareOnTwitter() {
        const url = encodeURIComponent(window.location.href);
        const text = encodeURIComponent('${course.name} - E-Learning Platform');
        window.open('https://twitter.com/intent/tweet?url=' + url + '&text=' + text, '_blank');
    }

    function shareOnWhatsapp() {
        const url = encodeURIComponent(window.location.href);
        const text = encodeURIComponent('${course.name} - E-Learning Platform: ' + window.location.href);
        window.open('https://wa.me/?text=' + text, '_blank');
    }

    function copyLink() {
        navigator.clipboard.writeText(window.location.href).then(() => {
            // Show toast notification
            showToast('Đã sao chép link!', 'success');
        });
    }

    function addToWishlist() {
        // Implementation for wishlist
        console.log('Added to wishlist');
    }

    // Load more reviews
    function loadMoreReviews() {
        // Implementation for loading more reviews
        console.log('Loading more reviews...');
    }
</script>
</body>
</html>

/*
===============================
MAIN JAVASCRIPT FILE
===============================
File: /static/js/main.js
*/

/**
* Main JavaScript file cho E-Learning Platform
* Chứa các functions và utilities chung cho toàn bộ ứng dụng
*/

// Global App Object
window.ELearningApp = {
// Configuration
config: {
apiBaseUrl: '/api/v1',
toastDuration: 3000,
scrollOffset: 100
},

// Utility functions
utils: {},

// Components
components: {},

// Modules
modules: {}
};

// Document Ready
document.addEventListener('DOMContentLoaded', function() {
console.log('🚀 E-Learning Platform initialized');

// Initialize common features
initializeCommonFeatures();
initializeBootstrapComponents();
initializeScrollBehavior();
initializeToastNotifications();
initializeFormValidation();
initializeLazyLoading();

// Initialize page-specific features
const bodyClass = document.body.className;
if (bodyClass.includes('homepage')) {
initializeHomepage();
} else if (bodyClass.includes('course-detail')) {
initializeCourseDetail();
} else if (bodyClass.includes('dashboard')) {
initializeDashboard();
}
});

/**
* Initialize common features
*/
function initializeCommonFeatures() {
// Back to top button
initializeBackToTop();

// Search functionality
initializeSearch();

// Navigation features
initializeNavigation();

// Loading states
initializeLoadingStates();
}

/**
* Back to top button functionality
*/
function initializeBackToTop() {
const backToTopBtn = document.getElementById('back-to-top');
if (!backToTopBtn) return;

// Show/hide button based on scroll position
window.addEventListener('scroll', function() {
if (window.pageYOffset > 300) {
backToTopBtn.classList.add('show');
} else {
backToTopBtn.classList.remove('show');
}
});

// Scroll to top on click
backToTopBtn.addEventListener('click', function(e) {
e.preventDefault();
window.scrollTo({
top: 0,
behavior: 'smooth'
});
});
}

/**
* Search functionality
*/
function initializeSearch() {
const searchInput = document.querySelector('input[name="q"]');
if (!searchInput) return;

let searchTimeout;

searchInput.addEventListener('input', function() {
clearTimeout(searchTimeout);
const query = this.value.trim();

if (query.length >= 2) {
searchTimeout = setTimeout(() => {
performSearch(query);
}, 300);
} else {
hideSearchResults();
}
});

// Hide results when clicking outside
document.addEventListener('click', function(e) {
if (!e.target.closest('.search-container')) {
hideSearchResults();
}
});
}

/**
* Perform search and show results
*/
function performSearch(query) {
const resultsContainer = getOrCreateSearchResults();
resultsContainer.innerHTML = '<div class="p-3 text-center"><i class="fas fa-spinner fa-spin"></i> Đang tìm...</div>';

fetch(`/api/v1/search?query=${encodeURIComponent(query)}&limit=5`)
.then(response => response.json())
.then(data => {
if (data.success) {
displaySearchResults(data.data);
} else {
throw new Error(data.message);
}
})
.catch(error => {
console.error('Search error:', error);
resultsContainer.innerHTML = '<div class="p-3 text-muted">Có lỗi xảy ra khi tìm kiếm</div>';
});
}

/**
* Display search results
*/
function displaySearchResults(results) {
const resultsContainer = getOrCreateSearchResults();
let html = '';

if (results.courses && results.courses.length > 0) {
html += '<div class="search-section"><h6 class="px-3 py-2 mb-0 bg-light">Khóa học</h6>';
results.courses.forEach(course => {
html += `
<div class="search-result-item">
    <div class="search-result-title">${course.name}</div>
    <div class="search-result-description">${course.instructor.fullName}</div>
    <a href="/courses/${course.id}" class="stretched-link"></a>
</div>
`;
});
html += '</div>';
}

if (results.instructors && results.instructors.length > 0) {
html += '<div class="search-section"><h6 class="px-3 py-2 mb-0 bg-light">Giảng viên</h6>';
results.instructors.forEach(instructor => {
html += `
<div class="search-result-item">
    <div class="search-result-title">${instructor.fullName}</div>
    <div class="search-result-description">Giảng viên</div>
    <a href="/instructors/${instructor.id}" class="stretched-link"></a>
</div>
`;
});
html += '</div>';
}

if (html === '') {
html = '<div class="p-3 text-muted">Không tìm thấy kết quả nào</div>';
}

resultsContainer.innerHTML = html;
}

/**
* Get or create search results container
*/
function getOrCreateSearchResults() {
let container = document.querySelector('.search-results');
if (!container) {
container = document.createElement('div');
container.className = 'search-results';
const searchContainer = document.querySelector('.search-container') ||
document.querySelector('input[name="q"]').closest('.input-group');
if (searchContainer) {
searchContainer.appendChild(container);
}
}
return container;
}

/**
* Hide search results
*/
function hideSearchResults() {
const resultsContainer = document.querySelector('.search-results');
if (resultsContainer) {
resultsContainer.remove();
}
}

/**
* Initialize navigation features
*/
function initializeNavigation() {
// Mobile menu toggle
const sidebarToggle = document.getElementById('sidebar-toggle');
const sidebar = document.getElementById('sidebar');
const overlay = document.getElementById('sidebar-overlay');

if (sidebarToggle && sidebar) {
sidebarToggle.addEventListener('click', function() {
sidebar.classList.toggle('show');
overlay?.classList.toggle('active');
});
}

if (overlay) {
overlay.addEventListener('click', function() {
sidebar?.classList.remove('show');
this.classList.remove('active');
});
}

// Dropdown hover effect for desktop
if (window.innerWidth >= 992) {
const dropdowns = document.querySelectorAll('.dropdown');
dropdowns.forEach(dropdown => {
dropdown.addEventListener('mouseenter', function() {
const dropdownToggle = this.querySelector('.dropdown-toggle');
const dropdownMenu = this.querySelector('.dropdown-menu');
if (dropdownToggle && dropdownMenu) {
dropdownToggle.click();
}
});

dropdown.addEventListener('mouseleave', function() {
const dropdownToggle = this.querySelector('.dropdown-toggle');
if (dropdownToggle) {
const dropdown = bootstrap.Dropdown.getInstance(dropdownToggle);
if (dropdown) {
dropdown.hide();
}
}
});
});
}
}

/**
* Initialize Bootstrap components
*/
function initializeBootstrapComponents() {
// Initialize tooltips
const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
tooltipTriggerList.map(function(tooltipTriggerEl) {
return new bootstrap.Tooltip(tooltipTriggerEl);
});

// Initialize popovers
const popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
popoverTriggerList.map(function(popoverTriggerEl) {
return new bootstrap.Popover(popoverTriggerEl);
});
}

/**
* Initialize scroll behavior
*/
function initializeScrollBehavior() {
// Smooth scrolling for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
anchor.addEventListener('click', function(e) {
const target = document.querySelector(this.getAttribute('href'));
if (target) {
e.preventDefault();
target.scrollIntoView({
behavior: 'smooth',
block: 'start'
});
}
});
});

// Navbar scroll effect
const navbar = document.querySelector('.navbar');
if (navbar) {
window.addEventListener('scroll', function() {
if (window.scrollY > 100) {
navbar.classList.add('scrolled');
} else {
navbar.classList.remove('scrolled');
}
});
}
}

/**
* Toast notification system
*/
function initializeToastNotifications() {
// Create toast container if not exists
if (!document.querySelector('.toast-container')) {
const container = document.createElement('div');
container.className = 'toast-container position-fixed top-0 end-0 p-3';
container.style.zIndex = '9999';
document.body.appendChild(container);
}
}

/**
* Show toast notification
*/
function showToast(message, type = 'info', duration = 3000) {
const container = document.querySelector('.toast-container');
if (!container) return;

const toastId = 'toast-' + Date.now();
const iconMap = {
success: 'fa-check-circle',
error: 'fa-exclamation-circle',
warning: 'fa-exclamation-triangle',
info: 'fa-info-circle'
};

const colorMap = {
success: 'text-success',
error: 'text-danger',
warning: 'text-warning',
info: 'text-primary'
};

const toastHTML = `
<div id="${toastId}" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
    <div class="toast-header">
        <i class="fas ${iconMap[type]} ${colorMap[type]} me-2"></i>
        <strong class="me-auto">Thông báo</strong>
        <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
    </div>
    <div class="toast-body">
        ${message}
    </div>
</div>
`;

container.insertAdjacentHTML('beforeend', toastHTML);

const toastElement = document.getElementById(toastId);
const toast = new bootstrap.Toast(toastElement, {
delay: duration
});

toast.show();

// Remove element after hiding
toastElement.addEventListener('hidden.bs.toast', function() {
this.remove();
});
}

/**
* Initialize form validation
*/
function initializeFormValidation() {
// Custom validation for forms
const forms = document.querySelectorAll('.needs-validation');
forms.forEach(form => {
form.addEventListener('submit', function(event) {
if (!form.checkValidity()) {
event.preventDefault();
event.stopPropagation();

// Focus on first invalid field
const firstInvalid = form.querySelector(':invalid');
if (firstInvalid) {
firstInvalid.focus();
}
}
form.classList.add('was-validated');
});
});

// Real-time validation
const inputs = document.querySelectorAll('input[required], textarea[required], select[required]');
inputs.forEach(input => {
input.addEventListener('blur', function() {
if (this.checkValidity()) {
this.classList.remove('is-invalid');
this.classList.add('is-valid');
} else {
this.classList.remove('is-valid');
this.classList.add('is-invalid');
}
});
});
}

/**
* Initialize lazy loading for images
*/
function initializeLazyLoading() {
if ('IntersectionObserver' in window) {
const imageObserver = new IntersectionObserver((entries, observer) => {
entries.forEach(entry => {
if (entry.isIntersecting) {
const img = entry.target;
img.src = img.dataset.src;
img.classList.remove('lazy');
imageObserver.unobserve(img);
}
});
});

document.querySelectorAll('img[data-src]').forEach(img => {
imageObserver.observe(img);
});
}
}

/**
* Initialize loading states
*/
function initializeLoadingStates() {
// Show loading overlay
window.showLoading = function() {
const overlay = document.getElementById('loading-spinner');
if (overlay) {
overlay.classList.add('active');
}
};

// Hide loading overlay
window.hideLoading = function() {
const overlay = document.getElementById('loading-spinner');
if (overlay) {
overlay.classList.remove('active');
}
};

// Auto-hide loading on page load
window.addEventListener('load', function() {
hideLoading();
});
}

/**
* AJAX Setup with CSRF token
*/
if (window.jQuery) {
$.ajaxSetup({
beforeSend: function(xhr) {
if (window.APP_CONFIG && window.APP_CONFIG.csrfToken) {
xhr.setRequestHeader(window.APP_CONFIG.csrfHeader, window.APP_CONFIG.csrfToken);
}
}
});
}

/**
* Utility Functions
*/
window.ELearningApp.utils = {
// Format currency
formatCurrency: function(amount) {
return new Intl.NumberFormat('vi-VN', {
style: 'currency',
currency: 'VND'
}).format(amount);
},

// Format duration
formatDuration: function(minutes) {
if (minutes < 60) {
return minutes + ' phút';
}
const hours = Math.floor(minutes / 60);
const mins = minutes % 60;
return hours + 'h' + (mins > 0 ? ' ' + mins + 'm' : '');
},

// Debounce function
debounce: function(func, wait) {
let timeout;
return function executedFunction(...args) {
const later = () => {
clearTimeout(timeout);
func(...args);
};
clearTimeout(timeout);
timeout = setTimeout(later, wait);
};
},

// Throttle function
throttle: function(func, limit) {
let inThrottle;
return function() {
const args = arguments;
const context = this;
if (!inThrottle) {
func.apply(context, args);
inThrottle = true;
setTimeout(() => inThrottle = false, limit);
}
};
}
};

/**
* Export functions to global scope
*/
window.showToast = showToast;
window.showLoading = window.ELearningApp.showLoading || function() {};
window.hideLoading = window.ELearningApp.hideLoading || function() {};

console.log('✅ Main.js loaded successfully');<%--
===============================
COURSE DETAIL PAGE
===============================
File: /WEB-INF/views/courses/detail.jsp
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="pageTitle" value="${course.name}" />
<c:set var="pageCSS" value="course-detail.css" />
<c:set var="pageJS" value="course-detail.js" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${course.name} - E-Learning Platform</title>

    <%-- SEO Meta Tags --%>
    <meta name="description" content="${fn:substring(course.description, 0, 160)}">
    <meta name="keywords" content="${course.category.name}, ${course.instructor.fullName}, online course">

    <%-- Open Graph Tags --%>
    <meta property="og:title" content="${course.name}">
    <meta property="og:description" content="${fn:substring(course.description, 0, 160)}">
    <meta property="og:image" content="${course.imageUrl}">
    <meta property="og:type" content="article">

    <%-- CSS --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="/css/main.css" rel="stylesheet">
    <link href="/css/components.css" rel="stylesheet">
    <link href="/css/course-detail.css" rel="stylesheet">

    <%-- JSON-LD Structured Data --%>
    <script type="application/ld+json">
        {
          "@context": "https://schema.org",
          "@type": "Course",
          "name": "${course.name}",
      "description": "${course.description}",
      "image": "${course.imageUrl}",
      "provider": {
        "@type": "Organization",
        "name": "E-Learning Platform"
      },
      "instructor": {
        "@type": "Person",
        "name": "${course.instructor.fullName}"
      },
      "coursePrerequisites": "${course.prerequisites}",
      "educationalLevel": "${course.difficultyLevel}",
      "offers": {
        "@type": "Offer",
        "price": "${course.price}",
        "priceCurrency": "VND"
      }
    }
    </script>
</head>

<body class="course-detail-page">
<%-- Header --%>
<jsp:include page="../layout/header.jsp" />

<%-- Course Hero Section --%>
<section class="course-hero">
    <div class="course-hero-bg">
        <img src="${course.imageUrl}" alt="${course.name}" class="hero-bg-image"
             onerror="this.src='/images/default-course-hero.jpg'">
        <div class="hero-overlay"></div>
    </div>

    <div class="container">
        <div class="row">
            <div class="col-lg-8">
                <div class="course-hero-content">
                    <%-- Breadcrumb --%>
                    <nav aria-label="breadcrumb" class="mb-3">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="/" class="text-white-50">Trang chủ</a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="/courses" class="text-white-50">Khóa học</a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="/courses?category=${course.category.id}" class="text-white-50">
                                    ${course.category.name}
                                </a>
                            </li>
                            <li class="breadcrumb-item active text-white">${course.name}</li>
                        </ol>
                    </nav>

                    <%-- Course Info --%>
                    <div class="course-badges mb-3">
                        <span class="badge bg-primary">${course.category.name}</span>
                        <span class="badge bg-${course.difficultyLevel == 'BEGINNER' ? 'success' : course.difficultyLevel == 'INTERMEDIATE' ? 'warning' : 'danger'}">
                            ${course.difficultyLevel == 'BEGINNER' ? 'Cơ bản' : course.difficultyLevel == 'INTERMEDIATE' ? 'Trung bình' : 'Nâng cao'}
                        </span>
                        <c:if test="${course.featured}">
                                <span class="badge bg-warning">
                                    <i class="fas fa-star me-1"></i>Nổi bật
                                </span>
                        </c:if>
                    </div>

                    <h1 class="course-title text-white mb-3">${course.name}</h1>
                    <p class="course-subtitle text-white-50 mb-4">${course.description}</p>

                    <%-- Course Stats --%>
                    <div class="course-stats">
                        <div class="stat-item">
                            <div class="rating">
                                <div class="stars">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="fas fa-star ${i <= course.averageRating ? 'text-warning' : 'text-muted'}"></i>
                                    </c:forEach>
                                </div>
                                <span class="rating-text">${course.averageRating} (${course.reviewCount} đánh giá)</span>
                            </div>
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-users me-2"></i>
                            ${course.enrollmentCount} học viên
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-clock me-2"></i>
                            ${course.formattedDuration}
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-play-circle me-2"></i>
                            ${course.lessonCount} bài học
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-language me-2"></i>
                            ${course.language}
                        </div>
                    </div>

                    <%-- Instructor Info --%>
                    <div class="instructor-info mt-4">
                        <div class="d-flex align-items-center">
                            <img src="${course.instructor.profileImageUrl}" alt="Instructor"
                                 class="instructor-avatar me-3"
                                 onerror="this.src='/images/default-avatar.png'">
                            <div>
                                <div class="instructor-label text-white-50">Giảng viên</div>
                                <div class="instructor-name text-white fw-bold">${course.instructor.fullName}</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<%-- Course Content --%>
<div class="course-content">
    <div class="container">
        <div class="row">
            <%-- Main Content --%>
            <div class="col-lg-8">
                <%-- Course Tabs --%>
                <div class="course-tabs">
                    <ul class="nav nav-tabs nav-fill" id="courseTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="overview-tab" data-bs-toggle="tab"
                                    data-bs-target="#overview" type="button" role="tab">
                                <i class="fas fa-info-circle me-2"></i>Tổng quan
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="curriculum-tab" data-bs-toggle="tab"
                                    data-bs-target="#curriculum" type="button" role="tab">
                                <i class="fas fa-list me-2"></i>Nội dung khóa học
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="instructor-tab" data-bs-toggle="tab"
                                    data-bs-target="#instructor" type="button" role="tab">
                                <i class="fas fa-user me-2"></i>Giảng viên
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="reviews-tab" data-bs-toggle="tab"
                                    data-bs-target="#reviews" type="button" role="tab">
                                <i class="fas fa-star me-2"></i>Đánh giá
                            </button>
                        </li>
                    </ul>

                    <div class="tab-content" id="courseTabsContent">
                        <%-- Overview Tab --%>
                        <div class="tab-pane fade show active" id="overview" role="tabpanel">
                            <div class="overview-content p-4">
                                <h4>Về khóa học này</h4>
                                <div class="course-description">
                                    ${course.detailedDescription}
                                </div>

                                <c:if test="${not empty course.learningObjectives}">
                                    <h5 class="mt-4">Bạn sẽ học được gì</h5>
                                    <div class="learning-objectives">
                                        <ul class="objectives-list">
                                            <c:forEach var="objective" items="${fn:split(course.learningObjectives, '|')}">
                                                <li>
                                                    <i class="fas fa-check text-success me-2"></i>
                                                        ${objective}
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                </c:if>

                                <c:if test="${not empty course.prerequisites}">
                                    <h5 class="mt-4">Yêu cầu</h5>
                                    <div class="prerequisites">
                                        <ul class="prerequisites-list">
                                            <c:forEach var="prerequisite" items="${fn:split(course.prerequisites, '|')}">
                                                <li>
                                                    <i class="fas fa-exclamation-circle text-warning me-2"></i>
                                                        ${prerequisite}
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                </c:if>

                                <%-- Course Features --%>
                                <h5 class="mt-4">Đặc điểm khóa học</h5>
                                <div class="course-features">
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <div class="feature-item">
                                                <i class="fas fa-infinity text-primary me-2"></i>
                                                Truy cập trọn đời
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="feature-item">
                                                <i class="fas fa-mobile-alt text-primary me-2"></i>
                                                Học trên mọi thiết bị
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="feature-item">
                                                <i class="fas fa-certificate text-primary me-2"></i>
                                                Chứng chỉ hoàn thành
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="feature-item">
                                                <i class="fas fa-question-circle text-primary me-2"></i>
                                                Hỗ trợ Q&A
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- Curriculum Tab --%>
                        <div class="tab-pane fade" id="curriculum" role="tabpanel">
                            <div class="curriculum-content p-4">
                                <div class="curriculum-header mb-4">
                                    <h4>Nội dung khóa học</h4>
                                    <p class="text-muted">
                                        ${course.lessonCount} bài học • ${course.formattedDuration} •
                                        ${course.quizCount} bài kiểm tra
                                    </p>
                                </div>

                                <div class="lessons-list">
                                    <c:forEach var="lesson" items="${course.lessons}" varStatus="status">
                                        <div class="lesson-item ${lesson.preview ? 'preview' : isEnrolled ? 'accessible' : 'locked'}">
                                            <div class="lesson-header">
                                                <div class="lesson-info">
                                                    <div class="lesson-number">${status.index + 1}</div>
                                                    <div class="lesson-content">
                                                        <h6 class="lesson-title">${lesson.title}</h6>
                                                        <p class="lesson-description">${lesson.content}</p>
                                                    </div>
                                                </div>
                                                <div class="lesson-meta">
                                                    <div class="lesson-duration">
                                                        <i class="fas fa-clock me-1"></i>
                                                            ${lesson.estimatedDuration} phút
                                                    </div>
                                                    <c:if test="${lesson.preview}">
                                                        <span class="badge bg-success">Preview</span>
                                                    </c:if>
                                                    <c:if test="${not lesson.preview and not isEnrolled}">
                                                        <i class="fas fa-lock text-muted"></i>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <c:if test="${lesson.preview or isEnrolled}">
                                                <div class="lesson-actions">
                                                    <c:choose>
                                                        <c:when test="${lesson.preview}">
                                                            <button class="btn btn-sm btn-outline-primary"
                                                                    onclick="previewLesson(${lesson.id})">
                                                                <i class="fas fa-play me-1"></i>Preview
                                                            </button>
                                                        </c:when>
                                                        <c:when test="${isEnrolled}">
                                                            <a href="/student/courses/${course.id}/lessons/${lesson.id}"
                                                               class="btn btn-sm btn-primary">
                                                                <i class="fas fa-play me-1"></i>Học bài
                                                            </a>
                                                        </c:when>
                                                    </c:choose>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <%-- Instructor Tab --%>
                        <div class="tab-pane fade" id="instructor" role="tabpanel">
                            <div class="instructor-detail p-4">
                                <div class="instructor-profile">
                                    <div class="row">
                                        <div class="col-md-3">
                                            <img src="${course.instructor.profileImageUrl}"
                                                 alt="${course.instructor.fullName}"
                                                 class="instructor-photo"
                                                 onerror="this.src='/images/default-avatar.png'">
                                        </div>
                                        <div class="col-md-9">
                                            <h4>${course.instructor.fullName}</h4>
                                            <p class="instructor-title text-muted">${course.instructor.jobTitle}</p>
                                            <div class="instructor-bio">
                                                ${course.instructor.bio}
                                            </div>

                                            <div class="instructor-stats mt-3">
                                                <div class="row g-3">
                                                    <div class="col-auto">
                                                        <div class="stat-item">
                                                            <div class="stat-number">${course.instructor.totalCourses}</div>
                                                            <div class="stat-label">Khóa học</div>
                                                        </div>
                                                    </div>
                                                    <div class="col-auto">
                                                        <div class="stat-item">
                                                            <div class="stat-number">${course.instructor.totalStudents}</div>
                                                            <div class="stat-label">Học viên</div>
                                                        </div>
                                                    </div>
                                                    <div class="col-auto">
                                                        <div class="stat-item">
                                                            <div class="stat-number">${course.instructor.averageRating}</div>
                                                            <div class="stat-label">Đánh giá</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <%-- Other Courses by Instructor --%>
                                <c:if test="${not empty instructorOtherCourses}">
                                    <h5 class="mt-4">Khóa học khác của giảng viên</h5>
                                    <div class="row g-3">
                                        <c:forEach var="otherCourse" items="${instructorOtherCourses}">
                                            <div class="col-md-6">
                                                <div class="mini-course-card">
                                                    <img src="${otherCourse.imageUrl}" alt="${otherCourse.name}"
                                                         onerror="this.src='/images/default-course.png'">
                                                    <div class="mini-course-info">
                                                        <h6>${otherCourse.name}</h6>
                                                        <div class="mini-course-meta">
                                                                <span class="rating">
                                                                    <i class="fas fa-star text-warning"></i>
                                                                    ${otherCourse.averageRating}
                                                                </span>
                                                            <span class="price">
                                                                    <c:choose>
                                                                        <c:when test="${otherCourse.price > 0}">
                                                                            <fmt:formatNumber value="${otherCourse.price}"
                                                                                              type="currency" currencySymbol="₫" />
                                                                        </c:when>
                                                                        <c:otherwise>Miễn phí</c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                        </div>
                                                        <a href="/courses/${otherCourse.id}" class="stretched-link"></a>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <%-- Reviews Tab --%>
                        <div class="tab-pane fade" id="reviews" role="tabpanel">
                            <div class="reviews-content p-4">
                                <%-- Reviews Summary --%>
                                <div class="reviews-summary">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="rating-overview text-center">
                                                <div class="overall-rating">${course.averageRating}</div>
                                                <div class="stars mb-2">
                                                    <c:forEach begin="1" end="5" var="i">
                                                        <i class="fas fa-star ${i <= course.averageRating ? 'text-warning' : 'text-muted'}"></i>
                                                    </c:forEach>
                                                </div>
                                                <div class="rating-count">${course.reviewCount} đánh giá</div>
                                            </div>
                                        </div>
                                        <div class="col-md-8">
                                            <div class="rating-breakdown">
                                                <c:forEach begin="5" end="1" step="-1" var="star">
                                                    <div class="rating-row">
                                                        <span class="rating-label">${star} sao</span>
                                                        <div class="rating-bar">
                                                            <div class="rating-fill" style="width: ${course.ratingDistribution[star-1]}%"></div>
                                                        </div>
                                                        <span class="rating-percent">${course.ratingDistribution[star-1]}%</span>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <%-- Reviews List --%>
                                <div class="reviews-list mt-4">
                                    <c:forEach var="review" items="${courseReviews}">
                                        <div class="review-item">
                                            <div class="review-header">
                                                <div class="reviewer-info">
                                                    <img src="${review.user.profileImageUrl}"
                                                         alt="${review.user.fullName}" class="reviewer-avatar"
                                                         onerror="this.src='/images/default-avatar.png'">
                                                    <div>
                                                        <div class="reviewer-name">${review.user.fullName}</div>
                                                        <div class="review-date">
                                                            <fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy" />
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="review-rating">
                                                    <c:forEach begin="1" end="5" var="i">
                                                        <i class="fas fa-star ${i <= review.rating ? 'text-warning' : 'text-muted'}"></i>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div class="review-content">
                                                    ${review.comment}
                                            </div>
                                            <div class="review-actions">
                                                <button class="btn btn-sm btn-outline-secondary">
                                                    <i class="fas fa-thumbs-up me-1"></i>
                                                    Hữu ích (${review.helpfulCount})
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <%-- Load More Reviews --%>
                                <c:if test="${hasMoreReviews}">
                                    <div class="text-center mt-4">
                                        <button class="btn btn-outline-primary" onclick="loadMoreReviews()">
                                            <i class="fas fa-plus me-2"></i>Xem thêm đánh giá
                                        </button>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Sidebar --%>
            <div class="col-lg-4">
                <div class="course-sidebar sticky-top">
                    <%-- Course Card --%>
                    <div class="course-card">
                        <div class="course-preview">
                            <img src="${course.imageUrl}" alt="${course.name}" class="course-image"
                                 onerror="this.src='/images/default-course.png'">
                            <div class="preview-overlay">
                                <button class="btn btn-lg btn-light" onclick="openPreviewModal()">
                                    <i class="fas fa-play me-2"></i>Xem trước
                                </button>
                            </div>
                        </div>

                        <div class="course-card-body">
                            <%-- Price --%>
                            <div class="course-price mb-3">
                                <c:choose>
                                    <c:when test="${course.price > 0}">
                                        <div class="current-price">
                                            <fmt:formatNumber value="${course.price}" type="currency"
                                                              currencySymbol="₫" maxFractionDigits="0" />
                                        </div>
                                        <c:if test="${not empty course.originalPrice and course.originalPrice > course.price}">
                                            <div class="original-price">
                                                <fmt:formatNumber value="${course.originalPrice}" type="currency"
                                                                  currencySymbol="₫" maxFractionDigits="0" />
                                            </div>
                                            <div class="discount-percent">
                                                -${course.discountPercent}%
                                            </div>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="free-price">Miễn phí</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <%-- Action Buttons --%>
                            <div class="course-actions">
                                <sec:authorize access="!isAuthenticated()">
                                    <a href="/login" class="btn btn-primary btn-lg w-100 mb-2">
                                        <i class="fas fa-shopping-cart me-2"></i>Đăng ký khóa học
                                    </a>
                                    <a href="/register" class="btn btn-outline-primary w-100">
                                        Tạo tài khoản miễn phí
                                    </a>
                                </sec:authorize>

                                <sec:authorize access="isAuthenticated()">
                                    <c:choose>
                                        <c:when test="${isEnrolled}">
                                            <a href="/student/courses/${course.id}" class="btn btn-success btn-lg w-100 mb-2">
                                                <i class="fas fa-play me-2"></i>Tiếp tục học
                                            </a>
                                            <div class="enrollment-info">
                                                <div class="progress mb-2">
                                                    <div class="progress-bar" style="width: ${enrollmentProgress}%"></div>
                                                </div>
                                                <small class="text-muted">Hoàn thành ${enrollmentProgress}%</small>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-primary btn-lg w-100 mb-2" onclick="enrollCourse()">
                                                <i class="fas fa-shopping-cart me-2"></i>Đăng ký khóa học
                                            </button>
                                            <button class="btn btn-outline-secondary w-100" onclick="addToWishlist()">
                                                <i class="fas fa-heart me-2"></i>Thêm vào yêu thích
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </sec:authorize>
                            </div>

                            <%-- Course Includes --%>
                            <div class="course-includes mt-4">
                                <h6>Khóa học bao gồm:</h6>
                                <ul class="includes-list">
                                    <li>
                                        <i class="fas fa-play-circle me-2"></i>
                                        ${course.lessonCount} bài học video
                                    </li>
                                    <li>
                                        <i class="fas fa-question-circle me-2"></i>
                                        ${course.quizCount} bài kiểm tra
                                    </li>
                                    <li>
                                        <i class="fas fa-infinity me-2"></i>
                                        Truy cập trọn đời
                                    </li>
                                    <li>
                                        <i class="fas fa-mobile-alt me-2"></i>
                                        Học trên mọi thiết bị
                                    </li>
                                    <li>
                                        <i class="fas fa-certificate me-2"></i>
                                        Chứng chỉ hoàn thành
                                    </li>
                                </ul>
                            </div>

                            <%-- Share Buttons --%>
                            <div class="share-buttons mt-4">
                                <h6>Chia sẻ khóa học:</h6>
                                <div class="d-flex gap-2">
                                    <button class="btn btn-outline-primary" onclick="shareOnFacebook()">
                                        <i class="fab fa-facebook-f"></i>
                                    </button>
                                    <button class="btn btn-outline-info" onclick="shareOnTwitter()">
                                        <i class="fab fa-twitter"></i>
                                    </button>
                                    <button class="btn btn-outline-success" onclick="shareOnWhatsapp()">
                                        <i class="fab fa-whatsapp"></i>
                                    </button>
                                    <button class="btn btn-outline-secondary" onclick="copyLink()">
                                        <i class="fas fa-link"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- Related Courses --%>
<section class="related-courses py-5 bg-light">
    <div class="container">
        <h3 class="mb-4">Khóa học liên quan</h3>
        <div class="row g-4">
            <c:forEach var="relatedCourse" items="${relatedCourses}">
                <div class="col-lg-3 col-md-6">
                    <div class="course-card">
                        <img src="${relatedCourse.imageUrl}" alt="${relatedCourse.name}"
                             class="card-img-top"
                             onerror="this.src='/images/default-course.png'">
                        <div class="card-body">
                            <h6 class="card-title">${relatedCourse.name}</h6>
                            <p class="card-text text-muted small">${relatedCourse.instructor.fullName}</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="rating">
                                    <i class="fas fa-star text-warning"></i>
                                        ${relatedCourse.averageRating}
                                </div>
                                <div class="price">
                                    <c:choose>
                                        <c:when test="${relatedCourse.price > 0}">
                                            <fmt:formatNumber value="${relatedCourse.price}" type="currency"
                                                              currencySymbol="₫" maxFractionDigits="0" />
                                        </c:when>
                                        <c:otherwise>Miễn phí</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <a href="/courses/${relatedCourse.id}" class="stretched-link"></a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<%-- Footer --%>
<jsp:include page="../layout/footer.jsp" />

<%-- Preview Modal --%>
<div class="modal fade" id="previewModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Xem trước khóa học</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="video-container">
                    <video id="previewVideo" controls class="w-100">
                        <source src="${course.previewVideoUrl}" type="video/mp4">
                        Trình duyệt không hỗ trợ video.
                    </video>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- JavaScript --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="/js/main.js"></script>
<script src="/js/course-detail.js"></script>

<script>
    // Course enrollment
    function enrollCourse() {
        <sec:authorize access="!isAuthenticated()">
        window.location.href = '/login?redirect=' + encodeURIComponent(window.location.href);
        return;
        </sec:authorize>

        const courseId = ${course.id};

        // Show loading state
        const btn = event.target;
        const originalText = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
        btn.disabled = true;

        fetch('/api/v1/enrollments', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                [window.APP_CONFIG.csrfHeader]: window.APP_CONFIG.csrfToken
            },
            body: 'courseId=' + courseId
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Show success message
                    btn.innerHTML = '<i class="fas fa-check me-2"></i>Đăng ký thành công!';
                    btn.classList.remove('btn-primary');
                    btn.classList.add('btn-success');

                    // Redirect after delay
                    setTimeout(() => {
                        window.location.href = '/student/courses/' + courseId;
                    }, 2000);
                } else {
                    throw new Error(data.message || 'Có lỗi xảy ra');
                }
            })
            .catch(error => {
                btn.innerHTML = originalText;
                btn.disabled = false;
                alert('Lỗi: ' + error.message);
            });
    }

    // Preview modal
    function openPreviewModal() {
        const modal = new bootstrap.Modal(document.getElementById('previewModal'));
        modal.show();
    }

    // Preview lesson
    function previewLesson(lessonId) {
        // Implementation for lesson preview
        window.open('/lessons/' + lessonId + '/preview', '_blank');
    }

    // Share functions
    function shareOnFacebook() {
        const url = encodeURIComponent(window.location.href);
        window.open('https://www.facebook.com/sharer/sharer.php?u=' + url, '_blank');
    }

    function shareOnTwitter() {
        const url = encodeURIComponent(window.location.href);
        const text = encodeURIComponent('${course.name} - E-Learning Platform');
        window.open('https://twitter.com/intent/tweet?url=' + url + '&text=' + text, '_blank');
    }

    function shareOnWhatsapp() {
        const url = encodeURIComponent(window.location.href);
        const text = encodeURIComponent('${course.name} - E-Learning Platform: ' + window.location.href);
        window.open('https://wa.me/?text=' + text, '_blank');
    }

    function copyLink() {
        navigator.clipboard.writeText(window.location.href).then(() => {
            // Show toast notification
            showToast('Đã sao chép link!', 'success');
        });
    }

    function addToWishlist() {
        // Implementation for wishlist
        console.log('Added to wishlist');
    }

    // Load more reviews
    function loadMoreReviews() {
        // Implementation for loading more reviews
        console.log('Loading more reviews...');
    }
</script>
</body>
</html>

/*
===============================
MAIN JAVASCRIPT FILE
===============================
File: /static/js/main.js
*/

/**
* Main JavaScript file cho E-Learning Platform
* Chứa các functions và utilities chung cho toàn bộ ứng dụng
*/

// Global App Object
window.ELearningApp = {
// Configuration
config: {
apiBaseUrl: '/api/v1',
toastDuration: 3000,
scrollOffset: 100
},

// Utility functions
utils: {},

// Components
components: {},

// Modules
modules: {}
};

// Document Ready
document.addEventListener('DOMContentLoaded', function() {
console.log('🚀 E-Learning Platform initialized');

// Initialize common features
initializeCommonFeatures();
initializeBootstrapComponents();
initializeScrollBehavior();
initializeToastNotifications();
initializeFormValidation();
initializeLazyLoading();

// Initialize page-specific features
const bodyClass = document.body.className;
if (bodyClass.includes('homepage')) {
initializeHomepage();
} else if (bodyClass.includes('course-detail')) {
initializeCourseDetail();
} else if (bodyClass.includes('dashboard')) {
initializeDashboard();
}
});

/**
* Initialize common features
*/
function initializeCommonFeatures() {
// Back to top button
initializeBackToTop();

// Search functionality
initializeSearch();

// Navigation features
initializeNavigation();

// Loading states
initializeLoadingStates();
}

/**
* Back to top button functionality
*/
function initializeBackToTop() {
const backToTopBtn = document.getElementById('back-to-top');
if (!backToTopBtn) return;

// Show/hide button based on scroll position
window.addEventListener('scroll', function() {
if (window.pageYOffset > 300) {
backToTopBtn.classList.add('show');
} else {
backToTopBtn.classList.remove('show');
}
});

// Scroll to top on click
backToTopBtn.addEventListener('click', function(e) {
e.preventDefault();
window.scrollTo({
top: 0,
behavior: 'smooth'
});
});
}

/**
* Search functionality
*/
function initializeSearch() {
const searchInput = document.querySelector('input[name="q"]');
if (!searchInput) return;

let searchTimeout;

searchInput.addEventListener('input', function() {
clearTimeout(searchTimeout);
const query = this.value.trim();

if (query.length >= 2) {
searchTimeout = setTimeout(() => {
performSearch(query);
}, 300);
} else {
hideSearchResults();
}
});

// Hide results when clicking outside
document.addEventListener('click', function(e) {
if (!e.target.closest('.search-container')) {
hideSearchResults();
}
});
}

/**
* Perform search and show results
*/
function performSearch(query) {
const resultsContainer = getOrCreateSearchResults();
resultsContainer.innerHTML = '<div class="p-3 text-center"><i class="fas fa-spinner fa-spin"></i> Đang tìm...</div>';

fetch(`/api/v1/search?query=${encodeURIComponent(query)}&limit=5`)
.then(response => response.json())
.then(data => {
if (data.success) {
displaySearchResults(data.data);
} else {
throw new Error(data.message);
}
})
.catch(error => {
console.error('Search error:', error);
resultsContainer.innerHTML = '<div class="p-3 text-muted">Có lỗi xảy ra khi tìm kiếm</div>';
});
}

/**
* Display search results
*/
function displaySearchResults(results) {
const resultsContainer = getOrCreateSearchResults();
let html = '';

if (results.courses && results.courses.length > 0) {
html += '<div class="search-section"><h6 class="px-3 py-2 mb-0 bg-light">Khóa học</h6>';
results.courses.forEach(course => {
html += `
<div class="search-result-item">
    <div class="search-result-title">${course.name}</div>
    <div class="search-result-description">${course.instructor.fullName}</div>
    <a href="/courses/${course.id}" class="stretched-link"></a>
</div>
`;
});
html += '</div>';
}

if (results.instructors && results.instructors.length > 0) {
html += '<div class="search-section"><h6 class="px-3 py-2 mb-0 bg-light">Giảng viên</h6>';
results.instructors.forEach(instructor => {
html += `
<div class="search-result-item">
    <div class="search-result-title">${instructor.fullName}</div>
    <div class="search-result-description">Giảng viên</div>
    <a href="/instructors/${instructor.id}" class="stretched-link"></a>
</div>
`;
});
html += '</div>';
}

if (html === '') {
html = '<div class="p-3 text-muted">Không tìm thấy kết quả nào</div>';
}

resultsContainer.innerHTML = html;
}

/**
* Get or create search results container
*/
function getOrCreateSearchResults() {
let container = document.querySelector('.search-results');
if (!container) {
container = document.createElement('div');
container.className = 'search-results';
const searchContainer = document.querySelector('.search-container') ||
document.querySelector('input[name="q"]').closest('.input-group');
if (searchContainer) {
searchContainer.appendChild(container);
}
}
return container;
}

/**
* Hide search results
*/
function hideSearchResults() {
const resultsContainer = document.querySelector('.search-results');
if (resultsContainer) {
resultsContainer.remove();
}
}

/**
* Initialize navigation features
*/
function initializeNavigation() {
// Mobile menu toggle
const sidebarToggle = document.getElementById('sidebar-toggle');
const sidebar = document.getElementById('sidebar');
const overlay = document.getElementById('sidebar-overlay');

if (sidebarToggle && sidebar) {
sidebarToggle.addEventListener('click', function() {
sidebar.classList.toggle('show');
overlay?.classList.toggle('active');
});
}

if (overlay) {
overlay.addEventListener('click', function() {
sidebar?.classList.remove('show');
this.classList.remove('active');
});
}

// Dropdown hover effect for desktop
if (window.innerWidth >= 992) {
const dropdowns = document.querySelectorAll('.dropdown');
dropdowns.forEach(dropdown => {
dropdown.addEventListener('mouseenter', function() {
const dropdownToggle = this.querySelector('.dropdown-toggle');
const dropdownMenu = this.querySelector('.dropdown-menu');
if (dropdownToggle && dropdownMenu) {
dropdownToggle.click();
}
});

dropdown.addEventListener('mouseleave', function() {
const dropdownToggle = this.querySelector('.dropdown-toggle');
if (dropdownToggle) {
const dropdown = bootstrap.Dropdown.getInstance(dropdownToggle);
if (dropdown) {
dropdown.hide();
}
}
});
});
}
}

/**
* Initialize Bootstrap components
*/
function initializeBootstrapComponents() {
// Initialize tooltips
const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
tooltipTriggerList.map(function(tooltipTriggerEl) {
return new bootstrap.Tooltip(tooltipTriggerEl);
});

// Initialize popovers
const popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
popoverTriggerList.map(function(popoverTriggerEl) {
return new bootstrap.Popover(popoverTriggerEl);
});
}

/**
* Initialize scroll behavior
*/
function initializeScrollBehavior() {
// Smooth scrolling for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
anchor.addEventListener('click', function(e) {
const target = document.querySelector(this.getAttribute('href'));
if (target) {
e.preventDefault();
target.scrollIntoView({
behavior: 'smooth',
block: 'start'
});
}
});
});

// Navbar scroll effect
const navbar = document.querySelector('.navbar');
if (navbar) {
window.addEventListener('scroll', function() {
if (window.scrollY > 100) {
navbar.classList.add('scrolled');
} else {
navbar.classList.remove('scrolled');
}
});
}
}

/**
* Toast notification system
*/
function initializeToastNotifications() {
// Create toast container if not exists
if (!document.querySelector('.toast-container')) {
const container = document.createElement('div');
container.className = 'toast-container position-fixed top-0 end-0 p-3';
container.style.zIndex = '9999';
document.body.appendChild(container);
}
}

/**
* Show toast notification
*/
function showToast(message, type = 'info', duration = 3000) {
const container = document.querySelector('.toast-container');
if (!container) return;

const toastId = 'toast-' + Date.now();
const iconMap = {
success: 'fa-check-circle',
error: 'fa-exclamation-circle',
warning: 'fa-exclamation-triangle',
info: 'fa-info-circle'
};

const colorMap = {
success: 'text-success',
error: 'text-danger',
warning: 'text-warning',
info: 'text-primary'
};

const toastHTML = `
<div id="${toastId}" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
    <div class="toast-header">
        <i class="fas ${iconMap[type]} ${colorMap[type]} me-2"></i>
        <strong class="me-auto">Thông báo</strong>
        <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
    </div>
    <div class="toast-body">
        ${message}
    </div>
</div>
`;

container.insertAdjacentHTML('beforeend', toastHTML);

const toastElement = document.getElementById(toastId);
const toast = new bootstrap.Toast(toastElement, {
delay: duration
});

toast.show();

// Remove element after hiding
toastElement.addEventListener('hidden.bs.toast', function() {
this.remove();
});
}

/**
* Initialize form validation
*/
function initializeFormValidation() {
// Custom validation for forms
const forms = document.querySelectorAll('.needs-validation');
forms.forEach(form => {
form.addEventListener('submit', function(event) {
if (!form.checkValidity()) {
event.preventDefault();
event.stopPropagation();

// Focus on first invalid field
const firstInvalid = form.querySelector(':invalid');
if (firstInvalid) {
firstInvalid.focus();
}
}
form.classList.add('was-validated');
});
});

// Real-time validation
const inputs = document.querySelectorAll('input[required], textarea[required], select[required]');
inputs.forEach(input => {
input.addEventListener('blur', function() {
if (this.checkValidity()) {
this.classList.remove('is-invalid');
this.classList.add('is-valid');
} else {
this.classList.remove('is-valid');
this.classList.add('is-invalid');
}
});
});
}

/**
* Initialize lazy loading for images
*/
function initializeLazyLoading() {
if ('IntersectionObserver' in window) {
const imageObserver = new IntersectionObserver((entries, observer) => {
entries.forEach(entry => {
if (entry.isIntersecting) {
const img = entry.target;
img.src = img.dataset.src;
img.classList.remove('lazy');
imageObserver.unobserve(img);
}
});
});

document.querySelectorAll('img[data-src]').forEach(img => {
imageObserver.observe(img);
});
}
}

/**
* Initialize loading states
*/
function initializeLoadingStates() {
// Show loading overlay
window.showLoading = function() {
const overlay = document.getElementById('loading-spinner');
if (overlay) {
overlay.classList.add('active');
}
};

// Hide loading overlay
window.hideLoading = function() {
const overlay = document.getElementById('loading-spinner');
if (overlay) {
overlay.classList.remove('active');
}
};

// Auto-hide loading on page load
window.addEventListener('load', function() {
hideLoading();
});
}

/**
* AJAX Setup with CSRF token
*/
if (window.jQuery) {
$.ajaxSetup({
beforeSend: function(xhr) {
if (window.APP_CONFIG && window.APP_CONFIG.csrfToken) {
xhr.setRequestHeader(window.APP_CONFIG.csrfHeader, window.APP_CONFIG.csrfToken);
}
}
});
}

/**
* Utility Functions
*/
window.ELearningApp.utils = {
// Format currency
formatCurrency: function(amount) {
return new Intl.NumberFormat('vi-VN', {
style: 'currency',
currency: 'VND'
}).format(amount);
},

// Format duration
formatDuration: function(minutes) {
if (minutes < 60) {
return minutes + ' phút';
}
const hours = Math.floor(minutes / 60);
const mins = minutes % 60;
return hours + 'h' + (mins > 0 ? ' ' + mins + 'm' : '');
},

// Debounce function
debounce: function(func, wait) {
let timeout;
return function executedFunction(...args) {
const later = () => {
clearTimeout(timeout);
func(...args);
};
clearTimeout(timeout);
timeout = setTimeout(later, wait);
};
},

// Throttle function
throttle: function(func, limit) {
let inThrottle;
return function() {
const args = arguments;
const context = this;
if (!inThrottle) {
func.apply(context, args);
inThrottle = true;
setTimeout(() => inThrottle = false, limit);
}
};
}
};

/**
* Export functions to global scope
*/
window.showToast = showToast;
window.showLoading = window.ELearningApp.showLoading || function() {};
window.hideLoading = window.ELearningApp.hideLoading || function() {};

console.log('✅ Main.js loaded successfully');