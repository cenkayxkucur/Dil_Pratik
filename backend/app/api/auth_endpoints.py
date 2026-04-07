from fastapi import APIRouter, HTTPException, Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
from pydantic import BaseModel
from typing import Optional
from datetime import datetime, timedelta
from jose import jwt, JWTError
from passlib.context import CryptContext
import os

security = HTTPBearer()

from ..database import get_db
from ..models import User

router = APIRouter(prefix="/auth", tags=["auth"])

SECRET_KEY = os.getenv("SECRET_KEY", "gizli-super-secret-key-12345-abcdef")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_DAYS = 7

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def hash_password(password: str) -> str:
    return pwd_context.hash(password)


def verify_password(plain: str, hashed: str) -> bool:
    return pwd_context.verify(plain, hashed)


def create_access_token(user_id: int, email: str) -> str:
    expire = datetime.utcnow() + timedelta(days=ACCESS_TOKEN_EXPIRE_DAYS)
    payload = {"sub": str(user_id), "email": email, "exp": expire}
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)


def format_user(user: User) -> dict:
    return {
        "id": user.id,
        "email": user.email,
        "username": user.username,
        "is_active": user.is_active,
        "created_at": user.created_at.isoformat() if user.created_at else datetime.utcnow().isoformat(),
        "updated_at": user.updated_at.isoformat() if user.updated_at else datetime.utcnow().isoformat(),
    }


class LoginRequest(BaseModel):
    email: str
    password: str


class RegisterRequest(BaseModel):
    email: str
    password: str
    username: str


@router.post("/register")
async def register(request: RegisterRequest, db: Session = Depends(get_db)):
    # Email kontrolü
    existing = db.query(User).filter(User.email == request.email).first()
    if existing:
        raise HTTPException(status_code=400, detail="Bu e-posta adresi zaten kayıtlı")

    # Kullanıcı adı kontrolü
    existing_username = db.query(User).filter(User.username == request.username).first()
    if existing_username:
        raise HTTPException(status_code=400, detail="Bu kullanıcı adı zaten alınmış")

    user = User(
        email=request.email,
        username=request.username,
        hashed_password=hash_password(request.password),
        is_active=True,
    )
    db.add(user)
    db.commit()
    db.refresh(user)

    token = create_access_token(user.id, user.email)
    return {"user": format_user(user), "token": token}


@router.post("/login")
async def login(request: LoginRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == request.email).first()
    if not user or not verify_password(request.password, user.hashed_password):
        raise HTTPException(status_code=401, detail="E-posta veya şifre hatalı")

    if not user.is_active:
        raise HTTPException(status_code=403, detail="Hesap devre dışı")

    token = create_access_token(user.id, user.email)
    return {"user": format_user(user), "token": token}


@router.post("/logout")
async def logout():
    return {"message": "Çıkış yapıldı"}


def _get_current_user_id(credentials: HTTPAuthorizationCredentials = Depends(security)) -> int:
    token = credentials.credentials
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id = int(payload["sub"])
        return user_id
    except (JWTError, KeyError, ValueError):
        raise HTTPException(status_code=401, detail="Geçersiz veya süresi dolmuş token")


@router.get("/me")
async def get_me(
    user_id: int = Depends(_get_current_user_id),
    db: Session = Depends(get_db),
):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="Kullanıcı bulunamadı")
    return {"user": format_user(user)}
