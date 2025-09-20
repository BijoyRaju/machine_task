import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Handle auth changes
        if (!authProvider.isLoggedIn) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
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
        // Show circular progress Indicator if loading
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If user details is null show error
        if (authProvider.user == null) {
          return const Scaffold(
            body: Center(child: Text('Error loading profile')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Profile Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withValues(alpha:0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withValues(alpha:0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Profile Picture
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: authProvider.user!.photoUrl != null
                            ? NetworkImage(authProvider.user!.photoUrl!)
                            : null,
                        child: authProvider.user!.photoUrl == null
                            ? const Icon(Icons.person, size: 50, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(height: 16),
                      
                      // User Name
                      Text(
                        authProvider.user!.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // User Email
                      Text(
                        authProvider.user!.email,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Profile Information
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile Information',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                      ),
                      const SizedBox(height: 20),
                      
                      _buildInfoRow(
                        context,
                        Icons.person,
                        'Name',
                        authProvider.user!.name,
                      ),
                      const SizedBox(height: 16),
                      
                      _buildInfoRow(
                        context,
                        Icons.email,
                        'Email',
                        authProvider.user!.email,
                      ),
                      const SizedBox(height: 16),
                      
                      _buildInfoRow(
                        context,
                        Icons.badge,
                        'User ID',
                        authProvider.user!.id,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // App Information
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'App Information',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                      ),
                      const SizedBox(height: 20),
                      
                      _buildInfoRow(
                        context,
                        Icons.apps,
                        'App Name',
                        'Machine Task',
                      ),
                      const SizedBox(height: 16),
                      
                      _buildInfoRow(
                        context,
                        Icons.info,
                        'Version',
                        '1.0.0',
                      ),
                      const SizedBox(height: 16),
                      
                      _buildInfoRow(
                        context,
                        Icons.build,
                        'Build',
                        '1',
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Sign Out Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showSignOutDialog(context, authProvider);
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSignOutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                authProvider.signOut();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}
