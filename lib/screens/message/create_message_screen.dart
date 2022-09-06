import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/message/bloc/chat_bloc.dart';
import 'package:traveling_social_app/screens/message/chat_screen.dart';
import 'package:traveling_social_app/services/user_service.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';

/// Create message screen
class CreateMessageScreen extends StatefulWidget {
  const CreateMessageScreen({Key? key}) : super(key: key);

  @override
  State<CreateMessageScreen> createState() => _CreateMessageScreenState();

  static Route route() =>
      MaterialPageRoute(builder: (_) => const CreateMessageScreen());
}

class _CreateMessageScreenState extends State<CreateMessageScreen> {
  _createMessage() async {
    var text = _userController.text;
    if (text.isEmpty) {
      ApplicationUtility.showFailToast(
          'Vui lòng nhập tên các thành viên trong nhóm');
      return;
    }
    var groupId = await _userService.createChatGroupWithNames(
        names: text.split(' '), groupName: _groupNameController.text);
    if (groupId == null) {
      ApplicationUtility.showFailToast("Lỗi bất đinh. Vui lòng thử lại");
      return;
    } else {
      Navigator.pushReplacement(context,
          ChatScreen.route(groupId: groupId, name: _groupNameController.text));
      context.read<ChatBloc>().add(const FetchChatGroup());
      ApplicationUtility.showSuccessToast(
          "Tạo nhóm chat ${_groupNameController.text} thành công!");
    }
  }

  final _userService = UserService();
  final _userController = TextEditingController();
  final _groupNameController = TextEditingController();

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
          "Tạo nhóm chat",
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
      body: Stack(
        children: [
          Padding(
            padding: kDefaultHorizPadding,
            child: Column(
              children: [
                TextField(
                  controller: _groupNameController,
                  decoration: InputDecoration(
                    label: Text(
                      "Tên nhóm",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: .7),
                    ),
                  ),
                ),
                TextField(
                  controller: _userController,
                  decoration: InputDecoration(
                    hintText: "Nhập tên người dùng cách nhau bởi dấu cách",
                    hintStyle: TextStyle(color: Colors.black45, fontSize: 14),
                    label: Text(
                      "Thành viên",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: .7),
                    ),
                  ),
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
    _userController.dispose();
    _groupNameController.dispose();
    super.dispose();
  }
}
