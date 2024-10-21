-- Subquery

SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs;


SELECT 
    company_id,
    name AS company_name
FROM
    company_dim
WHERE company_id IN (
    SELECT company_id
    FROM job_postings_fact
    WHERE job_no_degree_mention = true
    ORDER BY company_id
);




-- CTE (commomn table expression)

WITH january_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)

SELECT *
FROM january_jobs;



WITH company_job_count AS (
    SELECT 
        job_postings_fact.company_id,
        COUNT(*) AS job_count,
        company_dim.name AS company_name
    FROM 
        job_postings_fact
    JOIN 
        company_dim ON job_postings_fact.company_id = company_dim.company_id
    GROUP BY 
        job_postings_fact.company_id, company_dim.name
)

SELECT *
FROM company_job_count
ORDER BY job_count DESC