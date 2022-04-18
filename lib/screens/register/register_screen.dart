import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/login/login_screen.dart';
import 'package:traveling_social_app/screens/register/components/register_background.dart';
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
  bool isLoading = false;
  String? errorMessage;

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<dynamic> navigateToScreen(BuildContext c, Widget screen) {
    return Navigator.push(c, MaterialPageRoute(builder: (c) => screen));
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
        body: RegisterBackground(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width * .8,
                      child: Visibility(
                        visible: isLoading,
                        child: const LinearProgressIndicator(),
                      ),
                    ),
                    SizedBox(height: size.height * .03),
                    const Text(
                      'REGISTER',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: size.height * .03),
                    //ERR MESSAGE
                    SizedBox(
                      width: size.width * .8,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Visibility(
                          visible: errorMessage != null,
                          child: Text(
                            errorMessage.toString(),
                            style: TextStyle(
                              color: Colors.red[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ),
                    //  END OF ERR MSG
                    SizedBox(height: size.height * .03),
                    //EMAIL INPUT
                    RoundedInputContainer(
                      child: CustomTextFormField(
                        validator: (value) {},
                        controller: _usernameController,
                        hintText: 'enter your email ',
                        iconData: Icons.person,
                        onChange: (String value) {},
                      ),
                    ),
                    SizedBox(height: size.height * .03),
                    //PASSWORD INPUT
                    RoundedInputContainer(
                      child: TextFormField(
                        validator: (text) {
                          if (text == null) {
                            return "Required password";
                          } else if (text.length < 3) {
                            return "Password must be at least 4 characters or more";
                          }
                        },
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                            suffixIcon: Icon(
                              Icons.visibility,
                              color: Colors.white,
                            )),
                      ),
                    ),
                    //REGISTER BUTTON
                    RoundedButton(
                      text: 'Register',
                      onPress: () =>
                          navigateToScreen(context, const LoginScreen()),
                      textColor: Colors.white,
                      bgColor: kLoginPrimaryColor,
                    ),
                    //Already have account check
                    SizedBox(height: size.height * .03),
                    AlreadyHaveAccountCheck(
                        isLogin: false,
                        onPress: () =>
                            navigateToScreen(context, const LoginScreen())),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
