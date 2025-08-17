/**
 * LESSON-FORM.JS - JavaScript cho form tạo/sửa bài học
 * Xử lý các loại bài học: Video, Document, Text
 */

document.addEventListener('DOMContentLoaded', function() {
    // Khởi tạo các components
    initializeLessonTypeSelection();
    initializeVideoHandling();
    initializeDocumentHandling();
    initializeTextEditor();
    initializeFormValidation();
    initializeCharacterCounters();
    initializeProgressTracking();

    console.log('✅ Lesson form initialized');
});

/**
 * LESSON TYPE SELECTION
 * Xử lý chọn loại bài học
 */
function initializeLessonTypeSelection() {
    const typeCards = document.querySelectorAll('.lesson-type-card');
    const currentType = document.getElementById('lessonType')?.value || 'VIDEO';

    // Set initial state
    selectLessonType(currentType);

    // Add click handlers
    typeCards.forEach(card => {
        card.addEventListener('click', function() {
            const type = this.getAttribute('data-type');
            selectLessonType(type);
        });
    });
}

function selectLessonType(type) {
    // Remove active class từ tất cả cards
    document.querySelectorAll('.lesson-type-card').forEach(card => {
        card.classList.remove('active');
    });

    // Add active class cho card được chọn
    const selectedCard = document.querySelector(`[data-type="${type}"]`);
    if (selectedCard) {
        selectedCard.classList.add('active');
    }

    // Cập nhật hidden input
    const typeInput = document.getElementById('lessonType');
    if (typeInput) {
        typeInput.value = type;
    }

    // Hiển thị/ẩn content sections
    const contentSections = {
        'VIDEO': 'videoContent',
        'DOCUMENT': 'documentContent',
        'TEXT': 'textContent'
    };

    Object.entries(contentSections).forEach(([sectionType, sectionId]) => {
        const section = document.getElementById(sectionId);
        if (section) {
            section.style.display = sectionType === type ? 'block' : 'none';
        }
    });

    // Update form validation rules based on type
    updateValidationRules(type);
}

/**
 * VIDEO HANDLING
 * Xử lý video upload và preview
 */
