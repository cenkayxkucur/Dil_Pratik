from fastapi import APIRouter, Depends, HTTPException, UploadFile, File
from sqlalchemy.orm import Session
from typing import Dict, Optional
from app.services.ai_service import ai_service
from app.database import get_db
from app.models import PracticeSession, User
from datetime import datetime

router = APIRouter()

@router.post("/start-session")
async def start_session(
    user_id: int,
    language: str,
    db: Session = Depends(get_db)
):
    """Yeni bir konuşma oturumu başlatır."""
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    session = PracticeSession(
        user_id=user_id,
        start_time=datetime.utcnow()
    )
    db.add(session)
    db.commit()
    db.refresh(session)
    
    return {"session_id": session.id}

@router.post("/process-speech")
async def process_speech(
    file: UploadFile = File(...),
    session_id: int = None,
    db: Session = Depends(get_db)
):
    """Ses dosyasını işler ve yanıt üretir."""
    try:
        result = await ai_service.process_speech(file.file)
        
        if session_id:
            session = db.query(PracticeSession).filter(PracticeSession.id == session_id).first()
            if session:
                # Konuşma loglarını güncelle
                current_logs = session.conversation_log or []
                current_logs.append({
                    "timestamp": datetime.utcnow().isoformat(),
                    "type": "speech",
                    "content": result["text"],
                    "confidence": result["confidence"]
                })
                session.conversation_log = current_logs
                db.commit()
        
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/chat")
async def chat(
    user_id: int,
    message: str,
    session_id: Optional[int] = None,
    db: Session = Depends(get_db)
):
    """Metin tabanlı sohbet için endpoint."""
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    try:
        response = await ai_service.get_conversation_response(
            str(user_id),
            message,
            user.target_language,
            user.current_level.value
        )
        
        if session_id:
            session = db.query(PracticeSession).filter(PracticeSession.id == session_id).first()
            if session:
                # Konuşma loglarını güncelle
                current_logs = session.conversation_log or []
                current_logs.extend([
                    {
                        "timestamp": datetime.utcnow().isoformat(),
                        "type": "user",
                        "content": message
                    },
                    {
                        "timestamp": datetime.utcnow().isoformat(),
                        "type": "assistant",
                        "content": response
                    }
                ])
                session.conversation_log = current_logs
                db.commit()
        
        return {"response": response}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/end-session")
async def end_session(
    session_id: int,
    db: Session = Depends(get_db)
):
    """Konuşma oturumunu sonlandırır."""
    session = db.query(PracticeSession).filter(PracticeSession.id == session_id).first()
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    
    session.end_time = datetime.utcnow()
    db.commit()
    
    return {"message": "Session ended successfully"} 