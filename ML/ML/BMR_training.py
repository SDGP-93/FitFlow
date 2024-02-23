import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
data = pd.read_csv("C:/Users/User/Desktop/BMR.csv")
X = data[['Weight (kg)']]
y_male = data['Male BMR (calories/day)']
y_female = data['Female BMR (calories/day)']
X_train, X_test, y_male_train, y_male_test = train_test_split(X, y_male, test_size=0.2, random_state=42)

model = LinearRegression()

model.fit(X_train, y_male_train)

y_male_pred = model.predict(X_test)

mae = mean_absolute_error(y_male_test, y_male_pred)
mse = mean_squared_error(y_male_test, y_male_pred)
r2 = r2_score(y_male_test, y_male_pred)
print(f"MAE: {mae}, MSE: {mse}, R-squared: {r2}")
