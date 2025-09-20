import 'package:flutter/material.dart';
import 'package:machine_task/providers/auth_provider.dart';
import 'package:machine_task/providers/connectivity_provider.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'no_network_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
    
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Store navigator and providers before async operations
    final navigator = Navigator.of(context);
    final connectivityProvider = Provider.of<ConnectivityProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Initialize connectivity
    await connectivityProvider.initialize();
    
    // Check auth status
    await authProvider.checkAuthStatus();
    
    // Navigate based on state
    if (mounted) {
      if (!connectivityProvider.isConnected) {
        navigator.pushReplacement(
          MaterialPageRoute(builder: (context) => const NoNetworkScreen()),
        );
      } else if (authProvider.isLoggedIn) {
        navigator.pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        navigator.pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha:0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.people,
                  size: 60,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Machine Task',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                'Loading...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
