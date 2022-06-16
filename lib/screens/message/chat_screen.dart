import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:traveling_social_app/models/group_status.dart';
import 'package:traveling_social_app/screens/message/message_widget.dart';

import 'package:traveling_social_app/services/chat_service.dart';
import 'package:traveling_social_app/view_model/user_view_model.dart';
import 'package:traveling_social_app/widgets/chat_screen_app_bar.dart';

import '../../constants/app_theme_constants.dart';
import '../../models/base_user.dart';
import '../../models/message.dart';
import 'chat_controller.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.groupId,
    required this.tmpGroupName,
  }) : super(key: key);

  final int groupId;
  final String tmpGroupName;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chatController = TextEditingController();
  final _scrollController = ScrollController();
  int scroll = 0;
  bool isLoading = false;
  final _chatService = ChatService();
  Set<Message> _messages = <Message>{};
  late StompClient _stompClient;
  final _storage = const FlutterSecureStorage();
  final _focusNode = FocusNode();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _getMessages();
    connectSocket();
    _chatController.text = 'Message ${DateTime.now().millisecondsSinceEpoch}';
    _focusNode.addListener(() {
      if (_focusNode.hasFocus &&
          MediaQuery.of(context).viewInsets.bottom != 0) {
        _scrollController.animateTo(0,
            duration: const Duration(milliseconds: 0), curve: Curves.linear);
      }
    });
  }

  int get groupId => widget.groupId;

  // StompBadStateException
  void connectSocket() async {
    _stompClient = StompClient(
      config: StompConfig(
        url: "ws://192.168.1.8:8088/tc-socket",
        stompConnectHeaders: {
          "Authorization": 'Bearer ${await _storage.read(key: 'accessToken')}'
        },
        onConnect: (StompFrame frame) {
          print("Connect web socket success");
          _stompClient.subscribe(
            destination: '/queue/groups/$groupId',
            callback: (frame) {
              var jsonMessage =
                  (jsonDecode(frame.body.toString()) as Map<String, dynamic>);
              print(jsonMessage);
              var m = Message.fromJson(jsonMessage);
              setState(() {
                _messages.add(m);
              });
            },
          );
          //subscrice to group status
          _stompClient.subscribe(
            destination: '/queue/groups/$groupId/status',
            callback: (frame) {
              var groupStatusResp =
                  jsonDecode(frame.body.toString()) as Map<String, dynamic>;
              GroupStatus groupStatus = GroupStatus.fromJson(groupStatusResp);
              // if (!isMyAccount(groupStatus.user!)) {
              print(groupStatus.status);
              if (groupStatus.status== 'TYPING') {
                print("SEZT TYPING TRUE");
                setState(() => _isTyping = true);
              } else {
                print("SEZT TYPING FALSE");
                setState(() => _isTyping = false);
              }

              // }
            },
          );
        },
        onWebSocketError: (_) {
          print("Failed to connect to tc socket $_");
        },
      ),
    );
    _stompClient.activate();
  }

  bool isMyAccount(BaseUserInfo user) {
    return context.read<UserViewModel>().user!.username == user.username;
  }

  send() async {
    sendStatus(status: "SENT");
    var message = Message();
    message.message = _chatController.text.toString();
    _stompClient.send(
        destination: '/app/groups/$groupId', body: jsonEncode(message));
    // _chatController.text = "Message ${DateTime.now().millisecondsSinceEpoch}";
    sendStatus(status: "SENT");
  }

  sendStatus({required String status}) async {
    _stompClient.send(
        destination: '/app/groups/$groupId/status',
        headers: {},
        body: jsonEncode({"status": status}));
  }

  _getMessages() async {
    var messages = await _chatService.getMessages(widget.groupId,
        direction: "ASC", sortBy: "createDate");
    setState(() => _messages = messages);
  }

  void showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  List<Message> get messages => _messages.toList().reversed.toList();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: ChatScreenAppBar(
        groupName: widget.tmpGroupName,
        isTyping: _isTyping,
      ),
      body: SizedBox(
        height: size.height,
        child: Stack(
          alignment: Alignment.center,
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
                alignment: Alignment.topCenter,
                color: Colors.grey.shade50,
                padding: const EdgeInsets.only(
                  right: 5,
                  left: 5,
                ),
                margin: const EdgeInsets.only(
                  bottom: 56,
                ),
                child: ListView(
                  reverse: true,
                  shrinkWrap: true,
                  children: _messages.toList().reversed.map((e) {
                    DateTime time = DateTime.fromMicrosecondsSinceEpoch(
                        DateTime.now().millisecondsSinceEpoch);
                    var fmt = DateFormat('hh:mm a').format(time);
                    var message = e;
                    return MessageWidget(
                      timeFormat: fmt,
                      onLongPress: () {},
                      isFirst: false,
                      isLast: false,
                      color: context
                                  .read<UserViewModel>()
                                  .user!
                                  .username
                                  .toString() !=
                              message.user?.username.toString()
                          ? kPrimaryLightColor
                          : kPrimaryLightColor.withOpacity(.85),
                      isSender: context
                              .read<UserViewModel>()
                              .user!
                              .username
                              .toString() ==
                          message.user?.username.toString(),
                      message: message.message.toString(),
                      isFavorite: false,
                      onDoubleTap: () {},
                      avt: message.user!.avt,
                    );
                  }).toList(),
                ),
              ),
            ),
            Positioned(
              child: ChatController(
                size: size,
                messageController: _chatController,
                onSendBtnPressed: send,
                onChange: (value) {
                  print('on change');
                  var str = value.toString();
                  if (str.isNotEmpty) {
                    sendStatus(status: "TYPING");
                  }
                },
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

  @override
  void dispose() {
    super.dispose();
    _chatController.dispose();
    _scrollController.dispose();
    _stompClient.deactivate();
  }
}

// child: ListView.builder(
//   controller: _scrollController,
//   reverse: true,
//   shrinkWrap: true,
//   itemBuilder: (context, index) {
//     DateTime time = DateTime.fromMicrosecondsSinceEpoch(
//         DateTime.now().millisecondsSinceEpoch);
//     var fmt = DateFormat('hh:mm a').format(time);
//     var message = _messages.elementAt(index);
//     return MessageEntry(
//       timeFormat: fmt,
//       onLongPress: () {},
//       isFirst: index == 0,
//       isLast: false,
//       color: kPrimaryLightColor,
//       isSender: context
//               .read<UserViewModel>()
//               .user!
//               .username
//               .toString() ==
//           message.user?.username.toString(),
//       message: message.message.toString(),
//       isFavorite: false,
//       onDoubleTap: () {},
//       avt: message.user!.avt,
//     );
//   },
//   itemCount: _messages.length,
// ),
