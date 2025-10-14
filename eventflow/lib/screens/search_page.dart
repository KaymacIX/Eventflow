import 'package:eventflow/widgets/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:eventflow/widgets/app_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Appbar(title: 'Search'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(children: [SizedBox(height: 20), SearchTextField()]),
      ),
    );
  }
}
