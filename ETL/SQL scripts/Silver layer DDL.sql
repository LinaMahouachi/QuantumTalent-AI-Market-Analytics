

-- Drop the silver table if it exists
IF OBJECT_ID('silver.ai_jobs_clean', 'U') IS NOT NULL
BEGIN
    DROP TABLE silver.ai_jobs_clean;
END
GO 

-- DDL for silver table-- 
CREATE TABLE silver.ai_jobs_clean (
    job_id VARCHAR(50) PRIMARY KEY,
    job_title VARCHAR(255) NOT NULL,
    salary_usd DECIMAL(15,2),
    experience_level VARCHAR(50),
    employment_type VARCHAR(50),
    company_location VARCHAR(100),
    company_size VARCHAR(50),
    employee_residence VARCHAR(100),
    remote_ratio VARCHAR(50),
    required_skills VARCHAR(MAX), 
    education_required VARCHAR(50),
    years_experience INT,
    experience_range VARCHAR(20),  -- new col
    industry VARCHAR(100),
    posting_date VARCHAR(20),
    benefits_score VARCHAR(20),
    company_name VARCHAR(255),
    posting_year INT  -- new col
);

TRUNCATE TABLE silver.ai_jobs_clean;

INSERT INTO silver.ai_jobs_clean (
    job_id, job_title, salary_usd, experience_level, employment_type,
    company_location, company_size, employee_residence, remote_ratio,
    required_skills, education_required, years_experience,experience_range, industry,
    posting_date,
    benefits_score, company_name, posting_year
)
SELECT
    job_id,
    TRIM(job_title),
    TRY_CAST(
    CASE 
        WHEN TRY_CAST(salary_usd AS DECIMAL(15,2)) <= 0 THEN NULL
        ELSE salary_usd
    END AS DECIMAL(15,2)
) AS salary_usd,
    CASE experience_level
        WHEN 'EN' THEN 'Entry'
        WHEN 'MI' THEN 'Mid'
        WHEN 'SE' THEN 'Senior'
        WHEN 'EX' THEN 'Executive'
        ELSE experience_level
    END AS experience_level,
    CASE employment_type
        when 'FL' THEN 'Freelance'
        WHEN 'PT' Then 'Part Time'
        WHEN 'CT' THEN 'Contract'
        WHEN 'FT' THEN ' Full Time'
        ELSE employment_type 
      END AS employment_type,
    company_location,
    CASE company_size
        WHEN 'S' THEN 'Small'
        WHEN 'M' THEN 'Medium'
        WHEN 'L' THEN 'Large'
        ELSE company_size
    END AS company_size,
    employee_residence,
    CASE remote_ratio
        WHEN '100' THEN 'Remote'
        WHEN '50' THEN 'Hybrid'
        WHEN '0' THEN 'On-site'
        ELSE remote_ratio
    END AS work_mode,
    required_skills,
    education_required,
    TRY_CAST(years_experience AS INT),
    CASE 
        WHEN years_experience  BETWEEN 0 AND 2 THEN '0–2'
        WHEN years_experience  BETWEEN 3 AND 5 THEN '3–5'
        WHEN years_experience  BETWEEN 6 AND 10 THEN '6–10'
        WHEN years_experience  > 10 THEN '10+'
        ELSE 'Unknown'
    END AS experience_range,
    industry,
    FORMAT(TRY_CAST(LTRIM(RTRIM(posting_date)) AS DATE), 'dd-MM-yyyy') AS posting_date,
    CASE 
        WHEN TRY_CAST(benefits_score AS DECIMAL(3,1)) IS NULL THEN 'Unknown'
        WHEN TRY_CAST(benefits_score AS DECIMAL(3,1)) < 6.0 THEN 'Poor'
        WHEN TRY_CAST(benefits_score AS DECIMAL(3,1)) < 7.5 THEN 'Fair'
        WHEN TRY_CAST(benefits_score AS DECIMAL(3,1)) < 8.5 THEN 'Good'
        WHEN TRY_CAST(benefits_score AS DECIMAL(3,1)) < 9.5 THEN 'Excellent'
        ELSE 'Outstanding'
    END AS benefits_category,
    company_name,
    YEAR(TRY_CAST(posting_date AS DATE)) AS posting_year
FROM bronze.ai_jobs;

select * from silver.ai_jobs_clean; 


--create table for job skills--
DROP TABLE IF EXISTS silver.job_skills;
CREATE TABLE silver.job_skills (
    job_id VARCHAR(50),
    skill_name VARCHAR(100)
);

INSERT INTO silver.job_skills (job_id, skill_name)
SELECT 
    job_id,
    TRIM(value) AS skill_name
FROM silver.ai_jobs_clean
CROSS APPLY STRING_SPLIT(required_skills, ',') 



--validation --
SELECT job_id, COUNT(*) AS count
FROM silver.ai_jobs_clean
GROUP BY job_id
HAVING COUNT(*) > 1;
--
select distinct industry from silver.ai_jobs_clean; 
--
SELECT DISTINCT job_title
FROM silver.ai_jobs_clean
ORDER BY job_title; 
SELECT 
    (SELECT COUNT(*) FROM bronze.ai_jobs) AS bronze_count,
    (SELECT COUNT(*) FROM silver.ai_jobs_clean) AS silver_count; 
--
 SELECT MIN(salary_usd) AS min_salary, MAX(salary_usd) AS max_salary
FROM silver.ai_jobs_clean;
--
SELECT DISTINCT benefits_score
FROM silver.ai_jobs_clean; 
-- -
SELECT TOP 10 * FROM silver.ai_jobs_clean ORDER BY NEWID();
