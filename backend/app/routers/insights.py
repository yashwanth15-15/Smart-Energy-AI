from fastapi import APIRouter
from sqlalchemy.orm import Session
from datetime import datetime
from app.database import SessionLocal
from app.models import Building, EnergyReading
from app.schemas.insight import InsightResponse
from app.services.scenario_manager import get_current_scenario

router = APIRouter(
    prefix="/insights",
    tags=["Insights"]
)

@router.get("", response_model=InsightResponse)
def get_insights():
    db: Session = SessionLocal()
    try:
        scenario = get_current_scenario()
        
        return InsightResponse(
            generated_at=datetime.utcnow(),
            summary=scenario["copilot_summary"],
            forecast=scenario["copilot_forecast"],
            recommended_action=scenario["copilot_action"],
            expected_savings_kwh=scenario["copilot_savings"],
            expected_cost_reduction=scenario["copilot_cost_reduction"],
            risk_level=scenario["copilot_risk"]
        )
    finally:
        db.close()
