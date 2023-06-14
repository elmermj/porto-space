import 'package:flutter/material.dart';

class TweenAnimateBody extends StatelessWidget {
  const TweenAnimateBody({
    super.key,
    required this.screenWidth,
    required this.offsetTweenValue,
    required this.scaleTweenValue,
    required this.matrixTweenValue,
    required this.body,
  });

  final double screenWidth;
  final double offsetTweenValue;
  final double scaleTweenValue;
  final double matrixTweenValue;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: offsetTweenValue), 
      duration: const Duration(milliseconds: 200), 
      builder: (context , val, widget){
        return Transform.translate(
          offset: Offset(-(screenWidth*val), 0),
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: scaleTweenValue),
            duration: const Duration(milliseconds: 200), 
            builder:(context , scale, widget) {
              return Transform.scale(
                scale: scale,
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: matrixTweenValue),
                  duration: const Duration(milliseconds: 200), 
                  builder:(context , rotate, widget) {
                    return Transform(
                      alignment: Alignment.centerLeft,
                      transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      // ..rotateX(-rotate*1.5)
                      ..rotateY(-rotate)
                      // ..rotateZ(rotate)
                      ,
                      child: body
                    );
                  }
                )
              );
            }
          ),
        );
      }
    );
  }
}