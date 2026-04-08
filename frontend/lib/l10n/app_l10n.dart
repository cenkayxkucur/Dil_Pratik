/// Uygulama genelinde kullanılan string sabitleri.
/// Desteklenen: Türkçe (tr), İngilizce (en), Almanca (de)
class AppStrings {
  // ── App ──────────────────────────────────────────────────
  final String appTitle;

  // ── Home ─────────────────────────────────────────────────
  final String learningLanguage;
  final String whatToDo;
  final String lessons;
  final String lessonsSubtitle;
  final String practice;
  final String practiceSubtitle;
  final String progress;
  final String progressSubtitle;
  final String learnFromErrors;
  final String learnFromErrorsSubtitle;
  final String vocabulary;
  final String vocabularySubtitle;
  final String dailyGoal;
  final String dailyGoalCompleted;
  final String streakDays;
  final String editDailyGoal;
  final String howManyPractices;
  final String changeTheme;
  final String changeLanguage;
  final String logout;

  // ── Auth ─────────────────────────────────────────────────
  final String loginTitle;
  final String registerTitle;
  final String email;
  final String password;
  final String username;
  final String emailRequired;
  final String emailInvalid;
  final String passwordRequired;
  final String passwordTooShort;
  final String usernameRequired;
  final String noAccount;
  final String alreadyAccount;
  final String loginButton;
  final String registerButton;

  // ── Common ───────────────────────────────────────────────
  final String loading;
  final String retry;
  final String cancel;
  final String save;
  final String delete;
  final String confirm;
  final String error;
  final String success;
  final String close;

  // ── Practice ─────────────────────────────────────────────
  final String practiceTitle;
  final String typeMessage;
  final String send;
  final String clearChat;
  final String pronunciationMode;
  final String pronunciationHint;
  final String speechSpeed;
  final String slow;
  final String normal;
  final String fast;

  // ── Vocabulary ───────────────────────────────────────────
  final String vocabularyTitle;
  final String addWord;
  final String wordLabel;
  final String translationLabel;
  final String contextLabel;
  final String searchHint;
  final String vocabularyEmpty;
  final String wordRequired;

  // ── Exercise ─────────────────────────────────────────────
  final String exerciseTitle;
  final String checkAnswer;
  final String nextExercise;
  final String submitAnswer;
  final String exerciseComplete;
  final String tryAgain;
  final String newExercise;
  final String scoreLabel;
  final String correctAnswers;
  final String yourAnswer;
  final String correctAnswer;
  final String multipleChoice;
  final String fillBlank;
  final String translationEx;

  // ── Lessons ──────────────────────────────────────────────
  final String lessonsTitle;
  final String topicsEmpty;
  final String lessonsEmpty;
  final String topicsError;
  final String lessonsError;
  final String doExercise;

  // ── Errors ───────────────────────────────────────────────
  final String networkError;
  final String unknownError;
  final String sessionExpired;

  const AppStrings({
    required this.appTitle,
    required this.learningLanguage,
    required this.whatToDo,
    required this.lessons,
    required this.lessonsSubtitle,
    required this.practice,
    required this.practiceSubtitle,
    required this.progress,
    required this.progressSubtitle,
    required this.learnFromErrors,
    required this.learnFromErrorsSubtitle,
    required this.vocabulary,
    required this.vocabularySubtitle,
    required this.dailyGoal,
    required this.dailyGoalCompleted,
    required this.streakDays,
    required this.editDailyGoal,
    required this.howManyPractices,
    required this.changeTheme,
    required this.changeLanguage,
    required this.logout,
    required this.loginTitle,
    required this.registerTitle,
    required this.email,
    required this.password,
    required this.username,
    required this.emailRequired,
    required this.emailInvalid,
    required this.passwordRequired,
    required this.passwordTooShort,
    required this.usernameRequired,
    required this.noAccount,
    required this.alreadyAccount,
    required this.loginButton,
    required this.registerButton,
    required this.loading,
    required this.retry,
    required this.cancel,
    required this.save,
    required this.delete,
    required this.confirm,
    required this.error,
    required this.success,
    required this.close,
    required this.practiceTitle,
    required this.typeMessage,
    required this.send,
    required this.clearChat,
    required this.pronunciationMode,
    required this.pronunciationHint,
    required this.speechSpeed,
    required this.slow,
    required this.normal,
    required this.fast,
    required this.vocabularyTitle,
    required this.addWord,
    required this.wordLabel,
    required this.translationLabel,
    required this.contextLabel,
    required this.searchHint,
    required this.vocabularyEmpty,
    required this.wordRequired,
    required this.exerciseTitle,
    required this.checkAnswer,
    required this.nextExercise,
    required this.submitAnswer,
    required this.exerciseComplete,
    required this.tryAgain,
    required this.newExercise,
    required this.scoreLabel,
    required this.correctAnswers,
    required this.yourAnswer,
    required this.correctAnswer,
    required this.multipleChoice,
    required this.fillBlank,
    required this.translationEx,
    required this.lessonsTitle,
    required this.topicsEmpty,
    required this.lessonsEmpty,
    required this.topicsError,
    required this.lessonsError,
    required this.doExercise,
    required this.networkError,
    required this.unknownError,
    required this.sessionExpired,
  });
}

