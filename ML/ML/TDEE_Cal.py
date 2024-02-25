def calculate_bmr(age, weight, height, gender): #Calculate BMR Function
    if gender.lower() == 'male':
        bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age) # Calculate male BMR Value
    elif gender.lower() == 'female':
        bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age) # Calculate female BMR Value
    else:
        raise ValueError("Invalid gender! Please Enter 'male' or 'female'.") #Display a error message
    return bmr

def calculate_tdee(bmr, activity_level): # calculate TDEE Function
    activity_multipliers = {
        'sedentary': 1.2,
        'lightly active': 1.375,
        'moderately active': 1.55,
        'very active': 1.725,
        'extra active': 1.9
    }
    if activity_level.lower() in activity_multipliers:
        return bmr * activity_multipliers[activity_level.lower()]
    else:
        raise ValueError("Invalid activity level! Please enter sedentary, lightly active, moderately active, very active or extra active correctly.")

def main(): #main function
    # Get user inputs
    age = int(input("Enter your age (in years): "))
    weight = float(input("Enter your weight (in kilograms): "))
    height = float(input("Enter your height (in centimeters): "))
    gender = input("Enter your gender (male/female): ")
    activity_level = input("Enter your activity level "
                           "(sedentary, lightly active, moderately active, very active, extra active): ")

    # Calculate BMR value
    bmr = calculate_bmr(age, weight, height, gender)

    # Calculate TDEE value
    tdee = calculate_tdee(bmr, activity_level)

    # Display the result TDEE Value
    print("Your Total Daily Energy Expenditure (TDEE) is:", tdee)

if __name__ == "__main__":
    main()  #main function
