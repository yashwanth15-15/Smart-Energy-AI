from pydantic import BaseModel
from typing import List

class Recommendation(BaseModel):
    title: str
    saving: str

class DashboardResponse(BaseModel):
    energy_usage: float
    energy_unit: str
    sustainability_score: int
    prediction: str
    recommendations: List[Recommendation]
    campus_health_score: int
    co2_saved: float
    cost_saved: float
    buildings_online: int
    active_alerts: int
    prediction_accuracy: float
