import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'models/user.dart';
import 'providers/auth_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/lessons_screen.dart';
import 'screens/lesson_screen.dart';
import 'screens/practice_screen.dart';
import 'screens/error_review_screen.dart';
import 'screens/progress_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

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
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/lessons',
        builder: (context, state) => const LessonsScreen(),
      ),
      GoRoute(
        path: '/practice',
        builder: (context, state) => const PracticeScreen(),
      ),
      GoRoute(
        path: '/error-review',
        builder: (context, state) => const ErrorReviewScreen(),
      ),
      GoRoute(
        path: '/progress',
        builder: (context, state) => const ProgressDashboardScreen(),
      ),
      GoRoute(
        path: '/lesson/:id',
        builder: (context, state) => LessonScreen(
          lessonId: int.parse(state.pathParameters['id']!),
        ),
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

    final router = ref.watch(_routerProvider);

    return MaterialApp.router(
      title: 'Dil Pratik',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
