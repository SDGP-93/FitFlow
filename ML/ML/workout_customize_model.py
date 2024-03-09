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

    # Get exercises data for the specified workout plan number from the dataset
    plan_data = dataset[dataset['PN'] == workout_plan_number].copy()

    # Predict calories burned for each exercise
    plan_data['Predicted_Calories'] = model.predict(plan_data[['Sets', 'Reps']])

 # Calculate adjusted sets and reps based on the difference between reported and predicted calories burned
    # Adjusted sets and reps are reduced if reported calories burned are higher than predicted
    # Calculate adjusted sets and reps based on calorie difference
    plan_data['Adjusted_Sets'] = plan_data['Sets'] - ((calories_burned - plan_data['Predicted_Calories']) // 100)
    plan_data['Adjusted_Reps'] = plan_data['Reps'] - ((calories_burned - plan_data['Predicted_Calories']) // 50)

    # Round adjusted sets and reps to nearest integer
    plan_data['Adjusted_Sets'] = plan_data['Adjusted_Sets'].astype(int)
    plan_data['Adjusted_Reps'] = plan_data['Adjusted_Reps'].astype(int)

    # Ensure adjusted sets and reps are at least 1
    plan_data['Adjusted_Sets'] = plan_data['Adjusted_Sets'].clip(lower=1)
    plan_data['Adjusted_Reps'] = plan_data['Adjusted_Reps'].clip(lower=1)

    # Construct the customized workout plan DataFrame
    workout_plan_df = plan_data[['Exercise', 'Adjusted_Sets', 'Adjusted_Reps']]

    return workout_plan_df


# Function to print workout plan
def print_workout_plan(workout_plan_df, workout_plan_number):
    print(f"\nGenerated Workout Plan Number: {workout_plan_number}\n")
    print(workout_plan_df.to_string(index=False))


def main():
    print("Welcome to the FitFlow workout plan generator!!!")
    while True:
        print("\nSelect an option:")
        print("1. Enter Number 1 For Customize Your Workout Plan")
        print("2. Exit")
        choice = input("Enter your choice: ")

        if choice == '1':
            try:
                calories_burned = int(input("Enter the total calories burned from the STEPS COUNTER: "))
                workout_plan_number = input("Enter the number of the workout plan you selected (e.g., '1plan'): ")
                workout_plan = generate_workout_plan(calories_burned, workout_plan_number)
                
                print("\n>>>>>>Generated Workout Plan<<<<<<")
                print_workout_plan(workout_plan, workout_plan_number)
                
            except ValueError:
                print("Please enter valid integers for calories burned.")
        elif choice == '2':
            print("Exiting...")
            break
        else:
            print("Invalid choice. Please enter a valid option.")


if __name__ == '__main__':
    main()
