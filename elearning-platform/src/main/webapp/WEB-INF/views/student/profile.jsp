<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ Cá Nhân - EduLearn Platform</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/student.css" rel="stylesheet">
</head>

<body>
<!-- Include Header -->
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <!-- Include Sidebar -->
        <div class="col-md-3 col-lg-2">
            <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
        </div>

        <!-- Main Content -->
        <div class="col-md-9 col-lg-10">
            <div class="main-content p-4">

                <!-- Page Header -->
                <div class="page-header mb-4">
                    <h2><i class="fas fa-user-circle me-2"></i>Hồ Sơ Cá Nhân</h2>
                    <p class="text-muted">Quản lý thông tin cá nhân và theo dõi tiến độ học tập</p>
                </div>

                <!-- Profile Content -->
                <div class="row">
                    <!-- Left Column - Profile Info -->
                    <div class="col-lg-4 mb-4">
                        <!-- Profile Card -->
                        <div class="card profile-card">
                            <div class="card-body text-center">
                                <!-- Avatar -->
                                <div class="avatar-container mb-3">
                                    <c:choose>
                                        <c:when test="${currentUser.avatarPath != null}">
                                            <img src="${pageContext.request.contextPath}/images/avatars/${currentUser.avatarPath}"
                                                 alt="${currentUser.fullName}" class="profile-avatar" id="profileAvatar">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="avatar-placeholder" id="profileAvatar">
                                                <i class="fas fa-user"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- Upload Button -->
                                    <label for="avatarUpload" class="avatar-upload-btn">
                                        <i class="fas fa-camera"></i>
                                        <input type="file" id="avatarUpload" accept="image/*" onchange="uploadAvatar(this)" style="display: none;">
                                    </label>
                                </div>

                                <!-- User Info -->
                                <h4 class="profile-name">${currentUser.fullName}</h4>
                                <p class="profile-email text-muted">${currentUser.email}</p>
                                <span class="badge bg-primary profile-role">
                                    <i class="fas fa-user-graduate me-1"></i>Học viên
                                </span>

                                <!-- Stats -->
                                <div class="profile-stats mt-4">
                                    <div class="row text-center">
                                        <div class="col-4">
                                            <div class="stat-item">
                                                <h5 class="stat-number">${enrolledCourses}</h5>
                                                <small class="stat-label">Khóa học</small>
                                            </div>
                                        </div>
                                        <div class="col-4">
                                            <div class="stat-item">
                                                <h5 class="stat-number">${completedCourses}</h5>
                                                <small class="stat-label">Hoàn thành</small>
                                            </div>
                                        </div>
                                        <div class="col-4">
                                            <div class="stat-item">
                                                <h5 class="stat-number">${totalStudyHours}</h5>
                                                <small class="stat-label">Giờ học</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Quick Actions -->
                        <div class="card mt-4">
                            <div class="card-header">
                                <h6 class="mb-0"><i class="fas fa-bolt me-2"></i>Hành động nhanh</h6>
                            </div>
                            <div class="card-body">
                                <div class="d-grid gap-2">
                                    <a href="${pageContext.request.contextPath}/student/courses" class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-book me-2"></i>Khóa học của tôi
                                    </a>
                                    <a href="${pageContext.request.contextPath}/student/certificates" class="btn btn-outline-success btn-sm">
                                        <i class="fas fa-certificate me-2"></i>Chứng chỉ
                                    </a>
                                    <button type="button" class="btn btn-outline-warning btn-sm" data-bs-toggle="modal" data-bs-target="#changePasswordModal">
                                        <i class="fas fa-key me-2"></i>Đổi mật khẩu
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Right Column - Details & Progress -->
                    <div class="col-lg-8">

                        <!-- Personal Information -->
                        <div class="card mb-4">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h6 class="mb-0"><i class="fas fa-user me-2"></i>Thông tin cá nhân</h6>
                                <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                                    <i class="fas fa-edit"></i> Chỉnh sửa
                                </button>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="info-item mb-3">
                                            <label class="info-label">Họ và tên:</label>
                                            <p class="info-value">${currentUser.fullName}</p>
                                        </div>
                                        <div class="info-item mb-3">
                                            <label class="info-label">Email:</label>
                                            <p class="info-value">${currentUser.email}</p>
                                        </div>
                                        <div class="info-item mb-3">
                                            <label class="info-label">Số điện thoại:</label>
                                            <p class="info-value">${currentUser.phoneNumber != null ? currentUser.phoneNumber : 'Chưa cập nhật'}</p>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="info-item mb-3">
                                            <label class="info-label">Ngày sinh:</label>
                                            <p class="info-value">
                                                <c:choose>
                                                    <c:when test="${currentUser.dateOfBirth != null}">
                                                        <fmt:formatDate value="${currentUser.dateOfBirth}" pattern="dd/MM/yyyy"/>
                                                    </c:when>
                                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                                </c:choose>
                                            </p>
                                        </div>
                                        <div class="info-item mb-3">
                                            <label class="info-label">Địa chỉ:</label>
                                            <p class="info-value">${currentUser.address != null ? currentUser.address : 'Chưa cập nhật'}</p>
                                        </div>
                                        <div class="info-item mb-3">
                                            <label class="info-label">Ngày tham gia:</label>
                                            <p class="info-value">
                                                <fmt:formatDate value="${currentUser.createdAt}" pattern="dd/MM/yyyy"/>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Learning Progress Chart -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <h6 class="mb-0"><i class="fas fa-chart-line me-2"></i>Tiến độ học tập tuần này</h6>
                            </div>
                            <div class="card-body">
                                <div style="height: 300px;">
                                    <canvas id="progressChart"></canvas>
                                </div>
                            </div>
                        </div>

                        <!-- Course Progress -->
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h6 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Tiến độ khóa học</h6>

                                <!-- Filter -->
                                <div class="btn-group btn-group-sm" role="group">
                                    <input type="radio" class="btn-check" name="courseFilter" id="allCourses" checked>
                                    <label class="btn btn-outline-primary" for="allCourses">Tất cả</label>

                                    <input type="radio" class="btn-check" name="courseFilter" id="inProgress">
                                    <label class="btn btn-outline-primary" for="inProgress">Đang học</label>

                                    <input type="radio" class="btn-check" name="courseFilter" id="completed">
                                    <label class="btn btn-outline-primary" for="completed">Hoàn thành</label>
                                </div>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${not empty enrollments}">
                                        <c:forEach items="${enrollments}" var="enrollment">
                                            <div class="course-progress-item mb-3" data-status="${enrollment.progress >= 100 ? 'completed' : 'in-progress'}">
                                                <div class="d-flex align-items-center">
                                                    <div class="course-thumbnail me-3">
                                                        <c:choose>
                                                            <c:when test="${enrollment.course.thumbnailPath != null}">
                                                                <img src="${pageContext.request.contextPath}/images/courses/${enrollment.course.thumbnailPath}"
                                                                     alt="${enrollment.course.name}" class="course-thumb">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="course-thumb-placeholder">
                                                                    <i class="fas fa-play"></i>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>

                                                    <div class="flex-grow-1">
                                                        <h6 class="course-title mb-1">
                                                            <a href="${pageContext.request.contextPath}/courses/${enrollment.course.id}/learn">
                                                                    ${enrollment.course.name}
                                                            </a>
                                                        </h6>
                                                        <p class="course-instructor text-muted mb-2">
                                                            <i class="fas fa-chalkboard-teacher me-1"></i>
                                                                ${enrollment.course.instructor.fullName}
                                                        </p>

                                                        <!-- Progress Bar -->
                                                        <div class="progress mb-2" style="height: 8px;">
                                                            <div class="progress-bar bg-primary"
                                                                 style="width: ${enrollment.progress}%"></div>
                                                        </div>

                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <small class="text-muted">
                                                                <fmt:formatNumber value="${enrollment.progress}" maxFractionDigits="1"/>% hoàn thành
                                                            </small>
                                                            <c:if test="${enrollment.progress >= 100}">
                                                                <span class="badge bg-success">
                                                                    <i class="fas fa-check me-1"></i>Hoàn thành
                                                                </span>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-4">
                                            <i class="fas fa-graduation-cap fa-3x text-muted mb-3"></i>
                                            <h6 class="text-muted">Chưa đăng ký khóa học nào</h6>
                                            <p class="text-muted">Hãy khám phá và đăng ký khóa học đầu tiên của bạn!</p>
                                            <a href="${pageContext.request.contextPath}/courses" class="btn btn-primary">
                                                <i class="fas fa-search me-2"></i>Tìm khóa học
                                            </a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Edit Profile Modal -->
