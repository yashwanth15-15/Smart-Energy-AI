from pydantic import BaseModel
from typing import List


class PredictionRequest(BaseModel):
    temperature: float
    occupancy: float
    hvac_status: int


class PredictionPoint(BaseModel):
    hour: int
    predicted_usage: float


class PredictionResponse(BaseModel):
    forecast: List[PredictionPoint]
    peak_demand_hour: str
    confidence_percent: float
    predicted_energy_usage: float
    ai_explanation: str
    estimated_savings: str