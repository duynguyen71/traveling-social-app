import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';

class AlreadyHaveAccountCheck extends StatelessWidget {
  const AlreadyHaveAccountCheck({
    Key? key,
    required this.isLogin,
    required this.onPress,
  }) : super(key: key);
  final bool isLogin;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * .8,
      child: GestureDetector(
        onTap: () => onPress(),
        child: RichText(
          textAlign: TextAlign.end,
          text: TextSpan(children: [
            TextSpan(
              // text: isLogin ? "Don't have account?" : "Already have account?",
              text: isLogin ? "Chưa có tài khoản?" : "Đã có tài khoản?",
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            TextSpan(
              // text: isLogin ? " Sign up" : " Sign in",
              text: isLogin ? " Đăng kí" : " Đăng nhập",
              style: const TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
