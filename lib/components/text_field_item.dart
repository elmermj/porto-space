import 'package:flutter/material.dart';
import 'package:porto_space/misc/misc_index.dart';

class TextFieldItem extends StatelessWidget {
  const TextFieldItem({
    super.key,
    required this.labelText,
    this.controller,
    required this.isDate,
    required this.validator,
    this.onTap,
    this.textResult,
    this.textAlign,
  });

  final String? labelText;
  final TextEditingController? controller;
  final bool isDate;
  final bool? validator;
  final void Function()? onTap;
  final String? textResult;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        decoration: BoxDecoration(
          border: Border(bottom: Constants.borderSideSoft)
        ),
        child: isDate?
        Container(
          padding: const EdgeInsets.only(left: 4,right: 4,bottom: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(labelText!,style: TextStyle(
                    fontSize: Constants.textSL,
                    fontWeight: FontWeight.normal
                  )),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                        textResult!,
                        style: TextStyle(fontSize: Constants.textL,),
                      )
                  ),
                ],
              ),
            ],
          ),
        ):
        TextField(
          textAlign: textAlign ?? TextAlign.end,
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: InputBorder.none,
            fillColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: Constants.textSL,
            )
          ),
          style: TextStyle(
            fontSize: Constants.textL,
          ),
          onChanged: (value) {
            value = value.trim();
            value = value.replaceAll(RegExp(r'\s+'), ' ');
            // debugPrint(value);
          },
        ),
      ),
    );
  }
}