from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    database_url: str = "sqlite:///./smart_energy.db"
    cors_origins: str = "http://localhost:8000,http://127.0.0.1:8000,http://localhost:3000,http://127.0.0.1:3000"
    
    class Config:
        env_file = ".env"

settings = Settings()
