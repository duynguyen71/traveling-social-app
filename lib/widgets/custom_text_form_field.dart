import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {Key? key,
        this.hintText,
        this.iconData,
        required this.onChange,
        required this.controller,
        required this.validator,
        this.node})
      : super(key: key);

  final String? hintText;
  final IconData? iconData;
  final ValueChanged<String> onChange;
  final TextEditingController controller;
  final Function validator;
  final FocusNode? node;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) => validator(value),
      controller: controller,
      focusNode: node,
      onChanged: (text) => onChange(text),
      decoration: InputDecoration(
        hintText: hintText ?? '',
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
