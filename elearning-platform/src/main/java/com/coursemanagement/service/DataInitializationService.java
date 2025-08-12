package com.coursemanagement.service;

import com.coursemanagement.entity.*;
import com.coursemanagement.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.PostConstruct;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * Service khởi tạo dữ liệu mẫu cho hệ thống e-learning
 * Tự động chạy khi ứng dụng khởi động và tạo data demo
 * Cải thiện với dữ liệu phong phú và realistic hơn
 */
@Service
@Transactional
public class DataInitializationService {

    @Autowired private UserRepository userRepository;
    @Autowired private CategoryRepository categoryRepository;
    @Autowired private CourseRepository courseRepository;
    @Autowired private LessonRepository lessonRepository;
    @Autowired private QuizRepository quizRepository;
    @Autowired private QuestionRepository questionRepository;
    @Autowired private EnrollmentRepository enrollmentRepository;
    @Autowired private PasswordEncoder passwordEncoder;

    private Random random = new Random();

    /**
     * Method chính để khởi tạo tất cả dữ liệu mẫu
     * Chạy ngay sau khi ApplicationContext được load
     */
    @PostConstruct
    public void initializeData() {
        try {
            System.out.println("🚀 Bắt đầu khởi tạo dữ liệu mẫu cho hệ thống e-learning...");

            createSampleUsers();
            createSampleCategories();
            createSampleCourses();
            createSampleLessons();
            createSampleQuizzes();
            createSampleEnrollments();

            System.out.println("✅ Khởi tạo dữ liệu mẫu hoàn thành!");
            printSystemStatistics();

        } catch (Exception e) {
            System.err.println("❌ Lỗi khi khởi tạo dữ liệu mẫu: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Tạo người dùng mẫu với các role khác nhau
     * Bao gồm admin, giảng viên và học viên
     */
    private void createSampleUsers() {
        System.out.println("👥 Tạo người dùng mẫu...");

        try {
            // Kiểm tra đã có admin chưa
            if (userRepository.findByUsername("admin").isPresent()) {
                System.out.println("⚠️ Dữ liệu người dùng đã tồn tại, bỏ qua...");
                return;
            }

            // Tạo tài khoản Admin
            User admin = new User();
            admin.setUsername("admin");
            admin.setPassword(passwordEncoder.encode("admin123"));
            admin.setEmail("admin@elearning.vn");
            admin.setFullName("Quản trị viên hệ thống");
            admin.setRole(User.Role.ADMIN);
            admin.setActive(true);
            admin.setPhoneNumber("0901234567");
            admin.setBio("Quản trị viên chính của hệ thống e-learning platform");
            userRepository.save(admin);

            // Tạo các giảng viên mẫu với thông tin chi tiết
            String[][] instructorData = {
                    {"instructor1", "Nguyễn Văn An", "nguyenvanan@elearning.vn", "0902345678",
                            "Giảng viên lập trình với 10 năm kinh nghiệm trong Java và Spring Framework"},
                    {"instructor2", "Trần Thị Bình", "tranthibinh@elearning.vn", "0903456789",
                            "Chuyên gia thiết kế UI/UX với nhiều dự án thực tế cho các công ty lớn"},
                    {"instructor3", "Lê Hoàng Công", "lehoangcong@elearning.vn", "0904567890",
                            "Digital Marketing Expert với chứng chỉ Google Ads và Facebook Blueprint"},
                    {"instructor4", "Phạm Thị Dung", "phamthidung@elearning.vn", "0905678901",
                            "Giảng viên tiếng Anh với bằng TESOL và kinh nghiệm giảng dạy IELTS"},
                    {"instructor5", "Hoàng Văn Minh", "hoangvanminh@elearning.vn", "0906789012",
                            "Business Analyst với MBA và kinh nghiệm quản lý dự án tại các tập đoàn"}
            };

            for (String[] data : instructorData) {
                User instructor = new User();
                instructor.setUsername(data[0]);
                instructor.setPassword(passwordEncoder.encode("instructor123"));
                instructor.setFullName(data[1]);
                instructor.setEmail(data[2]);
                instructor.setRole(User.Role.INSTRUCTOR);
                instructor.setActive(true);
                instructor.setPhoneNumber(data[3]);
                instructor.setBio(data[4]);
                userRepository.save(instructor);
            }

            // Tạo học viên mẫu với đa dạng background
            String[][] studentData = {
                    {"student1", "Nguyễn Minh Tuấn", "tuannguyen@gmail.com", "0907890123",
                            "Sinh viên năm 3 ngành Công nghệ thông tin, đam mê lập trình web"},
                    {"student2", "Trần Thị Hoa", "hoatran@gmail.com", "0908901234",
                            "Nhân viên marketing muốn nâng cao kỹ năng digital marketing"},
                    {"student3", "Lê Văn Bách", "bachle@gmail.com", "0909012345",
                            "Thiết kế đồ họa freelancer muốn học UI/UX design"},
                    {"student4", "Phạm Thị Lan", "lanpham@gmail.com", "0900123456",
                            "Giáo viên tiếng Anh muốn cải thiện kỹ năng giao tiếp"},
                    {"student5", "Nguyễn Hoàng Duy", "duynguyen@gmail.com", "0901234567",
                            "Chủ cửa hàng nhỏ muốn học kinh doanh và quản lý"},
                    {"student6", "Trần Minh Châu", "chautran@gmail.com", "0902345678",
                            "Fresh graduate muốn học lập trình để xin việc"},
                    {"student7", "Lê Thị Mai", "maile@gmail.com", "0903456789",
                            "Nhân viên kế toán muốn chuyển sang phân tích dữ liệu"},
                    {"student8", "Phạm Văn Nam", "nampham@gmail.com", "0904567890",
                            "Developer junior muốn nâng cao kỹ năng Java và Spring"}
            };

            for (String[] data : studentData) {
                User student = new User();
                student.setUsername(data[0]);
                student.setPassword(passwordEncoder.encode("student123"));
                student.setFullName(data[1]);
                student.setEmail(data[2]);
                student.setRole(User.Role.STUDENT);
                student.setActive(true);
                student.setPhoneNumber(data[3]);
                student.setBio(data[4]);
                userRepository.save(student);
            }

            System.out.println("✅ Đã tạo " + (1 + instructorData.length + studentData.length) + " người dùng mẫu");

        } catch (Exception e) {
            System.err.println("❌ Lỗi tạo người dùng mẫu: " + e.getMessage());
        }
    }

    /**
     * Tạo danh mục khóa học với màu sắc và icon phù hợp
     */
    private void createSampleCategories() {
        System.out.println("📁 Tạo danh mục khóa học...");

        try {
            if (categoryRepository.count() > 0) {
                System.out.println("⚠️ Dữ liệu danh mục đã tồn tại, bỏ qua...");
                return;
            }

            String[][] categoryData = {
                    {"Lập trình", "Các khóa học về lập trình và phát triển phần mềm, từ cơ bản đến nâng cao", "#007bff", "fas fa-code"},
                    {"Thiết kế", "Khóa học thiết kế đồ họa, UI/UX và sáng tạo nghệ thuật số", "#28a745", "fas fa-palette"},
                    {"Marketing", "Digital marketing, SEO, SEM, Social Media và chiến lược bán hàng", "#ffc107", "fas fa-bullhorn"},
                    {"Ngoại ngữ", "Học tiếng Anh, tiếng Nhật, tiếng Hàn và các ngôn ngữ quốc tế khác", "#17a2b8", "fas fa-language"},
                    {"Kinh doanh", "Quản lý, khởi nghiệp, phát triển doanh nghiệp và kỹ năng lãnh đạo", "#6c757d", "fas fa-briefcase"},
                    {"Kỹ năng mềm", "Kỹ năng giao tiếp, thuyết trình, phát triển bản thân và tư duy sáng tạo", "#e83e8c", "fas fa-user-graduate"},
                    {"Công nghệ", "AI, Machine Learning, Data Science và các công nghệ mới nhất", "#6f42c1", "fas fa-robot"},
                    {"Nghệ thuật", "Âm nhạc, hội họa, nhiếp ảnh và các nghệ thuật sáng tạo", "#fd7e14", "fas fa-camera"}
            };

            for (String[] data : categoryData) {
                Category category = new Category();
                category.setName(data[0]);
                category.setDescription(data[1]);
                category.setColorCode(data[2]);
                category.setIconClass(data[3]);
                category.setFeatured(true);
                categoryRepository.save(category);
            }

            System.out.println("✅ Đã tạo " + categoryData.length + " danh mục mẫu");

        } catch (Exception e) {
            System.err.println("❌ Lỗi tạo danh mục mẫu: " + e.getMessage());
        }
    }

    /**
     * Tạo khóa học mẫu với thông tin chi tiết và realistic
     */
    private void createSampleCourses() {
        System.out.println("📚 Tạo khóa học mẫu...");

        try {
            if (courseRepository.count() > 0) {
                System.out.println("⚠️ Dữ liệu khóa học đã tồn tại, bỏ qua...");
                return;
            }

            List<Category> categories = categoryRepository.findAll();
            List<User> instructors = userRepository.findByRole(User.Role.INSTRUCTOR);

            if (categories.isEmpty() || instructors.isEmpty()) {
                System.out.println("⚠️ Chưa có danh mục hoặc giảng viên, bỏ qua tạo khóa học");
                return;
            }

            // Dữ liệu khóa học phong phú và realistic
            Object[][] courseData = {
                    {"Lập trình Java từ Zero đến Hero",
                            "Khóa học Java toàn diện từ cơ bản đến nâng cao, bao gồm OOP, Collections, Streams, Spring Framework và xây dựng ứng dụng thực tế.",
                            "Lập trình", 80, Course.DifficultyLevel.INTERMEDIATE, 1499000.0, true,
                            "Biết sử dụng máy tính cơ bản",
                            "Thành thạo Java Core, OOP, Spring Boot, MySQL, có thể xây dựng web application hoàn chỉnh"},

                    {"UI/UX Design với Figma Pro",
                            "Tìm hiểu các nguyên tắc thiết kế UI/UX và thực hành với công cụ Figma chuyên nghiệp, từ wireframe đến prototype hoàn chỉnh.",
                            "Thiết kế", 45, Course.DifficultyLevel.BEGINNER, 899000.0, true,
                            "Không cần kinh nghiệm trước đó",
                            "Thiết kế được giao diện app/web, thành thạo Figma, hiểu về User Experience"},

                    {"Digital Marketing Mastery 2024",
                            "Khóa học marketing số toàn diện, bao gồm SEO, Google Ads, Facebook Ads, Content Marketing và Analytics với case study thực tế.",
                            "Marketing", 60, Course.DifficultyLevel.INTERMEDIATE, 1299000.0, true,
                            "Biết sử dụng internet và mạng xã hội",
                            "Lập và thực hiện chiến lược marketing số, chạy quảng cáo hiệu quả, phân tích ROI"},

                    {"Tiếng Anh giao tiếp Business",
                            "Khóa học tiếng Anh giao tiếp trong môi trường doanh nghiệp, presentation, negotiation và email writing chuyên nghiệp.",
                            "Ngoại ngữ", 100, Course.DifficultyLevel.INTERMEDIATE, 1199000.0, false,
                            "Tiếng Anh cơ bản (A2 trở lên)",
                            "Giao tiếp tự tin trong meeting, thuyết trình, viết email chuyên nghiệp"},

                    {"Startup & Quản lý dự án Agile",
                            "Học các phương pháp khởi nghiệp hiện đại, quản lý dự án với Agile/Scrum, xây dựng team và scale-up doanh nghiệp.",
                            "Kinh doanh", 50, Course.DifficultyLevel.ADVANCED, 1899000.0, true,
                            "Có ý tưởng kinh doanh hoặc đang làm việc trong team",
                            "Xây dựng business plan, quản lý team hiệu quả, ứng dụng Agile/Scrum"},

                    {"Thuyết trình và Public Speaking",
                            "Phát triển kỹ năng thuyết trình và giao tiếp trước đám đông một cách tự tin, từ cơ bản đến nâng cao.",
                            "Kỹ năng mềm", 30, Course.DifficultyLevel.BEGINNER, 699000.0, false,
                            "Không cần kinh nghiệm",
                            "Thuyết trình tự tin, structure nội dung hiệu quả, xử lý Q&A"},

                    {"Python cho Data Science",
                            "Học Python để phân tích dữ liệu với Pandas, NumPy, Matplotlib và Machine Learning với Scikit-learn, bao gồm dự án thực tế.",
                            "Công nghệ", 90, Course.DifficultyLevel.INTERMEDIATE, 1699000.0, true,
                            "Biết toán cơ bản và logic tư duy",
                            "Phân tích dữ liệu với Python, xây dựng mô hình ML cơ bản, visualization"},

                    {"Adobe Photoshop từ A-Z",
                            "Khóa học Photoshop toàn diện cho thiết kế đồ họa và chỉnh sửa ảnh chuyên nghiệp, từ tools cơ bản đến kỹ thuật nâng cao.",
                            "Nghệ thuật", 55, Course.DifficultyLevel.BEGINNER, 999000.0, false,
                            "Có máy tính và Photoshop",
                            "Chỉnh sửa ảnh chuyên nghiệp, thiết kế poster, banner, hiệu ứng đặc biệt"},

                    {"Machine Learning cơ bản",
                            "Giới thiệu Machine Learning với Python, các thuật toán cơ bản, và ứng dụng thực tế trong business.",
                            "Công nghệ", 70, Course.DifficultyLevel.ADVANCED, 2199000.0, true,
                            "Biết Python cơ bản, toán học đại cương",
                            "Hiểu và ứng dụng ML algorithms, xây dựng model predictions"},

                    {"Facebook Ads Advanced",
                            "Chiến lược quảng cáo Facebook nâng cao, tối ưu hóa ROI, custom audience và retargeting với budget optimization.",
                            "Marketing", 35, Course.DifficultyLevel.ADVANCED, 1599000.0, true,
                            "Đã chạy Facebook Ads cơ bản",
                            "Tối ưu campaigns hiệu quả, scale budget, giảm cost per acquisition"}
            };

            for (Object[] data : courseData) {
                Course course = new Course();
                course.setName((String) data[0]);
                course.setDescription((String) data[1]);
                course.setDuration((Integer) data[3]);
                course.setDifficultyLevel((Course.DifficultyLevel) data[4]);
                course.setPrice((Double) data[5]);
                course.setFeatured((Boolean) data[6]);
                course.setPrerequisites((String) data[7]);
                course.setLearningObjectives((String) data[8]);
                course.setActive(true);
                course.setLanguage("Vietnamese");

                // Tìm category phù hợp
                String categoryName = (String) data[2];
                Category category = categories.stream()
                        .filter(c -> c.getName().contains(categoryName))
                        .findFirst()
                        .orElse(categories.get(0));
                course.setCategory(category);

                // Random instructor
                User instructor = instructors.get(random.nextInt(instructors.size()));
                course.setInstructor(instructor);

                courseRepository.save(course);
            }

            System.out.println("✅ Đã tạo " + courseData.length + " khóa học mẫu");

        } catch (Exception e) {
            System.err.println("❌ Lỗi tạo khóa học mẫu: " + e.getMessage());
        }
    }

    /**
     * Tạo bài giảng cho từng khóa học
     */
    private void createSampleLessons() {
        System.out.println("📝 Tạo bài giảng mẫu...");

        try {
            List<Course> courses = courseRepository.findAll();
            if (courses.isEmpty()) {
                System.out.println("⚠️ Chưa có khóa học, bỏ qua tạo bài giảng");
                return;
            }

            for (Course course : courses) {
                String courseName = course.getName();
                String[][] lessonData;

                if (courseName.contains("Java")) {
                    lessonData = new String[][]{
                            {"Giới thiệu về Java và cài đặt môi trường",
                                    "Tìm hiểu lịch sử Java, đặc điểm của ngôn ngữ và hướng dẫn cài đặt JDK, IDE để bắt đầu lập trình.",
                                    "https://www.youtube.com/watch?v=eIrMbAQSU34"},
                            {"Cú pháp cơ bản và biến trong Java",
                                    "Học cú pháp cơ bản, cách khai báo biến, các kiểu dữ liệu primitive và reference trong Java.",
                                    null},
                            {"Cấu trúc điều khiển và vòng lặp",
                                    "If-else, switch-case, for, while, do-while và các cấu trúc điều khiển khác trong Java.",
                                    "https://www.youtube.com/watch?v=YEhDbWaKAXM"},
                            {"Lập trình hướng đối tượng - Classes và Objects",
                                    "Khái niệm OOP, cách tạo class, object, constructor và methods trong Java.",
                                    null},
                            {"Inheritance và Polymorphism",
                                    "Kế thừa, đa hình và các nguyên tắc OOP nâng cao trong Java.",
                                    "https://www.youtube.com/watch?v=Cr_U6DyWtWM"},
                            {"Exception Handling và File I/O",
                                    "Xử lý ngoại lệ với try-catch-finally, đọc ghi file và stream trong Java.",
                                    null},
                            {"Collections Framework",
                                    "ArrayList, LinkedList, HashMap, TreeSet và các collection quan trọng trong Java.",
                                    null},
                            {"Lambda Expressions và Stream API",
                                    "Functional programming với lambda, stream operations để xử lý data hiệu quả.",
                                    null}
                    };
                } else if (courseName.contains("UI/UX") || courseName.contains("Figma")) {
                    lessonData = new String[][]{
                            {"Nguyên tắc thiết kế UI/UX cơ bản",
                                    "Tìm hiểu về User Interface, User Experience và các nguyên tắc thiết kế cơ bản.",
                                    null},
                            {"Giới thiệu Figma và interface",
                                    "Làm quen với giao diện Figma, các tools cơ bản và setup workspace.",
                                    "https://www.youtube.com/watch?v=FTlczfBm7bk"},
                            {"Thiết kế Wireframe và Prototype",
                                    "Tạo wireframe cho app/web, low-fidelity và high-fidelity prototype.",
                                    null},
                            {"Color Theory và Typography",
                                    "Lý thuyết màu sắc, cách phối màu và chọn font chữ phù hợp cho design.",
                                    null},
                            {"Component Design System",
                                    "Xây dựng design system với component, style guide và maintain consistency.",
                                    null},
                            {"User Research và Testing",
                                    "Phương pháp nghiên cứu người dùng, A/B testing và thu thập feedback.",
                                    null}
                    };
                } else if (courseName.contains("Python")) {
                    lessonData = new String[][]{
                            {"Python Fundamentals",
                                    "Cú pháp Python cơ bản, variables, data types và control structures.",
                                    "https://www.youtube.com/watch?v=_uQrJ0TkZlc"},
                            {"Pandas cho Data Manipulation",
                                    "Làm việc với DataFrame, Series, đọc CSV/Excel và data cleaning với Pandas.",
                                    null},
                            {"NumPy cho Scientific Computing",
                                    "Arrays, mathematical operations và linear algebra với NumPy.",
                                    null},
                            {"Data Visualization với Matplotlib",
                                    "Tạo charts, plots và visualization đẹp với Matplotlib và Seaborn.",
                                    null},
                            {"Machine Learning với Scikit-learn",
                                    "Regression, classification và clustering với scikit-learn library.",
                                    null},
                            {"Project: Phân tích dữ liệu thực tế",
                                    "Dự án thực hành phân tích dataset thực tế từ A-Z.",
                                    null}
                    };
                } else {
                    // Bài giảng chung cho các khóa học khác
                    lessonData = new String[][]{
                            {"Bài 1: Giới thiệu khóa học",
                                    "Tổng quan về nội dung, mục tiêu và lộ trình học tập của khóa học.",
                                    null},
                            {"Bài 2: Kiến thức nền tảng",
                                    "Những kiến thức cơ bản và prerequisite cần thiết cho khóa học.",
                                    null},
                            {"Bài 3: Thực hành cơ bản",
                                    "Bài tập và thực hành đầu tiên để làm quen với nội dung khóa học.",
                                    null},
                            {"Bài 4: Kỹ thuật nâng cao",
                                    "Phát triển kỹ năng ở mức độ nâng cao với case study thực tế.",
                                    null},
                            {"Bài 5: Dự án tổng hợp",
                                    "Thực hiện dự án cuối khóa để áp dụng toàn bộ kiến thức đã học.",
                                    null}
                    };
                }

                for (int i = 0; i < lessonData.length; i++) {
                    Lesson lesson = new Lesson();
                    lesson.setTitle(lessonData[i][0]);
                    lesson.setContent(lessonData[i][1]);
                    lesson.setVideoLink(lessonData[i][2]);
                    lesson.setCourse(course);
                    lesson.setOrderIndex(i + 1);
                    lesson.setActive(true);
                    lesson.setEstimatedDuration(30 + (i * 5) + random.nextInt(15)); // 30-70 phút
                    lesson.setPreview(i == 0); // Bài đầu cho preview miễn phí

                    lessonRepository.save(lesson);
                }
            }

            System.out.println("✅ Đã tạo bài giảng cho tất cả khóa học");

        } catch (Exception e) {
            System.err.println("❌ Lỗi tạo bài giảng mẫu: " + e.getMessage());
        }
    }

    /**
     * Tạo quiz và câu hỏi cho từng khóa học
     */
    private void createSampleQuizzes() {
        System.out.println("❓ Tạo quiz và câu hỏi mẫu...");

        try {
            List<Course> courses = courseRepository.findAll();
            if (courses.isEmpty()) return;

            for (Course course : courses) {
                // Tạo 2 quiz cho mỗi khóa học
                for (int quizIndex = 1; quizIndex <= 2; quizIndex++) {
                    Quiz quiz = new Quiz();
                    quiz.setTitle("Kiểm tra " + (quizIndex == 1 ? "giữa khóa" : "cuối khóa") + " - " + course.getName());
                    quiz.setDescription("Bài kiểm tra " + (quizIndex == 1 ? "đánh giá kiến thức cơ bản" : "tổng hợp toàn khóa"));
                    quiz.setDuration(quizIndex == 1 ? 30 : 60); // 30 hoặc 60 phút
                    quiz.setMaxScore(100.0);
                    quiz.setPassScore(70.0);
                    quiz.setActive(true);
                    quiz.setShowCorrectAnswers(true);
                    quiz.setShuffleQuestions(true);
                    quiz.setRequireLogin(true);
                    quiz.setCourse(course);

                    Quiz savedQuiz = quizRepository.save(quiz);

                    // Tạo câu hỏi cho quiz
                    createQuestionsForQuiz(savedQuiz, course.getName());
                }
            }

            System.out.println("✅ Đã tạo quiz và câu hỏi cho tất cả khóa học");

        } catch (Exception e) {
            System.err.println("❌ Lỗi tạo quiz mẫu: " + e.getMessage());
        }
    }

    /**
     * Tạo câu hỏi specific cho từng quiz dựa trên tên khóa học
     */
    private void createQuestionsForQuiz(Quiz quiz, String courseName) {
        String[][] questionData;

        if (courseName.contains("Java")) {
            questionData = new String[][]{
                    {"Java là ngôn ngữ lập trình thuộc loại nào?",
                            "Compiled", "Interpreted", "Compiled và Interpreted", "Assembly", "C"},
                    {"Từ khóa nào được sử dụng để kế thừa trong Java?",
                            "implements", "extends", "inherits", "super", "B"},
                    {"Phương thức main trong Java có đặc điểm gì?",
                            "Private và static", "Public và dynamic", "Public và static", "Protected và final", "C"},
                    {"JVM viết tắt của cụm từ nào?",
                            "Java Virtual Machine", "Java Variable Method", "Java Version Manager", "Java Visual Mode", "A"},
                    {"Kiểu dữ liệu nào là primitive type trong Java?",
                            "String", "ArrayList", "int", "Scanner", "C"}
            };
        } else if (courseName.contains("UI/UX") || courseName.contains("Figma")) {
            questionData = new String[][]{
                    {"UX viết tắt của cụm từ nào?",
                            "User Experience", "User Extension", "Unique Experience", "Universal Extension", "A"},
                    {"Wireframe trong thiết kế UI/UX là gì?",
                            "Màu sắc giao diện", "Bản phác thảo khung giao diện", "Font chữ sử dụng", "Hiệu ứng animation", "B"},
                    {"Figma là công cụ dùng để làm gì?",
                            "Lập trình web", "Thiết kế giao diện", "Quản lý dự án", "Viết documentation", "B"},
                    {"Nguyên tắc nào quan trọng nhất trong UI Design?",
                            "Màu sắc đẹp", "Nhiều hiệu ứng", "Usability", "Font chữ đặc biệt", "C"}
            };
        } else if (courseName.contains("Python")) {
            questionData = new String[][]{
                    {"Python là ngôn ngữ lập trình gì?",
                            "Compiled", "Interpreted", "Assembly", "Machine code", "B"},
                    {"Thư viện nào dùng cho Data Analysis?",
                            "Pandas", "Tkinter", "Flask", "Django", "A"},
                    {"NumPy chủ yếu được sử dụng để làm gì?",
                            "Web development", "Scientific computing", "Game development", "Mobile app", "B"},
                    {"Phương thức đọc CSV trong Pandas?",
                            "read_csv()", "load_csv()", "import_csv()", "open_csv()", "A"}
            };
        } else {
            // Câu hỏi chung
            questionData = new String[][]{
                    {"Mục tiêu chính của việc học online là gì?",
                            "Giải trí", "Phát triển kỹ năng", "Giao lưu", "Thi đua", "B"},
                    {"Thái độ học tập hiệu quả nhất là gì?",
                            "Thụ động", "Tích cực và chủ động", "Thờ ơ", "Máy móc", "B"},
                    {"Yếu tố quan trọng nhất khi học online?",
                            "Tự giác và kỷ luật", "Máy tính đắt tiền", "Học nhiều giờ", "Ghi chép nhiều", "A"}
            };
        }

        for (int i = 0; i < questionData.length; i++) {
            Question question = new Question();
            question.setQuestionText(questionData[i][0]);
            question.setOptionA(questionData[i][1]);
            question.setOptionB(questionData[i][2]);
            question.setOptionC(questionData[i][3]);
            question.setOptionD(questionData[i][4]);
            question.setCorrectOption(questionData[i][5]);
            question.setExplanation("Giải thích chi tiết cho câu hỏi này sẽ được cập nhật...");
            question.setPoints(10.0);
            question.setDisplayOrder(i + 1);
            question.setQuiz(quiz);

            questionRepository.save(question);
        }
    }

    /**
     * Tạo enrollment mẫu (học viên đăng ký khóa học)
     */
    private void createSampleEnrollments() {
        System.out.println("📝 Tạo đăng ký khóa học mẫu...");

        try {
            List<User> students = userRepository.findByRole(User.Role.STUDENT);
            List<Course> courses = courseRepository.findAll();

            if (students.isEmpty() || courses.isEmpty()) return;

            // Mỗi học viên đăng ký random 2-4 khóa học
            for (User student : students) {
                int numEnrollments = 2 + random.nextInt(3); // 2-4 khóa học
                List<Course> selectedCourses = new ArrayList<>();

                for (int i = 0; i < numEnrollments && i < courses.size(); i++) {
                    Course course;
                    do {
                        course = courses.get(random.nextInt(courses.size()));
                    } while (selectedCourses.contains(course));

                    selectedCourses.add(course);

                    Enrollment enrollment = new Enrollment();
                    enrollment.setStudent(student);
                    enrollment.setCourse(course);
                    enrollment.setEnrollmentDate(LocalDateTime.now().minusDays(random.nextInt(30)));

                    // Random progress
                    int progress = random.nextInt(101);
                    enrollment.setProgress(progress);
                    enrollment.setCompleted(progress >= 100);

                    if (enrollment.isCompleted()) {
                        enrollment.setCompletionDate(LocalDateTime.now().minusDays(random.nextInt(10)));
                        enrollment.setCertificateIssued(true);
                    }

                    enrollmentRepository.save(enrollment);
                }
            }

            System.out.println("✅ Đã tạo enrollment mẫu");

        } catch (Exception e) {
            System.err.println("❌ Lỗi tạo enrollment mẫu: " + e.getMessage());
        }
    }

    /**
     * In thống kê hệ thống sau khi khởi tạo
     */
    private void printSystemStatistics() {
        System.out.println("\n📊 THỐNG KÊ HỆ THỐNG AFTER INITIALIZATION:");
        System.out.println("👥 Tổng số người dùng: " + userRepository.count());
        System.out.println("👨‍🏫 Giảng viên: " + userRepository.countByRole(User.Role.INSTRUCTOR));
        System.out.println("👨‍🎓 Học viên: " + userRepository.countByRole(User.Role.STUDENT));
        System.out.println("📁 Danh mục: " + categoryRepository.count());
        System.out.println("📚 Khóa học: " + courseRepository.count());
        System.out.println("📝 Bài giảng: " + lessonRepository.count());
        System.out.println("❓ Quiz: " + quizRepository.count());
        System.out.println("❔ Câu hỏi: " + questionRepository.count());
        System.out.println("📋 Đăng ký: " + enrollmentRepository.count());
        System.out.println("=====================================\n");
    }
}