package com.coursemanagement.service;

import com.coursemanagement.entity.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * Service để khởi tạo dữ liệu mẫu cho hệ thống
 * Tự động chạy sau khi ứng dụng khởi động hoàn tất
 */
@Service
@Transactional
public class DataInitializationService {

    @Autowired
    private UserService userService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private CourseService courseService;

    @Autowired
    private LessonService lessonService;

    @Autowired
    private QuizService quizService;

    @Autowired
    private EnrollmentService enrollmentService;

    /**
     * Khởi tạo dữ liệu mẫu sau khi ứng dụng sẵn sàng
     * Chỉ chạy khi database trống hoặc thiếu dữ liệu cơ bản
     */
    @EventListener(ApplicationReadyEvent.class)
    public void initializeSampleData() {
        try {
            System.out.println("🔄 Đang kiểm tra và khởi tạo dữ liệu mẫu...");

            // Tạo users mẫu
            createSampleUsers();

            // Tạo khóa học mẫu
            createSampleCourses();

            // Tạo bài giảng mẫu
            createSampleLessons();

            // Tạo quiz mẫu
            createSampleQuizzes();

            // Tạo đăng ký mẫu
            createSampleEnrollments();

            System.out.println("✅ Khởi tạo dữ liệu mẫu hoàn tất!");

        } catch (Exception e) {
            System.err.println("❌ Lỗi khởi tạo dữ liệu mẫu: " + e.getMessage());
            // Không throw exception để không crash ứng dụng
        }
    }

    /**
     * Tạo users mẫu (instructor và student)
     */
    private void createSampleUsers() {
        try {
            // Kiểm tra đã có instructor nào chưa
            List<User> instructors = userService.findByRole(User.Role.INSTRUCTOR);
            if (instructors.isEmpty()) {

                // Tạo instructors mẫu
                String[][] instructorData = {
                        {"instructor1", "instructor123", "instructor1@example.com", "Nguyễn Văn A"},
                        {"instructor2", "instructor123", "instructor2@example.com", "Trần Thị B"},
                        {"instructor3", "instructor123", "instructor3@example.com", "Lê Văn C"}
                };

                for (String[] data : instructorData) {
                    if (!userService.existsByUsername(data[0])) {
                        User instructor = new User();
                        instructor.setUsername(data[0]);
                        instructor.setPassword(data[1]);
                        instructor.setEmail(data[2]);
                        instructor.setRole(User.Role.INSTRUCTOR);
                        instructor.setActive(true);

                        userService.createUser(instructor);
                    }
                }

                System.out.println("✅ Đã tạo " + instructorData.length + " tài khoản instructor mẫu");
            }

            // Kiểm tra đã có student nào chưa
            List<User> students = userService.findByRole(User.Role.STUDENT);
            if (students.size() < 5) {

                // Tạo students mẫu
                String[][] studentData = {
                        {"student1", "student123", "student1@example.com"},
                        {"student2", "student123", "student2@example.com"},
                        {"student3", "student123", "student3@example.com"},
                        {"student4", "student123", "student4@example.com"},
                        {"student5", "student123", "student5@example.com"}
                };

                for (String[] data : studentData) {
                    if (!userService.existsByUsername(data[0])) {
                        User student = new User();
                        student.setUsername(data[0]);
                        student.setPassword(data[1]);
                        student.setEmail(data[2]);
                        student.setRole(User.Role.STUDENT);
                        student.setActive(true);

                        userService.createUser(student);
                    }
                }

                System.out.println("✅ Đã tạo " + studentData.length + " tài khoản student mẫu");
            }

        } catch (Exception e) {
            System.err.println("❌ Lỗi tạo users mẫu: " + e.getMessage());
        }
    }

