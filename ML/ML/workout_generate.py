import csv
import random

def read_exercises_from_csv(filename):
    exercises = []
    with open(filename, 'r', newline='') as file:
        reader = csv.DictReader(file)
        for row in reader:
            exercises.append(row)
    return exercises

def generate_workout_plan(exercises, bmr):
    if bmr < 1200:
        tbc_range = (0, 200)
    elif 1200 <= bmr < 1250:
        tbc_range = (200, 250)
    elif 1250 <= bmr < 1300:
        tbc_range = (250, 300)
    elif 1300 <= bmr < 1350:
        tbc_range = (300, 350)
    elif 1350 <= bmr < 1400:
        tbc_range = (350, 400)
    elif 1400 <= bmr < 1450:
        tbc_range = (400, 450)
    elif 1450 <= bmr < 1500:
        tbc_range = (450, 500)
    elif 1500 <= bmr < 1550:
        tbc_range = (500, 550)
    elif 1550 <= bmr < 1600:
        tbc_range = (550, 600)   
    else:  # BMR >= 1800
        tbc_range = (600, 1000)  

    filtered_exercises = [exercise for exercise in exercises if exercise.get('TCB') and tbc_range[0] <= int(exercise['TCB']) <= tbc_range[1]]

    if len(filtered_exercises) < 5:
        print("Not enough exercises available for the specified BMR range.")
        return [], 0

    plan_number = filtered_exercises[0]['PN']  # Selecting the plan number from the first exercise
    filtered_same_plan_exercises = [exercise for exercise in filtered_exercises if exercise['PN'] == plan_number]

    if len(filtered_same_plan_exercises) < 5:
        print("Not enough exercises with the same plan number.")
        return [], 0

    workout_plan = random.sample(filtered_same_plan_exercises, k=5)
    total_calories_burnt = sum(int(exercise['TCB']) for exercise in workout_plan)
    return workout_plan, total_calories_burnt




def display_workout_plan(workout_plan, total_calories_burnt):
    print("----------------------------------<<<<<<Your Workout Plan>>>>>>>-------------------------------------------------------")
    plan_numbers = set(exercise['PN'] for exercise in workout_plan)
    for plan_number in plan_numbers:
        print(f"Plan Number: {plan_number}")
        plan_exercises = [exercise for exercise in workout_plan if exercise['PN'] == plan_number]
        print("Exercises:")
        for exercise in plan_exercises:
            print("- Exercise Name:", exercise['Exercise'])
            print("  Description:", exercise['Description'])
            print("  Execute Steps:", exercise['Execute x1'])
            print("  Sets:", exercise['Sets'])
            print("  Reps:", exercise['Reps'])
            print("-------------------------------------------------------------------------------------------------")
        print("Total Calory Burnt from the workout Plan:", exercise['TCB'])
        print()

def main():
    exercises = read_exercises_from_csv("C:/Users/File/Desktop/workouts model/workout model/WorkoutData.csv")  #  CSV file path

    bmr = float(input("Enter your Basal Metabolic Rate (BMR): "))

    workout_plan, total_calories_burnt = generate_workout_plan(exercises, bmr)
    display_workout_plan(workout_plan, total_calories_burnt)

if __name__ == "__main__":
    main()
