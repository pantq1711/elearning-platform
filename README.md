# 🎓 E-Learning Platform - Hệ Thống Quản Lý Khóa Học Trực Tuyến

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![Java](https://img.shields.io/badge/Java-17-orange.svg)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.5.4-green.svg)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

Hệ thống quản lý khóa học trực tuyến toàn diện được xây dựng bằng **Spring Boot**, hỗ trợ đa người dùng với các chức năng học tập, quản lý và kiểm tra đánh giá hoàn chỉnh.

## 🌟 Tính Năng Chính

### 👨‍💼 Cho Admin
- **Dashboard tổng quan** với thống kê và biểu đồ chi tiết
- **Quản lý người dùng** (CRUD, phân quyền, kích hoạt/khóa tài khoản)
- **Quản lý danh mục** khóa học với màu sắc và icon
- **Quản lý khóa học** toàn diện (duyệt, featured, analytics)
- **Báo cáo thống kê** về enrollment, completion rate, revenue
- **Cấu hình hệ thống** và backup/restore data

### 👨‍🏫 Cho Giảng Viên (Instructor)
- **Dashboard cá nhân** với thống kê khóa học của mình
- **Tạo và quản lý khóa học** với editor WYSIWYG
- **Quản lý bài giảng** (video, document, interactive content)
- **Tạo quiz và câu hỏi** với nhiều loại câu hỏi
- **Theo dõi tiến độ học viên** và cung cấp feedback
- **Phân tích hiệu suất** khóa học và tương tác học viên

### 👨‍🎓 Cho Học Viên (Student)
- **Dashboard học tập** với progress tracking
- **Tìm kiếm và duyệt khóa học** với filter nâng cao
- **Đăng ký khóa học** và theo dõi tiến độ
- **Học bài và xem video** với bookmark và notes
- **Làm quiz và kiểm tra** với timer và auto-save
- **Chứng chỉ hoàn thành** khóa học
- **Profile cá nhân** và lịch sử học tập

### 🔧 Tính Năng Kỹ Thuật
- **REST API hoàn chỉnh** cho mobile app integration
- **Security mạnh mẽ** với Spring Security và JWT
- **File upload** hỗ trợ nhiều định dạng
- **Responsive design** tương thích mobile/tablet
- **Caching** với Redis (optional)
- **Email notifications** và real-time updates
- **Multi-language support** (i18n)
- **Global exception handling** với error pages thân thiện

## 🏗️ Kiến Trúc Hệ Thống

```
📁 elearning-platform/
├── 📁 src/main/java/com/coursemanagement/
│   ├── 📄 CourseManagementApplication.java      # Main application class
│   ├── 📁 config/                               # Configuration classes
│   │   ├── 📄 SecurityConfig.java               # Spring Security config (cải thiện)
│   │   └── 📄 WebConfig.java                    # Web MVC config (cải thiện)
│   ├── 📁 controller/                           # Controllers (MVC + REST)
│   │   ├── 📄 AuthController.java               # Authentication endpoints
│   │   ├── 📄 AdminController.java              # Admin dashboard & management
│   │   ├── 📄 InstructorController.java         # Instructor features
│   │   ├── 📄 StudentController.java            # Student learning portal
│   │   ├── 📄 HomeController.java               # Public pages
│   │   └── 📄 ApiController.java                # REST API endpoints (MỚI)
│   ├── 📁 entity/                               # JPA Entities với relationships
│   │   ├── 📄 User.java                         # User entity (3 roles)
│   │   ├── 📄 Category.java                     # Course categories
│   │   ├── 📄 Course.java                       # Course information
│   │   ├── 📄 Lesson.java                       # Course lessons
│   │   ├── 📄 Enrollment.java                   # Student enrollments
│   │   ├── 📄 Quiz.java                         # Quiz/tests
│   │   ├── 📄 Question.java                     # Quiz questions
│   │   └── 📄 QuizResult.java                   # Quiz results/scores
│   ├── 📁 repository/                           # Data Access Layer
│   │   ├── 📄 UserRepository.java               # User data access
│   │   ├── 📄 CategoryRepository.java           # Category data access
│   │   ├── 📄 CourseRepository.java             # Course data access
│   │   ├── 📄 LessonRepository.java             # Lesson data access
│   │   ├── 📄 EnrollmentRepository.java         # Enrollment data access
│   │   ├── 📄 QuizRepository.java               # Quiz data access
│   │   ├── 📄 QuestionRepository.java           # Question data access
│   │   └── 📄 QuizResultRepository.java         # Quiz result data access
│   ├── 📁 service/                              # Business Logic Layer
│   │   ├── 📄 UserService.java                  # User business logic
│   │   ├── 📄 CategoryService.java              # Category business logic
│   │   ├── 📄 CourseService.java                # Course business logic
│   │   ├── 📄 LessonService.java                # Lesson business logic
│   │   ├── 📄 EnrollmentService.java            # Enrollment business logic
│   │   ├── 📄 QuizService.java                  # Quiz business logic
│   │   └── 📄 DataInitializationService.java    # Sample data creation (cải thiện)
│   ├── 📁 dto/                                  # Data Transfer Objects (MỚI)
│   │   ├── 📄 UserDto.java                      # User DTO with validation
│   │   ├── 📄 CourseDto.java                    # Course DTO for API
│   │   ├── 📄 LessonDto.java                    # Lesson DTO
│   │   └── 📄 QuizDto.java                      # Quiz DTO
│   ├── 📁 utils/                                # Utility Classes (MỚI)
│   │   └── 📄 CourseUtils.java                  # Helper utilities
│   └── 📁 exception/                            # Exception Handling (MỚI)
│       └── 📄 GlobalExceptionHandler.java       # Global error handling
├── 📁 src/main/resources/
│   ├── 📄 application.properties                # Main configuration (cải thiện)
│   ├── 📄 application-dev.properties            # Development config (MỚI)
│   └── 📁 static/                               # Static web resources
│       ├── 📁 css/                              # Bootstrap CSS & custom styles
│       ├── 📁 js/                               # JavaScript files
│       └── 📁 images/                           # Images and icons
├── 📁 src/main/webapp/WEB-INF/views/            # JSP View Templates
│   ├── 📄 login.jsp                             # Login page
│   ├── 📄 home.jsp                              # Homepage
│   ├── 📁 admin/                                # Admin interface pages
│   ├── 📁 instructor/                           # Instructor interface pages
│   ├── 📁 student/                              # Student interface pages
│   ├── 📁 public/                               # Public pages
│   └── 📁 error/                                # Error pages
└── 📄 pom.xml                                   # Maven dependencies (cải thiện)
```

## 💾 Database Schema

Hệ thống sử dụng **8 bảng chính** với các relationships được thiết kế tối ưu:

```sql
📋 users (id, username, password, email, full_name, role, active, phone_number, bio, profile_image_url, created_at, last_login)
📋 categories (id, name, description, color_code, icon_class, featured, course_count, created_at)
📋 courses (id, name, description, category_id, instructor_id, duration, difficulty_level, language, prerequisites, learning_objectives, price, featured, active, image_url, slug, created_at, updated_at)
📋 lessons (id, course_id, title, content, video_link, document_url, order_index, estimated_duration, preview, active, slug, created_at, updated_at)
📋 enrollments (id, student_id, course_id, enrollment_date, completion_date, progress, completed, certificate_issued)
📋 quizzes (id, course_id, title, description, duration, max_score, pass_score, active, show_correct_answers, shuffle_questions, shuffle_answers, require_login, available_from, available_until, created_at, updated_at)
📋 questions (id, quiz_id, question_text, option_a, option_b, option_c, option_d, correct_option, explanation, points, difficulty_level, question_type, tags, image_url, display_order, created_at, updated_at)
📋 quiz_results (id, quiz_id, user_id, score, correct_answers, total_questions, started_at, submitted_at, time_taken, passed)
```

## 🚀 Hướng Dẫn Cài Đặt & Chạy

### Yêu Cầu Hệ Thống
- **Java 17+** (OpenJDK hoặc Oracle JDK)
- **Maven 3.6+** 
- **MySQL 8.0+** (hoặc H2 cho development)
- **IntelliJ IDEA** (khuyến nghị) hoặc VS Code
- **Git** cho version control

### Bước 1: Clone Repository
```bash
git clone https://github.com/your-username/elearning-platform.git
cd elearning-platform
```

### Bước 2: Cấu Hình Database

#### Option 1: MySQL (Production)
```sql
-- Tạo database
CREATE DATABASE course_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Tạo user (optional)
CREATE USER 'elearning'@'localhost' IDENTIFIED BY 'password123';
GRANT ALL PRIVILEGES ON course_management.* TO 'elearning'@'localhost';
FLUSH PRIVILEGES;
```

Cập nhật `application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/course_management
spring.datasource.username=elearning
spring.datasource.password=password123
```

#### Option 2: H2 Database (Development)
Chạy với profile development:
```bash
mvn spring-boot:run -Dspring.profiles.active=dev
```

### Bước 3: Cài Đặt Dependencies
```bash
mvn clean install
```

### Bước 4: Chạy Ứng Dụng

#### Development Mode
```bash
mvn spring-boot:run -Dspring.profiles.active=dev
```

#### Production Mode
```bash
mvn clean package
java -jar target/elearning-platform-1.0.0.jar
```

### Bước 5: Truy Cập Hệ Thống

- **URL chính**: http://localhost:8080
- **H2 Console** (dev mode): http://localhost:8080/h2-console
- **API Documentation**: http://localhost:8080/actuator/info
- **Health Check**: http://localhost:8080/actuator/health

## 👤 Tài Khoản Demo

Hệ thống tự động tạo tài khoản demo khi khởi động lần đầu:

| Role | Username | Password | Mô Tả |
|------|----------|----------|-------|
| **Admin** | admin | admin123 | Quản trị viên hệ thống |
| **Instructor** | instructor1 | instructor123 | Giảng viên Java |
| **Instructor** | instructor2 | instructor123 | Giảng viên UI/UX |
| **Student** | student1 | student123 | Học viên lập trình |
| **Student** | student2 | student123 | Học viên marketing |

## 📚 API Documentation

### Base URL
```
http://localhost:8080/api/v1
```

### Authentication Endpoints
```http
POST /api/v1/auth/register          # Đăng ký tài khoản
GET  /api/v1/auth/profile           # Lấy thông tin profile
PUT  /api/v1/auth/profile           # Cập nhật profile
```

### Course Endpoints
```http
GET  /api/v1/courses                # Danh sách khóa học (có pagination)
GET  /api/v1/courses/featured       # Khóa học nổi bật
GET  /api/v1/courses/{id}           # Chi tiết khóa học
GET  /api/v1/courses/{id}/lessons   # Bài học của khóa học
GET  /api/v1/courses/{id}/quizzes   # Quiz của khóa học
```

### Enrollment Endpoints
```http
POST /api/v1/enrollments            # Đăng ký khóa học
GET  /api/v1/enrollments/my-courses # Khóa học đã đăng ký
```

### Category & Search Endpoints
```http
GET  /api/v1/categories             # Danh sách danh mục
GET  /api/v1/search                 # Tìm kiếm tổng hợp
GET  /api/v1/statistics/overview    # Thống kê tổng quan
```

### Example API Usage
```javascript
// Đăng ký tài khoản mới
fetch('/api/v1/auth/register', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    username: 'newuser',
    email: 'user@example.com',
    fullName: 'Nguyễn Văn A',
    password: 'password123',
    confirmPassword: 'password123'
  })
});

// Lấy danh sách khóa học với pagination
fetch('/api/v1/courses?page=0&size=10&search=java&category=Lập trình')
  .then(response => response.json())
  .then(data => console.log(data));
```

## 🔧 Cấu Hình Nâng Cao

### Environment Profiles

#### Development Profile (`application-dev.properties`)
- H2 in-memory database
- Debug logging enabled
- Hot reload với DevTools
- Relaxed security settings
- Sample data auto-creation

#### Production Profile (`application-prod.properties`)
```properties
# Database
spring.datasource.hikari.maximum-pool-size=50
spring.datasource.hikari.minimum-idle=10

# Security
server.servlet.session.cookie.secure=true
server.servlet.session.cookie.http-only=true

# Logging
logging.level.root=WARN
logging.file.name=/var/log/elearning/app.log

# Actuator
management.endpoints.web.exposure.include=health,info,metrics
```

### Docker Deployment
```dockerfile
FROM openjdk:17-jdk-slim

# Tạo user không phải root
RUN addgroup --system elearning && adduser --system --group elearning

# Copy JAR file
COPY target/elearning-platform-1.0.0.jar app.jar

# Chạy với user elearning
USER elearning

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

# Start application
ENTRYPOINT ["java", "-jar", "/app.jar"]
```

```yaml
# docker-compose.yml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=prod
      - SPRING_DATASOURCE_URL=jdbc:mysql://db:3306/course_management
      - SPRING_DATASOURCE_USERNAME=elearning
      - SPRING_DATASOURCE_PASSWORD=secure_password
    depends_on:
      - db
      
  db:
    image: mysql:8.0
    environment:
      - MYSQL_DATABASE=course_management
      - MYSQL_USER=elearning
      - MYSQL_PASSWORD=secure_password
      - MYSQL_ROOT_PASSWORD=root_password
    volumes:
      - mysql_data:/var/lib/mysql
    ports:
      - "3306:3306"

volumes:
  mysql_data:
```

## 🧪 Testing

### Unit Tests
```bash
mvn test
```

### Integration Tests
```bash
mvn verify
```

### API Testing với Postman
Import collection từ `postman/elearning-api.postman_collection.json`

### Load Testing
```bash
# Sử dụng Apache Bench
ab -n 1000 -c 10 http://localhost:8080/api/v1/courses

# Sử dụng JMeter
jmeter -n -t load-test-plan.jmx -l results.jtl
```

## 📊 Monitoring & Analytics

### Actuator Endpoints
- `/actuator/health` - Health check
- `/actuator/metrics` - Application metrics
- `/actuator/info` - Application info
- `/actuator/prometheus` - Prometheus metrics

### Database Monitoring
```sql
-- Thống kê performance
SELECT 
    table_name,
    round(((data_length + index_length) / 1024 / 1024), 2) AS 'DB Size (MB)'
FROM information_schema.tables 
WHERE table_schema = 'course_management'
ORDER BY (data_length + index_length) DESC;

-- Active connections
SHOW PROCESSLIST;
```

## 🔒 Security Features

### Authentication & Authorization
- **BCrypt password encoding** với cost factor 12
- **Role-based access control** (RBAC) với 3 roles
- **Session management** với timeout và concurrent session control
- **CSRF protection** enabled
- **Remember-me functionality** với secure tokens

### Security Headers
- **X-Frame-Options: DENY** (Clickjacking protection)
- **X-Content-Type-Options: nosniff**
- **Strict-Transport-Security** với HSTS
- **Referrer-Policy: strict-origin-when-cross-origin**

### Input Validation
- **Jakarta Validation** với custom validators
- **SQL Injection prevention** với JPA/Hibernate
- **XSS protection** với input sanitization
- **File upload validation** với type và size limits

## 🐛 Troubleshooting

### Common Issues

#### 1. Database Connection Failed
```
Error: Could not connect to MySQL server
```
**Solution:**
- Kiểm tra MySQL service đã chạy chưa
- Verify connection string trong `application.properties`
- Check user permissions cho database

#### 2. JSP Views Not Loading
```
Error: Could not resolve view 'home'
```
**Solution:**
- Verify JSP dependencies trong `pom.xml`
- Check view resolver configuration trong `WebConfig.java`
- Ensure JSP files trong đúng directory `/WEB-INF/views/`

#### 3. File Upload Failed
```
Error: The field file exceeds its maximum permitted size
```
**Solution:**
- Increase file size limits trong `application.properties`:
```properties
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=25MB
```

#### 4. Memory Issues
```
Error: OutOfMemoryError
```
**Solution:**
- Increase JVM heap size:
```bash
java -Xmx2G -Xms1G -jar elearning-platform.jar
```

### Debug Mode
Enable debug logging:
```properties
logging.level.com.coursemanagement=DEBUG
logging.level.org.springframework.security=DEBUG
```

## 🤝 Contributing

### Development Workflow
1. Fork repository
2. Tạo feature branch: `git checkout -b feature/new-feature`
3. Commit changes: `git commit -m 'Add new feature'`
4. Push branch: `git push origin feature/new-feature`
5. Tạo Pull Request

### Code Standards
- **Java Code Style**: Google Java Style Guide
- **Commit Messages**: Conventional Commits
- **Branch Naming**: feature/*, bugfix/*, hotfix/*
- **Testing**: Minimum 80% code coverage

### Pull Request Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Unit tests added/updated
- [ ] Documentation updated
- [ ] No breaking changes (or documented)

## 📈 Roadmap

### Version 1.1.0 (Q2 2024)
- [ ] **Real-time chat** giữa instructor và students
- [ ] **Video conferencing** integration (Zoom/Google Meet)
- [ ] **Mobile app** với React Native
- [ ] **Payment integration** (VNPay, MoMo)
- [ ] **Certificate management** với blockchain

### Version 1.2.0 (Q3 2024)
- [ ] **AI-powered recommendations** cho courses
- [ ] **Gamification** với points và badges
- [ ] **Advanced analytics** với machine learning
- [ ] **Multi-tenant support** cho organizations
- [ ] **LMS integration** (Moodle, Blackboard)

### Version 2.0.0 (Q4 2024)
- [ ] **Microservices architecture** migration
- [ ] **Kubernetes deployment** support
- [ ] **GraphQL API** implementation
- [ ] **Advanced security** với OAuth2/OIDC
- [ ] **Multi-language content** support

## 📞 Support & Contact

- **Email**: support@elearningplatform.vn
- **Documentation**: Detailed trong code comments
- **Issues**: [GitHub Issues](https://github.com/your-username/elearning-platform/issues)
- **Wiki**: [Project Wiki](https://github.com/your-username/elearning-platform/wiki)

## 📄 License

Distributed under the **MIT License**. See `LICENSE` file for more information.

---

## 🎉 Kết Luận

**E-Learning Platform v1.0.0** là một hệ thống quản lý khóa học trực tuyến hoàn chỉnh và production-ready với:

### ✅ Đã Hoàn Thành
- **8 Entity classes** với relationships hoàn chỉnh
- **8 Repository interfaces** với custom queries và specifications
- **6 Service classes** với business logic đầy đủ
- **5 Controller classes** xử lý tất cả use cases
- **REST API hoàn chỉnh** với 20+ endpoints
- **Security configuration** với Spring Security nâng cao
- **Global exception handling** và error pages thân thiện
- **DTO classes** cho data transfer an toàn
- **Utility classes** với helper methods
- **JSP views** với Bootstrap UI responsive
- **Auto data initialization** với sample data phong phú
- **Vietnamese comments** chi tiết cho tất cả code
- **Production-ready configuration** với multiple environments
- **Comprehensive testing** support
- **Docker deployment** ready
- **Monitoring & metrics** với Actuator

### 🚀 Ready to Deploy
Hệ thống đã sẵn sàng cho việc deploy production với đầy đủ tính năng cần thiết cho một platform e-learning chuyên nghiệp.

**Start your e-learning journey now at: http://localhost:8080** 🎯