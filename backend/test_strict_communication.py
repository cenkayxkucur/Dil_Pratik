#!/usr/bin/env python3

import requests
import json

def test_strict_communication_language():
    """Test strict communication language enforcement"""
    
    base_url = "http://localhost:8000/api/ai/chat"
    headers = {"Content-Type": "application/json"}
    
    test_cases = [
        {
            "name": "✅ Correct: Turkish → English Learning",
            "data": {
                "message": "Merhaba! İngilizce öğreniyorum.",
                "language": "english",
                "level": "A1",
                "user_id": "test_user_1",
                "communication_language": "turkish"
            },
            "expected": "Should respond in English"
        },
        {
            "name": "❌ Wrong Language: English → English Learning (when Turkish expected)",
            "data": {
                "message": "Hello! I want to learn English.",
                "language": "english",
                "level": "A1",
                "user_id": "test_user_2",
                "communication_language": "turkish"
            },
            "expected": "Should ask to communicate in Turkish"
        },
        {
            "name": "❌ Wrong Language: German → English Learning (when Turkish expected)",
            "data": {
                "message": "Hallo! Ich möchte Englisch lernen.",
                "language": "english",
                "level": "A1",
                "user_id": "test_user_3",
                "communication_language": "turkish"
            },
            "expected": "Should ask to communicate in Turkish"
        },
        {
            "name": "✅ Correct: English → English Learning (Immersive)",
            "data": {
                "message": "Hello! I want to practice English grammar.",
                "language": "english",
                "level": "A1",
                "user_id": "test_user_4",
                "communication_language": "english"
            },
            "expected": "Should respond in English"
        },
        {
            "name": "❌ Wrong Language: Turkish → English Learning (when English immersive expected)",
            "data": {
                "message": "Merhaba! İngilizce gramer pratiği yapmak istiyorum.",
                "language": "english",
                "level": "A1",
                "user_id": "test_user_5",
                "communication_language": "english"
            },
            "expected": "Should ask to communicate in English"
        }
    ]
    
    print("🔒 Testing STRICT Communication Language Enforcement\n")
    print("=" * 70)
    
    for i, test_case in enumerate(test_cases, 1):
        print(f"\n{i}. {test_case['name']}")
        print("-" * 60)
        print(f"📝 Message: {test_case['data']['message']}")
        print(f"🎯 Target Language: {test_case['data']['language']}")
        print(f"💬 Communication Language: {test_case['data']['communication_language']}")
        print(f"🎲 Expected: {test_case['expected']}")
        
        try:
            response = requests.post(base_url, json=test_case['data'], headers=headers)
            
            if response.status_code == 200:
                result = response.json()
                ai_response = result.get('response', 'No response')
                print(f"🤖 AI Response: {ai_response}")
                
                # Check if AI is enforcing language rules
                if "communicate" in ai_response.lower() and ("only" in ai_response.lower() or "Turkish" in ai_response or "English" in ai_response):
                    print("✅ SUCCESS: AI is enforcing communication language rules!")
                else:
                    print("⚠️  REVIEW: Check if AI is properly enforcing rules")
                    
            else:
                print(f"❌ ERROR: Status {response.status_code} - {response.text}")
                
        except Exception as e:
            print(f"❌ ERROR: {e}")
            
        print("\n" + "." * 60)
    
    print(f"\n{'='*70}")
    print("🔍 Test completed! Review the responses to see if AI enforces language rules.")

if __name__ == "__main__":
    test_strict_communication_language()
