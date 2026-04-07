"""
AI Service — Google Gemini tabanlı dil öğrenme asistanı.

Her konuşma turunda iki şey yapılır:
1. Kullanıcıya ana yanıt üretilir.
2. Arka planda kullanıcının mesajı analiz edilerek öğrenme hafızası güncellenir
   (LearningInteraction, WordKnowledge, GrammarKnowledge, UserLearningProfile).
"""

from typing import Optional, List
import google.generativeai as genai
import os
import json
import logging
from datetime import datetime, timedelta
from sqlalchemy.orm import Session

import pathlib
backend_dir = pathlib.Path(__file__).parent.parent.parent
from dotenv import load_dotenv
load_dotenv(backend_dir / ".env")

logger = logging.getLogger(__name__)


class AIService:
    def __init__(self):
        self.api_key = os.getenv("GEMINI_API_KEY")

        if not self.api_key:
            logger.warning("⚠️ GEMINI_API_KEY not found")
            self.model = None
            return

        try:
            genai.configure(api_key=self.api_key)
            self.model = genai.GenerativeModel("gemini-2.0-flash")
            logger.info("✅ Google Gemini API initialized")
        except Exception as e:
            logger.error(f"❌ Failed to initialize Gemini API: {e}")
            self.model = None

    # ──────────────────────────────────────────────────────────────────────
    # Conversation history helpers
    # ──────────────────────────────────────────────────────────────────────

    def _load_history(self, db: Session, user_id: str, session_type: str,
                      lesson_id: Optional[int] = None, limit: int = 10) -> List[dict]:
        from ..models.models import ConversationMessage
        query = (
            db.query(ConversationMessage)
            .filter(
                ConversationMessage.user_id == user_id,
                ConversationMessage.session_type == session_type,
            )
        )
        if lesson_id is not None:
            query = query.filter(ConversationMessage.lesson_id == lesson_id)
        messages = query.order_by(ConversationMessage.id.desc()).limit(limit).all()
        return [{"role": m.role, "content": m.content} for m in reversed(messages)]

    def _save_messages(self, db: Session, user_id: str, session_type: str,
                       language: str, level: str,
                       user_message: str, ai_response: str,
                       lesson_id: Optional[int] = None):
        from ..models.models import ConversationMessage
        db.add(ConversationMessage(
            user_id=user_id, role="user", content=user_message,
            session_type=session_type, lesson_id=lesson_id,
            language=language, level=level,
        ))
        db.add(ConversationMessage(
            user_id=user_id, role="assistant", content=ai_response,
            session_type=session_type, lesson_id=lesson_id,
            language=language, level=level,
        ))
        db.commit()

    # ──────────────────────────────────────────────────────────────────────
    # Learning profile helpers
    # ──────────────────────────────────────────────────────────────────────

    def _get_learning_profile(self, db: Session, user_id: str, language: str) -> Optional[dict]:
        """Kullanıcının öğrenme profilini DB'den yükle."""
        from ..models.models import UserLearningProfile
        profile = (
            db.query(UserLearningProfile)
            .filter(
                UserLearningProfile.user_id == user_id,
                UserLearningProfile.language == language,
            )
            .first()
        )
        if not profile:
            return None
        return {
            "weak_grammar": json.loads(profile.weak_grammar or "[]"),
            "strong_grammar": json.loads(profile.strong_grammar or "[]"),
            "weak_vocabulary": json.loads(profile.weak_vocabulary or "[]"),
            "strong_vocabulary": json.loads(profile.strong_vocabulary or "[]"),
            "frequent_topics": json.loads(profile.frequent_topics or "[]"),
            "total_interactions": profile.total_interactions,
        }

    def _build_profile_context(self, profile: Optional[dict]) -> str:
        """Profil verilerini system prompt eki haline getir."""
        if not profile or profile["total_interactions"] < 3:
            return ""

        lines = ["\n\n--- KULLANICI ÖĞRENME PROFİLİ ---"]

        weak_g = profile.get("weak_grammar", [])
        if weak_g:
            items = ", ".join(
                f"{x['display']} (hata oranı: {x['error_rate']:.0%})"
                for x in weak_g[:3]
            )
            lines.append(f"⚠️ Zayıf gramer alanları: {items}")
            lines.append("→ Bu alanlara ek özen göster, gerekirse kısa hatırlatma yap.")

        weak_v = profile.get("weak_vocabulary", [])
        if weak_v:
            words = ", ".join(x["word"] for x in weak_v[:5])
            lines.append(f"⚠️ Sık yanlış yapılan kelimeler: {words}")

        strong_g = profile.get("strong_grammar", [])
        if strong_g:
            items = ", ".join(x["display"] for x in strong_g[:3])
            lines.append(f"✅ Güçlü olduğu alanlar: {items} — bunları öv.")

        topics = profile.get("frequent_topics", [])
        if topics:
            lines.append(f"📚 İlgilendiği konular: {', '.join(topics[:5])}")

        lines.append("--- PROFİL SONU ---")
        return "\n".join(lines)

    # ──────────────────────────────────────────────────────────────────────
    # Analytics — Etkileşim analizi ve hafıza güncelleme
    # ──────────────────────────────────────────────────────────────────────

    def analyze_and_store_interaction(
        self,
        db: Session,
        user_id: str,
        language: str,
        level: str,
        user_message: str,
        ai_response: str,
        session_type: str = "conversation",
    ):
        """
        Kullanıcı mesajını Gemini ile analiz et, etiketleri DB'ye kaydet,
        öğrenme profilini güncelle.
        Hata olursa sessizce yutulur — ana akışı etkilememeli.
        """
        if not self.model:
            return

        try:
            analysis = self._call_analysis_model(user_message, ai_response, language, level)
            self._store_interaction(db, user_id, language, level, session_type,
                                    user_message, ai_response, analysis)
            self._update_knowledge_tables(db, user_id, language, level, analysis)
            self._update_learning_profile(db, user_id, language)
        except Exception as e:
            logger.error(f"Analytics error (non-critical): {e}")

    def _call_analysis_model(self, user_message: str, ai_response: str,
                              language: str, level: str) -> dict:
        """
        Gemini'yi kullanarak kullanıcı mesajındaki hataları ve
        doğru yapıları tespit et. JSON döner.
        """
        prompt = f"""You are a language learning analytics system.
Analyze the following student message in {language} (level: {level}).

Student message: "{user_message}"
AI teacher response (for context): "{ai_response[:300]}"

Return ONLY a valid JSON object (no markdown, no explanation) with this exact structure:
{{
  "errors": [
    {{"type": "grammar|vocabulary|spelling", "code": "snake_case_rule_code", "display": "Human readable name", "phrase": "the wrong phrase"}}
  ],
  "correct": [
    {{"type": "grammar|vocabulary", "code": "snake_case_rule_code", "display": "Human readable name"}}
  ],
  "overall_score": 0.0,
  "topic_tags": ["tag1", "tag2"]
}}

Rules:
- "code" must be consistent snake_case (e.g. "present_tense", "genitive_case", "greeting_vocabulary")
- "overall_score" is 0.0 (completely wrong) to 1.0 (perfect)
- "topic_tags" are topic labels like ["greetings", "food", "travel", "numbers"]
- If the message is very short or unclear, return empty arrays and score 0.5
- Max 5 items in errors, 5 in correct
"""
        response = self.model.generate_content(prompt)
        text = response.text.strip()

        # JSON bloğunu temizle
        if "```" in text:
            text = text.split("```")[1]
            if text.startswith("json"):
                text = text[4:]

        parsed = json.loads(text)

        # Temel validasyon
        parsed.setdefault("errors", [])
        parsed.setdefault("correct", [])
        parsed.setdefault("overall_score", 0.5)
        parsed.setdefault("topic_tags", [])
        return parsed

    def _store_interaction(self, db: Session, user_id: str, language: str, level: str,
                           session_type: str, user_message: str, ai_response: str,
                           analysis: dict):
        from ..models.models import LearningInteraction
        db.add(LearningInteraction(
            user_id=user_id,
            language=language,
            level=level,
            session_type=session_type,
            user_message=user_message,
            ai_response=ai_response,
            errors=json.dumps(analysis.get("errors", []), ensure_ascii=False),
            correct=json.dumps(analysis.get("correct", []), ensure_ascii=False),
            overall_score=analysis.get("overall_score"),
            topic_tags=json.dumps(analysis.get("topic_tags", []), ensure_ascii=False),
        ))
        db.commit()

    def _update_knowledge_tables(self, db: Session, user_id: str, language: str,
                                  level: str, analysis: dict):
        from ..models.models import WordKnowledge, GrammarKnowledge

        def upsert_grammar(code: str, display: str, correct: bool):
            obj = (
                db.query(GrammarKnowledge)
                .filter_by(user_id=user_id, rule_code=code, language=language)
                .first()
            )
            if not obj:
                obj = GrammarKnowledge(
                    user_id=user_id, rule_code=code, rule_display=display,
                    language=language, level=level,
                )
                db.add(obj)
            if correct:
                obj.correct_count = (obj.correct_count or 0) + 1
            else:
                obj.incorrect_count = (obj.incorrect_count or 0) + 1
            obj.last_practiced = datetime.utcnow()

        def upsert_word(word: str, correct: bool):
            obj = (
                db.query(WordKnowledge)
                .filter_by(user_id=user_id, word=word.lower(), language=language)
                .first()
            )
            if not obj:
                obj = WordKnowledge(
                    user_id=user_id, word=word.lower(), language=language
                )
                db.add(obj)
            if correct:
                obj.correct_count = (obj.correct_count or 0) + 1
            else:
                obj.incorrect_count = (obj.incorrect_count or 0) + 1
                # Spaced repetition: hatalı kelimeyi 1 gün sonra tekrara koy
                obj.next_review_at = datetime.utcnow() + timedelta(days=1)
            obj.last_seen = datetime.utcnow()

        for err in analysis.get("errors", []):
            if err.get("type") == "grammar":
                upsert_grammar(err["code"], err["display"], correct=False)
            elif err.get("type") == "vocabulary" and err.get("phrase"):
                upsert_word(err["phrase"], correct=False)

        for cor in analysis.get("correct", []):
            if cor.get("type") == "grammar":
                upsert_grammar(cor["code"], cor["display"], correct=True)
            elif cor.get("type") == "vocabulary" and cor.get("phrase", None):
                # correct listesinde phrase olmayabilir, güvenli kontrol
                upsert_word(cor.get("phrase", cor.get("code", "")), correct=True)

        db.commit()

    def _update_learning_profile(self, db: Session, user_id: str, language: str):
        """
        GrammarKnowledge ve WordKnowledge tablolarını okuyarak
        UserLearningProfile'ı güncelle.
        """
        from ..models.models import (
            UserLearningProfile, GrammarKnowledge, WordKnowledge,
            LearningInteraction,
        )

        # Gramer özeti
        grammar_rows = (
            db.query(GrammarKnowledge)
            .filter_by(user_id=user_id, language=language)
            .all()
        )

        def error_rate(row) -> float:
            total = (row.correct_count or 0) + (row.incorrect_count or 0)
            return (row.incorrect_count or 0) / total if total > 0 else 0

        weak_grammar = [
            {"code": r.rule_code, "display": r.rule_display,
             "error_rate": round(error_rate(r), 2),
             "count": (r.correct_count or 0) + (r.incorrect_count or 0)}
            for r in grammar_rows
            if error_rate(r) >= 0.4 and ((r.correct_count or 0) + (r.incorrect_count or 0)) >= 2
        ]
        weak_grammar.sort(key=lambda x: x["error_rate"], reverse=True)

        strong_grammar = [
            {"code": r.rule_code, "display": r.rule_display,
             "error_rate": round(error_rate(r), 2),
             "count": (r.correct_count or 0) + (r.incorrect_count or 0)}
            for r in grammar_rows
            if error_rate(r) < 0.2 and (r.correct_count or 0) >= 3
        ]

        # Kelime özeti
        word_rows = (
            db.query(WordKnowledge)
            .filter_by(user_id=user_id, language=language)
            .all()
        )

        def word_error_rate(row) -> float:
            total = (row.correct_count or 0) + (row.incorrect_count or 0)
            return (row.incorrect_count or 0) / total if total > 0 else 0

        weak_vocab = [
            {"word": r.word, "language": language,
             "error_rate": round(word_error_rate(r), 2),
             "count": (r.correct_count or 0) + (r.incorrect_count or 0)}
            for r in word_rows
            if word_error_rate(r) >= 0.5 and ((r.correct_count or 0) + (r.incorrect_count or 0)) >= 2
        ]
        strong_vocab = [
            {"word": r.word, "language": language,
             "error_rate": round(word_error_rate(r), 2),
             "count": (r.correct_count or 0) + (r.incorrect_count or 0)}
            for r in word_rows
            if word_error_rate(r) < 0.1 and (r.correct_count or 0) >= 3
        ]

        # Konu etiketleri özeti
        recent = (
            db.query(LearningInteraction)
            .filter_by(user_id=user_id, language=language)
            .order_by(LearningInteraction.id.desc())
            .limit(50)
            .all()
        )
        topic_counter: dict = {}
        for row in recent:
            for tag in json.loads(row.topic_tags or "[]"):
                topic_counter[tag] = topic_counter.get(tag, 0) + 1
        frequent_topics = sorted(topic_counter, key=topic_counter.get, reverse=True)[:10]

        total = db.query(LearningInteraction).filter_by(
            user_id=user_id, language=language
        ).count()

        # Upsert
        profile = (
            db.query(UserLearningProfile)
            .filter_by(user_id=user_id, language=language)
            .first()
        )
        if not profile:
            profile = UserLearningProfile(user_id=user_id, language=language)
            db.add(profile)

        profile.weak_grammar = json.dumps(weak_grammar[:10], ensure_ascii=False)
        profile.strong_grammar = json.dumps(strong_grammar[:10], ensure_ascii=False)
        profile.weak_vocabulary = json.dumps(weak_vocab[:10], ensure_ascii=False)
        profile.strong_vocabulary = json.dumps(strong_vocab[:10], ensure_ascii=False)
        profile.frequent_topics = json.dumps(frequent_topics, ensure_ascii=False)
        profile.total_interactions = total
        profile.last_updated = datetime.utcnow()
        db.commit()

    # ──────────────────────────────────────────────────────────────────────
    # Public API
    # ──────────────────────────────────────────────────────────────────────

    def get_conversation_response(self, user_id: str, message: str, language: str,
                                  level: str, db: Session,
                                  communication_language: Optional[str] = None) -> str:
        if not self.model:
            raise RuntimeError("AI service is unavailable (API key missing).")

        history = self._load_history(db, user_id, "conversation")
        profile = self._get_learning_profile(db, user_id, language)
        system_prompt = (
            self._create_system_prompt(language, level, communication_language)
            + self._build_profile_context(profile)
        )

        context = f"{system_prompt}\n\nConversation History:\n"
        for msg in history:
            role = "User" if msg["role"] == "user" else "Assistant"
            context += f"{role}: {msg['content']}\n"
        context += f"\nUser: {message}\nAssistant:"

        response = self.model.generate_content(context)
        ai_response = response.text or "Yanıt üretilemedi."

        self._save_messages(db, user_id, "conversation", language, level, message, ai_response)

        # Arka planda analitik güncelle (hata olursa sessiz)
        self.analyze_and_store_interaction(
            db, user_id, language, level, message, ai_response, "conversation"
        )

        return ai_response

    def get_lesson_conversation_response(self, user_id: str, message: str,
                                         lesson_content: str, lesson_title: str,
                                         lesson_id: int, language: str, level: str,
                                         db: Session,
                                         communication_language: Optional[str] = None) -> str:
        if not self.model:
            raise RuntimeError("AI service is unavailable (API key missing).")

        history = self._load_history(db, user_id, "lesson", lesson_id=lesson_id)
        profile = self._get_learning_profile(db, user_id, language)
        lesson_system_prompt = (
            self._create_lesson_system_prompt(
                language, level, lesson_title, lesson_content, communication_language
            )
            + self._build_profile_context(profile)
        )

        context = f"{lesson_system_prompt}\n\nLesson Chat History:\n"
        for msg in history:
            role = "User" if msg["role"] == "user" else "AI"
            context += f"{role}: {msg['content']}\n"
        context += f"\nUser: {message}\nAI: "

        response = self.model.generate_content(context)
        ai_response = response.text or "Yanıt üretilemedi."

        self._save_messages(db, user_id, "lesson", language, level, message, ai_response,
                            lesson_id=lesson_id)

        self.analyze_and_store_interaction(
            db, user_id, language, level, message, ai_response, "lesson"
        )

        return ai_response

    def get_conversation_history(self, user_id: str, db: Session,
                                 session_type: str = "conversation",
                                 lesson_id: Optional[int] = None) -> list:
        return self._load_history(db, user_id, session_type, lesson_id=lesson_id, limit=50)

    def clear_conversation_history(self, user_id: str, db: Session,
                                   session_type: str = "conversation",
                                   lesson_id: Optional[int] = None) -> bool:
        try:
            from ..models.models import ConversationMessage
            query = db.query(ConversationMessage).filter(
                ConversationMessage.user_id == user_id,
                ConversationMessage.session_type == session_type,
            )
            if lesson_id is not None:
                query = query.filter(ConversationMessage.lesson_id == lesson_id)
            query.delete()
            db.commit()
            return True
        except Exception as e:
            logger.error(f"Error clearing conversation history: {e}")
            return False

    def analyze_grammar(self, text: str, language: str, level: str) -> dict:
        if not self.model:
            raise RuntimeError("AI service is unavailable.")
        try:
            prompt = f"""
            Analyze the following {language} text for grammar errors and provide corrections suitable for a {level} level learner:

            Text: "{text}"

            Provide a detailed analysis in JSON format including:
            - original_text
            - analysis (overall assessment)
            - corrections (list of corrected versions)
            - explanations (detailed explanations for each correction)
            """
            response = self.model.generate_content(prompt)
            return {
                "original_text": text,
                "analysis": response.text or "Analysis unavailable",
                "corrections": ["See analysis above"],
                "explanations": ["Detailed analysis provided above"],
            }
        except Exception as e:
            logger.error(f"Error analyzing grammar: {e}")
            raise

    def generate_practice_content(self, topic: str, language: str, level: str) -> dict:
        if not self.model:
            raise RuntimeError("AI service is unavailable.")
        try:
            prompt = f"""
            Create practice content for learning {language} at {level} level on the topic: {topic}

            Provide content in JSON format including:
            - content (lesson description)
            - vocabulary (5 key words with definitions)
            - exercises (3 fill-in-the-blank exercises)
            - questions (2 conversation starter questions)
            """
            response = self.model.generate_content(prompt)
            return {
                "topic": topic,
                "language": language,
                "level": level,
                "content": response.text or "Content generation failed",
                "vocabulary": [],
                "exercises": [],
                "questions": [],
            }
        except Exception as e:
            logger.error(f"Error generating practice content: {e}")
            raise

    # ──────────────────────────────────────────────────────────────────────
    # Prompt builders
    # ──────────────────────────────────────────────────────────────────────

    def _create_system_prompt(self, language: str, level: str,
                               communication_language: Optional[str] = None) -> str:
        language_names = {
            "turkish": "Turkish (Türkçe)",
            "english": "English",
            "german": "German (Deutsch)",
        }

        language_instructions = {
            "turkish": {
                "A1": "Sen Türkçe öğrenen A1 seviyesindeki öğrencilerle konuşan yardımcı bir öğretmensin. Basit kelimeler kullan, kısa cümleler kur, ve hatalarını nazikçe düzelt. Yanıtların 2-3 cümleyi geçmesin.",
                "A2": "Sen Türkçe öğrenen A2 seviyesindeki öğrencilerle konuşan öğretmensin. Günlük konuları tartış, temel gramer yapılarını kullan ve hatalarını düzelt.",
                "B1": "Sen Türkçe öğrenen B1 seviyesindeki öğrencilerle konuşan öğretmensin. Daha karmaşık konuları tartış, gramer hatalarını düzelt ve açıkla.",
                "B2": "Sen Türkçe öğrenen B2 seviyesindeki öğrencilerle konuşan öğretmensin. Soyut konuları tartış, gelişmiş gramer yapılarını kullan.",
                "C1": "Sen Türkçe öğrenen C1 seviyesindeki öğrencilerle konuşan öğretmensin. Akademik ve profesyonel konuları tartış, detaylı açıklamalar yap.",
                "C2": "Sen Türkçe öğrenen C2 seviyesindeki öğrencilerle konuşan öğretmensin. Ana dili seviyesinde konuşmalar yap, edebiyat ve kültür hakkında tartış.",
            },
            "english": {
                "A1": "You are a helpful English teacher talking with A1 level students. Use simple words, short sentences, and gently correct their mistakes. Keep responses to 2-3 sentences.",
                "A2": "You are an English teacher talking with A2 level students. Discuss everyday topics, use basic grammar structures and correct their errors.",
                "B1": "You are an English teacher talking with B1 level students. Discuss more complex topics, correct grammar errors and provide explanations.",
                "B2": "You are an English teacher talking with B2 level students. Discuss abstract topics and use nuanced grammar structures.",
                "C1": "You are an English teacher talking with C1 level students. Engage in academic and professional discussions with detailed explanations.",
                "C2": "You are an English teacher talking with C2 level students. Converse at native speaker level, discuss literature and culture.",
            },
            "german": {
                "A1": "Du bist ein hilfsbereiter Deutschlehrer, der mit A1-Schülern spricht. Verwende einfache Wörter, kurze Sätze und korrigiere Fehler sanft.",
                "A2": "Du bist ein Deutschlehrer, der mit A2-Schülern spricht. Diskutiere alltägliche Themen und korrigiere Fehler.",
                "B1": "Du bist ein Deutschlehrer, der mit B1-Schülern spricht. Diskutiere komplexere Themen und gib Erklärungen.",
                "B2": "Du bist ein Deutschlehrer, der mit B2-Schülern spricht. Diskutiere abstrakte Themen.",
                "C1": "Du bist ein Deutschlehrer, der mit C1-Schülern spricht. Führe akademische Diskussionen.",
                "C2": "Du bist ein Deutschlehrer, der mit C2-Schülern spricht. Unterhalte dich auf muttersprachlichem Niveau.",
            },
        }

        base_prompt = language_instructions.get(language, {}).get(
            level, f"You are a language teacher helping students learn {language} at {level} level."
        )

        comm_lang_name = language_names.get(communication_language, communication_language)
        target_lang_name = language_names.get(language, language)

        if communication_language and communication_language != language:
            base_prompt += f"""

COMMUNICATION LANGUAGE GUIDANCE:
1. The user will primarily communicate with you in {comm_lang_name}.
2. You should respond in {target_lang_name} to help them learn {target_lang_name}.
3. Engage naturally, ask follow-up questions, provide examples.
4. Correct grammar mistakes gently.
"""
        else:
            base_prompt += f"""

IMMERSIVE LANGUAGE LEARNING:
1. The user communicates in {target_lang_name} for immersive learning.
2. Provide natural responses and grammar corrections.
3. Engage in meaningful conversation, ask follow-up questions.
"""

        base_prompt += "\nÖNEMLİ: Her mesajda yazım hatası veya gramer hatası var mı kontrol et."
        return base_prompt

    def _create_lesson_system_prompt(self, language: str, level: str, lesson_title: str,
                                     lesson_content: str,
                                     communication_language: Optional[str] = None) -> str:
        lesson_summary = lesson_content[:500] + "..." if len(lesson_content) > 500 else lesson_content

        target_lang_name = {
            "turkish": "Turkish",
            "english": "English",
            "german": "German",
        }.get(language, language.title())

        base_prompt = f"""You are a specialized {target_lang_name} language teacher assistant focused on the current lesson.

📚 CURRENT LESSON CONTEXT:
- Lesson Title: {lesson_title}
- Language: {target_lang_name}
- Level: {level}
- Lesson Content Preview: {lesson_summary}

🎯 YOUR ROLE:
1. Answer questions specifically about this lesson content
2. Give practice exercises related to lesson material
3. Clarify grammar points mentioned in the lesson
4. Help with vocabulary from this specific lesson

⚠️ IMPORTANT: Stay focused on THIS specific lesson."""

        if communication_language and communication_language != language:
            comm_lang_name = {
                "turkish": "Turkish",
                "english": "English",
                "german": "German",
            }.get(communication_language, communication_language.title())
            base_prompt += f"\n\n🗣️ The user prefers explanations in {comm_lang_name}, but encourage {target_lang_name} practice."

        return base_prompt


# Global instance
ai_service = AIService()
