import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';

class RoundedInputContainer extends StatelessWidget {
  const RoundedInputContainer(
      {Key? key,
      required this.child,
      this.width,
      this.color,
      this.borderRadius,
      this.margin,
      this.padding})
      : super(key: key);

  final Widget child;
  final double? width;
  final Color? color;
  final double? borderRadius;
  final EdgeInsets? margin, padding;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: width ?? size.width * .8,
      margin: margin ?? const EdgeInsets.symmetric(vertical: 10),
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: 5),
      decoration: BoxDecoration(
        color: color ?? kLoginPrimaryColor.withOpacity(.4),
        borderRadius: BorderRadius.circular(borderRadius ?? 40),
      ),
      child: child,
    );
  }
}
