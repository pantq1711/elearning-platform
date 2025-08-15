<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!--
Pagination Component
Component phân trang có thể tái sử dụng cho toàn bộ ứng dụng

Parameters cần truyền vào:
- page: Trang hiện tại (bắt đầu từ 0)
- totalPages: Tổng số trang
- size: Số lượng item trên mỗi trang
- totalElements: Tổng số phần tử
- baseUrl: URL cơ sở để tạo các link phân trang
- additionalParams: Các tham số bổ sung (search, filter, etc.)
-->

<c:if test="${totalPages > 1}">
    <!-- Pagination Container -->
    <div class="pagination-container">
        <!-- Pagination Info -->
        <div class="pagination-info">
            <span class="pagination-text">
                Hiển thị
                <strong>${(page * size) + 1}</strong> -
                <strong>${((page + 1) * size > totalElements) ? totalElements : ((page + 1) * size)}</strong>
                trong tổng số
                <strong>${totalElements}</strong> kết quả
            </span>
        </div>

        <!-- Pagination Navigation -->
        <nav aria-label="Điều hướng trang">
            <ul class="pagination pagination-custom">
                <!-- First Page Button -->
                <c:if test="${page > 0}">
                    <li class="page-item">
                        <a class="page-link"
                           href="${baseUrl}?page=0&size=${size}${not empty additionalParams ? '&' : ''}${additionalParams}"
                           title="Trang đầu">
                            <i class="fas fa-angle-double-left"></i>
                        </a>
                    </li>
                </c:if>

                <!-- Previous Page Button -->
                <c:if test="${page > 0}">
                    <li class="page-item">
                        <a class="page-link"
                           href="${baseUrl}?page=${page - 1}&size=${size}${not empty additionalParams ? '&' : ''}${additionalParams}"
                           title="Trang trước">
                            <i class="fas fa-angle-left"></i>
                            <span class="d-none d-sm-inline ms-1">Trước</span>
                        </a>
                    </li>
                </c:if>
                <c:if test="${page == 0}">
                    <li class="page-item disabled">
                        <span class="page-link">
                            <i class="fas fa-angle-left"></i>
                            <span class="d-none d-sm-inline ms-1">Trước</span>
                        </span>
                    </li>
                </c:if>

                <!-- Page Numbers -->
                <c:set var="startPage" value="${page - 2 < 0 ? 0 : page - 2}"/>
                <c:set var="endPage" value="${page + 2 >= totalPages ? totalPages - 1 : page + 2}"/>

                <!-- Show first page if not in range -->
                <c:if test="${startPage > 0}">
                    <li class="page-item">
                        <a class="page-link"
                           href="${baseUrl}?page=0&size=${size}${not empty additionalParams ? '&' : ''}${additionalParams}">
                            1
                        </a>
                    </li>
                    <c:if test="${startPage > 1}">
                        <li class="page-item disabled">
                            <span class="page-link">...</span>
                        </li>
                    </c:if>
                </c:if>

                <!-- Main page numbers -->
                <c:forEach var="pageNum" begin="${startPage}" end="${endPage}">
                    <c:choose>
                        <c:when test="${pageNum == page}">
                            <li class="page-item active" aria-current="page">
                                <span class="page-link">
                                    ${pageNum + 1}
                                    <span class="sr-only">(hiện tại)</span>
                                </span>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="page-item">
                                <a class="page-link"
                                   href="${baseUrl}?page=${pageNum}&size=${size}${not empty additionalParams ? '&' : ''}${additionalParams}">
                                        ${pageNum + 1}
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <!-- Show last page if not in range -->
                <c:if test="${endPage < totalPages - 1}">
                    <c:if test="${endPage < totalPages - 2}">
                        <li class="page-item disabled">
                            <span class="page-link">...</span>
                        </li>
                    </c:if>
                    <li class="page-item">
                        <a class="page-link"
                           href="${baseUrl}?page=${totalPages - 1}&size=${size}${not empty additionalParams ? '&' : ''}${additionalParams}">
                                ${totalPages}
                        </a>
                    </li>
                </c:if>

                <!-- Next Page Button -->
                <c:if test="${page < totalPages - 1}">
                    <li class="page-item">
                        <a class="page-link"
                           href="${baseUrl}?page=${page + 1}&size=${size}${not empty additionalParams ? '&' : ''}${additionalParams}"
                           title="Trang tiếp">
                            <span class="d-none d-sm-inline me-1">Tiếp</span>
                            <i class="fas fa-angle-right"></i>
                        </a>
                    </li>
                </c:if>
                <c:if test="${page >= totalPages - 1}">
                    <li class="page-item disabled">
                        <span class="page-link">
                            <span class="d-none d-sm-inline me-1">Tiếp</span>
                            <i class="fas fa-angle-right"></i>
                        </span>
                    </li>
                </c:if>

                <!-- Last Page Button -->
                <c:if test="${page < totalPages - 1}">
                    <li class="page-item">
                        <a class="page-link"
                           href="${baseUrl}?page=${totalPages - 1}&size=${size}${not empty additionalParams ? '&' : ''}${additionalParams}"
                           title="Trang cuối">
                            <i class="fas fa-angle-double-right"></i>
                        </a>
                    </li>
                </c:if>
            </ul>
        </nav>

        <!-- Page Size Selector -->
        <div class="page-size-selector">
            <label for="pageSize" class="form-label">Hiển thị:</label>
            <select class="form-select form-select-sm" id="pageSize" onchange="changePageSize(this.value)">
                <option value="10" ${size == 10 ? 'selected' : ''}>10</option>
                <option value="20" ${size == 20 ? 'selected' : ''}>20</option>
                <option value="50" ${size == 50 ? 'selected' : ''}>50</option>
                <option value="100" ${size == 100 ? 'selected' : ''}>100</option>
            </select>
            <span class="form-text">/ trang</span>
        </div>
    </div>

    <!-- Mobile Pagination (Simpler version for small screens) -->
    <div class="mobile-pagination d-block d-md-none">
        <div class="row align-items-center">
            <div class="col-6">
                <c:if test="${page > 0}">
                    <a class="btn btn-outline-primary btn-sm w-100"
                       href="${baseUrl}?page=${page - 1}&size=${size}${not empty additionalParams ? '&' : ''}${additionalParams}">
                        <i class="fas fa-angle-left me-1"></i>Trước
                    </a>
                </c:if>
                <c:if test="${page == 0}">
                    <button class="btn btn-outline-secondary btn-sm w-100" disabled>
                        <i class="fas fa-angle-left me-1"></i>Trước
                    </button>
                </c:if>
            </div>
            <div class="col-6">
                <c:if test="${page < totalPages - 1}">
                    <a class="btn btn-outline-primary btn-sm w-100"
                       href="${baseUrl}?page=${page + 1}&size=${size}${not empty additionalParams ? '&' : ''}${additionalParams}">
                        Tiếp<i class="fas fa-angle-right ms-1"></i>
                    </a>
                </c:if>
                <c:if test="${page >= totalPages - 1}">
                    <button class="btn btn-outline-secondary btn-sm w-100" disabled>
                        Tiếp<i class="fas fa-angle-right ms-1"></i>
                    </button>
                </c:if>
            </div>
        </div>
        <div class="text-center mt-2">
            <small class="text-muted">
                Trang ${page + 1} / ${totalPages}
                (${totalElements} kết quả)
            </small>
        </div>
    </div>