function initializeVideoHandling() {
    const videoUploadArea = document.getElementById('videoUploadArea');
    const videoFileInput = document.getElementById('videoFile');
    const videoUrlInput = document.getElementById('videoUrl');
    const videoPreview = document.getElementById('videoPreview');
    const videoPlayer = document.getElementById('videoPreviewPlayer');

    if (!videoUploadArea || !videoFileInput) return;

    // Setup drag & drop
    setupFileUpload(videoUploadArea, videoFileInput, handleVideoFile);

    // Video URL input handler
    if (videoUrlInput) {
        videoUrlInput.addEventListener('input', debounce(function() {
            const url = this.value.trim();
            if (url) {
                handleVideoUrl(url);
            }
        }, 1000));
    }

    function handleVideoFile(file) {
        // Validate file type
        if (!file.type.startsWith('video/')) {
            showNotification('error', 'Vui lòng chọn file video hợp lệ!');
            return;
        }

        // Validate file size (100MB)
        const maxSize = 100 * 1024 * 1024;
        if (file.size > maxSize) {
            showNotification('error', 'File video quá lớn! Kích thước tối đa: 100MB');
            return;
        }

        // Update UI
        updateUploadAreaText(videoUploadArea, file.name, formatFileSize(file.size));

        // Show preview
        if (videoPreview && videoPlayer) {
            const url = URL.createObjectURL(file);
            videoPlayer.src = url;
            videoPreview.style.display = 'block';

            // Auto-detect duration
            videoPlayer.addEventListener('loadedmetadata', function() {
                const duration = Math.ceil(this.duration / 60); // Convert to minutes
                const durationInput = document.getElementById('duration');
                if (durationInput && !durationInput.value) {
                    durationInput.value = duration;
                }
            });
        }

        // Clear video URL if file is selected
        if (videoUrlInput) {
            videoUrlInput.value = '';
        }

        showNotification('success', 'Video đã được chọn thành công!');
    }

    function handleVideoUrl(url) {
        // Validate video URL patterns
        const videoPatterns = [
            /youtube\.com\/watch\?v=([a-zA-Z0-9_-]+)/,
            /youtu\.be\/([a-zA-Z0-9_-]+)/,
            /vimeo\.com\/(\d+)/,
            /drive\.google\.com\/file\/d\/([a-zA-Z0-9_-]+)/,
            /\.(mp4|avi|mov|wmv|flv|webm)$/i
        ];

        const isValidVideo = videoPatterns.some(pattern => pattern.test(url));

        if (isValidVideo) {
            // Clear file input if URL is provided
            videoFileInput.value = '';
            updateUploadAreaText(videoUploadArea, 'Video từ URL', 'Đã liên kết');

            // Try to embed video preview for supported platforms
            embedVideoPreview(url);

            showNotification('success', 'URL video hợp lệ!');
        } else {
            showNotification('error', 'URL video không hợp lệ! Hỗ trợ YouTube, Vimeo, Google Drive và file trực tiếp.');
        }
    }

    function embedVideoPreview(url) {
        if (!videoPreview) return;

        let embedHtml = '';

        // YouTube
        const youtubeMatch = url.match(/(?:youtube\.com\/watch\?v=|youtu\.be\/)([a-zA-Z0-9_-]+)/);
        if (youtubeMatch) {
            embedHtml = `<iframe width="100%" height="300" src="https://www.youtube.com/embed/${youtubeMatch[1]}" frameborder="0" allowfullscreen></iframe>`;
        }

        // Vimeo
        const vimeoMatch = url.match(/vimeo\.com\/(\d+)/);
        if (vimeoMatch) {
            embedHtml = `<iframe width="100%" height="300" src="https://player.vimeo.com/video/${vimeoMatch[1]}" frameborder="0" allowfullscreen></iframe>`;
        }

        // Direct video file
        if (url.match(/\.(mp4|avi|mov|wmv|flv|webm)$/i)) {
            embedHtml = `<video width="100%" height="300" controls><source src="${url}" type="video/mp4"></video>`;
        }

        if (embedHtml) {
            videoPreview.innerHTML = embedHtml;
            videoPreview.style.display = 'block';
        }
    }
}

/**
 * DOCUMENT HANDLING
 * Xử lý document upload
 */
function initializeDocumentHandling() {
    const documentUploadArea = document.getElementById('documentUploadArea');
    const documentFileInput = document.getElementById('documentFile');
    const documentUrlInput = document.getElementById('documentUrl');

    if (!documentUploadArea || !documentFileInput) return;

    // Setup drag & drop
    setupFileUpload(documentUploadArea, documentFileInput, handleDocumentFile);

    // Document URL input handler
    if (documentUrlInput) {
        documentUrlInput.addEventListener('input', debounce(function() {
            const url = this.value.trim();
            if (url) {
                handleDocumentUrl(url);
            }
        }, 1000));
    }

    function handleDocumentFile(file) {
        // Validate file type
        const allowedTypes = ['.pdf', '.doc', '.docx', '.ppt', '.pptx', '.xls', '.xlsx'];
        const fileExt = '.' + file.name.split('.').pop().toLowerCase();

        if (!allowedTypes.includes(fileExt)) {
            showNotification('error', 'Loại file không được hỗ trợ! Chỉ hỗ trợ: PDF, DOC, DOCX, PPT, PPTX, XLS, XLSX');
            return;
        }

        // Validate file size (50MB)
        const maxSize = 50 * 1024 * 1024;
        if (file.size > maxSize) {
            showNotification('error', 'File tài liệu quá lớn! Kích thước tối đa: 50MB');
            return;
        }

        // Update UI
        updateUploadAreaText(documentUploadArea, file.name, formatFileSize(file.size));

        // Clear document URL if file is selected
        if (documentUrlInput) {
            documentUrlInput.value = '';
        }

        showNotification('success', 'Tài liệu đã được chọn thành công!');
    }

    function handleDocumentUrl(url) {
        // Validate document URL patterns
        const documentPatterns = [
            /drive\.google\.com\/file\/d\/([a-zA-Z0-9_-]+)/,
            /dropbox\.com\/s\/([a-zA-Z0-9_-]+)/,
            /\.(pdf|doc|docx|ppt|pptx|xls|xlsx)$/i
        ];

        const isValidDocument = documentPatterns.some(pattern => pattern.test(url));

        if (isValidDocument) {
            // Clear file input if URL is provided
            documentFileInput.value = '';
            updateUploadAreaText(documentUploadArea, 'Tài liệu từ URL', 'Đã liên kết');

            showNotification('success', 'URL tài liệu hợp lệ!');
        } else {
            showNotification('error', 'URL tài liệu không hợp lệ! Hỗ trợ Google Drive, Dropbox và file trực tiếp.');
        }
    }
}

