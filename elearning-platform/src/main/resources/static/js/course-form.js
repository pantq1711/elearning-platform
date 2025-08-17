/**
 * COURSE-FORM.JS - JavaScript cho form tạo/sửa khóa học
 * Xử lý validation, file upload, và dynamic content
 */

document.addEventListener('DOMContentLoaded', function() {
    // Khởi tạo các components
    initializeTinyMCE();
    initializeFileUpload();
    initializeFormValidation();
    initializeCharacterCounters();
    initializePriceHandling();
    initializeCategorySearch();

    console.log('✅ Course form initialized');
});

/**
 * TINYMCE INITIALIZATION
 * Khởi tạo TinyMCE cho các textarea
 */
function initializeTinyMCE() {
    if (typeof tinymce === 'undefined') {
        console.warn('⚠️ TinyMCE không được load');
        return;
    }

    // Cấu hình TinyMCE cho description
    tinymce.init({
        selector: '#description',
        height: 400,
        menubar: false,
        plugins: [
            'advlist', 'autolink', 'lists', 'link', 'image', 'charmap',
            'anchor', 'searchreplace', 'visualblocks', 'code', 'fullscreen',
            'insertdatetime', 'media', 'table', 'preview', 'help', 'wordcount'
        ],
        toolbar: 'undo redo | blocks | ' +
            'bold italic forecolor | alignleft aligncenter ' +
            'alignright alignjustify | bullist numlist outdent indent | ' +
            'removeformat | link image | code fullscreen | help',
        content_style: 'body { font-family: Inter, Arial, sans-serif; font-size: 14px; padding: 10px; }',
        language: 'vi',
        branding: false,
        setup: function(editor) {
            editor.on('change', function() {
                // Trigger validation khi content thay đổi
                const textarea = document.getElementById('description');
                if (textarea) {
                    textarea.value = editor.getContent();
                    textarea.dispatchEvent(new Event('input'));
                }
            });
        }
    });

    // Cấu hình TinyMCE cho requirements (nếu có)
    tinymce.init({
        selector: '#requirements',
        height: 200,
        menubar: false,
        plugins: ['advlist', 'autolink', 'lists', 'link', 'code'],
        toolbar: 'undo redo | bullist numlist | bold italic | link | code',
        content_style: 'body { font-family: Inter, Arial, sans-serif; font-size: 14px; padding: 10px; }',
        language: 'vi',
        branding: false
    });

    // Cấu hình TinyMCE cho what you will learn
    tinymce.init({
        selector: '#whatYouWillLearn',
        height: 200,
        menubar: false,
        plugins: ['advlist', 'autolink', 'lists', 'link', 'code'],
        toolbar: 'undo redo | bullist numlist | bold italic | link | code',
        content_style: 'body { font-family: Inter, Arial, sans-serif; font-size: 14px; padding: 10px; }',
        language: 'vi',
        branding: false
    });
}

/**
 * FILE UPLOAD HANDLING
 * Xử lý drag & drop thumbnail upload
 */
function initializeFileUpload() {
    const uploadArea = document.getElementById('thumbnailUpload');
    const fileInput = document.getElementById('thumbnailFile');
    const preview = document.getElementById('thumbnailPreview');
    const previewImage = document.getElementById('previewImage');
    const previewName = document.getElementById('previewName');

    if (!uploadArea || !fileInput) return;

    // Click to select file
    uploadArea.addEventListener('click', (e) => {
        if (e.target === uploadArea || e.target.closest('.upload-icon, .upload-text, .upload-hint')) {
            fileInput.click();
        }
    });

    // Drag and drop events
    uploadArea.addEventListener('dragover', (e) => {
        e.preventDefault();
        uploadArea.classList.add('dragover');
    });

    uploadArea.addEventListener('dragleave', (e) => {
        e.preventDefault();
        uploadArea.classList.remove('dragover');
    });

    uploadArea.addEventListener('drop', (e) => {
        e.preventDefault();
        uploadArea.classList.remove('dragover');

        const files = e.dataTransfer.files;
        if (files.length > 0) {
            fileInput.files = files;
            handleFileSelect(files[0]);
        }
    });

    // File input change
    fileInput.addEventListener('change', (e) => {
        if (e.target.files.length > 0) {
            handleFileSelect(e.target.files[0]);
        }
    });

    /**
     * Xử lý file được chọn
     */
    function handleFileSelect(file) {
        // Validate file type
        const allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
        if (!allowedTypes.includes(file.type)) {
            showNotification('error', 'Chỉ hỗ trợ file ảnh (JPEG, PNG, GIF, WebP)!');
            return;
        }

        // Validate file size (5MB)
        const maxSize = 5 * 1024 * 1024;
        if (file.size > maxSize) {
            showNotification('error', 'File ảnh quá lớn! Kích thước tối đa: 5MB');
            return;
        }

        // Update UI
        const textEl = uploadArea.querySelector('.upload-text');
        const hintEl = uploadArea.querySelector('.upload-hint');

        if (textEl) textEl.textContent = file.name;
        if (hintEl) hintEl.textContent = formatFileSize(file.size);

        // Show preview
        if (preview && previewImage && previewName) {
            const reader = new FileReader();
            reader.onload = (e) => {
                previewImage.src = e.target.result;
                previewName.textContent = file.name;
                preview.style.display = 'block';
            };
            reader.readAsDataURL(file);
        }

        showNotification('success', 'Ảnh thumbnail đã được chọn thành công!');
    }
}

