import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomeSearchResultScreen extends StatelessWidget {
  const HomeSearchResultScreen({super.key, this.keywords});

  final keywords;

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