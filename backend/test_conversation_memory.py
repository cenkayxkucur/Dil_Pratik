import requests
import json

def test_conversation_history_system():
    """Test the complete conversation history system"""
    
    base_url = "http://localhost:8000/api/ai/chat"
    headers = {"Content-Type": "application/json"}
    
    # Test with a specific user ID to track conversation
    test_user_id = "test_user_conversation_123"
    
    # Conversation sequence to test memory
    conversation_sequence = [
        {
            "message": "Merhaba! Benim adım Cenk.",
            "expectation": "Should remember the name 'Cenk' for future messages"
        },
        {
            "message": "İngilizce öğreniyorum ve pratik yapmak istiyorum.",
            "expectation": "Should remember user is learning English"
        },
        {
            "message": "Benim adım neydi?",
            "expectation": "Should remember and respond with 'Cenk'"
        },
        {
            "message": "Hangi dili öğrenmeye çalıştığımı hatırlıyor musun?",
            "expectation": "Should remember 'English'"
        }
    ]
    
    print("🧪 Testing Conversation History & Memory System")
    print("=" * 60)
    print(f"👤 Test User ID: {test_user_id}")
    
    # Clear any existing history first
    try:
        clear_url = f"http://localhost:8000/api/ai/conversation-history/{test_user_id}"
        requests.delete(clear_url)
        print("🧹 Cleared existing conversation history")
    except:
        pass
    
    print("\n📝 Starting conversation sequence...\n")
    
    for i, step in enumerate(conversation_sequence, 1):
        print(f"{i}. Testing Memory: {step['expectation']}")
        print("-" * 50)
        
        # Prepare request data
        data = {
            "message": step["message"],
            "language": "english",
            "level": "A1",
            "user_id": test_user_id,
            "communication_language": "turkish"
        }
        
        try:
            response = requests.post(base_url, json=data, headers=headers)
            
            if response.status_code == 200:
                result = response.json()
                ai_response = result.get('response', 'No response')
                
                print(f"👤 User: \"{step['message']}\"")
                print(f"🤖 AI Response: \"{ai_response}\"")
                
                # Analyze if AI remembered previous context
                if i == 3:  # Name question
                    remembers_name = 'cenk' in ai_response.lower() or 'Cenk' in ai_response
                    print(f"🧠 Remembers name: {'✅ Yes' if remembers_name else '❌ No'}")
                elif i == 4:  # Language question  
                    remembers_language = any(word in ai_response.lower() for word in ['english', 'ingilizce', 'İngilizce'])
                    print(f"🧠 Remembers language: {'✅ Yes' if remembers_language else '❌ No'}")
                
            else:
                print(f"❌ HTTP Error: {response.status_code}")
                print(f"Response: {response.text}")
                
        except Exception as e:
            print(f"❌ Request failed: {e}")
        
        print()
    
    # Test conversation history retrieval
    print("📚 Testing conversation history retrieval...")
    print("-" * 50)
    
    try:
        history_url = f"http://localhost:8000/api/ai/conversation-history/{test_user_id}"
        history_response = requests.get(history_url)
        
        if history_response.status_code == 200:
            history_data = history_response.json()
            history = history_data.get('history', [])
            
            print(f"📊 Total messages in history: {len(history)}")
            print(f"👤 User messages: {len([msg for msg in history if msg.get('role') == 'User'])}")
            print(f"🤖 AI messages: {len([msg for msg in history if msg.get('role') == 'Assistant'])}")
            
            if history:
                print("\n📜 Last few messages:")
                for msg in history[-4:]:  # Show last 4 messages
                    role_icon = "👤" if msg.get('role') == 'User' else "🤖"
                    print(f"  {role_icon} {msg.get('role', 'Unknown')}: \"{msg.get('content', '')[:50]}...\"")
        else:
            print(f"❌ Failed to retrieve history: {history_response.status_code}")
            
    except Exception as e:
        print(f"❌ History retrieval failed: {e}")

if __name__ == "__main__":
    print("🚀 Starting conversation history test...")
    print("⚠️  Make sure backend server is running on http://localhost:8000")
    print()
    test_conversation_history_system()
    print("\n✅ Conversation history test completed!")
