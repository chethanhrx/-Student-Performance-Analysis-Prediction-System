from flask import Flask, render_template, request, jsonify
import pickle
import numpy as np

app = Flask(__name__)

# Load trained model
import os
model_path = os.path.join(os.path.dirname(__file__), 'student_score_model.pkl')
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
        features = np.array([[attendance, study_hours, previous_score]])
        prediction = model.predict(features)[0]
        return jsonify({'predicted_score': round(prediction, 2)})
    except Exception as e:
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    app.run(debug=True)