/**
 * FORM VALIDATION
 * Enhanced form validation với real-time feedback
 */
function initializeFormValidation() {
    const form = document.querySelector('.needs-validation');
    if (!form) return;

    // Submit validation
    form.addEventListener('submit', function(e) {
        if (!form.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();

            // Focus vào field đầu tiên có lỗi
            const firstInvalidField = form.querySelector(':invalid');
            if (firstInvalidField) {
                firstInvalidField.focus();
                firstInvalidField.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }

            showNotification('error', 'Vui lòng kiểm tra lại thông tin và sửa các lỗi!');
        }

        form.classList.add('was-validated');
    });

    // Real-time validation
    const inputs = form.querySelectorAll('input, textarea, select');
    inputs.forEach(input => {
        input.addEventListener('blur', validateField);
        input.addEventListener('input', debounce(validateField, 500));

        function validateField() {
            const isValid = input.checkValidity();

            // Remove existing classes
            input.classList.remove('is-valid', 'is-invalid');

            // Add appropriate class
            if (input.value.trim() !== '') {
                input.classList.add(isValid ? 'is-valid' : 'is-invalid');
            }

            // Custom validation cho specific fields
            if (input.id === 'name') {
                validateCourseName(input);
            } else if (input.id === 'price') {
                validatePrice(input);
            } else if (input.id === 'duration') {
                validateDuration(input);
            }
        }
    });

    // Custom validation functions
    function validateCourseName(input) {
        const value = input.value.trim();
        const feedback = input.nextElementSibling;

        if (value.length < 10) {
            setCustomValidity(input, 'Tên khóa học phải có ít nhất 10 ký tự');
        } else if (value.length > 200) {
            setCustomValidity(input, 'Tên khóa học không được quá 200 ký tự');
        } else {
            setCustomValidity(input, '');
        }
    }

    function validatePrice(input) {
        const value = parseFloat(input.value);

        if (value < 0) {
            setCustomValidity(input, 'Giá không được âm');
        } else if (value > 50000000) {
            setCustomValidity(input, 'Giá không được vượt quá 50,000,000 VNĐ');
        } else {
            setCustomValidity(input, '');
        }
    }

    function validateDuration(input) {
        const value = parseInt(input.value);

        if (value < 1) {
            setCustomValidity(input, 'Thời lượng phải lớn hơn 0');
        } else if (value > 1000) {
            setCustomValidity(input, 'Thời lượng không được vượt quá 1000 giờ');
        } else {
            setCustomValidity(input, '');
        }
    }

    function setCustomValidity(input, message) {
        input.setCustomValidity(message);

        // Update feedback text
        const feedback = input.parentElement.querySelector('.invalid-feedback');
        if (feedback && message) {
            feedback.textContent = message;
        }
    }
}

/**
 * CHARACTER COUNTERS
 * Đếm ký tự cho các input fields
 */
