import 'package:flutter/material.dart';

class TapEffectWidget extends StatelessWidget {
  const TapEffectWidget(
      {Key? key, required this.child, required this.tap, this.onLongPress})
      : super(key: key);
  final Widget child;
  final Function tap;
  final Function? onLongPress;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          tap();
        },
        onLongPress: () => onLongPress != null ? onLongPress!() : () {},
        child: Ink(
          child: child,
        ),
      ),
    );
  }
}
