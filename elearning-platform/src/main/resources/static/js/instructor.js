/**
 * INSTRUCTOR.JS - JavaScript chính cho giao diện instructor
 * Xử lý các tương tác người dùng, AJAX calls, và dynamic content
 */

// Khởi tạo khi DOM ready
document.addEventListener('DOMContentLoaded', function() {
    // Khởi tạo tất cả components
    initializeSidebar();
    initializeDataTables();
    initializeTooltips();
    initializeModals();
    initializeFileUploads();
    initializeCharts();
    initializeFormValidation();
    initializeNotifications();

    console.log('✅ Instructor interface initialized');
});

/**
 * SIDEBAR MANAGEMENT
 * Quản lý sidebar collapse/expand và mobile menu
 */
function initializeSidebar() {
    const sidebar = document.getElementById('sidebar');
    const sidebarToggle = document.querySelector('.sidebar-toggle');
    const mainContent = document.querySelector('.main-content');

    // Toggle sidebar on mobile
    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', function() {
            sidebar.classList.toggle('show');
        });
    }

    // Đóng sidebar khi click outside trên mobile
    document.addEventListener('click', function(e) {
        if (window.innerWidth <= 992) {
            if (!sidebar.contains(e.target) && !sidebarToggle.contains(e.target)) {
                sidebar.classList.remove('show');
            }
        }
    });

    // Auto-close sidebar on window resize
    window.addEventListener('resize', function() {
        if (window.innerWidth > 992) {
            sidebar.classList.remove('show');
        }
    });
}

/**
 * DATATABLES INITIALIZATION
 * Khởi tạo DataTables cho các bảng dữ liệu
 */
function initializeDataTables() {
    // Kiểm tra xem DataTables có được load không
    if (typeof $.fn.dataTable === 'undefined') {
        console.warn('⚠️ DataTables không được load');
        return;
    }

    // Cấu hình DataTables cho các bảng
    const tableConfigs = {
        '#coursesTable': {
            order: [[4, 'desc']], // Sắp xếp theo ngày tạo
            columnDefs: [
                { orderable: false, targets: [0, -1] }, // Không sort cột checkbox và actions
                { searchable: false, targets: [0, -1] }
            ]
        },
        '#lessonsTable': {
            order: [[3, 'desc']], // Sắp xếp theo ngày tạo
            columnDefs: [
                { orderable: false, targets: [-1] } // Không sort cột actions
            ]
        },
        '#studentsTable': {
            order: [[2, 'desc']], // Sắp xếp theo ngày đăng ký
            columnDefs: [
                { orderable: false, targets: [-1] } // Không sort cột actions
            ]
        },
        '#quizzesTable': {
            order: [[3, 'desc']], // Sắp xếp theo ngày tạo
            columnDefs: [
                { orderable: false, targets: [-1] } // Không sort cột actions
            ]
        }
    };

    // Khởi tạo từng bảng
    Object.keys(tableConfigs).forEach(selector => {
        const table = document.querySelector(selector);
        if (table) {
            $(selector).DataTable({
                ...getDefaultDataTableConfig(),
                ...tableConfigs[selector]
            });
        }
    });
}

/**
 * Cấu hình mặc định cho DataTables
 */
function getDefaultDataTableConfig() {
    return {
        responsive: true,
        pageLength: 10,
        lengthMenu: [[10, 25, 50, 100], [10, 25, 50, 100]],
        language: {
            "sProcessing": "Đang xử lý...",
            "sLengthMenu": "Hiển thị _MENU_ mục",
            "sZeroRecords": "Không tìm thấy dữ liệu",
            "sInfo": "Hiển thị _START_ đến _END_ trong tổng số _TOTAL_ mục",
            "sInfoEmpty": "Hiển thị 0 đến 0 trong tổng số 0 mục",
            "sInfoFiltered": "(được lọc từ _MAX_ mục)",
            "sSearch": "Tìm kiếm:",
            "sUrl": "",
            "oPaginate": {
                "sFirst": "Đầu",
                "sPrevious": "Trước",
                "sNext": "Tiếp",
                "sLast": "Cuối"
            }
        },
        dom: '<"row"<"col-sm-12 col-md-6"l><"col-sm-12 col-md-6"f>>' +
            '<"row"<"col-sm-12"tr>>' +
            '<"row"<"col-sm-12 col-md-5"i><"col-sm-12 col-md-7"p>>',
        drawCallback: function() {
            // Reinitialize tooltips sau khi table redraw
            initializeTooltips();
        }
    };
}

