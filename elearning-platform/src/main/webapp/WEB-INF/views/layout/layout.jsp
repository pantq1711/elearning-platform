<%--
===============================
LAYOUT CHUNG CHO TẤT CẢ TRANG
===============================
File: /WEB-INF/views/layout/layout.jsp
--%>
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
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <%-- SEO Meta Tags --%>
    <meta name="description" content="Hệ thống quản lý khóa học trực tuyến chuyên nghiệp">
    <meta name="keywords" content="e-learning, khóa học online, học trực tuyến">
    <meta name="author" content="E-Learning Platform">

    <%-- Title với dynamic content --%>
    <title>
        <c:choose>
            <c:when test="${not empty pageTitle}">${pageTitle} - </c:when>
        </c:choose>
        E-Learning Platform
    </title>

    <%-- Favicon --%>
    <link rel="icon" type="image/x-icon" href="/images/favicon.ico">

    <%-- Bootstrap 5 CSS --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <%-- Font Awesome Icons --%>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <%-- Google Fonts --%>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <%-- Custom CSS --%>
    <link href="/css/main.css" rel="stylesheet">
    <link href="/css/components.css" rel="stylesheet">
    <link href="/css/responsive.css" rel="stylesheet">

    <%-- Page specific CSS --%>
    <c:if test="${not empty pageCSS}">
        <link href="/css/${pageCSS}" rel="stylesheet">
    </c:if>

    <%-- CSRF Token cho Ajax requests --%>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
</head>

<body class="<c:out value='${bodyClass}' default='' />">
<%-- Loading Spinner --%>
<div id="loading-spinner" class="loading-overlay">
    <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">Đang tải...</span>
    </div>
</div>

<%-- Main Wrapper --%>
<div class="wrapper">
    <%-- Header Navigation --%>
    <jsp:include page="header.jsp" />

    <%-- Sidebar cho admin/instructor --%>
    <sec:authorize access="hasAnyRole('ADMIN', 'INSTRUCTOR')">
        <jsp:include page="sidebar.jsp" />
    </sec:authorize>

    <%-- Main Content Area --%>
    <main class="main-content">
        <%-- Breadcrumb Navigation --%>
        <c:if test="${not empty breadcrumbs}">
            <div class="container-fluid">
                <nav aria-label="breadcrumb" class="mb-4">
                    <ol class="breadcrumb">
                        <c:forEach var="crumb" items="${breadcrumbs}" varStatus="status">
                            <li class="breadcrumb-item ${status.last ? 'active' : ''}">
                                <c:choose>
                                    <c:when test="${status.last}">
                                        ${crumb.name}
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${crumb.url}">${crumb.name}</a>
                                    </c:otherwise>
                                </c:choose>
                            </li>
                        </c:forEach>
                    </ol>
                </nav>
            </div>
        </c:if>

        <%-- Alert Messages --%>
        <c:if test="${not empty message}">
            <div class="container-fluid">
                <div class="alert alert-${messageType} alert-dismissible fade show" role="alert">
                    <i class="fas fa-info-circle me-2"></i>
                        ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </div>
        </c:if>

        <%-- Page Content --%>
        <div class="content-wrapper">
            <jsp:include page="${contentPage}" />
        </div>
    </main>

    <%-- Footer --%>
    <jsp:include page="footer.jsp" />
</div>

<%-- Back to Top Button --%>
<button id="back-to-top" class="btn btn-primary btn-floating">
    <i class="fas fa-arrow-up"></i>
</button>

<%-- Toast Container for Notifications --%>
<div class="toast-container position-fixed top-0 end-0 p-3">
    <%-- Toast messages sẽ được inject bằng JavaScript --%>
</div>

<%-- JavaScript Libraries --%>
<%-- Bootstrap JS --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<%-- jQuery --%>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<%-- Chart.js cho biểu đồ --%>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<%-- Custom JavaScript --%>
<script src="/js/main.js"></script>
<script src="/js/components.js"></script>
<script src="/js/utils.js"></script>

<%-- Page specific JavaScript --%>
<c:if test="${not empty pageJS}">
    <script src="/js/${pageJS}"></script>
