"""
Uygulama konfigürasyonu.
Pydantic v1 ile uyumlu — Settings doğrudan pydantic.BaseSettings'den türer.
"""
from pydantic import BaseSettings
from functools import lru_cache


class Settings(BaseSettings):
    DATABASE_URL: str = "sqlite:///./dilpratik.db"
    SECRET_KEY: str = "gizli-super-secret-key-12345-abcdef"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    GEMINI_API_KEY: str = ""
    FIREBASE_CREDENTIALS: str = ""

    class Config:
        env_file = ".env"
        case_sensitive = False


@lru_cache()
def get_settings() -> Settings:
    return Settings()
