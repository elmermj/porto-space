import 'package:flutter/material.dart';

class HomeSearchResultScreen extends StatelessWidget {
  const HomeSearchResultScreen({super.key, this.keywords});

  final String? keywords;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result(s) for '$keywords'"),
      ),
      body: Center(
        child: Text("Keywords: '$keywords'"),
      ),
    );
  }
}