import 'package:flutter/material.dart';

class RoundedIconButton extends StatelessWidget {
  const RoundedIconButton(
      {Key? key, required this.onClick, required this.icon, this.iconColor})
      : super(key: key);

  final Function onClick;
  final IconData icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.5),
        borderRadius: BorderRadius.circular(100),
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
