<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!--
Sidebar Navigation Component
Tùy chỉnh menu dựa trên role của user (Admin/Instructor/Student)
Sử dụng cho các trang dashboard và quản lý
-->

<div class="sidebar" id="sidebar">
    <!-- Logo và Brand -->
    <div class="sidebar-header">
        <div class="brand-logo">
            <i class="fas fa-graduation-cap me-2"></i>
            <span class="brand-name">EduLearn</span>
        </div>
        <button class="sidebar-toggle d-lg-none" onclick="toggleSidebar()">
            <i class="fas fa-times"></i>
        </button>
    </div>

    <!-- User Info Section -->
    <div class="user-section">
        <div class="user-avatar">
            <c:choose>
                <c:when test="${currentUser.avatarPath != null}">
                    <img src="${pageContext.request.contextPath}/images/avatars/${currentUser.avatarPath}""
                         alt="${currentUser.fullName}" class="avatar-img">
                </c:when>
                <c:otherwise>
                    <div class="avatar-placeholder">
                        <i class="fas fa-user"></i>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="user-info">
            <div class="user-name">${currentUser.fullName}</div>
            <div class="user-role">
                <sec:authorize access="hasRole('ADMIN')">
                    <span class="role-badge role-admin">
                        <i class="fas fa-crown me-1"></i>Quản trị viên
                    </span>
                </sec:authorize>
                <sec:authorize access="hasRole('INSTRUCTOR')">
                    <span class="role-badge role-instructor">
                        <i class="fas fa-chalkboard-teacher me-1"></i>Giảng viên
                    </span>
                </sec:authorize>
                <sec:authorize access="hasRole('STUDENT')">
                    <span class="role-badge role-student">
                        <i class="fas fa-user-graduate me-1"></i>Học viên
                    </span>
                </sec:authorize>
            </div>
        </div>
    </div>

    <!-- Navigation Menu -->
    <nav class="sidebar-nav">
        <!-- Admin Menu -->
        <sec:authorize access="hasRole('ADMIN')">
            <div class="nav-section">
                <div class="nav-section-title">Quản trị hệ thống</div>

                <a href="/admin/dashboard"
                   class="nav-item ${pageContext.request.requestURI.contains('/admin/dashboard') ? 'active' : ''}">
                    <i class="fas fa-tachometer-alt nav-icon"></i>
                    <span class="nav-text">Dashboard</span>
                </a>

                <a href="/admin/users""
                   class="nav-item ${pageContext.request.requestURI.contains('/admin/users') ? 'active' : ''}">
                    <i class="fas fa-users nav-icon"></i>
                    <span class="nav-text">Quản lý người dùng</span>
                    <span class="nav-badge">${totalUsers}</span>
                </a>

                <a href="/admin/courses""
                   class="nav-item ${pageContext.request.requestURI.contains('/admin/courses') ? 'active' : ''}">
                    <i class="fas fa-book nav-icon"></i>
                    <span class="nav-text">Quản lý khóa học</span>
                    <span class="nav-badge">${totalCourses}</span>
                </a>

                <a href="/admin/categories""
                   class="nav-item ${pageContext.request.requestURI.contains('/admin/categories') ? 'active' : ''}">
                    <i class="fas fa-tags nav-icon"></i>
                    <span class="nav-text">Danh mục</span>
                </a>

                <a href="/admin/analytics""
                   class="nav-item ${pageContext.request.requestURI.contains('/admin/analytics') ? 'active' : ''}">
                    <i class="fas fa-chart-bar nav-icon"></i>
                    <span class="nav-text">Thống kê báo cáo</span>
                </a>
            </div>

            <div class="nav-section">
                <div class="nav-section-title">Cài đặt</div>

                <a href="/admin/settings""
                   class="nav-item ${pageContext.request.requestURI.contains('/admin/settings') ? 'active' : ''}">
                    <i class="fas fa-cogs nav-icon"></i>
                    <span class="nav-text">Cấu hình hệ thống</span>
                </a>

                <a href="/admin/backup""
                   class="nav-item ${pageContext.request.requestURI.contains('/admin/backup') ? 'active' : ''}">
                    <i class="fas fa-database nav-icon"></i>
                    <span class="nav-text">Sao lưu dữ liệu</span>
                </a>
            </div>
        </sec:authorize>

        <!-- Instructor Menu -->
        <sec:authorize access="hasRole('INSTRUCTOR')">
            <div class="nav-section">
                <div class="nav-section-title">Giảng dạy</div>

                <a href="//instructor/dashboard""
                   class="nav-item ${pageContext.request.requestURI.contains('/instructor/dashboard') ? 'active' : ''}">
                    <i class="fas fa-tachometer-alt nav-icon"></i>
                    <span class="nav-text">Dashboard</span>
                </a>

                <a href="//instructor/courses""
                   class="nav-item ${pageContext.request.requestURI.contains('/instructor/courses') ? 'active' : ''}">
                    <i class="fas fa-book nav-icon"></i>
                    <span class="nav-text">Khóa học của tôi</span>
                    <span class="nav-badge">${instructorCourses}</span>
                </a>

                <a href="//instructor/lessons""
                   class="nav-item ${pageContext.request.requestURI.contains('/instructor/lessons') ? 'active' : ''}">
                    <i class="fas fa-play-circle nav-icon"></i>
                    <span class="nav-text">Quản lý bài giảng</span>
                </a>

                <a href="//instructor/quizzes""
                   class="nav-item ${pageContext.request.requestURI.contains('/instructor/quizzes') ? 'active' : ''}">
                    <i class="fas fa-question-circle nav-icon"></i>
                    <span class="nav-text">Bài kiểm tra</span>
                </a>

                <a href="//instructor/students""
                   class="nav-item ${pageContext.request.requestURI.contains('/instructor/students') ? 'active' : ''}">
                    <i class="fas fa-user-graduate nav-icon"></i>
                    <span class="nav-text">Học viên</span>
                    <span class="nav-badge">${instructorStudents}</span>
                </a>
            </div>

            <div class="nav-section">
                <div class="nav-section-title">Phân tích</div>

                <a href="//instructor/analytics""
                   class="nav-item ${pageContext.request.requestURI.contains('/instructor/analytics') ? 'active' : ''}">
                    <i class="fas fa-chart-line nav-icon"></i>
                    <span class="nav-text">Thống kê</span>
                </a>

                <a href="//instructor/earnings""
                   class="nav-item ${pageContext.request.requestURI.contains('/instructor/earnings') ? 'active' : ''}">
                    <i class="fas fa-dollar-sign nav-icon"></i>
                    <span class="nav-text">Thu nhập</span>
                </a>
            </div>
        </sec:authorize>

        <!-- Student Menu -->
        <sec:authorize access="hasRole('STUDENT')">
            <div class="nav-section">
                <div class="nav-section-title">Học tập</div>

                <a href="//student/dashboard""
                   class="nav-item ${pageContext.request.requestURI.contains('/student/dashboard') ? 'active' : ''}">
                    <i class="fas fa-tachometer-alt nav-icon"></i>
                    <span class="nav-text">Dashboard</span>
                </a>

                <a href="//student/my-courses""
                   class="nav-item ${pageContext.request.requestURI.contains('/student/my-courses') ? 'active' : ''}">
                    <i class="fas fa-book-reader nav-icon"></i>
                    <span class="nav-text">Khóa học của tôi</span>
                    <span class="nav-badge">${myCoursesCount}</span>
                </a>

                <a href="//courses""
                   class="nav-item">
                    <i class="fas fa-search nav-icon"></i>
                    <span class="nav-text">Khám phá khóa học</span>
                </a>

                <a href="//student/certificates""
                   class="nav-item ${pageContext.request.requestURI.contains('/student/certificates') ? 'active' : ''}">
                    <i class="fas fa-certificate nav-icon"></i>
                    <span class="nav-text">Chứng chỉ</span>
                </a>

                <a href="//student/wishlist""
                   class="nav-item ${pageContext.request.requestURI.contains('/student/wishlist') ? 'active' : ''}">
                    <i class="fas fa-heart nav-icon"></i>
                    <span class="nav-text">Yêu thích</span>
                    <span class="nav-badge">${wishlistCount}</span>
                </a>
            </div>

            <div class="nav-section">
                <div class="nav-section-title">Tiến độ</div>

                <a href="//student/progress""
                   class="nav-item ${pageContext.request.requestURI.contains('/student/progress') ? 'active' : ''}">
                    <i class="fas fa-chart-pie nav-icon"></i>
                    <span class="nav-text">Tiến độ học tập</span>
                </a>

                <a href="//student/achievements""
                   class="nav-item ${pageContext.request.requestURI.contains('/student/achievements') ? 'active' : ''}">
                    <i class="fas fa-trophy nav-icon"></i>
                    <span class="nav-text">Thành tích</span>
                </a>
            </div>
        </sec:authorize>

        <!-- Common Menu cho tất cả role -->
        <div class="nav-section">
            <div class="nav-section-title">Tài khoản</div>

            <a href="//profile""
               class="nav-item ${pageContext.request.requestURI.contains('/profile') ? 'active' : ''}">
                <i class="fas fa-user-edit nav-icon"></i>
                <span class="nav-text">Hồ sơ cá nhân</span>
            </a>

            <a href="//settings""
               class="nav-item ${pageContext.request.requestURI.contains('/settings') ? 'active' : ''}">
                <i class="fas fa-cog nav-icon"></i>
                <span class="nav-text">Cài đặt</span>
            </a>

            <a href="//notifications""
               class="nav-item ${pageContext.request.requestURI.contains('/notifications') ? 'active' : ''}">
                <i class="fas fa-bell nav-icon"></i>
                <span class="nav-text">Thông báo</span>
                <span class="nav-badge notification-count" style="display: none;">0</span>
            </a>
        </div>

        <!-- Quick Actions -->
        <div class="nav-section">
            <div class="nav-section-title">Hỗ trợ</div>

            <a href="//help"" class="nav-item">
                <i class="fas fa-question-circle nav-icon"></i>
                <span class="nav-text">Trợ giúp</span>
            </a>

            <a href="//contact"" class="nav-item">
                <i class="fas fa-envelope nav-icon"></i>
                <span class="nav-text">Liên hệ</span>
            </a>
        </div>
    </nav>

    <!-- Logout Button -->
    <div class="sidebar-footer">
        <form method="POST" action="//logout"" class="w-100">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <button type="submit" class="btn-logout">
                <i class="fas fa-sign-out-alt me-2"></i>
                <span>Đăng xuất</span>
            </button>
        </form>
    </div>
