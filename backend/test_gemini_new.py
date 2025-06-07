import os
from dotenv import load_dotenv
import google.generativeai as genai

def test_gemini():
    # Load environment variables
    load_dotenv()
    api_key = os.getenv('GEMINI_API_KEY')
    
    if not api_key:
        print("❌ GEMINI_API_KEY not found in .env file")
        return False
    
    print(f"✅ API Key loaded: {api_key[:10]}...")
    
    # Configure Gemini
    genai.configure(api_key=api_key)
    
    # Test with gemini-1.5-flash
    try:
        model = genai.GenerativeModel('gemini-1.5-flash')
        print("✅ Gemini 1.5 Flash model created successfully!")
        
        # Test simple content generation
        response = model.generate_content('Merhaba! Bu bir test. Türkçe kısa yanıt ver.')
        print("✅ API Response:", response.text)
        
        return True
        
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

if __name__ == "__main__":
    test_gemini()
