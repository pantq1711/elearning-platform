<%--
FILE: src/main/webapp/WEB-INF/views/common/header.jsp
FIX: Thêm Spring Security taglib và fix logic hiển thị nút
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- ✅ FIX: THÊM SPRING SECURITY TAGLIB --%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%--
    Header Navigation Component - Component điều hướng chung
    ✅ ĐÃ FIX: Thêm Spring Security taglib để ẩn/hiện nút đúng cách
--%>

<!-- Custom CSS và JS -->
<link href="${pageContext.request.contextPath}/css/placeholder.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/js/image-placeholder.js"></script>

<header class="navbar navbar-expand-lg navbar-dark bg-primary sticky-top shadow">
    <div class="container">
        <!-- Logo và tên website -->
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/">
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
                    <a class="nav-link" href="${pageContext.request.contextPath}/">
                        <i class="fas fa-home me-1"></i>Trang Chủ
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/courses">
                        <i class="fas fa-book me-1"></i>Khóa Học
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/categories">
                        <i class="fas fa-list me-1"></i>Danh Mục
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/contact">
                        <i class="fas fa-envelope me-1"></i>Liên Hệ
                    </a>
                </li>
            </ul>

            <!-- Menu bên phải -->
            <ul class="navbar-nav">

                <!-- ✅ MENU CHO USER ĐÃ ĐĂNG NHẬP -->
                <sec:authorize access="isAuthenticated()">

                    <!-- Dashboard Links theo role -->
                    <sec:authorize access="hasRole('ADMIN')">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                                <i class="fas fa-tachometer-alt me-1"></i>Admin Dashboard
                            </a>
                        </li>
                    </sec:authorize>

                    <sec:authorize access="hasRole('INSTRUCTOR')">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/instructor/dashboard">
                                <i class="fas fa-chalkboard-teacher me-1"></i>Giảng Viên
                            </a>
                        </li>
                    </sec:authorize>

                    <sec:authorize access="hasRole('STUDENT')">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/student/dashboard">
                                <i class="fas fa-user-graduate me-1"></i>Học Tập
                            </a>
                        </li>
                    </sec:authorize>

                    <!-- User Profile Dropdown -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle d-flex align-items-center"
                           href="#" id="userDropdown" role="button"
                           data-bs-toggle="dropdown" aria-expanded="false">

                            <!-- User Avatar -->
                            <c:choose>
                                <c:when test="${not empty currentUser.profileImageUrl}">
                                    <img src="${currentUser.profileImageUrl}"
                                         alt="Avatar"
                                         class="rounded-circle me-2"
                                         style="width: 32px; height: 32px; object-fit: cover;">
                                </c:when>
                                <c:otherwise>
                                    <div class="bg-secondary rounded-circle me-2 d-flex align-items-center justify-content-center"
                                         style="width: 32px; height: 32px;">
                                        <i class="fas fa-user text-white"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <!-- User Name -->
                            <span class="d-none d-lg-inline">
                                <sec:authentication property="principal.fullName" var="fullName"/>
                                <c:choose>
                                    <c:when test="${not empty fullName and fullName != 'N/A'}">
                                        ${fullName}
                                    </c:when>
                                    <c:otherwise>
                                        <sec:authentication property="principal.username"/>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </a>

                        <!-- Dropdown Menu -->
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                            <!-- Profile -->
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                    <i class="fas fa-user me-2"></i>Hồ Sơ Cá Nhân
                                </a>
                            </li>

                            <!-- Settings -->
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/profile/settings">
                                    <i class="fas fa-cog me-2"></i>Cài Đặt
                                </a>
                            </li>

                            <!-- Change Password -->
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/profile/change-password">
                                    <i class="fas fa-key me-2"></i>Đổi Mật Khẩu
                                </a>
                            </li>

                            <li><hr class="dropdown-divider"></li>

                            <!-- Logout -->
                            <li>
                                <form method="POST" action="${pageContext.request.contextPath}/logout" class="d-inline">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <button type="submit" class="dropdown-item text-danger">
                                        <i class="fas fa-sign-out-alt me-2"></i>Đăng Xuất
                                    </button>
                                </form>
                            </li>
                        </ul>
                    </li>
                </sec:authorize>

                <!-- ✅ MENU CHO USER CHƯA ĐĂNG NHẬP - CHỈ HIỂN THỊ KHI CHƯA LOGIN -->
                <sec:authorize access="!isAuthenticated()">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/login">
                            <i class="fas fa-sign-in-alt me-1"></i>Đăng Nhập
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link btn btn-outline-light ms-2 px-3"
                           href="${pageContext.request.contextPath}/register">
                            <i class="fas fa-user-plus me-1"></i>Đăng Ký
                        </a>
                    </li>
                </sec:authorize>
            </ul>
        </div>
    </div>
</header>

<!-- ✅ NOTIFICATION BAR (nếu có message) -->
<c:if test="${not empty message}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <div class="container">
            <i class="fas fa-check-circle me-2"></i>
                ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </div>
</c:if>

<c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <div class="container">
            <i class="fas fa-exclamation-triangle me-2"></i>
                ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </div>
</c:if>

<c:if test="${not empty warning}">
    <div class="alert alert-warning alert-dismissible fade show" role="alert">
        <div class="container">
            <i class="fas fa-exclamation-circle me-2"></i>
                ${warning}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </div>
</c:if>

<!-- ✅ DEBUGGING SCRIPT - Có thể xóa sau khi test xong -->
<script>
    console.log('🔐 Header loaded. Authentication status:');
    <sec:authorize access="isAuthenticated()">
    console.log('✅ User is authenticated');
    console.log('👤 Username: <sec:authentication property="principal.username"/>');
    console.log('🎭 Role: <sec:authentication property="principal.authorities"/>');
    </sec:authorize>
    <sec:authorize access="!isAuthenticated()">
    console.log('❌ User is NOT authenticated');
    </sec:authorize>
</script>