from fastapi import APIRouter
from app.schemas.sustainability import SustainabilityResponse, EnvironmentalMetrics, SocialMetrics, GovernanceMetrics
from app.services.scenario_manager import get_current_scenario

router = APIRouter(
    prefix="/sustainability",
    tags=["Sustainability"]
)

@router.get("", response_model=SustainabilityResponse)
def get_sustainability_metrics():
    scenario = get_current_scenario()
    
    return SustainabilityResponse(
        environmental=EnvironmentalMetrics(
            electricity_consumption=12500.5,
            co2_emissions=4200.0,
            energy_saved=850.5,
            renewable_contribution=15.2 if scenario["name"] != "Heat Wave" else 28.4
        ),
        social=SocialMetrics(
            occupant_engagement=85,
            alerts_resolved=12,
            energy_awareness_score=92
        ),
        governance=GovernanceMetrics(
            buildings_connected=9,
            reports_generated=24,
            avg_response_time_mins=15,
            compliance_score=98
        )
    )
