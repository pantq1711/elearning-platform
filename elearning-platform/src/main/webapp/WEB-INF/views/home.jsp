<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduLearn Platform - Nền tảng học trực tuyến hàng đầu Việt Nam</title>

    <!-- Meta tags cho SEO -->
    <meta name="description" content="Nền tảng học trực tuyến EduLearn với hàng nghìn khóa học chất lượng cao về Lập trình, Thiết kế, Kinh doanh, Marketing từ các chuyên gia hàng đầu.">
    <meta name="keywords" content="học trực tuyến, khóa học online, lập trình, thiết kế, kinh doanh, marketing, EduLearn">
    <meta name="author" content="EduLearn Platform">

    <!-- Open Graph cho social media -->
    <meta property="og:title" content="EduLearn Platform - Nền tảng học trực tuyến hàng đầu">
    <meta property="og:description" content="Khám phá hàng nghìn khóa học chất lượng cao với giảng viên chuyên nghiệp">
    <meta property="og:type" content="website">
    <meta property="og:url" content="${pageContext.request.scheme}://${pageContext.request.serverName}${pageContext.request.contextPath}/">

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- AOS Animation -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="<c:url value='/css/home.css' />" rel="stylesheet">
</head>

<body>
<!-- Include Header -->
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<!-- Hero Section - Banner chính -->
<section class="hero-section">
    <div class="hero-background">
        <div class="hero-overlay"></div>
        <div class="container">
            <div class="row align-items-center min-vh-100">
                <div class="col-lg-6" data-aos="fade-right">
                    <div class="hero-content">
                        <h1 class="hero-title">
                            Khám phá tiềm năng của bạn với
                            <span class="text-gradient">EduLearn</span>
                        </h1>
                        <p class="hero-subtitle">
                            Nền tảng học trực tuyến hàng đầu Việt Nam với hơn
                            <strong>${totalCourses}</strong> khóa học chất lượng cao từ
                            <strong>${totalInstructors}</strong> giảng viên chuyên nghiệp.
                        </p>

                        <!-- CTA Buttons -->
                        <div class="hero-actions mt-4">
                            <sec:authorize access="!isAuthenticated()">
                                <a href="<c:url value='/register' />" class="btn btn-primary btn-lg me-3">
                                    <i class="fas fa-rocket me-2"></i>Bắt Đầu Học Ngay
                                </a>
                                <a href="<c:url value='/courses' />" class="btn btn-outline-light btn-lg">
                                    <i class="fas fa-play me-2"></i>Khám Phá Khóa Học
                                </a>
                            </sec:authorize>

                            <sec:authorize access="isAuthenticated()">
                                <sec:authorize access="hasRole('STUDENT')">
                                    <a href="<c:url value='/student/dashboard' />" class="btn btn-primary btn-lg me-3">
                                        <i class="fas fa-tachometer-alt me-2"></i>Vào Dashboard
                                    </a>
                                </sec:authorize>
                                <sec:authorize access="hasRole('INSTRUCTOR')">
                                    <a href="<c:url value='/instructor/dashboard' />" class="btn btn-primary btn-lg me-3">
                                        <i class="fas fa-chalkboard-teacher me-2"></i>Dashboard Giảng Viên
                                    </a>
                                </sec:authorize>
                                <sec:authorize access="hasRole('ADMIN')">
                                    <a href="<c:url value='/admin/dashboard' />" class="btn btn-primary btn-lg me-3">
                                        <i class="fas fa-cogs me-2"></i>Quản Trị Hệ Thống
                                    </a>
                                </sec:authorize>

                                <a href="<c:url value='/courses' />" class="btn btn-outline-light btn-lg">
                                    <i class="fas fa-search me-2"></i>Tìm Khóa Học Mới
                                </a>
                            </sec:authorize>
                        </div>

                        <!-- Stats mini -->
                        <div class="hero-stats mt-5">
                            <div class="row">
                                <div class="col-4">
                                    <div class="stat-item">
                                        <h3 class="stat-number">${totalStudents}+</h3>
                                        <p class="stat-label">Học viên</p>
                                    </div>
                                </div>
                                <div class="col-4">
                                    <div class="stat-item">
                                        <h3 class="stat-number">${totalCourses}+</h3>
                                        <p class="stat-label">Khóa học</p>
                                    </div>
                                </div>
                                <div class="col-4">
                                    <div class="stat-item">
                                        <h3 class="stat-number">98%</h3>
                                        <p class="stat-label">Hài lòng</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Hero Image/Video -->
                <div class="col-lg-6" data-aos="fade-left">
                    <div class="hero-media">
                        <div class="hero-image-container">
                            <img src="<c:url value='/images/hero-learning.jpg' />"
                                 alt="Học trực tuyến với EduLearn"
                                 class="img-fluid hero-image">
                            <div class="floating-card card-1" data-aos="fade-up" data-aos-delay="200">
                                <i class="fas fa-graduation-cap text-primary"></i>
                                <span>Chứng chỉ uy tín</span>
                            </div>
                            <div class="floating-card card-2" data-aos="fade-up" data-aos-delay="400">
                                <i class="fas fa-users text-success"></i>
                                <span>Cộng đồng học tập</span>
                            </div>
                            <div class="floating-card card-3" data-aos="fade-up" data-aos-delay="600">
                                <i class="fas fa-clock text-warning"></i>
                                <span>Học mọi lúc, mọi nơi</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Featured Categories Section -->
