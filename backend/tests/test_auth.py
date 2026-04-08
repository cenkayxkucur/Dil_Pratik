"""
Auth endpoint testleri:
  POST /auth/register
  POST /auth/login
  POST /auth/refresh
  GET  /auth/me
  POST /auth/logout
"""


def test_health(client):
    resp = client.get("/health")
    assert resp.status_code == 200
    assert resp.json()["status"] == "healthy"


class TestRegister:
    def test_register_success(self, client):
        resp = client.post(
            "/auth/register",
            json={
                "email": "newuser@example.com",
                "password": "password123",
                "username": "newuser",
            },
        )
        assert resp.status_code == 200
        data = resp.json()
        assert "token" in data
        assert "refresh_token" in data
        assert data["user"]["email"] == "newuser@example.com"
        assert data["user"]["username"] == "newuser"

    def test_register_duplicate_email(self, client, registered_user):
        resp = client.post(
            "/auth/register",
            json={
                "email": "test@example.com",
                "password": "anotherpass",
                "username": "anotheruser",
            },
        )
        assert resp.status_code == 400
        assert "e-posta" in resp.json()["detail"].lower()

    def test_register_duplicate_username(self, client, registered_user):
        resp = client.post(
            "/auth/register",
            json={
                "email": "other@example.com",
                "password": "somepass",
                "username": "testuser",
            },
        )
        assert resp.status_code == 400
        assert "kullanıcı adı" in resp.json()["detail"].lower()


class TestLogin:
    def test_login_success(self, client, registered_user):
        resp = client.post(
            "/auth/login",
            json={"email": "test@example.com", "password": "testpass123"},
        )
        assert resp.status_code == 200
        data = resp.json()
        assert "token" in data
        assert "refresh_token" in data

    def test_login_wrong_password(self, client, registered_user):
        resp = client.post(
            "/auth/login",
            json={"email": "test@example.com", "password": "wrongpass"},
        )
        assert resp.status_code == 401

    def test_login_unknown_email(self, client):
        resp = client.post(
            "/auth/login",
            json={"email": "nobody@example.com", "password": "pass"},
        )
        assert resp.status_code == 401


class TestRefreshToken:
    def test_refresh_success(self, client, registered_user):
        refresh_token = registered_user["refresh_token"]
        resp = client.post(
            "/auth/refresh",
            json={"refresh_token": refresh_token},
        )
        assert resp.status_code == 200
        data = resp.json()
        assert "token" in data
        assert "refresh_token" in data

    def test_refresh_invalid_token(self, client):
        resp = client.post(
            "/auth/refresh",
            json={"refresh_token": "this.is.invalid"},
        )
        assert resp.status_code == 401

    def test_refresh_with_access_token_fails(self, client, registered_user):
        """Access token'ı refresh olarak kullanmak 401 döndürmeli."""
        access_token = registered_user["token"]
        resp = client.post(
            "/auth/refresh",
            json={"refresh_token": access_token},
        )
        assert resp.status_code == 401


class TestGetMe:
    def test_get_me_success(self, client, auth_headers):
        resp = client.get("/auth/me", headers=auth_headers)
        assert resp.status_code == 200
        data = resp.json()
        assert "user" in data
        assert data["user"]["email"] == "test@example.com"

    def test_get_me_no_token(self, client):
        resp = client.get("/auth/me")
        assert resp.status_code == 403  # HTTPBearer returns 403 when missing

    def test_get_me_invalid_token(self, client):
        resp = client.get(
            "/auth/me",
            headers={"Authorization": "Bearer invalid.token.here"},
        )
        assert resp.status_code == 401


class TestLogout:
    def test_logout(self, client, auth_headers):
        resp = client.post("/auth/logout", headers=auth_headers)
        assert resp.status_code == 200
