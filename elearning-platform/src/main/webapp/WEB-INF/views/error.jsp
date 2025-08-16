<%--
HƯỚNG DẪN SỬA REGISTER.JSP:

1. Mở file: src/main/webapp/WEB-INF/views/register.jsp
2. Tìm dòng có class="invalid-feedback" (có nhiều chỗ)
3. Thêm style="display: none;" vào TẤT CẢ các div có class="invalid-feedback"

VÍ DỤ THAY ĐỔI:
--%>

<!-- ❌ TỪ (sai - hiển thị ngay): -->
<div class="invalid-feedback" style="display: none;">
    Vui lòng nhập họ và tên đầy đủ!
</div>

<!-- ✅ THÀNH (đúng - ẩn ban đầu): -->
<div class="invalid-feedback" style="display: none;">
    Vui lòng nhập họ và tên đầy đủ!
</div>

<%--
HOẶC CÁCH 2: Thêm CSS vào đầu file register.jsp:
--%>

<style>
    .invalid-feedback {
        display: none !important;
    }

    .form-control.is-invalid + .invalid-feedback {
        display: block !important;
    }

    .valid-feedback {
        display: none !important;
    }

    .form-control.is-valid + .valid-feedback {
        display: block !important;
    }
</style>

<%--
CÁCH 3: TÌM VÀ THAY THẾ TOÀN BỘ (KHUYẾN NGHỊ):
Sử dụng Find & Replace trong IDE:

TÌM: <div class="invalid-feedback" style="display: none;">
THAY BẰNG: <div class="invalid-feedback" style="display: none;">

TÌM: <div class="valid-feedback">
THAY BẰNG: <div class="valid-feedback" style="display: none;">
--%>

<%--
CÁCH 4: HOÀN CHỈNH - Thêm đoạn JavaScript này vào cuối file register.jsp
(trước thẻ đóng </body>):
--%>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Ẩn tất cả validation messages ban đầu
        const invalidFeedbacks = document.querySelectorAll('.invalid-feedback');
        const validFeedbacks = document.querySelectorAll('.valid-feedback');

        invalidFeedbacks.forEach(element => {
            element.style.display = 'none';
        });

        validFeedbacks.forEach(element => {
            element.style.display = 'none';
        });

        // Xóa các class validation có sẵn
        const inputs = document.querySelectorAll('.form-control');
        inputs.forEach(input => {
            input.classList.remove('is-valid', 'is-invalid');
        });

        console.log('✅ Đã ẩn validation messages ban đầu');
    });
</script>

<%--
ĐỊA CHỈ FILE CHÍNH XÁC:
src/main/webapp/WEB-INF/views/register.jsp

DÒNG CẦN TÌM (khoảng dòng 150-200):
<div class="invalid-feedback" style="display: none;">
    Vui lòng nhập họ và tên đầy đủ!
</div>

DÒNG SAU KHI SỬA:
<div class="invalid-feedback" style="display: none;">
    Vui lòng nhập họ và tên đầy đủ!
</div>

LÀM TƯƠNG TỰ CHO TẤT CẢ CÁC DÒNG có class="invalid-feedback" và "valid-feedback"
--%>