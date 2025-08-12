<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - Hệ thống Quản lý Khóa học</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --accent-color: #f093fb;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* Navigation */
        .navbar {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            box-shadow: 0 2px 20px rgba(0,0,0,0.1);
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
        }

        /* Hero Section */
        .hero-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 100px 0;
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
            background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.1'%3E%3Ccircle cx='30' cy='30' r='3'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
        }

        .hero-content {
            position: relative;
            z-index: 2;
        }

        .hero-title {
            font-size: 3.5rem;
            font-weight: 800;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }

        .hero-subtitle {
            font-size: 1.25rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }

        .btn-hero {
            padding: 15px 40px;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 50px;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            margin: 0 10px;
        }

        .btn-hero:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }

        /* Stats Section */
        .stats-section {
            background: #f8f9fa;
            padding: 80px 0;
        }

        .stat-card {
            background: white;
            border-radius: 20px;
            padding: 40px 20px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            height: 100%;
        }

        .stat-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 50px rgba(0,0,0,0.15);
        }

        .stat-icon {
            font-size: 3rem;
            margin-bottom: 20px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 800;
            color: #333;
            margin-bottom: 10px;
        }

        .stat-label {
            font-size: 1.1rem;
            color: #666;
            font-weight: 500;
        }

        /* Courses Section */
        .courses-section {
            padding: 80px 0;
        }

        .section-title {
            text-align: center;
            margin-bottom: 60px;
        }

        .section-title h2 {
            font-size: 2.5rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 15px;
        }

        .section-title p {
            font-size: 1.1rem;
            color: #666;
            max-width: 600px;
            margin: 0 auto;
        }

        .course-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            height: 100%;
        }

        .course-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 50px rgba(0,0,0,0.15);
        }

        .course-image {
            height: 200px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
        }

        .course-content {
            padding: 25px;
        }

        .course-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
            line-height: 1.4;
        }

        .course-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            font-size: 0.9rem;
            color: #666;
        }

        .course-description {
            color: #666;
            font-size: 0.95rem;
            line-height: 1.6;
            margin-bottom: 20px;
        }

        .course-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .btn-course {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border: none;
            color: white;
            padding: 10px 25px;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-course:hover {
            background: linear-gradient(135deg, var(--secondary-color), var(--primary-color));
            transform: translateX(5px);
        }

        /* Categories Section */
        .categories-section {
            background: #f8f9fa;
            padding: 80px 0;
        }

        .category-card {
            background: white;
            border-radius: 15px;
            padding: 30px 20px;
            text-align: center;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            height: 100%;
        }

        .category-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }

        .category-icon {
            font-size: 2.5rem;
            margin-bottom: 20px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .category-name {
            font-size: 1.2rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }

        .category-count {
            color: #666;
            font-size: 0.9rem;
        }

        /* Footer */
        .footer {
            background: #333;
            color: white;
            padding: 60px 0 30px;
        }

        .footer h5 {
            color: var(--primary-color);
            margin-bottom: 20px;
        }

        .footer-bottom {
            border-top: 1px solid #555;
            margin-top: 40px;
            padding-top: 20px;
            text-align: center;
            color: #ccc;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.5rem;
            }

            .hero-subtitle {
                font-size: 1rem;
            }

            .btn-hero {
                display: block;
                margin: 10px 0;
            }
        }
    </style>
</head>
<body>
<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container">
        <a class="navbar-brand" href="/">
            <i class="fas fa-graduation-cap me-2"></i>
            CourseHub
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="/">Trang chủ</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/courses">Khóa học</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/categories">Danh mục</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/about">Giới thiệu</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/contact">Liên hệ</a>
                </li>
                <c:choose>
                    <c:when test="${empty currentUser}">
                        <li class="nav-item">
                            <a class="nav-link" href="/login">Đăng nhập</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/register">Đăng ký</a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                <i class="fas fa-user me-1"></i>
                                    ${currentUser.username}
                            </a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="/profile">Hồ sơ</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="/logout">Đăng xuất</a></li>
                            </ul>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<section class="hero-section">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-6">
                <div class="hero-content">
                    <h1 class="hero-title">Học trực tuyến<br>hiệu quả hơn</h1>
                    <p class="hero-subtitle">
                        Khám phá hàng nghìn khóa học chất lượng cao từ các giảng viên hàng đầu.
                        Học mọi lúc, mọi nơi với trải nghiệm tuyệt vời.
                    </p>
                    <div class="hero-buttons">
                        <a href="/courses" class="btn btn-light btn-hero">
                            <i class="fas fa-search me-2"></i>Khám phá khóa học
                        </a>
                        <a href="/register" class="btn btn-outline-light btn-hero">
                            <i class="fas fa-user-plus me-2"></i>Đăng ký ngay
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="text-center">
                    <i class="fas fa-laptop-code" style="font-size: 20rem; opacity: 0.3;"></i>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Stats Section -->
