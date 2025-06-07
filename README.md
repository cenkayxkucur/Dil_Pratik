# Dil Pratik - AI-Powered Language Learning Platform

Yapay zeka destekli Türkçe dil öğrenme platformu. Google Gemini API kullanarak kullanıcılara gerçek zamanlı konuşma pratiği, telaffuz analizi, gramer öğrenimi ve kişiselleştirilmiş alıştırmalar sunar.

## 🚀 Özellikler

- 🎤 **Gerçek zamanlı sesli konuşma pratiği** - Web Speech API ile
- 📝 **AI destekli telaffuz analizi** - Google Gemini ile
- 📚 **Seviye bazlı gramer kütüphanesi** (A1-C2 CEFR seviyeleri)
- ❓ **Etkileşimli soru-cevap sistemi** - Akıllı chat bot
- 📊 **Kişisel gelişim takibi** - Detaylı ilerleme raporları
- 🌐 **Çapraz platform desteği** - Web, iOS, Android

## 🛠️ Teknoloji Stack

### Backend
- **FastAPI** - Modern Python web framework
- **Google Gemini AI** - Dil işleme ve AI yanıtları
- **PostgreSQL** - Veritabanı
- **SQLAlchemy** - ORM

### Frontend  
- **Flutter** - Cross-platform UI framework
- **Provider** - State management
- **Web Speech API** - Sesli etkileşim

## 📦 Kurulum

### Gereksinimler
- Python 3.8+
- Flutter 3.0+
- PostgreSQL
- Google Gemini API Key

### Backend Kurulumu

```bash
cd backend
pip install -r requirements.txt
```

`.env` dosyası oluşturun:
```env
GEMINI_API_KEY=your_gemini_api_key_here
DATABASE_URL=postgresql://username:password@localhost/dil_pratik
```

Veritabanını başlatın:
```bash
python create_tables.py
python main.py
```

### Frontend Kurulumu

```bash
cd frontend
flutter pub get
flutter run -d web
```

## 🚀 Çalıştırma

1. **Backend'i başlatın**:
```bash
cd backend
python main.py
```
Backend http://localhost:8000 adresinde çalışacak.

2. **Frontend'i başlatın**:
```bash
cd frontend  
flutter run -d web
```
Frontend http://localhost:3000 adresinde çalışacak.

## 📱 Kullanım

1. **Ana sayfa** - Dil seviyenizi seçin
2. **Pratik ekranı** - Sesli konuşma pratiği yapın
3. **Ders ekranı** - Gramer kurallarını öğrenin  
4. **İlerleme takibi** - Gelişiminizi görüntüleyin

## 🔧 API Endpoints

- `GET /health` - Sistem durumu
- `POST /ai/chat` - AI sohbet
- `POST /ai/analyze-grammar` - Gramer analizi
- `POST /ai/practice-content` - Pratik içeriği
- `POST /ai/grammar/{level}` - Seviye bazlı gramer

## 🤝 Katkıda Bulunma

1. Bu repository'yi fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add amazing feature'`)
4. Branch'i push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

## 🔗 Bağlantılar

- [Google Gemini AI](https://ai.google.dev/)
- [Flutter Documentation](https://docs.flutter.dev/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)

## 📞 İletişim

Proje hakkında sorularınız için issue oluşturabilirsiniz.
- 🎯 Kişiselleştirilmiş alıştırmalar
- 🌍 Çoklu dil desteği

## Teknik Altyapı

- Frontend: Flutter (Web + Mobile)
- Backend: Python (FastAPI)
- AI: OpenAI GPT-4 + Whisper
- Veritabanı: PostgreSQL
- Gerçek zamanlı iletişim: Firebase
- Text-to-Speech: Google Cloud TTS / ElevenLabs

## Kurulum

### Gereksinimler

- Flutter SDK
- Python 3.8+
- PostgreSQL
- Node.js 16+

### Backend Kurulumu

```bash
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### Frontend Kurulumu

```bash
cd frontend
flutter pub get
```

### Çalıştırma

1. Backend:
```bash
cd backend
uvicorn main:app --reload
```

2. Frontend:
```bash
cd frontend
flutter run
```

## Proje Yapısı

```
.
├── frontend/               # Flutter uygulaması
│   ├── lib/               # Dart kaynak kodları
│   ├── assets/           # Resimler, fontlar vs.
│   └── test/             # Frontend testleri
│
├── backend/               # Python FastAPI backend
│   ├── app/              # Ana uygulama kodları
│   ├── tests/            # Backend testleri
│   └── alembic/          # Veritabanı migrasyonları
│
└── docs/                 # Dokümantasyon 