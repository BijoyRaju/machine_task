import 'package:flutter/material.dart';
import 'package:machine_task/models/user.dart';
import 'package:machine_task/providers/user_provider.dart';
import 'package:provider/provider.dart';


class CreateUserScreen extends StatefulWidget {
  final User? user;
  final bool isEdit;

  const CreateUserScreen({
    super.key,
    this.user,
    this.isEdit = false,
  });

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _avatarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.user != null) {
      _firstNameController.text = widget.user!.firstName;
      _lastNameController.text = widget.user!.lastName;
      _emailController.text = widget.user!.email;
      _avatarController.text = widget.user!.avatar;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
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
            title: Text(widget.isEdit ? 'Edit User' : 'Create User'),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: userProvider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                widget.isEdit ? Icons.edit : Icons.person_add,
                                size: 40,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                widget.isEdit ? 'Edit User Information' : 'Create New User',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.isEdit
                                    ? 'Update the user information below'
                                    : 'Fill in the details to create a new user',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Form Fields
                        _buildTextField(
                          controller: _firstNameController,
                          label: 'First Name',
                          icon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter first name';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        _buildTextField(
                          controller: _lastNameController,
                          label: 'Last Name',
                          icon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter last name';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        _buildTextField(
                          controller: _avatarController,
                          label: 'Avatar URL (Optional)',
                          icon: Icons.image,
                          keyboardType: TextInputType.url,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final uri = Uri.tryParse(value);
                              if (uri == null || !uri.hasAbsolutePath) {
                                return 'Please enter a valid URL';
                              }
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Cancel'),
                              ),
                            ),

                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    final user = User(
                                      id: widget.isEdit ? (widget.user?.id ?? 0) : 0,
                                      firstName: _firstNameController.text.trim(),
                                      lastName: _lastNameController.text.trim(),
                                      email: _emailController.text.trim(),
                                      avatar: _avatarController.text.trim().isEmpty
                                          ? 'https://via.placeholder.com/150'
                                          : _avatarController.text.trim(),
                                    );

                                    if (widget.isEdit && widget.user != null) {
                                      userProvider.updateUser(widget.user!.id, user);
                                    } else {
                                      userProvider.createUser(user);
                                    }
                                    
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          widget.isEdit 
                                              ? 'User updated successfully' 
                                              : 'User created successfully',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(widget.isEdit ? 'Update User' : 'Create User'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}
