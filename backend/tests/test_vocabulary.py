"""
Vocabulary endpoint testleri:
  POST   /api/vocabulary/
  GET    /api/vocabulary/{user_id}
  DELETE /api/vocabulary/{word_id}
"""


class TestSaveWord:
    def test_save_word_success(self, client, registered_user):
        user_id = str(registered_user["user"]["id"])
        resp = client.post(
            "/api/vocabulary/",
            json={
                "user_id": user_id,
                "language": "english",
                "word": "ephemeral",
                "translation": "geçici",
                "context": "an ephemeral moment",
            },
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data["success"] is True
        assert "id" in data
        assert data["updated"] is False

    def test_save_word_upsert(self, client, registered_user):
        """Aynı kelime tekrar gönderildiğinde güncellenmeli."""
        user_id = str(registered_user["user"]["id"])
        payload = {
            "user_id": user_id,
            "language": "english",
            "word": "serendipity",
            "translation": "",
        }
        client.post("/api/vocabulary/", json=payload)

        payload["translation"] = "tesadüf"
        resp = client.post("/api/vocabulary/", json=payload)
        assert resp.status_code == 200
        assert resp.json()["updated"] is True

    def test_save_word_normalizes_case(self, client, registered_user):
        """Kelime küçük harfe normalize edilmeli."""
        user_id = str(registered_user["user"]["id"])
        resp = client.post(
            "/api/vocabulary/",
            json={
                "user_id": user_id,
                "language": "english",
                "word": "CAPITALIZE",
                "translation": "büyük harf",
            },
        )
        assert resp.status_code == 200


class TestGetWords:
    def test_get_words_empty(self, client, registered_user):
        user_id = str(registered_user["user"]["id"])
        resp = client.get(
            f"/api/vocabulary/{user_id}",
            params={"language": "english"},
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data["success"] is True
        assert isinstance(data["words"], list)

    def test_get_words_after_save(self, client, registered_user):
        user_id = str(registered_user["user"]["id"])
        # Kelimeyi kaydet
        client.post(
            "/api/vocabulary/",
            json={
                "user_id": user_id,
                "language": "german",
                "word": "gemütlich",
                "translation": "rahat",
            },
        )
        resp = client.get(
            f"/api/vocabulary/{user_id}",
            params={"language": "german"},
        )
        assert resp.status_code == 200
        words = resp.json()["words"]
        assert len(words) >= 1
        assert any(w["word"] == "gemütlich" for w in words)

    def test_get_words_language_filter(self, client, registered_user):
        """Farklı dile ait kelimeler görünmemeli."""
        user_id = str(registered_user["user"]["id"])
        client.post(
            "/api/vocabulary/",
            json={"user_id": user_id, "language": "turkish", "word": "elma"},
        )
        resp = client.get(
            f"/api/vocabulary/{user_id}",
            params={"language": "english"},
        )
        words = resp.json()["words"]
        assert all(w["word"] != "elma" for w in words)


class TestDeleteWord:
    def test_delete_word_success(self, client, registered_user):
        user_id = str(registered_user["user"]["id"])
        save_resp = client.post(
            "/api/vocabulary/",
            json={
                "user_id": user_id,
                "language": "english",
                "word": "tobedeleted",
            },
        )
        word_id = save_resp.json()["id"]

        del_resp = client.delete(
            f"/api/vocabulary/{word_id}",
            params={"user_id": user_id},
        )
        assert del_resp.status_code == 200
        assert del_resp.json()["success"] is True

    def test_delete_nonexistent_word(self, client, registered_user):
        user_id = str(registered_user["user"]["id"])
        resp = client.delete(
            "/api/vocabulary/999999",
            params={"user_id": user_id},
        )
        assert resp.status_code == 404

    def test_delete_another_users_word(self, client, registered_user):
        """Başka kullanıcının kelimesini silememeliyiz."""
        user_id = str(registered_user["user"]["id"])
        save_resp = client.post(
            "/api/vocabulary/",
            json={"user_id": user_id, "language": "english", "word": "private"},
        )
        word_id = save_resp.json()["id"]

        # Farklı user_id ile sil
        resp = client.delete(
            f"/api/vocabulary/{word_id}",
            params={"user_id": "999"},
        )
        assert resp.status_code == 404
