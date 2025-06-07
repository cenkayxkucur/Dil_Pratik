import openai
from dotenv import load_dotenv
import os
from typing import Dict, List, Optional

load_dotenv()

openai.api_key = os.getenv("OPENAI_API_KEY")

class AIService:
    def __init__(self):
        self.conversation_history: Dict[str, List[Dict]] = {}

    def process_speech(self, audio_file) -> Dict:
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

    def get_conversation_response(
        self,
        user_id: str,
        message: str,
        language: str,
        level: str
    ) -> str:
        """GPT-3.5 ile konuşma yanıtı ve düzeltmeler alır."""
        if user_id not in self.conversation_history:
            self.conversation_history[user_id] = []

        system_message = f"""Sen bir {language} öğretmenisin. Kullanıcının seviyesi {level}. 
        Doğal konuşma yap, hataları nazikçe düzelt ve öğrenmeyi teşvik et."""

        messages = [{"role": "system", "content": system_message}]
        messages.extend(self.conversation_history[user_id][-5:])  # Son 5 mesajı kullan
        messages.append({"role": "user", "content": message})

        try:
            response = openai.ChatCompletion.create(
                model="gpt-3.5-turbo",
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
            return f"Üzgünüm, bir hata oluştu: {str(e)}"

    def analyze_grammar(self, text: str, language: str) -> Dict:
        """Metindeki gramer hatalarını analiz eder."""
        try:
            prompt = f"""Aşağıdaki {language} metindeki gramer hatalarını analiz et:
            
            Metin: "{text}"
            
            Lütfen şu formatta yanıt ver:
            - Hatalar: [hata listesi]
            - Düzeltmeler: [düzeltme önerileri]
            - Açıklamalar: [gramer kuralı açıklamaları]
            """

            response = openai.ChatCompletion.create(
                model="gpt-3.5-turbo",
                messages=[{"role": "user", "content": prompt}],
                temperature=0.3,
                max_tokens=300
            )
            
            analysis = response.choices[0].message.content
            
            return {
                "original_text": text,
                "analysis": analysis,
                "corrections": [],  # Bu kısım daha detayına göre geliştirilebilir
                "explanations": []
            }

        except Exception as e:
            return {
                "original_text": text,
                "analysis": f"Analiz yapılamadı: {str(e)}",
                "corrections": [],
                "explanations": []
            }

    def generate_practice_content(self, topic: str, language: str, level: str) -> Dict:
        """Belirli bir konu için pratik içeriği oluşturur."""
        try:
            prompt = f"""
            {language} dilinde {level} seviyesi için "{topic}" konusunda pratik egzersizleri oluştur.
            Lütfen 3 farklı tipte soru hazırla:
            1. Çoktan seçmeli (4 seçenek)
            2. Boşluk doldurma
            3. Cümle kurma
            """

            response = openai.ChatCompletion.create(
                model="gpt-3.5-turbo",
                messages=[{"role": "user", "content": prompt}],
                temperature=0.5,
                max_tokens=400
            )
            
            content = response.choices[0].message.content
            
            return {
                "topic": topic,
                "language": language,
                "level": level,
                "content": content,
                "exercises": []  # Bu kısım parse edilebilir
            }

        except Exception as e:
            return {
                "topic": topic,
                "language": language,
                "level": level,
                "content": f"İçerik oluşturulamadı: {str(e)}",
                "exercises": []
            }

# Global instance
ai_service = AIService()
