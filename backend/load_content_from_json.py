#!/usr/bin/env python3
"""
JSON formatından veritabanına içerik yükleme script'i
"""
import sys
import os
import json

# Add the parent directory to the path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.database import SessionLocal
from app.models.structured_models import LanguageLevel, GrammarTopic, Lesson
from datetime import datetime

def load_content_from_json(json_data):
    """JSON formatından veritabanına içerik yükle"""
    print("Loading content from JSON...")
    
    db = SessionLocal()
    try:
        # 1. LanguageLevel oluştur
        language_level = LanguageLevel(
            language=json_data["language"],
            level=json_data["level"],
            display_name=json_data.get("display_name", f"{json_data['language'].title()} {json_data['level']} - Başlangıç"),
            description=json_data.get("level_description", f"{json_data['language'].title()} {json_data['level']} seviye"),
            order_index=_get_level_order_index(json_data["level"]),
            is_active=True,
            created_at=datetime.utcnow()
        )
        
        db.add(language_level)
        db.commit()
        db.refresh(language_level)
        print(f"✓ Created language level: {language_level.display_name}")
        
        # 2. GrammarTopics oluştur
        for topic_data in json_data["grammar_topics"]:
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
            print(f"  ✓ Created topic: {grammar_topic.title}")
            
            # 3. Lessons oluştur
            for lesson_data in topic_data["lessons"]:
                lesson = Lesson(
                    grammar_topic_id=grammar_topic.id,
                    title=lesson_data["title"],
                    description=lesson_data.get("description", ""),
                    content=lesson_data["content"],
                    lesson_type=lesson_data.get("lesson_type", "grammar"),
                    order_index=lesson_data["order_index"],
                    is_active=True,
                    created_at=datetime.utcnow(),
                    updated_at=datetime.utcnow()
                )
                
                db.add(lesson)
                db.commit()
                db.refresh(lesson)
                print(f"    ✓ Created lesson: {lesson.title}")
        
        print(f"\n🎉 Successfully loaded content for {language_level.display_name}!")
        print(f"✓ Created {len(json_data['grammar_topics'])} topics")
        
        total_lessons = sum(len(topic['lessons']) for topic in json_data['grammar_topics'])
        print(f"✓ Created {total_lessons} lessons")
        
    except Exception as e:
        print(f"❌ Error during loading: {e}")
        db.rollback()
        raise
    finally:
        db.close()

def _get_level_order_index(level):
    """Seviye order index'ini döndür"""
    level_order = {
        "A1": 1, "A2": 2, "B1": 3, 
        "B2": 4, "C1": 5, "C2": 6
    }
    return level_order.get(level, 0)

# Test JSON data
test_json = {
    "language": "turkish",
    "level": "A1",
    "display_name": "Türkçe A1 - Başlangıç",
    "level_description": "Türkçe temel seviye - günlük yaşamda sık kullanılan kelime ve ifadeler",
    "grammar_topics": [
        {
            "title": "Alfabe ve Telaffuz",
            "description": "Türk alfabesini öğrenir ve temel telaffuz kurallarını kavrarsınız.",
            "order_index": 1,
            "lessons": [
                {
                    "title": "Türk Alfabesi ve Temel Telaffuz",
                    "description": "Türk alfabesini ve temel sesleri öğrenelim.",
                    "content": "# Türk Alfabesi ve Temel Telaffuz\n\n## Türk Alfabesi (The Turkish Alphabet - Das Türkische Alphabet)\n- **Türk alfabesi 29 harften oluşur.** (The Turkish alphabet has 29 letters - Das Türkische Alphabet hat 29 Buchstaben.)\n- **Q, W, X harfleri Türkçede yoktur.** (Q, W, X are not used in Turkish - Q, W, X werden im Türkischen nicht benutzt.)\n\n### Türk Alfabesi:\nA, B, C, Ç, D, E, F, G, Ğ, H, I, İ, J, K, L, M, N, O, Ö, P, R, S, Ş, T, U, Ü, V, Y, Z\n\n## Temel Telaffuz Kuralları (Basic Pronunciation Rules - Grundlegende Ausspracheregeln)\n- **Ç = ch (İngilizce: chair / Almanca: tschüss)**\n- **Ş = sh (İngilizce: shoe / Almanca: schön)**\n- **Ğ = Yumuşak g (Ses vermez, uzatma yapar. İngilizce: silent letter / Almanca: stumm)**\n- **I = kalın ı (İngilizce ve Almancada tam karşılığı yoktur.)**\n- **C = j (İngilizce: jungle / Almanca: Dschungel)**\n\n## Örnekler (Examples - Beispiele)\n1. Çay (Tea - Tee)\n2. Şehir (City - Stadt)\n3. Dağ (Mountain - Berg)\n4. Sıcak (Hot - Heiß)\n5. Cam (Glass - Glas)\n\n## Örnek Diyaloglar\n**A:** Merhaba! Adın ne? (Hello! What's your name? - Hallo! Wie heißt du?)\n\n**B:** Merhaba! Ben Ali. (Hello! I'm Ali. - Hallo! Ich bin Ali.)\n\n**A:** Hoş geldin Ali! (Welcome Ali! - Willkommen Ali!)\n\n## Alıştırmalar\n1. Ç harfi hangi İngilizce sesi verir? \n- a) sh \n- b) ch \n- c) j \n- Cevap: b) ch\n\n2. Şehir kelimesinde hangi harf özel telaffuz ister? \n- a) Ş \n- b) Ç \n- c) Ğ \n- Cevap: a) Ş\n\n3. Türk alfabesinde kaç harf vardır? \n- a) 26 \n- b) 29 \n- c) 30 \n- Cevap: b) 29\n\n4. Q harfi Türk alfabesinde var mı? \n- a) Evet \n- b) Hayır \n- Cevap: b) Hayır\n\n5. \"Dağ\" kelimesinde hangi harf sessiz okunur? \n- a) Ç \n- b) Ğ \n- c) Ş \n- Cevap: b) Ğ\n",
                    "lesson_type": "grammar",
                    "order_index": 1
                }
            ]
        }
    ]
}

