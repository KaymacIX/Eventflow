import 'package:flutter/material.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget{
  const Appbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Home',
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),),
    backgroundColor: Colors.white,
    elevation: 0.0,
    centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  
}