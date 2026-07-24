from datetime import datetime
import random
import asyncio
from typing import List

from app.database import SessionLocal
from app.models import Building, EnergyReading

# ==============================================================
# Sensor Simulator Service
# ==============================================================
# This service runs as a background task when the FastAPI app starts.
# Every 30 seconds it generates a realistic sensor reading for **each**
# building stored in the `buildings` table and persists the reading to
# the `energy_readings` table.  The values are intentionally simple
# but follow plausible ranges based on building type.
# --------------------------------------------------------------

# Helper to pick a random value within a range (inclusive)
def _rand(min_val: float, max_val: float, precision: int = 2) -> float:
    return round(random.uniform(min_val, max_val), precision)

# Determine the "profile" of a building based on its name.
# Returns a dict with functions that calculate each metric given the
# current hour of the day (0‑23).
def _building_profile(name: str):
    name_lower = name.lower()
    if "hostel" in name_lower:
        # Hostels use more energy during evening/night (18‑02)
        def energy(hour):
            return _rand(80, 200) if 18 <= hour or hour <= 2 else _rand(30, 80)
        def temperature(_):
            return _rand(20, 24)
        def occupancy(hour):
            return _rand(50, 90) if 18 <= hour or hour <= 2 else _rand(10, 40)
        def co2(_):
            return _rand(400, 800)
        return {
            "energy": energy,
            "temperature": temperature,
            "occupancy": occupancy,
            "co2": co2,
        }
    if "cafe" in name_lower or "cafeteria" in name_lower:
        # Peaks at breakfast (7‑9), lunch (12‑14), dinner (18‑20)
        def energy(hour):
            if 7 <= hour <= 9 or 12 <= hour <= 14 or 18 <= hour <= 20:
                return _rand(120, 250)
            return _rand(30, 80)
        def temperature(_):
            return _rand(21, 25)
        def occupancy(hour):
            if 7 <= hour <= 9 or 12 <= hour <= 14 or 18 <= hour <= 20:
                return _rand(60, 100)
            return _rand(5, 20)
        def co2(_):
            return _rand(500, 1000)
        return {
            "energy": energy,
            "temperature": temperature,
            "occupancy": occupancy,
            "co2": co2,
        }
    if "library" in name_lower:
        # Steady daytime usage, low at night
        def energy(hour):
            return _rand(60, 120) if 8 <= hour <= 20 else _rand(10, 30)
        def temperature(_):
            return _rand(19, 23)
        def occupancy(hour):
            return _rand(30, 70) if 8 <= hour <= 20 else _rand(0, 10)
        def co2(_):
            return _rand(350, 600)
        return {
            "energy": energy,
            "temperature": temperature,
            "occupancy": occupancy,
            "co2": co2,
        }
    # Default commercial block profile (higher 9-17)
    def energy(hour):
        return _rand(150, 300) if 9 <= hour <= 17 else _rand(30, 80)
    def temperature(_):
        return _rand(20, 26)
    def occupancy(hour):
        return _rand(40, 90) if 9 <= hour <= 17 else _rand(5, 30)
    def co2(_):
        return _rand(400, 900)
    return {
        "energy": energy,
        "temperature": temperature,
        "occupancy": occupancy,
        "co2": co2,
    }

# Core coroutine that runs forever, generating data every 30 seconds.
async def run_simulation():
    while True:
        try:
            db = SessionLocal()
            buildings: List[Building] = db.query(Building).all()
            now = datetime.utcnow()
            hour = now.hour
            for b in buildings:
                profile = _building_profile(b.name)
                energy_kwh = profile["energy"](hour)
                temperature = profile["temperature"](hour)
                occupancy = profile["occupancy"](hour)
                co2 = profile["co2"](hour)
                # Simple cost estimation (e.g., $0.12 per kWh)
                estimated_cost = round(energy_kwh * 0.12, 2)

                reading = EnergyReading(
                    building_id=b.id,
                    timestamp=now,
                    energy_kwh=energy_kwh,
                    temperature=temperature,
                    occupancy=occupancy,
                    co2=co2,
                    estimated_cost=estimated_cost,
                )
                db.add(reading)
            db.commit()
        except Exception as exc:
            # In production we would log this properly.
            print(f"[Simulator] error generating data: {exc}")
        finally:
            db.close()
        # Wait 30 seconds before next cycle.
        await asyncio.sleep(30)

# Helper to start the background task; called from FastAPI lifespan.
def start_background_task():
    loop = asyncio.get_event_loop()
    loop.create_task(run_simulation())

# End of simulator service
