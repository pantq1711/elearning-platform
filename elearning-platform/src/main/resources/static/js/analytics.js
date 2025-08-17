/**
 * ANALYTICS.JS - JavaScript cho trang thống kê và báo cáo
 * Xử lý charts, data visualization và real-time updates
 */

// Global variables
let chartsInstances = {};
let realTimeInterval = null;
let currentDateRange = 'last30days';

document.addEventListener('DOMContentLoaded', function() {
    // Khởi tạo các components
    initializeCharts();
    initializeDateRangePicker();
    initializeRealTimeUpdates();
    initializeDataExport();
    initializeFilters();
    initializeTooltips();

    console.log('✅ Analytics page initialized');
});

/**
 * CHARTS INITIALIZATION
 * Khởi tạo tất cả charts với Chart.js
 */
function initializeCharts() {
    if (typeof Chart === 'undefined') {
        console.warn('⚠️ Chart.js không được load');
        return;
    }

    // Cấu hình Chart.js defaults
    Chart.defaults.font.family = 'Inter, sans-serif';
    Chart.defaults.font.size = 12;
    Chart.defaults.color = '#6c757d';
    Chart.defaults.plugins.legend.position = 'bottom';
    Chart.defaults.plugins.legend.labels.usePointStyle = true;
    Chart.defaults.plugins.legend.labels.padding = 20;

    // Initialize từng chart
    initializeOverviewCharts();
    initializeStudentAnalytics();
    initializeCourseAnalytics();
    initializeRevenueCharts();
    initializeEngagementCharts();
}

