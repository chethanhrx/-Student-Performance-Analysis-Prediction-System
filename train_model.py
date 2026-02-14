import pandas as pd
from sklearn.linear_model import LinearRegression
import pickle
import mysql.connector

# Connect to MySQL database
conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='',  # Update if you have a password
    database='student_analysis'
)

# Fetch data from students table
df = pd.read_sql('SELECT attendance, study_hours, previous_score, final_score FROM students', conn)
conn.close()

# Prepare features and target
X = df[['attendance', 'study_hours', 'previous_score']]
y = df['final_score']

# Train model
model = LinearRegression()
model.fit(X, y)

# Save model
with open('flask_app/student_score_model.pkl', 'wb') as f:
    pickle.dump(model, f)

print('Model trained and saved as flask_app/student_score_model.pkl')
