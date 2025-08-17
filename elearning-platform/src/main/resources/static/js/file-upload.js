/**
 * FILE-UPLOAD.JS - JavaScript chung cho xử lý upload file
 * Drag & drop, progress tracking, validation và preview
 */

// Global configuration
const FileUploadConfig = {
    maxFileSize: 100 * 1024 * 1024, // 100MB default
    allowedTypes: {
        image: ['image/jpeg', 'image/png', 'image/gif', 'image/webp'],
        video: ['video/mp4', 'video/avi', 'video/mov', 'video/wmv', 'video/flv', 'video/webm'],
        document: ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            'application/vnd.ms-powerpoint', 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
            'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'],
        audio: ['audio/mp3', 'audio/wav', 'audio/ogg', 'audio/m4a']
    },
    uploadEndpoint: '/api/upload',
    chunkSize: 1024 * 1024, // 1MB chunks for large files
    retryAttempts: 3,
    autoUpload: false
};

// File upload instances
const fileUploaders = new Map();

/**
 * FileUploader Class
 * Main class để xử lý upload file với đầy đủ tính năng
 */
class FileUploader {
    constructor(container, options = {}) {
        this.container = typeof container === 'string' ? document.querySelector(container) : container;
        this.options = { ...FileUploadConfig, ...options };
        this.files = [];
        this.uploadQueue = [];
        this.isUploading = false;
        this.currentUpload = null;

        this.init();
    }

    init() {
        if (!this.container) {
            console.error('FileUploader: Container not found');
            return;
        }

        this.createUploadInterface();
        this.bindEvents();

        // Store instance
        const id = this.container.id || 'uploader_' + Date.now();
        this.container.id = id;
        fileUploaders.set(id, this);

        console.log('✅ FileUploader initialized:', id);
    }

    createUploadInterface() {
        const uploadHTML = `
            <div class="file-upload-wrapper">
                <div class="upload-area" data-state="idle">
                    <div class="upload-icon">
                        <i class="fas fa-cloud-upload-alt"></i>
                    </div>
                    <div class="upload-text">
                        <h6>Kéo thả file vào đây hoặc click để chọn</h6>
                        <p class="upload-hint">
                            ${this.getTypeHint()} - Tối đa ${this.formatFileSize(this.options.maxFileSize)}
                        </p>
                    </div>
                    <input type="file" class="file-input" ${this.options.multiple ? 'multiple' : ''} 
                           accept="${this.getAcceptTypes()}">
                </div>
                
                <div class="upload-progress" style="display: none;">
                    <div class="progress-info">
                        <span class="progress-text">Đang upload...</span>
                        <span class="progress-percent">0%</span>
                    </div>
                    <div class="progress-bar-container">
                        <div class="progress-bar" style="width: 0%"></div>
                    </div>
                    <div class="progress-details">
                        <span class="upload-speed">0 KB/s</span>
                        <span class="time-remaining">--:--</span>
                    </div>
                </div>
                
                <div class="files-list"></div>
                
                <div class="upload-actions" style="display: none;">
                    <button type="button" class="btn btn-primary btn-upload" disabled>
                        <i class="fas fa-upload me-2"></i>Upload
                    </button>
                    <button type="button" class="btn btn-outline-secondary btn-clear">
                        <i class="fas fa-times me-2"></i>Xóa tất cả
                    </button>
                </div>
            </div>
        `;

        this.container.innerHTML = uploadHTML;

        // Get references
        this.uploadArea = this.container.querySelector('.upload-area');
        this.fileInput = this.container.querySelector('.file-input');
        this.progressContainer = this.container.querySelector('.upload-progress');
        this.filesList = this.container.querySelector('.files-list');
        this.actionsContainer = this.container.querySelector('.upload-actions');
        this.uploadBtn = this.container.querySelector('.btn-upload');
        this.clearBtn = this.container.querySelector('.btn-clear');
    }