function initializeOverviewCharts() {
    // Student Enrollment Trend Chart
    const enrollmentCtx = document.getElementById('enrollmentTrendChart');
    if (enrollmentCtx) {
        chartsInstances.enrollment = new Chart(enrollmentCtx, {
            type: 'line',
            data: {
                labels: getLastNDays(30),
                datasets: [{
                    label: 'Đăng ký mới',
                    data: generateSampleData(30, 5, 25),
                    borderColor: '#667eea',
                    backgroundColor: 'rgba(102, 126, 234, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointRadius: 0,
                    pointHoverRadius: 6
                }, {
                    label: 'Đăng ký tích lũy',
                    data: generateCumulativeData(30, 5, 25),
                    borderColor: '#764ba2',
                    backgroundColor: 'rgba(118, 75, 162, 0.1)',
                    borderWidth: 3,
                    fill: false,
                    tension: 0.4,
                    pointRadius: 0,
                    pointHoverRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                interaction: {
                    intersect: false,
                    mode: 'index'
                },
                plugins: {
                    title: {
                        display: true,
                        text: 'Xu hướng đăng ký học viên',
                        font: { size: 16, weight: 'bold' }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        titleColor: '#fff',
                        bodyColor: '#fff',
                        borderColor: '#667eea',
                        borderWidth: 1
                    }
                },
                scales: {
                    x: {
                        grid: { display: false },
                        ticks: { maxTicksLimit: 10 }
                    },
                    y: {
                        beginAtZero: true,
                        grid: { color: 'rgba(0, 0, 0, 0.05)' }
                    }
                },
                elements: {
                    point: { hoverRadius: 8 }
                }
            }
        });
    }

    // Course Completion Rate Chart
    const completionCtx = document.getElementById('completionRateChart');
    if (completionCtx) {
        chartsInstances.completion = new Chart(completionCtx, {
            type: 'doughnut',
            data: {
                labels: ['Hoàn thành', 'Đang học', 'Chưa bắt đầu', 'Đã bỏ'],
                datasets: [{
                    data: [45, 30, 15, 10],
                    backgroundColor: [
                        '#28a745',
                        '#667eea',
                        '#ffc107',
                        '#dc3545'
                    ],
                    borderWidth: 0,
                    hoverOffset: 10
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '60%',
                plugins: {
                    title: {
                        display: true,
                        text: 'Tỷ lệ hoàn thành khóa học',
                        font: { size: 16, weight: 'bold' }
                    },
                    legend: {
                        position: 'right'
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return context.label + ': ' + context.parsed + '%';
                            }
                        }
                    }
                }
            }
        });
    }
}

function initializeStudentAnalytics() {
    // Student Activity Heatmap
    const activityCtx = document.getElementById('studentActivityChart');
    if (activityCtx) {
        chartsInstances.activity = new Chart(activityCtx, {
            type: 'bar',
            data: {
                labels: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
                datasets: [{
                    label: 'Sáng (6-12h)',
                    data: [120, 150, 180, 170, 160, 90, 70],
                    backgroundColor: 'rgba(102, 126, 234, 0.8)',
                    borderRadius: 4
                }, {
                    label: 'Chiều (12-18h)',
                    data: [200, 220, 250, 240, 230, 140, 120],
                    backgroundColor: 'rgba(118, 75, 162, 0.8)',
                    borderRadius: 4
                }, {
                    label: 'Tối (18-24h)',
                    data: [180, 190, 210, 200, 190, 160, 140],
                    backgroundColor: 'rgba(40, 167, 69, 0.8)',
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    title: {
                        display: true,
                        text: 'Hoạt động học viên theo thời gian',
                        font: { size: 16, weight: 'bold' }
                    }
                },
                scales: {
                    x: {
                        stacked: true,
                        grid: { display: false }
                    },
                    y: {
                        stacked: true,
                        beginAtZero: true
                    }
                },
                interaction: {
                    intersect: false
                }
            }
        });
    }

    // Student Demographics Chart
    const demographicsCtx = document.getElementById('demographicsChart');
    if (demographicsCtx) {
        chartsInstances.demographics = new Chart(demographicsCtx, {
            type: 'radar',
            data: {
                labels: ['18-25', '26-35', '36-45', '46-55', '55+'],
                datasets: [{
                    label: 'Học viên mới',
                    data: [85, 90, 70, 45, 25],
                    borderColor: '#667eea',
                    backgroundColor: 'rgba(102, 126, 234, 0.2)',
                    borderWidth: 2,
                    pointRadius: 4
                }, {
                    label: 'Học viên cũ',
                    data: [65, 80, 85, 60, 35],
                    borderColor: '#28a745',
                    backgroundColor: 'rgba(40, 167, 69, 0.2)',
                    borderWidth: 2,
                    pointRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    title: {
                        display: true,
                        text: 'Phân bố độ tuổi học viên',
                        font: { size: 16, weight: 'bold' }
                    }
                },
                scales: {
                    r: {
                        beginAtZero: true,
                        max: 100,
                        ticks: {
                            stepSize: 20
                        }
                    }
                }
            }
        });
    }
}

function initializeCourseAnalytics() {
    // Top Courses Chart
    const topCoursesCtx = document.getElementById('topCoursesChart');
    if (topCoursesCtx) {
        chartsInstances.topCourses = new Chart(topCoursesCtx, {
            type: 'horizontalBar',
            data: {
                labels: [
                    'JavaScript Cơ Bản',
                    'React.js Advanced',
                    'Node.js Backend',
                    'Python Machine Learning',
                    'Digital Marketing'
                ],
                datasets: [{
                    label: 'Số học viên',
                    data: [245, 198, 167, 142, 128],
                    backgroundColor: [
                        '#667eea',
                        '#764ba2',
                        '#28a745',
                        '#ffc107',
                        '#dc3545'
                    ],
                    borderRadius: 6,
                    borderSkipped: false
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    title: {
                        display: true,
                        text: 'Top 5 khóa học phổ biến',
                        font: { size: 16, weight: 'bold' }
                    },
                    legend: {
                        display: false
                    }
                },
                scales: {
                    x: {
                        beginAtZero: true,
                        grid: { color: 'rgba(0, 0, 0, 0.05)' }
                    },
                    y: {
                        grid: { display: false }
                    }
                }
            }
        });
    }

    // Course Categories Distribution
    const categoriesCtx = document.getElementById('courseCategoriesChart');
    if (categoriesCtx) {
        chartsInstances.categories = new Chart(categoriesCtx, {
            type: 'polarArea',
            data: {
                labels: ['Lập trình', 'Thiết kế', 'Marketing', 'Kinh doanh', 'Ngoại ngữ'],
                datasets: [{
                    data: [35, 25, 20, 15, 5],
                    backgroundColor: [
                        'rgba(102, 126, 234, 0.8)',
                        'rgba(118, 75, 162, 0.8)',
                        'rgba(40, 167, 69, 0.8)',
                        'rgba(255, 193, 7, 0.8)',
                        'rgba(220, 53, 69, 0.8)'
                    ],
                    borderColor: [
                        '#667eea',
                        '#764ba2',
                        '#28a745',
                        '#ffc107',
                        '#dc3545'
                    ],
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    title: {
                        display: true,
                        text: 'Phân bố danh mục khóa học',
                        font: { size: 16, weight: 'bold' }
                    }
                },
                scales: {
                    r: {
                        beginAtZero: true
                    }
                }
            }
        });
    }
}

function initializeRevenueCharts() {
    // Revenue Trend Chart
    const revenueCtx = document.getElementById('revenueTrendChart');
    if (revenueCtx) {
        chartsInstances.revenue = new Chart(revenueCtx, {
            type: 'line',
            data: {
                labels: getLastNMonths(12),
                datasets: [{
                    label: 'Doanh thu',
                    data: [45000, 52000, 48000, 58000, 65000, 70000, 68000, 75000, 82000, 78000, 85000, 92000],
                    borderColor: '#28a745',
                    backgroundColor: 'rgba(40, 167, 69, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointRadius: 5,
                    pointHoverRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    title: {
                        display: true,
                        text: 'Xu hướng doanh thu 12 tháng',
                        font: { size: 16, weight: 'bold' }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return 'Doanh thu: ' + formatCurrency(context.parsed.y);
                            }
                        }
                    }
                },
                scales: {
                    x: {
                        grid: { display: false }
                    },
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return formatCurrency(value);
                            }
                        }
                    }
                }
            }
        });
    }

    // Payment Methods Chart
    const paymentCtx = document.getElementById('paymentMethodsChart');
    if (paymentCtx) {
        chartsInstances.payment = new Chart(paymentCtx, {
            type: 'pie',
            data: {
                labels: ['Banking', 'MoMo', 'VNPay', 'Thẻ tín dụng', 'Khác'],
                datasets: [{
                    data: [40, 25, 20, 10, 5],
                    backgroundColor: [
                        '#667eea',
                        '#e91e63',
                        '#ff9800',
                        '#2196f3',
                        '#9c27b0'
                    ],
                    borderWidth: 2,
                    borderColor: '#fff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    title: {
                        display: true,
                        text: 'Phương thức thanh toán',
                        font: { size: 16, weight: 'bold' }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return context.label + ': ' + context.parsed + '%';
                            }
                        }
                    }
                }
            }
        });
    }
}

