package com.coursemanagement.dto;

/**
 * DTO cho Dashboard Statistics
 */
public class DashboardStatsDto {

    private long totalUsers;
    private long totalStudents;
    private long totalInstructors;
    private long totalCourses;
    private long activeCourses;
    private long totalCategories;
    private long totalEnrollments;
    private long totalQuizzes;

    // Constructor
    public DashboardStatsDto() {}

    public DashboardStatsDto(long totalUsers, long totalStudents, long totalInstructors,
                             long totalCourses, long activeCourses, long totalCategories,
                             long totalEnrollments, long totalQuizzes) {
        this.totalUsers = totalUsers;
        this.totalStudents = totalStudents;
        this.totalInstructors = totalInstructors;
        this.totalCourses = totalCourses;
        this.activeCourses = activeCourses;
        this.totalCategories = totalCategories;
        this.totalEnrollments = totalEnrollments;
        this.totalQuizzes = totalQuizzes;
    }

    // Getters and Setters
    public long getTotalUsers() { return totalUsers; }
    public void setTotalUsers(long totalUsers) { this.totalUsers = totalUsers; }

    public long getTotalStudents() { return totalStudents; }
    public void setTotalStudents(long totalStudents) { this.totalStudents = totalStudents; }

    public long getTotalInstructors() { return totalInstructors; }
    public void setTotalInstructors(long totalInstructors) { this.totalInstructors = totalInstructors; }

    public long getTotalCourses() { return totalCourses; }
    public void setTotalCourses(long totalCourses) { this.totalCourses = totalCourses; }

    public long getActiveCourses() { return activeCourses; }
    public void setActiveCourses(long activeCourses) { this.activeCourses = activeCourses; }

    public long getTotalCategories() { return totalCategories; }
    public void setTotalCategories(long totalCategories) { this.totalCategories = totalCategories; }

    public long getTotalEnrollments() { return totalEnrollments; }
    public void setTotalEnrollments(long totalEnrollments) { this.totalEnrollments = totalEnrollments; }

    public long getTotalQuizzes() { return totalQuizzes; }
    public void setTotalQuizzes(long totalQuizzes) { this.totalQuizzes = totalQuizzes; }
}