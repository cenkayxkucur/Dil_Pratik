from typing import Optional
import google.generativeai as genai
import os
from dotenv import load_dotenv
import logging

# Load environment variables
import pathlib
backend_dir = pathlib.Path(__file__).parent.parent.parent
env_file = backend_dir / ".env"
load_dotenv(env_file)

logger = logging.getLogger(__name__)

class AIService:
    def __init__(self):
        """Initialize the AI service with Gemini API"""
        self.api_key = os.getenv("GEMINI_API_KEY")
        if not self.api_key:
            logger.warning("⚠️ GEMINI_API_KEY not found in environment variables")
            self.model = None
            return
            
        try:
            genai.configure(api_key=self.api_key)
            self.model = genai.GenerativeModel('gemini-1.5-flash')
            logger.info("✅ Google Gemini API initialized successfully")
        except Exception as e:
            logger.error(f"❌ Failed to initialize Gemini API: {e}")
            self.model = None

    def get_conversation_response(self, user_id: str, message: str, language: str, level: str, communication_language: Optional[str] = None) -> str:
        """Generate AI response for conversation with communication language support"""
        if not self.model:
            return "AI service is currently unavailable."

        try:
            system_prompt = self._create_system_prompt(language, level, communication_language)
            full_prompt = f"{system_prompt}\n\nUser message: {message}\n\nResponse:"
            
            response = self.model.generate_content(full_prompt)
            return response.text if response.text else "I'm sorry, I couldn't generate a response."
            
        except Exception as e:
            logger.error(f"Error generating conversation response: {e}")
            return "I apologize, but I'm having trouble responding right now."

    def analyze_grammar(self, text: str, language: str, level: str) -> dict:
        """Analyze grammar and provide corrections"""
        if not self.model:
            return {"error": "AI service is currently unavailable."}

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
                "analysis": response.text if response.text else "Analysis unavailable",
                "corrections": ["See analysis above"],
                "explanations": ["Detailed analysis provided above"]
            }
            
        except Exception as e:
            logger.error(f"Error analyzing grammar: {e}")
            return {"error": "Grammar analysis failed"}

    def generate_practice_content(self, topic: str, language: str, level: str) -> dict:
        """Generate practice content for a specific topic"""
        if not self.model:
            return {"error": "AI service is currently unavailable."}

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
                "content": response.text if response.text else "Content generation failed",
                "vocabulary": [],
                "exercises": [],
                "questions": []
            }
            
        except Exception as e:
            logger.error(f"Error generating practice content: {e}")
            return {"error": "Practice content generation failed"}

    def _create_system_prompt(self, language: str, level: str, communication_language: Optional[str] = None) -> str:
        """Create system prompt based on target language, level, and communication language"""
        
        # Base prompt based on target language and level
        language_instructions = {
            'turkish': {
                'A1': "Sen Türkçe öğrenen A1 seviyesindeki öğrencilerle konuşan yardımcı bir öğretmensin. Basit kelimeler kullan, kısa cümleler kur, ve hatalarını nazikçe düzelt. Yanıtların 2-3 cümleyi geçmesin.",
                'A2': "Sen Türkçe öğrenen A2 seviyesindeki öğrencilerle konuşan öğretmensin. Günlük konuları tartış, temel gramer yapılarını kullan ve hatalarını düzelt.",
                'B1': "Sen Türkçe öğrenen B1 seviyesindeki öğrencilerle konuşan öğretmensin. Daha karmaşık konuları tartış, gramer hatalarını düzelt ve açıkla.",
                'B2': "Sen Türkçe öğrenen B2 seviyesindeki öğrencilerle konuşan öğretmensin. Soyut konuları tartış, gelişmiş gramer yapılarını kullan.",
                'C1': "Sen Türkçe öğrenen C1 seviyesindeki öğrencilerle konuşan öğretmensin. Akademik ve profesyonel konuları tartış, detaylı açıklamalar yap.",
                'C2': "Sen Türkçe öğrenen C2 seviyesindeki öğrencilerle konuşan öğretmensin. Ana dili seviyesinde konuşmalar yap, edebiyat ve kültür hakkında tartış."
            },
            'english': {
                'A1': "You are a helpful English teacher talking with A1 level students. Use simple words, short sentences, and gently correct their mistakes. Keep responses to 2-3 sentences.",
                'A2': "You are an English teacher talking with A2 level students. Discuss everyday topics, use basic grammar structures and correct their errors.",
                'B1': "You are an English teacher talking with B1 level students. Discuss more complex topics, correct grammar errors and provide explanations.",
                'B2': "You are an English teacher talking with B2 level students. Discuss abstract topics and use nuanced grammar structures.",
                'C1': "You are an English teacher talking with C1 level students. Engage in academic and professional discussions with detailed explanations.",
                'C2': "You are an English teacher talking with C2 level students. Converse at native speaker level, discuss literature and culture."
            },
            'german': {
                'A1': "Du bist ein hilfsbereiter Deutschlehrer, der mit A1-Schülern spricht. Verwende einfache Wörter, kurze Sätze und korrigiere Fehler sanft. Halte Antworten auf 2-3 Sätze.",
                'A2': "Du bist ein Deutschlehrer, der mit A2-Schülern spricht. Diskutiere alltägliche Themen, verwende grundlegende Grammatikstrukturen und korrigiere Fehler.",
                'B1': "Du bist ein Deutschlehrer, der mit B1-Schülern spricht. Diskutiere komplexere Themen, korrigiere Grammatikfehler und gib Erklärungen.",
                'B2': "Du bist ein Deutschlehrer, der mit B2-Schülern spricht. Diskutiere abstrakte Themen und verwende nuancierte Grammatikstrukturen.",
                'C1': "Du bist ein Deutschlehrer, der mit C1-Schülern spricht. Führe akademische und berufliche Diskussionen mit detaillierten Erklärungen.",
                'C2': "Du bist ein Deutschlehrer, der mit C2-Schülern spricht. Unterhalte dich auf muttersprachlichem Niveau, diskutiere Literatur und Kultur."
            }
        }
        
        # Get base prompt
        base_prompt = language_instructions.get(language, {}).get(level, 
            f"You are a language teacher helping students learn {language} at {level} level.")
          # Add communication language instruction
        if communication_language and communication_language != language:
            communication_instruction = f"""
            
            IMPORTANT: The user will communicate with you in {communication_language}, but you should respond in {language} to help them learn {language}. 
            Understand their {communication_language} messages and respond appropriately in {language} at {level} level.
            """
        else:
            communication_instruction = f"""
            
            IMPORTANT: The user will communicate with you in {language}. This is an immersive {language} learning experience.
            """
        
        base_prompt += communication_instruction
        base_prompt += "\nÖNEMLİ: Her mesajda yazım hatası veya gramer hatası var mı kontrol et."
        
        return base_prompt

# Global instance
ai_service = AIService()