from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime


# Language Level Schemas
class LanguageLevelCreate(BaseModel):
    language: str  # turkish, english, german
    level: str     # A1, A2, B1, B2, C1, C2
    display_name: str  # A1 - Başlangıç
    is_active: Optional[bool] = True


class LanguageLevelResponse(BaseModel):
    id: int
    language: str
    level: str
    display_name: str
    is_active: bool
    created_at: datetime

    class Config:
        from_attributes = True


# Grammar Topic Schemas
class GrammarTopicCreate(BaseModel):
    language_level_id: int
    title: str
    description: Optional[str] = None
    order_index: Optional[int] = 0
    is_active: Optional[bool] = True


class GrammarTopicUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    order_index: Optional[int] = None
    is_active: Optional[bool] = None


class GrammarTopicResponse(BaseModel):
    id: int
    language_level_id: int
    title: str
    description: Optional[str] = None
    order_index: int
    is_active: bool
    created_at: datetime
    updated_at: Optional[datetime] = None
    
    # Language level bilgisi
    language_level: LanguageLevelResponse

    class Config:
        from_attributes = True


# Lesson Schemas
class LessonCreate(BaseModel):
    grammar_topic_id: int
    title: str
    content: str
    order_index: Optional[int] = 0
    is_active: Optional[bool] = True


class LessonUpdate(BaseModel):
    title: Optional[str] = None
    content: Optional[str] = None
    order_index: Optional[int] = None
    is_active: Optional[bool] = None


class LessonResponse(BaseModel):
    id: int
    grammar_topic_id: int
    title: str
    content: str
    order_index: int
    is_active: bool
    created_at: datetime
    updated_at: Optional[datetime] = None
    
    # Grammar topic bilgisi
    grammar_topic: GrammarTopicResponse

    class Config:
        from_attributes = True


# Combined Response Schemas
class GrammarTopicWithLessons(BaseModel):
    """Konu başlığı ve altındaki dersler"""
    id: int
    title: str
    description: Optional[str] = None
    order_index: int
    lessons: List[LessonResponse]

    class Config:
        from_attributes = True


class LanguageLevelWithTopics(BaseModel):
    """Dil seviyesi ve altındaki konu başlıkları"""
    id: int
    language: str
    level: str
    display_name: str
    grammar_topics: List[GrammarTopicWithLessons]

    class Config:
        from_attributes = True


# Filter and List Schemas
class LanguageLevelFilter(BaseModel):
    language: Optional[str] = None
    level: Optional[str] = None
    is_active: Optional[bool] = True


class GrammarTopicFilter(BaseModel):
    language_level_id: Optional[int] = None
    language: Optional[str] = None
    level: Optional[str] = None
    is_active: Optional[bool] = True


class LessonFilter(BaseModel):
    grammar_topic_id: Optional[int] = None
    language: Optional[str] = None
    level: Optional[str] = None
    is_active: Optional[bool] = True
