from fastapi import APIRouter, Request, HTTPException
from sqlalchemy.orm import Session
from datetime import datetime
import pandas as pd

from app.database import SessionLocal
from app.models import Building
from app.schemas.prediction import PredictionResponse, PredictionPoint
from app.services.scenario_manager import get_current_scenario

from app.core.auth import get_current_user
from fastapi import APIRouter, Request, HTTPException, Depends

router = APIRouter(
    prefix="/prediction",
    tags=["Prediction"]
)

@router.get("", response_model=PredictionResponse, dependencies=[Depends(get_current_user)])
def get_prediction(request: Request, temperature: float = 25.0, occupancy: float = 0.5, hvac_status: int = 1):
    db: Session = SessionLocal()
    try:
        model = request.app.state.model
        if model is None:
            raise HTTPException(status_code=503, detail="ML Model not loaded")

        scenario = get_current_scenario()
        
        # Generate 24-hour forecast based on inputs
        # For a more realistic forecast, we could vary the temperature and occupancy over the day,
        # but for simplicity and to match the API signature, we use the provided base values 
        # and add some natural diurnal variation.
        
        forecast = []
        peak_val = 0.0
        peak_hour = 0
        total_predicted = 0.0
        
        input_data = []
        for hour in range(24):
            # Diurnal temperature variation
            temp_var = temperature + (5 * (1 if 8 <= hour <= 18 else -1))
            # Occupancy peaks during working hours
            occ_var = occupancy if 8 <= hour <= 18 else (occupancy * 0.2)
            
            input_data.append({
                "temperature": temp_var,
                "occupancy": occ_var,
                "hvac_status": hvac_status
            })
            
        df = pd.DataFrame(input_data)
        
        # Run inference
        predictions = model.predict(df)
        
        for hour, val in enumerate(predictions):
            val = float(val)
            val = max(0, val) # Ensure non-negative
            
            # Apply scenario modifier for demonstration
            if scenario["analytics_curve_type"] == "morning_surge" and 6 <= hour <= 10:
                val *= 1.5
            elif scenario["analytics_curve_type"] == "afternoon_peak" and 14 <= hour <= 18:
                val *= 1.5
            elif scenario["analytics_curve_type"] == "heat_wave":
                val *= 1.3
                
            val = round(val, 1)
            forecast.append(PredictionPoint(hour=hour, predicted_usage=val))
            total_predicted += val
            
            if val > peak_val:
                peak_val = val
                peak_hour = hour
                
        return PredictionResponse(
            forecast=forecast,
            peak_demand_hour=f"{peak_hour:02d}:00",
            confidence_percent=92.5,
            predicted_energy_usage=round(total_predicted, 1),
            ai_explanation=f"XGBoost Model anticipates peak load at {peak_hour:02d}:00. Base Temp: {temperature}°C.",
            estimated_savings=f"{round(peak_val * 0.15, 1)} kWh"
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        db.close()