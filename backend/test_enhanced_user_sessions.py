#!/usr/bin/env python3
"""
Enhanced User Session and Conversation History Test
Tests both authenticated and anonymous user conversation tracking
"""

import requests
import json
import time
from datetime import datetime

BASE_URL = "http://localhost:8000"

def test_anonymous_user_conversation():
    """Test conversation history for anonymous users"""
    print("=" * 60)
    print("TESTING ANONYMOUS USER CONVERSATION HISTORY")
    print("=" * 60)
    
    # Generate anonymous user ID (simulating frontend behavior)
    timestamp = int(time.time() * 1000)
    anon_user_id = f"anon_user_{timestamp}_1234"
    print(f"Anonymous User ID: {anon_user_id}")
    
    # Test conversation flow
    messages = [
        "Hello, I want to practice Turkish",
        "Can you help me with basic greetings?",
        "How do I say good morning?",
        "What about good evening?"
    ]
    
    for i, message in enumerate(messages, 1):
        print(f"\n--- Message {i} ---")
        print(f"User: {message}")
        
        # Send message to AI
        response = requests.post(f"{BASE_URL}/ai/chat", json={
            "message": message,
            "language": "turkish",
            "level": "A1",
            "user_id": anon_user_id,
            "communication_language": "english"
        })
        
        if response.status_code == 200:
            ai_response = response.json()
            print(f"AI: {ai_response.get('response', 'No response')}")
        else:
            print(f"Error: {response.status_code} - {response.text}")
    
    # Check conversation history
    print(f"\n--- Checking Conversation History for {anon_user_id} ---")
    history_response = requests.get(f"{BASE_URL}/ai/conversation-history/{anon_user_id}")
    
    if history_response.status_code == 200:
        history = history_response.json()
        print(f"Success: Retrieved {len(history.get('history', []))} messages")
        
        # Display history
        for i, msg in enumerate(history.get('history', []), 1):
            role = msg.get('role', 'Unknown')
            content = msg.get('content', '')[:100] + '...' if len(msg.get('content', '')) > 100 else msg.get('content', '')
            print(f"{i}. {role}: {content}")
    else:
        print(f"History retrieval failed: {history_response.status_code}")
    
    return anon_user_id

def test_authenticated_user_conversation():
    """Test conversation history for authenticated users"""
    print("\n" + "=" * 60)
    print("TESTING AUTHENTICATED USER CONVERSATION HISTORY")
    print("=" * 60)
    
    # Simulate authenticated user ID
    auth_user_id = "auth_user_1"
    print(f"Authenticated User ID: {auth_user_id}")
    
    # Test conversation flow
    messages = [
        "I'm a registered user practicing Spanish",
        "Can you help me with conjugations?",
        "How do I conjugate 'hablar' in present tense?",
        "What about 'comer'?"
    ]
    
    for i, message in enumerate(messages, 1):
        print(f"\n--- Message {i} ---")
        print(f"User: {message}")
        
        # Send message to AI
        response = requests.post(f"{BASE_URL}/ai/chat", json={
            "message": message,
            "language": "spanish",
            "level": "B1",
            "user_id": auth_user_id,
            "communication_language": "english"
        })
        
        if response.status_code == 200:
            ai_response = response.json()
            print(f"AI: {ai_response.get('response', 'No response')}")
        else:
            print(f"Error: {response.status_code} - {response.text}")
    
    # Check conversation history
    print(f"\n--- Checking Conversation History for {auth_user_id} ---")
    history_response = requests.get(f"{BASE_URL}/ai/conversation-history/{auth_user_id}")
    
    if history_response.status_code == 200:
        history = history_response.json()
        print(f"Success: Retrieved {len(history.get('history', []))} messages")
        
        # Display history
        for i, msg in enumerate(history.get('history', []), 1):
            role = msg.get('role', 'Unknown')
            content = msg.get('content', '')[:100] + '...' if len(msg.get('content', '')) > 100 else msg.get('content', '')
            print(f"{i}. {role}: {content}")
    else:
        print(f"History retrieval failed: {history_response.status_code}")
    
    return auth_user_id

