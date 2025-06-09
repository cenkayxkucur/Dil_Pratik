from datetime import timedelta
from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session

from ..models.models import User, Lesson, Progress
from ..schemas.token import Token, TokenData
from ..schemas.user import UserCreate, UserLogin, UserResponse
from ..schemas.lesson import LessonCreate, LessonResponse
from ..schemas.progress import ProgressCreate, ProgressResponse
from ..services.auth import (
    authenticate_user,
    create_access_token,
    get_current_user,
    get_password_hash,
)
from ..services.user_service import UserService
from ..services.lesson_service import LessonService
from ..services.progress_service import ProgressService
from ..utils.database import get_db
from ..utils.config import get_settings

settings = get_settings()
router = APIRouter()


@router.post("/token", response_model=Token)
async def login_for_access_token(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db)
):
    user = authenticate_user(db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer"}


@router.post("/users/register", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def register_user(user: UserCreate, db: Session = Depends(get_db)):
    try:
        return await UserService.create_user(db, user)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.post("/users/login", response_model=dict)
async def login_user(user: UserLogin, db: Session = Depends(get_db)):
    try:
        db_user = await UserService.authenticate_user(db, user.email, user.password)
        token = create_access_token(data={"sub": db_user.email})
        return {"access_token": token, "token_type": "bearer"}
    except ValueError as e:
        raise HTTPException(status_code=401, detail=str(e))


@router.get("/users/me", response_model=UserResponse)
async def get_current_user_info(current_user: User = Depends(get_current_user)):
    return UserResponse(
        id=current_user.id,
        email=current_user.email,
        username=current_user.username,
        isActive=current_user.is_active,
        createdAt=current_user.created_at.isoformat(),
        updatedAt=current_user.updated_at.isoformat() if current_user.updated_at else None
    )


@router.post("/lessons", response_model=LessonResponse, status_code=status.HTTP_201_CREATED)
async def create_lesson(
    lesson: LessonCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    try:
        return await LessonService.create_lesson(db, lesson, current_user.id)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/lessons", response_model=List[LessonResponse])
async def get_lessons(
    skip: int = 0,
    limit: int = 10,
    language: Optional[str] = None,
    difficulty: Optional[str] = None,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    try:
        return await LessonService.get_lessons(
            db,
            user_id=current_user.id,
            skip=skip,
            limit=limit,
            language=language,
            difficulty=difficulty
        )
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/public/lessons", response_model=List[LessonResponse])
async def get_public_lessons(
    skip: int = 0,
    limit: int = 10,
    language: Optional[str] = None,
    difficulty: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Public endpoint to get lessons without authentication"""
    try:
        return await LessonService.get_public_lessons(
            db,
            skip=skip,
            limit=limit,
            language=language,
            difficulty=difficulty
        )
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/lessons/{lesson_id}", response_model=LessonResponse)
async def get_lesson(
    lesson_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    try:
        lesson = await LessonService.get_lesson(db, lesson_id)
        if not lesson:
            raise HTTPException(status_code=404, detail="Lesson not found")
        return lesson
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.post("/progress", response_model=ProgressResponse, status_code=status.HTTP_201_CREATED)
async def create_progress(
    progress: ProgressCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    try:
        return await ProgressService.create_progress(db, progress, current_user.id)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/progress", response_model=List[ProgressResponse])
async def get_progress(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    try:
        return await ProgressService.get_user_progress(db, current_user.id)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/progress/{lesson_id}", response_model=ProgressResponse)
async def get_lesson_progress(
    lesson_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    try:
        progress = await ProgressService.get_lesson_progress(db, lesson_id, current_user.id)
        if not progress:
            raise HTTPException(status_code=404, detail="Progress not found")
        return progress
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
