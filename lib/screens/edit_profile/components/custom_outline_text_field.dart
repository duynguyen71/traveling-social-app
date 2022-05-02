import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomOutlineTextField extends StatefulWidget {
  const CustomOutlineTextField({
    Key? key,
    required this.hintText,
    required this.labelText,
    required this.controller,
    required this.validate,
    this.onChange,
  }) : super(key: key);

  final String hintText;
  final String? labelText;
  final TextEditingController? controller;
  final Function? validate;
  final Function? onChange;

  @override
  _CustomOutlineTextFieldState createState() => _CustomOutlineTextFieldState();
}

class _CustomOutlineTextFieldState extends State<CustomOutlineTextField> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      width: size.width * .8,
      child: TextFormField(
        onChanged: (value) {
          if (this.widget.onChange != null) {
            return this.widget.onChange!(value);
          }
        },
        validator: (value) => widget.validate!(value),
        controller: this.widget.controller,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.all(10),
          labelText: this.widget.labelText,
          hintText: this.widget.hintText,
          hintStyle: TextStyle(
            fontSize: 18,
            color: Colors.black38,
          ),
        ),
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
