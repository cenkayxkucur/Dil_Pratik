from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime


# Language Level Schemas
class LanguageLevelResponse(BaseModel):
    id: int
    language: str
    level: str
    display_name: str
    description: Optional[str] = None
    order_index: int
    is_active: bool
    created_at: datetime

    class Config:
        from_attributes = True


# Grammar Topic Schemas  
class GrammarTopicResponse(BaseModel):
    id: int
    language_level_id: int
    title: str
    description: Optional[str] = None
    order_index: int
    is_active: bool
    created_at: datetime

    class Config:
        from_attributes = True


# Lesson Schemas
class LessonResponse(BaseModel):
    id: int
    grammar_topic_id: int
    title: str
    description: Optional[str] = None
    content: str
    lesson_type: str
    order_index: int
    is_active: bool
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


# Combined Response Schemas
class LanguageLevelWithTopics(BaseModel):
    """Language level with its grammar topics"""
    language_level: LanguageLevelResponse
    grammar_topics: List[GrammarTopicResponse]


class GrammarTopicWithLessons(BaseModel):
    """Grammar topic with its lessons"""
    grammar_topic: GrammarTopicResponse
    lessons: List[LessonResponse]


class LanguageLessonsResponse(BaseModel):
    """Complete language structure for lessons page"""
    language: str
    level: str
    display_name: str
    grammar_topics: List[GrammarTopicWithLessons]


# Filter Request Schemas
class LanguageFilterRequest(BaseModel):
    language: Optional[str] = None


class LevelFilterRequest(BaseModel):
    language: str
    level: Optional[str] = None
