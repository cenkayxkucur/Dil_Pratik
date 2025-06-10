import requests
import json

# Test communication language functionality
url = "http://localhost:8000/api/ai/chat"

data = {
    "message": "Merhaba, İngilizce öğreniyorum",
    "language": "english",
    "level": "A1", 
    "user_id": "test_user",
    "communication_language": "turkish"
}

headers = {
    "Content-Type": "application/json"
}

print("Testing Communication Language Integration...")
print(f"Sending request to: {url}")
print(f"Data: {json.dumps(data, indent=2)}")

try:
    response = requests.post(url, json=data, headers=headers)
    print(f"\nStatus Code: {response.status_code}")
    print(f"Response: {response.text}")
    
    if response.status_code == 200:
        result = response.json()
        print(f"\nAI Response: {result.get('response', 'No response')}")
        print(f"Success: {result.get('success', False)}")
    
except Exception as e:
    print(f"Error: {e}")
