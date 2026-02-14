-- ============================================
-- Student Performance Analysis & Prediction System
-- Database: MySQL
-- ============================================

-- ============================================
-- 1. DATABASE CREATION
-- ============================================

CREATE DATABASE IF NOT EXISTS student_analysis;

USE student_analysis;

-- ============================================
-- 2. TABLE CREATION
-- ============================================

DROP TABLE IF EXISTS students;

CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    attendance DECIMAL(5,2) NOT NULL,  -- Percentage (0-100)
    study_hours DECIMAL(5,2) NOT NULL,  -- Hours per week
    previous_score DECIMAL(5,2) NOT NULL,  -- Previous academic score (0-100)
    final_score DECIMAL(5,2) NOT NULL   -- Final exam score (0-100)
);

-- ============================================
-- 3. DATA INSERTION (30 Records)
-- ============================================

INSERT INTO students (name, gender, attendance, study_hours, previous_score, final_score) VALUES
('Aarav Sharma', 'Male', 95.50, 25.00, 88.00, 92.00),
('Priya Patel', 'Female', 88.00, 20.00, 85.50, 89.00),
('Rahul Verma', 'Male', 72.00, 15.00, 70.00, 75.00),
('Sneha Gupta', 'Female', 91.00, 22.00, 82.00, 88.00),
('Vikram Singh', 'Male', 68.00, 12.00, 65.00, 68.00),
('Anjali Reddy', 'Female', 85.00, 18.00, 78.00, 82.00),
('Raj Kumar', 'Male', 78.00, 16.00, 72.00, 76.00),
('Kavya Nair', 'Female', 92.00, 24.00, 90.00, 94.00),
('Arjun Menon', 'Male', 65.00, 10.00, 60.00, 62.00),
('Divya Joshi', 'Female', 80.00, 17.00, 75.00, 79.00),
('Sanjay Iyer', 'Male', 74.00, 14.00, 68.00, 71.00),
('Meera Desai', 'Female', 89.00, 21.00, 84.00, 87.00),
('Pranav Rao', 'Male', 82.00, 19.00, 76.00, 80.00),
('Nisha Bhat', 'Female', 94.00, 23.00, 89.00, 91.00),
('Kunal Shah', 'Male', 70.00, 13.00, 66.00, 69.00),
('Riya Choudhary', 'Female', 87.00, 19.00, 80.00, 84.00),
('Amit Pandey', 'Male', 76.00, 15.00, 71.00, 74.00),
('Swati Agarwal', 'Female', 90.00, 22.00, 86.00, 90.00),
('Deepak Kumar', 'Male', 64.00, 11.00, 58.00, 60.00),
('Pooja Singh', 'Female', 83.00, 18.00, 77.00, 81.00),
('Rohit Mishra', 'Male', 79.00, 16.00, 73.00, 77.00),
('Tara Williams', 'Female', 96.00, 26.00, 92.00, 96.00),
('Aditya Joshi', 'Male', 67.00, 12.00, 62.00, 65.00),
('Shreya Krishnan', 'Female', 86.00, 20.00, 81.00, 85.00),
('Nikhil Gupta', 'Male', 73.00, 14.00, 67.00, 70.00),
('Ananya Das', 'Female', 93.00, 24.00, 88.00, 92.00),
('Siddharth Nair', 'Male', 71.00, 13.00, 64.00, 67.00),
('Radhika Pillai', 'Female', 84.00, 17.00, 79.00, 83.00),
('Varun Sharma', 'Male', 77.00, 15.00, 70.00, 73.00),
('Ishita Malhotra', 'Female', 88.00, 21.00, 83.00, 87.00);

-- ============================================
-- 4. SQL QUERIES
-- ============================================

-- Query 1: Fetch top 5 students based on final_score
-- ============================================
SELECT id, name, gender, attendance, study_hours, previous_score, final_score
FROM students
ORDER BY final_score DESC
LIMIT 5;

-- Query 2: Calculate average final_score grouped by gender
-- ============================================
SELECT 
    gender,
    COUNT(*) AS total_students,
    AVG(final_score) AS average_final_score,
    AVG(attendance) AS average_attendance,
    AVG(study_hours) AS average_study_hours
FROM students
GROUP BY gender;

-- Query 3: List students with attendance less than 75%
-- ============================================
SELECT 
    id, 
    name, 
    gender, 
    attendance, 
    study_hours, 
    previous_score, 
    final_score
FROM students
WHERE attendance < 75
ORDER BY attendance ASC;

-- Query 4: Show relationship between study_hours and final_score using SQL logic
-- ============================================
-- This query demonstrates the relationship by categorizing study hours and showing statistics

SELECT 
    CASE 
        WHEN study_hours >= 20 THEN 'High (20+)'
        WHEN study_hours >= 15 THEN 'Medium (15-19)'
        ELSE 'Low (<15)'
    END AS study_hours_category,
    COUNT(*) AS total_students,
    AVG(study_hours) AS avg_study_hours,
    AVG(final_score) AS avg_final_score,
    MIN(final_score) AS min_final_score,
    MAX(final_score) AS max_final_score,
    AVG(previous_score) AS avg_previous_score
FROM students
GROUP BY 
    CASE 
        WHEN study_hours >= 20 THEN 'High (20+)'
        WHEN study_hours >= 15 THEN 'Medium (15-19)'
        ELSE 'Low (<15)'
    END
ORDER BY 
    CASE 
        WHEN study_hours >= 20 THEN 1
        WHEN study_hours >= 15 THEN 2
        ELSE 3
    END;

-- Additional: Correlation analysis between study_hours and final_score
-- ============================================
SELECT 
    ROUND(AVG(study_hours), 2) AS average_study_hours,
    ROUND(AVG(final_score), 2) AS average_final_score,
    ROUND((AVG(study_hours * final_score) - AVG(study_hours) * AVG(final_score)) / 
          (SQRT(AVG(study_hours * study_hours) - AVG(study_hours) * AVG(study_hours)) * 
           SQRT(AVG(final_score * final_score) - AVG(final_score) * AVG(final_score))), 4) AS correlation_coefficient
FROM students;

-- List all students with their study hours and final score for manual analysis
-- ============================================
SELECT 
    id,
    name,
    study_hours,
    final_score,
    final_score - previous_score AS score_improvement
FROM students
ORDER BY study_hours DESC;

-- ============================================
-- END OF SQL SCRIPT
-- ============================================
