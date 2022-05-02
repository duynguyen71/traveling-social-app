import 'dart:async';

import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/edit_profile/components/avatar_with_edit_button.dart';

import 'components/background.dart';
import 'package:provider/provider.dart';

import 'components/dialog_edit_image.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var usernameController = new TextEditingController();
  var locationController = new TextEditingController();
  var phoneController = new TextEditingController();


  @override
  void initState() {
    //get user data
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: kPrimaryColor,
          ),
        ),
        body: SizedBox(
          width: double.infinity,
          height: size.height,
          child: Background(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(top: 56),
                width: double.infinity,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AvatarWithEditButton(
                      onPressed: () {
                        buildDialog(context);
                      },
                    ),
                    SizedBox(height: size.height * .02),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> buildDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return const Dialog(
          child: DialogEditImage(),
        );
      },
    );
  }
}
