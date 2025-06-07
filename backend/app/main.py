from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .api.endpoints import router
from .api.ai_endpoints import router as ai_router
from .utils.database import Base, engine

# Create database tables
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Dil Pratik API",
    description="API for language learning application",
    version="1.0.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000", "http://localhost:8080"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(router, prefix="/api")
app.include_router(ai_router, prefix="/api/ai")
