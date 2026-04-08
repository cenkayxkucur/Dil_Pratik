import os
import sentry_sdk
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.endpoints import router as main_router
from app.api.conversation_endpoints import router as conversation_router
from app.api.grammar_endpoints import router as grammar_router
from app.api.auth_endpoints import router as auth_router
from app.api.ai_endpoints import router as ai_router
from app.api.lesson_endpoints import router as lesson_router
from app.api.structured_lesson_endpoints import router as structured_lesson_router
from app.api.vocabulary_endpoints import router as vocabulary_router
from app.database import engine
from app.utils.database import Base

# Tüm model sınıflarını import et — Base.metadata'ya kaydedilmeleri için gerekli
import app.models.models  # noqa: F401

# Sentry — DSN yoksa devre dışı
_sentry_dsn = os.getenv("SENTRY_DSN", "")
if _sentry_dsn:
    sentry_sdk.init(
        dsn=_sentry_dsn,
        traces_sample_rate=0.1,
        environment=os.getenv("ENVIRONMENT", "production"),
    )

# Veritabanı tablolarını oluştur
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Dil Pratik API",
    description="AI destekli dil öğrenme platformu backend API",
    version="1.0.0",
    docs_url="/docs" if os.getenv("ENVIRONMENT", "production") != "production" else None,
    redoc_url=None,
)

# CORS — production'da sadece izin verilen origin'ler
_raw_origins = os.getenv("ALLOWED_ORIGINS", "*")
if _raw_origins == "*":
    _allowed_origins = ["*"]
else:
    _allowed_origins = [o.strip() for o in _raw_origins.split(",") if o.strip()]

app.add_middleware(
    CORSMiddleware,
    allow_origins=_allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Router'ları ekle
app.include_router(auth_router)
app.include_router(structured_lesson_router, prefix="/api/v2", tags=["structured-lessons"])
app.include_router(lesson_router, prefix="/api/lessons", tags=["lessons"])
app.include_router(conversation_router, prefix="/api/conversation", tags=["conversation"])
app.include_router(grammar_router, prefix="/api/grammar", tags=["grammar"])
app.include_router(ai_router, prefix="/api/ai", tags=["ai"])
app.include_router(main_router, prefix="/api/main", tags=["main"])
app.include_router(vocabulary_router, prefix="/api/vocabulary", tags=["vocabulary"])

@app.get("/")
async def root():
    return {"message": "Language Learning AI Assistant API'ye Hoş Geldiniz!"}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

# Server başlatma
if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