function initializeEngagementCharts() {
    // Lesson Completion Timeline
    const timelineCtx = document.getElementById('lessonTimelineChart');
    if (timelineCtx) {
        chartsInstances.timeline = new Chart(timelineCtx, {
            type: 'line',
            data: {
                labels: getLastNDays(7),
                datasets: [{
                    label: 'Video lessons',
                    data: [85, 92, 78, 95, 88, 91, 87],
                    borderColor: '#667eea',
                    backgroundColor: 'rgba(102, 126, 234, 0.1)',
                    borderWidth: 2,
                    tension: 0.4
                }, {
                    label: 'Text lessons',
                    data: [72, 78, 83, 76, 80, 85, 82],
                    borderColor: '#ffc107',
                    backgroundColor: 'rgba(255, 193, 7, 0.1)',
                    borderWidth: 2,
                    tension: 0.4
                }, {
                    label: 'Quiz attempts',
                    data: [65, 68, 71, 69, 74, 77, 75],
                    borderColor: '#dc3545',
                    backgroundColor: 'rgba(220, 53, 69, 0.1)',
                    borderWidth: 2,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    title: {
                        display: true,
                        text: 'Tương tác với nội dung (7 ngày)',
                        font: { size: 16, weight: 'bold' }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 100,
                        ticks: {
                            callback: function(value) {
                                return value + '%';
                            }
                        }
                    }
                }
            }
        });
    }
}

/**
 * DATE RANGE PICKER
 * Xử lý chọn khoảng thời gian
 */
function initializeDateRangePicker() {
    const dateRangeBtns = document.querySelectorAll('.date-range-btn');
    const customDateRange = document.getElementById('customDateRange');

    dateRangeBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            // Remove active class from all buttons
            dateRangeBtns.forEach(b => b.classList.remove('active'));

            // Add active class to clicked button
            this.classList.add('active');

            const range = this.getAttribute('data-range');
            currentDateRange = range;

            if (range === 'custom') {
                customDateRange.style.display = 'block';
            } else {
                customDateRange.style.display = 'none';
                updateChartsData(range);
            }
        });
    });

    // Custom date range inputs
    const startDate = document.getElementById('startDate');
    const endDate = document.getElementById('endDate');

    if (startDate && endDate) {
        [startDate, endDate].forEach(input => {
            input.addEventListener('change', function() {
                if (startDate.value && endDate.value) {
                    const start = new Date(startDate.value);
                    const end = new Date(endDate.value);

                    if (start <= end) {
                        updateChartsData('custom', start, end);
                    } else {
                        alert('Ngày bắt đầu phải nhỏ hơn ngày kết thúc');
                    }
                }
            });
        });
    }
}

