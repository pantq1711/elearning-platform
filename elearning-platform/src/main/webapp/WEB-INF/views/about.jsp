<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giới Thiệu - EduLearn Platform</title>

    <!-- Meta tags cho SEO -->
    <meta name="description" content="Tìm hiểu về EduLearn Platform - nền tảng học trực tuyến hàng đầu Việt Nam với hàng nghìn khóa học chất lượng cao và đội ngũ giảng viên chuyên nghiệp.">
    <meta name="keywords" content="giới thiệu, về chúng tôi, e-learning, học trực tuyến, EduLearn, giáo dục, đào tạo">

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
            line-height: 1.6;
        }

        /* Hero Section */
        .hero-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 5rem 0;
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
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            line-height: 1.2;
        }

        .hero-subtitle {
            font-size: 1.25rem;
            opacity: 0.9;
            margin-bottom: 2rem;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        /* Stats Section */
        .stats-section {
            background: white;
            padding: 4rem 0;
            margin-top: -2rem;
            position: relative;
            z-index: 3;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 2rem;
            max-width: 1000px;
            margin: 0 auto;
        }

        .stat-card {
            text-align: center;
            padding: 2rem;
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
        }

        .stat-number {
            font-size: 3rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: var(--text-secondary);
            font-weight: 500;
            font-size: 1.1rem;
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin: 0 auto 1rem;
        }

        /* Mission Section */
        .mission-section {
            background: var(--light-bg);
            padding: 5rem 0;
        }

        .mission-content {
            max-width: 800px;
            margin: 0 auto;
            text-align: center;
        }

        .section-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 1rem;
        }

        .section-subtitle {
            font-size: 1.1rem;
            color: var(--text-secondary);
            margin-bottom: 3rem;
        }

        .mission-text {
            font-size: 1.1rem;
            color: var(--text-primary);
            line-height: 1.8;
            margin-bottom: 2rem;
        }

        /* Values Section */
        .values-section {
            padding: 5rem 0;
            background: white;
        }

        .values-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 3rem;
        }

        .value-card {
            text-align: center;
            padding: 2.5rem;
            border-radius: 1rem;
            background: var(--light-bg);
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
        }

        .value-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--card-shadow);
            background: white;
        }

        .value-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            margin: 0 auto 1.5rem;
        }

        .value-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
        }

        .value-description {
            color: var(--text-secondary);
            line-height: 1.7;
        }

        /* Team Section */
        .team-section {
            background: var(--light-bg);
            padding: 5rem 0;
        }

        .team-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2rem;
            margin-top: 3rem;
        }

        .team-card {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            text-align: center;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
        }

        .team-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
        }

        .team-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            margin: 0 auto 1.5rem;
            object-fit: cover;
            border: 4px solid var(--primary-color);
        }

        .team-name {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .team-position {
            color: var(--primary-color);
            font-weight: 500;
            margin-bottom: 1rem;
        }

        .team-description {
            color: var(--text-secondary);
            font-size: 0.95rem;
            line-height: 1.6;
            margin-bottom: 1.5rem;
        }

        .team-social {
            display: flex;
            justify-content: center;
            gap: 1rem;
        }

        .social-link {
            width: 40px;
            height: 40px;
            background: var(--light-bg);
            color: var(--text-secondary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .social-link:hover {
            background: var(--primary-color);
            color: white;
            transform: scale(1.1);
        }

        /* Timeline Section */
        .timeline-section {
            background: white;
            padding: 5rem 0;
        }

        .timeline {
            position: relative;
            max-width: 800px;
            margin: 3rem auto 0;
        }

        .timeline::before {
            content: '';
            position: absolute;
            left: 50%;
            top: 0;
            bottom: 0;
            width: 2px;
            background: var(--primary-color);
            transform: translateX(-50%);
        }

        .timeline-item {
            position: relative;
            margin-bottom: 3rem;
            display: flex;
            align-items: center;
        }

        .timeline-item:nth-child(odd) {
            flex-direction: row;
        }

        .timeline-item:nth-child(even) {
            flex-direction: row-reverse;
        }

        .timeline-content {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border-color);
            width: calc(50% - 40px);
            position: relative;
        }

        .timeline-item:nth-child(odd) .timeline-content {
            margin-right: 40px;
        }

        .timeline-item:nth-child(even) .timeline-content {
            margin-left: 40px;
        }

        .timeline-content::before {
            content: '';
            position: absolute;
            top: 50%;
            width: 0;
            height: 0;
            border-style: solid;
            transform: translateY(-50%);
        }

        .timeline-item:nth-child(odd) .timeline-content::before {
            right: -15px;
            border: 15px solid transparent;
            border-left-color: white;
        }

        .timeline-item:nth-child(even) .timeline-content::before {
            left: -15px;
            border: 15px solid transparent;
            border-right-color: white;
        }

        .timeline-marker {
            width: 20px;
            height: 20px;
            background: var(--primary-color);
            border-radius: 50%;
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            z-index: 2;
            border: 4px solid white;
            box-shadow: 0 0 0 4px var(--primary-color);
        }

        .timeline-year {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        .timeline-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .timeline-description {
            color: var(--text-secondary);
            line-height: 1.6;
        }

        /* CTA Section */
        .cta-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 5rem 0;
            text-align: center;
        }

        .cta-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .cta-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 2rem;
        }

        .btn-cta {
            background: white;
            color: var(--primary-color);
            border: none;
            border-radius: 0.75rem;
            padding: 1rem 2rem;
            font-size: 1.1rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-cta:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.2);
            color: var(--primary-color);
            text-decoration: none;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.5rem;
            }

            .section-title {
                font-size: 2rem;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .values-grid,
            .team-grid {
                grid-template-columns: 1fr;
            }

            .timeline::before {
                left: 20px;
            }

            .timeline-item {
                flex-direction: row !important;
            }

            .timeline-content {
                width: calc(100% - 60px);
                margin-left: 60px !important;
                margin-right: 0 !important;
            }

            .timeline-content::before {
                left: -15px !important;
                right: auto !important;
                border: 15px solid transparent !important;
                border-right-color: white !important;
                border-left-color: transparent !important;
            }

            .timeline-marker {
                left: 20px;
                transform: translateX(-50%);
            }

            .cta-title {
                font-size: 2rem;
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
            <h1 class="hero-title">Về EduLearn Platform</h1>
            <p class="hero-subtitle">
                Chúng tôi tin rằng giáo dục là chìa khóa mở ra tương lai và mọi người đều xứng đáng
                có cơ hội học tập chất lượng cao, không giới hạn về thời gian và địa điểm.
            </p>
        </div>
    </div>
</section>

<!-- Stats Section -->
<section class="stats-section">
    <div class="container">
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-users"></i>
                </div>
                <div class="stat-number" data-count="50000">0</div>
                <div class="stat-label">Học viên</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-book"></i>
                </div>
                <div class="stat-number" data-count="1500">0</div>
                <div class="stat-label">Khóa học</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-chalkboard-teacher"></i>
                </div>
                <div class="stat-number" data-count="800">0</div>
                <div class="stat-label">Giảng viên</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-certificate"></i>
                </div>
                <div class="stat-number" data-count="25000">0</div>
                <div class="stat-label">Chứng chỉ</div>
            </div>
        </div>
    </div>
</section>

<!-- Mission Section -->
<section class="mission-section">
    <div class="container">
        <div class="mission-content">
            <h2 class="section-title">Sứ mệnh của chúng tôi</h2>
            <p class="section-subtitle">
                Tạo ra một nền tảng giáo dục trực tuyến toàn diện và dễ tiếp cận
            </p>
            <p class="mission-text">
                EduLearn Platform được sinh ra với sứ mệnh dân chủ hóa giáo dục, mang đến cơ hội học tập
                chất lượng cao cho mọi người, mọi lúc, mọi nơi. Chúng tôi tin rằng kiến thức không có
                ranh giới và mọi người đều có quyền tiếp cận với nền giáo dục tốt nhất.
            </p>
            <p class="mission-text">
                Thông qua việc kết nối các chuyên gia hàng đầu với người học khắp Việt Nam, chúng tôi
                xây dựng một cộng đồng học tập năng động, nơi tri thức được chia sẻ và phát triển không ngừng.
            </p>
        </div>
    </div>
</section>

<!-- Values Section -->
<section class="values-section">
    <div class="container">
        <div class="text-center">
            <h2 class="section-title">Giá trị cốt lõi</h2>
            <p class="section-subtitle">
                Những nguyên tắc định hướng mọi hoạt động của chúng tôi
            </p>
        </div>

        <div class="values-grid">
            <div class="value-card">
                <div class="value-icon">
                    <i class="fas fa-heart"></i>
                </div>
                <h3 class="value-title">Đam mê giáo dục</h3>
                <p class="value-description">
                    Chúng tôi đặt tình yêu với giáo dục lên hàng đầu, cam kết mang đến
                    trải nghiệm học tập tốt nhất cho mọi người.
                </p>
            </div>

            <div class="value-card">
                <div class="value-icon">
                    <i class="fas fa-star"></i>
                </div>
                <h3 class="value-title">Chất lượng cao</h3>
                <p class="value-description">
                    Mọi khóa học đều được kiểm duyệt kỹ lưỡng, đảm bảo nội dung
                    chất lượng và cập nhật với xu hướng mới nhất.
                </p>
            </div>

            <div class="value-card">
                <div class="value-icon">
                    <i class="fas fa-users"></i>
                </div>
                <h3 class="value-title">Cộng đồng</h3>
                <p class="value-description">
                    Xây dựng cộng đồng học tập mạnh mẽ, nơi mọi người cùng học hỏi,
                    chia sẻ và phát triển together.
                </p>
            </div>

            <div class="value-card">
                <div class="value-icon">
                    <i class="fas fa-rocket"></i>
                </div>
                <h3 class="value-title">Đổi mới</h3>
                <p class="value-description">
                    Không ngừng đổi mới công nghệ và phương pháp giảng dạy để
                    mang đến trải nghiệm học tập tốt nhất.
                </p>
            </div>

            <div class="value-card">
                <div class="value-icon">
                    <i class="fas fa-handshake"></i>
                </div>
                <h3 class="value-title">Tính liêm chính</h3>
                <p class="value-description">
                    Hoạt động với tính minh bạch và trách nhiệm cao, đặt lợi ích
                    của người học lên trên hết.
                </p>
            </div>

            <div class="value-card">
                <div class="value-icon">
                    <i class="fas fa-globe"></i>
                </div>
                <h3 class="value-title">Khả năng tiếp cận</h3>
                <p class="value-description">
                    Đảm bảo mọi người đều có thể tiếp cận giáo dục chất lượng
                    với chi phí hợp lý và giao diện thân thiện.
                </p>
            </div>
        </div>
    </div>
</section>

<!-- Team Section -->
<section class="team-section">
    <div class="container">
        <div class="text-center">
            <h2 class="section-title">Đội ngũ của chúng tôi</h2>
            <p class="section-subtitle">
                Những con người tài năng đằng sau thành công của EduLearn Platform
            </p>
        </div>

        <div class="team-grid">
            <div class="team-card">
                <img src="${pageContext.request.contextPath}/images/team/ceo.jpg"" alt="CEO" class="team-avatar">
                <h3 class="team-name">Nguyễn Văn An</h3>
                <p class="team-position">Giám đốc điều hành (CEO)</p>
                <p class="team-description">
                    Với hơn 15 năm kinh nghiệm trong lĩnh vực giáo dục và công nghệ,
                    An đã dẫn dắt EduLearn trở thành nền tảng học trực tuyến hàng đầu.
                </p>
                <div class="team-social">
                    <a href="#" class="social-link">
                        <i class="fab fa-linkedin"></i>
                    </a>
                    <a href="#" class="social-link">
                        <i class="fab fa-twitter"></i>
                    </a>
                    <a href="#" class="social-link">
                        <i class="fas fa-envelope"></i>
                    </a>
                </div>
            </div>

            <div class="team-card">
                <img src="${pageContext.request.contextPath}/images/team/cto.jpg"" alt="CTO" class="team-avatar">
                <h3 class="team-name">Trần Thị Bình</h3>
                <p class="team-position">Giám đốc công nghệ (CTO)</p>
                <p class="team-description">
                    Bình là chuyên gia công nghệ với đam mê xây dựng các sản phẩm
                    giáo dục hiện đại và dễ sử dụng cho mọi người.
                </p>
                <div class="team-social">
                    <a href="#" class="social-link">
                        <i class="fab fa-linkedin"></i>
                    </a>
                    <a href="#" class="social-link">
                        <i class="fab fa-github"></i>
                    </a>
                    <a href="#" class="social-link">
                        <i class="fas fa-envelope"></i>
                    </a>
                </div>
            </div>

            <div class="team-card">
                <img src="${pageContext.request.contextPath}/images/team/ceo-education.jpg"" alt="Head of Education" class="team-avatar">
                <h3 class="team-name">Lê Minh Cường</h3>
                <p class="team-position">Trưởng phòng Giáo dục</p>
                <p class="team-description">
                    Cường có nhiều năm kinh nghiệm trong việc phát triển chương trình
                    giảng dạy và đảm bảo chất lượng nội dung các khóa học.
                </p>
                <div class="team-social">
                    <a href="#" class="social-link">
                        <i class="fab fa-linkedin"></i>
                    </a>
                    <a href="#" class="social-link">
                        <i class="fab fa-twitter"></i>
                    </a>
                    <a href="#" class="social-link">
                        <i class="fas fa-envelope"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Timeline Section -->
<section class="timeline-section">
    <div class="container">
        <div class="text-center">
            <h2 class="section-title">Hành trình phát triển</h2>
            <p class="section-subtitle">
                Những dấu mốc quan trọng trong quá trình xây dựng và phát triển EduLearn
            </p>
        </div>

        <div class="timeline">
            <div class="timeline-item">
                <div class="timeline-marker"></div>
                <div class="timeline-content">
                    <div class="timeline-year">2020</div>
                    <h3 class="timeline-title">Thành lập công ty</h3>
                    <p class="timeline-description">
                        EduLearn Platform được thành lập với tầm nhìn trở thành nền tảng
                        giáo dục trực tuyến hàng đầu Việt Nam.
                    </p>
                </div>
            </div>

            <div class="timeline-item">
                <div class="timeline-marker"></div>
                <div class="timeline-content">
                    <div class="timeline-year">2021</div>
                    <h3 class="timeline-title">Ra mắt phiên bản đầu tiên</h3>
                    <p class="timeline-description">
                        Chính thức ra mắt với 50 khóa học đầu tiên và 100 giảng viên
                        chất lượng cao trong các lĩnh vực khác nhau.
                    </p>
                </div>
            </div>

            <div class="timeline-item">
                <div class="timeline-marker"></div>
                <div class="timeline-content">
                    <div class="timeline-year">2022</div>
                    <h3 class="timeline-title">Mở rộng quy mô</h3>
                    <p class="timeline-description">
                        Đạt mốc 10,000 học viên và 500 khóa học. Triển khai ứng dụng
                        di động để học tập mọi lúc, mọi nơi.
                    </p>
                </div>
            </div>

            <div class="timeline-item">
                <div class="timeline-marker"></div>
                <div class="timeline-content">
                    <div class="timeline-year">2023</div>
                    <h3 class="timeline-title">Đạt mốc quan trọng</h3>
                    <p class="timeline-description">
                        Vượt mốc 25,000 học viên và 1,000 khóa học. Nhận đầu tư từ
                        các quỹ đầu tư uy tín để mở rộng hoạt động.
                    </p>
                </div>
            </div>

            <div class="timeline-item">
                <div class="timeline-marker"></div>
                <div class="timeline-content">
                    <div class="timeline-year">2024</div>
                    <h3 class="timeline-title">Tích hợp AI và Machine Learning</h3>
                    <p class="timeline-description">
                        Áp dụng công nghệ AI để cá nhân hóa trải nghiệm học tập và
                        đề xuất khóa học phù hợp cho từng học viên.
                    </p>
                </div>
            </div>

            <div class="timeline-item">
                <div class="timeline-marker"></div>
                <div class="timeline-content">
                    <div class="timeline-year">2025</div>
                    <h3 class="timeline-title">Mở rộng quốc tế</h3>
                    <p class="timeline-description">
                        Kế hoạch mở rộng ra các quốc gia Đông Nam Á và đạt mốc
                        100,000 học viên trên toàn khu vực.
                    </p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- CTA Section -->
<section class="cta-section">
    <div class="container">
        <h2 class="cta-title">Sẵn sàng bắt đầu hành trình học tập?</h2>
        <p class="cta-subtitle">
            Tham gia cùng hàng nghìn người đã thay đổi cuộc sống thông qua giáo dục trực tuyến
        </p>
        <a href="${pageContext.request.contextPath}/register"" class="btn-cta">
            <i class="fas fa-rocket"></i>
            Đăng ký ngay hôm nay
        </a>
    </div>
</section>

<!-- Include Footer -->
<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JavaScript -->
<script>
    // Counter animation - Hiệu ứng đếm số
    function animateCounters() {
        const counters = document.querySelectorAll('.stat-number[data-count]');

        counters.forEach(counter => {
            const target = parseInt(counter.getAttribute('data-count'));
            const duration = 2000; // 2 seconds
            const step = target / (duration / 16); // 60fps
            let current = 0;

            const timer = setInterval(() => {
                current += step;
                if (current >= target) {
                    current = target;
                    clearInterval(timer);
                }

                // Format number with commas
                counter.textContent = Math.floor(current).toLocaleString('vi-VN');
            }, 16);
        });
    }

    // Intersection Observer for animations - Quan sát để kích hoạt animation
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate');

                // Trigger counter animation when stats section is visible
                if (entry.target.classList.contains('stats-section')) {
                    animateCounters();
                }
            }
        });
    }, observerOptions);

    // Initialize animations - Khởi tạo animations
    document.addEventListener('DOMContentLoaded', function() {
        // Observe sections for animation
        const sections = document.querySelectorAll('.stats-section, .value-card, .team-card, .timeline-item');
        sections.forEach(section => {
            observer.observe(section);
        });

        // Add stagger animation to value cards
        const valueCards = document.querySelectorAll('.value-card');
        valueCards.forEach((card, index) => {
            card.style.animationDelay = `${index * 0.1}s`;
        });

        // Add stagger animation to team cards
        const teamCards = document.querySelectorAll('.team-card');
        teamCards.forEach((card, index) => {
            card.style.animationDelay = `${index * 0.15}s`;
        });

        // Smooth scrolling for internal links
        document.querySelectorAll('a[href^="#"]').forEach(link => {
            link.addEventListener('click', function(e) {
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
    });

    // Add CSS for animations - Thêm CSS cho animations
    const style = document.createElement('style');
    style.textContent = `
            .value-card, .team-card, .timeline-item {
                opacity: 0;
                transform: translateY(30px);
                transition: all 0.6s ease;
            }

            .value-card.animate, .team-card.animate, .timeline-item.animate {
                opacity: 1;
                transform: translateY(0);
            }

            .stat-card {
                transition: all 0.3s ease;
            }

            .stat-number {
                transition: all 0.3s ease;
            }
        `;
    document.head.appendChild(style);
</script>
</body>
</html>