# Yeni ders: Selamlaşma ve Tanışma
selamlasma_json = {
    "language": "turkish",
    "level": "A1",
    "display_name": "Türkçe A1 - Başlangıç",
    "level_description": "Türkçe temel seviye - günlük konuşmalarda kullanılan temel ifadeler ve selamlaşma",
    "grammar_topics": [
        {
            "title": "Selamlaşma ve Tanışma",
            "description": "Türkçede temel selamlaşma ve tanışma ifadelerini öğrenirsiniz.",
            "order_index": 2,
            "lessons": [
                {
                    "title": "Selamlaşma ve Tanışma İfadeleri",
                    "description": "Günlük hayatta kullanılan selamlaşma ve tanışma cümlelerini öğrenelim.",
                    "content": "# Selamlaşma ve Tanışma İfadeleri\n\n## Temel Selamlaşma Cümleleri (Basic Greetings - Grundbegrüßungen)\n- **Merhaba:** Hello - Hallo\n- **Günaydın:** Good morning - Guten Morgen\n- **İyi günler:** Good day - Guten Tag\n- **İyi akşamlar:** Good evening - Guten Abend\n- **Hoşça kal:** Goodbye (said to staying person) - Tschüss\n- **Güle güle:** Goodbye (said to leaving person) - Auf Wiedersehen\n\n## Tanışma Cümleleri (Introducing Yourself - Sich vorstellen)\n- **Benim adım Ali.** (My name is Ali - Mein Name ist Ali)\n- **Adın ne?** (What is your name? - Wie heißt du?)\n- **Nasılsın?** (How are you? - Wie geht's?)\n- **İyiyim, teşekkür ederim.** (I'm fine, thank you - Mir geht's gut, danke.)\n\n## Örnek Diyaloglar\n**A:** Merhaba! Adın ne? (Hello! What's your name? - Hallo! Wie heißt du?)\n\n**B:** Benim adım Elif. (My name is Elif - Mein Name ist Elif.)\n\n**A:** Nasılsın? (How are you? - Wie geht's?)\n\n**B:** İyiyim, teşekkür ederim. Sen nasılsın? (I'm fine, thank you. How are you? - Mir geht's gut, danke. Wie geht's dir?)\n\n**A:** Ben de iyiyim. (I'm fine too - Mir geht's auch gut.)\n\n## Alıştırmalar\n1. \"Good morning\" Türkçede hangisidir? \n- a) Merhaba \n- b) Günaydın \n- c) İyi akşamlar \n- Cevap: b) Günaydın\n\n2. Türkçede \"Goodbye\" demek için hangi ifadeyi kullanırsın? \n- a) Hoşça kal \n- b) Günaydın \n- c) Merhaba \n- Cevap: a) Hoşça kal\n\n3. \"Benim adım Ali.\" cümlesi ne anlama gelir? \n- a) How are you? \n- b) My name is Ali \n- c) Goodbye \n- Cevap: b) My name is Ali\n\n4. \"Nasılsın?\" sorusunun cevabı hangisi olabilir? \n- a) Benim adım Elif \n- b) Hoşça kal \n- c) İyiyim, teşekkür ederim \n- Cevap: c) İyiyim, teşekkür ederim\n\n5. \"Güle güle\" hangi durumda söylenir? \n- a) Gelen kişiye \n- b) Giden kişiye \n- Cevap: b) Giden kişiye\n",
                    "lesson_type": "conversation",
                    "order_index": 1
                }
            ]
        }
    ]
}

