from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker
from app.config import settings

# Fix Heroku/Render postgres:// URI issue
db_url = settings.database_url
if db_url.startswith("postgres://"):
    db_url = db_url.replace("postgres://", "postgresql://", 1)

# Configure args based on the database type
connect_args = {}
if db_url.startswith("sqlite"):
    connect_args["check_same_thread"] = False

# Setup SQLAlchemy engine
engine = create_engine(
    db_url, connect_args=connect_args
)

# Create a sessionmaker for dependency injection
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base class for our SQLAlchemy models
Base = declarative_base()

# Dependency to get a database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
