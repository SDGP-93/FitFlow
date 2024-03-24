
import pandas as pd
from sklearn.ensemble import RandomForestRegressor
import random

file_path = r"C:/Users/User/Desktop/FitFlow/ML/ML2/exercises - Easy Workouts.csv"
 

data = pd.read_csv(file_path)# Read the dataset 

# get Separating features (X) and target variable (y)
X = data[['Sets', 'Reps', 'ExerciseCaloriesBurnt']]
y = data['TotalCaloriesBurnt']

# Initializing the  model
model = RandomForestRegressor()

model.fit(X, y)# Fit the model to the data

def generate_workout(calories_required):
    predicted_workout = model.predict([[0, 0, calories_required]])# Predict the  workout

    selected_exercises = data[data['TotalCaloriesBurnt'] <= predicted_workout[0] + 10]# Select exercises 

    selected_exercises = selected_exercises.sample(n=5)  # Select 5 exercises

    print("Exercise                                 Sets    Reps")# Print the workout plan
    for index, row in selected_exercises.iterrows():
        print(f"{row['Exercise']: <40}{row['Sets']: <8}{row['Reps']: <6}")




input_calories = int(input("Enter the desired calorie expenditure: "))# Taking user input 
if (input_calories>300):
    input_calories=300

generate_workout(input_calories)# Generating and printing the workout plan






