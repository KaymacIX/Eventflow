import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventflow/providers/auth_provider.dart';
import 'package:eventflow/widgets/app_bar.dart';
import 'package:eventflow/widgets/custom_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoggingOut = false;

  Future<void> _handleLogout() async {
    setState(() => _isLoggingOut = true);
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    
    setState(() => _isLoggingOut = false);
    
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully')),
    );
    
    // Navigation is handled automatically by AuthWrapper in main.dart
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Appbar(title: 'Profile'),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;
          final userName = user?['name'] ?? 'John Doe';
          final userEmail = user?['email'] ?? 'johndoe@email.com';

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 20),
                              CircleAvatar(
                                radius: 70,
                                backgroundColor: const Color(0xFF13D0A1),
                                backgroundImage: user?['profile_photo_path'] != null
                                    ? NetworkImage(user!['profile_photo_path'])
                                    : null,
                                child: user?['profile_photo_path'] == null
                                    ? const Icon(Icons.person, size: 50, color: Colors.white)
                                    : null,
                              ),
                              SizedBox(height: 16),
                              Text(
                                userName,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                userEmail,
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                    SizedBox(height: 60),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        ListTile(
                          leading: Icon(Icons.location_city),
                          title: Text('Primary City'),
                          trailing: Text(
                            'Lusaka',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          onTap: () {
                            // Navigate to Primary City selection page
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.settings),
                          title: Text('Settings'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Navigate to Settings page
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.person_outline),
                          title: Text('Account Settings'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Handle logout
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
                CustomButton(
                  text: 'Logout',
                  isLoading: _isLoggingOut,
                  enabled: !_isLoggingOut,
                  onPressed: _handleLogout,
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
