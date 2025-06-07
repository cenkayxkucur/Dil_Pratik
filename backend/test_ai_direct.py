#!/usr/bin/env python3
"""
Direct test of AI service with Gemini API
"""

import sys
import os
sys.path.append('.')
sys.path.append('./app')

from app.services.ai_service import ai_service

def test_ai_service():
    """Test AI service directly"""
    print("🔍 Testing AI Service directly...")
    
    # Test conversation response
    try:
        response = ai_service.get_conversation_response(
            user_id="test-user-123",
            message="Merhaba, Türkçe öğreniyorum. Nasılsın?",
            language="turkish",
            level="A1"
        )
        print(f"✅ Conversation Response: {response}")
        return True
    except Exception as e:
        print(f"❌ Conversation test failed: {e}")
        return False

def test_grammar_analysis():
    """Test grammar analysis"""
    print("\n🔍 Testing Grammar Analysis...")
    
    try:
        analysis = ai_service.analyze_grammar(
            text="Ben çok mutluyum çünkü Türkçe öğreniyorım.",
            language="turkish"
        )
        print(f"✅ Grammar Analysis: {analysis}")
        return True
    except Exception as e:
        print(f"❌ Grammar analysis failed: {e}")
        return False

if __name__ == "__main__":
    print("🚀 Testing AI Service with Gemini API\n")
    
    test1 = test_ai_service()
    test2 = test_grammar_analysis()
    
    if test1 and test2:
        print("\n🎉 All AI service tests passed!")
    else:
        print("\n⚠️  Some AI service tests failed.")
