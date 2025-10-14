import 'package:flutter/material.dart';

import 'package:eventflow/screens/auth/login_screen.dart';
import 'package:eventflow/widgets/app_bar.dart';
import 'package:eventflow/widgets/custom_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Appbar(title: 'Profile'),
      body: Padding(
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
                            backgroundColor: Color(0xFF13D0A1),
                            backgroundImage: AssetImage('assets/images/profile.jpg'),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'John Doe',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'johndoe@email.com',
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
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
