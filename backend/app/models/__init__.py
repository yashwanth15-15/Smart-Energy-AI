from app.database import Base
from app.models.building import Building
from app.models.energy import EnergyReading
from app.models.prediction import Prediction
from app.models.alert import Alert

# Expose models so that Base.metadata.create_all can find them
__all__ = ["Base", "Building", "EnergyReading", "Prediction", "Alert"]
