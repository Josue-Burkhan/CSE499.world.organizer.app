import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:worldorganizer_app/views/screens/main/main_scaffold.dart';
import 'package:worldorganizer_app/views/screens/auth/offline_warning_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String _backendUrl = 'https://login.wild-fantasy.com';
  final _secureStorage = const FlutterSecureStorage();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId: '23514983718-j2up767vacptp67j0o6apb5nuiv0i784.apps.googleusercontent.com'
  );

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google Sign-In was canceled.')),
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to get Google ID token.')),
        );
        return;
      }

      final Uri verifyUrl = Uri.parse('$_backendUrl/auth/mobile/verify');
      final response = await http.post(
        verifyUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      if (response.statusCode != 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Login failed: Server Error ${response.statusCode}')),
        );
        return;
      }

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String? token = responseData['accessToken'];
      final String? refreshToken = responseData['refreshToken'];

      if (token != null && refreshToken != null) {
        await _secureStorage.write(key: 'token', value: token);
        await _secureStorage.write(key: 'refreshToken', value: refreshToken);

        try {
          final Uri meUrl = Uri.parse('$_backendUrl/api/account/me');
          final meResponse = await http.get(
            meUrl,
            headers: {'Authorization': 'Bearer $token'},
          );

          if (meResponse.statusCode == 200) {
            final Map<String, dynamic> meData = jsonDecode(meResponse.body);
            final Map<String, dynamic> accountData = meData['accountData'];
            final String userName = accountData['account_firstname'] ?? 'User';

            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login successful, welcome $userName!')),
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const MainScaffold(),
              ),
            );
          } else {
            throw Exception('Failed to load user data: ${meResponse.statusCode}');
          }
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Network error fetching user data: $e')),
          );
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed: No tokens received from server.'),
          ),
        );
      }
    } catch (e, s) {
      print('--- CATCH BLOCK HIT ---');
      print('Error during Google Sign-In: $e');
      print('Stack trace: $s');
      print('Error type: ${e.runtimeType}');

      String errorMessage = 'Error during login: $e';
      if (e is SocketException) {
        errorMessage = 'Network Error: Check connection or CORS';
      } else if (e is http.ClientException) {
        errorMessage = 'Client Error: ${e.message}';
      }

      print('Displaying SnackBar: $errorMessage');

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/logo-black.svg',
                  height: 150,
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to sync your worlds.',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 48),
                ElevatedButton.icon(
                  icon: SvgPicture.asset(
                    'assets/icons/google_logo.svg',
                    height: 24,
                  ),
                  label: const Text('Sign in with Google'),
                  onPressed: _handleGoogleSignIn,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const OfflineWarningScreen(),
                      ),
                    );
                  },
                  child: const Text('Continue without Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}