<%--
===============================
HOMEPAGE - Landing Page
===============================
File: /WEB-INF/views/home.jsp
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="pageTitle" value="Trang chủ" />
<c:set var="bodyClass" value="homepage" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>E-Learning Platform - Học trực tuyến hàng đầu Việt Nam</title>

    <%-- SEO Meta Tags --%>
    <meta name="description" content="Nền tảng học tập trực tuyến với hơn 1000+ khóa học chất lượng cao. Học mọi lúc, mọi nơi với chứng chỉ được công nhận.">
    <meta name="keywords" content="e-learning, học trực tuyến, khóa học online, lập trình, thiết kế, marketing">
    <meta name="author" content="E-Learning Platform">

    <%-- Open Graph Tags --%>
    <meta property="og:title" content="E-Learning Platform - Học trực tuyến hàng đầu">
    <meta property="og:description" content="Nền tảng học tập trực tuyến với 1000+ khóa học chất lượng cao">
    <meta property="og:image" content="/images/og-image.jpg">
    <meta property="og:url" content="${pageContext.request.requestURL}">
    <meta property="og:type" content="website">

    <%-- CSS --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="/css/main.css" rel="stylesheet">
    <link href="/css/components.css" rel="stylesheet">
    <link href="/css/responsive.css" rel="stylesheet">

    <%-- JSON-LD Structured Data --%>
    <script type="application/ld+json">
        {
          "@context": "https://schema.org",
          "@type": "EducationalOrganization",
          "name": "E-Learning Platform",
          "description": "Nền tảng học tập trực tuyến hàng đầu Việt Nam",
          "url": "${pageContext.request.requestURL}",
      "logo": "/images/logo.png",
      "address": {
        "@type": "PostalAddress",
        "addressCountry": "VN"
      }
    }
    </script>
</head>

<body class="homepage">
<%-- Header --%>
<jsp:include page="layout/header.jsp" />

<%-- Hero Section --%>
<section class="hero-section">
    <div class="hero-background">
        <div class="hero-overlay"></div>
        <video autoplay muted loop class="hero-video">
            <source src="/videos/hero-bg.mp4" type="video/mp4">
        </video>
    </div>

    <div class="container">
        <div class="row align-items-center min-vh-100">
            <div class="col-lg-6">
                <div class="hero-content">
                    <h1 class="hero-title fade-in-up">
                        Học tập không giới hạn cùng
                        <span class="text-gradient">E-Learning Platform</span>
                    </h1>
                    <p class="hero-description fade-in-up" data-delay="200">
                        Khám phá hơn <strong>1,000+ khóa học</strong> chất lượng cao được giảng dạy bởi
                        các chuyên gia hàng đầu. Học mọi lúc, mọi nơi với phương pháp hiện đại.
                    </p>

                    <div class="hero-stats fade-in-up" data-delay="400">
                        <div class="stat-item">
                            <div class="stat-number">${totalStudents}+</div>
                            <div class="stat-label">Học viên</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number">${totalCourses}+</div>
                            <div class="stat-label">Khóa học</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number">${totalInstructors}+</div>
                            <div class="stat-label">Giảng viên</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number">4.8★</div>
                            <div class="stat-label">Đánh giá</div>
                        </div>
                    </div>

                    <div class="hero-actions fade-in-up" data-delay="600">
                        <sec:authorize access="!isAuthenticated()">
                            <a href="/register" class="btn btn-primary btn-lg me-3">
                                <i class="fas fa-rocket me-2"></i>Bắt đầu học ngay
                            </a>
                            <a href="/courses" class="btn btn-outline-light btn-lg">
                                <i class="fas fa-play me-2"></i>Xem khóa học
                            </a>
                        </sec:authorize>

                        <sec:authorize access="isAuthenticated()">
                            <sec:authorize access="hasRole('STUDENT')">
                                <a href="/student/dashboard" class="btn btn-primary btn-lg me-3">
                                    <i class="fas fa-tachometer-alt me-2"></i>Vào Dashboard
                                </a>
                            </sec:authorize>
                            <sec:authorize access="hasAnyRole('ADMIN', 'INSTRUCTOR')">
                                <a href="/${role.toLowerCase()}/dashboard" class="btn btn-primary btn-lg me-3">
                                    <i class="fas fa-tachometer-alt me-2"></i>Vào Dashboard
                                </a>
                            </sec:authorize>
                            <a href="/courses" class="btn btn-outline-light btn-lg">
                                <i class="fas fa-search me-2"></i>Khám phá khóa học
                            </a>
                        </sec:authorize>
                    </div>
                </div>
            </div>

            <div class="col-lg-6">
                <div class="hero-visual fade-in-up" data-delay="800">
                    <div class="floating-cards">
                        <div class="floating-card card-1">
                            <i class="fas fa-code"></i>
                            <h6>Lập trình</h6>
                            <p>300+ khóa học</p>
                        </div>
                        <div class="floating-card card-2">
                            <i class="fas fa-palette"></i>
                            <h6>Thiết kế</h6>
                            <p>200+ khóa học</p>
                        </div>
                        <div class="floating-card card-3">
                            <i class="fas fa-bullhorn"></i>
                            <h6>Marketing</h6>
                            <p>150+ khóa học</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- Scroll Down Indicator --%>
    <div class="scroll-indicator">
        <div class="scroll-arrow">
            <i class="fas fa-chevron-down"></i>
        </div>
    </div>