/**
 * TEXT EDITOR
 * Khởi tạo TinyMCE cho nội dung văn bản
 */
function initializeTextEditor() {
    if (typeof tinymce === 'undefined') {
        console.warn('⚠️ TinyMCE không được load');
        return;
    }

    tinymce.init({
        selector: '#textContentArea',
        height: 400,
        menubar: false,
        plugins: [
            'advlist', 'autolink', 'lists', 'link', 'image', 'charmap',
            'anchor', 'searchreplace', 'visualblocks', 'code', 'fullscreen',
            'insertdatetime', 'media', 'table', 'preview', 'help', 'wordcount',
            'codesample', 'hr', 'pagebreak', 'nonbreaking', 'toc'
        ],
        toolbar: 'undo redo | blocks | ' +
            'bold italic forecolor backcolor | alignleft aligncenter ' +
            'alignright alignjustify | bullist numlist outdent indent | ' +
            'removeformat | link image media | table | codesample | ' +
            'hr pagebreak | code fullscreen | help',
        content_style: `
            body { 
                font-family: Inter, Arial, sans-serif; 
                font-size: 14px; 
                line-height: 1.6;
                padding: 15px;
            }
            h1, h2, h3, h4, h5, h6 { 
                color: #2c3e50; 
                margin-top: 1.5em; 
                margin-bottom: 0.5em; 
            }
            p { margin-bottom: 1em; }
            blockquote { 
                border-left: 4px solid #667eea; 
                padding-left: 1em; 
                margin: 1em 0; 
                font-style: italic; 
            }
            code { 
                background-color: #f8f9fa; 
                padding: 2px 4px; 
                border-radius: 3px; 
                font-family: 'Courier New', monospace; 
            }
            pre { 
                background-color: #f8f9fa; 
                padding: 1em; 
                border-radius: 5px; 
                overflow-x: auto; 
            }
        `,
        language: 'vi',
        branding: false,
        image_upload_handler: function(blobInfo, success, failure) {
            // Handle image upload for text content
            const formData = new FormData();
            formData.append('image', blobInfo.blob(), blobInfo.filename());

            // This would typically upload to your server
            // For now, we'll use a placeholder
            setTimeout(() => {
                success('/images/placeholder.jpg');
            }, 1000);
        },
        setup: function(editor) {
            editor.on('change', function() {
                // Auto-save content
                autoSaveContent();
            });
        }
    });
}

/**
 * FORM VALIDATION
 * Enhanced validation cho lesson form
 */
function initializeFormValidation() {
    const form = document.querySelector('.needs-validation');
    if (!form) return;

    form.addEventListener('submit', function(e) {
        // Get current lesson type
        const lessonType = document.getElementById('lessonType')?.value;

        // Validate based on lesson type
        let isValid = true;

        if (lessonType === 'VIDEO') {
            isValid = validateVideoContent();
        } else if (lessonType === 'DOCUMENT') {
            isValid = validateDocumentContent();
        } else if (lessonType === 'TEXT') {
            isValid = validateTextContent();
        }

        if (!isValid || !form.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();
            showNotification('error', 'Vui lòng kiểm tra lại thông tin và sửa các lỗi!');
        }

        form.classList.add('was-validated');
    });
}

function validateVideoContent() {
    const videoFile = document.getElementById('videoFile')?.files[0];
    const videoUrl = document.getElementById('videoUrl')?.value.trim();

    if (!videoFile && !videoUrl) {
        showNotification('error', 'Vui lòng chọn file video hoặc nhập URL video!');
        return false;
    }

    return true;
}

