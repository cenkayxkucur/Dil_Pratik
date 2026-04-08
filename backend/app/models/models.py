from sqlalchemy import (
    Boolean, Column, ForeignKey, Integer, String,
    DateTime, Text, Float, UniqueConstraint
)
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from ..utils.database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    username = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    lessons = relationship("Lesson", back_populates="user")
    progress = relationship("Progress", back_populates="user")


class Lesson(Base):
    __tablename__ = "lessons"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=True)
    # Structured lesson system FK
    grammar_topic_id = Column(Integer, ForeignKey("grammar_topics.id"), nullable=True)
    title = Column(String, nullable=False)
    description = Column(Text)
    content = Column(Text, nullable=False)
    lesson_type = Column(String, default="reading")  # reading, grammar, vocabulary, dialogue
    language = Column(String, nullable=False)
    level = Column(String, nullable=False)
    order_index = Column(Integer, default=0)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    user = relationship("User", back_populates="lessons")
    progress = relationship("Progress", back_populates="lesson")
    grammar_topic = relationship("GrammarTopic", back_populates="lessons")


class Progress(Base):
    __tablename__ = "progress"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    lesson_id = Column(Integer, ForeignKey("lessons.id"))
    score = Column(Float)
    completed = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    user = relationship("User", back_populates="progress")
    lesson = relationship("Lesson", back_populates="progress")


class PracticeSession(Base):
    __tablename__ = "practice_sessions"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    language = Column(String)
    level = Column(String)
    session_type = Column(String)
    content = Column(Text)
    score = Column(Float, nullable=True)
    completed = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    user = relationship("User")


class GrammarTopic(Base):
    """
    Bir LanguageLevel'a ait gramer/konu başlığı.
    Örn. english/A1 altında: "Greetings", "Present Simple", "Numbers"
    """
    __tablename__ = "grammar_topics"

    id = Column(Integer, primary_key=True, index=True)
    language_level_id = Column(Integer, ForeignKey("language_levels.id"), nullable=False, index=True)
    title = Column(String, nullable=False)          # "Greetings & Introductions"
    description = Column(Text)
    language = Column(String, nullable=False)       # Denormalized — hızlı sorgu için
    level = Column(String, nullable=False)          # Denormalized
    order_index = Column(Integer, default=0)
    is_active = Column(Boolean, default=True)
    examples = Column(Text)                         # JSON örnekler
    rules = Column(Text)                            # Gramer kuralı açıklaması
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    language_level = relationship("LanguageLevel", back_populates="grammar_topics")
    lessons = relationship("Lesson", back_populates="grammar_topic")


class ConversationMessage(Base):
    __tablename__ = "conversation_messages"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String, index=True)
    role = Column(String, nullable=False)        # "user" | "assistant"
    content = Column(Text, nullable=False)
    session_type = Column(String, default="conversation")  # "conversation" | "lesson"
    lesson_id = Column(Integer, nullable=True)
    language = Column(String, nullable=False)
    level = Column(String, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())


class LanguageLevel(Base):
    """
    Dil × Seviye kombinasyonu (örn. english × A1).
    Structured lesson sisteminin kök tablosudur.
    """
    __tablename__ = "language_levels"

    id = Column(Integer, primary_key=True, index=True)
    language = Column(String, nullable=False, index=True)   # english / german / turkish
    level = Column(String, nullable=False, index=True)      # A1 / A2 / B1 / B2 / C1 / C2
    display_name = Column(String, nullable=False)           # "Beginner", "Anfänger", "Başlangıç"
    description = Column(Text)
    order_index = Column(Integer, default=0)
    is_active = Column(Boolean, default=True)
    min_vocabulary = Column(Integer, default=0)
    max_vocabulary = Column(Integer, default=1000)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    grammar_topics = relationship("GrammarTopic", back_populates="language_level")

    __table_args__ = (
        UniqueConstraint("language", "level", name="uq_language_level"),
    )


# ──────────────────────────────────────────────────────────────────────────────
# ANALYTICS — Kişiselleştirilmiş öğrenme hafızası
# ──────────────────────────────────────────────────────────────────────────────

class LearningInteraction(Base):
    """
    Her konuşma turunda kullanıcının mesajı AI tarafından analiz edilir.
    Hangi kelime/gramer/konu kullanıldı, doğru muydu, yanlış mıydı?
    Bu tablo AI'ın "öğrenme hafızasının" ham kaydıdır.
    """
    __tablename__ = "learning_interactions"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String, index=True)
    language = Column(String, nullable=False)
    level = Column(String, nullable=False)
    session_type = Column(String, default="conversation")  # "conversation" | "lesson"

    user_message = Column(Text, nullable=False)
    ai_response = Column(Text, nullable=False)

    # AI analizi: JSON string — [{type, code, display, phrase}]
    # type: "grammar" | "vocabulary" | "spelling" | "pronunciation"
    errors = Column(Text, default="[]")

    # Doğru yapılanlar: [{type, code, display}]
    correct = Column(Text, default="[]")

    # Genel performans skoru 0-1
    overall_score = Column(Float, nullable=True)

    # Konu etiketleri: ["greetings", "food", "present_tense", ...]
    topic_tags = Column(Text, default="[]")

    created_at = Column(DateTime(timezone=True), server_default=func.now())


