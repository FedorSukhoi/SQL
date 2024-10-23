# SQL Analysis of the data job market. Focus on Data Scientists & Engineers

## Introduction
This README gives a deep dive into the peculiarities of the data industry, focusing on Data Scientists & Engineers. There are 5 chapters in this README. All the csv files with the data are acessible through *Project_csvs* folder. Huge props to Luke Barousse and his course on SQL.

## 1. The analysis of the top 40 jobs by salary

```sql
SELECT
    job_id,
    job_title_short,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short IN ('Data Scientist', 'Data Engineer')
    AND job_location = 'Anywhere'
    AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 40
```

**Data Scientists Salaries:**

Salary Averaging Method:
Average of top five Data Scientists’ salaries: **425,500$**.

According to research, Selby Jennings offers the highest payment of **550,000$** to a data scientist.

Notably, there are a number of high salaries for Data Scientists which include:

- *Selby Jennings: 525,000$*
- *Algo Capital Group: 375,000$*
- *Demandbase: 351,500$*
- *Demandbase: 324,000$*

**Data Engineering Salaries:**

Salary Averaging Method:

Average of top five Data Engineers’ salaries: **290,200$**.

Out of the Data Engineers, Engtal provides the highest salary of **325,000$**.

Other notable salaries include:

- *Engtal: 325,000$*
- *Durlston Partners: 300,000$*
- *Twitch: 251,000$*
- *Signify Technology: 250,000$*


**Key Takeaways**

Several organizations employ data scientists offering high salaries for this occupation, resulting in Data Scientists getting paid higher than Data Engineers. According to the analysis the average salary for Data Scientists is about 425,500 compared to that of Data Engineers which is 290,200.

Data Scientists employ two of the highest organizers: Selby Jennings and Demandbase who offer one of the highest salaries of 550,000 and 375,000 to data scientists respectively.

As for Data Engineers, Engtal offers 325,000 for the best candidate.

## 2. High-Paying Skills

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_title_short IN ('Data Scientist', 'Data Engineer')
        AND job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 40
)

SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
```

The goal of this chapter is to discover the most popular skills within the most high-paying roles, yet the code above doesn't show the counts of skills, rather it just shows the skills needed for every position in the top 40. It's possible to fix it.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_title_short IN ('Data Scientist', 'Data Engineer')
        AND job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 40
),
top_paying_skills AS (
    SELECT
        top_paying_jobs.*,
        skills
    FROM top_paying_jobs
    INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    ORDER BY
        salary_year_avg DESC
)

SELECT 
    COUNT(*) as skill_count,
    skills
FROM top_paying_skills
GROUP BY skills
ORDER BY skill_count DESC
```

### Key Observations

**Top Skills:**
- Python: Dominates the list with 25 mentions, indicating it is the most essential skill for the roles considered.
- SQL: A critical database language, mentioned 15 times, showing its importance in data manipulation and querying.
- Spark: With 13 mentions, it highlights the relevance of big data processing skills.

**Skills with Higher Demand:**

Tableau and AWS, both with 9 mentions, show a significant demand for data visualization and cloud computing skills, which are crucial in modern data environments.
Hadoop and various machine learning frameworks (like TensorFlow and PyTorch) are also considerable, indicating a trend towards big data technologies and machine learning applications.

**Programming Languages:**

Other programming languages like Java, Scala, and data manipulation libraries such as Pandas and NumPy suggest a well-rounded requirement for software development capabilities in data roles.

## 3. High-Demand Skills
```sql
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
```

### Key Observations

**Primary Skill Trends:**

- Python emerges as the most sought-after skill with 222,281 mentions, making it critical for both Data Scientists and Data Engineers. The prominence of Python aligns with its versatility in data manipulation, analysis, and machine learning.
- SQL, with 192,549 mentions, is another foundational skill demonstrating the importance of database querying and management in data roles.

**Cloud Technologies:**

