import 'package:flutter/material.dart';

class KeepAliveWidget extends StatefulWidget {
  const KeepAliveWidget(
      {Key? key, this.wantKeepAlive = true, required this.child})
      : super(key: key);

  final bool wantKeepAlive;
  final Widget child;

  @override
  State<KeepAliveWidget> createState() => _KeepAliveWidgetState();
}

class _KeepAliveWidgetState extends State<KeepAliveWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container();
  }

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;
}
