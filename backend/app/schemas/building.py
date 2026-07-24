from typing import List
from pydantic import BaseModel, RootModel


class BuildingStatus(BaseModel):
    name: str
    latest_energy: float
    temperature: float
    occupancy: float
    status: str
    hvac_status: str
    health: str
    efficiency_score: int

class BuildingStatusResponse(RootModel[List[BuildingStatus]]):
    pass