import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MyJourneySubScreen extends StatelessWidget {
  const MyJourneySubScreen({super.key});


  Widget baseColumn(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
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