#  Job Market Pulse — Salaries, Companies and Hiring Trends

A complete end-to-end data analytics project built on **122,000+ real job postings** from LinkedIn.  
This project answers a single powerful question:

> **What does the job market really look like : which roles are most in demand, which companies hire the most, and where do the highest salaries come from?**

---

##  Dashboard Preview

> ![Dashboard](dashboard.png)

---

##  Key Insights

-  **Sales Manager** is the most in-demand job title with **669 postings**
-  **Executive level** roles average **$201,926/year** — more than double Entry Level ($89,535)
-  **Liberty Healthcare and Rehabilitation Services** leads all companies with **1,108 postings**
-  **San Mateo, CA** has the highest average salary at **$253,968 avg max salary**
-  **81% of all job postings** are Full Time roles

---

##  Tech Stack

| Tool | Purpose |
|------|---------|
| Python (Pandas) | Data cleaning & ETL pipeline |
| MySQL (via XAMPP) | Data storage & SQL analysis |
| MySQL Workbench | Schema design & query execution |
| Excel | Stakeholder summary report with pivot tables |
| Power BI | Interactive dashboard |

---

##  Folder Structure

```
job-market-pulse/
├── data/
│   ├── raw/                  ← Original Kaggle CSV (never modified)
│   └── exports/              ← Cleaned CSV + SQL query exports
├── etl/
│   ├── clean.py              ← Standalone cleaning script
│   └── load.py               ← Loads cleaned data into MySQL
├── sql/
│   ├── Schema.sql            ← Table definitions
│   └── Analysis.sql          ← 5 business queries with insights
├── excel/
│   └── job_market_summary.xlsx  ← Pivot table report
└── powerbi/
    └── job_market_pulse.pbix    ← Interactive dashboard
```

---

##  Dataset

- **Source:** [LinkedIn Job Postings — Kaggle](https://www.kaggle.com/datasets/arshkon/linkedin-job-postings)
- **Raw data:** 123,849 rows × 31 columns
- **Cleaned data:** 122,130 rows × 26 columns
- **Valid salary rows:** 18,329 (yearly, $10K–$500K range)

---

##  How the Data Flows

```
Raw CSV (Kaggle)
     ↓
Python cleans it        ← etl/clean.py
     ↓
MySQL stores it         ← etl/load.py → job_market_db
     ↓
SQL analyzes it         ← sql/Analysis.sql (5 queries)
     ↓
Excel reports it        ← excel/job_market_summary.xlsx
     ↓
Power BI visualizes it  ← powerbi/job_market_pulse.pbix
```

---

##  Data Cleaning (clean.py)

- Dropped 5 columns with 95%+ missing values (`closed_time`, `skills_desc`, `med_salary`, `remote_allowed`, `applies`)
- Dropped rows with missing `company_name` (1.39% of data)
- Filled missing `formatted_experience_level` with `'Not Specified'`
- Flagged valid salary rows: yearly pay period, $10K–$500K range

---

##  SQL Analysis (Analysis.sql)

Five queries answering real business questions:

| Query | Question | Key Finding |
|-------|----------|-------------|
| `skills_demand` | Top 15 job titles by postings | Sales Manager leads with 669 |
| `salary_by_title` | Avg salary by experience level | Executive: $201K vs Entry: $89K |
| `top_companies` | Top 15 hiring companies | Liberty Healthcare: 1,108 postings |
| `worktype_breakdown` | Work type by experience level | 80% of jobs are Full Time |
| `salary_by_location` | Avg salary by city | San Mateo, CA tops at $253K |

**SQL concepts used:** `GROUP BY`, `HAVING`, `ROUND`, `AVG`, `COUNT`, `CASE WHEN`, `Window Functions (PARTITION BY)`

---

##  Power BI Dashboard

**Connected live to MySQL via ODBC.** The dashboard includes:

-  **4 KPI Cards** : Total Postings, Avg Mid Salary, Top Company, Top Job Title
-  **Top 15 Job Titles** : Horizontal bar chart
-  **Avg Salary by Experience Level** : Bar chart sorted by salary
-  **Top 15 Hiring Companies** : Bar chart by posting volume
-  **Work Type Breakdown** : Donut chart (Full Time dominates at 81%)
-  **Top 10 Cities by Average Salary** : Bar chart with salary range
-  **2 Slicers** : Filter by Experience Level and Work Type

**DAX Measures written:**
```
Avg Mid Salary = AVERAGEX(
    FILTER(job_postings,
        job_postings[min_salary] > 10000 &&
        job_postings[max_salary] < 500000 &&
        job_postings[pay_period] = "YEARLY"
    ),
    (job_postings[min_salary] + job_postings[max_salary]) / 2
)

Total Full Time = CALCULATE(
    COUNT(job_postings[job_id]),
    job_postings[work_type] = "FULL_TIME"
)
```

---

##  How to Run This Project

**Prerequisites:** Python 3.x, XAMPP (MySQL), Power BI Desktop, MySQL Workbench

```bash
# 1. Clone the repo
git clone https://github.com/vardhininandi/job-market-pulse.git
cd job-market-pulse

# 2. Install Python dependencies
pip install pandas sqlalchemy pymysql openpyxl

# 3. Download dataset from Kaggle
# Place postings.csv in data/raw/

# 4. Run the cleaning script
cd etl
python clean.py

# 5. Start MySQL in XAMPP, create database
# In MySQL Workbench: CREATE DATABASE job_market_db;
# Run sql/Schema.sql

# 6. Load data into MySQL
python load.py

# 7. Open Power BI dashboard
# Open powerbi/job_market_pulse.pbix
# Reconnect to your local MySQL via ODBC if prompted
```

---

##  Author

**Vardhini Nandi**  
Aspiring Data Analyst | Python · SQL · Excel · Power BI  
[LinkedIn](https://linkedin.com/in/vardhini-nandi-129541275/) · [GitHub](https://github.com/vardhininandi)
