# Seed Data for Dil Pratik Database

from sqlalchemy.orm import Session
from app.database import SessionLocal, engine
from app.models import Base, User, GrammarTopic, LanguageLevel
from datetime import datetime
import json

def create_seed_data():
    """Create initial seed data for the database"""
    print("Creating seed data...")
    
    # Create database session
    db = SessionLocal()
    
    try:
        # Create sample users
        users_data = [
            {
                "email": "test@example.com",
                "hashed_password": "$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW",  # password: secret
                "full_name": "Test User",
                "target_language": "turkish",
                "current_level": LanguageLevel.A1
            },
            {
                "email": "advanced@example.com", 
                "hashed_password": "$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW",
                "full_name": "Advanced User",
                "target_language": "english",
                "current_level": LanguageLevel.B2
            }
        ]
        
        for user_data in users_data:
            # Check if user already exists
            existing_user = db.query(User).filter(User.email == user_data["email"]).first()
            if not existing_user:
                user = User(**user_data)
                db.add(user)
                print(f"✅ Created user: {user_data['email']}")
        
        # Create sample grammar topics
        grammar_topics = [
            # Turkish Grammar Topics
            {
                "title": "Present Tense (-iyor)",
                "content": "Şimdiki zaman kipi nasıl kullanılır? Örnekler ve kurallar.",
                "level": LanguageLevel.A1,
                "language": "turkish",
                "examples": json.dumps([
                    {"turkish": "Ben çalışıyorum", "english": "I am working"},
                    {"turkish": "O okuyor", "english": "He/She is reading"},
                    {"turkish": "Biz yürüyoruz", "english": "We are walking"}
                ]),
                "exercises": json.dumps([
                    {
                        "question": "Complete: Ben ev ______ (temizlemek)",
                        "answer": "temizliyorum",
                        "options": ["temizliyorum", "temizledim", "temizleyeceğim"]
                    }
                ])
            },
            {
                "title": "Past Tense (-di)",
                "content": "Geçmiş zaman kipi nasıl kullanılır?",
                "level": LanguageLevel.A2,
                "language": "turkish",
                "examples": json.dumps([
                    {"turkish": "Ben gittim", "english": "I went"},
                    {"turkish": "O geldi", "english": "He/She came"},
                    {"turkish": "Biz yedik", "english": "We ate"}
                ]),
                "exercises": json.dumps([
                    {
                        "question": "Complete: Dün sinemaya ______ (gitmek)",
                        "answer": "gittim",
                        "options": ["gittim", "gidiyorum", "gideceğim"]
                    }
                ])
            },
            
            # English Grammar Topics
            {
                "title": "Present Simple vs Present Continuous",
                "content": "Understanding the difference between present simple and present continuous tenses.",
                "level": LanguageLevel.A1,
                "language": "english",
                "examples": json.dumps([
                    {"english": "I work every day", "rule": "Present Simple - routine"},
                    {"english": "I am working now", "rule": "Present Continuous - happening now"},
                    {"english": "She speaks English", "rule": "Present Simple - general fact"}
                ]),
                "exercises": json.dumps([
                    {
                        "question": "Choose the correct form: I _____ to school every day.",
                        "answer": "go",
                        "options": ["go", "am going", "goes"]
                    }
                ])
            },
            
            # German Grammar Topics
            {
                "title": "Der, Die, Das (Articles)",
                "content": "German definite articles and their usage.",
                "level": LanguageLevel.A1,
                "language": "german",
                "examples": json.dumps([
                    {"german": "der Mann", "english": "the man", "rule": "masculine"},
                    {"german": "die Frau", "english": "the woman", "rule": "feminine"},
                    {"german": "das Kind", "english": "the child", "rule": "neuter"}
                ]),
                "exercises": json.dumps([
                    {
                        "question": "Choose the correct article: ___ Haus",
                        "answer": "das",
                        "options": ["der", "die", "das"]
                    }
                ])
            }
        ]
        
        for topic_data in grammar_topics:
            # Check if topic already exists
            existing_topic = db.query(GrammarTopic).filter(
                GrammarTopic.title == topic_data["title"],
                GrammarTopic.language == topic_data["language"]
            ).first()
            
            if not existing_topic:
                topic = GrammarTopic(**topic_data)
                db.add(topic)
                print(f"✅ Created grammar topic: {topic_data['title']} ({topic_data['language']})")
        
        # Commit all changes
        db.commit()
        print("✅ Seed data created successfully!")
        
    except Exception as e:
        print(f"❌ Error creating seed data: {e}")
        db.rollback()
        raise
    finally:
        db.close()

if __name__ == "__main__":
    create_seed_data()
