from pydantic import BaseModel

class EnvironmentalMetrics(BaseModel):
    electricity_consumption: float
    co2_emissions: float
    energy_saved: float
    renewable_contribution: float

class SocialMetrics(BaseModel):
    occupant_engagement: int
    alerts_resolved: int
    energy_awareness_score: int

class GovernanceMetrics(BaseModel):
    buildings_connected: int
    reports_generated: int
    avg_response_time_mins: int
    compliance_score: int

class SustainabilityResponse(BaseModel):
    environmental: EnvironmentalMetrics
    social: SocialMetrics
    governance: GovernanceMetrics
