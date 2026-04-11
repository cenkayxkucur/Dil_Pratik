import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'models/user.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/ui_language_provider.dart';
import 'services/token_manager.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/lessons_screen.dart';
import 'screens/lesson_screen.dart';
import 'screens/practice_screen.dart';
import 'screens/error_review_screen.dart';
import 'screens/progress_dashboard_screen.dart';
import 'screens/vocabulary_screen.dart';

const _sentryDsn = String.fromEnvironment('SENTRY_DSN', defaultValue: '');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (_sentryDsn.isNotEmpty) {
    await SentryFlutter.init(
      (options) {
        options.dsn = _sentryDsn;
        options.tracesSampleRate = 0.1;
        options.environment = const String.fromEnvironment(
          'ENVIRONMENT',
          defaultValue: 'production',
        );
      },
      appRunner: () => runApp(const ProviderScope(child: MyApp())),
    );
  } else {
    runApp(const ProviderScope(child: MyApp()));
  }
}

// ──────────────────────────────────────────────────────────────
// Slide + fade page transition helper
// ──────────────────────────────────────────────────────────────

CustomTransitionPage<void> _slideFadePage(GoRouterState state, Widget child) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 180),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.04, 0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );

/// GoRouter'ı Riverpod ile senkronize eden notifier.
class _RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  _RouterNotifier(this._ref) {
    _ref.listen<User?>(authStateProvider, (_, __) => notifyListeners());
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final user = _ref.read(authStateProvider);
    final isLoggedIn = user != null;
    final loc = state.matchedLocation;

    final isPublic = loc == '/login' || loc == '/register';

    if (!isLoggedIn && !isPublic) return '/login';
    if (isLoggedIn && isPublic) return '/';
    return null;
  }
}

/// Auth yüklenmeden router çalışmaması için loading kontrolü.
final _routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);

  return GoRouter(
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _slideFadePage(state, const HomeScreen()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _slideFadePage(state, const LoginScreen()),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => _slideFadePage(state, const RegisterScreen()),
      ),
      GoRoute(
        path: '/lessons',
        pageBuilder: (context, state) => _slideFadePage(state, const LessonsScreen()),
      ),
      GoRoute(
        path: '/practice',
        pageBuilder: (context, state) => _slideFadePage(state, const PracticeScreen()),
      ),
      GoRoute(
        path: '/error-review',
        pageBuilder: (context, state) => _slideFadePage(state, const ErrorReviewScreen()),
      ),
      GoRoute(
        path: '/progress',
        pageBuilder: (context, state) =>
            _slideFadePage(state, const ProgressDashboardScreen()),
      ),
      GoRoute(
        path: '/lesson/:id',
        pageBuilder: (context, state) => _slideFadePage(
          state,
          LessonScreen(lessonId: int.parse(state.pathParameters['id']!)),
        ),
      ),
      GoRoute(
        path: '/vocabulary',
        pageBuilder: (context, state) =>
            _slideFadePage(state, const VocabularyScreen()),
      ),
    ],
  );
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Auth state yüklenene kadar loading göster
    final authState = ref.watch(authControllerProvider);

    if (authState.isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    // Token süresi dolduğunda (401) → oturumu kapat, router /login'e yönlendirir
    TokenManager.setOnExpired(() async {
      ref.read(authStateProvider.notifier).state = null;
      await ref.read(authServiceProvider).signOut();
    });

    final router = ref.watch(_routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return FocusTraversalGroup(
      policy: AppFocusTraversalPolicy(),
      child: MaterialApp.router(
        title: 'Dil Pratik',
        themeMode: themeMode,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}
