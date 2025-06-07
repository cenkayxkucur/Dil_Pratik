from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, Enum, JSON, Float
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base
import enum
from datetime import datetime

Base = declarative_base()

class LanguageLevel(enum.Enum):
    A1 = "A1"
    A2 = "A2"
    B1 = "B1"
    B2 = "B2"
    C1 = "C1"
    C2 = "C2"

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    full_name = Column(String)
    created_at = Column(DateTime, default=datetime.utcnow)
    target_language = Column(String)
    current_level = Column(Enum(LanguageLevel))
    
    # İlişkiler
    practice_sessions = relationship("PracticeSession", back_populates="user")
    progress_records = relationship("ProgressRecord", back_populates="user")

class GrammarTopic(Base):
    __tablename__ = "grammar_topics"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String)
    content = Column(String)
    level = Column(Enum(LanguageLevel))
    language = Column(String)
    examples = Column(JSON)  # JSON formatında örnek cümleler
    exercises = Column(JSON)  # JSON formatında alıştırmalar

class PracticeSession(Base):
    __tablename__ = "practice_sessions"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    start_time = Column(DateTime, default=datetime.utcnow)
    end_time = Column(DateTime, nullable=True)
    conversation_log = Column(JSON)  # JSON formatında konuşma kayıtları
    pronunciation_scores = Column(JSON)  # JSON formatında telaffuz skorları
    grammar_errors = Column(JSON)  # JSON formatında gramer hataları
    
    user = relationship("User", back_populates="practice_sessions")

class ProgressRecord(Base):
    __tablename__ = "progress_records"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    date = Column(DateTime, default=datetime.utcnow)
    topic_id = Column(Integer, ForeignKey("grammar_topics.id"))
    score = Column(Float)  # 0-100 arası skor
    error_types = Column(JSON)  # JSON formatında hata tipleri
    
    user = relationship("User", back_populates="progress_records")
    topic = relationship("GrammarTopic") 