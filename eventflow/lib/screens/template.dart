import 'package:flutter/material.dart';
import 'package:eventflow/widgets/bottom_nav_bar.dart';

class Template extends StatefulWidget {
  const Template({super.key});

  @override
  State<Template> createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          // Your widgets here
        ],
      ),
      // bottomNavigationBar: BottonNavBar(
      //   currentIndex: _selectedIndex,
      //   onTap: _onNavBarTap,
      // ),
    );
  }
}

AppBar appBar() {
  return AppBar(
    title: Text(
      'Home',
      style: TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    backgroundColor: Colors.white,
    elevation: 0.0,
    centerTitle: true,
  );
}
