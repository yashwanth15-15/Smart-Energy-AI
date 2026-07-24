from pydantic import BaseModel
from datetime import datetime
from typing import List

class TimelineEvent(BaseModel):
    id: str
    timestamp: datetime
    title: str
    description: str
    severity: str  # "info", "warning", "critical", "resolved"

class TimelineResponse(BaseModel):
    events: List[TimelineEvent]
