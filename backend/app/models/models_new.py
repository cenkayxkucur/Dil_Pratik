from sqlalchemy import Boolean, Column, ForeignKey, Integer, String, DateTime, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from ..utils.database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    username = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())


class LanguageLevel(Base):
    """Dil Seviyeleri - Her dil için mevcut seviyeler"""
    __tablename__ = "language_levels"

    id = Column(Integer, primary_key=True, index=True)
    language = Column(String, nullable=False)  # turkish, english, german
    level = Column(String, nullable=False)  # A1, A2, B1, B2, C1, C2
    display_name = Column(String, nullable=False)  # A1 - Başlangıç
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    grammar_topics = relationship("GrammarTopic", back_populates="language_level", cascade="all, delete-orphan")


class GrammarTopic(Base):
    """Gramer Konuları - Her dil seviyesi için konu başlıkları"""
    __tablename__ = "grammar_topics"

    id = Column(Integer, primary_key=True, index=True)
    language_level_id = Column(Integer, ForeignKey("language_levels.id"), nullable=False)
    title = Column(String, nullable=False)  # Selamlama ve Tanışma, Present Tense, etc.
    description = Column(Text)
    order_index = Column(Integer, default=0)  # Konu sırası
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    language_level = relationship("LanguageLevel", back_populates="grammar_topics")
    lessons = relationship("Lesson", back_populates="grammar_topic", cascade="all, delete-orphan")


class Lesson(Base):
    """Dersler - Her gramer konusu için ders içerikleri"""
    __tablename__ = "lessons"

    id = Column(Integer, primary_key=True, index=True)
    grammar_topic_id = Column(Integer, ForeignKey("grammar_topics.id"), nullable=False)
    title = Column(String, nullable=False)
    content = Column(Text, nullable=False)
    order_index = Column(Integer, default=0)  # Ders sırası konu içerisinde
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    grammar_topic = relationship("GrammarTopic", back_populates="lessons")
