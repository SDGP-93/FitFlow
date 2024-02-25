from joblib import load
import numpy as np  # Import numpy for array manipulation

# Load the BMR model
loaded_model = load('BMR.joblib')  # Adjust the filename if needed

# Input weight
input_weight = float(input("Enter weight (kg): "))  # Convert input to float
input_weight_array = np.array([[input_weight]])  # Convert input to 2D array

# Predict BMR using the loaded model
predicted_bmr = loaded_model.predict(input_weight_array)

print("Activity Levels:")
print("1 - Sedentary (little to no exercise)")
print("2 - Lightly active (light exercise/sports 1-3 days a week)")
print("3 - Moderately active (moderate exercise/sports 3-5 days a week)")
print("4 - Very active (hard exercise/sports 6-7 days a week)")
print("5 - Extra active (very hard exercise/sports & physical job or 2x training)")

# Input activity level
activity_lvl = int(input("Enter the number corresponding to your activity level: "))

# Calculate TDEE based on activity level
if activity_lvl == 1:
    tdee = predicted_bmr * 1.2
elif activity_lvl == 2:
    tdee = predicted_bmr * 1.375
elif activity_lvl == 3:
    tdee = predicted_bmr * 1.55
elif activity_lvl == 4:
    tdee = predicted_bmr * 1.725
elif activity_lvl == 5:
    tdee = predicted_bmr * 1.9
else:
    print("Invalid input")

height=input()


def tdeeFinal(tdee):
    switcher = {
        0: "zero",
        1: "one",
        2: "two",
    }

print("Predicted Basal Metabolic Rate:", predicted_bmr)
print("Total Daily Energy Expenditure:", tdee)

