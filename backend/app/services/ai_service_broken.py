import google.generativeai as genai
from dotenv import load_dotenv
import os
from typing import Dict, List, Optional
import json

load_dotenv()

class AIService:
    def __init__(self):
        self.conversation_history: Dict[str, List[Dict]] = {}
        self.api_key = os.getenv("GEMINI_API_KEY")
          # Re-enable Gemini API for real responses
        if self.api_key and self.api_key != "get-your-free-gemini-api-key-from-ai.google.dev":
            genai.configure(api_key=self.api_key)
            self.model = genai.GenerativeModel('gemini-1.5-flash')
            self.use_real_ai = True
            print("✅ Google Gemini API initialized successfully")
        else:
            self.model = None            self.use_real_ai = False
            print("⚠️  Using placeholder AI responses for endpoint testing")
    
    def get_conversation_response(self, user_id: str, message: str, language: str, level: str, communication_language: Optional[str] = None) -> str:
        """Get AI conversation response using Gemini or placeholder"""
        if user_id not in self.conversation_history:
            self.conversation_history[user_id] = []
        
        if self.use_real_ai:
            try:
                # Create system prompt based on language, level, and communication language
                system_prompt = self._create_system_prompt(language, level, communication_language)
                
                # Prepare conversation context for Gemini
                conversation_context = ""
                if self.conversation_history[user_id]:
                    conversation_context = "\n".join([
                        f"User: {msg['content']}" if msg['role'] == 'user' else f"Assistant: {msg['content']}"
                        for msg in self.conversation_history[user_id][-6:]  # Last 6 messages
                    ])
                
                # Create full prompt
                full_prompt = f"""{system_prompt}

Previous conversation:
{conversation_context}

Current user message: {message}

Please respond naturally and appropriately:"""
                  # Get response from Gemini
                response = self.model.generate_content(full_prompt)
                ai_response = response.text
                
                # Add to conversation history
                self.conversation_history[user_id].append({"role": "user", "content": message})
                self.conversation_history[user_id].append({"role": "assistant", "content": ai_response})
                
                return ai_response
                
            except Exception as e:
                print(f"Gemini API error: {e}")
                return self._placeholder_conversation_response(user_id, message, language, level)
        else:
            return self._placeholder_conversation_response(user_id, message, language, level)
    
    def analyze_grammar(self, text: str, language: str) -> Dict:
        """Analyze grammar using Gemini or placeholder"""
        if self.use_real_ai:
            try:
                prompt = f"""You are a grammar expert for {language} language. 
                Analyze the following text and provide detailed corrections and explanations.

                Text: "{text}"

                Please provide your response in JSON format with these keys:
                - original_text: the original text
                - analysis: overall analysis
                - corrections: array of suggested corrections
                - explanations: array of explanations for each correction

                Respond in {language} if the target language is Turkish or German, otherwise in English."""
                
                response = self.model.generate_content(prompt)
                
                # Try to parse JSON response, fallback to structured text
                try:
                    result = json.loads(response.text)
                    return result
                except:
                    return {
                        "original_text": text,
                        "analysis": response.text,
                        "corrections": ["See analysis above"],
                        "explanations": ["Detailed analysis provided above"]
                    }
                    
            except Exception as e:
                print(f"Gemini grammar analysis error: {e}")
                
        return {
            "original_text": text,
            "analysis": f"'{text}' metni için gramer analizi (placeholder).",
            "corrections": ["Placeholder düzeltme"],
            "explanations": ["Placeholder açıklama"]
        }

    def generate_practice_content(self, topic: str, language: str, level: str) -> Dict:
        """Generate practice content using Gemini or placeholder"""
        if self.use_real_ai:
            try:
                prompt = f"""Create practice content for {language} language learners at {level} level.
                Topic: {topic}

                Please generate:
                1. A short introduction to the topic (2-3 sentences)
                2. 3-5 vocabulary words related to the topic with definitions
                3. 3 practice sentences to complete
                4. 2 conversation questions about the topic

                Respond in JSON format with keys: content, vocabulary, exercises, questions
                Make the content appropriate for {level} level learners."""
                
                response = self.model.generate_content(prompt)
                  # Try to parse JSON response
                try:
                    result = json.loads(response.text)
                    result["topic"] = topic
                    result["language"] = language
                    result["level"] = level
                    return result
                except:
                    return {
                        "topic": topic,
                        "language": language,
                        "level": level,
                        "content": response.text,
                        "vocabulary": [],
                        "exercises": [],
                        "questions": []
                    }                    
            except Exception as e:
                print(f"Gemini content generation error: {e}")
        
        return {
            "topic": topic,
            "language": language,
            "level": level,
            "content": f"{topic} konusunda {language} dilinde {level} seviyesi içerik (placeholder).",
            "vocabulary": ["kelime1", "kelime2", "kelime3"],
            "exercises": ["Alıştırma 1", "Alıştırma 2", "Alıştırma 3"],
            "questions": ["Soru 1?", "Soru 2?"]
        }    def _create_system_prompt(self, language: str, level: str, communication_language: Optional[str] = None) -> str:
        """Create system prompt for different languages and levels"""
        
        # Base prompts for target languages
        prompts = {
            "turkish": {
                "A1": "Sen Türkçe öğrenen A1 seviyesindeki öğrencilerle konuşan yardımcı bir öğretmensin. Basit kelimeler kullan, kısa cümleler kur, ve hatalarını nazikçe düzelt. Yanıtların 2-3 cümleyi geçmesin. ÖNEMLİ: Her mesajda yazım hatası veya gramer hatası var mı kontrol et. Hata varsa hangi konuya çalışması gerektiğini söyle ve bir sonraki yanıtında o hatayı test edecek doğal bir soru sor.",
                "A2": "Sen Türkçe öğrenen A2 seviyesindeki öğrencilerle konuşan öğretmensin. Günlük konular hakkında konuş, temel gramer yapılarını kullan. Yanıtların anlaşılır ve eğitici olsun. ÖNEMLİ: Her mesajda yazım hatası veya gramer hatası var mı kontrol et. Hata varsa hangi konuya çalışması gerektiğini söyle ve bir sonraki yanıtında o hatayı test edecek doğal bir soru sor.",
                "B1": "Sen Türkçe öğrenen B1 seviyesindeki öğrencilerle konuşan deneyimli bir öğretmensin. Daha karmaşık konuları tartış, gramer hatalarını düzelt ve açıkla. ÖNEMLİ: Her mesajda yazım hatası veya gramer hatası var mı kontrol et. Hata varsa hangi konuya çalışması gerektiğini söyle ve bir sonraki yanıtında o hatayı test edecek doğal bir soru sor.",
                "B2": "Sen Türkçe öğrenen B2 seviyesindeki öğrencilerle konuşan uzman bir öğretmensin. Soyut konuları tartış, nüanslı gramer yapılarını kullan. ÖNEMLİ: Her mesajda yazım hatası veya gramer hatası var mı kontrol et. Hata varsa hangi konuya çalışması gerektiğini söyle ve bir sonraki yanıtında o hatayı test edecek doğal bir soru sor.",
                "C1": "Sen Türkçe öğrenen C1 seviyesindeki öğrencilerle konuşan uzman bir öğretmensin. Akademik ve profesyonel konular hakkında detaylı tartışmalar yap, karmaşık gramer yapılarını kullan ve ince nüansları açıkla. ÖNEMLİ: Her mesajda yazım hatası veya gramer hatası var mı kontrol et. Hata varsa hangi konuya çalışması gerektiğini söyle ve bir sonraki yanıtında o hatayı test edecek doğal bir soru sor.",
                "C2": "Sen Türkçe öğrenen C2 seviyesindeki öğrencilerle konuşan uzman bir öğretmensin. Ana dili seviyesinde konuşmalar yap, edebiyat ve kültürel konuları derinlemesine tartış. En ince gramer ve üslup hatalarını bile yakala. ÖNEMLİ: Her mesajda yazım hatası veya gramer hatası var mı kontrol et. Hata varsa hangi konuya çalışması gerektiğini söyle ve bir sonraki yanıtında o hatayı test edecek doğal bir soru sor."
            },
            "english": {
                "A1": "You are a helpful English teacher talking with A1 level students. Use simple words, short sentences, and gently correct mistakes. Keep responses to 2-3 sentences. IMPORTANT: Check every message for spelling or grammar errors. If there are errors, explain which topic they should study and ask a natural follow-up question that tests that specific error in your next response.",
                "A2": "You are an English teacher talking with A2 level students. Discuss everyday topics using basic grammar structures. Make responses clear and educational. IMPORTANT: Check every message for spelling or grammar errors. If there are errors, explain which topic they should study and ask a natural follow-up question that tests that specific error in your next response.",
                "B1": "You are an experienced English teacher talking with B1 level students. Discuss more complex topics, correct and explain grammar mistakes. IMPORTANT: Check every message for spelling or grammar errors. If there are errors, explain which topic they should study and ask a natural follow-up question that tests that specific error in your next response.",
                "B2": "You are an expert English teacher talking with B2 level students. Discuss abstract topics and use nuanced grammar structures. IMPORTANT: Check every message for spelling or grammar errors. If there are errors, explain which topic they should study and ask a natural follow-up question that tests that specific error in your next response.",
                "C1": "You are an expert English teacher talking with C1 level students. Engage in detailed discussions about academic and professional topics, use complex grammar structures and explain subtle nuances. IMPORTANT: Check every message for spelling or grammar errors. If there are errors, explain which topic they should study and ask a natural follow-up question that tests that specific error in your next response.",
                "C2": "You are a master English teacher talking with C2 level students. Converse at native speaker level, discuss literature and cultural topics in depth. Catch even the most subtle grammar and style errors. IMPORTANT: Check every message for spelling or grammar errors. If there are errors, explain which topic they should study and ask a natural follow-up question that tests that specific error in your next response."
            },
            "german": {
                "A1": "Du bist ein hilfreicher Deutschlehrer, der mit A1-Schülern spricht. Verwende einfache Wörter, kurze Sätze und korrigiere Fehler sanft. Halte Antworten bei 2-3 Sätzen. WICHTIG: Überprüfe jede Nachricht auf Rechtschreib- oder Grammatikfehler. Wenn Fehler vorhanden sind, erkläre, welches Thema sie lernen sollten, und stelle in deiner nächsten Antwort eine natürliche Folgefrage, die diesen spezifischen Fehler testet.",
                "A2": "Du bist ein Deutschlehrer, der mit A2-Schülern spricht. Diskutiere alltägliche Themen mit grundlegenden Grammatikstrukturen. Mache Antworten klar und lehrreich. WICHTIG: Überprüfe jede Nachricht auf Rechtschreib- oder Grammatikfehler. Wenn Fehler vorhanden sind, erkläre, welches Thema sie lernen sollten, und stelle in deiner nächsten Antwort eine natürliche Folgefrage, die diesen spezifischen Fehler testet.",
                "B1": "Du bist ein erfahrener Deutschlehrer, der mit B1-Schülern spricht. Diskutiere komplexere Themen, korrigiere und erkläre Grammatikfehler. WICHTIG: Überprüfe jede Nachricht auf Rechtschreib- oder Grammatikfehler. Wenn Fehler vorhanden sind, erkläre, welches Thema sie lernen sollten, und stelle in deiner nächsten Antwort eine natürliche Folgefrage, die diesen spezifischen Fehler testet.",
                "B2": "Du bist ein Experten-Deutschlehrer, der mit B2-Schülern spricht. Diskutiere abstrakte Themen und verwende nuancierte Grammatikstrukturen. WICHTIG: Überprüfe jede Nachricht auf Rechtschreib- oder Grammatikfehler. Wenn Fehler vorhanden sind, erkläre, welches Thema sie lernen sollten, und stelle in deiner nächsten Antwort eine natürliche Folgefrage, die diesen spezifischen Fehler testet.",
                "C1": "Du bist ein Experten-Deutschlehrer, der mit C1-Schülern spricht. Führe detaillierte Diskussionen über akademische und berufliche Themen, verwende komplexe Grammatikstrukturen und erkläre subtile Nuancen. WICHTIG: Überprüfe jede Nachricht auf Rechtschreib- oder Grammatikfehler. Wenn Fehler vorhanden sind, erkläre, welches Thema sie lernen sollten, und stelle in deiner nächsten Antwort eine natürliche Folgefrage, die diesen spezifischen Fehler testet.",
                "C2": "Du bist ein Meister-Deutschlehrer, der mit C2-Schülern spricht. Unterhalte dich auf muttersprachlichem Niveau, diskutiere Literatur und kulturelle Themen tiefgreifend. Erkenne selbst die subtilsten Grammatik- und Stilfehler. WICHTIG: Überprüfe jede Nachricht auf Rechtschreib- oder Grammatikfehler. Wenn Fehler vorhanden sind, erkläre, welches Thema sie lernen sollten, und stelle in deiner nächsten Antwort eine natürliche Folgefrage, die diesen spezifischen Fehler testet."
            }        }
        
        return prompts.get(language, {}).get(level, "You are a helpful language teacher.")

    def _placeholder_conversation_response(self, user_id: str, message: str, language: str, level: str) -> str:
        """Placeholder conversation response"""
        responses = {
            "turkish": f"Merhaba! '{message}' mesajınızı aldım. Türkçe dilinde {level} seviyesinde pratik yapıyoruz. Gerçek AI yanıtları için Gemini API key'i ekleyin. Bu seviyede yazım ve gramer hatalarınızı kontrol edip geri bildirim vereceğim.",
            "english": f"Hello! I received your message '{message}'. We're practicing English at {level} level. Add Gemini API key for real AI responses. At this level, I'll check your spelling and grammar errors and provide feedback.",
            "german": f"Hallo! Ich habe deine Nachricht '{message}' erhalten. Wir üben Deutsch auf {level} Niveau. Füge einen Gemini API-Schlüssel für echte KI-Antworten hinzu. Auf diesem Niveau werde ich deine Rechtschreib- und Grammatikfehler überprüfen und Feedback geben."
        }
        
        response = responses.get(language, f"Hello! Message received: '{message}'. Language: {language}, Level: {level}. I'll check your grammar and spelling at this level.")
        
        # Add to conversation history
        self.conversation_history[user_id].append({"role": "user", "content": message})
        self.conversation_history[user_id].append({"role": "assistant", "content": response})
        
        return response

# Global instance
ai_service = AIService()
