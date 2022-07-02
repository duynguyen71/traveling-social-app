import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/models/chat_group_status.dart';
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
    this.tmpGroupName,
  }) : super(key: key);

  final int groupId;
  final String? tmpGroupName;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chatController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = false;
  final _chatService = ChatService();
  Set<Message> _messages = <Message>{};
  late StompClient _stompClient;
  final _storage = const FlutterSecureStorage();
  final _focusNode = FocusNode();
  bool _isTyping = false;
  bool _isTextMessageEmpty = true;
  int _page = 0;
  final int _pageSize = 20;

  @override
  void initState() {
    _getMessages(page: _page, pageSize: _pageSize);
    _connectSocketServer();
    _chatController.text = 'Message ${DateTime.now().millisecondsSinceEpoch}';
    _focusNode.addListener(() {
      if (_focusNode.hasFocus &&
          MediaQuery.of(context).viewInsets.bottom != 0) {
        _scrollController.animateTo(0,
            duration: const Duration(milliseconds: 0), curve: Curves.linear);
      }
    });
    _isTextMessageEmpty = false;
    super.initState();
  }

  int get groupId => widget.groupId;

  // StompBadStateException
  _connectSocketServer() async {
    _stompClient = StompClient(
      config: StompConfig(
        url: kSocketUrl,
        stompConnectHeaders: {
          "Authorization": 'Bearer ${await _storage.read(key: 'accessToken')}'
        },
        onConnect: (StompFrame frame) {

          print("Connect web socket success");
          //subscribe messages
          _stompClient.subscribe(
            destination: '/queue/groups/$groupId',
            callback: (frame) {
              var jsonMessage =
                  (jsonDecode(frame.body.toString()) as Map<String, dynamic>);
              var m = Message.fromJson(jsonMessage);
              setState(() {
                _messages = {m}.union(_messages);
              });
            },
          );
          //subscribe to group status
          _stompClient.subscribe(
            destination: '/queue/groups/$groupId/status',
            callback: (frame) {
              var json =
                  jsonDecode(frame.body.toString()) as Map<String, dynamic>;
              _handleFrameStatusChange(json);
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

  // handle group status changes
  _handleFrameStatusChange(Map<String, dynamic> json) {
    GroupStatus groupStatus = GroupStatus.fromJson(json);
    if (!isMyAccount(groupStatus.user!)) {
      if (groupStatus.status == ChatGroupStatus.typing.value) {
        setState(() => _isTyping = true);
      } else {
        setState(() => _isTyping = false);
      }
    }
  }

  bool isMyAccount(BaseUserInfo user) {
    return context.read<UserViewModel>().user!.username == user.username;
  }

  set isLoading(bool i) => setState(() => _isLoading = i);

  //send message
  _sendMessage() async {
    var text = _chatController.text;
    if (text.isEmpty) {
      return;
    }
    var message = Message();
    message.message = text.toString();
    try {
      _stompClient.send(
          destination: '/app/groups/$groupId', body: jsonEncode(message));
    } on Exception catch (e) {
      print('Failed to send message: $e');
    } finally {
      _sendStatus(status: ChatGroupStatus.sent.value);
      text = "Message ${DateTime.now().millisecondsSinceEpoch}";
      // _clearTextMessage();
    }
  }

  //send ChatGroupStatus
  _sendStatus({required String status}) async {
    try {
      _stompClient.send(
          destination: '/app/groups/$groupId/status',
          headers: {},
          body: jsonEncode({"status": status}));
    } on Exception catch (e) {
      print("Failed to send group status : $status");
    }
  }

  //get group message
  _getMessages({required int page, required int pageSize}) async {
    try {
      isLoading = true;
      var messages = await _chatService.getMessages(widget.groupId,
          direction: "DESC",
          sortBy: "createDate",
          page: page,
          pageSize: pageSize);
      setState(() => _messages = messages);
    } on Exception catch (e) {
      print('Failed to get group $groupId messages: $e');
    } finally {
      isLoading = false;
      _scrollController.addListener(() {
        var position = _scrollController.position;
        if ((position.maxScrollExtent - position.pixels) <=
            MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                    .size
                    .height *
                .2) {
          if (!_isLoading) {
            isLoading = true;
            _chatService
                .getMessages(widget.groupId,
                    direction: "DESC",
                    sortBy: "createDate",
                    page: ++_page,
                    pageSize: _pageSize)
                .then((value) => setState(() => _messages.addAll(value)))
                .whenComplete(() => isLoading = false);
          }
        }
      });
    }
  }

  _clearTextMessage() {
    _chatController.clear();
    setState(() => _isTextMessageEmpty = true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: ChatScreenAppBar(
        groupName: widget.tmpGroupName.toString(),
        isTyping: _isTyping,
      ),
      body: SizedBox(
        height: size.height,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // ChatBackground(size: size),
            GestureDetector(
              onTap: () {
                if (FocusScope.of(context).hasFocus) {
                  FocusScope.of(context).unfocus();
                }
              },
              //MESSAGE LIST CONTAINER
              child: Container(
                alignment: Alignment.topCenter,
                color: Colors.grey.shade50,
                padding: const EdgeInsets.only(
                  right: 5,
                  left: 5,
                  // bottom: kChatControllerHeight,
                ),
                margin: const EdgeInsets.only(
                  bottom: kChatControllerHeight,
                ),
                child: ListView.builder(
                    reverse: true,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.manual,
                    physics: const BouncingScrollPhysics(),
                    controller: _scrollController,
                    itemCount: _messages.length + 1,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (index == _messages.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Visibility(
                            visible: _isLoading,
                            child: const CupertinoActivityIndicator(),
                          ),
                        );
                      }
                      var message = _messages.elementAt(index);
                      DateTime time = DateTime.fromMicrosecondsSinceEpoch(
                          DateTime.now().millisecondsSinceEpoch);
                      var fmt = DateFormat('hh:mm a').format(time);
                      return MessageWidget(
                        timeFormat: fmt,
                        hasError: false,
                        onLongPress: () {},
                        isFirst: false,
                        isLast: false,
                        color: context
                                    .read<AuthenticationBloc>()
                                    .state
                                    .user
                                    .username
                                    .toString() !=
                                message.user?.username.toString()
                            ? kPrimaryLightColor
                            : kPrimaryLightColor.withOpacity(.85),
                        isSender: context
                                .read<AuthenticationBloc>()
                                .state
                                .user
                                .username ==
                            message.user?.username,
                        message: message.message.toString(),
                        isFavorite: false,
                        onDoubleTap: () {},
                        avt: message.user!.avt.toString(),
                      );
                    }),
              ),
              //  END OF MESSAGE LIST
            ),

            //chat controller
            Positioned(
              child: ChatController(
                size: size,
                messageController: _chatController,
                onSendBtnPressed: _sendMessage,
                onChange: _handleTextInputChange,
                isTextMessageEmpty: _isTextMessageEmpty,
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

  _handleTextInputChange(value) {
    if (value.toString().trim().isNotEmpty) {
      isTextMessageEmpty = false;
      _sendStatus(status: ChatGroupStatus.typing.value);
    } else {
      isTextMessageEmpty = true;
      _sendStatus(status: ChatGroupStatus.none.value);
    }
  }

  set isTextMessageEmpty(bool i) => setState(() => _isTextMessageEmpty = i);

// @override
// void dispose() {
//   _sendStatus(status: 'LEAVE');
//   _stompClient.deactivate();
//   _chatController.dispose();
//   _scrollController.dispose();
//   _focusNode.dispose();
//   super.dispose();
// }
}