<section class="py-5 bg-light">
    <div class="container">
        <div class="text-center mb-5" data-aos="fade-up">
            <h2 class="section-title">Danh Mục Khóa Học Phổ Biến</h2>
            <p class="section-subtitle">Khám phá các lĩnh vực học tập đa dạng phù hợp với mục tiêu của bạn</p>
        </div>

        <div class="row">
            <c:forEach items="${featuredCategories}" var="category" varStatus="status">
                <div class="col-lg-3 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="${status.index * 100}">
                    <div class="category-card h-100">
                        <div class="category-icon" style="background-color: ${category.color}20;">
                            <i class="${category.icon}" style="color: ${category.color};"></i>
                        </div>
                        <div class="category-content">
                            <h5 class="category-name">${category.name}</h5>
                            <p class="category-description">${category.description}</p>
                            <div class="category-stats">
                                <span class="course-count">${category.courseCount} khóa học</span>
                            </div>
                        </div>
                        <a href="<c:url value='/courses?category=${category.name}' />"
                           class="stretched-link"></a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<!-- Featured Courses Section -->
<section class="py-5">
    <div class="container">
        <div class="text-center mb-5" data-aos="fade-up">
            <h2 class="section-title">Khóa Học Nổi Bật</h2>
            <p class="section-subtitle">Những khóa học được đánh giá cao nhất từ cộng đồng học viên</p>
        </div>

        <div class="row">
            <c:forEach items="${featuredCourses}" var="course" varStatus="status">
                <div class="col-lg-4 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="${status.index * 100}">
                    <div class="course-card h-100">
                        <div class="course-image">
                            <img src="<c:url value='/images/courses/${course.thumbnail}' />"
                                 alt="${course.name}" class="img-fluid">
                            <div class="course-badge">
                                <span class="badge bg-primary">Nổi bật</span>
                            </div>
                            <div class="course-level">
                                <span class="badge bg-dark">${course.difficultyLevel}</span>
                            </div>
                        </div>

                        <div class="course-content">
                            <div class="course-meta">
                                <span class="category">${course.category.name}</span>
                                <span class="duration">
                                        <i class="fas fa-clock me-1"></i>
                                        <fmt:formatNumber value="${course.duration / 60}" maxFractionDigits="1"/>h
                                    </span>
                            </div>

                            <h5 class="course-title">
                                <a href="<c:url value='/courses/${course.id}' />" class="text-decoration-none">
                                        ${course.name}
                                </a>
                            </h5>

                            <p class="course-description">${course.shortDescription}</p>

                            <div class="course-instructor">
                                <img src="<c:url value='/images/avatars/${course.instructor.avatar}' />"
                                     alt="${course.instructor.fullName}" class="instructor-avatar">
                                <span class="instructor-name">${course.instructor.fullName}</span>
                            </div>

                            <div class="course-footer">
                                <div class="course-rating">
                                    <div class="stars">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="fas fa-star ${i <= course.rating ? 'text-warning' : 'text-muted'}"></i>
                                        </c:forEach>
                                    </div>
                                    <span class="rating-text">(${course.reviewCount} đánh giá)</span>
                                </div>

                                <div class="course-price">
                                    <c:choose>
                                        <c:when test="${course.price == 0}">
                                            <span class="price-free">Miễn phí</span>
                                        </c:when>
                                        <c:otherwise>
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

        <div class="text-center mt-4" data-aos="fade-up">
            <a href="<c:url value='/courses' />" class="btn btn-outline-primary btn-lg">
                <i class="fas fa-th-large me-2"></i>Xem Tất Cả Khóa Học
            </a>
        </div>
    </div>
</section>