    bindEvents() {
        // Click to select files
        this.uploadArea.addEventListener('click', (e) => {
            if (e.target === this.uploadArea || this.uploadArea.contains(e.target)) {
                if (!this.isUploading) {
                    this.fileInput.click();
                }
            }
        });

        // File input change
        this.fileInput.addEventListener('change', (e) => {
            this.handleFiles(Array.from(e.target.files));
        });

        // Drag and drop events
        this.setupDragAndDrop();

        // Action buttons
        this.uploadBtn.addEventListener('click', () => this.startUpload());
        this.clearBtn.addEventListener('click', () => this.clearFiles());

        // Prevent default drag behaviors
        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
            document.addEventListener(eventName, this.preventDefaults, false);
        });
    }

    setupDragAndDrop() {
        this.uploadArea.addEventListener('dragenter', (e) => {
            e.preventDefault();
            this.uploadArea.classList.add('drag-over');
        });

        this.uploadArea.addEventListener('dragover', (e) => {
            e.preventDefault();
            this.uploadArea.classList.add('drag-over');
        });

        this.uploadArea.addEventListener('dragleave', (e) => {
            e.preventDefault();
            if (!this.uploadArea.contains(e.relatedTarget)) {
                this.uploadArea.classList.remove('drag-over');
            }
        });

        this.uploadArea.addEventListener('drop', (e) => {
            e.preventDefault();
            this.uploadArea.classList.remove('drag-over');

            if (this.isUploading) return;

            const files = Array.from(e.dataTransfer.files);
            this.handleFiles(files);
        });
    }

    handleFiles(files) {
        if (!files || files.length === 0) return;

        // Validate files
        const validFiles = files.filter(file => this.validateFile(file));

        if (validFiles.length === 0) {
            this.showNotification('error', 'Không có file hợp lệ nào được chọn');
            return;
        }

        // Add to files array
        if (this.options.multiple) {
            this.files.push(...validFiles);
        } else {
            this.files = [validFiles[0]];
        }

        // Remove duplicates
        this.files = this.removeDuplicateFiles(this.files);

        // Update UI
        this.renderFilesList();
        this.updateUploadArea();

        // Auto upload if enabled
        if (this.options.autoUpload && this.files.length > 0) {
            setTimeout(() => this.startUpload(), 500);
        }

        // Trigger custom event
        this.container.dispatchEvent(new CustomEvent('filesSelected', {
            detail: { files: this.files }
        }));
    }

    validateFile(file) {
        // Check file size
        if (file.size > this.options.maxFileSize) {
            this.showNotification('error',
                `File "${file.name}" quá lớn. Kích thước tối đa: ${this.formatFileSize(this.options.maxFileSize)}`);
            return false;
        }

        // Check file type
        if (this.options.allowedTypes && !this.isTypeAllowed(file.type)) {
            this.showNotification('error',
                `File "${file.name}" không được hỗ trợ. ${this.getTypeHint()}`);
            return false;
        }

        // Custom validation
        if (this.options.customValidator && !this.options.customValidator(file)) {
            return false;
        }

        return true;
    }

    isTypeAllowed(mimeType) {
        if (!this.options.allowedTypes) return true;

        if (Array.isArray(this.options.allowedTypes)) {
            return this.options.allowedTypes.includes(mimeType);
        }

        // Check by category
        for (const category of Object.values(this.options.allowedTypes)) {
            if (Array.isArray(category) && category.includes(mimeType)) {
                return true;
            }
        }

        return false;
    }

    removeDuplicateFiles(files) {
        const seen = new Set();
        return files.filter(file => {
            const key = `${file.name}_${file.size}_${file.lastModified}`;
            if (seen.has(key)) {
                return false;
            }
            seen.add(key);
            return true;
        });
    }

    renderFilesList() {
        if (this.files.length === 0) {
            this.filesList.innerHTML = '';
            this.actionsContainer.style.display = 'none';
            return;
        }

        const filesHTML = this.files.map((file, index) => {
            const fileType = this.getFileCategory(file.type);
            const icon = this.getFileIcon(fileType);

            return `
                <div class="file-item" data-index="${index}">
                    <div class="file-icon">
                        <i class="fas fa-${icon}"></i>
                    </div>
                    <div class="file-info">
                        <div class="file-name" title="${file.name}">${this.truncateFileName(file.name, 30)}</div>
                        <div class="file-meta">
                            ${this.formatFileSize(file.size)} • ${this.getFileCategory(file.type)}
                        </div>
                        <div class="file-progress" style="display: none;">
                            <div class="progress-bar-mini">
                                <div class="progress-fill" style="width: 0%"></div>
                            </div>
                            <span class="progress-text">0%</span>
                        </div>
                    </div>
                    <div class="file-actions">
                        <button type="button" class="btn-preview" data-index="${index}" title="Xem trước">
                            <i class="fas fa-eye"></i>
                        </button>
                        <button type="button" class="btn-remove" data-index="${index}" title="Xóa">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <div class="file-status">
                        <i class="fas fa-clock text-muted"></i>
                    </div>
                </div>
            `;
        }).join('');

        this.filesList.innerHTML = filesHTML;
        this.actionsContainer.style.display = 'block';
        this.uploadBtn.disabled = false;

        // Bind file item events
        this.bindFileItemEvents();
    }

    bindFileItemEvents() {
        // Preview buttons
        this.filesList.querySelectorAll('.btn-preview').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const index = parseInt(e.target.closest('.btn-preview').dataset.index);
                this.previewFile(this.files[index]);
            });
        });

        // Remove buttons
        this.filesList.querySelectorAll('.btn-remove').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const index = parseInt(e.target.closest('.btn-remove').dataset.index);
                this.removeFile(index);
            });
        });
    }

    previewFile(file) {
        const fileType = this.getFileCategory(file.type);

        if (fileType === 'image') {
            this.showImagePreview(file);
        } else if (fileType === 'video') {
            this.showVideoPreview(file);
        } else if (fileType === 'audio') {
            this.showAudioPreview(file);
        } else {
            this.showFileInfo(file);
        }
    }

    showImagePreview(file) {
        const reader = new FileReader();
        reader.onload = (e) => {
            const modalHTML = `
                <div class="file-preview-modal" onclick="this.remove()">
                    <div class="preview-content" onclick="event.stopPropagation()">
                        <div class="preview-header">
                            <h5>${file.name}</h5>
                            <button type="button" class="btn-close" onclick="this.closest('.file-preview-modal').remove()">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                        <div class="preview-body">
                            <img src="${e.target.result}" alt="${file.name}" style="max-width: 100%; max-height: 70vh;">
                        </div>
                        <div class="preview-footer">
                            <div class="file-details">
                                <span>Kích thước: ${this.formatFileSize(file.size)}</span>
                                <span>Loại: ${file.type}</span>
                            </div>
                        </div>
                    </div>
                </div>
            `;
            document.body.insertAdjacentHTML('beforeend', modalHTML);
        };
        reader.readAsDataURL(file);
    }

    showVideoPreview(file) {
        const url = URL.createObjectURL(file);
        const modalHTML = `
            <div class="file-preview-modal" onclick="this.remove()">
                <div class="preview-content" onclick="event.stopPropagation()">
                    <div class="preview-header">
                        <h5>${file.name}</h5>
                        <button type="button" class="btn-close" onclick="this.closest('.file-preview-modal').remove()">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <div class="preview-body">
                        <video controls style="max-width: 100%; max-height: 70vh;">
                            <source src="${url}" type="${file.type}">
                            Trình duyệt không hỗ trợ phát video.
                        </video>
                    </div>
                    <div class="preview-footer">
                        <div class="file-details">
                            <span>Kích thước: ${this.formatFileSize(file.size)}</span>
                            <span>Loại: ${file.type}</span>
                        </div>
                    </div>
                </div>
            </div>
        `;
        document.body.insertAdjacentHTML('beforeend', modalHTML);
    }

    removeFile(index) {
        this.files.splice(index, 1);
        this.renderFilesList();
        this.updateUploadArea();

        // Reset file input
        this.fileInput.value = '';

        // Trigger custom event
        this.container.dispatchEvent(new CustomEvent('fileRemoved', {
            detail: { index: index, filesCount: this.files.length }
        }));
    }

    clearFiles() {
        this.files = [];
        this.uploadQueue = [];
        this.fileInput.value = '';
        this.renderFilesList();
        this.updateUploadArea();
        this.hideProgress();

        // Trigger custom event
        this.container.dispatchEvent(new CustomEvent('filesCleared'));
    }

    updateUploadArea() {
        if (this.files.length > 0) {
            this.uploadArea.setAttribute('data-state', 'has-files');
            const text = this.uploadArea.querySelector('.upload-text h6');
            if (text) {
                text.textContent = `${this.files.length} file(s) đã chọn`;
            }
        } else {
            this.uploadArea.setAttribute('data-state', 'idle');
            const text = this.uploadArea.querySelector('.upload-text h6');
            if (text) {
                text.textContent = 'Kéo thả file vào đây hoặc click để chọn';
            }
        }
    }

    async startUpload() {
        if (this.files.length === 0 || this.isUploading) return;

        this.isUploading = true;
        this.uploadQueue = [...this.files];
        this.uploadBtn.disabled = true;
        this.uploadBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang upload...';

        this.showProgress();

        try {
            const results = [];

            for (let i = 0; i < this.uploadQueue.length; i++) {
                const file = this.uploadQueue[i];
                this.currentUpload = { file, index: i };

                this.updateFileStatus(i, 'uploading');

                const result = await this.uploadFile(file, i);
                results.push(result);

                this.updateFileStatus(i, result.success ? 'success' : 'error');
            }

            this.handleUploadComplete(results);

        } catch (error) {
            console.error('Upload error:', error);
            this.handleUploadError(error);
        } finally {
            this.isUploading = false;
            this.currentUpload = null;
        }
    }

    async uploadFile(file, index) {
        return new Promise((resolve, reject) => {
            const formData = new FormData();
            formData.append('file', file);

            // Add custom fields
            if (this.options.additionalData) {
                Object.keys(this.options.additionalData).forEach(key => {
                    formData.append(key, this.options.additionalData[key]);
                });
            }

            const xhr = new XMLHttpRequest();

            // Progress tracking
            xhr.upload.addEventListener('progress', (e) => {
                if (e.lengthComputable) {
                    const percent = Math.round((e.loaded / e.total) * 100);
                    this.updateProgress(percent, index);
                    this.updateFileProgress(index, percent);
                }
            });

            // Load tracking
            xhr.addEventListener('load', () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                    try {
                        const response = JSON.parse(xhr.responseText);
                        resolve({
                            success: true,
                            file: file,
                            response: response,
                            index: index
                        });
                    } catch (error) {
                        resolve({
                            success: true,
                            file: file,
                            response: { message: 'Upload successful' },
                            index: index
                        });
                    }
                } else {
                    resolve({
                        success: false,
                        file: file,
                        error: `HTTP ${xhr.status}: ${xhr.statusText}`,
                        index: index
                    });
                }
            });

            // Error tracking
            xhr.addEventListener('error', () => {
                resolve({
                    success: false,
                    file: file,
                    error: 'Network error occurred',
                    index: index
                });
            });

            // Timeout
            xhr.timeout = this.options.timeout || 300000; // 5 minutes
            xhr.addEventListener('timeout', () => {
                resolve({
                    success: false,
                    file: file,
                    error: 'Upload timeout',
                    index: index
                });
            });

            // Start upload
            xhr.open('POST', this.options.uploadEndpoint);

            // Add headers
            if (this.options.headers) {
                Object.keys(this.options.headers).forEach(key => {
                    xhr.setRequestHeader(key, this.options.headers[key]);
                });
            }

            xhr.send(formData);
        });
    }

    updateProgress(percent, fileIndex = null) {
        // Update overall progress
        const progressBar = this.progressContainer.querySelector('.progress-bar');
        const progressPercent = this.progressContainer.querySelector('.progress-percent');

        if (progressBar) progressBar.style.width = percent + '%';
        if (progressPercent) progressPercent.textContent = percent + '%';

        // Update file-specific progress
        if (fileIndex !== null) {
            this.updateFileProgress(fileIndex, percent);
        }
    }

    updateFileProgress(index, percent) {
        const fileItem = this.filesList.querySelector(`[data-index="${index}"]`);
        if (!fileItem) return;

        const progressContainer = fileItem.querySelector('.file-progress');
        const progressFill = fileItem.querySelector('.progress-fill');
        const progressText = fileItem.querySelector('.progress-text');

        if (progressContainer) progressContainer.style.display = 'block';
        if (progressFill) progressFill.style.width = percent + '%';
        if (progressText) progressText.textContent = percent + '%';
    }

    updateFileStatus(index, status) {
        const fileItem = this.filesList.querySelector(`[data-index="${index}"]`);
        if (!fileItem) return;

        const statusIcon = fileItem.querySelector('.file-status i');
        if (!statusIcon) return;

        statusIcon.className = 'fas ';

        switch (status) {
            case 'uploading':
                statusIcon.className += 'fa-spinner fa-spin text-primary';
                break;
            case 'success':
                statusIcon.className += 'fa-check-circle text-success';
                break;
            case 'error':
                statusIcon.className += 'fa-exclamation-circle text-danger';
                break;
            default:
                statusIcon.className += 'fa-clock text-muted';
        }
    }

    showProgress() {
        this.progressContainer.style.display = 'block';
        this.uploadArea.style.display = 'none';
    }

    hideProgress() {
        this.progressContainer.style.display = 'none';
        this.uploadArea.style.display = 'block';
    }

    handleUploadComplete(results) {
        const successCount = results.filter(r => r.success).length;
        const totalCount = results.length;

        this.hideProgress();

        if (successCount === totalCount) {
            this.showNotification('success', `Upload thành công ${totalCount} file(s)`);
        } else {
            this.showNotification('warning',
                `Upload hoàn tất: ${successCount}/${totalCount} file(s) thành công`);
        }

        // Reset UI
        this.uploadBtn.disabled = false;
        this.uploadBtn.innerHTML = '<i class="fas fa-upload me-2"></i>Upload';

        // Trigger complete event
        this.container.dispatchEvent(new CustomEvent('uploadComplete', {
            detail: { results: results, successCount: successCount, totalCount: totalCount }
        }));

        // Auto clear if all successful
        if (this.options.autoClear && successCount === totalCount) {
            setTimeout(() => this.clearFiles(), 2000);
        }
    }

    handleUploadError(error) {
        this.hideProgress();
        this.showNotification('error', 'Có lỗi xảy ra trong quá trình upload: ' + error.message);

        // Reset UI
        this.uploadBtn.disabled = false;
        this.uploadBtn.innerHTML = '<i class="fas fa-upload me-2"></i>Upload';

        // Trigger error event
        this.container.dispatchEvent(new CustomEvent('uploadError', {
            detail: { error: error }
        }));
    }

    // Utility methods
    getAcceptTypes() {
        if (!this.options.allowedTypes) return '*/*';

        if (Array.isArray(this.options.allowedTypes)) {
            return this.options.allowedTypes.join(',');
        }

        // Flatten all categories
        const allTypes = [];
        Object.values(this.options.allowedTypes).forEach(category => {
            if (Array.isArray(category)) {
                allTypes.push(...category);
            }
        });

        return allTypes.join(',');
    }

    getTypeHint() {
        if (!this.options.allowedTypes) return 'Tất cả loại file';

        if (Array.isArray(this.options.allowedTypes)) {
            return 'Hỗ trợ: ' + this.options.allowedTypes.join(', ');
        }

        const categories = Object.keys(this.options.allowedTypes);
        return 'Hỗ trợ: ' + categories.map(cat => this.capitalizeFirst(cat)).join(', ');
    }

    getFileCategory(mimeType) {
        if (mimeType.startsWith('image/')) return 'image';
        if (mimeType.startsWith('video/')) return 'video';
        if (mimeType.startsWith('audio/')) return 'audio';
        if (mimeType.includes('pdf')) return 'pdf';
        if (mimeType.includes('word') || mimeType.includes('document')) return 'document';
        if (mimeType.includes('excel') || mimeType.includes('spreadsheet')) return 'spreadsheet';
        if (mimeType.includes('powerpoint') || mimeType.includes('presentation')) return 'presentation';
        return 'file';
    }

    getFileIcon(category) {
        const icons = {
            image: 'file-image',
            video: 'file-video',
            audio: 'file-audio',
            pdf: 'file-pdf',
            document: 'file-word',
            spreadsheet: 'file-excel',
            presentation: 'file-powerpoint',
            file: 'file'
        };
        return icons[category] || 'file';
    }

    formatFileSize(bytes) {
        if (bytes === 0) return '0 Bytes';
        const k = 1024;
        const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
    }

    truncateFileName(name, maxLength) {
        if (name.length <= maxLength) return name;

        const extension = name.split('.').pop();
        const nameWithoutExt = name.substring(0, name.lastIndexOf('.'));
        const truncated = nameWithoutExt.substring(0, maxLength - extension.length - 4);

        return truncated + '...' + extension;
    }

    capitalizeFirst(str) {
        return str.charAt(0).toUpperCase() + str.slice(1);
    }

    preventDefaults(e) {
        e.preventDefault();
        e.stopPropagation();
    }

    showNotification(type, message) {
        if (typeof window.showNotification === 'function') {
            window.showNotification(type, message);
        } else {
            console.log(`${type.toUpperCase()}: ${message}`);
        }
    }

    // Public API methods
    getFiles() {
        return this.files;
    }

    addFiles(files) {
        this.handleFiles(Array.isArray(files) ? files : [files]);
    }

    removeFileByName(fileName) {
        const index = this.files.findIndex(file => file.name === fileName);
        if (index !== -1) {
            this.removeFile(index);
        }
    }

    setOption(key, value) {
        this.options[key] = value;
    }

    destroy() {
        // Remove event listeners
        this.uploadArea.removeEventListener('click', this.handleClick);
        this.fileInput.removeEventListener('change', this.handleFileInput);

        // Clear files
        this.files = [];
        this.uploadQueue = [];

        // Remove from instances map
        fileUploaders.delete(this.container.id);

        console.log('🗑️ FileUploader destroyed');
    }
}

