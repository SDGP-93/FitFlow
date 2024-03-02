from joblib import load
import numpy as np

# Load the BMR models
loaded_model_male_bmr = load('trained_model_male_bmr.joblib')
loaded_model_female_bmr = load('trained_model_female_bmr.joblib')

def predict_bmr(gender, weight, age, height):
    if gender.lower() == 'male':
        bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age)
    elif gender.lower() == 'female':
        bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age)
    else:
        raise ValueError("Invalid gender input.")
    return bmr

def calculate_tdee(bmr, activity_level):
    activity_multipliers = {
        1: 1.2,
        2: 1.375,
        3: 1.55,
        4: 1.725,
        5: 1.9
    }
    if activity_level in activity_multipliers:
        return bmr * activity_multipliers[activity_level]
    else:
        raise ValueError("Invalid activity level! Please enter a number from 1 to 5.")

def main():
    # Input gender
    gender = input("Enter gender (male/female): ")
    # Input weight
    weight = float(input("Enter weight (kg): "))
    # Input age
    age = int(input("Enter your age (in years): "))
    # Input height
    height = float(input("Enter your height (in centimeters): "))
    # Input activity level
    print("Activity Levels:")
    print("1 - Sedentary (little to no exercise)")
    print("2 - Lightly active (light exercise/sports 1-3 days a week)")
    print("3 - Moderately active (moderate exercise/sports 3-5 days a week)")
    print("4 - Very active (hard exercise/sports 6-7 days a week)")
    print("5 - Extra active (very hard exercise/sports & physical job or 2x training)")
    activity_lvl = int(input("Enter the number corresponding to your activity level: "))
    
    # Predict BMR
    predicted_bmr = predict_bmr(gender, weight, age, height)
    # Calculate TDEE
    tdee = calculate_tdee(predicted_bmr, activity_lvl)
    
    # Print Predicted BMR and TDEE
    print("Predicted Basal Metabolic Rate:", predicted_bmr)
    print("Total Daily Energy Expenditure:", tdee)

if __name__ == "__main__":
    main()
