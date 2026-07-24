from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    database_url: str = "sqlite:///./smart_energy.db"
    cors_origins: str = "http://localhost:8000,http://127.0.0.1:8000,http://localhost:3000,http://127.0.0.1:3000,https://smart-energy-ai-3ff26.web.app,https://smart-energy-ai-3ff26.firebaseapp.com"
    
    class Config:
        env_file = ".env"

settings = Settings()
