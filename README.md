# 🎓 HỆ THỐNG QUẢN LÝ KHÓA HỌC & KIỂM TRA TRỰC TUYẾN

Hệ thống quản lý khóa học và bài kiểm tra trắc nghiệm trực tuyến được xây dựng với Spring Boot, JSP và MySQL.

## 📋 TÍNH NĂNG CHÍNH

### 👥 Phân quyền người dùng
- **Admin**: Quản lý toàn hệ thống (users, categories, courses)
- **Instructor**: Tạo và quản lý khóa học, bài giảng, quiz của mình
- **Student**: Đăng ký khóa học, học bài, làm quiz và xem kết quả

### 🔧 Chức năng Admin
- ✅ CRUD người dùng (thêm, sửa, xóa, phân quyền, reset mật khẩu)
- ✅ CRUD danh mục khóa học
- ✅ Xem tổng quan tất cả khóa học trong hệ thống
- ✅ Dashboard thống kê toàn hệ thống

### 👨‍🏫 Chức năng Instructor
- ✅ CRUD khóa học của mình (nếu chưa có học viên đăng ký)
- ✅ CRUD bài giảng (text + link YouTube)
- ✅ CRUD bài kiểm tra trắc nghiệm với nhiều câu hỏi
- ✅ Xem kết quả bài kiểm tra của học viên
- ✅ Dashboard thống kê khóa học của mình

### 🎓 Chức năng Student
- ✅ Xem và đăng ký khóa học miễn phí
- ✅ Học bài giảng (text và video YouTube)
- ✅ Làm bài kiểm tra trắc nghiệm (chỉ 1 lần, hiển thị kết quả ngay)
- ✅ Xem điểm số và trạng thái hoàn thành khóa học
- ✅ Dashboard theo dõi tiến độ học tập

## 🛠️ CÔNG NGHỆ SỬ DỤNG

### Backend
- **Spring Boot 3.2.0** - Framework chính
- **Spring Security** - Xác thực và phân quyền
- **Spring Data JPA** - ORM và database operations
- **Hibernate** - ORM implementation
- **MySQL 8.0** - Database chính

### Frontend
- **JSP + JSTL** - Template engine
- **Bootstrap 5.3** - UI framework
- **Font Awesome 6.4** - Icons
- **JavaScript/jQuery** - Interactive features

### Security & Validation
- **BCrypt** - Mã hóa mật khẩu
- **Bean Validation** - Validation dữ liệu
- **CSRF Protection** - Bảo mật

## 📊 CẤU TRÚC DATABASE

```sql
-- Bảng chính
users (id, username, password, email, role, is_active, created_at, updated_at)
categories (id, name, description, created_at, updated_at)
courses (id, name, description, category_id, instructor_id, is_active, created_at, updated_at)
lessons (id, course_id, title, content, video_link, order_index, is_active, created_at, updated_at)
enrollments (id, user_id, course_id, enrolled_at, completed_at, is_completed, highest_score)
quizzes (id, course_id, title, description, duration, max_score, pass_score, is_active, created_at, updated_at)
questions (id, quiz_id, question_text, option_a, option_b, option_c, option_d, correct_option, explanation, created_at, updated_at)
quiz_results (id, quiz_id, user_id, score, correct_answers, total_questions, started_at, submitted_at, time_taken, is_passed)
```

## 🚀 HƯỚNG DẪN CÀI ĐẶT

### Yêu cầu hệ thống
- **Java 17+**
- **Maven 3.6+**
- **MySQL 8.0+**
- **IntelliJ IDEA** (khuyến nghị)

### Bước 1: Clone/Tạo project
```bash
# Tạo project Spring Boot mới trong IntelliJ
# File → New → Project → Spring Initializr
# Hoặc clone repository này
```

### Bước 2: Tạo database
```sql
CREATE DATABASE course_management;
USE course_management;
```

### Bước 3: Cấu hình application.properties
```properties
# Cập nhật thông tin database
spring.datasource.url=jdbc:mysql://localhost:3306/course_management
spring.datasource.username=root
spring.datasource.password=your_password
```

