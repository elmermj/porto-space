import 'package:flutter/material.dart';
import 'package:porto_space/misc/misc_index.dart';

class ProfileIcon50 extends StatelessWidget {
  ProfileIcon50({
    super.key,
    this.condition,
    required this.name,
  });

  var condition;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: const ShapeDecoration(
            shape: StarBorder.polygon(
              sides: 6,
              pointRounding: 0.4,
            ),
            color: Colors.black
          ),
        ),
        condition==null? Text(
          name!,
          style: TextStyle(
            fontSize: Constants.textS
          ),
          maxLines: 1,
          textAlign: TextAlign.center,
        ):
        condition? Text(
          name!,
          style: TextStyle(
            fontSize: Constants.textS
          ),
          maxLines: 1,
          textAlign: TextAlign.center,
        ):
        const Text(
          "You"
        )
      ],
    );
  }
}