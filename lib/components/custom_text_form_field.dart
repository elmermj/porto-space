import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {

  final String? labelText;
  final String? initialValue;
  final String? Function(String? p1)? validator;
  final TextAlign? textAlign;
  final TextStyle? style;
  final Function(String? p1)? onSaved;
  final bool? obscureText;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  const CustomTextFormField({
    super.key,
    required this.labelText,
    this.initialValue,
    required this.validator,
    this.textAlign,
    this.style,
    this.onSaved,
    this.obscureText = false,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left!,top!,right!,bottom!),
      child: TextFormField(
        style: style,
        textAlign: textAlign ?? TextAlign.start,
        initialValue: initialValue,
        validator: validator,
        onSaved: onSaved!,
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none,
          fillColor: Colors.white,
        ),
        obscureText: obscureText!,
        onChanged: (value) {
          value = value.trim();
          value = value.replaceAll(RegExp(r'\s+'), ' ');
          // debugPrint(value);
        },
      ),
    );
  }
}