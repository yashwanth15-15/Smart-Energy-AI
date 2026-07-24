from fastapi import APIRouter
from sqlalchemy.orm import Session
from datetime import datetime, timedelta
from app.database import SessionLocal
from app.models import Building, EnergyReading
from app.schemas.analytics import AnalyticsResponse

from app.services.scenario_manager import get_current_scenario
from cachetools import cached, TTLCache
from fastapi import APIRouter, Depends
from app.core.auth import get_current_user

analytics_cache = TTLCache(maxsize=100, ttl=60)

router = APIRouter(
    prefix="/analytics",
    tags=["Analytics"]
)

@router.get("", response_model=AnalyticsResponse, dependencies=[Depends(get_current_user)])
@cached(cache=analytics_cache)
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

        # Generate 24 hours of mock trend data
        base_time = datetime.now().replace(minute=0, second=0, microsecond=0)
        energy_trend = []
        carbon_trend = []
        for i in range(24):
            t = (base_time - timedelta(hours=23-i)).strftime("%H:00")
            energy_trend.append({"timestamp": t, "value": 100.0 + (i * 2.5) if i < 12 else 130.0 - ((i-12) * 1.5)})
            carbon_trend.append({"timestamp": t, "value": 4.0 + (i * 0.1) if i < 12 else 5.2 - ((i-12) * 0.05)})

        return AnalyticsResponse(
            todayTotalEnergy=round(today_total_energy, 1),
            weeklyTotalEnergy=round(today_total_energy * 6.5, 1),
            monthlyTotalEnergy=round(today_total_energy * 28, 1),
            todayCost=round(today_cost, 2),
            todayCo2=round(today_co2, 1),
            campusAverageEnergy=round(campus_avg, 1),
            highestConsumingBuilding=highest_building,
            lowestConsumingBuilding=lowest_building,
            totalActiveAlerts=active_alerts,
            energyTrend=energy_trend,
            carbonTrend=carbon_trend
        )
    finally:
        db.close()
