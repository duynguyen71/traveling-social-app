import 'package:flutter/material.dart';
class RoundedIconButton extends StatelessWidget {
  const RoundedIconButton({Key? key, required this.onClick, required this.icon}) : super(key: key);

  final Function onClick;
  final IconData icon;
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
        icon:  Icon(
        icon,
          color: Colors.white,
          size: 15,
        ),
      ),
    );
  }
}
