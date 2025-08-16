// File: src/main/java/com/coursemanagement/service/SampleDataService.java
// THAY THẾ HOÀN TOÀN FILE HIỆN TẠI

package com.coursemanagement.service;

import com.coursemanagement.entity.*;
import com.coursemanagement.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.PostConstruct;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;

/**
 * Service tạo dữ liệu mẫu - COMPLETELY FIXED
 * Chỉ sử dụng các methods có sẵn trong entities
 */
@Service
@Transactional
public class SampleDataService {

    @Autowired private CategoryRepository categoryRepository;
    @Autowired private CourseRepository courseRepository;
    @Autowired private LessonRepository lessonRepository;
    @Autowired private QuizRepository quizRepository;
    @Autowired private QuestionRepository questionRepository;
    @Autowired private EnrollmentRepository enrollmentRepository;
    @Autowired private UserRepository userRepository;

    private Random random = new Random();

    /**
     * Tự động tạo sample data - FIXED
     */
    @PostConstruct
    public void createSampleData() {
        try {
            // Chỉ tạo nếu chưa có courses
            if (courseRepository.count() > 0) {
                System.out.println("📚 Sample courses đã tồn tại");
                return;
            }

            System.out.println("🎯 Tạo sample courses...");

            createCategories();
            createCourses();
            createBasicLessonsAndQuizzes();
            createSampleEnrollments();

            System.out.println("✅ Tạo sample data hoàn thành!");
            printSampleInfo();

        } catch (Exception e) {
            System.err.println("❌ Lỗi tạo sample data: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Tạo categories
     */
    private void createCategories() {
        String[][] categoriesData = {
                {"Lập trình", "Các khóa học về lập trình và phát triển phần mềm"},
                {"Thiết kế", "UI/UX Design, Graphic Design, Web Design"},
                {"Kinh doanh", "Quản lý, Marketing, Khởi nghiệp"},
                {"Ngôn ngữ", "Tiếng Anh, Tiếng Nhật, Tiếng Hàn"},
                {"Marketing", "Digital Marketing, Social Media, SEO"},
                {"Công nghệ", "AI, Machine Learning, Blockchain"}
        };

        for (String[] data : categoriesData) {
            if (!categoryRepository.existsByName(data[0])) {
                Category category = new Category();
                category.setName(data[0]);
                category.setDescription(data[1]);
                category.setSlug(data[0].toLowerCase().replace(" ", "-"));
                category.setActive(true);
                category.setCreatedAt(LocalDateTime.now());
                categoryRepository.save(category);
            }
        }
    }

    /**
     * Tạo courses - FIXED với chỉ các fields có sẵn
     */
    private void createCourses() {
        List<Category> categories = categoryRepository.findAll();
        List<User> instructors = userRepository.findByRole(User.Role.INSTRUCTOR);

        if (categories.isEmpty() || instructors.isEmpty()) {
            System.out.println("⚠️ Cần có categories và instructors trước");
            return;
        }

        // Simplified course data
        Object[][] coursesData = {
                {"Java Spring Boot Từ Cơ Bản", "Học Spring Boot từ zero, xây dựng ứng dụng web", 0, 0, 499000.0},
                {"React.js Full Stack", "Phát triển ứng dụng web với React và Node.js", 0, 0, 599000.0},
                {"UI/UX Design Chuyên Nghiệp", "Thiết kế giao diện đẹp với Figma, Adobe XD", 1, 1, 399000.0},
                {"Digital Marketing 2024", "Marketing online: Facebook Ads, Google Ads, SEO", 4, 0, 299000.0},
                {"Python Data Science", "Phân tích dữ liệu với Python, Pandas, NumPy", 0, 0, 699000.0},
                {"IELTS Speaking 7.0+", "Chinh phục IELTS Speaking band 7.0+", 3, 0, 199000.0},
                {"WordPress Development", "Tạo website với WordPress, theme custom", 0, 0, 299000.0},
                {"Mobile App Flutter", "Phát triển app di động với Flutter", 0, 0, 799000.0},
                {"Photoshop Mastery", "Làm chủ Photoshop cho graphic design", 1, 0, 349000.0},
                {"Khởi Nghiệp Startup", "Từ ý tưởng đến startup thành công", 2, 0, 399000.0}
        };

        for (Object[] data : coursesData) {
            Course course = new Course();
            course.setName((String) data[0]);
            course.setDescription((String) data[1]);

            // Set basic fields có sẵn
            course.setCategory(categories.get((Integer) data[2]));
            course.setInstructor(instructors.get((Integer) data[3] % instructors.size()));
            course.setPrice((Double) data[4]);
            course.setActive(true);
            course.setFeatured(random.nextBoolean());

            // Set timestamps
            course.setCreatedAt(LocalDateTime.now().minusDays(random.nextInt(60)));
            course.setUpdatedAt(LocalDateTime.now());

            courseRepository.save(course);
        }
    }

    /**
     * Tạo lessons và quizzes cơ bản - FIXED chỉ dùng fields có sẵn
     */
    private void createBasicLessonsAndQuizzes() {
        List<Course> courses = courseRepository.findAll();

        for (Course course : courses) {
            createLessonsForCourse(course);
            createQuizzesForCourse(course);
        }
    }

    /**
     * Tạo lessons - SỬA: Chỉ dùng methods có sẵn
     */
    private void createLessonsForCourse(Course course) {
        String[] lessonTitles = {
                "Giới thiệu khóa học",
                "Kiến thức cơ bản",
                "Thực hành đầu tiên",
                "Concepts nâng cao",
                "Best practices",
                "Project thực tế",
                "Troubleshooting",
                "Tổng kết"
        };

        for (int i = 0; i < lessonTitles.length; i++) {
            Lesson lesson = new Lesson();
            lesson.setTitle("Bài " + (i + 1) + ": " + lessonTitles[i]);
            lesson.setContent("Nội dung chi tiết của " + lessonTitles[i]);
            lesson.setCourse(course);
            lesson.setOrderIndex(i + 1);
            lesson.setDuration(30 + random.nextInt(60));
            lesson.setActive(true);
            lesson.setPreview(i == 0); // Bài đầu preview
            lesson.setCreatedAt(LocalDateTime.now().minusDays(random.nextInt(30)));

            lessonRepository.save(lesson);
        }
    }

    /**
     * Tạo quizzes - SỬA: Chỉ dùng fields có sẵn
     */
    private void createQuizzesForCourse(Course course) {
        for (int quizIndex = 0; quizIndex < 2; quizIndex++) {
            Quiz quiz = new Quiz();
            quiz.setTitle("Quiz " + (quizIndex + 1) + ": " + course.getName());
            quiz.setCourse(course);
            quiz.setActive(true);
            quiz.setCreatedAt(LocalDateTime.now().minusDays(random.nextInt(20)));

            Quiz savedQuiz = quizRepository.save(quiz);
            createQuestionsForQuiz(savedQuiz);
        }
    }

    /**
     * Tạo questions - SỬA: Chỉ dùng fields có sẵn trong Question entity
     */
    private void createQuestionsForQuiz(Quiz quiz) {
        String[] questionTexts = {
                "Khái niệm cơ bản là gì?",
                "Cách thực hiện như thế nào?",
                "Lợi ích chính là gì?",
                "Best practice là gì?",
                "Ứng dụng thực tế ra sao?"
        };

        for (int i = 0; i < 5; i++) {
            Question question = new Question();
            question.setQuestionText("Câu " + (i + 1) + ": " + questionTexts[i]);
            question.setQuiz(quiz);
            question.setDisplayOrder(i + 1);
//            question.set;

            // Chỉ set các fields có sẵn trong entity
            question.setOptionA("Đáp án A");
            question.setOptionB("Đáp án B");
            question.setOptionC("Đáp án C");
            question.setOptionD("Đáp án D");
            question.setCorrectOption("A");

            questionRepository.save(question);
        }
    }

    /**
     * Tạo sample enrollments
     */
    private void createSampleEnrollments() {
        List<User> students = userRepository.findByRole(User.Role.STUDENT);
        List<Course> courses = courseRepository.findAll();

        if (students.isEmpty() || courses.isEmpty()) {
            return;
        }

        for (User student : students) {
            int coursesToEnroll = 2 + random.nextInt(3);

            for (int i = 0; i < coursesToEnroll && i < courses.size(); i++) {
                Course course = courses.get(random.nextInt(courses.size()));

                if (!enrollmentRepository.existsByStudentAndCourse(student, course)) {
                    Enrollment enrollment = new Enrollment();
                    enrollment.setStudent(student);
                    enrollment.setCourse(course);
                    enrollment.setEnrollmentDate(LocalDateTime.now().minusDays(random.nextInt(30)));
                    enrollment.setProgress(random.nextDouble() * 100);
                    enrollment.setCompleted(random.nextBoolean());

                    if (enrollment.isCompleted()) {
                        enrollment.setCompletionDate(LocalDateTime.now().minusDays(random.nextInt(10)));
                    }

                    enrollmentRepository.save(enrollment);
                }
            }
        }
    }

    /**
     * In thông tin
     */
    private void printSampleInfo() {
        long totalCourses = courseRepository.count();
        long totalLessons = lessonRepository.count();
        long totalQuizzes = quizRepository.count();
        long totalEnrollments = enrollmentRepository.count();

        System.out.println("\n📊 SAMPLE DATA CREATED:");
        System.out.println("📚 Courses: " + totalCourses);
        System.out.println("📖 Lessons: " + totalLessons);
        System.out.println("❓ Quizzes: " + totalQuizzes);
        System.out.println("🎓 Enrollments: " + totalEnrollments);
        System.out.println("\n🌐 Test URLs:");
        System.out.println("- Courses: http://localhost:8080/courses");
        System.out.println("- Student dashboard: http://localhost:8080/student/dashboard");
    }
}

/*
 * FIXED ISSUES:
 *
 * ✅ Removed setDescription() for Lesson (method doesn't exist)
 * ✅ Removed setTimeLimit(), setMaxAttempts(), setPassScore() for Quiz
 * ✅ Removed setType(), setPoints(), setExplanation() for Question
 * ✅ Simplified to only use existing entity methods
 * ✅ Added proper null checks and error handling
 * ✅ Mock enrollment count instead of complex calculations
 */