</c:if>

<!-- CSS Styles cho Pagination -->
<style>
    :root {
        --primary-color: #4f46e5;
        --primary-dark: #3730a3;
        --border-color: #e5e7eb;
        --text-primary: #1f2937;
        --text-secondary: #6b7280;
        --light-bg: #f8fafc;
    }

    /* Pagination Container */
    .pagination-container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 1rem;
        margin: 2rem 0;
        padding: 1.5rem;
        background: white;
        border-radius: 0.75rem;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        border: 1px solid var(--border-color);
    }

    .pagination-info {
        flex: 1;
        min-width: 200px;
    }

    .pagination-text {
        color: var(--text-secondary);
        font-size: 0.9rem;
    }

    .pagination-text strong {
        color: var(--text-primary);
        font-weight: 600;
    }

    /* Custom Pagination Styles */
    .pagination-custom {
        margin: 0;
        flex-wrap: wrap;
    }

    .pagination-custom .page-item {
        margin: 0 0.1rem;
    }

    .pagination-custom .page-link {
        border: 1px solid var(--border-color);
        color: var(--text-secondary);
        padding: 0.5rem 0.75rem;
        border-radius: 0.5rem;
        font-weight: 500;
        transition: all 0.3s ease;
        text-decoration: none;
        display: flex;
        align-items: center;
        min-width: 40px;
        justify-content: center;
    }

    .pagination-custom .page-link:hover {
        background-color: var(--light-bg);
        border-color: var(--primary-color);
        color: var(--primary-color);
        transform: translateY(-1px);
    }

    .pagination-custom .page-item.active .page-link {
        background-color: var(--primary-color);
        border-color: var(--primary-color);
        color: white;
        font-weight: 600;
        box-shadow: 0 4px 12px -4px var(--primary-color);
    }

    .pagination-custom .page-item.disabled .page-link {
        color: #c9cccf;
        background-color: white;
        border-color: var(--border-color);
        cursor: not-allowed;
    }

    .pagination-custom .page-item.disabled .page-link:hover {
        transform: none;
    }

    /* Page Size Selector */
    .page-size-selector {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        min-width: 150px;
    }

    .page-size-selector .form-label {
        margin: 0;
        font-size: 0.9rem;
        color: var(--text-secondary);
        white-space: nowrap;
    }

    .page-size-selector .form-select {
        width: auto;
        min-width: 70px;
        border: 1px solid var(--border-color);
        border-radius: 0.5rem;
        font-size: 0.9rem;
    }

    .page-size-selector .form-select:focus {
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
    }

    .page-size-selector .form-text {
        color: var(--text-secondary);
        font-size: 0.85rem;
        margin: 0;
        white-space: nowrap;
    }

    /* Mobile Pagination */
    .mobile-pagination {
        margin: 1rem 0;
        padding: 1rem;
        background: white;
        border-radius: 0.75rem;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        border: 1px solid var(--border-color);
    }

    /* Hide desktop pagination on mobile */
    @media (max-width: 767.98px) {
        .pagination-container {
            display: none;
        }
    }

    /* Hide mobile pagination on desktop */
    @media (min-width: 768px) {
        .mobile-pagination {
            display: none !important;
        }
    }

    /* Responsive adjustments */
    @media (max-width: 991.98px) {
        .pagination-container {
            flex-direction: column;
            align-items: stretch;
            text-align: center;
        }

        .pagination-info {
            order: 3;
            margin-top: 1rem;
        }

        .pagination-custom {
            order: 1;
            justify-content: center;
        }

        .page-size-selector {
            order: 2;
            justify-content: center;
            margin-top: 1rem;
        }
    }

    @media (max-width: 575.98px) {
        .pagination-custom .page-link {
            padding: 0.375rem 0.5rem;
            font-size: 0.85rem;
            min-width: 35px;
        }

        .pagination-custom .page-item {
            margin: 0 0.05rem;
        }

        /* Hide text on very small screens, keep only icons */
        .pagination-custom .d-none {
            display: none !important;
        }
    }

    /* Loading state */
    .pagination-loading {
        opacity: 0.6;
        pointer-events: none;
    }

    .pagination-loading::after {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        width: 20px;
        height: 20px;
        margin: -10px 0 0 -10px;
        border: 2px solid var(--primary-color);
        border-radius: 50%;
        border-right-color: transparent;
        animation: pagination-spin 1s linear infinite;
    }

    @keyframes pagination-spin {
        0% {
            transform: rotate(0deg);
        }
        100% {
            transform: rotate(360deg);
        }
    }

    /* Accessibility improvements */
    .sr-only {
        position: absolute;
        width: 1px;
        height: 1px;
        padding: 0;
        margin: -1px;
        overflow: hidden;
        clip: rect(0, 0, 0, 0);
        white-space: nowrap;
        border: 0;
    }

    /* Hover effects for better UX */
    .pagination-custom .page-link {
        position: relative;
        overflow: hidden;
    }

    .pagination-custom .page-link::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(79, 70, 229, 0.1), transparent);
        transition: left 0.5s;
    }

    .pagination-custom .page-link:hover::before {
        left: 100%;
    }

    /* Focus styles for accessibility */
    .pagination-custom .page-link:focus {
        outline: 2px solid var(--primary-color);
        outline-offset: 2px;
        z-index: 2;
    }

    /* Print styles */
    @media print {
        .pagination-container,
        .mobile-pagination {
            display: none;
        }
    }
