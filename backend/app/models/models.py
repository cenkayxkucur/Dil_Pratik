from sqlalchemy import Boolean, Column, ForeignKey, Integer, String, DateTime, Text, Float
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

    # Relationships
    lessons = relationship("Lesson", back_populates="user")
    progress = relationship("Progress", back_populates="user")


class Lesson(Base):
    __tablename__ = "lessons"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=True)
    title = Column(String, nullable=False)
    description = Column(Text)
    content = Column(Text, nullable=False)
    language = Column(String, nullable=False)  # turkish, english, german
    level = Column(String, nullable=False)  # A1, A2, B1, B2, C1, C2
    order_index = Column(Integer, default=0)  # Lesson order within level
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    user = relationship("User", back_populates="lessons")
    progress = relationship("Progress", back_populates="lesson")


class Progress(Base):
    __tablename__ = "progress"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    lesson_id = Column(Integer, ForeignKey("lessons.id"))
    score = Column(Float)
    completed = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    user = relationship("User", back_populates="progress")
    lesson = relationship("Lesson", back_populates="progress")


class PracticeSession(Base):
    __tablename__ = "practice_sessions"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    language = Column(String)  # target language
    level = Column(String)  # A1, A2, B1, B2, C1, C2
    session_type = Column(String)  # conversation, grammar, vocabulary
    content = Column(Text)  # session content/messages
    score = Column(Float, nullable=True)  # session score if applicable
    completed = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    user = relationship("User")


class GrammarTopic(Base):
    __tablename__ = "grammar_topics"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, index=True)
    description = Column(Text)
    language = Column(String)  # target language
    level = Column(String)  # A1, A2, B1, B2, C1, C2
    examples = Column(Text)  # JSON string of examples
    rules = Column(Text)  # grammar rules explanation
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())


class LanguageLevel(Base):
    __tablename__ = "language_levels"

    id = Column(Integer, primary_key=True, index=True)
    code = Column(String, unique=True, index=True)  # A1, A2, B1, B2, C1, C2
    name = Column(String)  # Beginner, Elementary, etc.
    description = Column(Text)
    language = Column(String)  # target language
    min_vocabulary = Column(Integer, default=0)  # minimum vocabulary size
    max_vocabulary = Column(Integer, default=1000)  # maximum vocabulary size
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())