from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv
import os

load_dotenv()

SQLALCHEMY_DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://postgres:123@localhost:5432/dilpratik"
)

# PostgreSQL için özel konfigürasyon
if SQLALCHEMY_DATABASE_URL.startswith("postgresql"):
    engine = create_engine(
        SQLALCHEMY_DATABASE_URL,
        pool_pre_ping=True,
        pool_recycle=300,
        echo=False
    )
else:
    engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

# Veritabanı bağlantısı için dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close() 