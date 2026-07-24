import os

# Configuration variables for the Smart Energy AI Backend
# This keeps our app configuration centralized.

DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./smart_energy.db")
