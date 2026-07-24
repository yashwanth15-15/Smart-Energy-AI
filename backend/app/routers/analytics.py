from fastapi import APIRouter
from sqlalchemy.orm import Session
from datetime import datetime, timedelta
from app.database import SessionLocal
from app.models import Building, EnergyReading
from app.schemas.analytics import AnalyticsResponse

from app.services.scenario_manager import get_current_scenario

router = APIRouter(
    prefix="/analytics",
    tags=["Analytics"]
)

@router.get("", response_model=AnalyticsResponse)
def get_analytics():
    db: Session = SessionLocal()
    try:
        scenario = get_current_scenario()
        
        today_total_energy = 2487.4
        today_cost = 42180.0
        today_co2 = 94.0
        
        highest_building = scenario["affected_building"]
        lowest_building = "Admin Block" if highest_building != "Admin Block" else "Cafeteria"
        campus_avg = 138.2
        active_alerts = 1 if scenario["dashboard_health"] < 90 else 0

        return AnalyticsResponse(
            todayTotalEnergy=round(today_total_energy, 1),
            weeklyTotalEnergy=round(today_total_energy * 6.5, 1),
            monthlyTotalEnergy=round(today_total_energy * 28, 1),
            todayCost=round(today_cost, 2),
            todayCo2=round(today_co2, 1),
            campusAverageEnergy=round(campus_avg, 1),
            highestConsumingBuilding=highest_building,
            lowestConsumingBuilding=lowest_building,
            totalActiveAlerts=active_alerts
        )
    finally:
        db.close()