<div class="modal fade" id="editProfileModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="editProfileForm" method="POST" action="${pageContext.request.contextPath}/student/profile/update">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-edit me-2"></i>Chỉnh sửa thông tin
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="fullName" class="form-label">Họ và tên *</label>
                                <input type="text" class="form-control" id="fullName" name="fullName"
                                       value="${currentUser.fullName}" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="phoneNumber" class="form-label">Số điện thoại</label>
                                <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber"
                                       value="${currentUser.phoneNumber}">
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="dateOfBirth" class="form-label">Ngày sinh</label>
                        <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth"
                               value="<fmt:formatDate value='${currentUser.dateOfBirth}' pattern='yyyy-MM-dd'/>">
                    </div>

                    <div class="mb-3">
                        <label for="address" class="form-label">Địa chỉ</label>
                        <textarea class="form-control" id="address" name="address" rows="3">${currentUser.address}</textarea>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i>Lưu thay đổi
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Change Password Modal -->
<div class="modal fade" id="changePasswordModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="changePasswordForm" method="POST" action="${pageContext.request.contextPath}/student/profile/change-password">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-key me-2"></i>Đổi mật khẩu
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <div class="mb-3">
                        <label for="currentPassword" class="form-label">Mật khẩu hiện tại *</label>
                        <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                    </div>

                    <div class="mb-3">
                        <label for="newPassword" class="form-label">Mật khẩu mới *</label>
                        <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                        <div class="form-text">Tối thiểu 8 ký tự, bao gồm chữ hoa, chữ thường và số</div>
                    </div>

                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Xác nhận mật khẩu mới *</label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-warning">
                        <i class="fas fa-key me-2"></i>Đổi mật khẩu
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Include Footer -->
<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>

