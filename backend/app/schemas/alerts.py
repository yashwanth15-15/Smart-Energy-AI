from pydantic import BaseModel
from datetime import datetime

class AlertResponse(BaseModel):
    title: str
    message: str
    severity: str
    timestamp: datetime
    recommendation: str
    estimated_savings: str
