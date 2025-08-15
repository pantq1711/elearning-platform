#!/bin/bash
# Script: fix_jsp_compilation.sh
# Khắc phục JSP compilation errors

echo "🔧 Khắc phục JSP compilation errors..."

# Dọn dẹp JSP compiled classes
echo "📁 Dọn dẹp JSP compiled files..."
rm -rf target/tomcat/work/
rm -rf target/classes/
find . -name "*.class" -path "*/jsp/*" -delete

# Kiểm tra JSP syntax errors
echo "🔍 Kiểm tra JSP syntax..."

# Tìm các JSP có thể có syntax error
find src/main/webapp/WEB-INF/views -name "*.jsp" -exec echo "Checking: {}" \;

# Kiểm tra các lỗi thường gặp trong JSP
echo "⚠️ Kiểm tra các lỗi JSP thường gặp:"

# 1. Kiểm tra taglib declarations
echo "1. Kiểm tra taglib declarations..."
grep -r "<%@ taglib" src/main/webapp/WEB-INF/views/ | grep -v "uri=" && echo "❌ Missing URI in taglib" || echo "✅ Taglib OK"

# 2. Kiểm tra unclosed tags
echo "2. Kiểm tra unclosed tags..."
find src/main/webapp/WEB-INF/views -name "*.jsp" -exec grep -l "<c:if.*>" {} \; | while read file; do
    if_count=$(grep -o "<c:if" "$file" | wc -l)
    endif_count=$(grep -o "</c:if>" "$file" | wc -l)
    if [ "$if_count" -ne "$endif_count" ]; then
        echo "❌ Unclosed <c:if> in $file (open: $if_count, close: $endif_count)"
    fi
done

# 3. Kiểm tra missing closing brackets
echo "3. Kiểm tra missing closing brackets..."
find src/main/webapp/WEB-INF/views -name "*.jsp" -exec grep -l '\${' {} \; | while read file; do
    open_count=$(grep -o '\${' "$file" | wc -l)
    close_count=$(grep -o '}' "$file" | wc -l)
    if [ "$open_count" -gt "$close_count" ]; then
        echo "❌ Missing closing } in $file"
    fi
done

# 4. Kiểm tra form tags
echo "4. Kiểm tra form tags..."
find src/main/webapp/WEB-INF/views -name "*.jsp" -exec grep -l "form:form" {} \; | while read file; do
    form_open=$(grep -o "<form:form" "$file" | wc -l)
    form_close=$(grep -o "</form:form>" "$file" | wc -l)
    if [ "$form_open" -ne "$form_close" ]; then
        echo "❌ Unclosed <form:form> in $file"
    fi
done

# Tạo backup của các JSP files quan trọng
echo "💾 Tạo backup JSP files..."
backup_dir="jsp_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir"
cp -r src/main/webapp/WEB-INF/views/*.jsp "$backup_dir/" 2>/dev/null || true

# Tái tạo target directory
echo "🏗️ Tái tạo target directory..."
mvn clean compile -q

echo "✅ Hoàn thành kiểm tra JSP!"
echo ""
echo "📋 Hướng dẫn tiếp theo:"
echo "1. Kiểm tra các lỗi được báo cáo ở trên"
echo "2. Sửa các JSP files có lỗi"
echo "3. Chạy: mvn clean package"
echo "4. Khởi động lại server"
echo ""
echo "🔗 Backup files trong: $backup_dir"