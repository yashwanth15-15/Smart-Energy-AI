from fastapi import APIRouter
from sqlalchemy.orm import Session
from datetime import datetime
from app.database import SessionLocal
from app.models import Building, EnergyReading
from app.schemas.prediction import PredictionResponse, PredictionPoint

from app.services.scenario_manager import get_current_scenario

router = APIRouter(
    prefix="/prediction",
    tags=["Prediction"]
)

@router.get("", response_model=PredictionResponse)
def get_prediction():
    db: Session = SessionLocal()
    try:
        buildings = db.query(Building).all()
        scenario = get_current_scenario()
        
        base_energy = 500.0

        # Adjust curve based on scenario
        curve_type = scenario["analytics_curve_type"]
        if curve_type == "morning_surge":
            curve = [0.2, 0.2, 0.2, 0.2, 0.2, 0.3, 0.6, 1.0, 1.5, 1.6, 1.4, 1.2, 1.1, 1.0, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.2, 0.2]
        elif curve_type == "afternoon_peak":
            curve = [0.3, 0.3, 0.3, 0.3, 0.4, 0.5, 0.6, 0.8, 0.9, 1.0, 1.2, 1.4, 1.6, 1.8, 1.9, 1.8, 1.5, 1.2, 1.0, 0.8, 0.6, 0.5, 0.4, 0.3]
        elif curve_type == "weekend_flat":
            curve = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.6, 0.6, 0.7, 0.7, 0.7, 0.7, 0.8, 0.7, 0.7, 0.7, 0.7, 0.6, 0.6, 0.5, 0.5, 0.5, 0.5, 0.5]
        elif curve_type == "heat_wave":
            curve = [0.8, 0.8, 0.8, 0.8, 0.9, 1.0, 1.2, 1.5, 1.8, 2.0, 2.2, 2.4, 2.6, 2.7, 2.8, 2.8, 2.6, 2.4, 2.0, 1.8, 1.5, 1.2, 1.0, 0.9]
        else:
            curve = [0.3, 0.25, 0.2, 0.2, 0.25, 0.3, 0.5, 0.8, 1.0, 1.1, 1.2, 1.25, 1.2, 1.3, 1.4, 1.35, 1.2, 1.0, 0.8, 0.7, 0.6, 0.5, 0.4, 0.35]
        
        forecast = []
        peak_val = 0.0
        peak_hour = 0
        total_predicted = 0.0
        
        avg_multiplier = sum(curve) / len(curve)
        scaling_factor = base_energy / avg_multiplier if avg_multiplier else 1.0
        
        for hour, mult in enumerate(curve):
            val = round(scaling_factor * mult, 1)
            forecast.append(PredictionPoint(hour=hour, predicted_usage=val))
            total_predicted += val
            if val > peak_val:
                peak_val = val
                peak_hour = hour
                
        return PredictionResponse(
            forecast=forecast,
            peak_demand_hour=scenario["prediction_peak_hour"],
            confidence_percent=94.5,
            predicted_energy_usage=round(total_predicted, 1),
            ai_explanation=f"AI anticipates peak load at {scenario['prediction_peak_hour']}. Scenario: {scenario['name']}",
            estimated_savings=f"{round(peak_val * 0.15, 1)} kWh"
        )
    finally:
        db.close()