/// Dil koduna göre string setini döndürür.
/// Desteklenmeyen kod için Türkçe'ye düşer.
class AppL10n {
  AppL10n._();

  static AppStrings of(String languageCode) {
    switch (languageCode) {
      case 'en':
        return _en;
      case 'de':
        return _de;
      default:
        return _tr;
    }
  }

  // ── Türkçe ───────────────────────────────────────────────
  static const _tr = AppStrings(
    appTitle: 'Dil Pratik',
    learningLanguage: 'Öğrendiğin dil',
    whatToDo: 'Ne yapmak istersin?',
    lessons: 'Dersler',
    lessonsSubtitle: 'Yapılandırılmış ders içerikleri',
    practice: 'Pratik',
    practiceSubtitle: 'AI ile sohbet yaparak pratik et',
    progress: 'İlerleme',
    progressSubtitle: 'Güçlü ve zayıf alanlarını gör',
    learnFromErrors: 'Hatalarından Öğren',
    learnFromErrorsSubtitle: 'Tekrar gereken konular',
    vocabulary: 'Kelime Defterim',
    vocabularySubtitle: 'Kaydettiğin kelimeler',
    dailyGoal: 'Günlük hedef',
    dailyGoalCompleted: 'Günlük hedef tamamlandı!',
    streakDays: 'gün',
    editDailyGoal: 'Günlük Hedef',
    howManyPractices: 'Günde kaç pratik yapmak istiyorsun?',
    changeTheme: 'Tema Değiştir',
    changeLanguage: 'Arayüz Dili',
    logout: 'Çıkış Yap',
    loginTitle: 'Giriş Yap',
    registerTitle: 'Hesap Oluştur',
    email: 'E-posta',
    password: 'Şifre',
    username: 'Kullanıcı Adı',
    emailRequired: 'E-posta gerekli',
    emailInvalid: 'Geçerli bir e-posta adresi girin',
    passwordRequired: 'Şifre gerekli',
    passwordTooShort: 'Şifre en az 6 karakter olmalı',
    usernameRequired: 'Kullanıcı adı gerekli',
    noAccount: 'Hesabınız yok mu? Kayıt olun',
    alreadyAccount: 'Zaten hesabınız var mı? Giriş yapın',
    loginButton: 'Giriş Yap',
    registerButton: 'Kayıt Ol',
    loading: 'Yükleniyor...',
    retry: 'Tekrar Dene',
    cancel: 'İptal',
    save: 'Kaydet',
    delete: 'Sil',
    confirm: 'Onayla',
    error: 'Hata',
    success: 'Başarılı',
    close: 'Kapat',
    practiceTitle: 'Pratik',
    typeMessage: 'Mesajınızı yazın...',
    send: 'Gönder',
    clearChat: 'Sohbeti Temizle',
    pronunciationMode: 'Telaffuz Modu',
    pronunciationHint: 'Telaffuz modu aktif. Konuştuğunda AI telaffuzunu değerlendirecek.',
    speechSpeed: 'Konuşma Hızı',
    slow: 'Yavaş',
    normal: 'Normal',
    fast: 'Hızlı',
    vocabularyTitle: 'Kelime Defterim',
    addWord: 'Kelime Ekle',
    wordLabel: 'Kelime',
    translationLabel: 'Çeviri (isteğe bağlı)',
    contextLabel: 'Bağlam (isteğe bağlı)',
    searchHint: 'Kelime ara...',
    vocabularyEmpty: 'Henüz kelime kaydetmediniz.\nPratik yaparken AI yanıtlarındaki 📖 butonu ile kelime ekleyebilirsiniz.',
    wordRequired: 'Kelime gerekli',
    exerciseTitle: 'Egzersiz',
    checkAnswer: 'Kontrol Et',
    nextExercise: 'Sonraki',
    submitAnswer: 'Cevapla',
    exerciseComplete: 'Egzersiz Tamamlandı!',
    tryAgain: 'Tekrar Dene',
    newExercise: 'Yeni Egzersiz',
    scoreLabel: 'Puan',
    correctAnswers: 'doğru',
    yourAnswer: 'Cevabınız',
    correctAnswer: 'Doğru cevap',
    multipleChoice: 'Çoktan Seçmeli',
    fillBlank: 'Boşluk Doldurma',
    translationEx: 'Çeviri',
    lessonsTitle: 'Dersler',
    topicsEmpty: 'Bu seviyede henüz konu bulunmuyor.\nYakında yeni konular eklenecek!',
    lessonsEmpty: 'Bu konuda henüz ders bulunmuyor.\nYakında yeni dersler eklenecek!',
    topicsError: 'Konular Yüklenemedi',
    lessonsError: 'Dersler Yüklenemedi',
    doExercise: 'Egzersiz Yap',
    networkError: 'Bağlantı hatası. İnternet bağlantınızı kontrol edin.',
    unknownError: 'Bilinmeyen bir hata oluştu.',
    sessionExpired: 'Oturumunuz sona erdi. Lütfen tekrar giriş yapın.',
  );

