# Database Migration Script for Dil Pratik

from sqlalchemy import create_engine
from app.utils.database import Base
from app.utils.database import SQLALCHEMY_DATABASE_URL
import os
from dotenv import load_dotenv

# Import models to register them with Base
from app.models.models import User, Lesson, Progress

load_dotenv()

def create_tables():
    """Create all database tables"""
    print("Creating database tables...")
    
    # Create engine
    engine = create_engine(SQLALCHEMY_DATABASE_URL)
    
    # Create all tables
    Base.metadata.create_all(bind=engine)
    
    print("✅ All tables created successfully!")
    print("Tables created:")
    for table_name in Base.metadata.tables.keys():
        print(f"  - {table_name}")

def drop_tables():
    """Drop all database tables (for reset)"""
    print("⚠️  Dropping all database tables...")
    
    engine = create_engine(SQLALCHEMY_DATABASE_URL)
    Base.metadata.drop_all(bind=engine)
    
    print("✅ All tables dropped!")

if __name__ == "__main__":
    import sys
    
    if len(sys.argv) > 1 and sys.argv[1] == "drop":
        drop_tables()
    else:
        create_tables()
