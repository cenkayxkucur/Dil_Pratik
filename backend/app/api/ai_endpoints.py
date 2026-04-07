from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel
from typing import Optional
from ..database import get_db
from ..services.ai_service import ai_service

router = APIRouter()


class ChatRequest(BaseModel):
    message: str
    language: str
    level: str
    user_id: str
    communication_language: Optional[str] = None


class ChatResponse(BaseModel):
    response: str
    success: bool


class GrammarAnalysisRequest(BaseModel):
    text: str
    language: str
    level: str


class PracticeContentRequest(BaseModel):
    topic: str
    language: str
    level: str


class LessonChatRequest(BaseModel):
    message: str
    lesson_id: int
    lesson_content: str
    lesson_title: str
    user_id: str
    language: str
    level: str
    communication_language: Optional[str] = None


class LessonChatResponse(BaseModel):
    response: str
    success: bool
    lesson_context: Optional[str] = None


@router.post("/chat", response_model=ChatResponse)
async def chat_with_ai(request: ChatRequest, db: Session = Depends(get_db)):
    try:
        response = ai_service.get_conversation_response(
            user_id=request.user_id,
            message=request.message,
            language=request.language,
            level=request.level,
            db=db,
            communication_language=request.communication_language,
        )
        return ChatResponse(response=response, success=True)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/analyze-grammar")
async def analyze_grammar(request: GrammarAnalysisRequest, db: Session = Depends(get_db)):
    try:
        analysis = ai_service.analyze_grammar(
            text=request.text,
            language=request.language,
            level=request.level,
        )
        return {"success": True, "analysis": analysis}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/generate-practice")
async def generate_practice_content(request: PracticeContentRequest, db: Session = Depends(get_db)):
    try:
        content = ai_service.generate_practice_content(
            topic=request.topic,
            language=request.language,
            level=request.level,
        )
        return {"success": True, "content": content}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/lesson-chat", response_model=LessonChatResponse)
