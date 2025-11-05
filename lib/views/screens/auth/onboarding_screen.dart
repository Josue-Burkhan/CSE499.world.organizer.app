import 'package:flutter/material.dart';
import 'offline_warning_screen.dart';
import '../home/home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  /// Handles the Google Sign-In flow.
  void _onLoginWithGoogle(BuildContext context) {
    // TODO: Implement Google Sign-In logic here.
    print("Login with Google pressed");

    // On successful login, navigate to the main app.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  /// Navigates the user to the "offline mode" warning screen.
  void _onContinueWithoutLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const OfflineWarningScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to World Organizer',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _onLoginWithGoogle(context),
                child: const Text('Login with Google'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => _onContinueWithoutLogin(context),
                child: const Text('Continue without login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
