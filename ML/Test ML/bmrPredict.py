from joblib import load
import numpy as np

# Load the BMR models
loaded_model_male_bmr = load('BMR_male.joblib')
loaded_model_female_bmr = load('BMR_female.joblib')

# Input gender
gender = input("Enter gender (male/female): ")

# Input weight
input_weight = float(input("Enter weight (kg): "))

# Convert input weight to a 2D array
input_weight_array = np.array([[input_weight]])

# Predict BMR based on gender
if gender.lower() == 'male':
    predicted_bmr = loaded_model_male_bmr.predict(input_weight_array)
elif gender.lower() == 'female':
    predicted_bmr = loaded_model_female_bmr.predict(input_weight_array)
else:
    print("Invalid gender input.")
    exit()

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

# Print Predicted BMR and TDEE
print("Predicted Basal Metabolic Rate:", predicted_bmr)
print("Total Daily Energy Expenditure:", tdee)