/**
 * GLOBAL FUNCTIONS
 * Các hàm tiện ích để sử dụng FileUploader
 */

// Initialize file uploader
function initFileUploader(selector, options = {}) {
    const containers = document.querySelectorAll(selector);
    const uploaders = [];

    containers.forEach(container => {
        const uploader = new FileUploader(container, options);
        uploaders.push(uploader);
    });

    return uploaders.length === 1 ? uploaders[0] : uploaders;
}

// Get existing uploader instance
function getFileUploader(containerId) {
    return fileUploaders.get(containerId);
}

// Batch upload multiple files to different endpoints
async function batchUpload(files, endpoints, options = {}) {
    const results = [];

    for (let i = 0; i < files.length; i++) {
        const file = files[i];
        const endpoint = endpoints[i] || endpoints[0];

        try {
            const result = await uploadSingleFile(file, endpoint, options);
            results.push(result);
        } catch (error) {
            results.push({ success: false, error: error.message, file: file });
        }
    }

    return results;
}

// Upload single file
function uploadSingleFile(file, endpoint, options = {}) {
    return new Promise((resolve, reject) => {
        const formData = new FormData();
        formData.append('file', file);

        if (options.additionalData) {
            Object.keys(options.additionalData).forEach(key => {
                formData.append(key, options.additionalData[key]);
            });
        }

        const xhr = new XMLHttpRequest();

        xhr.addEventListener('load', () => {
            if (xhr.status >= 200 && xhr.status < 300) {
                try {
                    const response = JSON.parse(xhr.responseText);
                    resolve({ success: true, response: response });
                } catch (error) {
                    resolve({ success: true, response: { message: 'Upload successful' } });
                }
            } else {
                reject(new Error(`HTTP ${xhr.status}: ${xhr.statusText}`));
            }
        });

        xhr.addEventListener('error', () => {
            reject(new Error('Network error'));
        });

        if (options.onProgress) {
            xhr.upload.addEventListener('progress', options.onProgress);
        }

        xhr.open('POST', endpoint);

        if (options.headers) {
            Object.keys(options.headers).forEach(key => {
                xhr.setRequestHeader(key, options.headers[key]);
            });
        }

        xhr.send(formData);
    });
}