  // ── English ───────────────────────────────────────────────
  static const _en = AppStrings(
    appTitle: 'Dil Pratik',
    learningLanguage: 'Learning language',
    whatToDo: 'What would you like to do?',
    lessons: 'Lessons',
    lessonsSubtitle: 'Structured lesson content',
    practice: 'Practice',
    practiceSubtitle: 'Converse with AI to practice',
    progress: 'Progress',
    progressSubtitle: 'See your strengths and weaknesses',
    learnFromErrors: 'Learn from Mistakes',
    learnFromErrorsSubtitle: 'Topics needing review',
    vocabulary: 'My Vocabulary',
    vocabularySubtitle: 'Your saved words',
    dailyGoal: 'Daily goal',
    dailyGoalCompleted: 'Daily goal completed!',
    streakDays: 'days',
    editDailyGoal: 'Daily Goal',
    howManyPractices: 'How many practices per day?',
    changeTheme: 'Change Theme',
    changeLanguage: 'Interface Language',
    logout: 'Log Out',
    loginTitle: 'Log In',
    registerTitle: 'Create Account',
    email: 'Email',
    password: 'Password',
    username: 'Username',
    emailRequired: 'Email is required',
    emailInvalid: 'Enter a valid email address',
    passwordRequired: 'Password is required',
    passwordTooShort: 'Password must be at least 6 characters',
    usernameRequired: 'Username is required',
    noAccount: "Don't have an account? Sign up",
    alreadyAccount: 'Already have an account? Log in',
    loginButton: 'Log In',
    registerButton: 'Sign Up',
    loading: 'Loading...',
    retry: 'Retry',
    cancel: 'Cancel',
    save: 'Save',
    delete: 'Delete',
    confirm: 'Confirm',
    error: 'Error',
    success: 'Success',
    close: 'Close',
    practiceTitle: 'Practice',
    typeMessage: 'Type your message...',
    send: 'Send',
    clearChat: 'Clear Chat',
    pronunciationMode: 'Pronunciation Mode',
    pronunciationHint: 'Pronunciation mode active. AI will evaluate your pronunciation when you speak.',
    speechSpeed: 'Speech Speed',
    slow: 'Slow',
    normal: 'Normal',
    fast: 'Fast',
    vocabularyTitle: 'My Vocabulary',
    addWord: 'Add Word',
    wordLabel: 'Word',
    translationLabel: 'Translation (optional)',
    contextLabel: 'Context (optional)',
    searchHint: 'Search words...',
    vocabularyEmpty: 'No words saved yet.\nTap the 📖 button on AI responses while practicing to add words.',
    wordRequired: 'Word is required',
    exerciseTitle: 'Exercise',
    checkAnswer: 'Check',
    nextExercise: 'Next',
    submitAnswer: 'Submit',
    exerciseComplete: 'Exercise Complete!',
    tryAgain: 'Try Again',
    newExercise: 'New Exercise',
    scoreLabel: 'Score',
    correctAnswers: 'correct',
    yourAnswer: 'Your answer',
    correctAnswer: 'Correct answer',
    multipleChoice: 'Multiple Choice',
    fillBlank: 'Fill in the Blank',
    translationEx: 'Translation',
    lessonsTitle: 'Lessons',
    topicsEmpty: 'No topics available for this level yet.\nNew topics coming soon!',
    lessonsEmpty: 'No lessons available for this topic yet.\nNew lessons coming soon!',
    topicsError: 'Failed to Load Topics',
    lessonsError: 'Failed to Load Lessons',
    doExercise: 'Do Exercise',
    networkError: 'Connection error. Please check your internet.',
    unknownError: 'An unknown error occurred.',
    sessionExpired: 'Your session has expired. Please log in again.',
  );

