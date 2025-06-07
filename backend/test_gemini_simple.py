#!/usr/bin/env python3
"""
Gemini API Test Script
Bu script Gemini API'nin doğru çalışıp çalışmadığını test eder.
"""
import os
import sys
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

def test_gemini_direct():
    """Test Gemini API directly without importing other modules"""
    print("🧪 Testing Gemini API directly...")
    
    try:
        import google.generativeai as genai
        print("✅ Gemini package imported successfully")
        
        # Get API key
        api_key = os.getenv("GEMINI_API_KEY")
        print(f"🔑 API Key found: {'Yes' if api_key else 'No'}")
        
        if not api_key or api_key == "get-your-free-gemini-api-key-from-ai.google.dev":
            print("❌ No valid Gemini API key found")
            return False
            
        # Configure Gemini
        genai.configure(api_key=api_key)
        print("✅ Gemini configured successfully")
        
        # Create model
        model = genai.GenerativeModel('gemini-pro')
        print("✅ Gemini model created successfully")
        
        # Test simple generation
        response = model.generate_content("Merhaba! Bu bir test mesajıdır. Kısa bir yanıt ver.")
        print("✅ Gemini API call successful")
        print(f"📝 Response: {response.text[:100]}...")
        
        return True
        
    except Exception as e:
        print(f"❌ Error testing Gemini: {e}")
        import traceback
        traceback.print_exc()
        return False

def test_ai_service():
    """Test our AI service"""
    print("\n🧪 Testing AI Service...")
    
    try:
        # Import AI service directly
        sys.path.append('.')
        
        # Import just the AI service file
        import importlib.util
        spec = importlib.util.spec_from_file_location(
            "ai_service", 
            "app/services/ai_service.py"
        )
        ai_module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(ai_module)
        
        # Create AI service instance
        ai_service = ai_module.AIService()
        print(f"✅ AI Service created. Using real AI: {ai_service.use_real_ai}")
        
        if ai_service.use_real_ai:
            # Test conversation
            response = ai_service.get_conversation_response(
                "test_user", 
                "Merhaba, nasılsın?", 
                "turkish", 
                "A1"
            )
            print(f"📝 Conversation response: {response[:100]}...")
            
            # Test grammar analysis
            grammar_result = ai_service.analyze_grammar("Bu bir test cümle.", "turkish")
            print(f"📝 Grammar analysis: {grammar_result['analysis'][:100]}...")
            
        return True
        
    except Exception as e:
        print(f"❌ Error testing AI Service: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    print("🚀 Starting Gemini API Tests...\n")
    
    # Test 1: Direct Gemini API
    gemini_ok = test_gemini_direct()
    
    # Test 2: AI Service (only if Gemini works)
    if gemini_ok:
        ai_service_ok = test_ai_service()
    else:
        print("⏩ Skipping AI Service test due to Gemini API issues")
        ai_service_ok = False
    
    # Summary
    print("\n📊 Test Results Summary:")
    print(f"   Gemini API: {'✅ PASS' if gemini_ok else '❌ FAIL'}")
    print(f"   AI Service: {'✅ PASS' if ai_service_ok else '❌ FAIL'}")
    
    if gemini_ok and ai_service_ok:
        print("\n🎉 All tests passed! Gemini integration is working!")
    else:
        print("\n🔧 Some tests failed. Check the errors above.")
