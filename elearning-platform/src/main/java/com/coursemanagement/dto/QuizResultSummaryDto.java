package com.coursemanagement.dto;

/**
 * DTO cho Quiz Result Summary
 */
public class QuizResultSummaryDto {

    private Long quizId;
    private String quizTitle;
    private String courseName;
    private Double score;
    private Double maxScore;
    private String scoreText;
    private String percentageText;
    private boolean isPassed;
    private String resultText;
    private String submittedAt;
    private String timeTaken;

    // Constructor
    public QuizResultSummaryDto() {}

    // Getters and Setters
    public Long getQuizId() { return quizId; }
    public void setQuizId(Long quizId) { this.quizId = quizId; }

    public String getQuizTitle() { return quizTitle; }
    public void setQuizTitle(String quizTitle) { this.quizTitle = quizTitle; }

    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }

    public Double getScore() { return score; }
    public void setScore(Double score) { this.score = score; }

    public Double getMaxScore() { return maxScore; }
    public void setMaxScore(Double maxScore) { this.maxScore = maxScore; }

    public String getScoreText() { return scoreText; }
    public void setScoreText(String scoreText) { this.scoreText = scoreText; }

    public String getPercentageText() { return percentageText; }
    public void setPercentageText(String percentageText) { this.percentageText = percentageText; }

    public boolean isPassed() { return isPassed; }
    public void setPassed(boolean passed) { isPassed = passed; }

    public String getResultText() { return resultText; }
    public void setResultText(String resultText) { this.resultText = resultText; }

    public String getSubmittedAt() { return submittedAt; }
    public void setSubmittedAt(String submittedAt) { this.submittedAt = submittedAt; }

    public String getTimeTaken() { return timeTaken; }
    public void setTimeTaken(String timeTaken) { this.timeTaken = timeTaken; }
}