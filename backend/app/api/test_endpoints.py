from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from ..database import get_db
from ..models.models import Lesson

router = APIRouter(prefix="/test", tags=["test"])

@router.get("/simple")
async def simple_test():
    """Simple test without database dependency"""
    return {"message": "Simple test works"}

@router.get("/db-test")
async def db_test(db: Session = Depends(get_db)):
    """Test with database dependency"""
    try:
        # Simple query
        count = db.query(Lesson).count()
        return {"message": "Database test works", "lesson_count": count}
    except Exception as e:
        return {"error": str(e)}
