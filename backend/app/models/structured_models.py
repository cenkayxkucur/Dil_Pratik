#!/usr/bin/env python3
"""
Yeni yapılandırılmış tablo modelleri
"""
from sqlalchemy import Column, Integer, String, Text, Boolean, DateTime, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from datetime import datetime

Base = declarative_base()

class LanguageLevel(Base):
    """
    Dil seviyeleri tablosu
    Her dil için ayrı seviyeler (Türkçe A1, İngilizce A1, vs.)
    """
    __tablename__ = "language_levels"
    
    id = Column(Integer, primary_key=True, index=True)
    language = Column(String(50), nullable=False)  # turkish, english, german
    level = Column(String(10), nullable=False)     # A1, A2, B1, B2, C1, C2
    display_name = Column(String(100), nullable=False)  # "Türkçe A1 - Başlangıç"
    description = Column(Text)                     # Seviye açıklaması
    order_index = Column(Integer, default=0)      # Sıralama için
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # İlişkiler
    grammar_topics = relationship("GrammarTopic", back_populates="language_level")
    
    def __repr__(self):
        return f"<LanguageLevel(language='{self.language}', level='{self.level}')>"

class GrammarTopic(Base):
    """
    Dil bilgisi konuları tablosu
    Her seviye için konu başlıkları (örn: Türkçe A1 için "Selamlaşma", "Tanışma", vs.)
    """
    __tablename__ = "grammar_topics"
    
    id = Column(Integer, primary_key=True, index=True)
    language_level_id = Column(Integer, ForeignKey("language_levels.id"), nullable=False)
    title = Column(String(200), nullable=False)   # Konu başlığı
    description = Column(Text)                    # Konu açıklaması
    order_index = Column(Integer, default=0)     # Sıralama için
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # İlişkiler
    language_level = relationship("LanguageLevel", back_populates="grammar_topics")
    lessons = relationship("Lesson", back_populates="grammar_topic")
    
    def __repr__(self):
        return f"<GrammarTopic(title='{self.title}')>"

class Lesson(Base):
    """
    Dersler tablosu
    Her grammar topic için dersler
    """
    __tablename__ = "lessons"
    
    id = Column(Integer, primary_key=True, index=True)
    grammar_topic_id = Column(Integer, ForeignKey("grammar_topics.id"), nullable=False)
    title = Column(String(200), nullable=False)  # Ders başlığı
    description = Column(Text)                   # Ders açıklaması
    content = Column(Text, nullable=False)       # Ders içeriği
    lesson_type = Column(String(50), default="grammar")  # grammar, vocabulary, practice, etc.
    order_index = Column(Integer, default=0)    # Sıralama için
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # İlişkiler
    grammar_topic = relationship("GrammarTopic", back_populates="lessons")
    
    def __repr__(self):
        return f"<Lesson(title='{self.title}')>"