</section>

<%-- Featured Categories Section --%>
<section class="categories-section py-5">
    <div class="container">
        <div class="section-header text-center mb-5">
            <h2 class="section-title">Khám phá các danh mục phổ biến</h2>
            <p class="section-description">
                Tìm kiếm khóa học phù hợp với mục tiêu và sở thích của bạn
            </p>
        </div>

        <div class="row g-4">
            <c:forEach var="category" items="${featuredCategories}" varStatus="status">
                <div class="col-lg-4 col-md-6">
                    <div class="category-card fade-in-up" data-delay="${status.index * 100}">
                        <div class="category-icon" style="background: ${category.colorCode}">
                            <i class="${category.iconClass}"></i>
                        </div>
                        <div class="category-content">
                            <h5 class="category-name">${category.name}</h5>
                            <p class="category-description">${category.description}</p>
                            <div class="category-stats">
                                <span class="course-count">${category.courseCount} khóa học</span>
                                <span class="student-count">${category.studentCount} học viên</span>
                            </div>
                        </div>
                        <a href="/courses?category=${category.id}" class="category-link">
                            <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<%-- Featured Courses Section --%>
<section class="featured-courses-section py-5 bg-light">
    <div class="container">
        <div class="section-header text-center mb-5">
            <h2 class="section-title">Khóa học nổi bật</h2>
            <p class="section-description">
                Những khóa học được yêu thích và đánh giá cao nhất
            </p>
        </div>

        <div class="row g-4">
            <c:forEach var="course" items="${featuredCourses}" varStatus="status">
                <div class="col-lg-4 col-md-6">
                    <div class="course-card fade-in-up" data-delay="${status.index * 100}">
                        <div class="course-image">
                            <img src="${course.imageUrl}" alt="${course.name}" class="card-img-top"
                                 onerror="this.src='/images/default-course.png'">
                            <div class="course-category-badge">${course.category.name}</div>
                            <c:if test="${course.featured}">
                                <div class="featured-badge">
                                    <i class="fas fa-star"></i>
                                </div>
                            </c:if>
                        </div>

                        <div class="card-body">
                            <h5 class="course-title">${course.name}</h5>
                            <p class="course-description">
                                    ${fn:substring(course.description, 0, 100)}...
                            </p>

                            <div class="instructor-info">
                                <img src="${course.instructor.profileImageUrl}" alt="Instructor"
                                     class="instructor-avatar"
                                     onerror="this.src='/images/default-avatar.png'">
                                <span class="instructor-name">${course.instructor.fullName}</span>
                            </div>

                            <div class="course-stats">
                                <div class="rating">
                                    <div class="stars">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="fas fa-star ${i <= course.averageRating ? 'text-warning' : 'text-muted'}"></i>
                                        </c:forEach>
                                    </div>
                                    <span class="rating-text">${course.averageRating} (${course.reviewCount})</span>
                                </div>
                                <div class="enrollment-count">
                                    <i class="fas fa-users me-1"></i>
                                        ${course.enrollmentCount} học viên
                                </div>
                            </div>

                            <div class="course-footer">
                                <div class="course-price ${course.price > 0 ? '' : 'free'}">
                                    <c:choose>
                                        <c:when test="${course.price > 0}">
                                            <fmt:formatNumber value="${course.price}" type="currency"
                                                              currencySymbol="₫" maxFractionDigits="0" />
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-success fw-bold">Miễn phí</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <a href="/courses/${course.id}" class="btn btn-primary">
                                    Xem chi tiết
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <div class="text-center mt-5">
            <a href="/courses" class="btn btn-outline-primary btn-lg">
                <i class="fas fa-search me-2"></i>Xem tất cả khóa học
            </a>
        </div>
    </div>
