"""
Pytest fixtures — in-memory SQLite test database + FastAPI TestClient.
"""
import sys
import os

# Proje kökünü path'e ekle
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from main import app
from app.database import get_db
from app.utils.database import Base
from app.models import models as _models  # noqa: F401 — modelleri Base'e kaydet

# In-memory SQLite (testler arası izole)
SQLALCHEMY_TEST_URL = "sqlite:///:memory:"

engine = create_engine(
    SQLALCHEMY_TEST_URL,
    connect_args={"check_same_thread": False},
)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


@pytest.fixture(scope="session", autouse=True)
def create_tables():
    """Session başında tabloları oluştur, sonunda kaldır."""
    Base.metadata.create_all(bind=engine)
    yield
    Base.metadata.drop_all(bind=engine)


@pytest.fixture()
def db_session():
    """Her test için temiz bir DB session döndürür."""
    connection = engine.connect()
    transaction = connection.begin()
    session = TestingSessionLocal(bind=connection)
    yield session
    session.close()
    transaction.rollback()
    connection.close()


@pytest.fixture()
def client(db_session):
    """Her test için DI override'lı TestClient döndürür."""

    def override_get_db():
        try:
            yield db_session
        finally:
            pass

    app.dependency_overrides[get_db] = override_get_db
    with TestClient(app) as c:
        yield c
    app.dependency_overrides.clear()


@pytest.fixture()
def registered_user(client):
    """Kayıtlı test kullanıcısı + token döndürür."""
    resp = client.post(
        "/auth/register",
        json={
            "email": "test@example.com",
            "password": "testpass123",
            "username": "testuser",
        },
    )
    assert resp.status_code == 200
    return resp.json()


@pytest.fixture()
def auth_headers(registered_user):
    """Bearer token header'ı döndürür."""
    token = registered_user["token"]
    return {"Authorization": f"Bearer {token}"}
