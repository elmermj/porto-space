import 'package:flutter/material.dart';
import 'package:porto_space/misc/color_schemes.g.dart';

class Constants {
  static Color portoWhite = const Color.fromARGB(255, 251, 255, 255);
  static Color trim1Color = const Color.fromARGB(255, 195, 240, 255);
  static Color mainTextColor = const Color.fromARGB(255, 33, 62, 72);
  static double textMicro= 8;
  static double textS = 10;
  static double textM = 12;
  static double textSL = 14;
  static double textL = 16;
  static double textXL = 18;
  static EdgeInsetsGeometry standardInset = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8);
  static EdgeInsetsGeometry startParagraphInset = const EdgeInsets.fromLTRB(16, 8, 16, 0);
  static BorderSide borderSideSoft = const BorderSide(
    width: 1,
    color: Color.fromRGBO(227, 227, 227, 1)
  );

  static BoxDecoration linearGradientBackground = BoxDecoration(
                                                    gradient: LinearGradient(
                                                    colors: [
                                                      const Color.fromARGB(255, 251, 255, 255),
                                                      lightColorScheme.secondaryContainer
                                                    ],
                                                    begin: const FractionalOffset(0, 0),
                                                    end: const FractionalOffset(0, 1.0),
                                                    stops: const [0.5, 1.0],
                                                    tileMode: TileMode.clamp),
                                                  );

  static BoxDecoration linearGradientBackgroundChat = const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 183, 203, 246),
                  Color.fromARGB(255, 219, 251, 251),
                  Color.fromARGB(255, 183, 203, 246)
                ],
                begin: FractionalOffset(0, 0),
                end: FractionalOffset(0, 1.0),
                stops: [0, 0.5, 1.0],
                tileMode: TileMode.clamp),
            );

  
  determineColor({String?  projectStatus}){
    Color? color;

    switch(projectStatus){
      case 'Initial':
        color = const Color.fromARGB(255, 88, 233, 255);
        debugPrint(projectStatus);
        return color;
      case 'In Progress':
        color = const Color.fromARGB(255, 88, 191, 255);
        debugPrint(projectStatus);
        return color;
      case 'On Pause':
        color = const Color.fromARGB(255, 232, 216, 39);
        debugPrint(projectStatus);
        return color;
      case 'Completed':
        color = const Color.fromARGB(255, 102, 255, 88);
        debugPrint(projectStatus);
        return color;
      case 'Cancelled':
        color = const Color.fromARGB(255, 255, 88, 88);
        debugPrint(projectStatus);
        return color;
    }
  }
}