</c:if>

<%-- Inline JavaScript cho CSRF và config --%>
<script>
    // Global configuration
    window.APP_CONFIG = {
        csrfToken: '${_csrf.token}',
        csrfHeader: '${_csrf.headerName}',
        contextPath: '${pageContext.request.contextPath}',
        currentUser: {
            <sec:authorize access="isAuthenticated()">
            id: '<sec:authentication property="principal.id"/>',
            username: '<sec:authentication property="principal.username"/>',
            fullName: '<sec:authentication property="principal.fullName"/>',
            role: '<sec:authentication property="principal.role"/>'
            </sec:authorize>
        }
    };

    // Setup CSRF token cho tất cả Ajax requests
    $.ajaxSetup({
        beforeSend: function(xhr) {
            xhr.setRequestHeader(window.APP_CONFIG.csrfHeader, window.APP_CONFIG.csrfToken);
        }
    });
</script>
</body>
</html>

<%--
===============================
HEADER NAVIGATION
===============================
File: /WEB-INF/views/layout/header.jsp
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<header class="header">
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
        <div class="container-fluid">
            <%-- Logo và Brand --%>
            <a class="navbar-brand d-flex align-items-center" href="/">
                <img src="/images/logo.png" alt="Logo" width="40" height="40" class="me-2">
                <span class="fw-bold">E-Learning</span>
            </a>

            <%-- Mobile Toggle Button --%>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>

            <%-- Navigation Menu --%>
            <div class="collapse navbar-collapse" id="navbarNav">
                <%-- Left Navigation --%>
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="/">
                            <i class="fas fa-home me-1"></i>Trang chủ
                        </a>
                    </li>

                    <%-- Navigation cho từng role --%>
                    <sec:authorize access="hasRole('ADMIN')">
                        <li class="nav-item">
                            <a class="nav-link" href="/admin/dashboard">
                                <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">
                                <i class="fas fa-cogs me-1"></i>Quản lý
                            </a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="/admin/users">
                                    <i class="fas fa-users me-2"></i>Người dùng
                                </a></li>
                                <li><a class="dropdown-item" href="/admin/courses">
                                    <i class="fas fa-book me-2"></i>Khóa học
                                </a></li>
                                <li><a class="dropdown-item" href="/admin/categories">
                                    <i class="fas fa-tags me-2"></i>Danh mục
                                </a></li>
                            </ul>
                        </li>
                    </sec:authorize>

                    <sec:authorize access="hasRole('INSTRUCTOR')">
                        <li class="nav-item">
                            <a class="nav-link" href="/instructor/dashboard">
                                <i class="fas fa-chalkboard-teacher me-1"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/instructor/courses">
                                <i class="fas fa-book me-1"></i>Khóa học của tôi
                            </a>
                        </li>
                    </sec:authorize>

                    <sec:authorize access="hasRole('STUDENT')">
                        <li class="nav-item">
                            <a class="nav-link" href="/student/dashboard">
                                <i class="fas fa-user-graduate me-1"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/student/courses">
                                <i class="fas fa-search me-1"></i>Tìm khóa học
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/student/my-courses">
                                <i class="fas fa-bookmark me-1"></i>Khóa học của tôi
                            </a>
                        </li>
                    </sec:authorize>
                </ul>

                <%-- Right Navigation --%>
                <ul class="navbar-nav">
                    <%-- Search Form --%>
                    <li class="nav-item me-2">
                        <form class="d-flex" action="/search" method="get">
                            <div class="input-group">
                                <input class="form-control form-control-sm" type="search"
                                       name="q" placeholder="Tìm kiếm khóa học...">
                                <button class="btn btn-outline-light btn-sm" type="submit">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </form>
                    </li>

                    <%-- Notifications (for authenticated users) --%>
                    <sec:authorize access="isAuthenticated()">
                        <li class="nav-item dropdown">
                            <a class="nav-link position-relative" href="#" data-bs-toggle="dropdown">
                                <i class="fas fa-bell"></i>
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                    3
                                </span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end notification-dropdown">
                                <li class="dropdown-header">Thông báo</li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item" href="#">
                                        <div class="d-flex">
                                            <div class="flex-shrink-0">
                                                <i class="fas fa-info-circle text-primary"></i>
                                            </div>
                                            <div class="flex-grow-1 ms-2">
                                                <h6 class="mb-0 small">Khóa học mới</h6>
                                                <p class="mb-0 small text-muted">Java Spring Boot đã được thêm</p>
                                            </div>
                                        </div>
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-center" href="/notifications">Xem tất cả</a></li>
                            </ul>
                        </li>
                    </sec:authorize>

                    <%-- User Menu --%>
                    <sec:authorize access="isAuthenticated()">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" data-bs-toggle="dropdown">
                                <img src="<sec:authentication property='principal.profileImageUrl'/>"
                                     alt="Avatar" class="rounded-circle me-2" width="32" height="32"
                                     onerror="this.src='/images/default-avatar.png'">
                                <span><sec:authentication property="principal.fullName"/></span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li class="dropdown-header">
                                    <strong><sec:authentication property="principal.fullName"/></strong>
                                    <br>
                                    <small class="text-muted">
                                        <sec:authentication property="principal.role"/>
                                    </small>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item" href="/profile">
                                        <i class="fas fa-user me-2"></i>Hồ sơ cá nhân
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="/settings">
                                        <i class="fas fa-cog me-2"></i>Cài đặt
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <form action="/logout" method="post" class="d-inline">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <button type="submit" class="dropdown-item text-danger">
                                            <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                                        </button>
                                    </form>
                                </li>
                            </ul>
                        </li>
                    </sec:authorize>

                    <%-- Login/Register cho guest users --%>
                    <sec:authorize access="!isAuthenticated()">
                        <li class="nav-item">
                            <a class="nav-link" href="/login">
                                <i class="fas fa-sign-in-alt me-1"></i>Đăng nhập
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/register">
                                <i class="fas fa-user-plus me-1"></i>Đăng ký
                            </a>
                        </li>
                    </sec:authorize>
                </ul>
            </div>
        </div>
    </nav>
