import requests
import json

def test_communication_scenarios():
    """Test different communication language scenarios"""
    
    base_url = "http://localhost:8000/api/ai/chat"
    headers = {"Content-Type": "application/json"}
    
    test_cases = [
        {
            "name": "Cross-language: Turkish → English Learning",
            "data": {
                "message": "Merhaba! İngilizce öğreniyorum ve practice yapmak istiyorum.",
                "language": "english",
                "level": "A1",
                "user_id": "test_user_1",
                "communication_language": "turkish"
            }
        },
        {
            "name": "Immersive: English → English Learning",
            "data": {
                "message": "Hello! I want to practice English grammar.",
                "language": "english", 
                "level": "A1",
                "user_id": "test_user_2",
                "communication_language": "english"
            }
        },
        {
            "name": "Cross-language: English → Turkish Learning",
            "data": {
                "message": "Hi! I'm learning Turkish and need help with basic phrases.",
                "language": "turkish",
                "level": "A1", 
                "user_id": "test_user_3",
                "communication_language": "english"
            }
        },
        {
            "name": "Same language (no communication_language specified)",
            "data": {
                "message": "Merhaba! Türkçe öğreniyorum.",
                "language": "turkish",
                "level": "A1",
                "user_id": "test_user_4"
            }
        }
    ]
    
    print("🧪 Testing Communication Language Integration\n")
    print("=" * 60)
    
    for i, test_case in enumerate(test_cases, 1):
        print(f"\n{i}. {test_case['name']}")
        print("-" * 50)
        
        try:
            response = requests.post(base_url, json=test_case['data'], headers=headers)
            
            print(f"📤 Request: {test_case['data']['message']}")
            print(f"🎯 Target Language: {test_case['data']['language'].title()}")
            print(f"📊 Level: {test_case['data']['level']}")
            comm_lang = test_case['data'].get('communication_language', 'Same as target')
            print(f"💬 Communication Language: {comm_lang.title() if comm_lang != 'Same as target' else comm_lang}")
            print(f"📈 Status Code: {response.status_code}")
            
            if response.status_code == 200:
                result = response.json()
                print(f"✅ Success: {result.get('success', False)}")
                print(f"📝 AI Response: {result.get('response', 'No response')}")
            else:
                print(f"❌ Error: {response.text}")
                
        except Exception as e:
            print(f"💥 Exception: {e}")
        
        print()

if __name__ == "__main__":
    test_communication_scenarios()
