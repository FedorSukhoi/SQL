
SELECT
    q1_postings.job_title_short,
    q1_postings.job_location,
    q1_postings.job_via,
    q1_postings.job_posted_date::date,
    q1_postings.salary_year_avg
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS q1_postings
WHERE
    q1_postings.salary_year_avg > 100000 AND 
    q1_postings.job_title_short IN ('Data Scientist', 'Data Engineer')
ORDER BY salary_year_avg DESC