import time
from typing import Dict, Any

# A predefined set of operational scenarios
SCENARIOS = [
    {
        "name": "Morning Startup",
        "description": "Campus demand is ramping up as buildings come online for the day.",
        "affected_building": "Engineering Building",
        "alert_title": "HVAC Pre-cooling Inefficient",
        "alert_desc": "Engineering Building HVAC is cooling empty rooms too early.",
        "dashboard_recommendation": "Delay HVAC startup by 30 mins.",
        "copilot_summary": "Morning startup sequence initiated. Engineering Building HVAC has begun cooling 45 minutes earlier than optimal, resulting in unnecessary baseline load. All other blocks are operating normally.",
        "copilot_forecast": "Campus demand will climb steeply until 09:00. Peak morning demand is estimated at 09:30.",
        "copilot_action": "Reschedule Engineering Building HVAC startup to 08:00.",
        "copilot_savings": "128 kWh",
        "copilot_cost_reduction": "₹2,480",
        "copilot_risk": "Low",
        "dashboard_health": 88,
        "prediction_peak_hour": "09:30",
        "analytics_curve_type": "morning_surge",
        "sustainability_efficiency": 92,
        "timeline_events": [
            {"title": "Morning startup completed.", "description": "System transition to active mode.", "severity": "info", "time_offset_mins": 15},
            {"title": "Engineering Building HVAC demand increased.", "description": "Cooling initiated ahead of schedule.", "severity": "warning", "time_offset_mins": 10},
            {"title": "AI generated optimization recommendation.", "description": "Suggested 30 min delay for HVAC.", "severity": "info", "time_offset_mins": 8},
            {"title": "Campus energy demand exceeded baseline.", "description": "Spike due to early cooling.", "severity": "warning", "time_offset_mins": 5},
            {"title": "Predicted peak demand updated.", "description": "Peak estimated at 09:30.", "severity": "info", "time_offset_mins": 2}
        ]
    },
    {
        "name": "Afternoon Peak",
        "description": "Campus is at maximum occupancy and heat load.",
        "affected_building": "Central Library",
        "alert_title": "Peak Demand Warning",
        "alert_desc": "Library approaching maximum electrical load threshold.",
        "dashboard_recommendation": "Dim lighting in Library common areas.",
        "copilot_summary": "Campus demand is near peak capacity due to afternoon occupancy. Central Library demand has increased by 14% over the last hour. Engineering Building remains stable.",
        "copilot_forecast": "Peak demand expected at 14:30. Current trajectory indicates we will exceed daily target.",
        "copilot_action": "Reduce HVAC cooling by 1°C in Central Library and dim non-essential lighting.",
        "copilot_savings": "240 kWh",
        "copilot_cost_reduction": "₹4,600",
        "copilot_risk": "Medium",
        "dashboard_health": 74,
        "prediction_peak_hour": "14:30",
        "analytics_curve_type": "afternoon_peak",
        "sustainability_efficiency": 84,
        "timeline_events": [
            {"title": "Campus occupancy peaked.", "description": "Maximum afternoon load registered.", "severity": "info", "time_offset_mins": 25},
            {"title": "Library energy demand increased.", "description": "Demand up 14% in last hour.", "severity": "warning", "time_offset_mins": 20},
            {"title": "Peak Demand Warning.", "description": "Threshold exceeded in Central Library.", "severity": "critical", "time_offset_mins": 12},
            {"title": "Load balancing recommended.", "description": "Suggested lighting reduction.", "severity": "info", "time_offset_mins": 5},
            {"title": "Predicted peak demand updated.", "description": "Target set for 14:30.", "severity": "info", "time_offset_mins": 2}
        ]
    },
    {
        "name": "Weekend Low Occupancy",
        "description": "Weekend operations with minimal campus load.",
        "affected_building": "Science Block",
        "alert_title": "Unnecessary Lighting",
        "alert_desc": "Science Block labs have lights on despite zero occupancy.",
        "dashboard_recommendation": "Turn off unused lights in Science Block.",
        "copilot_summary": "Weekend baseline operations. Campus occupancy is below 10%. However, Science Block lighting remains fully active on the 3rd floor despite no detected motion.",
        "copilot_forecast": "Demand will remain flat and low throughout the weekend.",
        "copilot_action": "Engage automated lighting sweep in Science Block.",
        "copilot_savings": "85 kWh",
        "copilot_cost_reduction": "₹1,100",
        "copilot_risk": "Low",
        "dashboard_health": 95,
        "prediction_peak_hour": "12:00",
        "analytics_curve_type": "weekend_flat",
        "sustainability_efficiency": 98,
        "timeline_events": [
            {"title": "Weekend baseline established.", "description": "Operations entered low-occupancy mode.", "severity": "info", "time_offset_mins": 120},
            {"title": "Science Block lighting anomaly.", "description": "Lights detected on 3rd floor.", "severity": "warning", "time_offset_mins": 45},
            {"title": "Zero occupancy confirmed.", "description": "Sensors report no motion in Science Block.", "severity": "info", "time_offset_mins": 30},
            {"title": "Automated lighting sweep recommended.", "description": "AI directive issued to turn off lights.", "severity": "info", "time_offset_mins": 10},
            {"title": "Campus efficiency stabilized.", "description": "System operating at 98% efficiency.", "severity": "resolved", "time_offset_mins": 2}
        ]
    },
    {
        "name": "Heat Wave",
        "description": "Extreme external temperatures causing high cooling load.",
        "affected_building": "Auditorium",
        "alert_title": "HVAC Overload",
        "alert_desc": "Auditorium HVAC is running at 100% capacity continuously.",
        "dashboard_recommendation": "Pre-cool Auditorium and reduce ventilation.",
        "copilot_summary": "Severe heat wave conditions detected. Campus cooling load is 32% above average. Auditorium HVAC is struggling to maintain setpoint and running continuously at max capacity.",
        "copilot_forecast": "Peak thermal load expected at 15:00. High risk of exceeding contracted peak demand limits.",
        "copilot_action": "Pre-cool all major zones immediately and implement load shedding for non-critical systems.",
        "copilot_savings": "450 kWh",
        "copilot_cost_reduction": "₹9,800",
        "copilot_risk": "High",
        "dashboard_health": 65,
        "prediction_peak_hour": "15:00",
        "analytics_curve_type": "heat_wave",
        "sustainability_efficiency": 72,
        "timeline_events": [
            {"title": "Severe heat wave detected.", "description": "External temps 10°C above average.", "severity": "warning", "time_offset_mins": 60},
            {"title": "Cooling load increased.", "description": "Campus load 32% above baseline.", "severity": "warning", "time_offset_mins": 40},
            {"title": "HVAC Overload Warning.", "description": "Auditorium HVAC at max capacity.", "severity": "critical", "time_offset_mins": 25},
            {"title": "Load shedding recommended.", "description": "Pre-cool zones and reduce non-critical systems.", "severity": "info", "time_offset_mins": 10},
            {"title": "Predicted peak demand updated.", "description": "Critical peak expected at 15:00.", "severity": "info", "time_offset_mins": 2}
        ]
    }
]

def get_current_scenario() -> Dict[str, Any]:
    """
    Returns the same scenario for a given 60-second window.
    This ensures all parallel API requests receive consistent data.
    """
    # Rotate scenario every 60 seconds based on current unix time
    scenario_index = int(time.time() // 60) % len(SCENARIOS)
    return SCENARIOS[scenario_index]
