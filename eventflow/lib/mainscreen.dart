import 'package:flutter/material.dart';

import 'package:eventflow/screens/home.dart';
import 'package:eventflow/screens/search_page.dart';

import 'package:eventflow/widgets/bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Home(),         // Your Home page
    SearchPage(),   // Replace with your actual pages
    // TicketsPage(),
    // FavoritesPage(),
    // ProfilePage(),
  ];

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottonNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}