async def lesson_chat_with_ai(request: LessonChatRequest, db: Session = Depends(get_db)):
    try:
        response = ai_service.get_lesson_conversation_response(
            user_id=request.user_id,
            message=request.message,
            lesson_content=request.lesson_content,
            lesson_title=request.lesson_title,
            lesson_id=request.lesson_id,
            language=request.language,
            level=request.level,
            db=db,
            communication_language=request.communication_language,
        )
        return LessonChatResponse(
            response=response,
            success=True,
            lesson_context=f"Ders: {request.lesson_title}",
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/conversation-history/{user_id}")
async def get_conversation_history(
    user_id: str,
    session_type: str = "conversation",
    lesson_id: Optional[int] = None,
    db: Session = Depends(get_db),
):
    try:
        history = ai_service.get_conversation_history(
            user_id=user_id, db=db,
            session_type=session_type, lesson_id=lesson_id,
        )
        return {"success": True, "history": history}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.delete("/conversation-history/{user_id}")
async def clear_conversation_history(
    user_id: str,
    session_type: str = "conversation",
    lesson_id: Optional[int] = None,
    db: Session = Depends(get_db),
):
    try:
        ai_service.clear_conversation_history(
            user_id=user_id, db=db,
            session_type=session_type, lesson_id=lesson_id,
        )
        return {"success": True, "message": "Conversation history cleared"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# ──────────────────────────────────────────────────────────────────────────────
# Analytics endpoints
# ──────────────────────────────────────────────────────────────────────────────

@router.get("/profile/{user_id}")
async def get_learning_profile(
    user_id: str,
    language: str,
    db: Session = Depends(get_db),
):
    """Kullanıcının öğrenme profilini döndür (zayıf/güçlü alanlar)."""
    try:
        from ..models.models import (
            UserLearningProfile, GrammarKnowledge, WordKnowledge
        )
        import json

        profile = (
            db.query(UserLearningProfile)
            .filter_by(user_id=user_id, language=language)
            .first()
        )

        if not profile:
            return {
                "success": True,
                "message": "Henüz yeterli veri yok",
                "total_interactions": 0,
                "weak_grammar": [],
                "strong_grammar": [],
                "weak_vocabulary": [],
                "strong_vocabulary": [],
                "frequent_topics": [],
            }

        return {
            "success": True,
            "total_interactions": profile.total_interactions,
            "weak_grammar": json.loads(profile.weak_grammar or "[]"),
            "strong_grammar": json.loads(profile.strong_grammar or "[]"),
            "weak_vocabulary": json.loads(profile.weak_vocabulary or "[]"),
            "strong_vocabulary": json.loads(profile.strong_vocabulary or "[]"),
            "frequent_topics": json.loads(profile.frequent_topics or "[]"),
            "last_updated": profile.last_updated.isoformat() if profile.last_updated else None,
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/weak-areas/{user_id}")
async def get_weak_areas(
    user_id: str,
    language: str,
    db: Session = Depends(get_db),
):
    """Kullanıcının en zayıf gramer ve kelime alanlarını döndür."""
    try:
        from ..models.models import GrammarKnowledge, WordKnowledge

        grammar_rows = (
            db.query(GrammarKnowledge)
            .filter_by(user_id=user_id, language=language)
            .all()
        )

        def err_rate(r):
            total = (r.correct_count or 0) + (r.incorrect_count or 0)
            return (r.incorrect_count or 0) / total if total > 0 else 0

        weak_grammar = sorted(
            [
                {
                    "code": r.rule_code,
                    "display": r.rule_display,
                    "error_rate": round(err_rate(r), 2),
                    "incorrect": r.incorrect_count,
                    "correct": r.correct_count,
                }
                for r in grammar_rows
                if ((r.correct_count or 0) + (r.incorrect_count or 0)) >= 2
            ],
            key=lambda x: x["error_rate"],
            reverse=True,
        )[:10]

        word_rows = (
            db.query(WordKnowledge)
            .filter_by(user_id=user_id, language=language)
            .all()
        )

        weak_vocab = sorted(
            [
                {
                    "word": r.word,
                    "error_rate": round(err_rate(r), 2),
                    "next_review_at": r.next_review_at.isoformat() if r.next_review_at else None,
                }
                for r in word_rows
                if ((r.correct_count or 0) + (r.incorrect_count or 0)) >= 2
            ],
            key=lambda x: x["error_rate"],
            reverse=True,
        )[:10]

        return {
            "success": True,
            "weak_grammar": weak_grammar,
            "weak_vocabulary": weak_vocab,
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/review-queue/{user_id}")
async def get_review_queue(
    user_id: str,
    language: str,
    db: Session = Depends(get_db),
):
    """
    Spaced repetition kuyruğu:
    - next_review_at <= şu an olan kelimeler (tekrar zamanı gelmiş)
    - En yüksek hata oranlı gramer kuralları
    - En yüksek hata oranlı kelimeler
    """
    try:
        from ..models.models import GrammarKnowledge, WordKnowledge
        from datetime import datetime

        now = datetime.utcnow()

        def err_rate(r):
            total = (r.correct_count or 0) + (r.incorrect_count or 0)
            return round((r.incorrect_count or 0) / total, 2) if total > 0 else 0

        # Tekrar zamanı gelmiş kelimeler
        due_words = (
            db.query(WordKnowledge)
            .filter(
                WordKnowledge.user_id == user_id,
                WordKnowledge.language == language,
                WordKnowledge.next_review_at <= now,
            )
            .order_by(WordKnowledge.next_review_at)
            .limit(20)
            .all()
        )

        # Hata oranı yüksek gramer kuralları (min 1 etkileşim)
        grammar_rows = (
            db.query(GrammarKnowledge)
            .filter_by(user_id=user_id, language=language)
            .filter(GrammarKnowledge.incorrect_count >= 1)
            .all()
        )
        weak_grammar = sorted(
            [
                {
                    "code": r.rule_code,
                    "display": r.rule_display,
                    "error_rate": err_rate(r),
                    "incorrect": r.incorrect_count or 0,
                    "correct": r.correct_count or 0,
                    "level": r.level,
                }
                for r in grammar_rows
            ],
            key=lambda x: x["error_rate"],
            reverse=True,
        )[:8]

        # Hata oranı yüksek kelimeler (min 1 yanlış)
        word_rows = (
            db.query(WordKnowledge)
            .filter_by(user_id=user_id, language=language)
            .filter(WordKnowledge.incorrect_count >= 1)
            .all()
        )
        weak_vocab = sorted(
            [
                {
                    "word": r.word,
                    "error_rate": err_rate(r),
                    "incorrect": r.incorrect_count or 0,
                    "correct": r.correct_count or 0,
                    "next_review_at": r.next_review_at.isoformat() if r.next_review_at else None,
                }
                for r in word_rows
            ],
            key=lambda x: x["error_rate"],
            reverse=True,
        )[:15]

        return {
            "success": True,
            "due_words": [
                {
                    "word": w.word,
                    "incorrect": w.incorrect_count or 0,
                    "correct": w.correct_count or 0,
                    "error_rate": err_rate(w),
                    "next_review_at": w.next_review_at.isoformat() if w.next_review_at else None,
                }
                for w in due_words
            ],
            "weak_grammar": weak_grammar,
            "weak_vocabulary": weak_vocab,
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/activity/{user_id}")
async def get_activity(
    user_id: str,
    language: str,
    days: int = 7,
    db: Session = Depends(get_db),
):
    """Son N günlük günlük etkileşim sayısını döndür (grafik için)."""
    try:
        from ..models.models import LearningInteraction
        from datetime import datetime, timedelta
        import json

        since = datetime.utcnow() - timedelta(days=days)
        rows = (
            db.query(LearningInteraction)
            .filter(
                LearningInteraction.user_id == user_id,
                LearningInteraction.language == language,
                LearningInteraction.created_at >= since,
            )
            .all()
        )

        # Güne göre grupla
        day_counts: dict = {}
        day_scores: dict = {}
        for row in rows:
            if row.created_at:
                day_key = row.created_at.strftime("%Y-%m-%d")
                day_counts[day_key] = day_counts.get(day_key, 0) + 1
                if row.overall_score is not None:
                    if day_key not in day_scores:
                        day_scores[day_key] = []
                    day_scores[day_key].append(row.overall_score)

        # Son N günü sırala, eksik günler 0
        result = []
        for i in range(days - 1, -1, -1):
            d = (datetime.utcnow() - timedelta(days=i)).strftime("%Y-%m-%d")
            scores = day_scores.get(d, [])
            result.append({
                "date": d,
                "count": day_counts.get(d, 0),
                "avg_score": round(sum(scores) / len(scores), 2) if scores else None,
            })

        return {"success": True, "days": result}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