</header>

<%--
===============================
SIDEBAR NAVIGATION (Admin/Instructor)
===============================
File: /WEB-INF/views/layout/sidebar.jsp
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<aside class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <h5 class="text-center text-white mb-0">
            <sec:authorize access="hasRole('ADMIN')">
                <i class="fas fa-crown me-2"></i>Admin Panel
            </sec:authorize>
            <sec:authorize access="hasRole('INSTRUCTOR')">
                <i class="fas fa-chalkboard-teacher me-2"></i>Instructor Panel
            </sec:authorize>
        </h5>
    </div>

    <nav class="sidebar-nav">
        <ul class="nav flex-column">
            <%-- Admin Menu --%>
            <sec:authorize access="hasRole('ADMIN')">
                <li class="nav-item">
                    <a class="nav-link ${currentPage == 'admin-dashboard' ? 'active' : ''}"
                       href="/admin/dashboard">
                        <i class="fas fa-tachometer-alt me-2"></i>
                        Dashboard
                    </a>
                </li>

                <li class="nav-item">
                    <h6 class="sidebar-heading text-muted mt-3 mb-2">QUẢN LÝ</h6>
                </li>

                <li class="nav-item">
                    <a class="nav-link ${currentPage == 'admin-users' ? 'active' : ''}"
                       href="/admin/users">
                        <i class="fas fa-users me-2"></i>
                        Người dùng
                        <span class="badge bg-primary rounded-pill ms-auto">${totalUsers}</span>
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link ${currentPage == 'admin-courses' ? 'active' : ''}"
                       href="/admin/courses">
                        <i class="fas fa-book me-2"></i>
                        Khóa học
                        <span class="badge bg-success rounded-pill ms-auto">${totalCourses}</span>
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link ${currentPage == 'admin-categories' ? 'active' : ''}"
                       href="/admin/categories">
                        <i class="fas fa-tags me-2"></i>
                        Danh mục
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link ${currentPage == 'admin-enrollments' ? 'active' : ''}"
                       href="/admin/enrollments">
                        <i class="fas fa-clipboard-list me-2"></i>
                        Đăng ký
                        <span class="badge bg-info rounded-pill ms-auto">${totalEnrollments}</span>
                    </a>
                </li>

                <li class="nav-item">
                    <h6 class="sidebar-heading text-muted mt-3 mb-2">BÁO CÁO</h6>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="/admin/reports">
                        <i class="fas fa-chart-bar me-2"></i>
                        Thống kê
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="/admin/analytics">
                        <i class="fas fa-chart-line me-2"></i>
                        Phân tích
                    </a>
                </li>

                <li class="nav-item">
                    <h6 class="sidebar-heading text-muted mt-3 mb-2">HỆ THỐNG</h6>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="/admin/settings">
                        <i class="fas fa-cog me-2"></i>
                        Cài đặt
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="/admin/logs">
                        <i class="fas fa-file-alt me-2"></i>
                        Logs
                    </a>
                </li>
            </sec:authorize>

            <%-- Instructor Menu --%>
            <sec:authorize access="hasRole('INSTRUCTOR')">
                <li class="nav-item">
                    <a class="nav-link ${currentPage == 'instructor-dashboard' ? 'active' : ''}"
                       href="/instructor/dashboard">
                        <i class="fas fa-tachometer-alt me-2"></i>
                        Dashboard
                    </a>
                </li>

                <li class="nav-item">
                    <h6 class="sidebar-heading text-muted mt-3 mb-2">KHÓA HỌC</h6>
                </li>

                <li class="nav-item">
                    <a class="nav-link ${currentPage == 'instructor-courses' ? 'active' : ''}"
                       href="/instructor/courses">
                        <i class="fas fa-book me-2"></i>
                        Khóa học của tôi
                        <span class="badge bg-primary rounded-pill ms-auto">${myCourses}</span>
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="/instructor/courses/new">
                        <i class="fas fa-plus me-2"></i>
                        Tạo khóa học mới
                    </a>
                </li>

                <li class="nav-item">
                    <h6 class="sidebar-heading text-muted mt-3 mb-2">GIẢNG DẠY</h6>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="/instructor/students">
                        <i class="fas fa-user-graduate me-2"></i>
                        Học viên
                        <span class="badge bg-success rounded-pill ms-auto">${myStudents}</span>
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="/instructor/quizzes">
                        <i class="fas fa-question-circle me-2"></i>
                        Quiz & Bài kiểm tra
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="/instructor/feedback">
                        <i class="fas fa-comments me-2"></i>
                        Feedback
                    </a>
                </li>

                <li class="nav-item">
                    <h6 class="sidebar-heading text-muted mt-3 mb-2">BÁO CÁO</h6>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="/instructor/analytics">
                        <i class="fas fa-chart-bar me-2"></i>
                        Thống kê khóa học
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="/instructor/earnings">
                        <i class="fas fa-dollar-sign me-2"></i>
                        Thu nhập
                    </a>
                </li>
            </sec:authorize>
        </ul>
    </nav>

    <%-- Sidebar Footer --%>
    <div class="sidebar-footer">
        <div class="text-center text-white-50 small">
            <i class="fas fa-user me-1"></i>
            <sec:authentication property="principal.fullName"/>
        </div>
        <div class="text-center mt-2">
            <button class="btn btn-sm btn-outline-light" id="sidebar-toggle">
                <i class="fas fa-angle-left"></i>
            </button>
        </div>
    </div>
