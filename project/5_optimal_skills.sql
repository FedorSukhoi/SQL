-- What are the optimal skills to learn?


WITH popular_skills AS (
    WITH job_skills AS (
        SELECT
            sj.skill_id,   -- Qualify this reference
            COUNT(*) AS skill_count
        FROM
            skills_job_dim sj  -- Use an alias for clearer reference
        INNER JOIN job_postings_fact jp ON sj.job_id = jp.job_id
        WHERE
            (jp.job_title_short = 'Data Scientist' OR jp.job_title_short = 'Data Engineer') 
            AND jp.salary_year_avg IS NOT NULL
        GROUP BY sj.skill_id
    )

    SELECT 
        js.skill_id,    -- Qualify this reference
        sd.skills,
        js.skill_count
    FROM
        job_skills js
    INNER JOIN skills_dim sd ON sd.skill_id = js.skill_id
),
top_paying_skills AS (
    SELECT
        sj.skill_id,    -- Qualify this reference
        sd.skills,
        ROUND(AVG(jp.salary_year_avg), 2) AS avg_salary
    FROM
        job_postings_fact jp
    INNER JOIN skills_job_dim sj ON jp.job_id = sj.job_id
    INNER JOIN skills_dim sd ON sd.skill_id = sj.skill_id
    WHERE
        (jp.job_title_short = 'Data Scientist' OR jp.job_title_short = 'Data Engineer') 
        AND jp.salary_year_avg IS NOT NULL
    GROUP BY
        sj.skill_id, sd.skills   -- Qualify this reference
)

SELECT 
    ps.skill_id,    -- Qualify this reference
    ps.skills,
    ROUND((POWER(skill_count, 1.0 / 4)*avg_salary/10000), 2) AS optimal_coefficient,
    ps.skill_count,
    tps.avg_salary
FROM 
    popular_skills ps
INNER JOIN top_paying_skills tps ON ps.skill_id = tps.skill_id
ORDER BY 
    optimal_coefficient DESC