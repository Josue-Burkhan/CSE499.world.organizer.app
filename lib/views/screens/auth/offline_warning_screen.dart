import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:worldorganizer_app/core/config/app_theme.dart';
import 'package:worldorganizer_app/views/screens/home/home_screen.dart';

class OfflineWarningScreen extends StatefulWidget {
  const OfflineWarningScreen({super.key});

  @override
  State<OfflineWarningScreen> createState() => _OfflineWarningScreenState();
}

class _OfflineWarningScreenState extends State<OfflineWarningScreen> {
  final _secureStorage = const FlutterSecureStorage();

  Future<void> _handleContinueOffline() async {
    await _secureStorage.write(key: 'session_type', value: 'offline');
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Mode Warning'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 100, color: Colors.grey),
              const SizedBox(height: 20),
              const Text(
                'You are about to proceed offline.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text:
                      'If you don’t log in, your content might be lost since it won’t be stored in the cloud, and it won’t stay synced across your devices. ',
                  style: const TextStyle(fontSize: 16),
                  children: [
                    TextSpan(
                      text: 'You can log in at any time from settings.',
                      style: TextStyle(
                        color: AppTheme.turquoiseColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _handleContinueOffline,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.turquoiseColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('I Understand, Continue'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
