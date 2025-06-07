#!/usr/bin/env python3
"""
Basic Gemini API connection test
"""

import google.generativeai as genai
from dotenv import load_dotenv
import os

load_dotenv()

def test_basic_gemini():
    """Test basic Gemini API connection"""
    print("🔍 Testing basic Gemini API connection...")
    
    api_key = os.getenv("GEMINI_API_KEY")
    print(f"API Key loaded: {api_key[:20]}..." if api_key else "No API key found")
    
    if not api_key:
        print("❌ No GEMINI_API_KEY found in environment")
        return False
    
    try:
        # Configure Gemini
        genai.configure(api_key=api_key)
        
        # Create model
        model = genai.GenerativeModel('gemini-1.5-flash')
        print("✅ Model created successfully")
        
        # Test simple generation
        print("🔍 Testing simple text generation...")
        response = model.generate_content("Hello, please respond with 'API connection successful'")
        print(f"✅ Gemini Response: {response.text}")
        
        return True
        
    except Exception as e:
        print(f"❌ Gemini API test failed: {e}")
        return False

if __name__ == "__main__":
    test_basic_gemini()