function initializeCharacterCounters() {
    const counters = [
        { inputId: 'name', counterId: 'nameCount', maxLength: 200 },
        { inputId: 'shortDescription', counterId: 'shortDescCount', maxLength: 500 }
    ];

    counters.forEach(({ inputId, counterId, maxLength }) => {
        const input = document.getElementById(inputId);
        const counter = document.getElementById(counterId);

        if (input && counter) {
            const updateCount = () => {
                const currentLength = input.value.length;
                counter.textContent = currentLength;

                // Update color based on usage
                if (currentLength > maxLength * 0.9) {
                    counter.style.color = '#ffc107'; // Warning
                } else if (currentLength >= maxLength) {
                    counter.style.color = '#dc3545'; // Danger
                } else {
                    counter.style.color = '#6c757d'; // Muted
                }
            };

            input.addEventListener('input', updateCount);
            updateCount(); // Initial count
        }
    });
}

/**
 * PRICE HANDLING
 * Xử lý giá tiền và định dạng
 */
function initializePriceHandling() {
    const priceInput = document.getElementById('price');
    const priceDisplay = document.getElementById('priceDisplay');
    const isFreeCheckbox = document.getElementById('isFree');

    if (!priceInput) return;

    // Format price display
    function updatePriceDisplay() {
        const value = parseFloat(priceInput.value) || 0;

        if (priceDisplay) {
            if (value === 0) {
                priceDisplay.textContent = 'Miễn phí';
                priceDisplay.className = 'text-success fw-bold';
            } else {
                priceDisplay.textContent = formatPrice(value);
                priceDisplay.className = 'text-primary fw-bold';
            }
        }
    }

    // Price input formatting
    priceInput.addEventListener('input', function(e) {
        let value = e.target.value.replace(/[^\d.]/g, '');

        // Chỉ cho phép một dấu chấm
        const parts = value.split('.');
        if (parts.length > 2) {
            value = parts[0] + '.' + parts.slice(1).join('');
        }

        e.target.value = value;
        updatePriceDisplay();
    });

    // Free course checkbox
    if (isFreeCheckbox) {
        isFreeCheckbox.addEventListener('change', function() {
            if (this.checked) {
                priceInput.value = '0';
                priceInput.disabled = true;
            } else {
                priceInput.disabled = false;
                priceInput.focus();
            }
            updatePriceDisplay();
        });
    }

    // Initial price display
    updatePriceDisplay();
}

/**
 * CATEGORY SEARCH
 * Search/filter cho danh mục
 */
function initializeCategorySearch() {
    const categorySelect = document.getElementById('categoryId');
    const categorySearch = document.getElementById('categorySearch');

    if (!categorySelect || !categorySearch) return;

    // Store original options
    const originalOptions = Array.from(categorySelect.options);

    categorySearch.addEventListener('input', function() {
        const searchTerm = this.value.toLowerCase();

        // Clear current options
        categorySelect.innerHTML = '';

        // Filter and add matching options
        const filteredOptions = originalOptions.filter(option =>
            option.text.toLowerCase().includes(searchTerm) ||
            option.value === ''
        );

        filteredOptions.forEach(option => {
            categorySelect.appendChild(option.cloneNode(true));
        });

        // Show/hide "no results" message
        if (filteredOptions.length === 1 && searchTerm.length > 0) {
            const noResultOption = new Option('Không tìm thấy danh mục phù hợp', '');
            noResultOption.disabled = true;
            categorySelect.appendChild(noResultOption);
        }
    });
}

/**
 * UTILITY FUNCTIONS
 */

// Format price với VNĐ
function formatPrice(price) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(price);
}

// Format file size
function formatFileSize(bytes) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
}

// Debounce function
function debounce(func, delay) {
    let timeoutId;
    return function (...args) {
        clearTimeout(timeoutId);
        timeoutId = setTimeout(() => func.apply(this, args), delay);
    };
}

// Show notification (requires instructor.js)
function showNotification(type, message, duration = 3000) {
    // Fallback nếu instructor.js chưa load
    if (typeof window.showNotification === 'function') {
        window.showNotification(type, message, duration);
    } else {
        // Simple alert fallback
        console.log(`${type.toUpperCase()}: ${message}`);
        if (type === 'error') {
            alert('Lỗi: ' + message);
        }
    }
}

/**
 * COURSE PREVIEW
 * Preview khóa học trước khi submit
 */
function previewCourse() {
    const formData = new FormData(document.querySelector('form'));
    const previewData = {};

    // Collect form data
    for (let [key, value] of formData.entries()) {
        previewData[key] = value;
    }

    // Get TinyMCE content
    if (typeof tinymce !== 'undefined') {
        previewData.description = tinymce.get('description')?.getContent() || '';
        previewData.requirements = tinymce.get('requirements')?.getContent() || '';
        previewData.whatYouWillLearn = tinymce.get('whatYouWillLearn')?.getContent() || '';
    }

    // Create preview modal
    createPreviewModal(previewData);
}

