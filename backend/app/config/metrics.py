import os

# Indian units
COST_PER_KWH = float(os.getenv("COST_PER_KWH", "8.5"))  # INR per kWh
CO2_PER_KWH = float(os.getenv("CO2_PER_KWH", "0.82"))  # kg CO₂ per kWh

# Anomaly detection thresholds (configurable)
ENERGY_THRESHOLD = float(os.getenv("ENERGY_THRESHOLD", "300"))  # kWh
SPIKE_PERCENT = float(os.getenv("SPIKE_PERCENT", "0.3"))      # 30% increase
TEMP_THRESHOLD = float(os.getenv("TEMP_THRESHOLD", "30"))    # °C