/**
 * TOOLTIPS INITIALIZATION
 * Khởi tạo Bootstrap tooltips
 */
function initializeTooltips() {
    if (typeof bootstrap !== 'undefined') {
        // Dispose existing tooltips
        document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(el => {
            const existingTooltip = bootstrap.Tooltip.getInstance(el);
            if (existingTooltip) {
                existingTooltip.dispose();
            }
        });

        // Initialize new tooltips
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    }
}

/**
 * MODALS INITIALIZATION
 * Khởi tạo và xử lý Bootstrap modals
 */
function initializeModals() {
    // Confirmation modals
    const confirmButtons = document.querySelectorAll('[data-confirm]');
    confirmButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();

            const message = this.getAttribute('data-confirm');
            const action = this.getAttribute('href') || this.getAttribute('data-action');

            showConfirmModal(message, () => {
                if (this.tagName === 'A') {
                    window.location.href = action;
                } else if (this.tagName === 'BUTTON' && this.form) {
                    this.form.submit();
                }
            });
        });
    });

    // Delete confirmation specifically
    const deleteButtons = document.querySelectorAll('[data-delete]');
    deleteButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();

            const itemName = this.getAttribute('data-delete');
            const action = this.getAttribute('href') || this.getAttribute('data-action');

            showDeleteConfirmModal(itemName, () => {
                if (this.tagName === 'A') {
                    window.location.href = action;
                } else if (this.form) {
                    this.form.submit();
                }
            });
        });
    });
}

/**
 * FILE UPLOAD HANDLING
 * Xử lý drag & drop file uploads
 */
function initializeFileUploads() {
    const uploadAreas = document.querySelectorAll('.file-upload-area');

    uploadAreas.forEach(area => {
        const input = area.querySelector('input[type="file"]');
        if (!input) return;

        // Click to upload
        area.addEventListener('click', (e) => {
            if (e.target === area || area.contains(e.target)) {
                input.click();
            }
        });

        // Drag & drop handlers
        area.addEventListener('dragover', (e) => {
            e.preventDefault();
            area.classList.add('dragover');
        });

        area.addEventListener('dragleave', (e) => {
            e.preventDefault();
            area.classList.remove('dragover');
        });

        area.addEventListener('drop', (e) => {
            e.preventDefault();
            area.classList.remove('dragover');

            const files = e.dataTransfer.files;
            if (files.length > 0) {
                input.files = files;
                handleFileSelect(input, files[0]);
            }
        });

        // File input change
        input.addEventListener('change', (e) => {
            if (e.target.files.length > 0) {
                handleFileSelect(input, e.target.files[0]);
            }
        });
    });
}

/**
 * Xử lý file được chọn
 */
function handleFileSelect(input, file) {
    const area = input.closest('.file-upload-area');
    const preview = area.querySelector('.file-preview');

    // Validate file type
    const allowedTypes = input.getAttribute('accept');
    if (allowedTypes && !isFileTypeAllowed(file, allowedTypes)) {
        showNotification('error', 'Loại file không được hỗ trợ!');
        return;
    }

    // Validate file size (10MB default)
    const maxSize = parseInt(input.getAttribute('data-max-size')) || 10 * 1024 * 1024;
    if (file.size > maxSize) {
        showNotification('error', `File quá lớn! Kích thước tối đa: ${formatFileSize(maxSize)}`);
        return;
    }

    // Update UI
    const textEl = area.querySelector('.upload-text');
    const hintEl = area.querySelector('.upload-hint');

    if (textEl) textEl.textContent = file.name;
    if (hintEl) hintEl.textContent = formatFileSize(file.size);

    // Show preview for images
    if (file.type.startsWith('image/') && preview) {
        const reader = new FileReader();
        reader.onload = (e) => {
            preview.innerHTML = `<img src="${e.target.result}" alt="Preview" style="max-width: 100%; max-height: 200px;">`;
            preview.style.display = 'block';
        };
        reader.readAsDataURL(file);
    }

    showNotification('success', 'File đã được chọn thành công!');
}

