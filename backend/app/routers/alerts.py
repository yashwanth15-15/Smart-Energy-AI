from fastapi import APIRouter
from sqlalchemy.orm import Session
from typing import List
from datetime import datetime
from app.database import SessionLocal
from app.models import Building, EnergyReading
from app.schemas.alerts import AlertResponse

from app.services.scenario_manager import get_current_scenario

from app.core.auth import get_current_user
from fastapi import APIRouter, Depends

router = APIRouter(
    prefix="/alerts",
    tags=["Alerts"]
)

@router.get("", response_model=List[AlertResponse], dependencies=[Depends(get_current_user)])
def get_alerts():
    db: Session = SessionLocal()
    try:
        scenario = get_current_scenario()
        now = datetime.utcnow()
        
        alerts = []
        
        # Add the scenario alert
        alerts.append(AlertResponse(
            title=scenario["alert_title"],
            message=scenario["alert_desc"],
            severity="high" if scenario["copilot_risk"].lower() == "high" else "medium",
            timestamp=now,
            recommendation=scenario["dashboard_recommendation"],
            estimated_savings=scenario["copilot_savings"]
        ))
        
        # Add a couple of generic low-priority alerts to make the dashboard look busy
        alerts.append(AlertResponse(
            title="Routine Maintenance",
            message="Scheduled maintenance for Admin Block HVAC.",
            severity="low",
            timestamp=now,
            recommendation="No action required.",
            estimated_savings="0 kWh"
        ))

        # Sort by severity
        severity_order = {"high": 0, "medium": 1, "low": 2}
        alerts.sort(key=lambda a: severity_order.get(a.severity, 3))
        
        return alerts
    finally:
        db.close()
