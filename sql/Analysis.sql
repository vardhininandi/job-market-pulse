USE job_market_db;
-- --------------------------------------------------------------------------------------------------------------------------
-- Query1 Top 15 most in demand job titles
-- Insight: Sales Manager dominates with 669 postings
-- -------------------------------------------------------------------------------------------------------------------------
SELECT title, COUNT(*) AS total_postings, ROUND(COUNT(*) * 100.0/ (SELECT COUNT(*) fROM job_postings), 2) AS pct_of_market
FROM job_postings
WHERE title IS NOT NULL
GROUP BY title
ORDER BY total_postings DESC
LIMIT 15;

-- ----------------------------------------------------------------------------------------------------------------------
-- Query 2 Average salary by experience level
-- Insight: Entry level avg $89,535 vs Executive level avg $201,926
-- ----------------------------------------------------------------------------------------------------------------------
SELECT formatted_experience_level, COUNT(*) AS total_postings,
ROUND(AVG(min_salary), 0) AS avg_min_salary,
ROUND(AVG(max_salary), 0) AS avg_max_salary,
ROUND((AVG(min_salary) + AVG(max_salary)) / 2, 0) AS avg_mid_salary
FROM job_postings
WHERE pay_period = 'YEARLY'
AND min_salary >= 10000
AND max_salary <= 500000
GROUP BY formatted_experience_level
ORDER BY avg_mid_salary DESC;

-- ----------------------------------------------------------------------------------------------------------------------
-- Query3 Top 15 hiring companies
-- Insight: Liberty Healthcare leads with 1108 postings
-- ----------------------------------------------------------------------------------------------------------------------
SELECT company_name, COUNT(*) AS total_postings,
COUNT(CASE WHEN work_type = 'FULL_TIME' THEN 1 END)AS full_time_postings
FROM job_postings
WHERE company_name IS NOT NULL 
AND company_name != 'company_name'
GROUP BY company_name
ORDER BY total_postings DESC
LIMIT 15; 

-- ------------------------------------------------------------------------------------------------------------------------
-- Query4 Work type breakdown by experience level
-- Insight: 80% of entry level jobs are full time
-- ------------------------------------------------------------------------------------------------------------------------
SELECT formatted_experience_level, work_type, COUNT(*) AS total, 
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY formatted_experience_level),1) AS pct_within_level
FROM job_postings
WHERE formatted_experience_level != 'Not Specified'
GROUP BY formatted_experience_level, work_type
ORDER BY formatted_experience_level, total DESC;

-- --------------------------------------------------------------------------------------------------------------------
-- Query5 Average salary by location
-- Insight: San Mateo CA highest at $253k avg max salary
-- ---------------------------------------------------------------------------------------------------------------------
SELECT location, COUNT(*) AS job_count,
ROUND(AVG(min_salary), 0) AS avg_min_salary,
ROUND(AVG(max_salary), 0) AS avg_max_salary,
ROUND(MIN(min_salary), 0) AS lowest_salary,
ROUND(MAX(max_salary), 0) AS highest_salary
FROM job_postings
WHERE pay_period = 'YEARLY'
AND min_salary >= 10000
AND max_salary <= 500000
AND location != 'location'
GROUP BY location
HAVING COUNT(*) >= 10
ORDER BY avg_max_salary DESC
LIMIT 20;