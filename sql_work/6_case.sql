SELECT
    COUNT(job_id) AS jobs_count,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location LIKE '%Moscow%' THEN 'Local'
        WHEN 
            job_location LIKE '%Russia%' OR 
            job_location LIKE '%Ukraine%' OR 
            job_location LIKE '%Belarus%' OR 
            job_location LIKE '%Finland%'
            THEN 'Rather Local'
        ELSE 'Onsite'
    END as location_category
FROM job_postings_fact
WHERE
    job_title_short = 'Data Scientist'
GROUP BY
    location_category
ORDER BY 
    jobs_count;


SELECT
    COUNT(job_id) AS jobs_count,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location LIKE '%Moscow%' THEN 'Local'
        WHEN 
            job_location LIKE '%Russia%' OR 
            job_location LIKE '%Ukraine%' OR 
            job_location LIKE '%Belarus%' OR 
            job_location LIKE '%Finland%'
            THEN 'Rather Local'
        ELSE 'Onsite'
    END as location_category
FROM job_postings_fact
WHERE
    job_title_short = 'Data Engineer'
GROUP BY
    location_category
ORDER BY 
    jobs_count;