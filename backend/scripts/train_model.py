import os
import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor
import pickle

def generate_data(filepath="data/energy_data.csv"):
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    
    np.random.seed(42)
    dates = pd.date_range(start="2026-01-01", periods=1000, freq="h")
    
    temp = np.random.normal(25, 5, 1000)
    humidity = np.random.normal(55, 10, 1000)
    hvac = np.random.choice([0, 1], 1000, p=[0.4, 0.6])
    
    usage = 100 + (temp - 25)**2 * 0.5 + hvac * 50 + np.random.normal(0, 5, 1000)
    
    df = pd.DataFrame({
        "timestamp": dates,
        "temperature": temp,
        "humidity": humidity,
        "hvac_status": hvac,
        "energy_usage": usage
    })
    
    df.to_csv(filepath, index=False)
    print(f"Generated data saved to {filepath}")
    return df

def train_model(df, model_path="model.pkl"):
    X = df[["temperature", "humidity", "hvac_status"]]
    y = df["energy_usage"]
    
    model = RandomForestRegressor(n_estimators=50, random_state=42)
    model.fit(X, y)
    
    with open(model_path, "wb") as f:
        pickle.dump(model, f)
    print(f"Model trained and saved to {model_path}")

if __name__ == "__main__":
    df = generate_data()
    train_model(df)