### Bước 4: Cấu hình Maven dependencies
```xml
<!-- Thêm các dependencies vào pom.xml -->
<dependencies>
    <!-- Spring Boot Starters -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-security</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    
    <!-- Database -->
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>8.0.33</version>
    </dependency>
    
    <!-- JSP Support -->
    <dependency>
        <groupId>org.apache.tomcat.embed</groupId>
        <artifactId>tomcat-embed-jasper</artifactId>
    </dependency>
    <dependency>
        <groupId>org.glassfish.web</groupId>
        <artifactId>jakarta.servlet.jsp.jstl</artifactId>
    </dependency>
    
    <!-- Validation -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-validation</artifactId>
    </dependency>
</dependencies>
```

### Bước 5: Chạy ứng dụng
```bash
# Trong IntelliJ, chạy CourseManagementApplication.java
# Hoặc sử dụng command line:
mvn spring-boot:run
```

### Bước 6: Truy cập ứng dụng
- **URL**: http://localhost:8080
- **Tài khoản admin mặc định**:
  - Username: `admin`
  - Password: `admin123`

## 👤 TÀI KHOẢN DEMO

Hệ thống tự động tạo các tài khoản demo khi khởi động:

| Role | Username | Password | Mô tả |
|------|----------|----------|-------|
| Admin | admin | admin123 | Quản trị viên hệ thống |
| Instructor | instructor1 | instructor123 | Giảng viên mẫu 1 |
| Instructor | instructor2 | instructor123 | Giảng viên mẫu 2 |
| Student | student1 | student123 | Học viên mẫu 1 |
| Student | student2 | student123 | Học viên mẫu 2 |

## 📁 CẤU TRÚC PROJECT

```
course-management-system/
├── src/main/java/com/coursemanagement/
│   ├── CourseManagementApplication.java     # Main application
│   ├── config/
│   │   ├── SecurityConfig.java              # Spring Security config
│   │   └── WebConfig.java                   # Web MVC config
│   ├── controller/
│   │   ├── AuthController.java              # Authentication
│   │   ├── AdminController.java             # Admin features
│   │   ├── InstructorController.java        # Instructor features
│   │   ├── StudentController.java           # Student features
│   │   └── HomeController.java              # Public pages
│   ├── entity/
│   │   ├── User.java                        # User entity
│   │   ├── Category.java                    # Category entity
│   │   ├── Course.java                      # Course entity
│   │   ├── Lesson.java                      # Lesson entity
│   │   ├── Enrollment.java                  # Enrollment entity
│   │   ├── Quiz.java                        # Quiz entity
│   │   ├── Question.java                    # Question entity
│   │   └── QuizResult.java                  # Quiz result entity
│   ├── repository/
│   │   ├── UserRepository.java              # User data access
│   │   ├── CategoryRepository.java          # Category data access
│   │   ├── CourseRepository.java            # Course data access
│   │   ├── LessonRepository.java            # Lesson data access
│   │   ├── EnrollmentRepository.java        # Enrollment data access
│   │   ├── QuizRepository.java              # Quiz data access
│   │   ├── QuestionRepository.java          # Question data access
│   │   └── QuizResultRepository.java        # Quiz result data access
│   ├── service/
│   │   ├── UserService.java                 # User business logic
│   │   ├── CategoryService.java             # Category business logic
│   │   ├── CourseService.java               # Course business logic
│   │   ├── LessonService.java               # Lesson business logic
│   │   ├── EnrollmentService.java           # Enrollment business logic
│   │   ├── QuizService.java                 # Quiz business logic
│   │   └── DataInitializationService.java   # Sample data initialization
│   └── dto/
│       ├── UserDto.java                     # User DTO
│       ├── CourseDto.java                   # Course DTO
│       └── QuizDto.java                     # Quiz DTO
├── src/main/resources/
│   ├── application.properties               # App configuration
│   └── static/
│       ├── css/
│       ├── js/
│       └── images/
└── src/main/webapp/WEB-INF/views/
    ├── login.jsp                            # Login page
    ├── home.jsp                             # Home page
    ├── admin/                               # Admin views
    ├── instructor/                          # Instructor views
    ├── student/                             # Student views
    ├── public/                              # Public views
    └── error/                               # Error pages
```

## 🔒 BẢO MẬT

- **Authentication**: Spring Security với BCrypt password encoding
- **Authorization**: Role-based access control (RBAC)
- **CSRF Protection**: Enabled for all forms
- **Session Management**: Secure session handling
- **Password Validation**: Minimum 6 characters
- **SQL Injection Prevention**: JPA/Hibernate parameterized queries

