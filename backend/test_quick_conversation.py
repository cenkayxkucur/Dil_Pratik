#!/usr/bin/env python3
"""
Quick test to verify backend conversation history system works correctly
Tests the AI service conversation memory functionality
"""

import requests
import json

BASE_URL = "http://localhost:8000/api"

def test_basic_conversation_memory():
    """Test basic conversation memory functionality"""
    print("Testing Basic Conversation Memory...")
    
    # Test with a simple conversation
    user_id = "test_user_123"
    
    # First message
    print("\n1. First message:")
    response1 = requests.post(f"{BASE_URL}/ai/chat", json={
        "message": "My name is Alice",
        "language": "english",
        "level": "B1",
        "user_id": user_id
    })
    
    if response1.status_code == 200:
        ai_response1 = response1.json()
        print(f"✅ Response: {ai_response1.get('response', 'No response')[:100]}...")
    else:
        print(f"❌ Error: {response1.status_code}")
        return False
    
    # Second message - should remember the name
    print("\n2. Second message (testing memory):")
    response2 = requests.post(f"{BASE_URL}/ai/chat", json={
        "message": "What is my name?",
        "language": "english",
        "level": "B1",
        "user_id": user_id
    })
    
    if response2.status_code == 200:
        ai_response2 = response2.json()
        response_text = ai_response2.get('response', '')
        print(f"✅ Response: {response_text[:100]}...")
        
        # Check if AI remembers the name
        if "alice" in response_text.lower():
            print("🎉 SUCCESS: AI remembered the name!")
            return True
        else:
            print("⚠️  WARNING: AI may not have remembered the name")
            return False
    else:
        print(f"❌ Error: {response2.status_code}")
        return False

def test_conversation_history_api():
    """Test conversation history API endpoints"""
    print("\nTesting Conversation History API...")
    
    user_id = "test_api_user_456"
    
    # Send a message first
    print("1. Sending test message...")
    response = requests.post(f"{BASE_URL}/ai/chat", json={
        "message": "Hello, this is a test message",
        "language": "english",
        "level": "A1",
        "user_id": user_id
    })
    
    if response.status_code != 200:
        print(f"❌ Failed to send message: {response.status_code}")
        return False
    
    print("✅ Message sent successfully")
    
    # Get conversation history
    print("2. Retrieving conversation history...")
    history_response = requests.get(f"{BASE_URL}/ai/conversation-history/{user_id}")
    
    if history_response.status_code == 200:
        history_data = history_response.json()
        history = history_data.get('history', [])
        print(f"✅ Retrieved {len(history)} messages")
        
        # Display history
        for i, msg in enumerate(history, 1):
            role = msg.get('role', 'Unknown')
            content = msg.get('content', '')[:50] + '...' if len(msg.get('content', '')) > 50 else msg.get('content', '')
            print(f"   {i}. {role}: {content}")
        
        return len(history) > 0
    else:
        print(f"❌ Failed to retrieve history: {history_response.status_code}")
        return False

def test_history_clearing():
    """Test conversation history clearing"""
    print("\nTesting History Clearing...")
    
    user_id = "test_clear_user_789"
    
    # Send some messages
    print("1. Building conversation history...")
    for i in range(2):
        response = requests.post(f"{BASE_URL}/ai/chat", json={
            "message": f"Test message {i+1}",
            "language": "english",
            "level": "A1",
            "user_id": user_id
        })
        if response.status_code == 200:
            print(f"   ✅ Message {i+1} sent")
        else:
            print(f"   ❌ Message {i+1} failed")
    
    # Check history before clearing
    print("2. Checking history before clear...")
    history_response = requests.get(f"{BASE_URL}/ai/conversation-history/{user_id}")
    if history_response.status_code == 200:
        before_count = len(history_response.json().get('history', []))
        print(f"   Messages before clear: {before_count}")
    else:
        print("   ❌ Failed to check history")
        return False
    
    # Clear history
    print("3. Clearing history...")
    clear_response = requests.delete(f"{BASE_URL}/ai/conversation-history/{user_id}")
    if clear_response.status_code == 200:
        print("   ✅ History cleared successfully")
    else:
        print(f"   ❌ Clear failed: {clear_response.status_code}")
        return False
    
    # Check history after clearing
    print("4. Checking history after clear...")
    history_response = requests.get(f"{BASE_URL}/ai/conversation-history/{user_id}")
    if history_response.status_code == 200:
        after_count = len(history_response.json().get('history', []))
        print(f"   Messages after clear: {after_count}")
        
        if after_count == 0:
            print("   🎉 SUCCESS: History cleared completely")
            return True
        else:
            print("   ⚠️  WARNING: History not completely cleared")
            return False
    else:
        print("   ❌ Failed to check history after clear")
        return False

def main():
    """Run all tests"""
    print("Quick Conversation Memory Test")
    print("=" * 40)
    
    results = []
    
    # Test 1: Basic conversation memory
    results.append(test_basic_conversation_memory())
    
    # Test 2: Conversation history API
    results.append(test_conversation_history_api())
    
    # Test 3: History clearing
    results.append(test_history_clearing())
    
    # Summary
    print("\n" + "=" * 40)
    print("TEST SUMMARY")
    print("=" * 40)
    
    passed = sum(results)
    total = len(results)
    
    print(f"Tests passed: {passed}/{total}")
    
    if passed == total:
        print("🎉 All tests passed!")
    else:
        print("⚠️  Some tests failed. Check the output above.")
    
    return passed == total

if __name__ == "__main__":
    main()
