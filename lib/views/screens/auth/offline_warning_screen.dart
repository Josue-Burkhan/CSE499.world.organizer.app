import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class OfflineWarningScreen extends StatelessWidget {
  const OfflineWarningScreen({super.key});

  /// Handles the Google Sign-In flow from the warning screen.
  void _onLoginWithGoogle(BuildContext context) {
    // TODO: Implement Google Sign-In logic here.
    print("Login with Google pressed");
    
    // On successful login, navigate to the main app.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  /// Commits the user to offline mode and proceeds to the app.
  void _onContinueOffline(BuildContext context) {
    // TODO: Set a flag in shared_preferences to remember this choice.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
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
                'Are you sure?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Without logging in, your data will only be saved locally on this device. If you delete the app or lose your phone, your data will be lost.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _onLoginWithGoogle(context),
                child: const Text('Login with Google'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => _onContinueOffline(context),
                child: const Text('Continue offline'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}