from sqlalchemy import Column, Integer, Float, DateTime, ForeignKey
from sqlalchemy.sql import func
from app.database import Base

# Stores a sensor reading for a building.
class EnergyReading(Base):
    __tablename__ = "energy_readings"

    id = Column(Integer, primary_key=True, index=True)
    building_id = Column(Integer, ForeignKey("buildings.id"), nullable=False, index=True)
    timestamp = Column(DateTime(timezone=True), server_default=func.now(), index=True)
    energy_kwh = Column(Float, nullable=False)
    temperature = Column(Float, nullable=False)
    occupancy = Column(Float, nullable=False)
    co2 = Column(Float, nullable=False)
    estimated_cost = Column(Float, nullable=False)
