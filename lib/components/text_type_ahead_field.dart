import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:porto_space/misc/misc_index.dart';

class TextTypeAheadField<T> extends StatelessWidget {
  const TextTypeAheadField({
    super.key,
    required this.labelText,
    required this.controller,
    required this.margin,
    required this.validator,
    required this.suggestionsCallback,
    required this.itemBuilder,
    required this.onSuggestionSelected,
  });

  final String? labelText;
  final TextEditingController? controller;
  final EdgeInsetsGeometry? margin;
  final bool? validator;
  final FutureOr<Iterable<T>> Function(String) suggestionsCallback;
  final Widget Function(BuildContext, T) itemBuilder;
  final void Function(T) onSuggestionSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Container(
        margin: margin,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        child: TypeAheadField<T>(
          textFieldConfiguration: TextFieldConfiguration(
            textAlign: TextAlign.end,
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText!,
              border: InputBorder.none,
              fillColor: Colors.white,
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
          suggestionsCallback: suggestionsCallback, 
          itemBuilder: itemBuilder,
          onSuggestionSelected: onSuggestionSelected
        )
      ),
    );
  }
}