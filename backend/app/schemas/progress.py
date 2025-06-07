from pydantic import BaseModel
from typing import Optional


class ProgressCreate(BaseModel):
    lessonId: int
    score: float
    completed: bool = False


class ProgressResponse(BaseModel):
    id: int
    userId: int
    lessonId: int
    score: float
    completed: bool
    createdAt: str
    updatedAt: Optional[str] = None

    class Config:
        from_attributes = True