/**
 * Kiểm tra loại file có được phép không
 */
function isFileTypeAllowed(file, allowedTypes) {
    const types = allowedTypes.split(',').map(type => type.trim());
    return types.some(type => {
        if (type.startsWith('.')) {
            return file.name.toLowerCase().endsWith(type.toLowerCase());
        } else {
            return file.type.match(type.replace('*', '.*'));
        }
    });
}

/**
 * Format file size
 */
function formatFileSize(bytes) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
}

/**
 * CHARTS INITIALIZATION
 * Khởi tạo charts cho analytics
 */
function initializeCharts() {
    // Kiểm tra Chart.js có được load không
    if (typeof Chart === 'undefined') {
        console.warn('⚠️ Chart.js không được load');
        return;
    }

    // Chart cho course analytics
    const courseChartCtx = document.getElementById('courseAnalyticsChart');
    if (courseChartCtx) {
        new Chart(courseChartCtx, {
            type: 'line',
            data: getCourseAnalyticsData(),
            options: getChartOptions('Thống kê khóa học')
        });
    }

    // Chart cho student enrollment
    const enrollmentChartCtx = document.getElementById('enrollmentChart');
    if (enrollmentChartCtx) {
        new Chart(enrollmentChartCtx, {
            type: 'bar',
            data: getEnrollmentData(),
            options: getChartOptions('Đăng ký theo tháng')
        });
    }

    // Pie chart cho course categories
    const categoryChartCtx = document.getElementById('categoryChart');
    if (categoryChartCtx) {
        new Chart(categoryChartCtx, {
            type: 'doughnut',
            data: getCategoryData(),
            options: getPieChartOptions('Phân bố danh mục')
        });
    }
}

/**
 * Lấy dữ liệu cho course analytics chart
 */
function getCourseAnalyticsData() {
    return {
        labels: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'],
        datasets: [{
            label: 'Khóa học mới',
            data: [12, 19, 8, 15, 25, 22, 30, 28, 35, 32, 38, 42],
            borderColor: '#667eea',
            backgroundColor: 'rgba(102, 126, 234, 0.1)',
            tension: 0.4
        }, {
            label: 'Học viên đăng ký',
            data: [85, 95, 78, 120, 135, 142, 158, 165, 175, 182, 195, 208],
            borderColor: '#764ba2',
            backgroundColor: 'rgba(118, 75, 162, 0.1)',
            tension: 0.4
        }]
    };
}

/**
 * Lấy dữ liệu enrollment
 */
function getEnrollmentData() {
    return {
        labels: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6'],
        datasets: [{
            label: 'Đăng ký mới',
            data: [65, 89, 75, 95, 108, 125],
            backgroundColor: '#667eea',
        }]
    };
}

/**
 * Lấy dữ liệu category
 */
function getCategoryData() {
    return {
        labels: ['Lập trình', 'Thiết kế', 'Marketing', 'Kinh doanh', 'Ngoại ngữ'],
        datasets: [{
            data: [35, 25, 20, 15, 5],
            backgroundColor: [
                '#667eea',
                '#764ba2',
                '#28a745',
                '#ffc107',
                '#dc3545'
            ]
        }]
    };
}

/**
 * Cấu hình chung cho charts
 */
