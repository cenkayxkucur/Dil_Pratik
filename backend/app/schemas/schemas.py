from pydantic import BaseModel, EmailStr
from typing import Optional, List
from datetime import datetime


class UserBase(BaseModel):
    email: EmailStr
    username: str


class UserCreate(UserBase):
    password: str


class User(UserBase):
    id: int
    is_active: bool
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    username: Optional[str] = None


class LessonBase(BaseModel):
    title: str
    content: str
    difficulty: str
    language: str


class LessonCreate(LessonBase):
    pass


class Lesson(LessonBase):
    id: int
    user_id: int
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class ProgressBase(BaseModel):
    score: float
    completed: bool


class ProgressCreate(ProgressBase):
    lesson_id: int


class Progress(ProgressBase):
    id: int
    user_id: int
    lesson_id: int
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class UserWithDetails(User):
    lessons: List[Lesson] = []
    progress: List[Progress] = []

    class Config:
        from_attributes = True 