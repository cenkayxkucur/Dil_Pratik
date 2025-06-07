from sqlalchemy.orm import Session
from typing import List, Optional
from ..models.models import Lesson as LessonModel
from ..schemas.lesson import LessonCreate, LessonResponse
from datetime import datetime


class LessonService:
    @staticmethod
    async def create_lesson(db: Session, lesson_data: LessonCreate, user_id: int) -> LessonResponse:
        """Create a new lesson"""
        db_lesson = LessonModel(
            title=lesson_data.title,
            description=lesson_data.description,
            language=lesson_data.language,
            difficulty=lesson_data.difficulty,
            content=lesson_data.content,
            created_at=datetime.utcnow()
        )
        
        db.add(db_lesson)
        db.commit()
        db.refresh(db_lesson)
        
        return LessonResponse(
            id=db_lesson.id,
            title=db_lesson.title,
            description=db_lesson.description,
            language=db_lesson.language,
            difficulty=db_lesson.difficulty,
            content=db_lesson.content,
            createdAt=db_lesson.created_at.isoformat(),
            updatedAt=db_lesson.updated_at.isoformat() if db_lesson.updated_at else None
        )
    
    @staticmethod
    async def get_lessons(db: Session, user_id: int, skip: int = 0, limit: int = 10, 
                         language: Optional[str] = None, difficulty: Optional[str] = None) -> List[LessonResponse]:
        """Get lessons with optional filters"""
        query = db.query(LessonModel)
        
        if language:
            query = query.filter(LessonModel.language == language)
        if difficulty:
            query = query.filter(LessonModel.difficulty == difficulty)
        
        lessons = query.offset(skip).limit(limit).all()
        
        return [
            LessonResponse(
                id=lesson.id,
                title=lesson.title,
                description=lesson.description,
                language=lesson.language,
                difficulty=lesson.difficulty,
                content=lesson.content,
                createdAt=lesson.created_at.isoformat(),
                updatedAt=lesson.updated_at.isoformat() if lesson.updated_at else None
            )
            for lesson in lessons
        ]
    
    @staticmethod
    async def get_lesson(db: Session, lesson_id: int) -> Optional[LessonResponse]:
        """Get a specific lesson"""
        lesson = db.query(LessonModel).filter(LessonModel.id == lesson_id).first()
        
        if not lesson:
            return None
            
        return LessonResponse(
            id=lesson.id,
            title=lesson.title,
            description=lesson.description,
            language=lesson.language,
            difficulty=lesson.difficulty,
            content=lesson.content,
            createdAt=lesson.created_at.isoformat(),
            updatedAt=lesson.updated_at.isoformat() if lesson.updated_at else None
        )
