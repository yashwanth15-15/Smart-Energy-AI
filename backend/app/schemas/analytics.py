from pydantic import BaseModel
from datetime import datetime

class DataPoint(BaseModel):
    timestamp: str
    value: float

class AnalyticsResponse(BaseModel):
    todayTotalEnergy: float
    weeklyTotalEnergy: float
    monthlyTotalEnergy: float
    todayCost: float
    todayCo2: float
    highestConsumingBuilding: str
    lowestConsumingBuilding: str
    campusAverageEnergy: float
    totalActiveAlerts: int
    energyTrend: list[DataPoint] = []
    carbonTrend: list[DataPoint] = []
