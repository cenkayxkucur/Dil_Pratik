from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List, Dict
from ..database import get_db
from ..services.structured_lesson_service import StructuredLessonService
from ..schemas.structured_lesson import (
    LanguageLevelResponse,
    GrammarTopicResponse,
    LessonResponse,
    LanguageLevelWithTopics,
    GrammarTopicWithLessons,
    LanguageLessonsResponse
)

router = APIRouter(tags=["structured-lessons"])

@router.get("/languages", response_model=List[str])
def get_available_languages(db: Session = Depends(get_db)):
    """Get list of available languages"""
    try:
        return StructuredLessonService.get_available_languages(db)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/languages/{language}/levels", response_model=List[Dict[str, str]])
def get_available_levels(
    language: str,
    db: Session = Depends(get_db)
):
    """Get available levels for a specific language"""
    try:
        return StructuredLessonService.get_available_levels_for_language(db, language)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/languages/{language}/levels/{level}", response_model=LanguageLevelWithTopics)
def get_language_level_with_topics(
    language: str,
    level: str,
    db: Session = Depends(get_db)
):
    """Get language level with its grammar topics"""
    try:
        result = StructuredLessonService.get_language_level_with_topics(db, language, level)
        if not result:
            raise HTTPException(status_code=404, detail="Language level not found")
        return result
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/topics/{topic_id}", response_model=GrammarTopicWithLessons)
def get_grammar_topic_with_lessons(
    topic_id: int,
    db: Session = Depends(get_db)
):
    """Get grammar topic with its lessons"""
    try:
        result = StructuredLessonService.get_grammar_topic_with_lessons(db, topic_id)
        if not result:
            raise HTTPException(status_code=404, detail="Grammar topic not found")
        return result
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/lessons/{lesson_id}", response_model=LessonResponse)
def get_lesson(
    lesson_id: int,
    db: Session = Depends(get_db)
):
    """Get a specific lesson by ID"""
    try:
        result = StructuredLessonService.get_lesson_by_id(db, lesson_id)
        if not result:
            raise HTTPException(status_code=404, detail="Lesson not found")
        return result
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/languages/{language}/lessons", response_model=LanguageLessonsResponse)
def get_language_lessons(
    language: str,
    level: str = None,
    topic_id: int = None,
    limit: int = 50,
    offset: int = 0,
    db: Session = Depends(get_db)
):
    """Get lessons for a language with optional filters"""
    try:
        return StructuredLessonService.get_language_lessons(
            db, language, level, topic_id, limit, offset
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
