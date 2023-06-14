import 'package:flutter/material.dart';
import 'package:porto_space/misc/misc_index.dart';

class ChatAppBar extends StatelessWidget {
  const ChatAppBar({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String? title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight, 
      child: Row(
        children: [
          Expanded(flex: 1, 
            child: GestureDetector(
              onTap: onTap,
              child: const Icon(Icons.arrow_back_ios_new),
            )
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(title!,
                style: TextStyle(
                  fontSize: Constants.textXL, 
                  fontWeight: FontWeight.w700
                ),
              ),
            ),
          ),
      ],
      )
    );
  }
}