Skills such as AWS and Azure are in high demand, with counts of 88,485 and 82,521 respectively. This indicates a growing reliance on cloud platforms within the data ecosystem, essential for building scalable and flexible data solutions.

*Data Processing Frameworks:*
Spark and Hadoop, both critical for big data processing, show substantial counts (78,142 and 44,458 respectively). This suggests an important trend toward utilizing distributed computing frameworks in data engineering and analytics.

*Visualization and Reporting:*
Skills such as Tableau and Power BI indicate essential tools for data visualization, with counts of 48,328 and 34,638. This reflects the increasing importance of data presentation skills, particularly for Data Scientists who need to communicate their findings effectively.

**Notable Differences**

*Despite the overlaps in required skills, we can identify specific trends:*
Data Scientists typically place greater emphasis on skills related to statistical analysis and machine learning (e.g., R, Python, and tools like Tableau and Power BI) for data visualization and interpretation. The demand for R (72,451) indicates a focus on statistical modeling and analysis.
Data Engineers, on the other hand, tend to emphasize skills related to data infrastructure and architecture with a stronger focus on Apache technologies (Hadoop, Spark) and cloud services (AWS, Azure). The higher counts for AWS and Azure reflect this focus on cloud computing for data management.

## 4. Top-paying Skills

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 2) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    (job_postings_fact.job_title_short = 'Data Scientist' OR job_postings_fact.job_title_short = 'Data Engineer') AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25
```

The analysis of the average salaries for various technical skills reveals insights into the demand and value placed on specific programming languages, tools, and platforms in the tech industry.

1. **Top Salaries**: The highest average salary listed is for individuals skilled in Asana, with an average of approximately $188,610. This suggests a strong demand for project management skills integrated with software tools, indicating employers are willing to pay a premium for expertise in effectively managing workflows.

2. **Competitive Tools**: Skills related to systems and databases such as MongoDB and Airtable have average salaries around $176,055 and $174,550 respectively. This emphasizes the high valuation placed on data management and storage competencies, crucial for modern software applications that require effective database interactions and data integrity.

3. **Developer Frameworks**: Node.js skills garner an average of about $170,505, reflecting the popularity of JavaScript and server-side scripting, which are integral to modern web development and creating scalable network applications. Other related technologies like Lua and Solidity (averaging $170,500 and $166,771 respectively) show that specialized programming languages tied to specific applications—such as game development and smart contracts—also command high salaries.

4. **Data Science and Machine Learning**: Skills in data manipulation and machine learning libraries, represented by Dplyr and PyTorch (averaging $163,111 and $144,723 respectively), are in significant demand as companies increasingly leverage data for competitive advantage. The inclusion of tools like Hugging Face signifies the ongoing emphasis on AI and machine learning technologies.

5. **Development Frameworks and Libraries**: Ruby on Rails remains a strong contributor to average salary totals at approximately $148,250, reflecting the enduring popularity of the framework for web applications. This suggests that expertise in backend development frameworks remains lucrative as businesses prioritize rapid deployment and prototyping.

6. **Insights into Collaborative and Development Tools**: Skills in platforms like Slack and Zoom, averaging around $143,858 and $143,362, indicate how critical collaboration tools have become in a hybrid work environment—highlighting the need for expertise that enables effective communication and project management.

7. **Emerging Technologies and Big Data**: Cassandra and Neo4j skills show healthy average salaries ($149,090 and $146,794), pointing towards the growing importance of NoSQL databases in handling large volumes of unstructured data. Similarly, skills in Kafka ($142,629) demonstrate the increasing reliance on event streaming platforms to achieve real-time data processing.

8. **General Trends**: Other technologies such as Scala and OpenStack are also well-compensated, suggesting that skills in both functional programming and cloud infrastructure remain vital as organizations look to innovate and scale.

In summary, the average salaries reflect a competitive landscape where specific programming languages, frameworks, and tools that facilitate efficient data handling, effective project management, and seamless collaboration are highly valued. The continuing evolution of technology indicates that demand for these skills is likely to persist, if not increase, further driving compensation upward in these areas.


## 5. The optimal skills

```sql
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
```

Analyzing the provided data on skills, skill counts, and average salaries I have decided to implement an optimal coefficient for grading the skills. The point is to multiply yearly salary by fourth root of count. It is like that to decrease the effect of the 

1. **Top Skills by Average Salary**:
- **MongoDB** has the highest average salary of approximately $176,055. This showcases the demand for expertise in NoSQL databases, crucial for handling unstructured data and supporting modern application architectures.
- **Python** and **SQL** also command competitive averages of about $135,592 and $133,416 respectively. Given their foundational role in data manipulation and analysis, proficiency in these languages is essential for any data professional.

2. **Emerging Technologies**:
- Skills in **Spark** and **Hadoop** are valuable for data processing and big data frameworks, with average salaries of around $139,222 and $135,992. As the need for processing large datasets grows, familiarity with these frameworks becomes increasingly critical for data engineers.
- **AWS** and **Azure**, representing cloud computing capabilities, have average salaries of $135,686 and $130,273 respectively. Mastery in cloud platforms is imperative as businesses transition to scalable cloud solutions for data storage and processing.

3. **Machine Learning and Data Science**:
- Tools like **TensorFlow** ($141,989) and **PyTorch** ($144,723) show the increasing integration of machine learning within data science workflows. Upskilling in these libraries is a strategic move as they become standard for implementing AI solutions.
- Data visualization tools such as **Tableau** ($128,980) emphasize the significance of presenting data insights effectively. As data-driven decision-making expands, the ability to communicate data visually will enhance the value of data professionals.

4. **Specialized Skills**:
- **Scala** (average salary $143,776) is particularly relevant for data engineering roles, especially involving Apache Spark. Knowledge of functional programming will offer a competitive edge.
- **Kubernetes** and **Docker**, both related to container orchestration and application deployment, are increasingly sought after. Their importance is underscored by the guaranteed average salaries (around $139,562 and $131,550). As data pipelines grow more complex, understanding containerized applications can facilitate smoother deployment processes.

5. **Essential Data Management Skills**:
- **Git** and **GitLab** are crucial for version control in collaborative environments, enhancing project management efficiency. Despite lower average salaries, these skills are fundamental to successful team dynamics in data projects.
- Proficiency in **Airflow** (average salary $140,304) indicates the necessity of workflow management for data pipelines. Understanding orchestration methods is critical to ensuring data processes are efficient and timely.

6. **Observations on Skill Count and Demand**:
- Python and SQL have the highest skill counts (7353 and 6340), reflecting their widespread use and importance. Mastery in these areas is foundational, essential for any data-centric role.
- Skills in newer technologies (like **Apache Kafka**, with an average salary of $142,629 and a skill count of 1,010) highlight a shift towards real-time data processing, making expertise in streaming technologies increasingly relevant.

**Conclusion**: Data scientists and engineers should prioritize learning and mastering Python, SQL, big data technologies (Spark, Hadoop), cloud platforms (AWS, Azure), and machine learning frameworks (TensorFlow, PyTorch). Additionally, skills related to containerization (Kubernetes, Docker) and workflow management (Airflow) are becoming indispensable as data processes evolve. Continuous learning in these areas will ensure that professionals remain competitive and capable of meeting the demands of the data-driven landscape in the years to come.


## Thoughts of a student, upon completing the course

I am aspiring to become either a Data Scientist or a Data Engineer, hence the choice of my field of analysis. Throughout this course I have discovered a ton of useful information about SQL and it's use. While I had some knowledge about the process of coding itself, the vscode set up was extremely new. It differs from Python and it was an unexpected discovery. Was it worth it? Financially? 100%, cause it was free. Timewise? 101%.