from sqlalchemy import Column, Integer, String
from app.database import Base

# Represents a physical building in the Smart Energy AI system
class Building(Base):
    __tablename__ = "buildings"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, index=True)
