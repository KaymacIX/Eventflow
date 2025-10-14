// import 'package:eventflow/screens/event_details.dart';
import 'package:eventflow/screens/auth/login_screen.dart';
import 'package:eventflow/screens/auth/register_screen.dart';
import 'package:eventflow/screens/profile_page.dart';
import 'package:eventflow/screens/home.dart';
import 'package:flutter/material.dart';

// ignore: unused_import
import 'mainscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
