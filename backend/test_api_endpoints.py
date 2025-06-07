#!/usr/bin/env python3
"""
Test script to verify API endpoints are working with Gemini API integration
"""

import requests
import json
import sys

BASE_URL = "http://127.0.0.1:8000"

def test_health():
    """Test health endpoint"""
    print("🔍 Testing health endpoint...")
    try:
        response = requests.get(f"{BASE_URL}/health")
        print(f"✅ Health check: {response.status_code} - {response.json()}")
        return True
    except Exception as e:
        print(f"❌ Health check failed: {e}")
        return False

def test_ai_chat():
    """Test AI chat endpoint with Gemini"""
    print("\n🔍 Testing AI chat endpoint...")
    try:
        payload = {
            "message": "Merhaba, Türkçe öğreniyorum. Nasılsın?",
            "language": "turkish",
            "level": "A1",
            "user_id": "test-user-123"
        }
        
        response = requests.post(
            f"{BASE_URL}/api/ai/chat",
            json=payload,
            headers={"Content-Type": "application/json"}
        )
        
        print(f"Status: {response.status_code}")
        if response.status_code == 200:
            result = response.json()
            print(f"✅ AI Chat Response: {result}")
            return True
        else:
            print(f"❌ AI Chat failed: {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ AI Chat test failed: {e}")
        return False

def test_grammar_analysis():
    """Test grammar analysis endpoint"""
    print("\n🔍 Testing grammar analysis endpoint...")
    try:
        payload = {
            "text": "Ben çok mutluyum çünkü Türkçe öğreniyorım.",
            "language": "turkish"
        }
        
        response = requests.post(
            f"{BASE_URL}/api/ai/analyze-grammar",
            json=payload,
            headers={"Content-Type": "application/json"}
        )
        
        print(f"Status: {response.status_code}")
        if response.status_code == 200:
            result = response.json()
            print(f"✅ Grammar Analysis: {result}")
            return True
        else:
            print(f"❌ Grammar Analysis failed: {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ Grammar Analysis test failed: {e}")
        return False

def test_practice_content():
    """Test practice content generation"""
    print("\n🔍 Testing practice content generation...")
    try:
        payload = {
            "topic": "Present Tense",
            "language": "turkish",  
            "level": "A1"
        }
        
        response = requests.post(
            f"{BASE_URL}/api/ai/generate-practice", 
            json=payload,
            headers={"Content-Type": "application/json"}
        )
        
        print(f"Status: {response.status_code}")
        if response.status_code == 200:
            result = response.json()
            print(f"✅ Practice Content: {result}")
            return True
        else:
            print(f"❌ Practice Content failed: {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ Practice Content test failed: {e}")
        return False

def test_grammar_endpoint():
    """Test grammar analyze endpoint (alternative endpoint)"""
    print("\n🔍 Testing grammar analyze endpoint...")
    try:
        # Test with query parameters
        params = {
            "text": "Ben okula gidiyorum ve arkadaşlarımla oyun oynuyorum.",
            "language": "turkish"
        }
        
        response = requests.post(
            f"{BASE_URL}/api/grammar/analyze",
            params=params,
            headers={"Content-Type": "application/json"}
        )
        
        print(f"Status: {response.status_code}")
        if response.status_code == 200:
            result = response.json()
            print(f"✅ Grammar Endpoint: {result}")
            return True
        else:
            print(f"❌ Grammar Endpoint failed: {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ Grammar Endpoint test failed: {e}")
        return False

def main():
    """Run all tests"""
    print("🚀 Starting API Endpoint Tests with Gemini Integration\n")
    
    tests = [
        ("Health Check", test_health),
        ("AI Chat", test_ai_chat),
        ("Grammar Analysis (AI)", test_grammar_analysis),
        ("Practice Content", test_practice_content),
        ("Grammar Endpoint", test_grammar_endpoint)
    ]
    
    results = []
    for test_name, test_func in tests:
        success = test_func()
        results.append((test_name, success))
    
    print("\n" + "="*50)
    print("📊 TEST RESULTS SUMMARY")
    print("="*50)
    
    passed = 0
    for test_name, success in results:
        status = "✅ PASS" if success else "❌ FAIL"
        print(f"{test_name}: {status}")
        if success:
            passed += 1
    
    print(f"\nOverall: {passed}/{len(results)} tests passed")
    
    if passed == len(results):
        print("🎉 All tests passed! Gemini API integration is working correctly.")
        return 0
    else:
        print("⚠️  Some tests failed. Check the output above for details.")
        return 1

if __name__ == "__main__":
    sys.exit(main())
