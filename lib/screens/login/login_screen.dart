import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/home/home_screen.dart';
import 'package:traveling_social_app/screens/login/components/login_background.dart';
import 'package:traveling_social_app/screens/register/register_screen.dart';
import 'package:traveling_social_app/services/user_service.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/view_model/loading_viewmodel.dart';
import 'package:traveling_social_app/view_model/user_viewmodel.dart';
import 'package:traveling_social_app/widgets/already_have_account_check.dart';
import 'package:traveling_social_app/widgets/custom_input_field.dart';
import 'package:traveling_social_app/widgets/rounded_button.dart';
import 'package:traveling_social_app/widgets/rounded_input_container.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
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
    ApplicationUtility.hideKeyboard();
    final username = _usernameController.text.toString();
    final password = _passwordController.text.toString();
    if (username.isEmpty) {
      _setErrorMessage('username must not be empty');
      return;
    }
    if (password.isEmpty) {
      _setErrorMessage('password must not be empty');
      return;
    }
    _showLoadingIndicator(true);
    try {
      await _userService.login(username, password);
      await context.read<UserViewModel>().fetchUserDetail();
      ApplicationUtility.pushAndReplace(context, const HomeScreen());
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _showLoadingIndicator(false);
    }
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
    _usernameController.text = 'nguyenkhanhduy21123@gmail.com';
    _passwordController.text = 'password';
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
    return SafeArea(
      child: Scaffold(
        body: LoginBackground(
          isLoading: _isLoading,
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              height: size.height,
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //APP NAME
                  const Text(
                    'Traveling Crew',
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
                          hintText: 'Username',
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
                            hintText: "Password",
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
                        text: 'Login',
                        onPress: () async => await _handleLogin(),
                        textColor: Colors.white,
                        bgColor: kLoginPrimaryColor,
                      ),
                      //Already have account check
                      SizedBox(height: size.height * .03),
                      AlreadyHaveAccountCheck(
                        isLogin: true,
                        onPress: () => ApplicationUtility.pushAndReplace(
                            context, const RegisterScreen()),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
