<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--
Pagination Component - Tái sử dụng cho các trang có phân trang
Parameters cần truyền:
- currentPage: trang hiện tại (0-based)
- totalPages: tổng số trang
- baseUrl: URL cơ bản (không có tham số page)
- pageSize: số item trên mỗi trang
- additionalParams: các tham số khác (optional)
--%>

<c:if test="${totalPages > 1}">
    <nav aria-label="Page navigation" class="mt-4">
        <ul class="pagination justify-content-center">

            <!-- Previous Page Button -->
            <c:choose>
                <c:when test="${currentPage > 0}">
                    <li class="page-item">
                        <a class="page-link"
                           href="${baseUrl}?page=${currentPage - 1}&size=${pageSize}${not empty additionalParams ? '&' : ''}${additionalParams}"
                           aria-label="Trang trước">
                            <i class="fas fa-chevron-left"></i>
                            <span class="d-none d-sm-inline ms-1">Trước</span>
                        </a>
                    </li>
                </c:when>
                <c:otherwise>
                    <li class="page-item disabled">
                        <span class="page-link" aria-label="Trang trước">
                            <i class="fas fa-chevron-left"></i>
                            <span class="d-none d-sm-inline ms-1">Trước</span>
                        </span>
                    </li>
                </c:otherwise>
            </c:choose>

            <!-- Smart pagination logic -->
            <c:choose>
                <!-- Nếu tổng số trang <= 7, hiện tất cả -->
                <c:when test="${totalPages <= 7}">
                    <c:forEach var="pageNum" begin="0" end="${totalPages - 1}">
                        <c:choose>
                            <c:when test="${pageNum == currentPage}">
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
                                       href="${baseUrl}?page=${pageNum}&size=${pageSize}${not empty additionalParams ? '&' : ''}${additionalParams}">
                                            ${pageNum + 1}
                                    </a>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </c:when>

                <!-- Nếu tổng số trang > 7, hiện thông minh -->
                <c:otherwise>
                    <!-- Xác định range hiển thị -->
                    <c:set var="startPage" value="${currentPage - 2 < 0 ? 0 : currentPage - 2}"/>
                    <c:set var="endPage" value="${currentPage + 2 >= totalPages ? totalPages - 1 : currentPage + 2}"/>

                    <!-- Show first page if not in range -->
                    <c:if test="${startPage > 0}">
                        <li class="page-item">
                            <a class="page-link"
                               href="${baseUrl}?page=0&size=${pageSize}${not empty additionalParams ? '&' : ''}${additionalParams}">
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
                            <c:when test="${pageNum == currentPage}">
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
                                       href="${baseUrl}?page=${pageNum}&size=${pageSize}${not empty additionalParams ? '&' : ''}${additionalParams}">
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
                               href="${baseUrl}?page=${totalPages - 1}&size=${pageSize}${not empty additionalParams ? '&' : ''}${additionalParams}">
                                    ${totalPages}
                            </a>
                        </li>
                    </c:if>
                </c:otherwise>
            </c:choose>

            <!-- Next Page Button -->
            <c:choose>
                <c:when test="${currentPage < totalPages - 1}">
                    <li class="page-item">
                        <a class="page-link"
                           href="${baseUrl}?page=${currentPage + 1}&size=${pageSize}${not empty additionalParams ? '&' : ''}${additionalParams}"
                           aria-label="Trang sau">
                            <span class="d-none d-sm-inline me-1">Sau</span>
                            <i class="fas fa-chevron-right"></i>
                        </a>
                    </li>
                </c:when>
                <c:otherwise>
                    <li class="page-item disabled">
                        <span class="page-link" aria-label="Trang sau">
                            <span class="d-none d-sm-inline me-1">Sau</span>
                            <i class="fas fa-chevron-right"></i>
                        </span>
                    </li>
                </c:otherwise>
            </c:choose>
        </ul>

        <!-- Page info -->
        <div class="pagination-info text-center mt-2">
            <small class="text-muted">
                Trang ${currentPage + 1} / ${totalPages}
                <c:if test="${not empty totalElements}">
                    (${totalElements} kết quả)
                </c:if>
            </small>
        </div>
    </nav>
</c:if>

<style>
    /* Custom pagination styles */
    .pagination .page-link {
        border-radius: 6px;
        margin: 0 2px;
        border: 1px solid #dee2e6;
        color: #495057;
        padding: 0.5rem 0.75rem;
        transition: all 0.2s ease;
    }

    .pagination .page-link:hover {
        background-color: #e9ecef;
        border-color: #adb5bd;
        color: #495057;
        text-decoration: none;
    }

    .pagination .page-item.active .page-link {
        background-color: #007bff;
        border-color: #007bff;
        color: white;
        box-shadow: 0 2px 4px rgba(0, 123, 255, 0.25);
    }

    .pagination .page-item.disabled .page-link {
        color: #6c757d;
        background-color: #fff;
        border-color: #dee2e6;
        cursor: not-allowed;
    }

    .pagination-info {
        font-size: 0.875rem;
        color: #6c757d;
    }

    /* Responsive adjustments */
    @media (max-width: 576px) {
        .pagination .page-link {
            padding: 0.375rem 0.5rem;
            font-size: 0.875rem;
        }

        .pagination .page-item:not(.active):not(.disabled):not(:first-child):not(:last-child) {
            display: none;
        }

        .pagination .page-item:nth-child(2):not(.active),
        .pagination .page-item:nth-last-child(2):not(.active) {
            display: list-item;
        }
    }
</style>