function createPreviewModal(data) {
    const modalHTML = `
        <div class="modal fade" id="coursePreviewModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-eye me-2"></i>Xem trước khóa học
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="course-preview">
                            <h4>${data.name || 'Tên khóa học'}</h4>
                            <p class="text-muted">${data.shortDescription || 'Mô tả ngắn'}</p>
                            
                            ${data.thumbnailFile ? `
                                <div class="mb-3">
                                    <img src="${URL.createObjectURL(data.thumbnailFile)}" 
                                         alt="Thumbnail" class="img-fluid rounded">
                                </div>
                            ` : ''}
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <strong>Giá:</strong> ${data.price ? formatPrice(parseFloat(data.price)) : 'Miễn phí'}
                                </div>
                                <div class="col-md-6">
                                    <strong>Thời lượng:</strong> ${data.duration || '0'} giờ
                                </div>
                            </div>
                            
                            <hr>
                            
                            <div class="description-content">
                                <h6>Mô tả chi tiết:</h6>
                                <div class="border p-3 rounded">${data.description || 'Chưa có mô tả'}</div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="button" class="btn btn-primary" onclick="submitForm()">
                            <i class="fas fa-save me-2"></i>Lưu khóa học
                        </button>
                    </div>
                </div>
            </div>
        </div>
    `;

    document.body.insertAdjacentHTML('beforeend', modalHTML);
    const modal = new bootstrap.Modal(document.getElementById('coursePreviewModal'));

    // Remove modal after hide
    document.getElementById('coursePreviewModal').addEventListener('hidden.bs.modal', function() {
        this.remove();
    });

    modal.show();
}

function submitForm() {
    document.querySelector('form').submit();
}

// Auto-save functionality
let autoSaveInterval;

function enableAutoSave() {
    if (autoSaveInterval) return;

    autoSaveInterval = setInterval(() => {
        const formData = new FormData(document.querySelector('form'));
        const autoSaveData = {};

        for (let [key, value] of formData.entries()) {
            if (typeof value === 'string') {
                autoSaveData[key] = value;
            }
        }

        // Get TinyMCE content
        if (typeof tinymce !== 'undefined') {
            autoSaveData.description = tinymce.get('description')?.getContent() || '';
        }

        localStorage.setItem('courseFormAutoSave', JSON.stringify(autoSaveData));
        console.log('Auto-saved at', new Date().toLocaleTimeString());
    }, 30000); // Auto-save every 30 seconds
}

function loadAutoSave() {
    const saved = localStorage.getItem('courseFormAutoSave');
    if (!saved) return;

    try {
        const data = JSON.parse(saved);

        // Confirm with user
        if (confirm('Tìm thấy dữ liệu đã lưu tự động. Bạn có muốn khôi phục không?')) {
            Object.keys(data).forEach(key => {
                const element = document.getElementById(key);
                if (element && element.type !== 'file') {
                    element.value = data[key];
                }
            });

            // Load TinyMCE content
            if (typeof tinymce !== 'undefined' && data.description) {
                tinymce.get('description')?.setContent(data.description);
            }

            showNotification('success', 'Đã khôi phục dữ liệu tự động lưu');
        }
    } catch (error) {
        console.error('Error loading auto-save data:', error);
    }
}

function clearAutoSave() {
    localStorage.removeItem('courseFormAutoSave');
    if (autoSaveInterval) {
        clearInterval(autoSaveInterval);
        autoSaveInterval = null;
    }
}

// Initialize auto-save on form changes
document.addEventListener('DOMContentLoaded', function() {
    loadAutoSave();

    const form = document.querySelector('form');
    if (form) {
        form.addEventListener('input', debounce(enableAutoSave, 1000));

        // Clear auto-save on successful submit
        form.addEventListener('submit', clearAutoSave);
    }
});

// Clear auto-save on page unload (successful navigation)
window.addEventListener('beforeunload', function() {
    // Don't clear if form has unsaved changes
    const form = document.querySelector('form');
    if (form && form.classList.contains('was-validated')) {
        clearAutoSave();
    }
});