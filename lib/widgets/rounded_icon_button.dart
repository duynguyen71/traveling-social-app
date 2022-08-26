import 'package:flutter/material.dart';

class RoundedIconButton extends StatelessWidget {
  const RoundedIconButton(
      {Key? key,
      required this.onClick,
      required this.icon,
      this.iconColor,
      required this.size,
      this.bgColor})
      : super(key: key);

  final Function onClick;
  final IconData icon;
  final Color? iconColor;
  final Color? bgColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: size,
      // width: size,
      constraints: BoxConstraints(
        maxWidth: size,
        maxHeight: size,
      ),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.black.withOpacity(.5),
        borderRadius: BorderRadius.circular(size),
      ),
      child: IconButton(
        onPressed: () => onClick(),
        constraints: const BoxConstraints(),
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          size: 15,
          color: Colors.white,
        ),
      ),
    );
  }
}
