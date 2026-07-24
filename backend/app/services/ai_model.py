import os
import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestRegressor
import joblib
from datetime import datetime

# Path to the persisted model (relative to this file's directory)
MODEL_PATH = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "model.pkl"))

def _generate_synthetic_data(num_samples: int = 10000):
    """Generate synthetic training data.
    Features: temperature, occupancy, hvac_status (binary)
    Target: energy_kwh (float)
    """
    rng = np.random.default_rng()
    temperature = rng.uniform(15, 30, size=num_samples)
    occupancy = rng.uniform(0, 100, size=num_samples)
    hvac_status = rng.integers(0, 2, size=num_samples)  # 0 or 1
    # Simple relationship with some noise
    energy = (temperature * 5) + (occupancy * 2) + (hvac_status * 50) + rng.normal(0, 20, size=num_samples)
    df = pd.DataFrame({
        'temperature': temperature,
        'occupancy': occupancy,
        'hvac_status': hvac_status,
        'energy_kwh': energy,
    })
    return df

def train_model():
    """Train a RandomForestRegressor and save to disk.
    Called automatically if model file does not exist.
    """
    df = _generate_synthetic_data()
    X = df[['temperature', 'occupancy', 'hvac_status']]
    y = df['energy_kwh']
    model = RandomForestRegressor(n_estimators=100, random_state=42)
    model.fit(X, y)
    os.makedirs(os.path.dirname(MODEL_PATH), exist_ok=True)
    joblib.dump(model, MODEL_PATH)
    print(f"[AI Model] Trained and saved model to {MODEL_PATH}")
    return model

def load_model():
    expected_features = ['temperature', 'occupancy', 'hvac_status']
    if os.path.exists(MODEL_PATH):
        try:
            model = joblib.load(MODEL_PATH)
            # Check if the saved model was trained with the expected features
            if hasattr(model, 'feature_names_in_'):
                if list(model.feature_names_in_) != expected_features:
                    print("[AI Model] Feature mismatch. Retraining model...")
                    return train_model()
            return model
        except Exception as e:
            print(f"[AI Model] Error loading model: {e}. Retraining...")
            return train_model()
    else:
        return train_model()

# Load (or train) the model at import time for fast inference
_model = load_model()

def predict(latest_reading: dict) -> float:
    """Predict next‑hour energy usage.
    `latest_reading` must contain `temperature`, `occupancy`, and `hvac_status` keys.
    Returns a float energy_kwh prediction.
    """
    try:
        X = pd.DataFrame({
            'temperature': [latest_reading['temperature']],
            'occupancy': [latest_reading['occupancy']],
            'hvac_status': [latest_reading.get('hvac_status', 1)],
        })
        pred = _model.predict(X)[0]
        return float(pred)
    except Exception as exc:
        print(f"[AI Model] Prediction error: {exc}")
        raise
