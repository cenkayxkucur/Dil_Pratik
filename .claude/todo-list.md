# Dil Pratik - TODO List

Son güncelleme: 2026-04-08 (oturum 3)

## Durum Özeti

- Backend API: 100% tamamlandı
- Frontend Core: 100% tamamlandı
- AI Entegrasyonu + Analytics: 100% tamamlandı
- Streak & Günlük Hedef: 100% tamamlandı
- Kelime Defteri: 100% tamamlandı
- Egzersiz Modları: 100% tamamlandı
- UI/UX (animasyon, erişilebilirlik, çoklu dil): 100% tamamlandı
- Ses Sistemi: 100% tamamlandı
- Test Altyapısı: 100% tamamlandı (E2E hariç)
- Veritabanı (SQLite dev): 100% tamamlandı
- Ders İçeriği: ~20% tamamlandı (ertelendi)
- Deployment: 0% tamamlandı ← sıradaki

**Hedef platform:** Web (önce), Mobile (sonra)
**Hedef kitle:** Genel kullanıcılar

---

## YUKSEK ONCELIK

### Veritabanı & AI Analytics

- [x] SQLite'a geçildi (PostgreSQL şifre sorunu bypass edildi — prod'da geri dönülür)
- [x] Analytics şeması eklendi: `LearningInteraction`, `WordKnowledge`, `GrammarKnowledge`, `UserLearningProfile`
- [x] AI her konuşma turunda kullanıcı mesajını Gemini ile analiz eder, hataları/doğruları etiketler
- [x] Kullanıcı profili prompt'a enjekte edilir — AI zayıf alanlara odaklanır
- [x] Spaced repetition foundation: `next_review_at` alanı kelime bilgisinde tutulur
- [x] Analytics endpoint'leri: `/api/ai/profile/{user_id}`, `/api/ai/weak-areas/{user_id}`
- [x] Venv yeniden kuruldu (bozuk paketler temizlendi)

### Kritik Bug & Teknik Borç

- [x] `backend/app/services/` içindeki 8 adet `ai_service` versiyonunu temizle — sadece `ai_service.py` bırak
- [x] `lesson_service_new.py` ve `structured_lesson_service_new.py` dosyalarını aktif olanla birleştir, eskisini sil
- [x] Konuşma geçmişini (`conversation_history`) bellekten veritabanına taşı — `conversation_messages` tablosu eklendi
- [x] API URL'i (`http://localhost:8000`) hardcoded'dan environment variable'a taşı (`AppConfig.apiBaseUrl`)
- [x] Hata durumunda sahte AI yanıtı dönme sorununu düzelt — kullanıcıya açık hata mesajı göster
- [x] `selectedLanguageProvider`'ı tek merkezi yere taşı → `lib/providers/language_provider.dart`
- [x] `lessonChat()` içindeki hardcoded `'communication_language': 'turkish'` — kullanıcı seçimine bağla

### Auth Akışı Tamamlama

- [x] Router redirect'i aktif et — giriş yapılmadan korumalı sayfalara erişim engellenmeli
- [x] Ana sayfayı düzenle — giriş yapılmamışken ders/pratik görünmemeli
- [ ] End-to-end auth akışı test et (register → login → JWT → korumalı endpoint)
- [x] Frontend'de token yenileme (refresh token) mantığını ekle
- [x] `auth_provider.dart` ve `auth_provider_new.dart` birleştir
- [x] `auth_service.dart` ve `auth_service_new.dart` birleştir

### İçerik Üretimi

- [ ] A1-C2 ders içeriği oluştur (Türkçe, İngilizce, Almanca)
- [ ] Gramer kuralları veritabanını doldur
- [ ] Seviye ve konuya göre kelime listeleri oluştur
- [ ] AI ile dinamik egzersiz üretimi (çoktan seçmeli, boşluk doldurma, eşleştirme)
- [ ] Seviye belirleme testleri ve ilerleme değerlendirme testleri
- [ ] Gerçek hayat senaryolarına dayalı konuşma diyalogları

### İlerleme Takibi — Gerçek Veri Bağlantısı

- [x] Progress dashboard'u mock data'dan gerçek backend'e bağla
- [x] Zayıf alan analizi ve öneri sistemi ekle

---

## ORTA ONCELIK

### Yeni Özellikler

- [x] **Spaced Repetition (Aralıklı Tekrar) Sistemi** — yanlış yapılan kelime/gramer noktaları otomatik tekrar kuyruğuna giriyor; "Hatalarından Ders Al" ekranı bunu beslemeli
- [x] **Günlük hedef & streak sistemi** — `UserStreak` modeli, `/api/ai/streak` endpoint, home screen'de ateş ikonu + progress bar, hedef değiştirme dialog'u
- [x] **Kelime defteri** — `SavedWord` modeli, `/api/vocabulary/` CRUD, `VocabularyScreen`, practice screen'de AI yanıtlarına kitap ikonu butonu, home screen 5. kart
- [x] **Yapılandırılmış egzersiz modları** — `ExerciseScreen` oluşturuldu; çoktan seçmeli, çeviri, boşluk doldurma; ders kartından "Egzersiz Yap" butonu

### Offline & Platform Genişletme (JWT sistemini koruyarak)