    /**
     * Tạo khóa học mẫu
     */
    private void createSampleCourses() {
        try {
            // Kiểm tra đã có khóa học nào chưa
            if (courseService.countAllCourses() > 0) {
                return;
            }

            List<User> instructors = userService.findByRole(User.Role.INSTRUCTOR);
            List<Category> categories = categoryService.findAll();

            if (instructors.isEmpty() || categories.isEmpty()) {
                return;
            }

            // Dữ liệu khóa học mẫu
            String[][] courseData = {
                    {"Lập trình Java cơ bản", "Học lập trình Java từ cơ bản đến nâng cao, bao gồm OOP và các framework phổ biến.", "Lập trình"},
                    {"Thiết kế UI/UX với Figma", "Tìm hiểu các nguyên tắc thiết kế UI/UX và thực hành với công cụ Figma chuyên nghiệp.", "Thiết kế"},
                    {"Digital Marketing toàn diện", "Khóa học marketing số từ A-Z, bao gồm SEO, SEM, Social Media Marketing và Analytics.", "Marketing"},
                    {"Tiếng Anh giao tiếp cơ bản", "Khóa học tiếng Anh giao tiếp hàng ngày, phù hợp cho người mới bắt đầu.", "Ngoại ngữ"},
                    {"Quản lý dự án với Agile", "Học các phương pháp quản lý dự án hiện đại, tập trung vào Agile và Scrum.", "Kinh doanh"},
                    {"Kỹ năng thuyết trình hiệu quả", "Phát triển kỹ năng thuyết trình và giao tiếp trước đám đông một cách tự tin.", "Kỹ năng mềm"}
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
                    course.setActive(true);

                    courseService.createCourse(course);
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
        try {
            List<Course> courses = courseService.findAllActiveCourses();

            if (courses.isEmpty()) {
                return;
            }

            // Tạo 3-5 bài giảng cho mỗi khóa học
            for (Course course : courses) {
                if (lessonService.countActiveLessonsByCourse(course) > 0) {
                    continue; // Đã có bài giảng rồi
                }

                String courseName = course.getName();
                String[][] lessonData;

                if (courseName.contains("Java")) {
                    lessonData = new String[][]{
                            {"Giới thiệu về Java", "Tổng quan về ngôn ngữ lập trình Java, lịch sử và ứng dụng.", "https://www.youtube.com/watch?v=eIrMbAQSU34"},
                            {"Cài đặt môi trường phát triển", "Hướng dẫn cài đặt JDK và IDE cho việc lập trình Java.", null},
                            {"Biến và kiểu dữ liệu", "Tìm hiểu về các kiểu dữ liệu cơ bản và cách khai báo biến.", "https://www.youtube.com/watch?v=YEhDbWaKAXM"},
                            {"Cấu trúc điều khiển", "Học về if-else, switch-case, vòng lặp for, while trong Java.", null},
                            {"Lập trình hướng đối tượng", "Giới thiệu các khái niệm OOP: Class, Object, Inheritance, Polymorphism.", "https://www.youtube.com/watch?v=Cr_U6DyWtWM"}
                    };
                } else if (courseName.contains("UI/UX")) {
                    lessonData = new String[][]{
                            {"Nguyên tắc thiết kế UI/UX", "Tìm hiểu các nguyên tắc cơ bản trong thiết kế giao diện người dùng.", null},
                            {"Giới thiệu Figma", "Làm quen với giao diện và các công cụ cơ bản của Figma.", "https://www.youtube.com/watch?v=FTlczfBm7bk"},
                            {"Thiết kế Wireframe", "Học cách tạo wireframe và prototype cho ứng dụng mobile.", null},
                            {"Color Theory và Typography", "Tìm hiểu về lý thuyết màu sắc và cách chọn font chữ phù hợp.", null}
                    };
                } else {
                    // Bài giảng chung cho các khóa học khác
                    lessonData = new String[][]{
                            {"Bài 1: Giới thiệu khóa học", "Tổng quan về nội dung và mục tiêu của khóa học.", null},
                            {"Bài 2: Kiến thức cơ bản", "Những kiến thức nền tảng cần thiết cho khóa học.", null},
                            {"Bài 3: Thực hành đầu tiên", "Bài tập thực hành đầu tiên để làm quen với nội dung.", null},
                            {"Bài 4: Nâng cao kỹ năng", "Phát triển kỹ năng ở mức độ nâng cao hơn.", null}
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

                    lessonService.createLesson(lesson);
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
        try {
            List<Course> courses = courseService.findAllActiveCourses();

            if (courses.isEmpty()) {
                return;
            }

            // Tạo 1-2 quiz cho mỗi khóa học
            for (Course course : courses) {
                if (quizService.countActiveQuizzesByCourse(course) > 0) {
                    continue; // Đã có quiz rồi
                }

                // Tạo quiz giữa khóa
                Quiz midQuiz = new Quiz();
                midQuiz.setTitle("Kiểm tra giữa khóa - " + course.getName());
                midQuiz.setDescription("Bài kiểm tra đánh giá kiến thức giữa khóa học");
                midQuiz.setDuration(30); // 30 phút
                midQuiz.setMaxScore(100.0);
                midQuiz.setPassScore(60.0);
                midQuiz.setCourse(course);
                midQuiz.setActive(true);

                Quiz createdMidQuiz = quizService.createQuiz(midQuiz);

                // Thêm câu hỏi cho quiz giữa khóa
                createSampleQuestions(createdMidQuiz, "giữa khóa");

                // Tạo quiz cuối khóa
                Quiz finalQuiz = new Quiz();
                finalQuiz.setTitle("Kiểm tra cuối khóa - " + course.getName());
                finalQuiz.setDescription("Bài kiểm tra tổng kết toàn bộ khóa học");
                finalQuiz.setDuration(45); // 45 phút
                finalQuiz.setMaxScore(100.0);
                finalQuiz.setPassScore(70.0);
                finalQuiz.setCourse(course);
                finalQuiz.setActive(true);

                Quiz createdFinalQuiz = quizService.createQuiz(finalQuiz);

                // Thêm câu hỏi cho quiz cuối khóa
                createSampleQuestions(createdFinalQuiz, "cuối khóa");
            }

            System.out.println("✅ Đã tạo quiz mẫu cho tất cả khóa học");

        } catch (Exception e) {
            System.err.println("❌ Lỗi tạo quiz mẫu: " + e.getMessage());
        }
    }

    /**
     * Tạo câu hỏi mẫu cho quiz
     */
    private void createSampleQuestions(Quiz quiz, String type) {
        try {
            String courseName = quiz.getCourse().getName();
            String[][] questionData;

            if (courseName.contains("Java")) {
                questionData = new String[][]{
                        {"Java là ngôn ngữ lập trình thuộc loại nào?", "Ngôn ngữ máy", "Ngôn ngữ bậc cao", "Ngôn ngữ assembly", "Ngôn ngữ kịch bản", "B"},
                        {"Từ khóa nào được sử dụng để kế thừa trong Java?", "implements", "extends", "inherits", "super", "B"},
                        {"Phương thức main() trong Java có đặc điểm gì?", "Private và static", "Public và dynamic", "Public và static", "Protected và final", "C"},
                        {"JVM viết tắt của cụm từ nào?", "Java Virtual Machine", "Java Variable Method", "Java Version Manager", "Java Visual Mode", "A"},
                        {"Kiểu dữ liệu nào sau đây là kiểu nguyên thủy trong Java?", "String", "ArrayList", "int", "Scanner", "C"}
                };
            } else if (courseName.contains("UI/UX")) {
                questionData = new String[][]{
                        {"UX viết tắt của cụm từ nào?", "User Experience", "User Extension", "Unique Experience", "Universal Extension", "A"},
                        {"Wireframe trong thiết kế UI/UX là gì?", "Màu sắc của giao diện", "Bản phác thảo khung giao diện", "Font chữ được sử dụng", "Hiệu ứng chuyển động", "B"},
                        {"Nguyên tắc nào quan trọng nhất trong thiết kế UI?", "Màu sắc đẹp", "Nhiều hiệu ứng", "Dễ sử dụng", "Font chữ lạ", "C"},
                        {"Figma là công cụ dùng để làm gì?", "Lập trình web", "Thiết kế giao diện", "Quản lý dự án", "Viết văn bản", "B"}
                };
            } else {
                // Câu hỏi chung
                questionData = new String[][]{
                        {"Mục tiêu chính của khóa học này là gì?", "Giải trí", "Học kiến thức và kỹ năng mới", "Giao lưu", "Thi đua", "B"},
                        {"Thái độ học tập tốt nhất là gì?", "Thụ động", "Tích cực và chủ động", "Thờ ơ", "Máy móc", "B"},
                        {"Điều quan trọng nhất khi học online là gì?", "Tự giác và kỷ luật", "Có máy tính đắt", "Học nhiều giờ", "Ghi chép nhiều", "A"}
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

                quizService.addQuestionToQuiz(quiz, question);
            }

        } catch (Exception e) {
            System.err.println("❌ Lỗi tạo câu hỏi mẫu: " + e.getMessage());
        }
    }

    /**
     * Tạo đăng ký mẫu
     */
    private void createSampleEnrollments() {
        try {
            List<User> students = userService.findByRole(User.Role.STUDENT);
            List<Course> courses = courseService.findAllActiveCourses();

            if (students.isEmpty() || courses.isEmpty()) {
                return;
            }

            // Mỗi student đăng ký 2-3 khóa học ngẫu nhiên
            for (User student : students) {
                int enrollmentCount = 0;
                for (int i = 0; i < courses.size() && enrollmentCount < 3; i++) {
                    Course course = courses.get(i);

                    // Chỉ đăng ký nếu chưa đăng ký khóa học này
                    if (!enrollmentService.isStudentEnrolled(student, course)) {
                        try {
                            enrollmentService.enrollStudent(student, course);
                            enrollmentCount++;
                        } catch (Exception e) {
                            // Bỏ qua lỗi đăng ký
                        }
                    }
                }
            }

            System.out.println("✅ Đã tạo đăng ký mẫu cho học viên");

        } catch (Exception e) {
            System.err.println("❌ Lỗi tạo đăng ký mẫu: " + e.getMessage());
        }
    }
}