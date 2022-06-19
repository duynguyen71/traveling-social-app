import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:traveling_social_app/screens/message/message_widget.dart';
import 'package:traveling_social_app/services/user_service.dart';
import 'package:traveling_social_app/view_model/user_view_model.dart';

import '../../constants/app_theme_constants.dart';
import '../../models/message.dart';
import '../../models/message_response.dart';
import 'chat_controller.dart';
import 'package:provider/provider.dart';

class PublicChatScreen extends StatefulWidget {
  const PublicChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  _PublicChatScreenState createState() => _PublicChatScreenState();
}

class _PublicChatScreenState extends State<PublicChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  int scroll = 0;
  bool isLoading = false;
  final Set<Message> _messages = <Message>{};
  late StompClient client;
  final _userService = UserService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    _messageController.text = "Message";
    connectSocket();
    super.initState();
  }

  void connectSocket() async {
    client = StompClient(
      config: StompConfig(
        url: 'ws://192.168.1.8:8088/tc-socket',
        stompConnectHeaders: {
          "Authorization": 'Bearer ${await _storage.read(key: 'accessToken')}'
        },
        onConnect: (StompFrame frame) {
          showToast("Connect to web socket success");
          client.subscribe(
            destination: '/topic/news',
            callback: (frame) {
              var m = Message.fromJson(
                  (jsonDecode(frame.body.toString()) as Map<String, dynamic>));
              setState(() {
                _messages.add(m);
              });
            },
          );
        },
        onWebSocketError: (_) {
          print("Failed to connect to tc socket $_");
        },
      ),
    );
    client.activate();
  }

  void _sendMessage() async {
    var string = _messageController.text.toString();
    var message = Message();
    message.message = string;
    message.user = context.read<UserViewModel>().user;
    client.send(
        destination: '/app/news', headers: {}, body: jsonEncode(message));
    // _messageController.clear();
    _messageController.text =
        "Message ${DateTime.now().millisecondsSinceEpoch}";
  }

  void showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: 68,
          title: const Text(
            'Public chat room',
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_drop_down, color: kPrimaryColor),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.call),
              color: kPrimaryColor,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.video_call),
              color: kPrimaryColor,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.info_outline),
              color: kPrimaryColor,
            ),
          ],
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Visibility(
              visible: isLoading,
              child: const CircularProgressIndicator(),
            ),
            // ChatBackground(size: size),
            GestureDetector(
              onTap: () {
                if (FocusScope.of(context).hasFocus) {
                  FocusScope.of(context).unfocus();
                }
              },
              child: Container(
                height: size.height,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(
                  right: 5,
                  left: 5,
                ),
                margin: const EdgeInsets.only(
                  bottom: 60,
                  // top: 80,
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    DateTime time = DateTime.fromMicrosecondsSinceEpoch(
                        DateTime.now().millisecondsSinceEpoch);
                    var fmt = DateFormat('hh:mm a').format(time);
                    var message = _messages.elementAt(index);
                    return MessageWidget(
                      hasError: false,
                      timeFormat: fmt,
                      onLongPress: () {},
                      isFirst: index == 0,
                      isLast: _messages.length == index + 1,
                      color: context.read<UserViewModel>().user!.username ==
                              message.user.toString()
                          ? kPrimaryLightColor
                          : kPrimaryLightColor.withOpacity(.7),
                      isSender: context.read<UserViewModel>().user!.username ==
                          message.user.toString(),
                      message: message.message.toString(),
                      isFavorite: false,
                      onDoubleTap: () {},
                      avt: '',
                    );
                  },
                  itemCount: _messages.length,
                ),
              ),
            ),
            Positioned(
              child: ChatController(
                size: size,
                messageController: _messageController,
                onSendBtnPressed: _sendMessage, isTextMessageEmpty: false,
              ),
              bottom: 0,
              left: 0,
              right: 0,
            ),
          ],
        ),
      ),
    );
  }
}
