import 'package:flutter/material.dart';

class MyTextIconButton extends StatelessWidget {
  const MyTextIconButton(
      {Key? key,
      required this.text,
      required this.icon,
      this.bgColor,
      this.textColor,
      required this.onTap})
      : super(key: key);
  final Function onTap;
  final String text;
  final IconData icon;
  final Color? bgColor, textColor;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      alignment: Alignment.center,
      child: Container(
        // constraints: BoxConstraints(maxWidth: 100),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: bgColor ?? Colors.grey.shade400,
            borderRadius: BorderRadius.circular(20)),
        child: TextButton(
          style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              alignment: Alignment.center,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          onPressed: () => onTap(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text,
                style:
                    TextStyle(fontSize: 12, color: textColor ?? Colors.white),
              ),
              Center(
                  child: Icon(
                icon,
                size: 14,
                color: Colors.white,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