# Yeni ders: Kişisel Bilgiler ve Sayılar
kisisel_bilgiler_json = {
    "language": "turkish",
    "level": "A1",
    "display_name": "Türkçe A1 - Başlangıç",
    "level_description": "Türkçe temel seviye - kişisel bilgiler ve temel sayılar",
    "grammar_topics": [
        {
            "title": "Kişisel Bilgiler ve Sayılar",
            "description": "Kişisel bilgileri ve temel sayıları öğrenirsiniz.",
            "order_index": 3,
            "lessons": [
                {
                    "title": "Kişisel Bilgiler ve Sayılar",
                    "description": "Kendi bilgilerini tanıtmak ve temel sayıları öğrenmek.",
                    "content": "# Kişisel Bilgiler ve Sayılar\n\n## Kişisel Bilgiler (Personal Information - Persönliche Informationen)\n- **Benim adım...** (My name is... - Mein Name ist...)\n- **Soyadım...** (My surname is... - Mein Nachname ist...)\n- **Ben ... yaşındayım.** (I am ... years old - Ich bin ... Jahre alt)\n- **Ben öğrenciyim.** (I am a student - Ich bin Student)\n- **Telefon numaram ...** (My phone number is ... - Meine Telefonnummer ist ...)\n\n## Sayılar (Numbers - Zahlen)\n- **0:** sıfır (zero - null)\n- **1:** bir (one - eins)\n- **2:** iki (two - zwei)\n- **3:** üç (three - drei)\n- **4:** dört (four - vier)\n- **5:** beş (five - fünf)\n- **6:** altı (six - sechs)\n- **7:** yedi (seven - sieben)\n- **8:** sekiz (eight - acht)\n- **9:** dokuz (nine - neun)\n- **10:** on (ten - zehn)\n\n## Örnek Diyaloglar\n**A:** Merhaba! Adın ne? (Hello! What's your name? - Hallo! Wie heißt du?)\n\n**B:** Benim adım Mehmet. Soyadım Yılmaz. (My name is Mehmet. My surname is Yılmaz - Mein Name ist Mehmet. Mein Nachname ist Yılmaz.)\n\n**A:** Kaç yaşındasın? (How old are you? - Wie alt bist du?)\n\n**B:** Ben yirmi yaşındayım. (I am twenty years old - Ich bin zwanzig Jahre alt.)\n\n**A:** Telefon numaran ne? (What is your phone number? - Wie ist deine Telefonnummer?)\n\n**B:** Telefon numaram 555 123 45 67. (My phone number is 555 123 45 67 - Meine Telefonnummer ist 555 123 45 67.)\n\n## Alıştırmalar\n1. \"Ben öğrenciyim\" cümlesinin İngilizce anlamı nedir? \n- a) I am a student \n- b) I am a teacher \n- c) I am a doctor \n- Cevap: a) I am a student\n\n2. \"Dört\" hangi sayıdır? \n- a) 3 \n- b) 4 \n- c) 5 \n- Cevap: b) 4\n\n3. \"Telefon numaram ...\" cümlesi hangi bilgi için kullanılır? \n- a) Yaş \n- b) Telefon \n- c) İsim \n- Cevap: b) Telefon\n\n4. \"Soyadım...\" cümlesinin Almanca karşılığı nedir? \n- a) Mein Name ist... \n- b) Mein Nachname ist... \n- c) Ich bin... \n- Cevap: b) Mein Nachname ist...\n\n5. \"Ben ... yaşındayım\" cümlesinde boşluğa ne yazılır? \n- a) Telefon numarası \n- b) Yaş \n- c) İsim \n- Cevap: b) Yaş\n",
                    "lesson_type": "conversation",
                    "order_index": 1
                }
            ]
        }
    ]
}

if __name__ == "__main__":
    # Test için örnek JSON'u yükle
    load_content_from_json(test_json)
    
    # Yeni dersleri yükle
    print("\n" + "="*50)
    print("Loading new lesson: Selamlaşma ve Tanışma")
    print("="*50)
    load_content_from_json(selamlasma_json)
    
    print("\n" + "="*50)
    print("Loading new lesson: Kişisel Bilgiler ve Sayılar")
    print("="*50)
    load_content_from_json(kisisel_bilgiler_json)