function updateChartsData(range, startDate = null, endDate = null) {
    let labels, days;

    switch (range) {
        case 'today':
            labels = getHoursToday();
            days = 1;
            break;
        case 'yesterday':
            labels = getHoursYesterday();
            days = 1;
            break;
        case 'last7days':
            labels = getLastNDays(7);
            days = 7;
            break;
        case 'last30days':
            labels = getLastNDays(30);
            days = 30;
            break;
        case 'thismonth':
            labels = getDaysThisMonth();
            days = new Date().getDate();
            break;
        case 'lastmonth':
            labels = getDaysLastMonth();
            days = new Date(new Date().getFullYear(), new Date().getMonth(), 0).getDate();
            break;
        case 'custom':
            if (startDate && endDate) {
                labels = getDatesBetween(startDate, endDate);
                days = Math.ceil((endDate - startDate) / (1000 * 60 * 60 * 24));
            }
            break;
        default:
            labels = getLastNDays(30);
            days = 30;
    }

    // Update charts với data mới
    updateChartLabelsAndData(labels, days);

    // Show loading animation
    showChartsLoading();

    // Simulate API call
    setTimeout(() => {
        hideChartsLoading();
        showNotification('success', 'Dữ liệu đã được cập nhật');
    }, 1500);
}

function updateChartLabelsAndData(labels, days) {
    Object.keys(chartsInstances).forEach(key => {
        const chart = chartsInstances[key];
        if (chart && chart.data) {
            // Update labels
            chart.data.labels = labels;

            // Update data (generate new sample data)
            chart.data.datasets.forEach(dataset => {
                if (dataset.data) {
                    dataset.data = generateSampleData(days, 10, 100);
                }
            });

            chart.update('active');
        }
    });
}

/**
 * REAL-TIME UPDATES
 * Cập nhật dữ liệu real-time
 */
function initializeRealTimeUpdates() {
    const realTimeToggle = document.getElementById('realTimeToggle');

    if (realTimeToggle) {
        realTimeToggle.addEventListener('change', function() {
            if (this.checked) {
                startRealTimeUpdates();
                showNotification('info', 'Đã bật cập nhật thời gian thực');
            } else {
                stopRealTimeUpdates();
                showNotification('info', 'Đã tắt cập nhật thời gian thực');
            }
        });
    }
}

function startRealTimeUpdates() {
    realTimeInterval = setInterval(() => {
        updateRealTimeMetrics();
        updateChartsRealTime();
    }, 30000); // Cập nhật mỗi 30 giây
}

function stopRealTimeUpdates() {
    if (realTimeInterval) {
        clearInterval(realTimeInterval);
        realTimeInterval = null;
    }
}

function updateRealTimeMetrics() {
    // Cập nhật các metric số liệu
    const metrics = document.querySelectorAll('.stats-number');

    metrics.forEach(metric => {
        const currentValue = parseInt(metric.textContent.replace(/,/g, ''));
        const change = Math.floor(Math.random() * 10) - 5; // -5 to +5
        const newValue = Math.max(0, currentValue + change);

        // Animate number change
        animateNumberChange(metric, currentValue, newValue);
    });

    // Update last updated time
    const lastUpdated = document.getElementById('lastUpdated');
    if (lastUpdated) {
        lastUpdated.textContent = 'Cập nhật lần cuối: ' + new Date().toLocaleTimeString('vi-VN');
    }
}

function updateChartsRealTime() {
    Object.keys(chartsInstances).forEach(key => {
        const chart = chartsInstances[key];
        if (chart && chart.data && chart.data.datasets) {
            chart.data.datasets.forEach(dataset => {
                if (dataset.data && dataset.data.length > 0) {
                    // Add new data point và remove oldest
                    const newValue = Math.floor(Math.random() * 100);
                    dataset.data.push(newValue);
                    dataset.data.shift();
                }
            });

            chart.update('none');
        }
    });
}

