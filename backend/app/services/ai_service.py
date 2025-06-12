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
        # Conversation history storage for each user
        self.conversation_history = {}
        
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
            # Initialize conversation history for new users
            if user_id not in self.conversation_history:
                self.conversation_history[user_id] = []
            
            # Get system prompt
            system_prompt = self._create_system_prompt(language, level, communication_language)
            
            # Build conversation context with history
            conversation_context = f"{system_prompt}\n\nConversation History:\n"
            
            # Add recent conversation history (last 10 messages to avoid token limits)
            recent_history = self.conversation_history[user_id][-10:]
            for msg in recent_history:
                conversation_context += f"{msg['role']}: {msg['content']}\n"
            
            # Add current user message
            conversation_context += f"\nUser: {message}\nAssistant:"
            
            response = self.model.generate_content(conversation_context)
            ai_response = response.text if response.text else "I'm sorry, I couldn't generate a response."
            
            # Save conversation to history
            self.conversation_history[user_id].append({"role": "User", "content": message})
            self.conversation_history[user_id].append({"role": "Assistant", "content": ai_response})
            
            # Keep history manageable (max 50 messages)
            if len(self.conversation_history[user_id]) > 50:
                self.conversation_history[user_id] = self.conversation_history[user_id][-50:]
            
            return ai_response
            
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
            - questions (2 conversation starter questions)            """
            
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

    def clear_conversation_history(self, user_id: str) -> bool:
        """Clear conversation history for a specific user"""
        try:
            if user_id in self.conversation_history:
                del self.conversation_history[user_id]
                logger.info(f"Cleared conversation history for user: {user_id}")
                return True
            return False
        except Exception as e:
            logger.error(f"Error clearing conversation history: {e}")
            return False
    
    def get_conversation_history(self, user_id: str) -> list:
        """Get conversation history for a specific user"""
        return self.conversation_history.get(user_id, [])
    
    def get_conversation_summary(self, user_id: str) -> dict:
        """Get conversation summary for a specific user"""
        history = self.conversation_history.get(user_id, [])
        return {
            "user_id": user_id,
            "total_messages": len(history),
            "user_messages": len([msg for msg in history if msg['role'] == 'User']),
            "assistant_messages": len([msg for msg in history if msg['role'] == 'Assistant']),
            "last_interaction": history[-1]['content'] if history else None
        }

    def _create_system_prompt(self, language: str, level: str, communication_language: Optional[str] = None) -> str:
        """Create system prompt based on target language, level, and communication language"""
        
        # Language name mapping for clear instructions
        language_names = {
            'turkish': 'Turkish (Türkçe)',
            'english': 'English',
            'german': 'German (Deutsch)'
        }
        
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
            f"You are a language teacher helping students learn {language} at {level} level.")        # Add communication language instruction
        comm_lang_name = language_names.get(communication_language, communication_language)
        target_lang_name = language_names.get(language, language)
        
        if communication_language and communication_language != language:            communication_instruction = f"""

COMMUNICATION LANGUAGE GUIDANCE:
1. The user will primarily communicate with you in {comm_lang_name}.
2. You should respond in {target_lang_name} to help them learn {target_lang_name}.
3. If the user writes in {comm_lang_name}, engage naturally and respond in {target_lang_name} at {level} level.
4. If the user accidentally writes in {target_lang_name} or another language, gently remind them: "I notice you're writing in a different language. For our cross-language learning, please communicate in {comm_lang_name} and I'll respond in {target_lang_name}."
5. Focus on grammar corrections and language learning, not strict language policing.
6. **IMPORTANT**: Do NOT just translate their message. You are a language teacher, not a translator. Engage in meaningful conversation, ask follow-up questions, provide examples, and create learning opportunities. Only provide translations when explicitly asked.
            """
        else:            communication_instruction = f"""

IMMERSIVE LANGUAGE LEARNING:
1. The user will communicate with you in {target_lang_name} for immersive learning.
2. If the user writes in {target_lang_name}, provide natural responses and grammar corrections.
3. If the user writes in another language, gently guide them: "For immersive {target_lang_name} learning, please try to communicate in {target_lang_name}."
4. Focus on helping them improve their {target_lang_name} skills through natural conversation.
5. **IMPORTANT**: Do NOT just translate their message. You are a language teacher, not a translator. Engage in meaningful conversation, ask follow-up questions, provide examples, and create learning opportunities. Only provide translations when explicitly asked.
            """
        
        base_prompt += communication_instruction
        base_prompt += "\nÖNEMLİ: Her mesajda yazım hatası veya gramer hatası var mı kontrol et."
        
        return base_prompt

# Global instance
ai_service = AIService()