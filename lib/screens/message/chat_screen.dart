import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/extension/string_apis.dart';
import 'package:traveling_social_app/models/chat_group_status.dart';
import 'package:traveling_social_app/models/group_status.dart';
import 'package:traveling_social_app/screens/message/components/chat_screen_drawer.dart';
import 'package:traveling_social_app/screens/message/message_widget.dart';

import 'package:traveling_social_app/services/chat_service.dart';
import 'package:traveling_social_app/widgets/chat_screen_app_bar.dart';

import '../../constants/app_theme_constants.dart';
import '../../models/base_user.dart';
import '../../models/message.dart';
import 'chat_controller.dart';
import 'package:provider/provider.dart';
import 'dart:math' as Math;

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

  static Route route({required int groupId, String? name}) => MaterialPageRoute(
        builder: (_) => ChatScreen(
          groupId: groupId,
          tmpGroupName: name,
        ),
      );
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
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
    });
    //get chat group detail
    // _getGroupDetail();
    //get messages
    _getMessages(page: _page, pageSize: _pageSize);
    //connect socket
    if (mounted) {
      _connectSocketServer();
    }
    // mock message data
    _chatController.text =
        lorem(paragraphs: 1, words: Math.Random().nextInt(10) + 6);
    _isTextMessageEmpty = false;
  }

  int get groupId => widget.groupId;

  _getGroupDetail() async {
    // var chatGroupDetail = await _chatService.getChatGroupDetail(groupId);
  }

  // StompBadStateException
  _connectSocketServer() async {
    _stompClient = StompClient(
      config: StompConfig(
        url: kSocketUrl,
        stompConnectHeaders: {
          "Authorization": 'Bearer ${await _storage.read(key: 'accessToken')}'
        },
        onConnect: (StompFrame frame) {
          //subscribe messages
          _stompClient.subscribe(
            destination: '/queue/groups/$groupId',
            callback: (frame) {
              _onReciveMessage(frame);
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

  void _onReciveMessage(StompFrame frame) {
    var jsonMessage =
        (jsonDecode(frame.body.toString()) as Map<String, dynamic>);
    var m = Message.fromJson(jsonMessage);
    var newMessages = {m, ..._messages};
    setState(() {
      _messages = newMessages;
      // _scrollController.jumpTo(0);
    });
  }

  // handle group status changes
  _handleFrameStatusChange(Map<String, dynamic> json) {
    if (!mounted) return;
    GroupStatus groupStatus = GroupStatus.fromJson(json);
    if (!isMyAccount(groupStatus.user!)) {
      var isTyping = groupStatus.status == ChatGroupStatus.typing.value;
      if (isTyping && _isTyping != true) {
        setState(() => _isTyping = true);
      } else if (!isTyping && _isTyping != false) {
        setState(() => _isTyping = false);
      }
    }
  }

  bool isMyAccount(BaseUserInfo user) {
    return context.read<AuthenticationBloc>().state.user.username ==
        user.username;
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
      _chatController.text =
          lorem(words: Math.Random().nextInt(10) + 5, paragraphs: 1);
      _scrollController.jumpTo(0);
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
      Navigator.pop(context);
      return;
    } finally {
      isLoading = false;
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
      endDrawer: const ChatScreenDrawer(),
      appBar: ChatScreenAppBar(
        groupName: widget.tmpGroupName.toString(),
        isTyping: _isTyping,
      ),
      body: SizedBox(
        height: size.height,
        child: Stack(
          children: [
            ListView.builder(
                padding: const EdgeInsets.only(bottom: 100, top: 56, left: 4.0),
                controller: _scrollController,
                addAutomaticKeepAlives: true,
                addRepaintBoundaries: true,
                reverse: true,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(),
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
                  var currentUserName =
                      context.read<AuthenticationBloc>().state.user.username;
                  return MessageWidget(
                    timeFormat: fmt,
                    hasError: false,
                    onLongPress: () {},
                    isFirst: false,
                    isLast: false,
                    color: currentUserName != message.user?.username
                        ? kPrimaryLightColor
                        : kPrimaryLightColor.withOpacity(.85),
                    isSender: currentUserName == message.user?.username,
                    message: message.message.toString(),
                    isFavorite: false,
                    onDoubleTap: () {},
                    avt: message.user?.avt,
                  );
                }),
            Positioned(
              child: ChatController(
                onSubmitted: (value) {
                  _sendMessage();
                },
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

  @override
  void dispose() {
    _sendStatus(status: 'LEAVE');
    _stompClient.deactivate();
    _focusNode.dispose();
    _scrollController.dispose();
    _chatController.dispose();

    super.dispose();
  }
}
