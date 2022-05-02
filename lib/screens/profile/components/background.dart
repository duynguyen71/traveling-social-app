import 'package:flutter/material.dart';
import 'package:traveling_social_app/widgets/loading_widget.dart';

class CurrentUserProfileBackground extends StatelessWidget {
  const CurrentUserProfileBackground(
      {Key? key, required this.child, required this.isLoading})
      : super(key: key);
  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [child, LoadingWidget(isLoading: isLoading)],
      ),
    );
  }
}
