



import pandas as pd
from sklearn.ensemble import RandomForestRegressor
import random

file_path = "C:/Users/User/Desktop/FitFlow/ML/ML2/exercises - Easy Workouts.csv"
data = pd.read_csv(file_path)

X = data[['Sets', 'Reps', 'ExerciseCaloriesBurnt']]
y = data['TotalCaloriesBurnt']
model = RandomForestRegressor()
model.fit(X, y)

def generate_workout(calories_required):
    predicted_workout = model.predict([[0, 0, calories_required]])

    selected_exercises = data[data['TotalCaloriesBurnt'] <= predicted_workout[0] + 10]
    selected_exercises = selected_exercises.sample(n=5)  # Select 5 exercises randomly

    print("Exercise                                 Sets    Reps")
    for index, row in selected_exercises.iterrows():
        print(f"{row['Exercise']: <40}{row['Sets']: <8}{row['Reps']: <6}")




input_calories = int(input("Enter the desired calorie expenditure: "))

generate_workout(input_calories)






