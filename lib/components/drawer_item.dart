import 'package:flutter/material.dart';
import 'package:porto_space/misc/misc_index.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  final String? text;
  final IconData? icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      child: GestureDetector(
        onTap: onTap,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(text!, textAlign: TextAlign.center, 
            softWrap: true,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: Constants.textM,
            ),
          ),
        ),
      )
    );
  }
}