#!/usr/bin/env python3
"""
Ders içeriklerini temizleme script'i
"""
import sys
import os

# Add the parent directory to the path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.database import SessionLocal
from app.models.structured_models import LanguageLevel, GrammarTopic, Lesson

def clear_lesson_content():
    """Tüm ders içeriklerini temizle"""
    print("Clearing all lesson content...")
    
    db = SessionLocal()
    try:
        # Önce lessons'ları sil (foreign key constraint)
        lessons_deleted = db.query(Lesson).delete()
        print(f"✓ Deleted {lessons_deleted} lessons")
        
        # Sonra grammar_topics'leri sil
        topics_deleted = db.query(GrammarTopic).delete()
        print(f"✓ Deleted {topics_deleted} grammar topics")
        
        # Son olarak language_levels'ları sil
        levels_deleted = db.query(LanguageLevel).delete()
        print(f"✓ Deleted {levels_deleted} language levels")
        
        db.commit()
        print("\n🎉 All lesson content cleared successfully!")
        
    except Exception as e:
        print(f"❌ Error during clearing: {e}")
        db.rollback()
        raise
    finally:
        db.close()

if __name__ == "__main__":
    clear_lesson_content()
