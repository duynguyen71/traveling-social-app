import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/login/components/login_background.dart';
import 'package:traveling_social_app/screens/register/register_screen.dart';
import 'package:traveling_social_app/services/user_service.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/widgets/already_have_account_check.dart';
import 'package:traveling_social_app/widgets/custom_input_field.dart';
import 'package:traveling_social_app/widgets/my_divider.dart';
import 'package:traveling_social_app/widgets/rounded_button.dart';
import 'package:traveling_social_app/widgets/rounded_input_container.dart';

import '../../repository/authentication_repository/authentication_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();

  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => const LoginScreen());
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _isHidePassword = true;
  String? _errorMessage;
  late UserService _userService;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  //handle login
  Future<void> _handleLogin() async {
    setState(() {
      _errorMessage = null;
    });
    ApplicationUtility.hideKeyboard();
    final username = _usernameController.text.toString();
    final password = _passwordController.text.toString();

    if (username.isEmpty) {
      _setErrorMessage('Tên tài khoản không được để trống');
      return;
    }
    if (password.isEmpty) {
      _setErrorMessage('Mật khẩu không được để trống');
      return;
    }
    _showLoadingIndicator(true);
    try {
      await context
          .read<AuthenticationRepository>()
          .logIn(username: username, password: password);
    } on SocketException catch (e) {
      print("Socket Exception " + e.toString());
      _showSocketErrAlertDialog();
    } catch (e) {
      _setErrorMessage(e.toString());
      print("Failed to login" + e.toString());
    } finally {
      _showLoadingIndicator(false);
    }
  }

  void _showSocketErrAlertDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Thông báo"),
            content: const Text("Lỗi bất định. Vui lòng đăng nhập lại"),
            actions: [
              CupertinoDialogAction(
                child: const Text("Got it"),
                isDefaultAction: true,
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        },
        barrierDismissible: false);
  }

  void _showLoadingIndicator(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  void _setErrorMessage(String? message) {
    setState(() {
      _errorMessage = message;
    });
  }

  @override
  void initState() {
    _isLoading = false;
    _userService = UserService();
    //
    // _usernameController.text = 'kddevit';
    // _passwordController.text = 'password';
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoginBackground(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Container(
            alignment: Alignment.center,
            height: size.height,
            color: Colors.white,
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //APP NAME
                const Text(
                  'TC TRAVEL',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: size.height * .03),

                //FORM
                Column(
                  children: [
                    //USERNAME
                    RoundedInputContainer(
                      child: CustomInputField(
                        controller: _usernameController,
                        hintText: 'Tên hoặc email',
                        iconData: Icons.person,
                        onChange: (value) => _setErrorMessage(null),
                      ),
                    ),
                    //PASSWORD
                    RoundedInputContainer(
                      child: TextField(
                        onChanged: (value) => _setErrorMessage(null),
                        obscureText: _isHidePassword,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: "Mật khẩu",
                          hintStyle: const TextStyle(color: Colors.white),
                          border: InputBorder.none,
                          icon: const Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_isHidePassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                _isHidePassword = !_isHidePassword;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    //ERROR MESSAGE
                    SizedBox(height: size.height * .015),
                    SizedBox(
                      width: size.width * .8,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Visibility(
                          visible: _errorMessage != null,
                          child: Text(_errorMessage.toString(),
                              style: TextStyle(
                                color: Colors.red[600],
                                fontStyle: FontStyle.italic,
                              )),
                        ),
                      ),
                    ),
                    //  Login Button
                    SizedBox(height: size.height * .03),
                    RoundedButton(
                      text: 'Đăng nhập',
                      onPress: () async => await _handleLogin(),
                      textColor: Colors.white,
                      bgColor: kLoginPrimaryColor,
                    ),
                    //Already have account check
                    SizedBox(height: size.height * .01),
                    AlreadyHaveAccountCheck(
                      isLogin: true,
                      onPress: () => ApplicationUtility.pushAndReplace(
                        context,
                        const RegisterScreen(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * .01),
                SizedBox(
                  width: size.width * .8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: MyDivider(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      Expanded(
                        child: Center(child: Text("hoặc")),
                      ),
                      Expanded(
                        child: MyDivider(
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * .02),
                SignInButton(
                  Buttons.Google,
                  onPressed: () {},
                  text: 'Đăng nhập với Google',
                  elevation: 0,
                ),
                SignInButton(Buttons.Facebook,
                    onPressed: () {},
                    elevation: 0,
                    text: 'Đăng nhập với Facebook'),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Quên mật khẩu?',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
