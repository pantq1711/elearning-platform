package com.coursemanagement.dto;

/**
 * DTO cho thống kê Category
 * Chứa thông tin về số lượng khóa học, học viên và doanh thu theo danh mục
 */
public class CategoryStats {

    private Long categoryId;
    private String categoryName;
    private String description;
    private int courseCount;
    private long totalEnrollments;
    private long completedEnrollments;
    private double completionRate;
    private double totalRevenue;
    private boolean featured;
    private String colorCode;
    private String iconClass;

    // Constructors
    public CategoryStats() {}

    public CategoryStats(Long categoryId, String categoryName, int courseCount) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.courseCount = courseCount;
    }

    public CategoryStats(Long categoryId, String categoryName, String description,
                         int courseCount, long totalEnrollments, long completedEnrollments) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.description = description;
        this.courseCount = courseCount;
        this.totalEnrollments = totalEnrollments;
        this.completedEnrollments = completedEnrollments;
        this.completionRate = totalEnrollments > 0 ?
                (double) completedEnrollments / totalEnrollments * 100 : 0.0;
    }

    // Getters và Setters
    public Long getCategoryId() { return categoryId; }
    public void setCategoryId(Long categoryId) { this.categoryId = categoryId; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getCourseCount() { return courseCount; }
    public void setCourseCount(int courseCount) { this.courseCount = courseCount; }

    public long getTotalEnrollments() { return totalEnrollments; }
    public void setTotalEnrollments(long totalEnrollments) {
        this.totalEnrollments = totalEnrollments;
        // Tự động tính lại completion rate khi thay đổi total enrollments
        this.completionRate = totalEnrollments > 0 ?
                (double) completedEnrollments / totalEnrollments * 100 : 0.0;
    }

    public long getCompletedEnrollments() { return completedEnrollments; }
    public void setCompletedEnrollments(long completedEnrollments) {
        this.completedEnrollments = completedEnrollments;
        // Tự động tính lại completion rate khi thay đổi completed enrollments
        this.completionRate = totalEnrollments > 0 ?
                (double) completedEnrollments / totalEnrollments * 100 : 0.0;
    }

    public double getCompletionRate() { return completionRate; }
    public void setCompletionRate(double completionRate) { this.completionRate = completionRate; }

    public double getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(double totalRevenue) { this.totalRevenue = totalRevenue; }

    public boolean isFeatured() { return featured; }
    public void setFeatured(boolean featured) { this.featured = featured; }

    public String getColorCode() { return colorCode; }
    public void setColorCode(String colorCode) { this.colorCode = colorCode; }

    public String getIconClass() { return iconClass; }
    public void setIconClass(String iconClass) { this.iconClass = iconClass; }

    /**
     * Tính toán completion rate dựa trên total và completed enrollments
     */
    public void calculateCompletionRate() {
        this.completionRate = totalEnrollments > 0 ?
                (double) completedEnrollments / totalEnrollments * 100 : 0.0;
    }

    @Override
    public String toString() {
        return "CategoryStats{" +
                "categoryId=" + categoryId +
                ", categoryName='" + categoryName + '\'' +
                ", courseCount=" + courseCount +
                ", totalEnrollments=" + totalEnrollments +
                ", completedEnrollments=" + completedEnrollments +
                ", completionRate=" + completionRate +
                ", totalRevenue=" + totalRevenue +
                '}';
    }
}