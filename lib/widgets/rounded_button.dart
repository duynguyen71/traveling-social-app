import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {Key? key,
      required this.text,
      required this.bgColor,
      required this.onPress,
      required this.textColor})
      : super(key: key);

  final String text;
  final Color bgColor;
  final Function onPress;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * .8,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: bgColor,
      ),
      child: TextButton(
        onPressed: () => onPress(),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(color: textColor),
        ),
        style: TextButton.styleFrom(
          elevation: 0,
        ),
      ),
    );
  }
}
