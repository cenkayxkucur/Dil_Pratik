from pydantic import BaseModel
from typing import Optional


class LessonCreate(BaseModel):
    title: str
    description: str
    language: str
    difficulty: str
    content: str


class LessonResponse(BaseModel):
    id: int
    title: str
    description: str
    language: str
    difficulty: str
    content: str
    createdAt: str
    updatedAt: Optional[str] = None

    class Config:
        from_attributes = True
