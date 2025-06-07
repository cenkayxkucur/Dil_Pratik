import requests
import json

# Test health endpoint
try:
    response = requests.get("http://127.0.0.1:8000/health")
    print(f"Health check: {response.status_code} - {response.json()}")
except Exception as e:
    print(f"Health check failed: {e}")

# Test AI chat endpoint
try:
    payload = {
        "message": "Merhaba, Türkçe öğreniyorum. Nasılsın?",
        "language": "turkish",
        "level": "A1",
        "user_id": "test-user-123"
    }
    
    response = requests.post(
        "http://127.0.0.1:8000/api/ai/chat",
        json=payload,
        headers={"Content-Type": "application/json"}
    )
    
    print(f"AI Chat Status: {response.status_code}")
    print(f"AI Chat Response: {response.text}")
    
except Exception as e:
    print(f"AI Chat test failed: {e}")
