from pydantic import BaseModel
from datetime import datetime

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
