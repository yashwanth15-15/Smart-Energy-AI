from fastapi import APIRouter
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List
from app.database import SessionLocal
from app.models import Building, EnergyReading
from app.schemas.building import BuildingStatus
from app.core.auth import get_current_user

router = APIRouter(
    prefix="/buildings",
    tags=["Buildings"]
)

@router.get("", response_model=List[BuildingStatus], dependencies=[Depends(get_current_user)])
def get_buildings():
    """Return the latest status for each building.
    Status logic (simple example):
      - Critical: occupancy > 80 or energy_kwh > 250
      - Warning:  occupancy > 60 or energy_kwh > 180
      - Normal: otherwise
    """
    db: Session = SessionLocal()
    try:
        buildings = db.query(Building).all()
        results: List[BuildingStatus] = []
        for b in buildings:
            latest = (
                db.query(EnergyReading)
                .filter(EnergyReading.building_id == b.id)
                .order_by(EnergyReading.timestamp.desc())
                .first()
            )
            if latest:
                energy = round(latest.energy_kwh, 1)
                temp = round(latest.temperature, 1)
                occ = round(latest.occupancy, 1)
                hvac_status = "ON" if temp > 24 or occ > 20 else "OFF"
                if occ > 80 or energy > 250:
                    status = "Critical"
                    health = "Poor"
                    efficiency_score = 45
                elif occ > 60 or energy > 180:
                    status = "Warning"
                    health = "Fair"
                    efficiency_score = 72
                else:
                    status = "Normal"
                    health = "Excellent"
                    efficiency_score = 92
            else:
                energy = temp = occ = 0.0
                status = "Normal"
                hvac_status = "OFF"
                health = "Good"
                efficiency_score = 85
            results.append(
                BuildingStatus(
                    name=b.name,
                    latest_energy=energy,
                    temperature=temp,
                    occupancy=occ,
                    status=status,
                    hvac_status=hvac_status,
                    health=health,
                    efficiency_score=efficiency_score,
                )
            )
        return results
    finally:
        db.close()
