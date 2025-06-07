from sqlalchemy.orm import Session
from typing import List, Optional
from ..models.models import User as UserModel
from ..schemas.user import UserCreate, UserLogin, UserResponse
from datetime import datetime
import hashlib


class UserService:
    @staticmethod
    async def create_user(db: Session, user_data: UserCreate) -> UserResponse:
        """Create a new user"""
        # Hash the password (simple implementation - use bcrypt in production)
        hashed_password = hashlib.sha256(user_data.password.encode()).hexdigest()
        
        db_user = UserModel(
            email=user_data.email,
            username=user_data.username,
            hashed_password=hashed_password,
            is_active=True,
            created_at=datetime.utcnow()
        )
        
        db.add(db_user)
        db.commit()
        db.refresh(db_user)
        
        return UserResponse(
            id=db_user.id,
            email=db_user.email,
            username=db_user.username,
            isActive=db_user.is_active,
            createdAt=db_user.created_at.isoformat(),
            updatedAt=db_user.updated_at.isoformat() if db_user.updated_at else None
        )
    
    @staticmethod
    async def authenticate_user(db: Session, email: str, password: str) -> UserModel:
        """Authenticate a user"""
        user = db.query(UserModel).filter(UserModel.email == email).first()
        if not user:
            raise ValueError("Invalid email or password")
        
        hashed_password = hashlib.sha256(password.encode()).hexdigest()
        if user.hashed_password != hashed_password:
            raise ValueError("Invalid email or password")
        
        return user
    
    @staticmethod
    async def get_user_by_email(db: Session, email: str) -> Optional[UserModel]:
        """Get user by email"""
        return db.query(UserModel).filter(UserModel.email == email).first()
    
    @staticmethod
    async def get_user_by_id(db: Session, user_id: int) -> Optional[UserModel]:
        """Get user by ID"""
        return db.query(UserModel).filter(UserModel.id == user_id).first()
