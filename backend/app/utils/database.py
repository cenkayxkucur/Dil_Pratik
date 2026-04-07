# Geriye dönük uyumluluk için tüm database nesnelerini app.database'den re-export eder.
# Yeni kod doğrudan app.database'i kullanmalı.
from sqlalchemy.ext.declarative import declarative_base
from ..database import engine, SessionLocal, get_db  # noqa: F401

Base = declarative_base()
