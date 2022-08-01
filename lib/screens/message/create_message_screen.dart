import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/models/user.dart';
import 'package:traveling_social_app/services/user_service.dart';

import '../../models/base_user.dart';

/// Create message screen
class CreateMessageScreen extends StatefulWidget {
  const CreateMessageScreen({Key? key}) : super(key: key);

  @override
  State<CreateMessageScreen> createState() => _CreateMessageScreenState();

  static Route route() =>
      MaterialPageRoute(builder: (_) => const CreateMessageScreen());
}

class _CreateMessageScreenState extends State<CreateMessageScreen> {
  _createMessage() async {}
  UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.clear,
            color: kPrimaryColor,
          ),
        ),
        title: const Text(
          "Create Message",
        ),
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 18,
          letterSpacing: .8,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async => await _createMessage(),
            icon: const Icon(
              Icons.send,
              color: kPrimaryColor,
            ),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: kDefaultHorizPadding,
        child: Column(
          children: [
            Autocomplete<BaseUserInfo>(
              optionsBuilder: (value) async {
                String usernameKeyWord = value.text;
                var list = await _userService.searchUsers(
                    username: usernameKeyWord, pageSize: 10);
                print(list);
                return list;
              },
              displayStringForOption: (BaseUserInfo user) {
                return user.username.toString();
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Container();
              },
              onSelected: (string) {},
              fieldViewBuilder: (context, textEditingController, focusNode,
                  onFieldSubmitted) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
