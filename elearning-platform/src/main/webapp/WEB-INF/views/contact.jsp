<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liên Hệ - EduLearn Platform</title>

    <!-- Meta tags cho SEO -->
    <meta name="description" content="Liên hệ với EduLearn Platform để được hỗ trợ về các vấn đề học tập, khóa học và dịch vụ. Chúng tôi luôn sẵn sàng giúp đỡ bạn.">
    <meta name="keywords" content="liên hệ, hỗ trợ, EduLearn, customer service, support">

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
            --border-color: #e5e7eb;
            --text-primary: #1f2937;
            --text-secondary: #6b7280;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--light-bg);
            line-height: 1.6;
        }

        /* Hero Section */
        .hero-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 4rem 0;
            position: relative;
            overflow: hidden;
        }

        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grid" width="10" height="10" patternUnits="userSpaceOnUse"><path d="M 10 0 L 0 0 0 10" fill="none" stroke="rgba(255,255,255,0.1)" stroke-width="0.5"/></pattern></defs><rect width="100" height="100" fill="url(%23grid)"/></svg>');
            opacity: 0.3;
        }

        .hero-content {
            position: relative;
            z-index: 2;
            text-align: center;
        }

        .hero-title {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .hero-subtitle {
            font-size: 1.2rem;
            opacity: 0.9;
            max-width: 600px;
            margin: 0 auto;
        }

        /* Contact Section */
        .contact-section {
            padding: 5rem 0;
        }

        .contact-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 3rem;
            margin-top: 2rem;
        }

        @media (max-width: 991.98px) {
            .contact-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Contact Form */
        .contact-form-card {
            background: white;
            border-radius: 1rem;
            padding: 2.5rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
        }

        .form-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }

        .form-title i {
            margin-right: 0.75rem;
            color: var(--primary-color);
        }

        .form-description {
            color: var(--text-secondary);
            margin-bottom: 2rem;
        }

        .form-floating {
            margin-bottom: 1.5rem;
        }

        .form-floating .form-control,
        .form-floating .form-select {
            border: 2px solid var(--border-color);
            border-radius: 0.75rem;
            padding: 1rem 0.75rem;
            height: auto;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-floating .form-control:focus,
        .form-floating .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }

        .form-floating label {
            color: var(--text-secondary);
            font-weight: 500;
        }

        .form-floating textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }

        .btn-submit {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            border: none;
            border-radius: 0.75rem;
            padding: 0.875rem 2rem;
            font-weight: 600;
            font-size: 1rem;
            color: white;
            width: 100%;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px -8px var(--primary-color);
        }

        .btn-submit:focus {
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.3);
        }

        .btn-submit .loading-spinner {
            display: none;
        }

        .btn-submit.loading .btn-text {
            display: none;
        }

        .btn-submit.loading .loading-spinner {
            display: inline-block;
        }

        /* Contact Info */
        .contact-info-card {
            background: white;
            border-radius: 1rem;
            padding: 2.5rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
            height: fit-content;
        }

        .info-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }

        .info-title i {
            margin-right: 0.75rem;
            color: var(--primary-color);
        }

        .info-description {
            color: var(--text-secondary);
            margin-bottom: 2rem;
        }

        .contact-item {
            display: flex;
            align-items: flex-start;
            padding: 1.5rem;
            background: var(--light-bg);
            border-radius: 0.75rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
            border: 1px solid var(--border-color);
        }

        .contact-item:hover {
            background: #f3f4f6;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px -4px rgba(0, 0, 0, 0.1);
        }

        .contact-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            margin-right: 1rem;
            flex-shrink: 0;
        }

        .contact-details {
            flex: 1;
        }

        .contact-label {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }

        .contact-value {
            color: var(--text-secondary);
            font-size: 0.95rem;
            line-height: 1.5;
        }

        .contact-value a {
            color: var(--primary-color);
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .contact-value a:hover {
            color: var(--primary-dark);
        }

        /* FAQ Section */
        .faq-section {
            background: white;
            padding: 5rem 0;
        }

        .section-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 1rem;
            text-align: center;
        }

        .section-subtitle {
            color: var(--text-secondary);
            font-size: 1.1rem;
            text-align: center;
            margin-bottom: 3rem;
        }

        .faq-accordion {
            max-width: 800px;
            margin: 0 auto;
        }

        .accordion-item {
            border: none;
            border-radius: 0.75rem !important;
            margin-bottom: 1rem;
            box-shadow: var(--card-shadow);
            overflow: hidden;
        }

        .accordion-header .accordion-button {
            background: white;
            border: none;
            padding: 1.5rem;
            font-weight: 600;
            color: var(--text-primary);
            font-size: 1.1rem;
            border-radius: 0.75rem !important;
        }

        .accordion-button:not(.collapsed) {
            background: var(--light-bg);
            color: var(--primary-color);
            box-shadow: none;
        }

        .accordion-button:focus {
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
            border-color: transparent;
        }

        .accordion-button::after {
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='%234f46e5'%3e%3cpath fill-rule='evenodd' d='M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z'/%3e%3c/svg%3e");
        }

        .accordion-body {
            padding: 0 1.5rem 1.5rem;
            color: var(--text-secondary);
            line-height: 1.7;
        }

        /* Social Media */
        .social-section {
            background: var(--light-bg);
            padding: 4rem 0;
            text-align: center;
        }

        .social-title {
            font-size: 2rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
        }

        .social-subtitle {
            color: var(--text-secondary);
            margin-bottom: 2rem;
        }

        .social-links {
            display: flex;
            justify-content: center;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .social-link {
            width: 60px;
            height: 60px;
            background: white;
            color: var(--text-secondary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            font-size: 1.5rem;
            transition: all 0.3s ease;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
        }

        .social-link:hover {
            color: white;
            transform: translateY(-4px) scale(1.1);
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.2);
        }

        .social-link.facebook:hover {
            background: #1877f2;
        }

        .social-link.twitter:hover {
            background: #1da1f2;
        }

        .social-link.linkedin:hover {
            background: #0077b5;
        }

        .social-link.youtube:hover {
            background: #ff0000;
        }

        .social-link.instagram:hover {
            background: linear-gradient(45deg, #f09433 0%, #e6683c 25%, #dc2743 50%, #cc2366 75%, #bc1888 100%);
        }

        /* Alert Messages */
        .alert {
            border-radius: 0.75rem;
            border: none;
            margin-bottom: 1.5rem;
            padding: 1rem 1.5rem;
        }

        .alert-success {
            background: #f0fdf4;
            color: #166534;
            border-left: 4px solid var(--success-color);
        }

        .alert-danger {
            background: #fef2f2;
            color: #991b1b;
            border-left: 4px solid var(--danger-color);
        }

        /* Maps */
        .map-container {
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: var(--card-shadow);
            margin-top: 2rem;
            height: 400px;
        }

        .map-placeholder {
            width: 100%;
            height: 100%;
            background: var(--light-bg);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-secondary);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .hero-title {
                font-size: 2rem;
            }

            .section-title {
                font-size: 2rem;
            }

            .contact-form-card,
            .contact-info-card {
                padding: 1.5rem;
            }

            .contact-item {
                padding: 1rem;
            }

            .social-links {
                gap: 0.75rem;
            }

            .social-link {
                width: 50px;
                height: 50px;
                font-size: 1.25rem;
            }
        }
    </style>
</head>

<body>
<!-- Include Header -->
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<!-- Hero Section -->
<section class="hero-section">
    <div class="container">
        <div class="hero-content">
            <h1 class="hero-title">Liên hệ với chúng tôi</h1>
            <p class="hero-subtitle">
                Chúng tôi luôn sẵn sàng hỗ trợ bạn trong hành trình học tập.
                Hãy liên hệ với chúng tôi bất cứ khi nào bạn cần giúp đỡ.
            </p>
        </div>
    </div>
</section>

<!-- Contact Section -->
<section class="contact-section">
    <div class="container">
        <!-- Hiển thị thông báo thành công/lỗi -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                    ${successMessage}
            </div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                    ${errorMessage}
            </div>
        </c:if>

        <div class="contact-grid">
            <!-- Contact Form -->
            <div class="contact-form-card">
                <h2 class="form-title">
                    <i class="fas fa-envelope"></i>
                    Gửi tin nhắn cho chúng tôi
                </h2>
                <p class="form-description">
                    Điền thông tin vào form bên dưới và chúng tôi sẽ phản hồi trong vòng 24 giờ.
                </p>

                <form method="POST" action="//contact"" id="contactForm" novalidate>
                    <!-- CSRF Token -->
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <!-- Họ và tên -->
                    <div class="form-floating">
                        <input type="text"
                               class="form-control"
                               id="fullName"
                               name="fullName"
                               placeholder="Họ và tên"
                               required
                               value="${param.fullName}">
                        <label for="fullName">
                            <i class="fas fa-user me-2"></i>Họ và tên *
                        </label>
                        <div class="invalid-feedback">
                            Vui lòng nhập họ và tên
                        </div>
                    </div>

                    <!-- Email -->
                    <div class="form-floating">
                        <input type="email"
                               class="form-control"
                               id="email"
                               name="email"
                               placeholder="Email"
                               required
                               value="${param.email}">
                        <label for="email">
                            <i class="fas fa-envelope me-2"></i>Email *
                        </label>
                        <div class="invalid-feedback">
                            Vui lòng nhập email hợp lệ
                        </div>
                    </div>

                    <!-- Số điện thoại -->
                    <div class="form-floating">
                        <input type="tel"
                               class="form-control"
                               id="phone"
                               name="phone"
                               placeholder="Số điện thoại"
                               value="${param.phone}">
                        <label for="phone">
                            <i class="fas fa-phone me-2"></i>Số điện thoại
                        </label>
                    </div>

                    <!-- Chủ đề -->
                    <div class="form-floating">
                        <select class="form-select" id="subject" name="subject" required>
                            <option value="">Chọn chủ đề...</option>
                            <option value="general" ${param.subject == 'general' ? 'selected' : ''}>Thông tin chung</option>
                            <option value="technical" ${param.subject == 'technical' ? 'selected' : ''}>Hỗ trợ kỹ thuật</option>
                            <option value="course" ${param.subject == 'course' ? 'selected' : ''}>Về khóa học</option>
                            <option value="billing" ${param.subject == 'billing' ? 'selected' : ''}>Thanh toán</option>
                            <option value="partnership" ${param.subject == 'partnership' ? 'selected' : ''}>Hợp tác</option>
                            <option value="other" ${param.subject == 'other' ? 'selected' : ''}>Khác</option>
                        </select>
                        <label for="subject">
                            <i class="fas fa-tag me-2"></i>Chủ đề *
                        </label>
                        <div class="invalid-feedback">
                            Vui lòng chọn chủ đề
                        </div>
                    </div>

                    <!-- Tin nhắn -->
                    <div class="form-floating">
                            <textarea class="form-control"
                                      id="message"
                                      name="message"
                                      placeholder="Tin nhắn"
                                      required
                                      style="min-height: 120px;">${param.message}</textarea>
                        <label for="message">
                            <i class="fas fa-comment me-2"></i>Tin nhắn *
                        </label>
                        <div class="invalid-feedback">
                            Vui lòng nhập tin nhắn
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" class="btn-submit" id="submitBtn">
                            <span class="btn-text">
                                <i class="fas fa-paper-plane me-2"></i>Gửi tin nhắn
                            </span>
                        <span class="loading-spinner">
                                <i class="fas fa-spinner fa-spin me-2"></i>Đang gửi...
                            </span>
                    </button>
                </form>
            </div>

            <!-- Contact Information -->
            <div class="contact-info-card">
                <h2 class="info-title">
                    <i class="fas fa-info-circle"></i>
                    Thông tin liên hệ
                </h2>
                <p class="info-description">
                    Bạn có thể liên hệ với chúng tôi qua các kênh sau hoặc ghé thăm văn phòng của chúng tôi.
                </p>

                <!-- Địa chỉ -->
                <div class="contact-item">
                    <div class="contact-icon">
                        <i class="fas fa-map-marker-alt"></i>
                    </div>
                    <div class="contact-details">
                        <div class="contact-label">Địa chỉ văn phòng</div>
                        <div class="contact-value">
                            123 Đường Lê Lợi, Quận 1<br>
                            Thành phố Hồ Chí Minh, Việt Nam<br>
                            Tầng 10, Tòa nhà ABC
                        </div>
                    </div>
                </div>

                <!-- Điện thoại -->
                <div class="contact-item">
                    <div class="contact-icon">
                        <i class="fas fa-phone"></i>
                    </div>
                    <div class="contact-details">
                        <div class="contact-label">Điện thoại</div>
                        <div class="contact-value">
                            Hotline: <a href="tel:+84901234567">+84 901 234 567</a><br>
                            Hỗ trợ: <a href="tel:+84901234568">+84 901 234 568</a>
                        </div>
                    </div>
                </div>

                <!-- Email -->
                <div class="contact-item">
                    <div class="contact-icon">
                        <i class="fas fa-envelope"></i>
                    </div>
                    <div class="contact-details">
                        <div class="contact-label">Email</div>
                        <div class="contact-value">
                            Chung: <a href="mailto:info@edulearn.vn">info@edulearn.vn</a><br>
                            Hỗ trợ: <a href="mailto:support@edulearn.vn">support@edulearn.vn</a>
                        </div>
                    </div>
                </div>

                <!-- Giờ làm việc -->
                <div class="contact-item">
                    <div class="contact-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="contact-details">
                        <div class="contact-label">Giờ làm việc</div>
                        <div class="contact-value">
                            Thứ 2 - Thứ 6: 8:00 - 18:00<br>
                            Thứ 7: 9:00 - 17:00<br>
                            Chủ nhật: 10:00 - 16:00
                        </div>
                    </div>
                </div>

                <!-- Map -->
                <div class="map-container">
                    <div class="map-placeholder">
                        <div class="text-center">
                            <i class="fas fa-map fa-3x mb-3"></i>
                            <p>Bản đồ sẽ được hiển thị ở đây</p>
                            <small class="text-muted">
                                Tích hợp Google Maps hoặc bản đồ khác
                            </small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- FAQ Section -->
<section class="faq-section">
    <div class="container">
        <h2 class="section-title">Câu hỏi thường gặp</h2>
        <p class="section-subtitle">
            Tìm hiểu các câu trả lời cho những câu hỏi phổ biến nhất
        </p>

        <div class="faq-accordion">
            <div class="accordion" id="faqAccordion">
                <!-- FAQ Item 1 -->
                <div class="accordion-item">
                    <h3 class="accordion-header" id="faq1">
                        <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapse1">
                            Làm thế nào để đăng ký tài khoản?
                        </button>
                    </h3>
                    <div id="collapse1" class="accordion-collapse collapse show" data-bs-parent="#faqAccordion">
                        <div class="accordion-body">
                            Để đăng ký tài khoản, bạn chỉ cần nhấp vào nút "Đăng ký" ở góc trên cùng bên phải,
                            điền thông tin cá nhân và xác nhận email. Quá trình đăng ký hoàn toàn miễn phí và
                            chỉ mất vài phút.
                        </div>
                    </div>
                </div>

                <!-- FAQ Item 2 -->
                <div class="accordion-item">
                    <h3 class="accordion-header" id="faq2">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse2">
                            Các khóa học có miễn phí không?
                        </button>
                    </h3>
                    <div id="collapse2" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                        <div class="accordion-body">
                            Chúng tôi có cả khóa học miễn phí và trả phí. Khóa học miễn phí thường là các khóa
                            cơ bản giúp bạn làm quen với nền tảng. Các khóa học chuyên sâu và có chứng chỉ
                            sẽ có mức phí hợp lý.
                        </div>
                    </div>
                </div>

                <!-- FAQ Item 3 -->
                <div class="accordion-item">
                    <h3 class="accordion-header" id="faq3">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse3">
                            Tôi có thể học trên thiết bị di động không?
                        </button>
                    </h3>
                    <div id="collapse3" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                        <div class="accordion-body">
                            Có, EduLearn Platform được tối ưu hóa cho mọi thiết bị. Bạn có thể học trên máy tính,
                            tablet, hoặc điện thoại thông minh. Chúng tôi cũng có ứng dụng di động để bạn có thể
                            học offline.
                        </div>
                    </div>
                </div>

                <!-- FAQ Item 4 -->
                <div class="accordion-item">
                    <h3 class="accordion-header" id="faq4">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse4">
                            Chứng chỉ hoàn thành có giá trị không?
                        </button>
                    </h3>
                    <div id="collapse4" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                        <div class="accordion-body">
                            Chứng chỉ của chúng tôi được công nhận bởi nhiều doanh nghiệp và tổ chức giáo dục.
                            Chúng tôi hợp tác với các chuyên gia hàng đầu để đảm bảo chất lượng và tính thực tiễn
                            của các khóa học.
                        </div>
                    </div>
                </div>

                <!-- FAQ Item 5 -->
                <div class="accordion-item">
                    <h3 class="accordion-header" id="faq5">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse5">
                            Làm thế nào để được hỗ trợ kỹ thuật?
                        </button>
                    </h3>
                    <div id="collapse5" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                        <div class="accordion-body">
                            Bạn có thể liên hệ với đội ngũ hỗ trợ của chúng tôi qua email support@edulearn.vn,
                            hotline, hoặc chat trực tiếp trên website. Chúng tôi cam kết phản hồi trong vòng 24 giờ.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Social Media Section -->
<section class="social-section">
    <div class="container">
        <h2 class="social-title">Kết nối với chúng tôi</h2>
        <p class="social-subtitle">
            Theo dõi chúng tôi trên các mạng xã hội để cập nhật thông tin mới nhất
        </p>

        <div class="social-links">
            <a href="#" class="social-link facebook" title="Facebook">
                <i class="fab fa-facebook-f"></i>
            </a>
            <a href="#" class="social-link twitter" title="Twitter">
                <i class="fab fa-twitter"></i>
            </a>
            <a href="#" class="social-link linkedin" title="LinkedIn">
                <i class="fab fa-linkedin-in"></i>
            </a>
            <a href="#" class="social-link youtube" title="YouTube">
                <i class="fab fa-youtube"></i>
            </a>
            <a href="#" class="social-link instagram" title="Instagram">
                <i class="fab fa-instagram"></i>
            </a>
        </div>
    </div>
</section>

<!-- Include Footer -->
<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JavaScript -->
<script>
    // Form validation - Validation form
    document.getElementById('contactForm').addEventListener('submit', function(e) {
        const form = this;

        if (!form.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();
        } else {
            // Show loading state
            const submitBtn = document.getElementById('submitBtn');
            submitBtn.classList.add('loading');
            submitBtn.disabled = true;
        }

        form.classList.add('was-validated');
    });

    // Real-time validation - Validation theo thời gian thực
    const formFields = document.querySelectorAll('#contactForm .form-control, #contactForm .form-select');
    formFields.forEach(field => {
        field.addEventListener('input', function() {
            validateField(this);
        });

        field.addEventListener('blur', function() {
            validateField(this);
        });
    });

    function validateField(field) {
        if (field.checkValidity()) {
            field.classList.remove('is-invalid');
            field.classList.add('is-valid');
        } else {
            field.classList.remove('is-valid');
            field.classList.add('is-invalid');
        }
    }

    // Phone number formatting - Định dạng số điện thoại
    document.getElementById('phone').addEventListener('input', function(e) {
        let value = e.target.value.replace(/\D/g, '');

        if (value.length > 0) {
            if (value.length <= 3) {
                value = value;
            } else if (value.length <= 6) {
                value = value.slice(0, 3) + ' ' + value.slice(3);
            } else if (value.length <= 10) {
                value = value.slice(0, 3) + ' ' + value.slice(3, 6) + ' ' + value.slice(6);
            } else {
                value = value.slice(0, 3) + ' ' + value.slice(3, 6) + ' ' + value.slice(6, 10);
            }
        }

        e.target.value = value;
    });

    // Character counter for message - Đếm ký tự tin nhắn
    const messageField = document.getElementById('message');
    const maxLength = 1000;

    // Create character counter
    const counterDiv = document.createElement('div');
    counterDiv.className = 'text-end mt-1';
    counterDiv.style.fontSize = '0.8rem';
    counterDiv.style.color = 'var(--text-secondary)';
    messageField.parentNode.appendChild(counterDiv);

    function updateCounter() {
        const currentLength = messageField.value.length;
        counterDiv.textContent = `${currentLength}/${maxLength} ký tự`;

        if (currentLength > maxLength * 0.9) {
            counterDiv.style.color = 'var(--warning-color)';
        } else if (currentLength > maxLength) {
            counterDiv.style.color = 'var(--danger-color)';
        } else {
            counterDiv.style.color = 'var(--text-secondary)';
        }
    }

    messageField.addEventListener('input', updateCounter);
    updateCounter(); // Initialize counter

    // Auto-resize textarea - Tự động thay đổi kích thước textarea
    messageField.addEventListener('input', function() {
        this.style.height = 'auto';
        this.style.height = Math.min(this.scrollHeight, 200) + 'px';
    });

    // Animation for contact items - Animation cho các mục liên hệ
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach((entry, index) => {
            if (entry.isIntersecting) {
                setTimeout(() => {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }, index * 100);
            }
        });
    }, observerOptions);

    // Initialize animations - Khởi tạo animations
    document.addEventListener('DOMContentLoaded', function() {
        // Animate contact items
        const contactItems = document.querySelectorAll('.contact-item, .accordion-item');
        contactItems.forEach((item, index) => {
            item.style.opacity = '0';
            item.style.transform = 'translateY(20px)';
            item.style.transition = 'all 0.6s ease';
            observer.observe(item);
        });

        // Auto focus on first field
        document.getElementById('fullName').focus();

        // Clear form if there are no errors
        if (!document.querySelector('.alert-danger')) {
            // Keep form values for re-submission in case of validation errors
        }
    });

    // Social media hover effects - Hiệu ứng hover cho social media
    document.querySelectorAll('.social-link').forEach(link => {
        link.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-4px) scale(1.1)';
        });

        link.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
        });
    });

    // Prevent double submission - Ngăn submit form nhiều lần
    document.getElementById('contactForm').addEventListener('submit', function() {
        const submitBtn = document.getElementById('submitBtn');
        submitBtn.disabled = true;

        // Re-enable after 5 seconds in case of errors
        setTimeout(() => {
            if (submitBtn.classList.contains('loading')) {
                submitBtn.classList.remove('loading');
                submitBtn.disabled = false;
            }
        }, 5000);
    });
</script>
</body>
</html>