from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional

class InsightResponse(BaseModel):
    generated_at: datetime
    summary: str
    forecast: str
    recommended_action: str
    expected_savings_kwh: str
    expected_cost_reduction: str
    risk_level: str
