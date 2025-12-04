import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/config/app_theme.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/views/screens/splash_screen.dart';

import 'package:worldorganizer_app/providers/core_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final appDatabase = AppDatabase();

  runApp(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(appDatabase)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'World Organizer',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
      home: const SplashScreen(),
    );
  }
}
