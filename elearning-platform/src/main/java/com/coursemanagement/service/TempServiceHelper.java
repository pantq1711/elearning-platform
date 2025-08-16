// File: src/main/java/com/coursemanagement/service/TempServiceHelper.java
// TEMPORARY SERVICE CHO MISSING METHODS

package com.coursemanagement.service;

import com.coursemanagement.entity.Course;
import com.coursemanagement.repository.CourseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Temporary service helper để implement missing methods
 * SỬ DỤNG TẠM THỜI cho đến khi fix xong Repository methods
 */
@Service
public class TempServiceHelper {

    @Autowired
    private CourseRepository courseRepository;

    /**
     * Find active courses - TEMPORARY IMPLEMENTATION
     */
    public List<Course> findActiveCourses() {
        return courseRepository.findAll()
                .stream()
                .filter(Course::isActive)
                .sorted((a, b) -> b.getCreatedAt().compareTo(a.getCreatedAt()))
                .collect(Collectors.toList());
    }

    /**
     * Search courses with pagination - TEMPORARY IMPLEMENTATION
     */
    public Page<Course> searchCoursesWithPagination(String keyword, Pageable pageable) {
        List<Course> allCourses = courseRepository.findAll();

        List<Course> filteredCourses = allCourses.stream()
                .filter(Course::isActive)
                .filter(course -> course.getName().toLowerCase().contains(keyword.toLowerCase()))
                .sorted((a, b) -> b.getCreatedAt().compareTo(a.getCreatedAt()))
                .collect(Collectors.toList());

        // Manual pagination
        int start = (int) pageable.getOffset();
        int end = Math.min((start + pageable.getPageSize()), filteredCourses.size());

        List<Course> pageContent = start < filteredCourses.size() ?
                filteredCourses.subList(start, end) : List.of();

        return new PageImpl<>(pageContent, pageable, filteredCourses.size());
    }

    /**
     * Find active courses with pagination - TEMPORARY IMPLEMENTATION
     */
    public Page<Course> findActiveCoursesWithPagination(Pageable pageable) {
        List<Course> activeCourses = findActiveCourses();

        // Manual pagination
        int start = (int) pageable.getOffset();
        int end = Math.min((start + pageable.getPageSize()), activeCourses.size());

        List<Course> pageContent = start < activeCourses.size() ?
                activeCourses.subList(start, end) : List.of();

        return new PageImpl<>(pageContent, pageable, activeCourses.size());
    }

    /**
     * Find featured courses - TEMPORARY IMPLEMENTATION
     */
    public List<Course> findFeaturedCourses(int limit) {
        return findActiveCourses()
                .stream()
                .filter(course -> Boolean.TRUE.equals(course.isFeatured()))
                .limit(limit)
                .collect(Collectors.toList());
    }

    /**
     * Count active courses - TEMPORARY IMPLEMENTATION
     */
    public long countActiveCourses() {
        return courseRepository.findAll()
                .stream()
                .mapToLong(course -> course.isActive() ? 1L : 0L)
                .sum();
    }
}

/*
 * HƯỚNG DẪN SỬ DỤNG TEMPORARY SERVICE:
 *
 * 1. Inject TempServiceHelper vào CourseService
 * 2. Delegate các method calls đến TempServiceHelper
 * 3. Sau khi fix xong Repository methods, remove file này
 *
 * VÍ DỤ TRONG CourseService:
 *
 * @Autowired
 * private TempServiceHelper tempHelper;
 *
 * public List<Course> findActiveCourses() {
 *     return tempHelper.findActiveCourses();
 * }
 */