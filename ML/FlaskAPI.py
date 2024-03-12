from flask import Flask, request, jsonify
from flask_cors import CORS  # Import CORS from flask_cors module
import pandas as pd
from sklearn.ensemble import RandomForestRegressor
import random
from joblib import load
import numpy as np

app = Flask(__name__)
CORS(app)  # Initialize CORS with your Flask app

# Load the BMR models
loaded_model_male_bmr = load(r'C:\Users\hp\Desktop\ModelsUpdated\FitFlow\ML\TDEE_ML\trained_model_male_bmr.joblib')
loaded_model_female_bmr = load(r'C:\Users\hp\Desktop\ModelsUpdated\FitFlow\ML\TDEE_ML\trained_model_female_bmr.joblib')

file_path = "ML\ML2\exercises - Easy Workouts.csv"
data = pd.read_csv(file_path)

X = data[['Sets', 'Reps', 'ExerciseCaloriesBurnt']]
y = data['TotalCaloriesBurnt']
model = RandomForestRegressor()
model.fit(X, y)

def generate_workout(calories_required):
    predicted_workout = model.predict([[0, 0, calories_required]])

    selected_exercises = data[data['TotalCaloriesBurnt'] <= predicted_workout[0] + 10]
    selected_exercises = selected_exercises.sample(n=5)  # Select 5 exercises randomly

    workouts = []
    for index, row in selected_exercises.iterrows():
        workout = {
            "Exercise": row['Exercise'],
            "Sets": row['Sets'],
            "Reps": row['Reps']
        }
        workouts.append(workout)

    return workouts

@app.route('/generate_workout', methods=['POST'])
def get_workout():
    input_calories = request.json.get('calories_required')
    if input_calories is None:
        return jsonify({'error': 'Calories required not provided'}), 400

    workouts = generate_workout(input_calories)
    return jsonify(workouts)


@app.route('/calculate_bmr', methods=['POST'])
def calculate_bmr():
    data = request.json
    gender = data.get('gender', '').lower()
    weight = data.get('weight', 0)
    activity_lvl = data.get('activity_level', 1)

    if gender not in ['male', 'female']:
        return jsonify({'error': 'Invalid gender'}), 400

    input_weight_array = np.array([[weight]])

    if gender == 'male':
        predicted_bmr = loaded_model_male_bmr.predict(input_weight_array)
    else:
        predicted_bmr = loaded_model_female_bmr.predict(input_weight_array)

    activity_multipliers = [1.2, 1.375, 1.55, 1.725, 1.9]
    if 1 <= activity_lvl <= 5:
        tdee = predicted_bmr * activity_multipliers[activity_lvl - 1]
    else:
        return jsonify({'error': 'Invalid activity level'}), 400

    return jsonify({'predicted_bmr': predicted_bmr.tolist(), 'tdee': tdee.tolist()})

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
