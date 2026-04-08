from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel
from typing import Optional

from ..database import get_db

router = APIRouter()


class SaveWordRequest(BaseModel):
    user_id: str
    language: str
    word: str
    translation: Optional[str] = None
    context: Optional[str] = None


@router.post("/")
async def save_word(request: SaveWordRequest, db: Session = Depends(get_db)):
    """Kelimeyi defterine kaydet. Aynı kelime zaten varsa güncelle."""
    try:
        from ..models.models import SavedWord
        from sqlalchemy.exc import IntegrityError

        existing = (
            db.query(SavedWord)
            .filter_by(
                user_id=request.user_id,
                word=request.word.strip().lower(),
                language=request.language,
            )
            .first()
        )

        word = request.word.strip().lower()

        if existing:
            if request.translation is not None:
                existing.translation = request.translation
            if request.context is not None:
                existing.context = request.context
            db.commit()
            return {"success": True, "id": existing.id, "updated": True}

        saved = SavedWord(
            user_id=request.user_id,
            language=request.language,
            word=word,
            translation=request.translation,
            context=request.context,
        )
        db.add(saved)
        db.commit()
        db.refresh(saved)
        return {"success": True, "id": saved.id, "updated": False}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/{user_id}")
async def get_saved_words(
    user_id: str,
    language: str,
    db: Session = Depends(get_db),
):
    """Kullanıcının kaydettiği kelimeleri döndür."""
    try:
        from ..models.models import SavedWord

        words = (
            db.query(SavedWord)
            .filter_by(user_id=user_id, language=language)
            .order_by(SavedWord.created_at.desc())
            .all()
        )

        return {
            "success": True,
            "words": [
                {
                    "id": w.id,
                    "word": w.word,
                    "translation": w.translation,
                    "context": w.context,
                    "created_at": w.created_at.isoformat() if w.created_at else None,
                }
                for w in words
            ],
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.delete("/{word_id}")
async def delete_saved_word(
    word_id: int,
    user_id: str,
    db: Session = Depends(get_db),
):
    """Kelimeyi defterden sil."""
    try:
        from ..models.models import SavedWord

        word = (
            db.query(SavedWord)
            .filter_by(id=word_id, user_id=user_id)
            .first()
        )
        if not word:
            raise HTTPException(status_code=404, detail="Kelime bulunamadı")

        db.delete(word)
        db.commit()
        return {"success": True}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
