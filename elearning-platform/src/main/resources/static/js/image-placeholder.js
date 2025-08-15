// File: src/main/resources/static/js/image-placeholder.js

/**
 * Xử lý ảnh bị lỗi và thay thế bằng placeholder
 */
document.addEventListener('DOMContentLoaded', function() {
    // Xử lý tất cả ảnh khi load trang
    handleImageErrors();

    // Tự động thay thế app store badges
    replaceAppStoreBadges();
});

/**
 * Xử lý ảnh bị lỗi
 */
function handleImageErrors() {
    const images = document.querySelectorAll('img');

    images.forEach(function(img) {
        img.onerror = function() {
            createImagePlaceholder(this);
        };

        // Kiểm tra nếu ảnh đã bị lỗi từ trước
        if (!img.complete || img.naturalHeight === 0) {
            createImagePlaceholder(img);
        }
    });
}

/**
 * Tạo placeholder cho ảnh bị lỗi
 */
function createImagePlaceholder(imgElement) {
    const src = imgElement.src;
    const alt = imgElement.alt || 'Image';
    const width = imgElement.width || imgElement.offsetWidth || 200;
    const height = imgElement.height || imgElement.offsetHeight || 200;

    // Tạo placeholder div
    const placeholder = document.createElement('div');
    placeholder.className = getPlaceholderClass(src);
    placeholder.style.width = width + 'px';
    placeholder.style.height = height + 'px';

    // Nội dung placeholder
    const content = getPlaceholderContent(src, alt);
    placeholder.innerHTML = content;

    // Thay thế img bằng placeholder
    imgElement.parentNode.replaceChild(placeholder, imgElement);
}

/**
 * Lấy class CSS cho placeholder dựa trên loại ảnh
 */
function getPlaceholderClass(src) {
    if (src.includes('testimonials')) {
        return 'image-placeholder testimonial-placeholder';
    } else if (src.includes('hero')) {
        return 'image-placeholder hero-placeholder';
    } else if (src.includes('courses')) {
        return 'image-placeholder course-placeholder';
    } else if (src.includes('avatars')) {
        return 'image-placeholder testimonial-placeholder';
    } else {
        return 'image-placeholder';
    }
}

/**
 * Lấy nội dung cho placeholder
 */
function getPlaceholderContent(src, alt) {
    if (src.includes('testimonials') || src.includes('avatars')) {
        // Lấy chữ cái đầu từ alt text
        const initials = alt.split(' ').map(word => word.charAt(0)).join('').toUpperCase();
        return initials.substring(0, 2) || 'ST';
    } else if (src.includes('hero')) {
        return '<i class="fas fa-graduation-cap"></i><span>EduLearn Platform</span>';
    } else if (src.includes('courses')) {
        return '<i class="fas fa-book"></i><span>Khóa học</span>';
    } else if (src.includes('app-store') || src.includes('google-play')) {
        return '<i class="fas fa-mobile-alt"></i>';
    } else {
        return '<i class="fas fa-image"></i>';
    }
}

/**
 * Thay thế app store badges bằng text links
 */
function replaceAppStoreBadges() {
    // Thay thế Google Play badge
    const googlePlayImages = document.querySelectorAll('img[src*="google-play"]');
    googlePlayImages.forEach(function(img) {
        const link = img.parentElement;
        if (link && link.tagName === 'A') {
            link.innerHTML = '<span class="app-badge-placeholder"><i class="fab fa-google-play"></i>Google Play</span>';
            link.href = '#';
        }
    });

    // Thay thế App Store badge
    const appStoreImages = document.querySelectorAll('img[src*="app-store"]');
    appStoreImages.forEach(function(img) {
        const link = img.parentElement;
        if (link && link.tagName === 'A') {
            link.innerHTML = '<span class="app-badge-placeholder"><i class="fab fa-apple"></i>App Store</span>';
            link.href = '#';
        }
    });
}

/**
 * Utility function để tạo avatar placeholder từ tên
 */
function createAvatarPlaceholder(name, size = 80) {
    const initials = name.split(' ').map(word => word.charAt(0)).join('').toUpperCase();
    const colors = ['#4f46e5', '#7c3aed', '#dc2626', '#059669', '#d97706'];
    const color = colors[name.length % colors.length];

    return `
        <div class="testimonial-placeholder" style="width: ${size}px; height: ${size}px; background: ${color};">
            ${initials.substring(0, 2)}
        </div>
    `;
}