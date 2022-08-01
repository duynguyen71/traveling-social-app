import 'package:flutter/cupertino.dart';

class RoundedBackgroundIcon extends StatelessWidget {
  const RoundedBackgroundIcon(
      {Key? key, required this.bgColor, required this.icon, required this.size})
      : super(key: key);

  final Color bgColor;
  final Icon icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(size)),
      child: icon,
    );
  }
}
