import pandas as pd
import os
#-------Paths-------------
RAW_PATH = "../data/raw/postings.csv"
EXPORT_PATH = "../data/exports/postings_cleaned.csv"
#--------Load------------- 
print('Loading raw data..')
df = pd.read_csv(RAW_PATH)
print(f"Raw shape: {df.shape}")

#-----Drop useless columns------
drop_cols = ['closed_time', 'skills_desc', 'med_salary', 'remote_allowed', 'applies']
df = df.drop(columns= drop_cols)

#-----Drop rows with missing companynames-----
df = df.dropna(subset = ['company_name'])

#----Fill missing experience levels-----
df['formatted_experience_level'] = df['formatted_experience_level'].fillna('Not Specified')

#-----Clean Salary outliers-----
#Flag rows with valid yearly salary range
df['has_valid_salary'] = (
    (df['pay_period'] == 'YEARLY') &
    (df['min_salary'] >= 10000) &
    (df['max_salary'] <= 500000)
)

#----Save----
os.makedirs("..data/exports", exist_ok = True)
df.to_csv(EXPORT_PATH, index = False)

print(f"Cleaned shape: {df.shape}")
print(f"Saved to {EXPORT_PATH}")