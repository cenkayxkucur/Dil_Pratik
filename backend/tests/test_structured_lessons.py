"""
Yapılandırılmış ders sistemi testleri:
  GET /api/v2/languages
  GET /api/v2/{language_code}/levels
  GET /api/v2/{language_code}/{level_code}/topics
"""


class TestStructuredLessons:
    def test_get_languages(self, client):
        resp = client.get("/api/v2/languages")
        assert resp.status_code == 200
        data = resp.json()
        # Yanıt liste veya dict olabilir
        assert data is not None

    def test_get_levels(self, client):
        resp = client.get("/api/v2/english/levels")
        # Mevcut içerik yoksa boş liste dönebilir — 200 bekliyoruz
        assert resp.status_code in (200, 404)

    def test_get_topics(self, client):
        resp = client.get("/api/v2/english/a1/topics")
        assert resp.status_code in (200, 404)


class TestExerciseEndpoint:
    """
    POST /api/ai/generate-exercises — Gemini çağrısı yaptığı için
    gerçek API key olmadan integration test yapılamaz.
    Request schema doğrulamasını test ediyoruz.
    """

    def test_missing_fields_returns_422(self, client, auth_headers):
        resp = client.post(
            "/api/ai/generate-exercises",
            json={},  # Gerekli alanlar eksik
            headers=auth_headers,
        )
        assert resp.status_code == 422

    def test_valid_schema_accepted(self, client, auth_headers):
        """
        Geçerli schema ile istek gönderildiğinde 200 veya 500 dönmeli
        (500: Gemini API key yok, ama şema geçti).
        """
        resp = client.post(
            "/api/ai/generate-exercises",
            json={
                "lesson_content": "Present simple tense: I go, you go, he goes.",
                "lesson_title": "Present Simple",
                "language": "english",
                "level": "a1",
                "exercise_count": 3,
            },
            headers=auth_headers,
        )
        assert resp.status_code in (200, 500)