## 📱 RESPONSIVE DESIGN

- ✅ Mobile-first design với Bootstrap 5
- ✅ Tương thích với tất cả thiết bị (desktop, tablet, mobile)
- ✅ UI/UX thân thiện và hiện đại
- ✅ Dark/Light theme support (có thể mở rộng)

## 🧪 TESTING

```bash
# Chạy unit tests
mvn test

# Chạy integration tests
mvn verify

# Test coverage report
mvn jacoco:report
```

## 📚 API ENDPOINTS

### Authentication
- `GET /login` - Trang đăng nhập
- `POST /perform_login` - Xử lý đăng nhập
- `GET /logout` - Đăng xuất
- `GET /register` - Trang đăng ký
- `POST /register` - Xử lý đăng ký

### Admin Endpoints
- `GET /admin/dashboard` - Admin dashboard
- `GET /admin/users` - Quản lý người dùng
- `GET /admin/categories` - Quản lý danh mục
- `GET /admin/courses` - Xem tất cả khóa học

### Instructor Endpoints
- `GET /instructor/dashboard` - Instructor dashboard
- `GET /instructor/courses` - Khóa học của tôi
- `GET /instructor/courses/{id}/lessons` - Quản lý bài giảng
- `GET /instructor/courses/{id}/quizzes` - Quản lý quiz

### Student Endpoints
- `GET /student/dashboard` - Student dashboard
- `GET /student/courses` - Tìm khóa học
- `GET /student/my-courses` - Khóa học đã đăng ký
- `GET /student/my-courses/{id}/lessons/{lessonId}` - Xem bài giảng
- `GET /student/my-courses/{courseId}/quizzes/{quizId}` - Làm quiz

## 🔧 CẤU HÌNH NÂNG CAO

### Database Connection Pool
```properties
spring.datasource.hikari.maximum-pool-size=20
spring.datasource.hikari.minimum-idle=5
spring.datasource.hikari.idle-timeout=300000
```

### Logging
```properties
logging.level.com.coursemanagement=DEBUG
logging.file.name=logs/course-management.log
```

### Session Management
```properties
server.servlet.session.timeout=30m
server.servlet.session.cookie.name=COURSE_MGMT_SESSION
```

## 🚀 DEPLOYMENT

### Development
```bash
mvn spring-boot:run
```

### Production
```bash
# Build JAR file
mvn clean package

# Run with production profile
java -jar target/course-management-system-0.0.1-SNAPSHOT.war --spring.profiles.active=production
```

### Docker Deployment
```dockerfile
FROM openjdk:17-jdk-slim
COPY target/course-management-system-0.0.1-SNAPSHOT.war app.war
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.war"]
```

## 📈 MONITORING & METRICS

- **Actuator endpoints**: `/actuator/health`, `/actuator/metrics`
- **Application info**: `/actuator/info`
- **Database health check**: Tự động kiểm tra kết nối DB

## 🔄 BACKUP & RECOVERY

```sql
-- Backup database
mysqldump -u root -p course_management > backup.sql

-- Restore database
mysql -u root -p course_management < backup.sql
```

## 🤝 ĐÓNG GÓP

1. Fork project
2. Tạo feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Tạo Pull Request

## 📞 HỖ TRỢ

- **Email**: support@coursemanagement.com
- **Documentation**: Xem chi tiết trong code comments
- **Issues**: Tạo issue trên GitHub repository

## 📄 LICENSE

Distributed under the MIT License. See `LICENSE` for more information.

---

## 🎉 HOÀN THÀNH!

Hệ thống đã được xây dựng hoàn chỉnh với:
- ✅ 8 Entity classes với relationships hoàn chỉnh
- ✅ 8 Repository interfaces với custom queries
- ✅ 6 Service classes với business logic
- ✅ 5 Controller classes xử lý tất cả endpoints
- ✅ Security configuration với Spring Security
- ✅ JSP views với Bootstrap UI
- ✅ Auto data initialization
- ✅ Comprehensive error handling
- ✅ Detailed Vietnamese comments
- ✅ Production-ready configuration

**Chạy ứng dụng và trải nghiệm ngay tại: http://localhost:8080** 🚀
