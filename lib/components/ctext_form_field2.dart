import 'package:flutter/material.dart';
import 'package:porto_space/misc/color_schemes.g.dart';
import 'package:porto_space/misc/misc_index.dart';

class CTextFormField2 extends StatelessWidget {
  const CTextFormField2({
    super.key,
    required this.hintText,
    required this.labelText,
    this.initialValue,
    this.validator,
    required this.onSaved,
    this.keyboardType,
  });

  final String? hintText;
  final String? labelText;
  final String? initialValue;
  final String? Function(String? p1)? validator;
  final void Function(String? p1)? onSaved;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8,2,8,2),
      child: TextFormField(
        initialValue: initialValue,
        onSaved: onSaved,
        maxLines: 15,
        minLines: 1,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintStyle: TextStyle(
            fontSize: Constants.textM
          ),
          labelStyle: TextStyle(
            fontSize: Constants.textM
          ),
          contentPadding: const EdgeInsets.fromLTRB(12,1,12,1),
          hintText: hintText,
          filled: true,
          labelText: labelText,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(6)),                      
          ),
          fillColor: lightColorScheme.onPrimary
        ),
        style: TextStyle(
          fontSize: Constants.textM
        ),
        onChanged: (value) {
          value = value.trim();
          value = value.replaceAll(RegExp(r'\s+'), ' ');
          // debugPrint(value);
        },
      )
    );
  }
}