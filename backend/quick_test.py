import requests
import json

def quick_conversation_test():
    """Quick test to verify conversation history is working"""
    
    base_url = "http://localhost:8000/api/ai/chat"
    headers = {"Content-Type": "application/json"}
    user_id = "quick_test_user"
    
    print("🧪 Quick Conversation History Test")
    print("=" * 40)
    
    # Message 1: Introduce name
    print("1️⃣ Introducing name...")
    data1 = {
        "message": "Merhaba! Benim adım Cenk ve İngilizce öğreniyorum.",
        "language": "english",
        "level": "A1", 
        "user_id": user_id,
        "communication_language": "turkish"
    }
    
    try:
        response1 = requests.post(base_url, json=data1, headers=headers)
        if response1.status_code == 200:
            result1 = response1.json()
            print(f"✅ Response received: {len(result1.get('response', ''))} characters")
        else:
            print(f"❌ Failed: {response1.status_code}")
    except Exception as e:
        print(f"❌ Error: {e}")
    
    # Message 2: Ask about name
    print("\n2️⃣ Testing memory...")
    data2 = {
        "message": "Benim adım neydi?",
        "language": "english",
        "level": "A1",
        "user_id": user_id, 
        "communication_language": "turkish"
    }
    
    try:
        response2 = requests.post(base_url, json=data2, headers=headers)
        if response2.status_code == 200:
            result2 = response2.json()
            ai_response = result2.get('response', '')
            remembers_name = 'cenk' in ai_response.lower() or 'Cenk' in ai_response
            
            print(f"🤖 AI Response: {ai_response}")
            print(f"🧠 Remembers 'Cenk': {'✅ YES' if remembers_name else '❌ NO'}")
            
            # Additional check
            if remembers_name:
                print("🎉 CONVERSATION HISTORY IS WORKING!")
            else:
                print("⚠️ Conversation history might not be working properly")
        else:
            print(f"❌ Failed: {response2.status_code}")
    except Exception as e:
        print(f"❌ Error: {e}")
    
    # Check history endpoint
    print("\n3️⃣ Checking history endpoint...")
    try:
        history_url = f"http://localhost:8000/api/ai/conversation-history/{user_id}"
        history_response = requests.get(history_url)
        
        if history_response.status_code == 200:
            history_data = history_response.json()
            history = history_data.get('history', [])
            print(f"📚 Total messages stored: {len(history)}")
            
            if len(history) >= 4:  # 2 user + 2 AI messages
                print("✅ History storage is working!")
            else:
                print("⚠️ History might not be storing correctly")
        else:
            print(f"❌ History endpoint failed: {history_response.status_code}")
    except Exception as e:
        print(f"❌ History check error: {e}")

if __name__ == "__main__":
    quick_conversation_test()
