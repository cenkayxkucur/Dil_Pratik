from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List, Optional
from ..database import get_db
from ..models import GrammarTopic, LanguageLevel
from ..services.ai_service import ai_service

router = APIRouter()

@router.get("/topics")
async def get_topics(
    language: str,
    level: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Belirli bir dil ve seviye için gramer konularını listeler."""
    query = db.query(GrammarTopic).filter(GrammarTopic.language == language)
    
    if level:
        query = query.filter(GrammarTopic.level == level)
    
    topics = query.all()
    return topics

@router.get("/topics/{topic_id}")
async def get_topic(
    topic_id: int,
    db: Session = Depends(get_db)
):
    """Belirli bir gramer konusunun detaylarını getirir."""
    topic = db.query(GrammarTopic).filter(GrammarTopic.id == topic_id).first()
    if not topic:
        raise HTTPException(status_code=404, detail="Topic not found")
    return topic

@router.post("/topics/{topic_id}/exercises")
async def generate_exercises(
    topic_id: int,
    error_types: Optional[List[str]] = None,
    db: Session = Depends(get_db)
):
    """Belirli bir konu için alıştırmalar üretir."""
    topic = db.query(GrammarTopic).filter(GrammarTopic.id == topic_id).first()
    if not topic:
        raise HTTPException(status_code=404, detail="Topic not found")
    
    exercises = await ai_service.generate_exercises(
        topic=topic.title,
        level=topic.level.value,
        language=topic.language,
        error_types=error_types
    )
    
    return exercises

@router.post("/topics")
async def create_topic(
    title: str,
    content: str,
    language: str,
    level: str,
    examples: List[dict],
    exercises: List[dict],
    db: Session = Depends(get_db)
):
    """Yeni bir gramer konusu oluşturur."""
    topic = GrammarTopic(
        title=title,
        content=content,
        language=language,
        level=level,
        examples=examples,
        exercises=exercises
    )
    
    db.add(topic)
    db.commit()
    db.refresh(topic)
    
    return topic

@router.post("/analyze")
async def analyze_grammar(
    text: str,
    language: str
):
    """Metnin gramer analizini yapar."""
    try:
        analysis = ai_service.analyze_grammar(text, language)
        return {
            "original_text": text,
            "language": language,
            "analysis": analysis
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Gramer analizi hatası: {str(e)}")