// Validate file before upload
function validateFileBeforeUpload(file, config = {}) {
    const errors = [];

    // Size validation
    const maxSize = config.maxSize || FileUploadConfig.maxFileSize;
    if (file.size > maxSize) {
        errors.push(`File quá lớn. Kích thước tối đa: ${formatFileSize(maxSize)}`);
    }

    // Type validation
    if (config.allowedTypes && !config.allowedTypes.includes(file.type)) {
        errors.push(`Loại file không được hỗ trợ: ${file.type}`);
    }

    // Custom validation
    if (config.customValidator && !config.customValidator(file)) {
        errors.push('File không đáp ứng yêu cầu tùy chỉnh');
    }

    return {
        isValid: errors.length === 0,
        errors: errors
    };
}

// Format file size utility
function formatFileSize(bytes) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
}

// Generate file preview
function generateFilePreview(file, callback) {
    const reader = new FileReader();

    if (file.type.startsWith('image/')) {
        reader.onload = (e) => callback(e.target.result, 'image');
        reader.readAsDataURL(file);
    } else if (file.type.startsWith('text/')) {
        reader.onload = (e) => callback(e.target.result, 'text');
        reader.readAsText(file);
    } else {
        callback(null, 'unsupported');
    }
}

// Auto-initialize on DOM ready
document.addEventListener('DOMContentLoaded', function() {
    // Auto-initialize elements with data-file-upload attribute
    const autoInitElements = document.querySelectorAll('[data-file-upload]');

    autoInitElements.forEach(element => {
        const options = {};

        // Parse data attributes
        if (element.dataset.maxSize) {
            options.maxFileSize = parseInt(element.dataset.maxSize);
        }

        if (element.dataset.allowedTypes) {
            options.allowedTypes = element.dataset.allowedTypes.split(',');
        }

        if (element.dataset.multiple !== undefined) {
            options.multiple = element.dataset.multiple !== 'false';
        }

        if (element.dataset.autoUpload !== undefined) {
            options.autoUpload = element.dataset.autoUpload === 'true';
        }

        if (element.dataset.endpoint) {
            options.uploadEndpoint = element.dataset.endpoint;
        }

        new FileUploader(element, options);
    });

    console.log('✅ FileUpload auto-initialization completed');
});

// Export for module usage
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { FileUploader, initFileUploader, getFileUploader, batchUpload };
}