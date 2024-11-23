import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal/src/shared/theme/app_theme.dart';
import 'package:journal/src/screens/home_screen.dart';
import 'package:journal/src/shared/theme/theme_provider.dart';
import 'package:journal/src/features/settings/screens/settings_screen.dart';
import 'package:journal/src/features/profile/screens/profile_screen.dart';
import 'package:journal/src/features/ai/screens/ai_assistant_screen.dart';
import 'package:journal/src/features/auth/screens/login_screen.dart';
import 'package:journal/src/features/auth/providers/auth_provider.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await analytics.setAnalyticsCollectionEnabled(true);
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  FirebaseDatabase.instance.ref().keepSynced(true);
  runApp(const ProviderScope(child: JournalApp()));
}

class JournalApp extends ConsumerWidget {
  const JournalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final authState = ref.watch(authProvider);

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          title: 'Journal',
          theme: AppTheme.light(lightDynamic),
          darkTheme: AppTheme.dark(darkDynamic),
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: analytics),
          ],
          home: authState.when(
            data: (user) => user != null ? const HomeScreen() : const LoginScreen(),
            loading: () => const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stackTrace) => Scaffold(
              body: Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
          onGenerateRoute: (settings) {
            if (authState.valueOrNull == null && settings.name != '/login') {
              return MaterialPageRoute(
                builder: (context) => const LoginScreen(),
                settings: const RouteSettings(name: '/login'),
              );
            }

            switch (settings.name) {
              case '/':
                return MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                  settings: settings,
                );
              case '/settings':
                return MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                  settings: settings,
                );
              case '/profile':
                return MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                  settings: settings,
                );
              case '/ai-assistant':
                return MaterialPageRoute(
                  builder: (context) => const AIAssistantScreen(),
                  settings: settings,
                );
              case '/login':
                return MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                  settings: settings,
                );
              default:
                return MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                  settings: settings,
                );
            }
          },
        );
      },
    );
  }
}
