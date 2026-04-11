from pydantic import BaseModel
from typing import Optional


class UserCreate(BaseModel):
    email: str
    username: str
    password: str


class UserLogin(BaseModel):
    email: str
    password: str


class UserResponse(BaseModel):
    id: int
    email: str
    username: str
    isActive: bool
    createdAt: str
    updatedAt: Optional[str] = None

    class Config:
        orm_mode = True