</section>

<%-- Why Choose Us Section --%>
<section class="features-section py-5">
    <div class="container">
        <div class="section-header text-center mb-5">
            <h2 class="section-title">Tại sao chọn chúng tôi?</h2>
            <p class="section-description">
                Những ưu điểm vượt trội giúp bạn học tập hiệu quả
            </p>
        </div>

        <div class="row g-4">
            <div class="col-lg-4 col-md-6">
                <div class="feature-card fade-in-up">
                    <div class="feature-icon">
                        <i class="fas fa-graduation-cap"></i>
                    </div>
                    <h5 class="feature-title">Chất lượng cao</h5>
                    <p class="feature-description">
                        Tất cả khóa học được thiết kế bởi các chuyên gia hàng đầu
                        với nội dung cập nhật và thực tiễn.
                    </p>
                </div>
            </div>

            <div class="col-lg-4 col-md-6">
                <div class="feature-card fade-in-up" data-delay="100">
                    <div class="feature-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <h5 class="feature-title">Linh hoạt thời gian</h5>
                    <p class="feature-description">
                        Học mọi lúc, mọi nơi với lịch trình phù hợp.
                        Truy cập trọn đời cho tất cả khóa học đã mua.
                    </p>
                </div>
            </div>

            <div class="col-lg-4 col-md-6">
                <div class="feature-card fade-in-up" data-delay="200">
                    <div class="feature-icon">
                        <i class="fas fa-certificate"></i>
                    </div>
                    <h5 class="feature-title">Chứng chỉ uy tín</h5>
                    <p class="feature-description">
                        Nhận chứng chỉ hoàn thành được công nhận rộng rãi
                        trong ngành và có thể chia sẻ trên LinkedIn.
                    </p>
                </div>
            </div>

            <div class="col-lg-4 col-md-6">
                <div class="feature-card fade-in-up" data-delay="300">
                    <div class="feature-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <h5 class="feature-title">Cộng đồng hỗ trợ</h5>
                    <p class="feature-description">
                        Tham gia cộng đồng học viên sôi động, trao đổi kinh nghiệm
                        và nhận hỗ trợ từ giảng viên.
                    </p>
                </div>
            </div>

            <div class="col-lg-4 col-md-6">
                <div class="feature-card fade-in-up" data-delay="400">
                    <div class="feature-icon">
                        <i class="fas fa-mobile-alt"></i>
                    </div>
                    <h5 class="feature-title">Đa nền tảng</h5>
                    <p class="feature-description">
                        Tương thích hoàn hảo trên máy tính, tablet và điện thoại.
                        Học offline với tính năng tải về.
                    </p>
                </div>
            </div>

            <div class="col-lg-4 col-md-6">
                <div class="feature-card fade-in-up" data-delay="500">
                    <div class="feature-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h5 class="feature-title">Đảm bảo chất lượng</h5>
                    <p class="feature-description">
                        Hoàn tiền 100% trong 30 ngày nếu không hài lòng.
                        Cam kết chất lượng giáo dục tốt nhất.
                    </p>
                </div>
            </div>
        </div>
    </div>
