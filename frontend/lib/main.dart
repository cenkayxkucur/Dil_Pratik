import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

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
  
  // Skip .env loading for now to avoid errors
  // try {
  //   await dotenv.load(fileName: ".env");
  // } catch (e) {
  //   print('Could not load .env file: $e');
  // }
  
  // Firebase initialization disabled for now
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  
  runApp(const ProviderScope(child: MyApp()));
}

final _router = GoRouter(
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
  redirect: (context, state) {
    // Simplify routing for now - no auth check
    return null;
  },
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Dil Pratik',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