function validateDocumentContent() {
    const documentFile = document.getElementById('documentFile')?.files[0];
    const documentUrl = document.getElementById('documentUrl')?.value.trim();

    if (!documentFile && !documentUrl) {
        showNotification('error', 'Vui lòng chọn file tài liệu hoặc nhập URL tài liệu!');
        return false;
    }

    return true;
}

function validateTextContent() {
    const content = tinymce.get('textContentArea')?.getContent() || '';

    if (content.trim().length < 100) {
        showNotification('error', 'Nội dung văn bản phải có ít nhất 100 ký tự!');
        return false;
    }

    return true;
}

function updateValidationRules(type) {
    // Remove required attributes from all content inputs
    const allInputs = document.querySelectorAll('#videoFile, #videoUrl, #documentFile, #documentUrl, #textContentArea');
    allInputs.forEach(input => input.removeAttribute('required'));

    // Add required attributes based on lesson type
    if (type === 'VIDEO') {
        // Video inputs are conditionally required (handled in validation)
    } else if (type === 'DOCUMENT') {
        // Document inputs are conditionally required (handled in validation)
    } else if (type === 'TEXT') {
        const textArea = document.getElementById('textContentArea');
        if (textArea) {
            textArea.setAttribute('required', true);
        }
    }
}

/**
 * CHARACTER COUNTERS
 */
function initializeCharacterCounters() {
    const counters = [
        { inputId: 'title', counterId: 'titleCount', maxLength: 200 },
        { inputId: 'description', counterId: 'descriptionCount', maxLength: 1000 }
    ];

    counters.forEach(({ inputId, counterId, maxLength }) => {
        const input = document.getElementById(inputId);
        const counter = document.getElementById(counterId);

        if (input && counter) {
            const updateCount = () => {
                const currentLength = input.value.length;
                counter.textContent = currentLength;

                if (currentLength > maxLength * 0.9) {
                    counter.style.color = '#ffc107';
                } else if (currentLength >= maxLength) {
                    counter.style.color = '#dc3545';
                } else {
                    counter.style.color = '#6c757d';
                }
            };

            input.addEventListener('input', updateCount);
            updateCount();
        }
    });
}

/**
 * PROGRESS TRACKING
 * Theo dõi tiến độ hoàn thành form
 */
function initializeProgressTracking() {
    const progressBar = createProgressBar();
    updateProgress();

    // Update progress on form changes
    const form = document.querySelector('form');
    if (form) {
        form.addEventListener('input', debounce(updateProgress, 500));
        form.addEventListener('change', updateProgress);
    }

    function createProgressBar() {
        const header = document.querySelector('.page-header');
        if (!header) return null;

        const progressHtml = `
            <div class="progress mb-3" style="height: 8px;">
                <div class="progress-bar bg-success" id="lessonFormProgress" role="progressbar" 
                     style="width: 0%" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">
                </div>
            </div>
        `;

        header.insertAdjacentHTML('beforeend', progressHtml);
        return document.getElementById('lessonFormProgress');
    }

    function updateProgress() {
        const progressBar = document.getElementById('lessonFormProgress');
        if (!progressBar) return;

        const requiredFields = [
            'title',
            'orderNumber',
            'lessonType'
        ];

        const lessonType = document.getElementById('lessonType')?.value;

        // Add content-specific required fields
        if (lessonType === 'VIDEO') {
            const hasVideo = document.getElementById('videoFile')?.files[0] ||
                document.getElementById('videoUrl')?.value.trim();
            requiredFields.push(hasVideo ? 'videoContent' : '');
        } else if (lessonType === 'DOCUMENT') {
            const hasDocument = document.getElementById('documentFile')?.files[0] ||
                document.getElementById('documentUrl')?.value.trim();
            requiredFields.push(hasDocument ? 'documentContent' : '');
        } else if (lessonType === 'TEXT') {
            const hasContent = tinymce.get('textContentArea')?.getContent()?.trim().length > 100;
            requiredFields.push(hasContent ? 'textContent' : '');
        }

        let completedFields = 0;
        const totalFields = requiredFields.length;

        requiredFields.forEach(fieldId => {
            if (fieldId === 'videoContent' || fieldId === 'documentContent' || fieldId === 'textContent') {
                completedFields++; // Already checked above
            } else if (fieldId) {
                const field = document.getElementById(fieldId);
                if (field && field.value.trim()) {
                    completedFields++;
                }
            }
        });

        const progress = Math.round((completedFields / totalFields) * 100);
        progressBar.style.width = progress + '%';
        progressBar.setAttribute('aria-valuenow', progress);

        // Update color based on progress
        progressBar.className = 'progress-bar ' +
            (progress < 50 ? 'bg-danger' :
                progress < 80 ? 'bg-warning' : 'bg-success');
    }
}