</section>

<%-- Testimonials Section --%>
<section class="testimonials-section py-5 bg-primary text-white">
    <div class="container">
        <div class="section-header text-center mb-5">
            <h2 class="section-title text-white">Học viên nói gì về chúng tôi</h2>
            <p class="section-description text-white-50">
                Hàng ngàn học viên đã thành công với các khóa học của chúng tôi
            </p>
        </div>

        <div class="testimonials-slider">
            <div class="row g-4">
                <c:forEach var="testimonial" items="${testimonials}" varStatus="status">
                    <div class="col-lg-4 col-md-6">
                        <div class="testimonial-card">
                            <div class="testimonial-content">
                                <div class="quote-icon">
                                    <i class="fas fa-quote-left"></i>
                                </div>
                                <p class="testimonial-text">"${testimonial.content}"</p>
                                <div class="testimonial-rating">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="fas fa-star ${i <= testimonial.rating ? 'text-warning' : 'text-muted'}"></i>
                                    </c:forEach>
                                </div>
                            </div>
                            <div class="testimonial-author">
                                <img src="${testimonial.user.profileImageUrl}" alt="Student"
                                     class="author-avatar"
                                     onerror="this.src='/images/default-avatar.png'">
                                <div class="author-info">
                                    <h6 class="author-name">${testimonial.user.fullName}</h6>
                                    <p class="author-title">${testimonial.user.jobTitle}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</section>

<%-- Newsletter Section --%>
<section class="newsletter-section py-5">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-6">
                <h3 class="newsletter-title">Đăng ký nhận thông tin khóa học mới</h3>
                <p class="newsletter-description">
                    Nhận thông báo về khóa học mới, khuyến mãi đặc biệt và tips học tập hiệu quả.
                </p>
            </div>
            <div class="col-lg-6">
                <form class="newsletter-form" id="newsletterForm">
                    <div class="input-group input-group-lg">
                        <input type="email" class="form-control" placeholder="Nhập email của bạn"
                               name="email" required>
                        <button class="btn btn-primary" type="submit">
                            <i class="fas fa-paper-plane me-2"></i>Đăng ký
                        </button>
                    </div>
                    <small class="text-muted">
                        Chúng tôi tôn trọng quyền riêng tư của bạn. Không spam!
                    </small>
                </form>
            </div>
        </div>
    </div>
</section>

<%-- Footer --%>
<jsp:include page="layout/footer.jsp" />

<%-- Back to Top Button --%>
<button id="back-to-top" class="btn btn-primary btn-floating">
    <i class="fas fa-arrow-up"></i>
</button>

<%-- JavaScript --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="/js/main.js"></script>
<script src="/js/homepage.js"></script>

<script>
    // Smooth scrolling for scroll indicator
    document.querySelector('.scroll-indicator').addEventListener('click', function() {
        document.querySelector('.categories-section').scrollIntoView({
            behavior: 'smooth'
        });
    });

    // Newsletter form submission
    document.getElementById('newsletterForm').addEventListener('submit', function(e) {
        e.preventDefault();
        const email = this.email.value;

        // Show loading state
        const btn = this.querySelector('button');
        const originalText = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
        btn.disabled = true;

        // Simulate API call
        setTimeout(() => {
            // Show success message
            btn.innerHTML = '<i class="fas fa-check me-2"></i>Thành công!';
            btn.classList.remove('btn-primary');
            btn.classList.add('btn-success');

            // Reset after 3 seconds
            setTimeout(() => {
                btn.innerHTML = originalText;
                btn.classList.remove('btn-success');
                btn.classList.add('btn-primary');
                btn.disabled = false;
                this.reset();
            }, 3000);
        }, 2000);
    });

    // Intersection Observer for animations
    const observeElements = document.querySelectorAll('.fade-in-up');
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const delay = entry.target.dataset.delay || 0;
                setTimeout(() => {
                    entry.target.style.animation = `fadeInUp 0.6s ease-out forwards`;
                }, delay);
                observer.unobserve(entry.target);
            }
        });
    }, { threshold: 0.1 });

    observeElements.forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(30px)';
        observer.observe(el);
    });
