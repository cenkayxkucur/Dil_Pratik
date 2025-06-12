import requests
import json

def test_improved_communication_prompts():
    """Test the improved, less strict communication language prompts"""
    
    base_url = "http://localhost:8000/api/ai/chat"
    headers = {"Content-Type": "application/json"}
    
    test_cases = [
        {
            "name": "✅ User writes correctly in communication language (Turkish)",
            "scenario": "Cross-language: Turkish → English Learning",
            "data": {
                "message": "Merhaba! İngilizce öğreniyorum ve yardım istiyorum.",
                "language": "english",
                "level": "A1",
                "user_id": "test_user_1",
                "communication_language": "turkish"
            },
            "expectation": "Should engage naturally, respond in English, no language warnings"
        },
        {
            "name": "✅ User writes correctly in immersive language (English)",
            "scenario": "Immersive: English → English Learning",
            "data": {
                "message": "Hello! I want to practice English grammar.",
                "language": "english",
                "level": "A1",
                "user_id": "test_user_2",
                "communication_language": "english"
            },
            "expectation": "Should engage naturally, provide grammar help, no language warnings"
        },
        {
            "name": "🔄 User accidentally writes in wrong language (cross-language)",
            "scenario": "User set Turkish communication but writes in English",
            "data": {
                "message": "Hello! I want to learn English but I'm supposed to communicate in Turkish.",
                "language": "english",
                "level": "A1",
                "user_id": "test_user_3",
                "communication_language": "turkish"
            },
            "expectation": "Should gently remind to use Turkish, but be helpful"
        },
        {
            "name": "🔄 User writes in wrong language (immersive)",
            "scenario": "User set immersive English but writes in Turkish",
            "data": {
                "message": "Merhaba! İngilizce öğreniyorum ama İngilizce yazmam gerekiyor.",
                "language": "english",
                "level": "A1", 
                "user_id": "test_user_4",
                "communication_language": "english"
            },
            "expectation": "Should gently guide to use English for immersive learning"
        },
        {
            "name": "🎯 User expects conversation, not translation (Turkish→English)",
            "scenario": "User says something expecting conversation, not just translation",
            "data": {
                "message": "Bugün hava çok güzel, dışarı çıkmak istiyorum.",
                "language": "english",
                "level": "A1",
                "user_id": "test_user_5",
                "communication_language": "turkish"
            },
            "expectation": "Should engage conversationally, not just translate. Ask questions, give examples."
        },
        {
            "name": "🎯 User expects conversation in immersive mode (English→English)",
            "scenario": "User talks about a topic expecting meaningful conversation",
            "data": {
                "message": "I like reading books in my free time.",
                "language": "english",
                "level": "A2",
                "user_id": "test_user_6",
                "communication_language": "english"
            },
            "expectation": "Should ask follow-up questions about books, provide vocabulary, create conversation"
        },
        {
            "name": "✅ User explicitly asks for translation",
            "scenario": "User specifically requests translation",
            "data": {
                "message": "Bu cümlenin İngilizce çevirisi nedir: 'Bugün hava çok güzel'?",
                "language": "english",
                "level": "A1",
                "user_id": "test_user_7",
                "communication_language": "turkish"
            },
            "expectation": "Should provide translation since explicitly requested"
        }
    ]
    
    print("🧪 Testing Improved Communication Language Prompts")
    print("=" * 60)
    
    for i, test_case in enumerate(test_cases, 1):
        print(f"\n{i}. {test_case['name']}")
        print(f"📋 Scenario: {test_case['scenario']}")
        print(f"💭 Expectation: {test_case['expectation']}")
        print("-" * 50)
        
        try:
            response = requests.post(base_url, json=test_case['data'], headers=headers)
            
            if response.status_code == 200:
                result = response.json()
                ai_response = result.get('response', 'No response')
                
                print(f"👤 User Message: \"{test_case['data']['message']}\"")
                print(f"🤖 AI Response: \"{ai_response}\"")
                  # Analysis
                response_lower = ai_response.lower()
                has_language_warning = any(phrase in response_lower for phrase in [
                    'please communicate', 'only in', 'different language', 
                    'lütfen', 'sadece', 'farklı dil'
                ])
                
                has_grammar_focus = any(phrase in response_lower for phrase in [
                    'grammar', 'correct', 'mistake', 'error', 'improvement',
                    'gramer', 'hata', 'düzeltme', 'gelişim'
                ])
                
                # Check if it's just translation vs conversation
                is_just_translation = (
                    len(ai_response.split()) < 10 and  # Very short response
                    not any(phrase in response_lower for phrase in [
                        '?', 'what', 'how', 'why', 'do you', 'can you', 'tell me',
                        'ne', 'nasıl', 'neden', 'söyler misin', 'anlatır mısın'
                    ])
                )
                
                has_conversational_elements = any(phrase in response_lower for phrase in [
                    '?', 'what about', 'tell me', 'can you', 'do you like', 'how do you',
                    'ne düşünüyorsun', 'anlatır mısın', 'nasıl', 'hangi'
                ])
                  print(f"📊 Analysis:")
                print(f"   - Contains language warning: {'❌ Yes' if has_language_warning else '✅ No'}")
                print(f"   - Focus on grammar/learning: {'✅ Yes' if has_grammar_focus else '❌ No'}")
                print(f"   - Just translation (bad): {'❌ Yes' if is_just_translation else '✅ No'}")
                print(f"   - Conversational elements: {'✅ Yes' if has_conversational_elements else '❌ No'}")
                
                # Determine if response is appropriate
                if i <= 2:  # Cases where user writes correctly
                    is_good = not has_language_warning and has_grammar_focus and not is_just_translation
                    print(f"   - Response quality: {'✅ Good' if is_good else '❌ Needs improvement'}")
                elif i <= 4:  # Cases where gentle guidance is expected
                    is_good = has_language_warning and not (response_lower.count('only') > 1)
                    print(f"   - Response quality: {'✅ Good' if is_good else '❌ Too strict or unclear'}")
                elif i <= 6:  # Conversation test cases
                    is_good = has_conversational_elements and not is_just_translation
                    print(f"   - Response quality: {'✅ Good' if is_good else '❌ Too simple/just translation'}")
                else:  # Translation request case
                    is_good = 'translation' in response_lower or 'çeviri' in response_lower
                    print(f"   - Response quality: {'✅ Good' if is_good else '❌ Should provide translation when asked'}")
                
            else:
                print(f"❌ HTTP Error: {response.status_code}")
                print(f"Response: {response.text}")
                
        except Exception as e:
            print(f"❌ Request failed: {e}")
        
        print()

if __name__ == "__main__":
    print("🚀 Starting improved communication language prompt tests...")
    test_improved_communication_prompts()
    print("\n✅ Test completed!")
