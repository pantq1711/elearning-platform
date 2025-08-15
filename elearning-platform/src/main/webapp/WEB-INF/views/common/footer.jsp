<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%--
    Footer Component - Component chân trang chung
    Sử dụng cho tất cả các trang trong hệ thống
    Bao gồm thông tin liên hệ, links hữu ích và social media
--%>

<footer class="bg-dark text-white mt-5">
    <!-- Main footer content -->
    <div class="container py-5">
        <div class="row">
            <!-- Cột 1: Thông tin về website -->
            <div class="col-lg-4 col-md-6 mb-4">
                <h5 class="fw-bold text-primary">
                    <i class="fas fa-graduation-cap me-2"></i>EduLearn Platform
                </h5>
                <p class="text-light">
                    Nền tảng học trực tuyến hàng đầu Việt Nam, cung cấp các khóa học chất lượng cao
                    từ những giảng viên có kinh nghiệm trong các lĩnh vực Công nghệ thông tin,
                    Marketing, Kinh doanh và nhiều lĩnh vực khác.
                </p>

                <!-- Social media links -->
                <div class="mt-3">
                    <h6 class="fw-bold">Kết nối với chúng tôi:</h6>
                    <div class="social-links">
                        <a href="#" class="text-white me-3" title="Facebook">
                            <i class="fab fa-facebook-f"></i>
                        </a>
                        <a href="#" class="text-white me-3" title="YouTube">
                            <i class="fab fa-youtube"></i>
                        </a>
                        <a href="#" class="text-white me-3" title="LinkedIn">
                            <i class="fab fa-linkedin-in"></i>
                        </a>
                        <a href="#" class="text-white me-3" title="Twitter">
                            <i class="fab fa-twitter"></i>
                        </a>
                        <a href="#" class="text-white me-3" title="Instagram">
                            <i class="fab fa-instagram"></i>
                        </a>
                    </div>
                </div>
            </div>

            <!-- Cột 2: Quick Links -->
            <div class="col-lg-2 col-md-6 mb-4">
                <h6 class="fw-bold text-primary">Liên Kết Nhanh</h6>
                <ul class="list-unstyled">
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/" class="text-light text-decoration-none hover-primary">
                            <i class="fas fa-home me-2"></i>Trang Chủ
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/courses"" class="text-light text-decoration-none hover-primary">
                            <i class="fas fa-book me-2"></i>Khóa Học
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/about"" class="text-light text-decoration-none hover-primary">
                            <i class="fas fa-info-circle me-2"></i>Giới Thiệu
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/contact"" class="text-light text-decoration-none hover-primary">
                            <i class="fas fa-envelope me-2"></i>Liên Hệ
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="#" class="text-light text-decoration-none hover-primary">
                            <i class="fas fa-question-circle me-2"></i>FAQ
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Cột 3: Danh mục khóa học -->
            <div class="col-lg-3 col-md-6 mb-4">
                <h6 class="fw-bold text-primary">Danh Mục Phổ Biến</h6>
                <ul class="list-unstyled">
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/courses?category=Programming""
                           class="text-light text-decoration-none hover-primary">
                            <i class="fas fa-code me-2"></i>Lập Trình
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/courses?category=Design""
                           class="text-light text-decoration-none hover-primary">
                            <i class="fas fa-paint-brush me-2"></i>Thiết Kế
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/courses?category=Business""
                           class="text-light text-decoration-none hover-primary">
                            <i class="fas fa-briefcase me-2"></i>Kinh Doanh
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/courses?category=Marketing""
                           class="text-light text-decoration-none hover-primary">
                            <i class="fas fa-bullhorn me-2"></i>Marketing
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/courses?category=Language""
                           class="text-light text-decoration-none hover-primary">
                            <i class="fas fa-language me-2"></i>Ngoại Ngữ
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Cột 4: Thông tin liên hệ -->
            <div class="col-lg-3 col-md-6 mb-4">
                <h6 class="fw-bold text-primary">Thông Tin Liên Hệ</h6>
                <div class="contact-info">
                    <div class="mb-3">
                        <i class="fas fa-map-marker-alt text-primary me-2"></i>
                        <span class="text-light">
                            123 Đường ABC, Quận 1<br>
                            TP. Hồ Chí Minh, Việt Nam
                        </span>
                    </div>
                    <div class="mb-3">
                        <i class="fas fa-phone text-primary me-2"></i>
                        <a href="tel:+84123456789" class="text-light text-decoration-none">
                            +84 123 456 789
                        </a>
                    </div>
                    <div class="mb-3">
                        <i class="fas fa-envelope text-primary me-2"></i>
                        <a href="mailto:info@edulearn.vn" class="text-light text-decoration-none">
                            info@edulearn.vn
                        </a>
                    </div>
                    <div class="mb-3">
                        <i class="fas fa-clock text-primary me-2"></i>
                        <span class="text-light">
                            Thứ 2 - Thứ 6: 8:00 - 18:00<br>
                            Thứ 7 - CN: 9:00 - 17:00
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Newsletter subscription -->
        <div class="row mt-4 pt-4 border-top">
            <div class="col-md-8">
                <h6 class="fw-bold text-primary">Đăng Ký Nhận Thông Tin Mới</h6>
                <p class="text-light mb-3">
                    Nhận thông báo về các khóa học mới, ưu đãi đặc biệt và tips học tập hữu ích.
                </p>
                <form class="newsletter-form" onsubmit="subscribeNewsletter(event)">
                    <div class="input-group" style="max-width: 400px;">
                        <input type="email" class="form-control"
                               placeholder="Nhập email của bạn..." required>
                        <button class="btn btn-primary" type="submit">
                            <i class="fas fa-paper-plane me-2"></i>Đăng Ký
                        </button>
                    </div>
                </form>
            </div>

            <!-- App download links -->
            <div class="col-md-4 text-md-end">
                <h6 class="fw-bold text-primary">Tải Ứng Dụng</h6>
                <div class="app-links mt-3">
                    <a href="#" class="me-2">
                        <img src="${pageContext.request.contextPath}/images/google-play.png"
                             alt="Google Play" style="height: 40px;">
                    </a>
                    <a href="#">
                        <img src="${pageContext.request.contextPath}/images/app-store.png"
                             alt="App Store" style="height: 40px;">
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Copyright -->
    <div class="bg-darker py-3">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <p class="mb-0 text-muted">
                        &copy; <span id="currentYear"></span> EduLearn Platform. Tất cả quyền được bảo lưu.
                    </p>
                </div>
                <div class="col-md-6 text-md-end">
                    <div class="footer-links">
                        <a href="#" class="text-muted text-decoration-none me-3">Chính sách bảo mật</a>
                        <a href="#" class="text-muted text-decoration-none me-3">Điều khoản sử dụng</a>
                        <a href="#" class="text-muted text-decoration-none">Hỗ trợ</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</footer>

