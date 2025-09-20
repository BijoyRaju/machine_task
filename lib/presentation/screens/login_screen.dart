import 'package:flutter/material.dart';
import 'package:machine_task/providers/auth_provider.dart';
import 'package:machine_task/providers/connectivity_provider.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'no_network_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    _initializeConnectivity();
  }

  void _initializeConnectivity() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final connectivityProvider = Provider.of<ConnectivityProvider>(context, listen: false);
      connectivityProvider.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, ConnectivityProvider>(
      builder: (context, authProvider, connectivityProvider, child) {
        // Listen to connectivity changes
        if (!connectivityProvider.isConnected) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const NoNetworkScreen()),
            );
          });
        }

        // Listen to auth changes
        if (authProvider.isLoggedIn) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          });
        }

        // Show error if any
        if (authProvider.error != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(authProvider.error!),
                backgroundColor: Colors.red,
              ),
            );
          });
        }

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo and Title
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.people,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Sign in with Google to continue',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),
                  
                  // Google Sign In Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: authProvider.isLoading
                          ? null
                          : () {
                              authProvider.signInWithGoogle();
                            },
                      icon: authProvider.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.login, color: Colors.white),
                      label: Text(
                        authProvider.isLoading ? 'Signing in...' : 'Sign in with Google',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Features List
                  
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
