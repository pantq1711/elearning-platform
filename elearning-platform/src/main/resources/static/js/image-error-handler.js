// File: src/main/resources/static/js/image-error-handler.js

/**
 * IMAGE ERROR HANDLER - Xử lý lỗi ảnh tự động
 * Tự động thay thế ảnh bị lỗi bằng placeholder
 */

(function() {
    'use strict';

    // Default placeholders
    const PLACEHOLDERS = {
        course: 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzAwIiBoZWlnaHQ9IjIwMCIgdmlld0JveD0iMCAwIDMwMCAyMDAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PHJlY3Qgd2lkdGg9IjMwMCIgaGVpZ2h0PSIyMDAiIGZpbGw9IiM2NjdlZWEiLz48dGV4dCB4PSIxNTAiIHk9IjEwMCIgZm9udC1mYW1pbHk9IkFyaWFsLCBzYW5zLXNlcmlmIiBmb250LXNpemU9IjQ4IiBmaWxsPSJ3aGl0ZSIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZG9taW5hbnQtYmFzZWxpbmU9ImNlbnRyYWwiPvCfk5o8L3RleHQ+PC9zdmc+',

        avatar: 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48Y2lyY2xlIGN4PSIyMCIgY3k9IjIwIiByPSIyMCIgZmlsbD0iIzY2N2VlYSIvPjx0ZXh0IHg9IjIwIiB5PSIyNCIgZm9udC1mYW1pbHk9IkFyaWFsLCBzYW5zLXNlcmlmIiBmb250LXNpemU9IjE2IiBmaWxsPSJ3aGl0ZSIgdGV4dC1hbmNob3I9Im1pZGRsZSI+8J+RpDwvdGV4dD48L3N2Zz4=',

        general: 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjE1MCIgdmlld0JveD0iMCAwIDIwMCAxNTAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PHJlY3Qgd2lkdGg9IjIwMCIgaGVpZ2h0PSIxNTAiIGZpbGw9IiNmM2Y0ZjYiIHN0cm9rZT0iI2QxZDVkYiIgc3Ryb2tlLXdpZHRoPSIyIiBzdHJva2UtZGFzaGFycmF5PSI1LDUiLz48dGV4dCB4PSIxMDAiIHk9Ijc1IiBmb250LWZhbWlseT0iQXJpYWwsIHNhbnMtc2VyaWYiIGZvbnQtc2l6ZT0iMzIiIGZpbGw9IiM2YjcyODAiIHRleHQtYW5jaG9yPSJtaWRkbGUiPvCflozkuLjwn5aC8J+VvjwvdGV4dD48L3N2Zz4='
    };

    /**
     * Xác định loại ảnh dựa trên src hoặc context
     */
    function getImageType(img) {
        const src = img.src || '';
        const alt = img.alt || '';
        const className = img.className || '';

        // Course images
        if (src.includes('/courses/') ||
            alt.toLowerCase().includes('course') ||
            className.includes('course')) {
            return 'course';
        }

        // Avatar images
        if (src.includes('/avatars/') ||
            alt.toLowerCase().includes('avatar') ||
            className.includes('avatar') ||
            className.includes('user')) {
            return 'avatar';
        }

        return 'general';
    }

    /**
     * Xử lý lỗi ảnh
     */
    function handleImageError(event) {
        const img = event.target;

        // Tránh infinite loop
        if (img.dataset.errorHandled === 'true') {
            return;
        }

        const imageType = getImageType(img);
        const placeholder = PLACEHOLDERS[imageType];

        // Đánh dấu đã xử lý
        img.dataset.errorHandled = 'true';

        // Thay đổi src
        img.src = placeholder;

        // Thêm class để styling
        img.classList.add('image-placeholder', `${imageType}-placeholder`);

        // Log cho debug (chỉ trong development)
        if (window.location.hostname === 'localhost') {
            console.warn('Image failed to load:', event.target.src);
        }
    }

    /**
     * Xử lý khi ảnh load thành công
     */
    function handleImageLoad(event) {
        const img = event.target;
        img.classList.remove('image-loading');
        img.classList.add('image-loaded');
    }

    /**
     * Thêm loading state cho ảnh
     */
    function addLoadingState(img) {
        img.classList.add('image-loading');
    }

    /**
     * Setup image error handling cho tất cả ảnh hiện tại
     */
    function setupExistingImages() {
        const images = document.querySelectorAll('img');
        images.forEach(img => {
            // Bỏ qua các ảnh đã được xử lý
            if (img.dataset.errorSetup === 'true') {
                return;
            }

            img.dataset.errorSetup = 'true';

            // Add event listeners
            img.addEventListener('error', handleImageError);
            img.addEventListener('load', handleImageLoad);

            // Add loading state nếu ảnh chưa load
            if (!img.complete) {
                addLoadingState(img);
            }

            // Kiểm tra ảnh đã bị lỗi từ trước
            if (img.src === '' || img.src.includes('null') || img.naturalWidth === 0) {
                handleImageError({ target: img });
            }
        });
    }

    /**
     * Setup observer cho dynamic images (lazy loading)
     */
    function setupDynamicImages() {
        // MutationObserver để handle dynamic content
        const observer = new MutationObserver(mutations => {
            mutations.forEach(mutation => {
                mutation.addedNodes.forEach(node => {
                    if (node.nodeType === 1) { // Element node
                        // Tìm tất cả img trong node mới
                        const images = node.tagName === 'IMG' ? [node] : node.querySelectorAll('img');
                        images.forEach(img => {
                            if (img.dataset.errorSetup !== 'true') {
                                img.dataset.errorSetup = 'true';
                                img.addEventListener('error', handleImageError);
                                img.addEventListener('load', handleImageLoad);

                                if (!img.complete) {
                                    addLoadingState(img);
                                }
                            }
                        });
                    }
                });
            });
        });

        observer.observe(document.body, {
            childList: true,
            subtree: true
        });
    }

    /**
     * Public API để manually handle specific images
     */
    window.ImageErrorHandler = {
        setup: function(selector) {
            const images = document.querySelectorAll(selector || 'img');
            images.forEach(img => {
                img.addEventListener('error', handleImageError);
                img.addEventListener('load', handleImageLoad);
            });
        },

        setPlaceholder: function(type, placeholder) {
            PLACEHOLDERS[type] = placeholder;
        },

        handleError: handleImageError
    };

    /**
     * Auto-initialize khi DOM ready
     */
    function init() {
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => {
                setupExistingImages();
                setupDynamicImages();
            });
        } else {
            setupExistingImages();
            setupDynamicImages();
        }
    }

    // Start the magic!
    init();

})();

/**
 * CÁCH SỬ DỤNG:
 *
 * 1. Auto: Script tự động xử lý tất cả ảnh
 * 2. Manual: ImageErrorHandler.setup('img.custom')
 * 3. Custom placeholder: ImageErrorHandler.setPlaceholder('course', 'custom-url')
 *
 * CSS CLASSES được thêm tự động:
 * - .image-loading: Khi ảnh đang load
 * - .image-loaded: Khi ảnh load thành công
 * - .image-placeholder: Khi ảnh bị lỗi
 * - .course-placeholder, .avatar-placeholder: Theo loại ảnh
 */