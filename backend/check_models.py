import os
from dotenv import load_dotenv
import google.generativeai as genai

load_dotenv()
api_key = os.getenv('GEMINI_API_KEY')
genai.configure(api_key=api_key)

# Mevcut modelleri listele
models = list(genai.list_models())
print(f'Toplam model sayısı: {len(models)}')
print()
print('Mevcut model adları:')
for i, model in enumerate(models):
    print(f'{i+1:2d}. {model.name}')
    if i >= 15:  # İlk 15 modeli göster
        print('...')
        break

print('\nGeneration modelleri:')
generation_models = [m for m in models if 'generateContent' in m.supported_generation_methods]
for model in generation_models[:10]:
    print(f'- {model.name}')
