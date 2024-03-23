



import pandas as pd
from sklearn.ensemble import RandomForestRegressor
import random

file_path = r"C:\Users\File\FitFlow\ML\ML2\exercises - Easy Workouts.csv" # File path to the dataset

data = pd.read_csv(file_path)# Reading the dataset into a pandas DataFrame

# Separating features (X) and target variable (y)
X = data[['Sets', 'Reps', 'ExerciseCaloriesBurnt']]
y = data['TotalCaloriesBurnt']

# Initializing the Random Forest Regressor model
model = RandomForestRegressor()

model.fit(X, y)# Fitting the model to the data

# Function to generate a workout plan based on desired calorie expenditure
def generate_workout(calories_required):
    predicted_workout = model.predict([[0, 0, calories_required]])# Predicting the required workout based on desired calorie expenditure

    selected_exercises = data[data['TotalCaloriesBurnt'] <= predicted_workout[0] + 10]# Selecting exercises with total calories burnt close to the predicted value

    selected_exercises = selected_exercises.sample(n=5)  # Select 5 exercises

    print("Exercise                                 Sets    Reps")# Printing the workout plan
    for index, row in selected_exercises.iterrows():
        print(f"{row['Exercise']: <40}{row['Sets']: <8}{row['Reps']: <6}")




input_calories = int(input("Enter the desired calorie expenditure: "))# Taking user input for desired calorie expenditure

generate_workout(input_calories)# Generating and printing the workout plan based on user input






