from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded
from app.core.middleware import LoggingMiddleware
from contextlib import asynccontextmanager
import pickle
import os

from app.routers import dashboard, prediction, buildings, analytics, alerts, insights, sustainability, timeline, copilot
from app.services.simulator import start_background_task
from app.database import engine, SessionLocal
from app.models import Base, Building
from app.config import settings

from app.database import Base, engine

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Initialize DB tables
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
    
    # Load ML Model
    try:
        from pathlib import Path

        # backend/app/main.py -> backend/model.pkl
        model_path = Path(__file__).resolve().parent.parent / "model.pkl"

        if model_path.exists():
            with open(model_path, "rb") as f:
                app.state.model = pickle.load(f)
            print(f"✅ Model loaded from: {model_path}")
        else:
            app.state.model = None
            print(f"❌ model.pkl not found at: {model_path}")

    except Exception as e:
        app.state.model = None
        print(f"❌ Error loading model: {e}")
    
    yield

from app.core.rate_limit import limiter

app = FastAPI(
    title="Smart Energy AI Backend",
    description="Production-ready FastAPI backend for Smart Energy AI",
    version="1.0.0",
    lifespan=lifespan
)
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)
app.add_middleware(LoggingMiddleware)

# CORS Configuration
origins = [origin.strip() for origin in settings.cors_origins.split(",")]
firebase_origins = [
    "https://smart-energy-ai-3ff26.web.app",
    "https://smart-energy-ai-3ff26.firebaseapp.com"
]
for fo in firebase_origins:
    if fo not in origins:
        origins.append(fo)

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_origin_regex=r"^https?://(localhost|127\.0\.0\.1)(:\d+)?$",
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
app.include_router(copilot.router)

@app.get("/")
def read_root():
    return {"message": "Smart Energy AI Backend"}

@app.get("/health")
def health_check():
    return {
        "status": "ok",
        "service": "Smart Energy AI Backend",
        "model_loaded": getattr(app.state, "model", None) is not None
    }