/**
 * DATA EXPORT
 * Xuất dữ liệu analytics
 */
function initializeDataExport() {
    const exportBtns = document.querySelectorAll('.export-btn');

    exportBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            const format = this.getAttribute('data-format');
            const type = this.getAttribute('data-type') || 'all';

            exportData(format, type);
        });
    });
}

function exportData(format, type) {
    // Show loading
    showNotification('info', 'Đang chuẩn bị file xuất...');

    const data = collectAnalyticsData(type);

    switch (format) {
        case 'csv':
            exportToCSV(data, type);
            break;
        case 'excel':
            exportToExcel(data, type);
            break;
        case 'pdf':
            exportToPDF(data, type);
            break;
        case 'json':
            exportToJSON(data, type);
            break;
        default:
            console.error('Unsupported export format:', format);
    }
}

function collectAnalyticsData(type) {
    // Thu thập dữ liệu từ charts và tables
    const data = {
        timestamp: new Date().toISOString(),
        dateRange: currentDateRange,
        type: type,
        charts: {},
        metrics: {}
    };

    // Collect chart data
    Object.keys(chartsInstances).forEach(key => {
        const chart = chartsInstances[key];
        if (chart && chart.data) {
            data.charts[key] = {
                labels: chart.data.labels,
                datasets: chart.data.datasets.map(dataset => ({
                    label: dataset.label,
                    data: dataset.data
                }))
            };
        }
    });

    // Collect metrics
    const metrics = document.querySelectorAll('.stats-number');
    metrics.forEach((metric, index) => {
        const label = metric.closest('.stats-card')?.querySelector('.stats-label')?.textContent || `Metric ${index}`;
        data.metrics[label] = metric.textContent;
    });

    return data;
}

function exportToCSV(data, type) {
    let csv = 'Date,Metric,Value\n';

    // Add metrics data
    Object.keys(data.metrics).forEach(key => {
        csv += `${data.timestamp},${key},${data.metrics[key]}\n`;
    });

    // Add chart data
    Object.keys(data.charts).forEach(chartKey => {
        const chart = data.charts[chartKey];
        chart.datasets.forEach(dataset => {
            dataset.data.forEach((value, index) => {
                const label = chart.labels[index] || index;
                csv += `${label},${dataset.label},${value}\n`;
            });
        });
    });

    downloadFile(csv, `analytics_${type}_${getCurrentDateString()}.csv`, 'text/csv');
    showNotification('success', 'Đã xuất file CSV thành công');
}

function exportToJSON(data, type) {
    const json = JSON.stringify(data, null, 2);
    downloadFile(json, `analytics_${type}_${getCurrentDateString()}.json`, 'application/json');
    showNotification('success', 'Đã xuất file JSON thành công');
}

function downloadFile(content, filename, mimeType) {
    const blob = new Blob([content], { type: mimeType });
    const url = window.URL.createObjectURL(blob);

    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();

    window.URL.revokeObjectURL(url);
    document.body.removeChild(a);
}

/**
 * FILTERS
 * Bộ lọc dữ liệu
 */
function initializeFilters() {
    const filterBtns = document.querySelectorAll('.filter-btn');
    const courseFilter = document.getElementById('courseFilter');
    const categoryFilter = document.getElementById('categoryFilter');

    filterBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            const filterType = this.getAttribute('data-filter');
            applyFilter(filterType);
        });
    });

    if (courseFilter) {
        courseFilter.addEventListener('change', function() {
            applyFilter('course', this.value);
        });
    }

    if (categoryFilter) {
        categoryFilter.addEventListener('change', function() {
            applyFilter('category', this.value);
        });
    }
}

function applyFilter(type, value = null) {
    showChartsLoading();

    // Simulate API call với filter
    setTimeout(() => {
        // Update charts với filtered data
        updateChartsWithFilter(type, value);
        hideChartsLoading();

        const filterText = value ? `${type}: ${value}` : type;
        showNotification('success', `Đã áp dụng bộ lọc: ${filterText}`);
    }, 1000);
}

function updateChartsWithFilter(type, value) {
    // Cập nhật charts với dữ liệu đã lọc
    Object.keys(chartsInstances).forEach(key => {
        const chart = chartsInstances[key];
        if (chart && chart.data && chart.data.datasets) {
            chart.data.datasets.forEach(dataset => {
                // Generate new filtered data
                dataset.data = generateSampleData(dataset.data.length, 10, 100);
            });

            chart.update();
        }
    });
}

