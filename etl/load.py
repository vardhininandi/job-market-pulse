import pandas as pd
from sqlalchemy import create_engine, text

#-----Configure----
DB_USER = "root"
DB_PASSWORD = ""
DB_HOST = "localhost"
DB_PORT = "3306"
DB_NAME = "job_market_db"

CLEANED_PATH = r"C:\Users\Vardhini Nandi\OneDrive\Desktop\job-market-pulse\data\exports\postings_cleaned.csv"

#----Connect to MySQL------
print("Connecting to MySQL...")
engine = create_engine( f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}",
                       connect_args= {"local_infile": 1})

#-----Test connection------
with engine.connect() as conn:
    conn.execute(text("SELECT 1"))
    print("Connected to MySQL successfully!")

#--------Load cleaned Data-------------
print("Loading cleaned CSV...")
cols = ['job_id', 'company_name', 'title', 'location', 'formatted_experience_level', 'work_type', 'min_salary', 'max_salary', 'pay_period', 'has_valid_salary', 'views', 'formatted_work_type']
df = pd.read_csv(CLEANED_PATH, usecols= cols)
print(f"Rows: {len(df)}, Cols: {len(df.columns)}")

#------Push to MySQL--------
print("Pushing to MySQL...")
df.to_sql(
    name = "job_postings",
    con = engine,
    if_exists = "replace", #recreate table if it already exists
    index = False,
    chunksize = 5000, #bigger chunks for faster approach
    method= "multi"   #batch insert therefore much faster
)

print(f" {len(df)} rows loaded into job_market_db.job_postings!")