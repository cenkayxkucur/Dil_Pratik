import openai
from openai import OpenAI
from dotenv import load_dotenv
import os
from typing import Dict, List, Optional
import json

load_dotenv()

class AIService:
    def __init__(self):
        self.conversation_history: Dict[str, List[Dict]] = {}
        self.api_key = os.getenv("OPENAI_API_KEY")
        
        # Initialize OpenAI client if API key is available
        if self.api_key and self.api_key != "placeholder-openai-key-gerekli-degil-simdilik":
            self.client = OpenAI(api_key=self.api_key)
            self.use_real_ai = True
            print("✅ OpenAI API initialized successfully")
        else:
            self.client = None
            self.use_real_ai = False
            print("⚠️  Using placeholder AI responses (no OpenAI API key)")

    def process_speech(self, audio_file) -> Dict:
        """Process audio file using Whisper API or placeholder"""
        if self.use_real_ai:
            try:
                # Real Whisper API implementation
                transcript = self.client.audio.transcriptions.create(
                    model="whisper-1",
                    file=audio_file
                )
                return {
                    "text": transcript.text,
                    "confidence": 0.95,  # Whisper doesn't provide confidence
                    "language": "auto-detected"
                }
            except Exception as e:
                print(f"Whisper API error: {e}")
                return self._placeholder_speech()
        else:
            return self._placeholder_speech()
    
    def _placeholder_speech(self) -> Dict:
        """Placeholder speech processing"""
        return {
            "text": "Bu bir placeholder metin. Whisper API aktif olunca gerçek çeviri burada olacak.",
            "confidence": 0.95,
            "language": "tr"
        }    def get_conversation_response(
        self,
        user_id: str,
        message: str,
        language: str,
        level: str
    ) -> str:
        """Get AI conversation response using OpenAI or placeholder"""
        if user_id not in self.conversation_history:
            self.conversation_history[user_id] = []
        
        if self.use_real_ai:
            try:
                # Create system prompt based on language and level
                system_prompt = self._create_system_prompt(language, level)
                
                # Prepare conversation history for OpenAI
                messages = [{"role": "system", "content": system_prompt}]
                messages.extend(self.conversation_history[user_id][-10:])  # Last 10 messages
                messages.append({"role": "user", "content": message})
                
                # Get response from OpenAI
                response = self.client.chat.completions.create(
                    model="gpt-3.5-turbo",
                    messages=messages,
                    max_tokens=200,
                    temperature=0.7
                )
                
                ai_response = response.choices[0].message.content
                
                # Add to conversation history
                self.conversation_history[user_id].append({"role": "user", "content": message})
                self.conversation_history[user_id].append({"role": "assistant", "content": ai_response})
                
                return ai_response
                
            except Exception as e:
                print(f"OpenAI API error: {e}")
                return self._placeholder_conversation_response(message, language, level)
        else:
            return self._placeholder_conversation_response(message, language, level)
    
    def _create_system_prompt(self, language: str, level: str) -> str:
        """Create system prompt for different languages and levels"""
        prompts = {
            "turkish": {
                "A1": "Sen Türkçe öğrenen A1 seviyesindeki öğrencilerle konuşan yardımcı bir öğretmensin. Basit kelimeler kullan, kısa cümleler kur, ve hatalarını nazikçe düzelt.",
                "A2": "Sen Türkçe öğrenen A2 seviyesindeki öğrencilerle konuşan öğretmensin. Günlük konular hakkında konuş, temel gramer yapılarını kullan.",
                "B1": "Sen Türkçe öğrenen B1 seviyesindeki öğrencilerle konuşan öğretmensin. Daha karmaşık konular hakkında konuşabilirsin.",
                "B2": "Sen Türkçe öğrenen B2 seviyesindeki öğrencilerle konuşan öğretmensin. İleri seviye konular ve karmaşık gramer yapıları kullanabilirsin.",
                "C1": "Sen Türkçe öğrenen C1 seviyesindeki öğrencilerle konuşan öğretmensin. Akademik ve profesyonel konular hakkında detaylı konuşmalar yapabilirsin.",
                "C2": "Sen Türkçe öğrenen C2 seviyesindeki öğrencilerle konuşan öğretmensin. Ana dili seviyesinde konuşmalar yap."
            },
            "english": {
                "A1": "You are a helpful English teacher talking with A1 level students. Use simple words, short sentences, and gently correct mistakes.",
                "A2": "You are an English teacher talking with A2 level students. Discuss everyday topics using basic grammar structures.",
                "B1": "You are an English teacher talking with B1 level students. You can discuss more complex topics.",
                "B2": "You are an English teacher talking with B2 level students. Use advanced topics and complex grammar structures.",
                "C1": "You are an English teacher talking with C1 level students. Have detailed discussions about academic and professional topics.",
                "C2": "You are an English teacher talking with C2 level students. Converse at native speaker level."
            },
            "german": {
                "A1": "Du bist ein hilfreicher Deutschlehrer, der mit A1-Schülern spricht. Verwende einfache Wörter, kurze Sätze und korrigiere Fehler sanft.",
                "A2": "Du bist ein Deutschlehrer, der mit A2-Schülern spricht. Diskutiere alltägliche Themen mit grundlegenden Grammatikstrukturen.",
                "B1": "Du bist ein Deutschlehrer, der mit B1-Schülern spricht. Du kannst komplexere Themen diskutieren.",
                "B2": "Du bist ein Deutschlehrer, der mit B2-Schülern spricht. Verwende fortgeschrittene Themen und komplexe Grammatikstrukturen.",
                "C1": "Du bist ein Deutschlehrer, der mit C1-Schülern spricht. Führe detaillierte Diskussionen über akademische und berufliche Themen.",
                "C2": "Du bist ein Deutschlehrer, der mit C2-Schülern spricht. Unterhalte dich auf muttersprachlichem Niveau."
            }
        }
        
        return prompts.get(language, {}).get(level, "You are a helpful language teacher.")
    
    def _placeholder_conversation_response(self, message: str, language: str, level: str) -> str:
        """Placeholder conversation response"""
        response = f"Merhaba! '{message}' mesajınızı aldım. {language} dilinde {level} seviyesinde pratik yapıyoruz. Bu şu anda placeholder bir yanıt."
        
        # Add to conversation history
        self.conversation_history[user_id].append({"role": "user", "content": message})
        self.conversation_history[user_id].append({"role": "assistant", "content": response})
        
        return response

    def analyze_grammar(self, text: str, language: str) -> Dict:
        """Placeholder gramer analizi"""
        return {
            "original_text": text,
            "analysis": f"'{text}' metni için gramer analizi. Bu placeholder bir yanıt - gerçek OpenAI analizi burada olacak.",
            "corrections": ["Placeholder düzeltme 1", "Placeholder düzeltme 2"],
            "explanations": ["Placeholder açıklama 1", "Placeholder açıklama 2"]
        }

    def generate_practice_content(self, topic: str, language: str, level: str) -> Dict:
        """Placeholder pratik içeriği"""
        return {
            "topic": topic,
            "language": language,
            "level": level,
            "content": f"{topic} konusunda {language} dilinde {level} seviyesi placeholder içerik.",
            "exercises": [
                {"type": "multiple_choice", "question": "Placeholder soru 1", "options": ["A", "B", "C", "D"]},
                {"type": "fill_blank", "sentence": "Bu bir _____ cümledir.", "answer": "placeholder"},
                {"type": "translate", "text": "Placeholder çeviri metni"}
            ]
        }

# Global instance
ai_service = AIService()
