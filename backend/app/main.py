from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

from app.routers import dashboard, prediction, buildings, analytics, alerts, insights, sustainability, timeline
from app.services.simulator import start_background_task
from app.database import engine, SessionLocal
from app.models import Base, Building

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Auto-create tables on startup
    Base.metadata.create_all(bind=engine)
    
    # Seed the Buildings table if empty
    db = SessionLocal()
    try:
        if db.query(Building).count() == 0:
            buildings = [
                "Engineering Block", "Science Block", "Library", 
                "Hostel A", "Hostel B", "Admin Block", 
                "Auditorium", "Cafeteria"
            ]
            for b_name in buildings:
                db.add(Building(name=b_name))
            db.commit()
    finally:
        db.close()
    
    start_background_task()
    yield

app = FastAPI(
    title="Smart Energy AI Backend",
    description="Production-ready FastAPI backend for Smart Energy AI",
    version="1.0.0",
    lifespan=lifespan
)

# CORS Configuration
app.add_middleware(
    CORSMiddleware,
    allow_origin_regex=r"http://(localhost|127\.0\.0\.1)(:\d+)?",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(dashboard.router)
app.include_router(prediction.router)
app.include_router(buildings.router)
app.include_router(analytics.router)
app.include_router(alerts.router)
app.include_router(insights.router)
app.include_router(sustainability.router)
app.include_router(timeline.router)

@app.get("/")
def read_root():
    return {"message": "Smart Energy AI Backend"}

@app.get("/health")
def health_check():
    return {
        "status": "ok",
        "service": "Smart Energy AI Backend"
    }