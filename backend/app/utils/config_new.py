from pydantic_settings import BaseSettings
from functools import lru_cache


class Settings(BaseSettings):
    # Database settings
    DATABASE_URL: str

    # Security settings
    SECRET_KEY: str
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    
    # Gemini AI settings
    GEMINI_API_KEY: str

    # Firebase settings
    FIREBASE_CREDENTIALS: str

    class Config:
        env_file = ".env"
        case_sensitive = False


@lru_cache()
def get_settings() -> Settings:
    return Settings()