function getChartOptions(title) {
    return {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            title: {
                display: true,
                text: title,
                font: {
                    size: 16,
                    weight: 'bold'
                }
            },
            legend: {
                display: true,
                position: 'bottom'
            }
        },
        scales: {
            y: {
                beginAtZero: true,
                grid: {
                    color: '#e9ecef'
                }
            },
            x: {
                grid: {
                    color: '#e9ecef'
                }
            }
        }
    };
}

/**
 * Cấu hình cho pie/doughnut charts
 */
function getPieChartOptions(title) {
    return {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            title: {
                display: true,
                text: title,
                font: {
                    size: 16,
                    weight: 'bold'
                }
            },
            legend: {
                display: true,
                position: 'bottom'
            }
        }
    };
}

/**
 * FORM VALIDATION
 * Xử lý validation cho forms
 */
function initializeFormValidation() {
    const forms = document.querySelectorAll('.needs-validation');

    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            if (!form.checkValidity()) {
                e.preventDefault();
                e.stopPropagation();

                // Focus vào field đầu tiên có lỗi
                const firstInvalidField = form.querySelector(':invalid');
                if (firstInvalidField) {
                    firstInvalidField.focus();
                }
            }

            form.classList.add('was-validated');
        }, false);

        // Real-time validation
        const inputs = form.querySelectorAll('input, textarea, select');
        inputs.forEach(input => {
            input.addEventListener('blur', function() {
                if (this.checkValidity()) {
                    this.classList.remove('is-invalid');
                    this.classList.add('is-valid');
                } else {
                    this.classList.remove('is-valid');
                    this.classList.add('is-invalid');
                }
            });
        });
    });
}

/**
 * NOTIFICATIONS SYSTEM
 * Hệ thống thông báo
 */
function initializeNotifications() {
    // Tự động ẩn alerts sau 5 giây
    const alerts = document.querySelectorAll('.alert:not(.alert-permanent)');
    alerts.forEach(alert => {
        setTimeout(() => {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });
}

/**
 * Hiển thị notification toast
 */
function showNotification(type, message, duration = 3000) {
    const toastContainer = getOrCreateToastContainer();

    const toast = document.createElement('div');
    toast.className = `toast align-items-center text-bg-${type} border-0`;
    toast.setAttribute('role', 'alert');
    toast.innerHTML = `
        <div class="d-flex">
            <div class="toast-body">
                <i class="fas fa-${getIconForType(type)} me-2"></i>
                ${message}
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    `;

    toastContainer.appendChild(toast);

    const bsToast = new bootstrap.Toast(toast, { delay: duration });
    bsToast.show();

    // Remove toast element sau khi ẩn
    toast.addEventListener('hidden.bs.toast', () => {
        toast.remove();
    });
}

/**
 * Lấy hoặc tạo toast container
 */
function getOrCreateToastContainer() {
    let container = document.getElementById('toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toast-container';
        container.className = 'toast-container position-fixed top-0 end-0 p-3';
        container.style.zIndex = '9999';
        document.body.appendChild(container);
    }
    return container;
}

/**
 * Lấy icon cho loại notification
 */
function getIconForType(type) {
    const icons = {
        'success': 'check-circle',
        'error': 'exclamation-circle',
        'warning': 'exclamation-triangle',
        'info': 'info-circle',
        'danger': 'times-circle'
    };
    return icons[type] || 'info-circle';
}

/**
 * MODAL HELPERS
 * Các helper functions cho modals
 */
function showConfirmModal(message, onConfirm) {
    const modal = createModal({
        title: 'Xác nhận',
        body: message,
        confirmText: 'Xác nhận',
        confirmClass: 'btn-primary',
        onConfirm: onConfirm
    });
    modal.show();
}

function showDeleteConfirmModal(itemName, onConfirm) {
    const modal = createModal({
        title: 'Xác nhận xóa',
        body: `Bạn có chắc chắn muốn xóa "${itemName}"? Hành động này không thể hoàn tác.`,
        confirmText: 'Xóa',
        confirmClass: 'btn-danger',
        onConfirm: onConfirm
    });
    modal.show();
}

/**
 * Tạo modal động
 */
function createModal({ title, body, confirmText = 'OK', confirmClass = 'btn-primary', onConfirm }) {
    const modalId = 'dynamic-modal-' + Date.now();
    const modalHTML = `
        <div class="modal fade" id="${modalId}" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">${title}</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        ${body}
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn ${confirmClass}" id="${modalId}-confirm">${confirmText}</button>
                    </div>
                </div>
            </div>
        </div>
    `;

    document.body.insertAdjacentHTML('beforeend', modalHTML);
    const modalElement = document.getElementById(modalId);
    const modal = new bootstrap.Modal(modalElement);

    // Handle confirm button
    const confirmBtn = document.getElementById(`${modalId}-confirm`);
    confirmBtn.addEventListener('click', () => {
        if (onConfirm) onConfirm();
        modal.hide();
    });

    // Remove modal element sau khi ẩn
    modalElement.addEventListener('hidden.bs.modal', () => {
        modalElement.remove();
    });

    return modal;
}

/**
 * AJAX HELPERS
 * Các helper functions cho AJAX requests
 */
function makeAjaxRequest(url, options = {}) {
    const defaultOptions = {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest'
        }
    };

    const config = { ...defaultOptions, ...options };

    return fetch(url, config)
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.json();
        })
        .catch(error => {
            console.error('AJAX Error:', error);
            showNotification('error', 'Có lỗi xảy ra khi gửi yêu cầu!');
            throw error;
        });
}