- [x] **Offline cache** — `CacheService` + `CacheKeys` ile TTL-tabanlı cache; yapılandırılmış dersler SharedPreferences'a önbelleklendi (1 saat / 30 dk TTL)
- [ ] **Sosyal login** — `google_sign_in` paketi + backend'de Google ID token doğrulama; mevcut JWT sistemi korunur
- [ ] **Push notification** — Firebase Cloud Messaging (FCM) auth olmadan eklenir; günlük hatırlatma, streak bildirimi

### Kod Kalitesi & Temizlik

- [x] `backend/` kökündeki geçici migration ve test script'lerini temizle (silindi)
- [x] `practice_screen_new.dart` silindi
- [x] Flutter analysis uyarılarını düzelt — `progressProvider` derleme hatası, debug print'ler temizlendi
- [x] Kullanılmayan importları temizle

### UI/UX İyileştirmeleri

- [x] Koyu/açık tema sistemi (dark/light mode) — `ThemeModeNotifier` + SharedPreferences kalıcı; AppBar'da toggle butonu
- [x] Web öncelikli responsive tasarım — home ekranı Wrap grid (2/3 col), practice ekranı Row/Column layout (>=700px)
- [x] Ekran geçişlerinde animasyon ve micro-interaction'lar — GoRouter `CustomTransitionPage` (slide+fade 220ms); NavCard `AnimatedScale` + `onTapDown` press efekti
- [x] Erişilebilirlik: ekran okuyucu desteği, klavye navigasyonu — `Semantics` wrapper (NavCard, form alanları, butonlar); `FocusTraversalGroup` uygulama genelinde; `autofillHints`; `textInputAction` zinciri (next→done)
- [x] Arayüz çoklu dil desteği (TR, EN, DE) — `AppL10n` sınıfı (~70 string, 3 dil); `UiLanguageNotifier` + SharedPreferences; AppBar'da flag popup menüsü; login/register/home/practice ekranları l10n'a bağlandı

### Ses Sistemi Geliştirme

- [x] Telaffuz değerlendirme sistemi (pronunciation assessment) — practice screen'e pronunciation modu eklendi; AI özel geri bildirim veriyor
- [x] Ses dosyası yönetimi ve işleme pipeline'ı — TTS `cancel()` before `speak()` (üst üste binme engeli); `TtsRate` enum (slow/normal/fast); practice settings panel'de hız seçici (SegmentedButton); `ttsRateProvider` state yönetimi; `TtsTypes` platform-bağımsız dosya

---

## DUSUK ONCELIK / GELECEK

### Platform Genişletme

- [ ] Offline cache — dersler ve gramer konularını local storage'a önbelleğe al
- [ ] PWA (Progressive Web App) kurulumu
- [ ] Mobil native özellikler ve performans optimizasyonu (web tamamlandıktan sonra)
- [ ] Flutter Desktop uygulama versiyonu

### Test Altyapısı

- [x] Backend unit ve integration testleri (pytest) — `backend/tests/conftest.py` (in-memory SQLite TestClient), `test_auth.py` (register/login/refresh/me/logout), `test_vocabulary.py` (save/list/filter/delete), `test_structured_lessons.py` (schema validation)
- [x] Flutter widget testleri — `test/widget_test.dart` genişletildi: `AppL10n` unit testleri (3 dil × kritik alanlar), form validation testleri, `ProviderScope` override testleri
- [ ] End-to-end test senaryoları (Playwright/Selenium — deployment sonrasına ertelendi)

### Production Deployment (Sıradaki major görev — bu sırayla)

- [ ] **1. Supabase** — PostgreSQL kurulumu, connection string al, `backend/.env`'de `DATABASE_URL` değiştir
- [ ] **2. Render** — FastAPI backend deploy (free tier), env variables ekle (GEMINI_API_KEY, SECRET_KEY, DATABASE_URL)
- [ ] **3. Vercel** — `flutter build web` → Vercel'e deploy, backend URL'i env'e ekle
- [ ] **4. Cloudflare** — DNS ayarları, SSL sertifikası (hem backend hem frontend)
- [ ] **5. Sentry** — `sentry-sdk[fastapi]` backend'e, `sentry_flutter` frontend'e entegre et
- [ ] Production ortam değişkenleri ve secrets yönetimi
- [ ] CI/CD pipeline (GitHub Actions) — opsiyonel
- [ ] Pinecone (projenin sonunda — RAG/semantic ders önerisi için)

---

## TAMAMLANDI

- [x] PostgreSQL veritabanı şeması ve SQLAlchemy modelleri
- [x] Google Gemini AI entegrasyonu (OpenAI'dan migrate)
- [x] FastAPI backend — tüm core endpoint'ler
- [x] Frontend-Backend bağlantısı (Dio HTTP client)
- [x] JWT kimlik doğrulama sistemi (backend)
- [x] Web Speech API ses tanıma (çoklu dil)
- [x] Text-to-Speech (TTS) servisi
- [x] İki yönlü sesli etkileşim modu
- [x] İlerleme dashboard'u (FL Chart ile görselleştirme)
- [x] Yapılandırılmış ders sistemi (structured lessons)
- [x] Ders bazlı AI sohbet sistemi
- [x] Konuşma geçmişi takibi
- [x] communication_language (iletişim dili) seçeneği
- [x] CEFR seviyeleri (A1-C2) prompt mühendisliği
- [x] CORS middleware ve hata yönetimi