</style>

<!-- JavaScript cho Pagination -->
<script>
    // Change page size - Thay đổi số lượng item trên trang
    function changePageSize(newSize) {
        const currentUrl = new URL(window.location);
        currentUrl.searchParams.set('size', newSize);
        currentUrl.searchParams.set('page', 0); // Reset về trang đầu khi thay đổi size
        window.location.href = currentUrl.toString();
    }

    // Add loading state to pagination links - Thêm trạng thái loading
    document.addEventListener('DOMContentLoaded', function() {
        const paginationLinks = document.querySelectorAll('.pagination-custom .page-link, .mobile-pagination .btn');

        paginationLinks.forEach(link => {
            link.addEventListener('click', function(e) {
                // Don't add loading to disabled links
                if (this.closest('.page-item')?.classList.contains('disabled') ||
                    this.hasAttribute('disabled')) {
                    e.preventDefault();
                    return;
                }

                // Add loading state
                const paginationContainer = document.querySelector('.pagination-container');
                if (paginationContainer) {
                    paginationContainer.classList.add('pagination-loading');
                }

                // Show loading indicator
                const loadingHtml = '<i class="fas fa-spinner fa-spin"></i>';
                if (this.querySelector('i')) {
                    const originalIcon = this.querySelector('i').className;
                    this.querySelector('i').className = 'fas fa-spinner fa-spin';

                    // Restore original icon if navigation fails
                    setTimeout(() => {
                        const icon = this.querySelector('i');
                        if (icon && icon.classList.contains('fa-spinner')) {
                            icon.className = originalIcon;
                        }
                    }, 5000);
                }
            });
        });

        // Keyboard navigation for pagination - Điều hướng bằng bàn phím
        document.addEventListener('keydown', function(e) {
            if (e.altKey && !e.ctrlKey && !e.metaKey) {
                const currentPage = ${page};
                const totalPages = ${totalPages};

                if (e.key === 'ArrowLeft' && currentPage > 0) {
                    // Alt + Left Arrow: Previous page
                    e.preventDefault();
                    const prevLink = document.querySelector('.pagination-custom .page-link[href*="page=' + (currentPage - 1) + '"]');
                    if (prevLink) prevLink.click();
                } else if (e.key === 'ArrowRight' && currentPage < totalPages - 1) {
                    // Alt + Right Arrow: Next page
                    e.preventDefault();
                    const nextLink = document.querySelector('.pagination-custom .page-link[href*="page=' + (currentPage + 1) + '"]');
                    if (nextLink) nextLink.click();
                } else if (e.key === 'Home') {
                    // Alt + Home: First page
                    e.preventDefault();
                    const firstLink = document.querySelector('.pagination-custom .page-link[href*="page=0"]');
                    if (firstLink) firstLink.click();
                } else if (e.key === 'End') {
                    // Alt + End: Last page
                    e.preventDefault();
                    const lastLink = document.querySelector('.pagination-custom .page-link[href*="page=' + (totalPages - 1) + '"]');
                    if (lastLink) lastLink.click();
                }
            }
        });

        // URL state management - Quản lý trạng thái URL
        function updateUrlState() {
            const currentUrl = new URL(window.location);
            const page = currentUrl.searchParams.get('page') || 0;
            const size = currentUrl.searchParams.get('size') || 20;

            // Update page size selector
            const pageSizeSelect = document.getElementById('pageSize');
            if (pageSizeSelect) {
                pageSizeSelect.value = size;
            }

            // Update browser history title
            const pageNumber = parseInt(page) + 1;
            const totalPages = ${totalPages};
            document.title = document.title.replace(/\s*\|\s*Trang \d+.*$/, '') +
                (totalPages > 1 ? ` | Trang ${pageNumber}/${totalPages}` : '');
        }

        updateUrlState();

        // Smooth scroll to top after page change - Cuộn mượt lên đầu trang
        if (window.location.search.includes('page=')) {
            const scrollTarget = document.querySelector('.pagination-container') ||
                document.querySelector('main') ||
                document.body;

            setTimeout(() => {
                scrollTarget.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }, 100);
        }

        // Add touch/swipe support for mobile - Hỗ trợ vuốt trên mobile
        let startX = null;
        let startY = null;

        document.addEventListener('touchstart', function(e) {
            startX = e.touches[0].clientX;
            startY = e.touches[0].clientY;
        }, { passive: true });

        document.addEventListener('touchend', function(e) {
            if (!startX || !startY) return;

            const endX = e.changedTouches[0].clientX;
            const endY = e.changedTouches[0].clientY;
            const diffX = startX - endX;
            const diffY = startY - endY;

            // Only handle horizontal swipes
            if (Math.abs(diffX) > Math.abs(diffY) && Math.abs(diffX) > 50) {
                const currentPage = ${page};
                const totalPages = ${totalPages};

                if (diffX > 0 && currentPage < totalPages - 1) {
                    // Swipe left: Next page
                    const nextLink = document.querySelector('.mobile-pagination .btn[href*="page=' + (currentPage + 1) + '"]');
                    if (nextLink) nextLink.click();
                } else if (diffX < 0 && currentPage > 0) {
                    // Swipe right: Previous page
                    const prevLink = document.querySelector('.mobile-pagination .btn[href*="page=' + (currentPage - 1) + '"]');
                    if (prevLink) prevLink.click();
                }
            }

            startX = null;
            startY = null;
        }, { passive: true });
    });

    // Utility function to get pagination parameters - Hàm tiện ích lấy tham số phân trang
    function getPaginationParams() {
        const currentUrl = new URL(window.location);
        return {
            page: parseInt(currentUrl.searchParams.get('page')) || 0,
            size: parseInt(currentUrl.searchParams.get('size')) || 20,
            totalPages: ${totalPages},
            totalElements: ${totalElements}
        };
    }

    // Function to build pagination URL - Hàm xây dựng URL phân trang
    function buildPaginationUrl(page, size, additionalParams) {
        const baseUrl = '${baseUrl}';
        const params = new URLSearchParams();
        params.set('page', page);
        params.set('size', size);

        if (additionalParams) {
            const additional = new URLSearchParams(additionalParams);
            for (const [key, value] of additional) {
                params.set(key, value);
            }
        }

        return baseUrl + '?' + params.toString();
    }
</script>