-- Which skills are the most popular for Data Scientists and Data Engineers?

WITH job_skills AS (
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim
    INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
    WHERE
        job_postings_fact.job_title_short = 'Data Scientist' OR job_postings_fact.job_title_short = 'Data Engineer'
    GROUP BY skill_id
)

SELECT 
    job_skills.skill_id,
    skills_dim.skills,
    skill_count
FROM
    job_skills
INNER JOIN skills_dim ON skills_dim.skill_id = job_skills.skill_id
ORDER BY skill_count DESC
LIMIT 15