/**
 * UTILITY FUNCTIONS
 */

function setupFileUpload(area, input, handler) {
    // Click to select
    area.addEventListener('click', () => input.click());

    // Drag & drop events
    area.addEventListener('dragover', (e) => {
        e.preventDefault();
        area.classList.add('dragover');
    });

    area.addEventListener('dragleave', () => {
        area.classList.remove('dragover');
    });

    area.addEventListener('drop', (e) => {
        e.preventDefault();
        area.classList.remove('dragover');

        const files = e.dataTransfer.files;
        if (files.length > 0) {
            input.files = files;
            handler(files[0]);
        }
    });

    // File input change
    input.addEventListener('change', (e) => {
        if (e.target.files.length > 0) {
            handler(e.target.files[0]);
        }
    });
}

function updateUploadAreaText(area, fileName, fileSize) {
    const textEl = area.querySelector('.upload-text');
    const hintEl = area.querySelector('.upload-hint');

    if (textEl) textEl.textContent = fileName;
    if (hintEl) hintEl.textContent = fileSize;
}

function formatFileSize(bytes) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
}

function debounce(func, delay) {
    let timeoutId;
    return function (...args) {
        clearTimeout(timeoutId);
        timeoutId = setTimeout(() => func.apply(this, args), delay);
    };
}

function showNotification(type, message, duration = 3000) {
    if (typeof window.showNotification === 'function') {
        window.showNotification(type, message, duration);
    } else {
        console.log(`${type.toUpperCase()}: ${message}`);
        if (type === 'error') {
            alert('Lỗi: ' + message);
        }
    }
}

// Auto-save functionality
let autoSaveTimer;

function autoSaveContent() {
    clearTimeout(autoSaveTimer);

    autoSaveTimer = setTimeout(() => {
        const formData = {
            title: document.getElementById('title')?.value || '',
            description: document.getElementById('description')?.value || '',
            lessonType: document.getElementById('lessonType')?.value || '',
            orderNumber: document.getElementById('orderNumber')?.value || '',
            textContent: tinymce.get('textContentArea')?.getContent() || ''
        };

        localStorage.setItem('lessonFormAutoSave', JSON.stringify(formData));
        console.log('Auto-saved lesson form data');
    }, 2000);
}

// Load auto-saved data on page load
function loadAutoSavedData() {
    const saved = localStorage.getItem('lessonFormAutoSave');
    if (!saved) return;

    try {
        const data = JSON.parse(saved);

        if (confirm('Tìm thấy dữ liệu đã lưu tự động. Bạn có muốn khôi phục không?')) {
            Object.keys(data).forEach(key => {
                const element = document.getElementById(key);
                if (element && key !== 'textContent') {
                    element.value = data[key];
                }
            });

            // Load TinyMCE content
            if (data.textContent && tinymce.get('textContentArea')) {
                tinymce.get('textContentArea').setContent(data.textContent);
            }

            showNotification('success', 'Đã khôi phục dữ liệu tự động lưu');
        }
    } catch (error) {
        console.error('Error loading auto-save data:', error);
    }
}

// Initialize auto-save
document.addEventListener('DOMContentLoaded', function() {
    setTimeout(loadAutoSavedData, 1000); // Load after form initialization

    // Clear auto-save on successful submit
    const form = document.querySelector('form');
    if (form) {
        form.addEventListener('submit', () => {
            localStorage.removeItem('lessonFormAutoSave');
        });
    }
});