from fastapi import APIRouter, HTTPException, Request
from pydantic import BaseModel
import random
from typing import List
from app.core.rate_limit import limiter

router = APIRouter(
    prefix="/copilot",
    tags=["Copilot"]
)

class ChatMessage(BaseModel):
    role: str
    content: str

class ChatRequest(BaseModel):
    messages: List[ChatMessage]
    context_data: dict | None = None

class ChatResponse(BaseModel):
    response: str
    suggested_actions: List[str] = []

@router.post("/chat", response_model=ChatResponse)
@limiter.limit("10/minute")
def copilot_chat(request_obj: Request, request: ChatRequest):
    if not request.messages:
        raise HTTPException(status_code=400, detail="Messages cannot be empty")
        
    last_message = request.messages[-1].content.lower()
    
    # Mock intelligent responses based on keywords
    response_text = ""
    suggestions = []
    
    if "energy" in last_message or "power" in last_message:
        response_text = "Based on the current campus load, the Engineering Block is consuming 12% more energy than predicted. I recommend inspecting the HVAC schedules."
        suggestions = ["Show Engineering Block data", "Adjust HVAC schedule"]
    elif "alert" in last_message or "warning" in last_message:
        response_text = "There are 2 active alerts regarding voltage fluctuations in the Science Block. The maintenance team has been notified."
        suggestions = ["View Alert Details", "Dismiss Alerts"]
    elif "cost" in last_message or "save" in last_message:
        response_text = "You can save approximately $450 daily by optimizing the cooling systems during non-peak hours (10 PM - 6 AM)."
        suggestions = ["Apply Optimization", "View Cost Analysis"]
    else:
        responses = [
            "I'm monitoring the campus systems. All parameters are within normal ranges.",
            "The AI models indicate a 94% confidence in today's load predictions.",
            "Is there a specific building or metric you'd like me to analyze?"
        ]
        response_text = random.choice(responses)
        suggestions = ["Analyze Building", "Show Predictions"]
        
    return ChatResponse(
        response=response_text,
        suggested_actions=suggestions
    )
