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
    plan_data = dataset[dataset['PN'] == workout_plan_number]

    # Extract information for each exercise
    exercises = plan_data['Exercise'].tolist()
    descriptions = plan_data['Description'].tolist()
    executes = plan_data['Execute x1'].tolist()
    reps = plan_data['Reps'].tolist()
    sets = plan_data['Sets'].tolist()

    # Predict the number of sets and reps based on the input calories
    predicted_calories = model.predict([[sets[0], reps[0]]])

    # Calculate the difference between predicted and input calories
    calorie_difference = calories_burned - predicted_calories

    # Adjust sets and reps based on the calorie difference
    adjusted_sets = [int(sets[i] + calorie_difference.item() // 100) for i in range(len(sets))]
    adjusted_reps = [int(reps[i] + calorie_difference.item() // 50) for i in range(len(reps))]

    # Construct the customized workout plan as a DataFrame
    workout_plan_df = pd.DataFrame({
        "Exercise": exercises,
        "Reps": adjusted_reps,
        "Sets": adjusted_sets
    })

    return workout_plan_df


# Function to print workout plan
def print_workout_plan(workout_plan_df, workout_plan_number):
    print(f"\nGenerated Workout Plan Number: {workout_plan_number}\n")
    print(workout_plan_df.to_string(index=False))


def main():
    print("Welcome to the Workout Planner Console Menu!!!")
    while True:
        print("\nSelect an option:")
        print("1. Generate Workout Plan")
        print("2. Exit")
        choice = input("Enter your choice: ")

        if choice == '1':
            try:
                calories_burned = int(input("Enter total calories burned by steps counter: "))
                workout_plan_number = input("Enter the number of the workout plan (e.g., '1plan'): ")
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
