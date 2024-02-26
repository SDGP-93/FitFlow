from joblib import load
import numpy as np

# Load the BMR models
#loaded_model_male_bmr = load('trained_model_male_bmr.joblib')
#loaded_model_female_bmr = load('trained_model_female_bmr.joblib')

def calculate_bmr(age, weight, height, gender):  # Calculate BMR Function
    if gender.lower() == 'male':
        bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age)  # Calculate male BMR Value
    elif gender.lower() == 'female':
        bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age)  # Calculate female BMR Value
    else:
        raise ValueError("Invalid gender! Please Enter your gender as 'male' or 'female'.")  # Display a error message
    return bmr

def calculate_tdee(bmr, activity_level):  # calculate TDEE Function
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

def main():  # main function
    # Get user inputs
    age = int(input("Enter your age (in years): "))
    weight = float(input("Enter your weight (in kilograms): "))
    height = float(input("Enter your height (in centimeters): "))
    gender = input("Enter your gender (male/female): ")

    # Input activity level
    print("Activity Levels:")
    print("1 - Sedentary (little to no exercise)")
    print("2 - Lightly active (light exercise/sports 1-3 days a week)")
    print("3 - Moderately active (moderate exercise/sports 3-5 days a week)")
    print("4 - Very active (hard exercise/sports 6-7 days a week)")
    print("5 - Extra active (very hard exercise/sports & physical job or 2x training)")
    activity_lvl = int(input("Enter the number corresponding to your activity level: "))

     # Calculate BMR value
    bmr = calculate_bmr(age, weight, height, gender)
    # Calculate TDEE value
    tdee = calculate_tdee(bmr, activity_lvl)

    # Display the result TDEE Value
    print("Your Basal Metabolic Rate is:",bmr)
    print("Your Total Daily Energy Expenditure (TDEE) is:", tdee)

if __name__ == "__main__":
    main()  # main function
