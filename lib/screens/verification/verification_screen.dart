import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/home/home_screen.dart';
import 'package:traveling_social_app/services/user_service.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/view_model/user_view_model.dart';
import 'package:traveling_social_app/widgets/loading_widget.dart';
import 'package:traveling_social_app/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String? errorMessage;
  bool _isLoading = false;
  final _userService = UserService();
  final _digit1 = TextEditingController();
  final _digit2 = TextEditingController();
  final _digit3 = TextEditingController();
  final _digit4 = TextEditingController();
  final _digit5 = TextEditingController();
  final _digit6 = TextEditingController();

  Future<void> handleVerifyAccount() async {
    ApplicationUtility.hideKeyboard();
    var d1 = _digit1.text.toString();
    var d2 = _digit2.text.toString();
    var d3 = _digit3.text.toString();
    var d4 = _digit4.text.toString();
    var d5 = _digit5.text.toString();
    var d6 = _digit6.text.toString();
    if (d1.isEmpty ||
        d2.isEmpty ||
        d3.isEmpty ||
        d4.isEmpty ||
        d5.isEmpty ||
        d6.isEmpty) {
      setState(() {
        errorMessage = 'Code is not valid!';
      });
    }
    try {
      setState(() {
        _isLoading = true;
      });
      await _userService.verifyAccount(code: '$d1$d2$d3$d4$d5$d6');
      await context.read<UserViewModel>().fetchUserDetail();
      ApplicationUtility.navigateToScreen(context, const HomeScreen());
      return;
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _digit1.dispose();
    _digit2.dispose();
    _digit3.dispose();
    _digit4.dispose();
    _digit5.dispose();
    _digit6.dispose();
    super.dispose();
  }

  void onChange() {
    var d1 = _digit1.text.toString();
    var d2 = _digit2.text.toString();
    var d3 = _digit3.text.toString();
    var d4 = _digit4.text.toString();
    var d5 = _digit5.text.toString();
    var d6 = _digit6.text.toString();
    print('$d1 + $d2 + $d3 + $d4 + $d5 + $d6 ');
    if (errorMessage != null) {
      setState(() {
        errorMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: Stack(
          alignment: Alignment.topLeft,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 25,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Verification',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Enter your OTP code number",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _textFieldOTP(
                                first: true,
                                last: false,
                                controller: _digit1,
                                onChange: () => onChange()),
                            _textFieldOTP(
                                first: false,
                                last: false,
                                controller: _digit2,
                                onChange: () => onChange()),
                            _textFieldOTP(
                                first: false,
                                last: false,
                                controller: _digit3,
                                onChange: () => onChange()),
                            _textFieldOTP(
                                first: false,
                                last: false,
                                controller: _digit4,
                                onChange: () => onChange()),
                            _textFieldOTP(
                                first: false,
                                last: false,
                                controller: _digit5,
                                onChange: () => onChange()),
                            _textFieldOTP(
                                first: false,
                                last: true,
                                controller: _digit6,
                                onChange: () => onChange()),
                          ],
                        ),
                        Wrap(
                          alignment: WrapAlignment.spaceAround,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: const [],
                        ),
                        const SizedBox(
                          height: 11,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            height: 18,
                            child: errorMessage != null
                                ? Text(
                                    errorMessage!,
                                    style: TextStyle(
                                        color: Colors.red[500],
                                        fontWeight: FontWeight.w400),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: RoundedButton(
                            onPress: () => handleVerifyAccount(),
                            text: 'Verify',
                            bgColor: kPrimaryColor,
                            textColor: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  const Text(
                    "Didn't you receive any code?",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black38,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  const Text(
                    "Resend new code",
                    style: TextStyle(
                      fontSize: 18,
                      color: kLoginPrimaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            LoadingWidget(isLoading: _isLoading),
          ],
        ),
      ),
    );
  }

  Widget _textFieldOTP(
      {required bool first,
      last,
      required controller,
      required Function onChange}) {
    return SizedBox(
      height: 40,
      child: AspectRatio(
        aspectRatio: 1,
        child: TextField(
          controller: controller,
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.isEmpty && first == false) {
              FocusScope.of(context).previousFocus();
            }
            onChange();
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1, color: Colors.black12),
                borderRadius: BorderRadius.circular(5)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2, color: kLoginPrimaryColor.withOpacity(.6)),
                borderRadius: BorderRadius.circular(5)),
          ),
        ),
      ),
    );
  }
}
