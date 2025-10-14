import 'package:eventflow/screens/event_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventflow/providers/event_provider.dart';

// ignore: unused_import
import 'mainscreen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
