import 'package:flutter/material.dart';

class MyJourneySubScreen extends StatelessWidget {
  const MyJourneySubScreen({super.key});


  Widget baseColumn(){
    return const SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("My Journey")
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return baseColumn();
  }
}