<!-- Why Choose Us Section -->
<section class="py-5 bg-gradient-primary">
    <div class="container">
        <div class="text-center mb-5" data-aos="fade-up">
            <h2 class="section-title text-white">Tại Sao Chọn EduLearn?</h2>
            <p class="section-subtitle text-white-50">Những lý do khiến hàng triệu học viên tin tưởng lựa chọn chúng tôi</p>
        </div>

        <div class="row">
            <div class="col-lg-3 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="0">
                <div class="feature-item text-center">
                    <div class="feature-icon">
                        <i class="fas fa-chalkboard-teacher"></i>
                    </div>
                    <h5 class="feature-title text-white">Giảng Viên Chuyên Nghiệp</h5>
                    <p class="feature-description text-white-75">
                        Đội ngũ giảng viên giàu kinh nghiệm từ các công ty hàng đầu
                    </p>
                </div>
            </div>

            <div class="col-lg-3 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="100">
                <div class="feature-item text-center">
                    <div class="feature-icon">
                        <i class="fas fa-laptop-code"></i>
                    </div>
                    <h5 class="feature-title text-white">Thực Hành Thực Tế</h5>
                    <p class="feature-description text-white-75">
                        Học qua dự án thực tế, áp dụng ngay vào công việc
                    </p>
                </div>
            </div>

            <div class="col-lg-3 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="200">
                <div class="feature-item text-center">
                    <div class="feature-icon">
                        <i class="fas fa-certificate"></i>
                    </div>
                    <h5 class="feature-title text-white">Chứng Chỉ Uy Tín</h5>
                    <p class="feature-description text-white-75">
                        Chứng chỉ được công nhận bởi các doanh nghiệp hàng đầu
                    </p>
                </div>
            </div>

            <div class="col-lg-3 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="300">
                <div class="feature-item text-center">
                    <div class="feature-icon">
                        <i class="fas fa-headset"></i>
                    </div>
                    <h5 class="feature-title text-white">Hỗ Trợ 24/7</h5>
                    <p class="feature-description text-white-75">
                        Đội ngũ hỗ trợ nhiệt tình, sẵn sàng giải đáp mọi thắc mắc
                    </p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Statistics Section -->
<section class="py-5">
    <div class="container">
        <div class="row text-center">
            <div class="col-lg-3 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="0">
                <div class="stat-card">
                    <div class="stat-icon text-primary">
                        <i class="fas fa-user-graduate"></i>
                    </div>
                    <div class="stat-content">
                        <h3 class="stat-number" data-target="${totalStudents}">${totalStudents}+</h3>
                        <p class="stat-label">Học viên đã tham gia</p>
                    </div>
                </div>
            </div>

            <div class="col-lg-3 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="100">
                <div class="stat-card">
                    <div class="stat-icon text-success">
                        <i class="fas fa-book"></i>
                    </div>
                    <div class="stat-content">
                        <h3 class="stat-number" data-target="${totalCourses}">${totalCourses}+</h3>
                        <p class="stat-label">Khóa học chất lượng</p>
                    </div>
                </div>
            </div>

            <div class="col-lg-3 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="200">
                <div class="stat-card">
                    <div class="stat-icon text-warning">
                        <i class="fas fa-chalkboard-teacher"></i>
                    </div>
                    <div class="stat-content">
                        <h3 class="stat-number" data-target="${totalInstructors}">${totalInstructors}+</h3>
                        <p class="stat-label">Giảng viên chuyên nghiệp</p>
                    </div>
                </div>
            </div>

            <div class="col-lg-3 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="300">
                <div class="stat-card">
                    <div class="stat-icon text-info">
                        <i class="fas fa-award"></i>
                    </div>
                    <div class="stat-content">
                        <h3 class="stat-number" data-target="10000">10,000+</h3>
                        <p class="stat-label">Chứng chỉ đã cấp</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Testimonials Section -->
