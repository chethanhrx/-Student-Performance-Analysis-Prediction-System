from flask import Flask, render_template, request, jsonify
import pickle
import numpy as np

app = Flask(__name__)

# Load trained model
import os
# Default to Random Forest model
model_path = os.path.join(os.path.dirname(__file__), 'student_score_model_rf.pkl')
model = pickle.load(open(model_path, 'rb'))

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict():
    try:
        attendance = float(request.form['attendance'])
        study_hours = float(request.form['study_hours'])
        previous_score = float(request.form['previous_score'])
        # Input validation
        errors = []
        if not (0 <= attendance <= 100):
            errors.append('Attendance must be between 0 and 100.')
        if not (0 <= study_hours <= 100):
            errors.append('Study hours must be between 0 and 100.')
        if not (0 <= previous_score <= 100):
            errors.append('Previous score must be between 0 and 100.')
        if errors:
            return jsonify({'error': ' '.join(errors)})
        features = np.array([[attendance, study_hours, previous_score]])
        prediction = model.predict(features)[0]
        # Clamp prediction to 0-100
        prediction = max(0, min(100, prediction))
        return jsonify({'predicted_score': round(prediction, 2)})
    except Exception as e:
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    app.run(debug=True)
