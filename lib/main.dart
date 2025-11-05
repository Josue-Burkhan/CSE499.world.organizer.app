import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/screens/splash_screen.dart';

void main() {
  // We will add database initialization and other async setup here later.
  runApp(
    // ProviderScope enables Riverpod state management for the entire app.
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'World Organizer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      // SplashScreen is the app's entry point, which will handle
      // navigation logic (e.g., to auth or home).
      home: const SplashScreen(),
    );
  }
}