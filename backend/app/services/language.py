from typing import List, Dict, Any
import openai
from google.cloud import texttospeech
import firebase_admin
from firebase_admin import credentials, storage

from ..utils.config import get_settings

settings = get_settings()

# Initialize OpenAI
openai.api_key = settings.OPENAI_API_KEY

# Initialize Firebase
cred = credentials.Certificate(settings.FIREBASE_CREDENTIALS)
firebase_admin.initialize_app(cred, {
    'storageBucket': 'your-bucket-name.appspot.com'
})
bucket = storage.bucket()

# Initialize Text-to-Speech
tts_client = texttospeech.TextToSpeechClient()


async def generate_lesson_content(
    language: str,
    difficulty: str,
    topic: str = None
) -> Dict[str, Any]:
    """Generate a language learning lesson using OpenAI."""
    prompt = f"""Create a language learning lesson in {language} for {difficulty} level students.
    {f'The topic should be about: {topic}' if topic else 'Choose an interesting topic.'}
    
    Include:
    1. A dialogue or text (100-150 words)
    2. 5 key vocabulary words with translations
    3. 3 grammar points explained
    4. 5 practice questions
    
    Format the response as a JSON object with these keys:
    - title
    - content (the dialogue/text)
    - vocabulary (list of dict with 'word', 'translation', 'example')
    - grammar (list of dict with 'point', 'explanation', 'example')
    - questions (list of dict with 'question', 'correct_answer', 'options')
    """

    response = await openai.ChatCompletion.acreate(
        model="gpt-4",
        messages=[
            {"role": "system", "content": "You are a language learning expert."},
            {"role": "user", "content": prompt}
        ]
    )

    return response.choices[0].message.content


async def generate_speech(text: str, language_code: str) -> str:
    """Generate speech from text and upload to Firebase Storage."""
    
    # Configure the voice request
    voice = texttospeech.VoiceSelectionParams(
        language_code=language_code,
        ssml_gender=texttospeech.SsmlVoiceGender.NEUTRAL
    )

    # Configure the audio encoding
    audio_config = texttospeech.AudioConfig(
        audio_encoding=texttospeech.AudioEncoding.MP3
    )

    # Perform the text-to-speech request
    synthesis_input = texttospeech.SynthesisInput(text=text)
    response = tts_client.synthesize_speech(
        input=synthesis_input,
        voice=voice,
        audio_config=audio_config
    )

    # Upload to Firebase Storage
    blob = bucket.blob(f"audio/{hash(text)}.mp3")
    blob.upload_from_string(
        response.audio_content,
        content_type="audio/mpeg"
    )

    # Make the blob publicly accessible
    blob.make_public()

    return blob.public_url


async def evaluate_answer(
    user_answer: str,
    correct_answer: str,
    language: str
) -> Dict[str, Any]:
    """Evaluate user's answer using OpenAI."""
    
    prompt = f"""Evaluate this language learning answer:
    Language: {language}
    Correct answer: {correct_answer}
    User's answer: {user_answer}

    Provide feedback in JSON format with:
    - score (0-100)
    - is_correct (boolean)
    - feedback (constructive feedback in English)
    - corrections (list of corrections if any)
    """

    response = await openai.ChatCompletion.acreate(
        model="gpt-4",
        messages=[
            {"role": "system", "content": "You are a language learning evaluator."},
            {"role": "user", "content": prompt}
        ]
    )

    return response.choices[0].message.content