</aside>

<%-- Sidebar Overlay cho mobile --%>
<div class="sidebar-overlay" id="sidebar-overlay"></div>

<%--
===============================
FOOTER
===============================
File: /WEB-INF/views/layout/footer.jsp
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<footer class="footer bg-dark text-light">
    <div class="container">
        <div class="row">
            <%-- Company Info --%>
            <div class="col-lg-4 col-md-6 mb-4">
                <h5 class="mb-3">
                    <img src="/images/logo-white.png" alt="Logo" width="30" height="30" class="me-2">
                    E-Learning Platform
                </h5>
                <p class="text-muted">
                    Nền tảng học tập trực tuyến hàng đầu Việt Nam, cung cấp các khóa học chất lượng cao
                    với giảng viên chuyên nghiệp và phương pháp giảng dạy hiện đại.
                </p>
                <div class="social-links">
                    <a href="#" class="text-light me-3"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="text-light me-3"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="text-light me-3"><i class="fab fa-linkedin-in"></i></a>
                    <a href="#" class="text-light me-3"><i class="fab fa-youtube"></i></a>
                </div>
            </div>

            <%-- Quick Links --%>
            <div class="col-lg-2 col-md-6 mb-4">
                <h6 class="mb-3">Liên kết nhanh</h6>
                <ul class="list-unstyled">
                    <li><a href="/" class="text-muted text-decoration-none">Trang chủ</a></li>
                    <li><a href="/courses" class="text-muted text-decoration-none">Khóa học</a></li>
                    <li><a href="/about" class="text-muted text-decoration-none">Về chúng tôi</a></li>
                    <li><a href="/contact" class="text-muted text-decoration-none">Liên hệ</a></li>
                    <li><a href="/blog" class="text-muted text-decoration-none">Blog</a></li>
                </ul>
            </div>

            <%-- Categories --%>
            <div class="col-lg-2 col-md-6 mb-4">
                <h6 class="mb-3">Danh mục</h6>
                <ul class="list-unstyled">
                    <li><a href="/courses?category=programming" class="text-muted text-decoration-none">Lập trình</a></li>
                    <li><a href="/courses?category=design" class="text-muted text-decoration-none">Thiết kế</a></li>
                    <li><a href="/courses?category=marketing" class="text-muted text-decoration-none">Marketing</a></li>
                    <li><a href="/courses?category=business" class="text-muted text-decoration-none">Kinh doanh</a></li>
                    <li><a href="/courses?category=language" class="text-muted text-decoration-none">Ngoại ngữ</a></li>
                </ul>
            </div>

            <%-- Support --%>
            <div class="col-lg-2 col-md-6 mb-4">
                <h6 class="mb-3">Hỗ trợ</h6>
                <ul class="list-unstyled">
                    <li><a href="/help" class="text-muted text-decoration-none">Trung tâm trợ giúp</a></li>
                    <li><a href="/faq" class="text-muted text-decoration-none">FAQ</a></li>
                    <li><a href="/privacy" class="text-muted text-decoration-none">Chính sách bảo mật</a></li>
                    <li><a href="/terms" class="text-muted text-decoration-none">Điều khoản sử dụng</a></li>
                    <li><a href="/refund" class="text-muted text-decoration-none">Chính sách hoàn tiền</a></li>
                </ul>
            </div>

            <%-- Contact Info --%>
            <div class="col-lg-2 col-md-6 mb-4">
                <h6 class="mb-3">Liên hệ</h6>
                <ul class="list-unstyled">
                    <li class="text-muted mb-2">
                        <i class="fas fa-map-marker-alt me-2"></i>
                        123 Đường ABC, Quận 1, TP.HCM
                    </li>
                    <li class="text-muted mb-2">
                        <i class="fas fa-phone me-2"></i>
                        (028) 1234 5678
                    </li>
                    <li class="text-muted mb-2">
                        <i class="fas fa-envelope me-2"></i>
                        support@elearning.vn
                    </li>
                    <li class="text-muted">
                        <i class="fas fa-clock me-2"></i>
                        T2-T6: 8:00 - 18:00
                    </li>
                </ul>
            </div>
        </div>

        <hr class="my-4">

        <%-- Copyright --%>
        <div class="row align-items-center">
            <div class="col-md-6">
                <p class="text-muted mb-0">
                    &copy; 2024 E-Learning Platform. All rights reserved.
                </p>
            </div>
            <div class="col-md-6 text-md-end">
                <p class="text-muted mb-0">
                    Made with <i class="fas fa-heart text-danger"></i> in Vietnam
                </p>
            </div>
        </div>
    </div>
</footer>