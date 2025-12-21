use ai_jobs; 

IF OBJECT_ID('bronze.ai_jobs', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.ai_jobs;
END
GO 

CREATE TABLE bronze.ai_jobs (
    job_id                  VARCHAR(50),
    job_title               VARCHAR(255),
    salary_usd              VARCHAR(50),
    salary_currency         VARCHAR(10),
    experience_level        VARCHAR(50),
    employment_type         VARCHAR(50),
    company_location        VARCHAR(100),
    company_size            VARCHAR(50),
    employee_residence      VARCHAR(100),
    remote_ratio            VARCHAR(50),
    required_skills         VARCHAR(MAX),
    education_required      VARCHAR(100),
    years_experience        VARCHAR(50),
    industry                VARCHAR(100),
    posting_date            VARCHAR(50),
    application_deadline    VARCHAR(50),
    job_description_length  VARCHAR(50),
    benefits_score          VARCHAR(50),
    company_name            VARCHAR(255)
);
GO 

TRUNCATE TABLE bronze.ai_jobs;
BULK INSERT bronze.ai_jobs
FROM 'C:\Users\user\Desktop\BIIIII\ai_job_dataset (2).csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    TABLOCK
);



select * from bronze.ai_jobs; 

SELECT COUNT(*) AS total_rows
FROM bronze.ai_jobs;

SELECT TOP 10 *
FROM bronze.ai_jobs;
