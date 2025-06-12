import requests
import json

def test_conversation_history():
    """Test conversation history tracking"""
    
    base_url = "http://localhost:8000/api/ai"
    headers = {"Content-Type": "application/json"}
    
    user_id = "test_conversation_user"
    
    conversation_flow = [
        {
            "message": "Merhaba! Benim adım John.",
            "expected_response_should_contain": ["merhaba", "john", "name"]
        },
        {
            "message": "Kaç yaşındayım biliyor musun?",
            "expected_response_should_contain": ["yaş", "john", "bilmiyor"]
        },
        {
            "message": "25 yaşındayım.",
            "expected_response_should_contain": ["25", "yaş"]
        },
        {
            "message": "Benim adımı hatırlıyor musun?",
            "expected_response_should_contain": ["john", "adın", "hatırlıyor"]
        }
    ]
    
    print("🧪 Testing Conversation History Memory")
    print("=" * 60)
    print(f"👤 User ID: {user_id}")
    print()
    
    # Clear any existing history first
    try:
        clear_response = requests.delete(f"{base_url}/conversation-history/{user_id}")
        print(f"🗑️ Cleared existing conversation history: {clear_response.status_code}")
        print()
    except:
        print("ℹ️ No existing history to clear")
        print()
    
    responses = []
    
    for i, step in enumerate(conversation_flow, 1):
        print(f"💬 Step {i}: Testing conversation memory")
        print(f"👤 User: \"{step['message']}\"")
        
        # Send message
        chat_data = {
            "message": step['message'],
            "language": "turkish",
            "level": "A1",
            "user_id": user_id,
            "communication_language": "turkish"
        }
        
        try:
            response = requests.post(f"{base_url}/chat", json=chat_data, headers=headers)
            
            if response.status_code == 200:
                result = response.json()
                ai_response = result.get('response', 'No response')
                responses.append(ai_response)
                
                print(f"🤖 AI: \"{ai_response}\"")
                
                # Check if AI remembers context
                memory_check = any(keyword.lower() in ai_response.lower() 
                                 for keyword in step['expected_response_should_contain'])
                
                if memory_check:
                    print("✅ Memory check: AI shows contextual awareness")
                else:
                    print("❌ Memory check: AI may not be using conversation history")
                
            else:
                print(f"❌ HTTP Error: {response.status_code}")
                print(f"Response: {response.text}")
                
        except Exception as e:
            print(f"❌ Request failed: {e}")
        
        print("-" * 50)
        print()
    
    # Test conversation history retrieval
    print("📚 Testing Conversation History Retrieval")
    print("-" * 50)
    
    try:
        history_response = requests.get(f"{base_url}/conversation-history/{user_id}")
        
        if history_response.status_code == 200:
            history_data = history_response.json()
            history = history_data.get('history', [])
            
            print(f"📊 Total messages in history: {len(history)}")
            print(f"👤 User messages: {len([msg for msg in history if msg['role'] == 'User'])}")
            print(f"🤖 AI messages: {len([msg for msg in history if msg['role'] == 'Assistant'])}")
            
            if len(history) >= len(conversation_flow) * 2:  # User + AI messages
                print("✅ Conversation history is being tracked correctly")
            else:
                print("❌ Conversation history may not be complete")
                
            print("\n📝 Conversation History Details:")
            for i, msg in enumerate(history):
                role_icon = "👤" if msg['role'] == 'User' else "🤖"
                print(f"  {i+1}. {role_icon} {msg['role']}: \"{msg['content'][:50]}{'...' if len(msg['content']) > 50 else ''}\"")
                
        else:
            print(f"❌ Failed to retrieve history: {history_response.status_code}")
            
    except Exception as e:
        print(f"❌ History retrieval failed: {e}")

if __name__ == "__main__":
    print("🚀 Starting conversation history test...")
    test_conversation_history()
    print("\n✅ Test completed!")
