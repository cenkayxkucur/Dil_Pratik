from sqlalchemy.orm import Session
from sqlalchemy import and_
from typing import List, Optional
from ..models.models import Lesson as LessonModel
from ..schemas.lesson import LessonCreate, LessonUpdate, LessonResponse, LessonListResponse, LessonFilterRequest
from datetime import datetime


class LessonService:
    @staticmethod
    def create_lesson(db: Session, lesson_data: LessonCreate, user_id: Optional[int] = None) -> LessonResponse:
        """Create a new lesson"""
        db_lesson = LessonModel(
            title=lesson_data.title,
            description=lesson_data.description,
            language=lesson_data.language,
            level=lesson_data.level,
            content=lesson_data.content,
            order_index=lesson_data.order_index,
            is_active=lesson_data.is_active,
            user_id=user_id,
            created_at=datetime.utcnow()
        )
        
        db.add(db_lesson)
        db.commit()
        db.refresh(db_lesson)
        
        return LessonResponse.from_orm(db_lesson)
    
    @staticmethod
    def get_lessons_by_filter(db: Session, filters: LessonFilterRequest) -> LessonListResponse:
        """Get lessons with language and level filters"""
        query = db.query(LessonModel).filter(LessonModel.is_active == True)
        
        # Apply filters
        if filters.language:
            query = query.filter(LessonModel.language == filters.language)
        if filters.level:
            query = query.filter(LessonModel.level == filters.level)
        
        # Order by order_index and created_at
        query = query.order_by(LessonModel.order_index, LessonModel.created_at)
        
        # Get total count
        total = query.count()
        
        # Apply pagination
        lessons = query.offset(filters.offset).limit(filters.limit).all()
        
        lesson_responses = [LessonResponse.from_orm(lesson) for lesson in lessons]
        
        return LessonListResponse(
            lessons=lesson_responses,
            total=total,
            offset=filters.offset,
            limit=filters.limit
        )
    
    @staticmethod
    def get_lesson_by_id(db: Session, lesson_id: int) -> Optional[LessonResponse]:
        """Get a lesson by ID"""
        lesson = db.query(LessonModel).filter(
            and_(LessonModel.id == lesson_id, LessonModel.is_active == True)
        ).first()
        
        if lesson:
            return LessonResponse.from_orm(lesson)
        return None
    
    @staticmethod
    def update_lesson(db: Session, lesson_id: int, lesson_data: LessonUpdate) -> Optional[LessonResponse]:
        """Update a lesson"""
        lesson = db.query(LessonModel).filter(LessonModel.id == lesson_id).first()
        
        if not lesson:
            return None
        
        # Update only provided fields
        if lesson_data.title is not None:
            lesson.title = lesson_data.title
        if lesson_data.description is not None:
            lesson.description = lesson_data.description
        if lesson_data.content is not None:
            lesson.content = lesson_data.content
        if lesson_data.order_index is not None:
            lesson.order_index = lesson_data.order_index
        if lesson_data.is_active is not None:
            lesson.is_active = lesson_data.is_active
        
        lesson.updated_at = datetime.utcnow()
        
        db.commit()
        db.refresh(lesson)
        
        return LessonResponse.from_orm(lesson)
    
    @staticmethod
    def delete_lesson(db: Session, lesson_id: int) -> bool:
        """Soft delete a lesson"""
        lesson = db.query(LessonModel).filter(LessonModel.id == lesson_id).first()
        
        if not lesson:
            return False
        
        lesson.is_active = False
        lesson.updated_at = datetime.utcnow()
        
        db.commit()
        return True
    
    @staticmethod
    def get_available_languages(db: Session) -> List[str]:
        """Get list of available languages"""
        languages = db.query(LessonModel.language).filter(
            LessonModel.is_active == True
        ).distinct().all()
        
        return [lang[0] for lang in languages if lang[0]]
    
    @staticmethod
    def get_available_levels_for_language(db: Session, language: str) -> List[str]:
        """Get available levels for a specific language"""
        levels = db.query(LessonModel.level).filter(
            and_(
                LessonModel.language == language,
                LessonModel.is_active == True
            )
        ).distinct().all()
        
        return [level[0] for level in levels if level[0]]
    
    @staticmethod
    def get_lesson_metadata(db: Session) -> dict:
        """Get lesson metadata including languages, levels, and counts"""
        # Get all languages
        languages = LessonService.get_available_languages(db)
        
        # Get all levels
        all_levels = db.query(LessonModel.level).filter(
            LessonModel.is_active == True
        ).distinct().all()
        levels = [level[0] for level in all_levels if level[0]]
        
        # Get lesson counts by language
        lesson_counts = {}
        for language in languages:
            count = db.query(LessonModel).filter(
                and_(
                    LessonModel.language == language,
                    LessonModel.is_active == True
                )
            ).count()
            lesson_counts[language] = count
        
        return {
            "languages": languages,
            "levels": levels,
            "lesson_counts": lesson_counts
        }
