#!/usr/bin/env python3
"""
Single lesson content loader - Her seferinde tek ders yükler
"""
import sys
import os

# Add the parent directory to the path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.database import SessionLocal
from app.models.structured_models import LanguageLevel, GrammarTopic, Lesson
from datetime import datetime

def load_single_lesson_content():
    """Tek ders içeriğini yükle"""
      # YENİ DERS VERİSİ - Zaman Kavramı ve Saatler
    lesson_data = {
        "language": "turkish",
        "level": "A1",
        "display_name": "Türkçe A1 - Başlangıç",
        "level_description": "Türkçe temel seviye - zaman kavramı ve saat sorma",
        "grammar_topics": [
            {
                "title": "Zaman Kavramı ve Saatler",
                "description": "Türkçede zamanı ve saatleri nasıl söyleyeceğinizi öğrenirsiniz.",
                "order_index": 6,
                "lessons": [
                    {
                        "title": "Zaman Kavramı ve Saatler",
                        "description": "Zaman ifadeleri ve saat sorma kalıplarını öğrenelim.",
                        "content": "# Zaman Kavramı ve Saatler\n\n## Temel Zaman Kelimeleri (Time Words - Zeitwörter)\n- **Bugün:** Today - Heute\n- **Yarın:** Tomorrow - Morgen\n- **Dün:** Yesterday - Gestern\n- **Şimdi:** Now - Jetzt\n- **Sabah:** Morning - Morgen\n- **Öğle:** Noon - Mittag\n- **Akşam:** Evening - Abend\n- **Gece:** Night - Nacht\n\n## Saat Sorma (Asking the Time - Uhrzeit fragen)\n- **Saat kaç?** (What time is it? - Wie spät ist es?)\n- **Saat beş.** (It is five o'clock - Es ist fünf Uhr.)\n- **Saat iki buçuk.** (It is two thirty - Es ist halb drei.)\n\n## Saat Söyleme Örnekleri\n- **Saat bir.** (It is one o'clock - Es ist ein Uhr.)\n- **Saat üç buçuk.** (It is three thirty - Es ist halb vier.)\n- **Saat on iki.** (It is twelve o'clock - Es ist zwölf Uhr.)\n\n## Örnek Diyaloglar\n**A:** Saat kaç? (What time is it? - Wie spät ist es?)\n\n**B:** Saat dört. (It is four o'clock - Es ist vier Uhr.)\n\n**A:** Bugün hangi gün? (What day is today? - Welcher Tag ist heute?)\n\n**B:** Bugün Pazartesi. (Today is Monday - Heute ist Montag.)\n\n**A:** Yarın saat kaçta buluşuyoruz? (What time do we meet tomorrow? - Um wie viel Uhr treffen wir uns morgen?)\n\n**B:** Saat iki buçukta. (At two thirty - Um halb drei.)\n\n## Alıştırmalar\n1. \"Heute\" Türkçede hangisidir? \n- a) Yarın \n- b) Bugün \n- c) Dün \n- Cevap: b) Bugün\n\n2. \"Saat iki buçuk\" İngilizcede nasıl söylenir? \n- a) Two thirty \n- b) Five o'clock \n- c) Three thirty \n- Cevap: a) Two thirty\n\n3. \"Gestern\" ne demektir? \n- a) Bugün \n- b) Yarın \n- c) Dün \n- Cevap: c) Dün\n\n4. \"Saat beş\" cümlesi Almanca nasıl söylenir? \n- a) Es ist drei Uhr. \n- b) Es ist fünf Uhr. \n- c) Es ist zwei Uhr. \n- Cevap: b) Es ist fünf Uhr.\n\n5. \"Öğle\" hangi zaman dilimidir? \n- a) Morning \n- b) Noon \n- c) Night \n- Cevap: b) Noon\n",
                        "lesson_type": "grammar",
                        "order_index": 1
                    }
                ]
            }
        ]
    }

    db = SessionLocal()
    try:
        print("Loading new lesson content...")
        
        # 1. Mevcut Turkish A1 Language Level'ı kullan (ID: 11)
        language_level = db.query(LanguageLevel).filter_by(id=11).first()
        
        if not language_level:
            print("❌ Turkish A1 Language Level (ID: 11) bulunamadı!")
            return
            
        print(f"✓ Using existing Language Level: {language_level.display_name} (ID: {language_level.id})")
          
        # 2. Grammar Topics ve Lessons ekle
        for topic_data in lesson_data["grammar_topics"]:
            # Aynı başlıkta topic var mı kontrol et
            existing_topic = db.query(GrammarTopic).filter_by(
                language_level_id=language_level.id,
                title=topic_data["title"]
            ).first()
            
            if existing_topic:
                print(f"⚠ Topic already exists: {topic_data['title']}, skipping...")
                continue
            
            # Yeni topic oluştur
            grammar_topic = GrammarTopic(
                language_level_id=language_level.id,
                title=topic_data["title"],
                description=topic_data["description"],
                order_index=topic_data["order_index"],
                is_active=True,
                created_at=datetime.utcnow()
            )
            db.add(grammar_topic)
            db.commit()
            db.refresh(grammar_topic)
            print(f"✓ Created topic: {topic_data['title']}")
            
            # Lessons ekle
            for lesson_data_item in topic_data["lessons"]:
                # Aynı başlıkta lesson var mı kontrol et
                existing_lesson = db.query(Lesson).filter_by(
                    grammar_topic_id=grammar_topic.id,
                    title=lesson_data_item["title"]
                ).first()
                
                if existing_lesson:
                    print(f"⚠ Lesson already exists: {lesson_data_item['title']}, skipping...")
                    continue
                
                lesson = Lesson(
                    grammar_topic_id=grammar_topic.id,
                    title=lesson_data_item["title"],
                    description=lesson_data_item["description"],
                    content=lesson_data_item["content"],
                    lesson_type=lesson_data_item["lesson_type"],
                    order_index=lesson_data_item["order_index"],
                    is_active=True,
                    created_at=datetime.utcnow(),
                    updated_at=datetime.utcnow()
                )
                db.add(lesson)
                print(f"✓ Created lesson: {lesson_data_item['title']}")
        
        db.commit()
        print("\n🎉 New lesson content loaded successfully!")
        
        # Stats
        total_topics = db.query(GrammarTopic).filter_by(language_level_id=language_level.id).count()
        total_lessons = db.query(Lesson).join(GrammarTopic).filter_by(language_level_id=language_level.id).count()
        print(f"📊 Current stats for {lesson_data['language']} {lesson_data['level']}:")
        print(f"   - Topics: {total_topics}")
        print(f"   - Lessons: {total_lessons}")
        
    except Exception as e:
        print(f"❌ Error loading content: {e}")
        db.rollback()
        raise
    finally:
        db.close()

if __name__ == "__main__":
    load_single_lesson_content()
