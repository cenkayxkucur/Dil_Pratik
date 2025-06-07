from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.endpoints import conversation, grammar
from app.api.auth_endpoints import router as auth_router
from app.api.ai_endpoints import router as ai_router
from app.database import engine
from app.utils.database import Base

# Veritabanı tablolarını oluştur
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Language Learning AI Assistant API",
    description="Backend API for the Language Learning AI Assistant platform",
    version="1.0.0"
)

# CORS ayarları
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Geliştirme ortamında tüm originlere izin ver
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Router'ları ekle
app.include_router(auth_router)
app.include_router(conversation.router, prefix="/api/conversation", tags=["conversation"])
app.include_router(grammar.router, prefix="/api/grammar", tags=["grammar"])
app.include_router(ai_router, prefix="/api/ai", tags=["ai"])

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