<!-- Scroll to top button -->
<button id="scrollToTop" class="btn btn-primary scroll-to-top" title="Về đầu trang">
    <i class="fas fa-chevron-up"></i>
</button>

<%-- Custom CSS cho footer --%>
<style>
    /* Footer styling */
    footer {
        margin-top: auto;
    }

    .bg-darker {
        background-color: #1a1a1a !important;
    }

    .social-links a {
        display: inline-block;
        width: 40px;
        height: 40px;
        line-height: 40px;
        text-align: center;
        border-radius: 50%;
        background-color: rgba(255, 255, 255, 0.1);
        transition: all 0.3s ease;
    }

    .social-links a:hover {
        background-color: var(--bs-primary);
        transform: translateY(-2px);
    }

    .hover-primary:hover {
        color: var(--bs-primary) !important;
        transition: color 0.3s ease;
    }

    .contact-info i {
        width: 20px;
        text-align: center;
    }

    .newsletter-form .btn {
        border-radius: 0 0.375rem 0.375rem 0;
    }

    /* Scroll to top button */
    .scroll-to-top {
        position: fixed;
        bottom: 20px;
        right: 20px;
        width: 50px;
        height: 50px;
        border-radius: 50%;
        z-index: 1000;
        opacity: 0;
        visibility: hidden;
        transition: all 0.3s ease;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    }

    .scroll-to-top.show {
        opacity: 1;
        visibility: visible;
    }

    .scroll-to-top:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.25);
    }

    /* Responsive adjustments */
    @media (max-width: 768px) {
        .social-links a {
            width: 35px;
            height: 35px;
            line-height: 35px;
        }

        .newsletter-form .input-group {
            max-width: 100% !important;
        }

        .app-links {
            text-align: center !important;
            margin-top: 1rem;
        }
    }
</style>

<%-- JavaScript cho footer functionality --%>
<script>
    // Set current year
    document.getElementById('currentYear').textContent = new Date().getFullYear();

    // Scroll to top functionality
    const scrollToTopBtn = document.getElementById('scrollToTop');

    // Show/hide scroll to top button
    window.addEventListener('scroll', function() {
        if (window.pageYOffset > 300) {
            scrollToTopBtn.classList.add('show');
        } else {
            scrollToTopBtn.classList.remove('show');
        }
    });

    // Smooth scroll to top
    scrollToTopBtn.addEventListener('click', function() {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });

    // Newsletter subscription
    function subscribeNewsletter(event) {
        event.preventDefault();
        const email = event.target.querySelector('input[type="email"]').value;

        // Simulate API call
        const button = event.target.querySelector('button');
        const originalText = button.innerHTML;

        button.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
        button.disabled = true;

        setTimeout(() => {
            button.innerHTML = '<i class="fas fa-check me-2"></i>Đã đăng ký!';
            button.classList.remove('btn-primary');
            button.classList.add('btn-success');

            setTimeout(() => {
                button.innerHTML = originalText;
                button.disabled = false;
                button.classList.remove('btn-success');
                button.classList.add('btn-primary');
                event.target.reset();
            }, 2000);
        }, 1500);
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
</script>