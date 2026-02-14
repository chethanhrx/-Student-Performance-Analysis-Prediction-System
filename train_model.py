import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import r2_score, mean_absolute_error, mean_squared_error
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

# Split data
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Linear Regression
lr_model = LinearRegression()
lr_model.fit(X_train, y_train)
lr_pred = lr_model.predict(X_test)

# Random Forest Regressor
rf_model = RandomForestRegressor(random_state=42)
rf_model.fit(X_train, y_train)
rf_pred = rf_model.predict(X_test)

# Evaluation metrics
def print_metrics(name, y_true, y_pred):
    print(f"\n{name}:")
    print(f"R2 Score: {r2_score(y_true, y_pred):.4f}")
    print(f"MAE: {mean_absolute_error(y_true, y_pred):.4f}")
    print(f"MSE: {mean_squared_error(y_true, y_pred):.4f}")

print_metrics('Linear Regression', y_test, lr_pred)
print_metrics('Random Forest', y_test, rf_pred)

# Save both models
with open('flask_app/student_score_model_lr.pkl', 'wb') as f:
    pickle.dump(lr_model, f)
with open('flask_app/student_score_model_rf.pkl', 'wb') as f:
    pickle.dump(rf_model, f)

print('\nModels trained and saved as:')
print(' - flask_app/student_score_model_lr.pkl (Linear Regression)')
print(' - flask_app/student_score_model_rf.pkl (Random Forest)')
