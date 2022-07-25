import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/widgets/config_widget.dart';
import 'package:traveling_social_app/widgets/loading_widget.dart';

class LoginBackground extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const LoginBackground(
      {Key? key, required this.child, required this.isLoading})
      : super(key: key);

  @override
  State<LoginBackground> createState() => _LoginBackgroundState();
}

class _LoginBackgroundState extends State<LoginBackground> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: Image.asset(
              "assets/images/bottom_left.png",
            ),
            bottom: 0,
            left: 0,
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset("assets/images/top_left.png",
                width: size.width * .3),
          ),
          widget.child,
          const Positioned(
            child: ConfigWidget(),
            bottom: 0,
            left: 0,
          ),
          LoadingWidget(isLoading: widget.isLoading)
        ],
      ),
    );
  }
}
