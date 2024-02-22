from joblib import load
import numpy as np  # Import numpy for array manipulation

input_weight = float(input("Enter weight: "))  # Convert input to float
input_weight_array = np.array([[input_weight]])  # Convert input to 2D array

loaded_model = load('BMR.joblib')  # Adjust the filename if needed

predicted_bmr = loaded_model.predict(input_weight_array)

print("Predicted BMR:", predicted_bmr)

