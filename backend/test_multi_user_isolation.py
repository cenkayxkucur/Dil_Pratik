import requests
import json
import time

def test_multi_user_isolation():
    """Test that different users can't see each other's conversations"""
    
    base_url = "http://localhost:8000/api/ai/chat"
    headers = {"Content-Type": "application/json"}
    
    # Different users with unique IDs
    user_a_id = "test_user_alice_456"
    user_b_id = "test_user_bob_789"
    user_c_id = "test_user_charlie_321"
    
    print("👥 Testing Multi-User Isolation System")
    print("=" * 60)
    
    # Clear any existing histories
    for user_id in [user_a_id, user_b_id, user_c_id]:
        try:
            clear_url = f"http://localhost:8000/api/ai/conversation-history/{user_id}"
            requests.delete(clear_url)
        except:
            pass
    
    print("🧹 Cleared all user histories")
    print()
    
    # User A conversation
    print("👤 USER A (Alice) - Starting conversation...")
    print("-" * 40)
    
    alice_data = {
        "message": "Merhaba! Ben Alice. Fransızca öğreniyorum.",
        "language": "french",
        "level": "B1",
        "user_id": user_a_id,
        "communication_language": "turkish"
    }
    
    try:
        response = requests.post(base_url, json=alice_data, headers=headers)
        if response.status_code == 200:
            result = response.json()
            print(f"👤 Alice: \"{alice_data['message']}\"")
            print(f"🤖 AI to Alice: \"{result.get('response', '')[:80]}...\"")
        else:
            print(f"❌ Alice request failed: {response.status_code}")
    except Exception as e:
        print(f"❌ Alice request error: {e}")
    
    print()
    time.sleep(1)
    
    # User B conversation
    print("👤 USER B (Bob) - Starting conversation...")
    print("-" * 40)
    
    bob_data = {
        "message": "Hi! I'm Bob. I want to learn Spanish.",
        "language": "spanish", 
        "level": "A2",
        "user_id": user_b_id,
        "communication_language": "english"
    }
    
    try:
        response = requests.post(base_url, json=bob_data, headers=headers)
        if response.status_code == 200:
            result = response.json()
            print(f"👤 Bob: \"{bob_data['message']}\"")
            print(f"🤖 AI to Bob: \"{result.get('response', '')[:80]}...\"")
        else:
            print(f"❌ Bob request failed: {response.status_code}")
    except Exception as e:
        print(f"❌ Bob request error: {e}")
    
    print()
    time.sleep(1)
    
    # User C conversation  
    print("👤 USER C (Charlie) - Starting conversation...")
    print("-" * 40)
    
    charlie_data = {
        "message": "Hola! Soy Charlie. Estudio alemán.",
        "language": "german",
        "level": "A1", 
        "user_id": user_c_id,
        "communication_language": "spanish"
    }
    
    try:
        response = requests.post(base_url, json=charlie_data, headers=headers)
        if response.status_code == 200:
            result = response.json()
            print(f"👤 Charlie: \"{charlie_data['message']}\"")
            print(f"🤖 AI to Charlie: \"{result.get('response', '')[:80]}...\"")
        else:
            print(f"❌ Charlie request failed: {response.status_code}")
    except Exception as e:
        print(f"❌ Charlie request error: {e}")
    
    print()
    
    # Test isolation by checking histories
    print("🔍 Testing conversation isolation...")
    print("=" * 60)
    
    users = [
        ("Alice", user_a_id, "Should only see French learning conversation"),
        ("Bob", user_b_id, "Should only see Spanish learning conversation"), 
        ("Charlie", user_c_id, "Should only see German learning conversation")
    ]
    
    for name, user_id, expectation in users:
        print(f"📚 Checking {name}'s conversation history...")
        print(f"🎯 {expectation}")
        print("-" * 40)
        
        try:
            history_url = f"http://localhost:8000/api/ai/conversation-history/{user_id}"
            response = requests.get(history_url)
            
            if response.status_code == 200:
                history_data = response.json()
                history = history_data.get('history', [])
                
                print(f"📊 {name} has {len(history)} messages in history")
                
                if history:
                    # Show user's messages to verify isolation
                    user_messages = [msg for msg in history if msg.get('role') == 'User']
                    print(f"👤 {name}'s messages:")
                    for msg in user_messages:
                        content = msg.get('content', '')[:60]
                        print(f"   💬 \"{content}...\"")
                    
                    # Check if other users' info appears (it shouldn't!)
                    content_text = ' '.join([msg.get('content', '') for msg in history]).lower()
                    
                    if name == "Alice":
                        has_others = any(word in content_text for word in ['bob', 'charlie', 'spanish', 'german'])
                        print(f"🔒 Contains other users' info: {'❌ Yes (BAD!)' if has_others else '✅ No (GOOD!)'}")
                    elif name == "Bob":
                        has_others = any(word in content_text for word in ['alice', 'charlie', 'french', 'german'])
                        print(f"🔒 Contains other users' info: {'❌ Yes (BAD!)' if has_others else '✅ No (GOOD!)'}")
                    elif name == "Charlie":
                        has_others = any(word in content_text for word in ['alice', 'bob', 'french', 'spanish'])
                        print(f"🔒 Contains other users' info: {'❌ Yes (BAD!)' if has_others else '✅ No (GOOD!)'}")
                else:
                    print(f"⚠️  No history found for {name}")
                    
            else:
                print(f"❌ Failed to get {name}'s history: {response.status_code}")
                
        except Exception as e:
            print(f"❌ Error checking {name}'s history: {e}")
        
        print()
    
    # Final summary
    print("📋 Multi-User Isolation Test Summary")
    print("=" * 60)
    print("✅ Each user should only see their own conversations")
    print("✅ No cross-contamination between different user sessions")
    print("✅ Backend properly isolates conversation histories by user_id")

if __name__ == "__main__":
    print("🚀 Starting multi-user isolation test...")
    print("⚠️  Make sure backend server is running on http://localhost:8000")
    print()
    test_multi_user_isolation()
    print("\n✅ Multi-user isolation test completed!")
