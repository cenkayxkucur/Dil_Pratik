from sqlalchemy.orm import Session
from typing import List, Optional
from ..models.models import Progress as ProgressModel, User as UserModel, Lesson as LessonModel
from ..schemas.progress import ProgressCreate, ProgressResponse
from datetime import datetime


class ProgressService:
    @staticmethod
    async def create_progress(db: Session, progress_data: ProgressCreate, user_id: int) -> ProgressResponse:
        """Create a new progress record"""
        db_progress = ProgressModel(
            user_id=user_id,
            lesson_id=progress_data.lessonId,
            score=progress_data.score,
            completed=progress_data.completed,
            created_at=datetime.utcnow()
        )
        
        db.add(db_progress)
        db.commit()
        db.refresh(db_progress)
        
        return ProgressResponse(
            id=db_progress.id,
            userId=db_progress.user_id,
            lessonId=db_progress.lesson_id,
            score=db_progress.score,
            completed=db_progress.completed,
            createdAt=db_progress.created_at.isoformat(),
            updatedAt=db_progress.updated_at.isoformat() if db_progress.updated_at else None
        )
    
    @staticmethod
    async def get_user_progress(db: Session, user_id: int) -> List[ProgressResponse]:
        """Get all progress records for a user"""
        progress_records = db.query(ProgressModel).filter(
            ProgressModel.user_id == user_id
        ).all()
        
        return [
            ProgressResponse(
                id=progress.id,
                userId=progress.user_id,
                lessonId=progress.lesson_id,
                score=progress.score,
                completed=progress.completed,
                createdAt=progress.created_at.isoformat(),
                updatedAt=progress.updated_at.isoformat() if progress.updated_at else None
            )
            for progress in progress_records
        ]
    
    @staticmethod
    async def get_lesson_progress(db: Session, lesson_id: int, user_id: int) -> Optional[ProgressResponse]:
        """Get progress for a specific lesson and user"""
        progress = db.query(ProgressModel).filter(
            ProgressModel.lesson_id == lesson_id,
            ProgressModel.user_id == user_id
        ).first()
        
        if not progress:
            return None
            
        return ProgressResponse(
            id=progress.id,
            userId=progress.user_id,
            lessonId=progress.lesson_id,
            score=progress.score,
            completed=progress.completed,
            createdAt=progress.created_at.isoformat(),
            updatedAt=progress.updated_at.isoformat() if progress.updated_at else None
        )
    
    @staticmethod
    async def update_progress(db: Session, progress_id: int, user_id: int, progress_data: ProgressCreate) -> Optional[ProgressResponse]:
        """Update an existing progress record"""
        progress = db.query(ProgressModel).filter(
            ProgressModel.id == progress_id,
            ProgressModel.user_id == user_id
        ).first()
        
        if not progress:
            return None
        
        progress.score = progress_data.score
        progress.completed = progress_data.completed
        progress.updated_at = datetime.utcnow()
        
        db.commit()
        db.refresh(progress)
        
        return ProgressResponse(
            id=progress.id,
            userId=progress.user_id,
            lessonId=progress.lesson_id,
            score=progress.score,
            completed=progress.completed,
            createdAt=progress.created_at.isoformat(),
            updatedAt=progress.updated_at.isoformat() if progress.updated_at else None
        )
