import 'package:flutter/material.dart';
import 'package:porto_space/misc/constants.dart';

class Components{

  Widget cTab({
    required String? text
  }){
    return Tab(text: text, height: 30);
  }

  Widget cEduDialogTitle({
    String? title
  }){
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color.fromRGBO(227, 227, 227, 1)
          )
        )
      ),
      child: Text(title!, textAlign: TextAlign.center, style: TextStyle(
        fontSize: Constants.textXL, fontWeight: FontWeight.w600
      ),)
    );
  }

  Widget cEduDialogContent({
    Key? key,
    required List<Widget> children
  }){
    return Form(
      key: key, 
      child: Column(
        children: children
      )
    );
  }
}