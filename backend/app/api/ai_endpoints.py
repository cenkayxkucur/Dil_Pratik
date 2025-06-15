from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel
from typing import Dict, List, Optional
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
    """Chat with AI language teacher"""
    try:
        response = ai_service.get_conversation_response(
            user_id=request.user_id,
            message=request.message,
            language=request.language,
            level=request.level,
            communication_language=request.communication_language
        )
        
        return ChatResponse(response=response, success=True)
    
    except Exception as e:
        print(f"Chat error: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/analyze-grammar")
async def analyze_grammar(request: GrammarAnalysisRequest, db: Session = Depends(get_db)):
    """Analyze grammar of text"""
    try:
        analysis = ai_service.analyze_grammar(
            text=request.text,
            language=request.language,
            level=request.level
        )
        
        return {"success": True, "analysis": analysis}
    
    except Exception as e:
        print(f"Grammar analysis error: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/generate-practice")
async def generate_practice_content(request: PracticeContentRequest, db: Session = Depends(get_db)):
    """Generate practice content for a topic"""
    try:
        content = ai_service.generate_practice_content(
            topic=request.topic,
            language=request.language,
            level=request.level
        )
        
        return {"success": True, "content": content}
    
    except Exception as e:
        print(f"Content generation error: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/lesson-chat", response_model=LessonChatResponse)
async def lesson_chat_with_ai(request: LessonChatRequest, db: Session = Depends(get_db)):
    """Chat with AI about specific lesson content"""
    try:
        response = ai_service.get_lesson_conversation_response(
            user_id=request.user_id,
            message=request.message,
            lesson_content=request.lesson_content,
            lesson_title=request.lesson_title,
            lesson_id=request.lesson_id,
            language=request.language,
            level=request.level,
            communication_language=request.communication_language
        )
        
        return LessonChatResponse(
            response=response, 
            success=True,
            lesson_context=f"Ders: {request.lesson_title}"
        )
    
    except Exception as e:
        print(f"Lesson chat error: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/conversation-history/{user_id}")
async def get_conversation_history(user_id: str, db: Session = Depends(get_db)):
    """Get conversation history for a user"""
    try:
        history = ai_service.conversation_history.get(user_id, [])
        return {"success": True, "history": history}
    
    except Exception as e:
        print(f"History retrieval error: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@router.delete("/conversation-history/{user_id}")
async def clear_conversation_history(user_id: str, db: Session = Depends(get_db)):
    """Clear conversation history for a user"""
    try:
        if user_id in ai_service.conversation_history:
            del ai_service.conversation_history[user_id]
        
        return {"success": True, "message": "Conversation history cleared"}
    
    except Exception as e:
        print(f"History clear error: {e}")
        raise HTTPException(status_code=500, detail=str(e))