  // ── Deutsch ───────────────────────────────────────────────
  static const _de = AppStrings(
    appTitle: 'Dil Pratik',
    learningLanguage: 'Lernsprache',
    whatToDo: 'Was möchtest du tun?',
    lessons: 'Lektionen',
    lessonsSubtitle: 'Strukturierte Lerninhalte',
    practice: 'Üben',
    practiceSubtitle: 'Unterhaltung mit KI zum Üben',
    progress: 'Fortschritt',
    progressSubtitle: 'Stärken und Schwächen sehen',
    learnFromErrors: 'Aus Fehlern lernen',
    learnFromErrorsSubtitle: 'Themen zur Wiederholung',
    vocabulary: 'Mein Wörterbuch',
    vocabularySubtitle: 'Deine gespeicherten Wörter',
    dailyGoal: 'Tagesziel',
    dailyGoalCompleted: 'Tagesziel erreicht!',
    streakDays: 'Tage',
    editDailyGoal: 'Tagesziel',
    howManyPractices: 'Wie viele Übungen pro Tag?',
    changeTheme: 'Thema ändern',
    changeLanguage: 'Oberflächensprache',
    logout: 'Abmelden',
    loginTitle: 'Anmelden',
    registerTitle: 'Konto erstellen',
    email: 'E-Mail',
    password: 'Passwort',
    username: 'Benutzername',
    emailRequired: 'E-Mail ist erforderlich',
    emailInvalid: 'Gültige E-Mail-Adresse eingeben',
    passwordRequired: 'Passwort ist erforderlich',
    passwordTooShort: 'Passwort muss mindestens 6 Zeichen haben',
    usernameRequired: 'Benutzername ist erforderlich',
    noAccount: 'Noch kein Konto? Registrieren',
    alreadyAccount: 'Bereits ein Konto? Anmelden',
    loginButton: 'Anmelden',
    registerButton: 'Registrieren',
    loading: 'Laden...',
    retry: 'Erneut versuchen',
    cancel: 'Abbrechen',
    save: 'Speichern',
    delete: 'Löschen',
    confirm: 'Bestätigen',
    error: 'Fehler',
    success: 'Erfolg',
    close: 'Schließen',
    practiceTitle: 'Üben',
    typeMessage: 'Nachricht eingeben...',
    send: 'Senden',
    clearChat: 'Chat leeren',
    pronunciationMode: 'Aussprache-Modus',
    pronunciationHint: 'Aussprache-Modus aktiv. KI bewertet deine Aussprache beim Sprechen.',
    speechSpeed: 'Sprechgeschwindigkeit',
    slow: 'Langsam',
    normal: 'Normal',
    fast: 'Schnell',
    vocabularyTitle: 'Mein Wörterbuch',
    addWord: 'Wort hinzufügen',
    wordLabel: 'Wort',
    translationLabel: 'Übersetzung (optional)',
    contextLabel: 'Kontext (optional)',
    searchHint: 'Wörter suchen...',
    vocabularyEmpty: 'Noch keine Wörter gespeichert.\nTippe beim Üben auf 📖 in KI-Antworten.',
    wordRequired: 'Wort ist erforderlich',
    exerciseTitle: 'Übung',
    checkAnswer: 'Prüfen',
    nextExercise: 'Weiter',
    submitAnswer: 'Antworten',
    exerciseComplete: 'Übung abgeschlossen!',
    tryAgain: 'Nochmal',
    newExercise: 'Neue Übung',
    scoreLabel: 'Punkte',
    correctAnswers: 'richtig',
    yourAnswer: 'Deine Antwort',
    correctAnswer: 'Richtige Antwort',
    multipleChoice: 'Mehrfachauswahl',
    fillBlank: 'Lückentext',
    translationEx: 'Übersetzung',
    lessonsTitle: 'Lektionen',
    topicsEmpty: 'Noch keine Themen für dieses Niveau.\nBald kommen neue Themen!',
    lessonsEmpty: 'Noch keine Lektionen für dieses Thema.\nBald kommen neue Lektionen!',
    topicsError: 'Themen konnten nicht geladen werden',
    lessonsError: 'Lektionen konnten nicht geladen werden',
    doExercise: 'Übung machen',
    networkError: 'Verbindungsfehler. Bitte Internetverbindung prüfen.',
    unknownError: 'Ein unbekannter Fehler ist aufgetreten.',
    sessionExpired: 'Ihre Sitzung ist abgelaufen. Bitte erneut anmelden.',
  );
}
