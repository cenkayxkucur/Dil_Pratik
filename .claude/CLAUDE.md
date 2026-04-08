# Dil Pratik - CLAUDE.md

## Proje Özeti

"Dil Pratik", Google Gemini AI destekli çok dilli bir dil öğrenme platformudur.
Kullanıcılar AI ile konuşma pratiği yapabilir, dersler takip edebilir, sesli etkileşim kurabilir
ve ilerleme istatistiklerini görebilir.

## Mimari

```
Dil_Pratik/
├── backend/          # Python FastAPI API sunucusu
│   ├── app/
│   │   ├── api/      # Endpoint'ler (ai, auth, lesson, conversation, grammar...)
│   │   ├── models/   # SQLAlchemy ORM modelleri
│   │   ├── schemas/  # Pydantic şemaları
│   │   ├── services/ # İş mantığı (ai_service, vb.)
│   │   └── utils/    # Yardımcı araçlar
│   ├── main.py       # FastAPI uygulama giriş noktası
│   └── requirements.txt
├── frontend/         # Flutter uygulaması (Web + Mobile)
│   └── lib/
│       ├── models/   # Dart veri modelleri (freezed)
│       ├── providers/# Riverpod state yönetimi
│       ├── screens/  # UI ekranlar
│       ├── services/ # API, ses, TTS servisleri
│       └── widgets/  # Yeniden kullanılabilir bileşenler
└── docs/
```

## Teknoloji Stack

### Backend

- **FastAPI** (Python) — REST API
- **SQLAlchemy** + **PostgreSQL** — ORM ve veritabanı
- **Google Gemini 1.5 Flash** — AI dil modeli (OpenAI'dan migrate edildi)
- **JWT** — Kimlik doğrulama (Firebase devre dışı)
- **Google Cloud TTS** — Metin okuma servisi

### Frontend

- **Flutter** — Web + iOS + Android çapraz platform
- **Riverpod** (hooks_riverpod) — State yönetimi
- **GoRouter** — Navigasyon
- **Dio** — HTTP istemci
- **Web Speech API** — Ses tanıma (speech-to-text)
- **FL Chart** — İlerleme grafikleri

## API Yapısı

| Prefix              | Router                      | Açıklama                           |
| ------------------- | --------------------------- | ---------------------------------- |
| `/api/ai`           | ai_endpoints                | Chat, gramer analizi, ders sohbeti |
| `/api/lessons`      | lesson_endpoints            | Ders CRUD                          |
| `/api/v2`           | structured_lesson_endpoints | Yapılandırılmış ders sistemi       |
| `/api/conversation` | conversation_endpoints      | Konuşma geçmişi                    |
| `/api/grammar`      | grammar_endpoints           | Gramer konuları                    |
| `/`                 | auth_endpoints              | JWT auth (register/login)          |

## Desteklenen Diller & Seviyeler

- **Öğrenilecek diller**: Türkçe, İngilizce, Almanca
- **CEFR seviyeleri**: A1, A2, B1, B2, C1, C2
- **Arayüz iletişim dili** (communication_language): Kullanıcının ana dili olarak ayrıca seçilebilir

## Önemli Notlar

- Firebase auth şu an **devre dışı** — JWT tabanlı auth aktif
- İlerleme dashboard'u şu an **mock data** kullanıyor, gerçek backend bağlantısı eksik
- Ders içeriği (A1-C2) **%20 tamamlandı**, üretim için içerik oluşturulması gerekiyor
- Backend `main.py` root dizinde, `app/main.py` tek satır (boş)
- Çok sayıda geçici migration ve test script'i `backend/` kökünde birikmiş durumda

## Geliştirme Ortamı

### Backend başlatma

```bash
cd backend
# venv aktif et
uvicorn main:app --reload --port 8000
```

### Frontend başlatma

```bash
cd frontend
flutter run -d web
# veya mobil için: flutter run -d <device_id>
```

### Ortam Değişkenleri (`backend/.env`)

```
GEMINI_API_KEY=...
DATABASE_URL=postgresql://...
SECRET_KEY=...
```
<!-- Gerçek değerler .env dosyasında, asla commit'e gitmez -->