<section class="stats-section">
    <div class="container">
        <div class="row">
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-book-open"></i>
                    </div>
                    <div class="stat-number">${totalCourses}</div>
                    <div class="stat-label">Khóa học</div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-number">${totalStudents}</div>
                    <div class="stat-label">Học viên</div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-chalkboard-teacher"></i>
                    </div>
                    <div class="stat-number">${totalInstructors}</div>
                    <div class="stat-label">Giảng viên</div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-certificate"></i>
                    </div>
                    <div class="stat-number">1000+</div>
                    <div class="stat-label">Chứng chí</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Popular Courses Section -->
<section class="courses-section">
    <div class="container">
        <div class="section-title">
            <h2>Khóa học phổ biến</h2>
            <p>Những khóa học được nhiều học viên lựa chọn và đánh giá cao nhất</p>
        </div>

        <div class="row">
            <c:forEach items="${popularCourses}" var="course" varStatus="status">
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="course-card">
                        <div class="course-image">
                            <i class="fas fa-${status.index % 2 == 0 ? 'laptop-code' : status.index % 3 == 0 ? 'paint-brush' : 'chart-line'}"></i>
                        </div>
                        <div class="course-content">
                            <h5 class="course-title">${course.name}</h5>
                            <div class="course-meta">
                                <span><i class="fas fa-user me-1"></i>${course.instructor.username}</span>
                                <span><i class="fas fa-users me-1"></i>${course.enrollmentCount} học viên</span>
                            </div>
                            <p class="course-description">
                                    ${course.description.length() > 100 ? course.description.substring(0, 100) += '...' : course.description}
                            </p>
                            <div class="course-footer">
                                <span class="text-success fw-bold">Miễn phí</span>
                                <a href="/courses/${course.id}" class="btn btn-course">
                                    Xem chi tiết <i class="fas fa-arrow-right ms-2"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <div class="text-center mt-5">
            <a href="/courses" class="btn btn-outline-primary btn-lg">
                Xem tất cả khóa học <i class="fas fa-arrow-right ms-2"></i>
            </a>
        </div>
    </div>
</section>

<!-- Categories Section -->
<section class="categories-section">
    <div class="container">
        <div class="section-title">
            <h2>Danh mục khóa học</h2>
            <p>Tìm hiểu các lĩnh vực đa dạng từ công nghệ đến kỹ năng mềm</p>
        </div>

        <div class="row">
            <c:forEach items="${topCategories}" var="category" varStatus="status">
                <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                    <div class="category-card">
                        <div class="category-icon">
                            <i class="fas fa-${
                                    category.name.contains('Lập trình') ? 'code' :
                                    category.name.contains('Thiết kế') ? 'palette' :
                                    category.name.contains('Marketing') ? 'bullhorn' :
                                    category.name.contains('Ngoại ngữ') ? 'language' :
                                    category.name.contains('Kinh doanh') ? 'briefcase' :
                                    'graduation-cap'
                                }"></i>
                        </div>
                        <div class="category-name">${category.name}</div>
                        <div class="category-count">${category.courseCount} khóa học</div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="footer">
    <div class="container">
        <div class="row">
            <div class="col-lg-4 col-md-6 mb-4">
                <h5><i class="fas fa-graduation-cap me-2"></i>CourseHub</h5>
                <p>Nền tảng học trực tuyến hàng đầu Việt Nam, cung cấp các khóa học chất lượng cao với giảng viên giàu kinh nghiệm.</p>
                <div class="social-links">
                    <a href="#" class="text-white me-3"><i class="fab fa-facebook fa-lg"></i></a>
                    <a href="#" class="text-white me-3"><i class="fab fa-twitter fa-lg"></i></a>
                    <a href="#" class="text-white me-3"><i class="fab fa-linkedin fa-lg"></i></a>
                    <a href="#" class="text-white"><i class="fab fa-youtube fa-lg"></i></a>
                </div>
            </div>
            <div class="col-lg-2 col-md-6 mb-4">
                <h5>Khóa học</h5>
                <ul class="list-unstyled">
                    <li><a href="/courses" class="text-white-50">Tất cả khóa học</a></li>
                    <li><a href="/categories" class="text-white-50">Danh mục</a></li>
                    <li><a href="#" class="text-white-50">Miễn phí</a></li>
                    <li><a href="#" class="text-white-50">Phổ biến</a></li>
                </ul>
            </div>
            <div class="col-lg-2 col-md-6 mb-4">
                <h5>Hỗ trợ</h5>
                <ul class="list-unstyled">
                    <li><a href="/about" class="text-white-50">Giới thiệu</a></li>
                    <li><a href="/contact" class="text-white-50">Liên hệ</a></li>
                    <li><a href="#" class="text-white-50">FAQ</a></li>
                    <li><a href="#" class="text-white-50">Hướng dẫn</a></li>
                </ul>
            </div>
            <div class="col-lg-4 col-md-6 mb-4">
                <h5>Liên hệ</h5>
                <ul class="list-unstyled">
                    <li><i class="fas fa-map-marker-alt me-2"></i>123 Đường ABC, Quận 1, TP.HCM</li>
                    <li><i class="fas fa-phone me-2"></i>+84 123 456 789</li>
                    <li><i class="fas fa-envelope me-2"></i>info@coursehub.vn</li>
                </ul>
            </div>
        </div>

        <div class="footer-bottom">
            <p>&copy; 2024 CourseHub. Tất cả quyền được bảo lưu.</p>
        </div>
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>