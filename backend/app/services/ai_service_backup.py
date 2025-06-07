import openai
from dotenv import load_dotenv
import os
from typing import Dict, List, Optional

load_dotenv()

openai.api_key = os.getenv("OPENAI_API_KEY")

class AIService:
    def __init__(self):
        self.conversation_history: Dict[str, List[Dict]] = {}

    async def process_speech(self, audio_file) -> Dict:
        """Whisper API ile ses dosyasını metne çevirir ve telaffuz analizi yapar."""
        try:
            # OpenAI 0.28.0 syntax
            transcript = openai.Audio.transcribe(
                model="whisper-1",
                file=audio_file
            )
              return {
                "text": transcript.get("text", ""),
                "confidence": None,  # 0.28.0'da confidence bilgisi farklı şekilde alınıyor
                "language": transcript.get("language", "")
            }
        except Exception as e:
            raise Exception(f"Speech processing error: {str(e)}")

    async def get_conversation_response(
        self,
        user_id: str,
        message: str,
        language: str,
        level: str
    ) -> str:
        """GPT-4 ile konuşma yanıtı ve düzeltmeler alır."""
        if user_id not in self.conversation_history:
            self.conversation_history[user_id] = []

        # Sistem mesajını hazırla
        system_message = f"""You are a helpful language learning assistant for {language}.
        Current student level: {level}
        Your task is to:
        1. Engage in conversation appropriate for their level
        2. Correct any grammar or pronunciation mistakes
        3. Provide explanations for corrections
        4. Keep responses concise and clear"""

        # Kullanıcı geçmişini ekle
        messages = [{"role": "system", "content": system_message}]
        messages.extend(self.conversation_history[user_id][-5:])  # Son 5 mesajı kullan
        messages.append({"role": "user", "content": message})        try:
            response = openai.ChatCompletion.create(
                model="gpt-3.5-turbo",  # gpt-4 yerine daha uygun fiyatlı model
                messages=messages,
                temperature=0.7,
                max_tokens=150
            )
            
            assistant_message = response.choices[0].message.content
            
            # Geçmişi güncelle
            self.conversation_history[user_id].append({"role": "user", "content": message})
            self.conversation_history[user_id].append({"role": "assistant", "content": assistant_message})
            
            return assistant_message

        except Exception as e:
            raise Exception(f"GPT processing error: {str(e)}")

    async def generate_exercises(
        self,
        topic: str,
        level: str,
        language: str,
        error_types: Optional[List[str]] = None
    ) -> Dict:
        """Belirli bir konu için alıştırmalar üretir."""
        prompt = f"""Create exercises for {language} learning.
        Topic: {topic}
        Level: {level}
        Error types to focus on: {', '.join(error_types) if error_types else 'general practice'}
        
        Generate:
        1. 3 multiple choice questions
        2. 2 fill-in-the-blank exercises
        3. 1 sentence construction task"""

        try:
            response = await self.client.chat.completions.create(
                model="gpt-4",
                messages=[{"role": "user", "content": prompt}],
                temperature=0.8,
                max_tokens=500
            )
            
            return {
                "exercises": response.choices[0].message.content,
                "topic": topic,
                "level": level
            }

        except Exception as e:
            raise Exception(f"Exercise generation error: {str(e)}")

ai_service = AIService() 