/**
 * UTILITY FUNCTIONS
 * Các hàm tiện ích
 */

// Format number với thousand separators
function formatNumber(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

// Format date theo định dạng Việt Nam
function formatDate(date) {
    if (!(date instanceof Date)) {
        date = new Date(date);
    }
    return date.toLocaleDateString('vi-VN');
}

// Truncate text với ellipsis
function truncateText(text, maxLength) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength) + '...';
}

// Debounce function
function debounce(func, delay) {
    let timeoutId;
    return function (...args) {
        clearTimeout(timeoutId);
        timeoutId = setTimeout(() => func.apply(this, args), delay);
    };
}

// Scroll to top
function scrollToTop() {
    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    });
}

/**
 * GLOBAL EVENT LISTENERS
 */

// Smooth scroll cho anchor links
document.addEventListener('click', function(e) {
    if (e.target.matches('a[href^="#"]')) {
        e.preventDefault();
        const target = document.querySelector(e.target.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    }
});

// Keyboard shortcuts
document.addEventListener('keydown', function(e) {
    // Ctrl/Cmd + S để save form
    if ((e.ctrlKey || e.metaKey) && e.key === 's') {
        e.preventDefault();
        const form = document.querySelector('form');
        if (form) {
            form.submit();
        }
    }

    // ESC để đóng modals
    if (e.key === 'Escape') {
        const openModal = document.querySelector('.modal.show');
        if (openModal) {
            const modal = bootstrap.Modal.getInstance(openModal);
            if (modal) modal.hide();
        }
    }
});

// Auto-save cho textareas lớn (localStorage)
const autoSaveTextareas = document.querySelectorAll('textarea[data-auto-save]');
autoSaveTextareas.forEach(textarea => {
    const key = `autosave_${textarea.id || 'textarea'}`;

    // Load saved content
    const saved = localStorage.getItem(key);
    if (saved && !textarea.value) {
        textarea.value = saved;
    }

    // Save on input với debounce
    const saveFunction = debounce(() => {
        localStorage.setItem(key, textarea.value);
    }, 1000);

    textarea.addEventListener('input', saveFunction);

    // Clear saved content khi submit
    const form = textarea.closest('form');
    if (form) {
        form.addEventListener('submit', () => {
            localStorage.removeItem(key);
        });
    }
});

// Console welcome message
console.log('%c🎓 EduLearn Instructor Dashboard', 'color: #667eea; font-size: 16px; font-weight: bold;');
console.log('%cChào mừng đến với giao diện giảng viên!', 'color: #764ba2; font-size: 12px;');