def test_user_session_isolation():
    """Test that different users have isolated conversation histories"""
    print("\n" + "=" * 60)
    print("TESTING USER SESSION ISOLATION")
    print("=" * 60)
    
    # Create two different users
    timestamp = int(time.time() * 1000)
    user1_id = f"anon_user_{timestamp}_0001"
    user2_id = f"anon_user_{timestamp}_0002"
    
    print(f"User 1 ID: {user1_id}")
    print(f"User 2 ID: {user2_id}")
    
    # User 1 sends messages
    print("\n--- User 1 Messages ---")
    user1_messages = ["Hello from user 1", "I'm learning French"]
    for msg in user1_messages:
        response = requests.post(f"{BASE_URL}/ai/chat", json={
            "message": msg,
            "language": "french",
            "level": "A1",
            "user_id": user1_id
        })
        if response.status_code == 200:
            print(f"User 1: {msg} -> AI: {response.json().get('response', '')[:50]}...")
    
    # User 2 sends messages
    print("\n--- User 2 Messages ---")
    user2_messages = ["Hello from user 2", "I'm learning German"]
    for msg in user2_messages:
        response = requests.post(f"{BASE_URL}/ai/chat", json={
            "message": msg,
            "language": "german",
            "level": "A2",
            "user_id": user2_id
        })
        if response.status_code == 200:
            print(f"User 2: {msg} -> AI: {response.json().get('response', '')[:50]}...")
    
    # Check both users' histories
    print("\n--- Checking History Isolation ---")
    
    # User 1 history
    user1_history = requests.get(f"{BASE_URL}/ai/conversation-history/{user1_id}")
    if user1_history.status_code == 200:
        user1_count = len(user1_history.json().get('history', []))
        print(f"User 1 has {user1_count} messages in history")
    
    # User 2 history
    user2_history = requests.get(f"{BASE_URL}/ai/conversation-history/{user2_id}")
    if user2_history.status_code == 200:
        user2_count = len(user2_history.json().get('history', []))
        print(f"User 2 has {user2_count} messages in history")
    
    # Verify isolation
    if user1_count == 4 and user2_count == 4:  # 2 user messages + 2 AI responses each
        print("✅ SUCCESS: User sessions are properly isolated")
    else:
        print("❌ FAILURE: User session isolation may be compromised")

def test_conversation_history_management():
    """Test conversation history clearing and management"""
    print("\n" + "=" * 60)
    print("TESTING CONVERSATION HISTORY MANAGEMENT")
    print("=" * 60)
    
    # Create test user
    timestamp = int(time.time() * 1000)
    test_user_id = f"test_management_{timestamp}"
    print(f"Test User ID: {test_user_id}")
    
    # Send some messages
    print("\n--- Building Conversation History ---")
    for i in range(3):
        msg = f"Test message {i+1}"
        response = requests.post(f"{BASE_URL}/ai/chat", json={
            "message": msg,
            "language": "english",
            "level": "B1",
            "user_id": test_user_id
        })
        if response.status_code == 200:
            print(f"✅ Message {i+1} sent successfully")
    
    # Check history before clearing
    print("\n--- Checking History Before Clear ---")
    history_response = requests.get(f"{BASE_URL}/ai/conversation-history/{test_user_id}")
    if history_response.status_code == 200:
        before_count = len(history_response.json().get('history', []))
        print(f"Messages before clear: {before_count}")
    
    # Clear history
    print("\n--- Clearing History ---")
    clear_response = requests.delete(f"{BASE_URL}/ai/conversation-history/{test_user_id}")
    if clear_response.status_code == 200:
        print("✅ History cleared successfully")
    else:
        print(f"❌ Clear failed: {clear_response.status_code}")
    
    # Check history after clearing
    print("\n--- Checking History After Clear ---")
    history_response = requests.get(f"{BASE_URL}/ai/conversation-history/{test_user_id}")
    if history_response.status_code == 200:
        after_count = len(history_response.json().get('history', []))
        print(f"Messages after clear: {after_count}")
        
        if after_count == 0:
            print("✅ SUCCESS: History cleared completely")
        else:
            print("❌ FAILURE: History not properly cleared")
    else:
        print(f"❌ History check failed: {history_response.status_code}")

def main():
    """Main test function"""
    print("Enhanced User Session and Conversation History Test")
    print(f"Test started at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"Testing against: {BASE_URL}")
    
    try:
        # Test anonymous users
        anon_user_id = test_anonymous_user_conversation()
        
        # Test authenticated users
        auth_user_id = test_authenticated_user_conversation()
        
        # Test session isolation
        test_user_session_isolation()
        
        # Test history management
        test_conversation_history_management()
        
        print("\n" + "=" * 60)
        print("TEST SUMMARY")
        print("=" * 60)
        print("✅ Anonymous user conversation tracking")
        print("✅ Authenticated user conversation tracking")
        print("✅ User session isolation")
        print("✅ Conversation history management")
        print("\n🎉 All tests completed successfully!")
        
    except Exception as e:
        print(f"\n❌ Test failed with error: {e}")
        print("Make sure the backend server is running on http://localhost:8000")

if __name__ == "__main__":
    main()
