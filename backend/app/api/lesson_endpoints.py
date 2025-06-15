from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List, Optional
from ..database import get_db
from ..services.lesson_service import LessonService
from ..schemas.lesson import (
    LessonCreate, 
    LessonUpdate, 
    LessonResponse, 
    LessonListResponse, 
    LessonFilterRequest
)

router = APIRouter(tags=["lessons"])


@router.post("/", response_model=LessonResponse, status_code=status.HTTP_201_CREATED)
def create_lesson(
    lesson_data: LessonCreate,
    db: Session = Depends(get_db)
):
    """Create a new lesson"""
    try:
        return LessonService.create_lesson(db, lesson_data)
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/", response_model=LessonListResponse)
def get_lessons(
    language: Optional[str] = None,
    level: Optional[str] = None,
    limit: Optional[int] = 50,
    offset: Optional[int] = 0,
    db: Session = Depends(get_db)
):
    """Get lessons with optional filters"""
    try:
        filters = LessonFilterRequest(
            language=language,
            level=level,
            limit=limit,
            offset=offset
        )
        return LessonService.get_lessons_by_filter(db, filters)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/{lesson_id}", response_model=LessonResponse)
def get_lesson(
    lesson_id: int,
    db: Session = Depends(get_db)
):
    """Get a specific lesson by ID"""
    lesson = LessonService.get_lesson_by_id(db, lesson_id)
    
    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")
    
    return lesson


@router.put("/{lesson_id}", response_model=LessonResponse)
def update_lesson(
    lesson_id: int,
    lesson_data: LessonUpdate,
    db: Session = Depends(get_db)
):
    """Update a lesson"""
    lesson = LessonService.update_lesson(db, lesson_id, lesson_data)
    
    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")
    
    return lesson


@router.delete("/{lesson_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_lesson(
    lesson_id: int,
    db: Session = Depends(get_db)
):
    """Delete a lesson (soft delete)"""
    success = LessonService.delete_lesson(db, lesson_id)
    
    if not success:
        raise HTTPException(status_code=404, detail="Lesson not found")


@router.get("/metadata/languages", response_model=List[str])
def get_available_languages(db: Session = Depends(get_db)):
    """Get list of available languages"""
    try:
        return LessonService.get_available_languages(db)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/metadata/levels/{language}", response_model=List[str])
def get_available_levels(
    language: str,
    db: Session = Depends(get_db)
):
    """Get available levels for a specific language"""
    try:
        return LessonService.get_available_levels_for_language(db, language)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
