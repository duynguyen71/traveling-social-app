import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingItemLeading extends StatelessWidget {
  const SettingItemLeading(
      {Key? key,
      required this.asset,
      this.bg = Colors.black12,
      this.color = Colors.white})
      : super(key: key);

  final String asset;
  final Color bg, color;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SvgPicture.asset(
        asset,
        height: 30,
        width: 30,
        color: color,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5.0),
      ),
      padding: const EdgeInsets.all(4.0),
    );
  }
}
