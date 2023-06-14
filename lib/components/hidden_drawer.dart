import 'package:flutter/material.dart';

class HiddenDrawer extends StatelessWidget {
  const HiddenDrawer({
    super.key,
    required this.child,
    required this.width,
  });

  final Widget? child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: width!,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 64),
        child:child
      )
    );
  }
}