/**
 * UTILITY FUNCTIONS
 */

// Animation cho số liệu
function animateNumberChange(element, from, to) {
    const duration = 1000;
    const start = Date.now();

    function update() {
        const elapsed = Date.now() - start;
        const progress = Math.min(elapsed / duration, 1);

        const current = Math.floor(from + (to - from) * progress);
        element.textContent = formatNumber(current);

        if (progress < 1) {
            requestAnimationFrame(update);
        }
    }

    requestAnimationFrame(update);
}

// Loading states cho charts
function showChartsLoading() {
    const chartContainers = document.querySelectorAll('.chart-container');
    chartContainers.forEach(container => {
        container.style.opacity = '0.5';
        container.style.pointerEvents = 'none';
    });
}

function hideChartsLoading() {
    const chartContainers = document.querySelectorAll('.chart-container');
    chartContainers.forEach(container => {
        container.style.opacity = '1';
        container.style.pointerEvents = 'auto';
    });
}

// Tạo dữ liệu mẫu
function generateSampleData(length, min, max) {
    return Array.from({ length }, () => Math.floor(Math.random() * (max - min + 1)) + min);
}

function generateCumulativeData(length, min, max) {
    const data = generateSampleData(length, min, max);
    return data.reduce((acc, curr, index) => {
        acc[index] = (acc[index - 1] || 0) + curr;
        return acc;
    }, []);
}

// Date utility functions
function getLastNDays(n) {
    const dates = [];
    for (let i = n - 1; i >= 0; i--) {
        const date = new Date();
        date.setDate(date.getDate() - i);
        dates.push(date.toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit' }));
    }
    return dates;
}

function getLastNMonths(n) {
    const months = [];
    for (let i = n - 1; i >= 0; i--) {
        const date = new Date();
        date.setMonth(date.getMonth() - i);
        months.push(date.toLocaleDateString('vi-VN', { month: 'short', year: 'numeric' }));
    }
    return months;
}

function getHoursToday() {
    const hours = [];
    for (let i = 0; i < 24; i++) {
        hours.push(i.toString().padStart(2, '0') + ':00');
    }
    return hours;
}

function getCurrentDateString() {
    return new Date().toISOString().split('T')[0];
}

// Format functions
function formatNumber(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(amount);
}

// Tooltips initialization
function initializeTooltips() {
    if (typeof bootstrap !== 'undefined') {
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    }
}

// Notification function
function showNotification(type, message, duration = 3000) {
    if (typeof window.showNotification === 'function') {
        window.showNotification(type, message, duration);
    } else {
        console.log(`${type.toUpperCase()}: ${message}`);
    }
}

// Cleanup khi rời trang
window.addEventListener('beforeunload', function() {
    stopRealTimeUpdates();

    // Destroy all chart instances
    Object.keys(chartsInstances).forEach(key => {
        if (chartsInstances[key] && typeof chartsInstances[key].destroy === 'function') {
            chartsInstances[key].destroy();
        }
    });
});

// Keyboard shortcuts
document.addEventListener('keydown', function(e) {
    // Ctrl/Cmd + E để export
    if ((e.ctrlKey || e.metaKey) && e.key === 'e') {
        e.preventDefault();
        exportData('csv', 'all');
    }

    // Ctrl/Cmd + R để refresh charts
    if ((e.ctrlKey || e.metaKey) && e.key === 'r') {
        e.preventDefault();
        updateChartsData(currentDateRange);
    }

    // F để toggle fullscreen cho chart container
    if (e.key === 'f' || e.key === 'F') {
        const focusedChart = document.querySelector('.chart-container:hover');
        if (focusedChart) {
            toggleChartFullscreen(focusedChart);
        }
    }
});

function toggleChartFullscreen(container) {
    if (container.classList.contains('fullscreen')) {
        container.classList.remove('fullscreen');
        document.body.style.overflow = 'auto';
    } else {
        container.classList.add('fullscreen');
        document.body.style.overflow = 'hidden';
    }
}

// Console welcome message
console.log('%c📊 EduLearn Analytics Dashboard', 'color: #667eea; font-size: 16px; font-weight: bold;');
console.log('%cReal-time analytics và data visualization', 'color: #764ba2; font-size: 12px;');