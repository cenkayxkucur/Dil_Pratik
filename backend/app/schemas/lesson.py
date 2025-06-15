from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime


class LessonCreate(BaseModel):
    title: str
    description: Optional[str] = None
    language: str  # turkish, english, german
    level: str     # A1, A2, B1, B2, C1, C2
    content: str
    order_index: Optional[int] = 0
    is_active: Optional[bool] = True


class LessonUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    content: Optional[str] = None
    order_index: Optional[int] = None
    is_active: Optional[bool] = None


class LessonResponse(BaseModel):
    id: int
    title: str
    description: Optional[str] = None
    language: str
    level: str
    content: str
    order_index: int
    is_active: bool
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class LessonListResponse(BaseModel):
    lessons: List[LessonResponse]
    total: int
    offset: int
    limit: int


class LessonFilterRequest(BaseModel):
    language: Optional[str] = None  # Filter by language
    level: Optional[str] = None     # Filter by level
    limit: Optional[int] = 50
    offset: Optional[int] = 0