class WordKnowledge(Base):
    """
    Kullanıcının kelime bazında öğrenme durumu.
    Bir kelime yanlış kullanıldığında incorrect_count artar,
    doğru kullanıldığında correct_count artar.
    next_review_at spaced repetition için kullanılır.
    """
    __tablename__ = "word_knowledge"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String, index=True)
    word = Column(String, nullable=False, index=True)
    language = Column(String, nullable=False)
    correct_count = Column(Integer, default=0)
    incorrect_count = Column(Integer, default=0)
    last_seen = Column(DateTime(timezone=True), server_default=func.now())
    next_review_at = Column(DateTime(timezone=True), nullable=True)

    __table_args__ = (
        UniqueConstraint("user_id", "word", "language", name="uq_word_user_lang"),
    )


class GrammarKnowledge(Base):
    """
    Kullanıcının gramer kural bazında performansı.
    rule_code: "present_tense", "genitive_case", "verb_conjugation" gibi
    standart kodlar — AI bu kodları tutarlı olarak üretmeli.
    """
    __tablename__ = "grammar_knowledge"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String, index=True)
    rule_code = Column(String, nullable=False, index=True)
    rule_display = Column(String, nullable=False)  # İnsan okunabilir ad
    language = Column(String, nullable=False)
    level = Column(String, nullable=False)
    correct_count = Column(Integer, default=0)
    incorrect_count = Column(Integer, default=0)
    last_practiced = Column(DateTime(timezone=True), server_default=func.now())

    __table_args__ = (
        UniqueConstraint("user_id", "rule_code", "language", name="uq_grammar_user_lang"),
    )


class UserLearningProfile(Base):
    """
    Kullanıcının aggregated öğrenme profili.
    AI her yanıt üretmeden önce bu tabloyu okur ve
    zayıf alanlara göre system prompt'u zenginleştirir.

    Bu tablo her LearningInteraction'dan sonra güncellenir.
    """
    __tablename__ = "user_learning_profiles"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String, index=True)
    language = Column(String, nullable=False)

    # JSON: [{"code": "present_tense", "display": "Geniş zaman", "error_rate": 0.8, "count": 5}]
    weak_grammar = Column(Text, default="[]")
    strong_grammar = Column(Text, default="[]")

    # JSON: [{"word": "apple", "language": "english", "error_rate": 0.6, "count": 3}]
    weak_vocabulary = Column(Text, default="[]")
    strong_vocabulary = Column(Text, default="[]")

    # JSON: ["greetings", "food", "travel"] — en çok çalışılan konular
    frequent_topics = Column(Text, default="[]")

    total_interactions = Column(Integer, default=0)
    last_updated = Column(DateTime(timezone=True), server_default=func.now())

    __table_args__ = (
        UniqueConstraint("user_id", "language", name="uq_profile_user_lang"),
    )


class UserStreak(Base):
    """
    Kullanıcının günlük çalışma serisi ve günlük hedef takibi.
    current_streak: Bugün dahil ardışık aktif gün sayısı
    longest_streak: Tüm zamanların en uzun serisi
    last_activity_date: Son aktivite tarihi (YYYY-MM-DD)
    total_days_active: Toplam aktif gün sayısı
    daily_goal_target: Günlük hedef etkileşim sayısı
    """
    __tablename__ = "user_streaks"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String, index=True)
    language = Column(String, nullable=False)
    current_streak = Column(Integer, default=0)
    longest_streak = Column(Integer, default=0)
    last_activity_date = Column(String, nullable=True)  # "YYYY-MM-DD"
    total_days_active = Column(Integer, default=0)
    daily_goal_target = Column(Integer, default=5)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    __table_args__ = (
        UniqueConstraint("user_id", "language", name="uq_streak_user_lang"),
    )


class SavedWord(Base):
    """
    Kullanıcının kaydettiği kelimeler (Kelime Defteri).
    Pratik veya ders sırasında manuel olarak kaydedilir.
    """
    __tablename__ = "saved_words"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String, index=True)
    language = Column(String, nullable=False)
    word = Column(String, nullable=False)
    translation = Column(String, nullable=True)   # Kullanıcının eklediği çeviri/not
    context = Column(Text, nullable=True)          # Kaydedildiği cümle/bağlam
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    __table_args__ = (
        UniqueConstraint("user_id", "word", "language", name="uq_saved_word_user_lang"),
    )
