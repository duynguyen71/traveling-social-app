import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/login/login_screen.dart';
import 'package:traveling_social_app/screens/register/components/register_background.dart';
import 'package:traveling_social_app/screens/verification/verification_screen.dart';
import 'package:traveling_social_app/services/user_service.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/widgets/already_have_account_check.dart';
import 'package:traveling_social_app/widgets/custom_text_form_field.dart';
import 'package:traveling_social_app/widgets/rounded_button.dart';
import 'package:traveling_social_app/widgets/rounded_input_container.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isLoading = false;
  bool _isHidePassword = true;

  String? _errorMessage;

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _userService = UserService();

  Future<void> handleRegister() async {
    ApplicationUtility.hideKeyboard();
    if (_errorMessage != null) return;
    final username = _usernameController.text.toString();
    if (username.isEmpty || username.length < 4) {
      setError('Tên tài khoản phải ít nhất 4 ký tự!');
      return;
    }
    final email = _emailController.text.toString();
    if (email.isEmpty) {
      setError('Email không hợp lệ');
      return;
    }
    final password = _passwordController.text.toString();
    if (password.isEmpty || password.length < 6) {
      setError('Mật khẩu phải ít nhất 6 ký tự!');
      return;
    }
    setLoading(true);
    try {
      await _userService.register(
          username: username, email: email, password: password);
      ApplicationUtility.navigateToScreen(context, const VerificationScreen());
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  setError(String? err) {
    setState(() {
      _errorMessage = err;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> onInputValueChange(input) async {
    setState(() {
      _errorMessage = null;
    });
    String? error;
    switch (input) {
      case 'username':
        {
          error = await _userService.checkValidationInput(
              input: input, value: _usernameController.text.toString());
          break;
        }
      case 'email':
        {
          error = await _userService.checkValidationInput(
              input: input, value: _emailController.text.toString());
          break;
        }
    }
    setState(() {
      _errorMessage = error;
    });
  }

  @override
  void initState() {
    int i = DateTime.now().millisecondsSinceEpoch;
    _usernameController.text = i.toString();
    _emailController.text = '$i@gmail.com';
    _passwordController.text = 'password';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: RegisterBackground(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              // autovalidateMode: AutovalidateMode.always,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'TC TRAVEL',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: size.height * .03),
                  //USERNAME INPUT
                  RoundedInputContainer(
                    child: CustomTextFormField(
                      validator: (value) {},
                      controller: _usernameController,
                      hintText: 'Nhập tên đăng nhập ',
                      iconData: Icons.person,
                      onChange: (String value) {
                        onInputValueChange('username');
                      },
                    ),
                  ),
                  SizedBox(height: size.height * .015),
                  //EMAIL INPUT
                  RoundedInputContainer(
                    child: CustomTextFormField(
                      validator: (value) {},
                      controller: _emailController,
                      hintText: 'Nhập email ',
                      iconData: Icons.person,
                      onChange: (String value) {
                        onInputValueChange('email');
                      },
                    ),
                  ),
                  SizedBox(height: size.height * .015),
                  //PASSWORD INPUT
                  RoundedInputContainer(
                    child: TextFormField(
                      validator: (text) {
                        return null;
                      },
                      controller: _passwordController,
                      obscureText: _isHidePassword,
                      decoration: InputDecoration(
                        hintText: "Nhập mật khẩu",
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
                  SizedBox(height: size.height * .015),
                  //ERR MESSAGE
                  SizedBox(
                    width: size.width * .8,
                    height: size.height * .03,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Visibility(
                        visible: _errorMessage != null,
                        child: Text(
                          _errorMessage.toString(),
                          style: TextStyle(
                            color: Colors.red[500],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //  END OF ERR MSG
                  SizedBox(height: size.height * .03),
                  //REGISTER BUTTON
                  RoundedButton(
                    text: 'Đăng kí',
                    onPress: () async => await handleRegister(),
                    textColor: Colors.white,
                    bgColor: kLoginPrimaryColor,
                  ),
                  //Already have account check
                  SizedBox(height: size.height * .03),
                  AlreadyHaveAccountCheck(
                      isLogin: false,
                      onPress: () => ApplicationUtility.pushAndReplace(
                          context, const LoginScreen())),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
