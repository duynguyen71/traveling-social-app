import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField({
    Key? key,
    this.hintText,
    this.iconData,
    required this.onChange,
    required this.controller,
    this.focusNode,
    this.textInputAction,
    this.onSubmit,
  }) : super(key: key);

  final String? hintText;
  final IconData? iconData;
  final ValueChanged<String> onChange;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function(String value)? onSubmit;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      onFieldSubmitted: (value) async {
        onSubmit != null ? await onSubmit!(value) : () {};
      },
      controller: controller,
      focusNode: focusNode,
      onChanged: (text) => onChange(text),
      decoration: InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white),
        icon: Icon(
          iconData,
          color: Colors.white,
        ),
      ),
    );
  }
}
