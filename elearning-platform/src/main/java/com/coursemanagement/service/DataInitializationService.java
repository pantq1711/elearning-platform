package com.coursemanagement.service;

import com.coursemanagement.entity.*;
import com.coursemanagement.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * Service để khởi tạo dữ liệu mẫu cho hệ thống
 * Chạy tự động khi ứng dụng khởi động
 */
@Service
@Transactional
public class DataInitializationService implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private LessonRepository lessonRepository;

    @Autowired
    private QuizRepository quizRepository;

    @Autowired
    private QuestionRepository questionRepository;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    /**
     * Entry point - chạy khi ứng dụng khởi động
     */
    @Override
    public void run(String... args) throws Exception {
        System.out.println("🚀 Bắt đầu khởi tạo dữ liệu mẫu...");

        try {
            // Tạo dữ liệu theo thứ tự dependencies
            createSampleUsers();
            createSampleCategories();
            createSampleCourses();
            createSampleLessons();
            createSampleQuizzes();
            createSampleEnrollments();

            System.out.println("✅ Hoàn thành khởi tạo dữ liệu mẫu!");

        } catch (Exception e) {
            System.err.println("❌ Lỗi khi khởi tạo dữ liệu: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Tạo người dùng mẫu
     */
    private void createSampleUsers() {
        System.out.println("📝 Tạo người dùng mẫu...");

        try {
            // Kiểm tra đã có admin chưa
            if (userRepository.findByUsername("admin").isPresent()) {
                System.out.println("⚠️ Dữ liệu người dùng đã tồn tại, bỏ qua...");
                return;
            }

            // Tạo Admin
            User admin = new User();
            admin.setUsername("admin");
            admin.setPassword(passwordEncoder.encode("admin123"));
            admin.setEmail("admin@coursemanagement.com");
            admin.setFullName("Quản trị viên");
            admin.setRole(User.Role.ADMIN);
            admin.setActive(true);
            userRepository.save(admin);

            // Tạo Instructors
            String[][] instructorData = {
                    {"instructor1", "instructor123", "instructor1@coursemanagement.com", "Nguyễn Văn Giáo"},
                    {"instructor2", "instructor123", "instructor2@coursemanagement.com", "Trần Thị Hướng"},
                    {"instructor3", "instructor123", "instructor3@coursemanagement.com", "Phạm Văn Tuấn"},
                    {"instructor4", "instructor123", "instructor4@coursemanagement.com", "Lê Thị Mai"}
            };

            for (String[] data : instructorData) {
                User instructor = new User();
                instructor.setUsername(data[0]);
                instructor.setPassword(passwordEncoder.encode(data[1]));
                instructor.setEmail(data[2]);
                instructor.setFullName(data[3]);
                instructor.setRole(User.Role.INSTRUCTOR);
                instructor.setActive(true);
                userRepository.save(instructor);
            }

            // Tạo Students
            String[][] studentData = {
                    {"student1", "student123", "student1@coursemanagement.com", "Hoàng Văn An"},
                    {"student2", "student123", "student2@coursemanagement.com", "Nguyễn Thị Bích"},
                    {"student3", "student123", "student3@coursemanagement.com", "Trần Văn Cường"},
                    {"student4", "student123", "student4@coursemanagement.com", "Lê Thị Dung"},
                    {"student5", "student123", "student5@coursemanagement.com", "Phạm Văn Em"},
                    {"student6", "student123", "student6@coursemanagement.com", "Võ Thị Phương"}
            };

            for (String[] data : studentData) {
                User student = new User();
                student.setUsername(data[0]);
                student.setPassword(passwordEncoder.encode(data[1]));
                student.setEmail(data[2]);
                student.setFullName(data[3]);
                student.setRole(User.Role.STUDENT);
                student.setActive(true);
                userRepository.save(student);
            }

            System.out.println("✅ Đã tạo " + (1 + instructorData.length + studentData.length) + " người dùng mẫu");

        } catch (Exception e) {
            System.err.println("❌ Lỗi tạo người dùng mẫu: " + e.getMessage());
        }
    }

    /**
     * Tạo danh mục mẫu
     */
    private void createSampleCategories() {
        System.out.println("📁 Tạo danh mục mẫu...");

        try {
            // Kiểm tra đã có danh mục chưa
            if (categoryRepository.count() > 0) {
                System.out.println("⚠️ Dữ liệu danh mục đã tồn tại, bỏ qua...");
                return;
            }

            String[][] categoryData = {
                    {"Lập trình", "Các khóa học về lập trình và phát triển phần mềm", "#007bff", "fas fa-code"},
                    {"Thiết kế", "Khóa học thiết kế đồ họa, UI/UX và sáng tạo", "#28a745", "fas fa-palette"},
                    {"Marketing", "Digital marketing, SEO, SEM và truyền thông", "#ffc107", "fas fa-bullhorn"},
                    {"Ngoại ngữ", "Học tiếng Anh, tiếng Nhật và các ngôn ngữ khác", "#17a2b8", "fas fa-language"},
                    {"Kinh doanh", "Quản lý, khởi nghiệp và phát triển doanh nghiệp", "#6c757d", "fas fa-briefcase"},
                    {"Kỹ năng mềm", "Kỹ năng giao tiếp, thuyết trình và phát triển bản thân", "#e83e8c", "fas fa-user-graduate"}
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
     * Tạo khóa học mẫu
     */
    private void createSampleCourses() {
        System.out.println("📚 Tạo khóa học mẫu...");

        try {
            // Kiểm tra đã có khóa học chưa
            if (courseRepository.count() > 0) {
                System.out.println("⚠️ Dữ liệu khóa học đã tồn tại, bỏ qua...");
                return;
            }

            // Lấy danh sách categories và instructors
            List<Category> categories = categoryRepository.findAll();
            List<User> instructors = userRepository.findByRole(User.Role.INSTRUCTOR);

            if (categories.isEmpty() || instructors.isEmpty()) {
                System.out.println("⚠️ Chưa có danh mục hoặc giảng viên, bỏ qua tạo khóa học");
                return;
            }

            // Dữ liệu khóa học mẫu
            String[][] courseData = {
                    {"Lập trình Java từ cơ bản đến nâng cao", "Khóa học Java toàn diện từ cơ bản đến nâng cao, bao gồm OOP, Collections, Streams và Spring Framework.", "Lập trình", "60"},
                    {"Thiết kế UI/UX với Figma", "Tìm hiểu các nguyên tắc thiết kế UI/UX và thực hành với công cụ Figma chuyên nghiệp.", "Thiết kế", "40"},
                    {"Digital Marketing toàn diện", "Khóa học marketing số từ A-Z, bao gồm SEO, SEM, Social Media Marketing và Analytics.", "Marketing", "50"},
                    {"Tiếng Anh giao tiếp cơ bản", "Khóa học tiếng Anh giao tiếp hàng ngày, phù hợp cho người mới bắt đầu.", "Ngoại ngữ", "80"},
                    {"Quản lý dự án với Agile", "Học các phương pháp quản lý dự án hiện đại, tập trung vào Agile và Scrum.", "Kinh doanh", "35"},
                    {"Kỹ năng thuyết trình hiệu quả", "Phát triển kỹ năng thuyết trình và giao tiếp trước đám đông một cách tự tin.", "Kỹ năng mềm", "25"},
                    {"Python cho Data Science", "Học Python để phân tích dữ liệu với Pandas, NumPy và Matplotlib.", "Lập trình", "70"},
                    {"Photoshop từ cơ bản đến chuyên nghiệp", "Khóa học Photoshop toàn diện cho thiết kế đồ họa và chỉnh sửa ảnh.", "Thiết kế", "45"},
                    {"Facebook Ads mastery", "Chiến lược quảng cáo Facebook hiệu quả, từ thiết lập đến tối ưu hóa ROI.", "Marketing", "30"},
                    {"IELTS Speaking Band 7+", "Luyện thi IELTS Speaking để đạt band 7 trở lên với phương pháp hiệu quả.", "Ngoại ngữ", "60"}
            };

            for (int i = 0; i < courseData.length; i++) {
                String[] data = courseData[i];

                // Tìm category theo tên
                Optional<Category> categoryOpt = categories.stream()
                        .filter(cat -> cat.getName().equals(data[2]))
                        .findFirst();

                if (categoryOpt.isPresent()) {
                    Course course = new Course();
                    course.setName(data[0]);
                    course.setDescription(data[1]);
                    course.setCategory(categoryOpt.get());
                    course.setInstructor(instructors.get(i % instructors.size()));
                    course.setEstimatedDuration(Integer.parseInt(data[3]));
                    course.setActive(true);
                    course.setFeatured(i < 6); // 6 khóa học đầu được featured

                    // Set difficulty level
                    if (i % 3 == 0) {
                        course.setDifficultyLevel(Course.DifficultyLevel.BEGINNER);
                    } else if (i % 3 == 1) {
                        course.setDifficultyLevel(Course.DifficultyLevel.INTERMEDIATE);
                    } else {
                        course.setDifficultyLevel(Course.DifficultyLevel.ADVANCED);
                    }

                    courseRepository.save(course);
                }
            }

            System.out.println("✅ Đã tạo " + courseData.length + " khóa học mẫu");

        } catch (Exception e) {
            System.err.println("❌ Lỗi tạo khóa học mẫu: " + e.getMessage());
        }
    }

    /**
     * Tạo bài giảng mẫu
     */
    private void createSampleLessons() {
        System.out.println("📖 Tạo bài giảng mẫu...");

        try {
            List<Course> courses = courseRepository.findAll();

            if (courses.isEmpty()) {
                System.out.println("⚠️ Chưa có khóa học, bỏ qua tạo bài giảng");
                return;
            }

            // Tạo 4-6 bài giảng cho mỗi khóa học
            for (Course course : courses) {
                if (lessonRepository.countByCourse(course) > 0) {
                    continue; // Đã có bài giảng rồi
                }

                String courseName = course.getName();
                String[][] lessonData;

                if (courseName.contains("Java")) {
                    lessonData = new String[][]{
                            {"Giới thiệu về Java", "Tổng quan về ngôn ngữ lập trình Java, lịch sử phát triển và ứng dụng trong thực tế.", "https://www.youtube.com/watch?v=eIrMbAQSU34"},
                            {"Cài đặt môi trường phát triển", "Hướng dẫn cài đặt JDK, IDE và các công cụ cần thiết để bắt đầu lập trình Java.", null},
                            {"Biến và kiểu dữ liệu", "Tìm hiểu về các kiểu dữ liệu cơ bản trong Java và cách khai báo, sử dụng biến.", "https://www.youtube.com/watch?v=YEhDbWaKAXM"},
                            {"Cấu trúc điều khiển", "Học về câu lệnh if-else, switch-case, vòng lặp for, while trong Java.", null},
                            {"Lập trình hướng đối tượng", "Giới thiệu các khái niệm OOP: Class, Object, Inheritance, Polymorphism.", "https://www.youtube.com/watch?v=Cr_U6DyWtWM"},
                            {"Exception Handling", "Xử lý ngoại lệ trong Java với try-catch-finally và custom exceptions.", null}
                    };
                } else if (courseName.contains("UI/UX")) {
                    lessonData = new String[][]{
                            {"Nguyên tắc thiết kế UI/UX", "Tìm hiểu các nguyên tắc cơ bản trong thiết kế giao diện người dùng và trải nghiệm người dùng.", null},
                            {"Giới thiệu Figma", "Làm quen với giao diện và các công cụ cơ bản của Figma cho thiết kế UI/UX.", "https://www.youtube.com/watch?v=FTlczfBm7bk"},
                            {"Thiết kế Wireframe", "Học cách tạo wireframe và prototype cho ứng dụng web và mobile.", null},
                            {"Color Theory và Typography", "Tìm hiểu về lý thuyết màu sắc và cách chọn font chữ phù hợp.", null},
                            {"User Research", "Phương pháp nghiên cứu người dùng và thu thập feedback để cải thiện thiết kế.", null}
                    };
                } else if (courseName.contains("Python")) {
                    lessonData = new String[][]{
                            {"Python Basics", "Cú pháp cơ bản của Python, biến, hàm và cấu trúc dữ liệu.", "https://www.youtube.com/watch?v=_uQrJ0TkZlc"},
                            {"Pandas cho Data Analysis", "Làm việc với DataFrame và Series trong Pandas để phân tích dữ liệu.", null},
                            {"NumPy và tính toán khoa học", "Sử dụng NumPy cho các phép tính toán số học và mảng đa chiều.", null},
                            {"Matplotlib và Seaborn", "Tạo biểu đồ và visualization dữ liệu với Matplotlib và Seaborn.", null},
                            {"Data Cleaning và Preprocessing", "Kỹ thuật làm sạch và tiền xử lý dữ liệu cho machine learning.", null}
                    };
                } else {
                    // Bài giảng chung cho các khóa học khác
                    lessonData = new String[][]{
                            {"Bài 1: Giới thiệu khóa học", "Tổng quan về nội dung, mục tiêu và lộ trình học tập của khóa học.", null},
                            {"Bài 2: Kiến thức cơ bản", "Những kiến thức nền tảng cần thiết trước khi bắt đầu học chuyên sâu.", null},
                            {"Bài 3: Thực hành đầu tiên", "Bài tập thực hành đầu tiên để làm quen với nội dung và công cụ.", null},
                            {"Bài 4: Kỹ thuật nâng cao", "Phát triển kỹ năng ở mức độ nâng cao với các ví dụ thực tế.", null},
                            {"Bài 5: Dự án thực hành", "Thực hiện dự án nhỏ để áp dụng kiến thức đã học.", null}
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
                    lesson.setEstimatedDuration(30 + (i * 5)); // 30-55 phút
                    lesson.setPreview(i == 0); // Bài đầu cho preview miễn phí

                    lessonRepository.save(lesson);
                }
            }

            System.out.println("✅ Đã tạo bài giảng mẫu cho tất cả khóa học");

        } catch (Exception e) {
            System.err.println("❌ Lỗi tạo bài giảng mẫu: " + e.getMessage());
        }
    }

    /**
     * Tạo quiz mẫu
     */
    private void createSampleQuizzes() {
        System.out.println("❓ Tạo quiz mẫu...");

        try {
            List<Course> courses = courseRepository.findAll();

            if (courses.isEmpty()) {
                System.out.println("⚠️ Chưa có khóa học, bỏ qua tạo quiz");
                return;
            }

            // Tạo 1-2 quiz cho mỗi khóa học
            for (Course course : courses) {
                if (quizRepository.countByCourse(course) > 0) {
                    continue; // Đã có quiz rồi
                }

                // Tạo quiz chính
                Quiz quiz = new Quiz();
                quiz.setTitle("Kiểm tra " + course.getName());
                quiz.setDescription("Bài kiểm tra kiến thức cơ bản về " + course.getName());
                quiz.setDuration(30); // 30 phút
                quiz.setMaxScore(100.0);
                quiz.setPassScore(60.0);
                quiz.setCourse(course);
                quiz.setActive(true);

                Quiz savedQuiz = quizRepository.save(quiz);

                // Tạo câu hỏi cho quiz
                createQuestionsForQuiz(savedQuiz, course.getName());

                // Tạo quiz cuối khóa (nếu khóa học dài)
                if (course.getEstimatedDuration() != null && course.getEstimatedDuration() > 40) {
                    Quiz finalQuiz = new Quiz();
                    finalQuiz.setTitle("Kiểm tra cuối khóa - " + course.getName());
                    finalQuiz.setDescription("Bài kiểm tra tổng hợp kiến thức toàn khóa học");
                    finalQuiz.setDuration(45); // 45 phút
                    finalQuiz.setMaxScore(100.0);
                    finalQuiz.setPassScore(70.0);
                    finalQuiz.setCourse(course);
                    finalQuiz.setActive(true);

                    Quiz savedFinalQuiz = quizRepository.save(finalQuiz);
                    createQuestionsForQuiz(savedFinalQuiz, course.getName() + "_advanced");
                }
            }

            System.out.println("✅ Đã tạo quiz mẫu cho tất cả khóa học");

        } catch (Exception e) {
            System.err.println("❌ Lỗi tạo quiz mẫu: " + e.getMessage());
        }
    }

    /**
     * Tạo câu hỏi cho quiz
     */
    private void createQuestionsForQuiz(Quiz quiz, String courseName) {
        String[][] questionData;

        if (courseName.contains("Java")) {
            questionData = new String[][]{
                    {"Phương thức main trong Java có đặc điểm gì?", "Private và static", "Public và dynamic", "Public và static", "Protected và final", "C"},
                    {"JVM viết tắt của cụm từ nào?", "Java Virtual Machine", "Java Variable Method", "Java Version Manager", "Java Visual Mode", "A"},
                    {"Kiểu dữ liệu nào sau đây là kiểu nguyên thủy trong Java?", "String", "ArrayList", "int", "Scanner", "C"},
                    {"Từ khóa nào được sử dụng để kế thừa trong Java?", "implements", "extends", "inherits", "super", "B"},
                    {"Phương thức nào được gọi tự động khi tạo object?", "main", "constructor", "finalize", "toString", "B"}
            };
        } else if (courseName.contains("UI/UX")) {
            questionData = new String[][]{
                    {"UX viết tắt của cụm từ nào?", "User Experience", "User Extension", "Unique Experience", "Universal Extension", "A"},
                    {"Wireframe trong thiết kế UI/UX là gì?", "Màu sắc của giao diện", "Bản phác thảo khung giao diện", "Font chữ được sử dụng", "Hiệu ứng chuyển động", "B"},
                    {"Nguyên tắc nào quan trọng nhất trong thiết kế UI?", "Màu sắc đẹp", "Nhiều hiệu ứng", "Dễ sử dụng", "Font chữ lạ", "C"},
                    {"Figma là công cụ dùng để làm gì?", "Lập trình web", "Thiết kế giao diện", "Quản lý dự án", "Viết văn bản", "B"}
            };
        } else if (courseName.contains("Python")) {
            questionData = new String[][]{
                    {"Python là ngôn ngữ lập trình gì?", "Compiled", "Interpreted", "Assembly", "Machine code", "B"},
                    {"Thư viện nào được sử dụng cho Data Analysis?", "Pandas", "Tkinter", "Flask", "Django", "A"},
                    {"Phương thức nào để đọc file CSV trong Pandas?", "read_csv()", "load_csv()", "import_csv()", "open_csv()", "A"},
                    {"NumPy chủ yếu được sử dụng để làm gì?", "Web development", "Tính toán khoa học", "Game development", "Mobile app", "B"}
            };
        } else {
            // Câu hỏi chung
            questionData = new String[][]{
                    {"Mục tiêu chính của khóa học này là gì?", "Giải trí", "Học kiến thức và kỹ năng mới", "Giao lưu", "Thi đua", "B"},
                    {"Thái độ học tập tốt nhất là gì?", "Thụ động", "Tích cực và chủ động", "Thờ ơ", "Máy móc", "B"},
                    {"Điều quan trọng nhất khi học online là gì?", "Tự giác và kỷ luật", "Có máy tính đắt", "Học nhiều giờ", "Ghi chép nhiều", "A"},
                    {"Cách tốt nhất để ghi nhớ kiến thức là gì?", "Học thuộc lòng", "Thực hành thường xuyên", "Chỉ đọc một lần", "Không cần ôn tập", "B"}
            };
        }

        for (String[] data : questionData) {
            Question question = new Question();
            question.setQuestionText(data[0]);
            question.setOptionA(data[1]);
            question.setOptionB(data[2]);
            question.setOptionC(data[3]);
            question.setOptionD(data[4]);
            question.setCorrectOption(data[5]);
            question.setExplanation("Đây là đáp án đúng dựa trên nội dung đã học trong khóa học.");
            question.setQuiz(quiz);
            question.setPoints(2.0);

            questionRepository.save(question);
        }
    }

    /**
     * Tạo enrollment mẫu
     */
    private void createSampleEnrollments() {
        System.out.println("🎯 Tạo enrollment mẫu...");

        try {
            List<User> students = userRepository.findByRole(User.Role.STUDENT);
            List<Course> courses = courseRepository.findAll();

            if (students.isEmpty() || courses.isEmpty()) {
                System.out.println("⚠️ Chưa có học viên hoặc khóa học, bỏ qua tạo enrollment");
                return;
            }

            // Mỗi học viên đăng ký 2-4 khóa học ngẫu nhiên
            for (User student : students) {
                int enrollmentCount = 2 + (int) (Math.random() * 3); // 2-4 khóa học

                for (int i = 0; i < enrollmentCount && i < courses.size(); i++) {
                    Course course = courses.get((int) (Math.random() * courses.size()));

                    // Kiểm tra đã đăng ký chưa
                    if (enrollmentRepository.existsByStudentAndCourse(student, course)) {
                        continue;
                    }

                    Enrollment enrollment = new Enrollment(student, course);

                    // Random tiến độ học tập
                    double progress = Math.random() * 100;
                    enrollment.setProgressPercentage(progress);

                    // Random study hours
                    enrollment.setStudyHours(Math.random() * 20);

                    // Nếu hoàn thành trên 80% thì mark là completed
                    if (progress > 80) {
                        enrollment.complete();
                        enrollment.setHighestScore(60 + Math.random() * 40); // 60-100 điểm
                    }

                    enrollmentRepository.save(enrollment);
                }
            }

            System.out.println("✅ Đã tạo enrollment mẫu cho học viên");

        } catch (Exception e) {
            System.err.println("❌ Lỗi tạo enrollment mẫu: " + e.getMessage());
        }
    }
}