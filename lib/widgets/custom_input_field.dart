import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField(
      {Key? key,
      this.hintText,
      this.iconData,
      required this.onChange,
      required this.controller,
})
      : super(key: key);

  final String? hintText;
  final IconData? iconData;
  final ValueChanged<String> onChange;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
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
