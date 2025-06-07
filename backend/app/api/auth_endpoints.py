from fastapi import APIRouter, HTTPException, Depends, status
from sqlalchemy.orm import Session
from pydantic import BaseModel
from ..database import get_db
from ..models import User
import hashlib
import secrets

router = APIRouter(prefix="/auth", tags=["auth"])

class LoginRequest(BaseModel):
    email: str
    password: str

class RegisterRequest(BaseModel):
    email: str
    password: str
    username: str

class UserResponse(BaseModel):
    id: int
    email: str
    username: str
    is_active: bool
    created_at: str
    updated_at: str

    class Config:
        from_attributes = True

@router.post("/login")
async def login(request: LoginRequest, db: Session = Depends(get_db)):
    try:
        # For testing, return a mock response
        # In production, you would verify the password hash
        return {
            "user": {
                "id": 1,
                "email": request.email,
                "username": "Test User",
                "is_active": True,
                "created_at": "2025-06-07T00:00:00",
                "updated_at": "2025-06-07T00:00:00"
            },
            "token": "mock_token_123"
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.post("/register")
async def register(request: RegisterRequest, db: Session = Depends(get_db)):
    try:
        # For testing, return a mock response
        # In production, you would hash the password and save to database
        return {
            "user": {
                "id": 2,
                "email": request.email,
                "username": request.username,
                "is_active": True,
                "created_at": "2025-06-07T00:00:00",
                "updated_at": "2025-06-07T00:00:00"
            },
            "token": "mock_token_456"
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.post("/logout")
async def logout():
    return {"message": "Logged out successfully"}
