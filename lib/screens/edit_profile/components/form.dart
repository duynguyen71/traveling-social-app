import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/models/User.dart';

import 'custom_outline_text_field.dart';
import 'custom_small_buttom.dart';
import 'package:provider/provider.dart';

class UserInfoForm extends StatefulWidget {
  const UserInfoForm({
    Key? key,
    required this.userModel,
  }) : super(key: key);
  final User userModel;

  @override
  _UserInfoFormState createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  final _formKey = GlobalKey<FormState>();
  var usernameController = TextEditingController();
  var bioController = TextEditingController();
  var fullNameController = TextEditingController();
  var locationController = TextEditingController();
  var phoneController = TextEditingController();

  String errMesssage = "";

  User get getUser {
    return this.widget.userModel;
  }

  @override
  void initState() {
    usernameController.text = getUser.username.toString();
    // fullNameController.text = getUser.fullName.toString();
    // locationController.text = getUser.location;
    // phoneController.text = getUser.phone.toString();
    // bioController.text = getUser.bio.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(errMesssage),
          CustomOutlineTextField(
            onChange: (e) {},
            labelText: null,
            controller: usernameController,
            hintText: "@",
            validate: (text) {
              if (text.isEmpty) {
                return "Required username";
              }
              if (text.length < 3) {
                return "Username must be at least 3 characters";
              }
            },
          ),
          SizedBox(height: size.height * .02),
          CustomOutlineTextField(
            labelText: null,
            controller: fullNameController,
            hintText: "Fullname",
            validate: (text) {
              if (text == null || text.length < 4)
                return "Username require more than 3 charactors";
            },
          ),
          SizedBox(height: size.height * .02),
          CustomOutlineTextField(
            labelText: null,
            controller: locationController,
            hintText: "Location",
            validate: (text) {
              if (text == null || text.isEmpty) {
                return "Please provide info about your city location";
              }
            },
          ),
          SizedBox(height: size.height * .02),
          CustomOutlineTextField(
            labelText: null,
            controller: phoneController,
            hintText: "Phone number",
            validate: (text) {
              if (text != null &&
                  !text.isEmpty &&
                  double.tryParse(text) == null) {
                return "Phone number is not valid";
              }
            },
          ),
          SizedBox(height: size.height * .02),
          CustomOutlineTextField(
            labelText: null,
            controller: bioController,
            hintText: "Bio",
            validate: (text) {},
          ),
          SizedBox(height: size.height * .02),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: size.width * .8,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomSmallTextButton(
                  backgroundColor: kPrimaryLightColor.withOpacity(.7),
                  text: "Cancel",
                  textColor: Colors.white,
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: size.width * .02),
                CustomSmallTextButton(
                  backgroundColor: kPrimaryColor,
                  text: "Save",
                  textColor: Colors.white,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    final isValid = _formKey.currentState!.validate();
                    if (isValid && this.errMesssage.isEmpty) {}
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    fullNameController.dispose();
    locationController.dispose();
    phoneController.dispose();
    bioController.dispose();
    super.dispose();
  }
}
