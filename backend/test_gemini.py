#!/usr/bin/env python3
"""Test script for Gemini AI service"""

import os
import sys
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

def test_gemini_import():
    try:
        import google.generativeai as genai
        print("✅ Google Generative AI imported successfully")
        return True
    except ImportError as e:
        print(f"❌ Failed to import Google Generative AI: {e}")
        return False

def test_dotenv():
    try:
        from dotenv import load_dotenv
        load_dotenv()
        
        api_key = os.getenv("GEMINI_API_KEY")
        print(f"📁 Environment loaded. API Key present: {'Yes' if api_key and api_key != 'get-your-free-gemini-api-key-from-ai.google.dev' else 'No (placeholder)'}")
        return True
    except ImportError as e:
        print(f"❌ Failed to load environment: {e}")
        return False

def test_ai_service():
    try:
        from app.services.ai_service import AIService
        
        # Create AI service instance
        ai_service = AIService()
        print(f"🤖 AI Service created. Using real AI: {ai_service.use_real_ai}")
        
        # Test a simple conversation
        response = ai_service.get_conversation_response(
            user_id="test_user",
            message="Hello, how are you?",
            language="english",
            level="A1"
        )
        
        print(f"💬 Test conversation response: {response[:100]}...")
        return True
        
    except Exception as e:
        print(f"❌ AI Service test failed: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    print("🧪 Testing Gemini AI Integration")
    print("=" * 50)
    
    # Run tests
    tests = [
        ("Gemini Import", test_gemini_import),
        ("Environment Variables", test_dotenv), 
        ("AI Service", test_ai_service)
    ]
    
    results = []
    for test_name, test_func in tests:
        print(f"\n📋 Running: {test_name}")
        result = test_func()
        results.append((test_name, result))
        print(f"Result: {'✅ PASS' if result else '❌ FAIL'}")
    
    print("\n" + "=" * 50)
    print("📊 Test Summary:")
    for test_name, result in results:
        status = "✅ PASS" if result else "❌ FAIL"
        print(f"  {test_name}: {status}")
    
    passed = sum(1 for _, result in results if result)
    total = len(results)
    print(f"\nOverall: {passed}/{total} tests passed")
    
    if passed == total:
        print("🎉 All tests passed! Gemini AI integration is working!")
    else:
        print("⚠️  Some tests failed. Check the logs above for details.")
