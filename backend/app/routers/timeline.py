from fastapi import APIRouter
from datetime import datetime, timedelta
from app.schemas.timeline import TimelineResponse, TimelineEvent
from app.services.scenario_manager import get_current_scenario
import uuid

router = APIRouter(
    prefix="/timeline",
    tags=["Timeline"]
)

@router.get("", response_model=TimelineResponse)
def get_timeline():
    scenario = get_current_scenario()
    now = datetime.utcnow()
    
    events = []
    
    # Generate events dynamically based on the scenario's defined timeline events
    for t_event in scenario.get("timeline_events", []):
        event_time = now - timedelta(minutes=t_event["time_offset_mins"])
        
        events.append(
            TimelineEvent(
                id=str(uuid.uuid4()),
                timestamp=event_time,
                title=t_event["title"],
                description=t_event["description"],
                severity=t_event["severity"]
            )
        )
        
    # Sort by timestamp descending (newest first)
    events.sort(key=lambda x: x.timestamp, reverse=True)
    
    return TimelineResponse(events=events)