<section class="py-5 bg-light">
    <div class="container">
        <div class="text-center mb-5" data-aos="fade-up">
            <h2 class="section-title">Học Viên Nói Gì Về Chúng Tôi</h2>
            <p class="section-subtitle">Những phản hồi tích cực từ cộng đồng học viên EduLearn</p>
        </div>

        <div class="row">
            <div class="col-lg-4 mb-4" data-aos="fade-up" data-aos-delay="0">
                <div class="testimonial-card">
                    <div class="testimonial-content">
                        <p class="testimonial-text">
                            "EduLearn đã thay đổi hoàn toàn sự nghiệp của tôi. Từ một người không biết gì về lập trình,
                            giờ tôi đã trở thành Full-stack Developer tại một công ty công nghệ hàng đầu."
                        </p>
                    </div>
                    <div class="testimonial-author">
                        <img src="<c:url value='/images/testimonials/student1.jpg' />"
                             alt="Nguyễn Văn A" class="author-avatar">
                        <div class="author-info">
                            <h6 class="author-name">Nguyễn Văn A</h6>
                            <span class="author-title">Full-stack Developer</span>
                        </div>
                        <div class="testimonial-rating">
                            <i class="fas fa-star text-warning"></i>
                            <i class="fas fa-star text-warning"></i>
                            <i class="fas fa-star text-warning"></i>
                            <i class="fas fa-star text-warning"></i>
                            <i class="fas fa-star text-warning"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-4 mb-4" data-aos="fade-up" data-aos-delay="100">
                <div class="testimonial-card">
                    <div class="testimonial-content">
                        <p class="testimonial-text">
                            "Khóa học Digital Marketing tại EduLearn rất thực tế. Tôi đã áp dụng ngay được vào công việc
                            và tăng doanh số cho công ty lên 200% chỉ sau 3 tháng."
                        </p>
                    </div>
                    <div class="testimonial-author">
                        <img src="<c:url value='/images/testimonials/student2.jpg' />"
                             alt="Trần Thị B" class="author-avatar">
                        <div class="author-info">
                            <h6 class="author-name">Trần Thị B</h6>
                            <span class="author-title">Marketing Manager</span>
                        </div>
                        <div class="testimonial-rating">
                            <i class="fas fa-star text-warning"></i>
                            <i class="fas fa-star text-warning"></i>
                            <i class="fas fa-star text-warning"></i>
                            <i class="fas fa-star text-warning"></i>
                            <i class="fas fa-star text-warning"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-4 mb-4" data-aos="fade-up" data-aos-delay="200">
                <div class="testimonial-card">
                    <div class="testimonial-content">
                        <p class="testimonial-text">
                            "Giao diện học tập rất thân thiện, giảng viên nhiệt tình. Đặc biệt là có cộng đồng học tập
                            sôi động, luôn hỗ trợ nhau trong quá trình học."
                        </p>
                    </div>
                    <div class="testimonial-author">
                        <img src="<c:url value='/images/testimonials/student3.jpg' />"
                             alt="Lê Văn C" class="author-avatar">
                        <div class="author-info">
                            <h6 class="author-name">Lê Văn C</h6>
                            <span class="author-title">UI/UX Designer</span>
                        </div>
                        <div class="testimonial-rating">
                            <i class="fas fa-star text-warning"></i>
                            <i class="fas fa-star text-warning"></i>
                            <i class="fas fa-star text-warning"></i>
                            <i class="fas fa-star text-warning"></i>
                            <i class="fas fa-star text-warning"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- CTA Section -->
<section class="py-5 bg-primary text-white">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-8" data-aos="fade-right">
                <h2 class="mb-3">Sẵn Sàng Bắt Đầu Hành Trình Học Tập?</h2>
                <p class="mb-0 fs-5">
                    Hãy tham gia cùng hàng triệu học viên đã thay đổi cuộc đời qua việc học tập tại EduLearn
                </p>
            </div>
            <div class="col-lg-4 text-lg-end" data-aos="fade-left">
                <sec:authorize access="!isAuthenticated()">
                    <a href="<c:url value='/register' />" class="btn btn-light btn-lg">
                        <i class="fas fa-rocket me-2"></i>Đăng Ký Ngay
                    </a>
                </sec:authorize>
                <sec:authorize access="isAuthenticated()">
                    <a href="<c:url value='/courses' />" class="btn btn-light btn-lg">
                        <i class="fas fa-search me-2"></i>Khám Phá Khóa Học
                    </a>
                </sec:authorize>
            </div>
        </div>
    </div>
</section>

<!-- Include Footer -->
<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- AOS Animation -->
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>

<!-- Custom JavaScript -->
<script>
    // Initialize AOS Animation
    AOS.init({
        duration: 800,
        once: true,
        offset: 100
    });

    // Counter animation for statistics
    function animateCounter(element, target) {
        let current = 0;
        const increment = target / 100;
        const timer = setInterval(() => {
            current += increment;
            if (current >= target) {
                current = target;
                clearInterval(timer);
            }
            element.textContent = Math.floor(current).toLocaleString() + '+';
        }, 20);
    }

    // Trigger counter animation when section is visible
    const observerOptions = {
        threshold: 0.5,
        rootMargin: '0px 0px -100px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const counters = entry.target.querySelectorAll('.stat-number[data-target]');
                counters.forEach(counter => {
                    const target = parseInt(counter.getAttribute('data-target'));
                    animateCounter(counter, target);
                });
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    const statsSection = document.querySelector('.py-5:nth-of-type(5)'); // Statistics section
    if (statsSection) {
        observer.observe(statsSection);
    }

    // Smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Add loading animation for CTA buttons
    document.querySelectorAll('.btn').forEach(button => {
        button.addEventListener('click', function(e) {
            if (this.href && !this.href.includes('#')) {
                const originalText = this.innerHTML;
                this.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang tải...';
                this.disabled = true;

                // Reset after a short delay if page doesn't change
                setTimeout(() => {
                    this.innerHTML = originalText;
                    this.disabled = false;
                }, 3000);
            }
        });
    });
</script>
</body>
</html>