</div>

<!-- Sidebar Overlay cho mobile -->
<div class="sidebar-overlay" id="sidebarOverlay" onclick="closeSidebar()"></div>

<!-- CSS Styles cho Sidebar -->
<style>
    :root {
        --primary-color: #4f46e5;
        --primary-dark: #3730a3;
        --sidebar-width: 280px;
        --sidebar-bg: #1f2937;
        --sidebar-header-bg: #111827;
        --nav-hover-bg: #374151;
        --nav-active-bg: var(--primary-color);
        --text-primary: #f9fafb;
        --text-secondary: #d1d5db;
        --text-muted: #9ca3af;
        --border-color: #374151;
    }

    .sidebar {
        position: fixed;
        top: 0;
        left: 0;
        width: var(--sidebar-width);
        height: 100vh;
        background: var(--sidebar-bg);
        z-index: 1050;
        transform: translateX(-100%);
        transition: transform 0.3s ease;
        overflow-y: auto;
        overflow-x: hidden;
        display: flex;
        flex-direction: column;
    }

    .sidebar.show {
        transform: translateX(0);
    }

    /* Sidebar Header */
    .sidebar-header {
        background: var(--sidebar-header-bg);
        padding: 1.5rem 1.25rem;
        border-bottom: 1px solid var(--border-color);
        display: flex;
        align-items: center;
        justify-content: space-between;
        min-height: 80px;
    }

    .brand-logo {
        display: flex;
        align-items: center;
        color: var(--text-primary);
        font-size: 1.5rem;
        font-weight: 700;
    }

    .brand-logo i {
        color: var(--primary-color);
        margin-right: 0.5rem;
    }

    .sidebar-toggle {
        background: none;
        border: none;
        color: var(--text-secondary);
        font-size: 1.25rem;
        cursor: pointer;
        padding: 0.5rem;
        border-radius: 0.375rem;
        transition: all 0.3s ease;
    }

    .sidebar-toggle:hover {
        background: var(--nav-hover-bg);
        color: var(--text-primary);
    }

    /* User Section */
    .user-section {
        display: flex;
        align-items: center;
        padding: 1.5rem 1.25rem;
        border-bottom: 1px solid var(--border-color);
        background: rgba(79, 70, 229, 0.05);
    }

    .user-avatar {
        width: 50px;
        height: 50px;
        margin-right: 1rem;
        flex-shrink: 0;
    }

    .avatar-img {
        width: 100%;
        height: 100%;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid var(--primary-color);
    }

    .avatar-placeholder {
        width: 100%;
        height: 100%;
        border-radius: 50%;
        background: var(--primary-color);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 1.25rem;
    }

    .user-info {
        flex: 1;
        min-width: 0;
    }

    .user-name {
        color: var(--text-primary);
        font-weight: 600;
        font-size: 0.95rem;
        margin-bottom: 0.25rem;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .role-badge {
        display: inline-flex;
        align-items: center;
        padding: 0.25rem 0.75rem;
        border-radius: 1rem;
        font-size: 0.75rem;
        font-weight: 500;
    }

    .role-admin {
        background: rgba(251, 191, 36, 0.1);
        color: #fbbf24;
        border: 1px solid rgba(251, 191, 36, 0.2);
    }

    .role-instructor {
        background: rgba(59, 130, 246, 0.1);
        color: #3b82f6;
        border: 1px solid rgba(59, 130, 246, 0.2);
    }

    .role-student {
        background: rgba(34, 197, 94, 0.1);
        color: #22c55e;
        border: 1px solid rgba(34, 197, 94, 0.2);
    }

    /* Navigation */
    .sidebar-nav {
        flex: 1;
        padding: 1rem 0;
        overflow-y: auto;
    }

    .nav-section {
        margin-bottom: 2rem;
    }

    .nav-section-title {
        color: var(--text-muted);
        font-size: 0.75rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        padding: 0 1.25rem;
        margin-bottom: 0.75rem;
    }

    .nav-item {
        display: flex;
        align-items: center;
        padding: 0.75rem 1.25rem;
        color: var(--text-secondary);
        text-decoration: none;
        font-size: 0.9rem;
        font-weight: 500;
        transition: all 0.3s ease;
        position: relative;
        border-left: 3px solid transparent;
    }

    .nav-item:hover {
        background: var(--nav-hover-bg);
        color: var(--text-primary);
        text-decoration: none;
    }

    .nav-item.active {
        background: var(--nav-active-bg);
        color: white;
        border-left-color: white;
    }

    .nav-icon {
        width: 20px;
        margin-right: 0.75rem;
        text-align: center;
        font-size: 1rem;
        flex-shrink: 0;
    }

    .nav-text {
        flex: 1;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .nav-badge {
        background: var(--primary-color);
        color: white;
        font-size: 0.7rem;
        font-weight: 600;
        padding: 0.25rem 0.5rem;
        border-radius: 1rem;
        min-width: 20px;
        text-align: center;
        line-height: 1;
    }

    .notification-count {
        background: #ef4444;
        animation: pulse 2s infinite;
    }

    /* Sidebar Footer */
    .sidebar-footer {
        padding: 1rem 1.25rem;
        border-top: 1px solid var(--border-color);
        background: var(--sidebar-header-bg);
    }

    .btn-logout {
        width: 100%;
        background: none;
        border: 1px solid var(--border-color);
        color: var(--text-secondary);
        padding: 0.75rem 1rem;
        border-radius: 0.5rem;
        font-size: 0.9rem;
        font-weight: 500;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .btn-logout:hover {
        background: #ef4444;
        border-color: #ef4444;
        color: white;
    }

    /* Sidebar Overlay */
    .sidebar-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        z-index: 1040;
        opacity: 0;
        visibility: hidden;
        transition: all 0.3s ease;
    }

    .sidebar-overlay.show {
        opacity: 1;
        visibility: visible;
    }

    /* Responsive Design */
    @media (min-width: 992px) {
        .sidebar {
            transform: translateX(0);
            position: relative;
            z-index: auto;
        }

        .sidebar-toggle {
            display: none;
        }

        .sidebar-overlay {
            display: none;
        }
    }

    @media (max-width: 991.98px) {
        .sidebar {
            width: 100%;
            max-width: 320px;
        }
    }

    /* Scrollbar Styling */
    .sidebar::-webkit-scrollbar {
        width: 4px;
    }

    .sidebar::-webkit-scrollbar-track {
        background: var(--sidebar-bg);
    }

    .sidebar::-webkit-scrollbar-thumb {
        background: var(--border-color);
        border-radius: 2px;
    }

    .sidebar::-webkit-scrollbar-thumb:hover {
        background: var(--text-muted);
    }

    /* Animation */
    @keyframes pulse {
        0%, 100% {
            opacity: 1;
        }
        50% {
            opacity: 0.5;
        }
    }
</style>

<!-- JavaScript cho Sidebar -->
<script>
    // Toggle sidebar cho mobile - Hiển thị/ẩn sidebar trên mobile
    function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const overlay = document.getElementById('sidebarOverlay');

        sidebar.classList.toggle('show');
        overlay.classList.toggle('show');

        // Prevent body scroll when sidebar is open
        document.body.style.overflow = sidebar.classList.contains('show') ? 'hidden' : '';
    }

    // Close sidebar - Đóng sidebar
    function closeSidebar() {
        const sidebar = document.getElementById('sidebar');
        const overlay = document.getElementById('sidebarOverlay');

        sidebar.classList.remove('show');
        overlay.classList.remove('show');
        document.body.style.overflow = '';
    }

    // Close sidebar when clicking outside on mobile - Đóng sidebar khi click bên ngoài
    document.addEventListener('click', function(e) {
        const sidebar = document.getElementById('sidebar');
        const toggleBtn = document.querySelector('.navbar-toggler');

        if (window.innerWidth < 992 &&
            sidebar.classList.contains('show') &&
            !sidebar.contains(e.target) &&
            !toggleBtn?.contains(e.target)) {
            closeSidebar();
        }
    });

    // Handle window resize - Xử lý khi thay đổi kích thước màn hình
    window.addEventListener('resize', function() {
        if (window.innerWidth >= 992) {
            closeSidebar();
        }
    });

    // Load notification count - Tải số lượng thông báo
    function loadNotificationCount() {
        fetch('/api/notifications/count')
            .then(response => response.json())
            .then(data => {
                const badge = document.querySelector('.notification-count');
                if (data.count > 0) {
                    badge.textContent = data.count > 99 ? '99+' : data.count;
                    badge.style.display = 'inline-flex';
                } else {
                    badge.style.display = 'none';
                }
            })
            .catch(error => {
                console.log('Không thể tải số lượng thông báo:', error);
            });
    }

    // Initialize sidebar - Khởi tạo sidebar
    document.addEventListener('DOMContentLoaded', function() {
        // Load notification count
        loadNotificationCount();

        // Update notification count every 30 seconds
        setInterval(loadNotificationCount, 30000);

        // Auto-close sidebar on mobile after navigation
        const navItems = document.querySelectorAll('.nav-item');
        navItems.forEach(item => {
            item.addEventListener('click', function() {
                if (window.innerWidth < 992) {
                    setTimeout(closeSidebar, 300);
                }
            });
        });
    });
</script>