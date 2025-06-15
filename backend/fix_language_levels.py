#!/usr/bin/env python3
"""
LanguageLevel kayıtlarını düzeltme scripti
"""
import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.database import SessionLocal
from app.models.structured_models import LanguageLevel, GrammarTopic, Lesson

def fix_language_levels():
    db = SessionLocal()
    try:
        print("🔧 LanguageLevel kayıtlarını düzeltiliyor...")
        
        # Turkish A1 için tüm kayıtları getir
        turkish_a1_levels = db.query(LanguageLevel).filter_by(language='turkish', level='A1').all()
        print(f"Bulunan Turkish A1 kayıtları: {len(turkish_a1_levels)}")
        
        if len(turkish_a1_levels) > 1:
            # İlk kaydı tut, diğerlerini sil
            main_level = turkish_a1_levels[0]
            main_level.display_name = "Türkçe A1 - Başlangıç"
            main_level.description = "Türkçe temel seviye - günlük yaşamda sık kullanılan kelime ve ifadeler"
            main_level.order_index = 1
            
            # Diğer level'ların grammar topic'lerini ana level'a taşı
            for i, level in enumerate(turkish_a1_levels[1:], 1):
                print(f"Level {level.id}'nin topic'lerini ana level'a taşıyor...")
                
                # Bu level'ın topic'lerini getir
                topics = db.query(GrammarTopic).filter_by(language_level_id=level.id).all()
                for topic in topics:
                    topic.language_level_id = main_level.id
                    print(f"  Topic '{topic.title}' taşındı")
                
                # Bu level'ı sil
                db.delete(level)
                print(f"Level {level.id} silindi")
            
            db.commit()
            print(f"✅ Ana level: {main_level.id} (display_name: {main_level.display_name})")
        else:
            print("✅ Zaten tek kayıt var")
        
        # Sonucu kontrol et
        final_levels = db.query(LanguageLevel).filter_by(language='turkish', level='A1').all()
        print(f"\n📊 Düzeltme sonrası Turkish A1 kayıtları: {len(final_levels)}")
        
        for level in final_levels:
            topics = db.query(GrammarTopic).filter_by(language_level_id=level.id).all()
            print(f"Level {level.id}: {len(topics)} topic")
            for topic in topics:
                lessons = db.query(Lesson).filter_by(grammar_topic_id=topic.id).all()
                print(f"  - {topic.title}: {len(lessons)} ders")
                
    except Exception as e:
        print(f"❌ Hata: {e}")
        db.rollback()
        raise
    finally:
        db.close()

if __name__ == "__main__":
    fix_language_levels()
