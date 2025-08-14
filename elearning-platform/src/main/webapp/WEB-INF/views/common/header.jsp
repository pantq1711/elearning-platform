<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%--
    Header Navigation Component - Component điều hướng chung
    Sử dụng cho tất cả các trang trong hệ thống
    Responsive navigation với Bootstrap 5
    Tích hợp Spring Security cho authentication/authorization
--%>

<header class="navbar navbar-expand-lg navbar-dark bg-primary sticky-top shadow">
    <div class="container">
        <!-- Logo và tên website -->
        <a class="navbar-brand fw-bold" href="<c:url value='/' />">
            <i class="fas fa-graduation-cap me-2"></i>
            EduLearn Platform
        </a>

        <!-- Button toggle cho mobile -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Navigation menu chính -->
        <div class="collapse navbar-collapse" id="navbarMain">
            <!-- Menu bên trái -->
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/' />">
                        <i class="fas fa-home me-1"></i>Trang Chủ
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/courses' />">
                        <i class="fas fa-book me-1"></i>Khóa Học
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/about' />">
                        <i class="fas fa-info-circle me-1"></i>Giới Thiệu
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/contact' />">
                        <i class="fas fa-envelope me-1"></i>Liên Hệ
                    </a>
                </li>
            </ul>

            <!-- Search box (hiển thị trên trang courses) -->
            <c:if test="${pageContext.request.servletPath == '/courses'}">
                <form class="d-flex me-3" method="GET" action="<c:url value='/courses' />">
                    <div class="input-group">
                        <input type="text" class="form-control" name="search"
                               placeholder="Tìm kiếm khóa học..." value="${param.search}">
                        <button class="btn btn-outline-light" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </form>
            </c:if>

            <!-- Menu bên phải - Authentication -->
            <ul class="navbar-nav">
                <!-- Kiểm tra nếu user đã đăng nhập -->
                <sec:authorize access="isAuthenticated()">
                    <!-- User dropdown menu -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle me-1"></i>
                            <sec:authentication property="principal.fullName" />
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <!-- Dashboard theo role -->
                            <sec:authorize access="hasRole('ADMIN')">
                                <li>
                                    <a class="dropdown-item" href="<c:url value='/admin/dashboard' />">
                                        <i class="fas fa-tachometer-alt me-2"></i>Dashboard Admin
                                    </a>
                                </li>
                            </sec:authorize>

                            <sec:authorize access="hasRole('INSTRUCTOR')">
                                <li>
                                    <a class="dropdown-item" href="<c:url value='/instructor/dashboard' />">
                                        <i class="fas fa-chalkboard-teacher me-2"></i>Dashboard Giảng Viên
                                    </a>
                                </li>
                            </sec:authorize>

                            <sec:authorize access="hasRole('STUDENT')">
                                <li>
                                    <a class="dropdown-item" href="<c:url value='/student/dashboard' />">
                                        <i class="fas fa-user-graduate me-2"></i>Dashboard Học Viên
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="<c:url value='/student/my-courses' />">
                                        <i class="fas fa-book-reader me-2"></i>Khóa Học Của Tôi
                                    </a>
                                </li>
                            </sec:authorize>

                            <li><hr class="dropdown-divider"></li>

                            <!-- Profile và settings -->
                            <li>
                                <a class="dropdown-item" href="<c:url value='/profile' />">
                                    <i class="fas fa-user-edit me-2"></i>Hồ Sơ Cá Nhân
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item" href="<c:url value='/change-password' />">
                                    <i class="fas fa-key me-2"></i>Đổi Mật Khẩu
                                </a>
                            </li>

                            <li><hr class="dropdown-divider"></li>

                            <!-- Logout -->
                            <li>
                                <form method="POST" action="<c:url value='/logout' />" class="d-inline">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <button type="submit" class="dropdown-item text-danger">
                                        <i class="fas fa-sign-out-alt me-2"></i>Đăng Xuất
                                    </button>
                                </form>
                            </li>
                        </ul>
                    </li>
                </sec:authorize>

                <!-- Menu cho user chưa đăng nhập -->
                <sec:authorize access="!isAuthenticated()">
                    <li class="nav-item">
                        <a class="nav-link" href="<c:url value='/login' />">
                            <i class="fas fa-sign-in-alt me-1"></i>Đăng Nhập
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link btn btn-outline-light ms-2 px-3" href="<c:url value='/register' />">
                            <i class="fas fa-user-plus me-1"></i>Đăng Ký
                        </a>
                    </li>
                </sec:authorize>
            </ul>
        </div>
    </div>
</header>

<!-- Notification/Alert bar (nếu có message) -->
<c:if test="${not empty message}">
    <div class="alert alert-success alert-dismissible fade show m-0" role="alert">
        <i class="fas fa-check-circle me-2"></i>${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show m-0" role="alert">
        <i class="fas fa-exclamation-triangle me-2"></i>${error}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<c:if test="${not empty warning}">
    <div class="alert alert-warning alert-dismissible fade show m-0" role="alert">
        <i class="fas fa-exclamation-circle me-2"></i>${warning}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<%-- Custom CSS cho header --%>
<style>
    .navbar-brand {
        font-size: 1.5rem;
        font-weight: 700;
    }

    .navbar-nav .nav-link {
        font-weight: 500;
        transition: all 0.3s ease;
    }

    .navbar-nav .nav-link:hover {
        background-color: rgba(255, 255, 255, 0.1);
        border-radius: 0.375rem;
    }

    .dropdown-menu {
        border: none;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        border-radius: 0.5rem;
    }

    .dropdown-item {
        font-weight: 500;
        transition: all 0.2s ease;
    }

    .dropdown-item:hover {
        background-color: var(--bs-primary);
        color: white;
    }

    .input-group .form-control:focus {
        border-color: rgba(255, 255, 255, 0.5);
        box-shadow: 0 0 0 0.2rem rgba(255, 255, 255, 0.25);
    }

    /* Animation cho alert */
    .alert {
        animation: slideDown 0.5s ease;
    }

    @keyframes slideDown {
        from {
            transform: translateY(-100%);
            opacity: 0;
        }
        to {
            transform: translateY(0);
            opacity: 1;
        }
    }
</style>