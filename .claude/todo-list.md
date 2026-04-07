# Dil Pratik - TODO List

Son güncelleme: 2026-04-07

## Durum Özeti

- Backend API: ~98% tamamlandı
- Frontend Core: ~90% tamamlandı
- AI Entegrasyonu + Analytics: 100% tamamlandı
- Veritabanı (SQLite dev): 100% tamamlandı
- Ders İçeriği: ~20% tamamlandı
- Deployment: 0% tamamlandı

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
- [ ] Frontend'de token yenileme (refresh token) mantığını ekle
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

- [ ] **Spaced Repetition (Aralıklı Tekrar) Sistemi** — yanlış yapılan kelime/gramer noktaları otomatik tekrar kuyruğuna giriyor; "Hatalarından Ders Al" ekranı bunu beslemeli
- [ ] **Günlük hedef & streak sistemi** — "günde 10 dakika" hedefi + üst üste kaç gün pratik yaptın sayacı
- [ ] **Kelime defteri** — konuşma/ders sırasında kelime kaydetme, backend'de yeni model gerekiyor
- [ ] **Yapılandırılmış egzersiz modları** — şu an sadece serbest sohbet var; çoktan seçmeli, çeviri, boşluk doldurma modları

### Offline & Platform Genişletme (JWT sistemini koruyarak)

- [ ] **Offline cache** — `shared_preferences`/`hive` ile ders ve profil verilerini önbelleğe al; bağlantı yokken göster
- [ ] **Sosyal login** — `google_sign_in` paketi + backend'de Google ID token doğrulama; mevcut JWT sistemi korunur
- [ ] **Push notification** — Firebase Cloud Messaging (FCM) auth olmadan eklenir; günlük hatırlatma, streak bildirimi

### Kod Kalitesi & Temizlik

- [x] `backend/` kökündeki geçici migration ve test script'lerini temizle (silindi)
- [x] `practice_screen_new.dart` silindi
- [ ] Flutter analysis uyarılarını ve deprecated kullanımları (`withOpacity` vb.) düzelt
- [ ] Kullanılmayan importları temizle

### UI/UX İyileştirmeleri

- [ ] Koyu/açık tema sistemi (dark/light mode)
- [ ] Web öncelikli responsive tasarım (sonra mobil uyum)
- [ ] Ekran geçişlerinde animasyon ve micro-interaction'lar
- [ ] Erişilebilirlik: ekran okuyucu desteği, klavye navigasyonu
- [ ] Arayüz çoklu dil desteği (TR, EN, DE)

### Ses Sistemi Geliştirme

- [ ] Telaffuz değerlendirme sistemi (pronunciation assessment)
- [ ] Ses dosyası yönetimi ve işleme pipeline'ı

---

## DUSUK ONCELIK / GELECEK

### Platform Genişletme

- [ ] Offline cache — dersler ve gramer konularını local storage'a önbelleğe al
- [ ] PWA (Progressive Web App) kurulumu
- [ ] Mobil native özellikler ve performans optimizasyonu (web tamamlandıktan sonra)
- [ ] Flutter Desktop uygulama versiyonu

### Test Altyapısı

- [ ] Backend unit ve integration testleri (pytest)
- [ ] Flutter widget testleri
- [ ] End-to-end test senaryoları

### Production Deployment (Kod geliştirme bittikten sonra — bu sırayla)

- [ ] Supabase PostgreSQL kurulumu → DATABASE_URL değişikliği (SQLite → Supabase)
- [ ] Render'a FastAPI backend deploy (free tier)
- [ ] Vercel'e Flutter web deploy (`flutter build web`)
- [ ] Cloudflare DNS + SSL (hem backend hem frontend)
- [ ] Sentry entegrasyonu (sentry-sdk[fastapi] + sentry_flutter)
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
