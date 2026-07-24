from fastapi import APIRouter
from sqlalchemy.orm import Session
from sqlalchemy import func
from app.database import SessionLocal
from app.models import Building, EnergyReading
from app.schemas.dashboard import DashboardResponse, Recommendation

from app.services.scenario_manager import get_current_scenario

router = APIRouter(
    prefix="/dashboard",
    tags=["Dashboard"]
)

@router.get("", response_model=DashboardResponse)
def get_dashboard():
    db: Session = SessionLocal()
    try:
        buildings = db.query(Building).all()
        scenario = get_current_scenario()
        
        total_energy = 2487.4
        avg_health = scenario["dashboard_health"]
        active_alerts = 1 if avg_health < 90 else 0

        recommendations = [Recommendation(title=scenario["dashboard_recommendation"], saving="15%")]

        return DashboardResponse(
            energy_usage=total_energy,
            energy_unit="kWh",
            sustainability_score=scenario["sustainability_efficiency"],
            prediction="Stable",
            recommendations=recommendations,
            campus_health_score=avg_health,
            co2_saved=94.0,
            cost_saved=126.0,
            buildings_online=len(buildings),
            active_alerts=active_alerts,
            prediction_accuracy=96.8
        )
    finally:
        db.close()
