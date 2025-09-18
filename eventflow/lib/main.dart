// import 'package:eventflow/screens/event_details.dart';
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
      home: MainScreen(), // Start directly on the Home page
      // home: EventDetails(), // Start directly on the Home page
    );
  }
}
