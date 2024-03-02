import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error
import joblib
import warnings

# Suppressing user warnings from scikit-learn
warnings.filterwarnings("ignore", category=UserWarning)

# Load dataset
dataset = pd.read_csv("C:/Users/File/Desktop/workouts model/workout model/WorkoutData.csv")

# Data Preprocessing
# Drop rows with missing values
dataset.dropna(inplace=True)

# Prepare data for training
X = dataset[['Sets', 'Reps']]  # Features
y = dataset['Calories Burned (per workout)']  # Target variable

# Split data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Initialize and train the model
model = LinearRegression()
model.fit(X_train, y_train)

# Make predictions on the test set
y_pred = model.predict(X_test)

# Evaluate the model
mse = mean_squared_error(y_test, y_pred)
print("Mean Squared Error:", mse)

# Save the model for later use
joblib.dump(model, 'workout_calories_model.pkl')


def generate_workout_plan(calories_burned, workout_plan_number):
    # Load the trained model
    model = joblib.load('workout_calories_model.pkl')

    # Default number of sets and reps
    default_sets = 3
    default_reps = 10

    # Predict the number of sets and reps based on the input calories
    predicted_calories = model.predict([[default_sets, default_reps]])

    # Calculate the difference between predicted and input calories
    calorie_difference = calories_burned - predicted_calories

    # Adjust sets and reps based on the calorie difference
    sets = int(default_sets + calorie_difference.item() // 100)  # Convert to integer
    reps = int(default_reps + calorie_difference.item() // 50)  # Convert to integer

    # Select exercises based on the workout plan number
    selected_exercises = dataset.loc[dataset['PN'] == workout_plan_number, 'Exercise']
    selected_descriptions = dataset.loc[dataset['PN'] == workout_plan_number, 'Description']
    selected_reps = reps
    selected_sets = sets
    selected_calories = selected_reps * selected_sets * 10  # Arbitrary value for demonstration

    # Construct the workout plan
    workout_plan = {
        "Workout Plan Number": workout_plan_number,
        "Exercises": selected_exercises.tolist(),
        "Descriptions": selected_descriptions.tolist(),
        "Reps": [selected_reps] * len(selected_exercises),
        "Sets": [selected_sets] * len(selected_exercises),
        "Calories Burned (per workout)": [selected_calories] * len(selected_exercises)
    }

    return workout_plan


def main():
    print("Welcome to the Workout Planner Console Menu!!!")
    while True:
        print("\nSelect an option:")
        print("1. Generate Workout Plan")
        print("2. Exit")
        choice = input("Enter your choice: ")

        if choice == '1':
            try:
                calories_burned = int(input("Enter total calories burned: "))
                workout_plan_number = input("Enter the number of the workout plan (e.g., '2plan'): ")
                workout_plan = generate_workout_plan(calories_burned, workout_plan_number)
                print("\nGenerated Workout Plan:")
                print("Workout Plan Number:", workout_plan['Workout Plan Number'])
                print("Exercises:")
                for i, exercise in enumerate(workout_plan['Exercises']):
                    print(f"{i + 1}. {exercise}")
                    print("Description:", workout_plan['Descriptions'][i])
                    print("Reps:", workout_plan['Reps'][i])
                    print("Sets:", workout_plan['Sets'][i])
                    print("Calories Burned (per workout):", workout_plan['Calories Burned (per workout)'][i])
            except ValueError:
                print("Please enter valid integers for calories burned.")
        elif choice == '2':
            print("Exiting...")
            break
        else:
            print("Invalid choice. Please enter a valid option.")


if __name__ == '__main__':
    main()
