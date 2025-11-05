import 'package:flutter/material.dart';
import 'auth/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  /// Handles the initial app startup logic.
  /// This will check auth status, load preferences, etc., in the future.
  Future<void> _navigateToNextScreen() async {
    // Simulate app loading time (e.g., loading assets, initializing services)
    await Future.delayed(const Duration(seconds: 3));

    // Ensure the widget is still mounted before attempting navigation.
    if (mounted) {
      // Use pushReplacement to remove the splash screen from the navigation stack.
      // The user should not be able to navigate "back" to the splash screen.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for the application logo
            FlutterLogo(size: 100),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