<script>
    $(document).ready(function() {
        // Initialize progress chart
        initProgressChart();

        // Setup course filter
        setupCourseFilter();

        // Setup form validation
        setupFormValidation();

        // Setup change password form
        setupChangePasswordForm();
    });

    /**
     * Khởi tạo biểu đồ tiến độ
     */
    function initProgressChart() {
        const ctx = document.getElementById('progressChart');
        if (!ctx) return;

        // Dữ liệu mẫu - thực tế sẽ lấy từ server
        const data = {
            labels: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
            datasets: [{
                label: 'Thời gian học (phút)',
                data: [${weeklyProgress}], // Từ server
                borderColor: '#0d6efd',
                backgroundColor: 'rgba(13, 110, 253, 0.1)',
                tension: 0.4,
                fill: true
            }]
        };

        new Chart(ctx, {
            type: 'line',
            data: data,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return value + 'p';
                            }
                        }
                    }
                }
            }
        });
    }

    /**
     * Setup course filter
     */
    function setupCourseFilter() {
        $('input[name="courseFilter"]').change(function() {
            const filter = $(this).attr('id');

            $('.course-progress-item').show();

            if (filter === 'inProgress') {
                $('.course-progress-item[data-status="completed"]').hide();
            } else if (filter === 'completed') {
                $('.course-progress-item[data-status="in-progress"]').hide();
            }
        });
    }

    /**
     * Upload avatar
     */
    function uploadAvatar(input) {
        if (input.files && input.files[0]) {
            const file = input.files[0];

            // Validate file type
            if (!file.type.match('image.*')) {
                alert('Vui lòng chọn file hình ảnh!');
                return;
            }

            // Validate file size (max 5MB)
            if (file.size > 5 * 1024 * 1024) {
                alert('Kích thước file không được vượt quá 5MB!');
                return;
            }

            // Show preview
            const reader = new FileReader();
            reader.onload = function(e) {
                $('#profileAvatar').attr('src', e.target.result);
            };
            reader.readAsDataURL(file);

            // Upload file
            const formData = new FormData();
            formData.append('avatar', file);
            formData.append('${_csrf.parameterName}', '${_csrf.token}');

            $.ajax({
                url: '${pageContext.request.contextPath}/student/profile/upload-avatar',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function(response) {
                    if (response.success) {
                        // Update avatar in header if exists
                        $('.navbar .avatar-img').attr('src', response.avatarUrl);

                        // Show success message
                        showNotification('Avatar đã được cập nhật thành công!', 'success');
                    } else {
                        showNotification('Có lỗi xảy ra khi upload avatar: ' + response.message, 'error');
                    }
                },
                error: function() {
                    showNotification('Có lỗi xảy ra khi upload avatar!', 'error');
                }
            });
        }
    }

    /**
     * Setup form validation
     */
    function setupFormValidation() {
        $('#editProfileForm').on('submit', function(e) {
            const fullName = $('#fullName').val().trim();

            if (fullName.length < 2) {
                e.preventDefault();
                showNotification('Họ tên phải có ít nhất 2 ký tự!', 'error');
                return false;
            }
        });
    }

    /**
     * Setup change password form
     */
    function setupChangePasswordForm() {
        $('#changePasswordForm').on('submit', function(e) {
            const currentPassword = $('#currentPassword').val();
            const newPassword = $('#newPassword').val();
            const confirmPassword = $('#confirmPassword').val();

            // Validate password strength
            const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$/;

            if (!passwordRegex.test(newPassword)) {
                e.preventDefault();
                showNotification('Mật khẩu mới phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số!', 'error');
                return false;
            }

            if (newPassword !== confirmPassword) {
                e.preventDefault();
                showNotification('Mật khẩu xác nhận không khớp!', 'error');
                return false;
            }

            if (currentPassword === newPassword) {
                e.preventDefault();
                showNotification('Mật khẩu mới phải khác mật khẩu hiện tại!', 'error');
                return false;
            }
        });
    }

    /**
     * Show notification
     */
    function showNotification(message, type) {
        // Implementation for notification system
        const alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
        const alert = `<div class="alert ${alertClass} alert-dismissible fade show" role="alert">
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>`;

        // Show at top of page
        $('body').prepend(alert);

        // Auto dismiss after 5 seconds
        setTimeout(function() {
            $('.alert').alert('close');
        }, 5000);
    }
</script>

</body>
</html>