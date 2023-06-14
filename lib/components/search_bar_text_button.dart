import 'package:flutter/material.dart';
import 'package:porto_space/misc/misc_index.dart';

class SearchBarTextButton extends StatelessWidget {
  const SearchBarTextButton({
    super.key,
    required this.buttonName,
    required this.color,
    required this.onPressed,
  });

  final String? buttonName;
  final Color? color;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
        ),
        onPressed: onPressed, 
        child: Text(
          buttonName!,
          style: TextStyle(
            color: color,
            fontSize: Constants.textM
          )
        )
      ),
    );
  }
}
