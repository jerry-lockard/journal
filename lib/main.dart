import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal/src/shared/theme/app_theme.dart';
import 'package:journal/src/screens/home_screen.dart';
import 'package:journal/src/shared/theme/theme_provider.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await analytics.setAnalyticsCollectionEnabled(true); // Enable analytics
  runApp(const ProviderScope(child: JournalApp()));
}

class JournalApp extends ConsumerWidget {
  const JournalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          title: 'Journal',
          theme: AppTheme.light(lightDynamic),
          darkTheme: AppTheme.dark(darkDynamic),
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          navigatorObservers: [
            FirebaseAnalyticsObserver(
                analytics: analytics), // Add analytics observer
          ],
          home: const HomeScreen(),
        );
      },
    );
  }
}
