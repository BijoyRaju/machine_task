import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/connectivity_provider.dart';
import '../widgets/user_card.dart';
import 'profile_screen.dart';
import 'user_detail_screen.dart';
import 'create_user_screen.dart';
import 'no_network_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _initializeProviders();
  }

  void _initializeProviders() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final connectivityProvider = Provider.of<ConnectivityProvider>(context, listen: false);
      connectivityProvider.initialize();
      
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.loadUsers(refresh: true);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.loadMoreUsers();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<UserProvider, AuthProvider, ConnectivityProvider>(
      builder: (context, userProvider, authProvider, connectivityProvider, child) {
        // Handle connectivity changes
        if (!connectivityProvider.isConnected) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const NoNetworkScreen()),
            );
          });
        }

        // Show error if any
        if (userProvider.error != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(userProvider.error!),
                backgroundColor: Colors.red,
              ),
            );
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Users'),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              // User Photo + Navigation to Profile
              if (authProvider.user != null)
                IconButton(
                  icon: CircleAvatar(
                    radius: 16,
                    backgroundImage: authProvider.user!.photoUrl != null
                        ? NetworkImage(authProvider.user!.photoUrl!)
                        : null,
                    child: authProvider.user!.photoUrl == null
                        ? const Icon(Icons.person, size: 20, color: Colors.white)
                        : null,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                ),
            ],
          ),
          body: userProvider.isLoading && userProvider.users.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : userProvider.users.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No users found',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pull to refresh or create a new user',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[500],
                                ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        userProvider.loadUsers(refresh: true);
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: userProvider.users.length + (userProvider.hasReachedMax ? 0 : 1),
                        itemBuilder: (context, index) {
                          if (index >= userProvider.users.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final user = userProvider.users[index];
                          return UserCard(
                            user: user,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => UserDetailScreen(userId: user.id),
                                ),
                              );
                            },
                            onEdit: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CreateUserScreen(
                                    user: user,
                                    isEdit: true,
                                  ),
                                ),
                              );
                            },
                            onDelete: () {
                              _showDeleteDialog(context, user.id, user.fullName);
                            },
                          );
                        },
                      ),
                    ),
          // Create new user 
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateUserScreen(),
                ),
              );
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, int userId, String userName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: Text('Are you sure you want to delete $userName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                userProvider.deleteUser(userId);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
