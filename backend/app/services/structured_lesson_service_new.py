from sqlalchemy.orm import Session
from sqlalchemy import and_
from typing import List, Optional, Dict
from ..models.structured_models import LanguageLevel, GrammarTopic, Lesson
from ..schemas.structured_lesson import (
    LanguageLevelResponse, 
    GrammarTopicResponse, 
    LessonResponse,
    LanguageLevelWithTopics,
    GrammarTopicWithLessons,
    LanguageLessonsResponse
)


class StructuredLessonService:
    
    @staticmethod
    def get_available_languages(db: Session) -> List[str]:
        """Get list of available languages"""
        languages = db.query(LanguageLevel.language).distinct().all()
        return [lang[0] for lang in languages if lang[0]]
    
    @staticmethod
    def get_available_levels_for_language(db: Session, language: str) -> List[Dict[str, str]]:
        """Get available levels for a specific language with display names"""
        levels = db.query(LanguageLevel).filter(
            and_(
                LanguageLevel.language == language,
                LanguageLevel.is_active == True
            )
        ).order_by(LanguageLevel.order_index).all()
        
        return [
            {
                "level": level.level,
                "display_name": level.display_name,
                "description": level.description
            }
            for level in levels
        ]
    
    @staticmethod
    def get_language_level_with_topics(db: Session, language: str, level: str) -> Optional[LanguageLevelWithTopics]:
        """Get language level with its grammar topics"""
        language_level = db.query(LanguageLevel).filter(
            and_(
                LanguageLevel.language == language,
                LanguageLevel.level == level,
                LanguageLevel.is_active == True
            )
        ).first()
        
        if not language_level:
            return None
        
        grammar_topics = db.query(GrammarTopic).filter(
            and_(
                GrammarTopic.language_level_id == language_level.id,
                GrammarTopic.is_active == True
            )
        ).order_by(GrammarTopic.order_index).all()
        
        return LanguageLevelWithTopics(
            language_level=LanguageLevelResponse.from_orm(language_level),
            grammar_topics=[GrammarTopicResponse.from_orm(topic) for topic in grammar_topics]
        )
    
    @staticmethod
    def get_grammar_topic_with_lessons(db: Session, topic_id: int) -> Optional[GrammarTopicWithLessons]:
        """Get grammar topic with its lessons"""
        grammar_topic = db.query(GrammarTopic).filter(
            and_(
                GrammarTopic.id == topic_id,
                GrammarTopic.is_active == True
            )
        ).first()
        
        if not grammar_topic:
            return None
        
        lessons = db.query(Lesson).filter(
            and_(
                Lesson.grammar_topic_id == topic_id,
                Lesson.is_active == True
            )
        ).order_by(Lesson.order_index).all()
        
        return GrammarTopicWithLessons(
            grammar_topic=GrammarTopicResponse.from_orm(grammar_topic),
            lessons=[LessonResponse.from_orm(lesson) for lesson in lessons]
        )
    
    @staticmethod
    def get_complete_language_lessons(db: Session, language: str, level: str) -> Optional[LanguageLessonsResponse]:
        """Get complete lesson structure for a language level - used for lessons page"""
        language_level = db.query(LanguageLevel).filter(
            and_(
                LanguageLevel.language == language,
                LanguageLevel.level == level,
                LanguageLevel.is_active == True
            )
        ).first()
        
        if not language_level:
            return None
        
        # Get all grammar topics for this level
        grammar_topics = db.query(GrammarTopic).filter(
            and_(
                GrammarTopic.language_level_id == language_level.id,
                GrammarTopic.is_active == True
            )
        ).order_by(GrammarTopic.order_index).all()
        
        # Get lessons for each topic
        topics_with_lessons = []
        for topic in grammar_topics:
            lessons = db.query(Lesson).filter(
                and_(
                    Lesson.grammar_topic_id == topic.id,
                    Lesson.is_active == True
                )
            ).order_by(Lesson.order_index).all()
            
            topics_with_lessons.append(
                GrammarTopicWithLessons(
                    grammar_topic=GrammarTopicResponse.from_orm(topic),
                    lessons=[LessonResponse.from_orm(lesson) for lesson in lessons]
                )
            )
        
        return LanguageLessonsResponse(
            language=language_level.language,
            level=language_level.level,
            display_name=language_level.display_name,
            grammar_topics=topics_with_lessons
        )
    
    @staticmethod
    def get_lesson_by_id(db: Session, lesson_id: int) -> Optional[LessonResponse]:
        """Get a specific lesson by ID"""
        lesson = db.query(Lesson).filter(
            and_(
                Lesson.id == lesson_id,
                Lesson.is_active == True
            )
        ).first()
        
        if lesson:
            return LessonResponse.from_orm(lesson)
        return None