</script>
</body>
</html>

<%--
===============================
COURSE LISTING PAGE
===============================
File: /WEB-INF/views/courses/list.jsp
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="Khóa học" />
<c:set var="pageCSS" value="courses.css" />
<c:set var="pageJS" value="courses.js" />

<div class="courses-page">
    <%-- Page Header --%>
    <div class="page-header bg-primary text-white py-5">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <h1 class="page-title mb-2">Khám phá khóa học</h1>
                    <p class="page-description mb-0">
                        Hơn ${totalCourses} khóa học từ cơ bản đến nâng cao
                    </p>
                </div>
                <div class="col-lg-4 text-lg-end">
                    <div class="search-box">
                        <form action="/courses" method="get" class="search-form">
                            <div class="input-group">
                                <input type="text" class="form-control" name="search"
                                       value="${param.search}" placeholder="Tìm kiếm khóa học...">
                                <button class="btn btn-light" type="submit">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container mt-4">
        <div class="row">
            <%-- Sidebar Filters --%>
            <div class="col-lg-3 col-md-4">
                <div class="filters-sidebar">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="fas fa-filter me-2"></i>
                                Bộ lọc
                            </h5>
                        </div>
                        <div class="card-body">
                            <form id="filterForm" action="/courses" method="get">
                                <input type="hidden" name="search" value="${param.search}">

                                <%-- Category Filter --%>
                                <div class="filter-group mb-4">
                                    <h6 class="filter-title">Danh mục</h6>
                                    <c:forEach var="category" items="${categories}">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox"
                                                   name="categories" value="${category.id}"
                                                   id="category_${category.id}"
                                                ${fn:contains(paramValues.categories, category.id.toString()) ? 'checked' : ''}>
                                            <label class="form-check-label" for="category_${category.id}">
                                                    ${category.name} (${category.courseCount})
                                            </label>
                                        </div>
                                    </c:forEach>
                                </div>

                                <%-- Difficulty Filter --%>
                                <div class="filter-group mb-4">
                                    <h6 class="filter-title">Mức độ</h6>
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox"
                                               name="difficulty" value="BEGINNER" id="diff_beginner"
                                        ${fn:contains(paramValues.difficulty, 'BEGINNER') ? 'checked' : ''}>
                                        <label class="form-check-label" for="diff_beginner">
                                            Cơ bản
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox"
                                               name="difficulty" value="INTERMEDIATE" id="diff_intermediate"
                                        ${fn:contains(paramValues.difficulty, 'INTERMEDIATE') ? 'checked' : ''}>
                                        <label class="form-check-label" for="diff_intermediate">
                                            Trung bình
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox"
                                               name="difficulty" value="ADVANCED" id="diff_advanced"
                                        ${fn:contains(paramValues.difficulty, 'ADVANCED') ? 'checked' : ''}>
                                        <label class="form-check-label" for="diff_advanced">
                                            Nâng cao
                                        </label>
                                    </div>
                                </div>

                                <%-- Price Filter --%>
                                <div class="filter-group mb-4">
                                    <h6 class="filter-title">Giá</h6>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio"
                                               name="price" value="free" id="price_free"
                                        ${param.price == 'free' ? 'checked' : ''}>
                                        <label class="form-check-label" for="price_free">
                                            Miễn phí
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio"
                                               name="price" value="paid" id="price_paid"
                                        ${param.price == 'paid' ? 'checked' : ''}>
                                        <label class="form-check-label" for="price_paid">
                                            Có phí
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio"
                                               name="price" value="all" id="price_all"
                                        ${empty param.price or param.price == 'all' ? 'checked' : ''}>
                                        <label class="form-check-label" for="price_all">
                                            Tất cả
                                        </label>
                                    </div>
                                </div>

                                <%-- Duration Filter --%>
                                <div class="filter-group mb-4">
                                    <h6 class="filter-title">Thời lượng</h6>
                                    <div class="range-slider">
                                        <input type="range" class="form-range" id="durationRange"
                                               min="0" max="200" value="${param.maxDuration or 200}">
                                        <div class="range-labels">
                                            <span>0h</span>
                                            <span>200h+</span>
                                        </div>
                                        <div class="range-value">
                                            Tối đa: <span id="durationValue">${param.maxDuration or 200}</span> giờ
                                        </div>
                                        <input type="hidden" name="maxDuration" id="maxDurationInput"
                                               value="${param.maxDuration or 200}">
                                    </div>
                                </div>

                                <div class="filter-actions">
                                    <button type="submit" class="btn btn-primary w-100 mb-2">
                                        <i class="fas fa-filter me-2"></i>Áp dụng
                                    </button>
                                    <a href="/courses" class="btn btn-outline-secondary w-100">
                                        <i class="fas fa-times me-2"></i>Xóa bộ lọc
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Main Content --%>
            <div class="col-lg-9 col-md-8">
                <%-- Results Header --%>
                <div class="results-header mb-4">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <h5 class="results-count">
                                Tìm thấy ${coursePage.totalElements} khóa học
                                <c:if test="${not empty param.search}">
                                    cho "<strong>${param.search}</strong>"
                                </c:if>
                            </h5>
                        </div>
                        <div class="col-md-6">
                            <div class="sort-options">
                                <div class="d-flex align-items-center gap-3">
                                    <label for="sortBy" class="form-label mb-0">Sắp xếp:</label>
                                    <select class="form-select" id="sortBy" name="sort">
                                        <option value="newest" ${param.sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                                        <option value="popular" ${param.sort == 'popular' ? 'selected' : ''}>Phổ biến</option>
                                        <option value="rating" ${param.sort == 'rating' ? 'selected' : ''}>Đánh giá cao</option>
                                        <option value="price_low" ${param.sort == 'price_low' ? 'selected' : ''}>Giá thấp</option>
                                        <option value="price_high" ${param.sort == 'price_high' ? 'selected' : ''}>Giá cao</option>
                                    </select>

                                    <div class="view-toggle">
                                        <button class="btn btn-outline-secondary ${viewMode != 'list' ? 'active' : ''}"
                                                onclick="setViewMode('grid')">
                                            <i class="fas fa-th"></i>
                                        </button>
                                        <button class="btn btn-outline-secondary ${viewMode == 'list' ? 'active' : ''}"
                                                onclick="setViewMode('list')">
                                            <i class="fas fa-list"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- Course Results --%>
                <div class="courses-grid ${viewMode == 'list' ? 'list-view' : 'grid-view'}">
                    <c:choose>
                        <c:when test="${not empty coursePage.content}">
                            <div class="row g-4">
                                <c:forEach var="course" items="${coursePage.content}">
                                    <div class="${viewMode == 'list' ? 'col-12' : 'col-lg-6 col-xl-4'}">
                                        <div class="course-card h-100">
                                            <div class="course-image">
                                                <img src="${course.imageUrl}" alt="${course.name}"
                                                     class="card-img-top"
                                                     onerror="this.src='/images/default-course.png'">
                                                <div class="course-overlay">
                                                    <a href="/courses/${course.id}" class="btn btn-primary">
                                                        Xem chi tiết
                                                    </a>
                                                </div>
                                                <div class="course-category-badge">${course.category.name}</div>
                                                <c:if test="${course.featured}">
                                                    <div class="featured-badge">
                                                        <i class="fas fa-star"></i>
                                                    </div>
                                                </c:if>
                                            </div>

                                            <div class="card-body">
                                                <h5 class="course-title">
                                                    <a href="/courses/${course.id}">${course.name}</a>
                                                </h5>
                                                <p class="course-description">
                                                        ${fn:substring(course.description, 0, 120)}...
                                                </p>

                                                <div class="course-meta">
                                                    <div class="instructor-info">
                                                        <img src="${course.instructor.profileImageUrl}"
                                                             alt="Instructor" class="instructor-avatar"
                                                             onerror="this.src='/images/default-avatar.png'">
                                                        <span class="instructor-name">${course.instructor.fullName}</span>
                                                    </div>

                                                    <div class="course-stats">
                                                        <div class="rating">
                                                            <div class="stars">
                                                                <c:forEach begin="1" end="5" var="i">
                                                                    <i class="fas fa-star ${i <= course.averageRating ? 'text-warning' : 'text-muted'}"></i>
                                                                </c:forEach>
                                                            </div>
                                                            <span class="rating-text">${course.averageRating}</span>
                                                        </div>
                                                        <div class="enrollment-count">
                                                            <i class="fas fa-users me-1"></i>
                                                                ${course.enrollmentCount}
                                                        </div>
                                                        <div class="duration">
                                                            <i class="fas fa-clock me-1"></i>
                                                                ${course.formattedDuration}
                                                        </div>
                                                    </div>

                                                    <div class="difficulty-badge">
                                                        <span class="badge bg-${course.difficultyLevel == 'BEGINNER' ? 'success' : course.difficultyLevel == 'INTERMEDIATE' ? 'warning' : 'danger'}">
                                                                ${course.difficultyLevel == 'BEGINNER' ? 'Cơ bản' : course.difficultyLevel == 'INTERMEDIATE' ? 'Trung bình' : 'Nâng cao'}
                                                        </span>
                                                    </div>
                                                </div>

                                                <div class="course-footer">
                                                    <div class="course-price">
                                                        <c:choose>
                                                            <c:when test="${course.price > 0}">
                                                                <span class="current-price">
                                                                    <fmt:formatNumber value="${course.price}" type="currency"
                                                                                      currencySymbol="₫" maxFractionDigits="0" />
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="free-price">Miễn phí</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <a href="/courses/${course.id}" class="btn btn-primary">
                                                        Xem chi tiết
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="no-results text-center py-5">
                                <i class="fas fa-search fa-3x text-muted mb-3"></i>
                                <h4 class="text-muted">Không tìm thấy khóa học nào</h4>
                                <p class="text-muted">
                                    Thử thay đổi từ khóa tìm kiếm hoặc bộ lọc để có kết quả tốt hơn.
                                </p>
                                <a href="/courses" class="btn btn-primary">
                                    <i class="fas fa-redo me-2"></i>Xem tất cả khóa học
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <%-- Pagination --%>
                <c:if test="${coursePage.totalPages > 1}">
                    <nav aria-label="Course pagination" class="mt-5">
                        <ul class="pagination justify-content-center">
                            <c:if test="${coursePage.hasPrevious()}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${coursePage.number - 1}&${queryString}">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </li>
                            </c:if>

                            <c:forEach begin="0" end="${coursePage.totalPages - 1}" var="i">
                                <c:if test="${i >= coursePage.number - 2 && i <= coursePage.number + 2}">
                                    <li class="page-item ${i == coursePage.number ? 'active' : ''}">
                                        <a class="page-link" href="?page=${i}&${queryString}">${i + 1}</a>
                                    </li>
                                </c:if>
                            </c:forEach>

                            <c:if test="${coursePage.hasNext()}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${coursePage.number + 1}&${queryString}">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script>
    // View mode toggle
    function setViewMode(mode) {
        localStorage.setItem('courseViewMode', mode);
        location.reload();
    }

    // Sort change handler
    document.getElementById('sortBy').addEventListener('change', function() {
        const url = new URL(window.location);
        url.searchParams.set('sort', this.value);
        window.location = url.toString();
    });

    // Duration range slider
    const durationRange = document.getElementById('durationRange');
    const durationValue = document.getElementById('durationValue');
    const maxDurationInput = document.getElementById('maxDurationInput');

    durationRange.addEventListener('input', function() {
        durationValue.textContent = this.value;
        maxDurationInput.value = this.value;
    });

    // Auto-submit filters on change
    document.querySelectorAll('#filterForm input[type="checkbox"], #filterForm input[type="radio"]').forEach(input => {
        input.addEventListener('change', function() {
            document.getElementById('filterForm').submit();
        });
    });
</script>