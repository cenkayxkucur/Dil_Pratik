import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

# Test AI service directly
import google.generativeai as genai
from dotenv import load_dotenv
import json

load_dotenv()

class SimpleAITest:
    def __init__(self):
        self.api_key = os.getenv("GEMINI_API_KEY")
        if self.api_key:
            genai.configure(api_key=self.api_key)
            self.model = genai.GenerativeModel('gemini-1.5-flash')
            print("✅ Gemini API başarıyla başlatıldı")
        else:
            print("❌ Gemini API key bulunamadı")
            
    def test_conversation(self):
        try:
            prompt = """Sen Türkçe öğrenen A1 seviyesindeki öğrencilerle konuşan yardımcı bir öğretmensin. 
            Basit kelimeler kullan, kısa cümleler kur.
            
            Kullanıcı mesajı: Merhaba, nasılsın?
            
            Yanıt ver:"""
            
            response = self.model.generate_content(prompt)
            print(f"Konuşma testi: {response.text}")
            return True
        except Exception as e:
            print(f"Konuşma testi hatası: {e}")
            return False
            
    def test_grammar(self):
        try:
            prompt = """Sen Türkçe dil uzmanısın. Aşağıdaki metni analiz et:
            
            Metin: "Ben okula gidiyom."
            
            JSON formatında yanıt ver:
            {
                "original_text": "...",
                "analysis": "...",
                "corrections": ["..."],
                "explanations": ["..."]
            }"""
            
            response = self.model.generate_content(prompt)
            print(f"Gramer testi: {response.text[:200]}...")
            return True
        except Exception as e:
            print(f"Gramer testi hatası: {e}")
            return False

if __name__ == "__main__":
    test = SimpleAITest()
    test.test_conversation()
    test.test_grammar()
