
-- GOLD: date dimension : --> Job demand over time -- 
CREATE TABLE gold.dim_date (
    date_key INT IDENTITY(1,1) PRIMARY KEY,
    posting_date DATE,
    year INT,
    month INT,
    quarter VARCHAR(2)
);

INSERT INTO gold.dim_date (posting_date, year, month, quarter)
SELECT DISTINCT
    TRY_CONVERT(DATE, posting_date, 103) AS full_date,
    YEAR(TRY_CONVERT(DATE, posting_date, 103)) AS year,
    MONTH(TRY_CONVERT(DATE, posting_date, 103)) AS month,
    CONCAT('Q', DATEPART(QUARTER, TRY_CONVERT(DATE, posting_date, 103))) AS quarter
FROM silver.ai_jobs_clean
WHERE TRY_CONVERT(DATE, posting_date, 103) IS NOT NULL;

select * from gold.dim_date; 

-- GOLD: job dimension : show roles and seniority -->Used for:Job demand by role and Avg salary by role -- 
CREATE TABLE gold.dim_job (
    job_key INT IDENTITY(1,1) PRIMARY KEY,
    job_title VARCHAR(255),
    experience_level VARCHAR(50)
);

INSERT INTO gold.dim_job
SELECT DISTINCT job_title, experience_level
FROM silver.ai_jobs_clean;

select * from gold.dim_job;

--GOLD: location dimension: geography: used for Job demand by country and salary variation -- 
CREATE TABLE gold.dim_location (
    location_key INT IDENTITY(1,1) PRIMARY KEY,
    company_location VARCHAR(100)
);

INSERT INTO gold.dim_location
SELECT DISTINCT company_location
FROM silver.ai_jobs_clean;
select * from gold.dim_location;


--GOLD: company dimansion :organization context -- 
CREATE TABLE gold.dim_company (
    company_key INT IDENTITY(1,1) PRIMARY KEY,
    company_name VARCHAR(255),
    company_size VARCHAR(50),
    industry VARCHAR(100)
);

INSERT INTO gold.dim_company
SELECT DISTINCT company_name, company_size, industry
FROM silver.ai_jobs_clean;
select * from gold.dim_company;

--gold: experiece dimensions: carrer profile-- 
CREATE TABLE gold.dim_experience (
    experience_key INT IDENTITY(1,1) PRIMARY KEY,
    years_experience INT,
    experience_range VARCHAR(20),
    education_required VARCHAR(50)
);

INSERT INTO gold.dim_experience
SELECT DISTINCT years_experience, experience_range, education_required
FROM silver.ai_jobs_clean;
select * from gold.dim_experience;

-- GOLD: work dimensions: conditions -- 
CREATE TABLE gold.dim_work (
    work_key INT IDENTITY(1,1) PRIMARY KEY,
    employment_type VARCHAR(50),
    work_arrangement VARCHAR(50),
    benefits_score VARCHAR(50)
);

INSERT INTO gold.dim_work
SELECT DISTINCT employment_type, remote_ratio, benefits_score
FROM silver.ai_jobs_clean;
select * from gold.dim_work;

--GOLD: skill dimansions-- 
CREATE TABLE gold.dim_skill (
    skill_key INT IDENTITY(1,1) PRIMARY KEY,
    skill_name VARCHAR(100)
);

INSERT INTO gold.dim_skill
SELECT DISTINCT TRIM(value)
FROM silver.ai_jobs_clean
CROSS APPLY STRING_SPLIT(required_skills, ',');
select * from gold.dim_skill;

-- FACT TABLE --
CREATE TABLE gold.fact_ai_jobs (
    fact_id INT IDENTITY(1,1) PRIMARY KEY,
    date_key INT,
    job_key INT,
    location_key INT,
    company_key INT,
    experience_key INT,
    work_key INT,
    salary_usd DECIMAL(15,2),
    job_count INT DEFAULT 1
);
INSERT INTO gold.fact_ai_jobs (
    date_key,
    job_key,
    location_key,
    company_key,
    experience_key,
    work_key,
    salary_usd,
    job_count
)
SELECT
    d.date_key,
    j.job_key,
    l.location_key,
    c.company_key,
    e.experience_key,
    w.work_key,
    s.salary_usd,
    1
FROM (
    SELECT *,
           TRY_CONVERT(DATE, posting_date, 103) AS posting_date_clean
    FROM silver.ai_jobs_clean
) s
LEFT JOIN gold.dim_date d
    ON s.posting_date_clean = d.posting_date
LEFT JOIN gold.dim_job j
    ON s.job_title = j.job_title
   AND s.experience_level = j.experience_level
LEFT JOIN gold.dim_location l
    ON s.company_location = l.company_location
LEFT JOIN gold.dim_company c
    ON s.company_name = c.company_name
LEFT JOIN gold.dim_experience e
    ON s.years_experience = e.years_experience
   AND s.education_required = e.education_required
LEFT JOIN gold.dim_work w
    ON s.remote_ratio = w.work_arrangement
   AND s.benefits_score = w.benefits_score
WHERE s.posting_date_clean IS NOT NULL;

select * from gold.fact_ai_jobs;

-- VALIDATION--

-- Check how many rows loaded:
SELECT COUNT(*) FROM gold.fact_ai_jobs;

-- Check missing date keys
SELECT COUNT(*) 
FROM gold.fact_ai_jobs
WHERE date_key IS NULL;
