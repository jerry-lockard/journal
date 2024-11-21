import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal/src/theme/app_theme.dart';
import 'package:journal/src/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: JournalApp()));
}

class JournalApp extends StatelessWidget {
  const JournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          title: 'Journal',
          theme: AppTheme.lightTheme(lightDynamic),
          darkTheme: AppTheme.darkTheme(darkDynamic),
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          home: const HomeScreen(),
        );
      },
    );
  }
}
